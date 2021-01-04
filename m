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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987D9C433E9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C35620770
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbhADRto (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbhADRtn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:43 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5372CC061794
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:22 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c7so28237134edv.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jgl455XwHK5OdxmBO7abn5gsz+5Hs22napmQo7sYKTw=;
        b=H4bpt9NJk0Mtv29c0+eVdub/4/vlrdVbs5Vg26cf2F22GIordb+Wh37r6/SDo8YijF
         ic5JdCGbcqozSDt62fdO0D3JsjWgBiwY/sctlgWD75/Mk6ccs/SlUz8GwOkoSCwq++cW
         JFfITGFVg2S3+Tgrqg8c3zEeHF5eCNH0GZGct+smZ6ynC/Iehj3uwSzGCQNhr7jFgCdN
         Jv+9jt9UDpboLC4xwK/Kk6bgUH54Mr/aAarvSxymB+pDiKj/xuFiUk8rqhW4JiF7Sy2n
         z5RGPoYA3Tnryx7Yc9IpZlV3DdrE/4bC2y+Owy6Kk96rmh6041GD/09wZXd34Xt1rx5H
         Jr0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jgl455XwHK5OdxmBO7abn5gsz+5Hs22napmQo7sYKTw=;
        b=QqGzIJPQt/2g2XvM6ALdngpaWjaJ8JmE49amrambktEjDiz2RY2PRnjOCxFcvjA8j8
         u3QHKbxpRIOLF6rN6MeuWjUWbPRCow2Kwj0eVG8Si8ipwfgeyse2GIAPE/mwbjl9bZwQ
         bWkr42dQxjZOROHm/cdvH/9h0Y5yU94NdUBt0dGt6nuDhGyPDqPE47l3lZVp5b81QXCo
         eT0hCfD4BLFIOZOX0UOz5wXojdsmdva17BhoN1cjjU8TBCmIhD+xQ5s+irF8jFiZhhHh
         Kvc7l1H36YhjGAtRDPGGXPDG6YHNlLmWbhw9LsXd6xsXczRH1FjnPQ0K8WbJb7tLffay
         8cng==
X-Gm-Message-State: AOAM531PSd5Sw3DnJoAj4kIO/PGytU+wAEfocDPNZIyygX/bDrDscrtx
        w5ZUw6starf7CUs43guvyZQ=
X-Google-Smtp-Source: ABdhPJwprN6LxrOCNzpMuEqQHcxWmrBQRqaAY4yJ4Dokb35LN7vr7r23KBTahia/Yv0LzdoD+gX5Ug==
X-Received: by 2002:a50:ac86:: with SMTP id x6mr20058616edc.197.1609782501057;
        Mon, 04 Jan 2021 09:48:21 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:20 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 44/44] kernel-shark: Add double click interface to PlotObject
Date:   Mon,  4 Jan 2021 19:47:24 +0200
Message-Id: <20210104174724.70404-45-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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

