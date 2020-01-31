Return-Path: <SRS0=DRQG=3U=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131EDC35240
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCFE420705
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="btbL3kIM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgAaML0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 07:11:26 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33775 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728484AbgAaML0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 07:11:26 -0500
Received: by mail-lj1-f194.google.com with SMTP id y6so6881440lji.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 31 Jan 2020 04:11:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qipCuniRHcK4NO/ZF+H7KETZf6+cNTp0f8iVvJThy8c=;
        b=btbL3kIMOIEr3QRxiEGO0XkOqGjQDs/DLgpAW8Wkopz1tN4n42TW/Cdwp9ZaEpNyJF
         H7cttgrsaV7n7BWPKAyLN6P8NHYzxPz5P5OoBWpkK6T5F4epRL9pe2dOhpmtCeb8Ytu4
         UPMx1pC54Ia6BgGMjzOn6zxX31aIIsjp+wB7/atbXIHnpaie0sjbL4mouOBl6QI8xfAz
         mL8ECOa0CRKKlXzI6b1vdQQ3RTPE7gFzhQhJ/YyGxlBswGDCYxah5o0HXtl6IHlpIYeZ
         MA42qimIJaWQzSsRTbBBTi7JpgyfgKoEVY4HmCkISGuWXPrMZDSJfZLuQBRHc0mX78G/
         Pn8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qipCuniRHcK4NO/ZF+H7KETZf6+cNTp0f8iVvJThy8c=;
        b=W/TVQvTQfjQogsPr62GKNL556BDQ+2+4+XBQK3c5TQG8lfF9aJstKcA7iBH2kIrCVN
         x3Y/n9Tbxipq9HSG2NiVanzqounUXuhHT9pLzrOeqU013z1jj1ACihB1HqiVBsuJyjVO
         vf/kuWbxqy46jjk4vOKBzC3V7Y63XG3X0EyUagq1udyzHQs/7BCsdmxiFVI71eCNa313
         aShVKDZS79QNVJM36Im34DGV6pLRgCpAtCP5rrnTu3QD+s7vlU31IM7sqvlAWsTVO7oT
         UzA+jXIMxiILl0TcfBFxSpZ8oDAt0j1qVyi/oLgJ5kZZfUmTdAAcD34pZR7fVw6zOsqt
         c90w==
X-Gm-Message-State: APjAAAUNLmCYk58mWY7bR9f1++GZlAtecM76An57I+WD3quFw2qaaonX
        ETTIXzycTPo6cCzNYtYsNCo=
X-Google-Smtp-Source: APXvYqyzw6LaCjtsr1KaQ8BhiDAzzIzsnhK+14sZV8ERZ2Zjx8IQaNGy449nBsE4ommnUXSI87tq3w==
X-Received: by 2002:a2e:9a04:: with SMTP id o4mr5935860lji.214.1580472683953;
        Fri, 31 Jan 2020 04:11:23 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i19sm4559965lfj.17.2020.01.31.04.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:11:23 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v19 07/15] trace-cmd: Add definitions of htonll() and ntohll()
Date:   Fri, 31 Jan 2020 14:11:03 +0200
Message-Id: <20200131121111.130355-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131121111.130355-1-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
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
index 09574db..95dce66 100644
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
index 0000000..94ad910
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
index aca13c4..f5611b4 100644
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
index 9c8a690..85a2bae 100644
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
index acdd2d5..4a9a857 100644
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

