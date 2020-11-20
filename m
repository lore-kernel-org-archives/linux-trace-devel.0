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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B19EC64E69
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22B3E223B0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JnNpelWf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgKTJne (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgKTJnd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:43:33 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EF5C061A04
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:33 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id y4so8848402edy.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fjaCgtvw6wV0fV1PpUZmz1DG9eabe5qIoWkkkrrOjQQ=;
        b=JnNpelWfNQg6e/mw8OqzYSj2lcM/iGXfjQFQWNbhDCOLladPb/rboIRPh3A0u83O5i
         2JkfePYudKeGQ3GJVMM25V2hqb9+j3/xoa9dV+kHAhGlN19n76P90Z4Cxui9DBEo0GeN
         R9HCA1lVb6pLCTKRayq5WhEWW1nWK/umEPGx3Ktkx7//0tFYqKLpyh/cfB6BQ5J8tLdO
         RCmEGZ4/4HL5OeNwvBzi17yc5uRzwQNCjYveK0dAX3+iZucrEYa/yo3hf1whvxT/APXj
         DkNHTgry0R7OqZIWkIDRZhvniYmlz9suDgMBJvmUcDlDgXGnbLtCLApOJk1jNIjd3nvv
         Obgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fjaCgtvw6wV0fV1PpUZmz1DG9eabe5qIoWkkkrrOjQQ=;
        b=uC6meUE2HJDFLlbZfwysIGZGFyt8MNerd27ikrwu/mcw8IfVNH4AqJN9NYGht5RmUi
         wxgu+8hXpVSTZ3WYizYqhz/KHIldOMqqIc4D6tv79e8+WMKYktG8QjqLY4QTaff//EZ7
         aev/5pwNhKPUz27g13DC6KSXUrD86O9a22s9ypt3i4O17MHzPPPQSwgVMpCijeJlsVKX
         ByryzZmawrRHEsuktvCfRIW1ObpjE4WyFXqAKSTR4wdF66QKMqOl0QYLJPDS0kRqyuFb
         lvHdf+hwg2XXZsLY9UoEdQo7moTP6IlGvBn5PxH5y9UKX6Vr3uR3PYipieStqgQb75UJ
         XStg==
X-Gm-Message-State: AOAM5331myrx285PfAEmfjRp6sScs8vgj5r7F0SxWyKp6oRV/H/CUzfX
        HHiFcrZM3igdyvjZ1mXew5k=
X-Google-Smtp-Source: ABdhPJwTXCdsn5lLTRqE6nfvMDm5xjXE0hkBI4fJnXahsRP4yAYn2gZMyfj+/5i0VFPnlodmJoHa9Q==
X-Received: by 2002:aa7:da8f:: with SMTP id q15mr8975431eds.229.1605865411913;
        Fri, 20 Nov 2020 01:43:31 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id h2sm897006ejx.55.2020.11.20.01.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:43:31 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 09/20] kernel-shark: Start introducing KernelShark 2.0
Date:   Fri, 20 Nov 2020 11:42:53 +0200
Message-Id: <20201120094304.271502-10-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120094304.271502-1-y.karadz@gmail.com>
References: <20201120094304.271502-1-y.karadz@gmail.com>
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

