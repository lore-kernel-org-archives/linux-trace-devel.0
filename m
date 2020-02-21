Return-Path: <SRS0=rBiU=4J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C91B8C35646
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 12:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AACD2073A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 12:42:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tVWD3xG3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgBUMm3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 07:42:29 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38286 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBUMm3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 07:42:29 -0500
Received: by mail-pf1-f193.google.com with SMTP id x185so1150642pfc.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Feb 2020 04:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YUU2NmdvCbfRSfGvF8cllcXbfi+7IY5/0mt6ImMgFhg=;
        b=tVWD3xG3ZjK5CBWcY457U/OSeksy9AWeavhv1w4IwDHbhhE4Jei95nhLbZIGulfHYB
         Sryfy3hoaBJN7TI1NjU4sZ11AOHJz7p9xZ4zf0ecaEsvMJHVRfC9CD3wXic8VLrL9HoE
         OVioZtye5OMNKEfF13WitEKrqOUiPnQNnStHwAzP/fYLc0pd9cJ/3hqbh7UyWW0h1lQG
         AmyjC17CFnoNQT2rl4bC6BQ9FjBdt0+bkSzU2RFQ/Dsbz2Vd3F6psCNvEi6MR4oWaUY3
         97kOm/i4NLPXlQmhNrPe8f3WZe0vtQRSftLNevK5agEuAxIpPW76ni0FZtqJsIJV4F3n
         ZaMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YUU2NmdvCbfRSfGvF8cllcXbfi+7IY5/0mt6ImMgFhg=;
        b=j7Mqc1Nbw5E+4q2LF911Rb2V56vq12KHYUwBjhD1npKC+XF3y6GspiLNibaPOPBiVa
         cuLcF2/HswJuk6FLR3c/P1LNlDbqVfyQwzx8rlI7zdj30Z4chMgT3cxmkR7D3alAaxBE
         p9TGikAhgEUTPIkhtvX5henL6GP5PnBzfPDkN87uAlv+2LkAVqGj9hp1Wwje9xa1Ykem
         rvsmOpG6jnKelBaKs4FexoF+SpfuGe1u/wOhljWaRh0z1VB2+pJM3MXeZk8eFICTzM7D
         PCq10i7kPEVz0u7BA0AG6Q2mNhkecEXa8jNOzCbvSTtxg4WIqx6NJqFA5oOE3ZmLyExF
         amNw==
X-Gm-Message-State: APjAAAUVa4po10scJlLKCEvD1wZ7Op0xWtiOW09d8UrgWqg7dKaNKLSo
        iFRjJEIZt+KVGVAH4u3Gfa/gqueqzXY=
X-Google-Smtp-Source: APXvYqxuE/cS15G2eGKEJoTv47CxMpLg5CS5oBcD9ag0wQvAciuqQtAgsTOMBg81Sg+Xyeqg3AZTyA==
X-Received: by 2002:a62:7b93:: with SMTP id w141mr38320781pfc.226.1582288948434;
        Fri, 21 Feb 2020 04:42:28 -0800 (PST)
Received: from i7.zsun.org.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v8sm2586794pgt.52.2020.02.21.04.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 04:42:27 -0800 (PST)
From:   sztsian@gmail.com
To:     y.karadz@gmail.com, rostedt@goodmis.org
Cc:     sztsian@gmail.com, linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] KernelShark: Inherit libdir from Makefile
Date:   Fri, 21 Feb 2020 20:42:04 +0800
Message-Id: <20200221124204.318917-1-sztsian@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Ziqian SUN (Zamir)" <sztsian@gmail.com>

The trace-cmd makefile supports install lib into a different name like
lib64. Now this patch implemented the same in kernel-shark.

Change since v1: Drop the change of EXECUTABLE_OUTPUT_PATH and fix set
command to lower case.

Signed-off-by: Ziqian SUN (Zamir) <sztsian@gmail.com>
---
 Makefile                        |  2 +-
 kernel-shark/CMakeLists.txt     | 11 ++++++++---
 kernel-shark/src/CMakeLists.txt |  6 +++---
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index d75f143..1aca807 100644
--- a/Makefile
+++ b/Makefile
@@ -295,7 +295,7 @@ CMAKE_COMMAND = /usr/bin/cmake
 BUILD_TYPE ?= RelWithDebInfo
 
 $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
-	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) ..
+	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) -D_LIBDIR=$(libdir) ..
 
 gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 8786b83..c60d29b 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -17,6 +17,10 @@ if (NOT _INSTALL_PREFIX)
     set(_INSTALL_PREFIX "/usr/local")
 endif (NOT _INSTALL_PREFIX)
 
+if (NOT _LIBDIR)
+    set(_LIBDIR "${_INSTALL_PREFIX}/lib")
+endif (NOT _LIBDIR)
+
 include(${KS_DIR}/build/FindTraceCmd.cmake)
 include(${KS_DIR}/build/FindJSONC.cmake)
 
@@ -34,7 +38,7 @@ if (Qt5Widgets_FOUND)
 
 endif (Qt5Widgets_FOUND)
 
-set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
+set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/${_LIBDIR}")
 set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 
 set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
@@ -54,14 +58,15 @@ if (NOT CMAKE_CXX_FLAGS_PACKAGE)
     set(CMAKE_CXX_FLAGS_PACKAGE "-O3")
 endif (NOT CMAKE_CXX_FLAGS_PACKAGE)
 
-set(KS_PLUGIN_INSTALL_PREFIX ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/plugins/)
+set(KS_PLUGIN_INSTALL_PREFIX ${_LIBDIR}/${KS_APP_NAME}/plugins/)
 
 set(KS_ICON        KS_icon_shark.svg)
 set(KS_ICON_FIN    KS_icon_fin.svg)
 set(KS_LOGO        KS_logo_symbol.svg)
 set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
 
-set(CMAKE_INSTALL_RPATH "${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/")
+set(CMAKE_INSTALL_RPATH "${_LIBDIR}/${KS_APP_NAME}/")
+
 
 if (CMAKE_BUILD_TYPE MATCHES Package)
 
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index 33b5db8..9666b18 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -15,7 +15,7 @@ target_link_libraries(kshark ${TRACEEVENT_LIBRARY}
 
 set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
 
-install(TARGETS kshark LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
+install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
 
 if (OPENGL_FOUND AND GLUT_FOUND)
 
@@ -29,7 +29,7 @@ if (OPENGL_FOUND AND GLUT_FOUND)
 
     set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
 
-    install(TARGETS kshark-plot LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME})
+    install(TARGETS kshark-plot LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
 
 endif (OPENGL_FOUND AND GLUT_FOUND)
 
@@ -85,7 +85,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
     install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
             RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
-            LIBRARY DESTINATION ${_INSTALL_PREFIX}/lib/${KS_APP_NAME}/)
+            LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME}/)
 
     install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
             DESTINATION ${_INSTALL_PREFIX}/share/applications/)
-- 
2.24.1

