Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18E2C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD0B12084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfDLNie (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51534 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfDLNie (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:34 -0400
Received: by mail-wm1-f66.google.com with SMTP id 4so11293959wmf.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QyKgGJb830tj2VKYVpZN0GpSFpkJhoqYtjtCcSNAbW4=;
        b=QoayqtEMWbEEMTkM/2LJBw5vpHjdyz1gF7CTP3X5EvToWjZPIlEQvg564ikR3GY+oD
         5Y/kbyHNRPnLEbSurdzKcg+iVoaRtwJ9uc2+8byzV5fjoT6+T6M3rhLQAozGyoytNZQC
         9VXclUt4umrNzqZrsXxT1TTCh4aI3ZbFkZpWUsp4KhJnJ4kiZCXzInz/eLoGZi05qCf+
         /SXpobqJ5p86Z/YlYXwgurptkRhCb95YCiX0GrFbJX6bfNTjsuBo9qw1+SGTvL30/yHy
         XrCRxdJH8aLgXbNss81//jk9QNYWAsAntYnhxiPhGchpkUGISJRfw2cHAA0aEbkaKD3M
         dBQw==
X-Gm-Message-State: APjAAAUKZE4HWXirSWJj026gHZ0dUnmAU92TTS6U5RlgydQQ1aXWWn2N
        JQTUvLBKviNjZzwe5SaD4L/36oxU
X-Google-Smtp-Source: APXvYqzGqHEx3sxHUsOkVVb5Y/3UPfUP1YSaDxyVA2M7++7dxs/Wlq/OZtWPnXgRep4X6Q0ih7Iu0Q==
X-Received: by 2002:a1c:730c:: with SMTP id d12mr11531302wmb.10.1555076312034;
        Fri, 12 Apr 2019 06:38:32 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:31 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 21/30] tools/lib/traceevent: Man pages for print field APIs
Date:   Fri, 12 Apr 2019 16:38:02 +0300
Message-Id: <20190412133811.15878-22-tstoyanov@vmware.com>
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
  tep_print_field(),
  tep_print_fields(),
  tep_print_num_field(),
  tep_print_func_field()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-field_print.txt             | 121 ++++++++++++++++++
 1 file changed, 121 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_print.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_print.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_print.txt
new file mode 100644
index 000000000000..7305e2391805
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-field_print.txt
@@ -0,0 +1,121 @@
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
+The _tep_print_fields()_ prints recorded values of all _event_'s fields. It
+iterates all fileds of the _event_, and calls _tep_print_field()_ for each of
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

