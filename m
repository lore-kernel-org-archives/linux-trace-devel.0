Return-Path: <SRS0=sU+T=WE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3CAC0650F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 23:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25CD72173E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 23:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732938AbfHHXh6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 19:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbfHHXh6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 19:37:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 650B02171F;
        Thu,  8 Aug 2019 23:37:57 +0000 (UTC)
Date:   Thu, 8 Aug 2019 19:37:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/7] trace-cmd: Move trace-output.c into the library
 code
Message-ID: <20190808193755.346da18f@gandalf.local.home>
In-Reply-To: <20190711130307.25041-2-tz.stoyanov@gmail.com>
References: <20190711130307.25041-1-tz.stoyanov@gmail.com>
        <20190711130307.25041-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Jul 2019 16:03:01 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Functions, implemented in trace-output.c file, do not depend on
> trace-cmd application context and can be used standalone. The file
> is moved from trace-cmd to libtracecmd. It also fixes a warning
> while loading python modules from kernelshark:
> ImportError: ctracecmd.so: undefined symbol: tracecmd_append_cpu_data
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/Makefile                     | 11 ++++++++++-
>  {tracecmd => lib/trace-cmd}/trace-output.c |  0
>  tracecmd/Makefile                          |  1 -
>  3 files changed, 10 insertions(+), 2 deletions(-)
>  rename {tracecmd => lib/trace-cmd}/trace-output.c (100%)
> 
> diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
> index 44c1332..9086eb6 100644
> --- a/lib/trace-cmd/Makefile
> +++ b/lib/trace-cmd/Makefile
> @@ -4,12 +4,15 @@ include $(src)/scripts/utils.mk
>  
>  bdir:=$(obj)/lib/trace-cmd
>  
> -DEFAULT_TARGET = $(bdir)/libtracecmd.a
> +TC_VERSION := $(bdir)/include/tc_version.h
> +
> +DEFAULT_TARGET = $(bdir)/libtracecmd.a $(TC_VERSION)
>  
>  OBJS =
>  OBJS += trace-hash.o
>  OBJS += trace-hooks.o
>  OBJS += trace-input.o
> +OBJS += trace-output.o
>  OBJS += trace-recorder.o
>  OBJS += trace-util.o
>  OBJS += trace-filter-hash.o
> @@ -29,6 +32,9 @@ $(bdir):
>  $(OBJS): | $(bdir)
>  $(DEPS): | $(bdir)
>  
> +$(TC_VERSION): force | $(bdir)/include
> +	$(Q)$(call update_version.h)
> +

Hi Ceco,

Why the addition of TC_VERISON here? It's not stated in the change log
to why this was copied over. I ever removed all references from
TC_VERSION and it still builds fine.

-- Steve


>  $(bdir)/libtracecmd.a: $(OBJS)
>  	$(Q)$(call do_build_static_lib)
>  
> @@ -43,6 +49,8 @@ $(bdir)/trace-util.o: $(obj)/plugins/trace_plugin_dir
>  $(DEPS): $(bdir)/.%.d: %.c
>  	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
>  
> +$(DEPS): $(TC_VERSION)
> +
>  $(OBJS): $(bdir)/%.o : $(bdir)/.%.d
>  
>  dep_includes := $(wildcard $(DEPS))
> @@ -54,4 +62,5 @@ endif
>  clean:
>  	$(RM) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d
>  
> +force:
>  .PHONY: clean
> diff --git a/tracecmd/trace-output.c b/lib/trace-cmd/trace-output.c
> similarity index 100%
> rename from tracecmd/trace-output.c
> rename to lib/trace-cmd/trace-output.c
> diff --git a/tracecmd/Makefile b/tracecmd/Makefile
> index bcd437a..6968f83 100644
> --- a/tracecmd/Makefile
> +++ b/tracecmd/Makefile
> @@ -29,7 +29,6 @@ TRACE_CMD_OBJS += trace-restore.o
>  TRACE_CMD_OBJS += trace-check-events.o
>  TRACE_CMD_OBJS += trace-show.o
>  TRACE_CMD_OBJS += trace-list.o
> -TRACE_CMD_OBJS += trace-output.o
>  TRACE_CMD_OBJS += trace-usage.o
>  TRACE_CMD_OBJS += trace-msg.o
>  

