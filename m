Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEA728EA54
	for <linux-trace-devel@vger.kernel.org>; Thu,  3 Apr 2025 19:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707579; cv=none; b=qJcJ6dmQKtq+OS7/qBEemAsc6LuJYw1S1pOZEGY5BLqrNUcgM0Hqe6YeJwGDiZ+7ZG82PWsHPVMDn0wBPhUJYcSmdKWA7dKhFiBuqQ3rapKF1YgGk4eQJsoheOSX9+CQm3QUUMMv5B00G+E8X1DnWZRImkp+JdsqTlApZhARwTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707579; c=relaxed/simple;
	bh=PSAnpAhDnHVwXatTD7VqzOLPOFjbiTQRvhG0/WryV4I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ADxV/2sODMwuiCw3mibG3i9GeBK2gfNCCqydM2cE75Sh4HRF6iHIXl0FIOpVLotqYbJdWosEaY4M4pObeIeZ/NsJevW5dtl0D60VAcfI5drEH9yjMyq3JemqAPDYTiYEi7Nm1Yf84lSNqK9NlyT6CgxWe933eQnvLjWtM1CG+1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECDBC4CEE3;
	Thu,  3 Apr 2025 19:12:58 +0000 (UTC)
Date: Thu, 3 Apr 2025 15:14:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Kutzer, Philipp" <philipp.kutzer@siemens-healthineers.com>
Cc: "linux-trace-devel@vger.kernel.org" <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtrace: Fix memory leak in tracefs_cpu
Message-ID: <20250403151404.0ab1b9df@gandalf.local.home>
In-Reply-To: <AM9PR05MB77778BE58632548B4D3EEBECB5DF2@AM9PR05MB7777.eurprd05.prod.outlook.com>
References: <AM9PR05MB77778BE58632548B4D3EEBECB5DF2@AM9PR05MB7777.eurprd05.prod.outlook.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 17 Mar 2025 11:24:36 +0000
"Kutzer, Philipp" <philipp.kutzer@siemens-healthineers.com> wrote:

> From: Philipp Kutzer <philipp.kutzer@siemens-healthineers.com>
> 
> Hi,
> 
> with the introduction of the interface to allow the tracefs_cpu to handle buffer allocation on their
>  own a memory leak was built in. 
> (Commit 1e1cc549d7e7fa408081e03e4effd3591a131ae5 - libtracefs: Add API to read tracefs_cpu 
> and return a kbuffer)
> 
> We cyclically call the tracefs_iterate_raw_events function from one of our applications and 
> noticed that our application was increasingly allocating memory. 
> 
> With the help of Address Sanitizer the root cause, allocating but not freeing memory 
> for "tcpu->buffer" was found. The fix will free memory during close and cleanup function 
> and has been successfully tested in our environment. The original problem (memory leak) 
> has been resolved.

Note, I cleaned up the change log:

    libtrace: Fix memory leak in tracefs_cpu
    
    The introduction of the interface to allow the tracefs_cpu to handle buffer
    allocation on their own caused a memory leak.  (Commit 1e1cc549d7
    ("libtracefs: Add API to read tracefs_cpu and return a kbuffer")).
    
    The help of Address Sanitizer found the root cause. The "tcpu->buffer" was
    being allocated but not freed. The fix will free memory during close and
    cleanup functions.


> 
> Signed-off-by: Philipp Kutzer mailto:philipp.kutzer@siemens-healthineers.com

Also, this should be:

 Signed-off-by: Philipp Kutzer <philipp.kutzer@siemens-healthineers.com>

> ---
> 
> diff --git a/src/tracefs-record.c b/src/tracefs-record.c
> index a2dcfc2..4cd0917 100644
> --- a/src/tracefs-record.c
> +++ b/src/tracefs-record.c
> @@ -293,6 +293,8 @@ void tracefs_cpu_close(struct tracefs_cpu *tcpu)
>         if (!tcpu)
>                 return;
> 
> +       free(tcpu->buffer);
> +       tcpu->buffer = NULL;
>         close(tcpu->fd);
>         tracefs_cpu_free_fd(tcpu);
> }

This also had whitespace issues.

I fixed it up and applied it.

Thanks,

-- Steve
