Return-Path: <SRS0=ndxz=QU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364BEC282C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E41020700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404328AbfBMQMw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Feb 2019 11:12:52 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39214 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733017AbfBMQMw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Feb 2019 11:12:52 -0500
Received: by mail-wr1-f68.google.com with SMTP id l5so2075471wrw.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Feb 2019 08:12:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=M7AEEHqJASumjBrkgCtFHeGRFX0dNhojcICusL532jE=;
        b=RzdlsinUa3PTaLyT1038yP0773wqPnMznZxr+uF60XmbGbZzKkMAh58ink19doBOBE
         NWTtxvClwARPcuMlTzQArrfmKADbybKjL5ZB89paSReQBqFX7vy6tXbCcWq8wXCUxc6a
         6ckOOv/U1heu32nem27Ispnjb69Gl/AEWUx2WIJosF5+9L5iXqs7g4ZYAZdeFM0xYpcN
         AQrFPojW2UBt4xtbRkrNo1cL0LC53upgK6UJNpzl0gNzw8tTccXmtJmKP/4AaWHyWGzX
         fsmGoalVADg4durAvb9dNbLuskacTDiUcB3SsVRWYf6pTDTHiZliCwKx0QChf4AzEB2+
         UTjQ==
X-Gm-Message-State: AHQUAuYBmTS8oGZwvZW1nKNfsUD+dtZ/RHDI9h07cLR5jCToeay0S8ze
        5AXoC6hGe0pEZISVsNXwXLN+ZpSj
X-Google-Smtp-Source: AHgI3IZdvanaUmO/p0PrTHl01yBz8Gg/d9QKKOR6ur5hdPVX8P62pbH+O87d5t32BZJ4BhdL1Or03Q==
X-Received: by 2002:adf:f8c1:: with SMTP id f1mr1002701wrq.31.1550074370379;
        Wed, 13 Feb 2019 08:12:50 -0800 (PST)
Received: from localhost.localdomain ([95.87.211.218])
        by smtp.gmail.com with ESMTPSA id h9sm3111631wrv.11.2019.02.13.08.12.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 08:12:49 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/8] kernel-shark: Add more sanity checks for model misbehavior detection
Date:   Wed, 13 Feb 2019 18:12:09 +0200
Message-Id: <20190213161216.14438-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190213161216.14438-1-ykaradzhov@vmware.com>
References: <20190213161216.14438-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I found that those checks are very useful for early detection of
misbehavior (bugs) of the visualization model. In particular those
checks helped me a lot when developing the multi-stream  branch of
KernelShark (future version 2.0).

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 28 +++++++++++++++++++---------
 kernel-shark/src/libkshark.c       |  7 ++++++-
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index 2094795..a4041c3 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -299,6 +299,7 @@ static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
 static void ksmodel_set_bin_counts(struct kshark_trace_histo *histo)
 {
 	int i = 0, prev_not_empty;
+	ssize_t count_tmp;
 
 	histo->tot_count = 0;
 	memset(&histo->bin_count[0], 0,
@@ -329,12 +330,18 @@ static void ksmodel_set_bin_counts(struct kshark_trace_histo *histo)
 			 * empty bin, which will give us the number of data
 			 * rows in the "prev_not_empty" bin.
 			 */
-			histo->bin_count[prev_not_empty] =
-				histo->map[i] - histo->map[prev_not_empty];
+			count_tmp = histo->map[i] - histo->map[prev_not_empty];
+
+			/*
+			 * We will do a sanity check. The number of data rows
+			 * in the previous not empty bin must be greater than
+			 * zero.
+			 */
+			assert(count_tmp > 0);
+			histo->bin_count[prev_not_empty] = count_tmp;
 
 			if (prev_not_empty != LOB(histo))
-				histo->tot_count +=
-					histo->bin_count[prev_not_empty];
+				histo->tot_count += count_tmp;
 
 			prev_not_empty = i;
 		}
@@ -346,19 +353,22 @@ static void ksmodel_set_bin_counts(struct kshark_trace_histo *histo)
 		 * The Upper Overflow bin is empty. Use the size of the dataset
 		 * to calculate the content of the previouse not empty bin.
 		 */
-		histo->bin_count[prev_not_empty] = histo->data_size -
-						   histo->map[prev_not_empty];
+		count_tmp = histo->data_size - histo->map[prev_not_empty];
 	} else {
 		/*
 		 * Use the index of the first entry inside the Upper Overflow
 		 * bin to calculate the content of the previouse not empty
 		 * bin.
 		 */
-		histo->bin_count[prev_not_empty] = histo->map[UOB(histo)] -
-						   histo->map[prev_not_empty];
+		count_tmp = histo->map[UOB(histo)] - histo->map[prev_not_empty];
 	}
 
-	histo->tot_count += histo->bin_count[prev_not_empty];
+	/*
+	 * We will do a sanity check. The number of data rows in the last not
+	 * empty bin must be greater than zero.
+	 */
+	assert(count_tmp > 0);
+	histo->tot_count += histo->bin_count[prev_not_empty] = count_tmp;
 }
 
 /**
diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 5033e47..9a41945 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -1552,7 +1552,7 @@ const struct kshark_entry dummy_entry = {
 static const struct kshark_entry *
 get_entry(const struct kshark_entry_request *req,
           struct kshark_entry **data,
-          ssize_t *index, size_t start, ssize_t end, int inc)
+          ssize_t *index, ssize_t start, ssize_t end, int inc)
 {
 	struct kshark_context *kshark_ctx = NULL;
 	const struct kshark_entry *e = NULL;
@@ -1564,6 +1564,11 @@ get_entry(const struct kshark_entry_request *req,
 	if (!kshark_instance(&kshark_ctx))
 		return e;
 
+	/*
+	 * We will do a sanity check in order to protect against infinite
+	 * loops.
+	 */
+	assert((inc > 0 && start < end) || (inc < 0 && start > end));
 	for (i = start; i != end; i += inc) {
 		if (req->cond(kshark_ctx, data[i], req->val)) {
 			/*
-- 
2.17.1

