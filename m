Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919F0C00144
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Jul 2022 20:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiG2Uu5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 16:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiG2Uu4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 16:50:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBCF1AF0D
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 13:50:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC1E36200D
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Jul 2022 20:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3584EC433D6;
        Fri, 29 Jul 2022 20:50:55 +0000 (UTC)
Date:   Fri, 29 Jul 2022 16:50:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     aahringo@redhat.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Do not use instance from trace context
Message-ID: <20220729165048.77f03fc7@rorschach.local.home>
In-Reply-To: <20220729040116.175015-1-tz.stoyanov@gmail.com>
References: <20220729040116.175015-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 29 Jul 2022 07:01:16 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When trace-cmd initiates a connection to a trace agent over the network,
> the logic in connect_to_agent() function incorrectly uses the last
> instance saved in the trace context, instead of the actual instance
> which is passed as input argument. This works if the remote agent is
> set last on the command line, but causes a problem if there is more than
> one agent or if there is a local buffer after the agent on the command
> line.
> 
> Reported-by: Alexander Aring <aahringo@redhat.com>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-record.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 2406489a..50039dad 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3934,15 +3934,15 @@ static void connect_to_agent(struct common_record_context *ctx,
>  		use_fifos = nr_fifos > 0;
>  	}
>  
> -	if (ctx->instance->result) {
> +	if (instance->result) {

Bah, I kept getting confused by when to use instance vs ctx->instance,
and I guess I messed this one up.

Thanks Tzvetomir on fixing it.

-- Steve


>  		role = TRACECMD_TIME_SYNC_ROLE_CLIENT;
> -		sd = connect_addr(ctx->instance->result);
> +		sd = connect_addr(instance->result);
>  		if (sd < 0)
>  			die("Failed to connect to host %s:%u",
>  			    instance->name, instance->port);
>  	} else {
>  		/* If connecting to a proxy, then this is the guest */
> -		if (is_proxy(ctx->instance))
> +		if (is_proxy(instance))
>  			role = TRACECMD_TIME_SYNC_ROLE_GUEST;
>  		else
>  			role = TRACECMD_TIME_SYNC_ROLE_HOST;

