Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FEAC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FAAD2084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfDLNia (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:30 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50248 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfDLNia (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:30 -0400
Received: by mail-wm1-f68.google.com with SMTP id z11so11357154wmi.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AFwVAijLoCh30tb6KrgZ0JsJmiHOCnKRknkIp8Jy59E=;
        b=RholWza6FE7BDli2GI+/psFEsIrRjEfCZ5K9A+CwYtfaSIvqFHP7igb5V955KjNCjw
         MwF3ZSsFUkTjVvUSQHNcLQJq5t7vkyn4XLsJhCAFHso4ptJ6/mOSWJdmKcRICCoDERo6
         oI4JrP2uUADU+h+LhtH3ApOw3WFiA7jEYVm4DfV9mtb/xJBMwwo1o5fVahu9ON9/hCqU
         869NIdENU8vn44Xqj5jgXDMZBqprAd3nBfu02HKu1tBcJU9rfYi+vTbE6QlAqKHT4Nek
         pYlm802jf0ujK4BdGZrMBNYGykpnIPHucdw062q05N0Wtzj91htIpP8vjsbR6/VsAp0p
         Qcew==
X-Gm-Message-State: APjAAAX54R5wBi/qDzeSpBJRdzwnbtV/Xd79gSb+8L1JC/1P7X+gspR8
        23KMyQuVBdBGRR+OCAhd8aImT87X
X-Google-Smtp-Source: APXvYqxUEQ4gN5EyATtSTyYjPDE9Uf5oeMJgd/4AXRkUvAHSxjes/qwECnDuBJ6/R9O9H8LTeyl3jA==
X-Received: by 2002:a7b:c3d7:: with SMTP id t23mr10739487wmj.62.1555076308315;
        Fri, 12 Apr 2019 06:38:28 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:27 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 17/30] tools/lib/traceevent: Man pages for libtraceevent event print related APIs
Date:   Fri, 12 Apr 2019 16:37:58 +0300
Message-Id: <20190412133811.15878-18-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190412133811.15878-1-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new man pages, describing libtraceevent event print related APIs:
  tep_print_event(),
  tep_print_event_data(),
  tep_event_info(),
  tep_print_event_task(),
  tep_print_event_time(),
  tep_set_print_raw()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-event_print.txt             | 138 ++++++++++++++++++
 1 file changed, 138 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_print.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
new file mode 100644
index 000000000000..2a0dec71fd99
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
@@ -0,0 +1,138 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_print_event, tep_print_event_data, tep_event_info, tep_print_event_task,
+tep_print_event_time, tep_set_print_raw - Parses the data into the print format.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+void *tep_print_event_time*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]record, bool _use_trace_clock_);
+void *tep_print_event_task*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
+void *tep_event_info*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
+void *tep_print_event_data*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
+void *tep_print_event*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, bool _use_trace_clock_);
+void *tep_set_print_raw*(struct tep_handle pass:[*]_tep_, int _print_raw_);
+--
+
+DESCRIPTION
+-----------
+The _tep_print_event_time()_ function writes the timestamp of the given _record_
+into the trace sequence _s_. The _tep_ argument is trace event parser context.
+The _use_trace_clock_ argument indicates if the tep->trace_clock should be used
+for parsing the timestamp.
+
+The _tep_print_event_task()_ function writes the task command, pid and CPU of
+the given _record_ using the given _event_ information into the trace sequence
+_s_. The _tep_ argument is trace event parser context.
+
+The _tep_event_info()_ function parses the raw data from the _record_ using
+the given _event_ information and writes the print format into the trace
+sequence _s_.
+
+The _tep_print_event_data()_ function writes the name of the _record_ using the
+given _event_ information into the trace sequence _s_ and calls
+_tep_event_info()_ to parse and write the raw data from the _record_. The _tep_
+argument is trace event parser context.
+
+The _tep_print_event()_ function writes the _record_ information. It finds the
+corresponding event and calls _tep_print_event_task()_, _tep_print_event_time()_
+and _tep_print_event_data()_ to parse and write the information, into the trace
+sequence _s_. The _tep_ argument is trace event parser context.
+The _use_trace_clock_ argument indicates if the tep->trace_clock should be used
+for parsing the timestamp.
+
+The _tep_set_print_raw()_ function forces event's information to be printed in
+raw format. It changes the behavior of _tep_event_info()_ function. The _tep_
+argument is trace event parser context. The _print_raw_ argument specifies
+whether to print in raw format or not.
+
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
+	struct tep_event *event;
+
+	/* print all event information */
+	trace_seq_reset(&seq);
+	tep_print_event(tep, &seq, record, TRUE);
+
+	event = tep_find_event_by_record(tep, record);
+
+	if (event != NULL) {
+		/* print event timestamp */
+		trace_seq_reset(&seq);
+		tep_print_event_time(tep, &seq, event, record, TRUE);
+
+		/* print event task information */
+		trace_seq_reset(&seq);
+		tep_print_event_task(tep, &seq, event, record);
+
+		/* print event name and raw data */
+		trace_seq_reset(&seq);
+		tep_print_event_data(tep, &seq, event, record);
+
+		/* print event raw data */
+		trace_seq_reset(&seq);
+		tep_event_info(&seq, event, record);
+
+		/* print event raw data in raw format */
+		trace_seq_reset(&seq);
+		tep_set_print_raw(tep, 1);
+		tep_event_info(&seq, event, record);
+	}
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

