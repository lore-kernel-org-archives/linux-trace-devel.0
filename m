Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DD63C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F394820652
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfCGPno (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:43:44 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34005 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfCGPno (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 10:43:44 -0500
Received: by mail-wr1-f65.google.com with SMTP id f14so17977841wrg.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Mar 2019 07:43:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0NlPH1sx2DN6jL09JWk0KaQC0Aq8UtRh2ftH7bTprAU=;
        b=Q4hzPNDqE3kZaHj1mnijz8G5K0uX0W9bFn2Sn16cmMJ0sej8DdRrkA8dQ2yz4GL21V
         +PrAhFYbDhrxgMIiP8/KaF3Z/XNS+Ig1YIcDxoGfFK96dN5lz4zqhpp0BD1tKLgRiOaX
         Gk5SmJej72+7Q+500wu0V8QngJ49sNMsl0xf8bx1WkmT3P6IZqp0cmtL5xWTX8yfZfN7
         lSaODsbWniyUmCZNITevMC9IEZl7t2vR68KpaXhZcXDDTcjzJRVNBJy7fINC+lG0I9DY
         39SuI8kAITeD+9d5sn4xg1CjFgeai7xYBKua6yjDmW2WToDCG8J66XPdvDEPqDjlSRkF
         bvJw==
X-Gm-Message-State: APjAAAUYfJ7hZufomcd9GUpzEohxaQaRwNo17kQy9TX44L1TXRDTUSkc
        DmGWpNH4ROjXRGVThlSWtHs=
X-Google-Smtp-Source: APXvYqxva+ydjn9MwlGpgqoMc1vJkSzFkegpNofVY63ld6DQQCWpwm0a9VQhT8APwWbyFTZ28SoNlA==
X-Received: by 2002:adf:ec07:: with SMTP id x7mr7126296wrn.174.1551973422773;
        Thu, 07 Mar 2019 07:43:42 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id h9sm10081463wrv.11.2019.03.07.07.43.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 07:43:42 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 2/4] kernel-shark: Fix a bug in ksmodel_zoom
Date:   Thu,  7 Mar 2019 17:43:14 +0200
Message-Id: <20190307154316.19194-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190307154316.19194-1-ykaradzhov@vmware.com>
References: <20190307154316.19194-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When zooming-in the model is supposed to avoid over-zooming by
recalculation the Scale factor. The new value of the Scale factor is
supposed to be such that the size of the bin cannot be smaller than 5
ns. This patch fixes a naive bug in the way the new scale value is
calculated. The bug was introduced in

f97e31f00 ("kernel-shark-qt: Introduce the visualization model used by the Qt-based KS")

but had no effect until

94efea960 ("kernel-shark-qt: Handle the case when the range of the model is too small")

because the ridiculous value of the Scale factor resulted in a very
small model range and because of this the modification of the model
was always rejected.

Fixes: f97e31f00 ("kernel-shark-qt: Introduce the visualization model used by the Qt-based KS")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index 4bd1e2c..af3440b 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -648,8 +648,8 @@ static void ksmodel_zoom(struct kshark_trace_histo *histo,
 	 * Avoid overzooming. If needed, adjust the Scale factor to a the value
 	 * which provides bin_size >= 5.
 	 */
-	if (zoom_in && range * (1 - r) < histo->n_bins * 5)
-		r = 1 - (histo->n_bins * 5) / range;
+	if (zoom_in && (int) range * (1. - r) < histo->n_bins * 5)
+		r = 1. - (histo->n_bins * 5.) / range;
 
 	/*
 	 * Now calculate the new range of the histo. Use the bin of the marker
-- 
2.19.1

