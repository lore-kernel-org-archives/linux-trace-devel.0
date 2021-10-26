Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10A9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 22:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F4760F02
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 22:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbhJZWKV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Oct 2021 18:10:21 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:29130 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237318AbhJZWKR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Oct 2021 18:10:17 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47--2cc785WMvKh1kmWmATw4g-1; Tue, 26 Oct 2021 18:07:47 -0400
X-MC-Unique: -2cc785WMvKh1kmWmATw4g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD978802B7A;
        Tue, 26 Oct 2021 22:07:45 +0000 (UTC)
Received: from x1.com (unknown [10.22.32.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02CE260BF1;
        Tue, 26 Oct 2021 22:07:03 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tao Zhou <tao.zhou@linux.dev>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
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
Subject: [PATCH V6 02/20] trace/osnoise: Improve comments about barrier need for NMI callbacks
Date:   Wed, 27 Oct 2021 00:06:13 +0200
Message-Id: <17c9b30b50e304269f08be3cbf8ca8188d2ebf7e.1635284863.git.bristot@kernel.org>
In-Reply-To: <cover.1635284863.git.bristot@kernel.org>
References: <cover.1635284863.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
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

