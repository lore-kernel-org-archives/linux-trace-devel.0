Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546FF1426D
	for <linux-trace-devel@vger.kernel.org>; Mon,  8 Jan 2024 11:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1C9j8agl"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40b5155e154so22284185e9.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Jan 2024 03:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704712293; x=1705317093; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BOOhBlA27uzhyVCiTVcFQvzX/ATkJKlZEDqWwgrGPvs=;
        b=1C9j8aglfZ3K4/Fc8o3VsPGupmZk0540BZqSMd07XfLC854gES8aS+aumpaF6zzb0i
         mNwawrc+k12b/LkdBAFGHtZwVn13CiJU/9HIYNpH7gYSUDgTqp9qoTW92zAi/O0FV9Qo
         R3vT0Y4Wz/MyJLihD8dRmA3pBSjMDebwyyXKb2g8/EUh62a9oZ7amkzzbjja1bJwc4V9
         DJreNXfp6kgOLkQsDj+VAIyn1h/7oU+ZNVWYsEsDFuOJ6Ql3PHYmLKPvVk81zw3lwA5N
         v+5Xw2hyFtwuw+5BIqZd0CUn34nXCrRBDlzgafBuyB6bykH+2iGoYicqZOmjKq/7g/c7
         O3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704712293; x=1705317093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BOOhBlA27uzhyVCiTVcFQvzX/ATkJKlZEDqWwgrGPvs=;
        b=UpDMBj31bo1xlLGfHSmg/i//t4YwxTaIzlf3fWjJFFvjoJXOTIO1gN7biBgfZDsS4/
         gjSybrpiquQ0fe8/ZGYvvamgZPD7nGuNsijFenResXpXr+mCjPeUj6U0IK5acB/3uT8s
         3ov7Kr4hTq+mh+r0keUIwtEy78/I4fZfoZ5R2i2RthZaA1pnSFYi6I7wTIZF8SVWu/nA
         oWIC2F5Tu8Ep1woUO8rpfkU2CU+KMwFY7yDZBvIcyd8wdhWvimsCbiF9s1eqG68M9fm2
         pDpwqqDOqCQ44H/T7e/UN5KreTPFvBypS4/yVbdzoknC7Vn1LPz7B5B/btQmRMavj6IC
         6vzQ==
X-Gm-Message-State: AOJu0YyKP0jI+gi8OJZRUg4KE+MH2YHRfrTyMdw3nnczTdgld3fKzJPb
	hwXxYNlr9Rfk10XQzZAMFsY91SDbcKgWco66IcuyiXeiW+3r
X-Google-Smtp-Source: AGHT+IEAt23CKYC1UZ6Jrxm5Xd0pbxXhTCXQen8LArwJ2uptg13z525RPqFQiWkaU8vvYFlg+CtsHQ==
X-Received: by 2002:a05:600c:3143:b0:40e:3b3a:aeb0 with SMTP id h3-20020a05600c314300b0040e3b3aaeb0mr1661808wmo.156.1704712293324;
        Mon, 08 Jan 2024 03:11:33 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id o31-20020a05600c511f00b0040b37f1079dsm10702176wms.29.2024.01.08.03.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jan 2024 03:11:33 -0800 (PST)
Date: Mon, 8 Jan 2024 11:11:29 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] kbuffer: Update kbuf->next in kbuffer_refresh()
Message-ID: <ZZvYYY5MI8l803Ad@google.com>
References: <20240105194015.253165-1-rostedt@goodmis.org>
 <20240105194015.253165-4-rostedt@goodmis.org>
 <ZZhuKFAkDHRLHlwt@google.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZhuKFAkDHRLHlwt@google.com>

On Fri, Jan 05, 2024 at 09:01:28PM +0000, Vincent Donnefort wrote:
> On Fri, Jan 05, 2024 at 02:37:44PM -0500, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > If the kbuffer was read to completion, the kbuf->curr would equal both the
> > size and kbuf->next. The kbuffer_refresh() is to update the kbuf if more
> > data was added to the buffer. But if curr is at the end, the next pointer
> > was not updated, which is incorrect. The next pointer needs to be moved to
> > the end of the newly written event.
> > 
> > Update the pointers in kbuffer_refresh() just as if it was loaded new (but
> > still keeping curr at the correct location).
> > 
> > Link: https://lore.kernel.org/linux-trace-devel/ZZfJQTOyl0dHiTU-@google.com/
> > 
> > Reported-by: Vincent Donnefort <vdonnefort@google.com>
> > Fixes: 7a4d5b24 ("kbuffer: Add kbuffer_refresh() API")
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> >  src/kbuffer-parse.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
> > index 4801d432c58c..1e1d168b534c 100644
> > --- a/src/kbuffer-parse.c
> > +++ b/src/kbuffer-parse.c
> > @@ -299,6 +299,9 @@ void kbuffer_free(struct kbuffer *kbuf)
> >  	free(kbuf);
> >  }
> >  
> > +static unsigned int old_update_pointers(struct kbuffer *kbuf);
> > +static unsigned int update_pointers(struct kbuffer *kbuf);
> > +
> >  /**
> >   * kbuffer_refresh - update the meta data from the subbuffer
> >   * @kbuf; The kbuffer to update
> > @@ -309,13 +312,24 @@ void kbuffer_free(struct kbuffer *kbuf)
> >  int kbuffer_refresh(struct kbuffer *kbuf)
> >  {
> >  	unsigned long long flags;
> > +	unsigned int old_size;
> >  
> >  	if (!kbuf || !kbuf->subbuffer)
> >  		return -1;
> >  
> > +	old_size = kbuf->size;
> > +
> >  	flags = read_long(kbuf, kbuf->subbuffer + 8);
> >  	kbuf->size = (unsigned int)flags & COMMIT_MASK;
> >  
> > +	/* Update next to be the next element */
> > +	if (kbuf->size != old_size && kbuf->curr == old_size) {
> > +		if (kbuf->flags & KBUFFER_FL_OLD_FORMAT)
> > +			old_update_pointers(kbuf);
> > +		else
> > +			update_pointers(kbuf);
> > +	}
> > +
> >  	return 0;
> >  }
> 
> I've been trying the new stack but I see some weird unexpected events:
> 
> $ echo 3 > /sys/kernel/debug/tracing/trace_marker
> 
> <...>-5 44401.178473328 mmiotrace_rw: 0 0 0 0 0 0     // I clearly didn't enable this event
> <...>-208 44401.178473328       print: tracing_mark_write: 2
> 
> 
> Looking closer at the kbuf I see before the kbuffer_refresh()
> 
>   index = 244, curr = 272, next = 272, size = 272, start = 16
> 
> And after
> 
>   index = 280, curr = 272, next = 280, size = 312, start = 16
> 
> Could this index be the problem as this is used in kbuffer_read_event()?

Yeah it seems that the update_pointers() is not enough. 

kbuffer_next_event(kbuf, NULL) will make sure curr is also up to date and will
do the update until an event type we can read. With that change I don't see any
spurious "mmiotrace_rw" on the output.

> 
> >  
> > -- 
> > 2.42.0
> > 
