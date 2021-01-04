Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437BAC4332B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 216A020715
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbhADRtn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727475AbhADRtm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:42 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113AFC061384
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:09 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id q22so37959648eja.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N18nqDVkTO7oT7I2PPf6G5+lJnx0aQoNQBe98h8pNrA=;
        b=SuQKydeYpLk7bn56pg7/YPjvbnVlKg7OBgXHJ1q6j5a/vu2hfndOMivz5PgWIyEfiD
         GsdXcLsQFBBzdDXY1El6Pw54e6QsqHzh8fqowu1QQ0NoSKFKOh5OLimCK2J/ovPvV1yM
         1Jt+Goxx0VCQOc/fVD026Yse3yXM1qTy8A2PTT93KARldQrNkqvjpBRFN+den1AcQfn+
         tOvXDJBLovpwLA+bpXyq6B4A2lVIi4cieaTRckaEBF1WVeTYaDmpuheA9eif+Wfdu+Fr
         FslZw6hJf9PfrM5uttTpaEMiZ1mc9A98IlNY5vbaekfaKU1ah1ayLvTgb7lnYi+ObAAb
         LunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N18nqDVkTO7oT7I2PPf6G5+lJnx0aQoNQBe98h8pNrA=;
        b=CKoMgGytJNnio8jQWfQhRZ2u5IOQLpKxe6PD90xT/UL4U4DDwdeq/OczhtSxm/Bp7I
         BFzrXvZNKFBpmNcc+SVPqk+rF2K6DQYOL81GFwOlytm5KyZXrnpv4lv5Hu7GJIOz8GwQ
         0hHGA5bcimkcCl/3P/PATEHali11pfUEeRV4cMsOoeXtHX1SnguuE/Mfzx3Vwuj844Xr
         OWNOiVNg7rBMXm5VgoKv0pdmaUPCT5vhDgMul7QvgoJuy2umzBp4pXJewNAWH+x6Cjdb
         KAYXND/n+VjLkgQBCA+fJdSEv1sDihH4e4zhWeZZNz00z+ALNcStIPQ3Yy4iaSHmqhNZ
         0JIA==
X-Gm-Message-State: AOAM532nSmVhdhDQCdu50m1lh24SkW5aWR0ODCKvTW/eb0PRTTIvO6uL
        LDeoz+Tr8BXZt8CF+T4xfG8=
X-Google-Smtp-Source: ABdhPJyU7+qSUfMN8JvSyEMQBu0cpmR1O2TzjImC5U2q0AL1bGrepErsmDu+P61pMw+On2haJ7wjGQ==
X-Received: by 2002:a17:906:4e46:: with SMTP id g6mr48772668ejw.243.1609782487852;
        Mon, 04 Jan 2021 09:48:07 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:07 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 30/44] kernel-shark: Make GLUT optional dependency
Date:   Mon,  4 Jan 2021 19:47:10 +0200
Message-Id: <20210104174724.70404-31-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

GLUT is not needed in order to build the KernelShark GUI. Currently
it is being used only by the plotting example, so it makes more sense
to removed it from the list of compulsory third party packages.
The patch optimizes the way the OpenGL and GLUT headers are included
and removes some duplicated code.

Signen-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 build/deff.h.cmake   |  3 +++
 src/CMakeLists.txt   |  4 ++--
 src/libkshark-plot.c | 20 +++++++-------------
 src/libkshark-plot.h | 11 +++++++++++
 4 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/build/deff.h.cmake b/build/deff.h.cmake
index e398c0c..868ffec 100644
--- a/build/deff.h.cmake
+++ b/build/deff.h.cmake
@@ -23,6 +23,9 @@
 /** "pkexec" executable. */
 #cmakedefine DO_AS_ROOT "@DO_AS_ROOT@"
 
+/** GLUT has been found. */
+#cmakedefine GLUT_FOUND
+
 /** Semicolon-separated list of plugin names. */
 #define KS_BUILTIN_PLUGINS "@PLUGINS@"
 
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index cf3279e..fe440db 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -38,7 +38,7 @@ install(FILES "${KS_DIR}/src/libkshark.h"
         DESTINATION ${KS_INCLUDS_DESTINATION}
             COMPONENT libkshark-devel)
 
-if (OPENGL_FOUND AND GLUT_FOUND)
+if (OPENGL_FOUND)
 
     message(STATUS "libkshark-plot")
     add_library(kshark-plot  SHARED  libkshark-plot.c)
@@ -61,7 +61,7 @@ if (OPENGL_FOUND AND GLUT_FOUND)
             ARCHIVE DESTINATION    ${_LIBDIR}
                 COMPONENT              libkshark-devel)
 
-endif (OPENGL_FOUND AND GLUT_FOUND)
+endif (OPENGL_FOUND)
 
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
diff --git a/src/libkshark-plot.c b/src/libkshark-plot.c
index 1c8ede4..c9a3530 100644
--- a/src/libkshark-plot.c
+++ b/src/libkshark-plot.c
@@ -19,10 +19,6 @@
 #include <string.h>
 #include <stdio.h>
 
-// OpenGL
-#include <GL/freeglut.h>
-#include <GL/gl.h>
-
 // KernelShark
 #include "libkshark-plot.h"
 
@@ -37,6 +33,10 @@
 #define STBTT_STATIC
 #include "stb_truetype.h"
 
+#ifdef GLUT_FOUND
+
+#include <GL/freeglut.h>
+
 /**
  * @brief Create an empty scene for drawing.
  *
@@ -61,17 +61,11 @@ void ksplot_make_scene(int width, int height)
 	/* Open the screen window. */
 	glutCreateWindow("KernelShark Plot");
 
-	/*
-	 * Set the origin of the coordinate system to be the top left corner.
-	 * The "Y" coordinate is inverted.
-	 */
-	gluOrtho2D(0, width, height, 0);
-	glViewport(0, 0, width, height);
-
-	glMatrixMode(GL_PROJECTION);
-	glLoadIdentity();
+	ksplot_resize_opengl(width, height);
 }
 
+#endif // GLUT_FOUND
+
 /**
  * @brief Initialize OpenGL.
  *
diff --git a/src/libkshark-plot.h b/src/libkshark-plot.h
index 0edf5d5..063740d 100644
--- a/src/libkshark-plot.h
+++ b/src/libkshark-plot.h
@@ -15,6 +15,10 @@
 // C
 #include <stdbool.h>
 
+// OpenGL
+#include <GL/gl.h>
+#include <GL/glu.h>
+
 /*
  * STB TrueType (single-file public domain library)
  * https://github.com/nothings/stb
@@ -25,6 +29,9 @@
 extern "C" {
 #endif
 
+// KernelShark
+#include "KsCmakeDef.hpp"
+
 /** Structure defining a RGB color. */
 struct ksplot_color {
 	/** The Red component of the color. */
@@ -46,8 +53,12 @@ struct ksplot_point {
 	int y;
 };
 
+#ifdef GLUT_FOUND
+
 void ksplot_make_scene(int width, int height);
 
+#endif // GLUT_FOUND
+
 void ksplot_init_opengl(int dpr);
 
 void ksplot_resize_opengl(int width, int height);
-- 
2.25.1

