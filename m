Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF96C3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 20:17:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9360217F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 20:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbfH1URE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 16:17:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfH1URE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 16:17:04 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3485217F5;
        Wed, 28 Aug 2019 20:17:02 +0000 (UTC)
Date:   Wed, 28 Aug 2019 16:17:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 7/8] trace-cmd: Move trace-cmd APIs from trace-cmd.h
 to trace-local.h
Message-ID: <20190828161701.5218d449@gandalf.local.home>
In-Reply-To: <20190814084712.28188-8-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
        <20190814084712.28188-8-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 14 Aug 2019 11:47:07 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> These APIs depend on trace-cmd context and cannot be used standalone:
> 	tracecmd_create_top_instance()
> 	tracecmd_remove_instances()
> 	tracecmd_filter_pid()
> 	tracecmd_add_event()
> 	tracecmd_enable_events()
> 	tracecmd_disable_all_tracing()
> 	tracecmd_disable_tracing()
> 	tracecmd_enable_tracing()
> 	tracecmd_stat_cpu()
> They are implemented in trace-cmd application, but declared as APIs in
> trace-cmd.h. The declarations are moved from trace-cmd.h to trace-local.h,
> local header file visible only to trace-cmd application.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h  |  9 ---------
>  tracecmd/include/trace-local.h | 11 +++++++++++
>  2 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 8db0686..2c8d798 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -137,8 +137,6 @@ int tracecmd_buffer_instances(struct tracecmd_input *handle);
>  const char *tracecmd_buffer_instance_name(struct tracecmd_input *handle, int indx);
>  struct tracecmd_input *tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx);
>  int tracecmd_is_buffer_instance(struct tracecmd_input *handle);
> -void tracecmd_create_top_instance(char *name);
> -void tracecmd_remove_instances(void);
>  
>  void tracecmd_set_ts_offset(struct tracecmd_input *handle, unsigned long long offset);
>  void tracecmd_set_ts2secs(struct tracecmd_input *handle, unsigned long long hz);
> @@ -304,14 +302,7 @@ struct tracecmd_recorder *tracecmd_create_buffer_recorder_maxkb(const char *file
>  
>  int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep);
>  void tracecmd_stop_recording(struct tracecmd_recorder *recorder);
> -void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
>  long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
> -void tracecmd_filter_pid(int pid, int exclude);
> -int tracecmd_add_event(const char *event_str, int stack);
> -void tracecmd_enable_events(void);
> -void tracecmd_disable_all_tracing(int disable_tracer);
> -void tracecmd_disable_tracing(void);
> -void tracecmd_enable_tracing(void);
>  
>  enum tracecmd_msg_flags {
>  	TRACECMD_MSG_FL_USE_TCP		= 1 << 0,
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index e2d5506..05760d8 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -216,6 +216,17 @@ void show_instance_file(struct buffer_instance *instance, const char *name);
>  
>  int count_cpus(void);
>  
> +/* moved from trace-cmd.h */
> +void tracecmd_create_top_instance(char *name);
> +void tracecmd_remove_instances(void);
> +void tracecmd_filter_pid(int pid, int exclude);
> +int tracecmd_add_event(const char *event_str, int stack);
> +void tracecmd_enable_events(void);
> +void tracecmd_disable_all_tracing(int disable_tracer);
> +void tracecmd_disable_tracing(void);
> +void tracecmd_enable_tracing(void);
> +void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
> +

I'll take this patch, but I wonder if we should change "tracecmd_" to
"trace_" to let it be known that these are local functions. That can be
a later patch.

-- Steve

>  /* No longer in event-utils.h */
>  void __noreturn die(const char *fmt, ...); /* Can be overriden */
>  void *malloc_or_die(unsigned int size); /* Can be overridden */

