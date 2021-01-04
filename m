Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1960EC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB5D2216C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbhADRs6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbhADRs6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:48:58 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CDFC06179A
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:47:43 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id j16so28229185edr.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bBJzBc1VWa6muzHjFVaPIDr6CrRz3Ngm8w3deLRJEMI=;
        b=ha50D0aukPjG4aoLUnb17yPxEzwQ2IMU6ID8hNSj6rCjLDvyg+TjjV+qVQIIMKwTAB
         9ma3PZvX4iFmk3UbSIa5dRnN80Iva3ifbDmYWxQbXaXFXUKqFEQNAHUfu9IHexgmL9Bu
         i/NtLre4Hu9EXI8wmfosuZ5jgS4G/IFNyQ5iO4w9Sa1Akr3+wZzsCJZRG3FvzwJU1CBU
         UAxBF12QTmXJqdjsQkMydelrGHLNLcdi6xvSoK4seIHBdW7usFH427zrdXT0wUsLPPnu
         VoZLWSrZV0i7C12AW1PnLpU2TUvvCR7V6LjPZ+YAKRcqoAzDOmGIN8rhHXFsjE8gsHjB
         h1yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bBJzBc1VWa6muzHjFVaPIDr6CrRz3Ngm8w3deLRJEMI=;
        b=uIWiIzBLgI37omnQWQbjJ7TlB8u8BzfDod00NvZdzLGUT8akCbGtPT+BwlAHY7shc/
         4H3wU0P6HS/d93pcqnA2O9DiVVOfJfbbRMrr33vf4GsgoNwXH/4ErdOrosy6klRM1Td9
         jH8bFN6txEp7a0Nl218nJLMuvMKei1Lpifl5UfV+MPkefWS+kgCzseTwKYGdz0vx3AkE
         rM3woALnwZ1LBrxWmtl+lN/A9OKbFZ2onp2akprmqUHvtFZTJ6LNXTLYXpKgNf5nrwtJ
         j1kJSiKq9HkpANhoBKNG2kOQnT0XPGF+IRxkdOjf0nr1spgq7rTOiSj7ic3NkbJ6QS+5
         bxmg==
X-Gm-Message-State: AOAM530N043z2+XanYHqjlQvEy67OHk0HJK79CbMbNH9FW1gMcpJ4XNF
        mNzDcp9o2Sb/NewDBjZWD0E=
X-Google-Smtp-Source: ABdhPJxdw8CkY5ehw4WI0imLOjM7mi0uTELuEpThH6NSB1bBHhq45E97fh6C43C64xxgFyCIgM0i6w==
X-Received: by 2002:a50:d685:: with SMTP id r5mr73894325edi.248.1609782462724;
        Mon, 04 Jan 2021 09:47:42 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:47:42 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 06/44] kernel-shark: Split the installation in two components
Date:   Mon,  4 Jan 2021 19:46:46 +0200
Message-Id: <20210104174724.70404-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The user can choose to install only the KernelShark GUI via
"install_gui.sh". It is also possible to install the library headers
and this can be done via "install_libkshark-devel.sh".

The changes implemented in this patch are inspired by the talk
"Deep CMake For Library Authors" presented at CppCon 2019 by Craig Scott.
https://crascit.com/2019/10/16/cppcon-2019-deep-cmake-for-library-authors/

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt                   |  2 +-
 build/cmake_uninstall.sh         | 23 ++++++++++----
 build/install_gui.sh             |  1 +
 build/install_libkshark-devel.sh |  1 +
 src/CMakeLists.txt               | 53 ++++++++++++++++++++++++++------
 src/plugins/CMakeLists.txt       |  3 +-
 6 files changed, 65 insertions(+), 18 deletions(-)
 create mode 100755 build/install_gui.sh
 create mode 100755 build/install_libkshark-devel.sh

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 76dd84a..2e970c3 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -84,7 +84,7 @@ set(KS_ICON_FIN    KS_icon_fin.svg)
 set(KS_LOGO        KS_logo_symbol.svg)
 set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
 
-set(CMAKE_INSTALL_RPATH "${_LIBDIR}")
+set(CMAKE_INSTALL_RPATH "${_LIBDIR}" "$ORIGIN")
 set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
 
 if (CMAKE_BUILD_TYPE MATCHES Package)
diff --git a/build/cmake_uninstall.sh b/build/cmake_uninstall.sh
index ae9eab5..0d93a8d 100755
--- a/build/cmake_uninstall.sh
+++ b/build/cmake_uninstall.sh
@@ -4,14 +4,25 @@ CYAN='\e[36m'
 PURPLE='\e[35m'
 NC='\e[0m' # No Color
 
