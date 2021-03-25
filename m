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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93DCC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 05:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7149661A21
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 05:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCYFOm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 01:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhCYFON (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 01:14:13 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B68C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 22:14:12 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c204so834300pfc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 22:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=geuzzqT25Lw+xF8SzRRXsHweAVEzuZ6UNoPFiaRAkMQ=;
        b=Qm2LTVm4Zy84s0KFM5DH+63HveUuGdWUGDO1D/RoeBTUqFKtau51BxxRLBDXqSVOwd
         9RFi0ApZq5SWAYK35x0YyOgPuPf3dfPzqdzFpZFmc8hD9SdTf4BPLX00DvxJOL9hQb33
         2kfnWxIu5wqYwwhm0HPY1n6/2iMVr07jWKEnXN4M/GRMDg4Jf5C7rASLcuxXaVNPIDtV
         Ku/iqvog1GnTE7aVlfb/hhmWXF0RJ898RTkfb+H91M539XiaBAGWUXBMwgOGyTCRs8gQ
         4EMwhiGJrMUKh7zP+Wob31T7bTiYuLHlGbE41R7aBUfD3jDubJMMz3RWpnuospNBQXbj
         0k9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=geuzzqT25Lw+xF8SzRRXsHweAVEzuZ6UNoPFiaRAkMQ=;
        b=o5/odeJh68F5CfKZEJI1bHPpvrfiKnFFp4DCfoaLsy8X9ZilD2vg+g1S40RZnDrifo
         0Tf2hb6OIpl65tVip1CXaEZ7ZqyzPYC9VYeT1J2Pi7dOX7++zsHhRabVFkrkfZdjl6nh
         nkPSny6YQz4khoQeT5Tsx94WplXi4KaVsq1JJHNdC4ZuBGaN/kknDM9oYnc/KMTzDGaY
         rmJWkebyCfVGVSteaPe9xGNWkHnZlWVhKt6DCC+M5miXupykYh9OfYoPdolPdmV1yJ9x
         MSbIzx8ajYGa0SiMxfRP5Y9duY9CNJ8SG7Xq4MS/rdLTFtH9PlmhVwjx+fnxdigD1h6N
         G7vw==
X-Gm-Message-State: AOAM533wURFOI3388IvQ3QBA3cQHAk1VsSP7w+T4otNt2/tbsqHfjQ5f
        vW4b6aT47DAU+V30hxsDHvYCbVR57vzCRROwib/bEfe4VCk=
X-Google-Smtp-Source: ABdhPJyncGfiujl3WJYNA8F9MDzaiHI/R57eAfO7dl6R25gLdyaJf2nCTsUXlAylo59ZW0cBorHswmyzTvDhHwiEm1I=
X-Received: by 2002:a17:903:304b:b029:e6:ef44:6b94 with SMTP id
 u11-20020a170903304bb02900e6ef446b94mr7591359pla.26.1616649252266; Wed, 24
 Mar 2021 22:14:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
 <20210324130418.436206-22-tz.stoyanov@gmail.com> <20210324171556.47b8065f@gandalf.local.home>
In-Reply-To: <20210324171556.47b8065f@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 25 Mar 2021 07:13:55 +0200
Message-ID: <CAPpZLN7Cj9Bzwmnc52jWFnGZHTAeTk+0v=oxHZ-+iJLmfJ4XEA@mail.gmail.com>
Subject: Re: [PATCH v3 21/23] trace-cmd: Get current clock for host-guest
 tracing session
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 24, 2021 at 11:15 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 24 Mar 2021 15:04:16 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > In host-guest tracing session, all peers should use the same tracing
> > clock. If there is no user configured trace clock, the current logic
> > assumes "local" clock for the session. This could be wrong, as other
> > clock than "local" could be already configured on the host, before
> > running trace-cmd. The default clock for host-guest tracing session
> > should be rertieved from the host's "trace_clock" file.
>
> Actually this is wrong. If clock is not specified, you should check the
> first instance, because if the user does:
>
>  # trace-cmd start -B foo -p nop -C myclock
>
>  # trace-cmd record -B foo -e kvm -e sched -A Guest -e all
>
> It should not use the clock from the top instance, but instead the first
> instance.

Yes, the implementation uses the clock from the first non-guest
instance, the description of the patch is not correct.

>
> I'm trying to make sure tha trace-cmd does not affect or even use the top
> instance if it is not part of the command line.
>
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  tracecmd/trace-record.c | 40 ++++++++++++++++++++++++++++++----------
> >  1 file changed, 30 insertions(+), 10 deletions(-)
> >
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index f90fdbe4..2fc6723a 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -6455,11 +6455,12 @@ static void get_tsc_offset(struct common_record_context *ctx)
> >
> >  static void set_tsync_params(struct common_record_context *ctx)
> >  {
> > -     const char *clock = ctx->clock;
> >       struct buffer_instance *instance;
> >       int shift, mult;
> >       bool force_tsc = false;
> > +     char *clock = NULL;
> >
> > +     if (!ctx->clock) {
> >       /*
> >        * If no clock is configured &&
> >        * KVM time sync protocol is available &&
> > @@ -6468,18 +6469,35 @@ static void set_tsync_params(struct common_record_context *ctx)
> >        * force using the x86-tsc clock for this host-guest tracing session
> >        * and store TSC to nsec multiplier and shift.
> >        */
> > -     if (!clock && tsync_proto_is_supported("kvm") &&
> > -         clock_is_supported(NULL, TSC_CLOCK) &&
> > -         !get_tsc_nsec(&shift, &mult) && mult) {
> > -             clock = TSC_CLOCK;
> > -             ctx->tsc2nsec.mult = mult;
> > -             ctx->tsc2nsec.shift = shift;
> > -             ctx->tsc2nsec.offset = get_clock_now(TSC_CLOCK);
> > -             force_tsc = true;
> > +             if (tsync_proto_is_supported("kvm") &&
> > +                 clock_is_supported(NULL, TSC_CLOCK) &&
>
> So we want to test the first instance, not the top one.

I assume that if the top instance supports "x86-tsc" clock, then any
instance should support it also ? Is it possible that supported clocks
can be different in each instance ?

>
> -- Steve
>
> > +                 !get_tsc_nsec(&shift, &mult) && mult) {
> > +                     clock = strdup(TSC_CLOCK);
> > +                     if (!clock)
> > +                             die("Cannot not allocate clock");
> > +                     ctx->tsc2nsec.mult = mult;
> > +                     ctx->tsc2nsec.shift = shift;
> > +                     ctx->tsc2nsec.offset = get_clock_now(TSC_CLOCK);
> > +                     force_tsc = true;
> > +             } else {
> > +             /*
> > +              * Else, use the current clock of the first host instance
> > +              */
> > +                     for_all_instances(instance) {
> > +                             if (is_guest(instance))
> > +                                     continue;
> > +                             clock = tracefs_get_clock(instance->tracefs);
> > +                             break;

This is the loop that gets the clock from the first non-guest
instance, in case there is no "-C ..." option in the command line.

> > +                     }
> > +             }
> > +     } else {
> > +             clock = strdup(ctx->clock);
> > +             if (!clock)
> > +                     die("Cannot not allocate clock");
> >       }
> >
> >       if (!clock && !ctx->tsync_loop_interval)
> > -             return;
> > +             goto out;
> >       for_all_instances(instance) {
> >               if (clock && !(instance->flags & BUFFER_FL_HAS_CLOCK)) {
> >                       /* use the same clock in all tracing peers */
> > @@ -6501,6 +6519,8 @@ static void set_tsync_params(struct common_record_context *ctx)
> >               }
> >               instance->tsync_loop_interval = ctx->tsync_loop_interval;
> >       }
> > +out:
> > +     free(clock);
> >  }
> >
> >  /*
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
