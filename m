Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEF1C10F09
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF6CB2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfCHNhX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:23 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46367 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfCHNhX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:23 -0500
Received: by mail-wr1-f67.google.com with SMTP id i16so21375568wrs.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YVSItG3KX9MP+WKJwfS70GD9v2G4NzYgsER32Iq0nUY=;
        b=tGaE/1TLAJPc1VsIQ5AmGbe4QsZXkjpKyE9TsHgDHHm7xrZTYobu2H2coz2x64vNGa
         u4TXuMwXRzxRpAX7Ij34MnqfBTRfqdodnnLm2aDoYsYtkgZjOtWP5+0GB2dKYBBc1sLF
         2JlJ3EUOYb+7czh+Plhsn9RcNO/GLcIqO9PVTH3yWSfhSx5mZU7o9bMpwMiz9clFnKUA
         r8+a9iCBFwBgG2KFdDfv38G5iIexKtNki0NIaucWtkQCNVmB/izyHcx1XzBuVclXcKWT
         75XP5fyBDov1y/4sxYBYWoobNdcSSaOfsdhNGOs46DOZRmxA1bp4qjz/HcDxSOSi8pmP
         UKxg==
X-Gm-Message-State: APjAAAV4QjnTe8Q5FoyqQy56qzD4ZOiYwQXViblM68h1N+xbZaVu2mvJ
        v5MgPkCekTHi5NJ817TqhJQ=
X-Google-Smtp-Source: APXvYqzHBYESHzWm02DBaF10+P8gm8ALylCiR6VlDaEXe6nsfbEx27D36P72xUHv/D7Vr3lEEba9XQ==
X-Received: by 2002:a5d:5511:: with SMTP id b17mr2783811wrv.277.1552052241803;
        Fri, 08 Mar 2019 05:37:21 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:21 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 26/46] tools/lib/traceevent: Man pages for tep_event_common_fields() and tep_event_fields()
Date:   Fri,  8 Mar 2019 15:36:34 +0200
Message-Id: <20190308133654.21264-27-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_event_common_fields() and tep_event_fields()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-fields.txt    | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-fields.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-fields.txt b/tools/lib/traceevent/Documentation/libtraceevent-fields.txt
new file mode 100644
index 000000000000..e4f344046519
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-fields.txt
@@ -0,0 +1,99 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_event_common_fields,tep_event_fields - Get a list of fields for an event.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_format_field pass:[*]pass:[*]*tep_event_common_fields*(struct tep_event pass:[*]_event_);
+struct tep_format_field pass:[*]pass:[*]*tep_event_fields*(struct tep_event pass:[*]_event_);
+--
+
+DESCRIPTION
+-----------
+The _tep_event_common_fields()_ function returns an array of pointers to common
+fields for the _event_. The array is allocated in the function and must be freed
+by free(). The last element of the array is NULL.
+
+The _tep_event_fields()_ function returns an array of pointers to event specific
+fields for the _event_. The array is allocated in the function and must be freed
+by free(). The last element of the array is NULL.
+
+RETURN VALUE
+------------
+Both _tep_event_common_fields()_ and _tep_event_fields()_ functions return
+an array of pointers to tep_format_field structures in case of success, or
+NULL in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+int i;
+struct tep_format_field **fields;
+struct tep_event *event = tep_find_event_by_name(tep, "kvm", "kvm_exit");
+if (event != NULL) {
+	fields = tep_event_common_fields(event);
+	if (fields != NULL) {
+		i = 0;
+		while (fields[i]) {
+			/* walk through the list of the common fields of the kvm_exit event */
+			i++;
+		}
+		free(fields);
+	}
+	fields = tep_event_fields(event);
+	if (fields != NULL) {
+		i = 0;
+		while (fields[i]) {
+			/* walk through the list of the event specific fields of the kvm_exit event */
+			i++;
+		}
+		free(fields);
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

