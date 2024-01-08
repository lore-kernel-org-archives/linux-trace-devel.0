Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5CB53E1F
	for <linux-trace-devel@vger.kernel.org>; Mon,  8 Jan 2024 16:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jJ5vr/vT"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3376ead25e1so688528f8f.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Jan 2024 08:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704732448; x=1705337248; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CnifjIzisvQv7q2pNVpmZmrK4xtUhC2UuZ6lRNroiuw=;
        b=jJ5vr/vTrGog4m1fnCLapm+w1blbEkklxfSHq8D5X25yTHRv/NNa3pS22sdrtcIR9E
         8OQZCYd0Wil5ahvDd+OQ0xj+btubtqwJuFh+AWlCib4C8WhybdOLVxD4v6LfhKHhPoQn
         Wyup5ZWgTd1ZMRxXk217DGMXgaGDrOcpllJex+iKOskJzSFDlihnBIaYF2Q7qVCxI/Co
         HdZEg793QrQc8/8MaxlEquxku67WIqUrdgy2NfRpgWdICAGwL0SzkhZY9OwSvJpOLNcU
         jccZ9HWQGsQT8OJy6b0vGlGKRv+Nu78/eNT56P0lZnoLfJrO9c5B/MoA1dksA4d8yaqd
         qqzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704732448; x=1705337248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnifjIzisvQv7q2pNVpmZmrK4xtUhC2UuZ6lRNroiuw=;
        b=W3XOzeCuujWTHdJFi1IzOn8Bgszsb1OSLdtjR0hLjhQu+eMtAHhv2T8VYt1OdWaclc
         peSwHL6lZZxTPpxPTEJhBfRgS8gdxi3gAQJBoXp3IR2GJL3GAlY+T4RlEfGd4v5y/GPw
         El2xQ7+C+jGx0UQ4uv5p9LARXhEgzMPaB7iKO0uM7oreKlMTHwRymr/SuyLZMPGEmrww
         KkRpZ9cJHEkDPzirtE6N1eBEeeIsGcMGfKLmI6KscWCJEQz/fT4HrcsgrY4clryw5Xhs
         H1+ayiIixZUa3oH7WXmJQiEGTrmYQfaFxVvcchJeYr/28QQkZSCtLpPlS4TUqs2E8Mrn
         j/wQ==
X-Gm-Message-State: AOJu0Yx7WIKWOJPi0w8xu1PnNpZEeHSDqjrQ0M/0pfQG3OVOKcYrdN/E
	cV2ncujYRrviq/o/i5E3SOhWC1gZ5wkxiOuVUt5+DMqLld6S
X-Google-Smtp-Source: AGHT+IEK4B0qunMoO0ufCJPjcVFL7wgnkCbafBsWwTJHQa1OmJwOPSDVBMnJ2+Vl06bfElfqkVWhpw==
X-Received: by 2002:a05:6000:cd1:b0:336:ca94:3e00 with SMTP id dq17-20020a0560000cd100b00336ca943e00mr1905402wrb.69.1704732448077;
        Mon, 08 Jan 2024 08:47:28 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id z16-20020a5d4d10000000b0033686e8f02dsm101917wrt.45.2024.01.08.08.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jan 2024 08:47:27 -0800 (PST)
Date: Mon, 8 Jan 2024 16:47:23 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] kbuffer: Update kbuf->next in kbuffer_refresh()
Message-ID: <ZZwnG9foWd7H4vfa@google.com>
References: <20240105194015.253165-1-rostedt@goodmis.org>
 <20240105194015.253165-4-rostedt@goodmis.org>
 <ZZhuKFAkDHRLHlwt@google.com>
 <ZZvYYY5MI8l803Ad@google.com>
 <20240108112853.2574015e@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240108112853.2574015e@gandalf.local.home>

On Mon, Jan 08, 2024 at 11:28:53AM -0500, Steven Rostedt wrote:
> On Mon, 8 Jan 2024 11:11:29 +0000
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > Yeah it seems that the update_pointers() is not enough. 
> > 
> > kbuffer_next_event(kbuf, NULL) will make sure curr is also up to date and will
> > do the update until an event type we can read. With that change I don't see any
> > spurious "mmiotrace_rw" on the output.
> 
> 
> Ah you're right. Try this.
> 
> -- Steve
> 
> diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
> index 1e1d168..5651797 100644
> --- a/src/kbuffer-parse.c
> +++ b/src/kbuffer-parse.c
> @@ -180,6 +180,7 @@ static int calc_index(struct kbuffer *kbuf, void *ptr)
>  	return (unsigned long)ptr - (unsigned long)kbuf->data;
>  }
>  
> +static int next_event(struct kbuffer *kbuf);
>  static int __next_event(struct kbuffer *kbuf);
>  
>  /*
> @@ -323,12 +324,8 @@ int kbuffer_refresh(struct kbuffer *kbuf)
>  	kbuf->size = (unsigned int)flags & COMMIT_MASK;
>  
>  	/* Update next to be the next element */
> -	if (kbuf->size != old_size && kbuf->curr == old_size) {
> -		if (kbuf->flags & KBUFFER_FL_OLD_FORMAT)
> -			old_update_pointers(kbuf);
> -		else
> -			update_pointers(kbuf);
> -	}
> +	if (kbuf->size != old_size && kbuf->curr == kbuf->next)
> +		next_event(kbuf);
>  
>  	return 0;
>  }

That worked!
