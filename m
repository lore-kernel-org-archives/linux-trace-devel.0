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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4CFC433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A38FC20715
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbhADRs6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbhADRs6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:48:58 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316FAC061798
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:47:43 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id i24so28215632edj.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yLWJrmcmsw/Q4BjbHxuxlypKW9YjouYM3r+4oORK2iI=;
        b=u1dBPuYAKNv2v4MBH9y/wIdrYqmzaLg+0QiQWB6mRzN9HhHgBXBZpNnvpgN46/mCOF
         L5bxJqHjM0X3TVyL+6uwcFhZ1Nicxtmw9/RjjgkoQd3ZVgRiC0Exsg3MxiHq8TdLKUqQ
         jdoVSVqGiLmKSIoa5FleSmd3SH5mAEltz+V+pjb49P5e2YxwSuusUczZjfU79dBseCpa
         c28PgpYRKjuh1yXLZ9UtdhXBbbo98/48d1Oo/VOgJxoJgSl1z/F7icien01+tIEDz4It
         +qiEnUt//n0FjM8PYJpXWYPS4CgWSKTRQi6NQSIid+VQVWcYRT/b/TOIaA5MZA/+zme3
         9gAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yLWJrmcmsw/Q4BjbHxuxlypKW9YjouYM3r+4oORK2iI=;
        b=fifVcFlXWD/FPKQse4rPce4sIoJtdHjNIhyHvHJ9ZSMPq5aI6qnCgGzUGmhtMEXlNM
         3nJKI0Ut2vAKX2hVjPjRCrSTnXbwsTsp+QSeYrWPWmfw6n8i4hT9vx9b5InbmgXmV/Nm
         M/Dj7FDmmwBTvYOmXwtE/W1RORPzq+2fcLeNY87y2ulFYXNk78Wx6ZNnVmi9Ukhptg59
         eqPX5eyUMQeFKSM6DVxXUqFG+sz1DbkIDqAU4k/KJUafS2wYoYJwF4ldOFh2hE78W1nA
         71Pvs/1duiCnWquZPVsENr28xwvtyiUcVb14n7p2le83omCXxaPUItDE5imVpNcsQR8l
         Yahg==
X-Gm-Message-State: AOAM530p7jqozBRsMw1PyY4Vo3wy5JGKoIZpHx+TGjWLhzv7CMxoxBCW
        vfuz2N0NTja7XNC/TQGgPBs=
X-Google-Smtp-Source: ABdhPJyWJB/Svu/gE7Vwo4dhvH4T+hjKyyLdx05VbrEx5o8SJsT0nQTtpJ+dkt08x2IWHH8dWaDOEA==
X-Received: by 2002:a05:6402:139a:: with SMTP id b26mr72372139edv.47.1609782461838;
        Mon, 04 Jan 2021 09:47:41 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:47:41 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 05/44] kernel-shark: Change default libraries install location
Date:   Mon,  4 Jan 2021 19:46:45 +0200
Message-Id: <20210104174724.70404-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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
index d75f179..76dd84a 100644
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
@@ -69,7 +84,8 @@ set(KS_ICON_FIN    KS_icon_fin.svg)
 set(KS_LOGO        KS_logo_symbol.svg)
 set(KS_LOGO_LABEL  KS_logo_horizontal.svg)
 
-set(CMAKE_INSTALL_RPATH "${_LIBDIR}/${KS_APP_NAME}/")
+set(CMAKE_INSTALL_RPATH "${_LIBDIR}")
+set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
 
 if (CMAKE_BUILD_TYPE MATCHES Package)
 
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 7663d44..25c372b 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -15,7 +15,7 @@ target_link_libraries(kshark trace::cmd
 
 set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
 
-install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
+install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR})
 
 if (OPENGL_FOUND AND GLUT_FOUND)
 
@@ -29,7 +29,7 @@ if (OPENGL_FOUND AND GLUT_FOUND)
 
     set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
 
-    install(TARGETS kshark-plot LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
+    install(TARGETS kshark-plot LIBRARY DESTINATION ${_LIBDIR})
 
 endif (OPENGL_FOUND AND GLUT_FOUND)
 
@@ -82,7 +82,7 @@ if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
     install(TARGETS ${KS_APP_NAME} kshark-record kshark-gui
             RUNTIME DESTINATION ${_INSTALL_PREFIX}/bin/
-            LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME}/)
+            LIBRARY DESTINATION ${_LIBDIR})
 
     install(FILES "${KS_DIR}/${KS_APP_NAME}.desktop"
             DESTINATION ${_INSTALL_PREFIX}/share/applications/)
-- 
2.25.1

