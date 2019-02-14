Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDC2C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 20:41:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53AC52192D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 20:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439995AbfBNUlg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 15:41:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439994AbfBNUlg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 15:41:36 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C4AF218FF;
        Thu, 14 Feb 2019 20:41:35 +0000 (UTC)
Date:   Thu, 14 Feb 2019 15:41:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v6 07/11] trace-cmd: Add `trace-cmd setup-guest`
 command
Message-ID: <20190214154132.43082ece@gandalf.local.home>
In-Reply-To: <20190214141335.28144-8-kaslevs@vmware.com>
References: <20190214141335.28144-1-kaslevs@vmware.com>
        <20190214141335.28144-8-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 14 Feb 2019 16:13:31 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> Add `trace-cmd setup-guest` command that creates the necessary FIFOs for tracing
> a guest over FIFOs instead of vsockets.
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>  tracecmd/Makefile              |   1 +
>  tracecmd/include/trace-local.h |   6 ++
>  tracecmd/trace-cmd.c           |   1 +
>  tracecmd/trace-setup-guest.c   | 186 +++++++++++++++++++++++++++++++++
>  tracecmd/trace-usage.c         |   8 ++
>  5 files changed, 202 insertions(+)
>  create mode 100644 tracecmd/trace-setup-guest.c
> 
> diff --git a/tracecmd/Makefile b/tracecmd/Makefile
> index 865b1c6..d3e3080 100644
> --- a/tracecmd/Makefile
> +++ b/tracecmd/Makefile
> @@ -35,6 +35,7 @@ TRACE_CMD_OBJS += trace-msg.o
>  
>  ifeq ($(VSOCK_DEFINED), 1)
>  TRACE_CMD_OBJS += trace-agent.o
> +TRACE_CMD_OBJS += trace-setup-guest.o
>  endif
>  
>  ALL_OBJS := $(TRACE_CMD_OBJS:%.o=$(bdir)/%.o)
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index 823d323..b23130e 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -14,6 +14,10 @@
>  
>  #define TRACE_AGENT_DEFAULT_PORT	823
>  
> +#define GUEST_PIPE_NAME		"trace-pipe-cpu"
> +#define GUEST_DIR_FMT		"/var/lib/trace-cmd/virt/%s"
> +#define GUEST_FIFO_FMT		GUEST_DIR_FMT "/" GUEST_PIPE_NAME "%d"
> +
>  extern int debug;
>  extern int quiet;
>  
> @@ -68,6 +72,8 @@ void trace_listen(int argc, char **argv);
>  
>  void trace_agent(int argc, char **argv);
>  
> +void trace_setup_guest(int argc, char **argv);
> +
>  void trace_restore(int argc, char **argv);
>  
>  void trace_clear(int argc, char **argv);
> diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
> index 3ae5e2e..4da82b4 100644
> --- a/tracecmd/trace-cmd.c
> +++ b/tracecmd/trace-cmd.c
> @@ -85,6 +85,7 @@ struct command commands[] = {
>  	{"listen", trace_listen},
>  #ifdef VSOCK
>  	{"agent", trace_agent},
> +	{"setup-guest", trace_setup_guest},
>  #endif
>  	{"split", trace_split},
>  	{"restore", trace_restore},
> diff --git a/tracecmd/trace-setup-guest.c b/tracecmd/trace-setup-guest.c
> new file mode 100644
> index 0000000..875ac0e
> --- /dev/null
> +++ b/tracecmd/trace-setup-guest.c
> @@ -0,0 +1,186 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 VMware Inc, Slavomir Kaslev <kaslevs@vmware.com>
> + *
> + */
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <getopt.h>
> +#include <grp.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +
> +#include "trace-local.h"
> +#include "trace-msg.h"
> +
> +static int make_dir(const char *path, mode_t mode)
> +{
> +	char *buf, *end, *p;
> +	int ret = 0;
> +
> +	buf = strdup(path);
> +	end = buf + strlen(buf);
> +
> +	for (p = buf; p < end; p++) {
> +		for (; p < end && *p == '/'; p++);
> +		for (; p < end && *p != '/'; p++);

Why not:
	for (p = buf; p && *p; p++) {

		for (; *p == '/'; p++);
		p = index(p, '/');
		if (p)
			*p = '\0';
			

> +
> +		*p = '\0';
> +		ret = mkdir(buf, mode);
> +		if (ret < 0) {
> +			if (errno != EEXIST) {
> +				ret = -errno;
> +				break;
> +			}
> +			ret = 0;
> +		}

		if (p)
			*p = '/';

?

No need for "end".

-- Steve

> +		*p = '/';
> +	}
> +
> +	free(buf);
> +	return ret;
> +}
> +

