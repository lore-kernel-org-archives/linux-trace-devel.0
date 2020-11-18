Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 761B4C5519F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00B66246F3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HZI/RYLj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgKROug (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 09:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgKROug (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 09:50:36 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3095C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:35 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id 1so2978826wme.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fjaCgtvw6wV0fV1PpUZmz1DG9eabe5qIoWkkkrrOjQQ=;
        b=HZI/RYLjKTxQWRI3TYdoS8Baz8tMcokB+wUT2C0hLbCouLX9OOH9dhFSFRI4CipaXQ
         FPz0JEkUcdeIaAfssCQ8QIdfXQFqyhly+CQmAg9oNB3T+U+Bgdnb4QHjnap9Rn8bWjWn
         nhJtbLy76De0cR01BzvqFfr/a8U8TvnR8SsgFNF7zALDCx8My8L5LhUKSQBoZtuxCazK
         AXi4+8pfAgDMZ/gqQ9FuBmGMFDcU0QHB5qFHLa7ClZw8PpCCx0mBFzJHYmOSN38+rjEs
         rpI6UCZIyPex5qoKSqVr5Sb3hFL3kc/f4UbIXHuTqlO7cIddAiA89CeL1v12ZlaHnafr
         5DQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fjaCgtvw6wV0fV1PpUZmz1DG9eabe5qIoWkkkrrOjQQ=;
        b=DI1cCzt5dzDZtwhh91tz3UyuA4TCzonsMo/6O8dxco+ZWgS6hFbE63BTx3yy8aOCQW
         YpjtVpV2Hi6Iy2tHOrAKEDfxfamOVDRLyrRFYp0+PQJRWw3btUGzpKIDkHpapwKkgINV
         YSUcUAJ5I1e2nysD17weLCj4gGjzQRxoXVnyT5haydqi/CLLXVjUM0TnhfEZE4pZG473
         x1Y80g1Gf3hFBGr1NxX6JGHwjIhss+riZhxpatYTYxVWy1YhXSagpSm5G7CeEbUXMA+f
         0VSg2Xv6sR9h3Vtx2RishTlB67P2yjF6yn5VhHRGo4jSqJbPg1oH+aPj5uW7BjY1C0yJ
         Zd8w==
X-Gm-Message-State: AOAM532INQi30KXPq5PxlrEbvhuAQL9DbChjCTvcIb2QyE6CcKupLyJT
        +KnRozEB6ls1E006RjT7oUA=
X-Google-Smtp-Source: ABdhPJz05wjGCXf9fcT6WWvKIj/uGG06sF7JgUdLuHVehomaQd8IyVsoLcgSs//58MB95UDp+xaYeQ==
X-Received: by 2002:a1c:4884:: with SMTP id v126mr428619wma.160.1605711034435;
        Wed, 18 Nov 2020 06:50:34 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id s202sm3926190wme.39.2020.11.18.06.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 06:50:33 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 09/20] kernel-shark: Start introducing KernelShark 2.0
Date:   Wed, 18 Nov 2020 16:49:52 +0200
Message-Id: <20201118145003.156542-10-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201118145003.156542-1-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is the very first patch from a series of patches that will
introduce KernelShark 2.0. The new version will take advantage
of the definition of Data streams and will imply significant
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
index 4d4f37b1..2bdab1a5 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -3,10 +3,10 @@ message("\n src ...")
 message(STATUS "libkshark")
 add_library(kshark SHARED libkshark.c
                           libkshark-hash.c
-                          libkshark-model.c
+#                           libkshark-model.c
                           libkshark-plugin.c
                           libkshark-tepdata.c
-                          libkshark-configio.c
+#                           libkshark-configio.c
                           libkshark-collection.c)
 
 target_link_libraries(kshark ${TRACECMD_LIBRARY}
@@ -101,7 +101,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
-add_subdirectory(plugins)
+# add_subdirectory(plugins)
 
 find_program(DO_AS_ROOT pkexec)
 
-- 
2.25.1

