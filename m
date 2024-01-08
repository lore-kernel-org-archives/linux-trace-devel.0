Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF0D55C00
	for <linux-trace-devel@vger.kernel.org>; Mon,  8 Jan 2024 17:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z0T54y1S"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-40e4c1e303dso2733715e9.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Jan 2024 09:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704735297; x=1705340097; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SWNPuOIqgA9MKrStVRw//gfmYBjoZetmrCjeTrvyp3w=;
        b=z0T54y1SQ+UdBe/6JYjtHIrPvkhywjxbQLC0BkKRyoW/JwHLpSXDs4WwmrdUK4D2UQ
         mRAr4Sc0fhhp1ULDqF1rplayIWm1PCRX7KQyt/tBwomeN4FqF7HyvG4PlhDlMzaHrq09
         qMKXtOOstFBypgpw11TkQqRIhvRjhWEZUiDXlHUblYlKyLw8XCRLsxVpUPy+EedvdTsK
         t5ky7jxe+Wscw4esuzifQX3n3Necll50XkXSGzzvMXGWQMW5fjbEkonmYwQUSuf86W/z
         YbkaBad+hgiQ4Hcl3r7n+i38XqFLY7W7hr3xvve7R+p1IpCDhXUA7yUYSbHR8Q5ydrkH
         RSyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704735297; x=1705340097;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWNPuOIqgA9MKrStVRw//gfmYBjoZetmrCjeTrvyp3w=;
        b=YcUIsn5gLRTPdoijIDTiKTBQZ/2sQ+zi3n0N/7/HMPcegoFCEjC80QyaS8iqqCl92x
         JLR59Y3eLQsiCe5Z8hsZkEGhja+jhyr+5iHu/cw4FZmawIlBrNlOPbMqNfKA2wFx1GmZ
         5vmqXZVZGcBoEkEJU9AnKozburx25n/CHVQjBZMiAmgOuAq2MoD2AbWeA65LTjD0WC1x
         5AH3AzDBWU3m7wqYofzyip60WdQ75cZLEZdMS/ar09qh9WH7YuSYiHI1h3QCGzssqRjX
         BzROktZsZ45HMddIprX3P95X0tECIDyvweZwQM/89nDt8Y53OsKVuX6l2+icfZYx/3Lh
         xZJg==
X-Gm-Message-State: AOJu0Yyq/wEKZ3MV45dPEsjAg+Ik2wy0gPhTpVl49Td7ewCSdnchTGqw
	RY3pL6Rx1tA5PeUSJcYhLQi0urIEaBbjkVRlwDNePKh8W1H8
X-Google-Smtp-Source: AGHT+IE08a2AxzcguUFC8oIkE+z3Wt9T40WCbyoTHAEEHytYip3UfUVo6zYZwBzY4cOyI56HKHGW1Q==
X-Received: by 2002:a05:600c:3790:b0:40d:94e4:27a7 with SMTP id o16-20020a05600c379000b0040d94e427a7mr1928362wmr.242.1704735297530;
        Mon, 08 Jan 2024 09:34:57 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id i11-20020a05600c354b00b0040e47dc2e8fsm538323wmq.6.2024.01.08.09.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jan 2024 09:34:57 -0800 (PST)
Date: Mon, 8 Jan 2024 17:34:53 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <ZZwyPScNdspmihke@google.com>
References: <20240105152906.743d7e03@gandalf.local.home>
 <ZZwFvyGvm0C38eBh@google.com>
 <20240108121625.66729036@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240108121625.66729036@gandalf.local.home>

