Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90610C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 755876023E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbhG2FLQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbhG2FLQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:16 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BFCC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:12 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y12so6393085edo.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T0zLZZKPmpL25tbLAra5wuwV9NpHnucnTUscDRY9rPc=;
        b=ri+nAaYHkTrWjkyu0tv/IewltlWlDaLtlA3qODjligNy7yKh4csnjcXrwNVh9glmIh
         0vsO69gzhgpYzdlJ/nR1Br3E9PWYlgF0vdeK73ku+SZvn/36NG0pR7XX7O/8KmfvF+AZ
         vjqMSyP/ReCl1LJNU05AkRuqrQGR7nbJAJqUCxW7G9+vg27AYdaXvyapupau9o3CFxNv
         EoHGUzNyRroLoHxzqq8GT94+6e6e4pCNgu91gsUFysOUP2+2TJlrILOD03SzxCHKjjWK
         dREWI46tNY3OG1OrKxO5pQ0VX3sJKAsVLqdDdYHtef7E9EEMAHETy7SQsAJwQao05err
         nwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T0zLZZKPmpL25tbLAra5wuwV9NpHnucnTUscDRY9rPc=;
        b=fndpR8iOxCRuWWBv34/z38monMDVZ9Lo1DF0KK9fechxMvjMbmVacgPbu2LePlMcMV
         LIcFNwZl7pkXjFMGCwEZqyc596LC8BEuuNIAQGpOXSVh8AglSHiuHYsXgtxZhYaoxEkC
         oM7HUZzUWv83h6xBIRJRVMn2YsVZMM2PyWz/4cqDUsjHKXBGF3dh07WoHbNVen7/Ypn/
         zgz3mk+rSdCNs7+3kAf+KdUCOffqIrVITe7Nvumin/rfk8pGssmw+E8aHehxXQ44WtXU
         ubBUgovbixjdm1IDF597uteUG4dey4h0xvoZsRHR3+w9r1x5xbkZilexNT2Dun9HbK+O
         CFuQ==
X-Gm-Message-State: AOAM530zY2VySFKNsim4KjfSKYdnyMkTPa0o5PpSxXDwAp0YkP11JZUH
        D0bOtAQBicV+bgiwPNtuudqWcjTSby2z2A==
X-Google-Smtp-Source: ABdhPJxAh9Mxbff2f2S5SR7cPxowYu4VpBiGPoy/6S3rf9UO1Qs6TIpWHfk6FOgYsgvneAiPzwwEOA==
X-Received: by 2002:a05:6402:896:: with SMTP id e22mr4001459edy.246.1627535470974;
        Wed, 28 Jul 2021 22:11:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 72/87] trace-cmd library: Add zlib compression algorithm
Date:   Thu, 29 Jul 2021 08:09:44 +0300
Message-Id: <20210729050959.12263-73-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added implementation for zlib compression algorithm, using libz
libraray, if available.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Makefile                                |   7 ++
 lib/trace-cmd/Makefile                  |   7 ++
 lib/trace-cmd/include/trace-cmd-local.h |   4 +
 lib/trace-cmd/trace-compress-zlib.c     | 109 ++++++++++++++++++++++++
 tracecmd/Makefile                       |   4 +
 5 files changed, 131 insertions(+)
 create mode 100644 lib/trace-cmd/trace-compress-zlib.c

diff --git a/Makefile b/Makefile
index d6fd09d8..2bc325dc 100644
--- a/Makefile
+++ b/Makefile
@@ -311,6 +311,13 @@ ifeq ($(PERF_DEFINED), 1)
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
index 0291b8de..f8a335d4 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -24,6 +24,10 @@ void tracecmd_info(const char *fmt, ...);
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
index 00000000..7f62bf0a
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
+static int zlib_compress(char *in, unsigned int in_bytes,
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
+static int zlib_decompress(char *in, unsigned int in_bytes,
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
2.31.1

