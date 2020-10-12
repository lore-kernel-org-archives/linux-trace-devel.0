Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31D4C43457
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 833BD2074D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EukK+8ha"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390964AbgJLOFC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730940AbgJLNf7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:35:59 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F33C0613D0
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:35:58 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id i1so13104791wro.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=avAYxea68r9wL9yBzVPbIuHqaqJjz0+4vW6MfyEUjlU=;
        b=EukK+8haEby0dx9hfOToeodZFubkvmbwaq7T6FcBISkCtQaL6gz2ZlAGCRqc8lGs/c
         JK3aYzHHA+vHoIjogo0YbT2PO+lbLXR+UE55JTEhQ4J/52GrFgQak2dyzoFl9sg3y2IM
         KQco4idYgHG4NU5J05KTWG2mfQtEXBlm9xU0MedNEAmqhyxo7emSDwliOz+2emdHydbp
         W7mF2eDAVGMI/gFDC7klB9x68bwMzf2K2kf10n7LeNUoydCTFhCp8dBGMnZ5roJ8c9EU
         EVi94ofzfPGCwIhMsV2nOWVJgczKVs8VuyKwdp4dcjzfK90OB01hG89E2jUWiDtZRlLQ
         p7gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=avAYxea68r9wL9yBzVPbIuHqaqJjz0+4vW6MfyEUjlU=;
        b=KB7LAvMIpandtgcHWl3LLiSaL5pQGD7iahJEs3XeAOZ2NH8p2rElK+gXT0mfB5HRyJ
         zRzBTzZ+Fm+S3JNlq4k3EgftYxLA2TJubunY/2g7wvS1jFCwBEHcr+rwQPXEEgcLipGr
         bO04hQM1QTvzu8QckPU7daoyONf+qPeYrqBVpmhldgRyiu4ywQFf2M9k0I1ThAurhQke
         IFz1zxPNNPMplbdO6FUueHs9SqQEI2uI+uUR0Ncm/Gs20A5RCBbV+Xh1cLTciwaVAvIo
         ClouKmiyFJQgxoIHQfS1UlCwXA+STmXJdiVzeR2GppZOqpgAWRJ4HI6rQF9YSQHH+VQ2
         7yxg==
X-Gm-Message-State: AOAM530TAoPsHZrE/IqW0CmJiFS10ya4fkcm1o6Yk/N2OQwB9HT9ZC+J
        2BaH1WxyUdjqfxvSwLaOhtF4MNrXP8w=
X-Google-Smtp-Source: ABdhPJzZ9URFS+eG8FAtLo6Oj2ynONX4LHlWgPxfJHGtxVJX+FUJ3JtBrGGHhatcauFj7liFf7Oklg==
X-Received: by 2002:a5d:40d2:: with SMTP id b18mr10538147wrq.155.1602509757518;
        Mon, 12 Oct 2020 06:35:57 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:35:57 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 01/20] kernel-shark: Start introducing KernelShark 2.0
Date:   Mon, 12 Oct 2020 16:35:04 +0300
Message-Id: <20201012133523.469040-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012133523.469040-1-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is the very first patch from a series of patches that will
introduce KernelShark 2.0. The new version implies significant
changes in the low level C API, used by the KernelShark GUI. As
a consequence of the API modifications, significant changes are
needed in every source file of the project. Because, we want to
avoid having a huge and ugly single commit that will be extremely
hard to review, we will introduce a regression. We will first
disable the compilation of all sub-components of KernelShark,
except the API itself. This is done by bypassing the search of
the necessary third party components (OpenGL and Qt). Later we
will introduce the changes of the API in several sub-steps and
will re-enable one by one the modified components of the GUI.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt          | 10 ++++----
 build/deff.h.cmake      | 14 ++---------
 examples/CMakeLists.txt | 54 ++++++++++++++++++++---------------------
 src/CMakeLists.txt      |  6 ++---
 4 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index c95249e9..ccca95c1 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -26,12 +26,12 @@ include(${KS_DIR}/build/FindJSONC.cmake)
 
 find_package(Doxygen)
 
