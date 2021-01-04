Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C8FC433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42B86206B2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727475AbhADRto (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbhADRtn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:43 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA3AC061387
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:11 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id jx16so37859776ejb.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YKJ0ck+D7lqWZ+gFM/UvvOKOIz8ieUwF4FUzkeQfx6I=;
        b=YxuUnMv72oT1frWhiouKTziXT07VRGxUjLgB6y0gsOIi/0TnRXQnwm1to8FVWSvSOb
         Y87NYR9fzx9JG7xbBIC2fvPkrv3fsB+sRx07Ug7rwYL9F0PqQ4GJCqDLjJqoavS9bPJv
         ZAtAKh4KvDlGGXsi7KDHAMA42kZ0OkYQHd3qxRVop0HQjlfHDgtt4WWw/wbb4aNlSAyR
         VsNYFLLe3at7rryRRrtyeRRHZkzotRV/iKQUx6K9yCgXpTrtV4IxkbJjnx838xQcUy0H
         XhgdhPMOTkgVPmsxpXcBhSuo05pPpXtl/bgpbcy3gSxUSPSFpQCacpVEuS01cFuBB32w
         Nfig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YKJ0ck+D7lqWZ+gFM/UvvOKOIz8ieUwF4FUzkeQfx6I=;
        b=Kz2r+Fdhv9h1t3Q5jeBmr95qndlXGSWZb12c0Zubhm6C1eei3CyJu1qYbjeMjKQpZf
         KQktwPf802OjpNyR2lznm3x7l9kHPXdYFI5bpVhMZkCZovMw1SSkgnkKh3M5pCfWmL64
         9JppVDskvuUpJObf1/RWHlNMBiIXxr4JEC9xs1RlCOcvFWkjlD5ANyfMJc8tip+WKvor
         o968Qkekiql94v67RcFfeRD88dN3tpP67gXuSfBjHQzrsOHtoV+gLigjgym2UhIcmkNy
         QjGtS51AzxdOCCdhugvCtBYBZHvWLy/5EJ+/caCjbWspAelFRF5HrYmksPOPo9BdVmYg
         vw0g==
X-Gm-Message-State: AOAM532sg4UV4wkK4yTuu7agcfq5egdIJcdvPU5TI/f2RpSummPT+MG6
        GerdS1JCiPxSy80XIADhifY=
X-Google-Smtp-Source: ABdhPJwezPfnrSBmIbRjGTDpqCpL2WjwAiehkMPnJCVSWAfikxiohbCPYQo9IyrFBsHY4dR+/QOyOQ==
X-Received: by 2002:a17:906:9588:: with SMTP id r8mr66199910ejx.148.1609782489907;
        Mon, 04 Jan 2021 09:48:09 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:09 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH v8 32/44] kernel-shark: Optimize ksplot_draw_polygon()
Date:   Mon,  4 Jan 2021 19:47:12 +0200
Message-Id: <20210104174724.70404-33-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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
index 597e5c2..5fdf4ca 100644
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

