Return-Path: <SRS0=Pf13=4V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26729C3F2D8
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF5612073B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uXzk7ahi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725283AbgCDJMb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 04:12:31 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39293 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728642AbgCDJMb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 04:12:31 -0500
Received: by mail-lf1-f68.google.com with SMTP id n30so868925lfh.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Mar 2020 01:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b+z91TIALgaS1oYglYCqMB6d0bH8Jw1sVU1cKpdYLbc=;
        b=uXzk7ahiDRVgNbX0dhN6wYaTUbAvachBnLASB/q5OiDcgq1+gowQOjR8RYMFafxZxj
         TPoz+8BrbGxfKDdKZjLlN3C+tR1m/YAlgWibYJ2pMXmseFnCDXuRqU0+iJsExqiqF29P
         dVnV0neVAd4yjTR7dxFywUBzSFtSuv7QRtjYJI2jb3YLqghRHiuy2MJg2pMYixa5hoYW
         cvmkSgv3UeIjNaB5KlKOsj9ElIEk6B9mU1c5wnQEEzYFvqSb3cbv/QfTAnZy1l4g78Ce
         sFcBnnTDeJKR+6LP86jIsyjPXuKdVEOcvUP0q2mKM/WLHqcfUQoMgik7lENlwjTpvT4I
         YUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b+z91TIALgaS1oYglYCqMB6d0bH8Jw1sVU1cKpdYLbc=;
        b=S+fy+IuHYwHziJid2SzVErkcT8Ahr0TljnMQnJfaiN3sw1LbiIRHobcYW/7Cx1QjXY
         wygZ/7yMZfgzUQKS77dUvxDBfi1AZrnasoeVBmYk/8fxzd/AZDiU8FSoEyj7EjIIFHbQ
         ThgSIqF6o9qI3cQq8KiymYZzr5xkIF2rPGlCVRIDAbyympPJ/Pn5my2TrVI+WxzA7J+C
         730v1T/O5DFVGWnZkRyEOl3lra6aXIu4P6gC46kC4YmpNlVrxD1N8hSwVoF5CbZH518B
         SNrDnlExCIpPHgCWp4Go2zz297fD4N0lM66TEqVOKScKZMGySoqhCCu8Oidwd2NdpB49
         j02A==
X-Gm-Message-State: ANhLgQ3oVE/M5iw9dxp8K47GbWGDVFOCZD10Zvpyg6Ef4isddLb+DEN2
        qgfeas2jJAlwZ3bj5ZJJcCg=
X-Google-Smtp-Source: ADFU+vs8WZ9EAh4BjrRxLHBS733/8fO7cs5MDM+J6hJSPsxA5wzvZHzFPmn3RCGp6BwSCTtgcHoS2Q==
X-Received: by 2002:a19:5508:: with SMTP id n8mr1444250lfe.105.1583313149108;
        Wed, 04 Mar 2020 01:12:29 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v15sm13327462lfg.51.2020.03.04.01.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 01:12:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v22 05/13] trace-cmd: Add definitions of htonll() and ntohll()
Date:   Wed,  4 Mar 2020 11:12:12 +0200
Message-Id: <20200304091220.30936-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304091220.30936-1-tz.stoyanov@gmail.com>
References: <20200304091220.30936-1-tz.stoyanov@gmail.com>
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
index 8b5405fb..d1d010de 100644
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

