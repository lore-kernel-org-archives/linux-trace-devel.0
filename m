Return-Path: <SRS0=wogL=LF=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37256 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728958AbeHVTH0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Aug 2018 15:07:26 -0400
Received: by mail-wm0-f65.google.com with SMTP id n11-v6so2655746wmc.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Aug 2018 08:42:02 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/5] kernel-shark-qt: Add OpenGL/GLUT as a third party dependency.
Date: Wed, 22 Aug 2018 18:41:36 +0300
Message-Id: <20180822154140.3748-2-y.karadz@gmail.com>
In-Reply-To: <20180822154140.3748-1-y.karadz@gmail.com>
References: <20180822154140.3748-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch prepares the Cmake build infrastructure for the
introduction of a KernelShark Ploting library, baset on OpenGl.
The Ploting library will be added in the following patch.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/CMakeLists.txt | 3 +++
 kernel-shark-qt/README         | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.txt
index 3516caa..0187eb4 100644
--- a/kernel-shark-qt/CMakeLists.txt
+++ b/kernel-shark-qt/CMakeLists.txt
@@ -17,6 +17,9 @@ include(${KS_DIR}/build/FindJSONC.cmake)
 
 find_package(Doxygen)
 
+find_package(OpenGL)
+find_package(GLUT)
+
 set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 
diff --git a/kernel-shark-qt/README b/kernel-shark-qt/README
index e6818fc..f03288c 100644
--- a/kernel-shark-qt/README
+++ b/kernel-shark-qt/README
@@ -7,6 +7,7 @@ Third Party Software:
 The external dependencies:
 1. In order to install the packages on Ubuntu do the following:
     sudo apt-get install build-essential git cmake libjson-c-dev -y
+    sudo apt-get install freeglut3-dev libxmu-dev libxi-dev -y
 
 1.1 I you want to be able to generate Doxygen documentation:
     sudo apt-get install graphviz doxygen-gui -y
@@ -14,6 +15,7 @@ The external dependencies:
 
 2. In order to install the packages on Fedora, as root do the following:
     dnf install gcc gcc-c++ git cmake json-c-devel -y
+    dnf install freeglut-devel redhat-rpm-config -y
 
 2.1 I you want to be able to generate Doxygen documentation:
     dnf install graphviz doxygen -y
-- 
2.17.1
