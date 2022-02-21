Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD028C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 13:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359135AbiBUNfl convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 08:35:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiBUNfk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 08:35:40 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E083DF29
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 05:35:16 -0800 (PST)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nM8qO-0000tF-N8; Mon, 21 Feb 2022 14:35:12 +0100
Date:   Mon, 21 Feb 2022 14:35:12 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v2] trace-compress: Add ZSTD support.
Message-ID: <YhOVEG2AjVPJEw0q@breakpoint.cc>
References: <20220219230151.56282-1-sebastian@breakpoint.cc>
 <20220219230151.56282-2-sebastian@breakpoint.cc>
 <CAPpZLN7_xM7rp_C7KGjed-8W4nt+Yn0XiN8mpwVGLjgCboTmhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAPpZLN7_xM7rp_C7KGjed-8W4nt+Yn0XiN8mpwVGLjgCboTmhQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The zstd support is using the context aware function so there is no need
to for the library to allocate one (including the memory) for every
invocation. This requires to be used in a single threaded environment or
the API needs to be extended to pass the context parameter.

In most cases the input buffer was 40KiB so it does not make sense to
use higher compression levels. Higher compression levels won't
significantly improve the compression ration given that the every 40KiB
block is independent. However higher compression levels will slow down
the compression process.

The upper level stores 4 bytes compressed and decompressed size. In
order to not save the decompressed size twice, the library won't store
the store in each compressed block. This shrinks the frame header a
little. In theory the ZSTD-magic (4 bytes) could be stripped away but
that is little complicated and the 4 bytes shouldn't hurt. We could even
enable check summing to be sure that the compressed block wasn't
accidentally tampered.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
v1…v2:
  - Use HAVE_ZSTD around tracecmd_zstd_init().
  - Make tracecmd_zstd_init() static inline so we can avoid the ifdef on
    the user's side.

 Makefile                                | 12 ++++
 lib/trace-cmd/Makefile                  |  5 +-
 lib/trace-cmd/include/trace-cmd-local.h |  9 +++
 lib/trace-cmd/trace-compress-zstd.c     | 91 +++++++++++++++++++++++++
 lib/trace-cmd/trace-compress.c          |  1 +
 tracecmd/Makefile                       |  2 +-
 6 files changed, 118 insertions(+), 2 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zstd.c

diff --git a/Makefile b/Makefile
index f5c2cdb894f9a..109cbeb29002a 100644
--- a/Makefile
+++ b/Makefile
@@ -307,6 +307,18 @@ CFLAGS += -DHAVE_ZLIB
 $(info    Have zlib compression support)
 endif
 
+TEST_LIBZSTD = $(shell sh -c "$(PKG_CONFIG) --atleast-version 1.4.0 libzstd > /dev/null 2>&1 && echo y")
+
+ifeq ("$(TEST_LIBZSTD)", "y")
+LIBZSTD_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags libzstd")
+LIBZSTD_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs libzstd")
+CFLAGS += -DHAVE_ZSTD
+ZSTD_INSTALLED=1
+$(info    Have ZSTD compression support)
+endif
+
+export LIBZSTD_CFLAGS LIBZSTD_LDLAGS ZSTD_INSTALLED
+
 CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -o /dev/null -x c - -lcunit >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 export CUNIT_INSTALLED
 
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 1820c67b48474..da0ad4deeb4f0 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -29,6 +29,9 @@ OBJS += trace-compress.o
 ifeq ($(ZLIB_INSTALLED), 1)
 OBJS += trace-compress-zlib.o
 endif
+ifeq ($(ZSTD_INSTALLED), 1)
+OBJS += trace-compress-zstd.o
+endif
 
 # Additional util objects
 OBJS += trace-blk-hack.o
@@ -48,7 +51,7 @@ $(DEPS): | $(bdir)
 $(LIBTRACECMD_STATIC): $(OBJS)
 	$(Q)$(call do_build_static_lib)
 
-LIBS = $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) -lpthread
+LIBS = $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) $(LIBZSTD_LDLAGS) -lpthread
 
 ifeq ($(ZLIB_INSTALLED), 1)
 LIBS += -lz
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 48f179d6f524a..a16e488a6bed1 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -30,6 +30,15 @@ void tracecmd_info(const char *fmt, ...);
 int tracecmd_zlib_init(void);
 #endif
 
