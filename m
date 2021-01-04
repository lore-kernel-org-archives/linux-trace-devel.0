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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B49AC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75B2820770
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbhADRtT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbhADRtS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:18 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E338C061386
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:10 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ce23so37888869ejb.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zKDG/9XZbnGW4hCDetg6B4UM+/yqlFKJwoWhpahy2EM=;
        b=CrgSuc7i0aePli35g6A+EOBip51HFsyA0gf2thI9CqPsddRH6mWeskG8gOe9Q+lDCe
         3ia4BairaZkcE1FHnYwHkt9dse2FJxe/JFoot2OYVKREe7TQX3LPabiGCmQUgt3zTYym
         0V8LzdWx/NYa4t6KJ1i9UsgLTtkTz2d1qdXcqbwziK0sTmueSM79CTc919Vger65tB5D
         RfLZOgy8i3yomVKWLLpA1jOQgV61bkWV4MhCn5sLlgRIJ8jhJYpwxMvJrXRv9nfS2XCT
         BUUMVwi71tgdsAcdysVApbNJIk1Y+sYSjZ1/+idOIN1jFHy8+na6qvAygmRacg6LjnSM
         Azzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zKDG/9XZbnGW4hCDetg6B4UM+/yqlFKJwoWhpahy2EM=;
        b=NOUigK1NLEBwWU6q/xqWqHXo1v5kYy6HyYxi+tl9l7HXTBWFdo2TcME+G3UsK59DH5
         xRAvrokCXxLzpLKXMlsZ8dansOegiblF5GvPy2X9vYuKh3YFxYJ0/VrSAzy/q9CY8N5t
         wCNXRxDwI1/rlHh3IzQXpgJtSHsTxTZkWud/RazABmeh+MZj0C8EyCCJstH4ul5t0DR7
         t9LUekCL5vVX7ol2RlnvmMD1akdG1z+0mp2ytQAVAzSyndxaQaTw0VylD6VBSVwMZqH7
         Gytx/NgK7wpNuN+AeBh1z2Xjhc++B3SB1BcZGH60ho9guv9wv/ZUXfwvUU2wnuYSQ2nu
         AgTw==
X-Gm-Message-State: AOAM530EkHLej3Afnnydcv4kXAHT43yJLc8dd703+WTqMUG5C3hw8bEN
        GahZ44CMllhGQf0t/fWPI70=
X-Google-Smtp-Source: ABdhPJzVZAMK6qnegBjH7WQkOr7a2qHy6ZwhzLuWL4OpMgMiaUnMecA82yaUunEMLPJBAgg7G6YW9A==
X-Received: by 2002:a17:906:4050:: with SMTP id y16mr65557260ejj.537.1609782488984;
        Mon, 04 Jan 2021 09:48:08 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:08 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 31/44] kernel-shark: Add ksplot_draw_polyline()
Date:   Mon,  4 Jan 2021 19:47:11 +0200
Message-Id: <20210104174724.70404-32-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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

