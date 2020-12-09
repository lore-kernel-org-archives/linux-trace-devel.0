Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC09DC4167B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B60C523A02
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732604AbgLINoT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732623AbgLINoS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:44:18 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D61C0619D2
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:40 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id q75so1718865wme.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DA5GhfxNhqzr5EyzsPBOzVZcoECLT/tXeBT2VbxoeEE=;
        b=J2flTilJ37C+sWsyCknW5Xm6LbsQAlNNnVKyn6+6nJv/0VemIQeTlRX7NBWFgVH/Hu
         YkFMbyTV6zx8ZCh8LEWeh9dwNNG3+C4ER0BYDfhkjYiCEKfJ9Ap1IhhavkZY54zAMq2Z
         nGhMEvsy54ebXm5VOLBpb1UaEhjlw+bFi55sy4sKaJoNLcVXXzKjK5LlmGtBF1iJgTfJ
         yD6ceF4f68w4ib02V9xsDz8NgiJF6KTWY2etA0Fnwyds7f5xM+VanSBVrVVqtLdTu+eb
         JL7Z5SPWhimKoKvHcnc2Xap5vYNEgUXhDXdWiCJJKaJdk+gIoNbx8rg0h0uuDaipRsHv
         twcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DA5GhfxNhqzr5EyzsPBOzVZcoECLT/tXeBT2VbxoeEE=;
        b=f3su4grM75VUnoupAauw4KEV6HbkcbG0jYWBaaWFn+k0EWytaukgF9h7noVoP6clSP
         qyTodf8Hn0Gwe2l2k9CwnvKijLqBfN1oqBsdmbHhzn/CF2dKLk4OtKxXxN2EsKVN+VV9
         4A2aEg4OA5idZzscac/bRdo3jBAe1Uom7mfPqpB+XSnvTdRpju6FvR26IdYLULaoHp23
         5UNL/AiCGFfo6XgLFlMEAZw3HZOU4DaeLKoGw1wk3PJaj7n7r+VY3hIVEF7Ob8oSvgCz
         cdRGNea+AxwICX3cC7xqje+Bukk3EDSyPlLIGhUSYHviCEV9Lvx2vDOxB3sAe0cjvF0h
         WXnw==
X-Gm-Message-State: AOAM532lDuy6PPHgy3mhXOQWaPICh4cIgBsvwKJ80AysLS9490jvLijA
        aobRXNvU9Vr9MT0Ujm3J3xE=
X-Google-Smtp-Source: ABdhPJxiyCJyiAzXZmPehnhZmUu1vyufd62srXETWJdZCLtv08ZUwQIu1DP422c0IpqU3/c1IYGD4Q==
X-Received: by 2002:a7b:cb04:: with SMTP id u4mr2864677wmj.74.1607521359317;
        Wed, 09 Dec 2020 05:42:39 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:38 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 22/27] kernel-shark: Make GLUT optional dependency
Date:   Wed,  9 Dec 2020 15:41:58 +0200
Message-Id: <20201209134203.428068-23-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
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
index 3a07d82..cbd45ed 100644
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
index 0c6b1a5..1c45f44 100644
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

