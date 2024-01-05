Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E384B328CD
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 17:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E819BC433C7;
	Fri,  5 Jan 2024 17:30:03 +0000 (UTC)
Date: Fri, 5 Jan 2024 12:31:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <20240105123111.02dd9915@gandalf.local.home>
In-Reply-To: <ZZgRS_5qLV0O-iue@google.com>
References: <20231228201100.78aae259@rorschach.local.home>
	<ZZfJQTOyl0dHiTU-@google.com>
	<20240105084100.5fe6ffa0@gandalf.local.home>
	<ZZgRS_5qLV0O-iue@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 5 Jan 2024 14:25:15 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> > > Maybe this ioctl should be called regardless if events are found on the current
> > > reader page. This would at least update the reader->read field and make sure
> > > subsequent readers are not getting the same events we already had here?  
> > 
> > If we call the ioctl() before we are finished reading events, the events on
> > the reader page will be discarded and added back to the writer buffer if
> > the writer is not on the reader page.  
> 
> Hum, I am a bit confused here. If the writer is not on the reader page, then
> there's no way a writer could overwrite these events while we access them?

Maybe I'm confused. Where do you want to call the ioctl again? If the
writer is off the reader page and we call the ioctl() where no new events
were added since our last read, the ioctl() will advance the reader page,
will it not? That is, any events that were on the previous reader page that
we did not read yet is lost.

The trace_mmap_load_subbuf() is called to update the reader page. If for
some reason the kbuf hasn't read all the data and calls the
tracefs_cpu_read_buf() again, it should still return the same kbuf, but
updated.

 kbuf = tracefs_cpu_read_buf() {
    ret = trace_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf) {
        if (data != kbuffer_subbuffer(kbuf)) {
            kbuffer_load_subbuffer(kbuf, data);
            return 1;
        }
     return ret > 0 ? tcpu->kbuf : NULL;
 }

 record.data = kbuffer_read_event(kbuf, &record.ts);
 kbuffer_next_event(kbuf, NULL);

 kbuf = tracefs_cpu_read_buf() {
    ret = trace_mmap_load_subbuf(tcpu->mapping, tcpu->kbuf) {
        kbuffer_refresh(kbuf);
        /* Are there still events to read? */
        if (kbuffer_curr_size(kbuf))
            return 1;

The above should return because the application has not read all of the
kbuf yet. This is perfectly fine for the application to do this.

If we don't return here, but instead do:

        ioctl(tmap->fd, TRACE_MMAP_IOCTL_GET_READER);

The buffer that kbuf points to will be swapped out with a new page. And the
data on the buffer is lost.

Hmm, but looking at how the code currently works without mapping, it looks
like it would do the read again anyway assuming that the kbuf was
completely read before reading again. Perhaps it would make the logic
simpler to assume that the buffer was completely read before this gets
called again. That is, we could have it do:

	if (data != kbuffer_subbuffer(kbuf)) {
		kbuffer_load_subbuffer(kbuf, data);
		return 1;
	}

	if (ioctl(tmap->fd, TRACE_MMAP_IOCTL_GET_READER) < 0)
		return -1;

	if (id != tmap->map->reader.id) {
		/* New page, just reload it */
		data = tmap->data + tmap->map->subbuf_size * id;
		kbuffer_load_subbuffer(kbuf, data);
		return 1;
	}

	/*
	 * Perhaps the reader page had a write that added
	 * more data.
	 */
	kbuffer_refresh(kbuf);

	/* Are there still events to read? */
	return kbuffer_curr_size(kbuf) ? 1 : 0;


> 
> > 
> > And there should only be one reader accessing the map. This is not thread
> > safe. Once you load the subbuffer into kbuf, kbuf handles what was read. We
> > don't want to use the reader page for that.  
> 
> I had in mind a scenario with two sequential read. In that case only the reader
> page read could help to "save" what has been read so far.
> 
> Currently, we have:
> 
>  <event A>
>  ./cpu-map
>    print event A
> 
>  <event B>
>  ./cpu-map
>    print event A 
>    print event B

The kbuffer keeps track of what was read from it, so I'm still confused by
what you mean.

-- Steve
