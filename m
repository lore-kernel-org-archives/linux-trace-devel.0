Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC56A34545
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 18:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H8jkhQpd"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-40d88fff7faso16023735e9.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Jan 2024 10:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704479043; x=1705083843; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MpF31PrVItMCuSimgxCiVzyuP+9Cc2Vn4VAs1TfdblI=;
        b=H8jkhQpdvSgaHYsHbTVD9TLMalqY7os/Ucs2J4F24V5nDsX+I5lL6xklzIQO1JP2Jq
         NB4E3HmAGVZnffGZf+Z94AsGwj5g57HeUO1zHwxEsKfQA7yPc8D4oHgHzwtF8XJ/TDNb
         d9JJuuAmlDJkaK9RkPO/ucYYN4iG37UKJeZENnsLY7G1dbrUGRILCLG7CZF2wAsnF85t
         sXuV88SdHqztjpnZH7oIMohq3DPy1oBr/Bl1i46oARZn7lC9VOa7Tg1ozIj22a8RvcFs
         YW9OLOJ6LpvJFwNU/GK7JfJ468NjGi4+v1hEkdxFD3iPkRqw2QsI+g/JaBA9SpCX2mGq
         v0RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704479043; x=1705083843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpF31PrVItMCuSimgxCiVzyuP+9Cc2Vn4VAs1TfdblI=;
        b=cVKzbdR+uCzfNjdM7lSXRXm5K2jAv73AaIPm3hw7OA1vi3vnRTXbGEA3W7bBgubm64
         dJb7SeujoToKQZBQBQ6WTCPSZAyjVCeeaoGEonaBJZRq8CxIBlJVyBNGxSWFgIME8N1L
         Brk6jG2TeNtlThGLLEIGxN8BAHI4a/9XaYI+Geiu5zPYFP3JBZfO5ARr60jA663FMk3H
         aAt9BZIEZqcWiQ4oodbzx7YewOMvSVKrCAu7qWpZkDia3HOpDxyKNJKOrQnYDF0t5VFe
         Jt4CUyl3wl7NKa/+NQbBv5EtMGWsVSpI6VqIGISZOd5ZOTN6Wz/ok0NfC66vf1KlqgBB
         ARpQ==
X-Gm-Message-State: AOJu0YxC64/TnfeLy9f2xamqVmwCYRBCQfrDcPbafSPLvHOLd+N044RY
	6TnnVjXuTRuxFI4j7FHoRbKDPuonhIe8RxF//Dqo9hfFYY+t
X-Google-Smtp-Source: AGHT+IFusOmASTNeJjIHCT3i0tvFXFvCR0H5gY9iazu5jL8fiTgQo+d3Uc5S60TD7uD/ExqDaPl9LA==
X-Received: by 2002:a05:600c:230a:b0:40d:8128:bc85 with SMTP id 10-20020a05600c230a00b0040d8128bc85mr657951wmo.103.1704479042709;
        Fri, 05 Jan 2024 10:24:02 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id l3-20020a05600c4f0300b0040d8d11bd4esm2315231wmq.36.2024.01.05.10.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 10:24:01 -0800 (PST)
Date: Fri, 5 Jan 2024 18:23:57 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <ZZhJPaFoVuZEO0IO@google.com>
References: <20231228201100.78aae259@rorschach.local.home>
 <ZZfJQTOyl0dHiTU-@google.com>
 <20240105084100.5fe6ffa0@gandalf.local.home>
 <ZZgRS_5qLV0O-iue@google.com>
 <20240105123111.02dd9915@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240105123111.02dd9915@gandalf.local.home>

On Fri, Jan 05, 2024 at 12:31:11PM -0500, Steven Rostedt wrote:
> On Fri, 5 Jan 2024 14:25:15 +0000
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > > > Maybe this ioctl should be called regardless if events are found on the current
> > > > reader page. This would at least update the reader->read field and make sure
> > > > subsequent readers are not getting the same events we already had here?  
> > > 
> > > If we call the ioctl() before we are finished reading events, the events on
> > > the reader page will be discarded and added back to the writer buffer if
> > > the writer is not on the reader page.  
> > 
> > Hum, I am a bit confused here. If the writer is not on the reader page, then
> > there's no way a writer could overwrite these events while we access them?
> 
> Maybe I'm confused. Where do you want to call the ioctl again? If the
> writer is off the reader page and we call the ioctl() where no new events
> were added since our last read, the ioctl() will advance the reader page,
> will it not? That is, any events that were on the previous reader page that
> we did not read yet is lost.

