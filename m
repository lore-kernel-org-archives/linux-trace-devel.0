Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A149FC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 17:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FC2D20842
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 17:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfCERJT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 12:09:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbfCERJT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 12:09:19 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38E2120652;
        Tue,  5 Mar 2019 17:09:18 +0000 (UTC)
Date:   Tue, 5 Mar 2019 12:09:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, Phil Auld <pauld@redhat.com>
Subject: Re: [PATCH 3/3] kernel-shark: sched_events plugin init with
 sched_switch events only
Message-ID: <20190305120916.5fb5c180@gandalf.local.home>
In-Reply-To: <20190305143924.11056-4-ykaradzhov@vmware.com>
References: <20190305143924.11056-1-ykaradzhov@vmware.com>
        <20190305143924.11056-4-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  5 Mar 2019 16:39:24 +0200
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> The sched_events plugin should not be totally disabled when the
> wakeup events are missing. The initialization of the plugin must
> fail only if the trace.dat file contains no sched_switch events.
> 

I added:

Reported-by: Phil Auld <pauld@redhat.com>

-- Steve

> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/plugins/sched_events.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
> index fe13e6a..c52fb29 100644
> --- a/kernel-shark/src/plugins/sched_events.c
> +++ b/kernel-shark/src/plugins/sched_events.c
> @@ -104,9 +104,6 @@ static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
>  					   &plugin_ctx->sched_waking_event,
>  					   &plugin_ctx->sched_waking_pid_field);
>  
> -	if (!wakeup_found)
> -		return false;
> -
>  	plugin_ctx->second_pass_hash = tracecmd_filter_id_hash_alloc();
>  
>  	return true;

