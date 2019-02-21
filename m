Return-Path: <SRS0=APAm=Q4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AB0C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 12:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F8D420855
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 12:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbfBUMmV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 07:42:21 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44682 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfBUMmU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 07:42:20 -0500
Received: by mail-wr1-f65.google.com with SMTP id w2so15251322wrt.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Feb 2019 04:42:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4kQJpN+KUQE58ceT6NtlUhUDUnVRmifNoacwSxV2NUM=;
        b=sv4zzRBMlLiCD3ayPhU9D8rh2qUMmZmx2DgFaW0v937aw9uOAZGTzXuBf0KvN8IPrX
         1DWK8yQ58e3rJj3puqtp7Ywcokp1ZY3cuYDV9rQVV8zstZr4AqeIpyY5cO533lIzPEec
         nLl2Viu6riwPRTM01YqZzVkZUNGLKuHtXaDE53u0Wz/78Zloo1yYXUcsF4O1B9l98lb2
         z89LBPyeEoWA0D36MVNsH6HKofyCls9a2bay8nI4Z2GLRUGM7J8MHMiZmo+vffXtAkNy
         PyR1AL3suiC7EGuAR2XwwL3aV6GiuI+oRVCLw6XeFqCU1aOV1CxlW+LDONkp/SdEYZWT
         +/nQ==
X-Gm-Message-State: AHQUAuamK8LDSbmG1tjmw8SXgFTAA3Hj0f163Zedv3tO1VswRR24+lLf
        NVAoaBplb+KUR9ejRHAZ9WI1Ys26
X-Google-Smtp-Source: AHgI3IZzI3gBxdCikWt79f4hH9ww471DCHBLUpeFwIOgO2AMA9hinae0QpS3ByYEwIP5D0XPSQILxQ==
X-Received: by 2002:a05:6000:14d:: with SMTP id r13mr1537792wrx.231.1550752939072;
        Thu, 21 Feb 2019 04:42:19 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b4sm1359517wrr.64.2019.02.21.04.42.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 04:42:18 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/3] kernel-shark: Fix a bug in ksmodel_shift_backward()
Date:   Thu, 21 Feb 2019 14:42:03 +0200
Message-Id: <20190221124205.21115-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190221124205.21115-1-ykaradzhov@vmware.com>
References: <20190221124205.21115-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Bin 0 of the new model has to be set after copying the overlaping bins
from the old model. Otherwise the new content of Bin 0 will be copied
into Bin "n". This bug has no effect because ksmodel_shift_backward()
has a second bug in the loop over the non-overlapping bins. The second
bug will be fixed in the following patch.

Fixes: f97e31f00 ("kernel-shark-qt: Introduce the visualization model ..")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index b71a9b8..a185d6b 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -557,17 +557,18 @@ void ksmodel_shift_backward(struct kshark_trace_histo *histo, size_t n)
 		ksmodel_fill(histo, histo->data, histo->data_size);
 		return;
 	}
-	/* Set the new Lower Overflow bin. */
-	ksmodel_set_lower_edge(histo);
 
 	/*
-	 * Copy the the mapping indexes of all overlaping bins starting from
+	 * Copy the mapping indexes of all overlaping bins starting from
 	 * bin "0" of the old histo. Note that the number of overlaping bins
 	 * is histo->n_bins - n.
 	 */
 	memmove(&histo->map[n], &histo->map[0],
 		sizeof(histo->map[0]) * (histo->n_bins - n));
 
+	/* Set the new Lower Overflow bin. */
+	ksmodel_set_lower_edge(histo);
+
 	/* Calculate only the content of the new (non-overlapping) bins. */
 	for (bin = 0; bin < n; ++bin) {
 		ksmodel_set_next_bin_edge(histo, bin, last_row);
-- 
2.17.1

