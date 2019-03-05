Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E97C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 17:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2224C20842
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 17:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfCERHr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 12:07:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbfCERHr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 12:07:47 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0C1320652;
        Tue,  5 Mar 2019 17:07:46 +0000 (UTC)
Date:   Tue, 5 Mar 2019 12:07:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark: Fix a memory leak in the sched_events
 plugin
Message-ID: <20190305120745.3e7a8091@gandalf.local.home>
In-Reply-To: <20190305143924.11056-3-ykaradzhov@vmware.com>
References: <20190305143924.11056-1-ykaradzhov@vmware.com>
        <20190305143924.11056-3-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  5 Mar 2019 16:39:23 +0200
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> When the sched_events plugin fails to initialize not all the
> memory allocated for the context of the plugin is freed properly.
> The problem gets fixed by using the free_context helper function
> defined in the previous patch.
> 
> Fixes: 4f392730e ("kernel-shark-qt: Make Sched event plugin use ...")

I took the patch, but don't truncate the fixes line. It's fine to go
over 80 characters:

Fixes: 4f392730e ("kernel-shark-qt: Make Sched event plugin use its own data collections")

-- Steve

> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/plugins/sched_events.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
> index 0d6de2d..fe13e6a 100644
> --- a/kernel-shark/src/plugins/sched_events.c
> +++ b/kernel-shark/src/plugins/sched_events.c
> @@ -74,8 +74,12 @@ static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
>  
>  	event = tep_find_event_by_name(plugin_ctx->pevent,
>  				       "sched", "sched_switch");
> -	if (!event)
> +	if (!event) {
> +		plugin_free_context(plugin_ctx);
> +		plugin_sched_context_handler = NULL;
> +
>  		return false;
> +	}
>  
>  	plugin_ctx->sched_switch_event = event;
>  	plugin_ctx->sched_switch_next_field =
> @@ -320,11 +324,8 @@ static int plugin_sched_init(struct kshark_context *kshark_ctx)
>  {
>  	struct plugin_sched_context *plugin_ctx;
>  
> -	if (!plugin_sched_init_context(kshark_ctx)) {
> -		free(plugin_sched_context_handler);
> -		plugin_sched_context_handler = NULL;
> +	if (!plugin_sched_init_context(kshark_ctx))
>  		return 0;
> -	}
>  
>  	plugin_ctx = plugin_sched_context_handler;
>  

