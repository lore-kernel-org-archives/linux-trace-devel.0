Return-Path: <SRS0=Pjg+=SU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63169C10F14
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3366420821
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731317AbfDRPWt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 11:22:49 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:46542 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389038AbfDRPWs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 11:22:48 -0400
Received: by mail-wr1-f53.google.com with SMTP id t17so3414840wrw.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Apr 2019 08:22:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y+mZou+iV60esjuLtX9pEpF4V+vOVjNaOTHcJwHzxf8=;
        b=V8aVSeTpSSLk40H0tAuysoeX/lbwNOglzvv/PcBX8wBjqbIrYGaar3W661LVHtQwHF
         KJXjbH209ToAB88XUFIbtEibJYew6fxJz+O1408NiFSPoG61Y1scGcHcgjUACNQwjCE0
         cPvnJg06CHCC9v2507ra2ZaXSUtfxrMZ7wsibPkMKl+TIhgzcdVjhxMOzgo3nrOFqAwc
         Rkh1IFhJn5S8mWDDCzxTMKiOWqTDESK5ssG6tiaes1WK8Ov3n6kaT2jYh65sd4z3UoTA
         iLk2ibv7qX+RwfJ3XZlc63YtXuCq7vlE2cvQwU3/iedrlorqWeQJwDG4BNzNCipppiBZ
         1HrQ==
X-Gm-Message-State: APjAAAVjJ4/Zq9I2r0pRXYayhxj/3Fooda5ADVXdBiQghNAvkSd3PKw5
        MHHVrJL1JWLhDDZB4qRRo9e+N06h
X-Google-Smtp-Source: APXvYqyMCobdPG8OjxyM+Cs7IKZQNU75l2rJBZF7es6dCRDONXgeSJ5BXJ5RKpVKe9uE4Z4bQjFEFw==
X-Received: by 2002:adf:db05:: with SMTP id s5mr64128000wri.247.1555600966603;
        Thu, 18 Apr 2019 08:22:46 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l12sm2543698wrt.31.2019.04.18.08.22.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 08:22:46 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 5/8] kernel-shark: Rename KS_DIR to KS_SOURCE_DIR
Date:   Thu, 18 Apr 2019 18:21:43 +0300
Message-Id: <20190418152146.27232-6-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190418152146.27232-1-ykaradzhov@vmware.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

KS_SOURCE_DIR is a more appropriate name since it defines the path to
the KernelShark source code used to build the application.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt     | 32 ++++++++++++++++----------------
 kernel-shark/build/deff.h.cmake |  2 +-
 kernel-shark/src/CMakeLists.txt | 10 +++++-----
 kernel-shark/src/KsUtils.cpp    |  4 ++--
 kernel-shark/src/KsUtils.hpp    |  2 +-
 5 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 1aee858..825cabd 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -10,10 +10,10 @@ set(KS_VERSION_PATCH 8)
 set(KS_VERSION_STRING ${KS_VERSION_MAJOR}.${KS_VERSION_MINOR}.${KS_VERSION_PATCH})
 message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
 
-set(KS_DIR ${CMAKE_SOURCE_DIR})
+set(KS_SOURCE_DIR ${CMAKE_SOURCE_DIR})
 
-include(${KS_DIR}/build/FindTraceCmd.cmake)
-include(${KS_DIR}/build/FindJSONC.cmake)
+include(${KS_SOURCE_DIR}/build/FindTraceCmd.cmake)
+include(${KS_SOURCE_DIR}/build/FindJSONC.cmake)
 
 find_package(Doxygen)
 
@@ -29,8 +29,8 @@ if (Qt5Widgets_FOUND)
 
 endif (Qt5Widgets_FOUND)
 
-set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
-set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
+set(LIBRARY_OUTPUT_PATH    "${KS_SOURCE_DIR}/lib")
+set(EXECUTABLE_OUTPUT_PATH "${KS_SOURCE_DIR}/bin")
 
 set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -g -pthread")
 set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -std=c++11 -pthread")
