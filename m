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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D74C2BB40
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E02CE239E5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732624AbgLINny (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732620AbgLINny (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:43:54 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90603C0619D5
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:41 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id g185so1718935wmf.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vqKUdTMbNdkQ2E1csPkmtzY+B4Tz3Wv67zhhE43J4js=;
        b=pYEfhVE2tdepLMBkiNzn0C87+0tGFcfiGY4Z/BkfZTeOaUIAs6cO8SQJ62XVtXTCkg
         PsYzOH15/FYLddUu4JP8sRUzwnaSn2H3jQ6dS9a3E5OSnfwE3eL1jXMNScORbbuESCKw
         uJZpjzg/9sp01Zx1779RX9OD4lYngn+RztuV/pLrQA9VTjVMykRJa2pT6ryQjkyEY2h5
         z7qvZ/uXK0h+j8WJ7OdXhHyqtdFZ5a/cF0f+LPLppu8Sc+AErWJHEVeV9SHhK+Z4szRO
         rpDd0rzNMUq+9PCfjQQrH7wUcGWIRJJoiB2Q3yPuC0s1PtZvDr2/pZFdDXiRV8ASP/vB
         hC8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vqKUdTMbNdkQ2E1csPkmtzY+B4Tz3Wv67zhhE43J4js=;
        b=gbQy3KVI0MCR2vKCFhtFM4r7ROibGBVHQKoNlvGaLcJpPANUu8J7SjzsYZxUjriu1M
         NYNRuDdbuYyM4Trs1ebdf2mcIOXAk/jgRrkzspt8YKLaTiEtUAa70gdrHPDBBiTa+j2w
         NQZU+LxlsLsLa63SM5awrVjograa4Zdp6mWSPebKU1eDJQ/XHUZrIQXzpKC54kL1A+wE
         jYNVv7GbDFYUu7kkMFULwu/0mqqlJa8daOsMmlL9JDAjOW/tGVOTx+YRZdO2fk/daNqs
         Nn2wAhnmnM5i5vPNpNBfu6bK5luwwaszkQmL2rpcxEjq4vBn3rI18rSUfst6L1Nm5fYc
         1zpQ==
X-Gm-Message-State: AOAM531/TygtkJ+iuezpCFRIqBAI2qHw0Ntpg/kglvXLdy0xutOcqDwr
        /9mfXXB1D/9YR3bBhxA2AKsCAh8J6io=
X-Google-Smtp-Source: ABdhPJw/bVHBsij5X7fCEqeVvgw5gvUbdH+K27HUpVidyI3miV2rH+mtCYGAn/MFvCzbu7jEY8Y2Pg==
X-Received: by 2002:a1c:bc02:: with SMTP id m2mr2848292wmf.59.1607521360321;
        Wed, 09 Dec 2020 05:42:40 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:39 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 23/27] kernel-shark: Add ksplot_draw_polyline()
Date:   Wed,  9 Dec 2020 15:41:59 +0200
Message-Id: <20201209134203.428068-24-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
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
index 1c45f44..32848b0 100644
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

