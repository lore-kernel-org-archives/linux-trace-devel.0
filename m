Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA693C43467
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 965452080D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:03:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HMYEMiPx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390858AbgJLOD3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730567AbgJLNgd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:36:33 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9F4C0613D6
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:32 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 13so17211315wmf.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CTJX00qPgrrAZTxudylLqB7eDCCdJRTQMfy/6Cxef9A=;
        b=HMYEMiPxwMWoCd7kGeNzR9h65PfY+kDKHJESuyDeD+2orGFCYUNQqIqywLoieGu30t
         kX1BmSfuXQ6ws3uijTlI6kwrE4Lkr+sw9U8JmMPjx5x18w5isyqgVcLEPoufmx2BG6Eo
         MgiiT/2VBPfwK5R5tcw6w7W5SrkZlMxjqTN6XmFkfDWuGP98NJkqPzYsgyIGrYube2Lp
         A4d8wdnki8Od4ExyN8uEjFMZkL/dvKBfoM+zzlPQuWRRaDo4peum3CsmA2abVIsyc1v9
         vVw18bLB0rjOeR8vVWRNd6xCEKuBC8P5JblgWAMokR2AZLVKqBU59+3wfpL53ZOVySS3
         HOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CTJX00qPgrrAZTxudylLqB7eDCCdJRTQMfy/6Cxef9A=;
        b=Ol8uIpQ0sMy254R/5j7mlDlioClUqNiSkH6cnR6qTq/s8F7y89O4WUAlK8+PTpStNA
         AnExjXBV/7KXl16xh0nHxRXr9GmH78VP1ssfBSfKB5o92fYgouQ9DqI9awzub5tPVMZy
         W9vl+JiTQOnqixoW+/qJGFXqP1/NFkNFaJ9Kr8482gUpSawVOIGqJ6VB4q7sc9GhQNx4
         dVo6ed4NtqzYoOrmhiKdEyZN+h298DmuwFVead9ZITL5lOZxVylWw164jGLmop1ArWz1
         H3e00qICGLQwtUGzG2Ox3NIt75hfk22IrLPz434cTHyRbkErOJlnXXNZO2i1SOC4bOJc
         8tdA==
X-Gm-Message-State: AOAM530DDI/VWBhL4KOBaNz98VIXS1sigOGKC+mGGk1Qa3/UCM/RPqf5
        Emjf8CvqcpyEsgd1d5gQ9g8=
X-Google-Smtp-Source: ABdhPJzOiaPifwbxcnLH2Ao6WRzf58lzxUj2E0ZB93QCYdVRz7jMp9Lp7NSyHGQK90ZX6mMRm8gxnA==
X-Received: by 2002:a1c:9e0e:: with SMTP id h14mr10820273wme.18.1602509790771;
        Mon, 12 Oct 2020 06:36:30 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:36:30 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 13/20] kernel-shark: Complete the stream integration
Date:   Mon, 12 Oct 2020 16:35:16 +0300
Message-Id: <20201012133523.469040-14-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012133523.469040-1-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch contains a number various relatively small modifications
needed in order to finalize the integration. Unfortunately those
changes are hard to disentangle so we will do everything in a single
patch.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/CMakeLists.txt    |   8 +-
 examples/datafilter.c      |  67 +++---
 src/CMakeLists.txt         |   3 +-
 src/libkshark-collection.c | 121 +++++++---
 src/libkshark-tepdata.c    | 352 +++++++++++++++++++++++++++++
 src/libkshark-tepdata.h    |  49 ++++
 src/libkshark.c            | 447 +++++++++++++++++++++++++------------
 src/libkshark.h            | 133 ++++++-----
 8 files changed, 920 insertions(+), 260 deletions(-)

diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index f6ed8978..8d40e42c 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -4,10 +4,10 @@ message(STATUS "dataload")
 add_executable(dload          dataload.c)
 target_link_libraries(dload   kshark)
 
-# message(STATUS "datafilter")
-# add_executable(dfilter          datafilter.c)
-# target_link_libraries(dfilter   kshark)
-#
+message(STATUS "datafilter")
+add_executable(dfilter          datafilter.c)
+target_link_libraries(dfilter   kshark)
+
 # message(STATUS "datahisto")
 # add_executable(dhisto          datahisto.c)
 # target_link_libraries(dhisto   kshark)
diff --git a/examples/datafilter.c b/examples/datafilter.c
index bebc1813..38afab81 100644
--- a/examples/datafilter.c
+++ b/examples/datafilter.c
@@ -7,22 +7,22 @@
 // C
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 
 // KernelShark
 #include "libkshark.h"
