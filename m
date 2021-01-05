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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4822C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 15:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A16E422BEF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 15:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbhAEPzs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Jan 2021 10:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbhAEPzs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Jan 2021 10:55:48 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BBBC061793
        for <linux-trace-devel@vger.kernel.org>; Tue,  5 Jan 2021 07:55:07 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id u19so663964edx.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Jan 2021 07:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IHaPZ/qiEW3SYewlPRXrjIxIYrH5KJu/4mgTm5/ZJWA=;
        b=diuTCpDngfavCIiBGCWTKUB6Tw8HNxBvg0HWQJn9FK/Oyh8At5x+Nm6Ub3dVIcsK8Z
         xWblQHQobYUMPiQsU32lG5sX+sznT/WIb1opp40qM+A4A+msITK5yUczDBUnXA4sBLud
         Dn9D7TSw5uGKU2aC/3DsNxTmaGRBPzl1D7Zfh9dtBrnWgBl7AEk718+GicR6wBJDjKbw
         owL5vOIgJkEO+9eTvp5Jff6urX43Xti7CztHnd+Lhfmbd6BIDQ3YiXCMW2P6SEIjkL3y
         a4EA6qx3E/9p0gAohF/nCkZ5FPEnVNPDJDIchalghSqqrB6WquvACdFBsEmeeMWJGq8c
         SRSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IHaPZ/qiEW3SYewlPRXrjIxIYrH5KJu/4mgTm5/ZJWA=;
        b=WJT2xNAB6sqfljN3BiWB0gnz+y+0XVRYhjSG5ZHi8/5/7FJxN/GZFWjCH97gEwsWhD
         RvSieOPgaHZsQ6aoEzE81ytuA34M9lJIZULKQoD04FE4RToXfp+G0spQTS4EGUX1A2HO
         g56Po/B2zynRAckmgRLDy/EQHAZg6s9nv/0d6Lg/OSKZy7Yd+8FX2gcHLxcImHphMF0K
         vvsd0ErWn9jpfmfqS0LVVTRUjhm8DyFLa7MZ4Dkhrx81CPB4pAGSSirXYA46JFCksnvE
         PxuYKYpADc+KxHxLpg48ri3i248TCfz+X5rsLsYpmxIyOzjRjqgAh1PsW7dDhkKqjBVD
         uOsQ==
X-Gm-Message-State: AOAM531U+ptgVzxcv/V3I2GrpuBsiO5+TLfOSHMPyQurvdjOYV5yjTIS
        cia1d4rHHBwVlfeo/cmRLHdJSAguJpRHhQ==
X-Google-Smtp-Source: ABdhPJx/uPmYPR43Kac3QyJqcS4GNeGOoJM6lJVj8t98xeftEvKlutc31M9FbRmfdHF/RFj38LVP8A==
X-Received: by 2002:a50:f392:: with SMTP id g18mr392341edm.306.1609862106188;
        Tue, 05 Jan 2021 07:55:06 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id t12sm45367882edy.49.2021.01.05.07.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 07:55:05 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/5] kernel-shark: Start using libtracecmd
Date:   Tue,  5 Jan 2021 17:54:49 +0200
Message-Id: <20210105155453.41228-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210105155453.41228-1-y.karadz@gmail.com>
References: <20210105155453.41228-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

libtracecmd is now a stand-alone libraries, similar to libtraceevent
and libtracefs. Start building and linking KernelShark against this
independent library.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt             |   4 +-
 build/FindTraceCmd.cmake   | 101 ++++++++++++++++++++++---------------
 build/FindTraceEvent.cmake |   1 -
 build/FindTraceFS.cmake    |   1 -
 src/CMakeLists.txt         |   2 +-
 src/libkshark-tepdata.c    |  18 +++----
 6 files changed, 72 insertions(+), 55 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 303e47e..59bbe72 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -21,11 +21,11 @@ if (NOT _LIBDIR)
     set(_LIBDIR "${_INSTALL_PREFIX}/lib")
 endif (NOT _LIBDIR)
 
