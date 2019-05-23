Return-Path: <SRS0=hb2W=TX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9944C282DE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EFC520665
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731174AbfEWPSq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 May 2019 11:18:46 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39446 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731168AbfEWPSq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 May 2019 11:18:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id w8so6729308wrl.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 May 2019 08:18:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FamIbrokL55QW90yqmuFSSjrrjfKdFoq1h0zI09ftcc=;
        b=aHshxV/TEm4yirJWVacraHlyINgKLaWPPZ5YHQe/JBnf1lNqKv4/6kzQv409UHvrri
         +B2jkLaOHWzrqc5N/1q0GuOUbytho3sXD+n8yaTizu4rl5kbqK7iftUgtYC634sSQgFO
         mmpGx4oq5Tqzg/UPKQvgqQy5+Eo+TyKqq65JejgOKPnpzLFr4WFLHN9IMZFDss+MhZpp
         qkWmoiEL5xJHAaOc/VnMlR2auAzdx5a9BOqfiUJTW6BFDk59iLmSaqJlSbRa7xO5kboe
         zXA2e3d92kznWBagv0K1xQrFdfP39FTZRjBth7+ZUGtZhhdK8uBHectmAiKTRXosFiIv
         b3cQ==
X-Gm-Message-State: APjAAAVRnISAM+rbHpvv85wW/M2b9WVYpA+c/iqjldlnlDu7hQ5ejtOK
        nDh2U2R+gZa3zWelsEA57L8=
X-Google-Smtp-Source: APXvYqzf/cFFGdJEnw3uUMz7wgawOWkhIwr8rIdGG27eApC+SjRC/pm1DdcS5o19CnCNXA1M+RbOWw==
X-Received: by 2002:a05:6000:47:: with SMTP id k7mr3084675wrx.305.1558624723911;
        Thu, 23 May 2019 08:18:43 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x9sm12687071wmf.27.2019.05.23.08.18.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:18:43 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/5] kernel-shark: Use full paths for non-standard library headers
Date:   Thu, 23 May 2019 18:18:09 +0300
Message-Id: <20190523151812.31391-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523151812.31391-1-ykaradzhov@vmware.com>
References: <20190523151812.31391-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The all header files included in the public interfaces of the trace-cmd
and KernelShark libraries have to use full path when including other
non-standard library headers. This will be useful if someone wants to use
those public interfaces from there installation location.

You may need to clean Cmake's cache after aplaying this patch:

cd kernel-shark/build
./cmake_clean.sh
cmake ..

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 include/trace-cmd/trace-cmd.h         |  2 +-
 include/traceevent/event-parse.h      |  2 +-
 kernel-shark/CMakeLists.txt           |  3 +-
 kernel-shark/build/FindTraceCmd.cmake | 40 ++++++++++++---------------
 kernel-shark/src/libkshark-plugin.h   |  2 +-
 kernel-shark/src/libkshark.h          |  9 +++---
 6 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index ceb03f4..9320098 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -6,7 +6,7 @@
 #ifndef _TRACE_CMD_H
 #define _TRACE_CMD_H
 
-#include "event-parse.h"
+#include "traceevent/event-parse.h"
 
 #define ARRAY_SIZE(_a) (sizeof(_a) / sizeof((_a)[0]))
 #define __weak __attribute__((weak))
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 5e0fd19..65cabd9 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -12,7 +12,7 @@
 #include <regex.h>
 #include <string.h>
 
-#include "trace-seq.h"
+#include "traceevent/trace-seq.h"
 
 #ifndef __maybe_unused
 #define __maybe_unused __attribute__((unused))
diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 52e4a29..145b058 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -56,8 +56,7 @@ SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
 include_directories(${KS_DIR}/src/
                     ${KS_DIR}/build/src/
                     ${JSONC_INCLUDE_DIR}
-                    ${TRACECMD_INCLUDE_DIR}
-                    ${TRACEEVENT_INCLUDE_DIR})
+                    ${TRACECMD_INCLUDE_DIR})
 
 message("")
 message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
diff --git a/kernel-shark/build/FindTraceCmd.cmake b/kernel-shark/build/FindTraceCmd.cmake
index b09a11b..21315e7 100644
--- a/kernel-shark/build/FindTraceCmd.cmake
+++ b/kernel-shark/build/FindTraceCmd.cmake
@@ -2,7 +2,6 @@
 # This module finds an installed trace-cmd package.
 #
 # It sets the following variables:
-#  TRACEEVENT_INCLUDE_DIR, where to find traceevent header.
 #  TRACEEVENT_LIBRARY_DIR , where to find the traceevent library.
 #  TRACEEVENT_LIBRARY, traceevent the library.
 #  TRACEEVENT_FOUND, If false, do not try to use traceevent.
@@ -20,26 +19,32 @@ find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd
                                        ${CMAKE_SOURCE_DIR}/../tracecmd/
                                 NO_DEFAULT_PATH)
 
