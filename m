Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD32C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 21:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E34761076
	for <linux-trace-devel@archiver.kernel.org>; Wed, 31 Mar 2021 21:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhCaVsd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 17:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhCaVs3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 17:48:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9A61601FC
        for <linux-trace-devel@vger.kernel.org>; Wed, 31 Mar 2021 21:48:28 +0000 (UTC)
Date:   Wed, 31 Mar 2021 17:48:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd: Fix double free in tsync_agent_thread()
Message-ID: <20210331174826.346a7077@gandalf.local.home>
In-Reply-To: <20210331170503.3a9934f5@gandalf.local.home>
References: <20210331170503.3a9934f5@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 31 Mar 2021 17:05:03 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> tracecmd_tsync_free() already frees the tsync, remove the free of it after
> that is called.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  lib/trace-cmd/trace-timesync.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
> index e860c335..ad73f08f 100644
> --- a/lib/trace-cmd/trace-timesync.c
> +++ b/lib/trace-cmd/trace-timesync.c
> @@ -887,7 +887,6 @@ static void *tsync_agent_thread(void *data)
>  out:
>  	tracecmd_msg_handle_close(tsync->msg_handle);
>  	tracecmd_tsync_free(tsync);
> -	free(tsync);
>  	close(sd);
>  

Debugging this more, this entire ending is wrong. New patch coming.

-- Steve

>  	pthread_exit(0);

