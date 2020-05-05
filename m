Return-Path: <SRS0=VUZx=6T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0C6C47247
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 May 2020 08:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D2822075A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 May 2020 08:40:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O8b8ayAB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgEEIkC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 May 2020 04:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgEEIkC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 May 2020 04:40:02 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A87C061A0F
        for <linux-trace-devel@vger.kernel.org>; Tue,  5 May 2020 01:40:01 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a7so716980pju.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 May 2020 01:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZdaUskkVFGu8MQMmRJS7lg4AMQn8v0LoXMPqpoBsyVo=;
        b=O8b8ayABDpnTMliiHu3UC8yrL3L0AzcMQ2i8eUQQp8UvlfV0e0g03tA+NSEqOWXTtB
         TVKhQkSHOtkm/vqu6A+O8EvyeaD49vCe2OZpSWz+ybk0LFh90vKHKzuL78cBGjjUsKhp
         630pb6uypNS/qkNWirLYeRR2KyIfpTPC86UFj658fjRR4jLk3T2xdm4vOr1lK0ofnyvv
         Q5QVvpAm5NPAMPSdqqgnbQBcaLwriIXxFvKZSeG1D9/u9U4IL0A1p9HRykNJUqBaSMx6
         4oALMkuPT4UYfx9XG0eyqEYo3J+SE8niliG7XU8IYgFkJAPwTWgrfOM3ojRlItUlXmV+
         9fIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZdaUskkVFGu8MQMmRJS7lg4AMQn8v0LoXMPqpoBsyVo=;
        b=W3PIfKMS3BUATYkQ7TFwE+1NYzE2VBE+pw6FIgWYqeYJ4wCVv64YFvaTcINSZdBraj
         KbytlEXBK4PM9Gs+oiXTXb5bvXZBDTXTUwZEYHYzeV/DkpDh++F6Gj3WjnPbLPTcvj41
         9Z+7fSK+va1t97P0p0BJvasggYkbwqPa9tD4LuN5xMv7ohZ2G4chGtWRYju3jk4qsAjn
         U77CXzfwvc7lFpC4Bgq3vwdMbQ3mFnoBpyxKIkzUreLg7UJmPMz5/4DI0IWUb2uUnHD4
         DiOJyooAKDmlKz2MtQQ3An8JGFFNMWyMkyyvyBH6zpbYpQV4oR+ls7ENe+FTiN7J+yj/
         8NGg==
X-Gm-Message-State: AGi0PuY1EV958RTqFmVHAQaEG4MI8fkhSswgfie401Mu2rbPP8xjnNkX
        wowmCc13bOXNoiTMxRuR4znAhPg/JpQgWt4UQHYiL9geqdo=
X-Google-Smtp-Source: APiQypIy2G/W6MEd89Dd6IHM1L8I1i55WAke8L89KdzyHwZ1y4Uo6DoeUBisT26/ZWD2y9ZIrXCB07qO/578HKwBKZA=
X-Received: by 2002:a17:902:a515:: with SMTP id s21mr2146662plq.41.1588668001411;
 Tue, 05 May 2020 01:40:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062711.107867-1-tz.stoyanov@gmail.com>
 <20200504062711.107867-5-tz.stoyanov@gmail.com> <20200504163001.0ce5629d@gandalf.local.home>
In-Reply-To: <20200504163001.0ce5629d@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 5 May 2020 11:39:50 +0300
Message-ID: <CAPpZLN4XFrqtvnOSkACfkyUNAm691ceEMT9LBBBZezwXc6OnVA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] trace-cmd: Do not try to update parent's memory
 from a fork()-ed child
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On Mon, May 4, 2020 at 11:30 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon,  4 May 2020 09:27:11 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > When trace-cmd runs a command, specified with the "-F" flag, it forks a
> > child process and executes the command in its context. This child process
> > receives a full copy of the parents memory at the moment of fork(). When
> > it modifies this copy, the parent memory is not affected. Calling the
> > function update_task_filter() in the child context will operate on a valid
> > data, but will not update anything in the parent's databases.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  tracecmd/trace-record.c | 64 +++++++++++++++++++++++++++++++++--------
> >  1 file changed, 52 insertions(+), 12 deletions(-)
> >
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index 1e4d38fa..ae8a5745 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -11,6 +11,7 @@
> >  #include <stdarg.h>
> >  #include <getopt.h>
> >  #include <time.h>
> > +#include <semaphore.h>
>
> OK, first things first. Do not use semaphores. I think I mentioned this to
> you before. Semaphores are a horrible interface, and should be avoided at
> all costs! ;-)
>
> Also, I don't think you are solving the bug you think you are ;-)
>

