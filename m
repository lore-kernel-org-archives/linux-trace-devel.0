Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212F9C1B0E3
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8D56205F4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732628AbgLINoT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732623AbgLINoT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:44:19 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88A6C0619D6
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:42 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id c1so1787176wrq.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=py/C/u2mTsZdNHYXgzsIL4FdMR9QvY8/lsFsB3cqVGQ=;
        b=NbMNQgE68Ug1oZTFdxt66R45wCe5wxpylK9GSx0SueVvNC2tXfaEma9kMxTsqofDQX
         /vdH981or3YCUoPZEgvHSACTZRYT8G2MwFMWLom4gOY/xckwRybolgou7UTFQV9YK7rh
         DTjSzeEgk8F7xSuibAtOm6+Dkvn1cgSCyz02PLeMO9vaHMp1XcrGsUA4Z49R/iOk+Sib
         Uj2vKmZndk+hwV9kJzaQMSxAxv/D+zGWfS3zrpuR8BenFKbz2YdTSOSxgBheNPxxaQwz
         JbQOx7yBYtQ8yv6acynv8/lShnnxXwYGoXTcm0rpinmXDwsOC6f8thbw4CvkPc7QEGvS
         3SAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=py/C/u2mTsZdNHYXgzsIL4FdMR9QvY8/lsFsB3cqVGQ=;
        b=IWK45DVDxy4LGzr22TOK4DP+JQtOjDmsKh5BymZA8jEIDtfrG7lKsf7eGeJ9KXrKVy
         gPHlHzgcuqvZwMDk9JUr0RUMcAMA4V4xwZHPRO7EQQ1CnYYr0yvkapjKCobk7uxeuJ3u
         1Imol1dRsA0jVl0TABeDsi/GxVpT6lJ5iHhdhzyZHjL2LmBOWlC7+NHDyW6J2U0f/yOo
         pXvqH4iwxG/Z/OAcoumMDdN1xIQavRYTGXhMWEnL4nBlUQTmVrOiconBSWwkQyTcNRT3
         RekSsiTPhK5yKhDgA154Cz1iht00hnNfDjOqFBs24bUKtrlBt1Ahn9XGNL63UXr7ETv3
         Ck/A==
X-Gm-Message-State: AOAM531CMoUUZCXCQM/bGqME35oe0sNmkvEc4j4UacBPkckoFHgXdI2K
        V1ivhZLf30NuwSu3WcgZy2w=
X-Google-Smtp-Source: ABdhPJw58suKZwntaZn6bd3+n322j988VN8WobDkYPk7Na0qlBGO76QrG2vBx85Wtmm9Ej4pEytEDg==
X-Received: by 2002:a5d:4e04:: with SMTP id p4mr1450976wrt.373.1607521361503;
        Wed, 09 Dec 2020 05:42:41 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:40 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH v6 24/27] kernel-shark: Optimize ksplot_draw_polygon()
Date:   Wed,  9 Dec 2020 15:42:00 +0200
Message-Id: <20201209134203.428068-25-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using a point inside the polygon to start the Triangle Fan looked
more intuitive to me when I first implemented this method. I guess
this was because when you use an internal point to start, the
resulting set of triangles looks like fan indeed. However, as
pointed out by Slavomir Kaslev, the Triangle Fan can be started
from any corner of the polygon.

Suggested-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plot.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/src/libkshark-plot.c b/src/libkshark-plot.c
index 32848b0..22a3e63 100644
--- a/src/libkshark-plot.c
+++ b/src/libkshark-plot.c
@@ -201,18 +201,9 @@ void ksplot_draw_polygon(const struct ksplot_point *points,
 		return;
 	}
 
-	/* Obtain a point inside the surface of the polygon. */
-	struct ksplot_point in_point;
-	in_point.x = (points[0].x + points[2].x) / 2;
-	in_point.y = (points[0].y + points[2].y) / 2;
-
-	/*
-	 * Draw a Triangle Fan using the internal point as a central
-	 * vertex.
-	 */
+	/* Draw a Triangle Fan. */
 	glBegin(GL_TRIANGLE_FAN);
 	glColor3ub(col->red, col->green, col->blue);
-	glVertex2i(in_point.x, in_point.y);
 	for (size_t i = 0; i < n_points; ++i)
 		glVertex2i(points[i].x, points[i].y);
 
-- 
2.25.1

