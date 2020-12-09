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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80BC3C4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58AE523B52
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732187AbgLINq4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732594AbgLINqz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:46:55 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96615C0617A7
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:46:11 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id 91so1800416wrj.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0JvNJho6nmQ6wRAwlTsWSUBLgvX8jyU10P1W/zdKzQs=;
        b=Wh6xggAZZrCXK0qhkEhuLlQnTV0uD7rnleKBf7DKXfPt+YXnfDgT9yWyqQQU6vFY7b
         ckzRmI9Ix1a9Wd91e16Ew4/dzSi9aH+jNxj+TmbgaI4FwoBb0eXvDCuSKyoEIiKDquL5
         8MSGqAPPtZMC6nLJFxA4Uz6So2LriRPfagvzzedUPl0EN1QQOPvrPEcaaoQ2rVdjRIch
         LC8HTYXsr3/EHn8CLx9+XoFTE9snojgbhhZ6zUbYXlO6wc9xq65GDWmK2ExWpXErCIiM
         vPI621lMXtj3buGzufA6+VwmR4JNk6jm/IZAa1yjbFzOwCTv1DNIQz3z4fqwfCn9B8Mz
         Ev0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0JvNJho6nmQ6wRAwlTsWSUBLgvX8jyU10P1W/zdKzQs=;
        b=ALSHCdjkouaXIsIUjs8TCUaVdePo9lgAo062YNm5dRCbmMinVOnxDLIg0GEL4kQG0W
         KVf91uJfKZlfeHRiqOj1lpBUlzNQKz1jQM3DymEtrGQyQKCytO5ctOsV/9WQV12lhJc4
         4BEu8AJrVvwGnqKL36O5Ccyf8ShdGXTWLTROQyG81Gi+fdcmuxAFKvMqOhDIGSjjsKXC
         k/35hOrbYDZdDesrc5AlqB7ReYx7hNdw8IBlanQGE09W7/oXc9vqH0eOv3LPK/vNboJr
         EyN8bTCW3wAxbqCIbHxgPPCVuYJQsV7jhE7llb01R2CnfLbDzU8vearz7ToHnljBEbld
         FNQg==
X-Gm-Message-State: AOAM530nC4JPk0wI8wBd5Uh+4CqCBr7qedPGCznhSJ0vJwssiRyjBkWL
        2YIq1//BguEPeojwAxS0hMI=
X-Google-Smtp-Source: ABdhPJzJFequOulsVFC6GfzNPNFfCenVljRSNbrBB736HQQQSRbyKFAHf5nbvPPJUTQMGsIJkojrcg==
X-Received: by 2002:adf:efc5:: with SMTP id i5mr2721541wrp.377.1607521570380;
        Wed, 09 Dec 2020 05:46:10 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id s1sm4029431wrv.97.2020.12.09.05.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:46:09 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 05/10] kernel-shark: Consistent method naming in KsPlotTools
Date:   Wed,  9 Dec 2020 15:45:25 +0200
Message-Id: <20201209134530.428368-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134530.428368-1-y.karadz@gmail.com>
References: <20201209134530.428368-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Remove "get" from the name of the methods used to retrieve data fields
in KsPlotTools. This makes the naming consistent with the style used by
Qt.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 30 +++++++++++++++---------------
 src/KsPlotTools.hpp | 34 +++++++++++++++++-----------------
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index ef15cde..4bf08ef 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -120,7 +120,7 @@ void Color::blend(float alpha)
  *
  * @returns ColorTable instance.
  */
