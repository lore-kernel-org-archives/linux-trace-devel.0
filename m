Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A09480046
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 17:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706031728; cv=none; b=DXXn4dUWmQKADQLncJOYlQQY4tf5dDTrRw+XD5MhFKDGLdWf+jAzpjibXWX+1ixA5OIMbsbjYskYhF1CiyuS8hHToGGuRY08HC68YgCSQ+DqRnSTfgwXJozDNyN3U6fgtvXuKzG4LiG7tmOzjqyB2U4ZBSp0rT+VqAFBJu72YUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706031728; c=relaxed/simple;
	bh=KZaBu5kCp1tpzy8AEmMz667V3w7oTzsr+05EsiCQLX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iS3D4B0qvXTmkCJADEhOk6Axi2huogNu8n1ReyHfD5Gq4ArsmW20iO1L0DCPkCZMe9NxDE+YqlcyFX2WPb52DDARv8cwXoPui4O+g+JWWY70MB3Tn22IeZbjhk/ywXPv9CrBvihitnteQ7kYwrWNz5ZZy7TV0QIuJ9Ixdnswyc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L2pf1iHP; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L2pf1iHP"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40e800461baso54861635e9.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 09:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706031724; x=1706636524; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Fi9SUnw+P6s+wHqDKKJH/WGmg+iG7l0IoyH1Ule5sg=;
        b=L2pf1iHP0kHzCIgEkb2AQtjo0nVXmbPgjSwArZyvkWFpTjIqNp4SH1LV2xLjcfw1Xq
         OFXEUvyMzxqQAo+gu6wspanpN3IvvLsBFsJ0P66o33eRMrwHdIJymRptBW0wtosdeltT
         5DHL62wG0WapZJSDmMg5QmSR4OjC8G5P+lgwzGNdPQ1pSRiHkZIpkQpyh/efcOdoBtPo
         LUt27JHdsoz7u89Bc1xfFePssd3uAjo/tRNuWgh0JnENJOisF5hhsE7Ak61lV0G8nMw2
         q7XogVcGmPM4Ctr+V1601tFbJhzHF8UNcN8do8WT6MQ9ng6iW6U9LS4XwhNJwrAo8QSz
         hBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706031724; x=1706636524;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Fi9SUnw+P6s+wHqDKKJH/WGmg+iG7l0IoyH1Ule5sg=;
        b=jF/u1h4jJJaA2KbUGd3FYm+YeD5EX5apC3O8oHYdjgfQnuRJF0Y41vkLBXFRmZpQsZ
         u8OH+uFRf+baNCQYRwlrrheENITJFJgCuiOr96z3HGef6bHPk8jZHspytNtV57qKYHbx
         wVT2HBKEA07RrpHp6gRNqnuWhoOw4IWkasxjeiPN8WZWJp5F6AQl+TlqA0gVJo1kuIZo
         k72Uk0PgRkoNjam8ftgp4N2JQwMJvN48/DCxZGxUSckYbj+TDTlgJxzrVqfkQF6DFskv
         5sEkVrmUb3i1ddDonVbxCeBQv0IYizM6d/+XNoF0zk74m/KLbL7ahikNcOcKKzuJhAuZ
         5wRw==
X-Gm-Message-State: AOJu0Yxu5Y+3tst/6SEYTe3xoczf4d0mogVLucHTa8YYChwv2GBCYbnD
	BRW7MH7SDEVvD3eCbd+/SJFxDolkAkccZyaIeiFRIOcMXQ9jdZW/6hVq/IvmOVdTi0+A2Cq/saD
	otA==
X-Google-Smtp-Source: AGHT+IF99i3Vp+jK+XxVAlQ/wOhh1+7K9HE/jba2rWuYkR5fEmMhEmHGKxwqIjfSSpXTm2DIBWOapw==
X-Received: by 2002:a05:600c:4ec8:b0:40e:bed4:4d05 with SMTP id g8-20020a05600c4ec800b0040ebed44d05mr361331wmq.353.1706031724373;
        Tue, 23 Jan 2024 09:42:04 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b0040e96a98762sm17386263wmb.17.2024.01.23.09.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 09:42:03 -0800 (PST)
Date: Tue, 23 Jan 2024 17:41:59 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Update the kbuf for previous read in
 trace_mmap_load_subbuf()
Message-ID: <Za_6Z1uK-KHkU2UV@google.com>
References: <20240123123337.1f785f98@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123123337.1f785f98@gandalf.local.home>

On Tue, Jan 23, 2024 at 12:33:37PM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The trace_mmap() checks if the mmapped data has any previously read data
> (the reader.read value of the meta page is non-zero), then it will pre-read
> the kbuf to move its internal reader pointer to the same value.
> 
> But when tracefs_cpu_read_buf() calls trace_mmap_load_subbuf(), its
> kbuf->subbuffer will not be the same as the mapped data and
> kbuffer_load_subbuffer() is called on it and it is returned. But that means
> its read pointer has not been updated, and the read data will restart again.
> 
> When the kbuf is updated in trace_mmap_load_subbuf() check the tmap->kbuf to
> see if it already read any of the data, and move the kbuffer forward just
> like the trace_mmap() does.
> 
> Link: https://lore.kernel.org/linux-trace-devel/Za-Md51snPcIoYFn@google.com/
> 
> Fixes: 2ed14b59 ("libtracefs: Add ring buffer memory mapping APIs")
> Reported-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

That fixes fast-forward, event already read are now skipped.

> ---
>  src/tracefs-mmap.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
> index d3af453..a288677 100644
> --- a/src/tracefs-mmap.c
> +++ b/src/tracefs-mmap.c
> @@ -165,6 +165,12 @@ __hidden int trace_mmap_load_subbuf(void *mapping, struct kbuffer *kbuf)
>  	 */
>  	if (data != kbuffer_subbuffer(kbuf)) {
>  		kbuffer_load_subbuffer(kbuf, data);
> +		/* Move the read pointer forward if need be */
> +		if (kbuffer_curr_index(tmap->kbuf)) {
> +			int size = kbuffer_curr_offset(tmap->kbuf);
> +			char tmpbuf[size];
> +			kbuffer_read_buffer(kbuf, tmpbuf, size);
> +		}
>  		return 1;
>  	}
>  
> -- 
> 2.43.0
> 