On Mon, Jan 08, 2024 at 12:16:25PM -0500, Steven Rostedt wrote:
> On Mon, 8 Jan 2024 14:25:03 +0000
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > [...]
> > 
> > > +/**
> > > + * trace_mmap - try to mmap the ring buffer
> > > + * @fd: The file descriptor to the trace_pipe_raw file
> > > + * @kbuf: The kbuffer to load the subbuffer to
> > > + *
> > > + * Will try to mmap the ring buffer if it is supported, and
> > > + * if not, will return NULL, otherwise it returns a descriptor
> > > + * to handle the mapping.
> > > + */
> > > +__hidden void *trace_mmap(int fd, struct kbuffer *kbuf)
> > > +{
> > > +	struct trace_mmap *tmap;
> > > +	int page_size;
> > > +	void *meta;
> > > +	void *data;
> > > +
> > > +	page_size = getpagesize();
> > > +	meta = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
> > > +	if (meta == MAP_FAILED)
> > > +		return NULL;
> > > +
> > > +	tmap = calloc(1, sizeof(*tmap));
> > > +	if (!tmap) {
> > > +		munmap(meta, page_size);
> > > +		return NULL;
> > > +	}
> > > +
> > > +	tmap->kbuf = kbuffer_dup(kbuf);
> > > +	if (!tmap->kbuf) {
> > > +		munmap(meta, page_size);
> > > +		free(tmap);
> > > +	}
> > > +
> > > +	tmap->fd = fd;
> > > +
> > > +	tmap->map = meta;
> > > +	tmap->meta_len = tmap->map->meta_page_size;
> > > +
> > > +	if (tmap->meta_len > page_size) {
> > > +		munmap(meta, page_size);
> > > +		meta = mmap(NULL, tmap->meta_len, PROT_READ, MAP_SHARED, fd, 0);
> > > +		if (meta == MAP_FAILED) {
> > > +			kbuffer_free(tmap->kbuf);
> > > +			free(tmap);
> > > +			return NULL;
> > > +		}
> > > +		tmap->map = meta;
> > > +	}
> > > +
> > > +	tmap->data_pages = meta + tmap->meta_len;
> > > +
> > > +	tmap->data_len = tmap->map->subbuf_size * tmap->map->nr_subbufs;
> > > +
> > > +	tmap->data = mmap(NULL, tmap->data_len, PROT_READ, MAP_SHARED,
> > > +			  fd, tmap->meta_len);
> > > +	if (tmap->data == MAP_FAILED) {
> > > +		munmap(meta, tmap->meta_len);
> > > +		kbuffer_free(tmap->kbuf);
> > > +		free(tmap);
> > > +		return NULL;
> > > +	}
> > > +
> > > +	tmap->last_idx = tmap->map->reader.id;
> > > +
> > > +	data = tmap->data + tmap->map->subbuf_size * tmap->last_idx;
> > > +	kbuffer_load_subbuffer(kbuf, data);
> > > +
> > > +	/*
> > > +	 * The page could have left over data on it that was already
> > > +	 * consumed. Move the "read" forward in that case.
> > > +	 */
> > > +	if (tmap->map->reader.read) {
> > > +		int size = kbuffer_start_of_data(kbuf) + tmap->map->reader.read;
> > > +		char tmpbuf[size];
> > > +		kbuffer_read_buffer(kbuf, tmpbuf, size);  
> > 
> > It does not seem to update the kbuf timestamp. To observe the problem I did:
> > 
> > ### Create few events on the page
> > 
> > $ echo 0 > /sys/kernel/tracing/trace
> > $ <read ring-buffer>
> > $ cat /proc/uptime | awk '{print $1}' > /sys/kernel/debug/tracing/trace_marker
> > <...>-2305 279515.453542096     print: tracing_mark_write: 279515.33
> > <...>-2307 279522.090413680     print: tracing_mark_write: 279521.97
> > <...>-2309 279522.960932976     print: tracing_mark_write: 279522.85
> > $ <unmap and close ring-buffer>
> > 
> > 
> > ### Re-map again the ring-buffer to trigger the fast-forward
> > 
> > $ <read ring-buffer>
> >   before fast-forward kbuf->timestamp=279515453542096
> >   after fast-forward kbuf->timestamp=279515453542096
> > $ cat /proc/uptime | awk '{print $1}' > /sys/kernel/debug/tracing/trace_marker
> > <...>-2312 279549.725524688     print: tracing_mark_write: 279557.12
> > 
> > The timestamp above is a few seconds off, which I believe might be due to an
> > outdated kbuf->timestamp.
> > 
> 
> Bah, it looks like we can't just simply copy. Can you try this patch?

That works!

> 
> -- Steve
> 
> diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
> index 1e1d168..192925a 100644
> --- a/src/kbuffer-parse.c
> +++ b/src/kbuffer-parse.c
> @@ -961,19 +961,12 @@ kbuffer_raw_get(struct kbuffer *kbuf, void *subbuf, struct kbuffer_raw_info *inf
>   */
>  int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
>  {
> -	int subbuf_size = kbuf->start + kbuf->size;
>  	unsigned long long ts;
>  	unsigned int type_len_ts;
>  	bool do_swap = false;
>  	int last_next;
>  	int save_curr;
>  
> -	if (!kbuf->curr && len >= subbuf_size) {
> -		memcpy(buffer, kbuf->subbuffer, subbuf_size);
> -		set_curr_to_end(kbuf);
> -		return kbuf->size;
> -	}
> -
>  	/* Are we at the end of the buffer */
>  	if (kbuf->curr >= kbuf->size)
>  		return 0;
> @@ -996,24 +989,13 @@ int kbuffer_read_buffer(struct kbuffer *kbuf, void *buffer, int len)
>  
>  	save_curr = kbuf->curr;
>  
> -	/* Copy the rest of the buffer if it fits */
> -	if (len >= kbuf->size - kbuf->curr) {
> -		set_curr_to_end(kbuf);
> -		last_next = kbuf->size;
> -	} else {
> -		/*
> -		 * The length doesn't hold the rest,
> -		 * need to find the last that fits
> -		 */
> +	/* Due to timestamps, we must save the current next to use */
> +	last_next = kbuf->next;
>  
> -		/* Due to timestamps, we must save the current next to use */
> +	while (len >= kbuf->next - save_curr) {
>  		last_next = kbuf->next;
> -
> -		while (len >= kbuf->next - save_curr) {
> -			last_next = kbuf->next;
> -			if (!kbuffer_next_event(kbuf, &ts))
> -				break;
> -		}
> +		if (!kbuffer_next_event(kbuf, &ts))
> +			break;
>  	}
>  
>  	len = last_next - save_curr;
