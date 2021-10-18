Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472A8C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 16:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3206861074
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 16:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhJRQw7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 12:52:59 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:53275 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234165AbhJRQwV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 12:52:21 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-RoTtR-2tN_uI8JBcC93W-A-1; Mon, 18 Oct 2021 12:50:06 -0400
X-MC-Unique: RoTtR-2tN_uI8JBcC93W-A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66D2518125C0;
        Mon, 18 Oct 2021 16:50:04 +0000 (UTC)
Received: from x1.com (unknown [10.22.18.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3480910016F4;
        Mon, 18 Oct 2021 16:49:57 +0000 (UTC)
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
Subject: [PATCH V3 16/19] rtla: Add rtla osnoise hist documentation
Date:   Mon, 18 Oct 2021 18:48:29 +0200
Message-Id: <180eeb33c0f8c85d39172ba4044f6ec170159304.1634574261.git.bristot@kernel.org>
In-Reply-To: <cover.1634574261.git.bristot@kernel.org>
References: <cover.1634574261.git.bristot@kernel.org>
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

Man page for rtla osnoise hist mode.

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
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
---
 .../rtla/Documentation/rtla-osnoise-hist.txt  | 117 ++++++++++++++++++
 1 file changed, 117 insertions(+)
 create mode 100644 tools/tracing/rtla/Documentation/rtla-osnoise-hist.txt

diff --git a/tools/tracing/rtla/Documentation/rtla-osnoise-hist.txt b/tools/tracing/rtla/Documentation/rtla-osnoise-hist.txt
new file mode 100644
index 000000000000..64f0895a5dcc
--- /dev/null
+++ b/tools/tracing/rtla/Documentation/rtla-osnoise-hist.txt
@@ -0,0 +1,117 @@
+rtla-osnoise-hist(1)
+===================
+
+NAME
+----
+rtla-osnoise-hist - Display a histogram of the osnoise tracer samples
+
+SYNOPSIS
+--------
+*rtla osnoise hist* ['OPTIONS']
+
+DESCRIPTION
+-----------
+The *rtla-osnoise-hist(1)* tool is an interface for the osnoise tracer. The
+osnoise tracer dispatches a kernel thread per-cpu. These threads read the
+time in a loop while with preemption, SoftIRQs and IRQs enabled, thus
+allowing all the sources of osnoise during its execution. The osnoise threads
+take note of the delta between each time read. Anytime the delta between two
+consecutive reads of the timer is higher than a 'threshold,' an
+*osnoise:sample_threshold* event is generated reporting the detected noise.
+
+The *rtla-osnoise-hist(1)* tool collects all *osnoise:sample_threshold*
+occurrence in a histogram, displaying the results in a user-friendly way.
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
+If -t is set, it will also save the trace to the output.
+*-S*, *--stop-total* 'us'::
+Stop the trace if the total sample is higher than the argument in microseconds.
+If -t is set, it will also save the trace to the output.
+*-c*, *--cpus* 'cpu-list'::
+Set the osnoise tracer to run the sample threads in the cpu-list.
+*-d*, *--duration* 'time[s|m|h|d]'::
+Set the duration of the session.
+*-t*, *--trace*['=file']::
+Save the stopped trace to ['file|osnoise_trace.txt'].
+*-P*, *--priority* 'o:prio|r:prio|f:prio|d:runtime:period'::
+Set scheduling parameters to the osnoise tracer threads, the format to
+set the priority are:
+  - 'o:prio' - use SCHED_OTHER with 'prio';
+  - 'r:prio' - use SCHED_RR with 'prio';
+  - 'f:prio' - use SCHED_FIFO with 'prio';
+  - 'd:runtime[us|ms|s]:period[us|ms|s]' - use SCHED_DEADLINE with
+'runtime' and 'period' in nanoseconds.
+
+*-b*, --bucket-size 'N'::
+Set the histogram bucket size (default 1).
+*-e*, --entries 'N'::
+Set the number of entries of the histogram (default 256).
+*--no-header*::
+Do not print header.
+*--no-summary*::
+Do not print summary.
+*--no-index*::
+Do not print index.
+*--with-zeros*::
+Print zero only entries.
+
+EXAMPLE
+-------
+In the example below, osnoise tracer threads are set to run with real-time
+priority 'FIFO:1', on CPUs '0-11', for '900ms' at each period ('1s' by
+default). The reason for reducing the runtime is to avoid starving the rtla
+tool. The tool is also set to run for 'one minute.' The output histogram is
+set to group outputs in buckets of '10 us' and '25' entries.
+
+-------------------------------------------------------
+[root@f34 ~/]# rtla osnoise hist -P F:1 -c 0-11 -r 900000 -d 1M -b 10 -e 25
+# RTLA osnoise histogram
+# Time unit is microseconds (us)
+# Duration:   0 00:01:00
+Index   CPU-000   CPU-001   CPU-002   CPU-003   CPU-004   CPU-005   CPU-006   CPU-007   CPU-008   CPU-009   CPU-010   CPU-011
+0         42982     46287     51779     53740     52024     44817     49898     36500     50408     50128     49523     52377
+10        12224      8356      2912       878      2667     10155      4573     18894      4214      4836      5708      2413
+20            8         5        12         2        13        24        20        41        29        53        39        39
+30            1         1         0         0        10         3         6        19        15        31        30        38
+40            0         0         0         0         0         4         2         7         2         3         8        11
+50            0         0         0         0         0         0         0         0         0         1         1         2
+over:         0         0         0         0         0         0         0         0         0         0         0         0
+count:    55215     54649     54703     54620     54714     55003     54499     55461     54668     55052     55309     54880
+min:          0         0         0         0         0         0         0         0         0         0         0         0
+avg:          0         0         0         0         0         0         0         0         0         0         0         0
+max:         30        30        20        20        30        40        40        40        40        50        50        50
+-------------------------------------------------------
+
+SEE ALSO
+--------
+_rtla-osnoise(1)_, _rtla-osnoise-top_(1)
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

