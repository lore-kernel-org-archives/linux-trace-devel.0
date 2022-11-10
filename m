Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9184C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Nov 2022 03:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiKJDDZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiKJDDY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 22:03:24 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195A92A3
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 19:03:22 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id f5so1769787ejc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Nov 2022 19:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ews2n34lRBiUzSgfvI+6a0CZ1ZaOjsflMkKXgZ1bg2M=;
        b=CLvmX+LLj9FyEGsePAzHUpS7OPoYpaRs1TCg4Bl5UD4efHtfL9qFY3DUv9Lu9ykZEh
         tI2Zbt9b3oz295lWt7SY3CRNYDSsrG/X3G1TGe62BksHD0oY1X6KXxE4ODWA7kjY9Umi
         bum55ac6zU2PJVLYtW04TNIHi9poV4lqYXEqA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ews2n34lRBiUzSgfvI+6a0CZ1ZaOjsflMkKXgZ1bg2M=;
        b=rj4flMpxEkq5E0Y4xxd4oURCRoNDOPTkjuboorPqFoD6d63Lc5Twm99BBfhJNwyXmF
         b6eE1cT0B5NAti7dkFspiP0Dze5OK+ZWctylXOSWuKLeCPjvNgZYHJw5osIkAc0H82We
         dHhWVwJGgvBcnwm2h08vKyWHFA/tJoBkEHruRn4RoJajEpig9Z7owjAObhUZ9cA6jyYQ
         Wcm0ps5QdOknjyKKNiswHOU52nhyYJuZRG5c74tqeBb4UdMg0F5g++LxjrvhqRlOpfkZ
         n9gwsUAJK+uUw9vsUk/JAuDW4TH/6EuK2gndUzvM7UQf6fGefG7KqI+yslM6Moxq2xIS
         6SJA==
X-Gm-Message-State: ACrzQf1JnsDiT/vLl+TixcJjrvROiI9mlS0Rszb9jDB98G9G+wcVrIgL
        7UDlDGBbjkhoyGkbS+nSj/860e0R9ELRfyW54aP3GhRaLJmkIA==
X-Google-Smtp-Source: AMsMyM6UhwI4c9hNLfa//pkYEHLOPrBz4+e7srlv5dg7kgkMD27kk1sqAhg6itX/HRa+uG+tAa8dnQ4T7AwQFVF+vQk=
X-Received: by 2002:a17:907:3f19:b0:7a3:2317:4221 with SMTP id
 hq25-20020a1709073f1900b007a323174221mr57816953ejc.562.1668049400209; Wed, 09
 Nov 2022 19:03:20 -0800 (PST)
MIME-Version: 1.0
References: <20221110025514.2989642-1-joel@joelfernandes.org>
In-Reply-To: <20221110025514.2989642-1-joel@joelfernandes.org>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Thu, 10 Nov 2022 03:03:09 +0000
Message-ID: <CAEXW_YSsbqoywrkNg-+v8YTV8LQEgtX+xJGTcpFHpqyApWt25w@mail.gmail.com>
Subject: Re: [PATCH] tracing: Dump instance traces into oops with ftrace_dump_on_oops
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org,
        Ross Zwisler <zwisler@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 10, 2022 at 2:55 AM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> Currently ftrace only dumps the current trace buffer on OOPS. For
