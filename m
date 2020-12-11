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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1ACBC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62E9423329
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390790AbgLKPKf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391079AbgLKPKF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:10:05 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8295C0619D9
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:46 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id q18so1847660wrn.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YKJ0ck+D7lqWZ+gFM/UvvOKOIz8ieUwF4FUzkeQfx6I=;
        b=rmD3yX20XBeHTNfWWKH95fRMFH9W6HZKTUGBhWSYpiZmSCX0CTJwNrOgnW4ZxISbE8
         zibqa/cJ4dw8gotCvoFAfbUX9JK1bVWQmCeFwuZw7lt+Aq52/Bc3gvzPkDHnhjBRPCIo
         R0grEl5NA7XgrA1bYR+zqfvGkWoY8dH4kVjGOo2ZYoU98x6B0qXthHxizbr5PQOY40eP
         7Rcxhzz8aYXkoGPVHV+UdwNBjIgLRA0ZuGq9anFvv9kC/PB2imQDrpdDQ+5xPNu9k0bp
         6EyEhooXtHVJvOyZ0C1TgVEITI8ABzqYnc9SuEp/NIb1qbe6Cz67fvDZOB6CR6ltd8/n
         9geQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YKJ0ck+D7lqWZ+gFM/UvvOKOIz8ieUwF4FUzkeQfx6I=;
        b=X9wgtTZDtnrwUSiaqialOrOkuN/5/OFIhl+dnTfMPbdU/bFDAfA1zMQL98qx+xB0Z4
         /QSg3l+IcZwf0p3T4dm2IZ4gfxiSxSvaph5HzoeoJKw3NcHteC0876p4R3qIQYW56WC8
         7VQW39Q02sYwtY+jX3h4Ey1bvwLRbUKbwjdOLn1/ZmOki/DLwPAtnlDRimF84GmoRIMz
         eqTFYTjhLs+ScgK/xh/l3Qy6mqReonv+kdr94AdlvOSJY+6jEdIgehQyL2znGhNDn1EB
         3wQjxaGFnXnzvORm4i2hlJ5JBdaRpqySvlTP6coBPHVq7egnYx8/FbWZti2mRhnKV/9W
         h2zA==
X-Gm-Message-State: AOAM533Cm7FhJzFI8OH7HWZrhHnWWotWho/QlP1zyPkmBXjrK6+D4fu+
        99jsTj3sWi9oKtZy6DBFEww=
X-Google-Smtp-Source: ABdhPJwbaI06GVWMe9nU7GyifX10ZmkLhUIZcJaJBMoHUW0ffJR7Rzg1jfz+AFR4SSTQprkuJm5jIA==
X-Received: by 2002:adf:f9c5:: with SMTP id w5mr14322754wrr.69.1607699325643;
        Fri, 11 Dec 2020 07:08:45 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:45 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH v7 29/32] kernel-shark: Optimize ksplot_draw_polygon()
Date:   Fri, 11 Dec 2020 17:07:53 +0200
Message-Id: <20201211150756.577366-30-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
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

