Return-Path: <SRS0=hb2W=TX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952F6C282DE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7368921773
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbfEWPSu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 May 2019 11:18:50 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35239 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730904AbfEWPSt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 May 2019 11:18:49 -0400
Received: by mail-wm1-f67.google.com with SMTP id w9so89402wmi.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 May 2019 08:18:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h31ubIrqnTVFVpMzr7o0ILyxaQapcHRERfA3iiyz+XM=;
        b=uPoXYRvIiDhL9U8o4WBf+nw0wzGUvioXDW4pp7PTy839bj5S1UAE4t9Fh55FrckaV0
         VCv1utOCN1gVIcYtOeLckpXp+qO5gRCpXZj11PYw0mmZG0eckdt/4GPhRx1DvYqW/yzB
         qr59ia+FJEw07LnXb3aqLz5csuR0G+5B6Kj0jJFZUQOuNL/VgtzGxHE4YmnrfWEPE3mj
         HM+0w6atuUyXzMyTlm+TY6g5OsS6kHw6brF/jTzWU5SOqElkz70JApzc1qlpPFDmF/6e
         LqNTpc9e4vQ8oWbmMXzIbcsILZESAbitTu6teippP7U7fWNw8OdfkbGtsWXz987Ujfju
         7dIQ==
X-Gm-Message-State: APjAAAXBbzGUx100UC4UdYWLxtyfLlRS9WUWB1iDdK4s6jJEKKWcbjlA
        EjCW8eIOFpjf4q2DD5/KsB4=
X-Google-Smtp-Source: APXvYqwvzEiboYWEfeIv8qSxTZK7+3yBj5c8aUiDuy4+ZbDRg12F4jmc/I+0yzq2+7eVXW2DoLjf+g==
X-Received: by 2002:a1c:1d4:: with SMTP id 203mr13265517wmb.76.1558624728060;
        Thu, 23 May 2019 08:18:48 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x9sm12687071wmf.27.2019.05.23.08.18.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:18:47 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 5/5] kernel-shark: Install public interface headers
Date:   Thu, 23 May 2019 18:18:12 +0300
Message-Id: <20190523151812.31391-6-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523151812.31391-1-ykaradzhov@vmware.com>
References: <20190523151812.31391-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Installing the header files included in the public interfaces of
the KernelShark libraries will make possible the libraries to be used
for development.

A symbolic link that points to the latest versions of the libraries is
added to INSTALL_PREFIX/lib/kernelshark

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/README             |  4 ++++
 kernel-shark/src/CMakeLists.txt | 42 +++++++++++++++++++++++++++++++--
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/README b/kernel-shark/README
index 379c390..573e279 100644
--- a/kernel-shark/README
+++ b/kernel-shark/README
@@ -44,6 +44,10 @@ as a CMake Command-Line option.
 2.1.3 By default, installation prefix is "/usr/local". It can be changed using
 -D_INSTALL_PREFIX= as a CMake Command-Line option.
 
+2.1.4 In order to install a development version (including headers e.t.c) add
+-D_DEVEL=1 as a CMake Command-Line option.
+
+
 Example:
     cmake -D_DOXYGEN_DOC=1 -D_DEBUG=1 -D_INSTALL_PREFIX=/usr ../
 
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index 6cbc00f..6dd9b5a 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -1,5 +1,13 @@
 message("\n src ...")
 
+macro(install_symlink filepath sympath)
+    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${filepath} ${sympath})")
+    install(CODE "LIST(APPEND CMAKE_INSTALL_MANIFEST_FILES ${sympath})")
+    install(CODE "message(\"-- Created symlink: ${sympath} -> ${filepath}\")")
+endmacro(install_symlink)
+
+set(KS_INCLUDS_DESTINATION "${_INSTALL_PREFIX}/include/${KS_APP_NAME}")
+
 message(STATUS "libkshark")
 add_library(kshark SHARED libkshark.c
                           libkshark-model.c
@@ -14,6 +22,22 @@ target_link_libraries(kshark ${CMAKE_DL_LIBS}
 
 set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
 
+install(TARGETS kshark LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
+
+if (_DEVEL)
+
+    install_symlink("libkshark.so.${KS_VERSION_STRING}"
+                    "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/libkshark.so")
+
+    install(FILES "${KS_DIR}/src/libkshark.h"
+            DESTINATION ${KS_INCLUDS_DESTINATION})
+    install(FILES "${KS_DIR}/src/libkshark-plugin.h"
+            DESTINATION ${KS_INCLUDS_DESTINATION})
+    install(FILES "${KS_DIR}/src/libkshark-model.h"
+            DESTINATION ${KS_INCLUDS_DESTINATION})
+
+endif (_DEVEL)
+
 if (OPENGL_FOUND AND GLUT_FOUND)
 
     message(STATUS "libkshark-plot")
@@ -26,6 +50,20 @@ if (OPENGL_FOUND AND GLUT_FOUND)
 
     set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
 
+    install(TARGETS kshark-plot LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
+
+    if (_DEVEL)
+
+        install_symlink("libkshark-plot.so.${KS_VERSION_STRING}"
+                        "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/libkshark-plot.so")
+
+        install(FILES "${KS_DIR}/src/KsPlotTools.hpp"
+                DESTINATION ${KS_INCLUDS_DESTINATION})
+        install(FILES "${KS_DIR}/src/libkshark-plot.h"
+                DESTINATION ${KS_INCLUDS_DESTINATION})
+
+    endif (_DEVEL)
+
 endif (OPENGL_FOUND AND GLUT_FOUND)
 
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
@@ -77,9 +115,9 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
     add_executable(kshark-record        kshark-record.cpp)
     target_link_libraries(kshark-record kshark-gui)
 
-    install(TARGETS ${KS_APP_NAME} kshark-record kshark kshark-plot kshark-gui
+    install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
             RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
-            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/)
+            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
 
     install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
             DESTINATION ${_INSTALL_PREFIX}/share/applications/)
-- 
2.20.1

