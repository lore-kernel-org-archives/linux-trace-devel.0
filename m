Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7F9C04A6B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8948217D6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbfEJUBy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 16:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbfEJUBL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 16:01:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 055EB217F5;
        Fri, 10 May 2019 20:01:10 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hPBhd-0006nH-5C; Fri, 10 May 2019 16:01:09 -0400
Message-Id: <20190510200109.054708419@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 10 May 2019 15:56:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: [PATCH 20/27] tools/lib/traceevent: Man pages for print field APIs
References: <20190510195606.537643615@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Create man pages for libtraceevent APIs:
  tep_print_field(),
  tep_print_fields(),
  tep_print_num_field(),
  tep_print_func_field()

Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-20-tstoyanov@vmware.com

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../libtraceevent-field_print.txt             | 126 ++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_print.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_print.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_print.txt
new file mode 100644
index 000000000000..9a9df98ac44d
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-field_print.txt
@@ -0,0 +1,126 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_print_field, tep_print_fields, tep_print_num_field, tep_print_func_field -
+Print the field content.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+void *tep_print_field*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, struct tep_format_field pass:[*]_field_);
+void *tep_print_fields*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, int _size_, struct tep_event pass:[*]_event_);
+int *tep_print_num_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
+int *tep_print_func_field*(struct trace_seq pass:[*]_s_, const char pass:[*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int _err_);
+--
+
+DESCRIPTION
+-----------
+These functions print recorded field's data, according to the field's type.
+
+The _tep_print_field()_ function extracts from the recorded raw _data_ value of
+the _field_ and prints it into _s_, according to the field type.
+
+The _tep_print_fields()_ prints each field name followed by the record's field
+value according to the field's type:
+[verse]
+--
+"field1_name=field1_value field2_name=field2_value ..."
+--
+It iterates all fields of the _event_, and calls _tep_print_field()_ for each of
+them.
+
+The _tep_print_num_field()_ function prints a numeric field with given format
+string. A search is performed in the _event_ for a field with _name_. If such
+field is found, its value is extracted from the _record_ and is printed in the
+_s_, according to the given format string _fmt_. If the argument _err_ is
+non-zero, and an error occures - it is printed in the _s_.
+
+The _tep_print_func_field()_ function prints a function field with given format
+string.  A search is performed in the _event_ for a field with _name_. If such
+field is found, its value is extracted from the _record_. The value is assumed
+to be a function address, and a search is perform to find the name of this
+function. The function name (if found) and its address are printed in the _s_,
+according to the given format string _fmt_. If the argument _err_ is non-zero,
+and an error occures - it is printed in _s_.
+
+RETURN VALUE
+------------
+The _tep_print_num_field()_ and _tep_print_func_field()_ functions return 1
+on success, -1 in case of an error or 0 if the print buffer _s_ is full.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+struct trace_seq seq;
+trace_seq_init(&seq);
+struct tep_event *event = tep_find_event_by_name(tep, "timer", "hrtimer_start");
+...
+void process_record(struct tep_record *record)
+{
+	struct tep_format_field *field_pid = tep_find_common_field(event, "common_pid");
+
+	trace_seq_reset(&seq);
+
+	/* Print the value of "common_pid" */
+	tep_print_field(&seq, record->data, field_pid);
+
+	/* Print all fields of the "hrtimer_start" event */
+	tep_print_fields(&seq, record->data, record->size, event);
+
+	/* Print the value of "expires" field with custom format string */
+	tep_print_num_field(&seq, " timer expires in %llu ", event, "expires", record, 0);
+
+	/* Print the address and the name of "function" field with custom format string */
+	tep_print_func_field(&seq, " timer function is %s ", event, "function", record, 0);
+ }
+ ...
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


