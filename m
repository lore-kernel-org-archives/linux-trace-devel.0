Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019CEC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE9482084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfDLNil (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:41 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41425 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbfDLNil (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id r4so11966519wrq.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qXfpYV/7hGD7mBqfVtObRA4PvFqsVhDjky1Vxeg/w50=;
        b=GujQYEs5nCugzNDQsWSV77JjZgTo+eDmcZ2B+ZyM9ThUPDg9B4DFeerrG5DPanCOrr
         MBgU4yJKm5vTPsqaM9MFrrMg4ovEKCA3lKuOZhWEi/xy2tLbtKpwyHwz8jEKSaAyegEx
         0gBR4U/Ezi15dD1FN21J1Rh8B+cvaUGzG1/0VyqZUHgSyapLkZnCM1TVeOROwis8qPdr
         RmkC3KoazqwOMF1pAvRe7fO8SQZZkyW03twPYFMcizhmRNUQrC3HhINqc1ASFLFz+Ha/
         01FSUAKYi2Tjh0JVUvgpvCbn4Yy8i18cHsTK/Fc6wj2aeH9mmxuwV3+zTLJSC6j7ujwf
         9Xvw==
X-Gm-Message-State: APjAAAWrPQdviiaWTt4pD9taNCoP+fE1vUUzM2w/cTbVrarg7Prn91Ci
        CaPMQMX0gbKFUJXj3aqnP8m0O6al
X-Google-Smtp-Source: APXvYqxjboqx9nJdQUUF2ErkZvv8wXnL1wKM0rzdWqT2OBk02TSgjuXEzchYinfCalzLtfSKi/SpmA==
X-Received: by 2002:adf:afd7:: with SMTP id y23mr34556922wrd.254.1555076319183;
        Fri, 12 Apr 2019 06:38:39 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:38 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 28/30] tools/lib/traceevent: Man pages for "latency format" APIs
Date:   Fri, 12 Apr 2019 16:38:09 +0300
Message-Id: <20190412133811.15878-29-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for libtraceevent APIs:
  tep_set_latency_format(),
  tep_is_latency_format(),
  tep_data_latency_format()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-latency_format.txt          | 154 ++++++++++++++++++
 1 file changed, 154 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt b/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
new file mode 100644
index 000000000000..3a3c9e9866ec
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
@@ -0,0 +1,154 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_set_latency_format, tep_is_latency_format, tep_data_latency_format -
+"latency output" format APIs.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+void *tep_set_latency_format*(struct tep_handle pass:[*]_tep_, int _lat_);
+bool *tep_is_latency_format*(struct tep_handle pass:[*]_tep_);
+void *tep_data_latency_format*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_);
+
+--
+
+DESCRIPTION
+-----------
+"Latency output" format prints information about interrupts being disabled,
+soft irq being disabled, the "need_resched" flag being set and preempt count.
+This information is recorded with every event, but by default is not printed.
+
+The _tep_set_latency_format()_ function enables the "latency output" printing.
+The _tep_ argument is trace event parser context. The _lat_ argument can be
+zero, for "latency output" disabled, or non zero for "latency output" enabled.
+Information is displayed with 6 characters. When a field is zero, or N/A,
+a pass:['.'] is printed. Example:
+[verse]
+--
+  <idle>-0       0d.h1 106467.859747: function:    ktime_get <-- tick_check_idle
+--
+The 0d.h1. denotes this information. The first character is never a pass:['.']
+and represents what CPU the trace was recorded on (CPU 0). The pass:['d']
+denotes that interrupts were disabled. The pass:['.'] is "need_resched" flag.
+If it is set, the character ['N'] would be displayed. The pass:['h'] means that
+this was called inside an interrupt handler. The pass:['1'] is the preemption
+disabled (preempt_count) was set to one. See 'LATENCY FORMAT' section.
+
+The _tep_is_latency_format()_ function gets if "latency output" is enabled.
+
+The _tep_data_latency_format()_ function parses out the latency format from
+_record_ and writes it into _s_. The _tep_ argument is the trace event parser
+context.
+
+This "Latency output" setting affects output of _tep_print_event_task()_
+and _tep_print_event_time()_ APIs.
+
+LATENCY FORMAT
+--------------
+The latency format displays 5 or more fields:
+[verse]
+--
+CPU #, interrupt state, scheduling state, current context, and preemption count.
+
+Field 1 is the CPU number (starting with zero).
+
+Field 2 is the interrupt enabled state:
+  d : Interrupts are disabled
+  . : Interrupts are enabled
+  X : The architecture does not support this information
+
+Field 3 is the "need resched" state.
+  N : The task is set to call the scheduler when possible, as another
+      higher priority task may need to be scheduled in.
+  . : The task is not set to call the scheduler.
+
+Field 4 is the context state.
+  . : Normal context
+  s : Soft interrupt context
+  h : Hard interrupt context
+  H : Hard interrupt context which triggered during soft interrupt context.
+  z : NMI context
+  Z : NMI context which triggered during hard interrupt context
+
+Field 5 is the preemption count.
+  . : The preempt count is zero.
+
+  On preemptible kernels (where the task can be scheduled out in
+  arbitrary locations while in kernel context), The preempt count,
+  when non zero, will prevent the kernel from scheduling out the
+  current task. The preempt count number is displayed when it is not
+  zero.
+--
+Depending on the kernel, it may show other fields (lock depth,
+or migration disabled, which are unique to specialized kernels).
+
+RETURN VALUE
+------------
+
+The _tep_is_latency_format()_ function returns true if "latency output"
+is enabled, or false if it is disabled.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+struct trace_seq seq;
+trace_seq_init(&seq);
+...
+	tep_set_latency_format(tep, 1);
+...
+	if (tep_is_latency_format(tep)) {
+		/* latency output format is enabled */
+	} else {
+		/* latency output format is disabled */
+	}
+...
+void process_record(struct tep_record *record)
+{
+	/* Write latency information in seq */
+	tep_data_latency_format(tep, &seq, record);
+}
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_, tep_print_event_task(3),
+tep_print_event_time(3)
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

