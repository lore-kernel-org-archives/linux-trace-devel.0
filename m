Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F52C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 16:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B87E610E8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 16:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhJRQxa convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 12:53:30 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:56221 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232333AbhJRQxA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 12:53:00 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-MrMRZ0akPxOxOKOEmacaEg-1; Mon, 18 Oct 2021 12:50:47 -0400
X-MC-Unique: MrMRZ0akPxOxOKOEmacaEg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C68F10A8E01;
        Mon, 18 Oct 2021 16:50:46 +0000 (UTC)
Received: from x1.com (unknown [10.22.18.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF23910016F4;
        Mon, 18 Oct 2021 16:50:04 +0000 (UTC)
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
Subject: [PATCH V3 17/19] rtla: Add rtla timerlat documentation
Date:   Mon, 18 Oct 2021 18:48:30 +0200
Message-Id: <3a8fc13db9ee5a79db0c9b5ca3aa69ba14a6955c.1634574261.git.bristot@kernel.org>
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

Man page for rtla timerlat tool.

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
 .../rtla/Documentation/rtla-timerlat.txt      | 65 +++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 tools/tracing/rtla/Documentation/rtla-timerlat.txt

diff --git a/tools/tracing/rtla/Documentation/rtla-timerlat.txt b/tools/tracing/rtla/Documentation/rtla-timerlat.txt
new file mode 100644
index 000000000000..2b5ef9a9d6b0
--- /dev/null
+++ b/tools/tracing/rtla/Documentation/rtla-timerlat.txt
@@ -0,0 +1,65 @@
+rtla-timerlat(1)
+================
+
+NAME
+----
+rtla-timerlat - Measures the operating system timer latency
+
+SYNOPSIS
+--------
+*rtla timerlat* [MODE] ...
+
+DESCRIPTION
+-----------
+The rtla-timerlat(1) tool is an interface for the timerlat tracer. The
+timerlat tracer dispatches a kernel thread per-cpu. These threads set
+a periodic timer to wake themselves up and go back to sleep. After the
+wakeup, they collect and generate useful information for the debugging
+of operating system timer latency.
+
+The timerlat tracer outputs information in two ways. It periodically
+prints the timer latency at the timer 'IRQ' handler and the 'Thread' handler.
+It also provides information for each noise via the osnoise tracepoints.
+The rtla-timerlat-top(1) mode displays a summary of the periodic output
+from the timerlat tracer. The rtla-hist-hist(1) mode displays a histogram of
+each tracer event occurrence. For further details, please refer to the
+respective man page.
+
+MODES
+-----
+*top*::
+  Prints the summary from timerlat tracer.
+*hist*::
+  Prints a histogram of timerlat samples.
+
+If no MODE is given, the top mode is called, passing the arguments.
+
+OPTIONS
+-------
+*-h*, *--help*::
+  Display the help text.
+
+For other options, see the man page for the corresponding mode.
+
+SEE ALSO
+--------
+_rtla-timerlat-top(1)_, _rtla-timerlat-hist(1)_
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

