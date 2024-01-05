Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D849B2DF73
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 13:39:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D20C433C7;
	Fri,  5 Jan 2024 13:39:53 +0000 (UTC)
Date: Fri, 5 Jan 2024 08:41:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <20240105084100.5fe6ffa0@gandalf.local.home>
In-Reply-To: <ZZfJQTOyl0dHiTU-@google.com>
References: <20231228201100.78aae259@rorschach.local.home>
	<ZZfJQTOyl0dHiTU-@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 5 Jan 2024 09:17:53 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> [...]
> 
> > +EXAMPLE
> > +-------
> > +[source,c]
> > +--
> > +#include <stdlib.h>
> > +#include <ctype.h>
> > +#include <tracefs.h>
> > +
> > +static void read_page(struct tep_handle *tep, struct kbuffer *kbuf)  
> 
> read_subbuf?

Heh, sure. That was copied from the original test I had.

> 
> > +{
> > +	static struct trace_seq seq;
> > +	struct tep_record record;
> > +
> > +	if (seq.buffer)
> > +		trace_seq_reset(&seq);
> > +	else
> > +		trace_seq_init(&seq);
> > +
> > +	while ((record.data = kbuffer_read_event(kbuf, &record.ts))) {
> > +		record.size = kbuffer_event_size(kbuf);
> > +		kbuffer_next_event(kbuf, NULL);
> > +		tep_print_event(tep, &seq, &record,
> > +				"%s-%d %9d\t%s: %s\n",
> > +				TEP_PRINT_COMM,
> > +				TEP_PRINT_PID,
> > +				TEP_PRINT_TIME,
> > +				TEP_PRINT_NAME,
> > +				TEP_PRINT_INFO);
> > +		trace_seq_do_printf(&seq);
> > +		trace_seq_reset(&seq);
> > +	}
> > +}
> > +  
> 
> [...]
> 
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
> 
> Could it fast-forward to the event until tmap->map->reader.read? So we don't
> read again the same events.
> 
> Something like
> 
>   while (kbuf->curr < tmap->map->reader.read)
>   	kbuffer_next_event(kbuf, NULL);

Note that kbuf->curr is not available to libtracefs. That's internal to
libtraceevent.

But we could have somethings like:

	kbuffer_load_subbuffer(kbuf, data);

	/* Update to kbuf index to the next read */
	if (tmap->map->reader.read) {
		char tmpbuf[tmap->map->reader.read];
		kbuffer_read_buffer(kbuf, tmpbuf, tmap->map->reader.read);
	}

Which should move the kbuf->curr to reader.read.


> 
> > +
> > +	return tmap;
> > +}
> > +
> > +__hidden void trace_unmap(void *mapping)
> > +{
> > +	struct trace_mmap *tmap = mapping;
> > +
> > +	munmap(tmap->data, tmap->data_len);
> > +	munmap(tmap->map, tmap->meta_len);
> > +	kbuffer_free(tmap->kbuf);
> > +	free(tmap);
> > +}
> > +
> > +__hidden int trace_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf)
> > +{
> > +	struct trace_mmap *tmap = mapping;
> > +	void *data;
> > +	int id;
> > +
> > +	id = tmap->map->reader.id;
> > +	data = tmap->data + tmap->map->subbuf_size * id;
> > +
> > +	/*
> > +	 * If kbuf doesn't point to the current sub-buffer
> > +	 * just load it and return.
> > +	 */
> > +	if (data != kbuffer_subbuffer(kbuf)) {
> > +		kbuffer_load_subbuffer(kbuf, data);
> > +		return 1;
> > +	}
> > +
> > +	/*
> > +	 * Perhaps the reader page had a write that added
> > +	 * more data.
> > +	 */
> > +	kbuffer_refresh(kbuf);
> > +
> > +	/* Are there still events to read? */
> > +	if (kbuffer_curr_size(kbuf))
> > +		return 1;  
> 
> It does not seem to be enough, only kbuf->size is updated in kbuffer_refresh()
> while kbuffer_curr_size is next - cur.

That's the size of the event, not what's on the buffer. Next just points to
the end of the current event. Hmm, or you mean that we read the last event
and something else was added? Yeah, should check if curr == size, then next
would need to be updated. That's a bug in kbuffer_refresh().

> 
> > +
> > +	/* See if a new page is ready? */
> > +	if (ioctl(tmap->fd, TRACE_MMAP_IOCTL_GET_READER) < 0)
> > +		return -1;  
> 
> Maybe this ioctl should be called regardless if events are found on the current
> reader page. This would at least update the reader->read field and make sure
> subsequent readers are not getting the same events we already had here?

If we call the ioctl() before we are finished reading events, the events on
the reader page will be discarded and added back to the writer buffer if
the writer is not on the reader page.

And there should only be one reader accessing the map. This is not thread
safe. Once you load the subbuffer into kbuf, kbuf handles what was read. We
don't want to use the reader page for that.

If something is reading the buffer outside this application, it's fine if
we read the same events. Multiple readers of the same buffer already screw
things up today. That's why I created instances.

-- Steve


> 
> > +	id = tmap->map->reader.id;
> > +	data = tmap->data + tmap->map->subbuf_size * id;
> > +  
> 
> [...]

