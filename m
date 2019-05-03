Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36808C04AAA
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11A17206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfECJLj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33013 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfECJLj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id e28so6927906wra.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zoCHQUw1ssGCWeN97SX1loE84Ah7IvIDRnJb8jnANtw=;
        b=N3ncxhVCC14i/g+w1l1P7Hx9duq2Lf1oCOTKdEGRGl3fKKNpTksGs9IztzYTvF+l9z
         3aThzXDmhtwWAHvfgvbkHemZkP8ulOxbU5evw3k2/Hcq7s09+HI13C4fElGyVUqmWNM6
         wuPi6VSTSUlwbRIhigyYAoPsDvckr4kUef8zyqwgcQAsu4mxYuxaPhBAKxwEktE776p0
         uoee23KS+5KBUa3PFThq7jsDKYr8XZKDyVYMDGNtV4R5iaaXVAaMosjSlmRrGcL03pLg
         UqRJr1WQkflm/K7R2pOBJCuENnT0cQK3n3KQc1qwotjaPNo3hJKf7YzG6ojShtE8eKlN
         eN4Q==
X-Gm-Message-State: APjAAAWQnKGLcUDlabmCwZbqdtvX9yKDomxOhzSYqVQTzku2QIvaHGdA
        pNMa36jYxzKRJPF4pjGRgOk=
X-Google-Smtp-Source: APXvYqybwRdtd17cALLvxAi22cgk1Z8ApUaH/WK59E9iZgTa4IC/i66iNsJpBn0M5sSrlFwLeTgBzw==
X-Received: by 2002:adf:c748:: with SMTP id b8mr6073780wrh.292.1556874697220;
        Fri, 03 May 2019 02:11:37 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:36 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 19/26] tools/lib/traceevent: Man pages for print field APIs
Date:   Fri,  3 May 2019 12:11:12 +0300
Message-Id: <20190503091119.23399-20-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503091119.23399-1-tstoyanov@vmware.com>
References: <20190503091119.23399-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for libtraceevent APIs:
  tep_print_field(),
  tep_print_fields(),
  tep_print_num_field(),
  tep_print_func_field()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-field_print.txt             | 126 ++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_print.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_print.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_print.txt
new file mode 100644
index 000000000000..2fe0c282f4d9
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
+ 	struct tep_format_field *field_pid = tep_find_common_field(event, "common_pid");
+
+ 	trace_seq_reset(&seq);
+
+ 	/* Print the value of "common_pid" */
+ 	tep_print_field(&seq, record->data, field_pid);
+
+ 	/* Print all fields of the "hrtimer_start" event */
+ 	tep_print_fields(&seq, record->data, record->size, event);
+
+ 	/* Print the value of "expires" field with custom format string */
+ 	tep_print_num_field(&seq, " timer expires in %llu ", event, "expires", record, 0);
+
+ 	/* Print the address and the name of "function" field with custom format string */
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

