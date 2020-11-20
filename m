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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D00DC64E69
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDE8B204EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:51:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jfJUqT0u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgKTJvK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgKTJvA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:51:00 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DBFC0613CF
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:51:00 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id oq3so11995013ejb.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yR/qujtOr8QwAikDvDtixGi/vHgY3HrOE31R5AsbXRM=;
        b=jfJUqT0ukMv6lDBSyN+j7Hdg5ZzN5yI7U7uo5mcdBRqRGmLjeWculhexHIM4Oiozxx
         VohOcsC/6Cow5sMGVvvU4XiV32qR4puf+SqyJCKwT87hkqEGH3d0MKFAjAYjeHijMItG
         2n32ozndl7REEj1veKFUH5/Kiyg+Pa0xDGXi7ZmkTeFG+pJXGOfqom42SpMgXJb+lW1k
         /PPxkxOK271lzrsf6Vpl0rp1+CI9jltgqxgUhzaExJddoCHH1sYc0smkzRtkm6bmY4U4
         wWj41s0SKLW3bQi/xYiUtCMNRpZDNjkcH4HfoP3MvidUG/sRoPJGBivOqFvie/3aOjO2
         0YJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yR/qujtOr8QwAikDvDtixGi/vHgY3HrOE31R5AsbXRM=;
        b=RqeQmvntbk3/a/GtZXDG6qkDw6nnpb21rpakBSlwuToYZiufScNj7R3miZ2UmR7XRD
         zXDIB3/nLVFnQPbNX0PBpFC2CZag2RLOxbn2EkzklQQWW0JzNx0H74Ftl7xBkLrEDmCr
         hxyGpJc6ysNmUlYhv7rDuFAWFL95XekxtM0ZwFH2H/0QnpxHs3BtVAa9lCyEFPvwM0Ij
         ytkhaye4FZkshMTMSFjmiYfEmYXq5YbXqs5zBIdde5MBvpBUyAg5SlTbqMbDQDxRmVQV
         NX/v2+jUpfwlwdgobRiFwzzLWwanahpTxqnWwr9nmM+3XGFoHHynZe3yw8JGIbuhKvdn
         wzFQ==
X-Gm-Message-State: AOAM532WwN4SKTZtHie69P4o97WKd5plDkS7SGEpRlgWFEYNh6c7Re1n
        P1MoH1rMMQKOIhu/QJIeI4EL8KuFCaI=
X-Google-Smtp-Source: ABdhPJzttlbSzsznTL5+oZRaWz9b4Ju69PFJf7wtt3623qKgN7cCAwejJ/bsAbKJbnZtS3Po6gQ34A==
X-Received: by 2002:a17:906:6091:: with SMTP id t17mr2533970ejj.476.1605865858969;
        Fri, 20 Nov 2020 01:50:58 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id e17sm861995edc.45.2020.11.20.01.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:50:58 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH 4/4] kernel-shark: Optimize ksplot_draw_polygon()
Date:   Fri, 20 Nov 2020 11:50:31 +0200
Message-Id: <20201120095031.271735-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120095031.271735-1-y.karadz@gmail.com>
References: <20201120095031.271735-1-y.karadz@gmail.com>
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
index dc49fbd9..7eea811c 100644
--- a/src/libkshark-plot.c
+++ b/src/libkshark-plot.c
@@ -200,18 +200,9 @@ void ksplot_draw_polygon(const struct ksplot_point *points,
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