+#ifdef HAVE_ZSTD
+int tracecmd_zstd_init(void);
+#else
+static inline int tracecmd_zstd_init(void)
+{
+	return 0;
+}
+#endif
+
 struct data_file_write {
 	unsigned long long	file_size;
 	unsigned long long	write_size;
diff --git a/lib/trace-cmd/trace-compress-zstd.c b/lib/trace-cmd/trace-compress-zstd.c
new file mode 100644
index 0000000000000..fc5e350f32509
--- /dev/null
+++ b/lib/trace-cmd/trace-compress-zstd.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2022, Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
+ *
+ */
+#include <stdlib.h>
+#include <zstd.h>
+#include <errno.h>
+
+#include "trace-cmd-private.h"
+
+#define __ZSTD_NAME		"zstd"
+#define __ZSTD_WEIGTH		5
+
+static ZSTD_CCtx *ctx_c;
+static ZSTD_DCtx *ctx_d;
+
+static int zstd_compress(const char *in, unsigned int in_bytes,
+			 char *out, unsigned int *out_bytes)
+{
+	size_t ret;
+
+	ret = ZSTD_compress2(ctx_c, out, *out_bytes, in, in_bytes);
+	if (ZSTD_isError(ret))
+		return -1;
+	*out_bytes = ret;
+	return 0;
+}
+
+static int zstd_decompress(const char *in, unsigned int in_bytes,
+			   char *out, unsigned int *out_bytes)
+{
+	size_t ret;
+
+	ret = ZSTD_decompressDCtx(ctx_d, out, *out_bytes, in, in_bytes);
+	if (ZSTD_isError(ret)) {
+		errno = -EINVAL;
+		return -1;
+	}
+	*out_bytes = ret;
+	errno = 0;
+	return 0;
+}
+
+static unsigned int zstd_compress_bound(unsigned int in_bytes)
+{
+	return ZSTD_compressBound(in_bytes);
+}
+
+static bool zstd_is_supported(const char *name, const char *version)
+{
+	if (!name)
+		return false;
+	if (strcmp(name, __ZSTD_NAME))
+		return false;
+
+	return true;
+}
+
+int tracecmd_zstd_init(void)
+{
+	int ret = 0;
+	size_t r;
+
+	ctx_c = ZSTD_createCCtx();
+	ctx_d = ZSTD_createDCtx();
+	if (!ctx_c || !ctx_d)
+		goto err;
+
+	r = ZSTD_CCtx_setParameter(ctx_c, ZSTD_c_contentSizeFlag, 0);
+	if (ZSTD_isError(r))
+		goto err;
+
+	ret = tracecmd_compress_proto_register(__ZSTD_NAME,
+					       ZSTD_versionString(),
+					       __ZSTD_WEIGTH,
+					       zstd_compress,
+					       zstd_decompress,
+					       zstd_compress_bound,
+					       zstd_is_supported);
+	if (!ret)
+		return 0;
+err:
+	ZSTD_freeCCtx(ctx_c);
+	ZSTD_freeDCtx(ctx_d);
+	ctx_c = NULL;
+	ctx_d = NULL;
+	if (ret < 0)
+		return ret;
+	return -1;
+}
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 210d58b602577..4fca7019ee048 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -390,6 +390,7 @@ void tracecmd_compress_init(void)
 #ifdef HAVE_ZLIB
 	tracecmd_zlib_init();
 #endif
+	tracecmd_zstd_init();
 }
 
 static struct compress_proto *compress_proto_select(void)
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 56742f0afa2f8..355f04723ad7c 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -49,7 +49,7 @@ all_objs := $(sort $(ALL_OBJS))
 all_deps := $(all_objs:$(bdir)/%.o=$(bdir)/.%.d)
 
 CONFIG_INCLUDES =
-CONFIG_LIBS	= -lrt -lpthread $(TRACE_LIBS)
+CONFIG_LIBS	= -lrt -lpthread $(TRACE_LIBS) $(LIBZSTD_LDLAGS)
 CONFIG_FLAGS	=
 
 ifeq ($(ZLIB_INSTALLED), 1)
-- 
2.35.1

