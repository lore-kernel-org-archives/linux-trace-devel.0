Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70336C4727C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AAD02145D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AunuJ9Kw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729971AbgI2Nlu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730077AbgI2Nlu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:41:50 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CC5C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:50 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id w2so4692481wmi.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uS+5BN0qQCxrHNROdqulT/alM50jLxxFwUBjYKYY2ro=;
        b=AunuJ9KwTW80Hnnc+G2V5yWhbn/pujnHT+PAnttRZyhUlS2cVkYrgS2mZeMvU3P7Xv
         XtxGyYrMx2348PuU3Jad2Z83wxlQ1PYK9yFKIFBvGREGCBxZJMbW71gJQsTPfkiECrb8
         1uErG3n/+6/CLtd7fTWGieIT5MrLdDSpZ/qEAtDnRAF1sncYdPRci7zSlpkrS2Eyy9ez
         4WISqNupTFyLGtVob+NeJnORJIrj7pNTM4XBCP98e0mGXTRbZetA9s6gUfPzu3VvVbOT
         IN5lHXwKdUJKylKL/3hIEIzANtdNLXdsTimMKAGRupYOr8j8+z7rwmumwQjVTeRAMPYy
         3ayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uS+5BN0qQCxrHNROdqulT/alM50jLxxFwUBjYKYY2ro=;
        b=OgqqMlteb98Sua0WAFIhNPGMvMTZ2GDE8H0rBK1CHs3np65CH5MkGPyndO6XmQcRhe
         IxjtEjtFdIAG4yMY+cObmjR1AOPVgdaHF8FBh6BJfyo9X7Rsyb0LTYrN4vBKKiZvYb2A
         XurdX1TlYHq0yXAaa74KsGNRWJ4LCA0vCK/ycKsBBxnm6srR8hfqc00szPvenZj3IrBU
         49QkrsZAdwPX8XlSLW2F9876odjherkFd5Ix6gXkbvZCH+72PNYbtU16ycqsNo6YGD/A
         vaf5RvuHUTfvL47G3QbjaASuMMdE2pKaHYYsQiTMvuJrVT+fuE7E5iLAkpjD9jNZm5pa
         xygg==
X-Gm-Message-State: AOAM533RqXdwrhHoKmvr45U4ffumBiZuU4f/fX8epg5JS4moxjMIR9hF
        z8LuMBNBxGsBOPsoOoCy9vI=
X-Google-Smtp-Source: ABdhPJxUuE6sabSjDC0RzSl/gM+Mh+Q6sQ8NbQlBRVY2AiiW4BkQ1fPdpWGupXOLMrs6WUxm5SnCZQ==
X-Received: by 2002:a7b:ca42:: with SMTP id m2mr4804160wml.145.1601386908905;
        Tue, 29 Sep 2020 06:41:48 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id b84sm6162792wmd.0.2020.09.29.06.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:41:48 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 03/15] kernel-shark: Start introducing KernelShark 2.0
Date:   Tue, 29 Sep 2020 16:41:11 +0300
Message-Id: <20200929134123.178688-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929134123.178688-1-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
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
 CMakeLists.txt          | 10 ++++-----
 build/deff.h.cmake      | 14 ++-----------
 examples/CMakeLists.txt | 46 ++++++++++++++++++++---------------------
 src/CMakeLists.txt      |  6 +++---
 4 files changed, 33 insertions(+), 43 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index c95249e..ccca95c 100644
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
index 032f305..8d40e42 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -8,26 +8,26 @@ message(STATUS "datafilter")
 add_executable(dfilter          datafilter.c)
 target_link_libraries(dfilter   kshark)
 
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
index 457c100..2e092b2 100644
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

