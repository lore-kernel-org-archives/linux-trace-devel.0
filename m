Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E40C6369E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC980221F7
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387514AbgLBWsu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 17:48:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387506AbgLBWsu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 17:48:50 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5480E208FE;
        Wed,  2 Dec 2020 22:48:09 +0000 (UTC)
Date:   Wed, 2 Dec 2020 17:48:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v25 05/16] trace-cmd: Add clock parameter to timestamp
 synchronization plugins
Message-ID: <20201202174807.1f442e0c@gandalf.local.home>
In-Reply-To: <20201029111816.247241-6-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
        <20201029111816.247241-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Oct 2020 13:18:05 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Some timestamp synchronization plugins may not support all ftrace
> clocks. Added logic to timestamp synchronization plugins to declare what
> ftace clocks they support. Added logic to select plugin depending on the

 "ftrace clocks"

> ftrace clock used in the current trace session and supported clocks.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h             |  4 ++--
>  lib/trace-cmd/include/trace-tsync-local.h |  1 +
>  lib/trace-cmd/trace-timesync.c            | 29 +++++++++++++++++++----
>  tracecmd/trace-record.c                   | 10 +++++++-
>  tracecmd/trace-tsync.c                    |  2 +-
>  5 files changed, 38 insertions(+), 8 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index b48381cd..21028940 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -448,8 +448,8 @@ struct tracecmd_time_sync {
>  };
>  
>  void tracecmd_tsync_init(void);
> -int tracecmd_tsync_proto_getall(char ***protos);
> -char *tracecmd_tsync_proto_select(char **protos);
> +int tracecmd_tsync_proto_getall(char ***protos, const char *clock);
> +char *tracecmd_tsync_proto_select(char **protos, char *clock);
>  bool tsync_proto_is_supported(char *proto_name);
>  void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
>  void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
> diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
> index 1f3bc443..25d5b4e8 100644
> --- a/lib/trace-cmd/include/trace-tsync-local.h
> +++ b/lib/trace-cmd/include/trace-tsync-local.h
> @@ -27,6 +27,7 @@ struct clock_sync_context {
>  };
>  
>  int tracecmd_tsync_proto_register(char *proto_name, int accuracy,
> +				  int supported_clocks,

Is this a bitmask? How is this used?

-- Steve

>  				  int (*init)(struct tracecmd_time_sync *),
>  				  int (*free)(struct tracecmd_time_sync *),
>  				  int (*calc)(struct tracecmd_time_sync *,
> diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
