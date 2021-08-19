Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D48C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C157A6113C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 04:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhHSETS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 00:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhHSETS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 00:19:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6214C610E6;
        Thu, 19 Aug 2021 04:18:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mGZVp-004duh-4J; Thu, 19 Aug 2021 00:18:41 -0400
Message-ID: <20210819041321.105110033@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 19 Aug 2021 00:13:21 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Tzvetomir Stoyanov" <tz.stoyanov@gmail.com>,
        Tom Zanussi <zanussi@kernel.org>
Subject: [PATCH v7 00/10] tracing: Creation of event probe
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The first 5 patches of this series has had Masami's updates as well as his
acks, and will no longer be in future series, as I'll be pushing them into
my linux-next queue.

Patch 6 received an ack from Masami, but I updated it, by pulling more out
of the old patch 7 and into that patch, adding more of the enum logic into
the internal processing of the set_print_fmt() code. This way, it adds the
switch statement, such that the addition of the eprobe only needs to add a
new case.

I pulled out the code from the old patch 7 that converts the parameter for
process_fetch_insn() regs into a void pointer called rec. I figured that
should be a separate patch as it's more set up for the eprobe code, then
having to do with the eprobe code itself.

For the eprobe code, I incorporated more of Masami's comments as well as
found some minor bugs. Those updates were:

Masami's suggestions:

 - Remove "return" for void function calls in trace_event_put_ref()
 - Used bit mask over checking separate bits of flags one at a time.
 - Check for duplicate eprobes.

Fixes:

 - Check for NULL pointer for probe_cleanup as there was an error path that
   could call it with a NULL pointer.
 - Check on create that it's for an eprobe (check for 'e'). Was breaking
   updates to kprobes and uprobes that were added by dynamic_events.
 - Add paranoid check of by enum to print_fmt call.
 - Fixed error_log ^ index handling

Other updates:

 - Updated the README to include eprobes
 - Added clear_dynamic_events() to selftests, to remove them even when
   there's a dependency between them.
 - Added a selftest to test the eprobes.


Steven Rostedt (VMware) (9):
      tracing: Add DYNAMIC flag for dynamic events
      tracing: Have dynamic events have a ref counter
      tracing/probe: Have traceprobe_parse_probe_arg() take a const arg
      tracing/probes: Allow for dot delimiter as well as slash for system names
      tracing/probes: Use struct_size() instead of defining custom macros
      tracing/probe: Change traceprobe_set_print_fmt() to take a type
      tracing/probes: Have process_fetch_insn() take a void * instead of pt_regs
      selftests/ftrace: Add clear_dynamic_events() to test cases
      selftests/ftrace: Add selftest for testing eprobe events

Tzvetomir Stoyanov (VMware) (1):
      tracing: Add a probe that attaches to trace events

----
 include/linux/trace_events.h                       |  52 +-
 kernel/trace/Makefile                              |   1 +
 kernel/trace/trace.c                               |   9 +-
 kernel/trace/trace.h                               |  18 +
 kernel/trace/trace_dynevent.c                      |  38 +
 kernel/trace/trace_dynevent.h                      |   4 +-
 kernel/trace/trace_eprobe.c                        | 932 +++++++++++++++++++++
 kernel/trace/trace_event_perf.c                    |   6 +-
 kernel/trace/trace_events.c                        |  22 +-
 kernel/trace/trace_events_synth.c                  |  21 +-
 kernel/trace/trace_events_trigger.c                |  20 +-
 kernel/trace/trace_kprobe.c                        |  43 +-
 kernel/trace/trace_probe.c                         |  84 +-
 kernel/trace/trace_probe.h                         |  15 +-
 kernel/trace/trace_probe_tmpl.h                    |   6 +-
 kernel/trace/trace_uprobe.c                        |  34 +-
 .../ftrace/test.d/dynevent/add_remove_eprobe.tc    |  53 ++
 tools/testing/selftests/ftrace/test.d/functions    |  22 +
 18 files changed, 1275 insertions(+), 105 deletions(-)
 create mode 100644 kernel/trace/trace_eprobe.c
 create mode 100644 tools/testing/selftests/ftrace/test.d/dynevent/add_remove_eprobe.tc
