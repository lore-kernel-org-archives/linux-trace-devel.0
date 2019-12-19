Return-Path: <SRS0=Ara6=2J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 617CCC43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 11:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DD222465E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 11:35:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nms513hK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfLSLfM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 06:35:12 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46858 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbfLSLfL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 06:35:11 -0500
Received: by mail-lj1-f196.google.com with SMTP id m26so3413769ljc.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Dec 2019 03:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p4M6pzPkOnzd8tSwcIWsxGrGVYgOdcLgm9q4Bb0pokU=;
        b=Nms513hKhQngwNjVQ1olpFTsM803SvXnzW67OWFbPZJ3vaMvUtvNozmdHykCUKigol
         q1/iWln/uw9sjYmOv+Dlk0d+XfiGowRKIb1oEshceSwjPXGdAVU/fIV3Hq4AUWWhUrOr
         zHCxzyJjncYl1J+CsU99RE5RlqTJ2rPykf/SH1JLbqzL3Ox3eNVqaOYRJA1FRqQr58OO
         mNqVl44Ya36Ga7MkIq2lYmh6ab8IAxUg0ZRIr4Lhd4qp4lXZY2g4qf/rKedD1moJ9I/c
         7pkh7BZ+jajBMa7LBcjXv2wajYdAiypMnYWKuRQpoG+E5zFEmfYQMLQdHDxDAc0Wh8J6
         6Giw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p4M6pzPkOnzd8tSwcIWsxGrGVYgOdcLgm9q4Bb0pokU=;
        b=kCyEP0TSx1F+jOWt143fig7Tk3AIv8q+lEW/gcHQeWz9VnwmIprgbp1PHQKBjChMjA
         O928Vxix3YkLqD9jjJmbFkv+yV9uXA1rO1QRKfB+z10hJnqCBhK6tMRU9EeLo3mfEXSo
         0leI9aurLNXccKWRHkpbruRWRLaZIMQC6I3c83OG4uOBkr/teIMShc/u0gcsb6WIG7u9
         aBDt5U5khk+bKvYwWsmDTYTYTqLk3Zm0UEUUMF1lOZ2u+TMhY/3Bo9rmuTvKMJZUDhV6
         Xm3Y4K3fbbZxjrwIe1LKMkG4H4fGTJbKnTVK8a6XRtHFHvq8dGfB5ewnsZ/oZWqzaGNK
         qZrQ==
X-Gm-Message-State: APjAAAWLshNMO073ioPb7VscfGtDvDTMdCPU1HMfqXisxkcsota9+w2N
        UtRgdO6xo64XFTT8QgGleik=
X-Google-Smtp-Source: APXvYqxoBkSjfXOvgtQDBOxLOwmelpSPzWKvDTwmcgJwu88v4aKv3ZrKYh9n32YBcJJ8nJDNmZ+2IQ==
X-Received: by 2002:a2e:8505:: with SMTP id j5mr5006066lji.235.1576755308945;
        Thu, 19 Dec 2019 03:35:08 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d4sm2437022lfn.42.2019.12.19.03.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 03:35:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/6] kernel-shark: Use new tracefs library
Date:   Thu, 19 Dec 2019 13:34:58 +0200
Message-Id: <20191219113502.28964-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191219113502.28964-1-tz.stoyanov@gmail.com>
References: <20191219113502.28964-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Link libtracefs to kernel-shark and use its API:
  tracefs_get_tracing_dir()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 kernel-shark/CMakeLists.txt           |  3 ++-
 kernel-shark/build/FindTraceCmd.cmake | 30 +++++++++++++++++++++++++++
 kernel-shark/src/CMakeLists.txt       |  2 ++
 kernel-shark/src/KsCaptureDialog.cpp  |  4 ++--
 kernel-shark/src/libkshark.h          |  1 +
 5 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 20478b9..8786b83 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -76,7 +76,8 @@ endif (CMAKE_BUILD_TYPE MATCHES Package)
 include_directories(${KS_DIR}/src/
                     ${KS_DIR}/build/src/
                     ${JSONC_INCLUDE_DIR}
-                    ${TRACECMD_INCLUDE_DIR})
+                    ${TRACECMD_INCLUDE_DIR}
+                    ${TRACEFS_INCLUDE_DIR})
 
 message("")
 message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
index d3e145c..f27fafe 100644
--- a/kernel-shark/build/FindTraceCmd.cmake
+++ b/kernel-shark/build/FindTraceCmd.cmake
@@ -6,6 +6,8 @@
 #  TRACEEVENT_FOUND, If false, do not try to use traceevent.
 #
 #  TRACECMD_INCLUDE_DIR, where to find trace-cmd header.
