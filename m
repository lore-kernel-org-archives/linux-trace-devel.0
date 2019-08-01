Return-Path: <SRS0=bY76=V5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED007C433FF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 07:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7E922087E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Aug 2019 07:50:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ihrvVAka"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfHAHuR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 03:50:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54899 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbfHAHuR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 03:50:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so63502068wme.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Aug 2019 00:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VydjWxgFLcBhhGpqUvNCxmX9fb/5D37fGYvzh6LVuTc=;
        b=ihrvVAkaMetvsSTtCiB+Ax0vUwDIx7yOyyNuYsXS5gxeFW1HosUbOaOaHY0FRaVmeI
         nd1X849kD3oCv0CVHtns28lrgQLCYw77cs2j5MCz52kT91/UdpLpohXwpNJyyW3qux7D
         pHzd0oxPcdlCikAP2oUzPR9biJigNB7wWDKMNmD8l5uXvVniJshPVVtbygRSMdpLzG/e
         pE92kXjCLlUpaSN6qpYThsnWPcImVgq8jEjZ02ARaQMGyTtXuH/PzfEGFghyPI1Q+jYe
         +PrWKXfBZoza13BaHI/1gtwd9AH0vhCaC/PTWr6n8jtD5fY4F0nxfihX20cWafhLk1Ej
         0ddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VydjWxgFLcBhhGpqUvNCxmX9fb/5D37fGYvzh6LVuTc=;
        b=ie03hfacfbbbBVQRguCnA3UQe85lQp4hlM8GQ2J4lUO0ah4a7mG+tcFRPdyI3AgGIN
         nJWtwcrYNgVX+75o/94FtcKSGsY5NsVQ6zTWVKq9AKZY1w3bcMyXjeFwlrlkUgk1JYA6
         BsC9lbmDGfQGrn+mAPuSw34yTJKw5A0uMjvYz5QGhey5FIYmvL/4hDJXb95qjqNpyokl
         8V3wGXXg19ykgmZdQ5bo10EEVZh1gU356pctBRbiY+95vx/VoVIEvdE3xfpOVLe5ebSq
         qdht76Ipxnd9xqYjEdRWc4kbfO/0VQ0AfVVeE1bLQFmUF2ZCol4ea6XcFV5LzSEFeLjF
         2oCA==
X-Gm-Message-State: APjAAAVpwhAIiXMj5vdEA9vWt2vfmC2EMz4gTDb6knLcKnZoKofOTPMG
        A8Zcds2RZFG+KexXRPWpyX29Oa8p208=
X-Google-Smtp-Source: APXvYqyWFJOcnOAR/PB8ypXimInP7UxD6u1QhjML6IfOq3Zlrp1A4NS9mwA57slXEOVbjIZWz2jN+w==
X-Received: by 2002:a1c:618a:: with SMTP id v132mr49254429wmb.17.1564645815001;
        Thu, 01 Aug 2019 00:50:15 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x16sm53157737wmj.4.2019.08.01.00.50.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 00:50:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8] tools/lib/traceevent: Man pages for libtraceevent event print related API
Date:   Thu,  1 Aug 2019 10:50:12 +0300
Message-Id: <20190801075012.22098-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Added new man page, describing tep_print_event() libtraceevent API.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
[
 v8 changes:
  - New tep_print_event() item is added - TEP_PRINT_INFO_RAW, to print
    event information in raw format.
]

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
2.21.0

