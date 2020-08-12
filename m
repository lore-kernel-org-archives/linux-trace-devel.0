Return-Path: <SRS0=GzmE=BW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7CEC433DF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Aug 2020 00:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FFD320782
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Aug 2020 00:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgHLAyO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Aug 2020 20:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLAyN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Aug 2020 20:54:13 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08D2D20782;
        Wed, 12 Aug 2020 00:54:12 +0000 (UTC)
Date:   Tue, 11 Aug 2020 20:54:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ahmed Zaki <anzaki@gmail.com>
Cc:     inux-trace-users@vger.kernel.org, linux-trace-devel@vger.kernel.org
Subject: Re: function_profile_enabled not showing Time info
Message-ID: <20200811205411.2f7748ac@oasis.local.home>
In-Reply-To: <CANczwAGy1tQe1yhgnwhfStGCfh4iFvMei_AqPEvTbLmmPBWatg@mail.gmail.com>
References: <CANczwAGy1tQe1yhgnwhfStGCfh4iFvMei_AqPEvTbLmmPBWatg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 12 Aug 2020 00:35:24 +0200
Ahmed Zaki <anzaki@gmail.com> wrote:

> Hello,
> 
> I am trying to use function_profile_enabled on a MIPS machine but only
> the HITS column is showing numbers. Time and Avg are showing all
> Zeros.

What clock are you using?

 cat /sys/kernel/debug/tracing/trace_clock

And also supply the dmesg output, so I can see if there's an issue with
the clock being used.

-- Steve


> 
> This is my .config file:
> 
> CONFIG_FTRACE=y
> CONFIG_FUNCTION_TRACER=y
> CONFIG_FUNCTION_GRAPH_TRACER=y
> CONFIG_IRQSOFF_TRACER=y
> CONFIG_SCHED_TRACER=y
> CONFIG_DYNAMIC_FTRACE=y
> 
> Am I missing something?
> 
> Thanks.

