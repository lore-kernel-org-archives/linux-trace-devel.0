Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C194CC61DD8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 732B42224B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MjeobTkC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgKLOYh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgKLOYg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 09:24:36 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9C5C0613D6
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:36 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id b8so6218757wrn.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iIx7+grTv/751ft5w1VwxSU0mvVww6kVQ6CUeDcj3aM=;
        b=MjeobTkCdVTZB95BkRS4tuSJHayQFQp1HR3nCBso4Uu3gXY0wqKGH2ZioJ9WsdidQW
         IES4yTr4Jkilwm39ESQfQ72dJpWTyOWsMzbExYfeWHRwpdCbikaUVeDlAYxlvKHym/7X
         VOcp7LRu1L4zxA3BekDjV71U9CfdRf9Kcneo+DZ2afOVxBNlOzAIzPnsmkEoIakVEqwL
         TeldwZOrK1OzuSjT2IdiNnNEN1qECc1gCBQ7BJKJP/v1/+o+7LZu0ubmfNeKMj+HyGjX
         KAlYKAo4eb/lFZK5w/aJmWz2WGCdVag/rY/eMMGDnxYOcDqio1JIXP2DnbxICA15X6f+
         /ULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iIx7+grTv/751ft5w1VwxSU0mvVww6kVQ6CUeDcj3aM=;
        b=Jv8cxhYIkQxDSrY/8NftIj4ROlhf2R/xHWbLGmtvQs+AYMhjnBvHuSgnhjQD+GbOJM
         mBCF5F0qjkalU9ujozdXapoosHnT5y9tUm5HeSvbNvjLxEcw34lderg4sc5p25iC0CV8
         9q1yGl8wQ3sm1cJPL6PWvmhqWpI3C3+Id58doj/95B9IgTutRYJIbggjrvZSDbyOO3W/
         KEXZjp7bbyrcgVJXa+jmjLaKR60m2DBs2NJYzz14w3PL2bjFNGp9mBJMkr71jEMb1XXT
         8PaOTXJAljAH+T1/bn9vqn8lkhLwQxyvf+G4K/p4JRPI3RFQpEbjx8ILlO1UqXtolz8k
         TSQA==
X-Gm-Message-State: AOAM530A6OkpNWUVMu5ElfXpYzb81pefGorliXtSE0qCdHmCghcsH222
        W1S7CGZRq1/lq0I+PG6gGIk5Sn5AUWU=
X-Google-Smtp-Source: ABdhPJyYO4fcI7s5Un2iJwt9PYjiNKOgzndhMi9iIDJCR0Yk0CV1OKja3V4njeDD1f4SJKaGhATfjg==
X-Received: by 2002:adf:84a5:: with SMTP id 34mr35096719wrg.8.1605191075281;
        Thu, 12 Nov 2020 06:24:35 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id h15sm6950685wrw.15.2020.11.12.06.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 06:24:34 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 16/20] kernel-shark: Use only signed types for model defs
Date:   Thu, 12 Nov 2020 16:23:54 +0200
Message-Id: <20201112142358.36821-17-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112142358.36821-1-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All variables that are used to describe the state of the model, like
the range of the model or the size of the bin must have signed integer
types. This is a continuation of the change started  by switching to
signed timestamps.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-model.c | 12 ++++++------
 src/libkshark-model.h | 18 +++++++++---------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/src/libkshark-model.c b/src/libkshark-model.c
