Return-Path: <SRS0=okv7=Q3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C37C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Feb 2019 09:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 205CA2086A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Feb 2019 09:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfBTJQf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Feb 2019 04:16:35 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55755 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfBTJQf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Feb 2019 04:16:35 -0500
Received: by mail-wm1-f67.google.com with SMTP id q187so5796865wme.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Feb 2019 01:16:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oV/ypSNUVMHb5ratKfeca/b65OtwvHaoNPoKeHd5bUo=;
        b=rUxfk7FUM/xt0VRqNsDWW3fJrIGrr9zCFSEIiMNUBTHsbVja4JLa9p35si4mYL31dT
         lvViR7uxIZcQUFjKy0v2cFkALdObP4Ba6k8gCoXMMyp6J4cafSqIPEcGEZTR1IKz0UOA
         7H1GP4UbqxTqOcQyUpqXme9T09YOHt9P0JgReMvtXG0uS1A6VM2bkURa5QB1WxpOnhde
         M8oTRnPl+HWfGj0ewtGJiu00l8185v/pbvGi4CBSE8nEoftLEP8S532ej39osNH0mZZu
         Lwtsp0cFPR37PJLSIESnqMf3vRfTkJbn6K2z/TXwLemw/unF3LaQnMQom39hFLwjhp26
         c2HQ==
X-Gm-Message-State: AHQUAuaSStQHVfFc1X3uobnC3kegK3/kaoLwVsNhBReWw0KKhr2aY7h4
        WiV4rvYLXQoLkZ8RAi1o8MVh7S8p
X-Google-Smtp-Source: AHgI3IbikyDzEAD/a5aWuuwSOXrUg2T2yT8HKNhRW0+KJ1kbxWcWfbEzp8QFmiKSAvEUj2nJzcwpIw==
X-Received: by 2002:a1c:1a08:: with SMTP id a8mr5644960wma.37.1550654193228;
        Wed, 20 Feb 2019 01:16:33 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t18sm7498309wmt.8.2019.02.20.01.16.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Feb 2019 01:16:32 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH] kernel-shark: Fixing the fix of ksmodel_shif_forward method()
Date:   Wed, 20 Feb 2019 11:16:10 +0200
Message-Id: <20190220091610.10699-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As explaned in the change log of

e54616484 ("Do not copy the Upper Overflow bin when shifting forward"),

the lower edge of the Upper Overflow bin is unusual (shift + 1). Because
of this, the content of the Upper Overflow bin cannot be copied, when
shifting the visible area forward. It has to be recalculated instead.
However, this is not enough to fix the bug. The last bin of the old histo
cannot be copied as well. This is because its upper edge is shifted
too (+1).

Reported-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Fixes: e54616484 ("Do not copy the Upper Overflow bin when shifting forward")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index b71a9b8..b80f71e 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -488,23 +488,30 @@ void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n)
 	ksmodel_set_lower_edge(histo);
 
 	/*
-	 * Copy the the mapping indexes of all overlaping bins starting from
-	 * bin "0" of the new histo. Note that the number of overlaping bins
-	 * is histo->n_bins - n.
 	 * We will do a sanity check. ksmodel_set_lower_edge() sets map[0]
 	 * index of the new histo. This index should then be equal to map[n]
 	 * index of the old histo.
 	 */
 	assert (histo->map[0] == histo->map[n]);
+
+	/*
+	 * Copy the mapping indexes of all overlaping bins starting from
+	 * bin "0" of the new histo. Note that the number of overlaping bins
+	 * is histo->n_bins - n. However, the last bin of the models is
+	 * unusual. Its size has been increased by "1" in order make sure that
+	 * the last entry of the dataset will fall into it (see the comment in
+	 * ksmodel_set_next_bin_edge()). Because of this, we do not want to
+	 * copy the very last bin of the old histo. We are going to recalculate
+	 * its content instead. */
 	memmove(&histo->map[0], &histo->map[n],
-		sizeof(histo->map[0]) * (histo->n_bins - n));
+		sizeof(histo->map[0]) * (histo->n_bins - n - 1));
 
 	/*
 	 * Calculate only the content of the new (non-overlapping) bins.
 	 * Start from the last copied bin and set the edge of each consecutive
 	 * bin.
 	 */
-	bin = histo->n_bins - n - 1;
+	bin = histo->n_bins - n - 2;
 	for (; bin < histo->n_bins; ++bin) {
 		ksmodel_set_next_bin_edge(histo, bin, last_row);
 		if (histo->map[bin + 1] > 0)
-- 
2.17.1

