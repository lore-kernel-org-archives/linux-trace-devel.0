Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D65C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 18:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2610360F4C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 18:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhHSSCK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 14:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhHSSCE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 14:02:04 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C1306044F;
        Thu, 19 Aug 2021 18:01:27 +0000 (UTC)
Date:   Thu, 19 Aug 2021 14:01:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 37/87] trace-cmd library: Set log size to the input
 tep handler when it is read from the file
Message-ID: <20210819140121.6b9bdfc8@oasis.local.home>
In-Reply-To: <20210729050959.12263-38-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-38-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:09:09 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Setting the long size to the input tep handler in tracecmd_read_headers()
> API may be too late, as this tep handler is used to read and parse data
> from the file before that. The most suitable place for that is
> tracecmd_alloc_fd() API, right after reading the long size from the
> file.
> 

Typo in subject. I was expecting to see some log size get set ;-)

-- Steve

> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index bf56c92a..0ced15a8 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -976,8 +976,6 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
>  	if (ret < 0)
>  		return -1;
>  
> -	tep_set_long_size(handle->pevent, handle->long_size);
> -
>  	if (state <= handle->file_state)
>  		return 0;
>  
> @@ -3473,6 +3471,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
>  
>  	do_read_check(handle, buf, 1);
>  	handle->long_size = buf[0];
> +	tep_set_long_size(handle->pevent, handle->long_size);
>  
>  	read4(handle, &page_size);
>  	handle->page_size = page_size;

