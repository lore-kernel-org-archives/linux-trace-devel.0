Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD736C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B853120811
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbfCNPKv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:10:51 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32788 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCNPKv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 11:10:51 -0400
Received: by mail-pf1-f193.google.com with SMTP id i19so4055428pfd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 08:10:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gSKQ5bH65mirLqB3barHk8fmR2aksEZmF9F1bcvAJtM=;
        b=XixBjbIL8e1Nj68mnteFK04St+gPyRxQpBhYbPKZDlErlMAU4n8FixPI2R6qU3ItmS
         qtlOTk8mvCmvYADFYQEDwSc7/b9kYTsSvjMv6/IHu+uudcF2S6iWr9kEzcegqt2/ZeFE
         cW7Hn2053al84BImuqLMV1gjXvRPyqE2LoWcJRUZHiyhT+CzsZ6ko3kz65JtECKawSgy
         g3zq4FPqrlW5hfQ2+ujcP2Qw2lBYh8TGcPEv2fFQNHzaSfQdyPcxhm8eQkvp4HGXFQ0F
         RK7umSnGYud1KUigoZt0UsBGeUpTNojGR84OEorkpJKb0JPpyhYgQMjrlR9xoHNQ6XWi
         wGiA==
X-Gm-Message-State: APjAAAU88ubAwbaDCcgHY7CNGpuOEP4qJAjNQbZDz7OsAHjPeNvzLoLb
        jWhsvAIKryFi4uwveqqMrvo=
X-Google-Smtp-Source: APXvYqyPg2JuCmh215V2vvLjSK1oay286fX3mj97CpOvVBEGt8pqtBs9DOOjBVNnkn6na5wFJIrOKQ==
X-Received: by 2002:a63:7e0e:: with SMTP id z14mr45722680pgc.436.1552576250752;
        Thu, 14 Mar 2019 08:10:50 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm8165585pfg.98.2019.03.14.08.10.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:10:50 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 11/12] kernel-shark: In model, handle the case when all bins are empty
Date:   Thu, 14 Mar 2019 17:10:11 +0200
Message-Id: <20190314151012.905-12-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190314151012.905-1-ykaradzhov@vmware.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

ksmodel_set_bin_counts() should not crash in the case when all
bins of the model, except the Upper Overflow bin, are empty.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index af3440b..29676c7 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -290,7 +290,7 @@ static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
 static void ksmodel_set_bin_counts(struct kshark_trace_histo *histo)
 {
 	int i = 0, prev_not_empty;
-	ssize_t count_tmp;
+	ssize_t count_tmp = 0;
 
 	histo->tot_count = 0;
 	memset(&histo->bin_count[0], 0,
@@ -303,7 +303,7 @@ static void ksmodel_set_bin_counts(struct kshark_trace_histo *histo)
 		prev_not_empty = LOB(histo);
 	} else {
 		/* Loop till the first non-empty bin. */
-		while (histo->map[i] < 0) {
+		while (histo->map[i] < 0 && i < histo->n_bins) {
 			++i;
 		}
 
@@ -316,7 +316,8 @@ static void ksmodel_set_bin_counts(struct kshark_trace_histo *histo)
 	 */
 	for (; i < histo->n_bins; ++i) {
 		if (histo->map[i] != KS_EMPTY_BIN) {
-			/* The current bin is not empty, take its data row and
+			/*
+			 * The current bin is not empty, take its data row and
 			 * subtract it from the data row of the previous not
 			 * empty bin, which will give us the number of data
 			 * rows in the "prev_not_empty" bin.
@@ -358,7 +359,7 @@ static void ksmodel_set_bin_counts(struct kshark_trace_histo *histo)
 	 * We will do a sanity check. The number of data rows in the last not
 	 * empty bin must be greater than zero.
 	 */
-	assert(count_tmp > 0);
+	assert(count_tmp >= 0);
 	histo->tot_count += histo->bin_count[prev_not_empty] = count_tmp;
 }
 
-- 
2.19.1