+#  TRACEFS_INCLUDE_DIR, where to find tracefs header.
+#  TRACEFS_LIBRARY, the tracefs library.
 #  TRACECMD_LIBRARY, the trace-cmd library.
 #  TRACECMD_FOUND, If false, do not try to use trace-cmd.
 
@@ -31,12 +33,21 @@ find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
                                 PATHS  $ENV{TRACE_CMD}/include/
                                        ${CMAKE_SOURCE_DIR}/../include/
                                 NO_DEFAULT_PATH)
+find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h
+                                PATHS  $ENV{TRACE_CMD}/include/
+                                       ${CMAKE_SOURCE_DIR}/../include/
+                                NO_DEFAULT_PATH)
 
 find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.a
                                 PATHS  $ENV{TRACE_CMD}/lib/
                                        ${CMAKE_SOURCE_DIR}/../lib/
                                 NO_DEFAULT_PATH)
 
+find_library(TRACEFS_LIBRARY    NAMES  trace-cmd/libtracefs.a
+                                PATHS  $ENV{TRACE_CMD}/lib/
+                                       ${CMAKE_SOURCE_DIR}/../lib/
+                                NO_DEFAULT_PATH)
+
 find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
                                 PATHS  $ENV{TRACE_CMD}/lib/
                                        ${CMAKE_SOURCE_DIR}/../lib/
@@ -46,7 +57,9 @@ find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.a
 # search was successful "find_path" will do nothing this time.
 find_program(TRACECMD_EXECUTABLE   NAMES  trace-cmd)
 find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h)
+find_path(TRACEFS_INCLUDE_DIR   NAMES  tracefs/tracefs.h)
 find_library(TRACECMD_LIBRARY   NAMES  trace-cmd/libtracecmd.so)
+find_library(TRACEFS_LIBRARY    NAMES  tracefs/libtracefs.so)
 find_library(TRACEEVENT_LIBRARY NAMES  traceevent/libtraceevent.so)
 
 IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY)
@@ -65,6 +78,23 @@ ELSE (TRACECMD_FOUND)
 
 ENDIF (TRACECMD_FOUND)
 
+IF (TRACEFS_INCLUDE_DIR AND TRACEFS_LIBRARY)
+
+  SET(TRACEFS_FOUND TRUE)
+
+ENDIF (TRACEFS_INCLUDE_DIR AND TRACEFS_LIBRARY)
+
+IF (TRACEFS_FOUND)
+
+  MESSAGE(STATUS "Found tracefs: ${TRACEFS_LIBRARY}")
+
+ELSE (TRACEFS_FOUND)
+
+  MESSAGE(FATAL_ERROR "\nCould not find tracefs!\n")
+
+ENDIF (TRACEFS_FOUND)
+
+
 IF (TRACEEVENT_LIBRARY)
 
   SET(TRACEEVENT_FOUND TRUE)
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index e20a030..33b5db8 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -9,6 +9,7 @@ add_library(kshark SHARED libkshark.c
 
 target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
                              ${TRACECMD_LIBRARY}
+                             ${TRACEFS_LIBRARY}
                              ${JSONC_LIBRARY}
                              ${CMAKE_DL_LIBS})
 
@@ -69,6 +70,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
                                      Qt5::Network
                                      ${TRACEEVENT_LIBRARY}
                                      ${TRACECMD_LIBRARY}
+                                     ${TRACEFS_LIBRARY}
                                      ${CMAKE_DL_LIBS})
 
     set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index ad05917..548b6fb 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -26,7 +26,7 @@ extern "C" {
 
 static inline tep_handle *local_events()
 {
-	return tracecmd_local_events(tracecmd_get_tracing_dir());
+	return tracecmd_local_events(tracefs_get_tracing_dir());
 }
 
 /**
@@ -204,7 +204,7 @@ QStringList KsCaptureControl::_getPlugins()
 	QStringList pluginList;
 	char **all_plugins;
 
-	all_plugins = tracecmd_local_plugins(tracecmd_get_tracing_dir());
+	all_plugins = tracecmd_local_plugins(tracefs_get_tracing_dir());
 
 	if (!all_plugins)
 		return pluginList;
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
index 3407db1..b05aa90 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -28,6 +28,7 @@ extern "C" {
 #include "trace-cmd/trace-cmd.h"
 #include "trace-cmd/trace-filter-hash.h"
 #include "traceevent/event-parse.h"
+#include "tracefs/tracefs.h"
 
 // KernelShark
 #include "libkshark-plugin.h"
-- 
2.23.0

