Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E53C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE5342087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfCHNhS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:18 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33254 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfCHNhS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:18 -0500
Received: by mail-wr1-f67.google.com with SMTP id i12so21393817wrw.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0vzoqlTsTIa8+mip/6sLndjy8lAI53sdv6Odos24xi0=;
        b=Oysj2h9hKzkLeHnpzC3lOWk0VLfM1tE4BD3CqYYtIO8Q0S3dibXMMyPxxvtoPm6PgG
         +0YMu0rObMLem4S2iPAq6Nyj1OvxA70BTzfuRIxTZ1gZj4P6kbq2He04Lf1mTaGJyfZi
         JLu8uuZu8PJYFAEzz2TmEAjuIHubo+z4QE6kOJDtCgwSsF96NZGWd2++kqV16uUBDBbA
         Kbr+tDYGZCFkItypcWHHZDoPxdDuhNbRuyZWys3y4P389IVYKv+v3UNkx8IP7c9q72LS
         iZkJxDAtLpPezzFuwLmEKppw9h01yg+8RE09UyFm45ITItZjFmIh6E8YWLZD5RGuYojC
         0yww==
X-Gm-Message-State: APjAAAUN6L96azmT+XIMXrCpJSSa4cXe3W4j1CkLiGHEctb7n2ed0CaO
        DrRrQeWTSvPsuObKK+h3P93a0U9y
X-Google-Smtp-Source: APXvYqy34jo30W8lpZcz8R9r3ttSse1NUt0L2EY85n4H/kVhQF47+UeRV+eggxgy64+G7Wl/WaLygQ==
X-Received: by 2002:adf:fdc3:: with SMTP id i3mr10434002wrs.252.1552052236423;
        Fri, 08 Mar 2019 05:37:16 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:15 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 20/46] tools/lib/traceevent: Man pages for tep_print_event(), tep_print_event_data(), tep_event_info(), tep_print_event_task() and tep_print_event_time()
Date:   Fri,  8 Mar 2019 15:36:28 +0200
Message-Id: <20190308133654.21264-21-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_print_event(), tep_print_event_data(),
tep_event_info(), tep_print_event_task() and tep_print_event_time()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-event_print.txt             | 126 ++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_print.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt b/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
new file mode 100644
index 000000000000..8fea72705645
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
@@ -0,0 +1,126 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_print_event,tep_print_event_data,tep_event_info,tep_print_event_task,tep_print_event_time - Parses the data into the print format.
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
+--
+
+DESCRIPTION
+-----------
+The _tep_print_event_time()_ function prints the timestamp of the _record_ using
+the given _event_ information as trace sequence in _s_. The _tep_ argument is
+trace event parser context. The _use_trace_clock_ argument indicates if
+the tep->trace_clock should be used for parsing the timestamp.
+
+The _tep_print_event_task()_ function prints the task command, pid and CPU of
+the _record_ using the given _event_ information as trace sequence in _s_.
+The _tep_ argument is trace event parser context.
+
+The _tep_event_info()_ function parses the raw data from the _record_ using
+the given _event_ information and writes the print format as trace sequence in
+_s_.
+
+The _tep_print_event_data()_ function writes the _event_ name  as trace
+sequence in _s_ and calls _tep_event_info()_ to parse and write the raw data
+from the _record_. The _tep_ argument is trace event parser context.
+
+The _tep_print_event()_ function prints the _record_ information as trace
+sequence in _s_. It finds the corresponding event and calls
+_tep_print_event_task()_,_tep_print_event_time()_ and _tep_print_event_data()_
+to parse and print the information.
+The _tep_ argument is trace event parser context. The _use_trace_clock_
+argument indicates if the tep->trace_clock should be used for parsing
+the timestamp.
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