-set(OpenGL_GL_PREFERENCE LEGACY)
-find_package(OpenGL)
-find_package(GLUT)
+# set(OpenGL_GL_PREFERENCE LEGACY)
+# find_package(OpenGL)
+# find_package(GLUT)
 
-find_package(Qt5Widgets 5.7.1)
-find_package(Qt5Network)
+# find_package(Qt5Widgets 5.7.1)
+# find_package(Qt5Network)
 if (Qt5Widgets_FOUND)
 
     message(STATUS "Found Qt5Widgets:  (version ${Qt5Widgets_VERSION})")
diff --git a/build/deff.h.cmake b/build/deff.h.cmake
index 79726ff6..e398c0ca 100644
--- a/build/deff.h.cmake
+++ b/build/deff.h.cmake
@@ -23,17 +23,7 @@
 /** "pkexec" executable. */
 #cmakedefine DO_AS_ROOT "@DO_AS_ROOT@"
 
-#ifdef __cplusplus
-
-	#include <QString>
-
-	/**
-	 * String containing semicolon-separated list of plugin names.
-	 * The plugins to be loaded when KernelShark starts are tagged
-	 * with "default".
-	 */
-	const QString plugins = "@PLUGINS@";
-
-#endif /* __cplusplus */
+/** Semicolon-separated list of plugin names. */
+#define KS_BUILTIN_PLUGINS "@PLUGINS@"
 
 #endif // _KS_CONFIG_H
diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index 032f3057..f6ed8978 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -4,30 +4,30 @@ message(STATUS "dataload")
 add_executable(dload          dataload.c)
 target_link_libraries(dload   kshark)
 
-message(STATUS "datafilter")
-add_executable(dfilter          datafilter.c)
-target_link_libraries(dfilter   kshark)
-
-message(STATUS "datahisto")
-add_executable(dhisto          datahisto.c)
-target_link_libraries(dhisto   kshark)
-
-message(STATUS "confogio")
-add_executable(confio          configio.c)
-target_link_libraries(confio   kshark)
-
-message(STATUS "dataplot")
-add_executable(dplot          dataplot.cpp)
-target_link_libraries(dplot   kshark-plot)
-
-if (Qt5Widgets_FOUND)
-
-    message(STATUS "widgetdemo")
-    add_executable(widgetdemo          widgetdemo.cpp)
-    target_link_libraries(widgetdemo   kshark-gui)
-
-    message(STATUS "cmd_split")
-    add_executable(cmd_split           cmd_split.cpp)
-    target_link_libraries(cmd_split    kshark-gui)
-
-endif (Qt5Widgets_FOUND)
+# message(STATUS "datafilter")
+# add_executable(dfilter          datafilter.c)
+# target_link_libraries(dfilter   kshark)
+#
+# message(STATUS "datahisto")
+# add_executable(dhisto          datahisto.c)
+# target_link_libraries(dhisto   kshark)
+#
+# message(STATUS "confogio")
+# add_executable(confio          configio.c)
+# target_link_libraries(confio   kshark)
+#
+# message(STATUS "dataplot")
+# add_executable(dplot          dataplot.cpp)
+# target_link_libraries(dplot   kshark-plot)
+#
+# if (Qt5Widgets_FOUND)
+#
+#     message(STATUS "widgetdemo")
+#     add_executable(widgetdemo          widgetdemo.cpp)
+#     target_link_libraries(widgetdemo   kshark-gui)
+#
+#     message(STATUS "cmd_split")
+#     add_executable(cmd_split           cmd_split.cpp)
+#     target_link_libraries(cmd_split    kshark-gui)
+#
+# endif (Qt5Widgets_FOUND)
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 457c1007..2e092b2e 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -2,9 +2,9 @@ message("\n src ...")
 
 message(STATUS "libkshark")
 add_library(kshark SHARED libkshark.c
-                          libkshark-model.c
+#                           libkshark-model.c
                           libkshark-plugin.c
-                          libkshark-configio.c
+#                           libkshark-configio.c
                           libkshark-collection.c)
 
 target_link_libraries(kshark ${TRACECMD_LIBRARY}
@@ -99,7 +99,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
-add_subdirectory(plugins)
+# add_subdirectory(plugins)
 
 find_program(DO_AS_ROOT pkexec)
 
-- 
2.25.1

