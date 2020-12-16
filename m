Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90661C1B0D8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:23:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61E4A238E5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Dec 2020 23:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgLPXXI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 18:23:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730468AbgLPXXH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 18:23:07 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37277239ED;
        Wed, 16 Dec 2020 23:21:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1kpg78-000xIn-5x; Wed, 16 Dec 2020 18:21:46 -0500
Message-ID: <20201216232145.985255400@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 16 Dec 2020 18:19:48 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 6/6 v2] trace-cmd: Re-enable the build of KernelShark v1
References: <20201216231942.127326802@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>

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

Link: https://lore.kernel.org/linux-trace-devel/20201216130715.181002-1-y.karadz@gmail.com

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
[ Removed Makefile libtraceevent updates as other commits handle them ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/CMakeLists.txt           |  1 +
 kernel-shark/build/FindTraceCmd.cmake | 29 ++++++---------------------
 kernel-shark/src/libkshark.c          | 14 ++++++++-----
 kernel-shark/src/libkshark.h          |  2 +-
 4 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index c95249e9a235..0c0b8255d7a1 100644
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
index c29b77911361..a40f70e54093 100644
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
index 52aacd3044eb..4e625a25e902 100644
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
index 0d6c50d10c1b..a9cba054a32f 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -26,7 +26,7 @@ extern "C" {
 
 // trace-cmd
 #include "trace-cmd/trace-cmd.h"
-#include "trace-cmd/trace-filter-hash.h"
+#include "private/trace-filter-hash.h"
 #include "traceevent/event-parse.h"
 #include "tracefs/tracefs.h"
 
-- 
2.29.2


