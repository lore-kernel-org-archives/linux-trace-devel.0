Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 865CBC636D4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Feb 2023 12:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjBMMGT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Feb 2023 07:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjBMMGJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Feb 2023 07:06:09 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CCB74C1C
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Feb 2023 04:05:48 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 683F94B3;
        Mon, 13 Feb 2023 04:05:20 -0800 (PST)
Received: from [10.57.16.179] (unknown [10.57.16.179])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C142B3F703;
        Mon, 13 Feb 2023 04:04:36 -0800 (PST)
Message-ID: <35fe67d1-0865-486f-bdbe-5eb8e034352d@arm.com>
Date:   Mon, 13 Feb 2023 12:04:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: libtraceevent + Rust
To:     Hidenori Kobayashi <hidenorik@chromium.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        rostedt@goodmis.org, Nikita Baksalyar <nikita.baksalyar@gmail.com>
References: <96dc3f67-5405-c1a4-7c94-a98de3085cc5@arm.com>
 <20230213051727.hvkd5wgqhxi66gqh@google.com>
Content-Language: en-US
From:   Douglas Raillard <douglas.raillard@arm.com>
In-Reply-To: <20230213051727.hvkd5wgqhxi66gqh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Hidenori,

> On 13-02-2023 05:17, Hidenori Kobayashi wrote:
> Hi Douglas,
> 
> On Fri, Oct 14, 2022 at 04:16:33PM +0100, Douglas Raillard wrote:
>> Hi everyone,
>>
>> The idea of having some Rust interop for libtraceevent was floated during the
>> Tracing Summit that took place this week.
>>
>> The overall work has two scopes:
>>      1. libtraceevent: low-level helpers to decode event formats and binary buffer pages.
>>      2. high level API that e.g. can consume a trace.dat file and expose an iterator API etc.
>>
>> The current discussion is only about #1. The 2nd part of the work has an
>> entirely different set of constraints as it would aim at integrating in the
>> Rust ecosystem as well as possible without trying to replace anything
>> pre-existent.
>   
> Has anyone actually started working on these?

We have, this has been my main focus since around November.

> 
> I have a Rust tool that parses the output from trace-cmd to infer the
> internal states of a kernel module. While it serves our needs for now,
> Steven kindly pointed me to this thread and suggested interacting
> directly with the tracefs and using the tracefs libraries for parsing.
> 
> So I'd like to know:
> - if this discussion reached a consensus

You are the first one to answer on that thread but the twitter poll from Steven was encouraging. At any
rate, we need it for LISA [1] so I'm making it happen.

> - if there is any publicly available work already

Yes and no: I'm currently developing it as part of LISA but in its own "traceevent" crate,
as added by that PR under tools/analysis/traceevent/:
https://github.com/ARM-software/lisa/pull/1843

This is very much WIP, so far I got:
* A parser for v6 header up to and including the event formats.
   Since that requires a C parser, it was a large chunk of the total work.
* A C interpreter as (somewhat) required for array lengths and mostly for the print fmt args.
* a zero-copy I/O layer that can load data from:
	* existing in-memory buffer
	* Any type implementing Read + Seek
	* mmap

Adding support for v7 header should be straightforward except for the I/O that might require adjustment
depending on how compression is implemented.


My current roadmap is:
1. Get to a state where I can share a trace-cmd report equivalent static tool for people to play with on
    their own data and report issues.
2. Make a serde backend hooked to it since we need it for LISA (assuming performance is good enough)
3. Figure out exactly how it sits in the libtraceevent ecosystem and maintains it in the
    long run, libtraceevent-style C bindings etc.

Note that if and when a serde backend is available, that should bring a conversion to JSON for basically free.

Unless I'm sidetracked by urgent things, 1. and 2. should become available in a few months. I expect 3. to happen
when I have something concrete to show to the world.

[1] LISA: https://github.com/ARM-software/lisa
> 
> Thanks,
> Hidenori

Thanks,

Douglas