> debugging a production usecase, I'd like to dump instance traces as
> well, into the kernel logs. The reason is we cannot use the global trace
> buffer as it may be used for other purposes.
>
> This patch adds support for dumping the trace buffer instances along
> with the global trace buffer.
>
> The instance traces are dumped first, and then the global trace buffer.
>
> Cc: Ross Zwisler <zwisler@google.com>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  kernel/trace/trace.c | 70 ++++++++++++++++++++++++--------------------
>  1 file changed, 39 insertions(+), 31 deletions(-)
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 47a44b055a1d..15ddee31cc23 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -9914,15 +9914,12 @@ trace_printk_seq(struct trace_seq *s)
>         trace_seq_init(s);
>  }
>
> -void trace_init_global_iter(struct trace_iterator *iter)
> +void trace_init_iter_with_tr(struct trace_iterator *iter, struct trace_array *tr)
>  {
> -       iter->tr = &global_trace;
> +       iter->tr = tr;
>         iter->trace = iter->tr->current_trace;
>         iter->cpu_file = RING_BUFFER_ALL_CPUS;
> -       iter->array_buffer = &global_trace.array_buffer;
> -
> -       if (iter->trace && iter->trace->open)
> -               iter->trace->open(iter);

I dropped this open() call by mistake. I did not show up as an issue
in my testing, so I missed it. I'll go fix that and send v2, sorry.

 - Joel


> +       iter->array_buffer = &iter->tr->array_buffer;
>
>         /* Annotate start of buffers if we had overruns */
>         if (ring_buffer_overruns(iter->array_buffer->buffer))
> @@ -9939,36 +9936,14 @@ void trace_init_global_iter(struct trace_iterator *iter)
>         iter->fmt_size = STATIC_FMT_BUF_SIZE;
>  }
>
> -void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
> +void ftrace_dump_one(struct trace_array *tr, enum ftrace_dump_mode oops_dump_mode)
>  {
> -       /* use static because iter can be a bit big for the stack */
>         static struct trace_iterator iter;
> -       static atomic_t dump_running;
> -       struct trace_array *tr = &global_trace;
>         unsigned int old_userobj;
> -       unsigned long flags;
>         int cnt = 0, cpu;
>
> -       /* Only allow one dump user at a time. */
> -       if (atomic_inc_return(&dump_running) != 1) {
> -               atomic_dec(&dump_running);
> -               return;
> -       }
> -
> -       /*
> -        * Always turn off tracing when we dump.
> -        * We don't need to show trace output of what happens
> -        * between multiple crashes.
> -        *
> -        * If the user does a sysrq-z, then they can re-enable
> -        * tracing with echo 1 > tracing_on.
> -        */
> -       tracing_off();
> -
> -       local_irq_save(flags);
> -
>         /* Simulate the iterator */
> -       trace_init_global_iter(&iter);
> +       trace_init_iter_with_tr(&iter, tr);
>
>         for_each_tracing_cpu(cpu) {
>                 atomic_inc(&per_cpu_ptr(iter.array_buffer->data, cpu)->disabled);
> @@ -9993,7 +9968,10 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
>                 iter.cpu_file = RING_BUFFER_ALL_CPUS;
>         }
>
> -       printk(KERN_TRACE "Dumping ftrace buffer:\n");
> +       if (tr == &global_trace)
> +               printk(KERN_TRACE "Dumping ftrace buffer:\n");
> +       else
> +               printk(KERN_TRACE "Dumping ftrace instance %s buffer:\n", tr->name);
>
>         /* Did function tracer already get disabled? */
>         if (ftrace_is_dead()) {
> @@ -10041,6 +10019,36 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
>         for_each_tracing_cpu(cpu) {
>                 atomic_dec(&per_cpu_ptr(iter.array_buffer->data, cpu)->disabled);
>         }
> +}
> +
> +void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
> +{
> +       /* use static because iter can be a bit big for the stack */
> +       static atomic_t dump_running;
> +       struct trace_array *tr;
> +       unsigned long flags;
> +
> +       /* Only allow one dump user at a time. */
> +       if (atomic_inc_return(&dump_running) != 1) {
> +               atomic_dec(&dump_running);
> +               return;
> +       }
> +
> +       /*
> +        * Always turn off tracing when we dump.
> +        * We don't need to show trace output of what happens
> +        * between multiple crashes.
> +        *
> +        * If the user does a sysrq-z, then they can re-enable
> +        * tracing with echo 1 > tracing_on.
> +        */
> +       tracing_off();
> +       local_irq_save(flags);
> +
> +       list_for_each_entry(tr, &ftrace_trace_arrays, list) {
> +               ftrace_dump_one(tr, oops_dump_mode);
> +       }
> +
>         atomic_dec(&dump_running);
>         local_irq_restore(flags);
>  }
> --
> 2.38.1.493.g58b659f92b-goog
>
