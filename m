Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B02C636C8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Jul 2021 03:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90200613E6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Jul 2021 03:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbhGPDeq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Jul 2021 23:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231230AbhGPDep (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Jul 2021 23:34:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 001C7613E6;
        Fri, 16 Jul 2021 03:31:50 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1m4EZp-000vD6-Q3; Thu, 15 Jul 2021 23:31:49 -0400
Message-ID: <20210716032632.272262604@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 15 Jul 2021 23:26:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: [PATCH 0/2] tracing: addition of event probe
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Tzvetomir,

Here's the updates to your patch. the first patch is your WIP that I forward
ported to the latest kernel. The second patches is my hacks to hook with the
triggers. It's still buggy and needs a bit of work (as we talked about).

I'll comment in the code. Please just merge the two patches together, and
fix them up to a proper patch that we can send to LKML in a week or two.

Tom, I Cc'd you because I wanted you to see where we are at, and because I
mentioned this work with the fix I sent to Linus (removing 'char *' as a
string for histograms). If you apply that patch, and these two, you can play
with it a little, but it is buggy. It's not even in a "RFC" level yet.
Thus, I'm Cc'ing you as more of an FYI than to ask you to review the
patches. There's more work to be done.

I'll reply to this patch set stating some of the know issues.


Steven Rostedt (VMware) (1):
      tracing: Update to the event probes

Tzvetomir (VMware) Stoyanov (1):
      Add new kprobe on tracepoint

----
 include/linux/kprobes.h      |  13 ++
 include/linux/trace_events.h |   4 +
 kernel/trace/trace.h         |   5 +
 kernel/trace/trace_kprobe.c  | 521 +++++++++++++++++++++++++++++++++++++++++--
 kernel/trace/trace_probe.c   |  25 ++-
 kernel/trace/trace_probe.h   |   7 +-
 kernel/trace/trace_uprobe.c  |   2 +-
 7 files changed, 554 insertions(+), 23 deletions(-)
