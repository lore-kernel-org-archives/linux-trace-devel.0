Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BAF1C61DA4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Feb 2023 00:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbjBOAhC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Feb 2023 19:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjBOAhB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Feb 2023 19:37:01 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C56E23D84
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Feb 2023 16:37:00 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b5so18729907plz.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Feb 2023 16:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xKJm0K/vS4jL2dzM+V14MocHPNUjvECWcmwue/mHpi0=;
        b=Rm51QBZix76ZWrVUcyCG2Jy7JxJ1sJ5R8FmYl/LLfL0ylBuiUWBy8/11a72biGWVuT
         dOQB+FkDk3VDcqdup8pRI3N7NKFiIBVumcBGVkEBZJuP1mb2V/rnzonJg86Wkt2SSCT9
         VNaoKpFRiiB/TqaD2+QiAlLZ0emtTYL7FZ3cE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xKJm0K/vS4jL2dzM+V14MocHPNUjvECWcmwue/mHpi0=;
        b=XBt+cXP80FTq1xIe1yww6OeEUO+VAwrb0MY7eGBpz1c9aDCx1Ytr9ILQ6c3MJXmeTF
         PHV8iUzb6rJazH7sRDMksPlkwQ3Ii7haDYZj1kHhkgAak6omUsXSGs8Nr4XCd/JFX1hH
         Xm++vaT9/2TsElLcLtKRlBbMRqx41I9II24ltbJA5z6eU2vboMTAuF5b+b09+PMA0S9y
         NrtQf2Nrk401itRVjindNKQSBnpILx9yNpz5CKipv3HfwcVIxl/uBPfkHV21WIL7NumV
         XUqGxsfQYSJmm/2NpJOyzKQJE4/FbwTCMD3k2ep0U+2/9+wkqBFpLqQX2BfRkydtFfrq
         CTpg==
X-Gm-Message-State: AO0yUKXZz1F5qXHKE1YdioIYRqk4rPMFKst6RCPs8eS4MwXfNmb1qTkf
        tXpVp6dEVlx7QuVI1TDyzbRsyR8xWY2y7HB8
X-Google-Smtp-Source: AK7set9jsc2OCyb+RySe07IS/co994650/LAbpld2doWg6cSLxDILUoMUeTNZ1nSDhZ4br1GczMTHg==
X-Received: by 2002:a17:902:f541:b0:199:564a:9936 with SMTP id h1-20020a170902f54100b00199564a9936mr607525plf.25.1676421419615;
        Tue, 14 Feb 2023 16:36:59 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:9782:aebc:580a:c8d8])
        by smtp.gmail.com with ESMTPSA id l3-20020a170903120300b00186c3afb49esm10755153plh.209.2023.02.14.16.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 16:36:59 -0800 (PST)
Date:   Wed, 15 Feb 2023 09:36:56 +0900
From:   Hidenori Kobayashi <hidenorik@chromium.org>
To:     Douglas Raillard <douglas.raillard@arm.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@goodmis.org, Nikita Baksalyar <nikita.baksalyar@gmail.com>
Subject: Re: libtraceevent + Rust
Message-ID: <20230215003656.myopnnfdgmmck7dg@google.com>
References: <96dc3f67-5405-c1a4-7c94-a98de3085cc5@arm.com>
 <20230213051727.hvkd5wgqhxi66gqh@google.com>
 <35fe67d1-0865-486f-bdbe-5eb8e034352d@arm.com>
 <20230214035657.4nz5tyirzfmvcxuq@google.com>
 <2c1381a6-164d-fc5c-fd69-653d69604c50@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c1381a6-164d-fc5c-fd69-653d69604c50@arm.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Douglas,

