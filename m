Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F9FC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A2C761421
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhEJGSB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhEJGSB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:18:01 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C555C06175F
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:56 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l4so22698469ejc.10
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wyAe7jeIzSidxBuGCawe7PFfO1SArYFIJoyoCgCvJtk=;
        b=WxDFacSmc8NHMcFOXBXYT0kXnWThyEzqrTBuys27xVcgmBIfMdtDIqBemoLa4dI3CV
         mvxoVL9dLaxVsmUvSVa8megiaZ+Hp3CgBSIJFNT/753OuAALTNs2Rk/eZrWuTcxDspTG
         QiVM06bDBmLedFKB9C5WXVSayQbtiVJCkZKPYHW10Ce44GcA7wxFChNRc/uJvIg6lp/Y
         aLbo2yKM3bZFi0gWqHQHDkYCT3MzyvPOH7dS0tMGbgy9jBs8ZzahLMOzubA7xoN8SMef
         0kp1aRh7RckyZwn/wMj+CLLWxi5kdp3LnOEe6k3Xq4BbEUZNYY/zPyxoFmadr+UfIxFT
         nBCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wyAe7jeIzSidxBuGCawe7PFfO1SArYFIJoyoCgCvJtk=;
        b=QvVP7pCLHRGc208JPyeALCPgGKoSoPaGcArbf7D/piJZv1saAFy+l5i+orE8f0kR5z
         WHnhmaHt9SpiL5JdsWWSUdDdKK9pZ0pqRG+m5FfOYDteS7ouFQaMF6qd3n2mWsE3ywkl
         OnMiyKZ1hF3YRNLMy9IjDWaDYL65dokW4+Vb8yi8umfgzcztVzpKSRQ++oLXO4UPkw3B
         3/ccz8/VqvtKw83FfhZow1aj9YFJq/hjUsmjh1yCiHvSzPxP8jAbzfMcPCDBZqgBOCU8
         YIHYbzQ5kauXGyRko/qdwLIEjNJnR5P+sNlQVdmRDqz17cCsgaWZA1tpcL9rnR5gRYaM
         5tuw==
X-Gm-Message-State: AOAM533Q/pbROJ1k8z89TikCqyPnzv3S0KmOvTv96nMR2Dg0K2Zsstxb
        4iT1pKP/aKTvp/+ZF8Z9C8M=
X-Google-Smtp-Source: ABdhPJytXdFjFQqPXJ/ndkzUdtG4RjrtQVnkQjcaOZg1GCQVPMPF9c4IKtp2TZ2lgKT2iS6KEmrnuA==
X-Received: by 2002:a17:906:a295:: with SMTP id i21mr23608555ejz.160.1620627415010;
        Sun, 09 May 2021 23:16:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 17/21] trace-cmd library: Add support for zlib compression library
Date:   Mon, 10 May 2021 09:16:32 +0300
Message-Id: <20210510061636.1794357-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If libz is available, use that library to provide trace file compression
support. The library is detected runtime.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/Makefile                  |  10 ++
 lib/trace-cmd/include/trace-cmd-local.h |   5 +
 lib/trace-cmd/trace-compress-zlib.c     | 172 ++++++++++++++++++++++++
 lib/trace-cmd/trace-compress.c          |   8 ++
 4 files changed, 195 insertions(+)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index bab4322d..83ba7016 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -7,6 +7,13 @@ ldir:=$(src)/lib/trace-cmd
 
 DEFAULT_TARGET = $(LIBTRACECMD_STATIC)
 
