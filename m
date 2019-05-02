Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2F2C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC3EF2075E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfEBMp7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:45:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37885 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfEBMp7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:45:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id k23so3177670wrd.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 05:45:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JDLVAnWL2bWT7LlBCrAiYByAByQs36OoGSQP+OjItiA=;
        b=oCI8idLDrz5fMxkugw4BtX8jMu0Yb4MeiAMn5ayBOeMHq3vxOpUNfULDQ8yd0GnG3I
         apLT4OF51vKKMz8QSz7MC6R8TZwvbxqhHuOyxjUmA2XSVMaJmQE1tPQHqzvENfkUOAoQ
         yxuILgaq5IdnpwdykvHlmNc+33wZ2hDJnxD4LEBuS5ibZBiBSt+UArb2xaZNnyfo1fGu
         LFtnvH+XFocpYw8s1dsIiWrB1sfut/RGLnHsbz+HcQQ0KZYI/0ImMA56RMSKU0FWF67r
         YHul+JdBIjFDqMupc0u/5JKYJjUd8kfjY3fnnIv/kTWmkVgY78a4jfWaW32isyBY53/P
         Pzaw==
X-Gm-Message-State: APjAAAX8I42LGiWLnrjop0KsSLJK62N1G05hFnF7UIOvn4Gf1ikp3i2V
        BqLa6Gh9D+AhuhfGut5hffkroZYV
X-Google-Smtp-Source: APXvYqzPB/t7/AIp2Mefoj1lLJryC6Eon9Jcu34XHORMWAgw6VX+JlDWQOIpEaeatc4yQo+Xe+1CsQ==
X-Received: by 2002:a5d:5041:: with SMTP id h1mr2697899wrt.181.1556801157876;
        Thu, 02 May 2019 05:45:57 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c10sm10012949wrd.69.2019.05.02.05.45.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:45:57 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/2] kernel-shark: Enforce update of the OpenGL widget when loading new session
Date:   Thu,  2 May 2019 15:45:35 +0300
Message-Id: <20190502124536.32463-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is needed in the case when the session was saved at different screen
resolution.

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsGLWidget.hpp   | 2 ++
 kernel-shark/src/KsMainWindow.cpp | 3 +--
 kernel-shark/src/KsTraceGraph.cpp | 2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsGLWidget.hpp b/kernel-shark/src/KsGLWidget.hpp
index 3bcecf9..bf68be3 100644
--- a/kernel-shark/src/KsGLWidget.hpp
+++ b/kernel-shark/src/KsGLWidget.hpp
@@ -41,6 +41,8 @@ public:
 
 	void reset();
 
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

