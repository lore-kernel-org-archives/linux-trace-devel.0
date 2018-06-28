Return-Path: <SRS0=5iTX=JO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:54483 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751403AbeF1Qa5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Jun 2018 12:30:57 -0400
Received: by mail-wm0-f68.google.com with SMTP id i139-v6so10355626wmf.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Jun 2018 09:30:56 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/9] kernel-shark-qt: Add Cmake build system for the Qt based KernelShark
Date: Thu, 28 Jun 2018 19:30:04 +0300
Message-Id: <20180628163012.21477-2-y.karadz@gmail.com>
In-Reply-To: <20180628163012.21477-1-y.karadz@gmail.com>
References: <20180628163012.21477-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch adds in /kernel-shark-qt a simple CMake building
infrastructure, to be used by the new, Qt-based version of
KernelShark. Currently, this does not build any objects.
It only generates a header file (src/KsDeff.h) containing some
user-specific definitions. The building infrastructure
is necessary for the coming changes.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/CMakeLists.txt           | 35 ++++++++++++
 kernel-shark-qt/build/FindTraceCmd.cmake | 70 ++++++++++++++++++++++++
 kernel-shark-qt/build/cmake_clean.sh     |  8 +++
 kernel-shark-qt/build/deff.h.cmake       | 20 +++++++
 kernel-shark-qt/src/CMakeLists.txt       |  4 ++
 5 files changed, 137 insertions(+)
 create mode 100644 kernel-shark-qt/CMakeLists.txt
 create mode 100644 kernel-shark-qt/build/FindTraceCmd.cmake
 create mode 100755 kernel-shark-qt/build/cmake_clean.sh
 create mode 100644 kernel-shark-qt/build/deff.h.cmake
 create mode 100644 kernel-shark-qt/src/CMakeLists.txt

diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.txt
new file mode 100644
index 0000000..56fca44
--- /dev/null
+++ b/kernel-shark-qt/CMakeLists.txt
@@ -0,0 +1,35 @@
+# Check if cmake has the required version
+cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
+
+# Set the name and version of the project
+project(kernel-shark-qt)
+
+set(KS_VERSION_MAJOR 0)
+set(KS_VERSION_MINOR 7)
+set(KS_VERSION_PATCH 0)
+set(KS_VERSION_STRING ${KS_VERSION_MAJOR}.${KS_VERSION_MINOR}.${KS_VERSION_PATCH})
+message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
+
+set(KS_DIR ${CMAKE_SOURCE_DIR})
+
+include(${KS_DIR}/build/FindTraceCmd.cmake)
+
+set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
+set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
+
+set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread")
+set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread")
+
+include_directories(${KS_DIR}/src/
+                    ${KS_DIR}/build/src/
+                    ${TRACECMD_INCLUDE_DIR}
+                    ${TRACEEVENT_INCLUDE_DIR})
+
+message("")
+message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
+message(STATUS "CXX flags    : " ${CMAKE_CXX_FLAGS})
+message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
+
+add_subdirectory(${KS_DIR}/src)
+
+message("")
diff --git a/kernel-shark-qt/build/FindTraceCmd.cmake b/kernel-shark-qt/build/FindTraceCmd.cmake
new file mode 100644
index 0000000..fb2092a
--- /dev/null
+++ b/kernel-shark-qt/build/FindTraceCmd.cmake
@@ -0,0 +1,70 @@
+# Find traceevent and trace-cmd
+# This module finds an installed trace-cmd package.
+#
+# It sets the following variables:
+#  TRACEEVENT_INCLUDE_DIR, where to find traceevent header.
+#  TRACEEVENT_LIBRARY_DIR , where to find the traceevent library.
+#  TRACEEVENT_LIBRARY, traceevent the library.
+#  TRACEEVENT_FOUND, If false, do not try to use traceevent.
+#
+#  TRACECMD_INCLUDE_DIR, where to find trace-cmd header.
+#  TRACECMD_LIBRARY_DIR , where to find the trace-cmd library.
+#  TRACECMD_LIBRARY, the trace-cmd library.
+#  TRACECMD_FOUND, If false, do not try to use trace-cmd.
+
+# MESSAGE(" Looking for trace-cmd ...")
+
+find_path(TRACECMD_BIN_DIR      NAMES  trace-cmd
+                                PATHS  $ENV{TRACE_CMD}/tracecmd/
+                                       ${CMAKE_SOURCE_DIR}/../tracecmd/)
+
+find_path(TRACECMD_INCLUDE_DIR  NAMES  trace-cmd.h
+                                PATHS  $ENV{TRACE_CMD}/include/trace-cmd/
+                                       ${CMAKE_SOURCE_DIR}/../include/trace-cmd/)
+
+find_path(TRACECMD_LIBRARY_DIR  NAMES  libtracecmd.a
+                                PATHS  $ENV{TRACE_CMD}/lib/trace-cmd/
+                                       ${CMAKE_SOURCE_DIR}/../lib/trace-cmd/)
+
+IF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY_DIR)
+
+  SET(TRACECMD_FOUND TRUE)
+  SET(TRACECMD_LIBRARY "${TRACECMD_LIBRARY_DIR}/libtracecmd.a")
+
+ENDIF (TRACECMD_INCLUDE_DIR AND TRACECMD_LIBRARY_DIR)
+
+IF (TRACECMD_FOUND)
+
+  MESSAGE(STATUS "Found trace-cmd: ${TRACECMD_LIBRARY}")
+
+ELSE (TRACECMD_FOUND)
+
+  MESSAGE(FATAL_ERROR "\nCould not find trace-cmd!\n")
+
+ENDIF (TRACECMD_FOUND)
+
+
+find_path(TRACEEVENT_INCLUDE_DIR  NAMES  event-parse.h
+                                  PATHS  $ENV{TRACE_CMD}/include/traceevent/
+                                         ${CMAKE_SOURCE_DIR}/../include/traceevent/)
+
+find_path(TRACEEVENT_LIBRARY_DIR  NAMES  libtraceevent.a
+                                  PATHS  $ENV{TRACE_CMD}/lib/traceevent/
+                                         ${CMAKE_SOURCE_DIR}/../lib/traceevent/)
+
+IF (TRACEEVENT_INCLUDE_DIR AND TRACEEVENT_LIBRARY_DIR)
+
+  SET(TRACEEVENT_FOUND TRUE)
+  SET(TRACEEVENT_LIBRARY "${TRACEEVENT_LIBRARY_DIR}/libtraceevent.a")
+
+ENDIF (TRACEEVENT_INCLUDE_DIR AND TRACEEVENT_LIBRARY_DIR)
+
+IF (TRACEEVENT_FOUND)
+
+  MESSAGE(STATUS "Found traceevent: ${TRACEEVENT_LIBRARY}")
+
+ELSE (TRACEEVENT_FOUND)
+
+  MESSAGE(FATAL_ERROR "\nCould not find libtraceevent!\n")
+
+ENDIF (TRACEEVENT_FOUND)
diff --git a/kernel-shark-qt/build/cmake_clean.sh b/kernel-shark-qt/build/cmake_clean.sh
new file mode 100755
index 0000000..ee0abbb
--- /dev/null
+++ b/kernel-shark-qt/build/cmake_clean.sh
@@ -0,0 +1,8 @@
+make clean
+rm CMakeCache.txt
+rm cmake_install.cmake
+rm Makefile
+rm -rf CMakeFiles/
+rm -rf src/
+rm -f ../lib/*
+rm -f ../src/KsDeff.h
diff --git a/kernel-shark-qt/build/deff.h.cmake b/kernel-shark-qt/build/deff.h.cmake
new file mode 100644
index 0000000..111fcdd
--- /dev/null
+++ b/kernel-shark-qt/build/deff.h.cmake
@@ -0,0 +1,20 @@
+ /**
+ *  \file    KsDeff.h
+ *  \brief   This File is generated by CMAKE
+ */
+
+/* ! -- Do Not Hand Edit - This File is generated by CMAKE -- ! */
+
+#ifndef _KS_CONFIG_H
+#define _KS_CONFIG_H
+
+/** KernelShark Version number. */
+#cmakedefine KS_VERSION_STRING "@KS_VERSION_STRING@"
+
+/** KernelShark source code path. */
+#cmakedefine KS_DIR "@KS_DIR@"
+
+/** Location of the trace-cmd executable. */
+#cmakedefine TRACECMD_BIN_DIR "@TRACECMD_BIN_DIR@"
+
+#endif // _KS_CONFIG_H
diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
new file mode 100644
index 0000000..8c66424
--- /dev/null
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -0,0 +1,4 @@
+message("\n src ...")
+
+configure_file( ${KS_DIR}/build/deff.h.cmake
+                ${KS_DIR}/src/KsDeff.h)
-- 
2.17.1
