Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335A3C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 21:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DD3A610E5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 21:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhJ1VeT convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:34:19 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:55228 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231616AbhJ1VeF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 17:34:05 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-RpYfT8A9OFGE2197Ab984w-1; Thu, 28 Oct 2021 17:31:32 -0400
X-MC-Unique: RpYfT8A9OFGE2197Ab984w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9248E802682;
        Thu, 28 Oct 2021 21:31:30 +0000 (UTC)
Received: from x1.com (unknown [10.22.32.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BF4F100EBBE;
        Thu, 28 Oct 2021 21:31:21 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V7 9/9] trace/osnoise: Remove PREEMPT_RT ifdefs from inside functions
Date:   Thu, 28 Oct 2021 23:29:37 +0200
Message-Id: <cda11d41106d1ed26d6275acc826f07e69e3ff22.1635452903.git.bristot@kernel.org>
In-Reply-To: <cover.1635452903.git.bristot@kernel.org>
References: <cover.1635452903.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Remove CONFIG_PREEMPT_RT from inside functions, avoiding
compilation problems in the future.

Cc: Steven Rostedt <rostedt@goodmis.org>
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
---
 kernel/trace/trace_osnoise.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index eaa6396e3262..e6e3e41bd8a3 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1505,9 +1505,11 @@ static enum hrtimer_restart timerlat_irq(struct hrtimer *timer)
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
 
@@ -1517,13 +1519,6 @@ static enum hrtimer_restart timerlat_irq(struct hrtimer *timer)
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
2.31.1

