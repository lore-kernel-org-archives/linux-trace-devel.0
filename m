Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E9FC433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 16:57:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88FEA61A12
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 16:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbhCXQ5O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbhCXQ44 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 12:56:56 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F017DC061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 09:56:55 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id v186so15016519pgv.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 09:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VWb7nS771OpasVyoILfTLWi84Ybnw/u85ZjnXxj2vBc=;
        b=RgqoISj0gMmnT4zaa5sXej9LY+aA69JEXznvfsrG2x8RZRlE2wtUyzqMQE4whQjJVm
         jWwiTTmXEy8zMBSsMAE0NeZEZKM1bppMRYD50aSByp+keMNnnMx97iuTv20Zitwd9Mlw
         GgE9Jd+5CPH5G4yPvqlBXj3Umqzt4qGYzTeoZhddlLZ5TgPtr7QLICvxeK2F46xkfyKc
         ktj1cSWw0Rfqhq1SEgCDXdW5h7MSS25aGcMK2FR27o7cKYmcewqIIAxaqlrOUTVPoNmd
         IW4+zgMIdh+PxI+sF8sst8CArlI4tAVtb7bvqbEAiDn96mtnYJcG/IFOByuE6CQKqmOg
         Y6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VWb7nS771OpasVyoILfTLWi84Ybnw/u85ZjnXxj2vBc=;
        b=PQKIaHrvPEPiSuyLGsNJjEiM+Janazb7yivxG83sGdf+RqGnojQ0N3WH7uP1o8QRv6
         Al1hN9dMM8Zdz7G3vpcKt1DwHeIH5Oj4OhXBc831Y6XKw/tQGHEqgAWUM+4OsjCd5rMo
         DTl9rXwLdaa8XJCVy4TAmxWeAfrgiaRrsL6FUaOC/oYBYrQUx4ujxtuX9cVlfvyaNwTV
         8zMFk0PZDoA0KJPTk88LCF7c0Pqg8nl2X6BpA4m0c8g81VEWNxH8GW2rS/nWbdfGHJvq
         tl5FB8jvi/Bz6LLnY5udAkoYRAIzn43IxBz6c/y8MBFKrRZXZNri1BUR3hvOMU/xwGRe
         5bFQ==
X-Gm-Message-State: AOAM5337cwIUUiygzn4ZOiuS/+9l5TWKYvsGm5UKwvvxbdYCjFNookoD
        zClzIs/goToRA5Xear+4bhiuGs2bqI/ocDvUjh8eabFsu0U=
X-Google-Smtp-Source: ABdhPJzpDXwOffUvpdBouxbYk5TY3NVraJMaqCiZgWTWHRQxAfOgvp7TonUdMWxj5B9tUEonp71gDw15wucLDHnDyZc=
X-Received: by 2002:aa7:8488:0:b029:1fc:f312:b24e with SMTP id
 u8-20020aa784880000b02901fcf312b24emr3729256pfn.55.1616605015527; Wed, 24 Mar
 2021 09:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
 <20210324130418.436206-7-tz.stoyanov@gmail.com> <20210324112001.0d897bdb@gandalf.local.home>
 <CAPpZLN7ULyGkfkB4s9ygrE3OiEjWZTcyy5smfK4vd8Sxoc1TEw@mail.gmail.com> <20210324122250.50fb6f9b@gandalf.local.home>
In-Reply-To: <20210324122250.50fb6f9b@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 24 Mar 2021 18:56:39 +0200
Message-ID: <CAPpZLN60Xva=xxMr=k0kdo7OZMLcJuUCrt=eskqbybT5_rgp9A@mail.gmail.com>
Subject: Re: [PATCH v3 06/23] trace-cmd: Add new trace-cmd clock tsc2nsec
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 24, 2021 at 6:22 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 24 Mar 2021 17:38:37 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > On Wed, Mar 24, 2021 at 5:20 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> > >> > > @@ -5904,7 +5965,15 @@ static void parse_record_options(int argc,
> > > >                       break;
> > > >               case 'C':
> > > >                       check_instance_die(ctx->instance, "-C");
> > > > -                     ctx->instance->clock = optarg;
> > > > +                     if (!strncmp(optarg, TSCNSEC_CLOCK, strlen(TSCNSEC_CLOCK))) {
> > >
> > > Hmm, why the strncmp()? Shouldn't it be a full match, not a partial one?
> > >
> > > > +                             ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
> > > > +                                                &ctx->tsc2nsec.mult);
> > > > +                             if (ret || !clock_is_supported(NULL, TSC_CLOCK))
> > > > +                                     die("Clock %s is not supported", optarg);
> > > > +                             ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
> > > > +                             ctx->instance->clock = strdup(TSC_CLOCK);
> > >
> > > Hmm, why the strdup? below we have clock = optarg, one of them is wrong. If
> > > we free instance->clock, then we can't have it set to optarg. As that was
> > > the way it was before, it looks to be a separate bug that probably needs
> > > its own patch.
> >
> > Actually, instance->clock is never freed - because there is no
> > function to free an instance. There is allocate_instance(), but no API
>
> Bah, I just noticed that I was confusing this with tracefs_instance :-p
>
>
> > to free. That's why both are valid. I was wondering if to use strdup
> > or simple assignment, and decided to allocate a memory. One day we may
> > implement free_instance(), there are a lot of resources in an instance
> > that should be freed.
>
> Perhaps that "one day" should be this week ;-)

That means to implement a cleanup after each trace-cmd subcommand ?
Currently, trace-cmd just exits and not freeing that memory is not a
big problem. I was thinking many times to implement free_instance(),
but there is no sense for it if there is no cleanup logic at the end
of each command.

>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
