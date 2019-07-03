Return-Path: <SRS0=Bo3z=VA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B82AC0650E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 561B6218A0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:10:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UUjHHTsZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfGCMK6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 08:10:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46442 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfGCMK6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:10:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so2489041wrw.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Jul 2019 05:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V/XInzqLeRVzuLBbY/CqJ+blJLzxw++kYRUTh9pvT3o=;
        b=UUjHHTsZA0uGSRFne6inM3naTQchLILV+S4zGQy0HhFmRHxNCFMsO11/MnfpmIbl2V
         Kj+LoasuYLIWQzyi238r825KsoDItT2RTrQFGjXLv5d9NvF7BAxHJJLDsSdf9h2IP+j9
         G9NfJAkWycPrnr5TcIbzXDAGM8Df4A9BxdJqqQUnekZ2jaJbNhHr/uwMucMClBCmlduR
         nRQ4BcrGYJhhIpz3a5VaqcDkM7d+qM2dslW1qfYmISeCUGDkXXW3+Vv5uUNiZ9IT+d0y
         j1xxGdUizBt9M3iU7BCmVoigMiRPbT9pspFx8DUUzMkbKcA6xeUa4BVdvFhK1diHT1yp
         yO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V/XInzqLeRVzuLBbY/CqJ+blJLzxw++kYRUTh9pvT3o=;
        b=hqjmmo4fnrjoMMdI6/f9GlioKGy/3hIdjbnrwkybUokPZFQGXnnHGdxteGjsChsaBX
         yoDO8Rv0ZvG64qRgDEyQrj5zTxPfR+kxvFZtVBCtcdZM4ktwbllcT8pj+yOK8RYlp1jj
         oNzpa4fj4KzN8ibRJ6gCCcEyGS2odB3K1Vt8YXM8b3xU0bVYEtrZEE4M/H72vgnG05GL
         gmMKV++bO5IXYV95NI1t3rmUZMPUSvHzAnfU3omGQj/F4ATaMf5RYWcoGdGyIcn1rWtB
         XGHe0HP2E/aOAhxmSEOSMS8dIJR6m25ZbP8D1Nwc57i91Pf4iEYbxfnB0wR7mnaXfzgm
         jZ3w==
X-Gm-Message-State: APjAAAWdsLHiaW6QsaajyqKUQwtFAOsrg8SBGHnhxsf2L8Lo5uPCVqTe
        KYQ3CoAWGuDQKMxMpJD3pAM=
X-Google-Smtp-Source: APXvYqx0aiCHE3H14oGZ+Rp7K8t7ILJrIHX3I6fjeNQySxEEyH43BrjqpKYFoSZrT1uyMgZYgi5ODw==
X-Received: by 2002:adf:f408:: with SMTP id g8mr4060818wro.256.1562155855385;
        Wed, 03 Jul 2019 05:10:55 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u18sm2321587wmd.19.2019.07.03.05.10.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 05:10:55 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [RFC PATCH v2 5/5] kernel-shark: Drop Freeglut as a compulsory dependency
Date:   Wed,  3 Jul 2019 15:10:23 +0300
Message-Id: <20190703121023.16655-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703121023.16655-1-y.karadz@gmail.com>
References: <20190703121023.16655-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Freeglut is not a necessary dependency for programs like the
KernelShark GUI that are using Qt for window and OpenGL context
management. Currently it is been used only by the data plotting
example (dataplot.cpp).

Suggested-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/build/deff.h.cmake      |  3 +++
 kernel-shark/examples/CMakeLists.txt | 10 +++++++---
 kernel-shark/src/CMakeLists.txt      |  4 ++--
 kernel-shark/src/KsGLWidget.cpp      |  4 ----
 kernel-shark/src/KsPlotTools.cpp     |  4 ----
 kernel-shark/src/libkshark-plot.c    | 17 ++++++++---------
 kernel-shark/src/libkshark-plot.h    |  2 +-
 7 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
index efee2a1..e3543ca 100644
--- a/kernel-shark/build/deff.h.cmake
+++ b/kernel-shark/build/deff.h.cmake
@@ -23,6 +23,9 @@
 /** "pkexec" executable. */
 #cmakedefine DO_AS_ROOT "@DO_AS_ROOT@"
 
+/** GLUT has been found. */
+#cmakedefine GLUT_FOUND
+
 #ifdef __cplusplus
 
 	#include <QString>
