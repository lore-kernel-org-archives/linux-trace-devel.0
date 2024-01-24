Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5A612AAD5
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jan 2024 17:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706118847; cv=none; b=rrI/K0r+WSZKU7LWQC7itmspnT1QDDvwjyQkRW4M4FkQiOQGMUTBfZ0nMg6ffyBkQQen6ya02olpuY3fuicaILG50V2V4v/m1UFc+EzuVYApZ20qe+3hKVkc9vt7CzKIEw5wPF5El4u8YkZOL2/gBgXnpp7x40pik6SH8OgsWJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706118847; c=relaxed/simple;
	bh=KdekAxaru+0mSb+wrJovGp9TnbewKCJsRt14j5z2Ub0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IDhoJg6ZUBkEqtqa7QlcRdFE/cDcIQuH+i7lYEFdkVaI1j4YjedbcNckkMmlsF9YXPWMFeP4t7LpdiqG9LwVkveNYYjwTmPvroQAM+VZZu/vHncHkpxPR/6FNL3uIRY3dK3AnV8ri6y3VQWUkhYOxTkT3NX0Z9ULbUrkHFxMF18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G0K6c/9V; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G0K6c/9V"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-339261a6ec2so4002213f8f.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jan 2024 09:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706118844; x=1706723644; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d0a6hLWHtx3P2v3UVNOF/m+cg3s0JN5AXCxJs4sZW+8=;
        b=G0K6c/9Vw4Pj8RyrDRudcw2ZNhSKysXL47Ojff093RFk4B/JuVvYlkRpuG8HLMFxOO
         +uXi89APBxLBKgkVmnCuTY/tZvGVQ8/MDS18yTUU+AISI/tbFlXAZxgDIiTwqXoUgsQ5
         lH+NCs7Jb2MfIPaW+bbgU/i9PsOQGnTJTdTGRg91LDYpI43fv72o6PEu8rtMp9IVEwKy
         xCdThQuz6in1lXlkvpEI17GrKuoG6DngwpKRUQMaPNPEvUVGRxTWZEGNcdvwdaMuxa2a
         FfAytIenr8bLNSKodiZEQoi5MTgGACZsrJy8qu6Q69iXPco/FvFHb8rX2H4S9K6xYDC3
         ZvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706118844; x=1706723644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d0a6hLWHtx3P2v3UVNOF/m+cg3s0JN5AXCxJs4sZW+8=;
        b=HQsFARGxJuLd2y9upvRKB6lEUeobNjhN2fyQVM+cv/t2BFHUUyxHiO+CBQZjnmOY6k
         nbMp2qKEFtDa9sosxcM2DWvUkKsRX0AOQAwxMeT5BCaVzYkXqTzcoUhgl9v4grPErKQ9
         WZtenTvIXJ0sfjiKLK6NimrouMTGtBshzW3iZbq8Maig8SoKpwVHcem/Ihj2tB/FT8jc
         WgVckCVve+pPJqPuwBWPS9au/rUHfsiEHFAd5gOgiJMhhvTJf5eZVAjJ+VVCL/s3i3lY
         1+LEYhUStx/nDjGGrNMr5CVkbvvt6eaDxO2gnxVYU+RJ6ic0GFVZ6ZBetH+dRBC4pJX+
         IXPA==
X-Gm-Message-State: AOJu0YzN4lgeN4TCo8A2zFlThsyYeL9ZiryttvfoUd35Pn5onfqUMo34
	/C7Nq5qXfat9v2g47TGnIsJ5mBc0SOjPEUOUXjSINN7k6GcqPcs5etHEGxH8R5z+G2DcT7CdzZw
	8+A==
X-Google-Smtp-Source: AGHT+IG93taXmHLADlNaGF+mAUJzwk4vZRmWqS6tEJ/+H81nqbO6svh+j59P8OecizMu9fGgOIh/lg==
X-Received: by 2002:a5d:4387:0:b0:339:48da:a15 with SMTP id i7-20020a5d4387000000b0033948da0a15mr819852wrq.76.1706118843764;
        Wed, 24 Jan 2024 09:54:03 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id bk9-20020a0560001d8900b003395642bc9bsm413101wrb.117.2024.01.24.09.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 09:54:03 -0800 (PST)
Date: Wed, 24 Jan 2024 17:54:00 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Update the kbuf for previous read in
 trace_mmap_load_subbuf()
Message-ID: <ZbFOuC0ak6JiOGCJ@google.com>
References: <20240123123337.1f785f98@gandalf.local.home>
 <Za_6Z1uK-KHkU2UV@google.com>
 <20240124115651.6a00a668@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124115651.6a00a668@gandalf.local.home>

On Wed, Jan 24, 2024 at 11:56:51AM -0500, Steven Rostedt wrote:
> On Tue, 23 Jan 2024 17:41:59 +0000
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > On Tue, Jan 23, 2024 at 12:33:37PM -0500, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > > 
> > > The trace_mmap() checks if the mmapped data has any previously read data
> > > (the reader.read value of the meta page is non-zero), then it will pre-read
> > > the kbuf to move its internal reader pointer to the same value.
> > > 
> > > But when tracefs_cpu_read_buf() calls trace_mmap_load_subbuf(), its
> > > kbuf->subbuffer will not be the same as the mapped data and
> > > kbuffer_load_subbuffer() is called on it and it is returned. But that means
> > > its read pointer has not been updated, and the read data will restart again.
> > > 
> > > When the kbuf is updated in trace_mmap_load_subbuf() check the tmap->kbuf to
> > > see if it already read any of the data, and move the kbuffer forward just
> > > like the trace_mmap() does.
> > > 
> > > Link: https://lore.kernel.org/linux-trace-devel/Za-Md51snPcIoYFn@google.com/
> > > 
> > > Fixes: 2ed14b59 ("libtracefs: Add ring buffer memory mapping APIs")
> > > Reported-by: Vincent Donnefort <vdonnefort@google.com>
> > > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>  
> > 
> > That fixes fast-forward, event already read are now skipped.
> 
> Can I also add your "Tested-by" tag then?
> 
> -- Steve

Of course, I wasn't sure you were using those tags for libtracefs. Will make it
more explicit next time!
