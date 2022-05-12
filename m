Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53ABC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 May 2022 03:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244533AbiELDFp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 May 2022 23:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244437AbiELDFo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 May 2022 23:05:44 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093581EEF2
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 May 2022 20:05:41 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id y27so2041609vkl.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 May 2022 20:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IuAx4f3sSM8Lh3YqFHCUg20B3Eu2I1T5RpNa3AtulyE=;
        b=CdS4ttsFHRRXU0b4/1xXWybqlweBTRd8bRtYFipTRaR6VEoaBPH1h2c9uVdmTOu8uZ
         elPsu+tYAFgaMYJuakBVIlTwv/MBI+BHPeHGZOfuYucLM5hM/6anVJLzOLo1PGRZW17x
         52rTkMgAHP1/cls2Ub6PS2FiZ7aKB8nOdoH/gjHOZERCYN0Lnw4uwvTlj6Y/nv3HZxtW
         KFVgcjZxOWrhCh9nmYBm61m75vZdh4/kpH0OrZa8F9++nb+KU3c6UFLJxcqs2PN0SQzW
         3wG/2tsqTvhEEkuRJHxXrCtDU0sQGqp4KgW5ls3ZF31LIC9IH/X7nI+szoUo7/HmHYLu
         6UfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IuAx4f3sSM8Lh3YqFHCUg20B3Eu2I1T5RpNa3AtulyE=;
        b=H76tm1vicdal62+p4aLZ7q7WYEf1UJT/nQLeaep71FOxJZYwVsavJlCNHvIPjjRUYY
         YYhkeiOJsS1LFGRbM3Tev0jDI7HI4Tp7jg4BFPRlR5oFIO7sIbCyoDuop/G33/qL4ZHa
         AFQb61gmHouGwCwJJiToNGW0RSPCzxH4Eup2svRoe5ww2ed0UthwIZs+Hobwi7xBqUra
         WxyuC9YeAqr5bP2i9EudyhMUWhvTi3ETbUULEzs4bztxve9eTfpMr2e/W6JeYuB/MQCP
         UMEdkJ/w8C3kyWrCfZ9+ssMBTDZOY9BKLmy/SjXScCcQ1FNvHnZ9N9a0XRqUI9uU5apA
         p8pA==
X-Gm-Message-State: AOAM532qShgpIGaqNYP4pn0FFIkG0f3gtKFbIs40b/rI80Aa22xLngVt
        5xVbuKF/WYOG5ufydsmqs5ae5LY4Vek7G17zgb+cZ/Tk9Rx78FpA
X-Google-Smtp-Source: ABdhPJxlVcYIzlvITVu3b78613ZHpvxP53QjpyNRGhu48u8FxaS7YYBBHCcx3KZaMjSMMJbeaxMJnjIU7l08tWrl6cw=
X-Received: by 2002:a1f:4188:0:b0:349:54be:cc27 with SMTP id
 o130-20020a1f4188000000b0034954becc27mr16411139vka.33.1652324740139; Wed, 11
 May 2022 20:05:40 -0700 (PDT)
MIME-Version: 1.0
References: <93fd065420c6a04141b5e8ba9c89dae1e7c9b6a0.camel@gmail.com>
 <CAPpZLN4A8tes3tnzDqLFBT7S2SvBixFwDW7GkYbSPeA+3e1yCQ@mail.gmail.com> <fbb8049e2a9fcce07110d5d97f08458d27c977b4.camel@gmail.com>
In-Reply-To: <fbb8049e2a9fcce07110d5d97f08458d27c977b4.camel@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 12 May 2022 06:05:24 +0300
Message-ID: <CAPpZLN4cETG40X1TWGa8b9o=rDhufXBKKGj0MDmCP4CVip9LpA@mail.gmail.com>
Subject: Re: how to register an event handler for the instance
To:     christopher lee <christopher.lee.eu@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, May 11, 2022 at 9:33 PM christopher lee
<christopher.lee.eu@gmail.com> wrote:
>
> On Sat, 2022-05-07 at 08:02 +0300, Tzvetomir Stoyanov wrote:
> > On Fri, May 6, 2022 at 7:18 PM christopher lee
> > <christopher.lee.eu@gmail.com> wrote:
> > >
> > > Hi all,
> > >
> > > I use libtraceevent in my trace tool to parse the event log. Now I
> > > allocated an instance, but no idea how to use
> > > tep_register_event_handler() to register a handler for the
> > > instance. Is
> > > it possilbe to register handler for the event in the instance?
> > >
> >
> > Hi Chrit,
> > All trace events are the same across all trace instances, thus the
> > handler registered with tep_register_event_handler() handles events
> > from all instances with a given id. That's why there are no
> > "instance"
> > oriented APIs in that library. I would suggest looking at the tracefs
> > library, which is instance aware. It can be used to allocate trace
> > instances and read events from a given instance.
> >
> > https://trace-cmd.org/Documentation/libtracefs/
> >
>
>
> Hi Tzvetomir Stoyanov,
>
> Thanks,  instance event handlers work now, but I'm confused with these
> codes, do I have to read trace_pipe_raw? I found that if I didn't read
> this file, the handler would not be able to get trace information.
> Becuase if I read this file, and also call tep_print_event() will
> consume lots of CPU resoruce. how can I parse the trace event info
> without reading this file?

Hi Christ,
All recorded events are in trace_pipe_raw file, so yes - if you want
to parse the trace event info, the first step is to read the events.
It consumes lots of CPU resources because there are a lot of events to
read and parse. I would suggest using the tracefs_iterate_raw_events()
API to read the events, as it is optimized to read the trace_pipe_raw
file in an efficient way, or at least to look at its implementation if
you do not want to use the tracefs library.

static int read_callback(struct tep_event *event, struct tep_record
*record, int cpu, void *context)
{
     ...
     tep_print_event();
     ...
}

tracefs_iterate_raw_events(tep, instance, NULL, 0, read_callback, ...);

>
>
>         for (i = 0; ; i++) {
>                 char *raw_buf;
>                 char *cpu;
>
>                 ret = asprintf(&cpu, "%s/cpu%d", per_cpu, i);
>                 if (ret < 0)
>                         pdie("Could not allocate memory for cpu buffer
> %d name", i);
>
>                 ret = stat(cpu, &st);
>                 if (ret < 0 || !S_ISDIR(st.st_mode)) {
>                         free(cpu);
>                         goto start;
>                 }
>
>                 ret = asprintf(&raw_buf, "%s/trace_pipe_raw", cpu);
>                 if (ret < 0)
>                         pdie("Could not allocate memory for cpu %d raw
> buffer name", i);
>
>                 read_raw_buffer(i, raw_buf);
>                 free(raw_buf);
>                 free(cpu);
>         }
>
> Best regards,
> Christ
>
> >



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
