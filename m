Return-Path: <SRS0=Bo3z=VA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694A2C0650E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E67B218A0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R26TYqwK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfGCMKw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 08:10:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40591 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfGCMKv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:10:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so2508286wre.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Jul 2019 05:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j7cr3StBGwcU2SsCSs1GWd+RPeSNRJZkMH6+uCYOwWc=;
        b=R26TYqwKPMTxfDg5DRJI+vWbfyafT7ybA3R7lfRVbmQEJreokk1eSMWR/w9dZ3r2UQ
         zqomm+p0kDaHZijWBXy+2NsExxQurSDtTTjsF91eapEvTGRNBSeyc2dRA7bBvf1a5EFf
         vsFD9ycpN6bqurReGV88r4mRtayfii5nsQecHU3o8nND10UEpmVI6ALtCG17yAjLsBIU
         k4dBLq0MdtIqpOHDaoJOrQ6fHkdwz3l36wN8ug2KSqLRZQBPpJT4+aDO8ZyfDshze/BH
         hSJ/BSwQ3XE9wp1CFFsdHt2loOi/6cqZui/+H94wynOjwRTSaE7CyZz8kxWpqw3G4y66
         qK6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j7cr3StBGwcU2SsCSs1GWd+RPeSNRJZkMH6+uCYOwWc=;
        b=RBWOSiIcobZRKyUYWzXpHFl/ySsY8eH2i+fn+yxYqjCFw7zaElmw9fP5YGeHMpfR+E
         DvoXlRsWWm8FSQXqMVUDbIi4r9ECs6cBJ5KP2sgaVm6fBHBr5n54fMi2AY7pRfS93KMU
         aKGrRxkNVAgZP3cQ1dhen38gfmbfGXOh97AmTwK5ensLQYkVyRc3e4o5W76nineCdkK2
         nD8OZJbDZvV49y7T3UZmTAwcOwOvgS2Jw6h718miOYjWGpeCDPPRKb+I5Zj7e59ud/q9
         pWBxgAk/fN7HIQSMeqitoEKm7ue6zKvsovGQP9daWhGA+pcORi2wKK1iO92LsXkASFsA
         DCfQ==
X-Gm-Message-State: APjAAAUTucCdYA6l+egoIE3so9VOd28nZ0dWl1k40IHmjQZ7k/5CcCcO
        bAC7nVRYhduHRbmUeX3sZ64=
X-Google-Smtp-Source: APXvYqxfQgIbVWMFeY+3KhwptsiRBsWdatKD+Dii2ILoCKOdn9LPOr9OZbKag9YD5iMRvLpzQbs6CA==
X-Received: by 2002:a5d:5112:: with SMTP id s18mr27779252wrt.111.1562155849911;
        Wed, 03 Jul 2019 05:10:49 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u18sm2321587wmd.19.2019.07.03.05.10.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 05:10:49 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [RFC PATCH v2 1/5] kernel-shark: Simplify the drawing of the Triangle Fan
Date:   Wed,  3 Jul 2019 15:10:19 +0300
Message-Id: <20190703121023.16655-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703121023.16655-1-y.karadz@gmail.com>
References: <20190703121023.16655-1-y.karadz@gmail.com>
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

