Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D7AC282CE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5060D2084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfDLNim (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51545 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfDLNim (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:42 -0400
Received: by mail-wm1-f65.google.com with SMTP id 4so11294536wmf.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pPrLL331apy6OvFrsj5B67meH5BkpFyF8aPQL+p16+k=;
        b=dzN7mmDLxC0xnqTDsxtTflj9qTvQ74TR8mOQNHl/jdGwW9F5xuVVTJIOARfclPxstG
         mXhgKWo8odYuHpgN30OajpGgyce43aW8axPs7ZhG5oZaFiNrlqXZoA5ljxce3JM3hCkz
         59qDaPO6ikH/K6qo65V3hWd9wfyo1u4DdKBS+V0sInatVgtc33s+llfhRtsAoz0u/ncE
         LMqmtzpcE8mKTT1eR1SV6rOJcPHxRKcfcSsiRhgKLf7M4pTrE8qDtxBJdmcjEeKlyBld
         aCfO8AYLevvNod+AuoZdMJHdcaLblsIjxMuMNZ27B1dS/leNM3ZD85EPLsEWl3NiRHrP
         81qw==
X-Gm-Message-State: APjAAAWRV1TF8miiL6ulSeG6UE4KO6k+jEOqat/OTivBzyMpdz+b69Js
        izpYdn95D16oc6F71RWRrWo=
X-Google-Smtp-Source: APXvYqziCrvEt7+1z2v9Bo6QePzqJoZylrsZp3zR2UaLR9gTeHaKkw0KE6IhfvVcHMSQ4ze84rOSqg==
X-Received: by 2002:a1c:a103:: with SMTP id k3mr11286832wme.8.1555076320143;
        Fri, 12 Apr 2019 06:38:40 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:39 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 29/30] tools/lib/traceevent: Man pages for APIs, used to extract common fields from a record
Date:   Fri, 12 Apr 2019 16:38:10 +0300
Message-Id: <20190412133811.15878-30-tstoyanov@vmware.com>
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
 tep_data_type(),
 tep_data_pid(),
 tep_data_preempt_count(),
 tep_data_flags()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-record_parse.txt            | 137 ++++++++++++++++++
 1 file changed, 137 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt b/tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt
new file mode 100644
index 000000000000..1e1b38e03fa7
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt
@@ -0,0 +1,137 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_data_type, tep_data_pid,tep_data_preempt_count, tep_data_flags -
+Extract common fields from a record.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *trace_flag_type* {
+	_TRACE_FLAG_IRQS_OFF_,
+	_TRACE_FLAG_IRQS_NOSUPPOR_,
+	_TRACE_FLAG_NEED_RESCHED_,
+	_TRACE_FLAG_HARDIRQ_,
+	_TRACE_FLAG_SOFTIRQ_,
+};
+
+int *tep_data_type*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
+int *tep_data_pid*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
+int *tep_data_preempt_count*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
+int *tep_data_flags*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
+--
+
+DESCRIPTION
+-----------
+This set of functions can be used to extract common fields from a record.
+
+The _tep_data_type()_ function gets the event id from the record _rec_.
+It reads the "common_type" field. The _tep_ argument is the trace event parser
+context.
+
+The _tep_data_pid()_ function gets the process id from the record _rec_.
+It reads the "common_pid" field. The _tep_ argument is the trace event parser
+context.
+
+The _tep_data_preempt_count()_ function gets the preemption count from the
+record _rec_. It reads the "common_preempt_count" field. The _tep_ argument is
+the trace event parser context.
+
+The _tep_data_flags()_ function gets the latency flags from the record _rec_.
+It reads the "common_flags" field. The _tep_ argument is the trace event parser
+context. Supported latency flags are:
+[verse]
+--
+	_TRACE_FLAG_IRQS_OFF_,		Interrupts are disabled.
+	_TRACE_FLAG_IRQS_NOSUPPOR_,	Reading IRQ flag is not supported by the architecture.
+	_TRACE_FLAG_NEED_RESCHED_,	Task needs rescheduling.
+	_TRACE_FLAG_HARDIRQ_,		Hard IRQ is running.
+	_TRACE_FLAG_SOFTIRQ_,		Soft IRQ is running.
+--
+
+RETURN VALUE
+------------
+The _tep_data_type()_ function returns an integer, representing the event id.
+
+The _tep_data_pid()_ function returns an integer, representing the process id
+
+The _tep_data_preempt_count()_ function returns an integer, representing the
+preemption count.
+
+The _tep_data_flags()_ function returns an integer, representing the latency
+flags. Look at the _trace_flag_type_ enum for supported flags.
+
+All these functions in case of an error return a negative integer.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+void process_record(struct tep_record *record)
+{
+	int data;
+
+	data = tep_data_type(tep, record);
+	if (data >= 0) {
+		/* Got the ID of the event */
+	}
+
+	data = tep_data_pid(tep, record);
+	if (data >= 0) {
+		/* Got the process ID */
+	}
+
+	data = tep_data_preempt_count(tep, record);
+	if (data >= 0) {
+		/* Got the preemption count */
+	}
+
+	data = tep_data_flags(tep, record);
+	if (data >= 0) {
+		/* Got the latency flags */
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

