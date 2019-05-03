Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E26C004C9
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55869206C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 09:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfECJLh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 05:11:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45338 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfECJLh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 05:11:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id s15so6836117wra.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 02:11:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c7OpjGTjS/0SCcfU9EFvP5Z6UhyFladJ5cnJxnD1qJs=;
        b=D+8W9W12h2JuOmyy7pV6iTAvoouKCYTJMtkxm+J2xBbdjNBid31RR+51sh6eaBs25n
         CGfEIPqm65RtSv8QXb7lkfB1cgg1IjrfTxmtcTqkT68oQ2/c5h196H/SPRSy/xrDHWDo
         2GFQgE0/hMgVnIaIsapu4iS+NizcbsCuOzKG8rnuFJAAje81xqcruxoNEEwlcbD5AAD6
         xClcJ/3J1Jn1Lz5I6CftpzfTXA5mdiJhT8CxVQ3ZT2ZktSk56X2Q4bhkeeJBAMpa9aGW
         4IsPXbBYLHAxtLiAeXeJ/5eEpjirEE5mhSDlmZ1AWTc0gh3OfKNycdFxZF3YHuv/RJOF
         hd5w==
X-Gm-Message-State: APjAAAVgNCeETuHJ0/qe6Mi65k+IW9TjWeZQNN6SzY71xSFKLVxe8/4y
        aiKFKkXNn7Oe9QMPqxqpdDE=
X-Google-Smtp-Source: APXvYqzcXKE+I0/r5ouLqt7/FrvaxkdvTDbYOnzaCPNcDWycweJMKomeaXS1c5sddSXHJNi1z7b5Sw==
X-Received: by 2002:a5d:604d:: with SMTP id j13mr6025302wrt.55.1556874695457;
        Fri, 03 May 2019 02:11:35 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b11sm2398596wmh.29.2019.05.03.02.11.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 02:11:35 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 17/26] tools/lib/traceevent: Man pages find field APIs
Date:   Fri,  3 May 2019 12:11:10 +0300
Message-Id: <20190503091119.23399-18-tstoyanov@vmware.com>
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
  tep_find_common_field(),
  tep_find_field()
  tep_find_any_field()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-field_find.txt              | 118 ++++++++++++++++++
 1 file changed, 118 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_find.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_find.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_find.txt
new file mode 100644
index 000000000000..0896af5b9eff
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-field_find.txt
@@ -0,0 +1,118 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_find_common_field, tep_find_field, tep_find_any_field -
+Search for a field in an event.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_format_field pass:[*]*tep_find_common_field*(struct tep_event pass:[*]_event_, const char pass:[*]_name_);
+struct tep_format_field pass:[*]*tep_find_field*(struct tep_event_ormat pass:[*]_event_, const char pass:[*]_name_);
+struct tep_format_field pass:[*]*tep_find_any_field*(struct tep_event pass:[*]_event_, const char pass:[*]_name_);
+--
+
+DESCRIPTION
+-----------
+These functions search for a field with given name in an event. The field
+returned can be used to find the field content from within a data record.
+
+The _tep_find_common_field()_ function searches for a common field with _name_
+in the _event_.
+
+The _tep_find_field()_ function searches for an event specific field with
+_name_ in the _event_.
+
+The _tep_find_any_field()_ function searches for any field with _name_ in the
+_event_.
+
+RETURN VALUE
+------------
+The _tep_find_common_field(), _tep_find_field()_ and _tep_find_any_field()_
+functions return a pointer to the found field, or NULL in case there is no field
+with the requested name.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+void get_htimer_info(struct tep_handle *tep, struct tep_record *record)
+{
+	struct tep_format_field *field;
+	struct tep_event *event;
+	long long softexpires;
+	int mode;
+	int pid;
+
+	event = tep_find_event_by_name(tep, "timer", "hrtimer_start");
+
+	field = tep_find_common_field(event, "common_pid");
+	if (field == NULL) {
+		/* Cannot find "common_pid" field in the event */
+	} else {
+		/* Get pid from the data record */
+		pid = tep_read_number(tep, record->data + field->offset,
+				      field->size);
+	}
+
+	field = tep_find_field(event, "softexpires");
+	if (field == NULL) {
+		/* Cannot find "softexpires" event specific field in the event */
+	} else {
+		/* Get softexpires parameter from the data record */
+		softexpires = tep_read_number(tep, record->data + field->offset,
+					      field->size);
+	}
+
+	field = tep_find_any_field(event, "mode");
+	if (field == NULL) {
+		/* Cannot find "mode" field in the event */
+	} else
+	{
+		/* Get mode parameter from the data record */
+		mode = tep_read_number(tep, record->data + field->offset,
+				       field->size);
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

