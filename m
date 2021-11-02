Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32EBC4167D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3935611C0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Nov 2021 20:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhKBUOg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 16:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231539AbhKBUOe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 16:14:34 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AE7A61166;
        Tue,  2 Nov 2021 20:11:59 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1mi08U-001jNL-Bh;
        Tue, 02 Nov 2021 16:11:58 -0400
Message-ID: <20211102201158.195288505@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 02 Nov 2021 16:11:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org
Subject: [for-next][PATCH 09/14] tracing/osnoise: Remove PREEMPT_RT ifdefs from inside functions
References: <20211102201126.559641540@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

Remove CONFIG_PREEMPT_RT from inside functions, avoiding
compilation problems in the future.

Link: https://lkml.kernel.org/r/37ee0881b033cdc513efc84ebea26cf77880c8c2.1635702894.git.bristot@kernel.org

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: linux-rt-users@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace_osnoise.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index a7dadf4bfc5f..3e4a1651e329 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1518,9 +1518,11 @@ static enum hrtimer_restart timerlat_irq(struct hrtimer *timer)
 	 * running, the thread needs to receive the softirq delta_start. The
 	 * reason being is that the softirq will be the last to be unfolded,
 	 * resseting the thread delay to zero.
+	 *
+	 * The PREEMPT_RT is a special case, though. As softirqs run as threads
+	 * on RT, moving the thread is enough.
 	 */
-#ifndef CONFIG_PREEMPT_RT
-	if (osn_var->softirq.delta_start) {
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && osn_var->softirq.delta_start) {
 		copy_int_safe_time(osn_var, &osn_var->thread.delta_start,
 				   &osn_var->softirq.delta_start);
 
@@ -1530,13 +1532,6 @@ static enum hrtimer_restart timerlat_irq(struct hrtimer *timer)
 		copy_int_safe_time(osn_var, &osn_var->thread.delta_start,
 				    &osn_var->irq.delta_start);
 	}
-#else /* CONFIG_PREEMPT_RT */
-	/*
-	 * The sofirqs run as threads on RT, so there is not need
-	 * to keep track of it.
-	 */
-	copy_int_safe_time(osn_var, &osn_var->thread.delta_start, &osn_var->irq.delta_start);
-#endif /* CONFIG_PREEMPT_RT */
 
 	/*
 	 * Compute the current time with the expected time.
-- 
2.33.0
