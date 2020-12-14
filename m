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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C329C4361B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Dec 2020 19:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99000224B1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Dec 2020 19:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502260AbgLNTcY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Dec 2020 14:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501915AbgLNTcB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Dec 2020 14:32:01 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F44C0613D6
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Dec 2020 11:31:21 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id r14so17596514wrn.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Dec 2020 11:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5CkkJQBKxHM7SxHq8sfcAQ7yfP7wewg8QwUrUXdGRPA=;
        b=dyzKdcXbLtrMhkjHCK/6XWaGhiduNZH4ZRKXpFqeZ2x+zpsLzsoQ2MfN4llITdyAa7
         2FwkKF5UlgOvnf2fUqWsz7q83ZSoFCcMqh7ws03AB02Yqfg4v3qfaVV8wTM86fiyy97e
         5BEPckKZH5U/2ERh3J7Ueh2Tvj/VXeEeWWkXU4fKTT359L7ejCJ41XhNrcQGEmwc+SwX
         aFdhmXf0Cf4NdrWzDGrzLgHboQ7wIMh/Vs6mLW9WF4mY2qag4CMd9WNWQmlMXrbMhwaW
         NTqpuK7AYfenmDRY4nob+vywX3fv6v6Z6gVXIlkXj3dnfKw1sE39Np4mBocntPytFmJ8
         yyZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5CkkJQBKxHM7SxHq8sfcAQ7yfP7wewg8QwUrUXdGRPA=;
        b=B8E3ftiQCdSMPIUMPk2q4A2nRPvD1rnqtOHD7TbWwBtv055NFWkjtQV86WyYk7K7WU
         DHfby6gReH3ImV50bYglvusu4S4uZBR1qDBR35W1CJ/elvR7T2EqUOd8wnI6d62UEHY3
         SgAv5ziI8lBpgE36aHKLiuJ3JbIsnIzVCm04JfAQtLNzSVa/UQE/ZV+lYt/H+qVjVy7o
         Wghsq6dRfTa9Uc09HXYcgvqpFXYPad9lJaANgH7bfe6bjrAyj3zrDUNnTRyIOdGjuITD
         fRp6za5xnpiRRHJsf9qCtitbl+AgTFZBAhT84sCamrj9kq6vVvOLIFRWxZ/aNhQIOcrT
         od5g==
X-Gm-Message-State: AOAM533VXHN/16JA3vafnEInE+R0tBOEpc+aRlHqWYDt9WrYZr+5xiC5
        elq5WsAezsU7VYu1J4dLHUg=
X-Google-Smtp-Source: ABdhPJziqBA5vy+eGQgp85PHlpcTJDvaZo3KXVTxBwR5JGxeHL1Y1hh5MfOzLiTPlDN7JbtovTFzLA==
X-Received: by 2002:adf:e84c:: with SMTP id d12mr31772206wrn.382.1607974279832;
        Mon, 14 Dec 2020 11:31:19 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id c4sm33312812wmf.19.2020.12.14.11.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 11:31:19 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH] trace-cmd: Re-enable the build of KernelShark v1
Date:   Mon, 14 Dec 2020 21:30:57 +0200
Message-Id: <20201214193057.705624-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

libtraceevent and libtracefs are now stand-alone libraries, independent
from trace-cmd, but nevertheless trace-cmd still provides legacy/obsolete
versions of this libraries. Since we are "freezing" KernelShark v1 and
all active development is now focused on  KernelShark v2, we will keep
v1 use the legacy/obsolete versions of the libraries.

An additional problem is that trace-filter-hash.h is no longer a public
header of libtracecmd. For this reason we are adding a copy of it to
kernel-shark/src/.

We also remove the inclusion of event-utils.h in parse-utils.c in order
to fix a compilation error when building libtraceevent.a.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Makefile                              | 16 ++++---
 kernel-shark/build/FindTraceCmd.cmake | 21 ---------
 kernel-shark/src/libkshark.c          | 14 +++---
 kernel-shark/src/libkshark.h          |  2 +-
 kernel-shark/src/trace-filter-hash.h  | 64 +++++++++++++++++++++++++++
 lib/traceevent/parse-utils.c          |  2 -
 6 files changed, 83 insertions(+), 36 deletions(-)
 create mode 100644 kernel-shark/src/trace-filter-hash.h

