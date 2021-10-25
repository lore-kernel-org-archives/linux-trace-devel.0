Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C89C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Oct 2021 17:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BE5160F9D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 25 Oct 2021 17:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbhJYRpS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 25 Oct 2021 13:45:18 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:44736 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234371AbhJYRo6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 13:44:58 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-LnozHLpEMe2iNo-cVpDLcQ-1; Mon, 25 Oct 2021 13:42:32 -0400
X-MC-Unique: LnozHLpEMe2iNo-cVpDLcQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34D88801B26;
        Mon, 25 Oct 2021 17:42:31 +0000 (UTC)
Received: from x1.com (unknown [10.22.9.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D52BA5C1A1;
        Mon, 25 Oct 2021 17:42:22 +0000 (UTC)
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
Subject: [PATCH V5 15/20] rtla: Add rtla osnoise man page
Date:   Mon, 25 Oct 2021 19:40:40 +0200
Message-Id: <66e75571354250bd6a4910649bf213dc457d6f19.1635181938.git.bristot@kernel.org>
In-Reply-To: <cover.1635181938.git.bristot@kernel.org>
References: <cover.1635181938.git.bristot@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=bristot@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Man page for rtla osnoise command.

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
 .../tools/rtla/common_osnoise_description.rst |  8 +++
 Documentation/tools/rtla/rtla-osnoise.rst     | 59 +++++++++++++++++++
 2 files changed, 67 insertions(+)
 create mode 100644 Documentation/tools/rtla/common_osnoise_description.rst
 create mode 100644 Documentation/tools/rtla/rtla-osnoise.rst

diff --git a/Documentation/tools/rtla/common_osnoise_description.rst b/Documentation/tools/rtla/common_osnoise_description.rst
new file mode 100644
index 000000000000..8973c5df888f
--- /dev/null
+++ b/Documentation/tools/rtla/common_osnoise_description.rst
@@ -0,0 +1,8 @@
+The **rtla osnoise** tool is an interface for the *osnoise* tracer. The
+*osnoise* tracer dispatches a kernel thread per-cpu. These threads read the
+time in a loop while with preemption, softirq and IRQs enabled, thus
+allowing all the sources of operating systme noise during its execution.
+The *osnoise*'s tracer threads take note of the delta between each time
+read, along with an interference counter of all sources of interference.
+At the end of each period, the *osnoise* tracer displays a summary of
+the results.
diff --git a/Documentation/tools/rtla/rtla-osnoise.rst b/Documentation/tools/rtla/rtla-osnoise.rst
new file mode 100644
index 000000000000..c129b206ce34
--- /dev/null
+++ b/Documentation/tools/rtla/rtla-osnoise.rst
@@ -0,0 +1,59 @@
+===============
+rtla-osnoise
+===============
+------------------------------------------------------------------
+Measure the operating system noise
+------------------------------------------------------------------
+
+:Manual section: 1
+
+SYNOPSIS
+========
+**rtla osnoise** [*MODE*] ...
+
+DESCRIPTION
+===========
+
+.. include:: common_osnoise_description.rst
+
+The *osnoise* tracer outputs information in two ways. It periodically prints
+a summary of the noise of the operating system, including the counters of
+the occurrence of the source of interference. It also provides information
+for each noise via the **osnoise:** tracepoints. The **rtla osnoise top**
+mode displays information about the periodic summary from the *osnoise* tracer.
+The **rtla osnoise hist** mode displays information about the noise using
+the **osnoise:** tracepoints. For further details, please refer to the
+respective man page.
+
+MODES
+=====
+**top**
+
+        Prints the summary from osnoise tracer.
+
+**hist**
+
+        Prints a histogram of osnoise samples.
+
+If no MODE is given, the top mode is called, passing the arguments.
+
+OPTIONS
+=======
+
+**-h**, **--help**
+
+        Display the help text.
+
+For other options, see the man page for the corresponding mode.
+
+SEE ALSO
+========
+**rtla-osnoise-top**\(1), **rtla-osnoise-hist**\(1)
+
+Osnoise tracer documentation: <https://www.kernel.org/doc/html/latest/trace/osnoise-tracer.html>
+
+AUTHOR
+======
+Written by Daniel Bristot de Oliveira <bristot@kernel.org>
+
+.. include:: common_appendix.rst
-- 
2.31.1

