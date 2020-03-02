Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA3CC3F2D2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF80D208C3
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E8lO2Uqq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgCBKOQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 05:14:16 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43924 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgCBKOQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 05:14:16 -0500
Received: by mail-lf1-f68.google.com with SMTP id s23so7523152lfs.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Mar 2020 02:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b+z91TIALgaS1oYglYCqMB6d0bH8Jw1sVU1cKpdYLbc=;
        b=E8lO2UqqqF/V8hA79+jlmHnoPp1C85s4uD/jZSUvGy3ISjiLsXUl5SAee5tqbEfHBL
         M6nnUjNRik/cPEg2/eMIUE9igJaGDvHw3HWzS3zSnLNPItrnXMFbQBD43lYIJpUBTEEt
         A+6gL51zvuav62alOw8Q4xWCv5E1grUxttcKaFuw6IM+LpUG93OdsUNAYLWYGJuWLsIp
         H14Y+HKUnRlttbYr47g42TQxU71ZOI11lr1IwXV8o/EwvM1eP2nnwsTGC/G/9kRJ99h+
         FGaCO7G8ggLeEsN4dR+roWsgpturqM029R+ihK8WtsAePuMU/FewOoUlRkCvNNVwR/Jk
         bI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b+z91TIALgaS1oYglYCqMB6d0bH8Jw1sVU1cKpdYLbc=;
        b=ByrvRoKqXZKcXznC0bLwSEYGn2Q52LzlHIIqMjH3ADECMMO8nfAU5EMQkhtaG6lgFB
         PgcXHTot4TcpMKQxunDN1ML7syFg2OMm/0eMjwKGcp7eNfqOcH+ZrJJ9em7+YjRPGbVX
         TgX3J2QyoFh7Vj09RIwNBq0vVnZRCbHXt+nqSPce0ANZDNNX/HCiZHWS0TTUUVxdIot+
         qYRZrOBA9sSSLSGVZ8lnss+MHDrog/3JV/g5bmjTA1uv9QBgnC7I+IteF5loXt4bK0M2
         V/YHoaYIcvwYc+hYHrNcj+6mhE7lTUzkll9SkCicjmfefNDSUdt4JbDXtQXbVCBqz4dx
         OWKQ==
X-Gm-Message-State: ANhLgQ3yZ7Oda+Eza3H5yuiQJoZKw8fB6KuFyjtG6L122l4oNr9Kd8tz
        8cplwm7rPXPLvjzpoh0k/JM=
X-Google-Smtp-Source: ADFU+vtuvyK8YEPcMYT5r38Yjzp9bEc3Y7CGInrii+OpV9kPcIJV2WBvenK/skJUQKiPS0Y/fOxSiw==
X-Received: by 2002:ac2:41d3:: with SMTP id d19mr1774562lfi.57.1583144053604;
        Mon, 02 Mar 2020 02:14:13 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x10sm11048236ljd.68.2020.03.02.02.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 02:14:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v21 05/13] trace-cmd: Add definitions of htonll() and ntohll()
Date:   Mon,  2 Mar 2020 12:13:56 +0200
Message-Id: <20200302101404.150035-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302101404.150035-1-tz.stoyanov@gmail.com>
References: <20200302101404.150035-1-tz.stoyanov@gmail.com>
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

