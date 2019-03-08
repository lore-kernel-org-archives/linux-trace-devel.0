Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83ACDC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 637A02087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfCHNhU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:20 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38750 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfCHNhU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:20 -0500
Received: by mail-wr1-f66.google.com with SMTP id g12so21392579wrm.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VoK8RZ1bBrmxLQIdPy5NvEXeYk4UUw/Bz0tITaBzfgE=;
        b=JLXmuMyXoiAr2rnI9qbUd0QFazW8hFc6rrZuYrhlUEe1wfbd7BCrh45UP/qGPPLfiS
         7r+2bjfCG11kNoT1kDYhxXzbG/SYCByBURoD4tOaguOVcNl2g0mAkXbWGj7K0s1Nay/D
         kydY6kG8kirgscZiXLE3YfTLI/pW+c8FPqKxWDO9P0AqJ2C1tljvylS0RSdmgala2BqP
         2l0aTlSWp4L67vkt30dTqvC+fzWfbY/HeHQNxV4ay/mH+uEyWkixo3W6hahIzjPJYz6P
         XULyNK5cN8wdoh6O/ukNfC2ERxbOOW2WbEx0KFt0mjGjYVPqtGA2KUk91lQch3yu9eEx
         OVYw==
X-Gm-Message-State: APjAAAV/3IJeBjAyi0jbFcUUftaWW6cTNs0uZ3ep0fRrpoRci/2teqGm
        MSHXuOXa0IYeh7zZjw0EzHc=
X-Google-Smtp-Source: APXvYqywQuGT7krRvp42oHJv2iObEuffBNEPmFdSMQR493NH9mvgAh58r6MP7Hsecupa4gLNB12W3g==
X-Received: by 2002:adf:afe3:: with SMTP id y35mr10839844wrd.318.1552052238292;
        Fri, 08 Mar 2019 05:37:18 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:17 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 22/46] tools/lib/traceevent: Man pages tep_find_common_field(), tep_find_field() and tep_find_any_field()
Date:   Fri,  8 Mar 2019 15:36:30 +0200
Message-Id: <20190308133654.21264-23-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_find_common_field(), tep_find_field()
and tep_find_any_field() as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-field_find.txt              | 98 +++++++++++++++++++
 1 file changed, 98 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_find.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_find.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_find.txt
new file mode 100644
index 000000000000..b941988429a0
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-field_find.txt
@@ -0,0 +1,98 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_find_common_field,tep_find_field,tep_find_any_field - Search for a field in an event.
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
+These functions search for a field with given name in an event.
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
+struct tep_handle *tep = tep_alloc();
+...
+struct tep_event *event = tep_find_event_by_name(tep, "timer", "hrtimer_start");
+...
+	struct tep_format_field *field;
+
+	field = tep_find_common_field(event, "common_pid");
+	if (field == NULL) {
+		/* Cannot find "common_pid" common field in the event */
+	}
+
+	field = tep_find_field(event, "softexpires");
+	if (field == NULL) {
+		/* Cannot find "softexpires" event specific field in the event */
+	}
+
+	field = tep_find_any_field(event, "mode");
+	if (field == NULL) {
+		/* Cannot find "mode" field in the event */
+	}
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

