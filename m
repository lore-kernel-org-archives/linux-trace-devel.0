Return-Path: <SRS0=G/7s=35=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB8FC2BA83
	for <linux-trace-devel@archiver.kernel.org>; Sun,  9 Feb 2020 03:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8523020838
	for <linux-trace-devel@archiver.kernel.org>; Sun,  9 Feb 2020 03:42:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SBpZPQoG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgBIDmo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 8 Feb 2020 22:42:44 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44329 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgBIDmo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 8 Feb 2020 22:42:44 -0500
Received: by mail-qt1-f195.google.com with SMTP id w8so2592143qts.11
        for <linux-trace-devel@vger.kernel.org>; Sat, 08 Feb 2020 19:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BCxlMOGmgsljZIHVsHnoIG3O8Pe40VqDaaSkPEpw/vg=;
        b=SBpZPQoGfzLK3JfE5doJtWZwghYhBUrBdLt+FbeWEMCxCZM8/GDPIrr0vQZHtz0MIe
         JzSKrIxSidyGCTxmQ0N82RBnffXMLlZbv4v22rwPI2u812dpyui+RqHAovr8bo/nTrcl
         0TNlosJNeVFOhaKODuY0ie8rAGX5sIIStoWZMJww2AcgQH945w6wdIUjsVPBjz2qcZhO
         wfhs5TsPqAJQOF4tue78kEF1Z1e6WvyoKuO37CxxS47SPZqEjadeVKj7Gsd3QHp93RFT
         OVHn/9YaMW+O4BuyDgB+mw/+g3JzGmbIKwIPnJadhtJhn0wwczDqbgYWt6wqVQJaBxFk
         Wt8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BCxlMOGmgsljZIHVsHnoIG3O8Pe40VqDaaSkPEpw/vg=;
        b=fAIVm+e9qVKry9V9Rft5gUH06uxDNeCDzmkvIbiQX4/HnjVnvc6/hEdHAuOWsXw7vx
         1aTOaWVyihHc0vnFYsRjHPmW81l08YmQdkDazuc2Cpe2VaDFXIe1it9aMabsmd/HvuCT
         a+eBZXb6nEVUnmww3PeLUOMaA5urEGayhgKMe2cJBCMJx7AI3Ja7rN59zU7pdkZ6OW7j
         YlBoVnxFiO9wDPxpBh18ClqQPEpPmk6nvY3ytpkgvdHdQ1IXpiws1Pcn7U1RJwd9XLAd
         y3Ax6FYcxCW3BULnQnh4JZGMBi3L1ziW1+pKYRxWB3z2DhJwDYLZV0kio0c5yjSHa5vl
         +EJw==
X-Gm-Message-State: APjAAAUfN4j3xV5Pi0f28SH24ncJvsmatpadn4aBhbG6qifN8XsdGw/B
        zHhTSNoRB+Fa60KmWGkShmg=
X-Google-Smtp-Source: APXvYqy1l4Qe7NxnCznjGsV/eAFhkEH4Ypkm+TCAf5KuzOHA5v/VhsE7Q1l7WE/BHNUN67kKfbBG/A==
X-Received: by 2002:aed:2321:: with SMTP id h30mr5058594qtc.355.1581219763313;
        Sat, 08 Feb 2020 19:42:43 -0800 (PST)
Received: from i7.lan (whoami.aosc.io. [104.224.149.185])
        by smtp.gmail.com with ESMTPSA id g62sm3749947qkd.25.2020.02.08.19.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 19:42:42 -0800 (PST)
From:   sztsian@gmail.com
To:     tz.stoyanov@gmail.com, rostedt@goodmis.org
Cc:     sztsian@gmail.com, linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] KernelShark: Inherit libdir from Makefile
Date:   Sun,  9 Feb 2020 11:42:25 +0800
Message-Id: <20200209034226.287464-2-sztsian@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200209034226.287464-1-sztsian@gmail.com>
References: <20200209034226.287464-1-sztsian@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Ziqian SUN (Zamir)" <sztsian@gmail.com>

The trace-cmd makefile supports install lib into a different name like
lib64. Now this patch implemented the same in kernel-shark.

And in order to make debuginfo also lives in the same file structure,
the compiling dir is changed to reflect libdir and prefix as well.

Signed-off-by: Ziqian SUN (Zamir) <sztsian@gmail.com>
---
 Makefile                        |  2 +-
 kernel-shark/CMakeLists.txt     | 13 +++++++++----
 kernel-shark/src/CMakeLists.txt |  6 +++---
 3 files changed, 13 insertions(+), 8 deletions(-)

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
index 8786b83..6652d08 100644
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
 
@@ -34,8 +38,8 @@ if (Qt5Widgets_FOUND)
 
 endif (Qt5Widgets_FOUND)
 
-set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
-set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
+set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/${_LIBDIR}")
+set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/${_INSTALL_PREFIX}/bin")
 
 set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -pthread -fPIC")
 set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++11 -pthread -fPIC")
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
+SET(CMAKE_INSTALL_RPATH "${_LIBDIR}/${KS_APP_NAME}/")
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

