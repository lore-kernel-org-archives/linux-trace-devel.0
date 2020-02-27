Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CF1C3F348
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDA4D24690
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GMlNI+2W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389875AbgB0OUQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:20:16 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41599 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389286AbgB0OUQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 09:20:16 -0500
Received: by mail-lj1-f193.google.com with SMTP id h23so3600768ljc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2020 06:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Agm4aCXIkmbaB+Pv433vldzqvF/93gjO3Xrh7cZjFL8=;
        b=GMlNI+2WF9G6lhAQ/dn6XKwlpYxRX//SI/Ip9vs+lN1L8aVTDU0BVncZm9DIaGkRKs
         xeiCgCCDKwdWOO4zCmBAHsfERprT0FvoyhzvFRYnbx+XkjgQajbSCJs6+6otAHJSFbG/
         H3qR9pH46AF0nSFC5ixBi0ASX1AjY+Iejw148AhoCdKhsIspO4m9QTWrfSm4r1Pd56ak
         DG3vYKFi0IE94P4hYrEwSBZPMu6weNufwQBYa3j+Txtjm7qbSsZjVHzWvh5tJN3kafjM
         OtM6e87XIANto+x6ho6JOiuYhlidV4ONqkl4pRyqclSp/bYMuNNSp8cAhu02oE/yxj5Q
         jPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Agm4aCXIkmbaB+Pv433vldzqvF/93gjO3Xrh7cZjFL8=;
        b=Gk1fOlFvGIiBDk0yH3OKFRpF1f/Fqe76Ig1nIurKjO9qJ7C4UlcvNY5GvBhT5ssrEq
         /YYOAWVI5QAPc/w05dHtxAxMrt2JgJm6TWFxBO1p+r5HPMma77KEk+8+JRUl55udwViq
         3KO/9zW8Pyye35sTJjiQNc2ts7GXUg2zYJthUbZiTX9lJvWeJk9UKWwgbPDmSDRMG/9P
         AT20BilgfYjshv+2jIMZnPC3hXWoTESwjTBCrS51AmvmU+eDLpoLwrJBVes8IVF/aIKu
         k43+9C53keiJuRO+RjbJaZq2kXSNMP4D6Xig0/1O8PdjLZY19NdrwzeU9ggLm9+oFOYW
         bIRg==
X-Gm-Message-State: ANhLgQ1dPnHuw5wrwVh3RGd+qFW7HPDP007V4ebONQPnpFJV9B+FukT2
        nQZmHik+i3RBSPG5Zdq+gaU=
X-Google-Smtp-Source: ADFU+vtfEJa2/N0VcPpE9KEQ7MofuI6WwqHUxFw0hmLvc6RRtUibWLAs0PAj+HP5BNrBkIrAlQZ1nw==
X-Received: by 2002:a2e:94c8:: with SMTP id r8mr3155536ljh.28.1582813213779;
        Thu, 27 Feb 2020 06:20:13 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l3sm3306437lja.78.2020.02.27.06.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 06:20:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v20 07/15] trace-cmd: Add definitions of htonll() and ntohll()
Date:   Thu, 27 Feb 2020 16:19:53 +0200
Message-Id: <20200227142001.61577-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227142001.61577-1-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Reorganized libtracecmd internal headers:
 - Renamed trace-cmd-local.h to trace-write-local.h
This internal header implements static __do_write_check() function,
used in trace-input.c, trace-output.c and trace-msg.c files.
The header cannot be included in other files, which do not call
__do_write_check(). The new name trace-write-local.h reflects more
closely the purpose of the file.
 - Added trace-cmd-local.h file, to share code inside libtracecmd.
 - Added definitions of htonll() and ntohll(), if not already defined, in
