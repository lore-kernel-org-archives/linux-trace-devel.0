Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BAAC64E7A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35107246EB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kvnOUakI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgKROun (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 09:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbgKROun (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 09:50:43 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F931C061A48
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:43 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id r17so2529958wrw.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iIx7+grTv/751ft5w1VwxSU0mvVww6kVQ6CUeDcj3aM=;
        b=kvnOUakIfbR2qscfJyM45Tec3DsuKox+blC4QGrQUsw99+XDzXzUZNw7K0nHH5kIQm
         FzPDIneTbCN0ajlh1JnOLFLFrwKzQdgsMVlF6hDH2cIZV7O/8fwc7l+eGOWv+cooVAnj
         2TyLvEG880NyxOqC+2vodo47IF1LnD9caFT3nH7uPqWIgi/PpDq3RqjirxV/qT0z6Pkj
         +WmfhwQzYZI5stKVuZdCBVrOx/fQ0nheUjdsFPRuSIOShoz+GwZAO2yCuuqcqB3Ahh79
         +kW7XVi8xD3d/tmw1aIswrcA72r3NQP6SSpOccFfkgAgoSVH0vmaGb70dETw7IAJ5apb
         fONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iIx7+grTv/751ft5w1VwxSU0mvVww6kVQ6CUeDcj3aM=;
        b=eJ9rDBhaCmF6u54gvB37llOb8UM6KC7M/fPV0zv1TyEiJS8M+PnHrSiQWtG5IZqeZY
         Hf2Y3jnzlnE58KeQqc4JjUbYum7AU0YRISXBulDFMLCpo/Wh/muCbP31XfW/QJ4/2jlY
         stYbj5kEHM5OBDRPqfM0Hdel2siEd9v7XyffJpXFv97ca3uMsoHpQhRMLYSs3TXAfVFT
         D+lqHSdyKJY0rOVoCuMJbhu+OHwulMrFkesAKIWpiWqGs2LamW7CroFQqHXdXEKYJcYU
         utNB+2ZiQel0hSo+VhZo1fD9m5iYrZkq2Jm/0lZBYCYm2SM8PSNSoqny5XQ7IuGdvfl6
         FMYw==
X-Gm-Message-State: AOAM532VVxbSvKmSKsmCQ3rP2ajhbyeoqF/GguV206Wax1wiqa5CAkAj
        rZAyHN2D/E1LxMvd9PI/BHcIQ3tPyek=
X-Google-Smtp-Source: ABdhPJywpDTPNUPSjcGswHHuLO62qpIoboSRb60PUw/GXjJQnZzRMWlvdIu84bm+YtoexpYqRIxfpw==
X-Received: by 2002:adf:9e4d:: with SMTP id v13mr5269633wre.135.1605711041792;
        Wed, 18 Nov 2020 06:50:41 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id s202sm3926190wme.39.2020.11.18.06.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 06:50:41 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 16/20] kernel-shark: Use only signed types for model defs
Date:   Wed, 18 Nov 2020 16:49:59 +0200
Message-Id: <20201118145003.156542-17-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201118145003.156542-1-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
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

