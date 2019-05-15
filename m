Return-Path: <SRS0=5FCK=TP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B26C04E53
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B9C20843
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfEOTKD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 May 2019 15:10:03 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43415 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfEOTKD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 May 2019 15:10:03 -0400
Received: by mail-pf1-f193.google.com with SMTP id c6so439094pfa.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 May 2019 12:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fMopaRiEkLJFdgNMCidCCP9ePIfite2UI6gPtVnZA0c=;
        b=oyw4VV3CMSm2sYCmRj50aNn6sXdcBpPj+B9V+lgCyUnCLdHRX26Wsmf19hfbETq1ew
         Ij79b50xXl2nAMDi+9Zoe4EwCMKNFnD5bycRKeE2ULEM6Py4bm5cUSGyj/27OTvg+cw1
         hJ9ouwxkBtJfzHwcmPXeEKV7w4sdr7rn7XKevVjpD6qDtFdeKTeRz2QHUCU5X/M//kzo
         Fjga/izQ5AG9cXZf6VN8Vmu1uI+McXkta1BtsI+YSkRBoeb1ntpHtmjNj7mQIpRkymBw
         b92m2s1ZHSMP3/flZWffL+NWdDZdKb7Dz9sVW693QoEOH+ip2iubtfYGdXLjAbYTs41R
         15Ug==
X-Gm-Message-State: APjAAAUoBFgyoEy9mcT/SWNeTc3XkYIbPHK9BW7ZCLhKEIaAllwHnqAB
        xZ+dhhC7MmSdrmpPF0sC1sY=
X-Google-Smtp-Source: APXvYqzvH0JHdzcsA5fzfmI9tGWG/m+KwcJRVakcyTao3LZMWCwkPqnng//fHxchvsmzrLH8QwHqWg==
X-Received: by 2002:a63:fd0c:: with SMTP id d12mr46250047pgh.391.1557947402396;
        Wed, 15 May 2019 12:10:02 -0700 (PDT)
Received: from localhost.localdomain (50-204-120-225-static.hfc.comcastbusiness.net. [50.204.120.225])
        by smtp.gmail.com with ESMTPSA id l65sm5772595pfb.7.2019.05.15.12.10.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 12:10:01 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Troy Engel <troyengel@gmail.com>,
        Bas van Dijk <v.dijk.bas@gmail.com>
Subject: [PATCH 1/6] kernel-shark: Remove hard-coded install paths
Date:   Wed, 15 May 2019 12:09:06 -0700
Message-Id: <20190515190911.20755-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190515190911.20755-1-ykaradzhov@vmware.com>
References: <20190515190911.20755-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The definitions of KS_APP_NAME and KS_ICON are used to derive standard
installation paths for the KernelShark libraries, plugins and icons.
The patch combines improvements suggested by Troy Engel and Bas van Dijk.

Suggested-by: Troy Engel <troyengel@gmail.com>
Suggested-by: Bas van Dijk <v.dijk.bas@gmail.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt             |  8 ++++++--
 kernel-shark/build/deff.h.cmake         |  3 +++
 kernel-shark/build/ks.desktop.cmake     |  4 ++--
 kernel-shark/src/CMakeLists.txt         | 19 +++++++++++--------
 kernel-shark/src/KsUtils.cpp            |  4 ++--
 kernel-shark/src/plugins/CMakeLists.txt |  3 +--
 6 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 1aee858..b886e2c 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -4,6 +4,7 @@ cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
 # Set the name and version of the project
 project(kernel-shark)
 
+set(KS_APP_NAME "kernelshark")
 set(KS_VERSION_MAJOR 0)
 set(KS_VERSION_MINOR 9)
 set(KS_VERSION_PATCH 8)
@@ -39,6 +40,9 @@ if(NOT _INSTALL_PREFIX)
 	set(_INSTALL_PREFIX "/usr/local")
 endif()
 
+set(KS_PLUGIN_INSTALL_PREFIX ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
+set(KS_ICON ksharkicon.png)
+
 if (NOT _DEBUG)
 
 	set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -O2")
@@ -46,7 +50,7 @@ if (NOT _DEBUG)
 
 endif (NOT _DEBUG)
 
-SET(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/kshark/")
+SET(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
 SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
 
 include_directories(${KS_DIR}/src/
@@ -79,7 +83,7 @@ if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
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
 
diff --git a/kernel-shark/build/ks.desktop.cmake b/kernel-shark/build/ks.desktop.cmake
index 10e3610..2b02c0d 100644
--- a/kernel-shark/build/ks.desktop.cmake
+++ b/kernel-shark/build/ks.desktop.cmake
@@ -4,7 +4,7 @@ Type=Application
 Name=Kernel Shark
 GenericName=Kernel Shark
 Comment=
-Exec=@_INSTALL_PREFIX@/bin/kernelshark
-Icon=@KS_DIR@/icons/ksharkicon.png
+Exec=@_INSTALL_PREFIX@/bin/@KS_APP_NAME@
+Icon=@_INSTALL_PREFIX@/share/icons/@KS_APP_NAME@/@KS_ICON@
 Categories=System;
 Terminal=false
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index b7dbd7e..6cbc00f 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -69,23 +69,26 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
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
-            DESTINATION /usr/share/applications/)
+    install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
+            DESTINATION ${_INSTALL_PREFIX}/share/applications/)
+
+    install(FILES "${KS_DIR}/icons/${KS_ICON}"
+            DESTINATION ${_INSTALL_PREFIX}/share/icons/${KS_APP_NAME})
 
     install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
-            DESTINATION /usr/share/polkit-1/actions/)
+            DESTINATION ${_INSTALL_PREFIX}/share/polkit-1/actions/)
 
     install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
             DESTINATION ${_INSTALL_PREFIX}/bin/)
diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index 0020bff..dcedd7b 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -619,8 +619,8 @@ char *KsPluginManager::_pluginLibFromName(const QString &plugin, int &n)
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

