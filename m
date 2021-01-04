Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B604FC433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CE2C206E4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbhADRsW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbhADRsU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:48:20 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B31EC061794
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:47:39 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id h16so28202448edt.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/MssCVWttlOSkk+O7dcpV0ElxXwUugI/eWzTY461130=;
        b=dp0dXJ++WkHZ97smGi7rR5HlexmVad5AEXYQfa9G8v0UH0cgBMQi30WBJGyLvgTmd7
         QsydfEauCe4DuhtYp/e7H9jLG0e/BJ3mSaNX4r7XwadWnARWMS3pF/y3i8q6FSr2Lig+
         i1QpBv0hJ8sd3Nt+eKH2uokMoAFB+8GSzXrpqZ5ZGYPNu2+KcVSEFYFftRUjJL/tzQjA
         jQ8/7OopPHT9nEEyxQ7Il867hZH1O1xIG922FIv8tG6RjgrwR3l3f+rLj3SXasoazvnx
         HwK+NNMd9kywAHArsYC2C54MzVYnAIDvjIAbKCGVqQhUn4thazmvm5C465yjjW62XoW4
         jebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/MssCVWttlOSkk+O7dcpV0ElxXwUugI/eWzTY461130=;
        b=D2SDjQCKAmhoGWpQrPR6LQ6IQfkKJpORiSzYe7CwjBhZ6PUXQQKV5D9MBfuF9U76UA
         FWWw+erh2bRs0Ur10mtrtHXh82Ba2L98WNPqp0fhNnTwLlS5h+++5fKYxbofeFbwSt50
         vB62q2dbQGXftXUbLdtWoe+atu2TY+OvxxyZWCRXSkTYaraHQBTuCaUjfsxJbdy1qBo6
         DJmN30TkHzgEOqKjVD2G62zUSBz6gyxvudL2HfJtgfhbo1L1kacs9CSAIjUHHddVK/vS
         S56Kg+bJDAy6DGK6FXTccA6mVD52WU2hT3EPXSDeBz6Od8v+4mINwpIshkZuHzrIvj/U
         JHBA==
X-Gm-Message-State: AOAM533UCO9lHOlbw51NO1B8ZZJteGbg3+x+GB8YH12X/u0TeHJvuHU8
        sUpXmJ/CET+4yo45aFBtmEE=
X-Google-Smtp-Source: ABdhPJx8kLA/ad9NjS9WNkbAWPHpF97xd9RGChhWlJg6TOsWw8YK3N7+RdPqwmILbrJgfTC9hIyJlg==
X-Received: by 2002:a05:6402:b9a:: with SMTP id cf26mr70866588edb.372.1609782458286;
        Mon, 04 Jan 2021 09:47:38 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:47:37 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 02/44] kernel-shark: Use libtraceevent and libtracefs
Date:   Mon,  4 Jan 2021 19:46:42 +0200
Message-Id: <20210104174724.70404-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

libtraceevent and libtracefs are now stand-alone libraries, independent
form trace-cmd. Start building and linking KernelShark against those
independent libraries. All 3 libraries (libtraceevent, libtracefs and
libtracecmd) are being detected by using pkg-config. Since
trace-filter-hash.h is no longer distributed as a public header by the
libtracecmd, we are adding a copy of it. This is a temporary solution.
In the folowing patches we will introduce a new implementation of the
hash table provided by trace-filter-hash.h and the header itself will
be removed once it is no longer needed.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt             |   9 ++-
 build/FindTraceCmd.cmake   | 138 +++++++++++++++----------------------
 build/FindTraceEvent.cmake |  76 ++++++++++++++++++++
 build/FindTraceFS.cmake    |  76 ++++++++++++++++++++
 src/CMakeLists.txt         |   6 +-
 src/libkshark.c            |  10 +--
 src/libkshark.h            |   2 +-
 src/trace-filter-hash.h    |  64 +++++++++++++++++
 8 files changed, 286 insertions(+), 95 deletions(-)
 create mode 100644 build/FindTraceEvent.cmake
 create mode 100644 build/FindTraceFS.cmake
 create mode 100644 src/trace-filter-hash.h

diff --git a/CMakeLists.txt b/CMakeLists.txt
index c95249e..3ea40f0 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -21,7 +21,11 @@ if (NOT _LIBDIR)
     set(_LIBDIR "${_INSTALL_PREFIX}/lib")
 endif (NOT _LIBDIR)
 
