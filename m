Return-Path: <SRS0=7BWw=MC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40265 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbeITWkr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Sep 2018 18:40:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id y8-v6so6482656wrh.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Sep 2018 09:56:23 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 6/8] kernel-shark-qt: Add src/plugins dir. to hold the source code of the plugins
Date: Thu, 20 Sep 2018 19:55:42 +0300
Message-Id: <20180920165544.17579-7-y.karadz@gmail.com>
In-Reply-To: <20180920165544.17579-1-y.karadz@gmail.com>
References: <20180920165544.17579-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Tell Cmake to enter src/plugins. Add a Cmake function for building plugin
libraries.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt         |  2 ++
 kernel-shark-qt/src/plugins/CMakeLists.txt | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)
 create mode 100644 kernel-shark-qt/src/plugins/CMakeLists.txt

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
index cdc28c4..3365413 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -28,5 +28,7 @@ if (OPENGL_FOUND AND GLUT_FOUND)
 
 endif (OPENGL_FOUND AND GLUT_FOUND)
 
+add_subdirectory(plugins)
+
 configure_file( ${KS_DIR}/build/deff.h.cmake
                 ${KS_DIR}/src/KsDeff.h)
diff --git a/kernel-shark-qt/src/plugins/CMakeLists.txt b/kernel-shark-qt/src/plugins/CMakeLists.txt
new file mode 100644
index 0000000..565f1cb
--- /dev/null
+++ b/kernel-shark-qt/src/plugins/CMakeLists.txt
@@ -0,0 +1,22 @@
+message("\n src/plugins ...")
+
+function(BUILD_PLUGIN)
+    set(options )
+    set(oneValueArgs NAME)
+    set(multiValueArgs SOURCE)
+    cmake_parse_arguments(ADD_PLUGIN "${options}"
+                                     ${oneValueArgs}
+                                     ${multiValueArgs}
+                                     ${ARGN})
+
+    message(STATUS ${ADD_PLUGIN_NAME})
+
+    add_library(${ADD_PLUGIN_NAME} SHARED ${ADD_PLUGIN_SOURCE})
+    set_target_properties(${ADD_PLUGIN_NAME} PROPERTIES PREFIX "plugin-")
+    target_link_libraries(${ADD_PLUGIN_NAME} kshark)
+
+endfunction()
+
+set(PLUGIN_LIST "")
+
+set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
-- 
2.17.1
