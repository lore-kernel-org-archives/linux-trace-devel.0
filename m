Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0F5C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 02:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347890AbiCXC7A (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 22:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238778AbiCXC67 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 22:58:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB01939E7;
        Wed, 23 Mar 2022 19:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A58261997;
        Thu, 24 Mar 2022 02:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29E2C340E8;
        Thu, 24 Mar 2022 02:57:27 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXDfC-007FKt-Uw;
        Wed, 23 Mar 2022 22:57:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     williskung@google.com, kaleshsingh@google.com,
        linux-rt-users@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 00/12] trace-cmd: Add trace-cmd analyze command
Date:   Wed, 23 Mar 2022 22:57:14 -0400
Message-Id: <20220324025726.1727204-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a new command called "analyze" that reads a trace.dat file and will
report useful information from it. Such as:

Time the CPUs were idle.

What tasks ran the most on a CPU.

For each task, how long were the wake ups, how long was it blocked,
preempted, or just sleeping.

And many more to come.

See the man page at the last patch for more details.

Steven Rostedt (Google) (12):
  trace-cmd: Add trace-cmd analyze
  trace-cmd analyze: Show what tasks are running the most
  trace-cmd analyze: Show how much tasks run on each CPU
  trace-cmd analyze: Use sched_switch to find comm mappings
  trace-cmd analyze: Use sched_switch event to update times
  trace-cmd analyze: Add tracing of tasks and their states
  trace-cmd analyze: Add "idleness"
  trace-cmd analyze: Track migration
  trace-cmd analyze: Add wake up latency timings
  trace-cmd analyze: Add counting of page faults
  trace-cmd analyze: Account for dropped events
  trace-cmd analyze: Add documentation

 .../trace-cmd/trace-cmd-analyze.1.txt         |  290 +++++
 tracecmd/Makefile                             |    1 +
 tracecmd/include/trace-local.h                |    2 +
 tracecmd/trace-analyze.c                      | 1046 +++++++++++++++++
 tracecmd/trace-cmd.c                          |    1 +
 tracecmd/trace-usage.c                        |    7 +
 6 files changed, 1347 insertions(+)
 create mode 100644 Documentation/trace-cmd/trace-cmd-analyze.1.txt
 create mode 100644 tracecmd/trace-analyze.c

-- 
2.35.1

