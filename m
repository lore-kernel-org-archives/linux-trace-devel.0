Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11933C433E6
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 15:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5D0F22BF5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 15:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbhAEPzv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Jan 2021 10:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbhAEPzv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Jan 2021 10:55:51 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD556C061798
        for <linux-trace-devel@vger.kernel.org>; Tue,  5 Jan 2021 07:55:10 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id b9so555063ejy.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Jan 2021 07:55:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h8maH0/7C6vhTfpgbPu1SQ5CGs+hRtNyW9R3dPCIHu4=;
        b=GjY7YxfTWy8dg80R+sblTnoESX/YTehwRO7Gc0PN4BcjJHVK9c+MP6N2Plo8yTGlS9
         YiAWGqK5M8HBEp9xtC4BLhrhl8MmAOb0gmiB+gA9zV+RNxoX0BOTsdUeqLLLLChjoxWM
         o5lC4CdHLTmJNFCkw+27au82fGnJzze5sy9uZT1MMkpcP/fIzUhMxvoscp31o3Yk2Kxv
         +YA8tBegH8WtxtDZDRKW3W/uRvcj6PAbDU/JS3pE7QRn6lSCKshLRI76c+OwUpdauew9
         lml50XH9+oOPtbelHqzTGZW89GuvhDLAenQe1eiHHWaYYthqZXqTkqp8It0MkOIZ4JUl
         f8jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h8maH0/7C6vhTfpgbPu1SQ5CGs+hRtNyW9R3dPCIHu4=;
        b=H03BC20ciIcT9a+o4GokaEs6muGYDFy/+/RbY20dYkPzgHdkbK9VC4SIJDtMOBYV2x
         c3xDrzM07fHALG7GQjxzBw7ctxTOzfM0IlscSBohytuXMloK6p0HVFGXvaaBK4rSsd22
         oLViwggKr1u2Up8XmLjsOJqMwzBZQSGNGbBxezvzEmnA/jrNR1YhUtMqHJ379p2hwFtw
         5vDbO+OWRVGZjTeNHId+lv9cEZX6LnyzMmXIuT3QJ5J0uMnn5faTodj240rmRikDYtxZ
         BJmFxsOxZJZOUZ7yt8AOCWrBDh/m+0pUYihdWh7uXQq+HWL1VfBp+btyjZ9zTTskOLs+
         J7iA==
X-Gm-Message-State: AOAM531AudP05HhjzfJEMrMhp1tYXS1QZV1gm45VUdMn5aNySkjALZTI
        8FgCkqhwt9mDLtPpc+UUmS0=
X-Google-Smtp-Source: ABdhPJwBBOU6IU7uNcAI9FQoOHFzC2Z6U4bPduND1NbyI92yVLGHf6Ajl1kTZrAXHvJt8cZzUj24jg==
X-Received: by 2002:a17:906:7b8d:: with SMTP id s13mr70550570ejo.479.1609862109575;
        Tue, 05 Jan 2021 07:55:09 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id t12sm45367882edy.49.2021.01.05.07.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 07:55:09 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/5] kernel-shark: Split the installation in two components
Date:   Tue,  5 Jan 2021 17:54:52 +0200
Message-Id: <20210105155453.41228-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210105155453.41228-1-y.karadz@gmail.com>
References: <20210105155453.41228-1-y.karadz@gmail.com>
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
index 543d7da..9abacd0 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -86,7 +86,7 @@ set(KS_ICON_FIN    KS_icon_fin.svg)
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
index fe3a3eb..e35b436 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -1,5 +1,7 @@
 message("\n src ...")
 
+set(KS_INCLUDS_DESTINATION "${_INSTALL_PREFIX}/include/${KS_APP_NAME}")
+
 message(STATUS "libkshark")
 add_library(kshark SHARED libkshark.c
                           libkshark-hash.c
@@ -15,9 +17,25 @@ target_link_libraries(kshark trace::cmd
                              jsonc::jsonc
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
 
 if (OPENGL_FOUND)
 
@@ -29,9 +47,18 @@ if (OPENGL_FOUND)
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
 
 endif (OPENGL_FOUND)
 
@@ -83,21 +110,27 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
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

