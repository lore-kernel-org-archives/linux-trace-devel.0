Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675E35FDA3
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 15:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706022838; cv=none; b=QV1PSyFeF0T5aRPXPJiYyToumJPe9z0fCSk17v6s3bQ/CFAH2loUdeI5ts0U9y+3Ix4t79xti64c8rUIW2EPq4Jb4iHqVoJAXIdNv5+Pwf3be8R1B9x/nu6jdtt9UoqAy+kMc5WBUCtD7WP/wJkHtzt8RrAYVgd4WfvXt1ZWZh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706022838; c=relaxed/simple;
	bh=YflcbesqM/hBfI/C1guEXxIQYBpmwEI9ONQMonclpa4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TKZN+Rh6N8ZreYzZdRGE+9sHV9TyWHdmqAX0iFN6nznQ9x3hqK9GlNNw+4vQpZiu8RHR7UedW7PJnp8CuLlzEDYIMTwb+UU3bJ5rx9U7bQ4cSOgBtT3S6ArUaRPUfBDmEfrjnqb2+QCS+HbK0FYt+pqf5N2ndk5Cd56GKEEH3Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE25C433F1;
	Tue, 23 Jan 2024 15:13:57 +0000 (UTC)
Date: Tue, 23 Jan 2024 10:15:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <20240123101528.66373913@gandalf.local.home>
In-Reply-To: <Za-Md51snPcIoYFn@google.com>
References: <20240105152906.743d7e03@gandalf.local.home>
	<Za-Md51snPcIoYFn@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Jan 2024 09:52:55 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> [...]
> 

> > +	data = tmap->data + tmap->map->subbuf_size * tmap->last_idx;
> > +	kbuffer_load_subbuffer(kbuf, data);

Only the tmap->kbuf is loaded above.


> > +
> > +	/*
> > +	 * The page could have left over data on it that was already
> > +	 * consumed. Move the "read" forward in that case.
> > +	 */
> > +	if (tmap->map->reader.read) {
> > +		int size = kbuffer_start_of_data(kbuf) + tmap->map->reader.read;
> > +		char tmpbuf[size];
> > +		kbuffer_read_buffer(kbuf, tmpbuf, size);
> > +	}  
> 
> We're fast-forwarding tmap->kbuf here. But in tracefs_cpu_read_buf(), we are
> using tcpu->kbuf. So overall, it seems this has no effect on what will be read
> later.
> 
> Sorry, not sure how I missed that when I worked with those changes before.

So we would need to add this in trace_mmap_load_subbuf()?


	if (data != kbuffer_subbuffer(kbuf)) {
		kbuffer_load_subbuffer(kbuf, data);
+		/* Move the read pointer forward if need be */
+		if (kbuffer_curr_index(tmap->kbuf)) {
+			int size = kbuffer_curr_index(tmap->kbuf);
+			char tmpbuf[size];
+			kbuffer_read_buffer(kbuf, tmpbuf, size);
+		}
		
		return 1;
	}

I think that could solve that.

-- Steve
