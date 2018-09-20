Return-Path: <SRS0=7BWw=MC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:50852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbeIUDva (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Sep 2018 23:51:30 -0400
Date: Thu, 20 Sep 2018 18:05:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 5/8] kernel-shark-qt: Remove the TODO action in
 kshark_read_at()
Message-ID: <20180920180550.15fb7e1d@gandalf.local.home>
In-Reply-To: <20180920165544.17579-6-y.karadz@gmail.com>
References: <20180920165544.17579-1-y.karadz@gmail.com>
        <20180920165544.17579-6-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 20 Sep 2018 19:55:41 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The TODO message states that we have to understand why racecmd_read_at()
> is not thread-safe and see if this can be fixed. We now know why and we
> know that this cannot be fixed.

I wouldn't say that it can not be fixed, but that it's hard to fix.

I'll update the change log.

Thanks!

-- Steve

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark-qt/src/libkshark.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
> index 3635b48..506511d 100644
> --- a/kernel-shark-qt/src/libkshark.c
> +++ b/kernel-shark-qt/src/libkshark.c
> @@ -842,9 +842,8 @@ struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
>  				  uint64_t offset)
>  {
>  	/*
> -	 * It turns that tracecmd_read_at() is not thread-safe.
> -	 * TODO: Understand why and see if this can be fixed.
> -	 * For the time being use a mutex to protect the access.
> +	 * Calling tracecmd_read_at() is not thread-safe. Use a mutex to
> +	 * protect the access.
>  	 */
>  	pthread_mutex_lock(&kshark_ctx->input_mutex);
>  
