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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEEE6C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 15:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99E5222C7C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 15:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbhAEPzu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Jan 2021 10:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbhAEPzu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Jan 2021 10:55:50 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D1CC061796
        for <linux-trace-devel@vger.kernel.org>; Tue,  5 Jan 2021 07:55:09 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id h16so609024edt.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Jan 2021 07:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k9VlewqD6Kum8oxQTseU3WP7mcm9thefyxkzRj4BMQs=;
        b=PtboCqwYKFfxvUZeHKXH1ViTk+VbKhF+jL/fE7lUaDezg6C4KqT9Ae3zIoWFccL4mi
         uny9T/nh+WL8tjDUwE4ElnDVp2f7hNnIkEUZuhp/8zYfigmpXiIy2nGps/FXVllOZhm1
         qz6TiyrFdE6BY70mc/Adr1ONuew223Iz16PGzO2cHMWpOuqO/SfpAYbXHL13+j3yOmS8
         TZXSx1PA3BJTbhoRcP3lzWMNerAUo2RE9/6sjcgzr4ZJM0DNDZ0eD6NHpdOundsWFcNP
         TNXtYyBkOh5fXG/2ratHUbBBZFEGxOtZQNwd+S3RGEJmGLgLghkHZYprJWnw0rfsim38
         qGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k9VlewqD6Kum8oxQTseU3WP7mcm9thefyxkzRj4BMQs=;
        b=HD/I55Gd+2nKoW2uR0wbiMgFWdCyOCKF0cNdAkJaM7PLsKOrwc6JCufEj/yyDwH74o
         XJ3K6mbPyrZB0nUONZWpCdE2IqCYBevMzNI2j5Gu/Yv9jOJTEqxCZRjB6AVqsloAFs1Z
         F9sPyEiNW/flnUpf+hBq2DuyCBzfiruAxYhR7Y1AWp3cS8b4IEjACpiKJKF0LGpP68/a
         4LkKU975kBkSjAQfWbqP1n2wWoY2tH4c5xcBWSj1JAicG+eotrERHh7e4MUCv12n5i8h
         usfLfLumtGtynIwnMwPcDCZKzKL0dlmPiYow7H9GtYMzdQhoOTXKPH3evNvrJpbEkwrt
         2HRQ==
X-Gm-Message-State: AOAM531btzgTgMquhh1w292p3z++c84fJlhH14Hpcpsg1NSFDAViInFy
        PZk+la51VCcDm/F3DKdgWK4=
X-Google-Smtp-Source: ABdhPJx6akOVQCBm6TAB78GNHn2h+BpjV1VZEQTX8JFEahPTK5NNYaTzwaQ3kR20yYbLAOVpbUP1QQ==
X-Received: by 2002:a05:6402:1c90:: with SMTP id cy16mr375531edb.73.1609862108357;
        Tue, 05 Jan 2021 07:55:08 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id t12sm45367882edy.49.2021.01.05.07.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 07:55:07 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/5] kernel-shark: Change default libraries install location
Date:   Tue,  5 Jan 2021 17:54:51 +0200
Message-Id: <20210105155453.41228-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210105155453.41228-1-y.karadz@gmail.com>
References: <20210105155453.41228-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The default installation path for the KernelShark libraries changes from
/usr/local/lib/kernelshark/ to /usr/local/lib64 (or /usr/local/lib on
32 but systems). This is done in order to be consistent with the install
locations of libtraceevent, libtracefs and libtracecmd.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt     | 28 ++++++++++++++++++++++------
 src/CMakeLists.txt |  6 +++---
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 59bbe72..543d7da 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -13,13 +13,28 @@ message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
 
 set(KS_DIR ${CMAKE_SOURCE_DIR})
 
-if (NOT _INSTALL_PREFIX)
+execute_process(COMMAND bash "-c" "echo __LP64__ | ${CMAKE_C_COMPILER} -E -x c - | tail -n 1"
+                OUTPUT_VARIABLE __LP64__)
+
+if (NOT _INSTALL_PREFIX AND NOT _LIBDIR)
+
     set(_INSTALL_PREFIX "/usr/local")
-endif (NOT _INSTALL_PREFIX)
 
-if (NOT _LIBDIR)
-    set(_LIBDIR "${_INSTALL_PREFIX}/lib")
-endif (NOT _LIBDIR)
+    if (__LP64__ MATCHES 1)
+        set(_LIBDIR "/usr/local/lib64")
+    else (__LP64__ MATCHES 1)
+        set(_LIBDIR "/usr/local/lib")
+    endif (__LP64__ MATCHES 1)
+
+elseif (NOT _INSTALL_PREFIX)
+
+    set(_INSTALL_PREFIX "/usr/local")
+
+elseif (NOT _LIBDIR)
+
+   set(_LIBDIR "${_INSTALL_PREFIX}/lib")
+
+endif ()
 
 set(CMAKE_MODULE_PATH "${KS_DIR}/build")
 find_package(TraceEvent REQUIRED)
@@ -71,7 +86,8 @@ set(KS_ICON_FIN    KS_icon_fin.svg)
 set(KS_LOGO        KS_logo_symbol.svg)
 set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
 
-set(CMAKE_INSTALL_RPATH "${_LIBDIR}/${KS_APP_NAME}/")
+set(CMAKE_INSTALL_RPATH "${_LIBDIR}")
+set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
 
 if (CMAKE_BUILD_TYPE MATCHES Package)
 
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index b393468..fe3a3eb 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -17,7 +17,7 @@ target_link_libraries(kshark trace::cmd
 
 set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
 
-install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
+install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR})
 
 if (OPENGL_FOUND)
 
@@ -31,7 +31,7 @@ if (OPENGL_FOUND)
 
     set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
 
-    install(TARGETS kshark-plot LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
+    install(TARGETS kshark-plot LIBRARY DESTINATION ${_LIBDIR})
 
 endif (OPENGL_FOUND)
 
@@ -84,7 +84,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
     install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
             RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
-            LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME}/)
+            LIBRARY DESTINATION ${_LIBDIR})
 
     install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
             DESTINATION ${_INSTALL_PREFIX}/share/applications/)
-- 
2.25.1

