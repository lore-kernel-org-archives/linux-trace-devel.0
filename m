Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA478C3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 20:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C281022CED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 20:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfH1UVn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 16:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbfH1UVn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 16:21:43 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14BF3217F5;
        Wed, 28 Aug 2019 20:21:42 +0000 (UTC)
Date:   Wed, 28 Aug 2019 16:21:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] trace-cmd: Move tracecmd_stack_tracer_status()
 function to libtracecmd
Message-ID: <20190828162140.38dd0880@gandalf.local.home>
In-Reply-To: <20190814084712.28188-9-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
        <20190814084712.28188-9-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 14 Aug 2019 11:47:08 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> tracecmd_stack_tracer_status() function reads the stack tracer status
> from the proc file system. It does not depend on trace-cmd context and
> can be used standalone. The function is moved from trace-cmd application
> into libtracecmd.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-util.c | 49 +++++++++++++++++++++++++++++++++
>  tracecmd/trace-stack.c     | 56 ++------------------------------------
>  2 files changed, 51 insertions(+), 54 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index 8c1a0a0..d16a018 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -25,6 +25,7 @@
>  #define LOCAL_PLUGIN_DIR ".trace-cmd/plugins"
>  #define TRACEFS_PATH "/sys/kernel/tracing"
>  #define DEBUGFS_PATH "/sys/kernel/debug"
> +#define PROC_STACK_FILE "/proc/sys/kernel/stack_tracer_enabled"
>  
>  int tracecmd_disable_sys_plugins;
>  int tracecmd_disable_plugins;
> @@ -1787,3 +1788,51 @@ int trace_set_log_file(char *logfile)
>  	return 0;
>  }
>  
> +/**
> + * tracecmd_stack_tracer_status - Check stack trace status
> + * @status: Returned stack trace status:
> + *		0 - not configured, disabled
> + *		non 0 - enabled
> + *
> + * Returns -1 in case of an error, 0 if file does not exist
> + *  (stack tracer not enabled) or 1 on successful completion.

  "(stack tracer not configured in kernel)"

Saying "enabled" is ambiguous.

> + */
> +int tracecmd_stack_tracer_status(int *status)

If we are making this a library function, shouldn't it be declared in
the trace-cmd.h file?

-- Steve