diff --git a/Makefile b/Makefile
index ab91ae7..a2a41ae 100644
--- a/Makefile
+++ b/Makefile
@@ -356,13 +356,6 @@ $(PKG_CONFIG_FILE) : ${PKG_CONFIG_SOURCE_FILE}.template
 $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
 	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) -D_LIBDIR=$(libdir) ..
 
-gui: force
-	$(MAKE) $(CMD_TARGETS)
-	$(MAKE) $(kshark-dir)/build/Makefile
-	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
-	@echo "gui build complete"
-	@echo "  kernelshark located at $(kshark-dir)/bin"
-
 trace-cmd: force $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACECMD_STATIC) $(LIBTRACEFS_STATIC_BUILD) \
 	force $(obj)/lib/trace-cmd/plugins/tracecmd_plugin_dir
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
@@ -387,6 +380,15 @@ libtracefs.a: $(LIBTRACEFS_STATIC)
 
 libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACEFS_STATIC_BUILD)
 
+gui: force
+	$(MAKE) $(CMD_TARGETS)
+	$(MAKE) $(LIBTRACEEVENT_STATIC)
+	$(MAKE) $(LIBTRACEFS_STATIC)
+	$(MAKE) $(kshark-dir)/build/Makefile
+	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
+	@echo "gui build complete"
+	@echo "  kernelshark located at $(kshark-dir)/bin"
+
 test: force $(LIBTRACEEVENT_STATIC_BUILD) $(LIBTRACEFS_STATIC_BUILD) $(LIBTRACECMD_STATIC)
 ifneq ($(CUNIT_INSTALLED),1)
 	$(error CUnit framework not installed, cannot build unit tests))
diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
index c29b779..c772e8c 100644
--- a/kernel-shark/build/FindTraceCmd.cmake
+++ b/kernel-shark/build/FindTraceCmd.cmake
@@ -14,20 +14,6 @@
 # MESSAGE(" Looking for trace-cmd ...")
 
 # First search in the user provided paths.
-if (CMAKE_BUILD_TYPE MATCHES Debug)
-
-  find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd
-                                     PATHS  $ENV{TRACE_CMD}/tracecmd/
-                                            ${CMAKE_SOURCE_DIR}/../tracecmd/
-                                     NO_DEFAULT_PATH)
-
-endif (CMAKE_BUILD_TYPE MATCHES Debug)
-
-if (NOT TRACECMD_EXECUTABLE)
-
-  set(TRACECMD_EXECUTABLE "${_INSTALL_PREFIX}/bin/trace-cmd")
-
-endif (NOT TRACECMD_EXECUTABLE)
 
 find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
                                 PATHS  $ENV{TRACE_CMD}/include/
@@ -53,14 +39,7 @@ find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
                                        ${CMAKE_SOURCE_DIR}/../lib/
                                 NO_DEFAULT_PATH)
 
-# If not found, search in the default system paths. Note that if the previous
-# search was successful "find_path" will do nothing this time.
 find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd)
-find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h)
-find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h)
-find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.so)
-find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.so)
-find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.so)
 
 IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
 
diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 52aacd3..4e625a2 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -141,10 +141,14 @@ bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
 
 	kshark_free_task_list(kshark_ctx);
 
-	handle = tracecmd_open(file);
+	handle = tracecmd_open_head(file);
 	if (!handle)
 		return false;
 
