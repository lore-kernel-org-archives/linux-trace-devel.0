Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD2080056
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 18:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706033102; cv=none; b=uzq9fyLCIpAkbS7qxg+3462u2l4p8f+UipHs5cWougDi1dNe7LhXjNjupKgFTCMwHdR1M5WXoUjM9l5Xjd33DCdgPEGUIR0+I6k2kcKFJ/wctHfR6Qsst1M2B+hedb66bI+OdxpNoijgMSwquw4LYutqs/GwHVWvMH5sJURymD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706033102; c=relaxed/simple;
	bh=oMu64SNvqUIcpfbcgibXlJ/Y9p2FjHY4Cn8SLtaKMIA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VWpQFRTrOI0CD1z7R2bXXdMos5YRcq3xSn5k4wMdRuyPHVTsbDKbGg8V/IP3gB3XqSGt72r7c/isj8GNNbGjDrpmh404i33TqN8OBE5LhTS070kIsHygjR60WBSl/fYbmH6OSgRpXzeCqaRZ9y1ImigGnlYKfr4p48WJgg/cv/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8919C433C7;
	Tue, 23 Jan 2024 18:05:01 +0000 (UTC)
Date: Tue, 23 Jan 2024 13:06:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Update trace_buffer_meta
Message-ID: <20240123130632.340a9c06@gandalf.local.home>
In-Reply-To: <20240123111242.3665230-1-vdonnefort@google.com>
References: <20240123111242.3665230-1-vdonnefort@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Jan 2024 11:12:42 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> The current version for struct trace_buffer_meta is taken from a work in
> progress Linux patch series. Update it.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/src/tracefs-mmap.c b/src/tracefs-mmap.c
> index 499233a..d3af453 100644
> --- a/src/tracefs-mmap.c
> +++ b/src/tracefs-mmap.c
> @@ -10,25 +10,24 @@
>  #include "tracefs-local.h"
>  
>  struct trace_buffer_meta {
> -	unsigned long	entries;
> -	unsigned long	overrun;
> -	unsigned long	read;
> +	__u32		meta_page_size;
> +	__u32		meta_struct_len;
>  
> -	unsigned long	subbufs_touched;
> -	unsigned long	subbufs_lost;
> -	unsigned long	subbufs_read;
> +	__u32		subbuf_size;
> +	__u32		nr_subbufs;
>  
>  	struct {
> -		unsigned long	lost_events;	/* Events lost at the time of the reader swap */
> -		__u32		id;		/* Reader subbuf ID from 0 to nr_subbufs - 1 */
> -		__u32		read;		/* Number of bytes read on the reader subbuf */
> +		__u64	lost_events;
> +		__u32	id;
> +		__u32	read;
>  	} reader;
>  
> -	__u32		subbuf_size;		/* Size of each subbuf including the header */
> -	__u32		nr_subbufs;		/* Number of subbufs in the ring-buffer */
> +	__u64	entries;
> +	__u64	overrun;
> +	__u64	read;
>  
> -	__u32		meta_page_size;		/* Size of the meta-page */
> -	__u32		meta_struct_len;	/* Len of this struct */
> +	__u64	subbufs_touched;
> +	__u64	subbufs_lost;
>  };
>  
>  #define TRACE_MMAP_IOCTL_GET_READER		_IO('T', 0x1)
> 
> base-commit: 73ac9c192d058712993f9941927c924f2e206168

I'll hold off applying this until we have the kernel side locked down.
As I'm expecting there to be more versions of this patch.

Thanks,

-- Steve
