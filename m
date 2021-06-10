Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BCCC47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BB5D61414
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhFJLg5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhFJLg4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:36:56 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6E1C0617A8
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:46 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id z8so1892432wrp.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KF+feKjMyKpX88QmGJlWIg3wMmDI0ahJDLjuPSqTtL0=;
        b=GBpUoHMqls7UkxcUVSlabWYCRfoOnSaZ7P+GrF20ukxz+i7vKzt0c8T89SaQpiSJEz
         CBmPIXEGQbRceu4yHmjqFmK6j+lcjABkY6NQvzKbhGKQypD5QGq8XMeNMddOCGlpZVdg
         GnrXZ5RnG8v6uZEFQpZkMzfx8i+Te0w7hpJwTZRYU0k0ogxvO7FZMcHdOiRFNEHIDWTS
         dLpjeT8ZUDWIkmeOa1+LlmL5gwoIbTVW6Ay0cyCMoiBOqLO+R8YiuMTTafCsFiQ5mGNs
         dARA3osoyJ3pu6gKdckHdw3yoVwnyntmOtNbj+LJ7QttlNgTHFKLVaGG/QPvJ39sqwiw
         qpnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KF+feKjMyKpX88QmGJlWIg3wMmDI0ahJDLjuPSqTtL0=;
        b=csXdKZX6IHWaZ2ZfsuG4Nh0lGXcYtH3Y1oZHVnhzgQoTSesRR9rCoTP3yu+qJmsxmX
         V9+xUoRpDv0a3807nwf4Ok5Vg4qF+zaIZlX4jZXbnfI0QAVtpb/HU23oVhSOXy36ejsI
         c8YdC7EX0uamP7BNWvF7ReUgva5pVg1Snt7xrHOFJHotKYcvucSrNNKqS7ix/671eK4w
         Mn0sYktQXxuADqNUUzUl8J24moZPo8d++L8I4DfdcEHpjill/L3btgwB5o80JeJFa52l
         WxnHnlHIY3pqjDcvFKhOY3JbTZOfq4u4PmloDqJI1an47MlGnlpSoLbz6GqLgkPNBhBl
         ZpBQ==
X-Gm-Message-State: AOAM530WyiVzbzbiVD9R7ZbP+i6glp6rgnn/DeWomOyQ3oc/+RBSHBNm
        +YVzwy5Tw8TjrAF2RKBo2wGNcHZZNe0MZg==
X-Google-Smtp-Source: ABdhPJy3zSJqz0V0I2WCuPtWLaLl/akJYNl1bOvOiUYjzywezy2sfIV4BW7XNj7V+Pk+lkKoAi4p0A==
X-Received: by 2002:a5d:4a4e:: with SMTP id v14mr4919094wrs.74.1623324884482;
        Thu, 10 Jun 2021 04:34:44 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 17/40] trace-cmd library: Add support for zlib compression library
Date:   Thu, 10 Jun 2021 14:34:03 +0300
Message-Id: <20210610113426.257931-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
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
index 24228d8f..80304141 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -31,6 +31,11 @@ void tracecmd_info(const char *fmt, ...);
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
index ff742226..2b329d00 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -353,6 +353,10 @@ int tracecmd_compress_init(void)
 	gettimeofday(&time, NULL);
 	srand((time.tv_sec * 1000) + (time.tv_usec / 1000));
 
+#ifdef HAVE_ZLIB
+	tracecmd_zlib_init();
+#endif
+
 	return 0;
 }
 
@@ -530,6 +534,10 @@ void tracecmd_compress_free(void)
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

