Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE4AC2BA4C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbiAZJtf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239403AbiAZJtd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:33 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443AEC061747
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:33 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id s5so37619159ejx.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wKSIYoN7p6vThicZyffEoNmC1WW8SdBhSUp2rHwqKLw=;
        b=iTytiVNXvqvX4iCHap1wRBnC7bCYsGqlG7WY+bIp3hrYLOSFNit5iw/Bwc/NnWJM2H
         FiFK8kuNyfUqe4uKgVMckxbt09hgG2Nkfuk7pvS6EQrpYL97eQ1htlItV0ZsgyVICZE8
         TjM3js/8v/F4wmtVHQn4tbA3D1fSCLp6EBDjZ7GDk+6o3r6/ntktE0spg1+v49v4vdGD
         D1/byi66tHyATAz9hTRcKoDkk55eD/DbfMD09wMuBkmcpxwNCn9xwXSPY+pmSjRJrXaG
         w/bYBqpPvLVjiSalh7KzCY/X3sD8zSMN9LEoCdRn1xtSulrIdTkR6DHxGEpDVA9b5AKG
         CCXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wKSIYoN7p6vThicZyffEoNmC1WW8SdBhSUp2rHwqKLw=;
        b=V9O/HM2XcNWBMkigOS/Y9/nVaHrClh3Nt7FtKWiehqwre9z0JA4RzEhAeSWpfrrKxJ
         QjmIFqu9z/mkgHgd30rJXSD8D5i01oMhRebbT+paENfiXn06gjkL6i0esZBEfBjEvR9f
         NoW9M/OzXWDblzH0LBcgh7JIAW1uyaujvS+WwTF0VS7nFuGDeSXMGG8R4k8+pan2svd/
         ztdYqbyUJg6NiCW1+yENCLwCDdw+ZXP8B8ZX8UNv84CDYdGMoSS+zVYLTVPGLF5nC2ln
         18am+iRYG2CxTj1Pp9nk6ypzMv4A7ZHFMXUZE2amzSMvIcC60rsZM8ZHW3wF9zv2U2c0
         hlNg==
X-Gm-Message-State: AOAM532I5RWYnjyU2/mwtH2toHYj3suSw1BhQye6wv2gPIzVQnXIoEUK
        3RlOgkb0Xj3IlrbBP+HdwT8fYfnBfsg=
X-Google-Smtp-Source: ABdhPJwEwcD4REsMT3w8c/AyNS/alkfStT2StH7kN1QiSDnfuqq07ejKVneW0BYRxzTtN0ZN0hd0PA==
X-Received: by 2002:a17:906:a415:: with SMTP id l21mr18908903ejz.311.1643190571817;
        Wed, 26 Jan 2022 01:49:31 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 17/20] trace-cmd library: Add zlib compression algorithm
Date:   Wed, 26 Jan 2022 11:49:03 +0200
Message-Id: <20220126094906.570451-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-compress.c          |   4 +
 tracecmd/Makefile                       |   4 +
 6 files changed, 135 insertions(+)
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
index a7be4a42..1820c67b 100644
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
index 4a4341dd..210d58b6 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -386,6 +386,10 @@ void tracecmd_compress_init(void)
 
 	gettimeofday(&time, NULL);
 	srand((time.tv_sec * 1000) + (time.tv_usec / 1000));
+
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
2.34.1

