Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB9FC433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 15:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3893619FF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 15:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236627AbhCXPjC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236784AbhCXPiz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 11:38:55 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0AAC061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 08:38:54 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id g15so17600000pfq.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 08:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NECRaqjtwgHO/b41z/5niRKvwf1xLAm2E8KMf3FwxBw=;
        b=RfC1M5qr9ceQV/9HDv2CrmWXXUjbZ5BW05jN30U23QSaJlL3eCdEAVSa0ZOw+XbeXZ
         FN5GAAyhjuQqUlk5XWyMI3RO+9mIgAf1Uhm9jvFD1MpMxj3/OVnCO8FIBCBd0GbwXV2e
         1IHgYkDffbumUEhEhxAEuz/FEmHafy+250XNHUC6BrsGC7ynbWJ7x88/PCN8T6H8bMXH
         1sCitXcarRXd0SahXv9l+I85LiKtPKgaluix1NTs95NtgGw+w7T+80zv/G3EgxDEkBMR
         ZjiNxs4c+4hprnAMcGSTp8TiFiOzCkkB5EqCKwYRnftnhdqY8FF6OszrvPdN/FwLZZtA
         CEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NECRaqjtwgHO/b41z/5niRKvwf1xLAm2E8KMf3FwxBw=;
        b=UZrI6McRPngW8ycsgRhwcksqzuD0TFKDSPdAZWTuaXNkCHnxVm69NLOSoIcph8pc/h
         C1ctPnOCbiidt7NZjzzelt9y3pWyTxWYM0RCmk64NqL/91mQouKJnZLt00ZNCAeSwCrZ
         0ave/hBINhC/nQ51i5wIe9FZmCpGdSBvs6yDTYvunqMGgjGAxBs5+S/bKKpwBqhwq8//
         CsTWF2g9inUVu4FnZ1VFUt5CyalGs0PtlN5JYqdgAWACvRA/q2+hePrmhkRA2/z8lnum
         KgaxbhMlgyI1v91bZ9E8X72B2XJgU25ZwzNK3H3YglJ10/nzBZ1v7h9FPtBBq4atiWpK
         mrsw==
X-Gm-Message-State: AOAM532FNhO+k8UdQZOJU6HZcZ23ujuq89E+7jioZ9ehnE9/05GcANGd
        SlkdtRzhdfp1mkuOj+ICLRWF0SauRcQh13nOy+35hYEHhpA8qQ==
X-Google-Smtp-Source: ABdhPJy6Pdf75uI4u5GXW0izPS2aq2z7XizCX6Wa7o3d4/TzqZm5WBW4gCha+M4v/CYLV+Tif3VpjAEPWAVIGThmjPs=
X-Received: by 2002:a63:c143:: with SMTP id p3mr3624042pgi.44.1616600334422;
 Wed, 24 Mar 2021 08:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
 <20210324130418.436206-7-tz.stoyanov@gmail.com> <20210324112001.0d897bdb@gandalf.local.home>
In-Reply-To: <20210324112001.0d897bdb@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 24 Mar 2021 17:38:37 +0200
Message-ID: <CAPpZLN7ULyGkfkB4s9ygrE3OiEjWZTcyy5smfK4vd8Sxoc1TEw@mail.gmail.com>
Subject: Re: [PATCH v3 06/23] trace-cmd: Add new trace-cmd clock tsc2nsec
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 24, 2021 at 5:20 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 24 Mar 2021 15:04:01 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > @@ -199,6 +200,12 @@ struct filter_pids {
> >       int exclude;
> >  };
> >
> > +struct tsc_nsec {
> > +     int mult;
> > +     int shift;
> > +     unsigned long long offset;
> > +};
> > +
> >  struct buffer_instance {
> >       struct buffer_instance  *next;
> >       char                    *name;
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index 5f7f5b3d..2a594736 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -57,6 +57,8 @@
> >  #define MAX_LATENCY  "tracing_max_latency"
> >  #define STAMP                "stamp"
> >  #define FUNC_STACK_TRACE "func_stack_trace"
> > +#define TSC_CLOCK    "x86-tsc"
> > +#define TSCNSEC_CLOCK        "tsc2nsec"
> >
> >  enum trace_type {
> >       TRACE_TYPE_RECORD       = 1,
> > @@ -198,6 +200,7 @@ struct common_record_context {
> >       char *date2ts;
> >       char *user;
> >       int data_flags;
> > +     struct tsc_nsec tsc2nsec;
>
> struct tsc_nsec is 16 bytes in size, ending with a 8 byte word. It should
> be added before the "int data_flags" to prevent a hole in the middle of
> this struct.
>
>
> >
> >       int record_all;
> >       int total_disable;
>
>
> > @@ -5904,7 +5965,15 @@ static void parse_record_options(int argc,
> >                       break;
> >               case 'C':
> >                       check_instance_die(ctx->instance, "-C");
> > -                     ctx->instance->clock = optarg;
> > +                     if (!strncmp(optarg, TSCNSEC_CLOCK, strlen(TSCNSEC_CLOCK))) {
>
> Hmm, why the strncmp()? Shouldn't it be a full match, not a partial one?
>
> > +                             ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
> > +                                                &ctx->tsc2nsec.mult);
> > +                             if (ret || !clock_is_supported(NULL, TSC_CLOCK))
> > +                                     die("Clock %s is not supported", optarg);
> > +                             ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
> > +                             ctx->instance->clock = strdup(TSC_CLOCK);
>
> Hmm, why the strdup? below we have clock = optarg, one of them is wrong. If
> we free instance->clock, then we can't have it set to optarg. As that was
> the way it was before, it looks to be a separate bug that probably needs
> its own patch.

Actually, instance->clock is never freed - because there is no
function to free an instance. There is allocate_instance(), but no API
to free. That's why both are valid. I was wondering if to use strdup
or simple assignment, and decided to allocate a memory. One day we may
implement free_instance(), there are a lot of resources in an instance
that should be freed.

>
> > +                     } else
> > +                             ctx->instance->clock = optarg;
>
> Actually, I think we should have the above be:
>
>                 case 'C':
>                         if (strcmp(optarg, TSCNSEC_CLOCK) == 0) {
>                                 ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
>                                                    &ctx->tsc2nsec.mult);
>                                 if (ret)
>                                         die("TSC to nanosecond is not supported");
>
>                                 ctx->instance->clock = TSC_CLOCK;
>                         } else {
>                                 ctx->instance->clock = optarg;
>                         }
>                         if (!clock_is_supported(ctx->instance->clock))
>                                 die("Clock %s is not supported",
>                                     ctx->instance->clock);
>                         ctx->instance->clock = strdup(ctx->instance->clock);
>                         if (!ctx->instance->clock)
>                                 die("Failed allocation");
>
> The above is more informative about the reason for the error, and also
> removes duplicate code in the check of supported clocks.
>
> -- Steve
>
>
> >                       ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
> >                       if (is_top_instance(ctx->instance))
> >                               guest_sync_set = true;
> > @@ -6159,6 +6228,13 @@ static void parse_record_options(int argc,
> >                               die("--fork option used for 'start' command only");
> >                       fork_process = true;
> >                       break;
> > +             case OPT_tsc2nsec:
> > +                     ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
> > +                                        &ctx->tsc2nsec.mult);
> > +                     if (ret)
> > +                             die("TSC to nanosecond is not supported");
> > +                     ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
> > +                     break;
> >               case OPT_quiet:
> >               case 'q':
> >                       quiet = true;



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
