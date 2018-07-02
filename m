Return-Path: <SRS0=8H7y=JS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:53198 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbeGBOEz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Jul 2018 10:04:55 -0400
Received: by mail-wm0-f66.google.com with SMTP id w16-v6so8537682wmc.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Jul 2018 07:04:54 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 2/9] kernel-shark-qt: Automatic generation of doxygen documentation
Date: Mon,  2 Jul 2018 17:04:17 +0300
Message-Id: <20180702140424.23221-2-y.karadz@gmail.com>
In-Reply-To: <20180702140424.23221-1-y.karadz@gmail.com>
References: <20180702140424.23221-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

A possibility for automatic generation of doxygen documentation
of the KernelShark code is added to the CMake build system.
In order to generate such a documentation use the "_DOXYGEN_DOC"
CMake Command-Line option.

example:
  cd build/
  cmake -D_DOXYGEN_DOC=1 ../
  make

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/CMakeLists.txt       | 17 +++++++++++++++++
 kernel-shark-qt/build/cmake_clean.sh |  2 ++
 kernel-shark-qt/doc/dox_config       | 15 +++++++++++++++
 3 files changed, 34 insertions(+)
 create mode 100644 kernel-shark-qt/doc/dox_config

diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.txt
index 56fca44..9929937 100644
--- a/kernel-shark-qt/CMakeLists.txt
+++ b/kernel-shark-qt/CMakeLists.txt
@@ -14,6 +14,8 @@ set(KS_DIR ${CMAKE_SOURCE_DIR})
 
 include(${KS_DIR}/build/FindTraceCmd.cmake)
 
+find_package(Doxygen)
+
 set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 
@@ -32,4 +34,19 @@ message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
 
 add_subdirectory(${KS_DIR}/src)
 
+if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
+
+    message("\n doxygen documentation ...")
+    add_custom_target(doc ALL)
+    add_custom_command(TARGET doc
+                       COMMAND doxygen dox_config > dox_build.log
+                       WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/doc)
+
+    set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES
+                                          "${KS_DIR}/doc/dox_build.log"
+                                          "${KS_DIR}/doc/html"
+                                          "${KS_DIR}/doc/latex")
+
+endif ()
+
 message("")
diff --git a/kernel-shark-qt/build/cmake_clean.sh b/kernel-shark-qt/build/cmake_clean.sh
index ee0abbb..57c40a4 100755
--- a/kernel-shark-qt/build/cmake_clean.sh
+++ b/kernel-shark-qt/build/cmake_clean.sh
@@ -6,3 +6,5 @@ rm -rf CMakeFiles/
 rm -rf src/
 rm -f ../lib/*
 rm -f ../src/KsDeff.h
+rm -f CMakeDoxyfile.in
+rm -f CMakeDoxygenDefaults.cmake
diff --git a/kernel-shark-qt/doc/dox_config b/kernel-shark-qt/doc/dox_config
new file mode 100644
index 0000000..b982baa
--- /dev/null
+++ b/kernel-shark-qt/doc/dox_config
@@ -0,0 +1,15 @@
+# For detailed description of all Doxygen Configuration Parameters see:
+# http://www.doxygen.org/manual/config.html
+
+DOXYFILE_ENCODING      = UTF-8
+PROJECT_NAME           = "kernel-shark-qt"
+PROJECT_BRIEF = "Kernel Shark is a front-end reader of the Linux kernel tracing data."
+INPUT                  = "../src/"
+SOURCE_BROWSER         = YES
+QT_AUTOBRIEF           = YES
+TAB_SIZE               = 8
+OPTIMIZE_OUTPUT_FOR_C  = YES
+CASE_SENSE_NAMES       = YES
+SORT_MEMBER_DOCS       = NO
+STRICT_PROTO_MATCHING  = YES
+DOT_MULTI_TARGETS      = YES
-- 
2.17.1
