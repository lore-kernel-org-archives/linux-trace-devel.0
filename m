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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05290C433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0AF2216C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbhADRs7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbhADRs7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:48:59 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF920C06179F
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:47:45 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id u19so28247584edx.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D3d713R5HfwUlCpz7BWPRY7IZsIzoZ+VHWYRKptPN1c=;
        b=OgUczI2at6KgB/5jPlwUqcccSPCGI3Vyo2XGctwIfTrW1vaetYrwqrmYmtDyEgDte6
         6/vnE9seMwH6d/ZRw4ucgHGozjzYaocB6u2O+wqNehgzrpwA8Ondca9YBdFWVbIpe2C+
         En1NSEKLfVX6wTVN2gV5OniazjaCI47Fgq7iBWcjYEsGJY9OCCm/yeXWe3dZmT/eZ7WJ
         UqXRR7hvwZZ3tbQFBHCR/KeFOqvgNSVSfTnZmXYY9Bog6sD/k0X5hTBgKg624BnzivSG
         VhzbG/8aR6TYssJzV3Eayp8pNvssNfBoXSDtbdo0NC6M7zKoRLgUmw/hHlT1UiUBNuJ1
         2FIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D3d713R5HfwUlCpz7BWPRY7IZsIzoZ+VHWYRKptPN1c=;
        b=sXCAIzVQvESkzsjq1GCaKhD/gsIezUHvw4SY5Va4vYbFrlsWe5Ku1DrofjROrqO7j+
         s4JAc1Pambf+IzHHQ2699cDR8B/0XVRmL6/L+lgjXeXQb1kVhIUtv/dJPfFCXShP4NpT
         /DQ3b+x3o4LTP3nOyNX3UrEx8q3udfVqYDEIZNVB2Cw7ODdaaKedYqoGIw2dYLtwMr7Z
         dpT8X7kXdCVtw3kuCFtTllVIlGQyMhFjKJ2XTSLHa1MQxGlzIERwt4wabBands4SY6IC
         l7HaSNBP2meRPXysXm6kTYH/qEGBBGU2SWffvQmw/Au9XUEc//XukQrT58eIKLSHzlyI
         E+Rw==
X-Gm-Message-State: AOAM531XGM9XyuqxSvSYleeLzYn4QIFpHWLaF0Bry3p3AMmoMIJ2bbG3
        Hom4wuIqkLF3rkyG3VHo36EaEqhumuthcA==
X-Google-Smtp-Source: ABdhPJws58ArGKZliPzk1tiDhxMMOTokBT/KZfMVRdgo9fHPkrtGHamDaHlsQPoDzVcLcgP0lQRQmQ==
X-Received: by 2002:a05:6402:22e1:: with SMTP id dn1mr73299294edb.347.1609782464517;
        Mon, 04 Jan 2021 09:47:44 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:47:43 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 08/44] kernel-shark: Define build target for JSONC
Date:   Mon,  4 Jan 2021 19:46:48 +0200
Message-Id: <20210104174724.70404-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Having the JSONC libs as a target simplifies the build/linking of
the KernelShark libraries and executables because all necessary
information, like include paths, compiler flags and library names
can be retriever directly from the target.

The patch also adds to FindJSONC.cmake the standard module
documentation header.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt        |  3 +-
 build/FindJSONC.cmake | 70 +++++++++++++++++++++++++++++++++----------
 src/CMakeLists.txt    |  2 +-
 3 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 2e970c3..f21d734 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -41,7 +41,7 @@ find_package(TraceEvent REQUIRED)
 find_package(TraceFS    REQUIRED)
 find_package(TraceCmd   REQUIRED)
 
-include(${KS_DIR}/build/FindJSONC.cmake)
+find_package(JSONC      REQUIRED)
 
 find_package(Doxygen)
 
@@ -99,7 +99,6 @@ endif (CMAKE_BUILD_TYPE MATCHES Package)
 
 include_directories(${KS_DIR}/src/
                     ${KS_DIR}/build/src/
-                    ${JSONC_INCLUDE_DIR}
                     ${TRACECMD_INCLUDE_DIR})
 
 message("")
