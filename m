Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AA3C4360F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0D8121927
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391293AbfBNOFI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:05:08 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53555 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388734AbfBNOFI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 09:05:08 -0500
Received: by mail-wm1-f68.google.com with SMTP id d15so6426065wmb.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Feb 2019 06:05:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Af/21bgfZacPnSAcR+/Un6w/CSk/gkweViFPTo3siOs=;
        b=HcCSyZaRW7mGeP3Mp2A8hF2N1H17TM2FJDa9hj49o5CA9ROKPf/glZGztGku+myxk8
         y6DAQk3UTKY3RWmipEInp05z3AEiV8hGLiD4yTYpVI+3WQYIgtmdHeA4Hggef4KGRjx5
         22VC7VRyV6bGWLheS25EpXjg/jd2oUfbOJEE8BohJ+OEN0DLevMzIkNOBvWdKonr0xL7
         3sZvx7b0CYJxqqgkgX2E22gCmzl8zqsFGz4hUSArgJWposL+4IPcPsPqez1uTmf/pQ/J
         jVyf7rHmiT3/LY2uWsKTijO1BtPyUjOwYr5++fNH3P9GJwxlEB6UHrLZaF72v2HhAddM
         At8Q==
X-Gm-Message-State: AHQUAuaeMvqskKLCD0L2YSrSHn1SxYpTHaTTlGhFmaLJSDnB1pj2gFpH
        HVhqy/VukhynWAmKTweM1o4=
X-Google-Smtp-Source: AHgI3IaiDuF8mbLIwePs4dzlUZBo9nGfAX/Ad2eU1rkYckEQwRnD1et+mKq81GQgQ3Hv0ykb19TDmQ==
X-Received: by 2002:a1c:ac42:: with SMTP id v63mr2801251wme.119.1550153106150;
        Thu, 14 Feb 2019 06:05:06 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q21sm3021131wmc.14.2019.02.14.06.05.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 06:05:05 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH] kernel-shark: Implement proper reser for the OpenGL widget
Date:   Thu, 14 Feb 2019 16:04:51 +0200
Message-Id: <20190214140451.827-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When loading a new trace.dat file the OpenGL widget has to be properly
reset. One important operation of this reset is to set the "_data"
pointer to NULL. This will block all attempts for drawing something
before the widget is set again. The bug was introduced in

7d057ae56 ("kernel-shark-qt: Add Trace Graph widget")

but had no effect until

94efea960 ("kernel-shark-qt: Handle the case when the range of ...")

because the number of bins of the model was zero, so nothing was plotted
anyway.

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Fixes: 7d057ae56 ("kernel-shark-qt: Add Trace Graph widget")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsGLWidget.cpp   | 9 +++++++++
 kernel-shark/src/KsGLWidget.hpp   | 2 ++
 kernel-shark/src/KsTraceGraph.cpp | 6 ++----
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/kernel-shark/src/KsGLWidget.cpp b/kernel-shark/src/KsGLWidget.cpp
index 917e86d..7a050c2 100644
--- a/kernel-shark/src/KsGLWidget.cpp
+++ b/kernel-shark/src/KsGLWidget.cpp
@@ -109,6 +109,15 @@ void KsGLWidget::paintGL()
 	_mState->activeMarker().draw();
 }
 
+/** Reset (empty) the widget. */
+void KsGLWidget::reset()
+{
+	_cpuList = {};
+	_taskList = {};
+	_data = nullptr;
+	_model.reset();
+}
+
 /** Reimplemented event handler used to receive mouse press events. */
 void KsGLWidget::mousePressEvent(QMouseEvent *event)
 {
diff --git a/kernel-shark/src/KsGLWidget.hpp b/kernel-shark/src/KsGLWidget.hpp
index 6fbf534..95f307b 100644
--- a/kernel-shark/src/KsGLWidget.hpp
+++ b/kernel-shark/src/KsGLWidget.hpp
@@ -37,6 +37,8 @@ public:
 
 	void paintGL() override;
 
+	void reset();
+
 	void mousePressEvent(QMouseEvent *event);
 
 	void mouseMoveEvent(QMouseEvent *event);
diff --git a/kernel-shark/src/KsTraceGraph.cpp b/kernel-shark/src/KsTraceGraph.cpp
index 844c794..6087e96 100644
--- a/kernel-shark/src/KsTraceGraph.cpp
+++ b/kernel-shark/src/KsTraceGraph.cpp
@@ -201,15 +201,13 @@ void KsTraceGraph::setMarkerSM(KsDualMarkerSM *m)
 /** Reset (empty) the widget. */
 void KsTraceGraph::reset()
 {
-	/* Clear the all graph lists and update. */
-	_glWindow._cpuList = {};
-	_glWindow._taskList = {};
+	/* Reset (empty) the OpenGL widget. */
+	_glWindow.reset();
 
 	_labelP2.setText("");
 	for (auto l1: {&_labelI1, &_labelI2, &_labelI3, &_labelI4, &_labelI5})
 		l1->setText("");
 
-	_glWindow.model()->reset();
 	_selfUpdate();
 	for (auto l2: {&_labelXMin, &_labelXMid, &_labelXMax})
 		l2->setText("");
-- 
2.17.1

