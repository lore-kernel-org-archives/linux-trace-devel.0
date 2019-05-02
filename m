Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E825C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 670252075E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEBMkn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:40:43 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36150 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfEBMkn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:40:43 -0400
Received: by mail-wr1-f67.google.com with SMTP id o4so3167409wra.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 05:40:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B2b1nhQASwdzA0A1+OW/NvGNY0+pW67mx28Mgy0aZUU=;
        b=CHzmbqGPPHlBMDboa8J8tF44HAYTj9FfIxk1RLS8rD+oL+t/lpARVYH/ejbLyVDc8e
         xO8IjrAxjXKQKLSshLehKhfGPVR4wNt6YUK4Bk0ysWSlzi0SmxRhtTi/X9lKi/TimIoy
         vGDPUsmfX35L0WA71ygvavKDon0ESamP+AU85tiDu6aGzOT9CA9IU8CrGjFsmxZ+1TC6
         IsJKbVt2pXJmt5r647SgvJrwgmBKEi9h6UmnX3KG+7jVpnylJUKKGo14F2ZmVIE8x6Yt
         2eQrhf2EvdH2TOfo0ZGv3W0QQkMqKT+RKKc9nESfV9nbYdWwd0b444rf5zedbVXjY4Ty
         +kLw==
X-Gm-Message-State: APjAAAU70pSXxEyXNOipxrPdvc9D20rVti/Q6UV7Rfmo+6+dt/su7t2l
        1VWpIfPnnLjLXuch3KfUI0k=
X-Google-Smtp-Source: APXvYqyx86CIj6lMrLqD8a6Vb7odqCYgoeddB2cq6UtnXCTNHUq3T9IOdv+fOyQLSoiFPtvv2AyzFw==
X-Received: by 2002:a5d:6386:: with SMTP id p6mr2686052wru.59.1556800840721;
        Thu, 02 May 2019 05:40:40 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d11sm7511008wmb.39.2019.05.02.05.40.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:40:40 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com, Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 7/8] kernel-shark: Remove hard-coded install paths for libraries and plugins
Date:   Thu,  2 May 2019 15:40:08 +0300
Message-Id: <20190502124009.32208-8-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502124009.32208-1-ykaradzhov@vmware.com>
References: <20190502124009.32208-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The definition of KS_APP_NAME is used to derive standard installation
paths for the KernelShark libraries and plugins.

Suggested-by: Troy Engel <troyengel@gmail.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt             |  7 +++++--
 kernel-shark/build/deff.h.cmake         |  3 +++
 kernel-shark/src/CMakeLists.txt         | 12 ++++++------
 kernel-shark/src/KsUtils.cpp            |  4 ++--
 kernel-shark/src/plugins/CMakeLists.txt |  3 +--
 5 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 1aee858..64f7de8 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -4,6 +4,7 @@ cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
 # Set the name and version of the project
 project(kernel-shark)
 
+set(KS_APP_NAME "kernelshark")
 set(KS_VERSION_MAJOR 0)
 set(KS_VERSION_MINOR 9)
 set(KS_VERSION_PATCH 8)
@@ -39,6 +40,8 @@ if(NOT _INSTALL_PREFIX)
 	set(_INSTALL_PREFIX "/usr/local")
 endif()
 
+set(KS_PLUGIN_INSTALL_PREFIX ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
+
 if (NOT _DEBUG)
 
 	set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -O2")
@@ -46,7 +49,7 @@ if (NOT _DEBUG)
 
 endif (NOT _DEBUG)
 
-SET(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/kshark/")
+SET(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
 SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
 
 include_directories(${KS_DIR}/src/
@@ -79,7 +82,7 @@ if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
 endif ()
 
 configure_file( ${KS_DIR}/build/ks.desktop.cmake
-                ${KS_DIR}/kernelshark.desktop)
+                ${KS_DIR}/${KS_APP_NAME}.desktop)
 
 configure_file( ${KS_DIR}/build/org.freedesktop.kshark-record.policy.cmake
                 ${KS_DIR}/org.freedesktop.kshark-record.policy)
diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
index 1cf8a80..efee2a1 100644
--- a/kernel-shark/build/deff.h.cmake
+++ b/kernel-shark/build/deff.h.cmake
@@ -14,6 +14,9 @@
 /** KernelShark installation prefix path. */
 #cmakedefine _INSTALL_PREFIX "@_INSTALL_PREFIX@"
 
+/** KernelShark plugins installation prefix path. */
+#cmakedefine KS_PLUGIN_INSTALL_PREFIX "@KS_PLUGIN_INSTALL_PREFIX@"
+
 /** Location of the trace-cmd executable. */
 #cmakedefine TRACECMD_BIN_DIR "@TRACECMD_BIN_DIR@"
 
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index b7dbd7e..2f28cae 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -69,19 +69,19 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
     set_target_properties(kshark-gui PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
 
-    message(STATUS "kernelshark")
-    add_executable(kernelshark          kernelshark.cpp)
-    target_link_libraries(kernelshark   kshark-gui)
+    message(STATUS ${KS_APP_NAME})
+    add_executable(${KS_APP_NAME}          kernelshark.cpp)
+    target_link_libraries(${KS_APP_NAME}   kshark-gui)
 
     message(STATUS "kshark-record")
     add_executable(kshark-record        kshark-record.cpp)
     target_link_libraries(kshark-record kshark-gui)
 
-    install(TARGETS kernelshark kshark-record kshark kshark-plot kshark-gui
+    install(TARGETS ${KS_APP_NAME} kshark-record kshark kshark-plot kshark-gui
             RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
-            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/kshark/)
+            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/)
 
-    install(FILES "${KS_DIR}/kernelshark.desktop"
+    install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
             DESTINATION /usr/share/applications/)
 
     install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index ee481bf..e2091be 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -621,8 +621,8 @@ char *KsPluginManager::_pluginLibFromName(const QString &plugin, int &n)
 		n = asprintf(&lib, "%s/plugin-%s.so",
 			     pathStr.c_str(), pluginStr.c_str());
 	} else {
-		n = asprintf(&lib, "%s/lib/kshark/plugins/plugin-%s.so",
-			     _INSTALL_PREFIX, pluginStr.c_str());
+		n = asprintf(&lib, "%s/plugin-%s.so",
+			     KS_PLUGIN_INSTALL_PREFIX, pluginStr.c_str());
 	}
 
 	return lib;
diff --git a/kernel-shark/src/plugins/CMakeLists.txt b/kernel-shark/src/plugins/CMakeLists.txt
index 64cf98d..6c77179 100644
--- a/kernel-shark/src/plugins/CMakeLists.txt
+++ b/kernel-shark/src/plugins/CMakeLists.txt
@@ -18,7 +18,6 @@ function(BUILD_PLUGIN)
 endfunction()
 
 set(PLUGIN_LIST "")
-
 BUILD_PLUGIN(NAME sched_events
              SOURCE sched_events.c SchedEvents.cpp)
 list(APPEND PLUGIN_LIST "sched_events default") # This plugin will be loaded by default
@@ -29,6 +28,6 @@ BUILD_PLUGIN(NAME missed_events
 list(APPEND PLUGIN_LIST "missed_events default") # This plugin will be loaded by default
 
 install(TARGETS sched_events missed_events
-        LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/kshark/plugins/)
+        LIBRARY DESTINATION ${KS_PLUGIN_INSTALL_PREFIX})
 
 set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
-- 
2.20.1

