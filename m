Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4D3C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 03:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE9E664EDA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Feb 2021 03:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhBSDx6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Feb 2021 22:53:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhBSDx5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Feb 2021 22:53:57 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7382464ED9;
        Fri, 19 Feb 2021 03:53:16 +0000 (UTC)
Date:   Thu, 18 Feb 2021 22:53:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 5/5] [WIP] trace-cmd: Add new subcomand "trace-cmd perf"
Message-ID: <20210218225314.76166422@oasis.local.home>
In-Reply-To: <20210218210352.61470b93@oasis.local.home>
References: <20201203060226.476475-1-tz.stoyanov@gmail.com>
        <20201203060226.476475-6-tz.stoyanov@gmail.com>
        <20210218210352.61470b93@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 18 Feb 2021 21:03:52 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Hence, we can use x86-tsc as the clock for both the host and guest, and
> then using perf find out how to convert that to what the 'local' clock
> would produce. At least the multiplier and the shfit.

I just tried this out:

 http://rostedt.org/private/perf-trace.c

Where I did:

 # trace-cmd record -M 1 -C local -e irq -e sched taskset -c 0 ./perf-trace
time_shift=31
time_mult=633046315
time_offset=-125757047487632
 # trace-cmd report |grep print         taskset-34857 [000] 125742.260276: print:                tracing_mark_write: [426606557411358] [125757.283123254] - <idle>-0 [0] softirq_raise: vec=9 [action=RCU]
         taskset-34857 [000] 125742.260283: print:                tracing_mark_write: [426606557431758] [125757.283129268] - <idle>-0 [0] softirq_entry: vec=9 [action=RCU]
         taskset-34857 [000] 125742.260289: print:                tracing_mark_write: [426606557580560] [125757.283173133] - <idle>-0 [0] softirq_exit: vec=9 [action=RCU]
         taskset-34857 [000] 125742.260295: print:                tracing_mark_write: [426606560784758] [125757.284117683] - <idle>-0 [0] softirq_raise: vec=7 [action=SCHED]

The time offset is slightly different, but we don't care. We only want
to convert the cycles into nanoseconds, and this appears to do the job!

-- Steve
