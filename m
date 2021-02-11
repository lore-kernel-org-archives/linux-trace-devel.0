Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E49BC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 364FD64E9A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:39:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhBKKih (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhBKKfp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:35:45 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282BFC06121C
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:37 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id f14so9257129ejc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q0x7OzHuHGLt4vm+vDXFtc2NcFBhXSQjvX9kEj5iZvE=;
        b=LS8ENm3nHcPJlWDndpWaVkCOaI/gCE1oMygjCMkPG05OPzgGReF/YwqB5q3ebprzX2
         q1hqPpLQb5WuRn3VL1ktpMc3v42s4lSMB/OZP8SrNvSRi8v4AA5XFZNGoRA3HRqcrKTv
         r2J/HVuF6/gto2RayhBTQAGa+yOrz3wSWVjf92xgNIfgeQsBtZV4ffNPXXgTlU/kKDB8
         8C2FNrFGBWlr9b359qduNlQcdv7GFCCTIpxHr8KFuPr4b8q9yTucxHGOi2oyYqqUajk+
         hPh8u/47PV+IdMMwdSaZo3QfjSEeh3lxKHtSwvQFtKe+6U1OTgYhX0NsdeyA0QZNyGlL
         vVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q0x7OzHuHGLt4vm+vDXFtc2NcFBhXSQjvX9kEj5iZvE=;
        b=XP+MfJc/PWaALBP+hwzVLmRpRtZdHvWkaRAX9rvzfqtHJMHtViKGluF+66nJYSzvMB
         rdpJTVSjbKc1GTk5YG+TonH2o5bphC/mSgrM9llGcd4bkKfDcN/4wUXa3G+OmwiIU5PB
         6cD1rV9fiNr9CGy7tcZvIRYvu5Xmlp33IyTRPOICH4xcektNdZLEPnJ0ZZmEEDEqg92p
         Tx9hiDYoO43zW44N46cyohM78r/c2Uc8dgXtkLupdude8dTp7PxOLNz4lp1w6JXak4Ma
         WIgEYCr+Bjr99cd2gd84y39Qw1vRC+KvxsKX4Az3NfNaW7N7JCO8mKJXmyBPDMGAIpzH
         nY+g==
X-Gm-Message-State: AOAM5327+TbEka+tJuPb1LIcSstY9KsOOzizjgK0X0cTR124dg6JlPkn
        KFRkzOdkx+Pm8kDtKs9uzk0=
X-Google-Smtp-Source: ABdhPJzhTbvtO4ZwrmPQsre5rqtAsDFI18VHHvME1k3pO9MoICY6ZIObN4CZS3O2FXh1Pr4zGymsOg==
X-Received: by 2002:a17:906:7687:: with SMTP id o7mr7948000ejm.209.1613039555927;
        Thu, 11 Feb 2021 02:32:35 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:35 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 15/27] kernel-shark: Search for font with Cmake at pre-build
Date:   Thu, 11 Feb 2021 12:31:53 +0200
Message-Id: <20210211103205.418588-16-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Being able to load the Truetype font is compulsory for the functioning
of the visualization, hence the font must be considered as critical
external dependency. Add a search for the font file next to the search
of the other third party dependencies and have this file added as
definition in the Cmake-generated header file. This way we do not need
to search for the font every time when we open KernelShark.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .github/workflows/main.yml |  1 +
 CMakeLists.txt             | 14 ++++++++++++++
 README                     |  1 +
 build/deff.h.cmake         |  3 +++
 examples/CMakeLists.txt    |  4 ++--
 src/CMakeLists.txt         |  4 ++--
 tests/CMakeLists.txt       | 22 +++++++++++++---------
 tests/libkshark-tests.cpp  |  9 +++++++++
 8 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/.github/workflows/main.yml b/.github/workflows/main.yml
index 2cce624..4125354 100644
--- a/.github/workflows/main.yml
+++ b/.github/workflows/main.yml
@@ -19,6 +19,7 @@ jobs:
         sudo apt-get update
         sudo apt-get install build-essential git cmake libjson-c-dev -y
         sudo apt-get install freeglut3-dev libxmu-dev libxi-dev -y
+        sudo apt-get install fonts-freefont-ttf
         sudo apt-get install qtbase5-dev libboost-all-dev -y
         git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
         cd libtraceevent
diff --git a/CMakeLists.txt b/CMakeLists.txt
index b9b947e..8ca33fd 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -49,6 +49,20 @@ set(OpenGL_GL_PREFERENCE LEGACY)
 find_package(OpenGL)
 find_package(GLUT)
 
+set(KS_FONT FreeSans)
+execute_process(COMMAND  bash "-c" "fc-list '${KS_FONT}' |grep ${KS_FONT}.ttf | cut -d':' -f 1 -z"
+                OUTPUT_VARIABLE TT_FONT_FILE)
+
+if (TT_FONT_FILE)
+
+  message(STATUS "Found font: ${TT_FONT_FILE}")
+
+else (TT_FONT_FILE)
+
+  message(WARNING "\nCould not find font ${KS_FONT}!\n")
+
+endif (TT_FONT_FILE)
+
 find_package(Qt5Widgets 5.7.1)
 find_package(Qt5Network)
 if (Qt5Widgets_FOUND)
