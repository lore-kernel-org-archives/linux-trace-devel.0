Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9AEFC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 05:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FF0261A16
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 05:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCYFgL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 01:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhCYFfv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 01:35:51 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426F7C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 22:35:51 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id l76so675792pga.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 22:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=juxMwbeW6bQloFYY4OCyypaNp1fkeGZHxLTvUL+ldU4=;
        b=T+2mm0Alvm+PTNGASxFxHCWuNVuSeerNeEfxvLRmJd2CiNGZtk5X/ZiBljeYPnN59Q
         PXcg6gOlkrwKQGWrdqur6icd1zTpk4N6sjsQ0RqoI7I8aE0kBqR8/xTuS9QPMafoC5KB
         v7HKriCOvJC8nKd5kdDMakxBtLtSa63HCTNl05z98o+qXRTYp/eBL2QLuhP/ib7Xx/ZV
         dB28ifn+WbTqZ7be5NfdZA8OzyATSHS/SA68OMX8G0Ic1o9oFYfNYpZKEDC1BTJnw0ya
         /lpp+OlcceDrosgvKeMP8g/iVaEUP82StlAgVzb1Oi3UOUo+5T+ER7TdKStgs2Td6mHA
         3oxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=juxMwbeW6bQloFYY4OCyypaNp1fkeGZHxLTvUL+ldU4=;
        b=KO1we5wRZF9RJowcpI1oqEMptGABmUTrcvqVKxNFBH9gY14KD8RmV/HmhhFH2J9Zoi
         NGGIbB4940hTHG3FUKW4otOjonFzV4qQbd08kctEa47fqkuIY70eAiFBgRKmYXr7Em5M
         U/y5ALZu94poWsNjKNqFTJMlRQKv3C9iqXV+S0xa+PflGnk23G0K2DOm9xFzZxZ1queO
         YFS78viDoVDe8CfWxsDWzg2RfztpbPxWRU4S7QPcktY2YYQJQkjIq3dUg+vwpeK9o1G0
         P3k/5d+NdmicgPOPc1/NVtlMen2y/WVw4TpNCvOT0ITw78BjBIHi1dYHvmcFnks98v/n
         yz0A==
X-Gm-Message-State: AOAM531wxkYgfVWMFakWyklS9UHhKAsl9Ww7PP/PHnYZqs3fBD7Dk3+y
        OZyJNi+bqDpj8SxgdPqB4iHnuEcswYVRSLEYX60IFZeaT6gi3g==
X-Google-Smtp-Source: ABdhPJzBRgU0agUfeJHkeNmx8NqnreBUhn3KeFqwlH0ilcvmcMwF0Xo9/hvWYj4m1YOwS9BOuQ0hi4DbUxrFu+Ni4Ak=
X-Received: by 2002:a17:903:304b:b029:e6:ef44:6b94 with SMTP id
 u11-20020a170903304bb02900e6ef446b94mr7683707pla.26.1616650550795; Wed, 24
 Mar 2021 22:35:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
 <20210324130418.436206-23-tz.stoyanov@gmail.com> <20210324172446.611276a4@gandalf.local.home>
In-Reply-To: <20210324172446.611276a4@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 25 Mar 2021 07:35:34 +0200
Message-ID: <CAPpZLN4g1o=oSK9SO6PL=QptcSfVEyytX3aSi4JXLCAt72F7rg@mail.gmail.com>
Subject: Re: [PATCH v3 22/23] trace-cmd: Save the trace clocks in TRACECLOCK option
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 24, 2021 at 11:24 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 24 Mar 2021 15:04:17 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Save the content of the trace_clock file in the TRACECLOCK option in
> > the trace.dat file. The clocks can be printed with "trace-cmd dump
> > --options" command.
> > These clocks were saved right before the tracing data in the file, but
> > this patch set changed that logic. Now only the selected clock is saved
> > in the file before the tracing data.
> > Having all supported trace clocks in the file is useful for debug
> > purposes. Adding clocks in the existing TRACECLOCK option is save and
> > will not break the older versions of trace-cmd.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  tracecmd/trace-record.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index 2fc6723a..f4c27ef1 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -4138,6 +4138,7 @@ enum {
> >  static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
> >  {
> >       int type = 0;
> > +     char *clocks;
> >
> >       if (ctx->date2ts) {
> >               if (ctx->data_flags & DATA_FL_DATE)
> > @@ -4149,12 +4150,15 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
> >       if (type)
> >               tracecmd_add_option(handle, type, strlen(ctx->date2ts)+1, ctx->date2ts);
> >
> > -     tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
> > +     clocks = tracefs_instance_file_read(NULL, "trace_clock", NULL);
> > +     tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK,
> > +                         clocks ? strlen(clocks)+1 : 0, clocks);
>
> Strange. Even after applying this patch, I still get:
>
> # ./tracecmd/trace-cmd dump
>
>  Tracing meta data in file trace.dat:
>         [Initial format]
>                 6       [Version]
>                 0       [Little endian]
>                 8       [Bytes in a long]
>                 4096    [Page size, bytes]
>         [Header page, 205 bytes]
>         [Header event, 205 bytes]
>         [Ftrace format, 15 events]
>         [Events format, 104 systems]
>         [Kallsyms, 6978379 bytes]
>         [Trace printk, 4997 bytes]
>         [Saved command lines, 1987 bytes]
>         8 [CPUs with tracing data]
>         [13 options]
>         [Flyrecord tracing data]
>         [Tracing clock]
>                  No tracing clock saved in the file
>
>
> Seems to be that it skips over the options unless you explicitly ask for it.

Going to fix it in v4. The way it should work:
 1. "trace-cmd dump" && "trace-cmd dump --clock": [Tracing clock] -
dump the clock written just before the tracing data. This clock is
valid only if there is a TRACECLOCK option in the file. Here is prints
"No tracing clock saved in the file" because options are not parsed
and TRACECLOCK is not detected, going to fix this. This should be the
first user specified clock with "-C ..." option, or the clock of the
first trace instance.
 2. "trace-cmd dump --options" - dump the content of the TRACECLOCK
option, all clocks from "trace_clock" of the top instance, during the
trace session. The selected clock here could be different from the one
in the previous point, if the top instance is not used in the tracing.
The idea is to have all supported clocks here, the selected one is
written before the tracing data - that way the old trace-cmd logic
will still work.

>
> -- Steve
>
> >       add_option_hooks(handle);
> >       add_uname(handle);
> >       add_version(handle);
> >       if (!no_top_instance())
> >               add_trace_id(handle, &top_instance);
> > +     free(clocks);
> >  }
> >
> >  static void write_guest_file(struct buffer_instance *instance)
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
