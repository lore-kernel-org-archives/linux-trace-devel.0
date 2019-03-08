Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E30C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0451A2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfCHNhV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:21 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33258 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbfCHNhV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:21 -0500
Received: by mail-wr1-f66.google.com with SMTP id i12so21393973wrw.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2WcUNq91Sa+L9JNqxAv6wVI1ERPpxmfxrgVkMMg/soc=;
        b=hc322iya/nToF8gwoJS9ajIQwsZJI1OuUiGsEdeDjN7esOKYxNvIZgDCqHhqzjnLgO
         supJDwKGtVnjLj54FZykS0BQP2NUKFxBGG+eQlde/MTxEgijFIfn8uOx/7UVBHmyVp1H
         wI31szS8CPHM0yCaP4Jgoenz+OUQMeufnW1cnXRGohvsrkOnsxvlWshqztTc2eGvw/c9
         MToIBKexLtdRHO0l2m9YNH+a6uSYwTFrAIcprF40xz3JGfp6qNUsDMEvBz0qLAk/y6J8
         z8QNbDZ+zMV4JUm37QK4EmWUyGkjQATxYl8ZVclbMc7UHAjEu9mpmHiChtmaFcP368Cj
         f4vw==
X-Gm-Message-State: APjAAAVxYVSOtMO1s+bfC8e7AvuIdiWLYchlEOzpm5LGoeP7IIHaF1mN
        kXtNn9YMWBGUxfuuc+KLOfE=
X-Google-Smtp-Source: APXvYqx3xGg4fwPVZPndJ3IDaTio9ntxbx+A4he4TYytk4hlkFnalrQx1c/iBdbdt3zIa0KXaa6Ntw==
X-Received: by 2002:a5d:6b8f:: with SMTP id n15mr11226205wrx.110.1552052239106;
        Fri, 08 Mar 2019 05:37:19 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:18 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 23/46] tools/lib/traceevent: Man pages tep_get_any_field_val(), tep_get_common_field_val(), tep_get_field_val() and tep_get_field_raw()
Date:   Fri,  8 Mar 2019 15:36:31 +0200
Message-Id: <20190308133654.21264-24-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_get_any_field_val(), tep_get_common_field_val(),
tep_get_field_val() and tep_get_field_raw() as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-field_get_val.txt           | 117 ++++++++++++++++++
 1 file changed, 117 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt
new file mode 100644
index 000000000000..dbb4875c49fb
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt
@@ -0,0 +1,117 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_any_field_val,tep_get_common_field_val,tep_get_field_val,tep_get_field_raw - Get value of a field.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+int *tep_get_any_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
+int *tep_get_common_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
+int *tep_get_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, unsigned long long pass:[*]_val_, int _err_);
+void pass:[*]*tep_get_field_raw*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_, int pass:[*]_len_, int _err_);
+--
+
+DESCRIPTION
+-----------
+These functions can be used to find a field and retrieve its value.
+
+The _tep_get_any_field_val()_ function searches in the _record_ for a filed with
+_name_, part of the _event_. If the field is found, its value is stored in _val_.
+In case of an error, an error string is printed into _s_, if _err_ is not 0.
+
+The _tep_get_common_field_val()_ function does the same as
+_tep_get_any_field_val()_, but searches only in the common fields.
+
+The _tep_get_field_val()_ function does the same as
+_tep_get_any_field_val()_, but searches only in the event specific fields.
+
+The _tep_get_field_raw()_ function searches in the _record_ for a filed with _name_,
+part of the _event_. If the field is found, a pointer to its raw data is returned.
+The size of the data is stored in _len_. In case of an error, an error string
+is printed into _s_, if _err_ is not 0.
+
+RETURN VALUE
+------------
+The _tep_get_any_field_val()_, _tep_get_common_field_val()_ and
+_tep_get_field_val()_ functions return 0 on success, or -1 in case of an error.
+
+The _tep_get_field_raw()_ function returns a pointer to field's raw data, and
+places the length of this data in _len_. In case of an error NULL is returned.
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
+struct tep_event *event = tep_find_event_by_name(tep, "kvm", "kvm_exit");
+...
+void process_record(struct tep_record *record)
+{
+	int len;
+	char *comm;
+	struct tep_event_format *event;
+	unsigned long long val;
+
+	event = tep_find_event_by_record(pevent, record);
+	if (event != NULL) {
+		if (tep_get_common_field_val(NULL, event, "common_type", record, &val, 0) == 0) {
+			/* Got the value of common type field */
+		}
+		if (tep_get_field_val(NULL, event, "pid", record, &val, 0) == 0) {
+			/* Got the value of pid specific field */
+		}
+		comm = tep_get_field_raw(NULL, event, "comm", record, &len, 0);
+		if (comm != NULL) {
+			/* Got a pointer to the comm event specific field */
+		}
+	}
+}
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

