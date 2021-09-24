Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C754C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 10:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 030DB61164
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 10:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240270AbhIXKbm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 06:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231140AbhIXKbl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 06:31:41 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02A0061164;
        Fri, 24 Sep 2021 10:30:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mTiT1-003KSl-RS; Fri, 24 Sep 2021 06:30:07 -0400
Message-ID: <20210924102917.106053441@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 24 Sep 2021 06:29:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2 v2] tracing: Have trace_pid_list be a sparse array
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When the trace_pid_list was created, the default pid max was 32768.
Creating a bitmask that can hold one bit for all 32768 took up 4096 (one
page). Having a one page bitmask was not much of a problem, and that was
used for mapping pids. But today, systems are bigger and can run more
tasks, and now the default pid_max is usually set to 4194304. Which means
to handle that many pids requires 524288 bytes. Worse yet, the pid_max can
be set to 2^30 (1073741824 or 1G) which would take 134217728 (128M) of
memory to store this array.

Since the pid_list array is very sparsely populated, it is a huge waste of
memory to store all possible bits for each pid when most will not be set.

Instead, use a page table scheme to store the array, and allow this to
handle up to 30 bit pids.

The pid_mask will start out with 256 entries for the first 8 MSB bits.
This will cost 1K for 32 bit architectures and 2K for 64 bit. Each of
these will have a 256 array to store the next 8 bits of the pid (another
1 or 2K). These will hold an 2K byte bitmask (which will cover the LSB
14 bits or 16384 pids).
 
When the trace_pid_list is allocated, it will have the 1/2K upper bits
allocated, and then it will allocate a cache for the next upper chunks and
the lower chunks (default 6 of each). Then when a bit is "set", these
chunks will be pulled from the free list and added to the array. If the
free list gets down to a lever (default 2), it will trigger an irqwork
that will refill the cache back up.

On clearing a bit, if the clear causes the bitmask to be zero, that chunk
will then be placed back into the free cache for later use, keeping the
need to allocate more down to a minimum.

Changes since v1: https://lore.kernel.org/all/20210924033547.939554938@goodmis.org/

 - Changed the bit split from 10,10,12 to 8,8,14 and only check the
   30 bits of the pid, as according to linux/thread.h a pid may only
   be at most 30 bits.

 - Added a WARN_ON_ONCE(pid_max > (1 << 30)) to be sure.

Steven Rostedt (VMware) (2):
      tracing: Place trace_pid_list logic into abstract functions
      tracing: Create a sparse bitmask for pid filtering

----
 kernel/trace/Makefile       |   1 +
 kernel/trace/ftrace.c       |   6 +-
 kernel/trace/pid_list.c     | 557 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c        |  78 +++----
 kernel/trace/trace.h        |  14 +-
 kernel/trace/trace_events.c |   6 +-
 6 files changed, 601 insertions(+), 61 deletions(-)
 create mode 100644 kernel/trace/pid_list.c
