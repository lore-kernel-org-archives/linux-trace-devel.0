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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4D3C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D947F20715
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbhADRti (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbhADRti (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:38 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A540C0617AA
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:47:54 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id d17so37831005ejy.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XynZx8mlfSH4Iv0AtOqnkf6GHN6nsdOTeoSDbCbk7WY=;
        b=doGinOIi2FOq0OJhd3678pSRt7ekSiIX2SwCHg2BOy2a2nT1o/eTbS2f6aw6irD5sC
         fWd+NZe2D/joZVCN9DJDH7sfFaDqWnCL1pzsEQeeZyxcbvqADsA7GkzS6avaanPBqwK9
         yI6dHqS4WDet9SN+H8WZoMj2V5ypI9ATcsSeKjjOWQpsj3J7SL1CVKm12WR7ffJ4Vw0H
         rDZwmpfGFIh3s/VTAnMdPhv8fOXwYWGOaFILrdnhJhNSMF56qTKv3DwQ7eNFPgWx0+UM
         AxwGEdtejbpohLz7BRRalTHcPh1+2OUeBSIlLgcubJGflxS9zUlAMV9Oj+CxkoQ8No1K
         9xMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XynZx8mlfSH4Iv0AtOqnkf6GHN6nsdOTeoSDbCbk7WY=;
        b=ksGjmm2dDsTiewDfXkZZhuodoYlu0dVQHHyD6mVfqvZf5Du8fgRwJOc88D0eLhVYTq
         RFPFXHUc21XDdaGxo8wY6Wqu0wm6RVSJEvINAtYEopOxnHnN2I+bTTzjG80Ff8OiPQ/F
         b6tTwWDhFfWdaCtlgsUgId+ds0qrA/smVrRPSqf25dXEmewrJkx+c5lUjuzgypC2LW7a
         2/8e6vW0OHYZNlVkm1aSW35Ukvhyte5pZOW4wAcBSRxocAUJklcrEzhQjW0qW7TT2mK+
         WTsUt9LpQfczbskLZbyESyBBbb4PksICCjolPHJjOGKthnnl9tun/SeXk+hnnEt4dGMu
         cYiA==
X-Gm-Message-State: AOAM532mQTUsJEBvZiz2gHGPIeLf6MUOQlxQwekJmkPlRemeMy5c1pN2
        uME8gOxO1r88mnF/C6WCCI8=
X-Google-Smtp-Source: ABdhPJxoF83zPG0kTOi5xNSnRxsTTSKiK9lIZTKK5wIXehW3GuzNCEknhZbCaskIthuGNZd1BeRKbg==
X-Received: by 2002:a17:906:6693:: with SMTP id z19mr65715780ejo.376.1609782473073;
        Mon, 04 Jan 2021 09:47:53 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:47:52 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 17/44] kernel-shark: Start introducing KernelShark 2.0
Date:   Mon,  4 Jan 2021 19:46:57 +0200
Message-Id: <20210104174724.70404-18-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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
index f21d734..cac2fa6 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -45,12 +45,12 @@ find_package(JSONC      REQUIRED)
 
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
index 79726ff..e398c0c 100644
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
index 032f305..f6ed897 100644
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
index ce82d30..fac1d5e 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -5,10 +5,10 @@ set(KS_INCLUDS_DESTINATION "${_INSTALL_PREFIX}/include/${KS_APP_NAME}")
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
 
 target_link_libraries(kshark trace::cmd
@@ -134,7 +134,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
 endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
-add_subdirectory(plugins)
+# add_subdirectory(plugins)
 
 find_program(DO_AS_ROOT pkexec)
 
-- 
2.25.1

