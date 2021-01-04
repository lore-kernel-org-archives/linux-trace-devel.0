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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BAC9C433DB
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 636CE206B2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbhADRtm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbhADRtm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:42 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84590C0617BC
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:02 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id 6so37899624ejz.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dZ0Md1ZVuFNbmAKxQLmv9j8FqeYHXxFKPJzenH94qMY=;
        b=E5kOZ7bsL02yoNcX6junxp95SIuuWG6WiAz7klh2OJJsEvTZe3WDMIQZ34SVONQ1vW
         f68Bid/M0nIZ4J66V8tMn+MkRmam5oAxTFakdvX/SCrDqq4RsmuYNyf7+xZaAju59V24
         nsPp83hOl0D5+Kcqi4IneQDcEJY6GCR3ZXLoQIjgVpT420HdNDMCjl7o1RgXJb3vhdnl
         lKiM2MMjBNaynTyeUqAWuI9AGTZOUw931LGISZh6D1oWLu0Qgn8TT86WK7o5gekJ1r2w
         +NgriMTuor79DqRjAASWWOwtOZ8gFxmjPFeSdkivycNVCKsL9HBAHpVI/+fJLDAef3xz
         ZU+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dZ0Md1ZVuFNbmAKxQLmv9j8FqeYHXxFKPJzenH94qMY=;
        b=jaYTd9JGatD7nwcvUFQjDFlV+xAnLC8ya6Fqr61bTzILMiWs2oEPOt/BKCE0etuckl
         7vxxUqA2d+HkRqC2sJkBMiiJPM5ZQkne829pdeQ1HlKM/nyOkdGbUskGU1Uwi7qdb6ry
         IsXh2S+Z9mIj2/1KSuLAK7OCOVkRb9g3Ba5HBUXknCuMvH0fgZlqIszjyEvbg+rueC7R
         1ZYzoKQqxS/k/hzy7ofYjRPKDdUV7LlGJthmEh47/GiCjqUiIzGY9Jqd9dRgx8CW3AHS
         5BWzDYkUOb+zjQ8+IxR3NB1IabPcd7PHps4IJ99DbRMUHvcA3bfXS0f5paU+CrXjqZa4
         gblg==
X-Gm-Message-State: AOAM533oQd9ulFQqSiQ+TzcJyni10gjk+TDbwgW5Hd8XRi2KUEV4+LP9
        LpcJjV12aAaylOpQJ1PVu6/0fltDqu1t7A==
X-Google-Smtp-Source: ABdhPJy6jsdW+O3icsQP6jw94T6JNro+zf5xCTcdl49aVZDXt39XHOOQdzhnzN5nLzt0OhXvbDzyow==
X-Received: by 2002:a17:906:56ca:: with SMTP id an10mr67684516ejc.498.1609782481260;
        Mon, 04 Jan 2021 09:48:01 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:00 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 24/44] kernel-shark: Use only signed types for model defs
Date:   Mon,  4 Jan 2021 19:47:04 +0200
Message-Id: <20210104174724.70404-25-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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
index 97cff31..f3864bf 100644
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
index 87e252e..b862480 100644
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

