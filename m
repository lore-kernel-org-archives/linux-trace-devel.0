Return-Path: <SRS0=L+0X=LS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36058 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbeIDUSa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Sep 2018 16:18:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id m27-v6so4539566wrf.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 04 Sep 2018 08:52:47 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/7] kernel-shark-qt: Add src/plugins dir. to hold the source code of the plugins
Date: Tue,  4 Sep 2018 18:52:16 +0300
Message-Id: <20180904155218.32518-6-y.karadz@gmail.com>
In-Reply-To: <20180904155218.32518-1-y.karadz@gmail.com>
References: <20180904155218.32518-1-y.karadz@gmail.com>
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
index cdc28c4c..3365413e 100644
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
index 00000000..565f1cb3
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