index 97cff314..f3864bfd 100644
--- a/src/libkshark-model.c
+++ b/src/libkshark-model.c
@@ -91,10 +91,10 @@ static bool ksmodel_histo_alloc(struct kshark_trace_histo *histo, size_t n)
 }
 
 static void ksmodel_set_in_range_bining(struct kshark_trace_histo *histo,
-					size_t n, uint64_t min, uint64_t max,
+					size_t n, int64_t min, int64_t max,
 					bool force_in_range)
 {
-	uint64_t corrected_range, delta_range, range = max - min;
+	int64_t corrected_range, delta_range, range = max - min;
 	struct kshark_entry *last;
 
 	/* The size of the bin must be >= 1, hence the range must be >= n. */
@@ -163,7 +163,7 @@ static void ksmodel_set_in_range_bining(struct kshark_trace_histo *histo,
  * @param max: Upper edge of the time-window to be visualized.
  */
 void ksmodel_set_bining(struct kshark_trace_histo *histo,
-			size_t n, uint64_t min, uint64_t max)
+			size_t n, int64_t min, int64_t max)
 {
 	ksmodel_set_in_range_bining(histo, n, min, max, false);
 }
@@ -256,7 +256,7 @@ static size_t ksmodel_set_upper_edge(struct kshark_trace_histo *histo)
 static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
 				      size_t bin, size_t last_row)
 {
-	uint64_t time_min, time_max;
+	int64_t time_min, time_max;
 	size_t next_bin = bin + 1;
 	ssize_t row;
 
@@ -598,9 +598,9 @@ void ksmodel_shift_backward(struct kshark_trace_histo *histo, size_t n)
  * @param histo: Input location for the model descriptor.
  * @param ts: position in time to be visualized.
  */
-void ksmodel_jump_to(struct kshark_trace_histo *histo, uint64_t ts)
+void ksmodel_jump_to(struct kshark_trace_histo *histo, int64_t ts)
 {
-	uint64_t min, max, range_min;
+	int64_t min, max, range_min;
 
 	if (ts > histo->min && ts < histo->max) {
 		/*
diff --git a/src/libkshark-model.h b/src/libkshark-model.h
index 87e252eb..b8624809 100644
--- a/src/libkshark-model.h
+++ b/src/libkshark-model.h
@@ -58,16 +58,16 @@ struct kshark_trace_histo {
 	 * Lower edge of the time-window to be visualized. Only entries having
 	 * timestamp >= min will be visualized.
 	 */
-	uint64_t		min;
+	int64_t			min;
 
 	/**
 	 * Upper edge of the time-window to be visualized. Only entries having
 	 * timestamp <= max will be visualized.
 	 */
-	uint64_t		max;
+	int64_t			max;
 
 	/** The size in time for each bin. */
-	uint64_t		bin_size;
+	int64_t			bin_size;
 
 	/** Number of bins. */
 	int			n_bins;
@@ -78,7 +78,7 @@ void ksmodel_init(struct kshark_trace_histo *histo);
 void ksmodel_clear(struct kshark_trace_histo *histo);
 
 void ksmodel_set_bining(struct kshark_trace_histo *histo,
-			size_t n, uint64_t min, uint64_t max);
+			size_t n, int64_t min, int64_t max);
 
 void ksmodel_fill(struct kshark_trace_histo *histo,
 		  struct kshark_entry **data, size_t n);
@@ -89,7 +89,7 @@ void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n);
 
 void ksmodel_shift_backward(struct kshark_trace_histo *histo, size_t n);
 
-void ksmodel_jump_to(struct kshark_trace_histo *histo, uint64_t ts);
+void ksmodel_jump_to(struct kshark_trace_histo *histo, int64_t ts);
 
 void ksmodel_zoom_out(struct kshark_trace_histo *histo,
 		      double r, int mark);
@@ -163,16 +163,16 @@ ksmodel_get_task_missed_events(struct kshark_trace_histo *histo,
 			       struct kshark_entry_collection *col,
 			       ssize_t *index);
 
-static inline double ksmodel_bin_time(struct kshark_trace_histo *histo,
+static inline int64_t ksmodel_bin_ts(struct kshark_trace_histo *histo,
 				      int bin)
 {
-	return (histo->min + bin*histo->bin_size) * 1e-9;
+	return (histo->min + bin*histo->bin_size);
 }
 
-static inline uint64_t ksmodel_bin_ts(struct kshark_trace_histo *histo,
+static inline double ksmodel_bin_time(struct kshark_trace_histo *histo,
 				      int bin)
 {
-	return (histo->min + bin*histo->bin_size);
+	return ksmodel_bin_ts(histo, bin) * 1e-9;
 }
 
 #ifdef __cplusplus
-- 
2.25.1

