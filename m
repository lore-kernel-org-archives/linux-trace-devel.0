Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5ACC282DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E85DE2171F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfDSTeg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 15:34:36 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33223 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbfDSTeg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 15:34:36 -0400
Received: by mail-wm1-f66.google.com with SMTP id z6so9540142wmi.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 12:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AvGVFLM+dfFF/jKTzW+SOqyfsLgBn7rS8Uryt335C7s=;
        b=R7crRJSAS7gthi7r9HNRRzoQYTk+1Vzcju9pQYE/PIFW3DjtefHmHJEJy4fvbLeIGK
         5hayETJ3ZpiZ0rcHyzUOSLuUKl7JhQlgqXDRIKwhbFSBYLk5w4zkmokBY0G0b5WGSON/
         /ftJSG/B8vktRLeF/6xbaCZqLgDquh5v2MrhsiGOW1q4CRGTImXxaps5pfN2PE1cfh3c
         3sJonQzhNFT/cxcuzbjBvNg7LlRle82V1rNV620T2dyzHlJTVTmObrLAmm9L18FGDubX
         QwRmC6jB9Zl/mN8iu+TZJcZ3UGgtUb2kTP4mhGoCXHg99JE4bm/jWK+TaI87qikzPyQB
         bvTQ==
X-Gm-Message-State: APjAAAVxWLvp4/ymhS1q6lqwA9b3L1+CVK8FLtTfWzIyh4Q+qIUBql/t
        dxeZwL+cteCGMdAGMh+VZkt3JNzE
X-Google-Smtp-Source: APXvYqz+2qs5rw8GzGuCOl3iV58o8+r4tFdttDlZ81+8/1aK/nogBazEjmGXHFypwHyFs4pT3+ljDA==
X-Received: by 2002:a7b:c7d0:: with SMTP id z16mr2894458wmk.136.1555681861963;
        Fri, 19 Apr 2019 06:51:01 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g132sm4120496wme.3.2019.04.19.06.51.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Apr 2019 06:51:01 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v3 5/8] kernel-shark: Rename KS_DIR to KS_SOURCE_DIR
Date:   Fri, 19 Apr 2019 16:50:33 +0300
Message-Id: <20190419135036.19340-6-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190419135036.19340-1-ykaradzhov@vmware.com>
References: <20190419135036.19340-1-ykaradzhov@vmware.com>
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
index 019bde8..e776d62 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -123,7 +123,7 @@ inline QString dialogDir()
 {
 	QString path = QCoreApplication::applicationFilePath();
 
-	return path.contains(KS_DIR) ? KS_DIR : QDir::homePath();
+	return path.contains(KS_SOURCE_DIR) ? KS_SOURCE_DIR : QDir::homePath();
 }
 
 }; // KsUtils
-- 
2.20.1

