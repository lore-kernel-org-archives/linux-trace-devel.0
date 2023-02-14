Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C82F7C61DA4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Feb 2023 03:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjBND5D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Feb 2023 22:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBND5C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Feb 2023 22:57:02 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEE713D64
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Feb 2023 19:57:00 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id bt14so2504206pfb.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Feb 2023 19:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9KljKV71DcJi7xc6MNMS1mS7MUtPxdLW1GgHlGiJm8w=;
        b=FHq1rER+pD78ecrwg+F77noGHlQGG4rnSOElDPQwyixWmM8Mfd/Uqfq6pR+/9f6uVl
         YFnmTn197RGaJ/C7jFAmLk41WIWF3q7CqKi7a6jBQCWAt/fHVeboXhXjLB3tfQEUqskr
         AwbbOFVZ6eQ0puKG2grP89p0AZTaGu12UPhM8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9KljKV71DcJi7xc6MNMS1mS7MUtPxdLW1GgHlGiJm8w=;
        b=zgA2ZqEbNBsxouwwHWJasBfOa6wFqYFVzIURiJ5WmAIpwLLCePpIz5C6TckGq2SjTb
         AKBktG1LJA86f+ianltk9jQsoRzdgi+MlJtSsqkixoRq+OZO/dyamWbpbdJXs5YocBNw
         4nORtOeggU7+o68eo8GyionM6qNXsytpRvc9by56zHa+QCJpLQ97X7sYlqyM5L3vaD1n
         xia4Ftk26n+Jnihs6oTcAAT732M0dW2JruSCpjfkqu3kKG1t2SsEhuvjsJDzKaZEN/rR
         VHdt/502PNfIvCuHUogFByAXETsEc2vFELapVuYlAShWw0Wo7VIZtnYQ6PqzqhyXHOVr
         BUmw==
X-Gm-Message-State: AO0yUKW1lP3YceJjCgb/fxzJctKofAuSJTT1dRCLV8ZPabXP5O2F3A9B
        Aez0Pe5uegdEoz/hyzLOLXIkOg==
X-Google-Smtp-Source: AK7set9c6t6uVZwH2oozSCf+wGItACDWJj9o+FA5goRFEoq3xaSxoLWJfagiY+QAzV0nYy/ZMxDN4A==
X-Received: by 2002:aa7:8bdb:0:b0:5a8:52d5:3bb9 with SMTP id s27-20020aa78bdb000000b005a852d53bb9mr845822pfd.10.1676347020412;
        Mon, 13 Feb 2023 19:57:00 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:9782:aebc:580a:c8d8])
        by smtp.gmail.com with ESMTPSA id y21-20020aa78555000000b0058d9058fe8asm4695259pfn.103.2023.02.13.19.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 19:56:59 -0800 (PST)
Date:   Tue, 14 Feb 2023 12:56:57 +0900
From:   Hidenori Kobayashi <hidenorik@chromium.org>
To:     Douglas Raillard <douglas.raillard@arm.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@goodmis.org, Nikita Baksalyar <nikita.baksalyar@gmail.com>
Subject: Re: libtraceevent + Rust
Message-ID: <20230214035657.4nz5tyirzfmvcxuq@google.com>
References: <96dc3f67-5405-c1a4-7c94-a98de3085cc5@arm.com>
 <20230213051727.hvkd5wgqhxi66gqh@google.com>
 <35fe67d1-0865-486f-bdbe-5eb8e034352d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35fe67d1-0865-486f-bdbe-5eb8e034352d@arm.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Douglas,

On Mon, Feb 13, 2023 at 12:04:36PM +0000, Douglas Raillard wrote:
> Hi Hidenori,
> 
> > On 13-02-2023 05:17, Hidenori Kobayashi wrote:
> > Hi Douglas,
> > 
> > On Fri, Oct 14, 2022 at 04:16:33PM +0100, Douglas Raillard wrote:
> > > Hi everyone,
> > > 
> > > The idea of having some Rust interop for libtraceevent was floated during the
> > > Tracing Summit that took place this week.
> > > 
> > > The overall work has two scopes:
> > >      1. libtraceevent: low-level helpers to decode event formats and binary buffer pages.
> > >      2. high level API that e.g. can consume a trace.dat file and expose an iterator API etc.
> > > 
> > > The current discussion is only about #1. The 2nd part of the work has an
> > > entirely different set of constraints as it would aim at integrating in the
> > > Rust ecosystem as well as possible without trying to replace anything
> > > pre-existent.
> > Has anyone actually started working on these?
> 
> We have, this has been my main focus since around November.
> 
> > 
> > I have a Rust tool that parses the output from trace-cmd to infer the
> > internal states of a kernel module. While it serves our needs for now,
> > Steven kindly pointed me to this thread and suggested interacting
> > directly with the tracefs and using the tracefs libraries for parsing.
> > 
> > So I'd like to know:
> > - if this discussion reached a consensus
> 
> You are the first one to answer on that thread but the twitter poll from Steven was encouraging. At any
> rate, we need it for LISA [1] so I'm making it happen.
> 
> > - if there is any publicly available work already
> 
> Yes and no: I'm currently developing it as part of LISA but in its own "traceevent" crate,
> as added by that PR under tools/analysis/traceevent/:
> https://github.com/ARM-software/lisa/pull/1843

Thanks! Let me take a look.

Do you intend to keep this inside the LISA project repository?

The LISA project per se is interesting, but I feel your work is also
valuable for other projects. Is there any chance that this becomes a
standalone crate?

> This is very much WIP, so far I got:
> * A parser for v6 header up to and including the event formats.
>   Since that requires a C parser, it was a large chunk of the total work.
> * A C interpreter as (somewhat) required for array lengths and mostly for the print fmt args.
> * a zero-copy I/O layer that can load data from:
> 	* existing in-memory buffer
> 	* Any type implementing Read + Seek
> 	* mmap
> 
> Adding support for v7 header should be straightforward except for the I/O that might require adjustment
> depending on how compression is implemented.
> 
> 
> My current roadmap is:
> 1. Get to a state where I can share a trace-cmd report equivalent static tool for people to play with on
>    their own data and report issues.
> 2. Make a serde backend hooked to it since we need it for LISA (assuming performance is good enough)
> 3. Figure out exactly how it sits in the libtraceevent ecosystem and maintains it in the
>    long run, libtraceevent-style C bindings etc.
> 
> Note that if and when a serde backend is available, that should bring a conversion to JSON for basically free.
> 
> Unless I'm sidetracked by urgent things, 1. and 2. should become available in a few months. I expect 3. to happen
> when I have something concrete to show to the world.
> 
> [1] LISA: https://github.com/ARM-software/lisa
> > 
> > Thanks,
> > Hidenori
> 
> Thanks,
> 
> Douglas

Thanks,
Hidenori
