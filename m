Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470C8C10F00
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2288520651
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730626AbfDEKOZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 06:14:25 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46275 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730610AbfDEKOY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 06:14:24 -0400
Received: by mail-wr1-f65.google.com with SMTP id t17so7229128wrw.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 03:14:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3kCs6yTQU/sffdGqkB6qw65WKyElK8Q+ceTi/PCsYS0=;
        b=r7/vHHfwK98ngDmFv1O/aSZGKm6C0nR7Ubje8Blcq/1VOaTsTW6JB9LafNpxqIIsOT
         EExGuL05UtA1hb+QrWfcUTcYJXgjSHggXE6cW4jMlN6a3AhnpGrH0Qz/TqvUvGg7hPWm
         dqy2Vq3npNNnwM9o5s/m7LEUoZ/txHaxTuHubVM/w3sLwuUxEh2QZsH3xXZ4QCVDJxul
         WkvqBSjJp/y4gPp/JkUftGPEjeL2s1jQ+tUDhJ9zMUQ2TXy3vanPF6pARwXGXYa6EaUe
         QQc23JMEKJsG8up+JDYTsiEX0HBSsGllCrpAZKI7NxaknRq/GtD+RPknZ3964jVTLsK8
         zlNw==
X-Gm-Message-State: APjAAAUQ82lm1zAXc20zEK4rmp/kVuj/VEigc+xtACdTPxDWz+CtAEty
        nTH5UpxPD1MuANIYamq4qKVBKJccMzM=
X-Google-Smtp-Source: APXvYqynxk+IzY0pzsxJtcMd0HSR8T9lvmTQfn3qdQW9vrooUsWMWnnnYO9P2e6+bb+xtdgaekM+NA==
X-Received: by 2002:a5d:6988:: with SMTP id g8mr7830480wru.117.1554459262467;
        Fri, 05 Apr 2019 03:14:22 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a187sm1851124wma.32.2019.04.05.03.14.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Apr 2019 03:14:22 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [RFC v2 2/6] kernel-shark: Prepare for building the NumPy interface
Date:   Fri,  5 Apr 2019 13:14:07 +0300
Message-Id: <20190405101411.25466-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190405101411.25466-1-ykaradzhov@vmware.com>
References: <20190405101411.25466-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch prepares the Cmake build infrastructure for the
introduction of a the NumPy interface.

We add building of a static version of the C API library to be used by
the interface. The NumPy interface itself will be added in the following
patches.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt        |  3 +++
 kernel-shark/README                | 12 ++++++++--
 kernel-shark/build/FindNumPy.cmake | 35 ++++++++++++++++++++++++++++
 kernel-shark/src/CMakeLists.txt    | 37 ++++++++++++++++++++++--------
 4 files changed, 76 insertions(+), 11 deletions(-)
 create mode 100644 kernel-shark/build/FindNumPy.cmake

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index e0778ba..c6a4abf 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -34,6 +34,9 @@ if (Qt5Widgets_FOUND)
 
 endif (Qt5Widgets_FOUND)
 
+find_package(PythonLibs)
+include(${KS_DIR}/build/FindNumPy.cmake)
+
 set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 
diff --git a/kernel-shark/README b/kernel-shark/README
index b238d3f..a75b08b 100644
--- a/kernel-shark/README
+++ b/kernel-shark/README
@@ -12,7 +12,11 @@ KernelShark has the following external dependencies:
     sudo apt-get install freeglut3-dev libxmu-dev libxi-dev -y
     sudo apt-get install qtbase5-dev -y
 
-1.1 I you want to be able to generate Doxygen documentation:
+1.1 I you want to be able to use the NumPu Interface of KernelShark:
+    sudo apt-get install libpython3-dev cython3 -y
+    sudo apt-get install python3-numpy python3-matplotlib -y
+
+1.2 I you want to be able to generate Doxygen documentation:
     sudo apt-get install graphviz doxygen-gui -y
 
 
@@ -21,7 +25,11 @@ KernelShark has the following external dependencies:
     dnf install freeglut-devel redhat-rpm-config -y
     dnf install qt5-qtbase-devel -y
 