diff --git a/README b/README
index d7efd96..a7e66df 100644
--- a/README
+++ b/README
@@ -12,6 +12,7 @@ KernelShark has the following external dependencies:
 1. In order to install the packages on Ubuntu do the following:
     sudo apt-get install build-essential git cmake libjson-c-dev -y
     sudo apt-get install freeglut3-dev libxmu-dev libxi-dev -y
+    sudo apt-get install fonts-freefont-ttf
     sudo apt-get install qtbase5-dev -y
 
 1.1 I you want to be able to generate Doxygen documentation:
diff --git a/build/deff.h.cmake b/build/deff.h.cmake
index 423a2fd..06cbf16 100644
--- a/build/deff.h.cmake
+++ b/build/deff.h.cmake
@@ -26,6 +26,9 @@
 /** GLUT has been found. */
 #cmakedefine GLUT_FOUND
 
+/** Truetype font file. */
+#cmakedefine TT_FONT_FILE "@TT_FONT_FILE@"
+
 /** Qt - old version detected. */
 #cmakedefine QT_VERSION_LESS_5_11
 
diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index e6af5f2..bc17635 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -24,7 +24,7 @@ message(STATUS "dataplot")
 add_executable(dplot          dataplot.cpp)
 target_link_libraries(dplot   kshark-plot)
 
-if (Qt5Widgets_FOUND)
+if (Qt5Widgets_FOUND AND TT_FONT_FILE)
 
     message(STATUS "widgetdemo")
     add_executable(widgetdemo          widgetdemo.cpp)
@@ -34,4 +34,4 @@ if (Qt5Widgets_FOUND)
     add_executable(cmd_split           cmd_split.cpp)
     target_link_libraries(cmd_split    kshark-gui)
 
-endif (Qt5Widgets_FOUND)
+endif (Qt5Widgets_FOUND AND TT_FONT_FILE)
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 140fed8..6c02d82 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -63,7 +63,7 @@ if (OPENGL_FOUND)
 
 endif (OPENGL_FOUND)
 
-if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
+if (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
 
     message(STATUS "libkshark-gui")
     set (ks-guiLib_hdr  KsUtils.hpp
@@ -134,7 +134,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
             DESTINATION ${_INSTALL_PREFIX}/bin/
                 COMPONENT                 kernelshark)
 
-endif (Qt5Widgets_FOUND AND Qt5Network_FOUND)
+endif (Qt5Widgets_FOUND AND Qt5Network_FOUND AND TT_FONT_FILE)
 
 add_subdirectory(plugins)
 set(PLUGINS ${PLUGINS} PARENT_SCOPE)
diff --git a/tests/CMakeLists.txt b/tests/CMakeLists.txt
index 28f711b..1814c72 100644
--- a/tests/CMakeLists.txt
+++ b/tests/CMakeLists.txt
@@ -38,13 +38,17 @@ add_test(NAME              "libkshark_tests"
          COMMAND           ${KS_TEST_DIR}/kshark-tests --log_format=HRF
          WORKING_DIRECTORY ${KS_TEST_DIR})
 
-add_executable(kshark-gui-tests          libkshark-gui-tests.cpp)
-target_include_directories(kshark-gui-tests PRIVATE ${Boost_INCLUDE_DIRS})
-target_compile_definitions(kshark-gui-tests PRIVATE "BOOST_TEST_DYN_LINK=1")
-target_link_libraries(kshark-gui-tests   kshark-gui
-                                     ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
+if (Qt5Widgets_FOUND AND TT_FONT_FILE)
 
-message(STATUS "libkshark-gui_tests")
-add_test(NAME              "libkshark-gui_tests"
-         COMMAND           ${KS_TEST_DIR}/kshark-gui-tests --log_format=HRF
-         WORKING_DIRECTORY ${KS_TEST_DIR})
+    add_executable(kshark-gui-tests          libkshark-gui-tests.cpp)
+    target_include_directories(kshark-gui-tests PRIVATE ${Boost_INCLUDE_DIRS})
+    target_compile_definitions(kshark-gui-tests PRIVATE "BOOST_TEST_DYN_LINK=1")
+    target_link_libraries(kshark-gui-tests   kshark-gui
+                          ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
+
+    message(STATUS "libkshark-gui_tests")
+    add_test(NAME              "libkshark-gui_tests"
+             COMMAND           ${KS_TEST_DIR}/kshark-gui-tests --log_format=HRF
+             WORKING_DIRECTORY ${KS_TEST_DIR})
+
+endif (Qt5Widgets_FOUND AND TT_FONT_FILE)
diff --git a/tests/libkshark-tests.cpp b/tests/libkshark-tests.cpp
index a22c1e5..5f7c88a 100644
--- a/tests/libkshark-tests.cpp
+++ b/tests/libkshark-tests.cpp
@@ -435,3 +435,12 @@ BOOST_AUTO_TEST_CASE(readout_plugins)
 
 	kshark_free(kshark_ctx);
 }
+
+BOOST_AUTO_TEST_CASE(check_font_found)
+{
+#ifdef TT_FONT_FILE
+BOOST_REQUIRE(true);
+#else
+BOOST_REQUIRE(false);
+#endif
+}
-- 
2.25.1

