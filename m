Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E39F35F19
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 20:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5921C433C8;
	Fri,  5 Jan 2024 20:10:36 +0000 (UTC)
Date: Fri, 5 Jan 2024 15:11:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <20240105151145.55996b48@gandalf.local.home>
In-Reply-To: <20240105123111.02dd9915@gandalf.local.home>
References: <20231228201100.78aae259@rorschach.local.home>
	<ZZfJQTOyl0dHiTU-@google.com>
	<20240105084100.5fe6ffa0@gandalf.local.home>
	<ZZgRS_5qLV0O-iue@google.com>
	<20240105123111.02dd9915@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 5 Jan 2024 12:31:11 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Hmm, but looking at how the code currently works without mapping, it looks
> like it would do the read again anyway assuming that the kbuf was
> completely read before reading again. Perhaps it would make the logic
> simpler to assume that the buffer was completely read before this gets
> called again. That is, we could have it do:

Now I remember why I did it the other way. This is called to get the
kbuffer after it is mapped. That is, the first time we call this,
kbuf->curr will be zero, and we do not want to call the ioctl(). If we do,
we just threw away all the events currently loaded on the kbuf.

That is, the code does this:


        tcpu = tracefs_cpu_open_mapped(NULL, cpu, 0);

// Here the memory is already mapped, and a kbuf is loaded.

        mapped = tracefs_cpu_is_mapped(tcpu);
        if (!mapped)
                printf("Was not able to map, falling back to buffered read\n");
        while ((kbuf = mapped ? tracefs_cpu_read_buf(tcpu, true) :

// The tracefs_cpu_read_buf() will call the trace_mmap_load_subbuf().
// That is, it must check if kbuf has left over data and return that.
// If it does the ioctl() here, it will throw out what it loaded in the
// initial mapping.


                        tracefs_cpu_buffered_read_buf(tcpu, true))) {
                read_page(tep, kbuf);
        }



-- Steve


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

