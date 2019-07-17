Return-Path: <SRS0=BCkm=VO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B02C76192
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 08:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBF9E2077C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 08:53:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SI66BH9d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfGQIxn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 04:53:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44606 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfGQIxn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 04:53:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so23832707wrf.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2019 01:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YZfgbfjlvqspg+SIs4amFjMMq3Ztoyr0Cba62FvzcMM=;
        b=SI66BH9d2FmIi+TK0zAwTX8kbJl5MnoMxBLP+Uu2+h1izrhmMQPt8RrRl9ctCkHfIY
         NUrlVl1lWUJ/h0YnVuuELCfuiyikkwnLKSOXFiFc9O5M6VjlyOTeBwzf9AQE6dUF1300
         2bgaoGcHQTB/LznGABDWazgL1HqkSUOl0paXCEBeg3Xbnunh8Nav/NjodTcZg+iVcrMq
         /cEtM2hp70Apc+ee2jv1PVFZp0xzcWtNx+6YgguilKDxPmk+U8WiHylDu3Y3Kn4Juytu
         4NOoXVNJ06Xj3zdc3879Jj9GjJz1GbQbpQ93Q+OJkiJ/kYnpFldFivV0yPIWIBt26iQ4
         GZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YZfgbfjlvqspg+SIs4amFjMMq3Ztoyr0Cba62FvzcMM=;
        b=UDJEOy0ypLZ5fVBo23du27e6M0cLNwg0XuDQFBrZe1GgZYtezCBsJjea+OXTz1CAbP
         Yx0bHYkSc7eGUJpLcVKw32lF71Y8Mo2MjDC75h2T/5UFQedaza71UuoV5N9Gb25rkZ2G
         bdzeZRX7fgHdlM8Q09mkredUuyqANlI+uB7QgwaDrElv2JTgZ6stPJhAzUxfN7BoxoLx
         CblXre9CaP7BLDoU7ZbrX6Hbgd5guXnZiJH6rP3OQQuvi3f44VLRTeUBNyOTIq6zQXV7
         +OhTUUWh9iDGeKm6vro58APzUuVIF583BU3yO7zMIl4z7rmgk2risFjF5GyiYgzN9ri9
         U7Ig==
X-Gm-Message-State: APjAAAU4b6nMM4yF2Vwo6n5eFkAOfYDToO87ZuoWYQpHkkE8nqNpZJZC
        06iR9Muc77w9bT6G+27fo4k=
X-Google-Smtp-Source: APXvYqxg0rpTCVg4jBKasFWtUnZQcE57L+GeWF1WZIuu1WNEdCnbtKNFJ6DkIc/IB7gA/l8v6hMWeQ==
X-Received: by 2002:a5d:4108:: with SMTP id l8mr40858539wrp.113.1563353621310;
        Wed, 17 Jul 2019 01:53:41 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w23sm24102127wmi.45.2019.07.17.01.53.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 01:53:41 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark: Always check if data is loaded before changing the graphs
Date:   Wed, 17 Jul 2019 11:53:06 +0300
Message-Id: <20190717085306.12393-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190717085306.12393-1-y.karadz@gmail.com>
References: <20190717085306.12393-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We want all operations over the graphs (like Zoom or Scroll) to be
protected for the case when no data is loaded or no graphs are plotted.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsGLWidget.cpp   | 22 ++++++++++++++++++++--
 kernel-shark/src/KsGLWidget.hpp   |  2 ++
 kernel-shark/src/KsTraceGraph.cpp |  9 +++++++++
 3 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsGLWidget.cpp b/kernel-shark/src/KsGLWidget.cpp
index ce68052..e930006 100644
--- a/kernel-shark/src/KsGLWidget.cpp
+++ b/kernel-shark/src/KsGLWidget.cpp
@@ -88,9 +88,11 @@ void KsGLWidget::paintGL()
 
 	glClear(GL_COLOR_BUFFER_BIT);
 
+	if (isEmpty())
+		return;
+
 	/* Draw the time axis. */
-	if(_data)
-		_drawAxisX(size);
+	_drawAxisX(size);
 
 	/* Process and draw all graphs by using the built-in logic. */
 	_makeGraphs(_cpuList, _taskList);
@@ -127,6 +129,13 @@ void KsGLWidget::reset()
 	_model.reset();
 }
 
+/** Check if the widget is empty (not showing anything). */
+bool KsGLWidget::isEmpty() const {
+	return !_data ||
+	       !_data->size() ||
+	       (!_cpuList.size() && !_taskList.size());
+}
+
 /** Reimplemented event handler used to receive mouse press events. */
 void KsGLWidget::mousePressEvent(QMouseEvent *event)
 {
@@ -198,6 +207,9 @@ void KsGLWidget::mouseMoveEvent(QMouseEvent *event)
 	size_t row;
 	bool ret;
 
+	if (isEmpty())
+		return;
+
 	if (_rubberBand.isVisible())
 		_rangeBoundStretched(_posInRange(event->pos().x()));
 
@@ -224,6 +236,9 @@ void KsGLWidget::mouseMoveEvent(QMouseEvent *event)
 /** Reimplemented event handler used to receive mouse release events. */
 void KsGLWidget::mouseReleaseEvent(QMouseEvent *event)
 {
+	if (isEmpty())
+		return;
+
 	if (event->button() == Qt::LeftButton) {
 		size_t posMouseRel = _posInRange(event->pos().x());
 		int min, max;
@@ -251,6 +266,9 @@ void KsGLWidget::wheelEvent(QWheelEvent * event)
 {
 	int zoomFocus;
 
+	if (isEmpty())
+		return;
+
 	if (_mState->activeMarker()._isSet &&
 	    _mState->activeMarker().isVisible()) {
 		/*
diff --git a/kernel-shark/src/KsGLWidget.hpp b/kernel-shark/src/KsGLWidget.hpp
index e141b0a..3d428b1 100644
--- a/kernel-shark/src/KsGLWidget.hpp
+++ b/kernel-shark/src/KsGLWidget.hpp
@@ -41,6 +41,8 @@ public:
 
 	void reset();
 
+	bool isEmpty() const;
+
 	/** Reprocess all graphs. */
 	void update() {resizeGL(width(), height());}
 
diff --git a/kernel-shark/src/KsTraceGraph.cpp b/kernel-shark/src/KsTraceGraph.cpp
index 324f36e..2e48372 100644
--- a/kernel-shark/src/KsTraceGraph.cpp
+++ b/kernel-shark/src/KsTraceGraph.cpp
@@ -234,6 +234,9 @@ void KsTraceGraph::_zoomOut()
 
 void KsTraceGraph::_quickZoomIn()
 {
+	if (_glWindow.isEmpty())
+		return;
+
 	/* Bin size will be 100 ns. */
 	_glWindow.model()->quickZoomIn(100);
 	if (_mState->activeMarker()._isSet &&
@@ -249,6 +252,9 @@ void KsTraceGraph::_quickZoomIn()
 
 void KsTraceGraph::_quickZoomOut()
 {
+	if (_glWindow.isEmpty())
+		return;
+
 	_glWindow.model()->quickZoomOut();
 }
 
@@ -646,6 +652,9 @@ void KsTraceGraph::_updateGraphs(GraphActions action)
 	double k;
 	int bin;
 
+	if (_glWindow.isEmpty())
+		return;
+
 	/*
 	 * Set the "Key Pressed" flag. The flag will stay set as long as the user
 	 * keeps the corresponding action button pressed.
-- 
2.20.1

