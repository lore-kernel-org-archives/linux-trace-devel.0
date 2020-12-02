Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE5D5C64E7C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 23:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BD8F22206
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 23:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgLBXIC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 18:08:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgLBXH6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 18:07:58 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80AB9221FD;
        Wed,  2 Dec 2020 23:07:17 +0000 (UTC)
Date:   Wed, 2 Dec 2020 18:07:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v25 07/16] trace-cmd: Add host / guest role in timestamp
 synchronization context
Message-ID: <20201202180715.0afcf626@gandalf.local.home>
In-Reply-To: <20201029111816.247241-8-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
        <20201029111816.247241-8-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Oct 2020 13:18:07 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> @@ -298,8 +298,11 @@ static int clock_context_init(struct tracecmd_time_sync *tsync, bool server)
>  	clock = calloc(1, sizeof(struct clock_sync_context));
>  	if (!clock)
>  		return -1;
> -
> -	clock->is_server = server;
> +	clock->is_guest = guest;
> +	if (clock->is_guest)
> +		clock->is_server = true;
> +	else
> +		clock->is_server = false;

Wait? You want them to equal?

Then you should have:

	clock->is_server = guest;

If you want them opposite:

	clock->is_server = !guest;

-- Steve

>  	if (get_vsocket_params(tsync->msg_handle->fd, &clock->local_cid,
>  			       &clock->local_port, &clock->remote_cid,
>  			       &clock->remote_port))