diff --git a/build/FindJSONC.cmake b/build/FindJSONC.cmake
index 3bae20f..2d0d41f 100644
--- a/build/FindJSONC.cmake
+++ b/build/FindJSONC.cmake
@@ -1,13 +1,44 @@
-# - Try to find json-c
-# https://cmake.org/Wiki/CMake:How_To_Find_Libraries
-# Once done this will define
-#  JSONC_FOUND - System has json-c
-#  JSONC_INCLUDE_DIRS - The json-c include directories
-#  JSONC_LIBRARIES - The libraries needed to use json-c
-#  JSONC_DEFINITIONS - Compiler switches required for using json-c
-
-find_package(PkgConfig)
+
+#[=======================================================================[.rst:
+FindJSONC
+-------
+
+Finds the traceevent library.
+
+Imported Targets
+^^^^^^^^^^^^^^^^
+
+This module defines the :prop_tgt:`IMPORTED` targets:
+
+``jsonc::jsonc``
+ Defined if the system has json-c.
+
+Result Variables
+^^^^^^^^^^^^^^^^
+
+``JSONC_FOUND``
+  True if the system has the json-c library.
+``JSONC_VERSION``
+  The version of the json-c library which was found.
+``JSONC_INCLUDE_DIRS``
+  Include directories needed to use json-c.
+``JSONC_LIBRARIES``
+  Libraries needed to link to json-c.
+
+Cache Variables
+^^^^^^^^^^^^^^^
+
+``JSONC_INCLUDE_DIR``
+  The directory containing ``json.h``.
+``JSONC_LIBRARY``
+  The path to the traceevent library.
+
+#]=======================================================================]
+
+find_package(PkgConfig QUIET)
 pkg_check_modules(PC_JSONC QUIET json-c)
+
+set(JSONC_VERSION     ${PC_JSONC_VERSION})
 set(JSONC_DEFINITIONS ${PC_JSONC_CFLAGS_OTHER})
 
 find_path(JSONC_INCLUDE_DIR json.h
@@ -20,19 +51,28 @@ find_library(JSONC_LIBRARY NAMES json-c libjson-c
 find_library(JSONC_LIBRARY NAMES json-c libjson-c
              HINTS ${PC_JSON-C_LIBDIR} ${PC_JSON-C_LIBRARY_DIRS})
 
+mark_as_advanced(JSONC_INCLUDE_DIR JSONC_LIBRARY)
+
 include(FindPackageHandleStandardArgs)
 # handle the QUIETLY and REQUIRED arguments and set JSONC_FOUND to TRUE
 # if all listed variables are TRUE
 find_package_handle_standard_args(JSONC DEFAULT_MSG
                                   JSONC_LIBRARY JSONC_INCLUDE_DIR)
 
-if (NOT JSONC_FOUND)
+if(JSONC_FOUND)
 
-  message(FATAL_ERROR "Json-C is Required!\n")
+  set(JSONC_LIBRARIES    ${JSONC_LIBRARY})
+  set(JSONC_INCLUDE_DIRS ${JSONC_INCLUDE_DIR})
 
-endif (NOT JSONC_FOUND)
+  if(NOT TARGET jsonc::jsonc)
+    add_library(jsonc::jsonc UNKNOWN IMPORTED)
 
-mark_as_advanced(JSONC_INCLUDE_DIR JSONC_LIBRARY)
+    set_target_properties(jsonc::jsonc
+                          PROPERTIES
+                            INTERFACE_INCLUDE_DIRECTORIES "${JSONC_INCLUDE_DIRS}"
+                            INTERFACE_COMPILE_DEFINITIONS "${JSONC_DEFINITIONS}"
+                            IMPORTED_LINK_INTERFACE_LANGUAGES "C"
+                            IMPORTED_LOCATION "${JSONC_LIBRARIES}")
+  endif()
 
-set(JSONC_LIBRARIES    ${JSONC_LIBRARY})
-set(JSONC_INCLUDE_DIRS ${JSONC_INCLUDE_DIR})
+endif()
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index d51e5ee..ecd448c 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -12,7 +12,7 @@ add_library(kshark SHARED libkshark.c
 target_link_libraries(kshark trace::cmd
                              trace::fs
                              trace::event
-                             ${JSONC_LIBRARY}
+                             jsonc::jsonc
                              ${CMAKE_DL_LIBS})
 
 set_target_properties(kshark  PROPERTIES
-- 
2.25.1

