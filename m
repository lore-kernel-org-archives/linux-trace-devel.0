Return-Path: <SRS0=5FCK=TP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90812C04E53
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 659FE20843
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfEOTK0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 May 2019 15:10:26 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34350 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbfEOTK0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 May 2019 15:10:26 -0400
Received: by mail-pg1-f194.google.com with SMTP id c13so262450pgt.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 May 2019 12:10:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0UepxbYX1clVl10dlAJ3fiSWMgeVvZ368TMAXoM2DDs=;
        b=SpEW7M5856625xSokud5xbfxvLkD0L8FWk8aT1BD7QrXP5ugfChhwZnAL2kb1u2DW7
         Ze1ThN1S2R7OR2Sq0xStra4ekFzMqZMH7o4o4psV7TJcYCPLcx65nblj5RlEbootFVPr
         Md1z7/UZ8VYY58KblhB3791ZhDUIeFq1k0siIAwC6CK+0NuhKg2VJtK8Fz+2MBxpv7PR
         Od9ORLuZebrcuZ8b/UqORzS8KP/SCddpJB2+xN/NXy0EklVi4pKTVcYLFEarFFTGzMbS
         lxHmwP7OAtIn3RTCzdiVaCCYMcqcmDfqe0/EfAr98ViXr/w626PQJnMG5LrE8rP82gsX
         OMgw==
X-Gm-Message-State: APjAAAVyTkG195ZoWrZMzf2CSfdSF9/QfKgzMb8LD5Q4PvSzq1DaF/st
        C82AO/u5bk7byjTi/Y2IXLo=
X-Google-Smtp-Source: APXvYqwrJTc04Y23XH0tyGnjJDzQcofPU+rIzT1MbvJ2wRj4HStoj2dBfLYPgJJXeEumknYWVLpFeg==
X-Received: by 2002:a65:48ca:: with SMTP id o10mr45902319pgs.136.1557947425474;
        Wed, 15 May 2019 12:10:25 -0700 (PDT)
Received: from localhost.localdomain (50-204-120-225-static.hfc.comcastbusiness.net. [50.204.120.225])
        by smtp.gmail.com with ESMTPSA id l65sm5772595pfb.7.2019.05.15.12.10.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 12:10:24 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH 3/6] kernel-shark: Enforce update of the OpenGL widget when loading new session
Date:   Wed, 15 May 2019 12:09:08 -0700
Message-Id: <20190515190911.20755-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190515190911.20755-1-ykaradzhov@vmware.com>
References: <20190515190911.20755-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is needed in the case when the session was saved at different screen
resolution.

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsGLWidget.hpp   | 3 +++
 kernel-shark/src/KsMainWindow.cpp | 3 +--
 kernel-shark/src/KsTraceGraph.cpp | 2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsGLWidget.hpp b/kernel-shark/src/KsGLWidget.hpp
index 3bcecf9..bc5cacf 100644
--- a/kernel-shark/src/KsGLWidget.hpp
+++ b/kernel-shark/src/KsGLWidget.hpp
@@ -41,6 +41,9 @@ public:
 
 	void reset();
 
+	/** Reprocess all graphs. */
+	void update() {resizeGL(width(), height());}
+
 	void mousePressEvent(QMouseEvent *event);
 
 	void mouseMoveEvent(QMouseEvent *event);
diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index bb593bd..3cf10bc 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -435,7 +435,6 @@ QString KsMainWindow::lastSessionFile()
 void KsMainWindow::_restoreSession()
 {
 	loadSession(lastSessionFile());
-	_graph.updateGeom();
 }
 
 void KsMainWindow::_importSession()
@@ -450,7 +449,6 @@ void KsMainWindow::_importSession()
 		return;
 
 	loadSession(fileName);
-	_graph.updateGeom();
 }
 
 void KsMainWindow::_updateSession()
@@ -1100,6 +1098,7 @@ void KsMainWindow::loadSession(const QString &fileName)
 
 	_session.loadTable(&_view);
 	_colorPhaseSlider.setValue(_session.getColorScheme() * 100);
+	_graph.updateGeom();
 }
 
 void KsMainWindow::_initCapture()
diff --git a/kernel-shark/src/KsTraceGraph.cpp b/kernel-shark/src/KsTraceGraph.cpp
index 6087e96..da2c6aa 100644
--- a/kernel-shark/src/KsTraceGraph.cpp
+++ b/kernel-shark/src/KsTraceGraph.cpp
@@ -538,6 +538,8 @@ void KsTraceGraph::updateGeom()
 			       * allow the scroll bar to disappear when the
 			       * widget is extended to maximum.
 			       */
+
+	_glWindow.update();
 }
 
 void KsTraceGraph::_updateGraphLegends()
-- 
2.20.1

