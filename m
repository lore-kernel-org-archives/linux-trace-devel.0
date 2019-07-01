Return-Path: <SRS0=mM2H=U6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D0BC06511
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jul 2019 12:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 390A120B7C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jul 2019 12:17:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uf0K5eXY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfGAMRq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 08:17:46 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55652 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbfGAMRp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 08:17:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so15625658wmj.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Jul 2019 05:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j7cr3StBGwcU2SsCSs1GWd+RPeSNRJZkMH6+uCYOwWc=;
        b=Uf0K5eXYaC8doP0ZRP9+KpoV4etBHPf6KIg2Zd9Iwzu6JYCwtLMgy2iRdnyXZQS4h8
         xKSLXo/RNhiLP+MQM8tcgoAaMFaorXJAuAeXt0MT+8sSfa0vjVQdtDLDsLQftfbqVOo6
         6aObWqG1lS8ePtNh6pHFJvHfsRyvHLVxcdFidMLdNWI8X+DXfcBU1zUpKmLziXg33S+B
         N0jIJ57d58UOf8jvuiWdeliJcKrbR3WTlq3i5RBY7gW9f6J+DhRfknkD3nSVMtCtf+Cq
         epO4jAqSt4grtw/jm/2EEgxeqdXXE6RqXsH1SPBCRg0PwwTbDWCQAmJHEJ/uCgX+SdxS
         Cs6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j7cr3StBGwcU2SsCSs1GWd+RPeSNRJZkMH6+uCYOwWc=;
        b=d7sZO4H3Seq4oNAh0PK81hQcs4O9W5Tayi/GCLbMdd2cDC4am6je84O+vl2LINN8M2
         GScyDaLXS1jUhMTGvxme4DdihEJplpX219bZl9lDbDW/ua1aDkxhXpb1gvlmb9m8P8sa
         vbfTKC5J/A8uBWkHxcn2Bqs4bm5mgd4ZVtkXtp3NcseFKysIBrf3lWRpVFio2FTxzpB3
         AlEMrLT0bLEu4EnduQ4OgPOtBo1j59vFQznX6Cv2J+44XwAPLxJ1aC5GulN8LBBtGKOE
         6BHDbdX/x4JnvNKyRytDm9f382f5t85CHg4xWQ4snphqG9gNd/x5omQsz/eBPPGQi8on
         Oyvw==
X-Gm-Message-State: APjAAAWyF02blnUC6FTdlQ+WtOgWynQXeNMF9ZI4HtM32T/wRbg7w0m3
        ef7XtvvKiDBa0UNrsEvZ0dE=
X-Google-Smtp-Source: APXvYqwsabadEhyEnLy0hybmqzbFivvyLE+mEjQHuv3gZPGKM1vIUtdvg6YVHqyiatSfCSn4l6Ctvg==
X-Received: by 2002:a1c:2d8b:: with SMTP id t133mr16941726wmt.57.1561983463798;
        Mon, 01 Jul 2019 05:17:43 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g11sm8382520wru.24.2019.07.01.05.17.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 05:17:43 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [RFC PATCH 1/3] kernel-shark: Simplify the drawing of the Triangle Fan
Date:   Mon,  1 Jul 2019 15:17:18 +0300
Message-Id: <20190701121720.18009-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190701121720.18009-1-y.karadz@gmail.com>
References: <20190701121720.18009-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The central vertex of the Triangle Fan doesn't need to be an internal
point. The first point of the polygon can be used instead.

Suggested-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/libkshark-plot.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/kernel-shark/src/libkshark-plot.c b/kernel-shark/src/libkshark-plot.c
index 17d3b90..cdd0ef8 100644
--- a/kernel-shark/src/libkshark-plot.c
+++ b/kernel-shark/src/libkshark-plot.c
@@ -162,18 +162,9 @@ void ksplot_draw_polygon(const struct ksplot_point *points,
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
2.20.1

