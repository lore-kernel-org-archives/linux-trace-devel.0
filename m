Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC450C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3B2F610E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhINNS2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbhINNSX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:23 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6888EC061760
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:06 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id z184-20020a1c7ec1000000b003065f0bc631so2097990wmc.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CTrf7INUA20Bk1rTfPxVSMlhRbenOJ5lSnPqezUKuCY=;
        b=pnpBhR+fCp2gh0tEnUkmvN2t/ch01tSlphaISctRzOcgDY56ODrb0yrJovrKTUOwiG
         bQsbkd39LFGIt24pwPighKFN+/TZu7NVFj0LJxxF1R8jWXkf+vB6vIvt3MTDHsVMPu03
         0fRYWnBoM7PakVareDnVPff93w77V7eKHKMrOcW2i/u/aMjSeAdX2i2GwwddQYyUlapL
         sDDYKKfU0dm3XZAg20uCFpHguNwbiEKzpRStYjuU126l+o6xHhMvyxNngXxHPylYH4TE
         qZXXvgcGRMg2GDJREmFHaxGh1JU+jvv/bEPhLHBhP28KGGQmf6ZnHfbmsWNdzMhfjoFZ
         lV0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CTrf7INUA20Bk1rTfPxVSMlhRbenOJ5lSnPqezUKuCY=;
        b=r0hfqEL1Nj2+KFHk0308irRjXWoF6kqx1yWgr89EAVZVLOmXgHz8T+CgJLpn7RupwR
         IRdAJratRS+RabaBmz76p9aaZ4e0ivcBWW1ydLI2vkmiSHUWMKjvv5GFnkqSM8xdtNwH
         RaV66UrqarBQS1JdCagKNYKkIOhF8rA2anOZNxYk83tF7J9GSL205HRF+MOzHciH0kge
         eW3qKDBZN3Ry2QkC/nlrlZPdxzyCbP0it9DCmBAm0qxswbxWLS1aX7uh1y8ilQD9lci6
         ym3xAOgQGZa01+Bmzpigt8GaEXrdXQD9r3/1YO6J+1QnVLZkI3HCVOKgq56dJC6tbXe0
         P9GA==
X-Gm-Message-State: AOAM530Nc12aRcBCpsmcdtktlUx4b0+80o73uNpq0KCwUmr+AOG0/bII
        iMu/3ruIhGlxHHax8dqzA5rvN5N+G1Y=
X-Google-Smtp-Source: ABdhPJzBAham+DnXVUKkWpoYRxZoVUFnXa9klH44DXxANcy2DpAmL+lbOo1dEq2NUB0BLCoHZc8QPA==
X-Received: by 2002:a7b:cb86:: with SMTP id m6mr2187850wmi.4.1631625425003;
        Tue, 14 Sep 2021 06:17:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:17:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 17/20] trace-cmd library: Add zlib compression algorithm
Date:   Tue, 14 Sep 2021 16:16:42 +0300
Message-Id: <20210914131645.3966308-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
index 14223a08..9ab33553 100644
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
index b198b8dc..c1f37cdf 100644
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
2.31.1

