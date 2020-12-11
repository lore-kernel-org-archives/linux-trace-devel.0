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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9993AC4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7CD723BAB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392564AbgLKPLF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437700AbgLKPKW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:10:22 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0A2C0619D6
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:44 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id w5so5634377wrm.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QAc9rN/+ebUnaVnLoOymp9XTB1lOzET5wq4JdqzjX/o=;
        b=u1QgzXH22N/RWzCaQVfe4/xpa+OYhDr7tfq3n/tCTndqhjTm8Ync1DWcNl2794cwEp
         Gb4ZFBPn5THFndFwMKSrlR1SQwFdlZb5/8sjcPgx7AN2nMItH/t33Z1o+yR9Wr+TYE3z
         JG7KV06jk2KmiqU1/UIWImaZBGULICoB3VmcYzaWZ3LheNshdp9r7Qjsu18nS1CO38r5
         n953cw8wx5cjxQ6zeN4eU6cLhb9iTzpPNTfNeWKkzFxpwNcCmgYJZ/LwUcrrDWd1ioqQ
         +OfBipdoDmNjwZQMSa9GVSb57PLNtQMen6qKaHleDXIXi0askerg6PjIiOc5gb52RsF4
         xA+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QAc9rN/+ebUnaVnLoOymp9XTB1lOzET5wq4JdqzjX/o=;
        b=ZGaivuUc8Ci6brRqIJ4Keg1LRSiOb6iPPzgxuVavTKA8FFF6vb5H936zhTuupGwddm
         Vp/VkNgcVFUFxHQeZzglh9uq3WewaJkk+ijJ2RbayTZE295Y/MnY1BKnxLrIkcMxHPZI
         XHihZbCu6IyfSA7dEIsDfqUl/JjiKR8W2m6eLjO0q6k6KC87ipN3+Kxuqc58FpUrzDfR
         EpF4fRvA8sn0OKTTpta3ZbemVjCaPf+wnpNxWM1lU1VZLty5sbfNVxIHkNph5JxZtLO6
         bjnPeieQetUY5oIqZpRmFQ3R2C3Ht7LT1U9K3/bXlbW+/eF6eljbs6lH3m5QjlaoJtnl
         pHUg==
X-Gm-Message-State: AOAM532cebI7FwvoCLGbLp0j2CE24iojs7BOf6x4NVQJCFBAKhaYIUt4
        snHQQHiy7x6MsNU29KbRw+heIU3RWLk=
X-Google-Smtp-Source: ABdhPJxawZ/cAe3MhWKx5Df77qjN1Fa2MxmUdiq3br3KE6au095Mpz8VJ7TQRU5tBharG7/BNXjqNQ==
X-Received: by 2002:a5d:4b4c:: with SMTP id w12mr14331232wrs.402.1607699323402;
        Fri, 11 Dec 2020 07:08:43 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:42 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 27/32] kernel-shark: Make GLUT optional dependency
Date:   Fri, 11 Dec 2020 17:07:51 +0200
Message-Id: <20201211150756.577366-28-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
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
index 939a016..96b69cd 100644
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

