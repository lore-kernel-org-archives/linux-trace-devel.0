Return-Path: <SRS0=Fk9f=SG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A795C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Apr 2019 14:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65112205F4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Apr 2019 14:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbfDDO4R (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 10:56:17 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:34847 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727353AbfDDO4Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 10:56:16 -0400
Received: by mail-wm1-f48.google.com with SMTP id y197so3803165wmd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Apr 2019 07:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/FzuVrzS4h3pn+/6VJqfH/y/Fb95rWw0bIS27j5PRuU=;
        b=SMf9AyT5RP3+9IuPAnVJeDFT9KJBWEykfLEZJjIVSf4CYNFcG7PwJkPSroYSbzb3SK
         aMrPwm8sLTYnd5OrtfY2WjEKOZEepZOr8lNC1/vNHzC431myr+iLezSpL0FnGXQGXWSs
         PUyckc9ScZFDoCGbX2bP7XyV/R6Il3auxFfYXwx27pvDVFUwy7YgQdSekQF2GgxyWJbi
         IzD8m7BYx3pTTPizULG+8Ew/iUFqSk/CUSRw+pVrmyYcm08p4D1Cy7Y4njnMS2TGqokj
         ejKML6nl/bh/SHm6W6OrYW8sBItvAlgyGk2AkZRyQK2IOIn4wqzXANB5yTSTOoasJ5sc
         Ac1Q==
X-Gm-Message-State: APjAAAWJrGndxW0yVDTQh+h0Hcbw38blWYiheidJOI4JtTr0OA7h3RkV
        kGjJJ2jdpIP2nKXVE0/pRgydQfQII90=
X-Google-Smtp-Source: APXvYqzJJXznaoWWIJDOVRRM1VpqokvIZF1cJvOPB5nLHyL5h2UNVHOBNpt4kiIKpdLF8BzM0CGo8g==
X-Received: by 2002:a05:600c:2199:: with SMTP id e25mr4292510wme.36.1554389774974;
        Thu, 04 Apr 2019 07:56:14 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id m13sm21919883wmg.42.2019.04.04.07.56.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Apr 2019 07:56:14 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/4] kernel-shark: Configuration information in ${HOME}/.cache/kernelshark
Date:   Thu,  4 Apr 2019 17:56:00 +0300
Message-Id: <20190404145603.13592-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190404145603.13592-1-ykaradzhov@vmware.com>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

By default the "Last session" configuration file will be saved in
${HOME}/.cache/kernelshark

After applying this patch you may need to clean the CMAKE cache.
This can be done by:

    cd kernel-shark/build/;./cmake_clean.sh; cd -
    make gui

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 Makefile                          |  5 ++++-
 kernel-shark/CMakeLists.txt       | 13 ++++++++-----
 kernel-shark/README               |  8 +++++++-
 kernel-shark/build/deff.h.cmake   |  4 ++--
 kernel-shark/src/KsMainWindow.cpp |  4 ++--
 5 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index cde45f8..d9b0c0e 100644
--- a/Makefile
+++ b/Makefile
@@ -254,7 +254,10 @@ all_cmd: $(CMD_TARGETS)
 CMAKE_COMMAND = /usr/bin/cmake
 
 $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
-	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -D_INSTALL_PREFIX=$(prefix) ..
+
+	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) \
+		-D_KS_CACHE_DIR=$(HOME)/.cache/kernelshark \
+		-D_INSTALL_PREFIX=$(prefix) ..
 
 gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 8858eb7..14d73f5 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -12,10 +12,12 @@ message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
 
 set(KS_DIR ${CMAKE_SOURCE_DIR})
 
-# Make a directory to hold configuration files. To change this do:
-# cmake .. -DKS_CONF_DIR=/your/preferred/path
-set(KS_CONF_DIR "${KS_DIR}/.ksconf" CACHE STRING "Directory for configuration files.")
-file(MAKE_DIRECTORY ${KS_CONF_DIR})
+# Make a directory to hold cached configuration files. To change this do:
+# cmake .. -D_KS_CACHE_DIR=/your/preferred/path
+set(_KS_CACHE_DIR "$ENV{HOME}/.cache/kernelshark"
+    CACHE STRING "Directory for cached configuration files.")
+
+file(MAKE_DIRECTORY ${_KS_CACHE_DIR})
 
 include(${KS_DIR}/build/FindTraceCmd.cmake)
 include(${KS_DIR}/build/FindJSONC.cmake)
@@ -66,7 +68,8 @@ include_directories(${KS_DIR}/src/
 message("")
 message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
 message(STATUS "CXX flags    : " ${CMAKE_CXX_FLAGS})
-message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
+message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS}\n)
+message(STATUS "config. files saved in ${_KS_CACHE_DIR}")
 
 add_subdirectory(${KS_DIR}/src)
 add_subdirectory(${KS_DIR}/examples)
diff --git a/kernel-shark/README b/kernel-shark/README
index 9f7db26..a75b08b 100644
--- a/kernel-shark/README
+++ b/kernel-shark/README
@@ -52,8 +52,14 @@ as a CMake Command-Line option.
 2.1.3 By default, installation prefix is "/usr/local". It can be changed using
 -D_INSTALL_PREFIX= as a CMake Command-Line option.
 
-Example:
+2.1.4 By default, the directory that holds cached configuration files is
+${HOME}/.cache/kernelshark/ .It can be changed using -D_KS_CACHE_DIR=
+as a CMake Command-Line option. Use only absolute paths for this option.
+
+
+Examples:
     cmake -D_DOXYGEN_DOC=1 -D_DEBUG=1 -D_INSTALL_PREFIX=/usr ../
+    cmake -D_KS_CACHE_DIR=${PWD}../.kscache ../
 
 2.2.1 Use "make clean" if you want to delete all already compiled objects.
 
diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
index 80d624c..f1f6a35 100644
--- a/kernel-shark/build/deff.h.cmake
+++ b/kernel-shark/build/deff.h.cmake
@@ -14,8 +14,8 @@
 /** KernelShark source code path. */
 #cmakedefine KS_DIR "@KS_DIR@"
 
-/** KernelShark configuration directory path. */
-#cmakedefine KS_CONF_DIR "@KS_CONF_DIR@"
+/** KernelShark cache directory path. */
+#cmakedefine _KS_CACHE_DIR "@_KS_CACHE_DIR@"
 
 /** Location of the trace-cmd executable. */
 #cmakedefine TRACECMD_BIN_DIR "@TRACECMD_BIN_DIR@"
diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 7afb721..d07a89d 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -133,7 +133,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 KsMainWindow::~KsMainWindow()
 {
 	kshark_context *kshark_ctx(nullptr);
-	QString file = KS_CONF_DIR;
+	QString file = _KS_CACHE_DIR;
 
 	file += "/lastsession.json";
 
@@ -370,7 +370,7 @@ void KsMainWindow::_open()
 
 void KsMainWindow::_restoreSession()
 {
-	QString file = KS_CONF_DIR;
+	QString file = _KS_CACHE_DIR;
 	file += "/lastsession.json";
 
 	loadSession(file);
-- 
2.19.1

