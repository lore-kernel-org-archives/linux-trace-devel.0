Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E1EC5519F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BE0C222BA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VglAGFwY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgKTJnm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727238AbgKTJnl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:43:41 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4860CC0617A7
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:41 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id lv15so6132819ejb.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iIx7+grTv/751ft5w1VwxSU0mvVww6kVQ6CUeDcj3aM=;
        b=VglAGFwYYe5AYDqOriX1124Bg56+Xc7oKg8hrncZs2JYjXfvH5rx540Had6EKIoGww
         VkMsjRAr5edrX/5hedcH5x/yZb/DAEzkOG6juRPMpQEdZt2J4r4eAl0IIEelH+CoG4/h
         xynNr+8wsurzwQ6XLL/I0nwRhHOCNurKsx5JXcgOIBvBSWTOtUP7HBdRWCK2aMpFGmQz
         ygzJOI9XYoLJNBYxh21VLzYgDBYU17vHmgJCeNuGCBewFPtKjKaoF7K+RWRM0YwdK+tQ
         Cx9VOdZUSvKvMqlRa+tL6697CGmmRuBQchWGBwqcEmKHRRMarrRBsi9UIaDFfvu4wr8b
         I75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iIx7+grTv/751ft5w1VwxSU0mvVww6kVQ6CUeDcj3aM=;
        b=qCpi20q4oMtY9R5Anun5vNnWpGT6voJE+pwI/awz0B7ss5BGfyAcZJkWFsc6w/ZjpS
         2jQUgEK7QNEDyB/Q9iDSS2ziw1EtMoIEOQsqZHWN+DEt3y/XjZ4NLZdfz5gA9YxbH2Qv
         cvnSgz6+kjW25goAnPZYAEh8EFI4puWyhaoJO3JtJPTJPYjdPthqGchMyFJMlzE1/OrF
         4c0EAuvOQDTNGnAs56tnLfck7QLjT/1LMu3T5K9bBcnb+8//9+w3d6O9vk8rGeKhE1oE
         kKBjyikw8S336gUKB99R3O5oYYnX0gZoyEdAFSSp9XZyTzsqR6BoY9iWF3nETzBIifoh
         MRCw==
X-Gm-Message-State: AOAM533OeP+5wL96SBloVfXYrILzQvtc1U28ssEJ9uZpimFVwc98ass7
        OJBYdJkFpttcsANxNQDLiEM=
X-Google-Smtp-Source: ABdhPJxWOwfigHGrc7jLlaHYZcjGh9mu2m1JvIdxnhWt+4PZlYj5bAZn1fyYIrbBIAeJOLoA7/lRew==
X-Received: by 2002:a17:906:c1c3:: with SMTP id bw3mr30584658ejb.126.1605865420014;
        Fri, 20 Nov 2020 01:43:40 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id h2sm897006ejx.55.2020.11.20.01.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:43:39 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 16/20] kernel-shark: Use only signed types for model defs
Date:   Fri, 20 Nov 2020 11:43:00 +0200
Message-Id: <20201120094304.271502-17-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120094304.271502-1-y.karadz@gmail.com>
References: <20201120094304.271502-1-y.karadz@gmail.com>
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

