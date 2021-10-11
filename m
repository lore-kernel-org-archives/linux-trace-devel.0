Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06114C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 14:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E596560E98
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 14:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243740AbhJKOlM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 10:41:12 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:32098 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243768AbhJKOkF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 10:40:05 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-OkDu8Ek4MRSdTpPui3RX0g-1; Mon, 11 Oct 2021 10:38:01 -0400
X-MC-Unique: OkDu8Ek4MRSdTpPui3RX0g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7495280292B;
        Mon, 11 Oct 2021 14:37:59 +0000 (UTC)
Received: from x1.bristot.me.homenet.telecomitalia.it (unknown [10.22.17.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9C8F19C59;
        Mon, 11 Oct 2021 14:37:39 +0000 (UTC)
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
Subject: [PATCH V2 14/19] rtla: Add rtla osnoise man page
Date:   Mon, 11 Oct 2021 16:36:02 +0200
Message-Id: <1b5a5183af9fbc5a64721620e2d344fed1d0f85d.1633958325.git.bristot@kernel.org>
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

Man page for rtla osnoise command.

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
 .../rtla/Documentation/rtla-osnoise.txt       | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 tools/tracing/rtla/Documentation/rtla-osnoise.txt

diff --git a/tools/tracing/rtla/Documentation/rtla-osnoise.txt b/tools/tracing/rtla/Documentation/rtla-osnoise.txt
new file mode 100644
index 000000000000..2da49246b645
--- /dev/null
+++ b/tools/tracing/rtla/Documentation/rtla-osnoise.txt
@@ -0,0 +1,68 @@
+rtla-osnoise(1)
+===============
+
+NAME
+----
+rtla-osnoise - Measure the operating system noise
+
+SYNOPSIS
+--------
+*rtla osnoise* [MODE] ...
+
+DESCRIPTION
+-----------
+The rtla-osnoise(1) tool is an interface for the osnoise tracer. The osnoise
+tracer dispatches a kernel thread per-cpu. These threads read the time in
+a loop while with preemption, softirqs and IRQs enabled, thus allowing all
+the sources of osnoise during its execution. The osnoise threads take note
+of the entry and exit point of any source of interferences, increasing a
+per-cpu interference counter. The osnoise tracer also saves an interference
+counter for each source of interference.
+
+The osnoise tracer outputs information in two ways. It periodically prints
+a summary of the noise of the operating system, including the counters of
+the occurrence of the source of interference. It also provides information
+for each noise via the osnoise tracepoints. The rtla-osnoise-top(1) mode
+display information about the periodic summary from the osnoise tracer.
+The rtla-osnoise-hist(1) mode display information about the noise using
+the *osnoise:* tracepoints. For further details, please refer to the
+respective man page.
+
+MODES
+-----
+*top*::
+  Prints the summary from osnoise tracer.
+*hist*::
+  Prints a histogram of osnoise samples.
+
+If no MODE is given, the top mode is called, passing the arguments.
+
+OPTIONS
+-------
+*-h*, *--help*::
+Display the help text.
+
+For other options, see the man page for the corresponding mode.
+
+SEE ALSO
+--------
+_rtla-osnoise-top(1)_, _rtla-osnoise-hist(1)_
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

