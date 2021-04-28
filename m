Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB2BC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6978B61168
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237712AbhD1Mc7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 08:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235833AbhD1Mc7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 08:32:59 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490E5C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:32:14 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id 20so28785875pll.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZKfo16jcnsVHvPqU2Q1hqoYkIdcFeAYi1smI1hTV3HM=;
        b=r/Om+0OhUSlrCqfl0jcV1Y+1VsiwxWS4wGixf6ixoVHS3+MJLw6GvYLFqv+ITeKt4n
         Z8wr0nl1tG5hvYdCL/Ls8j48uW3WoNbM1fOtVaCJPXxPkTzgpRSgEztz68PUurMoBMJi
         5nX8YMHsPC453TMSAh2QcKkKcVCRhOWhta6cdi6siwE3SKikcxtpg2ddfEAprrbNxODN
         6X01KfTRL7hyNktEtJvikzAftQUJnWqloyl0RC7ZjevCTqCf9XEN2PGWsm+uEaRCidEv
         e/nI+yEp81DjFsasyIs4GfD+kZSbln3yFrLCW9exYG9c5bdLl57h5MiLeVLg/SM1K6rT
         Y01w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZKfo16jcnsVHvPqU2Q1hqoYkIdcFeAYi1smI1hTV3HM=;
        b=gAFZNbLWJ8XpAMXeFJ7pPAxB1mFsG5I0hnN99oK/E9/bv1zldrH6cmbzI3wdF6kGni
         fnjQuwI7UZD3uugfTktXbO50QG2vX9DzsHVaiDaGTlHIkGE+qZ9Vnnl5Q9bLzYNSrGrg
         UKQDaMQzX/THWz8APANGqzbngHwqyZzifWXhnAOC9JktxBC6D8A1Lto9iPaVXtud0ne+
         eNhWphVzoNJ5gJsu2i9Q6oZZClqdSSMfpV0+yjUrJlBLXS4TUiFyf/fQYMJYE6dL9TPy
         jqiWhE2LTWWF5OsC5LygusuQ0Jc5cwiAXrj3r0KnGY+Z3fxPmNTbSafxJDAwjfIIbVFR
         C98Q==
X-Gm-Message-State: AOAM5313gM4MA6CoDvqQ2HHDu4s0WFwgzOz/U26Sd3AHHKDjgt8Uel0U
        qSSR+G7b2QirXDyU1DrFaDWTnEa+0WzrcxVLkCwWnZBPLcZ0PQ==
X-Google-Smtp-Source: ABdhPJzhG5hp2JPRoxqWjW63ooUTq1IXkzIIx5TLyAnaqqrihLykpCC4n4MeOfZzUDwVCkcigFQqYyhhPwkblgXFQO8=
X-Received: by 2002:a17:902:122:b029:e8:bde2:7f6c with SMTP id
 31-20020a1709020122b02900e8bde27f6cmr30009178plb.29.1619613133736; Wed, 28
 Apr 2021 05:32:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210416103409.24597-1-tz.stoyanov@gmail.com> <20210416103409.24597-3-tz.stoyanov@gmail.com>
 <20210416161221.031d1f5d@gandalf.local.home> <CAPpZLN4K6H8p1zNuqHQd0LGDHatAgR+8SHRH1jTP8=Jb_bMZUw@mail.gmail.com>
 <20210419094543.15c131c2@gandalf.local.home> <20210419111407.29a90f86@gandalf.local.home>