While modifying the code for per instance PID filtering, I changed the ptrace()
related logic and decided to test these changes with "--proc-map". I looked at
the implementation to find out how ptrace() works when a program is filtered and
reached to this update_task_filter() call in the child context. I
thought it should
update the filtered tasks with child's PID and realized it does not update the
parent's list because it runs in the child context.
That's the reason for this patch, I agree there is no actual bug. As I
understand,
the update_task_filter() is called in child context to update ftrace
filter configuration
with the child's PID, not to update some trace-cmd internal state. That's why
add_filter_pid() is called again in the parent's context.
As there is no actual bug, and you prefer to avoid any semaphores in trace-cmd,
I'll withdraw the patch.

> With today's code (without this patch), I can run:
>
>  # trace-cmd record -e exceptions -e sched -e irq --proc-map ls
>
> And for that result I can do:
>
>  # trace-cmd dump --options
> [..]
>                 [Option PROCMAPS, 2383 bytes]
> a10 30 /usr/bin/ls
> 556850495000 556850499000 /usr/bin/ls
> 556850499000 5568504ad000 /usr/bin/ls
> 5568504ad000 5568504b6000 /usr/bin/ls
> 5568504b6000 5568504b8000 /usr/bin/ls
> 5568504b8000 5568504b9000 /usr/bin/ls
> 556850c60000 556850c81000 [heap]
> 7efce4a9b000 7efcf1a45000 /usr/lib/locale/locale-archive
> 7efcf1a49000 7efcf1a4f000 /usr/lib64/libpthread-2.28.so
> 7efcf1a4f000 7efcf1a5f000 /usr/lib64/libpthread-2.28.so
> 7efcf1a5f000 7efcf1a65000 /usr/lib64/libpthread-2.28.so
> 7efcf1a65000 7efcf1a66000 /usr/lib64/libpthread-2.28.so
> 7efcf1a66000 7efcf1a67000 /usr/lib64/libpthread-2.28.so
> [..]
>
> What is it that you are fixing? Remember, if we run --proc-map, we enable
> ptrace. Which at the end of its execution we have:
>
>                         case PTRACE_EVENT_EXIT:
>                                 if (get_procmap)
>                                         get_pid_addr_maps(pid);
>
> Where the code records the proc_map of the -F process when it exits.
>
> The only thing this patch is saving, is the wasted time of updating the
> procmaps from the child. And to stop that, all you need is this:
>
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 1e4d38fa..4d647887 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -1187,7 +1187,7 @@ static void get_filter_pid_maps(void)
>         }
>  }
>
> -static void update_task_filter(void)
> +static void update_task_filter(bool do_procmaps)
>  {
>         struct buffer_instance *instance;
>         int pid = getpid();
> @@ -1195,7 +1195,7 @@ static void update_task_filter(void)
>         if (no_filter)
>                 return;
>
> -       if (get_procmap && filter_pids)
> +       if (do_procmaps && get_procmap && filter_pids)
>                 get_filter_pid_maps();
>
>         if (filter_task)
> @@ -1496,7 +1496,7 @@ static void run_cmd(enum trace_type type, const char *user, int argc, char **arg
>                 die("failed to fork");
>         if (!pid) {
>                 /* child */
> -               update_task_filter();
> +               update_task_filter(false);
>                 tracecmd_enable_tracing();
>                 enable_ptrace();
>                 /*
> @@ -6285,7 +6285,7 @@ static void record_trace(int argc, char **argv,
>                 if (!latency)
>                         start_threads(type, ctx);
>         } else {
> -               update_task_filter();
> +               update_task_filter(true);
>                 tracecmd_enable_tracing();
>                 exit(0);
>         }
> @@ -6293,11 +6293,11 @@ static void record_trace(int argc, char **argv,
>         if (ctx->run_command) {
>                 run_cmd(type, ctx->user, (argc - optind) - 1, &argv[optind + 1]);
>         } else if (ctx->instance && is_agent(ctx->instance)) {
> -               update_task_filter();
> +               update_task_filter(true);
>                 tracecmd_enable_tracing();
>                 tracecmd_msg_wait_close(ctx->instance->msg_handle);
>         } else {
> -               update_task_filter();
> +               update_task_filter(true);
>                 tracecmd_enable_tracing();
>                 /* We don't ptrace ourself */
>                 if (do_ptrace && filter_pids) {
>
> -- Steve



--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
