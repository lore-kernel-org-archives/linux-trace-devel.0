Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38121C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 18:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1629360EB5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 18:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbhHSSLo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 14:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232328AbhHSSLn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 14:11:43 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1B18604D7;
        Thu, 19 Aug 2021 18:11:06 +0000 (UTC)
Date:   Thu, 19 Aug 2021 14:11:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 44/87] trace-cmd library: Set input handler default
 values in allocation function
Message-ID: <20210819141100.7456592d@oasis.local.home>
In-Reply-To: <20210729050959.12263-45-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-45-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:09:16 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Set usecs flag by default when the input handler is allocated, it makes
> more sense than setting it when options are handeled. This clean up is
> needed for parsing version 7 trace files, where multiple options
> sections may exist.

Clean ups like this can also be moved to the front of the patch queue.

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 41f95874..23eea0d1 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -2794,8 +2794,6 @@ static int handle_options(struct tracecmd_input *handle)
>  	int cpus;
>  	int ret;
>  
> -	/* By default, use usecs, unless told otherwise */
> -	handle->flags |= TRACECMD_FL_IN_USECS;
>  	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
>  
>  	for (;;) {
> @@ -3448,6 +3446,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
>  	handle->fd = fd;
>  	handle->ref = 1;
>  
> +	/* By default, use usecs, unless told otherwise */
> +	handle->flags |= TRACECMD_FL_IN_USECS;
> +
>  	if (do_read_check(handle, buf, 3))
>  		goto failed_read;
>  

