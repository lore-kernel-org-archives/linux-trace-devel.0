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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC4BC4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9625A23AC4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732444AbgLINr3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732440AbgLINr3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:47:29 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE31FC061285
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:46:16 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id r14so1822239wrn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jgl455XwHK5OdxmBO7abn5gsz+5Hs22napmQo7sYKTw=;
        b=JZetE0QGoC1zt4I5XvNL5tW9KiW0hP/RF7NPY5PN2VZ/gzJbercvu+F8y8QYXrIIpK
         VZM2NzqO4KXtETb3rek/YQ96kskZOUzBQcUoMaSuGk0qUv/ZL4z8V8pvPpAJNbCGxOJy
         3VInqfc15K1aLwXZF67Kry+HGIMzlvg0NC2Zh9T/6UazVOF0I2nUVXjzj1P9aX4R6b23
         nShSUB/w6KbqwnBfz9XCWxYWHPynadxL2Hs3EDpTteSVM6UfDElnlMCFr8idfv+3BqnV
         WS7NVPRCAo+eVDi2DeuusDlTAEei8hKZYhY89KDdNW0e8qY22jH66SNYapwtEi2G8SN8
         6YlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jgl455XwHK5OdxmBO7abn5gsz+5Hs22napmQo7sYKTw=;
        b=MzFrK7VYl+7zHwGusjlN5MbDVZ9J1M58KeTgCZ+rlzFy18g799bGUI+7fwJFQGlYe8
         17Apxl6CH7OuqxpDi9ObdiBl5KCWDqU3fLquTCWSiZSQ6OlACH827S6TpG7K+4gkgljI
         KPCD/fWed71IuPtEMB9Y61Ux34cq3g76fT38XjthPIEr53mII02bgxnonzCwsL6Zw4hA
         44ReyfUiSuYtPNTU7dHVn+duUtsPhiXP2G+JR+BAuk/9Rg64u+s57ViJTkMIGYftpTQ1
         DkFkf5ZRMJYVv4A3v8LA7pkpuD7NVqVXUpAGt7/R1s2r6qT89+iVcJbgyScvgeDamv+H
         w9fA==
X-Gm-Message-State: AOAM532aJfKbWAm/7tAzGWvkZEdjdno6uPy2C/fQZCVEqhgEF8vthbRP
        T/vbd6FVveB/G0yc9/giJg8=
X-Google-Smtp-Source: ABdhPJzdFPw0rx6nO1ljxhZQ5kenPqTlBeTcAXlqVjBNh1OyZ2rIHw76ZXTDLN6kizwsYNTp9eAt0Q==
X-Received: by 2002:a5d:5005:: with SMTP id e5mr2739151wrt.279.1607521575651;
        Wed, 09 Dec 2020 05:46:15 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id s1sm4029431wrv.97.2020.12.09.05.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:46:15 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 10/10] kernel-shark: Add double click interface to PlotObject
Date:   Wed,  9 Dec 2020 15:45:30 +0200
Message-Id: <20201209134530.428368-11-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134530.428368-1-y.karadz@gmail.com>
References: <20201209134530.428368-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The interface consists of two virtual methods that have to be implemented
by the inheriting classes. The first implements the double-click action
of the object while the second one calculates the distance between the
object and the exact position of the mouse click. The second method is
used by the GUI to decide if the double-click action has to be executed
or not. The patch contains a simple method for retrieving the geometrical
center of a Shape. This helper method can be useful when implementing the
calculation of the distance in the inheriting classes.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 31 +++++++++++++++++++++++++++++++
 src/KsPlotTools.hpp | 14 ++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 8d38009..ac9c5b2 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -251,6 +251,21 @@ Color getColor(const ColorTable *colors, int id)
 	return {};
 }
 
+/**
+ * @brief A method to be implemented in the inheriting class. It calculates
+ *	  the distance between the position of the click and the shape. This
+ *	  distance is used by the GUI to decide if the corresponding
+ *	  "Double click" action of the shape must be executed. The default
+ *	  implementation returns infinity.
+ *
+ * @param x: The X coordinate of the click.
+ * @param y: The Y coordinate of the click.
+ */
+double PlotObject::distance(int x, int y) const
+{
+	return std::numeric_limits<double>::max();
+}
+
 /**
  * @brief Create a default Shape.
  */
@@ -298,6 +313,22 @@ Shape::~Shape() {
 	delete[] _points;
 }
 
+/** @brief Get the coordinates of the geometrical center of this shape. */
+ksplot_point Shape::center() const
+{
+	ksplot_point c = {0, 0};
+
+	for (size_t i = 0; i < _nPoints; ++i) {
+		c.x += _points[i].x;
+		c.y += _points[i].y;
+	}
+
+	c.x /= _nPoints;
+	c.y /= _nPoints;
+
+	return c;
+}
+
 /** Assignment operator. */
 void Shape::operator=(const Shape &s)
 {
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index b9b93f3..c993181 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -103,6 +103,16 @@ public:
 			_draw(_color, _size);
 	}
 
+	/**
+	 * Generic action to be executed when the objects is double clicked.
+	 */
+	void doubleClick() const {
+		if (_visible)
+			_doubleClick();
+	}
+
+	virtual double distance(int x, int y) const;
+
 	/** Is this object visible. */
 	bool	_visible;
 
@@ -114,6 +124,8 @@ public:
 
 private:
 	virtual void _draw(const Color &col, float s) const = 0;
+
+	virtual void _doubleClick() const {}
 };
 
 /** List of graphical element. */
@@ -135,6 +147,8 @@ public:
 	/* Keep this destructor virtual. */
 	virtual ~Shape();
 
+	ksplot_point center() const;
+
 	void operator=(const Shape &s);
 
 	void setPoint(size_t i, int x, int y);
-- 
2.25.1

