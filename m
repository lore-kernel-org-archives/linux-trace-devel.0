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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C06FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:48:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1692823329
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391320AbgLKPI5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391873AbgLKPIz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:08:55 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775B7C061794
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:14 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id k10so7827966wmi.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hE+uIEor9ya/fd68YUmCQUa32mnHUFmSROH8CSHHer0=;
        b=hOHoqG3UCEaomfu2A6pakqjKh9BTlAh6FCVPOWQouHXh8RAJMeQOM1yfa8ScLiZn3z
         2+TgUQ2ZhCL56hYkr8qZaCK/R/f0881O+80g04i4nYoMQKzHY5cSkqMZrif7zvlAkQuf
         Jb12PX+Hkrh/qOiO6K3eycmfHQGUr3fuPQOofUY4XoKwSls2aP3e7GOOxVSsX+zKbdwf
         XEl/1uxdIi3Pfa2ME0eb4/gF6NYYWFZsb5/LEWM3qsM35REtzfeKZE9hD3nvnMvNdSg4
         /EkTrqbVd7WbbU0P20STUn90aC8j7V19JIiPDxxDjyz7dH63U3OHEBq5gCAXmNQwtpIr
         P5vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hE+uIEor9ya/fd68YUmCQUa32mnHUFmSROH8CSHHer0=;
        b=hhAxDaAVW6elZJ/l8n2rJirpcY1SMBPo4LtHfxMHs3xMiC1JyCY9ZcpirBgVPUCQ0+
         D740gqE3IAz530vqPdlG3suRee4n1L2qRRxv0PTM1nZKPHRtpWa5kmMHCC2igYhi46m5
         d5Z62rHYjXPL5/0l5k3v3boWrlUzDEuKMzhgoT5NPmM9LAM6kJW2No0Ro+PX+KX6uslb
         i7OlZJIyKH77CXPQiA2W32dYttWNSMf4bRzvkzGrPhFUwAGha2u7/esUUD7bX2lAPeTB
         6rz8hYbpw9Pjq8+Biq8kjXpXsuldJdS84SHEfN54iTMPEzdXuA45z3o9UBtx9Hj7TKxF
         kIVg==
X-Gm-Message-State: AOAM531JKexEmoN9ruc4woInhzoNtSb/L5jjKwgdsTWfuSL5foFWUq1d
        P3CFui928DKaQgC0W87RgjH8f1+cVbM=
X-Google-Smtp-Source: ABdhPJwpUIS58KerJAD5i5s3V0oOsoujdB7zfzE8aP3ot8LCyi3frZAt/lJ4Ux0Y75mzZsMX//Oofw==
X-Received: by 2002:a7b:cf30:: with SMTP id m16mr13884498wmg.145.1607699293202;
        Fri, 11 Dec 2020 07:08:13 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:12 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 03/32] kernel-shark: Use libtraceevent and libtracefs
Date:   Fri, 11 Dec 2020 17:07:27 +0200
Message-Id: <20201211150756.577366-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

libtraceevent and libtracefs are now stand-alone libraries, independent
form trace-cmd. Start building and linking KernelShark against those
independent libraries.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt             |  8 +++-
 build/FindTraceCmd.cmake   | 53 ++-------------------------
 build/FindTraceEvent.cmake | 75 ++++++++++++++++++++++++++++++++++++++
 build/FindTraceFS.cmake    | 75 ++++++++++++++++++++++++++++++++++++++
 src/CMakeLists.txt         |  4 +-
 src/libkshark.c            | 10 ++---
 6 files changed, 166 insertions(+), 59 deletions(-)
 create mode 100644 build/FindTraceEvent.cmake
 create mode 100644 build/FindTraceFS.cmake

diff --git a/CMakeLists.txt b/CMakeLists.txt
index e730398..007f46a 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -22,6 +22,11 @@ if (NOT _LIBDIR)
 endif (NOT _LIBDIR)
 
 include(${KS_DIR}/build/FindTraceCmd.cmake)
+
+set(CMAKE_MODULE_PATH "${KS_DIR}/build")
+find_package(TraceEvent REQUIRED)
+find_package(TraceFS    REQUIRED)
+
 include(${KS_DIR}/build/FindJSONC.cmake)
 
 find_package(Doxygen)
@@ -80,8 +85,7 @@ endif (CMAKE_BUILD_TYPE MATCHES Package)
 include_directories(${KS_DIR}/src/
                     ${KS_DIR}/build/src/
                     ${JSONC_INCLUDE_DIR}
-                    ${TRACECMD_INCLUDE_DIR}
-                    ${TRACEFS_INCLUDE_DIR})
+                    ${TRACECMD_INCLUDE_DIR})
 
 message("")
 message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
diff --git a/build/FindTraceCmd.cmake b/build/FindTraceCmd.cmake
index 02f4529..5df2789 100644
--- a/build/FindTraceCmd.cmake
+++ b/build/FindTraceCmd.cmake
@@ -32,30 +32,15 @@ find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
                                 PATHS  $ENV{TRACE_CMD}/include/
                                 NO_DEFAULT_PATH)
 
-find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h
-                                PATHS  $ENV{TRACE_CMD}/include/
-                                NO_DEFAULT_PATH)
-
 find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.a
                                 PATHS  $ENV{TRACE_CMD}/lib/
                                 NO_DEFAULT_PATH)
 
-find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.a
-                                PATHS  $ENV{TRACE_CMD}/lib/
-                                NO_DEFAULT_PATH)
-
-find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
-                                PATHS  $ENV{TRACE_CMD}/lib/
-                                NO_DEFAULT_PATH)
-
 # If not found, search in the default system paths. Note that if the previous
 # search was successful "find_path" will do nothing this time.
-find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd)
-find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h)
-find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h)
-find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.so)
-find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.so)
-find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.so)
+find_program(TRACECMD_EXECUTABLE NAMES  trace-cmd)
+find_path(TRACECMD_INCLUDE_DIR   NAMES  trace-cmd/trace-cmd.h)
+find_library(TRACECMD_LIBRARY    NAMES  trace-cmd/libtracecmd.so)
 
 IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
 
@@ -72,35 +57,3 @@ ELSE (TRACECMD_FOUND)
   MESSAGE(FATAL_ERROR "\nCould not find trace-cmd!\n")
 
 ENDIF (TRACECMD_FOUND)
-
-IF (TRACEFS_INCLUDE_DIR AND TRACEFS_LIBRARY)
-
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
diff --git a/build/FindTraceEvent.cmake b/build/FindTraceEvent.cmake
new file mode 100644
index 0000000..8525697
--- /dev/null
+++ b/build/FindTraceEvent.cmake
@@ -0,0 +1,75 @@
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
index 0000000..982a61d
--- /dev/null
+++ b/build/FindTraceFS.cmake
@@ -0,0 +1,75 @@
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
index 457c100..7474e9d 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -8,8 +8,8 @@ add_library(kshark SHARED libkshark.c
                           libkshark-collection.c)
 
 target_link_libraries(kshark ${TRACECMD_LIBRARY}
-                             ${TRACEFS_LIBRARY}
-                             ${TRACEEVENT_LIBRARY}
+                             trace::fs
+                             trace::event
                              ${JSONC_LIBRARY}
                              ${CMAKE_DL_LIBS})
 
diff --git a/src/libkshark.c b/src/libkshark.c
index 52aacd3..a14d3c5 100644
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
-- 
2.25.1

