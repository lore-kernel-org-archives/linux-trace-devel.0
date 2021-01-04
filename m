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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34350C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1042E20700
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbhADRte (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbhADRte (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:34 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846FEC06138F
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:20 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y24so28198359edt.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SyimfIUcyOxEzAGqudBgzM4qdeXWlI+NU+A9xhnpx+8=;
        b=QfkTXR/F4Q/YX1Vhh/tt8zQQc/hLklfU3y/qrpgFU7HZJMzwJpQFUfT9NjW53eTvbe
         ZDkQcpPG8TOVerXOG2NrwmiCkVT5Nk9olIaNa1EswCIFgeZlstNsLIC67zUTlZlEPTuo
         Kds7+AbA6mB5+Av+G1dE4ExCkPClQRsV6BdMIrOdFoYGCWx8EjXeZMypuE9/FrtxOPHq
         t4VC6kaZMhZ8TeWc2EibhzNQQjkCVbrirLcRPOdpNbhSAIZLw154NSLT+wuRVxn3ElK6
         y65QTJkdiYsSsJldaoR7cjzCwQg2rR/VjrnoQroMS1XB0V7FylUM7s+FTaRF4Iks60fY
         dpRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SyimfIUcyOxEzAGqudBgzM4qdeXWlI+NU+A9xhnpx+8=;
        b=bJpDFyIfQtI/WohHVYf8f9az155+yBZNYbDtCbC35k8AZYg5i15PYHG29DaVYC7/Q3
         l3zZxTksSscLa2dr5YTRLiP7FsMytx/VvfuqDMjs5yB+8WsWt+ob2/kgibRkP2Tocs2V
         7cLAuiUTUCeI0RJCbeFc0gebtCDzqaocKOpw23WdAMTy2baTultr/6/xp1XvoUMRwL9S
         xMNu/rDp0akUvM0bzAHAweyLFpcoX1TMgIWR8P4AiODW147c0rlA+ggizHKka6Iwpluv
         EjJetewkWt421P5BMSiUpATVp0Eiui6untVTBC7yPYuGCAcNm4YVZtusRy23jmaIaTbo
         62Ew==
X-Gm-Message-State: AOAM532XD4X/nJz8oNN6BaIFSUxWAW7l9xwS7wWpPRI0jMJQZp/RNtBK
        ZaHn3YVGvFNGlzI9zK6W8eP4zae9vsFB2g==
X-Google-Smtp-Source: ABdhPJxwFWJwIu03DuGHVivXdP51LcEVtMG/Njo0SBffklRpcRN2zCo1WZF0VMH8LGjE+sc3xAFdQw==
X-Received: by 2002:a50:ed04:: with SMTP id j4mr73342894eds.84.1609782499319;
        Mon, 04 Jan 2021 09:48:19 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:18 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 42/44] kernel-shark: Add class Polyline to KsPlot namespace
Date:   Mon,  4 Jan 2021 19:47:22 +0200
Message-Id: <20210104174724.70404-43-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a simple plotting class that represents a poly-line.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 14 ++++++++++++++
 src/KsPlotTools.hpp | 16 ++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 529f737..9f98386 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -503,6 +503,20 @@ void Line::_draw(const Color &col, float size) const
 				 col.color_c_ptr(), size);
 }
 
+/**
+ * @brief Create a default polyline. All points are initialized at (0, 0).
+ *
+ * @param n: The number of points connected by the polyline.
+ */
+Polyline::Polyline(size_t n)
+: Shape(n)
+{}
+
+void Polyline::_draw(const Color &col, float size) const
+{
+	ksplot_draw_polyline(_points, _nPoints, col.color_c_ptr(), size);
+}
+
 /**
  * @brief Create a default polygon. All points are initialized at (0, 0).
  *
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index 5ce8f6f..4a7ca0a 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -253,6 +253,22 @@ private:
 	void _draw(const Color &col, float size = 1.) const override;
 };
 
+/** This class represents a polyline. */
+class Polyline : public Shape {
+public:
+	Polyline(size_t n);
+
+	/**
+	 * @brief Destroy the polyline object. Keep this destructor virtual.
+	 */
+	virtual ~Polyline() {}
+
+private:
+	Polyline() = delete;
+
+	void _draw(const Color &, float size = 1.) const override;
+};
+
 /** This class represents a polygon. */
 class Polygon : public Shape {
 public:
-- 
2.25.1

