Return-Path: <SRS0=XDEQ=MW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-dm3nam03on0085.outbound.protection.outlook.com ([104.47.41.85]:42585
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727567AbeJKDei (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Oct 2018 23:34:38 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2 1/4] kernel-shark-qt: Add Qt as a third party dependency.
Date: Wed, 10 Oct 2018 23:10:12 +0300
Message-Id: <20181010201015.23824-2-ykaradzhov@vmware.com>
In-Reply-To: <20181010201015.23824-1-ykaradzhov@vmware.com>
References: <20181010201015.23824-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

This patch prepares the Cmake build infrastructure for the
introduction of a KernelShark GUI, baset on Qt.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/CMakeLists.txt | 8 ++++++++
 kernel-shark-qt/README         | 6 +++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.txt
index 4a40b11..71a021e 100644
--- a/kernel-shark-qt/CMakeLists.txt
+++ b/kernel-shark-qt/CMakeLists.txt
@@ -20,6 +20,14 @@ find_package(Doxygen)
 find_package(OpenGL)
 find_package(GLUT)
 
+find_package(Qt5Widgets 5.7.1)
+find_package(Qt5Network)
+if (Qt5Widgets_FOUND)
+
+    message(STATUS "Found Qt5Widgets:  (version ${Qt5Widgets_VERSION})")
+
+endif (Qt5Widgets_FOUND)
+
 set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 
diff --git a/kernel-shark-qt/README b/kernel-shark-qt/README
index 84708bd..14bcb77 100644
--- a/kernel-shark-qt/README
+++ b/kernel-shark-qt/README
@@ -4,10 +4,13 @@ This directory contains the new Qt-based version of the KernelShark GUI.
 
 Third Party Software:
 ------------------------------------------------------------
-The external dependencies:
+KernelShark has the following external dependencies:
+  Cmake, Json-C, OpenGL/Glut, Qt5Base.
+
 1. In order to install the packages on Ubuntu do the following:
     sudo apt-get install build-essential git cmake libjson-c-dev -y
     sudo apt-get install freeglut3-dev libxmu-dev libxi-dev -y
+    sudo apt-get install qtbase5-dev -y
 
 1.1 I you want to be able to generate Doxygen documentation:
     sudo apt-get install graphviz doxygen-gui -y
@@ -16,6 +19,7 @@ The external dependencies:
 2. In order to install the packages on Fedora, as root do the following:
     dnf install gcc gcc-c++ git cmake json-c-devel -y
     dnf install freeglut-devel redhat-rpm-config -y
+    dnf install qt5-qtbase-devel -y
 
 2.1 I you want to be able to generate Doxygen documentation:
     dnf install graphviz doxygen -y
-- 
2.17.1
