Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D070153E0E
	for <linux-trace-devel@vger.kernel.org>; Mon,  8 Jan 2024 17:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1682C433C8;
	Mon,  8 Jan 2024 17:15:29 +0000 (UTC)
Date: Mon, 8 Jan 2024 12:16:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <20240108121625.66729036@gandalf.local.home>
In-Reply-To: <ZZwFvyGvm0C38eBh@google.com>
References: <20240105152906.743d7e03@gandalf.local.home>
	<ZZwFvyGvm0C38eBh@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 8 Jan 2024 14:25:03 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> [...]
> 
> > +/**
> > + * trace_mmap - try to mmap the ring buffer
> > + * @fd: The file descriptor to the trace_pipe_raw file
> > + * @kbuf: The kbuffer to load the subbuffer to
> > + *
> > + * Will try to mmap the ring buffer if it is supported, and
> > + * if not, will return NULL, otherwise it returns a descriptor
> > + * to handle the mapping.
> > + */
> > +__hidden void *trace_mmap(int fd, struct kbuffer *kbuf)
> > +{
> > +	struct trace_mmap *tmap;
> > +	int page_size;
> > +	void *meta;
> > +	void *data;
> > +
> > +	page_size = getpagesize();
> > +	meta = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
> > +	if (meta == MAP_FAILED)
> > +		return NULL;
> > +
> > +	tmap = calloc(1, sizeof(*tmap));
> > +	if (!tmap) {
> > +		munmap(meta, page_size);
> > +		return NULL;
> > +	}
> > +
> > +	tmap->kbuf = kbuffer_dup(kbuf);
> > +	if (!tmap->kbuf) {
> > +		munmap(meta, page_size);
> > +		free(tmap);
> > +	}
> > +
> > +	tmap->fd = fd;
> > +
> > +	tmap->map = meta;
> > +	tmap->meta_len = tmap->map->meta_page_size;
> > +
> > +	if (tmap->meta_len > page_size) {
> > +		munmap(meta, page_size);
> > +		meta = mmap(NULL, tmap->meta_len, PROT_READ, MAP_SHARED, fd, 0);
> > +		if (meta == MAP_FAILED) {
> > +			kbuffer_free(tmap->kbuf);
> > +			free(tmap);
> > +			return NULL;
> > +		}
> > +		tmap->map = meta;
> > +	}
> > +
> > +	tmap->data_pages = meta + tmap->meta_len;
> > +
> > +	tmap->data_len = tmap->map->subbuf_size * tmap->map->nr_subbufs;
> > +
> > +	tmap->data = mmap(NULL, tmap->data_len, PROT_READ, MAP_SHARED,
> > +			  fd, tmap->meta_len);
> > +	if (tmap->data == MAP_FAILED) {
> > +		munmap(meta, tmap->meta_len);
> > +		kbuffer_free(tmap->kbuf);
> > +		free(tmap);
> > +		return NULL;
> > +	}
> > +
> > +	tmap->last_idx = tmap->map->reader.id;
> > +
> > +	data = tmap->data + tmap->map->subbuf_size * tmap->last_idx;
> > +	kbuffer_load_subbuffer(kbuf, data);
> > +
> > +	/*
> > +	 * The page could have left over data on it that was already
> > +	 * consumed. Move the "read" forward in that case.
> > +	 */
> > +	if (tmap->map->reader.read) {
> > +		int size = kbuffer_start_of_data(kbuf) + tmap->map->reader.read;
> > +		char tmpbuf[size];
> > +		kbuffer_read_buffer(kbuf, tmpbuf, size);  
> 
> It does not seem to update the kbuf timestamp. To observe the problem I did:
> 
> ### Create few events on the page
> 
> $ echo 0 > /sys/kernel/tracing/trace
> $ <read ring-buffer>
> $ cat /proc/uptime | awk '{print $1}' > /sys/kernel/debug/tracing/trace_marker
> <...>-2305 279515.453542096     print: tracing_mark_write: 279515.33
> <...>-2307 279522.090413680     print: tracing_mark_write: 279521.97
> <...>-2309 279522.960932976     print: tracing_mark_write: 279522.85
> $ <unmap and close ring-buffer>
> 
> 
> ### Re-map again the ring-buffer to trigger the fast-forward
> 
> $ <read ring-buffer>
>   before fast-forward kbuf->timestamp=279515453542096
>   after fast-forward kbuf->timestamp=279515453542096
> $ cat /proc/uptime | awk '{print $1}' > /sys/kernel/debug/tracing/trace_marker
> <...>-2312 279549.725524688     print: tracing_mark_write: 279557.12
> 
> The timestamp above is a few seconds off, which I believe might be due to an
> outdated kbuf->timestamp.
> 

Bah, it looks like we can't just simply copy. Can you try this patch?

-- Steve

diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index 1e1d168..192925a 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -961,19 +961,12 @@ kbuffer_raw_get(struct kbuffer *kbuf, void *subbuf, struct kbuffer_raw_info *inf
  */
 int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
 {
-	int subbuf_size = kbuf->start + kbuf->size;
 	unsigned long long ts;
 	unsigned int type_len_ts;
 	bool do_swap = false;
 	int last_next;
 	int save_curr;
 
-	if (!kbuf->curr && len >= subbuf_size) {
-		memcpy(buffer, kbuf->subbuffer, subbuf_size);
-		set_curr_to_end(kbuf);
-		return kbuf->size;
-	}
-
 	/* Are we at the end of the buffer */
 	if (kbuf->curr >= kbuf->size)
 		return 0;
@@ -996,24 +989,13 @@ int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
 
 	save_curr = kbuf->curr;
 
-	/* Copy the rest of the buffer if it fits */
-	if (len >= kbuf->size - kbuf->curr) {
-		set_curr_to_end(kbuf);
-		last_next = kbuf->size;
-	} else {
-		/*
-		 * The length doesn't hold the rest,
-		 * need to find the last that fits
-		 */
+	/* Due to timestamps, we must save the current next to use */
+	last_next = kbuf->next;
 
-		/* Due to timestamps, we must save the current next to use */
+	while (len >= kbuf->next - save_curr) {
 		last_next = kbuf->next;
-
-		while (len >= kbuf->next - save_curr) {
-			last_next = kbuf->next;
-			if (!kbuffer_next_event(kbuf, &ts))
-				break;
-		}
+		if (!kbuffer_next_event(kbuf, &ts))
+			break;
 	}
 
 	len = last_next - save_curr;
