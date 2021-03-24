Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A016DC433C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 16:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A08361A01
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 16:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhCXQXO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:23:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234076AbhCXQWw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 12:22:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA2CA619C0;
        Wed, 24 Mar 2021 16:22:51 +0000 (UTC)
Date:   Wed, 24 Mar 2021 12:22:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 06/23] trace-cmd: Add new trace-cmd clock tsc2nsec
Message-ID: <20210324122250.50fb6f9b@gandalf.local.home>
In-Reply-To: <CAPpZLN7ULyGkfkB4s9ygrE3OiEjWZTcyy5smfK4vd8Sxoc1TEw@mail.gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
        <20210324130418.436206-7-tz.stoyanov@gmail.com>
        <20210324112001.0d897bdb@gandalf.local.home>
        <CAPpZLN7ULyGkfkB4s9ygrE3OiEjWZTcyy5smfK4vd8Sxoc1TEw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Mar 2021 17:38:37 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Wed, Mar 24, 2021 at 5:20 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >> > > @@ -5904,7 +5965,15 @@ static void parse_record_options(int argc,
> > >                       break;
> > >               case 'C':
> > >                       check_instance_die(ctx->instance, "-C");
> > > -                     ctx->instance->clock = optarg;
> > > +                     if (!strncmp(optarg, TSCNSEC_CLOCK, strlen(TSCNSEC_CLOCK))) {  
> >
> > Hmm, why the strncmp()? Shouldn't it be a full match, not a partial one?
> >  
> > > +                             ret = get_tsc_nsec(&ctx->tsc2nsec.shift,
> > > +                                                &ctx->tsc2nsec.mult);
> > > +                             if (ret || !clock_is_supported(NULL, TSC_CLOCK))
> > > +                                     die("Clock %s is not supported", optarg);
> > > +                             ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
> > > +                             ctx->instance->clock = strdup(TSC_CLOCK);  
> >
> > Hmm, why the strdup? below we have clock = optarg, one of them is wrong. If
> > we free instance->clock, then we can't have it set to optarg. As that was
> > the way it was before, it looks to be a separate bug that probably needs
> > its own patch.  
> 
> Actually, instance->clock is never freed - because there is no
> function to free an instance. There is allocate_instance(), but no API

Bah, I just noticed that I was confusing this with tracefs_instance :-p


> to free. That's why both are valid. I was wondering if to use strdup
> or simple assignment, and decided to allocate a memory. One day we may
> implement free_instance(), there are a lot of resources in an instance
> that should be freed.

Perhaps that "one day" should be this week ;-)

-- Steve
