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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BFC4C35647
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 13:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BCA024653
	for <linux-trace-devel@archiver.kernel.org>; Fri, 21 Feb 2020 13:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CwYZKz6m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgBUN5c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 08:57:32 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46943 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728672AbgBUN5b (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 08:57:31 -0500
Received: by mail-pg1-f193.google.com with SMTP id y30so991839pga.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Feb 2020 05:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pp0eLxzVqy54eCu69GTHRshbNtaB4nYiZHkafIfn9II=;
        b=CwYZKz6m/al7qM5hTgFR/ENvqQb99zM+wDzIjNxzgJAid59dK4mVfYV2AbiU7ISX/9
         rwTyD8gFHGEEnm7bxf3XyaVMoovfo893BGsPmsc/G/GN6bKhcuwIiieDjKie3UpjtqON
         85Dj2F3JjOVAwj/fIBoJYubDf9PspmzlifuMAY4ZneOiHnaHDSmXuVnSMIeOdFuNktQ/
         ot8aEDhINfzyJzlWqSL7UEybE7QoPrC3CETYv93J9lTpWCSCmcJFacv8lapSJxVexxQ3
         p+2PnRgQoNIkY/IHR+ZMsjOtHmkocRd4qiD5eJ36hSU3Ysl/TuJeeODcJnLFwv2w1oKw
         s1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pp0eLxzVqy54eCu69GTHRshbNtaB4nYiZHkafIfn9II=;
        b=I9YCYS0EehEp57Imm7eWoR1pZmErir8AK1WpOvvGgbYM9WdABuZUT1rnk3NylalHIK
         tk4CryvSZViF1h13oOdZsCVSkIByKEszqe4AyABMZ5dU4Pz1HEbFG4HbXdrrbtsDNIl7
         dmf9JqWLiFid474yta4lAH+k6r14kNs/zCB4kr+T+nV9Clj3gAOYK+qVtY870p5hki7P
         y3Y0+BHOdfo2F6dwir15u2cGVZRUClTyA4cYVHRR//EGeSdEA/LveVQcfic9n1dPzNb7
         roaVe9ltIQkRD3dqpPHAC8wo3mz3cgpkbT1XgoQ0a79Mss/hQ0mIL3A0SzFb9xteMmbu
         u72w==
X-Gm-Message-State: APjAAAU0mCAV4CSvrUtYE0z8jNg3inY8brh12GPGi0DPjihNUWsW20hN
        /nrfI7WcotEv5HaVywMeOKvD29ITCog=
X-Google-Smtp-Source: APXvYqxFFkmjKwXs3Ftn0RvpiKuzUfHC6HYGsoKYJ4+A/Ioaud8w3enR4SASsoMUcZEWzMLRBKGfDg==
X-Received: by 2002:a63:e007:: with SMTP id e7mr37989057pgh.414.1582293450997;
        Fri, 21 Feb 2020 05:57:30 -0800 (PST)
Received: from i7.zsun.org.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x26sm3075970pfq.55.2020.02.21.05.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 05:57:30 -0800 (PST)
From:   sztsian@gmail.com
To:     y.karadz@gmail.com, rostedt@goodmis.org
Cc:     sztsian@gmail.com, linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] KernelShark: Inherit libdir from Makefile
Date:   Fri, 21 Feb 2020 21:57:13 +0800
Message-Id: <20200221135713.323958-1-sztsian@gmail.com>
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

Change since v2: Drop the change of LIBRARY_OUTPUT_PATH as well

Change since v1: Drop the change of EXECUTABLE_OUTPUT_PATH and fix set
command to lower case.

Signed-off-by: Ziqian SUN (Zamir) <sztsian@gmail.com>
---
 Makefile                        | 2 +-
 kernel-shark/CMakeLists.txt     | 8 ++++++--
 kernel-shark/src/CMakeLists.txt | 6 +++---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index a3facaa..2f9620e 100644
--- a/Makefile
+++ b/Makefile
@@ -297,7 +297,7 @@ CMAKE_COMMAND = /usr/bin/cmake
 BUILD_TYPE ?= RelWithDebInfo
 
 $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
-	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) ..
+	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -D_INSTALL_PREFIX=$(prefix) -D_LIBDIR=$(libdir) ..
 
 gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 8786b83..1c9ac2e 100644
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
 
@@ -54,14 +58,14 @@ if (NOT CMAKE_CXX_FLAGS_PACKAGE)
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

