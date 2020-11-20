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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204DFC6379D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:51:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1BC6222BA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:51:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kqI6RXlI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgKTJvA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgKTJu7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:50:59 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53203C0613CF
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:50:59 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id i19so11994099ejx.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=czyqGmgKbCcgaaaHz6VPe+qqM2yow6LxeEk/djHfMcE=;
        b=kqI6RXlI5s/bTR+nXHHzkp2UPn3xFJeBX34HhFVW0tnu9k4SktQ+O2TcVtwAiIzyPy
         +hynI37jkouDYdoLrA+yZ8EwdLf/f9SHW6E3G5PJYxvb96cMKcWVgtTz26y8hGqH00X0
         U2WdOmtGZPlk9I8sVbZTZ22GItVyTWNEcXv+mQuusNkRujx25opdxLo9EHVrc25puk22
         6udKWhwVvckJejhEJZkCLnYH8pJrS5Am8hB2kmddU/3XGYNik7Q4QCwJReJvT0xGsRNR
         Lpy1dieb+alt3quoKAhv+YUToxPMQyhJUQid6GYrKHgoTJyiFhuDkjEE/WirR9TClDgX
         CqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=czyqGmgKbCcgaaaHz6VPe+qqM2yow6LxeEk/djHfMcE=;
        b=I98VdHRQGRDubJSXCnI+EjREsaAH9YYdWNFgB0//kJHzFrafsYKwAv/kOHdB90uKdw
         fzI+Qce2zBWCqUHbsKV5PDnbCrOB4ueu3PBvJ+KJqe5zQ4AObYO/ZMyxkGaeE0Q1ewRw
         J2ZtM9Ny5bB8oBMJFYUtyddgc/5TXU469q7qKCwARnulKE9cF4D3K54KJcJXZK72hUMM
         SRwQBwJwNb/kEbACPVGtNu9IvldgUkcwSjiw/C9KGnJxaxcwoRQ5xsvvexh0PTqPwbbb
         T0laBrY2O2+Zr+6ft4l+gOZrgrBGIhKH81/2cy7Brd8eMsubfhxzNL/0dqAugWqprDWm
         mv5w==
X-Gm-Message-State: AOAM530PLc5n8BbrZxWj6q40r7EBJU48a0UbpxAH14UEg3IXQluTTaMt
        j+I6IL/RAPahB8uVDAqye3s=
X-Google-Smtp-Source: ABdhPJwQ8PyLPMSHRgb6eemZEHeCCaQk5EgdVAlXvKXynSBqkp9cdDkrt03mM5+kK2hyz3FKQMymfA==
X-Received: by 2002:a17:907:3d8d:: with SMTP id he13mr15523254ejc.306.1605865858009;
        Fri, 20 Nov 2020 01:50:58 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id e17sm861995edc.45.2020.11.20.01.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:50:57 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/4] kernel-shark: Add ksplot_draw_polyline()
Date:   Fri, 20 Nov 2020 11:50:30 +0200
Message-Id: <20201120095031.271735-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120095031.271735-1-y.karadz@gmail.com>
References: <20201120095031.271735-1-y.karadz@gmail.com>
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
index f2c5be30..dc49fbd9 100644
--- a/src/libkshark-plot.c
+++ b/src/libkshark-plot.c
@@ -150,6 +150,30 @@ void ksplot_draw_line(const struct ksplot_point *a,
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
@@ -211,12 +235,8 @@ void ksplot_draw_polygon_contour(const struct ksplot_point *points,
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
index 063740d9..d881b20a 100644
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