-include(${KS_DIR}/build/FindTraceCmd.cmake)
+set(CMAKE_MODULE_PATH "${KS_DIR}/build")
+find_package(TraceEvent REQUIRED)
+find_package(TraceFS    REQUIRED)
+find_package(TraceCmd   REQUIRED)
+
 include(${KS_DIR}/build/FindJSONC.cmake)
 
 find_package(Doxygen)
@@ -80,8 +84,7 @@ endif (CMAKE_BUILD_TYPE MATCHES Package)
 include_directories(${KS_DIR}/src/
                     ${KS_DIR}/build/src/
                     ${JSONC_INCLUDE_DIR}
-                    ${TRACECMD_INCLUDE_DIR}
-                    ${TRACEFS_INCLUDE_DIR})
+                    ${TRACECMD_INCLUDE_DIR})
 
 message("")
 message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
diff --git a/build/FindTraceCmd.cmake b/build/FindTraceCmd.cmake
index 02f4529..23eefed 100644
--- a/build/FindTraceCmd.cmake
+++ b/build/FindTraceCmd.cmake
@@ -1,106 +1,78 @@
-# Find traceevent and trace-cmd
-# This module finds an installed trace-cmd package.
-#
-# It sets the following variables:
-#  TRACEEVENT_LIBRARY, traceevent the library.
-#  TRACEEVENT_FOUND, If false, do not try to use traceevent.
-#
-#  TRACECMD_INCLUDE_DIR, where to find trace-cmd header.
-#  TRACEFS_INCLUDE_DIR, where to find tracefs header.
-#  TRACEFS_LIBRARY, the tracefs library.
-#  TRACECMD_LIBRARY, the trace-cmd library.
-#  TRACECMD_FOUND, If false, do not try to use trace-cmd.
+# SPDX-License-Identifier: LGPL-2.1
 
-# MESSAGE(" Looking for trace-cmd ...")
+#[=======================================================================[.rst:
+FindTraceCmd
+-------
 
-# First search in the user provided paths.
-if (CMAKE_BUILD_TYPE MATCHES Debug)
+Finds the tracecmd library.
 
-  find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd
-                                     PATHS  $ENV{TRACE_CMD}/tracecmd/
-                                     NO_DEFAULT_PATH)
+Imported Targets
+^^^^^^^^^^^^^^^^
 
-endif (CMAKE_BUILD_TYPE MATCHES Debug)
+This module defines the :prop_tgt:`IMPORTED` targets:
 
-if (NOT TRACECMD_EXECUTABLE)
+``trace::cmd``
+ Defined if the system has libtracecmd.
 
-  set(TRACECMD_EXECUTABLE "${_INSTALL_PREFIX}/bin/trace-cmd")
+Result Variables
+^^^^^^^^^^^^^^^^
 
-endif (NOT TRACECMD_EXECUTABLE)
+``TraceCmd_FOUND``
+  True if the system has the libtracecmd library.
+``TraceCmd_VERSION``
+  The version of the libtracecmd library which was found.
+``TraceCmd_INCLUDE_DIRS``
+  Include directories needed to use libtracecmd.
+``TraceCmd_LIBRARIES``
+  Libraries needed to link to libtracecmd.
 
-find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
-                                PATHS  $ENV{TRACE_CMD}/include/
-                                NO_DEFAULT_PATH)
+Cache Variables
+^^^^^^^^^^^^^^^
 
-find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h
-                                PATHS  $ENV{TRACE_CMD}/include/
-                                NO_DEFAULT_PATH)
+``TraceCmd_INCLUDE_DIR``
+  The directory containing ``trace-cmd.h``.
+``TraceCmd_LIBRARY``
+  The path to the tracecmd library.
 
-find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.a
-                                PATHS  $ENV{TRACE_CMD}/lib/
-                                NO_DEFAULT_PATH)
+#]=======================================================================]
 
-find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.a
-                                PATHS  $ENV{TRACE_CMD}/lib/
-                                NO_DEFAULT_PATH)
+find_package(PkgConfig QUIET)
+pkg_check_modules(PC_TraceCmd QUIET libtracecmd)
 
