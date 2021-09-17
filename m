Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBAFBC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D758611C8
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343887AbhIQPsm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 11:48:42 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:21868 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343928AbhIQPsF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 11:48:05 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-bRNVlaTgO-ytI1FEpmrPWw-1; Fri, 17 Sep 2021 11:46:38 -0400
X-MC-Unique: bRNVlaTgO-ytI1FEpmrPWw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E891101AFCC;
        Fri, 17 Sep 2021 15:46:37 +0000 (UTC)
Received: from x1.bristot.me.homenet.telecomitalia.it (unknown [10.22.17.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F1E05D9C6;
        Fri, 17 Sep 2021 15:46:34 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Kate Carcia <kcarcia@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 15/19] rtla: Add rtla osnoise top documentation
Date:   Fri, 17 Sep 2021 17:43:58 +0200
Message-Id: <6df2782bbf0055bd7552694b1d7cfb9b97d68328.1631889858.git.bristot@kernel.org>
In-Reply-To: <cover.1631889858.git.bristot@kernel.org>
References: <cover.1631889858.git.bristot@kernel.org>
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

Man page for rtla osnoise top mode.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
Cc: linux-rt-users@vger.kernel.org
Cc: linux-trace-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 .../rtla/Documentation/rtla-osnoise-top.txt   | 98 +++++++++++++++++++
 1 file changed, 98 insertions(+)
 create mode 100644 tools/tracing/rtla/Documentation/rtla-osnoise-top.txt

diff --git a/tools/tracing/rtla/Documentation/rtla-osnoise-top.txt b/tools/tracing/rtla/Documentation/rtla-osnoise-top.txt
new file mode 100644
index 000000000000..e4da5db422e8
--- /dev/null
+++ b/tools/tracing/rtla/Documentation/rtla-osnoise-top.txt
@@ -0,0 +1,98 @@
+rtla-osnoise-top(1)
+===================
+
+NAME
+----
+rtla-osnoise-top - Display a summary of the operating system noise
+
+SYNOPSIS
+--------
+*rtla osnoise top* ['OPTIONS']
+
+DESCRIPTION
+-----------
+The rtla-osnoise-top(1) tool is an interface for the osnoise tracer. The
+osnoise tracer dispatches a kernel thread per-cpu. These threads read the
+time in a loop while with preemption, softirq and IRQs enabled, thus
+allowing all the sources of osnoise during its execution. The osnoise's
+tracer threads take note of the delta between each time read, along with
+an interference counter for each source of interference. At the end of
+each period, the osnoise tracer displays a summary of the results.
+
+*rtla osnoise top* collects the periodic summary from the osnoise tracer,
+including the counters of the occurrence of the interference source,
+displaying the results in a user-friendly format.
+
+The tool also allows many configurations of the osnoise tracer and the
+collection of the tracer output.
+
+OPTIONS
+-------
+*-h*, *--help*::
+Print help menu.
+*-p*, *--period* 'us'::
+Set the osnoise tracer period in microseconds.
+*-r*, *--runtime* 'us'::
+Set the osnoise tracer runtime in microseconds.
+*-s*, *--stop* 'us'::
+Stop the trace if a single sample is higher than the argument in microseconds.
+If -T is set, it will also save the trace to the output.
+*-S*, *--stop-total* 'us'::
+Stop the trace if the total sample is higher than the argument in microseconds.
+If -T is set, it will also save the trace to the output.
+*-c*, *--cpus* 'cpu-list'::
+Set the osnoise tracer to run the sample threads in the cpu-list.
+*-d*, *--duration* 'time[s|m|h|d]'::
+Set the duration of the session.
+*-T*, *--trace*['=file']::
+Save the stopped trace to ['file|osnoise_trace.txt'].
+*-q*, *--quiet*::
+Print only a summary at the end of the session.
+*-P*, *--priority* 'o:prio|r:prio|f:prio|d:runtime:period'::
+Set scheduling parameters to the osnoise tracer threads, the format to set the priority are:
+  - 'o:prio' - use SCHED_OTHER with 'prio';
+  - 'r:prio' - use SCHED_RR with 'prio';
+  - 'f:prio' - use SCHED_FIFO with 'prio';
+  - 'd:runtime[us|ms|s]:period[us|ms|s]' - use SCHED_DEADLINE with 'runtime' and 'period' in nanoseconds.
+
+EXAMPLE
+-------
+In the example below, the rtla osnoise top tool is set to run with a
+real-time priority 'FIFO:1', on CPUs '0-3', for '900ms' at each period
+('1s' by default). The reason for reducing the runtime is to avoid starving
+the rtla tool. The tool is also set to run for 'one minute' and to display
+a summary of the report at the end of the session.
+
+-------------------------------------------------------
+[root@f34 ~]# rtla osnoise top -P F:1 -c 0-3 -r 900000 -d 1M -q
+                                          Operating System Noise
+duration:   0 00:01:00 | time is in us
+CPU Period       Runtime        Noise  % CPU Aval   Max Noise   Max Single          HW          NMI          IRQ      Softirq       Thread
+  0 #59         53100000       304896    99.42580        6978           56         549            0        53111         1590           13
+  1 #59         53100000       338339    99.36282        8092           24         399            0        53130         1448           31
+  2 #59         53100000       290842    99.45227        6582           39         855            0        53110         1406           12
+  3 #59         53100000       204935    99.61405        6251           33         290            0        53156         1460           12
+-------------------------------------------------------
+
+SEE ALSO
+--------
+_rtla-osnoise(1)_, _rtla-osnoise-hist_(1)
+
+Osnoise tracer documentation: <https://www.kernel.org/doc/html/latest/trace/osnoise-tracer.html>
+
+AUTHOR
+------
+Written by Daniel Bristot de Oliveira <bristot@kernel.org>
+
+REPORTING BUGS
+--------------
+Report bugs to <lkml@vger.kernel.org>
+
+LICENSE
+-------
+rtla is Free Software licensed under the GNU GPLv2
+
+COPYING
+-------
+Copyright \(C) 2021 Red Hat, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.31.1

