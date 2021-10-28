Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0003C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 21:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7E3E61056
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 21:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhJ1Vd1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:33:27 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:40906 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231387AbhJ1Vd1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 17:33:27 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-LPIpG4fpN-OQmOrMbfoUew-1; Thu, 28 Oct 2021 17:30:55 -0400
X-MC-Unique: LPIpG4fpN-OQmOrMbfoUew-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5ED7818414A0;
        Thu, 28 Oct 2021 21:30:54 +0000 (UTC)
Received: from x1.com (unknown [10.22.32.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5858100EBBE;
        Thu, 28 Oct 2021 21:30:50 +0000 (UTC)
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
Subject: [PATCH V7 2/9] trace/osnoise: Improve comments about barrier need for NMI callbacks
Date:   Thu, 28 Oct 2021 23:29:30 +0200
Message-Id: <a58392a99484739430d2a75bb0bd7aed6e3ab7ca.1635452903.git.bristot@kernel.org>
In-Reply-To: <cover.1635452903.git.bristot@kernel.org>
References: <cover.1635452903.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

trace_osnoise_callback_enabled is used by ftrace_nmi_enter/exit()
to know when to call the NMI callback. The barrier is used to
avoid having callbacks enabled before the resetting date during
the start or to touch the values after stopping the tracer.

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
 kernel/trace/trace_osnoise.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 73f9609cba3d..f941a322ca89 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1929,8 +1929,10 @@ static int __osnoise_tracer_start(struct trace_array *tr)
 	retval = osnoise_hook_events();
 	if (retval)
 		return retval;
+
 	/*
-	 * Make sure NMIs see reseted values.
+	 * Make sure that ftrace_nmi_enter/exit() see reset values
+	 * before enabling trace_osnoise_callback_enabled.
 	 */
 	barrier();
 	trace_osnoise_callback_enabled = true;
@@ -1965,6 +1967,10 @@ static void osnoise_tracer_stop(struct trace_array *tr)
 		return;
 
 	trace_osnoise_callback_enabled = false;
+	/*
+	 * Make sure that ftrace_nmi_enter/exit() see
+	 * trace_osnoise_callback_enabled as false before continuing.
+	 */
 	barrier();
 
 	stop_per_cpu_kthreads();
-- 
2.31.1