-find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
-                                PATHS  $ENV{TRACE_CMD}/lib/
-                                NO_DEFAULT_PATH)
+set(TraceCmd_VERSION     ${PC_TraceCmd_VERSION})
+set(TraceCmd_DEFINITIONS ${PC_TraceCmd_CFLAGS_OTHER})
 
-# If not found, search in the default system paths. Note that if the previous
-# search was successful "find_path" will do nothing this time.
-find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd)
-find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h)
-find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h)
-find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.so)
-find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.so)
-find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.so)
+find_path(TraceCmd_INCLUDE_DIR NAMES trace-cmd/trace-cmd.h
+                               HINTS ${PC_TraceCmd_INCLUDE_DIRS}
+                                     ${PC_TraceCmd_INCLUDEDIR})
 
-IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
+find_library(TraceCmd_LIBRARY  NAMES tracecmd libtracecmd
+                               HINTS ${PC_TraceCmd_LIBDIR}
+                                     ${PC_TraceCmdLIBRARY_DIRS})
 
-  SET(TRACECMD_FOUND TRUE)
+mark_as_advanced(TraceCmd_INCLUDE_DIR TraceCmd_LIBRARY)
 
-ENDIF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
+include(FindPackageHandleStandardArgs)
 
-IF (TRACECMD_FOUND)
+find_package_handle_standard_args(TraceCmd DEFAULT_MSG
+                                  TraceCmd_LIBRARY TraceCmd_INCLUDE_DIR)
 
-  MESSAGE(STATUS "Found trace-cmd: ${TRACECMD_LIBRARY}")
+if(TraceCmd_FOUND)
 
-ELSE (TRACECMD_FOUND)
+  set(TraceCmd_LIBRARIES    ${TraceCmd_LIBRARY})
+  set(TraceCmd_INCLUDE_DIRS ${TraceCmd_INCLUDE_DIR})
 
-  MESSAGE(FATAL_ERROR "\nCould not find trace-cmd!\n")
+  if(NOT TARGET trace::cmd)
+    add_library(trace::cmd UNKNOWN IMPORTED)
 
-ENDIF (TRACECMD_FOUND)
+    set_target_properties(trace::cmd
+                          PROPERTIES
+                            INTERFACE_INCLUDE_DIRECTORIES "${TraceCmd_INCLUDE_DIRS}"
+                            INTERFACE_COMPILE_DEFINITIONS "${TraceCmd_DEFINITIONS}"
+                            IMPORTED_LINK_INTERFACE_LANGUAGES "C"
+                            IMPORTED_LOCATION "${TraceCmd_LIBRARIES}")
+  endif()
 
-IF (TRACEFS_INCLUDE_DIR AND TRACEFS_LIBRARY)
+endif()
 
