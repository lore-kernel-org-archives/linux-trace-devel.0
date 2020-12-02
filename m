Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B27C6369E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 23:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CFA6221F7
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 23:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgLBXFD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 18:05:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:40228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbgLBXFD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 18:05:03 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3AC4221F7;
        Wed,  2 Dec 2020 23:04:22 +0000 (UTC)
Date:   Wed, 2 Dec 2020 18:04:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v25 06/16] trace-cmd: Add role parameter to timestamp
 synchronization plugins
Message-ID: <20201202180420.044e5e39@gandalf.local.home>
In-Reply-To: <20201029111816.247241-7-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
        <20201029111816.247241-7-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Oct 2020 13:18:06 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Defined HOST and GUEST roles in timestamp synchronization context.
> Some timestamp synchronization plugins may not support running in both
> host and guest roles. This could happen in nested virtualization use
> case, where the same plugin can be used as a host and as a guest.
> Added logic to timestamp synchronization plugins to declare what roles
> they support. Added logic to select plugin depending on supported roles
> and currently requested role.
> 
> clocks. Added logic to timestamp synchronization plugins to declare what
> ftace clocks they support. Added logic to select plugin depending on the
> ftrace clock used in the current trace session and supported clocks.

 Extra paragraph?

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h             | 10 ++++++++--
>  lib/trace-cmd/include/trace-tsync-local.h |  2 +-
>  lib/trace-cmd/trace-timesync.c            | 17 ++++++++++++++---
>  tracecmd/trace-record.c                   |  3 ++-
>  tracecmd/trace-tsync.c                    |  3 ++-
>  5 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 21028940..1ca2da10 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -437,6 +437,11 @@ enum{
>  	TRACECMD_TIME_SYNC_CMD_STOP	= 2,
>  };
>  
> +enum tracecmd_time_sync_role {
> +	TRACECMD_TIME_SYNC_ROLE_HOST	= 0x01,
> +	TRACECMD_TIME_SYNC_ROLE_GUEST	= 0x02

If this is going to be used as a bitmask, it's best to demonstrate that
with:

	(1 << 0),
	(1 << 1)

-- Steve


> +};
> +
>  struct tracecmd_time_sync {
>  	char				*proto_name;
>  	int				loop_interval;