+pound := \#
+ZLIB_INSTALLED := $(shell if (printf "$(pound)include <zlib.h>\n void main(){deflateInit(NULL, Z_BEST_COMPRESSION);}" | $(CC) -o /dev/null -x c - -lz >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+ifeq ($(ZLIB_INSTALLED), 1)
+CFLAGS += -DHAVE_ZLIB
+$(info    Have zlib compression support)
+endif
+
 OBJS =
 OBJS += trace-hash.o
 OBJS += trace-hooks.o
@@ -26,6 +33,9 @@ OBJS += trace-timesync-ptp.o
 OBJS += trace-timesync-kvm.o
 endif
 OBJS += trace-compress.o
+ifeq ($(ZLIB_INSTALLED), 1)
+OBJS += trace-compress-zlib.o
+endif
 
 # Additional util objects
 OBJS += trace-blk-hack.o
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index c8c51ff0..86d91caf 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -30,6 +30,11 @@ void tracecmd_fatal(const char *fmt, ...);
 #endif
 #endif
 
+#ifdef HAVE_ZLIB
+int tracecmd_zlib_init(void);
+void tracecmd_zlib_free(void);
+#endif
+
 int tracecmd_compress_init(void);
 void tracecmd_compress_free(void);
 
diff --git a/lib/trace-cmd/trace-compress-zlib.c b/lib/trace-cmd/trace-compress-zlib.c
new file mode 100644
index 00000000..3208d57b
--- /dev/null
+++ b/lib/trace-cmd/trace-compress-zlib.c
@@ -0,0 +1,172 @@
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
+#define __ZLIB_FILE		"libz.so"
+#define ZLIB_FUNC_COMPRESS	"compress2"
+#define ZLIB_FUNC_DECOMOPRESS	"uncompress"
+#define ZLIB_FUNC_SIZE		"compressBound"
+#define ZLIB_FUNC_VERSION	"zlibVersion"
+
+static void *zlib_handle;
+static int (*_lib_compress)(unsigned char *out, unsigned long *out_bytes,
+			    unsigned char *in, unsigned long in_bytes, int level);
+static int (*_libz_decompress)(unsigned char *out, unsigned long *out_bytes,
+			       unsigned char *in, unsigned long in_bytes);
+static unsigned long (*_libz_compress_bound)(unsigned long in_bytes);
+static const char *(*_libz_version)(void);
+
+static int zlib_compress(char *in, unsigned int in_bytes,
+			 char *out, unsigned int *out_bytes)
+{
+	unsigned long out_size = *out_bytes;
+	int ret;
+
+	if (!_lib_compress)
+		return -1;
+
+	ret = _lib_compress((unsigned char *)out, &out_size,
+			    (unsigned char *)in, (unsigned long)in_bytes, Z_BEST_COMPRESSION);
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
+static int zlib_decompress(char *in, unsigned int in_bytes,
+			   char *out, unsigned int *out_bytes)
+{
+	unsigned long out_size = *out_bytes;
+	int ret;
+
+	if (!_libz_decompress)
+		return -1;
+
+	ret = _libz_decompress((unsigned char *)out, &out_size,
+			       (unsigned char *)in, (unsigned long)in_bytes);
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
+	if (!_libz_compress_bound)
+		return 0;
+	return _libz_compress_bound(in_bytes);
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
+	if (!_libz_version)
+		return false;
+	zver = _libz_version();
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
+	if (zlib_handle)
+		return 0;
+
+	zlib_handle = dlopen(__ZLIB_FILE, RTLD_NOW | RTLD_GLOBAL);
+	if (!zlib_handle)
+		return -1;
+	_lib_compress = dlsym(zlib_handle, ZLIB_FUNC_COMPRESS);
+	if (!_lib_compress)
+		goto error;
+	_libz_decompress = dlsym(zlib_handle, ZLIB_FUNC_DECOMOPRESS);
+	if (!_libz_decompress)
+		goto error;
+	_libz_compress_bound = dlsym(zlib_handle, ZLIB_FUNC_SIZE);
+	if (!_libz_compress_bound)
+		goto error;
+	_libz_version = dlsym(zlib_handle, ZLIB_FUNC_VERSION);
+	if (!_libz_version)
+		goto error;
+
+	return tracecmd_compress_proto_register(__ZLIB_NAME, _libz_version(), __ZLIB_WEIGTH,
+						zlib_compress, zlib_decompress,
+						zlib_compress_bound, zlib_is_supported);
+
+error:
+	_lib_compress = NULL;
+	_libz_decompress = NULL;
+	_libz_version = NULL;
+	dlclose(zlib_handle);
+	zlib_handle = NULL;
+	return -1;
+}
+
+void tracecmd_zlib_free(void)
+{
+	_lib_compress = NULL;
+	_libz_decompress = NULL;
+	_libz_version = NULL;
+
+	if (zlib_handle) {
+		dlclose(zlib_handle);
+		zlib_handle = NULL;
+	}
+
+}
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 0f7e318a..dfa808ab 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -314,6 +314,10 @@ int tracecmd_compress_init(void)
 	gettimeofday(&time, NULL);
 	srand((time.tv_sec * 1000) + (time.tv_usec / 1000));
 
+#ifdef HAVE_ZLIB
+	tracecmd_zlib_init();
+#endif
+
 	return 0;
 }
 
@@ -477,6 +481,10 @@ void tracecmd_compress_free(void)
 	struct compress_proto *proto = proto_list;
 	struct compress_proto *del;
 
+#ifdef HAVE_ZLIB
+	tracecmd_zlib_free();
+#endif
+
 	while (proto) {
 		del = proto;
 		proto = proto->next;
-- 
2.31.1

