Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17219C43334
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jun 2022 15:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245273AbiFGPaS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 11:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344044AbiFGPaN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 11:30:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F5EC8BF3
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 08:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91730B8212D
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 15:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169F1C385A5;
        Tue,  7 Jun 2022 15:30:08 +0000 (UTC)
Date:   Tue, 7 Jun 2022 11:30:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Julia Lawall <julia.lawall@inria.fr>
Subject: [PATCH] trace-cmd report: Explain the '-l' option better in the man
 page
Message-ID: <20220607113007.652e14e2@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The '-l' option shows latency information of each event. It is not well
documented. Update the man page to show what the cryptic values mean.

Reported-by: Julia Lawall <julia.lawall@inria.fr>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216069
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../trace-cmd/trace-cmd-report.1.txt          | 39 +++++++++++++++----
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
index df60dd87d979..ccf635fb664b 100644
--- a/Documentation/trace-cmd/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
@@ -221,13 +221,38 @@ OPTIONS
       <idle>-0       0d.h1. 106467.859747: function:             ktime_get <-- tick_check_idle
 ----
 
-    The 0d.h1. denotes this information. The first character is never a '.'
-    and represents what CPU the trace was recorded on (CPU 0). The 'd' denotes
-    that interrupts were disabled. The 'h' means that this was called inside
-    an interrupt handler. The '1' is the preemption disabled (preempt_count)
-    was set to one.  The two '.'s are "need_resched" flag and kernel lock
-    counter.  If the "need_resched" flag is set, then that character would be a
-    'N'.
+    The 0d.h1. denotes this information.
+
+    It starts with a number. This represents the CPU number that the event occurred
+    on.
+
+    The second character is one of the following:
+
+        'd' - Interrupts are disabled
+	'.' - Interrupts are enabled
+	'X' - Has flags that are not yet known by trace-cmd
+
+    The third character is the "need rescheduling" flag.
+
+	'N' - A schedule is set to take place
+	'.' - No scheduling is set
+
+    The forth character represents the context the event was in when it triggered
+
+	'h' - Hard interrupt context
+	's' - Soft interrupt context
+	'H' - Hard interrupt context that interrupted a soft interrupt
+	'.' - Normal context
+
+    The next is a number (should be less than 10), that represents the preemption
+    depth (the number of times preempt_disable() is called without preempt_enable()).
+    '.' means preemption is enabled.
+
+    On some systems, "migrate disable" may exist, in which case a number will be
+    shown for that, or '.' meaning migration is enabled.
+
+    If lockdep in enabled on the system, then the number represents the depth of
+    locks that are held when the event triggered. '.' means no locks are held.
 
 *-w*::
     If both the 'sched_switch' and 'sched_wakeup' events are enabled, then
-- 
2.35.1

