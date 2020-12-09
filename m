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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8A3C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 355DC23AC4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732627AbgLINq4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732187AbgLINqz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:46:55 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937A1C0617A6
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:46:10 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id k14so1824919wrn.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YHZTducm3OvxzN8lAvSGl2yIVpuXdLUr0IrY9hi8Ax0=;
        b=ITdKoOYJiLbGawCOY48ldDjlWz8DNefxqv3CtKEJiHyZcUAR2ewg7R+CKetVJ2s1yI
         bi/X+xtWlBGi2o6n0/zvO79AvWnWt322y2xseo6F5ZFVMKrfm8g5dO5dsdj16PjCdyyZ
         GEipFtPNPyk+OCF7Uji8otcvx7hUcKlfH5YwMbMo/dFic4yNKKrHxvZTE7UvyxSjS7x2
         vOc4bLNYBAi1L+ttGo4pkbZwm2c7qwC98RIv7Ap2nnor0PH8F1QMNSLQgklr5mC3CMFj
         zjWkCfQlbb5Kpwi0WdrE5HJdqWU/eCoMeSmeVLVbMnz1N5VIsNS1haWal/fQKIRczNNi
         MyIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YHZTducm3OvxzN8lAvSGl2yIVpuXdLUr0IrY9hi8Ax0=;
        b=NKbS1XAIwJmKFhbOiTuXNHH2VkJw5I6NZ0LdH+PGIwnAgh9Ctzb8ZBx8z0qo/wGi4f
         zPnZU/9E6RTQ4jl9Xvyaox0tE58ybyxu7cIDYCG5eKmCSMg95lOiI9/3sXqvW8il75fw
         9CNuHF7bSs031KhFKAaEGv8TSGNerpfGVnWBmdkze2hE45Rduq1c+0rw0CTmSJD1VDzf
         9suvNdszu8rPJr3qAyJttF3F5EQz4EarYBHXqux3mnpPo7RAP1oUAVL6IlQK601cJVP0
         DrndzB7jXj0D6qKqzjjhGbuKAm3khUwJTxQKpTJ/OnWPgffZmTWTR/RLHzlEQ5B6uImk
         MwXA==
X-Gm-Message-State: AOAM531ZAY8tKIjTMwlB5bb7sTKvFlG01IqkuMkvnsv6dmjEJ6go4xF1
        iN5NjdnDHi2hkcbgY4onAxo=
X-Google-Smtp-Source: ABdhPJxn9HnQZ8vPXK4YfajFMU4yd9nqWGpGIhUPTqr12pSt2YHoCwm3A9AYrxMU9J10TByGeGqwMg==
X-Received: by 2002:adf:f74e:: with SMTP id z14mr2950275wrp.146.1607521569380;
        Wed, 09 Dec 2020 05:46:09 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id s1sm4029431wrv.97.2020.12.09.05.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:46:08 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 04/10] kernel-shark: Add TextBox class to KsPlot namespace
Date:   Wed,  9 Dec 2020 15:45:24 +0200
Message-Id: <20201209134530.428368-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134530.428368-1-y.karadz@gmail.com>
References: <20201209134530.428368-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This class represents a text that is printed/drawn inside a colorful
frame.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 116 ++++++++++++++++++++++++++++++++++++++++++++
 src/KsPlotTools.hpp |  42 ++++++++++++++++
 2 files changed, 158 insertions(+)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 52c3cbb..ef15cde 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -97,6 +97,23 @@ void Color::setRainbowColor(int n)
 	set(r, g, b);
 }
 
