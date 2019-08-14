Return-Path: <SRS0=RHP/=WK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A080DC0650F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7806C2084F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="axSJYPhQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfHNIrU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:47:20 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34232 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfHNIrU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 04:47:20 -0400
Received: by mail-wm1-f68.google.com with SMTP id e8so2823254wme.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Aug 2019 01:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BzpyXnjPBi5Md5sppUmcV5UzhBMiyw6EOIYqgcZkdNw=;
        b=axSJYPhQ2uRbWgX2w3SipaMF2PHyTurXdwIiXXATMdc4ngAoT/dIjXi9xnKrx3AUpv
         smLQcF4paoO3Z/R6mgmu9HsBAwxHvDEp9o/C0qD1EFhMnaMTSzJ2haDaidxPWQwkJugb
         qTNQreiQDxWDHYHLwITnDwy4d1qsc2fjD+WgOXsDkUvbl8e4q40+UCaGwmXqnyAlLjLA
         2uiudtna0lYjVB0gJOKt/3Q/Wt8cqxh7VbjXuyP0M/cTEfeRpObsAxOmAun7VLCbYU/O
         WE8oobLpTHmxb1IWDHW14hS5SAFohz933f+qKt6M74dPGhBmxwngYNPUhu76gf7XUzu2
         PA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BzpyXnjPBi5Md5sppUmcV5UzhBMiyw6EOIYqgcZkdNw=;
        b=MbgxTvOhTKG7uAdBQt88pz1CQIVmfPCLJzLLsiYlVJISY5KhsKMZcMktqT8M6CuT3Z
         u1O9HHw9f2AliIWI9DjykA3mwlSAWj1k9WrFik7NYlUO9mTE3nYvXv2i7+kkFFEoRZio
         GWE1eKxpsiHa28ffemHEVCdh5bUGCCh4kTNVJoZHzhKWVcHb8QiVWP6DKGvCWI0H/5Jm
         zuh/0GX7uPNzKW3nWO00CxuJYFzER+DacQ0AfLloSqtId439vu6KmKenppqsYT4VOFW/
         i9weMbXxWdwlTVQubcE5Ou933NxNkBGbcRJyIVu3D9EMeuy9Wrik7HHgTcbxF/GxQCY3
         0VvA==
X-Gm-Message-State: APjAAAU0XCWMLLqZ1o5JN3BG8mMAZzhs5Vk7qdcXKyDXMLUDfyv8fPhv
        Nbvtlx0GmIADfWHKpc7tm0c=
X-Google-Smtp-Source: APXvYqwiCJ825F/QYGW4HcNwKRMoqJUa7p+k09GbpGlaCWk5HIFsHPcK/kdoTgr8+l9Ry313wfY7Zg==
X-Received: by 2002:a1c:f418:: with SMTP id z24mr7135818wma.80.1565772437894;
        Wed, 14 Aug 2019 01:47:17 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c19sm2897481wml.13.2019.08.14.01.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 01:47:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/8] trace-cmd: Move trace-output.c into the library code
Date:   Wed, 14 Aug 2019 11:47:02 +0300
Message-Id: <20190814084712.28188-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814084712.28188-1-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Functions, implemented in trace-output.c file, do not depend on
trace-cmd application context and can be used standalone. The file
is moved from trace-cmd to libtracecmd. It also fixes a warning
while loading python modules from kernelshark:
ImportError: ctracecmd.so: undefined symbol: tracecmd_append_cpu_data

Since in trace-output.c is the only code, that uses FILE_VERSION_STRING
define (the version of trace.dat file format), this define is moved from
version.h in trace-cmd-local.h.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
[
 v2 changes:
   - Removed trace-output.c dependency of version.h. Moved FILE_VERSION_STRING
     define from top Makefile to trace-cmd-local.h.
]
 Makefile                                   | 3 ---
 include/version.h                          | 5 -----
 lib/trace-cmd/Makefile                     | 1 +
 lib/trace-cmd/include/trace-cmd-local.h    | 7 +++++++
 {tracecmd => lib/trace-cmd}/trace-output.c | 1 -
 tracecmd/Makefile                          | 1 -
 6 files changed, 8 insertions(+), 10 deletions(-)
 rename {tracecmd => lib/trace-cmd}/trace-output.c (99%)

diff --git a/Makefile b/Makefile
index d34c615..a848394 100644
--- a/Makefile
+++ b/Makefile
@@ -10,9 +10,6 @@ export TC_PATCHLEVEL
 export TC_EXTRAVERSION
 export TRACECMD_VERSION
 
-# file format version
-FILE_VERSION = 6
-
 MAKEFLAGS += --no-print-directory
 
 # Makefiles suck: This macro sets a default value of $(2) for the
diff --git a/include/version.h b/include/version.h
index 68ce79e..fcf7ba0 100644
--- a/include/version.h
+++ b/include/version.h
@@ -9,9 +9,4 @@
 #include "tc_version.h"
 #endif
 
-#define _STR(x)	#x
-#define STR(x)	_STR(x)
-
-#define FILE_VERSION_STRING STR(FILE_VERSION)
-
 #endif /* _VERSION_H */
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 44c1332..0543b91 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -10,6 +10,7 @@ OBJS =
 OBJS += trace-hash.o
 OBJS += trace-hooks.o
 OBJS += trace-input.o
+OBJS += trace-output.o
 OBJS += trace-recorder.o
 OBJS += trace-util.o
 OBJS += trace-filter-hash.o
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index fa96d4f..bad325f 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -11,6 +11,13 @@
 #include "trace-cmd.h"
 #include "event-utils.h"
 
+/* trace.dat file format version */
+#define FILE_VERSION 6
+
+#define _STR(x)	#x
+#define STR(x)	_STR(x)
+#define FILE_VERSION_STRING STR(FILE_VERSION)
+
 extern int quiet;
 
 static ssize_t __do_write(int fd, const void *data, size_t size)
diff --git a/tracecmd/trace-output.c b/lib/trace-cmd/trace-output.c
similarity index 99%
rename from tracecmd/trace-output.c
rename to lib/trace-cmd/trace-output.c
index 33d6ce3..1f94346 100644
--- a/tracecmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -23,7 +23,6 @@
 #include "trace-cmd-local.h"
 #include "list.h"
 #include "trace-msg.h"
-#include "version.h"
 
 /* We can't depend on the host size for size_t, all must be 64 bit */
 typedef unsigned long long	tsize_t;
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index bcd437a..6968f83 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -29,7 +29,6 @@ TRACE_CMD_OBJS += trace-restore.o
 TRACE_CMD_OBJS += trace-check-events.o
 TRACE_CMD_OBJS += trace-show.o
 TRACE_CMD_OBJS += trace-list.o
-TRACE_CMD_OBJS += trace-output.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-msg.o
 
-- 
2.21.0

