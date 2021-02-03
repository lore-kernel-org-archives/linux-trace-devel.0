Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C354CC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Feb 2021 20:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 780F664F4D
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Feb 2021 20:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhBCUU6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 15:20:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhBCUU4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 15:20:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8768964F4D;
        Wed,  3 Feb 2021 20:20:15 +0000 (UTC)
Date:   Wed, 3 Feb 2021 15:20:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v27 1/5] trace-cmd: Add timestamp synchronization per
 vCPU
Message-ID: <20210203152013.21560b32@gandalf.local.home>
In-Reply-To: <20210201160339.506562-2-tz.stoyanov@gmail.com>
References: <20210201160339.506562-1-tz.stoyanov@gmail.com>
        <20210201160339.506562-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  1 Feb 2021 18:03:35 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> --- a/lib/trace-cmd/trace-timesync.c
> +++ b/lib/trace-cmd/trace-timesync.c
> @@ -22,6 +22,8 @@
>  #include "event-utils.h"
>  #include "trace-tsync-local.h"
>  
> +typedef __be16 be16;

I'm curious to why you added this, because I have a machine that doesn't
define __be16. I'm guessing it comes from "#include <linux/limits.h>", was
there a reason to use that?

I really don't see the difference between __be16 and unsigned short. I
think it's mostly used for static parsers. Perhaps its best to use __u16,
or "unsigned short" to make sure it compiles on older systems.

-- Steve


> +
>  struct tsync_proto {
>  	struct tsync_proto *next;
>  	char proto_name[TRACECMD_TSYNC_PNAME_LENGTH];
> @@ -34,9 +36,13 @@ struct tsync_proto {
>  	int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
>  	int (*clock_sync_calc)(struct tracecmd_time_sync *clock_context,
>  			       long long *offset, long long *scaling,
> -			       long long *timestamp);
> +			       long long *timestamp, unsigned int cpu);
>  };
>  
> +struct tsync_probe_request_msg {
> +	be16	cpu;
> +} __packed;