trace-cmd-local.h

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 lib/trace-cmd/include/trace-cmd-local.h   | 45 ++++++-----------------
 lib/trace-cmd/include/trace-write-local.h | 43 ++++++++++++++++++++++
 lib/trace-cmd/trace-input.c               |  2 +-
 lib/trace-cmd/trace-msg.c                 |  2 +-
 lib/trace-cmd/trace-output.c              |  2 +
 5 files changed, 58 insertions(+), 36 deletions(-)
 create mode 100644 lib/trace-cmd/include/trace-write-local.h

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 09574dbd..95dce66c 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -6,10 +6,8 @@
 #ifndef _TRACE_CMD_LOCAL_H
 #define _TRACE_CMD_LOCAL_H
 
-/* Local for trace-input.c and trace-output.c */
-
-#include "trace-cmd.h"
-#include "event-utils.h"
+/* Can be overridden */
+void warning(const char *fmt, ...);
 
 /* trace.dat file format version */
 #define FILE_VERSION 6
@@ -18,36 +16,15 @@
 #define STR(x)	_STR(x)
 #define FILE_VERSION_STRING STR(FILE_VERSION)
 
-static ssize_t __do_write(int fd, const void *data, size_t size)
-{
-	ssize_t tot = 0;
-	ssize_t w;
-
-	do {
-		w = write(fd, data + tot, size - tot);
-		tot += w;
-
-		if (!w)
-			break;
-		if (w < 0)
-			return w;
-	} while (tot != size);
-
-	return tot;
-}
-
-static ssize_t
-__do_write_check(int fd, const void *data, size_t size)
-{
-	ssize_t ret;
-
-	ret = __do_write(fd, data, size);
-	if (ret < 0)
-		return ret;
-	if (ret != size)
-		return -1;
+#ifndef htonll
+# if __BYTE_ORDER == __LITTLE_ENDIAN
+#define htonll(x) __bswap_64(x)
+#define ntohll(x) __bswap_64(x)
+#else
+#define htonll(x) (x)
+#define ntohll(x) (x)
+#endif
+#endif
 
-	return 0;
-}
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/include/trace-write-local.h b/lib/trace-cmd/include/trace-write-local.h
new file mode 100644
index 00000000..94ad910b
--- /dev/null
+++ b/lib/trace-cmd/include/trace-write-local.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+#ifndef _TRACE_WRITE_LOCAL_H
+#define _TRACE_WRITE_LOCAL_H
+
+/* Local for trace-input.c, trace-output.c and trace-msg.c */
+
+static ssize_t __do_write(int fd, const void *data, size_t size)
+{
+	ssize_t tot = 0;
+	ssize_t w;
+
+	do {
+		w = write(fd, data + tot, size - tot);
+		tot += w;
+
+		if (!w)
+			break;
+		if (w < 0)
+			return w;
+	} while (tot != size);
+
+	return tot;
+}
+
+static ssize_t
+__do_write_check(int fd, const void *data, size_t size)
+{
+	ssize_t ret;
+
+	ret = __do_write(fd, data, size);
+	if (ret < 0)
+		return ret;
+	if (ret != size)
+		return -1;
+
+	return 0;
+}
+
+#endif /* _TRACE_WRITE_LOCAL_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index aca13c4e..f5611b46 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -15,7 +15,7 @@
 
 #include <linux/time64.h>
 
-#include "trace-cmd-local.h"
+#include "trace-write-local.h"
 #include "trace-local.h"
 #include "kbuffer.h"
 #include "list.h"
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 9c8a6908..85a2bae6 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -22,7 +22,7 @@
 #include <sys/types.h>
 #include <linux/types.h>
 
-#include "trace-cmd-local.h"
+#include "trace-write-local.h"
 #include "trace-local.h"
 #include "trace-msg.h"
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index acdd2d57..4a9a857d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -21,7 +21,9 @@
 #include <glob.h>
 
 #include "tracefs.h"
+#include "trace-cmd.h"
 #include "trace-cmd-local.h"
+#include "trace-write-local.h"
 #include "list.h"
 #include "trace-msg.h"
 
-- 
2.24.1

