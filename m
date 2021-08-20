Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C16C41537
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 20:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D15FD6115B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Aug 2021 20:47:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240027AbhHTUsX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Aug 2021 16:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230282AbhHTUsV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Aug 2021 16:48:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9A4E61042;
        Fri, 20 Aug 2021 20:47:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mHBQT-004qNT-La; Fri, 20 Aug 2021 16:47:41 -0400
Message-ID: <20210820204644.546662591@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 20 Aug 2021 16:46:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: [PATCH v9 0/6] tracing: Creation of event probe
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


V8 Link: https://lore.kernel.org/linux-trace-devel/20210819152604.704335282@goodmis.org/

Changes from v8:

Found and fixed a bug in the selftests that check the README file.
I was testing that requirement with eprobes, and found that it was not
flagging it as not added. Found the reason, and fixed it.

Changed the selftest for add/remove of the eprobe to just add test
and remove it.

Moved the selftest that added a eprobe to a synthetic event into the trigger
tests.

Have the "testing duplicate" not test kprobes if kprobes are not configured
in.

Steven Rostedt (VMware) (5):
      selftests/ftrace: Add clear_dynamic_events() to test cases
      selftests/ftrace: Fix requirement check of README file
      selftests/ftrace: Add test case to test adding and removing of event probe
      selftests/ftrace: Add selftest for testing eprobe events on synthetic events
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
 kernel/trace/trace_kprobe.c                        |   8 -
 kernel/trace/trace_probe.c                         |  16 +-
 kernel/trace/trace_probe.h                         |   6 +-
 .../ftrace/test.d/dynevent/add_remove_eprobe.tc    |  40 +
 .../ftrace/test.d/dynevent/test_duplicates.tc      |  38 +
 tools/testing/selftests/ftrace/test.d/functions    |  24 +-
 .../inter-event/trigger-synthetic-eprobe.tc        |  53 ++
 13 files changed, 1116 insertions(+), 14 deletions(-)
 create mode 100644 kernel/trace/trace_eprobe.c
 create mode 100644 tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/dynevent/test_duplicates.tc
 create mode 100644 tools/testing/selftests/ftrace/test.d/trigger/inter-event/trigger-synthetic-eprobe.tc