diff --git a/kernel-shark/examples/CMakeLists.txt b/kernel-shark/examples/CMakeLists.txt
index 824b21c..74898c0 100644
--- a/kernel-shark/examples/CMakeLists.txt
+++ b/kernel-shark/examples/CMakeLists.txt
@@ -16,9 +16,13 @@ message(STATUS "confogio")
 add_executable(confio          configio.c)
 target_link_libraries(confio   kshark)
 
-message(STATUS "dataplot")
-add_executable(dplot          dataplot.cpp)
-target_link_libraries(dplot   kshark-plot)
+if (GLUT_FOUND)
+
+    message(STATUS "dataplot")
+    add_executable(dplot          dataplot.cpp)
+    target_link_libraries(dplot   kshark-plot)
+
+endif (GLUT_FOUND)
 
 message(STATUS "widgetdemo")
 add_executable(widgetdemo          widgetdemo.cpp)
diff --git a/kernel-shark/src/CMakeLists.txt b/kernel-shark/src/CMakeLists.txt
index 36ce884..8c8f988 100644
--- a/kernel-shark/src/CMakeLists.txt
+++ b/kernel-shark/src/CMakeLists.txt
@@ -38,7 +38,7 @@ if (_DEVEL)
 
 endif (_DEVEL)
 
-if (OPENGL_FOUND AND GLUT_FOUND)
+if (OPENGL_FOUND)
 
     message(STATUS "libkshark-plot")
     add_library(kshark-plot  SHARED  libkshark-plot.c
@@ -65,7 +65,7 @@ if (OPENGL_FOUND AND GLUT_FOUND)
 
     endif (_DEVEL)
 
-endif (OPENGL_FOUND AND GLUT_FOUND)
+endif (OPENGL_FOUND)
 
 if (Qt5Widgets_FOUND AND Qt5Network_FOUND)
 
diff --git a/kernel-shark/src/KsGLWidget.cpp b/kernel-shark/src/KsGLWidget.cpp
index ce68052..37819d3 100644
--- a/kernel-shark/src/KsGLWidget.cpp
+++ b/kernel-shark/src/KsGLWidget.cpp
@@ -9,10 +9,6 @@
  *  @brief   OpenGL widget for plotting trace graphs.
  */
 
-// OpenGL
-#include <GL/glut.h>
-#include <GL/gl.h>
-
 // KernelShark
 #include "KsGLWidget.hpp"
 #include "KsUtils.hpp"
diff --git a/kernel-shark/src/KsPlotTools.cpp b/kernel-shark/src/KsPlotTools.cpp
index a8eddcd..152ec47 100644
--- a/kernel-shark/src/KsPlotTools.cpp
+++ b/kernel-shark/src/KsPlotTools.cpp
@@ -16,10 +16,6 @@
 #include <algorithm>
 #include <vector>
 
-// OpenGL
-#include <GL/freeglut.h>
-#include <GL/gl.h>
-
 // KernelShark
 #include "KsPlotTools.hpp"
 
diff --git a/kernel-shark/src/libkshark-plot.c b/kernel-shark/src/libkshark-plot.c
index 1982494..32e2ae9 100644
--- a/kernel-shark/src/libkshark-plot.c
+++ b/kernel-shark/src/libkshark-plot.c
@@ -19,6 +19,7 @@
 
 // KernelShark
 #include "libkshark-plot.h"
+#include "KsCmakeDef.hpp"
 
 /*
  * STB TrueType (single-file public domain library)
@@ -31,6 +32,10 @@
 #define STBTT_STATIC
 #include "stb_truetype.h"
 
+#ifdef GLUT_FOUND
+
+#include <GL/freeglut.h>
+
 /**
  * @brief Create an empty scene for drawing.
  *
@@ -55,17 +60,11 @@ void ksplot_make_scene(int width, int height)
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
diff --git a/kernel-shark/src/libkshark-plot.h b/kernel-shark/src/libkshark-plot.h
index 1895bee..2c44787 100644
--- a/kernel-shark/src/libkshark-plot.h
+++ b/kernel-shark/src/libkshark-plot.h
@@ -16,8 +16,8 @@
 #include <stdbool.h>
 
 // OpenGL
-#include <GL/freeglut.h>
 #include <GL/gl.h>
+#include <GL/glu.h>
 
 /*
  * STB TrueType (single-file public domain library)
-- 
2.20.1

