Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6910C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 14:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9474F60E98
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 14:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243419AbhJKOmW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 10:42:22 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:55507 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244362AbhJKOk5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 10:40:57 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-4AUeVWkkNAO7dA1OGZ6sAw-1; Mon, 11 Oct 2021 10:38:54 -0400
X-MC-Unique: 4AUeVWkkNAO7dA1OGZ6sAw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2508BD521;
        Mon, 11 Oct 2021 14:38:52 +0000 (UTC)
Received: from x1.bristot.me.homenet.telecomitalia.it (unknown [10.22.17.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0724919C59;
        Mon, 11 Oct 2021 14:38:43 +0000 (UTC)
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Kate Carcia <kcarcia@redhat.com>,
        John Kacur <jkacur@redhat.com>,
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
Subject: [PATCH V2 19/19] rtla: Add rtla timerlat hist documentation
Date:   Mon, 11 Oct 2021 16:36:07 +0200
Message-Id: <f5003a95855174dc010622ba33eb4b548b5cdae9.1633958325.git.bristot@kernel.org>
In-Reply-To: <cover.1633958325.git.bristot@kernel.org>
References: <cover.1633958325.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Man page for rtla timerlat hist mode.

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
 .../rtla/Documentation/rtla-timerlat-hist.txt | 162 ++++++++++++++++++
 1 file changed, 162 insertions(+)
 create mode 100644 tools/tracing/rtla/Documentation/rtla-timerlat-hist.txt

diff --git a/tools/tracing/rtla/Documentation/rtla-timerlat-hist.txt b/tools/tracing/rtla/Documentation/rtla-timerlat-hist.txt
new file mode 100644
index 000000000000..fbbc981aa82d
--- /dev/null
+++ b/tools/tracing/rtla/Documentation/rtla-timerlat-hist.txt
@@ -0,0 +1,162 @@
+rtla-timerlat-hist(1)
+=====================
+
+NAME
+----
+rtla-timerlat-hist - Histograms of the operating system timer latency
+
+SYNOPSIS
+--------
+*rtla timerlat hist* ['OPTIONS'] ...
+
+DESCRIPTION
+-----------
+The rtla-hist-hist(1) mode displays a histogram of each tracer event occurrence.
+
+The rtla-timerlat(1) tool is an interface for the timerlat tracer. The
+timerlat tracer dispatches a kernel thread per-cpu. These threads set a
+periodic timer to wake themselves up and go back to sleep. After the wakeup,
+they collect and generate useful information for the debugging of operating
+system timer latency.
+
+The timerlat tracer outputs information in two ways. It periodically prints
+the timer latency at the timer 'IRQ' handler and the 'Thread' handler. It
+also provides information for each noise via the osnoise tracepoints. This
+tool uses the periodic information, and the osnoise tracepoints are enabled
+when using the -T option.
+
+OPTIONS
+-------
+*-h*, *--help*::
+Print help menu.
+*-p*, *--period* 'us'::
+Set the timerlat tracer period in microseconds.
+*-i*, *--irq* 'us'::
+Stop trace if the irq latency is higher than the argument in us.
+*-T*, *--thread* 'us'::
+Stop trace if the thread latency is higher than the argument in us.
+*-s*, *--stack* 'us'::
+Save the stack trace at the IRQ if a thread latency is higher than the
+argument in us.
+*-c*, *--cpus* 'cpu-list'::
+Set the timerlat tracer to run the sample threads in the cpu-list.
+*-d*, *--duration* 'time[s|m|h|d]'::
+Set the duration of the session.
+*-T*, *--trace*['=file']::
+Save the stopped trace to ['file|timerlat_trace.txt'].
+*-P*, *--priority* 'o:prio|r:prio|f:prio|d:runtime:period'::
+Set scheduling parameters to the timerlat tracer threads, the format to
+set the priority are:
+  - 'o:prio' - use SCHED_OTHER with 'prio';
+  - 'r:prio' - use SCHED_RR with 'prio';
+  - 'f:prio' - use SCHED_FIFO with 'prio';
+  - 'd:runtime[us|ms|s]:period[us|ms|s]' - use SCHED_DEADLINE with 'runtime' and
+'period' in nanoseconds.
+
+*-b*, *--bucket-size* 'N'::
+Set the histogram bucket size (default 1).
+*-e*, *--entries* 'N'::
+Set the number of entries of the histogram (default 256).
+*--no-irq*::
+Ignore IRQ latencies.
+*--no-thread*::
+Ignore thread latencies.
+*--no-header*::
+So not print header.
+*--no-summary*::
+Do not print summary.
+*--no-index*::
+So not print index.
+*--skip-zeros*::
+Skip zero only entries.
+
+EXAMPLE
+-------
+In the example below, *rtla timerlat hist* is set to run for '10' minutes,
+in the cpus '0-4', 'skipping zero' only lines. Moreover, *rtla timerlat
+hist* will change the priority of the timelat threads to run under
+'SCHED_DEADLINE' priority, with a '10 us' runtime every '1 ms' period. The
+'1ms' period is also passed to the timerlat tracer.
+
+------------------------------------------
+[root@alien ~]# timerlat hist -d 10m -c 0-4 --skip-zeros -P d:100us:1ms -p 1ms
+# RTLA timerlat histogram
+# Time unit is microseconds (us)
+# Duration:   0 00:10:00
+Index   IRQ-000   Thr-000   IRQ-001   Thr-001   IRQ-002   Thr-002   IRQ-003   Thr-003   IRQ-004   Thr-004
+0        276489         0    206089         0    466018         0    481102         0    205546         0
+1        318327     35487    388149     30024     94531     48382     83082     71078    388026     55730
+2          3282    122584      4019    126527     28231    109012     23311     89309      4568     98739
+3           940     11815       837      9863      6209     16227      6895     17196       910      9780
+4           444     17287       424     11574      2097     38443      2169     36736       462     13476
+5           206     43291       255     25581      1223    101908      1304    101137       236     28913
+6           132    101501        96     64584       635    213774       757    215471        99     73453
+7            74    169347        65    124758       350     57466       441     53639        69    148573
+8            53     85183        31    156751       229      9052       306      9026        39    139907
+9            22     10387        12     42762       161      2554       225      2689        19     26192
+10           13      1898         8      5770       114      1247       128      1405        13      3772
+11            9       560         9       924        71       686        76       765         8       713
+12            4       256         2       360        50       411        64       474         3       278
+13            2       167         2       172        43       256        53       350         4       180
+14            1        88         1       116        15       198        42       223         0       115
+15            2        63         3        94        11       139        20       150         0        58
+16            2        37         0        56         5        78        10       102         0        39
+17            0        18         0        28         4        57         8        80         0        15
+18            0         8         0        17         2        50         6        56         0        12
+19            0         9         0         5         0        19         0        48         0        18
+20            0         4         0         8         0        11         2        27         0         4
+21            0         2         0         3         1         9         1        18         0         6
+22            0         1         0         3         1         7         0         3         0         5
+23            0         2         0         4         0         2         0         7         0         2
+24            0         2         0         2         1         3         0         3         0         5
+25            0         0         0         1         0         1         0         1         0         3
+26            0         1         0         0         0         2         0         2         0         0
+27            0         0         0         3         0         1         0         0         0         1
+28            0         0         0         3         0         0         0         1         0         0
+29            0         0         0         2         0         2         0         1         0         3
+30            0         1         0         0         0         0         0         0         0         0
+31            0         1         0         0         0         0         0         2         0         2
+32            0         0         0         1         0         2         0         0         0         0
+33            0         0         0         2         0         0         0         0         0         1
+34            0         0         0         0         0         0         0         0         0         2
+35            0         1         0         1         0         0         0         0         0         1
+36            0         1         0         0         0         1         0         1         0         0
+37            0         0         0         1         0         0         0         0         0         0
+40            0         0         0         0         0         1         0         1         0         0
+41            0         0         0         0         0         0         0         0         0         1
+42            0         0         0         0         0         0         0         0         0         1
+44            0         0         0         0         0         1         0         0         0         0
+46            0         0         0         0         0         0         0         1         0         0
+47            0         0         0         0         0         0         0         0         0         1
+50            0         0         0         0         0         0         0         0         0         1
+54            0         0         0         1         0         0         0         0         0         0
+58            0         0         0         1         0         0         0         0         0         0
+over:         0         0         0         0         0         0         0         0         0         0
+count:   600002    600002    600002    600002    600002    600002    600002    600002    600002    600002
+min:          0         1         0         1         0         1         0         1         0         1
+avg:          0         5         0         5         0         4         0         4         0         5
+max:         16        36        15        58        24        44        21        46        13        50
+------------------------------------------
+
+SEE ALSO
+--------
+_rtla-timerlat(1)_, _rtla-timerlat-top(1)_
+
+Timerlat tracer documentation: <https://www.kernel.org/doc/html/latest/trace/timerlat-tracer.html>
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

