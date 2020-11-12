Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1977C56201
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CB562224B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VkvfJjee"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgKLOYa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgKLOY3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 09:24:29 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3EAC0613D4
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:29 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id 23so6277080wmg.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fjaCgtvw6wV0fV1PpUZmz1DG9eabe5qIoWkkkrrOjQQ=;
        b=VkvfJjeekCQ/pHCw4xIiyu22AqueZJy/gsn5igT+bRLiSwcGLPiy78ZzcwV2voUKuW
         gT6MEq+Ca/4uSwNzqfEk/ZaONRWv52lShbPS3mfKwYynTx4X3aca16YAezt1kDq27xpT
         gg1VvdP8blvSfPeo65D1imhZqH3tbe8tdn2FlJWbVkQzvRVmwqIP1RlaV0XtbEQbMGyD
         rHimANdpQ56z3AxAZ+53qyoQRPvp8NS38m4DXMpGHQk7i4tdK9x8pJbG4bXJ17hmUk9Y
         kfuOXhhuDMUf1qd6x4B0hO/QZjXqWxMBTFye13zCwh0kRlNTt9LUbJn0bVYMGhLtucLN
         A0Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fjaCgtvw6wV0fV1PpUZmz1DG9eabe5qIoWkkkrrOjQQ=;
        b=KZGOlp/t0mfcGk6oS9mqpbvpM0XaNwBtfRyKtFh8tVQ2vbH1h5O2Q9ABfhtMdrclE5
         Sxa4dgcCUuu/1v3p2Kdsif/o2gQ82rIqche1iJ3F5DmTk8KIPTkakX+s4Tz1YsMP1ZAv
         PAGc/d2LpgeE7TwZBkLx5pazvkdpCC9yAjFfQO/HdSMHtgzl346JzrvxvNmX04xSnuqa
         sSULVhpsgH0o5SJDhKKYlTjSVLiLlz04gueeWJ/7cxh9fcr6Vm+5JQ4A4n1ePzQQ/AP2
         jEpkgrp9rKNqu7DhwfJTCBzivSL62ZNveIcobTB8X51aRUQh1G78nda0MJV1sfgTMVX4
         Xd/w==
X-Gm-Message-State: AOAM531bsLIM6uf0v06WXmAsFgujFHf1G5/qcTqxYXFPXdh1uFl2KBn0
        rVYTkLtpFJQIdhTflECn+/cs8vkxk7w=
X-Google-Smtp-Source: ABdhPJwfEFN+aB7FPxWvXwCc6wYIAanJWsj6qJa/8Dk4PuXLdzUDD/PuCUWtIazsWFvce23UVYwkHw==
X-Received: by 2002:a1c:5f45:: with SMTP id t66mr9366512wmb.132.1605191067851;
        Thu, 12 Nov 2020 06:24:27 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id h15sm6950685wrw.15.2020.11.12.06.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 06:24:27 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 09/20] kernel-shark: Start introducing KernelShark 2.0
Date:   Thu, 12 Nov 2020 16:23:47 +0200
Message-Id: <20201112142358.36821-10-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112142358.36821-1-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
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

