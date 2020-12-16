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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0D3C2BBCA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 13:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B23042339F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 13:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgLPNIW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 08:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgLPNIV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 08:08:21 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673B0C061794
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 05:07:41 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 91so23112733wrj.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Dec 2020 05:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ieuwC0Cy5tMwbsO2aqXExeaHKA3jX/eKSfzHvD9pmYs=;
        b=ZaQVdNO2bkBBaJaCGO8yaBYXHbHHsz2PoRqiFQMACbo4vfvTpyT2LK7EnD4L9M9YFE
         L7dY+cQMOhsrYJnSN4UsGvmo5b7tLkvS0Zn1aeLshsWGxvgJBXUOcZyk/YEgOAk5Kj2y
         aENF3KbBOdsJ7nIW2bI9gS4DoX2C+iT/5kOwd4gLv2oA0Mt62nXesPTABBEG30I+oAEo
         C88QpkWkTq71RYvn5pyXbDZwu1Tv5UkuekLdWOyajj3sX6jlaMXYgdCT1qVDDpP1teQE
         Tl60mfcTDpyc1S8u4KuKXkhslJT5NqEtaSDa6Aw7k2k5uy/wll0wEt3ZLbP6VeO+vhQn
         uDHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ieuwC0Cy5tMwbsO2aqXExeaHKA3jX/eKSfzHvD9pmYs=;
        b=G2HCV4d92XStbUYCptqLAxnsovwb0NHvMnuaDDAekiKOF0ErtuMDhZ03FzWCr8JO8u
         mE9Boi3tgiLnHUWwnR0lIWkSf92TEi2edm8MBRLmJThHmx/ZNr0JgsUACMSTySSPk9g8
         nPQm/zhMjEx+ueN5UdDtwkrU4SIxjPKv2K9AdWCsBYMutlMBYlNr8frDgDaEV5xpu/ny
         4HmuZKa+m92G9P/01KgXCSVpb0tPDtftJG4+pTHpm32DqDnOaoK86RRxfdUb55vQbzxV
         qnQ4uT6pvKC7Dsvor7IbPg94Ai2JUzBzREOYT3LZBEzShrvC0Q5IxbB/Ntrnu/tpLsK2
         2I2w==
X-Gm-Message-State: AOAM533Lo5GnvGJDK3Y6gd5DEQKXxnByvMjvUxjcFWTTBKOssW4ZxnGx
        kD3Sb07XNyyhiTUVPbIq7jgFvnjBmrxL7g==
X-Google-Smtp-Source: ABdhPJzncoBfupljmFo4mKDtDbTOl0AtzIOOoqV+55EzDkIMiYdRjarLo3KX36rlydV34CKc/j38pg==
X-Received: by 2002:adf:eac7:: with SMTP id o7mr38750212wrn.23.1608124060091;
        Wed, 16 Dec 2020 05:07:40 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.23])
        by smtp.gmail.com with ESMTPSA id y63sm2774572wmd.21.2020.12.16.05.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 05:07:39 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2] trace-cmd: Re-enable the build of KernelShark v1
Date:   Wed, 16 Dec 2020 15:07:15 +0200
Message-Id: <20201216130715.181002-1-y.karadz@gmail.com>
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
header of libtracecmd. For this reason we are adding the path to the
tarce-cmd private headers to the list of header file locations.

We also remove the inclusion of event-utils.h in parse-utils.c in order
to fix a compilation error when building libtraceevent.a.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Makefile                              | 16 ++++++++-------
 kernel-shark/CMakeLists.txt           |  1 +
 kernel-shark/build/FindTraceCmd.cmake | 29 ++++++---------------------
 kernel-shark/src/libkshark.c          | 14 ++++++++-----
 kernel-shark/src/libkshark.h          |  2 +-
 lib/traceevent/parse-utils.c          |  2 --
 6 files changed, 26 insertions(+), 38 deletions(-)

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
diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index c95249e..0c0b825 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -81,6 +81,7 @@ include_directories(${KS_DIR}/src/
                     ${KS_DIR}/build/src/
                     ${JSONC_INCLUDE_DIR}
                     ${TRACECMD_INCLUDE_DIR}
+                    ${TRACECMD_PRIVATE_INCLUDE_DIR}
                     ${TRACEFS_INCLUDE_DIR})
 
 message("")
diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
index c29b779..a40f70e 100644
--- a/kernel-shark/build/FindTraceCmd.cmake
+++ b/kernel-shark/build/FindTraceCmd.cmake
@@ -14,25 +14,15 @@
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
                                        ${CMAKE_SOURCE_DIR}/../include/
                                 NO_DEFAULT_PATH)
+find_path(TRACECMD_PRIVATE_INCLUDE_DIR  NAMES private/trace-filter-hash.h
+                                PATHS  $ENV{TRACE_CMD}/lib/trace-cmd/include/
+                                       ${CMAKE_SOURCE_DIR}/../lib/trace-cmd/include/
+                                NO_DEFAULT_PATH)
 find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h
                                 PATHS  $ENV{TRACE_CMD}/include/
                                        ${CMAKE_SOURCE_DIR}/../include/
@@ -53,20 +43,13 @@ find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
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
 
-IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
+IF (TRACECMD_INCLUDE_DIR AND TRACECMD_PRIVATE_INCLUDE_DIR AND TRACECMD_LIBRARY)
 
   SET(TRACECMD_FOUND TRUE)
 
-ENDIF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
+ENDIF (TRACECMD_INCLUDE_DIR AND TRACECMD_PRIVATE_INCLUDE_DIR AND TRACECMD_LIBRARY)
 
 IF (TRACECMD_FOUND)
 
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
index 0d6c50d..a9cba05 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -26,7 +26,7 @@ extern "C" {
 
 // trace-cmd
 #include "trace-cmd/trace-cmd.h"
-#include "trace-cmd/trace-filter-hash.h"
+#include "private/trace-filter-hash.h"
 #include "traceevent/event-parse.h"
 #include "tracefs/tracefs.h"
 
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

