Return-Path: <SRS0=uJAW=VG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF36C73C53
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89CB1214AF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfGIPjB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbfGIPjB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 11:39:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 753DC214AF;
        Tue,  9 Jul 2019 15:38:59 +0000 (UTC)
Date:   Tue, 9 Jul 2019 11:38:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Clean up python plugin warnings
Message-ID: <20190709113858.0922121a@gandalf.local.home>
In-Reply-To: <20190709142600.13348-1-tz.stoyanov@gmail.com>
References: <20190709142600.13348-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  9 Jul 2019 17:26:00 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

Hi Tzvetomir,

This should be broken up into two patches.

1) remove the tracecmd_enable_events(), and the subject should be:
   trace-cmd: Remove tracecmd_enable_events() function
   And the change log can talk about the python warning and also that
   nothing happens to use it.

2) trace-cmd: Move trace-output.c into the library code
   And the change log should state that trace-ouput.c contains code
   that can be used outside of trace-cmd, and should be part of the
   library. It can also mention that a warning is caused by loading
   python modules inside kernelshark because that depends on the
   library code.

Thanks!

-- Steve


> All trace-cmd APIs (functions, declared in trace-cmd.h) are exposed
> automatically at build time as python bindings, using trace-cmd python
> plugin. Implementation of those functions is supposed to be in libtracecmd
> library. Not all functions, declared in trace-cmd.h are APIs, some of them
> are internal and should not be exposed:
>  tracecmd_enable_events() is removed from trace-cmd.h, as it heavily depends on
>   trace-cmd internals. It is no more exposed as python binding.
> Others are implemented in trace-cmd application and cannot be used outside it:
>  trace-output.c file is moved from trace-cmd to libtracecmd. All functions
>   implemented there are now part of the library.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h              |  1 -
>  lib/trace-cmd/Makefile                     | 11 ++++++++++-
>  {tracecmd => lib/trace-cmd}/trace-output.c |  0
>  tracecmd/Makefile                          |  1 -
>  4 files changed, 10 insertions(+), 3 deletions(-)
>  rename {tracecmd => lib/trace-cmd}/trace-output.c (100%)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 6f62ab9..1f2f5bf 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -292,7 +292,6 @@ void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
>  long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
>  void tracecmd_filter_pid(int pid, int exclude);
>  int tracecmd_add_event(const char *event_str, int stack);
> -void tracecmd_enable_events(void);
>  void tracecmd_disable_all_tracing(int disable_tracer);
>  void tracecmd_disable_tracing(void);
>  void tracecmd_enable_tracing(void);
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