-2.1 I you want to be able to generate Doxygen documentation:
+2.1 I you want to be able to use the NumPu Interface of KernelShark:
+    dnf install python3-devel python-Cython -y
+    dnf install python-numpy python3-matplotlib -y
+
+2.2 I you want to be able to generate Doxygen documentation:
     dnf install graphviz doxygen -y
 
 
diff --git a/kernel-shark/build/FindNumPy.cmake b/kernel-shark/build/FindNumPy.cmake
new file mode 100644
index 0000000..b23440c
--- /dev/null
+++ b/kernel-shark/build/FindNumPy.cmake
@@ -0,0 +1,35 @@
+execute_process(COMMAND python -c "import Cython; print(Cython.__version__)"
+                RESULT_VARIABLE CYTHON_RES
+                OUTPUT_VARIABLE CYTHON_VERSION
+                ERROR_VARIABLE CYTHON_ERR
+                OUTPUT_STRIP_TRAILING_WHITESPACE)
+
+IF (CYTHON_RES MATCHES 0)
+
+  SET(CYTHON_FOUND TRUE)
+  message(STATUS "Found Cython:  (version: ${CYTHON_VERSION})")
+
+ELSE (CYTHON_RES MATCHES 0)
+
+  SET(CYTHON_FOUND FALSE)
+  message(STATUS "\nCould not find CYTHON:  ${CYTHON_ERR}\n")
+
+ENDIF (CYTHON_RES MATCHES 0)
+
+execute_process(COMMAND python -c "import numpy; print(numpy.__version__)"
+                RESULT_VARIABLE NP_RES
+                OUTPUT_VARIABLE NUMPY_VERSION
+                ERROR_VARIABLE NP_ERR
+                OUTPUT_STRIP_TRAILING_WHITESPACE)
+
+IF (NP_RES MATCHES 0)
+
+  SET(NUMPY_FOUND TRUE)
+  message(STATUS "Found NumPy:  (version: ${NUMPY_VERSION})")
+
+ELSE (NP_RES MATCHES 0)
+
+  SET(NUMPY_FOUND FALSE)
+  message(STATUS "\nCould not find NumPy:  ${NP_ERR}\n")
+
+ENDIF (NP_RES MATCHES 0)
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index b7dbd7e..b9a05e1 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -1,16 +1,21 @@
 message("\n src ...")
 
 message(STATUS "libkshark")
-add_library(kshark SHARED libkshark.c
-                          libkshark-model.c
-                          libkshark-plugin.c
-                          libkshark-configio.c
-                          libkshark-collection.c)
 
-target_link_libraries(kshark ${CMAKE_DL_LIBS}
-                             ${JSONC_LIBRARY}
-                             ${TRACEEVENT_LIBRARY}
-                             ${TRACECMD_LIBRARY})
+set(LIBKSHARK_SOURCE libkshark.c
+                     libkshark-model.c
+                     libkshark-plugin.c
+                     libkshark-configio.c
+                     libkshark-collection.c)
+
+set(LIBKSHARK_LINK_LIBS ${CMAKE_DL_LIBS}
+                        ${JSONC_LIBRARY}
+                        ${TRACEEVENT_LIBRARY}
+                        ${TRACECMD_LIBRARY})
+
+add_library(kshark SHARED ${LIBKSHARK_SOURCE})
+
+target_link_libraries(kshark ${LIBKSHARK_LINK_LIBS})
 
 set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
 
@@ -28,6 +33,20 @@ if (OPENGL_FOUND AND GLUT_FOUND)
 
 endif (OPENGL_FOUND AND GLUT_FOUND)
 
+if (PYTHONLIBS_FOUND AND CYTHON_FOUND AND NUMPY_FOUND)
+
+    message(STATUS "kshark_wrapper")
+
+    add_library(kshark-static STATIC ${LIBKSHARK_SOURCE})
+
+    target_compile_options(kshark-static PUBLIC "-fPIC")
+
+    set_target_properties(kshark-static PROPERTIES OUTPUT_NAME kshark)
+
+    target_link_libraries(kshark-static ${LIBKSHARK_LINK_LIBS})
+
+endif (PYTHONLIBS_FOUND AND CYTHON_FOUND AND NUMPY_FOUND)
+
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
     message(STATUS "libkshark-gui")
-- 
2.19.1

