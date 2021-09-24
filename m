Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4F1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 03:37:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BD6F60F94
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 03:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243927AbhIXDik (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 Sep 2021 23:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243960AbhIXDij (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 23:38:39 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83C6960FA0;
        Fri, 24 Sep 2021 03:37:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mTc1K-003Hys-9p; Thu, 23 Sep 2021 23:37:06 -0400
Message-ID: <20210924033547.939554938@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 23 Sep 2021 23:35:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] tracing: Have trace_pid_list be a sparse array
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
handle up to 32 bit pids.

The pid_mask will start out with 1024 entries for the first 10 MSB bits.
This will cost 4K for 32 bit architectures and 8K for 64 bit. Each of
these will have a 1024 array to store the next 10 bits of the pid (another
4 or 8K). These will hold an 512 byte bitmask (which will cover the LSB 12
  bits or 4096 bits).
 
When the trace_pid_list is allocated, it will have the 4/8K upper bits
allocated, and then it will allocate a cache for the next upper chunks and
the lower chunks (default 6 of each). Then when a bit is "set", these
chunks will be pulled from the free list and added to the array. If the
free list gets down to a lever (default 2), it will trigger an irqwork
that will refill the cache back up.

On clearing a bit, if the clear causes the bitmask to be zero, that chunk
will then be placed back into the free cache for later use, keeping the
need to allocate more down to a minimum.


Steven Rostedt (VMware) (2):
      tracing: Place trace_pid_list logic into abstract functions
      tracing: Create a sparse bitmask for pid filtering

----
 kernel/trace/Makefile       |   1 +
 kernel/trace/ftrace.c       |   6 +-
 kernel/trace/pid_list.c     | 551 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c        |  78 +++----
 kernel/trace/trace.h        |  14 +-
 kernel/trace/trace_events.c |   6 +-
 6 files changed, 595 insertions(+), 61 deletions(-)
 create mode 100644 kernel/trace/pid_list.c
