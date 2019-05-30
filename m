Return-Path: <SRS0=Uv3S=T6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A54CC28CC0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 May 2019 13:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 745AF2596C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 May 2019 13:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbfE3NQ1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 May 2019 09:16:27 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36444 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfE3NQ1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 May 2019 09:16:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so1145958wrs.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 May 2019 06:16:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ahYYgWHBx2oqLxCL5qOzCwcIs7KGU3jYSe5NcrYtC4o=;
        b=Suq4HTr9I5xwk/xFXrZNgl8GIydM4oDZTDucEMrOdQ1cB1H0JgBv2A1ws6iB7f22ZJ
         fPCiQ2Y2gVRyG1KK2DfAn8MRSJ7HmTGr22w1YiNjuSfIaDlzxuANn0+PHhh3i0zJWDc3
         Qi7138m2pSQVTPZYzGS/768GNJKWL62unYWtuE4Dh40Gi9LCwQqXYsBN6zWeKtFzFpeA
         9ICHBE7Vn6NwkzB6NDMvXntYFAJtkIynSEOaUA6wCfbenRX5pN3UJax+zF3MXNCGbVTi
         UrZAuXG3t8asJ73VyIyFM/Q/fD1+Wd040u0pFHPpzQ7wnv13vXmi6LeqEBax8xKR3RWe
         7yiA==
X-Gm-Message-State: APjAAAX2m7uHcjDCTYjiVtUovalwEKPfjiu+CWeRkNI37lHZD5W33hpF
        2KiFVOM+mPTLaKlU4uUG9TTded7y
X-Google-Smtp-Source: APXvYqwf5WTKSEykxz7Ro7ul6vVJZ4p5yGCD7Jfj6YkiT1IDnj4EHPt0o+Xh7bbBICovLApQkH3fFQ==
X-Received: by 2002:adf:fbc7:: with SMTP id d7mr2449788wrs.224.1559222184766;
        Thu, 30 May 2019 06:16:24 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q15sm2334874wrr.19.2019.05.30.06.16.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 30 May 2019 06:16:24 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/2] kernel-shark: Install public interface headers
Date:   Thu, 30 May 2019 16:15:56 +0300
Message-Id: <20190530131556.21832-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190530131556.21832-1-ykaradzhov@vmware.com>
References: <20190530131556.21832-1-ykaradzhov@vmware.com>
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
 kernel-shark/README                     |  4 ++
 kernel-shark/src/CMakeLists.txt         | 56 ++++++++++++++++++++++---
 kernel-shark/src/plugins/CMakeLists.txt |  3 +-
 3 files changed, 56 insertions(+), 7 deletions(-)

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
index 6cbc00f..36ce884 100644
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
 
+install(TARGETS kshark LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}
+                       COMPONENT core)
+
+if (_DEVEL)
+
+    install_symlink("libkshark.so.${KS_VERSION_STRING}"
+                    "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/libkshark.so")
+
+    install(FILES "${KS_DIR}/src/libkshark.h"
+                  "${KS_DIR}/src/libkshark-plugin.h"
+                  "${KS_DIR}/src/libkshark-model.h"
+            DESTINATION ${KS_INCLUDS_DESTINATION}
+            COMPONENT devel)
+
+endif (_DEVEL)
+
 if (OPENGL_FOUND AND GLUT_FOUND)
 
     message(STATUS "libkshark-plot")
@@ -26,6 +50,21 @@ if (OPENGL_FOUND AND GLUT_FOUND)
 
     set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
 
+    install(TARGETS kshark-plot LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}
+                                COMPONENT core)
+
+    if (_DEVEL)
+
+        install_symlink("libkshark-plot.so.${KS_VERSION_STRING}"
+                        "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/libkshark-plot.so")
+
+        install(FILES "${KS_DIR}/src/KsPlotTools.hpp"
+                      "${KS_DIR}/src/libkshark-plot.h"
+                DESTINATION ${KS_INCLUDS_DESTINATION}
+                COMPONENT devel)
+
+    endif (_DEVEL)
+
 endif (OPENGL_FOUND AND GLUT_FOUND)
 
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
@@ -77,21 +116,26 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
     add_executable(kshark-record        kshark-record.cpp)
     target_link_libraries(kshark-record kshark-gui)
 
-    install(TARGETS ${KS_APP_NAME} kshark-record kshark kshark-plot kshark-gui
+    install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
             RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
-            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/)
+            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}
+            COMPONENT core)
 
     install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
-            DESTINATION ${_INSTALL_PREFIX}/share/applications/)
+            DESTINATION ${_INSTALL_PREFIX}/share/applications/
+            COMPONENT core)
 
     install(FILES "${KS_DIR}/icons/${KS_ICON}"
-            DESTINATION ${_INSTALL_PREFIX}/share/icons/${KS_APP_NAME})
+            DESTINATION ${_INSTALL_PREFIX}/share/icons/${KS_APP_NAME}
+            COMPONENT core)
 
     install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
-            DESTINATION ${_INSTALL_PREFIX}/share/polkit-1/actions/)
+            DESTINATION ${_INSTALL_PREFIX}/share/polkit-1/actions/
+            COMPONENT core)
 
     install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
-            DESTINATION ${_INSTALL_PREFIX}/bin/)
+            DESTINATION ${_INSTALL_PREFIX}/bin/
+            COMPONENT core)
 
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
diff --git a/kernel-shark/src/plugins/CMakeLists.txt b/kernel-shark/src/plugins/CMakeLists.txt
index 6c77179..51f6f65 100644
--- a/kernel-shark/src/plugins/CMakeLists.txt
+++ b/kernel-shark/src/plugins/CMakeLists.txt
@@ -28,6 +28,7 @@ BUILD_PLUGIN(NAME missed_events
 list(APPEND PLUGIN_LIST "missed_events default") # This plugin will be loaded by default
 
 install(TARGETS sched_events missed_events
-        LIBRARY DESTINATION ${KS_PLUGIN_INSTALL_PREFIX})
+        LIBRARY DESTINATION ${KS_PLUGIN_INSTALL_PREFIX}
+        COMPONENT core)
 
 set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
-- 
2.20.1