-  SET(TRACEFS_FOUND TRUE)
-
-ENDIF (TRACEFS_INCLUDE_DIR AND TRACEFS_LIBRARY)
-
-IF (TRACEFS_FOUND)
-
-  MESSAGE(STATUS "Found tracefs: ${TRACEFS_LIBRARY}")
-
-ELSE (TRACEFS_FOUND)
-
-  MESSAGE(FATAL_ERROR "\nCould not find tracefs!\n")
-
-ENDIF (TRACEFS_FOUND)
-
-IF (TRACEEVENT_LIBRARY)
-
-  SET(TRACEEVENT_FOUND TRUE)
-
-ENDIF (TRACEEVENT_LIBRARY)
-
-IF (TRACEEVENT_FOUND)
-
-  MESSAGE(STATUS "Found traceevent: ${TRACEEVENT_LIBRARY}")
-
-ELSE (TRACEEVENT_FOUND)
-
-  MESSAGE(FATAL_ERROR "\nCould not find libtraceevent!\n")
-
-ENDIF (TRACEEVENT_FOUND)
+find_program(TRACECMD_EXECUTABLE NAMES trace-cmd)
diff --git a/build/FindTraceEvent.cmake b/build/FindTraceEvent.cmake
new file mode 100644
index 0000000..ae391b6
--- /dev/null
+++ b/build/FindTraceEvent.cmake
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: LGPL-2.1
+
+#[=======================================================================[.rst:
+FindTraceevent
+-------
+
+Finds the traceevent library.
+
+Imported Targets
+^^^^^^^^^^^^^^^^
+
+This module defines the :prop_tgt:`IMPORTED` targets:
+
+``trace::event``
+ Defined if the system has libtraceevent.
+
+Result Variables
+^^^^^^^^^^^^^^^^
+
+``TraceEvent_FOUND``
+  True if the system has the libtraceevent library.
+``TraceEvent_VERSION``
+  The version of the libtraceevent library which was found.
+``TraceEvent_INCLUDE_DIRS``
+  Include directories needed to use libtraceevent.
+``TraceEvent_LIBRARIES``
+  Libraries needed to link to libtraceevent.
+
+Cache Variables
+^^^^^^^^^^^^^^^
+
+``TraceEvent_INCLUDE_DIR``
+  The directory containing ``event-parse.h``.
+``TraceEvent_LIBRARY``
+  The path to the traceevent library.
+
+#]=======================================================================]
+
+find_package(PkgConfig QUIET)
+pkg_check_modules(PC_TraceEvent QUIET libtraceevent)
+
+set(TraceEvent_VERSION     ${PC_TraceEvent_VERSION})
+set(TraceEvent_DEFINITIONS ${PC_TraceEvent_CFLAGS_OTHER})
+
+find_path(TraceEvent_INCLUDE_DIR  NAMES traceevent/event-parse.h
+                                  HINTS ${PC_TraceEvent_INCLUDE_DIRS}
+                                        ${PC_TraceEvent_INCLUDEDIR})
+
+find_library(TraceEvent_LIBRARY   NAMES traceevent libtraceevent
+                                  HINTS ${PC_TraceEvent_LIBDIR}
+                                        ${PC_TraceEventLIBRARY_DIRS})
+
+mark_as_advanced(TraceEvent_INCLUDE_DIR TraceEvent_LIBRARY)
+
+include(FindPackageHandleStandardArgs)
+
+find_package_handle_standard_args(TraceEvent DEFAULT_MSG
+                                  TraceEvent_LIBRARY TraceEvent_INCLUDE_DIR)
+
+if(TraceEvent_FOUND)
+
+  set(TraceEvent_LIBRARIES    ${TraceEvent_LIBRARY})
+  set(TraceEvent_INCLUDE_DIRS ${TraceEvent_INCLUDE_DIR})
+
+  if(NOT TARGET trace::event)
+    add_library(trace::event UNKNOWN IMPORTED)
+
+    set_target_properties(trace::event
+                          PROPERTIES
+                            INTERFACE_INCLUDE_DIRECTORIES "${TraceEvent_INCLUDE_DIRS}"
+                            INTERFACE_COMPILE_DEFINITIONS "${TraceEvent_DEFINITIONS}"
+                            IMPORTED_LINK_INTERFACE_LANGUAGES "C"
+                            IMPORTED_LOCATION "${TraceEvent_LIBRARIES}")
+  endif()
+
+endif()
diff --git a/build/FindTraceFS.cmake b/build/FindTraceFS.cmake
new file mode 100644
index 0000000..82fa012
--- /dev/null
+++ b/build/FindTraceFS.cmake
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: LGPL-2.1
+
+#[=======================================================================[.rst:
+FindTraceFS
+-------
+
+Finds the tracefs library.
+
+Imported Targets
+^^^^^^^^^^^^^^^^
+
+This module defines the :prop_tgt:`IMPORTED` targets:
+
+``trace::fs``
+ Defined if the system has libtracefs.
+
+Result Variables
+^^^^^^^^^^^^^^^^
+
+``TraceFS_FOUND``
+  True if the system has the libtracefs library.
+``TraceFS_VERSION``
+  The version of the libtracefs library which was found.
+``TraceFS_INCLUDE_DIRS``
+  Include directories needed to use libtracefs.
+``TraceFS_LIBRARIES``
+  Libraries needed to link to libtracefs.
+
+Cache Variables
+^^^^^^^^^^^^^^^
+
+``TraceFS_INCLUDE_DIR``
+  The directory containing ``tracefs.h``.
+``TraceFS_LIBRARY``
+  The path to the tracefs library.
+
+#]=======================================================================]
+
+find_package(PkgConfig QUIET)
+pkg_check_modules(PC_TraceFS QUIET libtracefs)
+
+set(TraceFS_VERSION     ${PC_TraceFS_VERSION})
+set(TraceFS_DEFINITIONS ${PC_TraceFS_CFLAGS_OTHER})
+
+find_path(TraceFS_INCLUDE_DIR  NAMES tracefs/tracefs.h
+                               HINTS ${PC_TraceFS_INCLUDE_DIRS}
+                                     ${PC_TraceFS_INCLUDEDIR})
+
+find_library(TraceFS_LIBRARY   NAMES tracefs libtracefs
+                               HINTS ${PC_TraceFS_LIBDIR}
+                                     ${PC_TraceFSLIBRARY_DIRS})
+
+mark_as_advanced(TraceFS_INCLUDE_DIR TraceFS_LIBRARY)
+
+include(FindPackageHandleStandardArgs)
+
+find_package_handle_standard_args(TraceFS DEFAULT_MSG
+                                  TraceFS_LIBRARY TraceFS_INCLUDE_DIR)
+
+if(TraceFS_FOUND)
+
+  set(TraceFS_LIBRARIES    ${TraceFS_LIBRARY})
+  set(TraceFS_INCLUDE_DIRS ${TraceFS_INCLUDE_DIR})
+
+  if(NOT TARGET trace::fs)
+    add_library(trace::fs UNKNOWN IMPORTED)
+
+    set_target_properties(trace::fs
+                          PROPERTIES
+                            INTERFACE_INCLUDE_DIRECTORIES "${TraceFS_INCLUDE_DIRS}"
+                            INTERFACE_COMPILE_DEFINITIONS "${TraceFS_DEFINITIONS}"
+                            IMPORTED_LINK_INTERFACE_LANGUAGES "C"
+                            IMPORTED_LOCATION "${TraceFS_LIBRARIES}")
+  endif()
+
+endif()
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 457c100..7663d44 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -7,9 +7,9 @@ add_library(kshark SHARED libkshark.c
                           libkshark-configio.c
                           libkshark-collection.c)
 
