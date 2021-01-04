Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21E5C433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C101E20700
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbhADRte (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbhADRte (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:34 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9D2C061574
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:18 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b2so28272712edm.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zX3Jx/rqMTuIRQADtuT1k2P3h10g6nJEdPWVUEWe854=;
        b=tVmzTa0KHGnGTfUxfVrROkucxIC3LWHuidckooxoTY2KD1EL+J3t6Q8+rqDyqhOMXR
         TQdvFlQY3cAjv/7bqgUbGLbFNtOATxQ2UzUzPxMz5IYAHJrQAN2Eu8+mNePjD5ELwknS
         lVl10tKVpGECEG7hjLzcoP+w+jikKUsJQYYzm3rq106gOTyrFuW+4K5H17RqWyn0t1oI
         fyqR4m+ySCK4Ed2M5fLqb4fSbpkqKvXXJaFuDpYhWSbl7ELTA9rEpkd4uAejAjF8IhC3
         VK5hipvwEWqP+Veplsa+bSzBaNQ0x+FKkP3YAU3DO2tmGIFQOFfGIow6k02Np1XUaPQn
         6wvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zX3Jx/rqMTuIRQADtuT1k2P3h10g6nJEdPWVUEWe854=;
        b=iJ09bzp71h+toBPdTLG+LHq+kPqRpSRvJ0Hp2pc/plU7h5zCSy4e0g+itKUYkfZYRy
         yKyQR6403AL75Mrc9Zqi/P0lOIlRCvFiD83A9hhXd0aN4HTcSDYCkkqqI0IIiEQqbui7
         //C4DyI3cpXjamN0h0NA11HlbAhqi930Byfer2QOWp176HRxRRNmzcuJ9wVhykPrRrTw
         rjoZVDMP4FJBApdfDM5pObWfgv/HxHskX2K/RQvES9WZ8O7x2R/8zAXBvum38F8BVXIV
         0zvJ6cZ8cLQzpTMxXOSklYYYibuweqDZJM6SznGQK57HkPMPT7xSIk2xvJoKD4SiUlf8
         Mhug==
X-Gm-Message-State: AOAM532laoOsR68z4uD+BDkButzojfnoM4wJESkclHrTSxNUGc7sincm
        jgt/LZcs+SBACrdO+KiUp8A=
X-Google-Smtp-Source: ABdhPJzNbfT7uo9S7UB3oIDl7SuUukpRg8PWeJVBkntLuuNWtaPnei78AP0AzRQB035tay2f0zdPzw==
X-Received: by 2002:aa7:dcd0:: with SMTP id w16mr72439201edu.229.1609782497187;
        Mon, 04 Jan 2021 09:48:17 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:16 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 40/44] kernel-shark: Make the label part of the graph
Date:   Mon,  4 Jan 2021 19:47:20 +0200
Message-Id: <20210104174724.70404-41-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The capability to draw text with OpenGL is used. With this
functionality we will no longer need to create special Qt widgets
containing the text of the labels and carefully align those widgets
next to the OpenGL plotting area. This will greatly simplify the
internel structure of the TraceGraph widget.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 34 +++++++++++++++++++++++++---------
 src/KsPlotTools.hpp | 18 +++++++++++++++---
 2 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 4bf08ef..d952f5e 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -759,6 +759,7 @@ Graph::Graph()
   _collectionPtr(nullptr),
   _binColors(nullptr),
   _ensembleColors(nullptr),
+  _label(),
   _zeroSuppress(false)
 {}
 
@@ -777,6 +778,7 @@ Graph::Graph(kshark_trace_histo *histo, KsPlot::ColorTable *bct, KsPlot::ColorTa
   _collectionPtr(nullptr),
   _binColors(bct),
   _ensembleColors(ect),
+  _label(),
   _zeroSuppress(false)
 {
 	if (!_bins) {
@@ -795,10 +797,15 @@ Graph::~Graph()
 	delete[] _bins;
 }
 
+int Graph::_firstBinOffset()
+{
+	return _labelSize + 2 * _hMargin;
+}
+
 void Graph::_initBins()
 {
 	for (int i = 0; i < _size; ++i) {
-		_bins[i]._base.setX(i + _hMargin);
+		_bins[i]._base.setX(i + _firstBinOffset());
 		_bins[i]._base.setY(0);
 		_bins[i]._val.setX(_bins[i]._base.x());
 		_bins[i]._val.setY(_bins[i]._base.y());
@@ -852,6 +859,8 @@ void Graph::setBase(int b)
 	if (b == _bins[0]._base.y()) // Nothing to do.
 		return;
 
+	_label.setBoxAppearance(_label._color, _labelSize, height());
+
 	for (int i = 0; i < _size; ++i) {
 		mod = _bins[i].mod();
 		_bins[i]._base.setY(b);
@@ -870,24 +879,29 @@ void Graph::setHeight(int h)
 }
 
 /**
- * @brief Set the size of the white space added on both sides of the Graph.
+ * @brief Set the color and the dimensions of the graph's label.
  *
- * @param hMargin: the size of the white space in pixels.
+ * @param f: The font to be used to draw the labels.
+ * @param col: The color of the ComboGraph's label.
+ * @param lSize: the size of the graph's label in pixels.
+ * @param hMargin: the size of the white margine space in pixels.
  */
-void Graph::setHMargin(int hMargin)
+void Graph::setLabelAppearance(ksplot_font *f, Color col, int lSize, int hMargin)
 {
 	if (!_size)
 		return;
 
-	if (hMargin == _bins[0]._base.x()) // Nothing to do.
-		return;
+	_labelSize = lSize;
+	_hMargin = hMargin;
+
+	_label.setPos({_hMargin, base()});
+	_label.setFont(f);
+	_label.setBoxAppearance(col, lSize, height());
 
 	for (int i = 0; i < _size; ++i) {
-		_bins[i]._base.setX(i + hMargin);
+		_bins[i]._base.setX(i + _firstBinOffset());
 		_bins[i]._val.setX(_bins[i]._base.x());
 	}
-
-	_hMargin = hMargin;
 }
 
 /**
@@ -1312,6 +1326,8 @@ void Graph::draw(float size)
 	int lastPid(-1), b(0), boxH(_height * .3);
 	Rectangle taskBox;
 
+	_label.draw();
+
 	/*
 	 * Start by drawing a line between the base points of the first and
 	 * the last bin.
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index 287e0fb..8f530b0 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -506,7 +506,11 @@ public:
 	/** @brief Get a particular bin. */
 	const Bin &bin(int bin) const {return _bins[bin];}
 
-	void setHMargin(int hMargin);
+	/** Set the text of the graph's label. */
+	void setLabelText(std::string text) {_label.setText(text);}
+
+	void setLabelAppearance(ksplot_font *f, Color col,
+				int lSize, int hMargin);
 
 	/**
 	 * Check if this graph is Zero Suppressed. Zero Suppressed means that
@@ -521,7 +525,7 @@ public:
 	 */
 	void setZeroSuppressed(bool zs) {_zeroSuppress = zs;}
 
-private:
+protected:
 	/** Pointer to the model descriptor object. */
 	kshark_trace_histo	*_histoPtr;
 
@@ -537,6 +541,9 @@ private:
 	 */
 	int			_hMargin;
 
+	/** The horizontal size of the Graph's label. */
+	int			_labelSize;
+
 	/** The vertical size (height) of the Graph. */
 	int			_height;
 
@@ -549,9 +556,14 @@ private:
 	/** Hash table of ensemble's colors. */
 	ColorTable		*_ensembleColors;
 
+private:
+	TextBox		_label;
+
 	bool			_zeroSuppress;
 
-	void _initBins();
+	void	_initBins();
+
+	int	_firstBinOffset();
 };
 
 }; // KsPlot
-- 
2.25.1

