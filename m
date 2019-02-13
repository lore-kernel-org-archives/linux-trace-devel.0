Return-Path: <SRS0=ndxz=QU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 550D2C282CA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29EEA20700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404330AbfBMQM4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Feb 2019 11:12:56 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36042 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404329AbfBMQMz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Feb 2019 11:12:55 -0500
Received: by mail-wm1-f68.google.com with SMTP id j125so3044818wmj.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Feb 2019 08:12:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=N1lZDA2FMMxFH72nmZgX/iChkGGScgPNZ9sZeSxjjB0=;
        b=svjlaJgkAWPg5NGNNmh1tORTBmE5KYw6RqfRZDFWUiJrf9zdzaANexW7usNg2JQ/fW
         Zo7C1n07pard25XcPeIEhkv0h+6yDONXsTMTilpCXo9bl+qfdsLDR2edgQcLDVIc3HDM
         vKmgnw1ysLbB/Kw3MaHkLabrGO8Ns5MkQMPAyuhKPQXL6YnbOsUAM73d61S1txkubSO8
         zCubQ/FVRkkdEAPKDKVjI56X8O1BKu1fa7Hd107O7nf6mFSb13AXV4Bqq1GxTu2IuG1D
         dxl3QaitHg9hUewbsFSWakHWc1lu/GrvYphcotakhMT57AGEcPQrCnxZ3kAaKTAgvcmh
         XHdQ==
X-Gm-Message-State: AHQUAuZXPQW5OYRyh78Fm+gCp3yt8DYn5hi5llepXz8U7QkbS4tytc8z
        5FoPLI01foe6ACCCRPueZRk=
X-Google-Smtp-Source: AHgI3IY7uGFVnA4ydDQXZsqQE2UfAGIVPOXbFPAAEVH50vR0FYwpDUPGOnYaoiPOfT9YoONTubT6mw==
X-Received: by 2002:a1c:c783:: with SMTP id x125mr975353wmf.6.1550074373924;
        Wed, 13 Feb 2019 08:12:53 -0800 (PST)
Received: from localhost.localdomain ([95.87.211.218])
        by smtp.gmail.com with ESMTPSA id h9sm3111631wrv.11.2019.02.13.08.12.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 08:12:53 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/8] kernel-shark: Do not copy the Upper Overflow bin when shifting forward
Date:   Wed, 13 Feb 2019 18:12:10 +0200
Message-Id: <20190213161216.14438-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190213161216.14438-1-ykaradzhov@vmware.com>
References: <20190213161216.14438-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

ksmodel_shift_forward() copies the mapping indexes of all overlapping
bins of the model starting from bin "0" of the new histo up to bin
"histo->n_bins - n". Then the mapping index of the old Upper Overflow
bin is considered to be the mapping index of first non-overlapping bin,
which is wrong. It is wrong because in ksmodel_set_upper_edge() the
value of "histo->max" is considered inside the range of the model hence
the Upper Overflow bin starts at "histo->max + 1" but the first
non-overlapping bin will start at exactly "histo->max".

Fixes: f97e31f00 ("kernel-shark-qt: Introduce the visualization model used by the Qt-based KS")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index a4041c3..b71a9b8 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -500,13 +500,11 @@ void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n)
 		sizeof(histo->map[0]) * (histo->n_bins - n));
 
 	/*
-	 * The mapping index of the old Upper Overflow bin is now index of the
-	 * first new bin.
+	 * Calculate only the content of the new (non-overlapping) bins.
+	 * Start from the last copied bin and set the edge of each consecutive
+	 * bin.
 	 */
-	bin = UOB(histo) - n;
-	histo->map[bin] = histo->map[UOB(histo)];
-
-	/* Calculate only the content of the new (non-overlapping) bins. */
+	bin = histo->n_bins - n - 1;
 	for (; bin < histo->n_bins; ++bin) {
 		ksmodel_set_next_bin_edge(histo, bin, last_row);
 		if (histo->map[bin + 1] > 0)
-- 
2.17.1