-target_link_libraries(kshark ${TRACECMD_LIBRARY}
-                             ${TRACEFS_LIBRARY}
-                             ${TRACEEVENT_LIBRARY}
+target_link_libraries(kshark trace::cmd
+                             trace::fs
+                             trace::event
                              ${JSONC_LIBRARY}
                              ${CMAKE_DL_LIBS})
 
diff --git a/src/libkshark.c b/src/libkshark.c
index 42dc08c..a540da2 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -141,7 +141,7 @@ bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
 
 	kshark_free_task_list(kshark_ctx);
 
-	handle = tracecmd_open(file);
+	handle = tracecmd_open_head(file);
 	if (!handle)
 		return false;
 
@@ -696,7 +696,7 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
 	int pid;
 	int cpu;
 
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+	n_cpus = tep_get_cpus(kshark_ctx->pevent);
 	cpu_list = calloc(n_cpus, sizeof(*cpu_list));
 	if (!cpu_list)
 		return -ENOMEM;
@@ -867,7 +867,7 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 	if (total < 0)
 		goto fail;
 
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+	n_cpus = tep_get_cpus(kshark_ctx->pevent);
 
 	rows = calloc(total, sizeof(struct kshark_entry *));
 	if (!rows)
@@ -923,7 +923,7 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	if (total < 0)
 		goto fail;
 
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+	n_cpus = tep_get_cpus(kshark_ctx->pevent);
 
 	rows = calloc(total, sizeof(struct tep_record *));
 	if (!rows)
@@ -1047,7 +1047,7 @@ size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
 	if (total < 0)
 		goto fail;
 
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+	n_cpus = tep_get_cpus(kshark_ctx->pevent);
 
 	status = data_matrix_alloc(total, offset_array,
 					  cpu_array,
diff --git a/src/libkshark.h b/src/libkshark.h
index 0d6c50d..a44f46e 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -26,7 +26,7 @@ extern "C" {
 
 // trace-cmd
 #include "trace-cmd/trace-cmd.h"
-#include "trace-cmd/trace-filter-hash.h"
+#include "trace-filter-hash.h"
 #include "traceevent/event-parse.h"
 #include "tracefs/tracefs.h"
 
diff --git a/src/trace-filter-hash.h b/src/trace-filter-hash.h
new file mode 100644
index 0000000..4111c41
--- /dev/null
+++ b/src/trace-filter-hash.h
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
-- 
2.25.1

