Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D965AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240133AbhLJLDb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbhLJLDa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:30 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B9DC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:55 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id w1so28501455edc.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W7WACWTRxYHvxphLFaDkLLl6Ip7NTeMCnyKHUYDHUMg=;
        b=kZ7j8jqvv0savlSF1X/sOqaJPDHzd85twWwd+xI95TerZ4zOjC5rD2dAwo5CDzrUP5
         d8XEbFbLRFwbZSaBHlhbgd4RV9EIXgyi220Tpa7dvmla5ZVlOJMYXQK2LtqadQ/2hff+
         tXCKw4NzSHcq3JWKruHThQQHXxohTYDEINRWrkL/o9h5hRTtrXnknea9bpQYXAiiCyyC
         Cv1G/c7j6fhez/qJwpNe7TldJ2dL9JEQ5sQguy4y0Px/KZLz9koEYmnUMqv+rsJB5IsV
         9Mh1Hz98UszeAtw3zhmRjuZ8md0soEcU1ifGHS31WXLLXIuqYvep21InX8my21YbvVFn
         av+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W7WACWTRxYHvxphLFaDkLLl6Ip7NTeMCnyKHUYDHUMg=;
        b=0Vq0ODnnAgtr/YBZgYR4eyh6G6S7hXTfvMG4Vs0Rx0L5ap7bIO9PkEiE2eA4MdBNJ3
         CiCP5i7xWb/4aeci7Ei+p2bt4DAtows5a3fLNRC7Sbk4EXg5W0shwOf6U2mMHKiiDOic
         hXhla7eZmR99I6RV7sOnnSp9wf5sG2sGPVsGoZa0wBYuJacG/f2rQHPDZDzDpG20VJFQ
         sE59zkCOV6WUoYrVggaVsqwckKXhjh+HiZaHe7+/JF8OVVWYJOI0qpovmXXpyEhBHgUK
         8+G5o0j280kiRsDI/OFCAJf4w1oHToHFC88naENRVK7KylwwBR4q0HdLZKUfopdbvnhP
         vtlQ==
X-Gm-Message-State: AOAM531D3iSNsI/V06w+6rxBczv+MxM55g431MVSM/d19UrPoD6r5YjA
        /cewUBqaYHLFxpHLZuR/Ti4gVMB83/U=
X-Google-Smtp-Source: ABdhPJzhmehVQZrPru3d/BOPDgTO/s461ty7ovIZz/+UVG+T7f1WQv3p0336ktF3TBLEVns945sOxg==
X-Received: by 2002:a17:907:3f19:: with SMTP id hq25mr21973859ejc.225.1639133994371;
        Fri, 10 Dec 2021 02:59:54 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 17/20] trace-cmd library: Add zlib compression algorithm
Date:   Fri, 10 Dec 2021 12:59:35 +0200
Message-Id: <20211210105938.98250-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added implementation for zlib compression algorithm, using libz
library, if available.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile                                |   7 ++
 lib/trace-cmd/Makefile                  |   7 ++
 lib/trace-cmd/include/trace-cmd-local.h |   4 +
 lib/trace-cmd/trace-compress-zlib.c     | 109 ++++++++++++++++++++++++
 lib/trace-cmd/trace-compress.c          |   3 +
 tracecmd/Makefile                       |   4 +
 6 files changed, 134 insertions(+)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c

diff --git a/Makefile b/Makefile
index 91f62859..c9faf8db 100644
--- a/Makefile
+++ b/Makefile
@@ -300,6 +300,13 @@ ifeq ($(PERF_DEFINED), 1)
 CFLAGS += -DPERF
 endif
 
