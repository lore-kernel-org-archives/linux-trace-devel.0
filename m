Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21724C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 19:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CEA760F9B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 19:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhJ2TEg convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:04:36 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:58710 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230467AbhJ2TE1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Oct 2021 15:04:27 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-aUBgWNA2NE6rT4Pea9eR-A-1; Fri, 29 Oct 2021 15:01:56 -0400
X-MC-Unique: aUBgWNA2NE6rT4Pea9eR-A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6E5D8066F6;
        Fri, 29 Oct 2021 19:01:54 +0000 (UTC)
Received: from x1.com (unknown [10.22.10.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F137E5D9CA;
        Fri, 29 Oct 2021 19:01:49 +0000 (UTC)
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
Subject: [PATCH V8 9/9] tracing/osnoise: Remove PREEMPT_RT ifdefs from inside functions
Date:   Fri, 29 Oct 2021 21:00:35 +0200
Message-Id: <8e32bd96c85b691e606a545158815853581d0663.1635533292.git.bristot@kernel.org>
In-Reply-To: <cover.1635533292.git.bristot@kernel.org>
References: <cover.1635533292.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
index 2594193aa30e..7a8d1b631d75 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1517,9 +1517,11 @@ static enum hrtimer_restart timerlat_irq(struct hrtimer *timer)
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
 
@@ -1529,13 +1531,6 @@ static enum hrtimer_restart timerlat_irq(struct hrtimer *timer)
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

