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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B089C4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 16:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 570942246B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 16:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437937AbgLKP2J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392552AbgLKPJb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:09:31 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EFFC0617A6
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:16 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id a12so9362039wrv.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I0NmFYspL0nWDyoDHbxV8zk5GA140LeU8XNBINoc6GA=;
        b=XEn06CScHSkYkbhJCD+r8rXgp3pfyma9qV7hZQOHRjFP2N1fcZQh3Ok80Tt4hp69AP
         RqVt35wv4GHbLQT2AbxiNXyEyLDKsJvbg2XR49JTj8vz6k8b4tYTFkYafzpFhw3pegc5
         z5Z1K9Lcyei3nI8NahaL9Wr8fEcb/nJWCoSlW7rlbSt0l7SBQQPwYJGkp/BYns+0c0S0
         7bBfOPKNtlkv0yO1CaHstNu1PUc2vSTpHLTrIZrn+S3hqEuotuQ9xdrB1vjzGCbpSHd+
         LeLvdattimtynOWcmf8eVUqQAPwpqDewU95g2WKJ/I/l8Eosg1noyedvIYXsKBOtPYnO
         jPbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I0NmFYspL0nWDyoDHbxV8zk5GA140LeU8XNBINoc6GA=;
        b=ZnW6/Vtxe/PSnoUyK8ezDPc6tDQkBnhpdi/BuGuDqldZlmQfVR7NEJE2khTV/MakvH
         CyOhMWc6PBerDGVv8b+oxwc6xnZchUqmwtWh2a1V0uZE7e58/KCnOzO8fWoVHa5ztsW7
         jTZiT4Pijgqj0uK95j22W0SW6KqYp75ScpX+QkkqGn4A+a1er8XXVjfmAiJdvapFyZ1+
         uAm/jYgtQNG9cX+23qARV1sR6q1KzONuIDROZzjno2uC/ahNhtwbo+oyZ5cWaEw2iAiD
         /K2ClDovfGZeiCz8CZbShb/jDPtTI6IZLXT7D4cG966a3vhBDQpqQ3VweH8NuASfvhgL
         Z6sw==
X-Gm-Message-State: AOAM531Kf+K64SIPiu5rGUkqsweMgYDiu5+zHe9ITzrFPivf1kukgoHA
        8dPJrRZx7z0qR/SPF23wHD0=
X-Google-Smtp-Source: ABdhPJyjxxnTeP7EWIA5V6+gfDD3UVPESAbw0ECBAzXmZQt4zAbviljXuEZ/FRs83AoODDgbV1Lw1A==
X-Received: by 2002:adf:efc5:: with SMTP id i5mr14176815wrp.377.1607699295507;
        Fri, 11 Dec 2020 07:08:15 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:14 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 05/32] kernel-shark: Define build target for JSONC
Date:   Fri, 11 Dec 2020 17:07:29 +0200
Message-Id: <20201211150756.577366-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
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
 CMakeLists.txt        |  4 +--
 build/FindJSONC.cmake | 70 +++++++++++++++++++++++++++++++++----------
 src/CMakeLists.txt    |  2 +-
 3 files changed, 57 insertions(+), 19 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 007f46a..a66050f 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -26,8 +26,7 @@ include(${KS_DIR}/build/FindTraceCmd.cmake)
 set(CMAKE_MODULE_PATH "${KS_DIR}/build")
 find_package(TraceEvent REQUIRED)
 find_package(TraceFS    REQUIRED)
-
-include(${KS_DIR}/build/FindJSONC.cmake)
+find_package(JSONC      REQUIRED)
 
 find_package(Doxygen)
 
@@ -84,7 +83,6 @@ endif (CMAKE_BUILD_TYPE MATCHES Package)
 
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
index 7474e9d..213ce87 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -10,7 +10,7 @@ add_library(kshark SHARED libkshark.c
 target_link_libraries(kshark ${TRACECMD_LIBRARY}
                              trace::fs
                              trace::event
-                             ${JSONC_LIBRARY}
+                             jsonc::jsonc
                              ${CMAKE_DL_LIBS})
 
 set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
-- 
2.25.1