-include(${KS_DIR}/build/FindTraceCmd.cmake)
-
 set(CMAKE_MODULE_PATH "${KS_DIR}/build")
 find_package(TraceEvent REQUIRED)
 find_package(TraceFS    REQUIRED)
+find_package(TraceCmd   REQUIRED)
+
 find_package(JSONC      REQUIRED)
 
 find_package(Doxygen)
diff --git a/build/FindTraceCmd.cmake b/build/FindTraceCmd.cmake
index 5df2789..23eefed 100644
--- a/build/FindTraceCmd.cmake
+++ b/build/FindTraceCmd.cmake
@@ -1,59 +1,78 @@
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
 
-find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.a
-                                PATHS  $ENV{TRACE_CMD}/lib/
-                                NO_DEFAULT_PATH)
+``TraceCmd_INCLUDE_DIR``
+  The directory containing ``trace-cmd.h``.
+``TraceCmd_LIBRARY``
+  The path to the tracecmd library.
 
-# If not found, search in the default system paths. Note that if the previous
-# search was successful "find_path" will do nothing this time.
-find_program(TRACECMD_EXECUTABLE NAMES  trace-cmd)
-find_path(TRACECMD_INCLUDE_DIR   NAMES  trace-cmd/trace-cmd.h)
-find_library(TRACECMD_LIBRARY    NAMES  trace-cmd/libtracecmd.so)
+#]=======================================================================]
 
-IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
+find_package(PkgConfig QUIET)
+pkg_check_modules(PC_TraceCmd QUIET libtracecmd)
 
-  SET(TRACECMD_FOUND TRUE)
+set(TraceCmd_VERSION     ${PC_TraceCmd_VERSION})
+set(TraceCmd_DEFINITIONS ${PC_TraceCmd_CFLAGS_OTHER})
 
-ENDIF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
+find_path(TraceCmd_INCLUDE_DIR NAMES trace-cmd/trace-cmd.h
+                               HINTS ${PC_TraceCmd_INCLUDE_DIRS}
+                                     ${PC_TraceCmd_INCLUDEDIR})
 
-IF (TRACECMD_FOUND)
+find_library(TraceCmd_LIBRARY  NAMES tracecmd libtracecmd
+                               HINTS ${PC_TraceCmd_LIBDIR}
+                                     ${PC_TraceCmdLIBRARY_DIRS})
 
-  MESSAGE(STATUS "Found trace-cmd: ${TRACECMD_LIBRARY}")
+mark_as_advanced(TraceCmd_INCLUDE_DIR TraceCmd_LIBRARY)
 
-ELSE (TRACECMD_FOUND)
+include(FindPackageHandleStandardArgs)
 
-  MESSAGE(FATAL_ERROR "\nCould not find trace-cmd!\n")
+find_package_handle_standard_args(TraceCmd DEFAULT_MSG
+                                  TraceCmd_LIBRARY TraceCmd_INCLUDE_DIR)
 
-ENDIF (TRACECMD_FOUND)
+if(TraceCmd_FOUND)
+
+  set(TraceCmd_LIBRARIES    ${TraceCmd_LIBRARY})
+  set(TraceCmd_INCLUDE_DIRS ${TraceCmd_INCLUDE_DIR})
+
+  if(NOT TARGET trace::cmd)
+    add_library(trace::cmd UNKNOWN IMPORTED)
+
+    set_target_properties(trace::cmd
+                          PROPERTIES
+                            INTERFACE_INCLUDE_DIRECTORIES "${TraceCmd_INCLUDE_DIRS}"
+                            INTERFACE_COMPILE_DEFINITIONS "${TraceCmd_DEFINITIONS}"
+                            IMPORTED_LINK_INTERFACE_LANGUAGES "C"
+                            IMPORTED_LOCATION "${TraceCmd_LIBRARIES}")
+  endif()
+
+endif()
+
+find_program(TRACECMD_EXECUTABLE NAMES trace-cmd)
diff --git a/build/FindTraceEvent.cmake b/build/FindTraceEvent.cmake
index 8525697..f3feca9 100644
--- a/build/FindTraceEvent.cmake
+++ b/build/FindTraceEvent.cmake
@@ -1,4 +1,3 @@
-
 #[=======================================================================[.rst:
 FindTraceevent
 -------