I meant like the snippet you shared below.

If on a reader page, there are "unread" events, the ioctl will simply return the
same reader page, as long as there is something to read. It is then safe to call
the ioctl unconditionally.

> 
> The trace_mmap_load_subbuf() is called to update the reader page. If for
> some reason the kbuf hasn't read all the data and calls the
> tracefs_cpu_read_buf() again, it should still return the same kbuf, but
> updated.
> 
>  kbuf = tracefs_cpu_read_buf() {
>     ret = trace_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf) {
>         if (data != kbuffer_subbuffer(kbuf)) {
>             kbuffer_load_subbuffer(kbuf, data);
>             return 1;
>         }
>      return ret > 0 ? tcpu->kbuf : NULL;
>  }
> 
>  record.data = kbuffer_read_event(kbuf, &record.ts);
>  kbuffer_next_event(kbuf, NULL);
> 
>  kbuf = tracefs_cpu_read_buf() {
>     ret = trace_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf) {
>         kbuffer_refresh(kbuf);
>         /* Are there still events to read? */
>         if (kbuffer_curr_size(kbuf))
>             return 1;
> 
> The above should return because the application has not read all of the
> kbuf yet. This is perfectly fine for the application to do this.
> 
> If we don't return here, but instead do:
> 
>         ioctl(tmap->fd, TRACE_MMAP_IOCTL_GET_READER);
> 
> The buffer that kbuf points to will be swapped out with a new page. And the
> data on the buffer is lost.

It shouldn't, the same reader page will be returned, only the reader_page->read
pointer would be updated.

> 
> Hmm, but looking at how the code currently works without mapping, it looks
> like it would do the read again anyway assuming that the kbuf was
> completely read before reading again. Perhaps it would make the logic
> simpler to assume that the buffer was completely read before this gets
> called again. That is, we could have it do:
> 
> 	if (data != kbuffer_subbuffer(kbuf)) {
> 		kbuffer_load_subbuffer(kbuf, data);
> 		return 1;
> 	}
> 
> 	if (ioctl(tmap->fd, TRACE_MMAP_IOCTL_GET_READER) < 0)
> 		return -1;
> 
> 	if (id != tmap->map->reader.id) {
> 		/* New page, just reload it */
> 		data = tmap->data + tmap->map->subbuf_size * id;
> 		kbuffer_load_subbuffer(kbuf, data);
> 		return 1;
> 	}
> 
> 	/*
> 	 * Perhaps the reader page had a write that added
> 	 * more data.
> 	 */
> 	kbuffer_refresh(kbuf);
> 
> 	/* Are there still events to read? */
> 	return kbuffer_curr_size(kbuf) ? 1 : 0;
>

That sounds good

> 
> > 
> > > 
> > > And there should only be one reader accessing the map. This is not thread
> > > safe. Once you load the subbuffer into kbuf, kbuf handles what was read. We
> > > don't want to use the reader page for that.  
> > 
> > I had in mind a scenario with two sequential read. In that case only the reader
> > page read could help to "save" what has been read so far.
> > 
> > Currently, we have:
> > 
> >  <event A>
> >  ./cpu-map
> >    print event A
> > 
> >  <event B>
> >  ./cpu-map
> >    print event A 
> >    print event B
> 
> The kbuffer keeps track of what was read from it, so I'm still confused by
> what you mean.

We probably want to keep track of what has already been consumed outside of
the remits of a single libtraceevent execution.

But now with the code snippet above, in addition to the fast-forward when the
kbuf is first loaded (kbuffer_read_buffer(kbuf, tmpbuf, tmap->map->reader.read)), 
we shouldn't have that problem anymore.

  <event A>
  $ ./cpu-map
    print event A
 
  <event B>
  $ ./cpu-map
    print event B

Or even

  <event A>
  $ ./cpu-map
    print event A
 
  <event B>
  $ cat /sys/kernel/tracing/trace_pipe
    print event B
> 
> -- Steve