+/** Alpha blending with white background. */
+void Color::blend(float alpha)
+{
+	if (alpha < 0 || alpha > 1.)
+		return;
+
+	auto lamBld = [alpha](int val) {
+		return  val * alpha + (1 - alpha) * 255;
+	};
+
+	int r = lamBld(this->r());
+	int g = lamBld(this->g());
+	int b = lamBld(this->b());
+
+	set(r, g, b);
+}
+
 /**
  * @brief Create a Hash table of Rainbow colors. The sorted Pid values are
  *	  mapped to the palette of Rainbow colors.
@@ -507,6 +524,105 @@ void Polygon::_draw(const Color &col, float size) const
 					    col.color_c_ptr(),
 					    size);
 }
+/** The created object will print/draw only the text without the frame. */
+TextBox::TextBox()
+: _text(""),
+  _font(nullptr)
+{
+	setPos(Point(0, 0));
+	_box._visible = false;
+}
+
+
+/** The created object will print/draw only the text without the frame. */
+TextBox::TextBox(ksplot_font *f)
+: _text(""),
+  _font(f)
+{
+	setPos(Point(0, 0));
+	_box._visible = false;
+}
+
+/** The created object will print/draw only the text without the frame. */
+TextBox::TextBox(ksplot_font *f, const std::string &text, const Point &pos)
+: _text(text),
+  _font(f)
+{
+	setPos(pos);
+	_box._visible = false;
+}
+
+/** The created object will print/draw only the text without the frame. */
+TextBox::TextBox(ksplot_font *f, const std::string &text, const Color &col,
+		 const Point &pos)
+: _text(text),
+  _font(f)
+{
+	_color = col;
+	setPos(pos);
+	_box._visible = false;
+}
+
+/** The created object will print/draw the text and the frame. */
+TextBox::TextBox(ksplot_font *f, const std::string &text, const Color &col,
+		 const Point &pos, int l, int h)
+: _text(text),
+  _font(f)
+{
+	setPos(pos);
+	setBoxAppearance(col, l, h);
+}
+
+/**
+ * @brief Set the position of the bottom-left corner of the frame.
+ *
+ * @param p: The coordinates of the bottom-left corner.
+ */
+void TextBox::setPos(const Point &p)
+{
+	_box.setPoint(0, p);
+}
+
+/**
+ * @brief Set the color and the dimensions of the frame.
+ *
+ * @param col: The color of the frame.
+ * @param l: The length of the frame.
+ * @param h: The height of the frame.
+ */
+void TextBox::setBoxAppearance(const Color &col, int l, int h)
+{
+	_box.setFill(true);
+	_box._color = col;
+	_box._visible = true;
+
+	if (h <= 0 && _font)
+		h = _font->height;
+
+	_box.setPoint(1, _box.getPointX(0),	_box.getPointY(0) - h);
+	_box.setPoint(2, _box.getPointX(0) + l,	_box.getPointY(0) - h);
+	_box.setPoint(3, _box.getPointX(0) + l,	_box.getPointY(0));
+}
+
+void TextBox::_draw(const Color &col, float size) const
+{
+	_box.draw();
+	if (!_font || _text.empty())
+		return;
+
+	if (_box._visible ) {
+		int bShift = (_box.getPointY(0) - _box.getPointY(1) - _font->height) / 2;
+		ksplot_print_text(_font, NULL,
+				  _box.getPointX(0) + _font->height / 4,
+				  _box.getPointY(0) - _font->base - bShift,
+				  _text.c_str());
+	} else {
+		ksplot_print_text(_font, col.color_c_ptr(),
+				  _box.getPointX(0) + _font->height / 4,
+				  _box.getPointY(0) - _font->base,
+				  _text.c_str());
+	}
+}
 
 /**
  * @brief Create a default Mark.
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index dbb15bf..b270a56 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -47,6 +47,8 @@ public:
 
 	void setRainbowColor(int n);
 
+	void blend(float alpha);
+
 	/**
 	 * @brief Get the C struct defining the RGB color.
 	 */
@@ -305,6 +307,46 @@ public:
 	virtual ~Rectangle() {}
 };
 
+/**
+ * This class represents a text that is printed/drawn inside a colorful frame.
+ */
+class TextBox : public PlotObject {
+public:
+	TextBox();
+
+	TextBox(ksplot_font *f);
+
+	TextBox(ksplot_font *f, const std::string &text, const Point &pos);
+
+	TextBox(ksplot_font *f, const std::string &text, const Color &col,
+		const Point &pos);
+
+	TextBox(ksplot_font *f, const std::string &text, const Color &col,
+		const Point &pos, int l, int h = -1);
+
+	/** Destroy the TextBox object. Keep this destructor virtual. */
+	virtual ~TextBox() {}
+
+	/** Set the font to be used. */
+	void setFont(ksplot_font *f) {_font = f;}
+
+	/** Set the text. */
+	void setText(const std::string &t) {_text = t;}
+
+	void setPos(const Point &p);
+
+	void setBoxAppearance(const Color &col, int l, int h);
+
+private:
+	void _draw(const Color &, float size = 1.) const override;
+
+	std::string	_text;
+
+	ksplot_font	*_font;
+
+	Rectangle	_box;
+};
+
 /**
  * This class represents the graphical element of the KernelShark GUI marker.
  */
-- 
2.25.1

