Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73ECBC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbhLBM2u (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbhLBM2t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:49 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D0DC061759
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:26 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y13so115218004edd.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rRRaXmobcWSLIN9RqPvdMqevONWo7Khh7/TGyV5KCZY=;
        b=KtwgRL7ecewlewfjbxG12jMvaoE3d6QaMi3A5aQjy8cOAlWQ5jbTrEXTf1y1LXnVw3
         DXFUn0Vbi0ZJulT0eTjf7nBn75k/B/ydczJRHpvW7zANWYw/oNXcahgztwXw8t23fG7/
         BZGDcezSAkk9J5rqnUrfC66bMyot/1mFyoqiG0kkYLpnkEVMnF958y658FFOwj1B/XC+
         o16zgFp3q8xdWcVs5JYy7WOvwTf2KM/FXRM6j4S+EPtLH4l2kh7WViFY5jCxmNe0+o45
         b03Cm8NSyglbneERHd4Kx9/rqSqLMtlHtkf6Av24zVz42u7R8hV4vbMW7el65Vmdb/dc
         Pdyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rRRaXmobcWSLIN9RqPvdMqevONWo7Khh7/TGyV5KCZY=;
        b=cVYsUoYZ0nU6iCqEg9WEAEcxBpIKloHrLiF+w2FyL1GFsNomo3w4N+aVa6CWq8ECCO
         uO7vpO690gFyLXnOWBnlH+Wx8b7aCQ3sMe+4RCoXCQVAH/QxeUJ6dno/UIGe+LUX4Hyz
         X4AIO9Eyazr5ptRZ6YSn98qC1eps6IvzJDJbmxmSJTe2ZihcOMdWtdVnYPI6szD59vRk
         wXgI/Iw5szrneOI2o996S8kK57b9thNhBPGC/mlHF3yHhTsUTd+HKwT+Zckz0hzdeWxH
         9pVZ3B9wv0DBGcoodswW0t2yGFbcEnEDLOc3p4PF+hJP0zJI+tCTUU2uoWChMzArEVHY
         BC2Q==
X-Gm-Message-State: AOAM531wDge8RkkL1ghUozcpBA6CECZSqUYlpUazbOBuf0KLmy30Gto8
        wb2V841AOJmwJwdrRqyHzhd9I7x1PCUUJg==
X-Google-Smtp-Source: ABdhPJx2IK5z0vf3SFaJ+KVNXRJHac/fETgLRI5AK220bq/iS3fcrFmKU4vdSvhLObgW7XdFy5njnA==
X-Received: by 2002:a17:906:3a4a:: with SMTP id a10mr14793372ejf.253.1638447925162;
        Thu, 02 Dec 2021 04:25:25 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:24 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 17/20] trace-cmd library: Add zlib compression algorithm
Date:   Thu,  2 Dec 2021 14:25:04 +0200
Message-Id: <20211202122507.43572-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
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
index fb479d8d..5f3f1056 100644
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
index 133d1308..fc0724c6 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -356,6 +356,9 @@ void tracecmd_compress_init(void)
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