On Tue, Feb 14, 2023 at 10:38:52AM +0000, Douglas Raillard wrote:
> On 14-02-2023 03:56, Hidenori Kobayashi wrote:
> > Hi Douglas,
> > 
> > On Mon, Feb 13, 2023 at 12:04:36PM +0000, Douglas Raillard wrote:
> > > Hi Hidenori,
> > > 
> > > > On 13-02-2023 05:17, Hidenori Kobayashi wrote:
> > > > Hi Douglas,
> > > > 
> > > > On Fri, Oct 14, 2022 at 04:16:33PM +0100, Douglas Raillard wrote:
> > > > > Hi everyone,
> > > > > 
> > > > > The idea of having some Rust interop for libtraceevent was floated during the
> > > > > Tracing Summit that took place this week.
> > > > > 
> > > > > The overall work has two scopes:
> > > > >       1. libtraceevent: low-level helpers to decode event formats and binary buffer pages.
> > > > >       2. high level API that e.g. can consume a trace.dat file and expose an iterator API etc.
> > > > > 
> > > > > The current discussion is only about #1. The 2nd part of the work has an
> > > > > entirely different set of constraints as it would aim at integrating in the
> > > > > Rust ecosystem as well as possible without trying to replace anything
> > > > > pre-existent.
> > > > Has anyone actually started working on these?
> > > 
> > > We have, this has been my main focus since around November.
> > > 
> > > > 
> > > > I have a Rust tool that parses the output from trace-cmd to infer the
> > > > internal states of a kernel module. While it serves our needs for now,
> > > > Steven kindly pointed me to this thread and suggested interacting
> > > > directly with the tracefs and using the tracefs libraries for parsing.
> > > > 
> > > > So I'd like to know:
> > > > - if this discussion reached a consensus
> > > 
> > > You are the first one to answer on that thread but the twitter poll from Steven was encouraging. At any
> > > rate, we need it for LISA [1] so I'm making it happen.
> > > 
> > > > - if there is any publicly available work already
> > > 
> > > Yes and no: I'm currently developing it as part of LISA but in its own "traceevent" crate,
> > > as added by that PR under tools/analysis/traceevent/:
> > > https://github.com/ARM-software/lisa/pull/1843
> > 
> > Thanks! Let me take a look.
> > 
> > Do you intend to keep this inside the LISA project repository?
> > 
> > The LISA project per se is interesting, but I feel your work is also
> > valuable for other projects. Is there any chance that this becomes a
> > standalone crate?
> 
> Yes, LISA is not necessarily the final location of that piece of code. I've made it
> as a separate crate from the other Rust bits so it can be split effortlessly when the time comes.
 
Looking forward to the upcoming announcement!

> > 
> > > This is very much WIP, so far I got:
> > > * A parser for v6 header up to and including the event formats.
> > >    Since that requires a C parser, it was a large chunk of the total work.
> > > * A C interpreter as (somewhat) required for array lengths and mostly for the print fmt args.
> > > * a zero-copy I/O layer that can load data from:
> > > 	* existing in-memory buffer
> > > 	* Any type implementing Read + Seek
> > > 	* mmap
> > > 
> > > Adding support for v7 header should be straightforward except for the I/O that might require adjustment
> > > depending on how compression is implemented.
> > > 
> > > 
> > > My current roadmap is:
> > > 1. Get to a state where I can share a trace-cmd report equivalent static tool for people to play with on
> > >     their own data and report issues.
> > > 2. Make a serde backend hooked to it since we need it for LISA (assuming performance is good enough)
> > > 3. Figure out exactly how it sits in the libtraceevent ecosystem and maintains it in the
> > >     long run, libtraceevent-style C bindings etc.
> > > 
> > > Note that if and when a serde backend is available, that should bring a conversion to JSON for basically free.
> > > 
> > > Unless I'm sidetracked by urgent things, 1. and 2. should become available in a few months. I expect 3. to happen
> > > when I have something concrete to show to the world.
> > > 
> > > [1] LISA: https://github.com/ARM-software/lisa
> > > > 
> > > > Thanks,
> > > > Hidenori
> > > 
> > > Thanks,
> > > 
> > > Douglas
> > 
> > Thanks,
> > Hidenori
> 
