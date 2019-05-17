Return-Path: <SRS0=lDd+=TR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7901FC04E87
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AC6221743
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 May 2019 19:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558121969;
	bh=zOOOzvFj4VvqACHZm2sdySpg6LWDWMIQqOD5g98Q8/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rnjQgMlwzNBEwC90Ewg0/8MJqIa8mMZj9zUO6sP4iGlZR3RG+2hQ0R3vegtiTblo/
	 rTQMOLSV7zW2Nk/Y+AwHs/tCMCVDKuFmp2AVgZsFKSe9VrVqXb8tdZs1o2Ca85iuZP
	 1C9fSBWYTk6chWJMtXqzqqRU7+wFWnXbOgLyy+50=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbfEQTjO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 May 2019 15:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729803AbfEQTjO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 May 2019 15:39:14 -0400
Received: from quaco.ghostprotocols.net (unknown [190.15.121.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B37F621726;
        Fri, 17 May 2019 19:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558121952;
        bh=zOOOzvFj4VvqACHZm2sdySpg6LWDWMIQqOD5g98Q8/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8qbHPmcLvZM1snaLQ8/PLlDaHjCTsje7BUp7tZekdrr+s+hvCav404ojHGTWZD4H
         8rCaM2/3Mb74UBJVEYsILK2a3QSn56S/zFrYDGuk4vO0HYYDWPY3Zjec2eKbC1Q2SM
         IPyVNh9EDaZJLgc/mJpOcY2VltFop723UWWr4g80=
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
Subject: [PATCH 39/73] tools lib traceevent: Man pages for print field APIs
Date:   Fri, 17 May 2019 16:35:37 -0300
Message-Id: <20190517193611.4974-40-acme@kernel.org>
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

  tep_print_field(),
  tep_print_fields(),
  tep_print_num_field(),
  tep_print_func_field()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190503091119.23399-20-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190510200109.054708419@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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

