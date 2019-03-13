Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30314C4360F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0892420643
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfCMPWv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:22:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40498 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbfCMPWv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 11:22:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id g20so2278487wmh.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Mar 2019 08:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tQevJRRUFASCuExjPBPCtEpKTIB4DClt89m6t1aOYpM=;
        b=WuryOzPMk9BYqXee9Iy/s1W8ARYGDP9DQFTZidruHrCti3hld7qt8fnQOi2dAaGzza
         m4OxNuahdm+vkYGIWnJXwGTwqqwJnZXIJjOvhbYJWmNrjTkYfKf05iG3Sa2Gw03HM4Vl
         YljrrTwg8F7UNJ3hnVEElnyvrwfrfAO7Zf7qaL+AsIHXVlR67fXLiqcQO7eTo/1IXoPL
         Zkxm/GVuNe/UElQmP0Yk5kKPxOyh8LvneEuoYX4Vm6HUPVyzBWlBkE+5/yYMpQ3P0ESn
         hPCdjvrLiUmXHC7QAUrux9Tq3hnY2lHpStTlQ0ZzOG7m6kK3TegsuMAcd+dkJ/XeyEbg
         oLNw==
X-Gm-Message-State: APjAAAWktH5+uvdNjRfpTvuk+BqPtGkpneH4w+g3Mfj1vQEapG/Pf4eX
        yEtgA3wO/G0dS14ZldK9b/E=
X-Google-Smtp-Source: APXvYqxELE9myarokPI3/boZzHRQp6TQMCt5vkYqXdnt6BYTntoRQvV3HVh59FXp/PxjRoc9StuZQA==
X-Received: by 2002:a1c:cb86:: with SMTP id b128mr2660607wmg.46.1552490569644;
        Wed, 13 Mar 2019 08:22:49 -0700 (PDT)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id w10sm20775822wrn.32.2019.03.13.08.22.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 08:22:49 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 2/3] kernel-shark: Configuration information in ${HOME}/.cache/kernelshark
Date:   Wed, 13 Mar 2019 17:22:19 +0200
Message-Id: <20190313152220.22026-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190313152220.22026-1-ykaradzhov@vmware.com>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
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
 Makefile                          |  2 +-
 kernel-shark/CMakeLists.txt       | 13 ++++++++-----
 kernel-shark/build/deff.h.cmake   |  4 ++--
 kernel-shark/src/KsMainWindow.cpp |  4 ++--
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/Makefile b/Makefile
index b780718..4cebd00 100644
--- a/Makefile
+++ b/Makefile
@@ -254,7 +254,7 @@ all_cmd: $(CMD_TARGETS)
 CMAKE_COMMAND = /usr/bin/cmake
 
 $(kshark-dir)/build/Makefile: $(kshark-dir)/CMakeLists.txt
-	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) ..
+	$(Q) cd $(kshark-dir)/build && $(CMAKE_COMMAND) -DKS_CACHE_DIR=$(HOME)/.cache/kernelshark ..
 
 gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build
diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 20ced14..c3743b4 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -12,10 +12,12 @@ message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
 
 set(KS_DIR ${CMAKE_SOURCE_DIR})
 
-# Make a directory to hold configuration files. To change this do:
-# cmake .. -DKS_CONF_DIR=/your/preferred/path
-set(KS_CONF_DIR "${KS_DIR}/.ksconf" CACHE STRING "Directory for configuration files.")
-file(MAKE_DIRECTORY ${KS_CONF_DIR})
+# Make a directory to hold cached configuration files. To change this do:
+# cmake .. -DKS_CACHE_DIR=/your/preferred/path
+set(KS_CACHE_DIR "$ENV{HOME}/.cache/kernelshark"
+    CACHE STRING "Directory for cached configuration files.")
+
+file(MAKE_DIRECTORY ${KS_CACHE_DIR})
 
 include(${KS_DIR}/build/FindTraceCmd.cmake)
 include(${KS_DIR}/build/FindJSONC.cmake)
@@ -59,7 +61,8 @@ include_directories(${KS_DIR}/src/
 message("")
 message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
 message(STATUS "CXX flags    : " ${CMAKE_CXX_FLAGS})
-message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
+message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS}\n)
+message(STATUS "config. files saved in ${KS_CACHE_DIR}")
 
 add_subdirectory(${KS_DIR}/src)
 add_subdirectory(${KS_DIR}/examples)
diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
index 80d624c..56b37da 100644
--- a/kernel-shark/build/deff.h.cmake
+++ b/kernel-shark/build/deff.h.cmake
@@ -14,8 +14,8 @@
 /** KernelShark source code path. */
 #cmakedefine KS_DIR "@KS_DIR@"
 
-/** KernelShark configuration directory path. */
-#cmakedefine KS_CONF_DIR "@KS_CONF_DIR@"
+/** KernelShark cache directory path. */
+#cmakedefine KS_CACHE_DIR "@KS_CACHE_DIR@"
 
 /** Location of the trace-cmd executable. */
 #cmakedefine TRACECMD_BIN_DIR "@TRACECMD_BIN_DIR@"
diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 8ac19a7..d832f3f 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -133,7 +133,7 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 KsMainWindow::~KsMainWindow()
 {
 	kshark_context *kshark_ctx(nullptr);
-	QString file = KS_CONF_DIR;
+	QString file = KS_CACHE_DIR;
 
 	file += "/lastsession.json";
 
@@ -370,7 +370,7 @@ void KsMainWindow::_open()
 
 void KsMainWindow::_restorSession()
 {
-	QString file = KS_CONF_DIR;
+	QString file = KS_CACHE_DIR;
 	file += "/lastsession.json";
 
 	loadSession(file);
-- 
2.19.1