+uninstall () {
+    NAME=$1
+    NAME=${NAME##*_}
+    NAME=${NAME%.*}
+    NAME=${NAME/manifest/the project}
+    if [ -e $1 ]
+    then
+        echo -e "${CYAN}Uninstall " $NAME"...${NC}"
+        xargs rm -v < $1
+        rm -f $1
+    fi
+}
+
 if [[ $EUID -ne 0 ]]; then
    echo -e "${PURPLE}Permission denied${NC}" 1>&2
    exit 100
 fi
 
-if [ -e install_manifest.txt ]
-then
-    echo -e "${CYAN}Uninstall the project...${NC}"
-    xargs rm -v < install_manifest.txt
-    rm -f install_manifest.txt
-fi
+for manifest in "$search_dir"${PWD}/install_manifest*
+do
+   uninstall $manifest
+done
diff --git a/build/install_gui.sh b/build/install_gui.sh
new file mode 100755
index 0000000..1583fb9
--- /dev/null
+++ b/build/install_gui.sh
@@ -0,0 +1 @@
+sudo cmake -DCOMPONENT=kernelshark -P cmake_install.cmake
diff --git a/build/install_libkshark-devel.sh b/build/install_libkshark-devel.sh
new file mode 100755
index 0000000..a7e420d
--- /dev/null
+++ b/build/install_libkshark-devel.sh
@@ -0,0 +1 @@
+sudo cmake -DCOMPONENT=libkshark-devel -P cmake_install.cmake
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 25c372b..d51e5ee 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -1,5 +1,7 @@
 message("\n src ...")
 
+set(KS_INCLUDS_DESTINATION "${_INSTALL_PREFIX}/include/${KS_APP_NAME}")
+
 message(STATUS "libkshark")
 add_library(kshark SHARED libkshark.c
                           libkshark-model.c
@@ -13,9 +15,25 @@ target_link_libraries(kshark trace::cmd
                              ${JSONC_LIBRARY}
                              ${CMAKE_DL_LIBS})
 
-set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
+set_target_properties(kshark  PROPERTIES
+                                  SOVERSION ${KS_VERSION_MAJOR}
+                                  VERSION   ${KS_VERSION_STRING})
+
+
+install(TARGETS kshark
+        LIBRARY DESTINATION    ${_LIBDIR}
+            COMPONENT              kernelshark
+            NAMELINK_COMPONENT     libkshark-devel
+        INCLUDES DESTINATION   ${_INSTALL_PREFIX}/include/${KS_APP_NAME}
+            COMPONENT              libkshark-devel
+        ARCHIVE DESTINATION    ${_LIBDIR}
+            COMPONENT              libkshark-devel)
 
-install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR})
+install(FILES "${KS_DIR}/src/libkshark.h"
+              "${KS_DIR}/src/libkshark-model.h"
+              "${KS_DIR}/src/libkshark-plugin.h"
+        DESTINATION ${KS_INCLUDS_DESTINATION}
+            COMPONENT libkshark-devel)
 
 if (OPENGL_FOUND AND GLUT_FOUND)
 
@@ -27,9 +45,18 @@ if (OPENGL_FOUND AND GLUT_FOUND)
                                        ${GLUT_LIBRARY}
                                        ${OPENGL_LIBRARIES})
 
-    set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
+    set_target_properties(kshark-plot PROPERTIES
+                                          SOVERSION ${KS_VERSION_MAJOR}
+                                          VERSION   ${KS_VERSION_STRING})
 
-    install(TARGETS kshark-plot LIBRARY DESTINATION ${_LIBDIR})
+    install(TARGETS kshark-plot
+            LIBRARY DESTINATION    ${_LIBDIR}
+                COMPONENT              kernelshark
+                NAMELINK_COMPONENT     libkshark-devel
+            INCLUDES DESTINATION   ${_INSTALL_PREFIX}/include/${KS_APP_NAME}
+                COMPONENT              libkshark-devel
+            ARCHIVE DESTINATION    ${_LIBDIR}
+                COMPONENT              libkshark-devel)
 
 endif (OPENGL_FOUND AND GLUT_FOUND)
 
@@ -81,21 +108,27 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
     target_link_libraries(kshark-record kshark-gui)
 
     install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
-            RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
-            LIBRARY DESTINATION ${_LIBDIR})
+            RUNTIME DESTINATION       ${_INSTALL_PREFIX}/bin/
+                COMPONENT                 kernelshark
+            LIBRARY DESTINATION       ${_LIBDIR}
+                COMPONENT                 kernelshark)
 
     install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
-            DESTINATION ${_INSTALL_PREFIX}/share/applications/)
+            DESTINATION ${_INSTALL_PREFIX}/share/applications/
+                COMPONENT                 kernelshark)
 
     install(FILES "${KS_DIR}/icons/${KS_ICON}"
                   "${KS_DIR}/icons/${KS_ICON_FIN}"
-            DESTINATION ${_INSTALL_PREFIX}/share/icons/${KS_APP_NAME})
+            DESTINATION ${_INSTALL_PREFIX}/share/icons/${KS_APP_NAME}
+                COMPONENT                 kernelshark)
 
     install(FILES "${KS_DIR}/org.freedesktop.kshark-record.policy"
-            DESTINATION /usr/share/polkit-1/actions/)
+            DESTINATION /usr/share/polkit-1/actions/
+                COMPONENT                 kernelshark)
 
     install(PROGRAMS "${KS_DIR}/bin/kshark-su-record"
-            DESTINATION ${_INSTALL_PREFIX}/bin/)
+            DESTINATION ${_INSTALL_PREFIX}/bin/
+                COMPONENT                 kernelshark)
 
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index 6c77179..2da73f8 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -28,6 +28,7 @@ BUILD_PLUGIN(NAME missed_events
 list(APPEND PLUGIN_LIST "missed_events default") # This plugin will be loaded by default
 
 install(TARGETS sched_events missed_events
-        LIBRARY DESTINATION ${KS_PLUGIN_INSTALL_PREFIX})
+        LIBRARY DESTINATION ${KS_PLUGIN_INSTALL_PREFIX}
+        COMPONENT kernelshark)
 
 set(PLUGINS ${PLUGIN_LIST} PARENT_SCOPE)
-- 
2.25.1

