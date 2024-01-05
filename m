Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1698935EF4
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 18:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314DCC433C8;
	Fri,  5 Jan 2024 18:59:02 +0000 (UTC)
Date: Fri, 5 Jan 2024 14:00:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <20240105140010.06c09e3a@gandalf.local.home>
In-Reply-To: <ZZhJPaFoVuZEO0IO@google.com>
References: <20231228201100.78aae259@rorschach.local.home>
	<ZZfJQTOyl0dHiTU-@google.com>
	<20240105084100.5fe6ffa0@gandalf.local.home>
	<ZZgRS_5qLV0O-iue@google.com>
	<20240105123111.02dd9915@gandalf.local.home>
	<ZZhJPaFoVuZEO0IO@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 5 Jan 2024 18:23:57 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> On Fri, Jan 05, 2024 at 12:31:11PM -0500, Steven Rostedt wrote:
> > On Fri, 5 Jan 2024 14:25:15 +0000
> > Vincent Donnefort <vdonnefort@google.com> wrote:
> >   
> > > > > Maybe this ioctl should be called regardless if events are found on the current
> > > > > reader page. This would at least update the reader->read field and make sure
> > > > > subsequent readers are not getting the same events we already had here?    
> > > > 
> > > > If we call the ioctl() before we are finished reading events, the events on
> > > > the reader page will be discarded and added back to the writer buffer if
> > > > the writer is not on the reader page.    
> > > 
> > > Hum, I am a bit confused here. If the writer is not on the reader page, then
> > > there's no way a writer could overwrite these events while we access them?  
> > 
> > Maybe I'm confused. Where do you want to call the ioctl again? If the
> > writer is off the reader page and we call the ioctl() where no new events
> > were added since our last read, the ioctl() will advance the reader page,
> > will it not? That is, any events that were on the previous reader page that
> > we did not read yet is lost.  
> 
> I meant like the snippet you shared below.
> 
> If on a reader page, there are "unread" events, the ioctl will simply return the
> same reader page, as long as there is something to read. It is then safe to call
> the ioctl unconditionally.

There's only unread events the first time we read the cpubuffer after
mapping. Then every ioctl() will give a new page if the writer is not
currently on it.

int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu)
{
	struct ring_buffer_per_cpu *cpu_buffer;
	unsigned long reader_size;
	unsigned long flags;

	cpu_buffer = rb_get_mapped_buffer(buffer, cpu);
	if (IS_ERR(cpu_buffer))
		return (int)PTR_ERR(cpu_buffer);

	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
consume:
	if (rb_per_cpu_empty(cpu_buffer))
		goto out;

	reader_size = rb_page_size(cpu_buffer->reader_page);

	/*
	 * There are data to be read on the current reader page, we can
	 * return to the caller. But before that, we assume the latter will read
	 * everything. Let's update the kernel reader accordingly.
	 */
	if (cpu_buffer->reader_page->read < reader_size) {
		while (cpu_buffer->reader_page->read < reader_size)
			rb_advance_reader(cpu_buffer);

// This updates the reader_page to the size of the page.
// This means that the next time this is called, it will swap the page.

		goto out;
	}

	if (WARN_ON(!rb_get_reader_page(cpu_buffer)))
		goto out;

	goto consume;
out:
	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
	rb_put_mapped_buffer(cpu_buffer);

	return 0;
}


> 
> > 
> > The trace_mmap_load_subbuf() is called to update the reader page. If for
> > some reason the kbuf hasn't read all the data and calls the
> > tracefs_cpu_read_buf() again, it should still return the same kbuf, but
> > updated.
> > 
> >  kbuf = tracefs_cpu_read_buf() {
> >     ret = trace_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf) {
> >         if (data != kbuffer_subbuffer(kbuf)) {
> >             kbuffer_load_subbuffer(kbuf, data);
> >             return 1;
> >         }
> >      return ret > 0 ? tcpu->kbuf : NULL;
> >  }
> > 
> >  record.data = kbuffer_read_event(kbuf, &record.ts);
> >  kbuffer_next_event(kbuf, NULL);
> > 
> >  kbuf = tracefs_cpu_read_buf() {
> >     ret = trace_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf) {
> >         kbuffer_refresh(kbuf);
> >         /* Are there still events to read? */
> >         if (kbuffer_curr_size(kbuf))
> >             return 1;
> > 
> > The above should return because the application has not read all of the
> > kbuf yet. This is perfectly fine for the application to do this.
> > 
> > If we don't return here, but instead do:
> > 
> >         ioctl(tmap->fd, TRACE_MMAP_IOCTL_GET_READER);
> > 
> > The buffer that kbuf points to will be swapped out with a new page. And the
> > data on the buffer is lost.  
> 
> It shouldn't, the same reader page will be returned, only the reader_page->read
> pointer would be updated.

But after the first read of the page, the reader_page->read is at the end,
and will swap.

> 
> > 
> > Hmm, but looking at how the code currently works without mapping, it looks
> > like it would do the read again anyway assuming that the kbuf was
> > completely read before reading again. Perhaps it would make the logic
> > simpler to assume that the buffer was completely read before this gets
> > called again. That is, we could have it do:
> > 
> > 	if (data != kbuffer_subbuffer(kbuf)) {
> > 		kbuffer_load_subbuffer(kbuf, data);
> > 		return 1;
> > 	}
> > 
> > 	if (ioctl(tmap->fd, TRACE_MMAP_IOCTL_GET_READER) < 0)
> > 		return -1;
> > 
> > 	if (id != tmap->map->reader.id) {
> > 		/* New page, just reload it */
> > 		data = tmap->data + tmap->map->subbuf_size * id;
> > 		kbuffer_load_subbuffer(kbuf, data);
> > 		return 1;
> > 	}
> > 
> > 	/*
> > 	 * Perhaps the reader page had a write that added
> > 	 * more data.
> > 	 */
> > 	kbuffer_refresh(kbuf);
> > 
> > 	/* Are there still events to read? */
> > 	return kbuffer_curr_size(kbuf) ? 1 : 0;
> >  
> 
> That sounds good
> 
> >   
> > >   
> > > > 
> > > > And there should only be one reader accessing the map. This is not thread
> > > > safe. Once you load the subbuffer into kbuf, kbuf handles what was read. We
> > > > don't want to use the reader page for that.    
> > > 
> > > I had in mind a scenario with two sequential read. In that case only the reader
> > > page read could help to "save" what has been read so far.
> > > 
> > > Currently, we have:
> > > 
> > >  <event A>
> > >  ./cpu-map
> > >    print event A
> > > 
> > >  <event B>
> > >  ./cpu-map
> > >    print event A 
> > >    print event B  
> > 
> > The kbuffer keeps track of what was read from it, so I'm still confused by
> > what you mean.  
> 
> We probably want to keep track of what has already been consumed outside of
> the remits of a single libtraceevent execution.
> 
> But now with the code snippet above, in addition to the fast-forward when the
> kbuf is first loaded (kbuffer_read_buffer(kbuf, tmpbuf, tmap->map->reader.read)), 
> we shouldn't have that problem anymore.
> 
>   <event A>
>   $ ./cpu-map
>     print event A
>  
>   <event B>
>   $ ./cpu-map
>     print event B

I think that should be on the kernel side. The first mapping should update
the read meta page and then update the reader_page so that the next mapping
will give something different.

> 
> Or even
> 
>   <event A>
>   $ ./cpu-map
>     print event A
>  
>   <event B>
>   $ cat /sys/kernel/tracing/trace_pipe
>     print event B

So this is a kernel change, not a library one.

-- Steve