@@ -49,8 +49,8 @@ endif (NOT _DEBUG)
 SET(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/kshark/")
 SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
 
-include_directories(${KS_DIR}/src/
-                    ${KS_DIR}/build/src/
+include_directories(${KS_SOURCE_DIR}/src/
+                    ${KS_SOURCE_DIR}/build/src/
                     ${JSONC_INCLUDE_DIR}
                     ${TRACECMD_INCLUDE_DIR}
                     ${TRACEEVENT_INCLUDE_DIR})
@@ -60,8 +60,8 @@ message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
 message(STATUS "CXX flags    : " ${CMAKE_CXX_FLAGS})
 message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
 
-add_subdirectory(${KS_DIR}/src)
-add_subdirectory(${KS_DIR}/examples)
+add_subdirectory(${KS_SOURCE_DIR}/src)
+add_subdirectory(${KS_SOURCE_DIR}/examples)
 
 if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
 
@@ -72,16 +72,16 @@ if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
                        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/doc)
 
     set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES
-                                          "${KS_DIR}/doc/dox_build.log"
-                                          "${KS_DIR}/doc/html"
-                                          "${KS_DIR}/doc/latex")
+                                          "${KS_SOURCE_DIR}/doc/dox_build.log"
+                                          "${KS_SOURCE_DIR}/doc/html"
+                                          "${KS_SOURCE_DIR}/doc/latex")
 
 endif ()
 
-configure_file( ${KS_DIR}/build/ks.desktop.cmake
-                ${KS_DIR}/kernelshark.desktop)
+configure_file(${KS_SOURCE_DIR}/build/ks.desktop.cmake
+               ${KS_SOURCE_DIR}/kernelshark.desktop)
 
-configure_file( ${KS_DIR}/build/org.freedesktop.kshark-record.policy.cmake
-                ${KS_DIR}/org.freedesktop.kshark-record.policy)
+configure_file(${KS_SOURCE_DIR}/build/org.freedesktop.kshark-record.policy.cmake
+               ${KS_SOURCE_DIR}/org.freedesktop.kshark-record.policy)
 
 message("")
diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
index ba211f4..47c9d9f 100644
--- a/kernel-shark/build/deff.h.cmake
+++ b/kernel-shark/build/deff.h.cmake
@@ -12,7 +12,7 @@
 #cmakedefine KS_VERSION_STRING "@KS_VERSION_STRING@"
 
 /** KernelShark source code path. */
-#cmakedefine KS_DIR "@KS_DIR@"
+#cmakedefine KS_SOURCE_DIR "@KS_SOURCE_DIR@"
 
 /** KernelShark installation prefix path. */
 #cmakedefine _INSTALL_PREFIX "@_INSTALL_PREFIX@"
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index b7dbd7e..5f97916 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -81,13 +81,13 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
             RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
             LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/kshark/)
 
-    install(FILES "${KS_DIR}/kernelshark.desktop"
+    install(FILES "${KS_SOURCE_DIR}/kernelshark.desktop"
             DESTINATION /usr/share/applications/)
 
-    install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
+    install(FILES "${KS_SOURCE_DIR}/org.freedesktop.kshark-record.policy"
             DESTINATION /usr/share/polkit-1/actions/)
 
-    install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
+    install(PROGRAMS "${KS_SOURCE_DIR}/bin/kshark-su-record"
             DESTINATION ${_INSTALL_PREFIX}/bin/)
 
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
@@ -96,5 +96,5 @@ add_subdirectory(plugins)
 
 find_program(DO_AS_ROOT pkexec)
 
-configure_file( ${KS_DIR}/build/deff.h.cmake
-                ${KS_DIR}/src/KsCmakeDef.hpp)
+configure_file( ${KS_SOURCE_DIR}/build/deff.h.cmake
+                ${KS_SOURCE_DIR}/src/KsCmakeDef.hpp)
diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index b05c0dc..387a1e0 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -491,9 +491,9 @@ char *KsPluginManager::_pluginLibFromName(const QString &plugin, int &n)
 	std::string pluginStr = plugin.toStdString();
 	char *lib;
 
-	if (path.contains(KS_DIR)) {
+	if (path.contains(KS_SOURCE_DIR)) {
 		n = asprintf(&lib, "%s/lib/plugin-%s.so",
-			     KS_DIR, pluginStr.c_str());
+			     KS_SOURCE_DIR, pluginStr.c_str());
 	} else {
 		n = asprintf(&lib, "%s/lib/kshark/plugins/plugin-%s.so",
 			     _INSTALL_PREFIX, pluginStr.c_str());
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index 85da9ae..e776d62 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -123,7 +123,7 @@ inline QString dialogDir()
 {
 	QString path = QCoreApplication::applicationFilePath();
 
-	return (path.contains(KS_DIR)) ? KS_DIR : QDir::homePath();
+	return path.contains(KS_SOURCE_DIR) ? KS_SOURCE_DIR : QDir::homePath();
 }
 
 }; // KsUtils
-- 
2.19.1

