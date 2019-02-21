Return-Path: <SRS0=APAm=Q4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DAAC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 12:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 501D520855
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 12:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfBUMmZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 07:42:25 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46824 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfBUMmY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 07:42:24 -0500
Received: by mail-wr1-f68.google.com with SMTP id i16so21632546wrs.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Feb 2019 04:42:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MIFDGcZ18A3JgbTqtauIpl7P9OseZ+du+XJa2TArfgM=;
        b=XKt9UDTyrqlTJ0TDMh3ZTkWA2m6kcABTP2xn6Ap+pRb7moPYFp2pA9Kv67bJjJv9YL
         h4eK89zIlKhl7hx2akqz3NdMijE0cbBZ690lzHiR/6qtPuVA7xOeaEOXFaILl39ENHL3
         qMI6TGjWHCYROf2cjJrBBykpZgTGQJe/DtHm6GNZiUQv/JvWrkz70RsaimN07KRVaVRn
         2kWqneHs2+jUN4DgEztxq6HHPZSJAb1cmod0ifYxOflnLhzwUziHJGf1VR4cpAFDinjM
         zs3lRI0lEhrdJTllgLJkC33nNEz2ePmifpLbdcjktttcuCAABSIjz7Uq3kBVGrKDcQ4a
         h/Yw==
X-Gm-Message-State: AHQUAuYY4uxYpSFbzKdZeWseshjz3dJzICio61CJiZg3PF0bkQYH/ckr
        3hSk6/AECKblbwnMNLDIDPE=
X-Google-Smtp-Source: AHgI3IZsEj+7gY4p6i0/a0X9a2zakY8idgaHGonY0+NoBWOPCp41hZxag6V9qnf2qeRCfSxbIWExAA==
X-Received: by 2002:a1c:9ed7:: with SMTP id h206mr9745707wme.28.1550752943273;
        Thu, 21 Feb 2019 04:42:23 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b4sm1359517wrr.64.2019.02.21.04.42.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 04:42:22 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/3] kernel-shark: Fix a bug in shift_XXX methods of the visualization model
Date:   Thu, 21 Feb 2019 14:42:04 +0200
Message-Id: <20190221124205.21115-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190221124205.21115-1-ykaradzhov@vmware.com>
References: <20190221124205.21115-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In ksmodel_shift_forward() and ksmodel_shift_backward() we are supposed
to recalculate only the content of the new (non-overlapping) Bins. However
the loop does not take into account that the static function used to do
the job actually calculates next Bin (bin + 1). The result is this
misunderstanding is that we recalculate also the first overlapping
Bin (n). This wipes up the effect of the bug fixed by the previous patch.

Fixes: f97e31f00 ("kernel-shark-qt: Introduce the visualization model ..")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index a185d6b..b6d3612 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -505,7 +505,11 @@ void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n)
 	 * bin.
 	 */
 	bin = histo->n_bins - n - 1;
-	for (; bin < histo->n_bins; ++bin) {
+	for (; bin < histo->n_bins - 1; ++bin) {
+		/*
+		 * Note that this function will set the bin having index
+		 * "bin + 1".
+		 */
 		ksmodel_set_next_bin_edge(histo, bin, last_row);
 		if (histo->map[bin + 1] > 0)
 			last_row = histo->map[bin + 1];
@@ -570,7 +574,11 @@ void ksmodel_shift_backward(struct kshark_trace_histo *histo, size_t n)
 	ksmodel_set_lower_edge(histo);
 
 	/* Calculate only the content of the new (non-overlapping) bins. */
-	for (bin = 0; bin < n; ++bin) {
+	for (bin = 0; bin < n - 1; ++bin) {
+		/*
+		 * Note that this function will set the bin having index
+		 * "bin + 1".
+		 */
 		ksmodel_set_next_bin_edge(histo, bin, last_row);
 		if (histo->map[bin + 1] > 0)
 			last_row = histo->map[bin + 1];
-- 
2.17.1

