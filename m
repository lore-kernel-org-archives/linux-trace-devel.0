Return-Path: <SRS0=5FCK=TP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 949C3C04E53
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66CA020843
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfEOTKn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 May 2019 15:10:43 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46064 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfEOTKn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 May 2019 15:10:43 -0400
Received: by mail-pf1-f196.google.com with SMTP id s11so436796pfm.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 May 2019 12:10:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H6lwmKt2n7Pf69RpCrlNpRShPPy7nJ7fY587b1cNBUc=;
        b=oF2Dfr1dQYdg5kY2JZ/ACxvet6gX0w3hsH0Gj5saaCbRAhuQ1optfiBRbhm3nm6wuM
         uwc8ITg853KLUzR9YVe8xr12L9h7Sks+9izBB/qAfLj/2pswnNHnC3JKQEfFcU5AI1Ut
         SNBEsPEsZAqSno0Mu5KgLwis9YkEIaMqpzjZLY58EaKiAdPz7QXoc+cHOnlaw1dp/okH
         p3qccpZmOcP9sHk0FiM6dEFww5c2RenI58gmmH+egeNtXX0d31l3jZeJXXfNPBfzhEZX
         4vY8cM6EmGXI3/FuBHzZmCepCkGK9dwzrjyiQBkKvF5zm2TqqiSARxg12VH7l5aOdJrT
         jc3Q==
X-Gm-Message-State: APjAAAUfjABMYLjZsB5cBuZB/txKfDPiJZisPUrHFMG+aogXzCngJbUv
        7sLAu3jkPkD6p+FejcDnRGU=
X-Google-Smtp-Source: APXvYqyJPqRplKPeCSSi3BNsz97WV0qsL/H1nPHl0gGz1sV79pJXk+YNURUws2oA3/N3cFILHsBz3w==
X-Received: by 2002:a63:2745:: with SMTP id n66mr44882075pgn.208.1557947442508;
        Wed, 15 May 2019 12:10:42 -0700 (PDT)
Received: from localhost.localdomain (50-204-120-225-static.hfc.comcastbusiness.net. [50.204.120.225])
        by smtp.gmail.com with ESMTPSA id l65sm5772595pfb.7.2019.05.15.12.10.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 12:10:42 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 5/6] kernel-shark: Improve the appearance on high screen resolution
Date:   Wed, 15 May 2019 12:09:10 -0700
Message-Id: <20190515190911.20755-6-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190515190911.20755-1-ykaradzhov@vmware.com>
References: <20190515190911.20755-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some of the components of the plots haven't been properly scaled
when displayed on high screen resolution.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsGLWidget.cpp  | 24 ++++++++++++++----------
 kernel-shark/src/KsGLWidget.hpp  |  2 +-
 kernel-shark/src/KsPlotTools.cpp |  4 +++-
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/kernel-shark/src/KsGLWidget.cpp b/kernel-shark/src/KsGLWidget.cpp
index 789514a..ce68052 100644
--- a/kernel-shark/src/KsGLWidget.cpp
+++ b/kernel-shark/src/KsGLWidget.cpp
@@ -84,24 +84,29 @@ void KsGLWidget::resizeGL(int w, int h)
 /** Reimplemented function used to plot trace graphs. */
 void KsGLWidget::paintGL()
 {
+	float size = 1.5 * _dpr;
+
 	glClear(GL_COLOR_BUFFER_BIT);
 
 	/* Draw the time axis. */
 	if(_data)
-		_drawAxisX();
+		_drawAxisX(size);
 
 	/* Process and draw all graphs by using the built-in logic. */
 	_makeGraphs(_cpuList, _taskList);
 	for (auto const &g: _graphs)
-		g->draw(1.5 * _dpr);
+		g->draw(size);
 
 	/* Process and draw all plugin-specific shapes. */
 	_makePluginShapes(_cpuList, _taskList);
 	while (!_shapes.empty()) {
 		auto s = _shapes.front();
+		_shapes.pop_front();
+
+		s->_size = size;
 		s->draw();
+
 		delete s;
-		_shapes.pop_front();
 	}
 
 	/*
@@ -448,22 +453,21 @@ void KsGLWidget::findGraphIds(const kshark_entry &e,
 		*graphTask = -1;
 }
 
-void KsGLWidget::_drawAxisX()
+void KsGLWidget::_drawAxisX(float size)
 {
 	KsPlot::Point a0(_hMargin, _vMargin / 4), a1(_hMargin, _vMargin / 2);
-	KsPlot::Point b0(width()/2, _vMargin / 4), b1(width() / 2, _vMargin / 2);
+	KsPlot::Point b0(width() / 2, _vMargin / 4), b1(width() / 2, _vMargin / 2);
 	KsPlot::Point c0(width() - _hMargin, _vMargin / 4),
 			 c1(width() - _hMargin, _vMargin / 2);
-	int lineSize = 2 * _dpr;
 
 	a0._size = c0._size = _dpr;
 
 	a0.draw();
 	c0.draw();
-	KsPlot::drawLine(a0, a1, {}, lineSize);
-	KsPlot::drawLine(b0, b1, {}, lineSize);
-	KsPlot::drawLine(c0, c1, {}, lineSize);
-	KsPlot::drawLine(a0, c0, {}, lineSize);
+	KsPlot::drawLine(a0, a1, {}, size);
+	KsPlot::drawLine(b0, b1, {}, size);
+	KsPlot::drawLine(c0, c1, {}, size);
+	KsPlot::drawLine(a0, c0, {}, size);
 }
 
 void KsGLWidget::_makeGraphs(QVector<int> cpuList, QVector<int> taskList)
diff --git a/kernel-shark/src/KsGLWidget.hpp b/kernel-shark/src/KsGLWidget.hpp
index bc5cacf..e141b0a 100644
--- a/kernel-shark/src/KsGLWidget.hpp
+++ b/kernel-shark/src/KsGLWidget.hpp
@@ -190,7 +190,7 @@ private:
 
 	int 		_dpr;
 
-	void _drawAxisX();
+	void _drawAxisX(float size);
 
 	void _makeGraphs(QVector<int> cpuMask, QVector<int> taskMask);
 
diff --git a/kernel-shark/src/KsPlotTools.cpp b/kernel-shark/src/KsPlotTools.cpp
index 2b16a51..f95ada5 100644
--- a/kernel-shark/src/KsPlotTools.cpp
+++ b/kernel-shark/src/KsPlotTools.cpp
@@ -1089,8 +1089,10 @@ void Graph::draw(float size)
 	/* Draw as vartical lines all bins containing data. */
 	for (int i = 0; i < _size; ++i)
 		if (_bins[i]._idFront >= 0 || _bins[i]._idBack >= 0)
-			if (_bins[i]._visMask & KS_EVENT_VIEW_FILTER_MASK)
+			if (_bins[i]._visMask & KS_EVENT_VIEW_FILTER_MASK) {
+				_bins[i]._size = size;
 				_bins[i].draw();
+			}
 
 	auto lamCheckEnsblVal = [this] (int v) {
 		return v > 0 || (v == 0 && !this->_zeroSuppress);
-- 
2.20.1

