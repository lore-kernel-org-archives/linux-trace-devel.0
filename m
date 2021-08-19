Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF33C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 15:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFE78610D2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 15:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240384AbhHSP3D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 11:29:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240051AbhHSP3C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 11:29:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64C5A61029;
        Thu, 19 Aug 2021 15:28:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mGjxw-004he6-Tc; Thu, 19 Aug 2021 11:28:24 -0400
Message-ID: <20210819152604.704335282@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 19 Aug 2021 11:26:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: [PATCH v8 0/5] tracing: Creation of event probe
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

V7 Link: https://lore.kernel.org/linux-trace-devel/20210819041321.105110033@goodmis.org/

Changes from v7:

I moved the patches that have been acked by Masami into my linux-next queue
and removed them from this patch series.

I added Masami's patch to check for duplicate events and return a proper
error message about the duplication.

I changed the duplication check in the eprobe code to match Masami's
changes.

I fixed a bug in the removing of dynamic events in the selftest code.

Added a new test to make sure the duplicate events are caught.


Masami Hiramatsu (1):
      tracing/probes: Reject events which have the same name of existing one

Steven Rostedt (VMware) (3):
      selftests/ftrace: Add clear_dynamic_events() to test cases
      selftests/ftrace: Add selftest for testing eprobe events
      selftests/ftrace: Add selftest for testing duplicate eprobes and kprobes

Tzvetomir Stoyanov (VMware) (1):
      tracing: Add a probe that attaches to trace events

----
 include/linux/trace_events.h                       |   4 +
 kernel/trace/Makefile                              |   1 +
 kernel/trace/trace.c                               |   5 +-
 kernel/trace/trace.h                               |  18 +
 kernel/trace/trace_eprobe.c                        | 903 +++++++++++++++++++++
 kernel/trace/trace_events_trigger.c                |  14 +-
 kernel/trace/trace_kprobe.c                        |  14 +-
 kernel/trace/trace_probe.c                         |  41 +-
 kernel/trace/trace_probe.h                         |   7 +-
 kernel/trace/trace_uprobe.c                        |   6 +-
 .../ftrace/test.d/dynevent/add_remove_eprobe.tc    |  53 ++
 .../ftrace/test.d/dynevent/test_duplicates.tc      |  28 +
 tools/testing/selftests/ftrace/test.d/functions    |  22 +
 13 files changed, 1101 insertions(+), 15 deletions(-)
 create mode 100644 kernel/trace/trace_eprobe.c
 create mode 100644 tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/dynevent/test_duplicates.tc
