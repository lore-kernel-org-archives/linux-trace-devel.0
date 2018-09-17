Return-Path: <SRS0=TioG=L7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53125 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728790AbeIQULK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Sep 2018 16:11:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id y139-v6so9895265wmc.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Sep 2018 07:43:31 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 5/7] kernel-shark-qt: Add src/plugins dir. to hold the source code of the plugins
Date: Mon, 17 Sep 2018 17:42:24 +0300
Message-Id: <20180917144226.8653-6-y.karadz@gmail.com>
In-Reply-To: <20180917144226.8653-1-y.karadz@gmail.com>
References: <20180917144226.8653-1-y.karadz@gmail.com>
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
