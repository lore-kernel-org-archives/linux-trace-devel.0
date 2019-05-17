Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30EEAC04E87
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 032462173C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558121987;
	bh=Pki2Aaa++CF5Sm8Vvh+8o3szdBpJoA8iAy2VJYoAHjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eaNN6YpElYpUlQbI0aKfVq6fmb+LgTehZ+gNfZLCCx4PqwSZwwyZKSPv/3rB8lTTI
	 1C0pK61sSnZq88yZJyliW8yWwZRcBILp4nt7n+2SIt2CbMWyPhBWbH/AguVLehVpX5
	 oYfhsniQ3bwsyrfKnptJyRB++vfAebaqcckYLCF0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbfEQTjl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729566AbfEQTjl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:39:41 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 880D821726;
        Fri, 17 May 2019 19:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121979;
        bh=Pki2Aaa++CF5Sm8Vvh+8o3szdBpJoA8iAy2VJYoAHjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sn6BdZkMQpL5nxAiXLb0Jq4Yp9YZhT2DUBGKsCdP9qDSDRMp5IquOnRsA4YReh2YL
         54EgBJ6nq/K3QtwWfzg0KmREj7mCCEcmOuS+Ew+IGHqfyZ0C97GU2Z24BS2W6ljeHJ
         eFJRlfPhlJzYzVGkUOXN2O3Xd25jw3lOyfWnCDos=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 45/73] tools lib traceevent: Man pages for APIs used to extract common fields from a record
Date:   Fri, 17 May 2019 16:35:43 -0300
Message-Id: <20190517193611.4974-46-acme@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190517193611.4974-1-acme@kernel.org>
References: <20190517193611.4974-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Create man pages for libtraceevent APIs:

 tep_data_type(),
 tep_data_pid(),
 tep_data_preempt_count(),
 tep_data_flags()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-26-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200110.284281830@goodmis.org
[ Fixed missing T in description of NOSUPPORT flag ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../libtraceevent-record_parse.txt            | 137 ++++++++++++++++++
 1 file changed, 137 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt b/tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt
new file mode 100644
index 000000000000..e9a69116c78b
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
+	_TRACE_FLAG_IRQS_NOSUPPORT_,
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
+	_TRACE_FLAG_IRQS_NOSUPPORT_,	Reading IRQ flag is not supported by the architecture.
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