-ColorTable getTaskColorTable()
+ColorTable taskColorTable()
 {
 	struct kshark_context *kshark_ctx(nullptr);
 	int nTasks(0), pid, *pids, i(0), *streamIds;
@@ -173,7 +173,7 @@ ColorTable getTaskColorTable()
  *
  * @returns ColorTable instance.
  */
-ColorTable getCPUColorTable()
+ColorTable CPUColorTable()
 {
 	kshark_context *kshark_ctx(nullptr);
 	int nCPUs, nCPUMax(0), *streamIds;
@@ -205,7 +205,7 @@ ColorTable getCPUColorTable()
  *
  * @returns ColorTable instance.
  */
-ColorTable getStreamColorTable()
+ColorTable streamColorTable()
 {
 	kshark_context *kshark_ctx(nullptr);
 	ColorTable colors;
@@ -360,7 +360,7 @@ void Shape::setPoint(size_t i, const Point &p)
  * @brief Get the point "i". If the point does not exist, the function returns
  *	  nullptr.
  */
-const ksplot_point *Shape::getPoint(size_t i) const
+const ksplot_point *Shape::point(size_t i) const
 {
 	if (i < _nPoints)
 		return &_points[i];
@@ -394,7 +394,7 @@ void Shape::setPointY(size_t i, int y) {
  * @brief Get the horizontal coordinate of the point "i". If the point does
  * 	  not exist, the function returns 0.
  */
-int Shape::getPointX(size_t i) const {
+int Shape::pointX(size_t i) const {
 	if (i < _nPoints)
 		return _points[i].x;
 
@@ -405,7 +405,7 @@ int Shape::getPointX(size_t i) const {
  * @brief Get the vertical coordinate of the point "i". If the point does
  * 	  not exist, the function returns 0.
  */
-int Shape::getPointY(size_t i) const {
+int Shape::pointY(size_t i) const {
 	if (i < _nPoints)
 		return _points[i].y;
 
@@ -599,9 +599,9 @@ void TextBox::setBoxAppearance(const Color &col, int l, int h)
 	if (h <= 0 && _font)
 		h = _font->height;
 
-	_box.setPoint(1, _box.getPointX(0),	_box.getPointY(0) - h);
-	_box.setPoint(2, _box.getPointX(0) + l,	_box.getPointY(0) - h);
-	_box.setPoint(3, _box.getPointX(0) + l,	_box.getPointY(0));
+	_box.setPoint(1, _box.pointX(0),	_box.pointY(0) - h);
+	_box.setPoint(2, _box.pointX(0) + l,	_box.pointY(0) - h);
+	_box.setPoint(3, _box.pointX(0) + l,	_box.pointY(0));
 }
 
 void TextBox::_draw(const Color &col, float size) const
@@ -611,15 +611,15 @@ void TextBox::_draw(const Color &col, float size) const
 		return;
 
 	if (_box._visible ) {
-		int bShift = (_box.getPointY(0) - _box.getPointY(1) - _font->height) / 2;
+		int bShift = (_box.pointY(0) - _box.pointY(1) - _font->height) / 2;
 		ksplot_print_text(_font, NULL,
-				  _box.getPointX(0) + _font->height / 4,
-				  _box.getPointY(0) - _font->base - bShift,
+				  _box.pointX(0) + _font->height / 4,
+				  _box.pointY(0) - _font->base - bShift,
 				  _text.c_str());
 	} else {
 		ksplot_print_text(_font, col.color_c_ptr(),
-				  _box.getPointX(0) + _font->height / 4,
-				  _box.getPointY(0) - _font->base,
+				  _box.pointX(0) + _font->height / 4,
+				  _box.pointY(0) - _font->base,
 				  _text.c_str());
 	}
 }
@@ -808,7 +808,7 @@ void Graph::_initBins()
 /**
  *  Get the number of bins.
  */
-int Graph::size()
+int Graph::size() const
 {
 	return _size;
 }
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index b270a56..287e0fb 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -64,7 +64,7 @@ public:
 	 * @brief Get the frequency value used to generate the Rainbow
 	 * palette.
 	 */
-	static float getRainbowFrequency() {return _frequency;}
+	static float rainbowFrequency() {return _frequency;}
 
 private:
 	ksplot_color _col_c;
@@ -76,11 +76,11 @@ private:
 /** Hash table of colors. */
 typedef std::unordered_map<int, KsPlot::Color> ColorTable;
 
-ColorTable getTaskColorTable();
+ColorTable taskColorTable();
 
-ColorTable getCPUColorTable();
+ColorTable CPUColorTable();
 
-ColorTable getStreamColorTable();
+ColorTable streamColorTable();
 
 Color getColor(const ColorTable *colors, int id);
 
@@ -143,15 +143,15 @@ public:
 
 	void setPoint(size_t i, const Point &p);
 
-	const ksplot_point *getPoint(size_t i) const;
+	const ksplot_point *point(size_t i) const;
 
 	void setPointX(size_t i, int x);
 
 	void setPointY(size_t i, int y);
 
-	int getPointX(size_t i) const;
+	int pointX(size_t i) const;
 
-	int getPointY(size_t i) const;
+	int pointY(size_t i) const;
 
 	/**
 	 * @brief Get the number of point used to define the polygon.
@@ -179,10 +179,10 @@ public:
 	virtual ~Point() {}
 
 	/** @brief Get the horizontal coordinate of the point. */
-	int x() const {return getPointX(0);}
+	int x() const {return pointX(0);}
 
 	/** @brief Get the vertical coordinate of the point. */
-	int y() const {return getPointY(0);}
+	int y() const {return pointY(0);}
 
 	/** @brief Set the horizontal coordinate of the point. */
 	void setX(int x) {setPointX(0, x);}
@@ -201,7 +201,7 @@ public:
 	/**
 	 * @brief Get the C struct defining the point.
 	 */
-	const ksplot_point *point_c_ptr() const {return getPoint(0);}
+	const ksplot_point *point_c_ptr() const {return point(0);}
 
 private:
 	void _draw(const Color &col, float size = 1.) const override;
@@ -235,7 +235,7 @@ public:
 	void setA(int x, int y) { setPoint(0, x, y);}
 
 	/** @brief Get the first finishing point of the line. */
-	const ksplot_point *getA() const {return getPoint(0);}
+	const ksplot_point *a() const {return point(0);}
 
 	/**
 	 * @brief Set the coordinats of the second finishing point of the
@@ -247,7 +247,7 @@ public:
 	void setB(int x, int y) {setPoint(1, x, y);}
 
 	/** @brief Get the second finishing point of the line. */
-	const ksplot_point *getB() const {return getPoint(1);}
+	const ksplot_point *b() const {return point(1);}
 
 private:
 	void _draw(const Color &col, float size = 1.) const override;
@@ -408,7 +408,7 @@ public:
 	void drawVal(float size = 2.);
 
 	/** Get the height (module) of the line, representing the Bin. */
-	int mod() {return _val.y() - _base.y();}
+	int mod() const {return _val.y() - _base.y();}
 
 	/** @brief Set the vertical coordinate of the "val" Point. */
 	void setVal(int v) {_val.setY(_base.y() - v); }
@@ -458,7 +458,7 @@ public:
 	/* Keep this destructor virtual. */
 	virtual ~Graph();
 
-	int size();
+	int size() const;
 
 	void setModelPtr(kshark_trace_histo *histo);
 
@@ -485,12 +485,12 @@ public:
 	void setBase(int b);
 
 	/** @brief Get the vertical coordinate of the Graph's base. */
-	int getBase() const {return _bins[0]._base.y();}
+	int base() const {return _bins[0]._base.y();}
 
 	void setHeight(int h);
 
 	/** @brief Get the vertical size (height) of the Graph. */
-	int getHeight() const {return _height;}
+	int height() const {return _height;}
 
 	void setBinValue(int bin, int val);
 
@@ -504,7 +504,7 @@ public:
 		    const Color &col, uint8_t m);
 
 	/** @brief Get a particular bin. */
-	const Bin &getBin(int bin) const {return _bins[bin];}
+	const Bin &bin(int bin) const {return _bins[bin];}
 
 	void setHMargin(int hMargin);
 
-- 
2.25.1

