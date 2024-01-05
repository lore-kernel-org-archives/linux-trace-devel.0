Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDE436091
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 20:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D89C433C8;
	Fri,  5 Jan 2024 20:20:54 +0000 (UTC)
Date: Fri, 5 Jan 2024 15:22:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <20240105152202.5b6995c0@gandalf.local.home>
In-Reply-To: <20240105084100.5fe6ffa0@gandalf.local.home>
References: <20231228201100.78aae259@rorschach.local.home>
	<ZZfJQTOyl0dHiTU-@google.com>
	<20240105084100.5fe6ffa0@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 5 Jan 2024 08:41:00 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > Could it fast-forward to the event until tmap->map->reader.read? So we don't
> > read again the same events.
> > 
> > Something like
> > 
> >   while (kbuf->curr < tmap->map->reader.read)
> >   	kbuffer_next_event(kbuf, NULL);  
> 
> Note that kbuf->curr is not available to libtracefs. That's internal to
> libtraceevent.
> 
> But we could have somethings like:
> 
> 	kbuffer_load_subbuffer(kbuf, data);
> 
> 	/* Update to kbuf index to the next read */
> 	if (tmap->map->reader.read) {
> 		char tmpbuf[tmap->map->reader.read];
> 		kbuffer_read_buffer(kbuf, tmpbuf, tmap->map->reader.read);
> 	}
> 
> Which should move the kbuf->curr to reader.read.

So, I tried out this:

(compiled the sample code into /tmp/map)

 # taskset -c 0 echo hello > /sys/kernel/tracing/trace_marker
 # /tmp/map 0
<...>-3767  6659.560129846	print: tracing_mark_write: hello

 # taskset -c 0 echo hello 2 > /sys/kernel/tracing/trace_marker
# /tmp/map 0
<...>-3767  6659.560129846	print: tracing_mark_write: hello

<...>-3769  6669.280279823	print: tracing_mark_write: hello 2


So it reported "hello" and "hello 2" but only should have reported "hello 2".

I added this:

@@ -111,6 +112,16 @@ __hidden void *trace_mmap(int fd, struct kbuffer *kbuf)
        data = tmap->data + tmap->map->subbuf_size * tmap->last_idx;
        kbuffer_load_subbuffer(kbuf, data);
 
+       /*
+        * The page could have left over data on it that was already
+        * consumed. Move the "read" forward in that case.
+        */
+       if (tmap->map->reader.read) {
+               int size = kbuffer_start_of_data(kbuf) + tmap->map->reader.read;
+               char tmpbuf[size];
+               kbuffer_read_buffer(kbuf, tmpbuf, size);
+       }
+
        return tmap;
 }

And now I get:

 # taskset -c 0 echo hello > /sys/kernel/tracing/trace_marker
 # /tmp/map 0
<...>-3938  6820.503525176	print: tracing_mark_write: hello

 # taskset -c 0 echo hello 2 > /sys/kernel/tracing/trace_marker
 # /tmp/map 0
<...>-3940  6827.655627086	print: tracing_mark_write: hello 2

The way you were expecting.

[
 Note the above didn't work until I applied to libtraceevent:

  https://lore.kernel.org/all/20240105194015.253165-3-rostedt@goodmis.org/
]

I'll send a v2.

-- Steve.
