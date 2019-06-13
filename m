Return-Path: <SRS0=Le/E=UM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8B8C31E4A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0698206BB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:36:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfFMPgY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:36:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52225 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbfFMKSz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 06:18:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so9580127wms.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jun 2019 03:18:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lJ7+/c/WAkKVkbI6XyMUhScqD+X+tXhqbDhiJPX7GtA=;
        b=T5PXXOW0H4+D1+pf7AnkmEzt8aBVBcDOdt6num9MpfjpyWfZiSLunwZeZhVWebVzGo
         LmSf99tshTSbEkgS6qvaJeRli5eIhoByTm5YQ0pNuQtbrfGft/P+WFxleUDPmSsaQTxv
         wbCro06USSjNT/+cvbklD7FfrPQK/YiwKKWv0BUugKt4MVIBr7MTLgS5pF6EBX3hZoPw
         H9QvonposobHN7OOcYULfFQdPHeZKmkpSp2tF4X4J3ifEwfmEXlZP//dqgbbxD1XjD+S
         mcEhgePATgHFlZoTfcKcpEqP2Bbe364N6BZulfAyTNTyjr+ERkZPZj9EbTRhq/dwtlGt
         EY3w==
X-Gm-Message-State: APjAAAUOb2mp76w78a2+4ayOVVl12sN7zhpfk2+snywN3Lr/oSY9lcP3
        7FXOG4UNTKfkTZ1H6+AFkFs=
X-Google-Smtp-Source: APXvYqwfqWwFt3urHlj562jtN9R2H0enihRde20seGjZrIp7MF3qQ//kBCPXSfEtJwL1ztfD/IApCw==
X-Received: by 2002:a7b:cb4b:: with SMTP id v11mr2968976wmj.85.1560421132705;
        Thu, 13 Jun 2019 03:18:52 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s9sm2712198wmc.11.2019.06.13.03.18.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 03:18:52 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 1/2] tools/lib/traceevent: Man pages for libtraceevent event print related API
Date:   Thu, 13 Jun 2019 13:18:50 +0300
Message-Id: <20190613101851.22811-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new man page, describing tep_print_event() libtraceevent API.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-event_print.txt             | 130 ++++++++++++++++++
 1 file changed, 130 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_print.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
new file mode 100644
index 000000000000..ddbf99b9c661
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
+	TEP_PRINT_INFO, "%s" - event information. If any width is specified in
+			the format string, the event information will be
+			printed in raw format.
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
2.21.0

