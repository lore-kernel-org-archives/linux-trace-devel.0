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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AEE6C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3524C206B2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbhADRtd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbhADRtc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:32 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753B8C06138D
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:16 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id b9so37959375ejy.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T4A7E1BDscYXt41eolB0dZpFcPyC9alYcsymRqZXNtk=;
        b=g8O671zAm9lhVPIZhgeZRxmLNGOrf+UKpzCUrQHhLbNvJmJNd5XVgADGgv5QNc4Gsy
         u3A87XKkvkXiSwLQ31LTpeRNt2c3p/h0sUlL7Wwd6P7tHLwiYgtWxXkX71VYpUiqFgft
         RFUIhmEDCXNVA6mfoz5VgmjPG+TAZcAAlyF723lEXc5RzDFntKPDdF133LfsufjGZst7
         Xas1B0OLaON3vjye2x8MN5jHlaF4xHW88hJJWfegqVAW/iDZTaiAHmrMR5Qv4WBRUml8
         lBfeHrluW5BPErg3uFT67tYNDQBDokw0xj50xoLD31AMHZC1MjK47y8Z15nMlxxi1Qoa
         a8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T4A7E1BDscYXt41eolB0dZpFcPyC9alYcsymRqZXNtk=;
        b=FEwvMgZgRp3rTgzmGrDSGeGabe1WjhVo8Tfc2rmh6NRHm+VCQTwr3KlT2AHKfxMfOf
         VMfDIQH88O5t8pf4Wr4WEnZu+39jJYKS6ZGwWR5I8cwQ5IE2cRJtrPUaCXs6yH1XYqm8
         rG8QQinNI40LzJ5baQ8Ymg+g5FwfNH+qRD36dr+e7WUierTAm4nHfkMCk4oBTBc4hS9t
         nT31nNfJbshJ662c5Cq5FE2JXXlmumjtdB1bKZ4vjFhHNeT34QDydodvOxD35hYms+Oh
         Y2AjIIEkNeE+cGImh34YfBZvLWMkNyzLlHGbDsurpv9+MrLfLeDIiPhfwx0pgVg59U3C
         W+ng==
X-Gm-Message-State: AOAM531vSuHydPpDJ2ik7+U8IpY1LZO+MO7g3AODTznWBxgfu6ClUPIa
        PXgjrCOqmfRS9RyJt4OIh1o=
X-Google-Smtp-Source: ABdhPJyAvMqMt6igawczBDjk7aZ/NkUPp7qYq8EaNO0wyGjOrOyAVbrYK2wdrmf/MNjQ2bMC53Dnrw==
X-Received: by 2002:a17:906:59a:: with SMTP id 26mr66644705ejn.309.1609782495239;
        Mon, 04 Jan 2021 09:48:15 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:14 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 38/44] kernel-shark: Add TextBox class to KsPlot namespace
Date:   Mon,  4 Jan 2021 19:47:18 +0200
Message-Id: <20210104174724.70404-39-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This class represents a text that is printed/drawn inside a colorful
frame.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 99 +++++++++++++++++++++++++++++++++++++++++++++
 src/KsPlotTools.hpp | 40 ++++++++++++++++++
 2 files changed, 139 insertions(+)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 6c3902a..ef15cde 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -524,6 +524,105 @@ void Polygon::_draw(const Color &col, float size) const
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
index 7ffabd8..b270a56 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -307,6 +307,46 @@ public:
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

