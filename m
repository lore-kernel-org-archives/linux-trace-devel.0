Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696C5C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 19 Feb 2022 23:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242121AbiBSXCZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 18:02:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240183AbiBSXCZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 18:02:25 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBFCFC6
        for <linux-trace-devel@vger.kernel.org>; Sat, 19 Feb 2022 15:02:05 -0800 (PST)
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Chamillionaire.breakpoint.cc with esmtp (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1nLYjr-0000dW-8b; Sun, 20 Feb 2022 00:02:03 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     linux-trace-devel@vger.kernel.org
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH] trace-cmd library: Add ZSTD support.
Date:   Sun, 20 Feb 2022 00:01:51 +0100
Message-Id: <20220219230151.56282-2-sebastian@breakpoint.cc>
In-Reply-To: <20220219230151.56282-1-sebastian@breakpoint.cc>
References: <20220219230151.56282-1-sebastian@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Breakpoint-Spam-Score: -1.0
X-Breakpoint-Spam-Level: -
X-Breakpoint-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
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
 Makefile                                | 12 ++++
 lib/trace-cmd/Makefile                  |  5 +-
 lib/trace-cmd/include/trace-cmd-local.h |  4 ++
 lib/trace-cmd/trace-compress-zstd.c     | 91 +++++++++++++++++++++++++
 lib/trace-cmd/trace-compress.c          |  3 +
 tracecmd/Makefile                       |  2 +-
 6 files changed, 115 insertions(+), 2 deletions(-)
 create mode 100644 lib/trace-cmd/trace-compress-zstd.c

diff --git a/Makefile b/Makefile
index f5c2cdb894f9a..109cbeb29002a 100644
--- a/Makefile
+++ b/Makefile
@@ -307,6 +307,18 @@ CFLAGS +=3D -DHAVE_ZLIB
 $(info    Have zlib compression support)
 endif
=20
+TEST_LIBZSTD =3D $(shell sh -c "$(PKG_CONFIG) --atleast-version 1.4.0 libz=
std > /dev/null 2>&1 && echo y")
+
+ifeq ("$(TEST_LIBZSTD)", "y")
+LIBZSTD_CFLAGS =3D $(shell sh -c "$(PKG_CONFIG) --cflags libzstd")
+LIBZSTD_LDLAGS =3D $(shell sh -c "$(PKG_CONFIG) --libs libzstd")
+CFLAGS +=3D -DHAVE_ZSTD
+ZSTD_INSTALLED=3D1
+$(info    Have ZSTD compression support)
+endif
+
+export LIBZSTD_CFLAGS LIBZSTD_LDLAGS ZSTD_INSTALLED
+
 CUNIT_INSTALLED :=3D $(shell if (printf "$(pound)include <CUnit/Basic.h>\n=
 void main(){CU_initialize_registry();}" | $(CC) -o /dev/null -x c - -lcuni=
t >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 export CUNIT_INSTALLED
=20
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 1820c67b48474..da0ad4deeb4f0 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -29,6 +29,9 @@ OBJS +=3D trace-compress.o
 ifeq ($(ZLIB_INSTALLED), 1)
 OBJS +=3D trace-compress-zlib.o
 endif
+ifeq ($(ZSTD_INSTALLED), 1)
+OBJS +=3D trace-compress-zstd.o
+endif
=20
 # Additional util objects
 OBJS +=3D trace-blk-hack.o
@@ -48,7 +51,7 @@ $(DEPS): | $(bdir)
 $(LIBTRACECMD_STATIC): $(OBJS)
 	$(Q)$(call do_build_static_lib)
=20
-LIBS =3D $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) -lpthread
+LIBS =3D $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS) $(LIBZSTD_LDLAGS) -l=
pthread
=20
 ifeq ($(ZLIB_INSTALLED), 1)
 LIBS +=3D -lz
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/includ=
e/trace-cmd-local.h
index 48f179d6f524a..8601a15f86f22 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -30,6 +30,10 @@ void tracecmd_info(const char *fmt, ...);
 int tracecmd_zlib_init(void);
 #endif
=20
+#ifdef HAVE_ZLIB
+int tracecmd_zstd_init(void);
+#endif
+
 struct data_file_write {
 	unsigned long long	file_size;
 	unsigned long long	write_size;
diff --git a/lib/trace-cmd/trace-compress-zstd.c b/lib/trace-cmd/trace-comp=
ress-zstd.c
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
+	ret =3D ZSTD_compress2(ctx_c, out, *out_bytes, in, in_bytes);
+	if (ZSTD_isError(ret))
+		return -1;
+	*out_bytes =3D ret;
+	return 0;
+}
+
+static int zstd_decompress(const char *in, unsigned int in_bytes,
+			   char *out, unsigned int *out_bytes)
+{
+	size_t ret;
+
+	ret =3D ZSTD_decompressDCtx(ctx_d, out, *out_bytes, in, in_bytes);
+	if (ZSTD_isError(ret)) {
+		errno =3D -EINVAL;
+		return -1;
+	}
+	*out_bytes =3D ret;
+	errno =3D 0;
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
+	int ret =3D 0;
+	size_t r;
+
+	ctx_c =3D ZSTD_createCCtx();
+	ctx_d =3D ZSTD_createDCtx();
+	if (!ctx_c || !ctx_d)
+		goto err;
+
+	r =3D ZSTD_CCtx_setParameter(ctx_c, ZSTD_c_contentSizeFlag, 0);
+	if (ZSTD_isError(r))
+		goto err;
+
+	ret =3D tracecmd_compress_proto_register(__ZSTD_NAME,
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
+	ctx_c =3D NULL;
+	ctx_d =3D NULL;
+	if (ret < 0)
+		return ret;
+	return -1;
+}
diff --git a/lib/trace-cmd/trace-compress.c b/lib/trace-cmd/trace-compress.c
index 210d58b602577..a14155a321f45 100644
--- a/lib/trace-cmd/trace-compress.c
+++ b/lib/trace-cmd/trace-compress.c
@@ -390,6 +390,9 @@ void tracecmd_compress_init(void)
 #ifdef HAVE_ZLIB
 	tracecmd_zlib_init();
 #endif
+#ifdef HAVE_ZSTD
+	tracecmd_zstd_init();
+#endif
 }
=20
 static struct compress_proto *compress_proto_select(void)
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 56742f0afa2f8..355f04723ad7c 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -49,7 +49,7 @@ all_objs :=3D $(sort $(ALL_OBJS))
 all_deps :=3D $(all_objs:$(bdir)/%.o=3D$(bdir)/.%.d)
=20
 CONFIG_INCLUDES =3D
-CONFIG_LIBS	=3D -lrt -lpthread $(TRACE_LIBS)
+CONFIG_LIBS	=3D -lrt -lpthread $(TRACE_LIBS) $(LIBZSTD_LDLAGS)
 CONFIG_FLAGS	=3D
=20
 ifeq ($(ZLIB_INSTALLED), 1)
--=20
2.35.1

