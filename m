Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8716AC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 16:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CF1764F07
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Feb 2021 16:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhBXQz5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:55:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:45644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235778AbhBXQyw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 11:54:52 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ADF264F03;
        Wed, 24 Feb 2021 16:54:10 +0000 (UTC)
Date:   Wed, 24 Feb 2021 11:54:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Viktor Rosendahl <Viktor.Rosendahl@bmw.de>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Adding latency tracking to trace-cmd
Message-ID: <20210224115408.1c76ee3f@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Viktor,

While doing some tests to trace-cmd, I found that the trace-cmd record was
broken for latency tracers, and has been for some time. That's probably
because nobody has been using it for such.

That is, trace-cmd record is mostly used for "flyrecord" which is the
constant recording of tracing. But if the user records one of the latency
tracers (preemptirqsoff, wakeup_rt, etc), then it switches to "latency"
mode and only takes a snapshot at the end of the recording. This is what I
found to be broken, because it reset the tracing before taking the
snapshot and lost whatever it was recording. Nobody seemed to complain
about it, so I guess nobody cared.

The fix is simple, and I was about to do so, but then I thought about your
latency-collector tool, and thought that should be exactly what trace-cmd
should do for such tracers. That is, instead of just taking a snapshot of
the latency at the end of the recording (which it was suppose to do now),
it should act like your latency-collector tool, and take snapshots
every time there's a new latency.

My question to you is, would you like to work on adding that feature to
trace-cmd?

  git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git

(which requires the libtracefs and libtracevent libraries).

I'm thinking if someone were to do:

 trace-cmd record -p wakeup_rt 

It would then act just like the latency-collector and record every new
instance of a latency into the trace.dat file, where:

 trace-cmd report

would then nicely format that data for the user.

Thoughts?

-- Steve
