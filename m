Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D740C4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54F5123AC4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732439AbgLINr1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732405AbgLINr0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:47:26 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08E9C0617B0
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:46:12 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id m5so1802444wrx.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zX3Jx/rqMTuIRQADtuT1k2P3h10g6nJEdPWVUEWe854=;
        b=jmYOn3u+d051EJrLnMHtep3W9PUVQ08C8OoeZoQyWq0OwxC71KbfpMwawAlFnjw6n+
         9rJJv11cS/F8ZRLbKc15dBgcuEpNkopvgG4BSzZUTAPwxx+9G9WcOTauG+uK9kARPgGe
         G4+ztTsutP2vnMNLbZ3DQYDRoHDtplnrXrFk9XnCmYVmLKYLmjYenTPOzSJsPFnY8FDq
         h8FaN1aZpnkRKcOExIeNraWbTL9MsU0fEZbhyZ6wFEAk3AeumAjl50Oemet/gVZk3Jd9
         WOaz08T2lrow+sLN6I9F+3b69/+yDmYBwwccGOvxuqMohhyCwwABpLrskaiIMzLCqGQR
         YSDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zX3Jx/rqMTuIRQADtuT1k2P3h10g6nJEdPWVUEWe854=;
        b=ojUBFuOGyJusPav09REafSC+srPD4wEAZe83M1cSKWq5LDyaM4Jik0ro+0qJqN3ibw
         9OfKdC5qe+M1/gya9up919AaRk3SpA7/ZQvktNgTNM3YfVHi+5fd80Yu/Q4/ctljN3+J
         Pw9kl+3jMHwLZHXgzJ6ZIkUDfTq4wLPa1VAvv0/YOM2N0XxK5iv4pkuxyNcdYiSLMZmN
         pEjDN8uCfvaY5YZQjzbbmyDeDtaWQqauzaxlEsz98IDhhGS4PI9QChc4qYBwY3CveE6a
         EgOSE/Z1gwsIETu8gV8qbIcGvkhjd1Z8u69yRcP4GLa2vnYVsuRcrOurt1YkSb+qOot3
         +WWQ==
X-Gm-Message-State: AOAM531pblXGbWTTQuTfGL30u4WXxyemsxDO/NEGILqWP5wNCbfkQIFY
        RSAzUxCGoWhbMIYHV39Uen4=
X-Google-Smtp-Source: ABdhPJzFYdkIi+1afHABr8C7scShqdy+6wP39wtwf2VJR3y7r+BZ3ZxkuqEXxxXuVwFFMvw/NppbYg==
X-Received: by 2002:a5d:4f8a:: with SMTP id d10mr2766066wru.219.1607521571476;
        Wed, 09 Dec 2020 05:46:11 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id s1sm4029431wrv.97.2020.12.09.05.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:46:11 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 06/10] kernel-shark: Make the label part of the graph
Date:   Wed,  9 Dec 2020 15:45:26 +0200
Message-Id: <20201209134530.428368-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134530.428368-1-y.karadz@gmail.com>
References: <20201209134530.428368-1-y.karadz@gmail.com>
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

