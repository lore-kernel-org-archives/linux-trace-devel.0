Return-Path: <SRS0=g3Xf=24=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49DA1C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0056A214D8
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ufSyh8g1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgAGREL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:04:11 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36589 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728378AbgAGREL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:04:11 -0500
Received: by mail-lf1-f65.google.com with SMTP id n12so260222lfe.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 09:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JIbiFLTY+iln+xK3keCS5fbXFhlU2vbLli9rjpRqCCA=;
        b=ufSyh8g1ciA0++ni1kOefXD8NfZXZIqsdPPHpfQIzUsLfTNzwA0QwDwS8kL7+f03Ma
         4Tn0uNEuEOOCgmZZVZPd1Z4EJlxfu3g8KzmounQfas97Lh9TlY5WSav7N+BM8rsAx5I2
         vewIqvOOkWmfDO7P5A41AccIv0dODfZbZbnEViXUmZxEMdBsYuzDjesw958Du7UgypzR
         HPkgKLtnLYA8brE/QzKLKpr2s7IANrLPOiGbwWo0DrDs7WJY7AXIgxvSiZpOu0tzLFcn
         XNIhemwbsyib3ICDEa0mgzjqh6FVDn434tHa2ZKqnKVJBi4QKdHcv7hjnWRPzA2Hwzbw
         Onpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JIbiFLTY+iln+xK3keCS5fbXFhlU2vbLli9rjpRqCCA=;
        b=Lchlx3xKQNimZlt6yKgCqDEkgssw6p3vwcX2oOLJWu+/FDirjugrkusezOXSuafSls
         Pw9+VhN66zPJ9VXoKzHauonXoeDtACWNXKqM4C1setZKw8PqMbCS3BgSpWSfgY8tCRyC
         +x1a9Egk1DiiqFruesXljzZSG7wEt8vXR+V3p3EYCY2I1jQgFUpzf0SU1YoDDS0aLvIr
         bfskv2cqUMERjuRSuu8n/J4nR/OABnemRm1X+7+Az1x6se0zIQjxUGFzYd+2rYIifw/E
         9hahM3/gbDUa4UEv5sDs7VXtIv2XlNHf0jBW2ql+X7CTXGl+cHvDHSrZgs4TjizwLyZn
         e1ew==
X-Gm-Message-State: APjAAAV+AZVar138qCbP2nVEVXDhDo779fZVTFqjC/7aCbW0xprPiAYs
        xb5qmB7CCQNdjbBdG3pFI9dZnu9k
X-Google-Smtp-Source: APXvYqxyK2bP1zTTblcSN7G5UzWAStlogqXGDePpyn9r/XMpHayzugqVSpeMEq0Sc0R0gL5kkbWfpA==
X-Received: by 2002:ac2:5e78:: with SMTP id a24mr195001lfr.5.1578416647375;
        Tue, 07 Jan 2020 09:04:07 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d16sm140605lfa.16.2020.01.07.09.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:04:06 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Douglas.Raillard@arm.com,
        Valentin.Schneider@arm.com, nd@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 09/12] trace-cruncher: Automate the third-party build
Date:   Tue,  7 Jan 2020 19:03:09 +0200
Message-Id: <20200107170312.27116-10-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200107170312.27116-1-y.karadz@gmail.com>
References: <20200107170312.27116-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The goal is to provide a simple and intuitive installation procedure
and in the same time to encapsulate the used third-party libraries
inside the Python package. This way we avoid polluting the system-wide
locations with the patched versions of the third-party libraries.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 ...-_DEVEL-_LIBS-and-_RPATH_TO_ORIGIN-b.patch | 160 ++++++++++++++++++
 0001-kernel-shark-Add-_DEVEL-build-flag.patch |  90 ----------
 0002-kernel-shark-Add-reg_pid-plugin.patch    |   8 +-
 Makefile                                      |   4 +-
 install_third_party.sh                        |  39 +++++
 setup.py                                      |  32 ++--
 src/ksharkpy.c                                |   4 +-
 tracecruncher/__init__.py                     |   4 +
 8 files changed, 231 insertions(+), 110 deletions(-)
 create mode 100644 0001-kernel-shark-Add-_DEVEL-_LIBS-and-_RPATH_TO_ORIGIN-b.patch
 delete mode 100644 0001-kernel-shark-Add-_DEVEL-build-flag.patch
 create mode 100755 install_third_party.sh