In-Reply-To: <20210419111407.29a90f86@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 28 Apr 2021 15:31:57 +0300
Message-ID: <CAPpZLN6Zy0=qxp5yG-Z3EG_De9ewLiZuG1FoPYuEDNfH-YA96Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] trace-cmd library: Add check before applying
 tsc2nsec offset
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 19, 2021 at 6:14 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 19 Apr 2021 09:45:43 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
> > That is:
> >
> >       max = 0;
> >       for each stream:
> >               ret = read first event, compared to offset
> >               if (!ret) {
> >                       /* ret will be how much off by offset */
> >                       if (ret > max)
> >                               max = ret;
> >               }
> >       if (max) {
> >               for each stream:
> >                       Update offset by subtracting max
> >       }
> >
> > Look at each stream, and have some callback give you how much ahead the
> > first event is from its given offset. Take the biggest value from reading
> > all the streams, then tell all the streams to subtract its offset by that
> > max value. The end result is that all streams now start at a positive value.
>
> From our call, here's the pseudo code that I was talking about:
>
> > diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> > index b17b36e0..f03dadd3 100644
> > --- a/lib/trace-cmd/trace-input.c
> > +++ b/lib/trace-cmd/trace-input.c
> > @@ -1302,7 +1302,7 @@ static unsigned long long timestamp_host_sync(unsigned long long ts, int cpu,
> >                                        &tsync->ts_samples[mid+1]);
> >  }
> >
> > -static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
> > +static unsigned long long pre_timestamp_calc(unsigned long long ts, int cpu,
> >                                        struct tracecmd_input *handle)
>
> I pulled out the timestamp_calc into a helper function.
>
> >  {
> >       /* do not modify raw timestamps */
> > @@ -1318,17 +1318,44 @@ static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
> >               ts *= handle->ts2secs;
> >       } else if (handle->tsc_calc.mult) {
> >               /* auto calculated TSC clock frequency */
> > -             ts -= handle->tsc_calc.offset;
>
> And removed the calc offset.
>
> >               ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
> >       }
> >
> >       /* User specified time offset with --ts-offset or --date options */
> > -     if (handle->ts_offset)
> > -             ts += handle->ts_offset;
> > +     ts += handle->ts_offset;
>
> As we mentioned (and this can be a separate patch), the if statement is
> useless.
>
> >
> >       return ts;
> >  }
> >
> > +static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
> > +                                      struct tracecmd_input *handle)
> > +{
> > +     static int once;
> > +
> > +     ts = pre_timestamp_calc(ts, cpu, handle);
> > +     if (!once && ts > handle->start_ts_offset) {
> > +             once++;
> > +             tracecmd_warning();
> > +     }
> > +     ts -= handle->start_ts_offset;
>
> After looking at this more, I think we should just have the ts_offset and
> start_ts_offset be the same. And remove the ts += handle->ts_offset, from
> the pre_timestamp_calc() above, and have this check test just ts_offset.
>
> So now the timestamp_calc() will get the timestamp and then apply the
> ts_offset separately (and warn if the offset is greater than the ts).
>
> > +}
> > +
> > +
> > +
> > +long long tracecmd_cpu_first_ts_offset(struct tracecmd_input *handle, int cpu)
> > +}
> > +     struct tep_record rec;
> > +
> > +     rec = first_event(handle, cpu);
> > +     return pre_timestamp_calc(rec->ts, cpu, handle) - handle->ts_offset;
> > +}
>
> Add an API that shows the difference between the first stream event
> timestamp against the user supplied (or file supplied) ts_offset.
>
>
> > +
> > +int tracecmd_modify_ts_offset(struct tracecmd_input *handle, long long offset)
> > +{
> > +     handle->ts_offset += offset;
> > +}
>
> Allow the user to tweak that offset. As we already have:
>
> tracecmd_set_ts_offset(handle, offset) to set ts_offset, if the user found
> that the offset was before, it could tweak it.
>
> > +
> > +
> >  /*
> >   * Page is mapped, now read in the page header info.
> >   */
> >
>
>
> That is, in the options, we would need to have the calc offset from the
> file (doing the sync), do:
>
>         handle->ts_offset -= start_offset.
>
> Or something like that. I'll let you look at this code and see what you
> come up with, and we can discuss this further.
>
> -- Steve

On Thu, Apr 22, 2021 at 11:25 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 16 Apr 2021 10:01:18 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > On Fri, 16 Apr 2021 09:59:08 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > >
> > > As for pr_stat(), I think we should rename it to tep_info() and tep_vinfo()
> > > that acts just like tep_warning(), except it is for informational output
> > > (stdout instead of stderr). This is similar to what the kernel has.
> > >
> > > Since tep_vwarning() takes a name, so can tep_vinfo(), and I was thinking
> > > that we should expose this string to the application.
> > >
> >
> > Oh, and we could add a tep_critical() and tep_vcritical() which means that
> > the error is something really bad happened, (like failed to allocate).
>
> Any thoughts on this?

These changes are superseded by "RFC [PATCH 0/5] tsc2nsec fixes",
where some of these suggestions are implemented.
https://lore.kernel.org/linux-trace-devel/20210428122839.805296-1-tz.stoyanov@gmail.com/




--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
