Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB6BC282CE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21DE42084D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 13:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfDLNiW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 09:38:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40646 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfDLNiV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 09:38:21 -0400
Received: by mail-wm1-f68.google.com with SMTP id z24so11160129wmi.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 06:38:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WayPe/ynCqy+9hs7lwlZYmXZV7ePNTuMwn+lkelWKBQ=;
        b=EIEppgdM4YK3P+Fm9lmwuyB8FyZWWmaENa2Tj/SMiLK1w0ORcgZZLk2nJyYhLeZ5IN
         u3LLxH/MVRKSVZQfWzhL1iYo7x63uklJPXZoRzKXW0Tqiu4A/gMEHzHviJvS8bBuSxlK
         8FmF3GouUg9PN4TSFRpzYE8ClE21qs8Pl297Tmq2Dzc/XqgaMwk0ddLo1QpA7MADojEC
         hUOl7R7cHKIyz5x0MPVGsjKNt+0MqyuU6vRdKm4YE738pYXoo9wzQho6nIrOOVBjgc6/
         FjE1YYgXbsVO/t++IRl4vcMnZPQFCWx08x+7sHmoMa5sDTKhx1FzKS3WeVwzPsV/V+WA
         IDfg==
X-Gm-Message-State: APjAAAURL9CXnBPe9n+D1UK2w4N40IcTkzguz0RowrWJrzniTaSzGkP9
        UIcWbhFZdK9V7jDfhzqGdMJlvqhv
X-Google-Smtp-Source: APXvYqzaeKQkIhDaNJmL/yWP4siGhZ4S5+cQ/OVJowZamIe/QNcvd/uUZxpE6iTMV8FYWfe3r6Us3A==
X-Received: by 2002:a1c:415:: with SMTP id 21mr10770862wme.109.1555076300159;
        Fri, 12 Apr 2019 06:38:20 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x205sm11594682wmg.9.2019.04.12.06.38.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Apr 2019 06:38:19 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 08/30] tools/lib/traceevent: Man page for page size APIs
Date:   Fri, 12 Apr 2019 16:37:49 +0300
Message-Id: <20190412133811.15878-9-tstoyanov@vmware.com>
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
  tep_get_page_size()
  tep_set_page_size()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-page_size.txt | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_size.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
new file mode 100644
index 000000000000..2496b2cb2980
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
@@ -0,0 +1,80 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_get_page_size, tep_set_page_size - Get / set the size of a memory page on
+the machine, where the trace is generated
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
+void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
+--
+
+DESCRIPTION
+-----------
+The _tep_get_page_size()_ function returns the size of a memory page on
+the machine, where the trace is generated. The _tep_ argument is trace
+event parser context.
+
+The _tep_set_page_size()_ function stores in the _tep_ context the size of a
+memory page on the machine, where the trace is generated.
+The _tep_ argument is trace event parser context.
+The _page_size_ argument is the size of a memory page, in bytes.
+
+RETURN VALUE
+------------
+The _tep_get_page_size()_ function returns size of the memory page, in bytes.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	int page_size = 4096;
+	tep_set_page_size(tep, page_size);
+	if ( 4096 != tep_get_page_size(tep)) {
+		/* Something wrong happened, page size is not set as expected */
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