+#include "libkshark-tepdata.h"
 
 const char *default_file = "trace.dat";
 
 int main(int argc, char **argv)
 {
-	ssize_t i, n_rows, n_tasks, n_evts, count;
+	size_t i, sd, n_rows, n_tasks, n_evts, count;
 	struct kshark_context *kshark_ctx;
+	struct kshark_data_stream *stream;
 	struct kshark_entry **data = NULL;
-	struct tep_event_filter *adv_filter;
-	struct tep_event *event;
+	int *pids, *evt_ids;
 	char *entry_str;
-	bool status;
-	int *pids;
 
 	/* Create a new kshark session. */
 	kshark_ctx = NULL;
@@ -31,32 +31,30 @@ int main(int argc, char **argv)
 
 	/* Open a trace data file produced by trace-cmd. */
 	if (argc > 1)
-		status = kshark_open(kshark_ctx, argv[1]);
+		sd = kshark_open(kshark_ctx, argv[1]);
 	else
-		status = kshark_open(kshark_ctx, default_file);
+		sd = kshark_open(kshark_ctx, default_file);
 
-	if (!status) {
+	if (sd < 0) {
 		kshark_free(kshark_ctx);
 		return 1;
 	}
 
 	/* Load the content of the file into an array of entries. */
-	n_rows = kshark_load_data_entries(kshark_ctx, &data);
-	if (n_rows < 1) {
-		kshark_free(kshark_ctx);
-		return 1;
-	}
+	n_rows = kshark_load_entries(kshark_ctx, sd, &data);
 
 	/* Filter the trace data coming from trace-cmd. */
-	n_tasks = kshark_get_task_pids(kshark_ctx, &pids);
+	n_tasks = kshark_get_task_pids(kshark_ctx, sd, &pids);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
 	for (i = 0; i < n_tasks; ++i) {
-		const char *task_str =
-			tep_data_comm_from_pid(kshark_ctx->pevent,
-					       pids[i]);
+		char *task_str =
+			kshark_comm_from_pid(sd, pids[i]);
 
 		if (strcmp(task_str, "trace-cmd") == 0)
-			kshark_filter_add_id(kshark_ctx, KS_HIDE_TASK_FILTER,
-							 pids[i]);
+			kshark_filter_add_id(kshark_ctx, sd,
+					     KS_HIDE_TASK_FILTER,
+					     pids[i]);
+		free(task_str);
 	}
 
 	free(pids);
@@ -66,7 +64,8 @@ int main(int argc, char **argv)
 	 * filterd entris in text format.
 	 */
 	kshark_ctx->filter_mask = KS_TEXT_VIEW_FILTER_MASK;
-	kshark_filter_entries(kshark_ctx, data, n_rows);
+	kshark_ctx->filter_mask |= KS_EVENT_VIEW_FILTER_MASK;
+	kshark_filter_stream_entries(kshark_ctx, sd, data, n_rows);
 
 	/* Print to the screen the first 10 visible entries. */
 	count = 0;
@@ -87,15 +86,19 @@ int main(int argc, char **argv)
 	puts("\n\n");
 
 	/* Show only "sched" events. */
-	n_evts = tep_get_events_count(kshark_ctx->pevent);
+	n_evts = stream->n_events;
+	evt_ids = kshark_get_all_event_ids(kshark_ctx->stream[sd]);
 	for (i = 0; i < n_evts; ++i) {
-		event = tep_get_event(kshark_ctx->pevent, i);
-		if (strcmp(event->system, "sched") == 0)
-			kshark_filter_add_id(kshark_ctx, KS_SHOW_EVENT_FILTER,
-							 event->id);
+		char *event_str =
+			kshark_event_from_id(sd, evt_ids[i]);
+		if (strstr(event_str, "sched/"))
+			kshark_filter_add_id(kshark_ctx, sd,
+					     KS_SHOW_EVENT_FILTER,
+					     evt_ids[i]);
+		free(event_str);
 	}
 
-	kshark_filter_entries(kshark_ctx, data, n_rows);
+	kshark_filter_stream_entries(kshark_ctx, sd, data, n_rows);
 
 	/* Print to the screen the first 10 visible entries. */
 	count = 0;
@@ -116,19 +119,17 @@ int main(int argc, char **argv)
 	puts("\n\n");
 
 	/* Clear all filters. */
-	kshark_filter_clear(kshark_ctx, KS_HIDE_TASK_FILTER);
-	kshark_filter_clear(kshark_ctx, KS_SHOW_EVENT_FILTER);
+	kshark_filter_clear(kshark_ctx, sd, KS_HIDE_TASK_FILTER);
+	kshark_filter_clear(kshark_ctx, sd, KS_SHOW_EVENT_FILTER);
 
 	/* Use the Advanced filter to do event content based filtering. */
-	adv_filter = kshark_ctx->advanced_event_filter;
-	tep_filter_add_filter_str(adv_filter,
-				  "sched/sched_wakeup:target_cpu==1");
+	kshark_tep_add_filter_str(stream, "sched/sched_wakeup:target_cpu>1");
 
 	/* The Advanced filter requires reloading the data. */
 	for (i = 0; i < n_rows; ++i)
 		free(data[i]);
 
-	n_rows = kshark_load_data_entries(kshark_ctx, &data);
+	n_rows = kshark_load_entries(kshark_ctx, sd, &data);
 
 	count = 0;
 	for (i = 0; i < n_rows; ++i) {
@@ -149,7 +150,7 @@ int main(int argc, char **argv)
 	free(data);
 
 	/* Close the file. */
-	kshark_close(kshark_ctx);
+	kshark_close(kshark_ctx, sd);
 
 	/* Close the session. */
 	kshark_free(kshark_ctx);
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 2bdab1a5..74e12a28 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -7,7 +7,8 @@ add_library(kshark SHARED libkshark.c
                           libkshark-plugin.c
                           libkshark-tepdata.c
 #                           libkshark-configio.c
-                          libkshark-collection.c)
+                          libkshark-collection.c
+                          libkshark-tepdata.c)
 
 target_link_libraries(kshark ${TRACECMD_LIBRARY}
                              ${TRACEFS_LIBRARY}
diff --git a/src/libkshark-collection.c b/src/libkshark-collection.c
index 66cdbca8..915983b9 100644
--- a/src/libkshark-collection.c
+++ b/src/libkshark-collection.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 
 /*
- * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
  /**
@@ -11,9 +11,11 @@
 
 // C
 #include <stdbool.h>
+#include <string.h>
 #include <stdlib.h>
 #include <assert.h>
 #include <errno.h>
+#include <stdio.h>
 
 // KernelShark
 #include "libkshark.h"
@@ -74,7 +76,9 @@ kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
 			     ssize_t first,
 			     size_t n_rows,
 			     matching_condition_func cond,
-			     int val,
+			     int sd,
+			     int *values,
+			     int n_val,
 			     size_t margin)
 {
 	struct kshark_entry_collection *col_ptr = NULL;
@@ -117,7 +121,7 @@ kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
 	}
 
 	for (i = first + margin; i < end; ++i) {
-		if (!cond(kshark_ctx, data[i], val)) {
+		if (!cond(kshark_ctx, data[i], sd, values)) {
 			/*
 			 * The entry is irrelevant for this collection.
 			 * Do nothing.
@@ -147,7 +151,7 @@ kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
 			}
 		} else if (good_data &&
 			   data[i]->next &&
-			   !cond(kshark_ctx, data[i]->next, val)) {
+			   !cond(kshark_ctx, data[i]->next, sd, values)) {
 			/*
 			 * Break the collection here. Add some margin data
 			 * after the data of interest.
@@ -168,7 +172,7 @@ kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
 			 */
 			if (i + margin >= j) {
 				for (;j < i + margin; ++j) {
-					if (cond(kshark_ctx, data[j], val)) {
+					if (cond(kshark_ctx, data[j], sd, values)) {
 						/*
 						 * Good data has been found.
 						 * Continue extending the
@@ -228,9 +232,15 @@ kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
 	}
 
 	col_ptr->cond = cond;
-	col_ptr->val = val;
+	col_ptr->n_val = n_val;
+	col_ptr->stream_id = sd;
+	col_ptr->values = malloc(n_val * sizeof(*col_ptr->values));
+	memcpy(col_ptr->values, values, n_val * sizeof(*col_ptr->values));
 
 	col_ptr->size = resume_count;
+	if (!col_ptr->size)
+		free(col_list);
+
 	for (i = 0; i < col_ptr->size; ++i) {
 		assert(col_list->type == COLLECTION_RESUME);
 		col_ptr->resume_points[i] = col_list->index;
@@ -316,8 +326,8 @@ map_collection_request_init(const struct kshark_entry_collection *col,
 	size_t req_end;
 
 	if (req->next || col->size == 0) {
-		fprintf(stderr, "Unexpected input in ");
-		fprintf(stderr, "map_collection_request_init()\n");
+		fprintf(stderr,
+			"Unexpected input in map_collection_request_init()\n");
 		goto do_nothing;
 	}
 
@@ -477,7 +487,8 @@ map_collection_back_request(const struct kshark_entry_collection *col,
 				kshark_entry_request_alloc(req_first,
 							   0,
 							   req->cond,
-							   req->val,
+							   req->sd,
+							   req->values,
 							   req->vis_only,
 							   req->vis_mask);
 
@@ -561,7 +572,8 @@ map_collection_front_request(const struct kshark_entry_collection *col,
 				kshark_entry_request_alloc(req_first,
 							   0,
 							   req->cond,
-							   req->val,
+							   req->sd,
+							   req->values,
 							   req->vis_only,
 							   req->vis_mask);
 
@@ -702,25 +714,41 @@ kshark_get_collection_entry_back(struct kshark_entry_request *req,
 	return entry;
 }
 
+static bool val_compare(int *val_a, int *val_b, size_t n_val)
+{
+	size_t i;
+
+	for (i = 0; i < n_val; ++i)
+		if (val_a[i] != val_b[i])
+			return false;
+
+	return true;
+}
+
 /**
  * @brief Search the list of Data collections and find the collection defined
  *	  with a given Matching condition function and value.
  *
  * @param col: Input location for the Data collection list.
  * @param cond: Matching condition function.
- * @param val: Matching condition value, used by the Matching condition
- *	       function.
+ * @param sd: Data stream identifier.
+ * @param values: Array of matching condition value, used by the Matching
+ *		  condition function.
+ * @param n_val: The size of the array of Matching values.
  *
  * @returns Pointer to a Data collections on success, or NULL on failure.
  */
 struct kshark_entry_collection *
 kshark_find_data_collection(struct kshark_entry_collection *col,
 			    matching_condition_func cond,
-			    int val)
+			    int sd, int *values, size_t n_val)
 {
 	while (col) {
-		if (col->cond == cond && col->val == val)
-			return col;
+		if (col->cond == cond &&
+		    col->stream_id == sd &&
+		    col->n_val == n_val &&
+		    val_compare(col->values, values, n_val))
+				return col;
 
 		col = col->next;
 	}
@@ -748,6 +776,7 @@ static void kshark_free_data_collection(struct kshark_entry_collection *col)
 {
 	free(col->resume_points);
 	free(col->break_points);
+	free(col->values);
 	free(col);
 }
 
@@ -761,7 +790,10 @@ static void kshark_free_data_collection(struct kshark_entry_collection *col)
  * @param n_rows: The size of the inputted data.
  * @param cond: Matching condition function for the collection to be
  *	        registered.
- * @param val: Matching condition value of for collection to be registered.
+ * @param sd: Data stream identifier.
+ * @param values: Array of matching condition value, used by the Matching
+ *		  condition function.
+ * @param n_val: The size of the array of Matching values.
  * @param margin: The size of the additional (margin) data which do not
  *		  satisfy the matching condition, but is added at the
  *		  beginning and at the end of each interval of the collection
@@ -776,7 +808,8 @@ kshark_register_data_collection(struct kshark_context *kshark_ctx,
 				struct kshark_entry **data,
 				size_t n_rows,
 				matching_condition_func cond,
-				int val,
+				int sd,
+				int *values, size_t n_val,
 				size_t margin)
 {
 	struct kshark_entry_collection *col;
@@ -784,7 +817,7 @@ kshark_register_data_collection(struct kshark_context *kshark_ctx,
 	col = kshark_add_collection_to_list(kshark_ctx,
 					    &kshark_ctx->collections,
 					    data, n_rows,
-					    cond, val,
+					    cond, sd, values, n_val,
 					    margin);
 
 	return col;
@@ -801,7 +834,10 @@ kshark_register_data_collection(struct kshark_context *kshark_ctx,
  * @param n_rows: The size of the inputted data.
  * @param cond: Matching condition function for the collection to be
  *	        registered.
- * @param val: Matching condition value of for collection to be registered.
+ * @param sd: Data stream identifier.
+ * @param values: Array of matching condition value, used by the Matching
+ *		  condition function.
+ * @param n_val: The size of the array of Matching values.
  * @param margin: The size of the additional (margin) data which do not
  *		  satisfy the matching condition, but is added at the
  *		  beginning and at the end of each interval of the collection
@@ -817,14 +853,18 @@ kshark_add_collection_to_list(struct kshark_context *kshark_ctx,
 			      struct kshark_entry **data,
 			      size_t n_rows,
 			      matching_condition_func cond,
-			      int val,
+			      int sd, int *values, size_t n_val,
 			      size_t margin)
 {
 	struct kshark_entry_collection *col;
 
+	if (!data || n_rows == 0)
+		return NULL;
+
 	col = kshark_data_collection_alloc(kshark_ctx, data,
 					   0, n_rows,
-					   cond, val,
+					   cond, sd,
+					   values, n_val,
 					   margin);
 
 	if (col) {
@@ -844,18 +884,23 @@ kshark_add_collection_to_list(struct kshark_context *kshark_ctx,
  * @param col: Input location for the Data collection list.
  * @param cond: Matching condition function of the collection to be
  *	        unregistered.
- *
- * @param val: Matching condition value of the collection to be unregistered.
+ * @param sd: Data stream identifier.
+ * @param values: Array of matching condition value, used by the Matching
+ *		  condition function.
+ * @param n_val: The size of the array of Matching values.
  */
 void kshark_unregister_data_collection(struct kshark_entry_collection **col,
 				       matching_condition_func cond,
-				       int val)
+				       int sd, int *values, size_t n_val)
 {
 	struct kshark_entry_collection **last = col;
 	struct kshark_entry_collection *list;
 
 	for (list = *col; list; list = list->next) {
-		if (list->cond == cond && list->val == val) {
+		if (list->cond == cond &&
+		    list->stream_id == sd &&
+		    list->n_val == n_val &&
+		    val_compare(list->values, values, n_val)) {
 			*last = list->next;
 			kshark_free_data_collection(list);
 			return;
@@ -865,6 +910,32 @@ void kshark_unregister_data_collection(struct kshark_entry_collection **col,
 	}
 }
 
+/**
+ * @brief Unregister all Data collections associated with a given Data stream.
+ *
+ * @param col: Input location for the Data collection list.
+ * @param sd: Data stream identifier.
+ */
+void kshark_unregister_stream_collections(struct kshark_entry_collection **col,
+					  int sd)
+{
+	struct kshark_entry_collection **last = col;
+	struct kshark_entry_collection *list;
+
+	list = *col;
+	while (list) {
+		if (list->stream_id == sd) {
+			*last = list->next;
+			kshark_free_data_collection(list);
+			list = *last;
+			continue;
+		}
+
+		last = &list->next;
+		list = list->next;
+	}
+}
+
 /**
  * @brief Free all Data collections in a given list.
  *
diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 30c383c8..d9d57843 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -318,6 +318,9 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
 
 				pid = entry->pid;
 
+				/* Apply Id filtering. */
+				kshark_apply_filters(kshark_ctx, stream, entry);
+
 				/* Apply advanced event filtering. */
 				if (adv_filter && adv_filter->filters &&
 				    tep_filter_match(adv_filter, rec) != FILTER_MATCH)
@@ -1160,6 +1163,43 @@ out:
 	return peer_handle;
 }
 
+/** A list of built in default plugins for FTRACE (trace-cmd) data. */
+const char *tep_plugin_names[] = {
+	"sched_events",
+	"missed_events",
+	"kvm_combo",
+};
+
+/**
+ * Register to the data stream all default plugins for FTRACE (trace-cmd) data.
+ */
+int kshark_tep_handle_plugins(struct kshark_context *kshark_ctx, int sd)
+{
+	int i, n_tep_plugins = sizeof(tep_plugin_names) / sizeof (const char *);
+	struct kshark_plugin_list *plugin;
+	struct kshark_data_stream *stream;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return -EEXIST;
+
+	for (i = 0; i < n_tep_plugins; ++i) {
+		plugin = kshark_find_plugin_by_name(kshark_ctx->plugins,
+						    tep_plugin_names[i]);
+
+		if (plugin && plugin->process_interface) {
+			kshark_register_plugin_to_stream(stream,
+							 plugin->process_interface,
+							 true);
+		} else {
+			fprintf(stderr, "Plugin \"%s\" not found.\n",
+				tep_plugin_names[i]);
+		}
+	}
+
+	return kshark_handle_all_dpis(stream, KSHARK_PLUGIN_INIT);
+}
+
 /** The Process Id of the Idle tasks is zero. */
 #define LINUX_IDLE_TASK_PID	0
 
@@ -1210,6 +1250,172 @@ static int kshark_tep_stream_init(struct kshark_data_stream *stream,
 	return -EFAULT;
 }
 
+static struct tracecmd_input *get_top_input(struct kshark_context *kshark_ctx,
+					    int sd)
+{
+	struct kshark_data_stream *top_stream;
+
+	top_stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!top_stream)
+		return NULL;
+
+	return kshark_get_tep_input(top_stream);
+}
+
+/**
+ * @brief Get an array containing the names of all buffers in FTRACE data
+ *	  file.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param sd: Data stream identifier of the top buffers in the FTRACE data
+ *	  file.
+ * @param n_buffers: Output location for the size of the outputted array,
+ *	    or a negative error code on failure.
+ *
+ * @returns Array of strings on success, or NULL on failure. The user is
+ *	    responsible for freeing the elements of the outputted array.
+ */
+char **kshark_tep_get_buffer_names(struct kshark_context *kshark_ctx, int sd,
+				   int *n_buffers)
+{
+	struct tracecmd_input *top_input;
+	char **buffer_names;
+	int i, n;
+
+	top_input = get_top_input(kshark_ctx, sd);
+	if (!top_input) {
+		*n_buffers = -EFAULT;
+		return NULL;
+	}
+
+	n = tracecmd_buffer_instances(top_input);
+	buffer_names = malloc(n * sizeof(char *));
+
+	for (i = 0; i < n; ++i)
+		buffer_names[i] =
+			strdup(tracecmd_buffer_instance_name(top_input, i));
+
+	*n_buffers = n;
+	return buffer_names;
+}
+
+static void set_stream_fields(struct tracecmd_input *top_input, int i,
+			      const char *file,
+			      const char *name,
+			      struct kshark_data_stream *buffer_stream,
+			      struct tracecmd_input **buffer_input)
+{
+	*buffer_input = tracecmd_buffer_instance_handle(top_input, i);
+
+	buffer_stream->name = strdup(name);
+	buffer_stream->file = strdup(file);
+	buffer_stream->format = KS_TEP_DATA;
+}
+
+/**
+ * @brief Open a given buffers in FTRACE (trace-cmd) data file.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param sd: Data stream identifier of the top buffers in the FTRACE data
+ *	  file.
+ * @param buffer_name: The name of the buffer to open.
+ *
+ * @returns Data stream identifier of the buffer on success. Otherwise a
+ *	    negative error code.
+ */
+int kshark_tep_open_buffer(struct kshark_context *kshark_ctx, int sd,
+			   const char *buffer_name)
+{
+	struct kshark_data_stream *top_stream, *buffer_stream;
+	struct tracecmd_input *top_input, *buffer_input;
+	int i, sd_buffer, n_buffers, ret = -ENODATA;
+	char **names;
+
+	top_stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!top_stream)
+		return -EFAULT;
+
+	top_input = kshark_get_tep_input(top_stream);
+	if (!top_input)
+		return -EFAULT;
+
+	names = kshark_tep_get_buffer_names(kshark_ctx, sd, &n_buffers);
+
+	sd_buffer = kshark_add_stream(kshark_ctx);
+	buffer_stream = kshark_get_data_stream(kshark_ctx, sd_buffer);
+	if (!buffer_stream)
+		return -EFAULT;
+
+	for (i = 0; i < n_buffers; ++i) {
+		if (strcmp(buffer_name, names[i]) == 0) {
+			set_stream_fields(top_input, i,
+					  top_stream->file,
+					  buffer_name,
+					  buffer_stream,
+					  &buffer_input);
+
+			ret = kshark_tep_stream_init(buffer_stream,
+						     buffer_input);
+			break;
+		}
+	}
+
+	for (i = 0; i < n_buffers; ++i)
+		free(names[i]);
+	free(names);
+
+	return (ret < 0)? ret : buffer_stream->stream_id;
+}
+
+/**
+ * @brief Initialize data streams for all buffers in a FTRACE (trace-cmd) data
+ *	  file.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param sd: Data stream identifier of the top buffers in the FTRACE data
+ *	  file.
+ *
+ * @returns The total number of data streams initialized on success. Otherwise
+ *	    a negative error code.
+ */
+int kshark_tep_init_all_buffers(struct kshark_context *kshark_ctx,
+				int sd)
+{
+	struct kshark_data_stream *top_stream, *buffer_stream;
+	struct tracecmd_input *buffer_input;
+	struct tracecmd_input *top_input;
+	int i, n_buffers, sd_buffer, ret;
+
+	top_stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!top_stream)
+		return -EFAULT;
+
+	top_input = kshark_get_tep_input(top_stream);
+	if (!top_input)
+		return -EFAULT;
+
+	n_buffers = tracecmd_buffer_instances(top_input);
+	for (i = 0; i < n_buffers; ++i) {
+		sd_buffer = kshark_add_stream(kshark_ctx);
+		if (sd_buffer < 0)
+			return -EFAULT;
+
+		buffer_stream = kshark_ctx->stream[sd_buffer];
+
+		set_stream_fields(top_input, i,
+				  top_stream->file,
+				  tracecmd_buffer_instance_name(top_input, i),
+				  buffer_stream,
+				  &buffer_input);
+
+		ret = kshark_tep_stream_init(buffer_stream, buffer_input);
+		if (ret != 0)
+			return -EFAULT;
+	}
+
+	return n_buffers;
+}
+
 /** Initialize the FTRACE data input (from file). */
 int kshark_tep_init_input(struct kshark_data_stream *stream,
 			  const char *file)
@@ -1389,3 +1595,149 @@ char **kshark_tracecmd_local_plugins()
 {
 	return tracefs_tracers(tracefs_get_tracing_dir());
 }
+
+/**
+ * @brief Free an array, allocated by kshark_tracecmd_get_hostguest_mapping() API
+ *
+ *
+ * @param map: Array, allocated by kshark_tracecmd_get_hostguest_mapping() API
+ * @param count: Number of entries in the array
+ *
+ */
+void kshark_tracecmd_free_hostguest_map(struct kshark_host_guest_map *map, int count)
+{
+	int i;
+
+	if (!map)
+		return;
+	for (i = 0; i < count; i++) {
+		free(map[i].guest_name);
+		free(map[i].cpu_pid);
+		memset(&map[i], 0, sizeof(*map));
+	}
+	free(map);
+}
+
+/**
+ * @brief Get mapping of guest VCPU to host task, running that VCPU.
+ *	  Array of mappings for each guest is allocated and returned
+ *	  in map input parameter.
+ *
+ *
+ * @param map: Returns allocated array of kshark_host_guest_map structures, each
+ *	       one describing VCPUs mapping of one guest.
+ *
+ * @return The number of entries in the *map array, or a negative error code on
+ *	   failure.
+ */
+int kshark_tracecmd_get_hostguest_mapping(struct kshark_host_guest_map **map)
+{
+	struct kshark_host_guest_map *gmap = NULL;
+	struct tracecmd_input *peer_handle = NULL;
+	struct kshark_data_stream *peer_stream;
+	struct tracecmd_input *guest_handle = NULL;
+	struct kshark_data_stream *guest_stream;
+	struct kshark_context *kshark_ctx = NULL;
+	unsigned long long trace_id;
+	const char *name;
+	int vcpu_count;
+	const int *cpu_pid;
+	int *stream_ids;
+	int i, j, k;
+	int count = 0;
+	int ret;
+
+	if (!map || !kshark_instance(&kshark_ctx))
+		return -EFAULT;
+	if (*map)
+		return -EEXIST;
+
+	stream_ids = kshark_all_streams(kshark_ctx);
+	for (i = 0; i < kshark_ctx->n_streams; i++) {
+		guest_stream = kshark_get_data_stream(kshark_ctx, stream_ids[i]);
+		if (!guest_stream || guest_stream->format != KS_TEP_DATA)
+			continue;
+		guest_handle = kshark_get_tep_input(guest_stream);
+		if (!guest_handle)
+			continue;
+		trace_id = tracecmd_get_traceid(guest_handle);
+		if (!trace_id)
+			continue;
+		for (j = 0; j < kshark_ctx->n_streams; j++) {
+			if (stream_ids[i] == stream_ids[j])
+				continue;
+			peer_stream = kshark_get_data_stream(kshark_ctx, stream_ids[j]);
+			if (!peer_stream || peer_stream->format != KS_TEP_DATA)
+				continue;
+			peer_handle = kshark_get_tep_input(peer_stream);
+			if (!peer_handle)
+				continue;
+			ret = tracecmd_get_guest_cpumap(peer_handle, trace_id,
+							&name, &vcpu_count, &cpu_pid);
+			if (!ret && vcpu_count) {
+				gmap = realloc(*map,
+					       (count + 1) * sizeof(struct kshark_host_guest_map));
+				if (!gmap)
+					goto mem_error;
+				*map = gmap;
+				memset(&gmap[count], 0, sizeof(struct kshark_host_guest_map));
+				count++;
+				gmap[count - 1].guest_id = stream_ids[i];
+				gmap[count - 1].host_id = stream_ids[j];
+				gmap[count - 1].guest_name = strdup(name);
+				if (!gmap[count - 1].guest_name)
+					goto mem_error;
+				gmap[count - 1].vcpu_count = vcpu_count;
+				gmap[count - 1].cpu_pid = malloc(sizeof(int) * vcpu_count);
+				if (!gmap[count - 1].cpu_pid)
+					goto mem_error;
+				for (k = 0; k < vcpu_count; k++)
+					gmap[count - 1].cpu_pid[k] = cpu_pid[k];
+				break;
+			}
+		}
+	}
+
+	free(stream_ids);
+	return count;
+
+mem_error:
+	free(stream_ids);
+	if (*map) {
+		kshark_tracecmd_free_hostguest_map(*map, count);
+		*map = NULL;
+	}
+
+	return -ENOMEM;
+}
+
+/**
+ * @brief Find the data stream corresponding the top buffer of a FTRACE
+ *	  (trace-cmd) data file.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param file: The name of the file.
+ *
+ * @returns Data stream identifier of the top buffers in the FTRACE data
+ *	    fileon success. Otherwise a negative error code.
+ */
+int kshark_tep_find_top_stream(struct kshark_context *kshark_ctx,
+			       const char *file)
+{
+	struct kshark_data_stream *top_stream = NULL, *stream;
+	int i, *stream_ids = kshark_all_streams(kshark_ctx);
+
+	for (i = 0; i < kshark_ctx->n_streams; ++i) {
+		stream = kshark_ctx->stream[stream_ids[i]];
+		if (strcmp(stream->file, file) == 0 &&
+		    strcmp(stream->name, "top") == 0)
+			top_stream = stream;
+	}
+
+	free(stream_ids);
+
+	if (!top_stream)
+		return -EEXIST;
+
+	return top_stream->stream_id;
+}
diff --git a/src/libkshark-tepdata.h b/src/libkshark-tepdata.h
index a2bd211e..b6c9439e 100644
--- a/src/libkshark-tepdata.h
+++ b/src/libkshark-tepdata.h
@@ -41,9 +41,58 @@ void kshark_tep_filter_reset(struct kshark_data_stream *stream);
 
 char **kshark_tracecmd_local_plugins();
 
+struct tep_handle;
+
+struct tep_handle *kshark_get_tep(struct kshark_data_stream *stream);
+
+struct tracecmd_input;
+
+struct tracecmd_input *kshark_get_tep_input(struct kshark_data_stream *stream);
+
+struct tep_record;
+
 ssize_t kshark_load_tep_records(struct kshark_context *kshark_ctx, int sd,
 				struct tep_record ***data_rows);
 
+/**
+ * Structure representing the mapping between the virtual CPUs and their
+ * corresponding processes in the host.
+ */
+struct kshark_host_guest_map {
+	/** ID of guest stream */
+	int guest_id;
+
+	/** ID of host stream */
+	int host_id;
+
+	/** Guest name */
+	char *guest_name;
+
+	/** Number of guest's CPUs in *cpu_pid array */
+	int vcpu_count;
+
+	/** Array of host task PIDs, index is the VCPU id */
+	int *cpu_pid;
+};
+
+void kshark_tracecmd_free_hostguest_map(struct kshark_host_guest_map *map,
+					int count);
+
+int kshark_tracecmd_get_hostguest_mapping(struct kshark_host_guest_map **map);
+
+char **kshark_tep_get_buffer_names(struct kshark_context *kshark_ctx, int sd,
+				   int *n_buffers);
+
+int kshark_tep_open_buffer(struct kshark_context *kshark_ctx, int sd,
+			   const char *buffer_name);
+
+int kshark_tep_init_all_buffers(struct kshark_context *kshark_ctx, int sd);
+
+int kshark_tep_handle_plugins(struct kshark_context *kshark_ctx, int sd);
+
+int kshark_tep_find_top_stream(struct kshark_context *kshark_ctx,
+			       const char *file);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/src/libkshark.c b/src/libkshark.c
index bd2e4cc0..6ce7b6ba 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 
 /*
- * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
  /**
@@ -9,8 +9,10 @@
  *  @brief   API for processing of tracing data.
  */
 
+#ifndef _GNU_SOURCE
 /** Use GNU C Library. */
-#define _GNU_SOURCE 1
+#define _GNU_SOURCE
+#endif // _GNU_SOURCE
 
 // C
 #include <stdlib.h>
@@ -36,16 +38,6 @@ static bool kshark_default_context(struct kshark_context **context)
 				    sizeof(*kshark_ctx->stream));
 
 	kshark_ctx->collections = NULL;
-	kshark_ctx->plugins = NULL;
-
-	kshark_ctx->show_task_filter = tracecmd_filter_id_hash_alloc();
-	kshark_ctx->hide_task_filter = tracecmd_filter_id_hash_alloc();
-
-	kshark_ctx->show_event_filter = tracecmd_filter_id_hash_alloc();
-	kshark_ctx->hide_event_filter = tracecmd_filter_id_hash_alloc();
-
-	kshark_ctx->show_cpu_filter = tracecmd_filter_id_hash_alloc();
-	kshark_ctx->hide_cpu_filter = tracecmd_filter_id_hash_alloc();
 
 	kshark_ctx->filter_mask = 0x0;
 
@@ -386,6 +378,12 @@ void kshark_close(struct kshark_context *kshark_ctx, int sd)
 	if (!stream)
 		return;
 
+	/*
+	 * All data collections are file specific. Make sure that collections
+	 * from this file are not going to be used with another file.
+	 */
+	kshark_unregister_stream_collections(&kshark_ctx->collections, sd);
+
 	/* Close all active plugins for this stream. */
 	if (stream->plugins) {
 		kshark_handle_all_dpis(stream, KSHARK_PLUGIN_CLOSE);
@@ -530,103 +528,134 @@ ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int sd,
 	return stream->tasks->count;
 }
 
-static bool filter_find(struct tracecmd_filter_id *filter, int pid,
+static bool filter_find(struct kshark_hash_id *filter, int pid,
 			bool test)
 {
 	return !filter || !filter->count ||
-		!!(unsigned long)tracecmd_filter_id_find(filter, pid) == test;
+	       kshark_hash_id_find(filter, pid) == test;
 }
 
-static bool kshark_show_task(struct kshark_context *kshark_ctx, int pid)
+static bool kshark_show_task(struct kshark_data_stream *stream, int pid)
 {
-	return filter_find(kshark_ctx->show_task_filter, pid, true) &&
-	       filter_find(kshark_ctx->hide_task_filter, pid, false);
+	return filter_find(stream->show_task_filter, pid, true) &&
+	       filter_find(stream->hide_task_filter, pid, false);
 }
 
-static bool kshark_show_event(struct kshark_context *kshark_ctx, int pid)
+static bool kshark_show_event(struct kshark_data_stream *stream, int pid)
 {
-	return filter_find(kshark_ctx->show_event_filter, pid, true) &&
-	       filter_find(kshark_ctx->hide_event_filter, pid, false);
+	return filter_find(stream->show_event_filter, pid, true) &&
+	       filter_find(stream->hide_event_filter, pid, false);
 }
 
-static bool kshark_show_cpu(struct kshark_context *kshark_ctx, int cpu)
+static bool kshark_show_cpu(struct kshark_data_stream *stream, int cpu)
 {
-	return filter_find(kshark_ctx->show_cpu_filter, cpu, true) &&
-	       filter_find(kshark_ctx->hide_cpu_filter, cpu, false);
+	return filter_find(stream->show_cpu_filter, cpu, true) &&
+	       filter_find(stream->hide_cpu_filter, cpu, false);
+}
+
+static struct kshark_hash_id *get_filter(struct kshark_context *kshark_ctx,
+					 int sd,
+					 enum kshark_filter_type filter_id)
+{
+	struct kshark_data_stream *stream;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return NULL;
+
+	return kshark_get_filter(stream, filter_id);
 }
 
 /**
- * @brief Add an Id value to the filster specified by "filter_id".
+ * @brief Get an Id Filter.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param filter_id: Identifier of the filter.
+ */
+struct kshark_hash_id *
+kshark_get_filter(struct kshark_data_stream *stream,
+		  enum kshark_filter_type filter_id)
+{
+	switch (filter_id) {
+	case KS_SHOW_CPU_FILTER:
+		return stream->show_cpu_filter;
+	case KS_HIDE_CPU_FILTER:
+		return stream->hide_cpu_filter;
+	case KS_SHOW_EVENT_FILTER:
+		return stream->show_event_filter;
+	case KS_HIDE_EVENT_FILTER:
+		return stream->hide_event_filter;
+	case KS_SHOW_TASK_FILTER:
+		return stream->show_task_filter;
+	case KS_HIDE_TASK_FILTER:
+		return stream->hide_task_filter;
+	default:
+		return NULL;
+	}
+}
+
+/**
+ * @brief Add an Id value to the filter specified by "filter_id".
  *
  * @param kshark_ctx: Input location for the session context pointer.
+ * @param sd: Data stream identifier.
  * @param filter_id: Identifier of the filter.
  * @param id: Id value to be added to the filter.
  */
-void kshark_filter_add_id(struct kshark_context *kshark_ctx,
+void kshark_filter_add_id(struct kshark_context *kshark_ctx, int sd,
 			  int filter_id, int id)
 {
-	struct tracecmd_filter_id *filter;
+	struct kshark_hash_id *filter;
 
-	switch (filter_id) {
-		case KS_SHOW_CPU_FILTER:
-			filter = kshark_ctx->show_cpu_filter;
-			break;
-		case KS_HIDE_CPU_FILTER:
-			filter = kshark_ctx->hide_cpu_filter;
-			break;
-		case KS_SHOW_EVENT_FILTER:
-			filter = kshark_ctx->show_event_filter;
-			break;
-		case KS_HIDE_EVENT_FILTER:
-			filter = kshark_ctx->hide_event_filter;
-			break;
-		case KS_SHOW_TASK_FILTER:
-			filter = kshark_ctx->show_task_filter;
-			break;
-		case KS_HIDE_TASK_FILTER:
-			filter = kshark_ctx->hide_task_filter;
-			break;
-		default:
-			return;
+	filter = get_filter(kshark_ctx, sd, filter_id);
+	if (filter)
+		kshark_hash_id_add(filter, id);
+}
+
+/**
+ * @brief Get an array containing all Ids associated with a given Id Filter.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param sd: Data stream identifier.
+ * @param filter_id: Identifier of the filter.
+ * @param n: Output location for the size of the returned array.
+ *
+ * @return The user is responsible for freeing the array.
+ */
+int *kshark_get_filter_ids(struct kshark_context *kshark_ctx, int sd,
+			   int filter_id, int *n)
+{
+	struct kshark_hash_id *filter;
+
+	filter = get_filter(kshark_ctx, sd, filter_id);
+	if (filter) {
+		if (n)
+			*n = filter->count;
+
+		return kshark_hash_ids(filter);
 	}
 
-	tracecmd_filter_id_add(filter, id);
+	if (n)
+		*n = 0;
+
+	return NULL;
 }
 
 /**
- * @brief Clear (reset) the filster specified by "filter_id".
+ * @brief Clear (reset) the filter specified by "filter_id".
  *
  * @param kshark_ctx: Input location for the session context pointer.
+ * @param sd: Data stream identifier.
  * @param filter_id: Identifier of the filter.
  */
-void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id)
+void kshark_filter_clear(struct kshark_context *kshark_ctx, int sd,
+			 int filter_id)
 {
-	struct tracecmd_filter_id *filter;
-
-	switch (filter_id) {
-		case KS_SHOW_CPU_FILTER:
-			filter = kshark_ctx->show_cpu_filter;
-			break;
-		case KS_HIDE_CPU_FILTER:
-			filter = kshark_ctx->hide_cpu_filter;
-			break;
-		case KS_SHOW_EVENT_FILTER:
-			filter = kshark_ctx->show_event_filter;
-			break;
-		case KS_HIDE_EVENT_FILTER:
-			filter = kshark_ctx->hide_event_filter;
-			break;
-		case KS_SHOW_TASK_FILTER:
-			filter = kshark_ctx->show_task_filter;
-			break;
-		case KS_HIDE_TASK_FILTER:
-			filter = kshark_ctx->hide_task_filter;
-			break;
-		default:
-			return;
-	}
+	struct kshark_hash_id *filter;
 
-	tracecmd_filter_id_clear(filter);
+	filter = get_filter(kshark_ctx, sd, filter_id);
+	if (filter)
+		kshark_hash_id_clear(filter);
 }
 
 /**
@@ -636,7 +665,7 @@ void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id)
  *
  * @returns True if the Id filter is set, otherwise False.
  */
-bool kshark_this_filter_is_set(struct tracecmd_filter_id *filter)
+bool kshark_this_filter_is_set(struct kshark_hash_id *filter)
 {
 	return filter && filter->count;
 }
@@ -645,17 +674,49 @@ bool kshark_this_filter_is_set(struct tracecmd_filter_id *filter)
  * @brief Check if an Id filter is set.
  *
  * @param kshark_ctx: Input location for the session context pointer.
+ * @param sd: Data stream identifier.
  *
- * @returns True if at least one Id filter is set, otherwise False.
+ * @returns True if at least one Id filter of the stream is set, otherwise
+ *	    False.
  */
-bool kshark_filter_is_set(struct kshark_context *kshark_ctx)
+bool kshark_filter_is_set(struct kshark_context *kshark_ctx, int sd)
 {
-	return kshark_this_filter_is_set(kshark_ctx->show_task_filter) ||
--              kshark_this_filter_is_set(kshark_ctx->hide_task_filter) ||
--              kshark_this_filter_is_set(kshark_ctx->show_cpu_filter) ||
--              kshark_this_filter_is_set(kshark_ctx->hide_cpu_filter) ||
--              kshark_this_filter_is_set(kshark_ctx->show_event_filter) ||
--              kshark_this_filter_is_set(kshark_ctx->hide_event_filter);
+	struct kshark_data_stream *stream;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return false;
+
+	return kshark_this_filter_is_set(stream->show_task_filter) ||
+	       kshark_this_filter_is_set(stream->hide_task_filter)  ||
+	       kshark_this_filter_is_set(stream->show_cpu_filter)   ||
+	       kshark_this_filter_is_set(stream->hide_cpu_filter)   ||
+	       kshark_this_filter_is_set(stream->show_event_filter) ||
+	       kshark_this_filter_is_set(stream->hide_event_filter);
+}
+
+/**
+ * @brief Apply filters to a given entry.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param entry: Input location for entry.
+ */
+void kshark_apply_filters(struct kshark_context *kshark_ctx,
+			  struct kshark_data_stream *stream,
+			  struct kshark_entry *entry)
+{
+	/* Apply event filtering. */
+	if (!kshark_show_event(stream, entry->event_id))
+		unset_event_filter_flag(kshark_ctx, entry);
+
+	/* Apply CPU filtering. */
+	if (!kshark_show_cpu(stream, entry->cpu))
+		entry->visible &= ~kshark_ctx->filter_mask;
+
+	/* Apply task filtering. */
+	if (!kshark_show_task(stream, entry->pid))
+		entry->visible &= ~kshark_ctx->filter_mask;
 }
 
 static void set_all_visible(uint8_t *v) {
@@ -663,56 +724,100 @@ static void set_all_visible(uint8_t *v) {
 	*v |= 0xFF & ~KS_PLUGIN_UNTOUCHED_MASK;
 }
 
+static void filter_entries(struct kshark_context *kshark_ctx, int sd,
+			   struct kshark_entry **data, size_t n_entries)
+{
+	struct kshark_data_stream *stream = NULL;
+	size_t i;
+
+	/* Sanity checks before starting. */
+	if (sd >= 0) {
+		/* We will filter particular Data stream. */
+		stream = kshark_get_data_stream(kshark_ctx, sd);
+		if (!stream)
+			return;
+
+		if (stream->format == KS_TEP_DATA &&
+		    kshark_tep_filter_is_set(stream)) {
+			/* The advanced filter is set. */
+			fprintf(stderr,
+				"Failed to filter (sd = %i)!\n", sd);
+			fprintf(stderr,
+				"Reset the Advanced filter or reload the data.\n");
+
+			return;
+		}
+
+		if (!kshark_filter_is_set(kshark_ctx, sd))
+			return;
+	}
+
+	/* Apply only the Id filters. */
+	for (i = 0; i < n_entries; ++i) {
+		if (sd >= 0) {
+			/*
+			 * We only filter particular stream. Chack is the entry
+			 * belongs to this stream.
+			 */
+			if (data[i]->stream_id != sd)
+				continue;
+		} else {
+			/* We filter all streams. */
+			stream = kshark_ctx->stream[data[i]->stream_id];
+		}
+
+		/* Start with and entry which is visible everywhere. */
+		set_all_visible(&data[i]->visible);
+
+		/* Apply Id filtering. */
+		kshark_apply_filters(kshark_ctx, stream, data[i]);
+	}
+}
+
 /**
  * @brief This function loops over the array of entries specified by "data"
- *	  and "n_entries" and sets the "visible" fields of each entry
- *	  according to the criteria provided by the filters of the session's
- *	  context. The field "filter_mask" of the session's context is used to
- *	  control the level of visibility/invisibility of the entries which
- *	  are filtered-out.
+ *	  and "n_entries" and sets the "visible" fields of each entry from a
+ *	  given Data stream according to the criteria provided by the filters
+ *	  of the session's context. The field "filter_mask" of the session's
+ *	  context is used to control the level of visibility/invisibility of
+ *	  the entries which are filtered-out.
  *	  WARNING: Do not use this function if the advanced filter is set.
  *	  Applying the advanced filter requires access to prevent_record,
  *	  hence the data has to be reloaded using kshark_load_data_entries().
  *
  * @param kshark_ctx: Input location for the session context pointer.
+ * @param sd: Data stream identifier.
  * @param data: Input location for the trace data to be filtered.
  * @param n_entries: The size of the inputted data.
  */
-void kshark_filter_entries(struct kshark_context *kshark_ctx,
-			   struct kshark_entry **data,
-			   size_t n_entries)
+void kshark_filter_stream_entries(struct kshark_context *kshark_ctx,
+				  int sd,
+				  struct kshark_entry **data,
+				  size_t n_entries)
 {
-	int i;
-
-	if (kshark_ctx->advanced_event_filter->filters) {
-		/* The advanced filter is set. */
-		fprintf(stderr,
-			"Failed to filter!\n");
-		fprintf(stderr,
-			"Reset the Advanced filter or reload the data.\n");
-		return;
-	}
-
-	if (!kshark_filter_is_set(kshark_ctx))
-		return;
-
-	/* Apply only the Id filters. */
-	for (i = 0; i < n_entries; ++i) {
-		/* Start with and entry which is visible everywhere. */
-		set_all_visible(&data[i]->visible);
-
-		/* Apply event filtering. */
-		if (!kshark_show_event(kshark_ctx, data[i]->event_id))
-			unset_event_filter_flag(kshark_ctx, data[i]);
-
-		/* Apply CPU filtering. */
-		if (!kshark_show_cpu(kshark_ctx, data[i]->cpu))
-			data[i]->visible &= ~kshark_ctx->filter_mask;
+	if (sd >= 0)
+		filter_entries(kshark_ctx, sd, data, n_entries);
+}
 
-		/* Apply task filtering. */
-		if (!kshark_show_task(kshark_ctx, data[i]->pid))
-			data[i]->visible &= ~kshark_ctx->filter_mask;
-	}
+/**
+ * @brief This function loops over the array of entries specified by "data"
+ *	  and "n_entries" and sets the "visible" fields of each entry from
+ *	  all Data stream according to the criteria provided by the filters
+ *	  of the session's context. The field "filter_mask" of the session's
+ *	  context is used to control the level of visibility/invisibility of
+ *	  the entries which are filtered-out.
+ *	  WARNING: Do not use this function if the advanced filter is set.
+ *	  Applying the advanced filter requires access to prevent_record,
+ *	  hence the data has to be reloaded using kshark_load_data_entries().
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param data: Input location for the trace data to be filtered.
+ * @param n_entries: The size of the inputted data.
+ */
+void kshark_filter_all_entries(struct kshark_context *kshark_ctx,
+			       struct kshark_entry **data, size_t n_entries)
+{
+	filter_entries(kshark_ctx, -1, data, n_entries);
 }
 
 /**
@@ -729,6 +834,7 @@ void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
 			      size_t n_entries)
 {
 	int i;
+
 	for (i = 0; i < n_entries; ++i)
 		set_all_visible(&data[i]->visible);
 }
@@ -852,15 +958,15 @@ void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec)
  * @param h: Array index specifying the upper edge of the range to search in.
  *
  * @returns On success, the first kshark_entry inside the range, having a
-	    timestamp equal or bigger than "time".
-	    If all entries inside the range have timestamps greater than "time"
-	    the function returns BSEARCH_ALL_GREATER (negative value).
-	    If all entries inside the range have timestamps smaller than "time"
-	    the function returns BSEARCH_ALL_SMALLER (negative value).
+ *	    timestamp equal or bigger than "time".
+ *	    If all entries inside the range have timestamps greater than "time"
+ *	    the function returns BSEARCH_ALL_GREATER (negative value).
+ *	    If all entries inside the range have timestamps smaller than "time"
+ *	    the function returns BSEARCH_ALL_SMALLER (negative value).
  */
-ssize_t kshark_find_entry_by_time(uint64_t time,
-				 struct kshark_entry **data,
-				 size_t l, size_t h)
+ssize_t kshark_find_entry_by_time(int64_t time,
+				  struct kshark_entry **data,
+				  size_t l, size_t h)
 {
 	size_t mid;
 
@@ -884,15 +990,16 @@ ssize_t kshark_find_entry_by_time(uint64_t time,
  *
  * @param kshark_ctx: Input location for the session context pointer.
  * @param e: kshark_entry to be checked.
+ * @param sd: Data stream identifier.
  * @param pid: Matching condition value.
  *
  * @returns True if the Pid of the entry matches the value of "pid".
  *	    Else false.
  */
 bool kshark_match_pid(struct kshark_context *kshark_ctx,
-		      struct kshark_entry *e, int pid)
+		      struct kshark_entry *e, int sd, int *pid)
 {
-	if (e->pid == pid)
+	if (e->stream_id == sd && e->pid == *pid)
 		return true;
 
 	return false;
@@ -903,20 +1010,80 @@ bool kshark_match_pid(struct kshark_context *kshark_ctx,
  *
  * @param kshark_ctx: Input location for the session context pointer.
  * @param e: kshark_entry to be checked.
+ * @param sd: Data stream identifier.
  * @param cpu: Matching condition value.
  *
  * @returns True if the Cpu of the entry matches the value of "cpu".
  *	    Else false.
  */
 bool kshark_match_cpu(struct kshark_context *kshark_ctx,
-		      struct kshark_entry *e, int cpu)
+		      struct kshark_entry *e, int sd, int *cpu)
 {
-	if (e->cpu == cpu)
+	if (e->stream_id == sd && e->cpu == *cpu)
 		return true;
 
 	return false;
 }
 
+/**
+ * @brief Simple event Id matching function to be user for data requests.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param e: kshark_entry to be checked.
+ * @param sd: Data stream identifier.
+ * @param event_id: Matching condition value.
+ *
+ * @returns True if the event Id of the entry matches the value of "event_id".
+ *	    Else false.
+ */
+bool kshark_match_event_id(struct kshark_context *kshark_ctx,
+			   struct kshark_entry *e, int sd, int *event_id)
+{
+	return e->stream_id == sd && e->event_id == *event_id;
+}
+
+/**
+ * @brief Simple Event Id and PID matching function to be user for data requests.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param e: kshark_entry to be checked.
+ * @param sd: Data stream identifier.
+ * @param values: An array of matching condition value.
+ *	  values[0] is the matches PID and values[1] is the matches event Id.
+ *
+ * @returns True if the event Id of the entry matches the values.
+ *	    Else false.
+ */
+bool kshark_match_event_and_pid(struct kshark_context *kshark_ctx,
+				struct kshark_entry *e,
+				int sd, int *values)
+{
+	return e->stream_id == sd &&
+	       e->event_id == values[0] &&
+	       e->pid == values[1];
+}
+
+/**
+ * @brief Simple Event Id and CPU matching function to be user for data requests.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param e: kshark_entry to be checked.
+ * @param sd: Data stream identifier.
+ * @param values: An array of matching condition value.
+ *	  values[0] is the matches PID and values[1] is the matches event Id.
+ *
+ * @returns True if the event Id of the entry matches the values.
+ *	    Else false.
+ */
+bool kshark_match_event_and_cpu(struct kshark_context *kshark_ctx,
+				struct kshark_entry *e,
+				int sd, int *values)
+{
+	return e->stream_id == sd &&
+	       e->event_id == values[0] &&
+	       e->cpu == values[1];
+}
+
 /**
  * @brief Create Data request. The request defines the properties of the
  *	  requested kshark_entry.
@@ -925,8 +1092,9 @@ bool kshark_match_cpu(struct kshark_context *kshark_ctx,
  *		 where the search starts.
  * @param n: Number of array elements to search in.
  * @param cond: Matching condition function.
- * @param val: Matching condition value, used by the Matching condition
- *	       function.
+ * @param sd: Data stream identifier.
+ * @param values: Matching condition values, used by the Matching condition
+ *		  function.
  * @param vis_only: If true, a visible entry is requested.
  * @param vis_mask: If "vis_only" is true, use this mask to specify the level
  *		    of visibility of the requested entry.
@@ -937,7 +1105,7 @@ bool kshark_match_cpu(struct kshark_context *kshark_ctx,
  */
 struct kshark_entry_request *
 kshark_entry_request_alloc(size_t first, size_t n,
-			   matching_condition_func cond, int val,
+			   matching_condition_func cond, int sd, int *values,
 			   bool vis_only, int vis_mask)
 {
 	struct kshark_entry_request *req = malloc(sizeof(*req));
@@ -952,7 +1120,8 @@ kshark_entry_request_alloc(size_t first, size_t n,
 	req->first = first;
 	req->n = n;
 	req->cond = cond;
-	req->val = val;
+	req->sd = sd;
+	req->values = values;
 	req->vis_only = vis_only;
 	req->vis_mask = vis_mask;
 
@@ -1006,7 +1175,7 @@ get_entry(const struct kshark_entry_request *req,
 	 */
 	assert((inc > 0 && start < end) || (inc < 0 && start > end));
 	for (i = start; i != end; i += inc) {
-		if (req->cond(kshark_ctx, data[i], req->val)) {
+		if (req->cond(kshark_ctx, data[i], req->sd, req->values)) {
 			/*
 			 * Data satisfying the condition has been found.
 			 */
diff --git a/src/libkshark.h b/src/libkshark.h
index a73539f4..7239f56e 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -24,10 +24,6 @@
 extern "C" {
 #endif
 
-// trace-cmd
-#include "trace-cmd/trace-cmd.h"
-#include "trace-cmd/trace-filter-hash.h"
-
 // KernelShark
 #include "libkshark-plugin.h"
 
@@ -331,7 +327,6 @@ struct kshark_data_stream {
 	 */
 	struct kshark_data_stream_interface	interface;
 };
-
 /** Hard-coded maximum number of data stream. */
 #define KS_MAX_NUM_STREAMS	127
 
@@ -343,27 +338,6 @@ struct kshark_context {
 	/** The number of data streams. */
 	int				n_streams;
 
-	/** A mutex, used to protect the access to the input file. */
-	pthread_mutex_t		input_mutex;
-
-	/** Hash of tasks to filter on. */
-	struct tracecmd_filter_id	*show_task_filter;
-
-	/** Hash of tasks to not display. */
-	struct tracecmd_filter_id	*hide_task_filter;
-
-	/** Hash of events to filter on. */
-	struct tracecmd_filter_id	*show_event_filter;
-
-	/** Hash of events to not display. */
-	struct tracecmd_filter_id	*hide_event_filter;
-
-	/** Hash of CPUs to filter on. */
-	struct tracecmd_filter_id	*show_cpu_filter;
-
-	/** Hash of CPUs to not display. */
-	struct tracecmd_filter_id	*hide_cpu_filter;
-
 	/**
 	 * Bit mask, controlling the visibility of the entries after filtering.
 	 * If given bit is set here, all entries which are filtered-out will
@@ -371,12 +345,6 @@ struct kshark_context {
 	 */
 	uint8_t				filter_mask;
 
-	/**
-	 * Filter allowing sophisticated filtering based on the content of
-	 * the event.
-	 */
-	struct tep_event_filter		*advanced_event_filter;
-
 	/** List of Data collections. */
 	struct kshark_entry_collection *collections;
 
@@ -651,14 +619,22 @@ enum kshark_filter_type {
 	KS_HIDE_CPU_FILTER,
 };
 
-void kshark_filter_add_id(struct kshark_context *kshark_ctx,
+struct kshark_hash_id *
+kshark_get_filter(struct kshark_data_stream *stream,
+		  enum kshark_filter_type filter_id);
+
+void kshark_filter_add_id(struct kshark_context *kshark_ctx, int sd,
 			  int filter_id, int id);
 
-void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id);
+int *kshark_get_filter_ids(struct kshark_context *kshark_ctx, int sd,
+			   int filter_id, int *n);
+
+void kshark_filter_clear(struct kshark_context *kshark_ctx, int sd,
+			 int filter_id);
 
-bool kshark_this_filter_is_set(struct tracecmd_filter_id *filter);
+bool kshark_this_filter_is_set(struct kshark_hash_id *filter);
 
-bool kshark_filter_is_set(struct kshark_context *kshark_ctx);
+bool kshark_filter_is_set(struct kshark_context *kshark_ctx, int sd);
 
 static inline void unset_event_filter_flag(struct kshark_context *kshark_ctx,
 					   struct kshark_entry *e)
@@ -675,9 +651,16 @@ static inline void unset_event_filter_flag(struct kshark_context *kshark_ctx,
 	e->visible &= ~event_mask;
 }
 
-void kshark_filter_entries(struct kshark_context *kshark_ctx,
-			   struct kshark_entry **data,
-			   size_t n_entries);
+void kshark_apply_filters(struct kshark_context *kshark_ctx,
+			  struct kshark_data_stream *stream,
+			  struct kshark_entry *entry);
+
+void kshark_filter_stream_entries(struct kshark_context *kshark_ctx, int sd,
+				  struct kshark_entry **data,
+				  size_t n_entries);
+
+void kshark_filter_all_entries(struct kshark_context *kshark_ctx,
+			       struct kshark_entry **data, size_t n_entries);
 
 void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
 			      struct kshark_entry **data,
@@ -688,10 +671,10 @@ void kshark_plugin_actions(struct kshark_data_stream *stream,
 
 /** Search failed identifiers. */
 enum kshark_search_failed {
-	/** All entries have timestamps greater timestamps. */
+	/** All entries have greater timestamps. */
 	BSEARCH_ALL_GREATER = -1,
 
-	/** All entries have timestamps smaller timestamps. */
+	/** All entries have smaller timestamps. */
 	BSEARCH_ALL_SMALLER = -2,
 };
 
@@ -707,15 +690,26 @@ enum kshark_search_failed {
 		}					\
 	})
 
-ssize_t kshark_find_entry_by_time(uint64_t time,
+ssize_t kshark_find_entry_by_time(int64_t time,
 				  struct kshark_entry **data_rows,
 				  size_t l, size_t h);
 
 bool kshark_match_pid(struct kshark_context *kshark_ctx,
-		      struct kshark_entry *e, int pid);
+		      struct kshark_entry *e, int sd, int *pid);
 
 bool kshark_match_cpu(struct kshark_context *kshark_ctx,
-		      struct kshark_entry *e, int cpu);
+		      struct kshark_entry *e, int sd, int *cpu);
+
+bool kshark_match_event_id(struct kshark_context *kshark_ctx,
+			   struct kshark_entry *e, int sd, int *event_id);
+
+bool kshark_match_event_and_pid(struct kshark_context *kshark_ctx,
+				struct kshark_entry *e,
+				int sd, int *values);
+
+bool kshark_match_event_and_cpu(struct kshark_context *kshark_ctx,
+				struct kshark_entry *e,
+				int sd, int *values);
 
 /**
  * Empty bin identifier.
@@ -733,7 +727,7 @@ bool kshark_match_cpu(struct kshark_context *kshark_ctx,
 /** Matching condition function type. To be user for data requests */
 typedef bool (matching_condition_func)(struct kshark_context*,
 				       struct kshark_entry*,
-				       int);
+				       int, int*);
 
 /**
  * Data request structure, defining the properties of the required
@@ -755,10 +749,13 @@ struct kshark_entry_request {
 	/** Matching condition function. */
 	matching_condition_func *cond;
 
+	/** Data stream identifier. */
+	int sd;
+
 	/**
 	 * Matching condition value, used by the Matching condition function.
 	 */
-	int val;
+	int *values;
 
 	/** If true, a visible entry is requested. */
 	bool vis_only;
@@ -772,7 +769,7 @@ struct kshark_entry_request {
 
 struct kshark_entry_request *
 kshark_entry_request_alloc(size_t first, size_t n,
-			   matching_condition_func cond, int val,
+			   matching_condition_func cond, int sd, int *values,
 			   bool vis_only, int vis_mask);
 
 void kshark_free_entry_request(struct kshark_entry_request *req);
@@ -789,8 +786,8 @@ kshark_get_entry_back(const struct kshark_entry_request *req,
 
 /**
  * Data collections are used to optimize the search for an entry having an
- * abstract property, defined by a Matching condition function and a value.
- * When a collection is processed, the data which is relevant for the
+ * abstract property, defined by a Matching condition function and an array of
+ * values. When a collection is processed, the data which is relevant for the
  * collection is enclosed in "Data intervals", defined by pairs of "Resume" and
  * "Break" points. It is guaranteed that the data outside of the intervals
  * contains no entries satisfying the abstract matching condition. However, the
@@ -807,11 +804,17 @@ struct kshark_entry_collection {
 	/** Matching condition function, used to define the collections. */
 	matching_condition_func *cond;
 
+	/** Data stream identifier. */
+	int stream_id;
+
 	/**
-	 * Matching condition value, used by the Matching condition finction
-	 * to define the collections.
+	 * Array of matching condition values, used by the Matching condition
+	 * finction to define the collection.
 	 */
-	int val;
+	int *values;
+
+	/** The suze of the array of matching condition values. */
+	int n_val;
 
 	/**
 	 * Array of indexes defining the beginning of each individual data
@@ -834,26 +837,30 @@ kshark_add_collection_to_list(struct kshark_context *kshark_ctx,
 			      struct kshark_entry **data,
 			      size_t n_rows,
 			      matching_condition_func cond,
-			      int val,
+			      int sd, int *values, size_t n_val,
 			      size_t margin);
 
 struct kshark_entry_collection *
 kshark_register_data_collection(struct kshark_context *kshark_ctx,
 				struct kshark_entry **data, size_t n_rows,
-				matching_condition_func cond, int val,
+				matching_condition_func cond,
+				int sd, int *values, size_t n_val,
 				size_t margin);
 
 void kshark_unregister_data_collection(struct kshark_entry_collection **col,
 				       matching_condition_func cond,
-				       int val);
+				       int sd, int *values, size_t n_val);
 
 struct kshark_entry_collection *
 kshark_find_data_collection(struct kshark_entry_collection *col,
 			    matching_condition_func cond,
-			    int val);
+			    int sd, int *values, size_t n_val);
 
 void kshark_reset_data_collection(struct kshark_entry_collection *col);
 
+void kshark_unregister_stream_collections(struct kshark_entry_collection **col,
+					  int sd);
+
 void kshark_free_collection_list(struct kshark_entry_collection *col);
 
 const struct kshark_entry *
@@ -995,17 +1002,27 @@ bool kshark_export_adv_filters(struct kshark_context *kshark_ctx,
 bool kshark_import_adv_filters(struct kshark_context *kshark_ctx,
 			       struct kshark_config_doc *conf);
 
+bool kshark_export_event_filter(struct kshark_data_stream *stream,
+				enum kshark_filter_type filter_type,
+				const char *filter_name,
+				struct kshark_config_doc *conf);
+
+int kshark_import_event_filter(struct kshark_data_stream *stream,
+			       enum kshark_filter_type filter_type,
+			       const char *filter_name,
+			       struct kshark_config_doc *conf);
+
 bool kshark_export_user_mask(struct kshark_context *kshark_ctx,
 			     struct kshark_config_doc **conf);
 
 bool kshark_import_user_mask(struct kshark_context *kshark_ctx,
 			     struct kshark_config_doc *conf);
 
-bool kshark_export_filter_array(struct tracecmd_filter_id *filter,
+bool kshark_export_filter_array(struct kshark_hash_id *filter,
 				const char *filter_name,
 				struct kshark_config_doc *conf);
 
-bool kshark_import_filter_array(struct tracecmd_filter_id *filter,
+bool kshark_import_filter_array(struct kshark_hash_id *filter,
 				const char *filter_name,
 				struct kshark_config_doc *conf);
 
-- 
2.25.1