diff --git a/0001-kernel-shark-Add-_DEVEL-_LIBS-and-_RPATH_TO_ORIGIN-b.patch b/0001-kernel-shark-Add-_DEVEL-_LIBS-and-_RPATH_TO_ORIGIN-b.patch
new file mode 100644
index 0000000..68fb279
--- /dev/null
+++ b/0001-kernel-shark-Add-_DEVEL-_LIBS-and-_RPATH_TO_ORIGIN-b.patch
@@ -0,0 +1,160 @@
+From 9e3a3cb07674b787f64d2f4ee9cb4467745e815b Mon Sep 17 00:00:00 2001
+From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
+Date: Fri, 20 Sep 2019 14:31:15 +0300
+Subject: [PATCH 1/2] kernel-shark: Add _DEVEL, _LIBS and _RPATH_TO_ORIGIN
+ build flags
+
+If KernelShark is built with -D_LIBS=1 as a command-line argument
+for Cmake, only libkshark and libkshapr-plot will be compiled.
+
+If KernelShark is built with -D_DEVEL=1 as a command-line argument
+for Cmake, the headers of the libraries will be installed as well
+and a symbolic link that points to the version of the library
+being installed will be created.
+
+If built with -D_RPATH_TO_ORIGIN=1 the "rpath" of all libraries is
+set to "$ORIGIN".
+
+Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+---
+ kernel-shark/CMakeLists.txt     | 23 ++++++++++++++------
+ kernel-shark/README             |  3 +++
+ kernel-shark/src/CMakeLists.txt | 37 +++++++++++++++++++++++++++++++--
+ 3 files changed, 55 insertions(+), 8 deletions(-)
+
+diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
+index 20478b9..ea3133c 100644
+--- a/kernel-shark/CMakeLists.txt
++++ b/kernel-shark/CMakeLists.txt
+@@ -73,6 +73,12 @@ else (CMAKE_BUILD_TYPE MATCHES Package)
+ 
+ endif (CMAKE_BUILD_TYPE MATCHES Package)
+ 
++if (_RPATH_TO_ORIGIN)
++
++    set(CMAKE_INSTALL_RPATH $ORIGIN)
++
++endif (_RPATH_TO_ORIGIN)
++
+ include_directories(${KS_DIR}/src/
+                     ${KS_DIR}/build/src/
+                     ${JSONC_INCLUDE_DIR}
+@@ -84,7 +90,6 @@ message(STATUS "CXX flags    : " ${CMAKE_CXX_FLAGS})
+ message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
+ 
+ add_subdirectory(${KS_DIR}/src)
+-add_subdirectory(${KS_DIR}/examples)
+ 
+ if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
+ 
+@@ -99,12 +104,18 @@ if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
+                              "${KS_DIR}/Documentation/doxygen/html"
+                              "${KS_DIR}/Documentation/doxygen/latex")
+ 
+-endif ()
++endif (_DOXYGEN_DOC AND DOXYGEN_FOUND)
++
++if (NOT _LIBS)
++
++    add_subdirectory(${KS_DIR}/examples)
++
++    configure_file(${KS_DIR}/build/ks.desktop.cmake
++                   ${KS_DIR}/${KS_APP_NAME}.desktop)
+ 
+-configure_file( ${KS_DIR}/build/ks.desktop.cmake
+-                ${KS_DIR}/${KS_APP_NAME}.desktop)
++    configure_file(${KS_DIR}/build/org.freedesktop.kshark-record.policy.cmake
++                   ${KS_DIR}/org.freedesktop.kshark-record.policy)
+ 
+-configure_file( ${KS_DIR}/build/org.freedesktop.kshark-record.policy.cmake
+-                ${KS_DIR}/org.freedesktop.kshark-record.policy)
++endif (NOT _LIBS)
+ 
+ message("")
+diff --git a/kernel-shark/README b/kernel-shark/README
+index 6c360bb..0f14212 100644
+--- a/kernel-shark/README
++++ b/kernel-shark/README
+@@ -96,6 +96,9 @@ the dialog will derive the absolut path to the trace-cmd executable from
+ 
+ If no build types is specified, the type will be "RelWithDebInfo".
+ 
++2.1.4 In order to install a development version (including headers e.t.c) add
++-D_DEVEL=1 as a CMake Command-Line option.
++
+ Examples:
+ 
+     cmake -D_DOXYGEN_DOC=1 -D_INSTALL_PREFIX=/usr ../
+diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
+index e20a030..f63da6a 100644
+--- a/kernel-shark/src/CMakeLists.txt
++++ b/kernel-shark/src/CMakeLists.txt
+@@ -1,5 +1,13 @@
+ message("\n src ...")
+ 
++macro(install_symlink filepath sympath)
++    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${filepath} ${sympath})")
++    install(CODE "LIST(APPEND CMAKE_INSTALL_MANIFEST_FILES ${sympath})")
++    install(CODE "message(\"-- Created symlink: ${sympath} -> ${filepath}\")")
++endmacro(install_symlink)
++
++set(KS_INCLUDS_DESTINATION "${_INSTALL_PREFIX}/include/${KS_APP_NAME}")
++
+ message(STATUS "libkshark")
+ add_library(kshark SHARED libkshark.c
+                           libkshark-model.c
+@@ -16,6 +24,19 @@ set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
+ 
+ install(TARGETS kshark LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
+ 
++if (_DEVEL)
++
++    install_symlink("libkshark.so.${KS_VERSION_STRING}"
++                    "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/libkshark.so")
++
++    install(FILES "${KS_DIR}/src/libkshark.h"
++                  "${KS_DIR}/src/libkshark-plugin.h"
++                  "${KS_DIR}/src/libkshark-model.h"
++            DESTINATION ${KS_INCLUDS_DESTINATION}
++            COMPONENT devel)
++
++endif (_DEVEL)
++
+ if (OPENGL_FOUND AND GLUT_FOUND)
+ 
+     message(STATUS "libkshark-plot")
+@@ -30,9 +51,21 @@ if (OPENGL_FOUND AND GLUT_FOUND)
+ 
+     install(TARGETS kshark-plot LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
+ 
++    if (_DEVEL)
++
++        install_symlink("libkshark-plot.so.${KS_VERSION_STRING}"
++                        "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/libkshark-plot.so")
++
++        install(FILES "${KS_DIR}/src/KsPlotTools.hpp"
++                      "${KS_DIR}/src/libkshark-plot.h"
++                DESTINATION ${KS_INCLUDS_DESTINATION}
++                COMPONENT devel)
++
++    endif (_DEVEL)
++
+ endif (OPENGL_FOUND AND GLUT_FOUND)
+ 
+-if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
++if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND NOT _LIBS)
+ 
+     message(STATUS "libkshark-gui")
+     set (ks-guiLib_hdr  KsUtils.hpp
+@@ -98,7 +131,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
+     install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
+             DESTINATION ${_INSTALL_PREFIX}/bin/)
+ 
+-endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
++endif (Qt5Widgets_FOUND AND Qt5Network_FOUND AND NOT _LIBS)
+ 
+ add_subdirectory(plugins)
+ 
+-- 
+2.20.1
+
diff --git a/0001-kernel-shark-Add-_DEVEL-build-flag.patch b/0001-kernel-shark-Add-_DEVEL-build-flag.patch
deleted file mode 100644
index ddd3fd4..0000000
--- a/0001-kernel-shark-Add-_DEVEL-build-flag.patch
+++ /dev/null
@@ -1,90 +0,0 @@
-From 6c9e3b3f29c8af4780bb46313c3af73fb5d852c7 Mon Sep 17 00:00:00 2001
-From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
-Date: Fri, 20 Sep 2019 14:31:15 +0300
-Subject: [PATCH 1/2] kernel-shark: Add _DEVEL build flag
-
-KernelShark can be built with -D_DEVEL=1 as a command-line argument
-for Cmake. In this case the headers of the libraries will be installed
-as well and a symbolic link that points to the version of the library
-being installed will be created.
-
-Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
----
- kernel-shark/README             |  3 +++
- kernel-shark/src/CMakeLists.txt | 33 +++++++++++++++++++++++++++++++++
- 2 files changed, 36 insertions(+)
-
-diff --git a/kernel-shark/README b/kernel-shark/README
-index 6c360bb..0f14212 100644
---- a/kernel-shark/README
-+++ b/kernel-shark/README
-@@ -96,6 +96,9 @@ the dialog will derive the absolut path to the trace-cmd executable from
- 
- If no build types is specified, the type will be "RelWithDebInfo".
- 
-+2.1.4 In order to install a development version (including headers e.t.c) add
-+-D_DEVEL=1 as a CMake Command-Line option.
-+
- Examples:
- 
-     cmake -D_DOXYGEN_DOC=1 -D_INSTALL_PREFIX=/usr ../
-diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
-index e20a030..305840b 100644
---- a/kernel-shark/src/CMakeLists.txt
-+++ b/kernel-shark/src/CMakeLists.txt
-@@ -1,5 +1,13 @@
- message("\n src ...")
- 
-+macro(install_symlink filepath sympath)
-+    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${filepath} ${sympath})")
-+    install(CODE "LIST(APPEND CMAKE_INSTALL_MANIFEST_FILES ${sympath})")
-+    install(CODE "message(\"-- Created symlink: ${sympath} -> ${filepath}\")")
-+endmacro(install_symlink)
-+
-+set(KS_INCLUDS_DESTINATION "${_INSTALL_PREFIX}/include/${KS_APP_NAME}")
-+
- message(STATUS "libkshark")
- add_library(kshark SHARED libkshark.c
-                           libkshark-model.c
-@@ -16,6 +24,19 @@ set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
- 
- install(TARGETS kshark LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
- 
-+if (_DEVEL)
-+
-+    install_symlink("libkshark.so.${KS_VERSION_STRING}"
-+                    "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/libkshark.so")
-+
-+    install(FILES "${KS_DIR}/src/libkshark.h"
-+                  "${KS_DIR}/src/libkshark-plugin.h"
-+                  "${KS_DIR}/src/libkshark-model.h"
-+            DESTINATION ${KS_INCLUDS_DESTINATION}
-+            COMPONENT devel)
-+
-+endif (_DEVEL)
-+
- if (OPENGL_FOUND AND GLUT_FOUND)
- 
-     message(STATUS "libkshark-plot")
-@@ -30,6 +51,18 @@ if (OPENGL_FOUND AND GLUT_FOUND)
- 
-     install(TARGETS kshark-plot LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
- 
-+    if (_DEVEL)
-+
-+        install_symlink("libkshark-plot.so.${KS_VERSION_STRING}"
-+                        "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/libkshark-plot.so")
-+
-+        install(FILES "${KS_DIR}/src/KsPlotTools.hpp"
-+                      "${KS_DIR}/src/libkshark-plot.h"
-+                DESTINATION ${KS_INCLUDS_DESTINATION}
-+                COMPONENT devel)
-+
-+    endif (_DEVEL)
-+
- endif (OPENGL_FOUND AND GLUT_FOUND)
- 
- if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
--- 
-2.20.1
-
diff --git a/0002-kernel-shark-Add-reg_pid-plugin.patch b/0002-kernel-shark-Add-reg_pid-plugin.patch
index 146e3e6..8edc91f 100644
--- a/0002-kernel-shark-Add-reg_pid-plugin.patch
+++ b/0002-kernel-shark-Add-reg_pid-plugin.patch
@@ -1,4 +1,4 @@
-From b3efcb6368bc7f70a23e156dce6c58d09953889a Mon Sep 17 00:00:00 2001
+From dbfb97e61e9907df195970cf378740a1ee927de9 Mon Sep 17 00:00:00 2001
 From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
 Date: Wed, 9 Oct 2019 16:57:27 +0300
 Subject: [PATCH 2/2] kernel-shark: Add "reg_pid" plugin
@@ -33,7 +33,7 @@ index 6c77179..bf69945 100644
  set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
 diff --git a/kernel-shark/src/plugins/reg_pid.c b/kernel-shark/src/plugins/reg_pid.c
 new file mode 100644
-index 0000000..4116dd8
+index 0000000..df2e406
 --- /dev/null
 +++ b/kernel-shark/src/plugins/reg_pid.c
 @@ -0,0 +1,189 @@
@@ -216,14 +216,14 @@ index 0000000..4116dd8
 +/** Load this plugin. */
 +int KSHARK_PLUGIN_INITIALIZER(struct kshark_context *kshark_ctx)
 +{
-+// 	printf("--> pid_reg init\n");
++	printf("--> pid_reg init\n");
 +	return plugin_pid_reg_init(kshark_ctx);
 +}
 +
 +/** Unload this plugin. */
 +int KSHARK_PLUGIN_DEINITIALIZER(struct kshark_context *kshark_ctx)
 +{
-+// 	printf("<-- pid reg close\n");
++	printf("<-- pid reg close\n");
 +	return plugin_pid_reg_close(kshark_ctx);
 +}
 -- 
diff --git a/Makefile b/Makefile
index 735d43c..9f49184 100644
--- a/Makefile
+++ b/Makefile
@@ -5,10 +5,12 @@
 #
 
 all:
+	./install_third_party.sh
 	python3 setup.py build
 
 clean:
-	rm -rf build src/datawrapper.c
+	rm -rf third_party build tracecruncher/lib
+	rm -f src/datawrapper.c
 
 install:
 	python3 setup.py install --record install_manifest.txt
diff --git a/install_third_party.sh b/install_third_party.sh
new file mode 100755
index 0000000..412885e
--- /dev/null
+++ b/install_third_party.sh
@@ -0,0 +1,39 @@
+#!/bin/bash
+
+TRUNK=${PWD}
+THIRD_PARTY_LIB=${TRUNK}/tracecruncher/lib/libtracecmd.so
+
+if [ -f ${THIRD_PARTY_LIB} ]; then
+    exit 0
+fi
+
+TAG=kernelshark-v1.1
+THIRD_PARTY_DIR=${TRUNK}/third_party
+mkdir ${THIRD_PARTY_DIR}
+cd ${THIRD_PARTY_DIR}
+
+echo 'Installing: ' ${TAG}
+
+git clone git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git --branch=${TAG}
+
+cd trace-cmd
+git am ${TRUNK}/0001-kernel-shark-*
+git am ${TRUNK}/0002-kernel-shark-*
+
+make prefix=${THIRD_PARTY_DIR} install_libs
+
+cd kernel-shark/build/
+cmake -D_DEVEL=1 -D_LIBS=1 -D_INSTALL_PREFIX=${THIRD_PARTY_DIR} -D_RPATH_TO_ORIGIN=1 ..
+make install
+
+cd ${TRUNK}
+
+LIB_DIR=${TRUNK}/tracecruncher/lib/
+if [ ! -d "${LIB_DIR}" ]; then
+    mkdir ${LIB_DIR}
+fi
+
+cp -v ${THIRD_PARTY_DIR}/lib/kernelshark/libkshark.so.* ${TRUNK}/tracecruncher/lib/
+cp -v ${THIRD_PARTY_DIR}/lib/kernelshark/plugins/*.so ${TRUNK}/tracecruncher/lib/
+cp -v ${THIRD_PARTY_DIR}/lib/traceevent/*.so ${TRUNK}/tracecruncher/lib/
+cp -v ${THIRD_PARTY_DIR}/lib/trace-cmd/*.so ${TRUNK}/tracecruncher/lib/
diff --git a/setup.py b/setup.py
index 526e1e7..81f6e8e 100644
--- a/setup.py
+++ b/setup.py
@@ -12,34 +12,37 @@ from Cython.Build import cythonize
 import numpy as np
 
 def main():
-    kshark_path = '/usr/local/lib/kernelshark'
-    traceevent_path = '/usr/local/lib/traceevent/'
-    tracecmd_path = '/usr/local/lib/trace-cmd/'
+    third_party = './third_party'
 
     cythonize('src/datawrapper.pyx')
+
+    third_party_libdirs = [third_party+'/lib/kernelshark',
+                           third_party+'/lib/traceevent',
+                           third_party+'/lib/trace-cmd']
+
+    runtime_library_dirs=['$ORIGIN/lib']
+
     module_data = Extension('tracecruncher.datawrapper',
                             sources=['src/datawrapper.c'],
-                            include_dirs=[np.get_include()],
-                            library_dirs=[kshark_path, traceevent_path, tracecmd_path],
-                            runtime_library_dirs=[kshark_path, traceevent_path, tracecmd_path],
+                            include_dirs=[np.get_include(), third_party+'/include'],
+                            library_dirs=third_party_libdirs,
+                            runtime_library_dirs=runtime_library_dirs,
                             libraries=['kshark', 'traceevent', 'tracecmd']
                             )
 
     module_ks = Extension('tracecruncher.ksharkpy',
                           sources=['src/ksharkpy.c'],
-                          library_dirs=[kshark_path],
-                          runtime_library_dirs=[kshark_path],
+                          include_dirs=[third_party+'/include'],
+                          library_dirs=third_party_libdirs,
+                          runtime_library_dirs=runtime_library_dirs,
                           libraries=['kshark'],
-                          define_macros=[
-                              ('LIB_KSHARK_PATH', '\"' + kshark_path + '/libkshark.so\"'),
-                              ('KS_PLUGIN_DIR',   '\"' + kshark_path + '/plugins\"')
-                              ],
                           )
 
     module_ft = Extension('tracecruncher.ftracepy',
                           sources=['src/ftracepy.c'],
-                          library_dirs=[kshark_path, traceevent_path, tracecmd_path],
-                          runtime_library_dirs=[kshark_path, traceevent_path, tracecmd_path],
+                          include_dirs=[third_party+'/include'],
+                          library_dirs=third_party_libdirs,
+                          runtime_library_dirs=runtime_library_dirs,
                           libraries=['kshark', 'traceevent', 'tracecmd'],
                           )
 
@@ -52,6 +55,7 @@ def main():
           license='LGPL-2.1',
           packages=find_packages(),
           ext_modules=[module_data, module_ks, module_ft],
+          package_data={'tracecruncher': ['lib/*.so*']},
           classifiers=[
               'Development Status :: 3 - Alpha',
               'Programming Language :: Python :: 3',
diff --git a/src/ksharkpy.c b/src/ksharkpy.c
index 5a15a77..553c70a 100644
--- a/src/ksharkpy.c
+++ b/src/ksharkpy.c
@@ -137,7 +137,9 @@ static PyObject *method_register_plugin(PyObject *self, PyObject *args,
 		return NULL;
 	}
 
-	if (asprintf(&lib_file, "%s/plugin-%s.so", KS_PLUGIN_DIR, plugin) < 0) {
+	if (asprintf(&lib_file, "%s/lib/plugin-%s.so",
+			        getenv("TRACE_CRUNCHER_PATH"),
+				plugin) < 0) {
 		KS_MEM_ERROR
 		return NULL;
 	}
diff --git a/tracecruncher/__init__.py b/tracecruncher/__init__.py
index e69de29..1b34d53 100644
--- a/tracecruncher/__init__.py
+++ b/tracecruncher/__init__.py
@@ -0,0 +1,4 @@
+import os
+
+pwd = os.path.dirname(os.path.abspath(__file__))
+os.environ['TRACE_CRUNCHER_PATH'] = pwd
-- 
2.20.1

