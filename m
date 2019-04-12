Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D4EC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2FFE2084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfDLNiT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:19 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43781 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfDLNiT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id k17so7336272wrx.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7bejhqSWNJ6yrsYhJqtY8KvJICS0zi1EcjABl3JOxyQ=;
        b=qmoB6W8GPXSBN++PZi/kkU81o95U9B8m5W5jjRx6Kn5XtjlVDlktOgTepu3LESlG1r
         wsRzcVLhGDztwW5uo6JkiZZcDOm9jjXi/Y86mNs6auNyVkb+P9ZW8Mw6W8h2tIPRclm4
         ubLaXdaMNpFOSI95HX/F4kCFlqS9hYXCF7nTISYiFfqSeDYMAICU1YlNvGGJ5VzBWqb7
         8ZMlgUPw/c8d/Bl7csn1tsQkRKQOnf+HTNRHkQhI1k0PBXQbrhwJNj5XX75XafX3Qkix
         4OybBoLT1aAMBPUOVaQSOUj+G5D7puUfeHTamJbxvcBOfTmQ3LhcKFhHcnCb6R8vU/3J
         Q9lg==
X-Gm-Message-State: APjAAAUoAlxo5zHEseUcyyl5QAEupCiefitPexOFAug9NF8ventBy2HT
        A4JsunnogctahraHl1UZygo=
X-Google-Smtp-Source: APXvYqzzlxRxbjUM3KBSHoU4t3uHf+sAlqr1ncGvbMAckoLosMvld9TpsGVq9w8oC6m/kbKZ/AYKfg==
X-Received: by 2002:adf:e288:: with SMTP id v8mr29978170wri.7.1555076298299;
        Fri, 12 Apr 2019 06:38:18 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:17 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 06/30] tools/lib/traceevent: Man page for file endian APIs
Date:   Fri, 12 Apr 2019 16:37:47 +0300
Message-Id: <20190412133811.15878-7-tstoyanov@vmware.com>
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
  tep_is_file_bigendian(),
  tep_set_file_bigendian()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-file_endian.txt             | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
new file mode 100644
index 000000000000..f401ad311047
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
@@ -0,0 +1,91 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_is_file_bigendian, tep_set_file_bigendian - Get / set the endianness of the
+raw data being accessed by the tep handler.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_endian* {
+	TEP_LITTLE_ENDIAN = 0,
+	TEP_BIG_ENDIAN
+};
+
+bool *tep_is_file_bigendian*(struct tep_handle pass:[*]_tep_);
+void *tep_set_file_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _endian_);
+
+--
+DESCRIPTION
+-----------
+The _tep_is_file_bigendian()_ function gets the endianness of the raw data,
+being accessed by the tep handler. The _tep_ argument is trace event parser
+context.
+
+The _tep_set_file_bigendian()_ function sets the endianness of raw data being
+accessed by the tep handler. The _tep_ argument is trace event parser context.
+[verse]
+--
+The _endian_ argument is the endianness:
+	_TEP_LITTLE_ENDIAN_ - the raw data is in little endian format,
+	_TEP_BIG_ENDIAN_ - the raw data is in big endian format.
+--
+RETURN VALUE
+------------
+The _tep_is_file_bigendian()_ function returns true if the data is in bigendian
+format, false otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	tep_set_file_bigendian(tep, TEP_LITTLE_ENDIAN);
+...
+	if (tep_is_file_bigendian(tep)) {
+		/* The raw data is in big endian */
+	} else {
+		/* The raw data is in little endian */
+	}
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

