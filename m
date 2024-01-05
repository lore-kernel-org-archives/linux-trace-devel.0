Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63E82E3E8
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 14:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XM/2OU6Q"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-336746c7b6dso1169017f8f.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Jan 2024 06:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704464719; x=1705069519; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ELrpz+EYx8M0wX7h6inI9jKG7fZbVizMXDHBpWELeDU=;
        b=XM/2OU6QNLKvmeoXIs8MRUWESOInW6AA75w+/AOpCJIWGbgxmAo1H+qNG3TJF7UcNV
         v3tE6trw5pc0Q3nC1UxWL0DdX3sSOyQk2aqEuj59/8SFFMjmDjnIQidA2ioWHjHoaG3G
         asdB8HAlrYsThFGfGlkWyJNKkuYiUeLlTo/mstEMN1Sw6gX/+ZpymKsJe0jKS120BZqu
         QecuBh+JWHoV8ZiM5+1Fe23yDU/GnQpIIPM7kPUFG4omU+d6oeyywFkbWn4VyepT/I4f
         Y6NJNyCnh83mCDuCjKwPArsELqVYp6Djkt2JZ/MINl8fluCzoN4ZCzR/+RAGNfBrHFkt
         TTKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704464719; x=1705069519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELrpz+EYx8M0wX7h6inI9jKG7fZbVizMXDHBpWELeDU=;
        b=ktRnmS3WLYx7qaPXnbnGkeBYr1b30THjRcdHEUsLj5uutWYOUm4nBIe7ZKC0XZMAvh
         7OHNOj+eE2Xba9j9p6eDA7eA/HcwS9v++Lcv1xpPAcBurZacrFhOIE5hODyTQwCWsuy7
         Rpq+ToPRUloKl1/EmrUuYKmHuzGNq3kLO7hvRIFQ8B+Q0iTjYFBrtklGvEttdU3HyMDx
         uzLX25sIHPfN8LSv1E7XT5Nsx5GebRImfRp+NF3zKb3rbnr5FTVoTLFWkQZ32lvwfVZs
         HdN7nO4eVrxOfzng1PceZu5+gINrmHzRJLoFDONt1xVKv9oipwhz4j3vyqiW4/9J4WO8
         D/LQ==
X-Gm-Message-State: AOJu0YzBCuek5Jx+i8+71rLv7BY0HgGlWSHWLWmg9kdeG8jP4LFhP+//
	mC/Lr87LWcZosZ6B0GwNJkJ/+gnCMAF4hl7dZdr8M4TfKKjg
X-Google-Smtp-Source: AGHT+IFFs6h2DlzMnubtLM3G6FH5CgXDPOQyluQGb2DmOpd+vjw5uY2oig3mIhBdcDk9pypFq73b1g==
X-Received: by 2002:adf:c64e:0:b0:336:da60:d60c with SMTP id u14-20020adfc64e000000b00336da60d60cmr1517133wrg.115.1704464718809;
        Fri, 05 Jan 2024 06:25:18 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id cx12-20020a056000092c00b00336b702af06sm1493151wrb.16.2024.01.05.06.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 06:25:18 -0800 (PST)
Date: Fri, 5 Jan 2024 14:25:15 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Add ring buffer memory mapping APIs
Message-ID: <ZZgRS_5qLV0O-iue@google.com>
References: <20231228201100.78aae259@rorschach.local.home>
 <ZZfJQTOyl0dHiTU-@google.com>
 <20240105084100.5fe6ffa0@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240105084100.5fe6ffa0@gandalf.local.home>

[...]

> > > +	/*
> > > +	 * Perhaps the reader page had a write that added
> > > +	 * more data.
> > > +	 */
> > > +	kbuffer_refresh(kbuf);
> > > +
> > > +	/* Are there still events to read? */
> > > +	if (kbuffer_curr_size(kbuf))
> > > +		return 1;  
> > 
> > It does not seem to be enough, only kbuf->size is updated in kbuffer_refresh()
> > while kbuffer_curr_size is next - cur.
> 
> That's the size of the event, not what's on the buffer. Next just points to
> the end of the current event. Hmm, or you mean that we read the last event
> and something else was added? Yeah, should check if curr == size, then next
> would need to be updated. That's a bug in kbuffer_refresh().

Yeah, probably kbuffer_refresh should also update kbuf->next and not only
kbuf->size.

> 
> > 
> > > +
> > > +	/* See if a new page is ready? */
> > > +	if (ioctl(tmap->fd, TRACE_MMAP_IOCTL_GET_READER) < 0)
> > > +		return -1;  
> > 
> > Maybe this ioctl should be called regardless if events are found on the current
> > reader page. This would at least update the reader->read field and make sure
> > subsequent readers are not getting the same events we already had here?
> 
> If we call the ioctl() before we are finished reading events, the events on
> the reader page will be discarded and added back to the writer buffer if
> the writer is not on the reader page.

Hum, I am a bit confused here. If the writer is not on the reader page, then
there's no way a writer could overwrite these events while we access them?

> 
> And there should only be one reader accessing the map. This is not thread
> safe. Once you load the subbuffer into kbuf, kbuf handles what was read. We
> don't want to use the reader page for that.

I had in mind a scenario with two sequential read. In that case only the reader
page read could help to "save" what has been read so far.

Currently, we have:

 <event A>
 ./cpu-map
   print event A

 <event B>
 ./cpu-map
   print event A 
   print event B

> 
> If something is reading the buffer outside this application, it's fine if
> we read the same events. Multiple readers of the same buffer already screw
> things up today. That's why I created instances.
> 
> -- Steve
> 
> 
> > 
> > > +	id = tmap->map->reader.id;
> > > +	data = tmap->data + tmap->map->subbuf_size * id;
> > > +  
> > 
> > [...]
> 
