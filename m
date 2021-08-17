Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C6EC4320E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 03:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCEC060EB5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 03:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237334AbhHQDvD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233889AbhHQDvB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 23:51:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C7F960EB5;
        Tue, 17 Aug 2021 03:50:28 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mFq7O-004OJQ-TR; Mon, 16 Aug 2021 23:50:26 -0400
Message-ID: <20210817034255.421910614@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 16 Aug 2021 23:42:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 0/7] tracing: Creation of event probe
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a patch series that adds the event probe feature and tries to
incorporate all of Masami's comments.

While updating Tzvetomir's patch, I found some other things that could be
changed as well, and some was added as extra patches.

For instance, removing the customize struct size macros from kprobe and
uprobe events and using the struct_size() macro.

To implement "REC->type" and show the event type for the trace event, the
traceprobe_set_print_fmt() needed to be updated to allow for that.

Instead of allocating a temp buffer that traceprobe_parse_probe_arg() can
manipulate, just have that function do the allocation instead of placing the
burden onto the callers.

Anyway, here's version 6!

-- Steve


Steven Rostedt (VMware) (6):
      tracing: Add DYNAMIC flag for dynamic events
      tracing: Have dynamic events have a ref counter
      tracing/probe: Have traceprobe_parse_probe_arg() take a const arg
      tracing/probes: Allow for dot delimiter as well as slash for system names
      tracing/probes: Use struct_size() instead of defining custom macros
      tracing/probe: Change traceprobe_set_print_fmt() to take a type

Tzvetomir Stoyanov (VMware) (1):
      tracing: Add a probe that attaches to trace events

----
 include/linux/trace_events.h        |  52 ++-
 kernel/trace/Makefile               |   1 +
 kernel/trace/trace.c                |   4 +-
 kernel/trace/trace.h                |  18 +
 kernel/trace/trace_dynevent.c       |  38 ++
 kernel/trace/trace_dynevent.h       |   4 +-
 kernel/trace/trace_eprobe.c         | 895 ++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_event_perf.c     |   6 +-
 kernel/trace/trace_events.c         |  22 +-
 kernel/trace/trace_events_synth.c   |  21 +-
 kernel/trace/trace_events_trigger.c |  20 +-
 kernel/trace/trace_kprobe.c         |  43 +-
 kernel/trace/trace_probe.c          |  81 ++--
 kernel/trace/trace_probe.h          |  15 +-
 kernel/trace/trace_probe_tmpl.h     |   6 +-
 kernel/trace/trace_uprobe.c         |  34 +-
 16 files changed, 1156 insertions(+), 104 deletions(-)
 create mode 100644 kernel/trace/trace_eprobe.c