+	/* Read the tracing data from the file. */
+	if (tracecmd_init_data(handle) < 0)
+		return false;
+
 	if (pthread_mutex_init(&kshark_ctx->input_mutex, NULL) != 0) {
 		tracecmd_close(handle);
 		return false;
@@ -696,7 +700,7 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
 	int pid;
 	int cpu;
 
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+	n_cpus = tep_get_cpus(kshark_ctx->pevent);;
 	cpu_list = calloc(n_cpus, sizeof(*cpu_list));
 	if (!cpu_list)
 		return -ENOMEM;
@@ -867,7 +871,7 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 	if (total < 0)
 		goto fail;
 
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+	n_cpus = tep_get_cpus(kshark_ctx->pevent);;
 
 	rows = calloc(total, sizeof(struct kshark_entry *));
 	if (!rows)
@@ -923,7 +927,7 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	if (total < 0)
 		goto fail;
 
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+	n_cpus = tep_get_cpus(kshark_ctx->pevent);;
 
 	rows = calloc(total, sizeof(struct tep_record *));
 	if (!rows)
@@ -1047,7 +1051,7 @@ size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
 	if (total < 0)
 		goto fail;
 
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+	n_cpus = tep_get_cpus(kshark_ctx->pevent);;
 
 	status = data_matrix_alloc(total, offset_array,
 					  cpu_array,
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
index 0d6c50d..a44f46e 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -26,7 +26,7 @@ extern "C" {
 
 // trace-cmd
 #include "trace-cmd/trace-cmd.h"
-#include "trace-cmd/trace-filter-hash.h"
+#include "trace-filter-hash.h"
 #include "traceevent/event-parse.h"
 #include "tracefs/tracefs.h"
 
diff --git a/kernel-shark/src/trace-filter-hash.h b/kernel-shark/src/trace-filter-hash.h
new file mode 100644
index 0000000..4111c41
--- /dev/null
+++ b/kernel-shark/src/trace-filter-hash.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2018 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ *
+ */
+#ifndef _TRACE_FILTER_HASH_H
+#define _TRACE_FILTER_HASH_H
+
+#include <stdint.h>
+
+struct tracecmd_filter_id_item {
+	struct tracecmd_filter_id_item	*next;
+	int				id;
+};
+
+struct tracecmd_filter_id {
+	struct tracecmd_filter_id_item **hash;
+	int				count;
+};
+
+/**
+ * tracecmd_quick_hash - A quick (non secured) hash alogirthm
+ * @val: The value to perform the hash on
+ * @bits: The size in bits you need to return
+ *
+ * This is a quick hashing function adapted from Donald E. Knuth's 32
+ * bit multiplicative hash.  See The Art of Computer Programming (TAOCP).
+ * Multiplication by the Prime number, closest to the golden ratio of
+ * 2^32.
+ *
+ * @bits is used to max the result for use cases that require
+ * a power of 2 return value that is less than 32 bits. Any value
+ * of @bits greater than 31 (or zero), will simply return the full hash on @val.
+ */
+static inline uint32_t tracecmd_quick_hash(uint32_t val, unsigned int bits)
+{
+	val *= UINT32_C(2654435761);
+
+	if (!bits || bits > 31)
+		return val;
+
+	return val & ((1 << bits) - 1);
+}
+
+struct tracecmd_filter_id_item *
+  tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id);
+void tracecmd_filter_id_add(struct tracecmd_filter_id *hash, int id);
+void tracecmd_filter_id_remove(struct tracecmd_filter_id *hash, int id);
+void tracecmd_filter_id_clear(struct tracecmd_filter_id *hash);
+struct tracecmd_filter_id *tracecmd_filter_id_hash_alloc(void);
+void tracecmd_filter_id_hash_free(struct tracecmd_filter_id *hash);
+struct tracecmd_filter_id *
+  tracecmd_filter_id_hash_copy(struct tracecmd_filter_id *hash);
+int *tracecmd_filter_ids(struct tracecmd_filter_id *hash);
+int tracecmd_filter_id_compare(struct tracecmd_filter_id *hash1,
+			       struct tracecmd_filter_id *hash2);
+
+static inline int tracecmd_filter_task_count(struct tracecmd_filter_id *hash)
+{
+	return hash->count;
+}
+
+#endif /* _TRACE_FILTER_HASH_H */
diff --git a/lib/traceevent/parse-utils.c b/lib/traceevent/parse-utils.c
index 150cee8..62d2789 100644
--- a/lib/traceevent/parse-utils.c
+++ b/lib/traceevent/parse-utils.c
@@ -9,8 +9,6 @@
 #include <stdarg.h>
 #include <errno.h>
 
-#include "event-utils.h"
-
 #define __weak __attribute__((weak))
 
 void __vwarning(const char *fmt, va_list ap)
-- 
2.25.1

