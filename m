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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE54C4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 943EE23A7C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437695AbgLKPKg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437699AbgLKPKW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:10:22 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FEFC0619D8
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:45 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id r3so9397554wrt.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zKDG/9XZbnGW4hCDetg6B4UM+/yqlFKJwoWhpahy2EM=;
        b=ml0dSEXj3mdAWUCKRgPMjPem0RJ4IAXzZ8el2Mik/WrwSRDuUfn22pgOI6bxg2BhEP
         yN926GxYBFs5YJjksZhnGvC0mHh0KHNIDEpHFuTdbEl9a1WKc6fJoY3ie7/rGGAd/z56
         TPikk1V5EL5/FUlZ1gOX1nfH893taW28NU4w2KTrFcaHIyisbQeKwn/+/HHKXyRUnBME
         EZhRseW2zI3VVZrqxiCDffYwiTy3QRzvjQZ4b2VXpea4cbWXx285c9wiLsqtsBR9GWMp
         2Nus3fC3D6Dm/CG10edM6mFR0cBtpFYDt0l1oER+basu8NF458vcg1SSmmpraTAT5uSt
         ELRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zKDG/9XZbnGW4hCDetg6B4UM+/yqlFKJwoWhpahy2EM=;
        b=EOe1PcehjVqahAysAo6F7jQpU+GwsbpQq1o+o6eXRK0+JNEO9QWE8u7mDT9ruaQfPi
         f0/DvLXhVUxG+IVJ1vNg/9SGs6Pa1VPBMomiWXlMIexRtIYjmEHZrtOtRLDwn+OB6v0x
         NkePCawB8Gdx/kJCQ0IKXWZm+Ga7BShmr/K3NGRHctD1wgXBEPOevMlHqQyqsSChnxGY
         UTzPFLPhs5HE1fnO2DwkRi28nrLm3NLt8hn5YTYnn+D/VkIDaMkbDe9oXvSoybFk4wlG
         IQVg5KhfqJY00bmvpghJZ9aW2Nq/qZ3UgKG2vDN7i7ozlOMsSsQaOMT8SPi4FEfPMk1w
         uzdQ==
X-Gm-Message-State: AOAM533bu8ib4ct4lgtz5ex2FnXqYyhj4z51VcCfZqEWjlAkxjsH1LHs
        hLlfbVgwiphGqdnZTzhHcE+5qlVITw0=
X-Google-Smtp-Source: ABdhPJxa19gcyH131NM7LeHoIa/bP+4FOX0BpqZ6GNCIUWyIibH8Up+oxkyVYlXzFrY0bLcYRoUm1g==
X-Received: by 2002:a5d:6845:: with SMTP id o5mr14273548wrw.421.1607699324498;
        Fri, 11 Dec 2020 07:08:44 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:43 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 28/32] kernel-shark: Add ksplot_draw_polyline()
Date:   Fri, 11 Dec 2020 17:07:52 +0200
Message-Id: <20201211150756.577366-29-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The method draws continuous line between an ordered array of
points (poly-line).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plot.c | 32 ++++++++++++++++++++++++++------
 src/libkshark-plot.h |  5 +++++
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/src/libkshark-plot.c b/src/libkshark-plot.c
index c9a3530..597e5c2 100644
--- a/src/libkshark-plot.c
+++ b/src/libkshark-plot.c
@@ -151,6 +151,30 @@ void ksplot_draw_line(const struct ksplot_point *a,
 	glEnd();
 }
 
+/**
+ * @brief Draw the a polyline.
+ *
+ * @param points: Input location for the array of points defining the polyline.
+ * @param n_points: The size of the array of points.
+ * @param col: The color of the polyline.
+ * @param size: The size of the polyline.
+ */
+void ksplot_draw_polyline(const struct ksplot_point *points,
+			  size_t n_points,
+			  const struct ksplot_color *col,
+			  float size)
+{
+	if (!points || !n_points || !col || size < .5f)
+		return;
+
+	/* Loop over the points of the polygon and draw connecting lines. */
+	for(size_t i = 1; i < n_points; ++i)
+		ksplot_draw_line(&points[i - 1],
+				 &points[i],
+				 col,
+				 size);
+}
+
 /**
  * @brief Draw a polygon.
  *
@@ -212,12 +236,8 @@ void ksplot_draw_polygon_contour(const struct ksplot_point *points,
 	if (!points || !n_points || !col || size < .5f)
 		return;
 
-	/* Loop over the points of the polygon and draw connecting lines. */
-	for(size_t i = 1; i < n_points; ++i)
-		ksplot_draw_line(&points[i - 1],
-				 &points[i],
-				 col,
-				 size);
+	/* Loop over the points of the polygon and draw a polyline. */
+	ksplot_draw_polyline(points, n_points, col, size);
 
 	/* Close the contour. */
 	ksplot_draw_line(&points[0],
diff --git a/src/libkshark-plot.h b/src/libkshark-plot.h
index 063740d..d881b20 100644
--- a/src/libkshark-plot.h
+++ b/src/libkshark-plot.h
@@ -72,6 +72,11 @@ void ksplot_draw_line(const struct ksplot_point *a,
 		      const struct ksplot_color *col,
 		      float size);
 
+void ksplot_draw_polyline(const struct ksplot_point *points,
+			  size_t n_points,
+			  const struct ksplot_color *col,
+			  float size);
+
 void ksplot_draw_polygon(const struct ksplot_point *points,
 			 size_t n_points,
 			 const struct ksplot_color *col,
-- 
2.25.1

