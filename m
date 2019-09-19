Return-Path: <SRS0=Eaid=XO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F09C3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 21:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11784218AF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 21:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391028AbfISV0C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 17:26:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389506AbfISVZn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 17:25:43 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6796021907;
        Thu, 19 Sep 2019 21:25:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iB3vp-0008Sm-LP; Thu, 19 Sep 2019 17:25:41 -0400
Message-Id: <20190919212541.553160178@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 19 Sep 2019 17:23:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH 1/6] tools/lib/traceevent: Man pages for libtraceevent event print related
 API
References: <20190919212335.400961206@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Added new man page, describing tep_print_event() libtraceevent API.

Link: http://lore.kernel.org/linux-trace-devel/20190801075012.22098-1-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../libtraceevent-event_print.txt             | 130 ++++++++++++++++++
 1 file changed, 130 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_print.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
new file mode 100644
index 000000000000..2c6a61811118
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
@@ -0,0 +1,130 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_print_event - Writes event information into a trace sequence.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+void *tep_print_event*(struct tep_handle pass:[*]_tep_, struct trace_seqpass:[*]_s_, struct tep_record pass:[*]_record_, const char pass:[*]_fmt_, _..._)
+--
+
+DESCRIPTION
+-----------
+
+The _tep_print_event()_ function parses the event information of the given
+_record_ and writes it into the trace sequence _s_, according to the format
+string _fmt_. The desired information is specified after the format string.
+The _fmt_ is printf-like format string, following arguments are supported:
+[verse]
+--
+	TEP_PRINT_PID, "%d"  - PID of the event.
+	TEP_PRINT_CPU, "%d"  - Event CPU.
+	TEP_PRINT_COMM, "%s" - Event command string.
+	TEP_PRINT_NAME, "%s" - Event name.
+	TEP_PRINT_LATENCY, "%s" - Latency of the event. It prints 4 or more
+			fields - interrupt state, scheduling state,
+			current context, and preemption count.
+			Field 1 is the interrupt enabled state:
+				d : Interrupts are disabled
+				. : Interrupts are enabled
+				X : The architecture does not support this
+				    information
+			Field 2 is the "need resched" state.
+				N : The task is set to call the scheduler when
+				    possible, as another higher priority task
+				    may need to be scheduled in.
+				. : The task is not set to call the scheduler.
+			Field 3 is the context state.
+				. : Normal context
+				s : Soft interrupt context
+				h : Hard interrupt context
+				H : Hard interrupt context which triggered
+				    during soft interrupt context.
+				z : NMI context
+				Z : NMI context which triggered during hard
+				    interrupt context
+			Field 4 is the preemption count.
+				. : The preempt count is zero.
+			On preemptible kernels (where the task can be scheduled
+			out in arbitrary locations while in kernel context), the
+			preempt count, when non zero, will prevent the kernel
+			from scheduling out the current task. The preempt count
+			number is displayed when it is not zero.
+			Depending on the kernel, it may show other fields
+			(lock depth, or migration disabled, which are unique to
+			specialized kernels).
+	TEP_PRINT_TIME, %d - event time stamp. A divisor and precision can be
+			specified as part of this format string:
+			"%precision.divisord". Example:
+			"%3.1000d" - divide the time by 1000 and print the first
+			3 digits before the dot. Thus, the time stamp
+			"123456000" will be printed as "123.456"
+	TEP_PRINT_INFO, "%s" - event information.
+	TEP_PRINT_INFO_RAW, "%s" - event information, in raw format.
+
+--
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct trace_seq seq;
+trace_seq_init(&seq);
+struct tep_handle *tep = tep_alloc();
+...
+void print_my_event(struct tep_record *record)
+{
+	trace_seq_reset(&seq);
+	tep_print_event(tep, s, record, "%16s-%-5d [%03d] %s %6.1000d %s %s",
+			TEP_PRINT_COMM, TEP_PRINT_PID, TEP_PRINT_CPU,
+			TEP_PRINT_LATENCY, TEP_PRINT_TIME, TEP_PRINT_NAME,
+			TEP_PRINT_INFO);
+}
+...
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*trace-seq.h*
+	Header file to include in order to have access to trace sequences related APIs.
+	Trace sequences are used to allow a function to call several other functions
+	to create a string of data to use.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
-- 
2.20.1