-find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd.h
-                                PATHS  $ENV{TRACE_CMD}/include/trace-cmd/
-                                       ${CMAKE_SOURCE_DIR}/../include/trace-cmd/
+find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h
+                                PATHS  $ENV{TRACE_CMD}/include/
+                                       ${CMAKE_SOURCE_DIR}/../include/
                                 NO_DEFAULT_PATH)
 
-find_path(TRACECMD_LIBRARY_DIR  NAMES  libtracecmd.a
-                                PATHS  $ENV{TRACE_CMD}/lib/trace-cmd/
-                                       ${CMAKE_SOURCE_DIR}/../lib/trace-cmd/
+find_path(TRACECMD_LIBRARY_DIR  NAMES  trace-cmd/libtracecmd.a
+                                PATHS  $ENV{TRACE_CMD}/lib/
+                                       ${CMAKE_SOURCE_DIR}/../lib/
                                 NO_DEFAULT_PATH)
 
+find_path(TRACEEVENT_LIBRARY_DIR  NAMES  traceevent/libtraceevent.a
+                                  PATHS  $ENV{TRACE_CMD}/lib/
+                                         ${CMAKE_SOURCE_DIR}/../lib/
+                                  NO_DEFAULT_PATH)
+
 # If not found, search in the default system paths. Note that if the previous
 # search was successful "find_path" will do nothing this time.
 find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd)
-find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd.h)
-find_path(TRACECMD_LIBRARY_DIR  NAMES  libtracecmd.a)
+find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd/trace-cmd.h)
+find_library(TRACECMD_LIBRARY_DIR  NAMES  trace-cmd/libtracecmd.a)
+find_library(TRACEEVENT_LIBRARY_DIR  NAMES  traceevent/libtraceevent.a)
 
 IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY_DIR)
 
   SET(TRACECMD_FOUND TRUE)
-  SET(TRACECMD_LIBRARY "${TRACECMD_LIBRARY_DIR}/libtracecmd.a")
+  SET(TRACECMD_LIBRARY "${TRACECMD_LIBRARY_DIR}/trace-cmd/libtracecmd.a")
 
 ENDIF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY_DIR)
 
@@ -53,21 +58,12 @@ ELSE (TRACECMD_FOUND)
 
 ENDIF (TRACECMD_FOUND)
 
-
-find_path(TRACEEVENT_INCLUDE_DIR  NAMES  event-parse.h
-                                  PATHS  $ENV{TRACE_CMD}/include/traceevent/
-                                         ${CMAKE_SOURCE_DIR}/../include/traceevent/)
-
-find_path(TRACEEVENT_LIBRARY_DIR  NAMES  libtraceevent.a
-                                  PATHS  $ENV{TRACE_CMD}/lib/traceevent/
-                                         ${CMAKE_SOURCE_DIR}/../lib/traceevent/)
-
-IF (TRACEEVENT_INCLUDE_DIR AND TRACEEVENT_LIBRARY_DIR)
+IF (TRACEEVENT_LIBRARY_DIR)
 
   SET(TRACEEVENT_FOUND TRUE)
-  SET(TRACEEVENT_LIBRARY "${TRACEEVENT_LIBRARY_DIR}/libtraceevent.a")
+  SET(TRACEEVENT_LIBRARY "${TRACEEVENT_LIBRARY_DIR}/traceevent/libtraceevent.a")
 
-ENDIF (TRACEEVENT_INCLUDE_DIR AND TRACEEVENT_LIBRARY_DIR)
+ENDIF (TRACEEVENT_LIBRARY_DIR)
 
 IF (TRACEEVENT_FOUND)
 
diff --git a/kernel-shark/src/libkshark-plugin.h b/kernel-shark/src/libkshark-plugin.h
index 0cb677a..b3cf1c6 100644
--- a/kernel-shark/src/libkshark-plugin.h
+++ b/kernel-shark/src/libkshark-plugin.h
@@ -17,7 +17,7 @@ extern "C" {
 #endif // __cplusplus
 
 // trace-cmd
-#include "event-parse.h"
+#include "traceevent/event-parse.h"
 
 /* Quiet warnings over documenting simple structures */
 //! @cond Doxygen_Suppress
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
index 92ade41..e4349c3 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -18,17 +18,16 @@
 #include <errno.h>
 
 // Json-C
-#include <json.h>
+#include <json-c/json.h>
 
 #ifdef __cplusplus
 extern "C" {
 #endif
 
 // trace-cmd
-#include "trace-cmd.h"
-#include "trace-filter-hash.h"
-#include "event-parse.h"
-#include "trace-filter-hash.h"
+#include "trace-cmd/trace-cmd.h"
+#include "trace-cmd/trace-filter-hash.h"
+#include "traceevent/event-parse.h"
 
 // KernelShark
 #include "libkshark-plugin.h"
-- 
2.20.1

