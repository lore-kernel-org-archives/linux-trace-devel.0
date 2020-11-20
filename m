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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51390C63798
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE466204EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:51:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tOeThnBG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbgKTJvB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgKTJu6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:50:58 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6B7C0613CF
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:50:58 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id m16so8894560edr.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wriBU+rl4vgI+CCPNszDbWo8+4LWfdsPTrG/FLV03E0=;
        b=tOeThnBGDTvpe8LG8jNzCt8T2NQY6HBCTQzDF4OY9UvVq3Hu11PMIn0XLqZKEqDIZ3
         0ogd2YsS+9yEzgGrn2GmByTysaiE5H/S95IdaDbad+K2H15kjoYnum8zgGvd2SKf4Pb7
         Dx9HarW24HflaQi88ZP7M4boz/BgotbxOoYUmTYvYd/4FxRfynWmKMgR4bAQjcWLZ1qi
         BQelCBvFQs9X8M9czMEKYEXvDCggunjGLHgmXxQfOi8wzUYR/sZ9hH+q8t8S1jAobWID
         nyXiL2TNGsPbhmTwB+bZLg11e9ClYsNgwZN24xSu5MlpcUm+MS1tuDPTcyMjra5i1d8n
         G+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wriBU+rl4vgI+CCPNszDbWo8+4LWfdsPTrG/FLV03E0=;
        b=Z6VXFIsD33Fm7LMktUJmLYOCBtjIKT0alEB+GiznZqxDSnKqE8iGp7CbwjHU//z1BT
         MIRqYks3QQ4BzZgDyFi2xzTRju87eWI5VX/Viig4NrNDIqCcxUX3RZszTx+FBt665thc
         5DDtd5izF1cbDtr9dBtitMnkdw6B+KUR6JT63r9uOTiEfZTiKUETxwiSyizdPAEvtcnj
         r3A9S9NX4hvh7VjqT91eo4WZoM9NQvK3UPF07BnHfpsD5WcAENXF8J8CW1aW7yxbZOiU
         tSa2XTTV9i4mpDMaBnDsHBuEK5Wcn+ykrvNGEGCsAdh+FxHFiilNZhbXs4udqvjVwpn1
         Jthw==
X-Gm-Message-State: AOAM533u8lY31MgSRpeL15+75fHrkSgWvDh4casqNIajTNoNDCza4hyq
        sM52K7fTHQfjWlFfIHm8nFs=
X-Google-Smtp-Source: ABdhPJz7beAXt+YXsfAUrRxzeBoVvlFnH3ftjAqkCLxQ8BaDJ+S3+RZ3rlrURhuMCswFpkO+PGX3pQ==
X-Received: by 2002:aa7:d54a:: with SMTP id u10mr10762403edr.168.1605865856848;
        Fri, 20 Nov 2020 01:50:56 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id e17sm861995edc.45.2020.11.20.01.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:50:56 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/4] kernel-shark: Make GLUT optional dependency
Date:   Fri, 20 Nov 2020 11:50:29 +0200
Message-Id: <20201120095031.271735-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120095031.271735-1-y.karadz@gmail.com>
References: <20201120095031.271735-1-y.karadz@gmail.com>
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
index e398c0ca..868ffeca 100644
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
index 3a07d824..cbd45ed7 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -19,7 +19,7 @@ set_target_properties(kshark  PROPERTIES SUFFIX	".so.${KS_VERSION_STRING}")
 
 install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
 
-if (OPENGL_FOUND AND GLUT_FOUND)
+if (OPENGL_FOUND)
 
     message(STATUS "libkshark-plot")
     add_library(kshark-plot  SHARED  libkshark-plot.c)
@@ -33,7 +33,7 @@ if (OPENGL_FOUND AND GLUT_FOUND)
 
     install(TARGETS kshark-plot LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
 
-endif (OPENGL_FOUND AND GLUT_FOUND)
+endif (OPENGL_FOUND)
 
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
diff --git a/src/libkshark-plot.c b/src/libkshark-plot.c
index 06483334..f2c5be30 100644
--- a/src/libkshark-plot.c
+++ b/src/libkshark-plot.c
@@ -18,10 +18,6 @@
 #include <string.h>
 #include <stdio.h>
 
-// OpenGL
-#include <GL/freeglut.h>
-#include <GL/gl.h>
-
 // KernelShark
 #include "libkshark-plot.h"
 
@@ -36,6 +32,10 @@
 #define STBTT_STATIC
 #include "stb_truetype.h"
 
+#ifdef GLUT_FOUND
+
+#include <GL/freeglut.h>
+
 /**
  * @brief Create an empty scene for drawing.
  *
@@ -60,17 +60,11 @@ void ksplot_make_scene(int width, int height)
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
index 0edf5d50..063740d9 100644
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