diff --git a/build/FindTraceFS.cmake b/build/FindTraceFS.cmake
index 982a61d..2a5f7bd 100644
--- a/build/FindTraceFS.cmake
+++ b/build/FindTraceFS.cmake
@@ -1,4 +1,3 @@
-
 #[=======================================================================[.rst:
 FindTraceFS
 -------
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 285f88a..b393468 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -9,7 +9,7 @@ add_library(kshark SHARED libkshark.c
                           libkshark-configio.c
                           libkshark-collection.c)
 
-target_link_libraries(kshark ${TRACECMD_LIBRARY}
+target_link_libraries(kshark trace::cmd
                              trace::fs
                              trace::event
                              jsonc::jsonc
diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index a82f5c5..724cff2 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -277,7 +277,7 @@ static void free_rec_list(struct rec_list **rec_list, int n_cpus,
 			temp_rec = rec_list[cpu];
 			rec_list[cpu] = temp_rec->next;
 			if (type == REC_RECORD)
-				free_record(temp_rec->rec);
+				tracecmd_free_record(temp_rec->rec);
 			free(temp_rec);
 		}
 	}
@@ -379,7 +379,7 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
 				    tep_filter_match(adv_filter, rec) != FILTER_MATCH)
 					unset_event_filter_flag(kshark_ctx, entry);
 
-				free_record(rec);
+				tracecmd_free_record(rec);
 				break;
 			} /* REC_ENTRY */
 			}
@@ -571,7 +571,7 @@ static ssize_t tepdata_load_matrix(struct kshark_data_stream *stream,
  *
  * @param kshark_ctx: Input location for the session context pointer.
  * @param sd: Data stream identifier.
- * @param data_rows: Output location for the trace data. Use free_record()
+ * @param data_rows: Output location for the trace data. Use tracecmd_free_record()
  *	 	     to free the elements of the outputted array.
  *
  * @returns The size of the outputted data in the case of success, or a
@@ -657,7 +657,7 @@ static const int tepdata_get_event_id(struct kshark_data_stream *stream,
 		if (record)
 			event_id = tep_data_type(kshark_get_tep(stream), record);
 
-		free_record(record);
+		tracecmd_free_record(record);
 
 		pthread_mutex_unlock(&stream->input_mutex);
 	}
@@ -749,7 +749,7 @@ static const int tepdata_get_pid(struct kshark_data_stream *stream,
 		if (record)
 			pid = tep_data_pid(kshark_get_tep(stream), record);
 
-		free_record(record);
+		tracecmd_free_record(record);
 
 		pthread_mutex_unlock(&stream->input_mutex);
 	}
@@ -798,7 +798,7 @@ static char *tepdata_get_latency(struct kshark_data_stream *stream,
 	tep_print_event(kshark_get_tep(stream), &seq, record,
 			"%s", TEP_PRINT_LATENCY);
 
-	free_record(record);
+	tracecmd_free_record(record);
 
 	pthread_mutex_unlock(&stream->input_mutex);
 
@@ -869,7 +869,7 @@ static char *tepdata_get_info(struct kshark_data_stream *stream,
 	if (event)
 		info = get_info_str(stream, record, event);
 
-	free_record(record);
+	tracecmd_free_record(record);
 
 	pthread_mutex_unlock(&stream->input_mutex);
 
@@ -1178,7 +1178,7 @@ int tepdata_read_event_field(struct kshark_data_stream *stream,
 
 	ret = tep_read_number_field(evt_field, record->data,
 				    (unsigned long long *) val);
-	free_record(record);
+	tracecmd_free_record(record);
 
 	return ret;
 }
@@ -1308,7 +1308,7 @@ static int kshark_tep_stream_init(struct kshark_data_stream *stream,
 		goto fail;
 
 	tep_handle->input = input;
-	tep_handle->tep = tracecmd_get_pevent(tep_handle->input);
+	tep_handle->tep = tracecmd_get_tep(tep_handle->input);
 	if (!tep_handle->tep)
 		goto fail;
 
-- 
2.25.1

