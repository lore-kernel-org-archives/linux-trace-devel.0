Return-Path: <SRS0=HiQF=K5=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45058 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729384AbeHNUwU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Aug 2018 16:52:20 -0400
Received: by mail-wr1-f67.google.com with SMTP id f12-v6so17935169wrv.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Aug 2018 11:04:02 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/3] kernel-shark-qt: Add Json-C as a third party dependency.
Date: Tue, 14 Aug 2018 21:03:46 +0300
Message-Id: <20180814180348.17236-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch prepares the Cmake build infrastructure for the
introduction of a Json I/O for filter configurations. The Json I/O will
be added to the C API of KernelShark in the following patch.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/CMakeLists.txt        |  2 ++
 kernel-shark-qt/README                |  4 +--
 kernel-shark-qt/build/FindJSONC.cmake | 38 +++++++++++++++++++++++++++
 kernel-shark-qt/src/CMakeLists.txt    |  1 +
 4 files changed, 43 insertions(+), 2 deletions(-)
 create mode 100644 kernel-shark-qt/build/FindJSONC.cmake

diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.txt
index 7a802cd..3516caa 100644
--- a/kernel-shark-qt/CMakeLists.txt
+++ b/kernel-shark-qt/CMakeLists.txt
@@ -13,6 +13,7 @@ message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
 set(KS_DIR ${CMAKE_SOURCE_DIR})
 
 include(${KS_DIR}/build/FindTraceCmd.cmake)
+include(${KS_DIR}/build/FindJSONC.cmake)
 
 find_package(Doxygen)
 
@@ -24,6 +25,7 @@ set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread")
 
 include_directories(${KS_DIR}/src/
                     ${KS_DIR}/build/src/
+                    ${JSONC_INCLUDE_DIR}
                     ${TRACECMD_INCLUDE_DIR}
                     ${TRACEEVENT_INCLUDE_DIR})
 
diff --git a/kernel-shark-qt/README b/kernel-shark-qt/README
index 6ff77a5..e6818fc 100644
--- a/kernel-shark-qt/README
+++ b/kernel-shark-qt/README
@@ -6,14 +6,14 @@ Third Party Software:
 ------------------------------------------------------------
 The external dependencies:
 1. In order to install the packages on Ubuntu do the following:
-    sudo apt-get install build-essential git cmake -y
+    sudo apt-get install build-essential git cmake libjson-c-dev -y
 
 1.1 I you want to be able to generate Doxygen documentation:
     sudo apt-get install graphviz doxygen-gui -y
 
 
 2. In order to install the packages on Fedora, as root do the following:
-    dnf install gcc gcc-c++ git cmake -y
+    dnf install gcc gcc-c++ git cmake json-c-devel -y
 
 2.1 I you want to be able to generate Doxygen documentation:
     dnf install graphviz doxygen -y
diff --git a/kernel-shark-qt/build/FindJSONC.cmake b/kernel-shark-qt/build/FindJSONC.cmake
new file mode 100644
index 0000000..3bae20f
--- /dev/null
+++ b/kernel-shark-qt/build/FindJSONC.cmake
@@ -0,0 +1,38 @@
+# - Try to find json-c
+# https://cmake.org/Wiki/CMake:How_To_Find_Libraries
+# Once done this will define
+#  JSONC_FOUND - System has json-c
+#  JSONC_INCLUDE_DIRS - The json-c include directories
+#  JSONC_LIBRARIES - The libraries needed to use json-c
+#  JSONC_DEFINITIONS - Compiler switches required for using json-c
+
+find_package(PkgConfig)
+pkg_check_modules(PC_JSONC QUIET json-c)
+set(JSONC_DEFINITIONS ${PC_JSONC_CFLAGS_OTHER})
+
+find_path(JSONC_INCLUDE_DIR json.h
+          HINTS ${PC_JSONC_INCLUDEDIR} ${PC_JSONC_INCLUDE_DIRS}
+          PATH_SUFFIXES json-c)
+
+find_library(JSONC_LIBRARY NAMES json-c libjson-c
+             HINTS ${PC_JSONC_LIBDIR} ${PC_JSONC_LIBRARY_DIRS})
+
+find_library(JSONC_LIBRARY NAMES json-c libjson-c
+             HINTS ${PC_JSON-C_LIBDIR} ${PC_JSON-C_LIBRARY_DIRS})
+
+include(FindPackageHandleStandardArgs)
+# handle the QUIETLY and REQUIRED arguments and set JSONC_FOUND to TRUE
+# if all listed variables are TRUE
+find_package_handle_standard_args(JSONC DEFAULT_MSG
+                                  JSONC_LIBRARY JSONC_INCLUDE_DIR)
+
+if (NOT JSONC_FOUND)
+
+  message(FATAL_ERROR "Json-C is Required!\n")
+
+endif (NOT JSONC_FOUND)
+
+mark_as_advanced(JSONC_INCLUDE_DIR JSONC_LIBRARY)
+
+set(JSONC_LIBRARIES    ${JSONC_LIBRARY})
+set(JSONC_INCLUDE_DIRS ${JSONC_INCLUDE_DIR})
diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
index cd42920..ea5dbda 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -6,6 +6,7 @@ add_library(kshark SHARED libkshark.c
                           libkshark-collection.c)
 
 target_link_libraries(kshark ${CMAKE_DL_LIBS}
+                             ${JSONC_LIBRARY}
                              ${TRACEEVENT_LIBRARY}
                              ${TRACECMD_LIBRARY})
 
-- 
2.17.1