+ZLIB_INSTALLED := $(shell if (printf "$(pound)include <zlib.h>\n void main(){deflateInit(NULL, Z_BEST_COMPRESSION);}" | $(CC) -o /dev/null -x c - -lz >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+ifeq ($(ZLIB_INSTALLED), 1)
+export ZLIB_INSTALLED
+CFLAGS += -DHAVE_ZLIB
+$(info    Have zlib compression support)
+endif
+
 CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -o /dev/null -x c - -lcunit >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 export CUNIT_INSTALLED
 
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index bab4322d..1ee6ac4c 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -26,6 +26,9 @@ OBJS += trace-timesync-ptp.o
 OBJS += trace-timesync-kvm.o
 endif
 OBJS += trace-compress.o
+ifeq ($(ZLIB_INSTALLED), 1)
+OBJS += trace-compress-zlib.o
+endif
 
 # Additional util objects
 OBJS += trace-blk-hack.o
@@ -47,6 +50,10 @@ $(LIBTRACECMD_STATIC): $(OBJS)
 
 LIBS = $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) -lpthread
 
+ifeq ($(ZLIB_INSTALLED), 1)
+LIBS += -lz
+endif
+
 $(LIBTRACECMD_SHARED_VERSION): $(LIBTRACECMD_SHARED)
 	@ln -sf $(<F) $@
 
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index ca682ed9..3d75bd63 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -26,6 +26,10 @@ void tracecmd_info(const char *fmt, ...);
 #endif
 #endif
 
+#ifdef HAVE_ZLIB
+int tracecmd_zlib_init(void);
+#endif
+
 struct data_file_write {
 	unsigned long long	file_size;
 	unsigned long long	write_size;
diff --git a/lib/trace-cmd/trace-compress-zlib.c b/lib/trace-cmd/trace-compress-zlib.c
new file mode 100644
index 00000000..a697cc61
--- /dev/null
+++ b/lib/trace-cmd/trace-compress-zlib.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2021, VMware, Tzvetomir Stoyanov tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <dlfcn.h>
+#include <zlib.h>
+#include <errno.h>
+
+#include "trace-cmd-private.h"
+
+#define __ZLIB_NAME		"zlib"
+#define __ZLIB_WEIGTH		10
+
+static int zlib_compress(const char *in, unsigned int in_bytes,
+			 char *out, unsigned int *out_bytes)
+{
+	unsigned long out_size = *out_bytes;
+	int ret;
+
+	ret = compress2((unsigned char *)out, &out_size,
+			(unsigned char *)in, (unsigned long)in_bytes, Z_BEST_COMPRESSION);
+	*out_bytes = out_size;
+	errno = 0;
+	switch (ret) {
+	case Z_OK:
+		return 0;
+	case Z_BUF_ERROR:
+		errno = -ENOBUFS;
+		break;
+	case Z_MEM_ERROR:
+		errno = -ENOMEM;
+		break;
+	case Z_STREAM_ERROR:
+		errno = -EINVAL;
+		break;
+	default:
+		errno = -EFAULT;
+		break;
+	}
+
+	return -1;
+}
+
+static int zlib_decompress(const char *in, unsigned int in_bytes,
+			   char *out, unsigned int *out_bytes)
+{
+	unsigned long out_size = *out_bytes;
+	int ret;
+
+	ret = uncompress((unsigned char *)out, &out_size,
+			 (unsigned char *)in, (unsigned long)in_bytes);
+	*out_bytes = out_size;
+	errno = 0;
+	switch (ret) {
+	case Z_OK:
+		return 0;
+	case Z_BUF_ERROR:
+		errno = -ENOBUFS;
+		break;
+	case Z_MEM_ERROR:
+		errno = -ENOMEM;
+		break;
+	case Z_DATA_ERROR:
+		errno = -EINVAL;
+		break;
+	default:
+		errno = -EFAULT;
+		break;
+	}
+
+	return -1;
+}
+
+static unsigned int zlib_compress_bound(unsigned int in_bytes)
+{
+	return compressBound(in_bytes);
+}
+
+static bool zlib_is_supported(const char *name, const char *version)
+{
+	const char *zver;
+
+	if (!name)
+		return false;
+	if (strlen(name) != strlen(__ZLIB_NAME) || strcmp(name, __ZLIB_NAME))
+		return false;
+
+	if (!version)
+		return true;
+
+	zver = zlibVersion();
+	if (!zver)
+		return false;
+
+	/* Compare the major version number */
+	if (atoi(version) <= atoi(zver))
+		return true;
+
+	return false;
+}
+
+int tracecmd_zlib_init(void)
+{
+	return tracecmd_compress_proto_register(__ZLIB_NAME, zlibVersion(), __ZLIB_WEIGTH,
+						zlib_compress, zlib_decompress,
+						zlib_compress_bound, zlib_is_supported);
+}
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 883cf669..3d8f31bf 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -359,6 +359,9 @@ void tracecmd_compress_init(void)
 	gettimeofday(&time, NULL);
 	srand((time.tv_sec * 1000) + (time.tv_usec / 1000));
 
+#ifdef HAVE_ZLIB
+	tracecmd_zlib_init();
+#endif
 }
 
 static struct compress_proto *compress_proto_select(void)
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 80c69bbb..b7a23dc4 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -51,6 +51,10 @@ CONFIG_INCLUDES =
 CONFIG_LIBS	= -lrt -lpthread $(TRACE_LIBS)
 CONFIG_FLAGS	=
 
+ifeq ($(ZLIB_INSTALLED), 1)
+CONFIG_LIBS += -lz
+endif
+
 all: $(TARGETS)
 
 $(bdir):
-- 
2.33.1

