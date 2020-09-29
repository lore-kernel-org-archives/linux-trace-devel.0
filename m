Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55285C4727D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B882145D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:42:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qVSPqxwO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730123AbgI2NmK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbgI2NmK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:42:10 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C938C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:42:08 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e16so5492860wrm.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H/jCUSEMLfC78nTbHR79KSAYPXvC0FbRMqZZe7Z1x1s=;
        b=qVSPqxwOafoJYw7u/iTETLnFk1wxS5dGqrgKu1hG3+usMD/dil/moCOUpbfSTIXhhn
         UmfbhIeM6nZWSW18LpVF57c9E7uz7u2O4CdXdeUsSm+w0+nN5kSIBLVW3m4vPiGlHgiX
         3xOYt2Wf+ux34m4tll4Fe/8oMJjPgHt+bNfjvzOSfeyBFRVOhpm3mKLQTZBcBg161La0
         jT+q+OoV2ykAmHl4PR43atQxNxW38qxQAigoTzFkf2MQn1F4fmPf5hdyyZfwhUmonvCy
         g08rfPlgSdbTqt/UmTZMS1//ISSzRjFPU1nF/DdvnusEAEFzOekbgNbCfUflHlggID/u
         3uYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H/jCUSEMLfC78nTbHR79KSAYPXvC0FbRMqZZe7Z1x1s=;
        b=mpKkg2TGxilh1tmWDsNxu7W8/hX8Fz/vGFTs2MH4iPUkF/F63USBq/HFX45goypwwA
         Qomwifj7xVqIwzF/1jbaB/iy/ziZYzfKr5wReSRL1gXB5mBLCVYADEwos9ohxFcyJ0ci
         I3iGtIB9GHkfn401WIhLRYIyKQIrVJpyc7hA0OCHRD+JMeDe1uUYcUuNzYWUERJGwQyY
         Mn/p5vGXnRYcmZAhk/CrAQ1FmbHhmt2jpJaIrV53GjaOvySFxJfJEF1MUogOxV+UL7ba
         fZJCyBXQsUvf236IfdDIc1bGEn/65mPa7ivf5A6X0Hijasqa96kL2VzuUBl7mZNIfTsX
         7iXQ==
X-Gm-Message-State: AOAM53072L8rwdr013pCwcq1DnoxzaILOWOTuytbQRgO4GeNFoAYKsx0
        NywVVmyph6E1y6OOHPdczaI=
X-Google-Smtp-Source: ABdhPJxl1IvcZsUlSrX9IV5DDDmUv1uaKgQXaLBNJHsXt7QNwp0413/Zy9KLowhXp4q9O8WApvnnNg==
X-Received: by 2002:a5d:570b:: with SMTP id a11mr4543844wrv.139.1601386925106;
        Tue, 29 Sep 2020 06:42:05 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id b84sm6162792wmd.0.2020.09.29.06.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:42:04 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 08/15] kernel-shark: Integrate the stream definitions with the C API
Date:   Tue, 29 Sep 2020 16:41:16 +0300
Message-Id: <20200929134123.178688-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929134123.178688-1-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Unfortunately this integration can only happen in a single change,
which results into one huge patch, that may be hard to review. In
this patch we modify the API itself plus the two most basic examples
demonstrating how to use it. The most noticeable change that this
new version of the API brings is that the processing of the
trace-cmd/Ftrace data is wrapped inside the dedicated implementation
of the Data stream interface and no trace-cmd definitions are leaking
outside of src/libkshark-tepdata.c.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/datafilter.c      |   67 +-
 examples/dataload.c        |   22 +-
 src/CMakeLists.txt         |    3 +-
 src/libkshark-collection.c |  121 ++-
 src/libkshark-plugin.c     |  597 +++++++++--
 src/libkshark-plugin.h     |  279 ++++--
 src/libkshark-tepdata.c    | 1754 ++++++++++++++++++++++++++++++++
 src/libkshark-tepdata.h    |  100 ++
 src/libkshark.c            | 1928 +++++++++++++-----------------------
 src/libkshark.h            |  414 +++++---
 10 files changed, 3699 insertions(+), 1586 deletions(-)
 create mode 100644 src/libkshark-tepdata.c
 create mode 100644 src/libkshark-tepdata.h

diff --git a/examples/datafilter.c b/examples/datafilter.c
index bebc181..38afab8 100644
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
diff --git a/examples/dataload.c b/examples/dataload.c
index 15c5de0..ab3612f 100644
--- a/examples/dataload.c
+++ b/examples/dataload.c
@@ -19,8 +19,7 @@ int main(int argc, char **argv)
 	struct kshark_entry **data = NULL;
 	ssize_t r, n_rows, n_tasks;
 	char *entry_str;
-	bool status;
-	int *pids;
+	int sd, *pids;
 
 	/* Create a new kshark session. */
 	kshark_ctx = NULL;
@@ -29,30 +28,29 @@ int main(int argc, char **argv)
 
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
+	n_rows = kshark_load_entries(kshark_ctx, sd, &data);
 	if (n_rows < 1) {
 		kshark_free(kshark_ctx);
 		return 1;
 	}
 
 	/* Print to the screen the list of all tasks. */
-	n_tasks = kshark_get_task_pids(kshark_ctx, &pids);
+	n_tasks = kshark_get_task_pids(kshark_ctx, sd, &pids);
 	for (r = 0; r < n_tasks; ++r) {
-		const char *task_str =
-			tep_data_comm_from_pid(kshark_ctx->pevent,
-					       pids[r]);
-
+		char *task_str =
+			kshark_comm_from_pid(sd, pids[r]);
 		printf("task: %s-%i\n", task_str, pids[r]);
+		free(task_str);
 	}
 
 	free(pids);
@@ -82,7 +80,7 @@ int main(int argc, char **argv)
 	free(data);
 
 	/* Close the file. */
-	kshark_close(kshark_ctx);
+	kshark_close(kshark_ctx, sd);
 
 	/* Close the session. */
 	kshark_free(kshark_ctx);
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 39c4dcf..99c47ea 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -6,7 +6,8 @@ add_library(kshark SHARED libkshark.c
 #                           libkshark-model.c
                           libkshark-plugin.c
 #                           libkshark-configio.c
-                          libkshark-collection.c)
+                          libkshark-collection.c
+                          libkshark-tepdata.c)
 
 target_link_libraries(kshark ${TRACECMD_LIBRARY}
                              ${TRACEFS_LIBRARY}
diff --git a/src/libkshark-collection.c b/src/libkshark-collection.c
index 66cdbca..915983b 100644
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
diff --git a/src/libkshark-plugin.c b/src/libkshark-plugin.c
index 4b21392..8e5299c 100644
--- a/src/libkshark-plugin.c
+++ b/src/libkshark-plugin.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: LGPL-2.1
 
 /*
- * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
  /**
@@ -13,8 +13,7 @@
 #ifndef _GNU_SOURCE
 /** Use GNU C Library. */
 #define _GNU_SOURCE
-
-#endif
+#endif // _GNU_SOURCE
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -27,23 +26,36 @@
 #include "libkshark-plugin.h"
 #include "libkshark.h"
 
-static struct kshark_event_handler *
-gui_event_handler_alloc(int event_id,
-			kshark_plugin_event_handler_func evt_func,
-			kshark_plugin_draw_handler_func dw_func)
+static struct kshark_event_proc_handler *
+data_event_handler_alloc(int event_id,
+			 kshark_plugin_event_handler_func evt_func)
 {
-	struct kshark_event_handler *handler = malloc(sizeof(*handler));
+	struct kshark_event_proc_handler *handler = malloc(sizeof(*handler));
 
 	if (!handler) {
-		fprintf(stderr,
-			"failed to allocate memory for gui eventhandler");
+		fputs("failed to allocate memory for event handler\n", stderr);
 		return NULL;
 	}
 
 	handler->next = NULL;
 	handler->id = event_id;
 	handler->event_func = evt_func;
-	handler->draw_func = dw_func;
+
+	return handler;
+}
+
+static struct kshark_draw_handler *
+data_draw_handler_alloc(kshark_plugin_draw_handler_func draw_func)
+{
+	struct kshark_draw_handler *handler = malloc(sizeof(*handler));
+
+	if (!handler) {
+		fputs("failed to allocate memory for draw handler\n", stderr);
+		return NULL;
+	}
+
+	handler->next = NULL;
+	handler->draw_func = draw_func;
 
 	return handler;
 }
@@ -55,8 +67,8 @@ gui_event_handler_alloc(int event_id,
  * @param handlers: Input location for the Event handler list.
  * @param event_id: Event Id to search for.
  */
-struct kshark_event_handler *
-kshark_find_event_handler(struct kshark_event_handler *handlers, int event_id)
+struct kshark_event_proc_handler *
+kshark_find_event_handler(struct kshark_event_proc_handler *handlers, int event_id)
 {
 	for (; handlers; handlers = handlers->next)
 		if (handlers->id == event_id)
@@ -68,26 +80,25 @@ kshark_find_event_handler(struct kshark_event_handler *handlers, int event_id)
 /**
  * @brief Add new event handler to an existing list of handlers.
  *
- * @param handlers: Input location for the Event handler list.
+ * @param stream: Input location for a Trace data stream pointer.
  * @param event_id: Event Id.
  * @param evt_func: Input location for an Event action provided by the plugin.
- * @param dw_func: Input location for a Draw action provided by the plugin.
  *
  * @returns Zero on success, or a negative error code on failure.
  */
-int kshark_register_event_handler(struct kshark_event_handler **handlers,
+int kshark_register_event_handler(struct kshark_data_stream *stream,
 				  int event_id,
-				  kshark_plugin_event_handler_func evt_func,
-				  kshark_plugin_draw_handler_func dw_func)
+				  kshark_plugin_event_handler_func evt_func)
 {
-	struct kshark_event_handler *handler =
-		gui_event_handler_alloc(event_id, evt_func, dw_func);
+	struct kshark_event_proc_handler *handler =
+		data_event_handler_alloc(event_id, evt_func);
 
 	if(!handler)
 		return -ENOMEM;
 
-	handler->next = *handlers;
-	*handlers = handler;
+	handler->next = stream->event_handlers;
+	stream->event_handlers = handler;
+
 	return 0;
 }
 
@@ -95,23 +106,20 @@ int kshark_register_event_handler(struct kshark_event_handler **handlers,
  * @brief Search the list for a specific plugin handle. If such a plugin handle
  *	  exists, unregister (remove and free) this handle from the list.
  *
- * @param handlers: Input location for the Event handler list.
+ * @param stream: Input location for a Trace data stream pointer.
  * @param event_id: Event Id of the plugin handler to be unregistered.
- * @param evt_func: Event action function of the handler to be unregistered.
- * @param dw_func: Draw action function of the handler to be unregistered.
+ * @param evt_func: Event action function to be unregistered.
  */
-void kshark_unregister_event_handler(struct kshark_event_handler **handlers,
+void kshark_unregister_event_handler(struct kshark_data_stream *stream,
 				     int event_id,
-				     kshark_plugin_event_handler_func evt_func,
-				     kshark_plugin_draw_handler_func dw_func)
+				     kshark_plugin_event_handler_func evt_func)
 {
-	struct kshark_event_handler **last;
+	struct kshark_event_proc_handler **last;
 
-	for (last = handlers; *last; last = &(*last)->next) {
+	for (last = &stream->event_handlers; *last; last = &(*last)->next) {
 		if ((*last)->id == event_id &&
-		    (*last)->event_func == evt_func &&
-		    (*last)->draw_func == dw_func) {
-			struct kshark_event_handler *this_handler;
+		    (*last)->event_func == evt_func) {
+			struct kshark_event_proc_handler *this_handler;
 			this_handler = *last;
 			*last = this_handler->next;
 			free(this_handler);
@@ -126,9 +134,71 @@ void kshark_unregister_event_handler(struct kshark_event_handler **handlers,
  *
  * @param handlers: Input location for the Event handler list.
  */
-void kshark_free_event_handler_list(struct kshark_event_handler *handlers)
+void kshark_free_event_handler_list(struct kshark_event_proc_handler *handlers)
+{
+	struct kshark_event_proc_handler *last;
+
+	while (handlers) {
+		last = handlers;
+		handlers = handlers->next;
+		free(last);
+	}
+}
+
+/**
+ * @brief Add new event handler to an existing list of handlers.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param draw_func: Input location for a Draw action provided by the plugin.
+ *
+ * @returns Zero on success, or a negative error code on failure.
+ */
+int kshark_register_draw_handler(struct kshark_data_stream *stream,
+				 kshark_plugin_draw_handler_func draw_func)
+{
+	struct kshark_draw_handler *handler = data_draw_handler_alloc(draw_func);
+
+	if(!handler)
+		return -ENOMEM;
+
+	handler->next = stream->draw_handlers;
+	stream->draw_handlers = handler;
+
+	return 0;
+}
+
+/**
+ * @brief Search the list for a specific plugin handle. If such a plugin handle
+ *	  exists, unregister (remove and free) this handle from the list.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param draw_func: Draw action function to be unregistered.
+ */
+void kshark_unregister_draw_handler(struct kshark_data_stream *stream,
+				    kshark_plugin_draw_handler_func draw_func)
+{
+	struct kshark_draw_handler **last;
+
+	for (last = &stream->draw_handlers; *last; last = &(*last)->next) {
+		if ((*last)->draw_func == draw_func) {
+			struct kshark_draw_handler *this_handler;
+			this_handler = *last;
+			*last = this_handler->next;
+			free(this_handler);
+
+			return;
+		}
+	}
+}
+
+/**
+ * @brief Free all DRaw handlers in a given list.
+ *
+ * @param handlers: Input location for the Draw handler list.
+ */
+void kshark_free_draw_handler_list(struct kshark_draw_handler *handlers)
 {
-	struct kshark_event_handler *last;
+	struct kshark_draw_handler *last;
 
 	while (handlers) {
 		last = handlers;
@@ -139,96 +209,182 @@ void kshark_free_event_handler_list(struct kshark_event_handler *handlers)
 
 /**
  * @brief Allocate memory for a new plugin. Add this plugin to the list of
- *	  plugins used by the session.
+ *	  plugins.
  *
  * @param kshark_ctx: Input location for the session context pointer.
+ * @param name: The name of the plugin to register.
  * @param file: The plugin object file to load.
  *
- * @returns Zero on success, or a negative error code on failure.
+ * @returns The plugin object on success, or NULL on failure.
  */
-int kshark_register_plugin(struct kshark_context *kshark_ctx,
-			   const char *file)
+struct kshark_plugin_list *
+kshark_register_plugin(struct kshark_context *kshark_ctx,
+		       const char *name,
+		       const char *file)
 {
-	struct kshark_plugin_list *plugin = kshark_ctx->plugins;
+	kshark_plugin_load_func init_func, close_func;
+	kshark_check_data_func check_func;
+	struct kshark_plugin_list *plugin;
 	struct stat st;
 	int ret;
 
-	while (plugin) {
-		if (strcmp(plugin->file, file) == 0)
-			return -EEXIST;
+	printf("loading plugin \"%s\" from %s\n", name, file);
 
-		plugin = plugin->next;
+	plugin = kshark_find_plugin(kshark_ctx->plugins, file);
+	if(plugin) {
+		fputs("the plugin is already loaded.\n", stderr);
+		return NULL;
 	}
 
 	ret = stat(file, &st);
 	if (ret < 0) {
-		fprintf(stderr, "plugin %s not found\n", file);
-		return -ENODEV;
+		fprintf(stderr, "plugin %s not found.\n", file);
+		return NULL;
 	}
 
-	plugin = calloc(sizeof(struct kshark_plugin_list), 1);
+	plugin = calloc(1, sizeof(struct kshark_plugin_list));
 	if (!plugin) {
-		fprintf(stderr, "failed to allocate memory for plugin\n");
-		return -ENOMEM;
+		fputs("failed to allocate memory for plugin.\n", stderr);
+		return NULL;
 	}
 
-	if (asprintf(&plugin->file, "%s", file) <= 0) {
+	plugin->handle = dlopen(file, RTLD_NOW | RTLD_GLOBAL);
+	if (!plugin->handle) {
 		fprintf(stderr,
-			"failed to allocate memory for plugin file name");
-		return -ENOMEM;
+			"failed to open plugin file.\n%s\n",
+			dlerror());
+		goto fail;
 	}
 
-	plugin->handle = dlopen(plugin->file, RTLD_NOW | RTLD_GLOBAL);
-	if (!plugin->handle)
+	plugin->file = strdup(file);
+	plugin->name = strdup(name);
+	if (!plugin->file|| !plugin->name)
 		goto fail;
 
-	plugin->init = dlsym(plugin->handle,
-			     KSHARK_PLUGIN_INITIALIZER_NAME);
+	plugin->ctrl_interface =
+		dlsym(plugin->handle, KSHARK_MENU_PLUGIN_INITIALIZER_NAME);
+
+	init_func = dlsym(plugin->handle,
+			  KSHARK_PLOT_PLUGIN_INITIALIZER_NAME);
 
-	plugin->close = dlsym(plugin->handle,
-			      KSHARK_PLUGIN_DEINITIALIZER_NAME);
+	close_func = dlsym(plugin->handle,
+			   KSHARK_PLOT_PLUGIN_DEINITIALIZER_NAME);
 
-	if (!plugin->init || !plugin->close)
+	if (!!(long)init_func && !!(long)close_func) {
+		plugin->process_interface =
+			calloc(1, sizeof(*plugin->process_interface));
+
+		if (!plugin->process_interface)
+			goto fail;
+
+		plugin->process_interface->name = strdup(plugin->name);
+		plugin->process_interface->init = init_func;
+		plugin->process_interface->close = close_func;
+	} else if (!!(long)init_func || !!(long)close_func) {
+		fprintf(stderr,
+			"incomplete draw interface found (will be ignored).\n%s\n",
+			dlerror());
+	}
+
+	init_func = dlsym(plugin->handle,
+			  KSHARK_INPUT_INITIALIZER_NAME);
+
+	close_func = dlsym(plugin->handle,
+			   KSHARK_INPUT_DEINITIALIZER_NAME);
+
+	check_func = dlsym(plugin->handle,
+			   KSHARK_INPUT_CHECK_NAME);
+
+	if (!!(long)init_func &&
+	    !!(long)close_func &&
+	    !!(long)check_func) {
+		plugin->readout_interface =
+			calloc(1, sizeof(*plugin->readout_interface));
+
+		if (!plugin->readout_interface)
+			goto fail;
+
+		plugin->readout_interface->name = strdup(plugin->name);
+		plugin->readout_interface->init = init_func;
+		plugin->readout_interface->close = close_func;
+		plugin->readout_interface->check_data = check_func;
+
+		kshark_register_input(kshark_ctx, plugin->readout_interface);
+	} else if (!!(long)init_func ||
+		   !!(long)close_func ||
+		   !!(long)check_func) {
+		fprintf(stderr,
+			"incomplete input interface found (will be ignored).\n%s\n",
+			dlerror());
+	}
+
+	if (!plugin->process_interface &&
+	    !plugin->readout_interface &&
+	    !plugin->ctrl_interface) {
+		fputs("no interfaces found in this plugin.\n", stderr);
 		goto fail;
+	}
 
 	plugin->next = kshark_ctx->plugins;
 	kshark_ctx->plugins = plugin;
+	kshark_ctx->n_plugins++;
 
-	return 0;
+	return plugin;
 
  fail:
-	fprintf(stderr, "cannot load plugin '%s'\n%s\n",
-		plugin->file, dlerror());
+	fprintf(stderr, "cannot load plugin '%s'\n", file);
 
-	if (plugin->handle) {
+	if (plugin->handle)
 		dlclose(plugin->handle);
-		plugin->handle = NULL;
-	}
 
 	free(plugin);
 
-	return EFAULT;
+	return NULL;
+}
+
+/** Close and free this plugin. */
+static void free_plugin(struct kshark_plugin_list *plugin)
+{
+	dlclose(plugin->handle);
+
+	if (plugin->process_interface){
+		free(plugin->process_interface->name);
+		free(plugin->process_interface);
+	}
+
+	if (plugin->readout_interface) {
+		free(plugin->readout_interface->name);
+		free(plugin->readout_interface);
+	}
+
+	free(plugin->name);
+	free(plugin->file);
+	free(plugin);
 }
 
 /**
  * @brief Unrgister a plugin.
  *
- * @param kshark_ctx: Input location for context pointer.
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param name: The name of the plugin to unregister.
  * @param file: The plugin object file to unregister.
  */
 void kshark_unregister_plugin(struct kshark_context *kshark_ctx,
+			      const char *name,
 			      const char *file)
 {
 	struct kshark_plugin_list **last;
 
 	for (last = &kshark_ctx->plugins; *last; last = &(*last)->next) {
-		if (strcmp((*last)->file, file) == 0) {
+		if (strcmp((*last)->process_interface->name, name) == 0 &&
+		    strcmp((*last)->file, file) == 0) {
 			struct kshark_plugin_list *this_plugin;
+
 			this_plugin = *last;
 			*last = this_plugin->next;
+			free_plugin(this_plugin);
 
-			dlclose(this_plugin->handle);
-			free(this_plugin);
+			kshark_ctx->n_plugins--;
 
 			return;
 		}
@@ -248,48 +404,303 @@ void kshark_free_plugin_list(struct kshark_plugin_list *plugins)
 		last = plugins;
 		plugins = plugins->next;
 
-		free(last->file);
-		dlclose(last->handle);
+		free_plugin(last);
+	}
+}
+
+/**
+ * @brief Register a data readout interface (input).
+ *
+ * @param kshark_ctx: Input location for the context pointer.
+ * @param plugin: Input location for the data readout interface (input).
+ */
+struct kshark_dri_list *
+kshark_register_input(struct kshark_context *kshark_ctx,
+		      struct kshark_dri *plugin)
+{
+	struct kshark_dri_list *input;
+
+	input = calloc(1, sizeof(*input));
+	if (!input) {
+		fputs("failed to allocate memory for readout plugin.\n", stderr);
+		return NULL;
+	}
 
+	input->interface = plugin;
+	input->next = kshark_ctx->inputs;
+	kshark_ctx->inputs = input;
+
+	return input;
+}
+
+/**
+ * @brief Unrgister a data readout interface (input).
+ *
+ * @param kshark_ctx: Input location for the context pointer.
+ * @param name: The data readout's name.
+ */
+void kshark_unregister_input(struct kshark_context *kshark_ctx,
+			     const char *name)
+{
+	struct kshark_dri_list **last;
+
+	for (last = &kshark_ctx->inputs; *last; last = &(*last)->next) {
+		if (strcmp((*last)->interface->name, name) == 0) {
+			struct kshark_dri_list *this_input;
+			this_input = *last;
+			*last = this_input->next;
+
+			free(this_input);
+
+			return;
+		}
+	}
+}
+
+/**
+ * @brief Free a list of plugin interfaces.
+ *
+ * @param plugins: Input location for the plugins list.
+ */
+void
+kshark_free_dpi_list(struct kshark_dpi_list *plugins)
+{
+	struct kshark_dpi_list *last;
+
+	while (plugins) {
+		last = plugins;
+		plugins = plugins->next;
 		free(last);
 	}
 }
 
 /**
- * @brief Use this function to initialize/update/deinitialize all registered
- *	  plugins.
+ * @brief Find a plugin by its library file.
+ *
+ * @param plugins: A list of plugins to search in.
+ * @param lib: The plugin object file to load.
  *
- * @param kshark_ctx: Input location for context pointer.
+ * @returns The plugin object on success, or NULL on failure.
+ */
+struct kshark_plugin_list *
+kshark_find_plugin(struct kshark_plugin_list *plugins, const char *lib)
+{
+	for (; plugins; plugins = plugins->next)
+		if (strcmp(plugins->file, lib) == 0)
+			return plugins;
+
+	return NULL;
+}
+
+/**
+ * @brief Find a plugin by its name.
+ *
+ * @param plugins: A list of plugins to search in.
+ * @param name: The plugin object file to load.
+ *
+ * @returns The plugin object on success, or NULL on failure.
+ */
+struct kshark_plugin_list *
+kshark_find_plugin_by_name(struct kshark_plugin_list *plugins,
+			   const char *name)
+{
+	for (; plugins; plugins = plugins->next)
+		if (strcmp(plugins->name, name) == 0)
+			return plugins;
+
+	return NULL;
+}
+
+/**
+ * @brief Register plugin to a given data stream.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param plugin: Input location for the data processing interface.
+ * @param active: If false, the plugin will be registered but disables.
+ *		  Otherwise the plugin will be active.
+ *
+ * @returns The plugin object on success, or NULL on failure.
+ */
+struct kshark_dpi_list *
+kshark_register_plugin_to_stream(struct kshark_data_stream *stream,
+				 struct kshark_dpi *plugin,
+				 bool active)
+{
+	struct kshark_dpi_list *plugin_list = stream->plugins;
+
+	/* Check if the plugin is already registered to this stream. */
+	while (plugin_list) {
+		if (strcmp(plugin_list->interface->name, plugin->name) == 0 &&
+		    plugin_list->interface->init == plugin->init &&
+		    plugin_list->interface->close == plugin->close) {
+			kshark_handle_dpi(stream, plugin_list,
+					  KSHARK_PLUGIN_CLOSE);
+
+			plugin_list->status =
+				(active)? KSHARK_PLUGIN_ENABLED : 0;
+
+			return plugin_list;
+		}
+
+		plugin_list = plugin_list->next;
+	}
+
+	plugin_list = calloc(1, sizeof(*plugin_list));
+	plugin_list->interface = plugin;
+
+	if (active)
+		plugin_list->status = KSHARK_PLUGIN_ENABLED;
+
+	plugin_list->next = stream->plugins;
+	stream->plugins = plugin_list;
+	stream->n_plugins++;
+
+	return plugin_list;
+}
+
+/**
+ * @brief Unregister plugin to a given data stream.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param plugin: Input location for the data processing interface.
+ */
+void kshark_unregister_plugin_from_stream(struct kshark_data_stream *stream,
+				          struct kshark_dpi *plugin)
+{
+	struct kshark_dpi_list **last;
+
+	for (last = &stream->plugins; *last; last = &(*last)->next) {
+		if ((*last)->interface->init == plugin->init &&
+		    (*last)->interface->close == plugin->close &&
+		    strcmp((*last)->interface->name, plugin->name) == 0) {
+			struct kshark_dpi_list *this_plugin;
+
+			this_plugin = *last;
+			*last = this_plugin->next;
+			this_plugin->interface->close(stream);
+			free(this_plugin);
+
+			stream->n_plugins--;
+
+			return;
+		}
+	}
+}
+
+static void plugin_init(struct kshark_data_stream *stream,
+			struct kshark_dpi_list *plugin)
+{
+	int handler_count = plugin->interface->init(stream);
+
+	if (handler_count > 0) {
+		plugin->status &= ~KSHARK_PLUGIN_FAILED;
+		plugin->status |= KSHARK_PLUGIN_LOADED;
+	} else {
+		fprintf(stderr,
+			"plugin \"%s\" failed to initialize on stream %s:%s\n",
+			plugin->interface->name,
+			stream->file,
+			stream->name);
+
+		plugin->status |= KSHARK_PLUGIN_FAILED;
+		plugin->status &= ~KSHARK_PLUGIN_LOADED;
+	}
+}
+
+static void plugin_close(struct kshark_data_stream *stream,
+			 struct kshark_dpi_list *plugin)
+{
+	plugin->interface->close(stream);
+	plugin->status &= ~KSHARK_PLUGIN_LOADED;
+}
+
+/**
+ * @brief Use this function to initialize/update/deinitialize a plugin for
+ *	  a given Data stream.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param plugin: The plugin to be handled.
  * @param task_id: Action identifier specifying the action to be executed.
  *
  * @returns The number of successful added/removed plugin handlers on success,
  *	    or a negative error code on failure.
  */
-int kshark_handle_plugins(struct kshark_context *kshark_ctx,
-			  enum kshark_plugin_actions task_id)
+int kshark_handle_dpi(struct kshark_data_stream *stream,
+		      struct kshark_dpi_list *plugin,
+		      enum kshark_plugin_actions task_id)
 {
-	struct kshark_plugin_list *plugin;
 	int handler_count = 0;
 
-	for (plugin = kshark_ctx->plugins; plugin; plugin = plugin->next) {
-		switch (task_id) {
-		case KSHARK_PLUGIN_INIT:
-			handler_count += plugin->init(kshark_ctx);
-			break;
+	switch (task_id) {
+	case KSHARK_PLUGIN_INIT:
+		if (plugin->status & KSHARK_PLUGIN_ENABLED)
+			plugin_init(stream, plugin);
 
-		case KSHARK_PLUGIN_UPDATE:
-			plugin->close(kshark_ctx);
-			handler_count += plugin->init(kshark_ctx);
-			break;
+		break;
 
-		case KSHARK_PLUGIN_CLOSE:
-			handler_count += plugin->close(kshark_ctx);
-			break;
+	case KSHARK_PLUGIN_UPDATE:
+		if (plugin->status & KSHARK_PLUGIN_LOADED)
+			plugin_close(stream, plugin);
 
-		default:
-			return -EINVAL;
-		}
+		plugin->status &= ~KSHARK_PLUGIN_FAILED;
+
+		if (plugin->status & KSHARK_PLUGIN_ENABLED)
+			plugin_init(stream, plugin);
+
+		break;
+
+	case KSHARK_PLUGIN_CLOSE:
+		if (plugin->status & KSHARK_PLUGIN_LOADED)
+			plugin_close(stream, plugin);
+
+		plugin->status &= ~KSHARK_PLUGIN_FAILED;
+		break;
+
+	default:
+		return -EINVAL;
 	}
 
 	return handler_count;
 }
+
+/**
+ * @brief Use this function to initialize/update/deinitialize all registered
+ *	  data processing plugins for a given Data stream.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param task_id: Action identifier specifying the action to be executed. Can
+ *		   be KSHARK_PLUGIN_INIT, KSHARK_PLUGIN_UPDATE or
+ *		   KSHARK_PLUGIN_CLOSE.
+ *
+ * @returns The number of successful added/removed plugin handlers on success,
+ *	    or a negative error code on failure.
+ */
+int kshark_handle_all_dpis(struct kshark_data_stream *stream,
+			   enum kshark_plugin_actions task_id)
+{
+	struct kshark_dpi_list *plugin;
+	int handler_count = 0;
+
+	for (plugin = stream->plugins; plugin; plugin = plugin->next)
+		handler_count +=
+			kshark_handle_dpi(stream, plugin, task_id);
+
+	return handler_count;
+}
+
+/**
+ * @brief Free all readout interfaces in a given list.
+ *
+ * @param inputs: Input location for the inputs list.
+ */
+void kshark_free_dri_list(struct kshark_dri_list *inputs)
+{
+	struct kshark_dri_list *last;
+
+	while (inputs) {
+		last = inputs;
+		inputs = inputs->next;
+
+		free(last);
+	}
+}
diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
index b3cf1c6..7390d74 100644
--- a/src/libkshark-plugin.h
+++ b/src/libkshark-plugin.h
@@ -4,10 +4,10 @@
  * Copyright (C) 2016 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  */
 
- /**
-  *  @file    libkshark-plugin.h
-  *  @brief   KernelShark plugins.
-  */
+/**
+ *  @file    libkshark-plugin.h
+ *  @brief   KernelShark plugins.
+ */
 
 #ifndef _KSHARK_PLUGIN_H
 #define _KSHARK_PLUGIN_H
@@ -16,35 +16,47 @@
 extern "C" {
 #endif // __cplusplus
 
-// trace-cmd
-#include "traceevent/event-parse.h"
+// C
+#include <stdint.h>
+#include <stdbool.h>
 
 /* Quiet warnings over documenting simple structures */
 //! @cond Doxygen_Suppress
 
-#define KSHARK_PLUGIN_INITIALIZER kshark_plugin_initializer
-
-#define KSHARK_PLUGIN_DEINITIALIZER kshark_plugin_deinitializer
-
 #define _MAKE_STR(x)	#x
+
 #define MAKE_STR(x)	_MAKE_STR(x)
 
-#define KSHARK_PLUGIN_INITIALIZER_NAME MAKE_STR(KSHARK_PLUGIN_INITIALIZER)
+#define KSHARK_PLOT_PLUGIN_INITIALIZER kshark_data_plugin_initializer
 
-#define KSHARK_PLUGIN_DEINITIALIZER_NAME MAKE_STR(KSHARK_PLUGIN_DEINITIALIZER)
+#define KSHARK_PLOT_PLUGIN_DEINITIALIZER kshark_data_plugin_deinitializer
 
-struct kshark_context;
+#define KSHARK_PLOT_PLUGIN_INITIALIZER_NAME MAKE_STR(KSHARK_PLOT_PLUGIN_INITIALIZER)
+
+#define KSHARK_PLOT_PLUGIN_DEINITIALIZER_NAME MAKE_STR(KSHARK_PLOT_PLUGIN_DEINITIALIZER)
+
+#define KSHARK_MENU_PLUGIN_INITIALIZER kshark_plugin_menu_initializer
+
+#define KSHARK_MENU_PLUGIN_INITIALIZER_NAME MAKE_STR(KSHARK_MENU_PLUGIN_INITIALIZER)
+
+#define KSHARK_INPUT_INITIALIZER kshark_input_initializer
+
+#define KSHARK_INPUT_DEINITIALIZER kshark_input_deinitializer
+
+#define KSHARK_INPUT_CHECK kshark_input_check
+
+#define KSHARK_INPUT_INITIALIZER_NAME MAKE_STR(KSHARK_INPUT_INITIALIZER)
 
+#define KSHARK_INPUT_DEINITIALIZER_NAME MAKE_STR(KSHARK_INPUT_DEINITIALIZER)
+
+#define KSHARK_INPUT_CHECK_NAME MAKE_STR(KSHARK_INPUT_CHECK)
+
+struct kshark_data_stream;
+struct kshark_context;
 struct kshark_entry;
 
 //! @endcond
 
-/**
- * A function type to be used when defining load/reload/unload plugin
- * functions.
- */
-typedef int (*kshark_plugin_load_func)(struct kshark_context *);
-
 struct kshark_trace_histo;
 
 /**
@@ -57,18 +69,17 @@ struct kshark_cpp_argv {
 };
 
 /** A function type to be used when defining plugin functions for drawing. */
-typedef void
-(*kshark_plugin_draw_handler_func)(struct kshark_cpp_argv *argv,
-				   int val, int draw_action);
+typedef void (*kshark_plugin_draw_handler_func)(struct kshark_cpp_argv *argv,
+						int sd,
+						int val,
+						int draw_action);
 
 /**
  * A function type to be used when defining plugin functions for data
  * manipulation.
  */
-typedef void
-(*kshark_plugin_event_handler_func)(struct kshark_context *kshark_ctx,
-				    struct tep_record *rec,
-				    struct kshark_entry *e);
+typedef void (*kshark_plugin_event_handler_func)(struct kshark_data_stream *stream,
+						 void *rec, struct kshark_entry *e);
 
 /** Plugin action identifier. */
 enum kshark_plugin_actions {
@@ -89,30 +100,15 @@ enum kshark_plugin_actions {
 	 * plugins.
 	 */
 	KSHARK_PLUGIN_CLOSE,
-
-	/**
-	 * Task draw action. This action identifier is used by the plugin draw
-	 * function.
-	 */
-	KSHARK_PLUGIN_TASK_DRAW,
-
-	/**
-	 * CPU draw action. This action identifier is used by the plugin draw
-	 * function.
-	 */
-	KSHARK_PLUGIN_CPU_DRAW,
 };
 
-/**
- * Plugin Event handler structure, defining the properties of the required
- * kshark_entry.
- */
-struct kshark_event_handler {
-	/** Pointer to the next Plugin Event handler. */
-	struct kshark_event_handler		*next;
+/** No event identifier associated with the plugin. */
+#define KS_PLUGIN_NO_EVENT (-ENODEV)
 
-	/** Unique Id ot the trace event type. */
-	int					id;
+/** Plugin's Trace event processing handler structure. */
+struct kshark_event_proc_handler {
+	/** Pointer to the next Plugin Event handler. */
+	struct kshark_event_proc_handler		*next;
 
 	/**
 	 * Event action function. This action can be used to modify the content
@@ -120,6 +116,28 @@ struct kshark_event_handler {
 	 */
 	kshark_plugin_event_handler_func	event_func;
 
+	/** Unique Id ot the trace event type. */
+	int id;
+};
+
+struct kshark_event_proc_handler *
+kshark_find_event_handler(struct kshark_event_proc_handler *handlers, int event_id);
+
+int kshark_register_event_handler(struct kshark_data_stream *stream,
+				  int event_id,
+				  kshark_plugin_event_handler_func evt_func);
+
+void kshark_unregister_event_handler(struct kshark_data_stream *stream,
+				     int event_id,
+				     kshark_plugin_event_handler_func evt_func);
+
+void kshark_free_event_handler_list(struct kshark_event_proc_handler *handlers);
+
+/** Plugin's drawing handler structure. */
+struct kshark_draw_handler {
+	/** Pointer to the next Plugin Event handler. */
+	struct kshark_draw_handler		*next;
+
 	/**
 	 * Draw action function. This action can be used to draw additional
 	 * graphical elements (shapes) for all kshark_entries having Event Ids
@@ -128,31 +146,66 @@ struct kshark_event_handler {
 	kshark_plugin_draw_handler_func		draw_func;
 };
 
-struct kshark_event_handler *
-kshark_find_event_handler(struct kshark_event_handler *handlers, int event_id);
+int kshark_register_draw_handler(struct kshark_data_stream *stream,
+				 kshark_plugin_draw_handler_func draw_func);
 
-int kshark_register_event_handler(struct kshark_event_handler **handlers,
-				  int event_id,
-				  kshark_plugin_event_handler_func evt_func,
-				  kshark_plugin_draw_handler_func dw_func);
+void kshark_unregister_draw_handler(struct kshark_data_stream *stream,
+				    kshark_plugin_draw_handler_func draw_func);
 
-void kshark_unregister_event_handler(struct kshark_event_handler **handlers,
-				     int event_id,
-				     kshark_plugin_event_handler_func evt_func,
-				     kshark_plugin_draw_handler_func dw_func);
+void kshark_free_draw_handler_list(struct kshark_draw_handler *handlers);
 
-void kshark_free_event_handler_list(struct kshark_event_handler *handlers);
+/**
+ * A function type to be used when defining load/reload/unload plugin
+ * functions.
+ */
+typedef int (*kshark_plugin_load_func)(struct kshark_data_stream *);
 
-/** Linked list of plugins. */
-struct kshark_plugin_list {
-	/** Pointer to the next Plugin. */
-	struct kshark_plugin_list	*next;
+/**
+ * A function type to be used when data check function for the plugin.
+ */
+typedef int (*kshark_check_data_func)(const char *filename);
 
-	/** The plugin object file to load. */
-	char				*file;
+/**
+ * A function type to be used when defining plugin's configuration/control
+ * function.
+ */
+typedef void *(*kshark_plugin_ctrl_func)(void *);
+
+
+/** Plugable Data Readout Interface (dpi). */
+struct kshark_dri {
+	/** The a short name for this data input. */
+	char				*name;
+
+	/** Data format identifier. */
+	int				format;
+
+	/** Callback function for initialization of the data input. */
+	kshark_plugin_load_func		init;
+
+	/** Callback function for deinitialization of the data input. */
+	kshark_plugin_load_func		close;
+
+	/**
+	 * Callback function for checking if the data input is applicable for
+	 * a given data file.
+	 */
+	kshark_check_data_func		check_data;
+};
 
-	/** Plugin Event handler. */
-	void				*handle;
+/** Linked list of Data Readout Interfaces (dri). */
+struct kshark_dri_list {
+	/** Pointer to the next input interface. */
+	struct kshark_dri_list		*next;
+
+	/** Pointer to the interface of methods used by the input. */
+	struct kshark_dri		*interface;
+};
+
+/** Plugable Data Processing Interface (dpi). */
+struct kshark_dpi {
+	/** The plugin's short name. */
+	char				*name;
 
 	/** Callback function for initialization of the plugin. */
 	kshark_plugin_load_func		init;
@@ -161,16 +214,102 @@ struct kshark_plugin_list {
 	kshark_plugin_load_func		close;
 };
 
-int kshark_register_plugin(struct kshark_context *kshark_ctx,
-			   const char *file);
+/** Linked list of data processing interfaces (dpi). */
+struct kshark_dpi_list {
+	/** Pointer to the next plugin interface. */
+	struct kshark_dpi_list		*next;
+
+	/** Pointer to the interface of methods used by the plugin. */
+	struct kshark_dpi		*interface;
+
+	/**
+	 * The status of the interface.
+	 */
+	int				status;
+};
+
+struct kshark_dri_list *
+kshark_register_input(struct kshark_context *kshark_ctx,
+		      struct kshark_dri *plugin);
+
+void kshark_unregister_input(struct kshark_context *kshark_ctx,
+			     const char *file);
+
+void kshark_free_dri_list(struct kshark_dri_list *inputs);
+
+/** Linked list of plugins. */
+struct kshark_plugin_list {
+	/** Pointer to the next plugin. */
+	struct kshark_plugin_list	*next;
+
+	/** The plugin's short name. */
+	char	*name;
+
+	/** The plugin object file to load. */
+	char	*file;
+
+	/** Plugin's object file handler. */
+	void	*handle;
+
+	/**
+	 * Control interface of the plugin. Can be used to configure
+	 * the plugin.
+	 */
+	kshark_plugin_ctrl_func		ctrl_interface;
+
+	/** The interface of methods used by a data processing plugin. */
+	struct kshark_dpi		*process_interface;
+
+	/** The interface of methods used by a data readout plugin. */
+	struct kshark_dri		*readout_interface;
+};
+
+/** Plugin status identifiers. */
+enum kshark_plugin_status {
+	/** The plugin is enabled. */
+	KSHARK_PLUGIN_ENABLED	= 1 << 0,
+
+	/** The plugin is successfully loaded. */
+	KSHARK_PLUGIN_LOADED	= 1 << 1,
+
+	/** The plugin failed to initialization. */
+	KSHARK_PLUGIN_FAILED	= 1 << 2,
+};
+
+struct kshark_plugin_list *
+kshark_register_plugin(struct kshark_context *kshark_ctx,
+		       const char *name,
+		       const char *file);
 
 void kshark_unregister_plugin(struct kshark_context *kshark_ctx,
+			      const char *name,
 			      const char *file);
 
 void kshark_free_plugin_list(struct kshark_plugin_list *plugins);
 
-int kshark_handle_plugins(struct kshark_context *kshark_ctx,
-			  enum kshark_plugin_actions  task_id);
+void kshark_free_dpi_list(struct kshark_dpi_list *plugins);
+
+struct kshark_plugin_list *
+kshark_find_plugin(struct kshark_plugin_list *plugins, const char *file);
+
+struct kshark_plugin_list *
+kshark_find_plugin_by_name(struct kshark_plugin_list *plugins,
+			   const char *name);
+
+struct kshark_dpi_list *
+kshark_register_plugin_to_stream(struct kshark_data_stream *stream,
+				 struct kshark_dpi *plugin,
+				 bool active);
+
+void kshark_unregister_plugin_from_stream(struct kshark_data_stream *stream,
+					  struct kshark_dpi *plugin);
+
+int kshark_handle_dpi(struct kshark_data_stream *stream,
+		      struct kshark_dpi_list *plugin,
+		      enum kshark_plugin_actions task_id);
+
+int kshark_handle_all_dpis(struct kshark_data_stream *stream,
+			   enum kshark_plugin_actions  task_id);
 
 #ifdef __cplusplus
 }
diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
new file mode 100644
index 0000000..4af4dfe
--- /dev/null
+++ b/src/libkshark-tepdata.c
@@ -0,0 +1,1754 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    libkshark-tepdata.c
+ *  @brief   API for processing of FTRACE (trace-cmd) data.
+ */
+
+
+// C
+#ifndef _GNU_SOURCE
+/** Use GNU C Library. */
+#define _GNU_SOURCE
+#endif // _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+// trace-cmd
+#include "trace-cmd/trace-cmd.h"
+#include "tracefs/tracefs.h"
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
+#include "libkshark-tepdata.h"
+
+static __thread struct trace_seq seq;
+
+static bool init_thread_seq(void)
+{
+	if (!seq.buffer)
+		trace_seq_init(&seq);
+
+	return seq.buffer != NULL;
+}
+
+/** Structure for handling all unique attributes of the FTRACE data. */
+struct tepdata_handle {
+	/** Page event used to parse the page. */
+	struct tep_handle	*tep; /* MUST BE FIRST ENTRY */
+
+	/** Input handle for the trace data file. */
+	struct tracecmd_input	*input;
+
+	/**
+	 * Filter allowing sophisticated filtering based on the content of
+	 * the event.
+	 */
+	struct tep_event_filter	*advanced_event_filter;
+
+	/** The unique Id of the sched_switch_event event. */
+	int sched_switch_event_id;
+
+	/** Pointer to the sched_switch_next_field format descriptor. */
+	struct tep_format_field	*sched_switch_next_field;
+
+	/** Pointer to the sched_switch_comm_field format descriptor. */
+	struct tep_format_field	*sched_switch_comm_field;
+};
+
+/** Get the Page event object used to parse the page. */
+struct tep_handle *kshark_get_tep(struct kshark_data_stream *stream)
+{
+	if (stream->format != KS_TEP_DATA)
+		return NULL;
+
+	struct tepdata_handle *tep_handle = stream->interface.handle;
+	return tep_handle->tep;
+}
+
+/** Get the input handle for the trace data file */
+struct tracecmd_input *kshark_get_tep_input(struct kshark_data_stream *stream)
+{
+	if (stream->format != KS_TEP_DATA)
+		return NULL;
+
+	struct tepdata_handle *tep_handle = stream->interface.handle;
+	return tep_handle->input;
+}
+
+static inline struct tep_event_filter *
+get_adv_filter(struct kshark_data_stream *stream)
+{
+	if (stream->format != KS_TEP_DATA)
+		return NULL;
+
+	struct tepdata_handle *tep_handle = stream->interface.handle;
+	return tep_handle->advanced_event_filter;
+}
+
+static int get_sched_switch_id(struct kshark_data_stream *stream)
+{
+	if (stream->format != KS_TEP_DATA)
+		return -EINVAL;
+
+	struct tepdata_handle *tep_handle = stream->interface.handle;
+	return tep_handle->sched_switch_event_id;
+}
+
+static struct tep_format_field *get_sched_next(struct kshark_data_stream *stream)
+{
+	if (stream->format != KS_TEP_DATA)
+		return NULL;
+
+	struct tepdata_handle *tep_handle = stream->interface.handle;
+	return tep_handle->sched_switch_next_field;
+}
+
+static struct tep_format_field *get_sched_comm(struct kshark_data_stream *stream)
+{
+	if (stream->format != KS_TEP_DATA)
+		return NULL;
+
+	struct tepdata_handle *tep_handle = stream->interface.handle;
+	return tep_handle->sched_switch_comm_field;
+}
+
+static void set_entry_values(struct kshark_data_stream *stream,
+			     struct tep_record *record,
+			     struct kshark_entry *entry)
+{
+	/* Offset of the record */
+	entry->offset = record->offset;
+
+	/* CPU Id of the record */
+	entry->cpu = record->cpu;
+
+	/* Time stamp of the record */
+	entry->ts = record->ts;
+
+	/* Event Id of the record */
+	entry->event_id = tep_data_type(kshark_get_tep(stream), record);
+
+	/*
+	 * Is visible mask. This default value means that the entry
+	 * is visible everywhere.
+	 */
+	entry->visible = 0xFF;
+
+	/* Process Id of the record */
+	entry->pid = tep_data_pid(kshark_get_tep(stream), record);
+}
+
+/** Prior time offset of the "missed_events" entry. */
+#define ME_ENTRY_TIME_SHIFT	10
+
+static void missed_events_action(struct kshark_data_stream *stream,
+				 struct tep_record *record,
+				 struct kshark_entry *entry)
+{
+	/*
+	 * Use the offset field of the entry to store the number of missed
+	 * events.
+	 */
+	entry->offset = record->missed_events;
+
+	entry->cpu = record->cpu;
+
+	/*
+	 * Position the "missed_events" entry a bit before (in time)
+	 * the original record.
+	 */
+	entry->ts = record->ts - ME_ENTRY_TIME_SHIFT;
+
+	/* All custom entries must have negative event Identifiers. */
+	entry->event_id = KS_EVENT_OVERFLOW;
+
+	entry->visible = 0xFF;
+
+	entry->pid = tep_data_pid(kshark_get_tep(stream), record);
+}
+
+/**
+ * rec_list is used to pass the data to the load functions.
+ * The rec_list will contain the list of entries from the source,
+ * and will be a link list of per CPU entries.
+ */
+struct rec_list {
+	union {
+		/* Used by kshark_load_data_records */
+		struct {
+			/** next pointer, matches entry->next */
+			struct rec_list		*next;
+			/** pointer to the raw record data */
+			struct tep_record	*rec;
+		};
+		/** entry - Used for kshark_load_data_entries() */
+		struct kshark_entry		entry;
+	};
+};
+
+static int get_next_pid(struct kshark_data_stream *stream,
+			struct tep_record *record)
+{
+	unsigned long long val;
+	int ret;
+
+	ret = tep_read_number_field(get_sched_next(stream),
+				    record->data, &val);
+
+	return ret ? : val;
+}
+
+static void register_command(struct kshark_data_stream *stream,
+			     struct tep_record *record,
+			     int pid)
+{
+	struct tep_format_field *comm_field = get_sched_comm(stream);
+	const char *comm = record->data + comm_field->offset;
+	/*
+	 * TODO: The retrieve of the name of the command above needs to be
+	 * implemented as a wrapper function in libtracevent.
+	 */
+
+	if (!tep_is_pid_registered(kshark_get_tep(stream), pid))
+			tep_register_comm(kshark_get_tep(stream), comm, pid);
+}
+
+/**
+ * rec_type defines what type of rec_list is being used.
+ */
+enum rec_type {
+	REC_RECORD,
+	REC_ENTRY,
+};
+
+static void free_rec_list(struct rec_list **rec_list, int n_cpus,
+			  enum rec_type type)
+{
+	struct rec_list *temp_rec;
+	int cpu;
+
+	for (cpu = 0; cpu < n_cpus; ++cpu) {
+		while (rec_list[cpu]) {
+			temp_rec = rec_list[cpu];
+			rec_list[cpu] = temp_rec->next;
+			if (type == REC_RECORD)
+				free_record(temp_rec->rec);
+			free(temp_rec);
+		}
+	}
+	free(rec_list);
+}
+
+static ssize_t get_records(struct kshark_context *kshark_ctx,
+			   struct kshark_data_stream *stream,
+			   struct rec_list ***rec_list,
+			   enum rec_type type)
+{
+	struct tep_event_filter *adv_filter = NULL;
+	struct rec_list **temp_next;
+	struct rec_list **cpu_list;
+	struct rec_list *temp_rec;
+	struct tep_record *rec;
+	ssize_t count, total = 0;
+	int pid, next_pid, cpu;
+
+	cpu_list = calloc(stream->n_cpus, sizeof(*cpu_list));
+	if (!cpu_list)
+		return -ENOMEM;
+
+	if (type == REC_ENTRY)
+		adv_filter = get_adv_filter(stream);
+
+	for (cpu = 0; cpu < stream->n_cpus; ++cpu) {
+		count = 0;
+		cpu_list[cpu] = NULL;
+		temp_next = &cpu_list[cpu];
+
+		rec = tracecmd_read_cpu_first(kshark_get_tep_input(stream), cpu);
+		while (rec) {
+			*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));
+			if (!temp_rec)
+				goto fail;
+
+			temp_rec->next = NULL;
+
+			switch (type) {
+			case REC_RECORD:
+				temp_rec->rec = rec;
+				pid = tep_data_pid(kshark_get_tep(stream), rec);
+				break;
+			case REC_ENTRY: {
+				struct kshark_entry *entry;
+
+				if (rec->missed_events) {
+					/*
+					 * Insert a custom "missed_events" entry just
+					 * befor this record.
+					 */
+					entry = &temp_rec->entry;
+					missed_events_action(stream, rec, entry);
+
+					/* Apply time calibration. */
+					kshark_postprocess_entry(stream, rec, entry);
+
+					entry->stream_id = stream->stream_id;
+
+					temp_next = &temp_rec->next;
+					++count;
+
+					/* Now allocate a new rec_list node and comtinue. */
+					*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));
+				}
+
+				entry = &temp_rec->entry;
+				set_entry_values(stream, rec, entry);
+
+				if(entry->event_id == get_sched_switch_id(stream)) {
+					next_pid = get_next_pid(stream, rec);
+					if (next_pid >= 0)
+						register_command(stream, rec, next_pid);
+				}
+
+				entry->stream_id = stream->stream_id;
+
+				/*
+				 * Post-process the content of the entry. This includes
+				 * time calibration and event-specific plugin actions.
+				 */
+				kshark_postprocess_entry(stream, rec, entry);
+
+				pid = entry->pid;
+
+				/* Apply Id filtering. */
+				kshark_apply_filters(kshark_ctx, stream, entry);
+
+				/* Apply advanced event filtering. */
+				if (adv_filter && adv_filter->filters &&
+				    tep_filter_match(adv_filter, rec) != FILTER_MATCH)
+					unset_event_filter_flag(kshark_ctx, entry);
+
+				free_record(rec);
+				break;
+			} /* REC_ENTRY */
+			}
+
+			kshark_hash_id_add(stream->tasks, pid);
+
+			temp_next = &temp_rec->next;
+
+			++count;
+			rec = tracecmd_read_data(kshark_get_tep_input(stream), cpu);
+		}
+
+		total += count;
+	}
+
+	*rec_list = cpu_list;
+	return total;
+
+ fail:
+	free_rec_list(cpu_list, stream->n_cpus, type);
+	return -ENOMEM;
+}
+
+static int pick_next_cpu(struct rec_list **rec_list, int n_cpus,
+			 enum rec_type type)
+{
+	uint64_t ts = 0;
+	uint64_t rec_ts;
+	int next_cpu = -1;
+	int cpu;
+
+	for (cpu = 0; cpu < n_cpus; ++cpu) {
+		if (!rec_list[cpu])
+			continue;
+
+		switch (type) {
+		case REC_RECORD:
+			rec_ts = rec_list[cpu]->rec->ts;
+			break;
+		case REC_ENTRY:
+			rec_ts = rec_list[cpu]->entry.ts;
+			break;
+		}
+		if (!ts || rec_ts < ts) {
+			ts = rec_ts;
+			next_cpu = cpu;
+		}
+	}
+
+	return next_cpu;
+}
+
+/**
+ * @brief Load the content of the trace data file asociated with a given
+ *	  Data stream into an array of kshark_entries. This function
+ *	  provides an abstraction of the entries from the raw data
+ *	  that is read, however the "latency" and the "info" fields can be
+ *	  accessed only via the offset into the file. This makes the access
+ *	  to these two fields much slower.
+ *	  If one or more filters are set, the "visible" fields of each entry
+ *	  is updated according to the criteria provided by the filters. The
+ *	  field "filter_mask" of the session's context is used to control the
+ *	  level of visibility/invisibility of the filtered entries.
+ *
+ * @param stream: Input location for the FTRACE data stream pointer.
+ * @param kshark_ctx: Input location for context pointer.
+ * @param data_rows: Output location for the trace data. The user is
+ *		     responsible for freeing the elements of the outputted
+ *		     array.
+ *
+ * @returns The size of the outputted data in the case of success, or a
+ *	    negative error code on failure.
+ */
+ssize_t tepdata_load_entries(struct kshark_data_stream *stream,
+				struct kshark_context *kshark_ctx,
+				struct kshark_entry ***data_rows)
+{
+	enum rec_type type = REC_ENTRY;
+	struct kshark_entry **rows;
+	struct rec_list **rec_list;
+	ssize_t count, total = 0;
+
+	total = get_records(kshark_ctx, stream, &rec_list, type);
+	if (total < 0)
+		goto fail;
+
+	rows = calloc(total, sizeof(struct kshark_entry *));
+	if (!rows)
+		goto fail_free;
+
+	for (count = 0; count < total; count++) {
+		int next_cpu;
+
+		next_cpu = pick_next_cpu(rec_list, stream->n_cpus, type);
+
+		if (next_cpu >= 0) {
+			rows[count] = &rec_list[next_cpu]->entry;
+			rec_list[next_cpu] = rec_list[next_cpu]->next;
+		}
+	}
+
+	/* There should be no entries left in rec_list. */
+	free_rec_list(rec_list, stream->n_cpus, type);
+	*data_rows = rows;
+
+	return total;
+
+ fail_free:
+	free_rec_list(rec_list, stream->n_cpus, type);
+
+ fail:
+	fprintf(stderr, "Failed to allocate memory during data loading.\n");
+	return -ENOMEM;
+}
+
+static ssize_t tepdata_load_matrix(struct kshark_data_stream *stream,
+				   struct kshark_context *kshark_ctx,
+				   int16_t **cpu_array,
+				   int32_t **pid_array,
+				   int32_t **event_array,
+				   int64_t **offset_array,
+				   int64_t **ts_array)
+{
+	enum rec_type type = REC_ENTRY;
+	struct rec_list **rec_list;
+	ssize_t count, total = 0;
+	bool status;
+
+	total = get_records(kshark_ctx, stream, &rec_list, type);
+	if (total < 0)
+		goto fail;
+
+	status = kshark_data_matrix_alloc(total, cpu_array,
+						 pid_array,
+						 event_array,
+						 offset_array,
+						 ts_array);
+	if (!status)
+		goto fail_free;
+
+	for (count = 0; count < total; count++) {
+		int next_cpu;
+
+		next_cpu = pick_next_cpu(rec_list, stream->n_cpus, type);
+		if (next_cpu >= 0) {
+			struct rec_list *rec = rec_list[next_cpu];
+			struct kshark_entry *e = &rec->entry;
+
+			if (offset_array)
+				(*offset_array)[count] = e->offset;
+
+			if (cpu_array)
+				(*cpu_array)[count] = e->cpu;
+
+			if (ts_array) {
+				kshark_calib_entry(stream, e);
+				(*ts_array)[count] = e->ts;
+			}
+
+			if (pid_array)
+				(*pid_array)[count] = e->pid;
+
+			if (event_array)
+				(*event_array)[count] = e->event_id;
+
+			rec_list[next_cpu] = rec_list[next_cpu]->next;
+			free(rec);
+		}
+	}
+
+	/* There should be no entries left in rec_list. */
+	free_rec_list(rec_list, stream->n_cpus, type);
+	return total;
+
+ fail_free:
+	free_rec_list(rec_list, stream->n_cpus, type);
+
+ fail:
+	fprintf(stderr, "Failed to allocate memory during data loading.\n");
+	return -ENOMEM;
+}
+
+/**
+ * @brief Load the content of the trace data file into an array of
+ *	  tep_records. Use this function only if you need fast access
+ *	  to all fields of the record.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param sd: Data stream identifier.
+ * @param data_rows: Output location for the trace data. Use free_record()
+ *	 	     to free the elements of the outputted array.
+ *
+ * @returns The size of the outputted data in the case of success, or a
+ *	    negative error code on failure.
+ */
+ssize_t kshark_load_tep_records(struct kshark_context *kshark_ctx, int sd,
+				struct tep_record ***data_rows)
+{
+	struct kshark_data_stream *stream;
+	enum rec_type type = REC_RECORD;
+	struct rec_list **rec_list;
+	struct rec_list *temp_rec;
+	struct tep_record **rows;
+	struct tep_record *rec;
+	ssize_t count, total = 0;
+
+	if (*data_rows)
+		free(*data_rows);
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return -EBADF;
+
+	total = get_records(kshark_ctx, stream, &rec_list, type);
+	if (total < 0)
+		goto fail;
+
+	rows = calloc(total, sizeof(struct tep_record *));
+	if (!rows)
+		goto fail_free;
+
+	for (count = 0; count < total; count++) {
+		int next_cpu;
+
+		next_cpu = pick_next_cpu(rec_list, stream->n_cpus, type);
+
+		if (next_cpu >= 0) {
+			rec = rec_list[next_cpu]->rec;
+			rows[count] = rec;
+
+			temp_rec = rec_list[next_cpu];
+			rec_list[next_cpu] = rec_list[next_cpu]->next;
+			free(temp_rec);
+			/* The record is still referenced in rows */
+		}
+	}
+
+	/* There should be no records left in rec_list */
+	free_rec_list(rec_list, stream->n_cpus, type);
+	*data_rows = rows;
+	return total;
+
+ fail_free:
+	free_rec_list(rec_list, stream->n_cpus, type);
+
+ fail:
+	fprintf(stderr, "Failed to allocate memory during data loading.\n");
+	return -ENOMEM;
+}
+
+static const int tepdata_get_event_id(struct kshark_data_stream *stream,
+				      const struct kshark_entry *entry)
+{
+	int event_id = KS_EMPTY_BIN;
+	struct tep_record *record;
+
+	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
+		event_id = entry->event_id;
+	} else {
+		/*
+		 * The entry has been touched by a plugin callback function.
+		 * Because of this we do not trust the value of
+		 * "entry->event_id".
+		 *
+		 * Currently the data reading operations are not thread-safe.
+		 * Use a mutex to protect the access.
+		 */
+		pthread_mutex_lock(&stream->input_mutex);
+
+		record = tracecmd_read_at(kshark_get_tep_input(stream),
+					  entry->offset, NULL);
+
+		if (record)
+			event_id = tep_data_type(kshark_get_tep(stream), record);
+
+		free_record(record);
+
+		pthread_mutex_unlock(&stream->input_mutex);
+	}
+
+	return (event_id == -1)? -EFAULT : event_id;
+}
+
+static char* missed_events_dump(struct kshark_data_stream *stream,
+				      const struct kshark_entry *entry,
+				      bool get_info)
+{
+	char *buffer;
+	int size = 0;
+
+	if (get_info)
+		size = asprintf(&buffer, "missed_events=%i",
+				(int) entry->offset);
+	else
+		size = asprintf(&buffer, "missed_events");
+
+	if (size > 0)
+		return buffer;
+
+	return NULL;
+}
+
+static char *tepdata_get_event_name(struct kshark_data_stream *stream,
+				    const struct kshark_entry *entry)
+{
+	struct tep_event *event;
+	char *buffer;
+
+	int event_id = stream->interface.get_event_id(stream, entry);
+	if (event_id == -EFAULT)
+		return NULL;
+
+	if (event_id < 0) {
+		switch (event_id) {
+		case KS_EVENT_OVERFLOW:
+			return missed_events_dump(stream, entry, false);
+		default:
+			return NULL;
+		}
+	}
+
+	/*
+	 * Currently the data reading operations are not thread-safe.
+	 * Use a mutex to protect the access.
+	 */
+	pthread_mutex_lock(&stream->input_mutex);
+
+	event = tep_find_event(kshark_get_tep(stream), event_id);
+
+	pthread_mutex_unlock(&stream->input_mutex);
+
+	if (!event ||
+            asprintf(&buffer, "%s/%s", event->system, event->name) <= 0)
+		return NULL;
+
+	return buffer;
+}
+
+static const int tepdata_get_pid(struct kshark_data_stream *stream,
+				 const struct kshark_entry *entry)
+{
+	struct tep_record *record;
+	int pid = KS_EMPTY_BIN;
+
+	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
+		pid = entry->pid;
+	} else {
+		/*
+		 * The entry has been touched by a plugin callback function.
+		 * Because of this we do not trust the value of "entry->pid".
+		 *
+		 * Currently the data reading operations are not thread-safe.
+		 * Use a mutex to protect the access.
+		 */
+		pthread_mutex_lock(&stream->input_mutex);
+
+		record = tracecmd_read_at(kshark_get_tep_input(stream),
+					  entry->offset, NULL);
+
+		if (record)
+			pid = tep_data_pid(kshark_get_tep(stream), record);
+
+		free_record(record);
+
+		pthread_mutex_unlock(&stream->input_mutex);
+	}
+
+	return pid;
+}
+
+static char *tepdata_get_task(struct kshark_data_stream *stream,
+			      const struct kshark_entry *entry)
+{
+	int pid = stream->interface.get_pid(stream, entry);
+	const char *task;
+	char *buffer;
+
+	task = tep_data_comm_from_pid(kshark_get_tep(stream), pid);
+	if (asprintf(&buffer, "%s", task)  <= 0)
+		return NULL;
+
+	return buffer;
+}
+
+static char *tepdata_get_latency(struct kshark_data_stream *stream,
+				 const struct kshark_entry *entry)
+{
+	struct tep_record *record;
+	char *buffer;
+
+	/* Check if this is a "Missed event" (event_id < 0). */
+	if (!init_thread_seq() || entry->event_id < 0)
+		return NULL;
+
+	/*
+	 * Currently the data reading operations are not thread-safe.
+	 * Use a mutex to protect the access.
+	 */
+	pthread_mutex_lock(&stream->input_mutex);
+
+	record = tracecmd_read_at(kshark_get_tep_input(stream), entry->offset, NULL);
+
+	if (!record)
+		return NULL;
+
+	trace_seq_reset(&seq);
+	tep_print_event(kshark_get_tep(stream), &seq, record,
+			"%s", TEP_PRINT_LATENCY);
+
+	free_record(record);
+
+	pthread_mutex_unlock(&stream->input_mutex);
+
+	if (asprintf(&buffer, "%s", seq.buffer)  <= 0)
+		return NULL;
+
+	return buffer;
+}
+
+static char *get_info_str(struct kshark_data_stream *stream,
+			  struct tep_record *record,
+			  struct tep_event *event)
+{
+	char *pos, *buffer;
+
+	if (!init_thread_seq() || !record || !event)
+		return NULL;
+
+	trace_seq_reset(&seq);
+	tep_print_event(kshark_get_tep(stream), &seq, record,
+			"%s", TEP_PRINT_INFO);
+
+	/*
+	 * The event info string contains a trailing newline.
+	 * Remove this newline.
+	 */
+	if ((pos = strchr(seq.buffer, '\n')) != NULL)
+		*pos = '\0';
+
+	if (asprintf(&buffer, "%s", seq.buffer)  <= 0)
+		return NULL;
+
+	return buffer;
+}
+
+static char *tepdata_get_info(struct kshark_data_stream *stream,
+			      const struct kshark_entry *entry)
+{
+	struct tep_record *record;
+	struct tep_event *event;
+	char *info = NULL;
+	int event_id;
+
+	if (entry->event_id < 0) {
+		switch (entry->event_id) {
+		case KS_EVENT_OVERFLOW:
+			return missed_events_dump(stream, entry, true);
+		default:
+			return NULL;
+		}
+	}
+
+	/*
+	 * Currently the data reading operations are not thread-safe.
+	 * Use a mutex to protect the access.
+	 */
+	pthread_mutex_lock(&stream->input_mutex);
+
+	record = tracecmd_read_at(kshark_get_tep_input(stream), entry->offset, NULL);
+	if (!record) {
+		pthread_mutex_unlock(&stream->input_mutex);
+		return NULL;
+	}
+
+	event_id = tep_data_type(kshark_get_tep(stream), record);
+	event = tep_find_event(kshark_get_tep(stream), event_id);
+
+	if (event)
+		info = get_info_str(stream, record, event);
+
+	free_record(record);
+
+	pthread_mutex_unlock(&stream->input_mutex);
+
+	return info;
+}
+
+static int *tepdata_get_event_ids(struct kshark_data_stream *stream)
+{
+	struct tep_event **events;
+	int i, *evt_ids;
+
+	events = tep_list_events(kshark_get_tep(stream), TEP_EVENT_SORT_SYSTEM);
+	evt_ids = malloc(stream->n_events * sizeof(*evt_ids));
+
+	for (i = 0; i < stream->n_events ; ++i)
+		evt_ids[i] = events[i]->id;
+
+	return evt_ids;
+}
+
+static int tepdata_get_field_names(struct kshark_data_stream *stream,
+				   const struct kshark_entry *entry,
+				   char ***fields_str)
+{
+	struct tep_format_field *field, **fields;
+	struct tep_event *event;
+	int i= 0, nr_fields;
+	char **buffer;
+
+	*fields_str = NULL;
+	event = tep_find_event(kshark_get_tep(stream), entry->event_id);
+	if (!event)
+		return 0;
+
+	nr_fields = event->format.nr_fields + event->format.nr_common;
+	buffer = calloc(nr_fields, sizeof(**fields_str));
+
+	fields = tep_event_common_fields(event);
+	for (field = *fields; field; field = field->next)
+		if (asprintf(&buffer[i++], "%s", field->name) <= 0)
+			goto fail;
+
+	free(fields);
+
+	fields = tep_event_fields(event);
+	for (field = *fields; field; field = field->next)
+		if (asprintf(&buffer[i++], "%s", field->name) <= 0)
+			goto fail;
+
+	free(fields);
+
+	*fields_str = buffer;
+	return nr_fields;
+
+ fail:
+	for (i = 0; i < nr_fields; ++i)
+		free(buffer[i]);
+
+	return -EFAULT;
+}
+
+/**
+ * Custom entry info function type. To be user for dumping info for custom
+ * KernelShark entryes.
+ */
+typedef char *(kshark_custom_info_func)(struct kshark_data_stream *,
+					const struct kshark_entry *,
+					bool);
+
+static char* kshark_dump_custom_entry(struct kshark_data_stream *stream,
+				      const struct kshark_entry *entry,
+				      kshark_custom_info_func info_func)
+{
+	char *entry_str;
+	int size = 0;
+
+	size = asprintf(&entry_str, "%" PRIu64 "; %s-%i; CPU %i; ; %s; %s; 0x%x",
+			entry->ts,
+			tep_data_comm_from_pid(kshark_get_tep(stream), entry->pid),
+			entry->pid,
+			entry->cpu,
+			info_func(stream, entry, false),
+			info_func(stream, entry, true),
+			entry->visible);
+
+	if (size > 0)
+		return entry_str;
+
+	return NULL;
+}
+
+/**
+ * @brief Dump into a string the content of one entry. The function allocates
+ *	  a null terminated string and returns a pointer to this string.
+ *
+ * @param stream: Input location for the FTRACE data stream pointer.
+ * @param entry: A Kernel Shark entry to be printed.
+ *
+ * @returns The returned string contains a semicolon-separated list of data
+ *	    fields. The user has to free the returned string.
+ */
+static char *tepdata_dump_entry(struct kshark_data_stream *stream,
+				const struct kshark_entry *entry)
+{
+	char *entry_str, *task, *latency, *event, *info;
+	struct kshark_context *kshark_ctx = NULL;
+	int n = 0;
+
+	if (!kshark_instance(&kshark_ctx) || !init_thread_seq())
+		return NULL;
+
+	if (entry->event_id >= 0) {
+		if (kshark_get_tep(stream)) {
+			task = stream->interface.get_task(stream, entry);
+			latency = stream->interface.get_latency(stream, entry);
+			event = stream->interface.get_event_name(stream, entry);
+			info = stream->interface.get_info(stream, entry);
+
+			n = asprintf(&entry_str,
+				     "%i; %" PRIu64 "; %s-%i; CPU %i; %s; %s; %s; 0x%x",
+				     entry->stream_id,
+				     entry->ts,
+				     task,
+				     stream->interface.get_pid(stream, entry),
+				     entry->cpu,
+				     latency,
+				     event,
+				     info,
+				     entry->visible);
+
+			free(task);
+			free(latency);
+			free(event);
+			free(info);
+		} else {
+			n = asprintf(&entry_str,
+				     "%i; %li; [UNKNOWN TASK]-%i; CPU %i; ; [UNKNOWN EVENT]; [NO INFO]; 0x%x",
+				     entry->stream_id,
+				     entry->ts,
+				     stream->interface.get_pid(stream, entry),
+				     entry->cpu,
+				     entry->visible);
+		}
+
+		if (n < 1)
+			return NULL;
+	} else {
+		switch (entry->event_id) {
+		case KS_EVENT_OVERFLOW:
+			entry_str = kshark_dump_custom_entry(stream, entry,
+							     missed_events_dump);
+		default:
+			return NULL;
+		}
+	}
+
+	return entry_str;
+}
+
+static const int tepdata_find_event_id(struct kshark_data_stream *stream,
+				       const char *event_name)
+{
+	struct tep_event *event;
+	char *buffer, *system, *name;
+
+	if (asprintf(&buffer, "%s", event_name) < 1)
+		return -1;
+
+	system = strtok(buffer, "/");
+	name = strtok(NULL, "");
+	if (!system || !name)
+		return -1;
+
+	event = tep_find_event_by_name(kshark_get_tep(stream), system, name);
+
+	free(buffer);
+
+	if (!event)
+		return -1;
+
+	return event->id;
+}
+
+static struct tep_format_field *
+get_evt_field(struct kshark_data_stream *stream,
+	      int event_id, const char *field_name)
+{
+	struct tep_event *event = tep_find_event(kshark_get_tep(stream),
+						 event_id);
+	if (!event)
+		return NULL;
+
+	return tep_find_any_field(event, field_name);
+}
+
+/**
+ * @brief  Get the type of a trace record field. For the moment only integer
+ *	   fields are supported.
+ *
+ * @param stream: Input location for the FTRACE data stream pointer.
+ * @param entry: Input location for the Kernel Shark entry asociated with thes
+ *		 record.
+ * @param field: The name of the field.
+ *
+ * @returns KS_INTEGER_FIELD in case the field has an integer type. Otherwise
+ *	    KS_INVALIDE_FIELD.
+ */
+kshark_event_field_format
+tepdata_get_field_type(struct kshark_data_stream *stream,
+		       const struct kshark_entry *entry,
+		       const char *field)
+{
+	struct tep_format_field *evt_field;
+	int mask = ~(TEP_FIELD_IS_SIGNED |
+		     TEP_FIELD_IS_LONG |
+		     TEP_FIELD_IS_FLAG);
+
+	evt_field = get_evt_field(stream, entry->event_id, field);
+	if (!evt_field)
+		return KS_INVALIDE_FIELD;
+
+	if (mask & evt_field->flags)
+		return KS_INVALIDE_FIELD;
+
+	return KS_INTEGER_FIELD;
+}
+
+/**
+ * @brief  Get the value of a trace record field.
+ *
+ * @param stream: Input location for the FTRACE data stream pointer.
+ * @param rec: Input location for the trace record.
+ * @param field: The name of the field.
+ * @param val: Output location for the field value.
+ *
+ * @returns Returns 0 on success, otherwise a negative error code..
+ */
+int tepdata_read_record_field(struct kshark_data_stream *stream,
+			      void *rec,
+			      const char *field, int64_t *val)
+{
+	struct tep_format_field *evt_field;
+	struct tep_record *record = rec;
+	int event_id, ret;
+
+	if (!record)
+		return -EFAULT;
+
+	event_id = tep_data_type(kshark_get_tep(stream), record);
+	evt_field = get_evt_field(stream, event_id, field);
+	if (!evt_field)
+		return -EINVAL;
+
+	ret = tep_read_number_field(evt_field, record->data,
+				    (unsigned long long *) val);
+
+	return ret;
+}
+
+/**
+ * @brief  Get the value of a trace record field.
+ *
+ * @param stream: Input location for the FTRACE data stream pointer.
+ * @param entry: Input location for the Kernel Shark entry asociated with thes
+ *		 record.
+ * @param field: The name of the field.
+ * @param val: Output location for the field value.
+ *
+ * @returns Returns 0 on success, otherwise a negative error code.
+ */
+int tepdata_read_event_field(struct kshark_data_stream *stream,
+			     const struct kshark_entry *entry,
+			     const char *field, int64_t *val)
+{
+	struct tep_format_field *evt_field;
+	struct tep_record *record;
+	int ret;
+
+	evt_field = get_evt_field(stream, entry->event_id, field);
+	if (!evt_field)
+		return -EINVAL;
+
+	record = tracecmd_read_at(kshark_get_tep_input(stream),
+				  entry->offset, NULL);
+	if (!record)
+		return -EFAULT;
+
+	ret = tep_read_number_field(evt_field, record->data,
+				    (unsigned long long *) val);
+	free_record(record);
+
+	return ret;
+}
+
+/** Initialize all methods used by a stream of FTRACE data. */
+static void kshark_tep_init_methods(struct kshark_data_stream *stream)
+{
+	stream->interface.get_pid = tepdata_get_pid;
+	stream->interface.get_task = tepdata_get_task;
+	stream->interface.get_event_id = tepdata_get_event_id;
+	stream->interface.get_event_name = tepdata_get_event_name;
+	stream->interface.get_latency = tepdata_get_latency;
+	stream->interface.get_info = tepdata_get_info;
+	stream->interface.find_event_id = tepdata_find_event_id;
+	stream->interface.get_all_event_ids = tepdata_get_event_ids;
+	stream->interface.dump_entry = tepdata_dump_entry;
+	stream->interface.get_all_field_names = tepdata_get_field_names;
+	stream->interface.get_event_field_type = tepdata_get_field_type;
+	stream->interface.read_record_field_int64 = tepdata_read_record_field;
+	stream->interface.read_event_field_int64 = tepdata_read_event_field;
+	stream->interface.load_entries = tepdata_load_entries;
+	stream->interface.load_matrix = tepdata_load_matrix;
+}
+
+/** Find a host stream from the same tracing session, that has guest information */
+static struct tracecmd_input *
+kshark_tep_find_merge_peer(struct kshark_context *kshark_ctx,
+			   struct tracecmd_input *handle)
+{
+	struct tracecmd_input *peer_handle = NULL;
+	struct kshark_data_stream *peer_stream;
+	unsigned long long trace_id;
+	int *stream_ids = NULL;
+	int ret;
+	int i;
+
+	trace_id = tracecmd_get_traceid(handle);
+	if (!trace_id)
+		goto out;
+
+	stream_ids = kshark_all_streams(kshark_ctx);
+	if (!stream_ids)
+		goto out;
+
+	for (i = 0; i < kshark_ctx->n_streams - 1; i++) {
+		peer_stream = kshark_get_data_stream(kshark_ctx, stream_ids[i]);
+		if (!peer_stream || peer_stream->format != KS_TEP_DATA)
+			continue;
+
+		peer_handle = kshark_get_tep_input(peer_stream);
+		if (!peer_handle)
+			continue;
+
+		ret = tracecmd_get_guest_cpumap(peer_handle, trace_id,
+						NULL, NULL, NULL);
+		if (!ret)
+			break;
+	}
+
+	if (i == kshark_ctx->n_streams)
+		peer_handle = NULL;
+
+out:
+	free(stream_ids);
+	return peer_handle;
+}
+
+/** A list of built in default plugins for FTRACE (trace-cmd) data. */
+const char *tep_plugin_names[] = {
+	"sched_events",
+	"missed_events",
+	"kvm_combo",
+};
+
+/** The Process Id of the Idle tasks is zero. */
+#define LINUX_IDLE_TASK_PID	0
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
+static int kshark_tep_stream_init(struct kshark_data_stream *stream,
+				  struct tracecmd_input *input)
+{
+	struct tepdata_handle *tep_handle;
+	struct tep_event *event;
+
+	tep_handle = calloc(1, sizeof(*tep_handle));
+	if (!tep_handle)
+		goto fail;
+
+	tep_handle->input = input;
+	tep_handle->tep = tracecmd_get_pevent(tep_handle->input);
+	if (!tep_handle->tep)
+		goto fail;
+
+	tep_handle->sched_switch_event_id = -EINVAL;
+	event = tep_find_event_by_name(tep_handle->tep,
+				       "sched", "sched_switch");
+	if (event) {
+		tep_handle->sched_switch_event_id = event->id;
+
+		tep_handle->sched_switch_next_field =
+			tep_find_any_field(event, "next_pid");
+
+		tep_handle->sched_switch_comm_field =
+			tep_find_field(event, "next_comm");
+	}
+
+	stream->n_cpus = tep_get_cpus(tep_handle->tep);
+	stream->n_events = tep_get_events_count(tep_handle->tep);
+	stream->idle_pid = LINUX_IDLE_TASK_PID;
+
+	tep_handle->advanced_event_filter =
+		tep_filter_alloc(tep_handle->tep);
+
+	kshark_tep_init_methods(stream);
+
+	stream->interface.handle = tep_handle;
+
+	return 0;
+
+ fail:
+	free(tep_handle);
+	stream->interface.handle = NULL;
+	return -EFAULT;
+}
+
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
+/** Initialize the FTRACE data input (from file). */
+int kshark_tep_init_input(struct kshark_data_stream *stream,
+			  const char *file)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct tracecmd_input *merge_peer;
+	struct tracecmd_input *input;
+
+	if (!kshark_instance(&kshark_ctx) || !init_thread_seq())
+		return -EEXIST;
+
+	/*
+	 * Turn off function trace indent and turn on show parent
+	 * if possible.
+	 */
+	tep_plugin_add_option("ftrace:parent", "1");
+	tep_plugin_add_option("ftrace:indent", "0");
+
+	input = tracecmd_open_head(file);
+	if (!input)
+		return -EEXIST;
+
+	/* Find a merge peer from the same tracing session. */
+	merge_peer = kshark_tep_find_merge_peer(kshark_ctx, input);
+	if (merge_peer)
+		tracecmd_pair_peer(input, merge_peer);
+
+	/* Read the tracing data from the file. */
+	if (tracecmd_init_data(input) < 0)
+		goto fail;
+
+	/* Initialize the stream asociated with the main buffer. */
+	if (kshark_tep_stream_init(stream, input) < 0)
+		goto fail;
+
+	stream->name = strdup("top");
+
+	return 0;
+
+ fail:
+	tracecmd_close(input);
+	return -EFAULT;
+}
+
+/** Initialize using the locally available tracing events. */
+int kshark_tep_init_local(struct kshark_data_stream *stream)
+{
+	struct tepdata_handle *tep_handle;
+
+	tep_handle = calloc(1, sizeof(*tep_handle));
+	if (!tep_handle)
+		return -EFAULT;
+
+	tep_handle->tep = tracefs_local_events(tracefs_get_tracing_dir());
+	if (!tep_handle->tep)
+		goto fail;
+
+	stream->n_events = tep_get_events_count(tep_handle->tep);
+	stream->n_cpus =  tep_get_cpus(tep_handle->tep);
+	stream->format = KS_TEP_DATA;
+	if (asprintf(&stream->file, "Local system") <= 0)
+		goto fail;
+
+	stream->interface.handle = tep_handle;
+	kshark_tep_init_methods(stream);
+
+	return 0;
+
+ fail:
+	free(tep_handle);
+	stream->interface.handle = NULL;
+	return -EFAULT;
+}
+
+/** Method used to close a stream of FTRACE data. */
+void kshark_tep_close_interface(struct kshark_data_stream *stream)
+{
+	struct tepdata_handle *tep_handle = stream->interface.handle;
+
+	if (seq.buffer)
+		trace_seq_destroy(&seq);
+
+	if (tep_handle->advanced_event_filter) {
+		tep_filter_reset(tep_handle->advanced_event_filter);
+		tep_filter_free(tep_handle->advanced_event_filter);
+		tep_handle->advanced_event_filter = NULL;
+	}
+
+	if (tep_handle->input)
+		tracecmd_close(tep_handle->input);
+
+	free(tep_handle);
+	stream->interface.handle = NULL;
+}
+
+/** Check if the filter any filter is set. */
+bool kshark_tep_filter_is_set(struct kshark_data_stream *stream)
+{
+	struct tep_event_filter *adv_filter = get_adv_filter(stream);
+
+	if (adv_filter && adv_filter->filters)
+		return true;
+
+	return false;
+}
+
+/**
+ * @brief Add a filter based on the content of the event.
+ *
+ * @param stream: Input location for the FTRACE data stream pointer.
+ * @param filter_str: The definition of the filter.
+ *
+ * @returns 0 if the filter was successfully added or a negative error code.
+ */
+int kshark_tep_add_filter_str(struct kshark_data_stream *stream,
+			       const char *filter_str)
+{
+	struct tep_event_filter *adv_filter = get_adv_filter(stream);
+	int ret = tep_filter_add_filter_str(adv_filter, filter_str);
+
+	if (ret < 0) {
+		char error_str[200];
+		int error_status =
+			tep_strerror(kshark_get_tep(stream), ret, error_str,
+				     sizeof(error_str));
+
+		if (error_status == 0)
+			fprintf(stderr, "filter failed due to: %s\n",
+					error_str);
+	}
+
+	return ret;
+}
+
+/**
+ * @brief Get a string showing the filter definition.
+ *
+ * @param stream: Input location for the FTRACE data stream pointer.
+ * @param event_id: The unique Id of the event type of the filter.
+ *
+ * @returns A string that displays the filter contents. This string must be
+ *	    freed with free(str). NULL is returned if no filter is found or
+ *	    allocation failed.
+ */
+char *kshark_tep_filter_make_string(struct kshark_data_stream *stream,
+				    int event_id)
+{
+	struct tep_event_filter *adv_filter = get_adv_filter(stream);
+
+	return tep_filter_make_string(adv_filter, event_id);
+}
+
+/**
+ * @brief Remove a filter based on the content of the event.
+ *
+ * @param stream: Input location for the FTRACE data stream pointer.
+ * @param event_id: The unique Id of the event type of the filter.
+ *
+ * @return 1: if an event was removed or 0 if the event was not found.
+ */
+int kshark_tep_filter_remove_event(struct kshark_data_stream *stream,
+				   int event_id)
+{
+	struct tep_event_filter *adv_filter = get_adv_filter(stream);
+
+	return tep_filter_remove_event(adv_filter, event_id);
+}
+
+/** Reset all filters based on the content of the event. */
+void kshark_tep_filter_reset(struct kshark_data_stream *stream)
+{
+	return tep_filter_reset(get_adv_filter(stream));
+}
+
+/** Get an array of available tracer plugins. */
+char **kshark_tracecmd_local_plugins()
+{
+	return tracefs_tracers(tracefs_get_tracing_dir());
+}
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
new file mode 100644
index 0000000..22926fc
--- /dev/null
+++ b/src/libkshark-tepdata.h
@@ -0,0 +1,100 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/**
+ *  @file    libkshark-tepdata.h
+ *  @brief   API for processing of FTRACE (trace-cmd) data.
+ */
+
+#ifndef _KSHARK_TEPDATA_H
+#define _KSHARK_TEPDATA_H
+
+// KernelShark
+#include "libkshark.h"
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+int kshark_tep_init_input(struct kshark_data_stream *stream,
+			  const char *file);
+
+int kshark_tep_init_local(struct kshark_data_stream *stream);
+
+void kshark_tep_close_interface(struct kshark_data_stream *stream);
+
+bool kshark_tep_filter_is_set(struct kshark_data_stream *stream);
+
+int kshark_tep_add_filter_str(struct kshark_data_stream *stream,
+			      const char *filter_str);
+
+char *kshark_tep_filter_make_string(struct kshark_data_stream *stream,
+				    int event_id);
+
+int kshark_tep_filter_remove_event(struct kshark_data_stream *stream,
+				   int event_id);
+
+void kshark_tep_filter_reset(struct kshark_data_stream *stream);
+
+char **kshark_tracecmd_local_plugins();
+
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
+ssize_t kshark_load_tep_records(struct kshark_context *kshark_ctx, int sd,
+				struct tep_record ***data_rows);
+
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
+#ifdef __cplusplus
+}
+#endif
+
+#endif // _KSHARK_TEPDATA_H
diff --git a/src/libkshark.c b/src/libkshark.c
index 92e2450..3a988df 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -1,26 +1,28 @@
 // SPDX-License-Identifier: LGPL-2.1
 
 /*
- * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
  /**
  *  @file    libkshark.c
- *  @brief   API for processing of FTRACE (trace-cmd) data.
+ *  @brief   API for processing of traceing data.
  */
 
+#ifndef _GNU_SOURCE
 /** Use GNU C Library. */
-#define _GNU_SOURCE 1
+#define _GNU_SOURCE
+#endif // _GNU_SOURCE
 
 // C
 #include <stdlib.h>
 #include <stdio.h>
 #include <assert.h>
+#include <string.h>
 
 // KernelShark
 #include "libkshark.h"
-
-static __thread struct trace_seq seq;
+#include "libkshark-tepdata.h"
 
 static struct kshark_context *kshark_context_handler = NULL;
 
@@ -32,18 +34,11 @@ static bool kshark_default_context(struct kshark_context **context)
 	if (!kshark_ctx)
 		return false;
 
-	kshark_ctx->event_handlers = NULL;
-	kshark_ctx->collections = NULL;
-	kshark_ctx->plugins = NULL;
-
-	kshark_ctx->show_task_filter = tracecmd_filter_id_hash_alloc();
-	kshark_ctx->hide_task_filter = tracecmd_filter_id_hash_alloc();
-
-	kshark_ctx->show_event_filter = tracecmd_filter_id_hash_alloc();
-	kshark_ctx->hide_event_filter = tracecmd_filter_id_hash_alloc();
+	kshark_ctx->stream = calloc(KS_MAX_NUM_STREAMS,
+				    sizeof(*kshark_ctx->stream));
 
-	kshark_ctx->show_cpu_filter = tracecmd_filter_id_hash_alloc();
-	kshark_ctx->hide_cpu_filter = tracecmd_filter_id_hash_alloc();
+	kshark_ctx->collections = NULL;
+	kshark_ctx->inputs = NULL;
 
 	kshark_ctx->filter_mask = 0x0;
 
@@ -58,14 +53,6 @@ static bool kshark_default_context(struct kshark_context **context)
 	return true;
 }
 
-static bool init_thread_seq(void)
-{
-	if (!seq.buffer)
-		trace_seq_init(&seq);
-
-	return seq.buffer != NULL;
-}
-
 /**
  * @brief Initialize a kshark session. This function must be called before
  *	  calling any other kshark function. If the session has been
@@ -102,1466 +89,809 @@ bool kshark_instance(struct kshark_context **kshark_ctx)
 		}
 	}
 
-	if (!init_thread_seq())
-		return false;
-
 	return true;
 }
 
-static void kshark_free_task_list(struct kshark_context *kshark_ctx)
-{
-	struct kshark_task_list *task;
-	int i;
-
-	if (!kshark_ctx)
-		return;
-
-	for (i = 0; i < KS_TASK_HASH_SIZE; ++i) {
-		while (kshark_ctx->tasks[i]) {
-			task = kshark_ctx->tasks[i];
-			kshark_ctx->tasks[i] = task->next;
-			free(task);
-		}
-	}
-}
-
 /**
  * @brief Open and prepare for reading a trace data file specified by "file".
- *	  If the specified file does not exist, or contains no trace data,
- *	  the function returns false.
  *
  * @param kshark_ctx: Input location for context pointer.
  * @param file: The file to load.
  *
- * @returns True on success, or false on failure.
+ * @returns The Id number of the data stream associated with this file on success.
+ * 	    Otherwise a negative errno code.
  */
-bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
+int kshark_open(struct kshark_context *kshark_ctx, const char *file)
 {
-	struct tracecmd_input *handle;
-
-	kshark_free_task_list(kshark_ctx);
-
-	handle = tracecmd_open(file);
-	if (!handle)
-		return false;
+	int sd, rt;
 
-	if (pthread_mutex_init(&kshark_ctx->input_mutex, NULL) != 0) {
-		tracecmd_close(handle);
-		return false;
-	}
+	sd = kshark_add_stream(kshark_ctx);
+	if (sd < 0)
+		return sd;
 
-	kshark_ctx->handle = handle;
-	kshark_ctx->pevent = tracecmd_get_pevent(handle);
+	rt = kshark_stream_open(kshark_ctx->stream[sd], file);
+	if (rt < 0)
+		return rt;
 
-	kshark_ctx->advanced_event_filter =
-		tep_filter_alloc(kshark_ctx->pevent);
-
-	/*
-	 * Turn off function trace indent and turn on show parent
-	 * if possible.
-	 */
-	tep_plugin_add_option("ftrace:parent", "1");
-	tep_plugin_add_option("ftrace:indent", "0");
-
-	return true;
+	return sd;
 }
 
-/**
- * @brief Close the trace data file and free the trace data handle.
- *
- * @param kshark_ctx: Input location for the session context pointer.
- */
-void kshark_close(struct kshark_context *kshark_ctx)
+static void kshark_stream_free(struct kshark_data_stream *stream)
 {
-	if (!kshark_ctx || !kshark_ctx->handle)
+	if (!stream)
 		return;
 
-	/*
-	 * All filters are file specific. Make sure that the Pids and Event Ids
-	 * from this file are not going to be used with another file.
-	 */
-	tracecmd_filter_id_clear(kshark_ctx->show_task_filter);
-	tracecmd_filter_id_clear(kshark_ctx->hide_task_filter);
-	tracecmd_filter_id_clear(kshark_ctx->show_event_filter);
-	tracecmd_filter_id_clear(kshark_ctx->hide_event_filter);
-	tracecmd_filter_id_clear(kshark_ctx->show_cpu_filter);
-	tracecmd_filter_id_clear(kshark_ctx->hide_cpu_filter);
-
-	if (kshark_ctx->advanced_event_filter) {
-		tep_filter_reset(kshark_ctx->advanced_event_filter);
-		tep_filter_free(kshark_ctx->advanced_event_filter);
-		kshark_ctx->advanced_event_filter = NULL;
-	}
+	kshark_hash_id_free(stream->show_task_filter);
+	kshark_hash_id_free(stream->hide_task_filter);
 
-	/*
-	 * All data collections are file specific. Make sure that collections
-	 * from this file are not going to be used with another file.
-	 */
-	kshark_free_collection_list(kshark_ctx->collections);
-	kshark_ctx->collections = NULL;
+	kshark_hash_id_free(stream->show_event_filter);
+	kshark_hash_id_free(stream->hide_event_filter);
+
+	kshark_hash_id_free(stream->show_cpu_filter);
+	kshark_hash_id_free(stream->hide_cpu_filter);
 
-	tracecmd_close(kshark_ctx->handle);
-	kshark_ctx->handle = NULL;
-	kshark_ctx->pevent = NULL;
+	kshark_hash_id_free(stream->tasks);
 
-	pthread_mutex_destroy(&kshark_ctx->input_mutex);
+	free(stream->calib_array);
+	free(stream->file);
+	free(stream->name);
+	free(stream);
 }
 
-/**
- * @brief Deinitialize kshark session. Should be called after closing all
- *	  open trace data files and before your application terminates.
- *
- * @param kshark_ctx: Optional input location for session context pointer.
- *		      If it points to a context of a sessuin, that sessuin
- *		      will be deinitialize. If it points to NULL, it will
- *		      deinitialize the current session.
- */
-void kshark_free(struct kshark_context *kshark_ctx)
+static struct kshark_data_stream *kshark_stream_alloc()
 {
-	if (kshark_ctx == NULL) {
-		if (kshark_context_handler == NULL)
-			return;
-
-		kshark_ctx = kshark_context_handler;
-		/* kshark_ctx_handler will be set to NULL below. */
-	}
+	struct kshark_data_stream *stream;
 
-	tracecmd_filter_id_hash_free(kshark_ctx->show_task_filter);
-	tracecmd_filter_id_hash_free(kshark_ctx->hide_task_filter);
-
-	tracecmd_filter_id_hash_free(kshark_ctx->show_event_filter);
-	tracecmd_filter_id_hash_free(kshark_ctx->hide_event_filter);
-
-	tracecmd_filter_id_hash_free(kshark_ctx->show_cpu_filter);
-	tracecmd_filter_id_hash_free(kshark_ctx->hide_cpu_filter);
-
-	if (kshark_ctx->plugins) {
-		kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_CLOSE);
-		kshark_free_plugin_list(kshark_ctx->plugins);
-		kshark_free_event_handler_list(kshark_ctx->event_handlers);
-	}
+	stream = calloc(1, sizeof(*stream));
+	if (!stream)
+		goto fail;
 
-	kshark_free_task_list(kshark_ctx);
+	stream->event_handlers = NULL;
+	stream->plugins = NULL;
 
-	if (seq.buffer)
-		trace_seq_destroy(&seq);
+	stream->show_task_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
+	stream->hide_task_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
 
-	if (kshark_ctx == kshark_context_handler)
-		kshark_context_handler = NULL;
+	stream->show_event_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
+	stream->hide_event_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
 
-	free(kshark_ctx);
-}
+	stream->show_cpu_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
+	stream->hide_cpu_filter = kshark_hash_id_alloc(KS_FILTER_HASH_NBITS);
 
-static struct kshark_task_list *
-kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
-{
-	struct kshark_task_list *list;
+	stream->tasks = kshark_hash_id_alloc(KS_TASK_HASH_NBITS);
 
-	for (list = kshark_ctx->tasks[key]; list; list = list->next) {
-		if (list->pid == pid)
-			return list;
+	if (!stream->show_task_filter ||
+	    !stream->hide_task_filter ||
+	    !stream->show_event_filter ||
+	    !stream->hide_event_filter ||
+	    !stream->tasks) {
+		    goto fail;
 	}
 
-	return NULL;
-}
-
-static struct kshark_task_list *
-kshark_add_task(struct kshark_context *kshark_ctx, int pid)
-{
-	struct kshark_task_list *list;
-	uint32_t key;
+	stream->format = KS_INVALIDE_DATA;
 
-	key = tracecmd_quick_hash(pid, KS_TASK_HASH_SHIFT);
-
-	list = kshark_find_task(kshark_ctx, key, pid);
-	if (list)
-		return list;
-
-	list = malloc(sizeof(*list));
-	if (!list)
-		return NULL;
+	return stream;
 
-	list->pid = pid;
-	list->next = kshark_ctx->tasks[key];
-	kshark_ctx->tasks[key] = list;
+ fail:
+	fprintf(stderr, "Failed to allocate memory for data stream.\n");
+	if (stream)
+		kshark_stream_free(stream);
 
-	return list;
+	return NULL;
 }
 
 /**
- * @brief Get an array containing the Process Ids of all tasks presented in
- *	  the loaded trace data file.
+ * @brief Add new Trace data stream.
  *
  * @param kshark_ctx: Input location for context pointer.
- * @param pids: Output location for the Pids of the tasks. The user is
- *		responsible for freeing the elements of the outputted array.
  *
- * @returns The size of the outputted array of Pids in the case of success,
- *	    or a negative error code on failure.
+ * @returns Zero on success or a negative error code in the case of an errno.
  */
-ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids)
+int kshark_add_stream(struct kshark_context *kshark_ctx)
 {
-	size_t i, pid_count = 0, pid_size = KS_TASK_HASH_SIZE;
-	struct kshark_task_list *list;
-	int *temp_pids;
-
-	*pids = calloc(pid_size, sizeof(int));
-	if (!*pids)
-		goto fail;
+	struct kshark_data_stream *stream;
 
-	for (i = 0; i < KS_TASK_HASH_SIZE; ++i) {
-		list = kshark_ctx->tasks[i];
-		while (list) {
-			(*pids)[pid_count] = list->pid;
-			list = list->next;
-			if (++pid_count >= pid_size) {
-				pid_size *= 2;
-				temp_pids = realloc(*pids, pid_size * sizeof(int));
-				if (!temp_pids) {
-					goto fail;
-				}
-				*pids = temp_pids;
-			}
-		}
-	}
+	if (kshark_ctx->n_streams == KS_MAX_NUM_STREAMS)
+		return -EMFILE;
 
-	if (pid_count) {
-		temp_pids = realloc(*pids, pid_count * sizeof(int));
-		if (!temp_pids)
-			goto fail;
+	stream = kshark_stream_alloc();
+	stream->stream_id = kshark_ctx->n_streams;
 
-		/* Paranoid: In the unlikely case of shrinking *pids, realloc moves it */
-		*pids = temp_pids;
-	} else {
-		free(*pids);
-		*pids = NULL;
+	if (pthread_mutex_init(&stream->input_mutex, NULL) != 0) {
+		free(stream);
+		return -EAGAIN;
 	}
 
-	return pid_count;
-
-fail:
-	fprintf(stderr, "Failed to allocate memory for Task Pids.\n");
-	free(*pids);
-	*pids = NULL;
-	return -ENOMEM;
-}
-
-static bool filter_find(struct tracecmd_filter_id *filter, int pid,
-			bool test)
-{
-	return !filter || !filter->count ||
-		!!(unsigned long)tracecmd_filter_id_find(filter, pid) == test;
-}
+	kshark_ctx->stream[kshark_ctx->n_streams++] = stream;
 
-static bool kshark_show_task(struct kshark_context *kshark_ctx, int pid)
-{
-	return filter_find(kshark_ctx->show_task_filter, pid, true) &&
-	       filter_find(kshark_ctx->hide_task_filter, pid, false);
+	return stream->stream_id;
 }
 
-static bool kshark_show_event(struct kshark_context *kshark_ctx, int pid)
+static bool is_tep(const char *filename)
 {
-	return filter_find(kshark_ctx->show_event_filter, pid, true) &&
-	       filter_find(kshark_ctx->hide_event_filter, pid, false);
+	char *ext = strrchr(filename, '.');
+	return ext && strcmp(ext, ".dat") == 0;
 }
 
-static bool kshark_show_cpu(struct kshark_context *kshark_ctx, int cpu)
+static void set_format(struct kshark_context *kshark_ctx,
+		       struct kshark_data_stream *stream,
+		       const char *filename)
 {
-	return filter_find(kshark_ctx->show_cpu_filter, cpu, true) &&
-	       filter_find(kshark_ctx->hide_cpu_filter, cpu, false);
-}
+	struct kshark_dri_list *input;
 
-/**
- * @brief Add an Id value to the filster specified by "filter_id".
- *
- * @param kshark_ctx: Input location for the session context pointer.
- * @param filter_id: Identifier of the filter.
- * @param id: Id value to be added to the filter.
- */
-void kshark_filter_add_id(struct kshark_context *kshark_ctx,
-			  int filter_id, int id)
-{
-	struct tracecmd_filter_id *filter;
+	stream->format = KS_INVALIDE_DATA;
 
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
+	if (is_tep(filename)) {
+		stream->format = KS_TEP_DATA;
+		return;
 	}
 
-	tracecmd_filter_id_add(filter, id);
-}
-
-/**
- * @brief Clear (reset) the filster specified by "filter_id".
- *
- * @param kshark_ctx: Input location for the session context pointer.
- * @param filter_id: Identifier of the filter.
- */
-void kshark_filter_clear(struct kshark_context *kshark_ctx, int filter_id)
-{
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
+	for (input = kshark_ctx->inputs; input; input = input->next) {
+		stream->format = input->interface->check_data(filename);
+		if (stream->format != KS_INVALIDE_DATA) {
+			input->interface->format = stream->format;
 			return;
+		}
 	}
-
-	tracecmd_filter_id_clear(filter);
 }
 
 /**
- * @brief Check if a given Id filter is set.
+ * @brief Use an existing Trace data stream to open and prepare for reading
+ *	  a trace data file specified by "file".
  *
- * @param filter: Input location for the Id filster.
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param file: The file to load.
  *
- * @returns True if the Id filter is set, otherwise False.
+ * @returns Zero on success or a negative error code in the case of an errno.
  */
-bool kshark_this_filter_is_set(struct tracecmd_filter_id *filter)
+int kshark_stream_open(struct kshark_data_stream *stream, const char *file)
 {
-	return filter && filter->count;
-}
+	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_dri_list *input;
 
-/**
- * @brief Check if an Id filter is set.
- *
- * @param kshark_ctx: Input location for the session context pointer.
- *
- * @returns True if at least one Id filter is set, otherwise False.
- */
-bool kshark_filter_is_set(struct kshark_context *kshark_ctx)
-{
-	return kshark_this_filter_is_set(kshark_ctx->show_task_filter) ||
--              kshark_this_filter_is_set(kshark_ctx->hide_task_filter) ||
--              kshark_this_filter_is_set(kshark_ctx->show_cpu_filter) ||
--              kshark_this_filter_is_set(kshark_ctx->hide_cpu_filter) ||
--              kshark_this_filter_is_set(kshark_ctx->show_event_filter) ||
--              kshark_this_filter_is_set(kshark_ctx->hide_event_filter);
-}
+	if (!stream || !kshark_instance(&kshark_ctx))
+		return -EFAULT;
 
-static inline void unset_event_filter_flag(struct kshark_context *kshark_ctx,
-					   struct kshark_entry *e)
-{
-	/*
-	 * All entries, filtered-out by the event filters, will be treated
-	 * differently, when visualized. Because of this, ignore the value
-	 * of the GRAPH_VIEW flag provided by the user via
-	 * kshark_ctx->filter_mask. The value of the EVENT_VIEW flag in
-	 * kshark_ctx->filter_mask will be used instead.
-	 */
-	int event_mask = kshark_ctx->filter_mask & ~KS_GRAPH_VIEW_FILTER_MASK;
+	stream->file = strdup(file);
+	set_format(kshark_ctx, stream, file);
 
-	e->visible &= ~event_mask;
-}
+	switch (stream->format) {
+	case KS_TEP_DATA:
+		return kshark_tep_init_input(stream, file);
 
-static void set_all_visible(uint8_t *v) {
-	/*  Keep the original value of the PLUGIN_UNTOUCHED bit flag. */
-	*v |= 0xFF & ~KS_PLUGIN_UNTOUCHED_MASK;
+	default:
+		for (input = kshark_ctx->inputs; input; input = input->next) {
+			if (stream->format == input->interface->format)
+				return input->interface->init(stream);
+		}
+
+		return -ENODATA;
+	}
 }
 
 /**
- * @brief This function loops over the array of entries specified by "data"
- *	  and "n_entries" and sets the "visible" fields of each entry
- *	  according to the criteria provided by the filters of the session's
- *	  context. The field "filter_mask" of the session's context is used to
- *	  control the level of visibility/invisibility of the entries which
- *	  are filtered-out.
- *	  WARNING: Do not use this function if the advanced filter is set.
- *	  Applying the advanced filter requires access to prevent_record,
- *	  hence the data has to be reloaded using kshark_load_data_entries().
+ * @brief Get an array containing the Ids of all opened Trace data streams.
+ * 	  The User is responsible for freeing the array.
  *
- * @param kshark_ctx: Input location for the session context pointer.
- * @param data: Input location for the trace data to be filtered.
- * @param n_entries: The size of the inputted data.
+ * @param kshark_ctx: Input location for context pointer.
  */
-void kshark_filter_entries(struct kshark_context *kshark_ctx,
-			   struct kshark_entry **data,
-			   size_t n_entries)
+int *kshark_all_streams(struct kshark_context *kshark_ctx)
 {
-	int i;
+	int *ids, i, count = 0;
 
-	if (kshark_ctx->advanced_event_filter->filters) {
-		/* The advanced filter is set. */
-		fprintf(stderr,
-			"Failed to filter!\n");
+	ids = malloc(kshark_ctx->n_streams * (sizeof(*ids)));
+	if (!ids) {
 		fprintf(stderr,
-			"Reset the Advanced filter or reload the data.\n");
-		return;
+			"Failed to allocate memory for stream array.\n");
+		return NULL;
 	}
 
-	if (!kshark_filter_is_set(kshark_ctx))
-		return;
+	for (i = 0; i < KS_MAX_NUM_STREAMS; ++i)
+		if (kshark_ctx->stream[i])
+			ids[count++] = i;
 
-	/* Apply only the Id filters. */
-	for (i = 0; i < n_entries; ++i) {
-		/* Start with and entry which is visible everywhere. */
-		set_all_visible(&data[i]->visible);
+	return ids;
+}
 
-		/* Apply event filtering. */
-		if (!kshark_show_event(kshark_ctx, data[i]->event_id))
-			unset_event_filter_flag(kshark_ctx, data[i]);
+static void kshark_stream_close(struct kshark_data_stream *stream)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_dri_list *input;
 
-		/* Apply CPU filtering. */
-		if (!kshark_show_cpu(kshark_ctx, data[i]->cpu))
-			data[i]->visible &= ~kshark_ctx->filter_mask;
+	if (!stream || !kshark_instance(&kshark_ctx))
+		return;
 
-		/* Apply task filtering. */
-		if (!kshark_show_task(kshark_ctx, data[i]->pid))
-			data[i]->visible &= ~kshark_ctx->filter_mask;
+	/*
+	 * All filters are file specific. Make sure that all Process Ids and
+	 * Event Ids from this file are not going to be used with another file.
+	 */
+	kshark_hash_id_clear(stream->show_task_filter);
+	kshark_hash_id_clear(stream->hide_task_filter);
+	kshark_hash_id_clear(stream->show_event_filter);
+	kshark_hash_id_clear(stream->hide_event_filter);
+	kshark_hash_id_clear(stream->show_cpu_filter);
+	kshark_hash_id_clear(stream->hide_cpu_filter);
+
+	switch (stream->format) {
+	case KS_TEP_DATA:
+		kshark_tep_close_interface(stream);
+		break;
+
+	default:
+		for (input = kshark_ctx->inputs; input; input = input->next) {
+			if (stream->format == input->interface->format)
+				input->interface->close(stream);
+		}
+
+		break;
 	}
+
+	pthread_mutex_destroy(&stream->input_mutex);
 }
 
 /**
- * @brief This function loops over the array of entries specified by "data"
- *	  and "n_entries" and resets the "visible" fields of each entry to
- *	  the default value of "0xFF" (visible everywhere).
+ * @brief Close the trace data file and free the trace data handle.
  *
  * @param kshark_ctx: Input location for the session context pointer.
- * @param data: Input location for the trace data to be unfiltered.
- * @param n_entries: The size of the inputted data.
+ * @param sd: Data stream identifier.
  */
-void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
-			      struct kshark_entry **data,
-			      size_t n_entries)
-{
-	int i;
-	for (i = 0; i < n_entries; ++i)
-		set_all_visible(&data[i]->visible);
-}
-
-static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
-				    struct tep_record *record,
-				    struct kshark_entry *entry)
+void kshark_close(struct kshark_context *kshark_ctx, int sd)
 {
-	/* Offset of the record */
-	entry->offset = record->offset;
-
-	/* CPU Id of the record */
-	entry->cpu = record->cpu;
-
-	/* Time stamp of the record */
-	entry->ts = record->ts;
+	struct kshark_data_stream *stream;
 
-	/* Event Id of the record */
-	entry->event_id = tep_data_type(kshark_ctx->pevent, record);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return;
 
 	/*
-	 * Is visible mask. This default value means that the entry
-	 * is visible everywhere.
+	 * All data collections are file specific. Make sure that collections
+	 * from this file are not going to be used with another file.
 	 */
-	entry->visible = 0xFF;
+	kshark_unregister_stream_collections(&kshark_ctx->collections, sd);
 
-	/* Process Id of the record */
-	entry->pid = tep_data_pid(kshark_ctx->pevent, record);
-}
+	/* Close all active plugins for this stream. */
+	if (stream->plugins) {
+		kshark_handle_all_dpis(stream, KSHARK_PLUGIN_CLOSE);
+		kshark_free_event_handler_list(stream->event_handlers);
+		kshark_free_dpi_list(stream->plugins);
+	}
 
-/** Prior time offset of the "missed_events" entry. */
-#define ME_ENTRY_TIME_SHIFT	10
+	kshark_stream_close(stream);
+	kshark_stream_free(stream);
+	kshark_ctx->stream[sd] = NULL;
+	kshark_ctx->n_streams--;
+}
 
-static void missed_events_action(struct kshark_context *kshark_ctx,
-				 struct tep_record *record,
-				 struct kshark_entry *entry)
+/**
+ * @brief Close all currently open trace data file and free the trace data handle.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ */
+void kshark_close_all(struct kshark_context *kshark_ctx)
 {
-	/*
-	 * Use the offset field of the entry to store the number of missed
-	 * events.
-	 */
-	entry->offset = record->missed_events;
+	int i, *stream_ids, n_streams;
 
-	entry->cpu = record->cpu;
+	stream_ids = kshark_all_streams(kshark_ctx);
 
 	/*
-	 * Position the "missed_events" entry a bit before (in time)
-	 * the original record.
+	 * Get a copy of shark_ctx->n_streams befor you start closing. Be aware
+	 * that kshark_close() will decrement shark_ctx->n_streams.
 	 */
-	entry->ts = record->ts - ME_ENTRY_TIME_SHIFT;
-
-	/* All custom entries must have negative event Identifiers. */
-	entry->event_id = KS_EVENT_OVERFLOW;
+	n_streams = kshark_ctx->n_streams;
+	for (i = 0; i < n_streams; ++i)
+		kshark_close(kshark_ctx, stream_ids[i]);
 
-	entry->visible = 0xFF;
-
-	entry->pid = tep_data_pid(kshark_ctx->pevent, record);
+	free(stream_ids);
 }
 
-static const char* missed_events_dump(struct kshark_context *kshark_ctx,
-				      const struct kshark_entry *entry,
-				      bool get_info)
-{
-	int size = 0;
-	static char *buffer;
-
-	if (get_info)
-		size = asprintf(&buffer, "missed_events=%i", (int) entry->offset);
-	else
-		size = asprintf(&buffer, "missed_events");
-	if (size > 0)
-		return buffer;
-
-	return NULL;
-}
-
-/**
- * rec_list is used to pass the data to the load functions.
- * The rec_list will contain the list of entries from the source,
- * and will be a link list of per CPU entries.
- */
-struct rec_list {
-	union {
-		/* Used by kshark_load_data_records */
-		struct {
-			/** next pointer, matches entry->next */
-			struct rec_list		*next;
-			/** pointer to the raw record data */
-			struct tep_record	*rec;
-		};
-		/** entry - Used for kshark_load_data_entries() */
-		struct kshark_entry		entry;
-	};
-};
-
 /**
- * rec_type defines what type of rec_list is being used.
+ * @brief Deinitialize kshark session. Should be called after closing all
+ *	  open trace data files and before your application terminates.
+ *
+ * @param kshark_ctx: Optional input location for session context pointer.
+ *		      If it points to a context of a session, that session
+ *		      will be deinitialize. If it points to NULL, it will
+ *		      deinitialize the current session.
  */
-enum rec_type {
-	REC_RECORD,
-	REC_ENTRY,
-};
-
-static void free_rec_list(struct rec_list **rec_list, int n_cpus,
-			  enum rec_type type)
-{
-	struct rec_list *temp_rec;
-	int cpu;
-
-	for (cpu = 0; cpu < n_cpus; ++cpu) {
-		while (rec_list[cpu]) {
-			temp_rec = rec_list[cpu];
-			rec_list[cpu] = temp_rec->next;
-			if (type == REC_RECORD)
-				free_record(temp_rec->rec);
-			free(temp_rec);
-		}
-	}
-	free(rec_list);
-}
-
-static ssize_t get_records(struct kshark_context *kshark_ctx,
-			   struct rec_list ***rec_list, enum rec_type type)
+void kshark_free(struct kshark_context *kshark_ctx)
 {
-	struct kshark_event_handler *evt_handler;
-	struct tep_event_filter *adv_filter;
-	struct kshark_task_list *task;
-	struct tep_record *rec;
-	struct rec_list **temp_next;
-	struct rec_list **cpu_list;
-	struct rec_list *temp_rec;
-	size_t count, total = 0;
-	int n_cpus;
-	int pid;
-	int cpu;
-
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
-	cpu_list = calloc(n_cpus, sizeof(*cpu_list));
-	if (!cpu_list)
-		return -ENOMEM;
-
-	/* Just to shorten the name */
-	if (type == REC_ENTRY)
-		adv_filter = kshark_ctx->advanced_event_filter;
-
-	for (cpu = 0; cpu < n_cpus; ++cpu) {
-		count = 0;
-		cpu_list[cpu] = NULL;
-		temp_next = &cpu_list[cpu];
-
-		rec = tracecmd_read_cpu_first(kshark_ctx->handle, cpu);
-		while (rec) {
-			*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));
-			if (!temp_rec)
-				goto fail;
-
-			temp_rec->next = NULL;
-
-			switch (type) {
-			case REC_RECORD:
-				temp_rec->rec = rec;
-				pid = tep_data_pid(kshark_ctx->pevent, rec);
-				break;
-			case REC_ENTRY: {
-				struct kshark_entry *entry;
-				int ret;
-
-				if (rec->missed_events) {
-					/*
-					 * Insert a custom "missed_events" entry just
-					 * befor this record.
-					 */
-					entry = &temp_rec->entry;
-					missed_events_action(kshark_ctx, rec, entry);
-
-					temp_next = &temp_rec->next;
-					++count;
-
-					/* Now allocate a new rec_list node and comtinue. */
-					*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));
-				}
-
-				entry = &temp_rec->entry;
-				kshark_set_entry_values(kshark_ctx, rec, entry);
-
-				/* Execute all plugin-provided actions (if any). */
-				evt_handler = kshark_ctx->event_handlers;
-				while ((evt_handler = kshark_find_event_handler(evt_handler,
-										entry->event_id))) {
-					evt_handler->event_func(kshark_ctx, rec, entry);
-					evt_handler = evt_handler->next;
-					entry->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
-				}
-
-				pid = entry->pid;
-				/* Apply event filtering. */
-				ret = FILTER_MATCH;
-				if (adv_filter->filters)
-					ret = tep_filter_match(adv_filter, rec);
-
-				if (!kshark_show_event(kshark_ctx, entry->event_id) ||
-				    ret != FILTER_MATCH) {
-					unset_event_filter_flag(kshark_ctx, entry);
-				}
-
-				/* Apply CPU filtering. */
-				if (!kshark_show_cpu(kshark_ctx, entry->pid)) {
-					entry->visible &= ~kshark_ctx->filter_mask;
-				}
-
-				/* Apply task filtering. */
-				if (!kshark_show_task(kshark_ctx, entry->pid)) {
-					entry->visible &= ~kshark_ctx->filter_mask;
-				}
-				free_record(rec);
-				break;
-			} /* REC_ENTRY */
-			}
+	if (kshark_ctx == NULL) {
+		if (kshark_context_handler == NULL)
+			return;
 
-			task = kshark_add_task(kshark_ctx, pid);
-			if (!task) {
-				free_record(rec);
-				goto fail;
-			}
+		kshark_ctx = kshark_context_handler;
+		/* kshark_ctx_handler will be set to NULL below. */
+	}
 
-			temp_next = &temp_rec->next;
+	kshark_close_all(kshark_ctx);
 
-			++count;
-			rec = tracecmd_read_data(kshark_ctx->handle, cpu);
-		}
+	free(kshark_ctx->stream);
 
-		total += count;
-	}
+	if (kshark_ctx->plugins)
+		kshark_free_plugin_list(kshark_ctx->plugins);
 
-	*rec_list = cpu_list;
-	return total;
+	kshark_free_dri_list(kshark_ctx->inputs);
 
- fail:
-	free_rec_list(cpu_list, n_cpus, type);
-	return -ENOMEM;
-}
-
-static int pick_next_cpu(struct rec_list **rec_list, int n_cpus,
-			 enum rec_type type)
-{
-	uint64_t ts = 0;
-	uint64_t rec_ts;
-	int next_cpu = -1;
-	int cpu;
-
-	for (cpu = 0; cpu < n_cpus; ++cpu) {
-		if (!rec_list[cpu])
-			continue;
-
-		switch (type) {
-		case REC_RECORD:
-			rec_ts = rec_list[cpu]->rec->ts;
-			break;
-		case REC_ENTRY:
-			rec_ts = rec_list[cpu]->entry.ts;
-			break;
-		}
-		if (!ts || rec_ts < ts) {
-			ts = rec_ts;
-			next_cpu = cpu;
-		}
-	}
+	if (kshark_ctx == kshark_context_handler)
+		kshark_context_handler = NULL;
 
-	return next_cpu;
+	free(kshark_ctx);
 }
 
 /**
- * @brief Load the content of the trace data file into an array of
- *	  kshark_entries. This function provides an abstraction of the
- *	  entries from the raw data that is read, however the "latency"
- *	  and the "info" fields can be accessed only via the offset
- *	  into the file. This makes the access to these two fields much
- *	  slower.
- *	  If one or more filters are set, the "visible" fields of each entry
- *	  is updated according to the criteria provided by the filters. The
- *	  field "filter_mask" of the session's context is used to control the
- *	  level of visibility/invisibility of the filtered entries.
+ * @brief Get an array containing the Process Ids of all tasks presented in
+ *	  the loaded trace data file.
  *
  * @param kshark_ctx: Input location for context pointer.
- * @param data_rows: Output location for the trace data. The user is
- *		     responsible for freeing the elements of the outputted
- *		     array.
+ * @param sd: Data stream identifier.
+ * @param pids: Output location for the Pids of the tasks. The user is
+ *		responsible for freeing the elements of the outputted array.
  *
- * @returns The size of the outputted data in the case of success, or a
- *	    negative error code on failure.
+ * @returns The size of the outputted array of Pids in the case of success,
+ *	    or a negative error code on failure.
  */
-ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
-				 struct kshark_entry ***data_rows)
+ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int sd,
+			     int **pids)
 {
-	struct kshark_entry **rows;
-	struct rec_list **rec_list;
-	enum rec_type type = REC_ENTRY;
-	ssize_t count, total = 0;
-	int n_cpus;
-
-	if (*data_rows)
-		free(*data_rows);
-
-	total = get_records(kshark_ctx, &rec_list, type);
-	if (total < 0)
-		goto fail;
-
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
-
-	rows = calloc(total, sizeof(struct kshark_entry *));
-	if (!rows)
-		goto fail_free;
-
-	for (count = 0; count < total; count++) {
-		int next_cpu;
-
-		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
-
-		if (next_cpu >= 0) {
-			rows[count] = &rec_list[next_cpu]->entry;
-			rec_list[next_cpu] = rec_list[next_cpu]->next;
-		}
-	}
-
-	free_rec_list(rec_list, n_cpus, type);
-	*data_rows = rows;
-	return total;
+	struct kshark_data_stream *stream;
 
- fail_free:
-	free_rec_list(rec_list, n_cpus, type);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return -EBADF;
 
- fail:
-	fprintf(stderr, "Failed to allocate memory during data loading.\n");
-	return -ENOMEM;
+	*pids = kshark_hash_ids(stream->tasks);
+	return stream->tasks->count;
 }
 
 /**
- * @brief Load the content of the trace data file into an array of
- *	  tep_records. Use this function only if you need fast access
- *	  to all fields of the record.
- *
- * @param kshark_ctx: Input location for the session context pointer.
- * @param data_rows: Output location for the trace data. Use free_record()
- *	 	     to free the elements of the outputted array.
+ * @brief Get the name of the command/task from its Process Id.
  *
- * @returns The size of the outputted data in the case of success, or a
- *	    negative error code on failure.
+ * @param sd: Data stream identifier.
+ * @param pid: Process Id of the command/task.
  */
-ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
-				 struct tep_record ***data_rows)
+char *kshark_comm_from_pid(int sd, int pid)
 {
-	struct tep_record **rows;
-	struct tep_record *rec;
-	struct rec_list **rec_list;
-	struct rec_list *temp_rec;
-	enum rec_type type = REC_RECORD;
-	ssize_t count, total = 0;
-	int n_cpus;
-
-	total = get_records(kshark_ctx, &rec_list, type);
-	if (total < 0)
-		goto fail;
+	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_data_stream *stream;
+	struct kshark_entry e;
 
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+	if (!kshark_instance(&kshark_ctx))
+		return NULL;
 
-	rows = calloc(total, sizeof(struct tep_record *));
-	if (!rows)
-		goto fail_free;
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return NULL;
 
-	for (count = 0; count < total; count++) {
-		int next_cpu;
+	e.visible = KS_PLUGIN_UNTOUCHED_MASK;
+	e.pid = pid;
 
-		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
+	return stream->interface.get_task(stream, &e);
+}
 
-		if (next_cpu >= 0) {
-			rec = rec_list[next_cpu]->rec;
-			rows[count] = rec;
+/**
+ * @brief Get the name of the event from its Id.
+ *
+ * @param sd: Data stream identifier.
+ * @param event_id: The unique Id of the event type.
+ */
+char *kshark_event_from_id(int sd, int event_id)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_data_stream *stream;
+	struct kshark_entry e;
 
-			temp_rec = rec_list[next_cpu];
-			rec_list[next_cpu] = rec_list[next_cpu]->next;
-			free(temp_rec);
-			/* The record is still referenced in rows */
-		}
-	}
+	if (!kshark_instance(&kshark_ctx))
+		return NULL;
 
-	/* There should be no records left in rec_list */
-	free_rec_list(rec_list, n_cpus, type);
-	*data_rows = rows;
-	return total;
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return NULL;
 
- fail_free:
-	free_rec_list(rec_list, n_cpus, type);
+	e.visible = KS_PLUGIN_UNTOUCHED_MASK;
+	e.event_id = event_id;
 
- fail:
-	fprintf(stderr, "Failed to allocate memory during data loading.\n");
-	return -ENOMEM;
+	return stream->interface.get_event_name(stream, &e);
 }
 
-static inline void free_ptr(void *ptr)
+static bool filter_find(struct kshark_hash_id *filter, int pid,
+			bool test)
 {
-	if (ptr)
-		free(*(void **)ptr);
+	return !filter || !filter->count ||
+	       kshark_hash_id_find(filter, pid) == test;
 }
 
-static bool data_matrix_alloc(size_t n_rows, uint64_t **offset_array,
-					     uint16_t **cpu_array,
-					     uint64_t **ts_array,
-					     uint16_t **pid_array,
-					     int **event_array)
+static bool kshark_show_task(struct kshark_data_stream *stream, int pid)
 {
-	if (offset_array) {
-		*offset_array = calloc(n_rows, sizeof(**offset_array));
-		if (!*offset_array)
-			return false;
-	}
-
-	if (cpu_array) {
-		*cpu_array = calloc(n_rows, sizeof(**cpu_array));
-		if (!*cpu_array)
-			goto free_offset;
-	}
-
-	if (ts_array) {
-		*ts_array = calloc(n_rows, sizeof(**ts_array));
-		if (!*ts_array)
-			goto free_cpu;
-	}
+	return filter_find(stream->show_task_filter, pid, true) &&
+	       filter_find(stream->hide_task_filter, pid, false);
+}
 
-	if (pid_array) {
-		*pid_array = calloc(n_rows, sizeof(**pid_array));
-		if (!*pid_array)
-			goto free_ts;
-	}
+static bool kshark_show_event(struct kshark_data_stream *stream, int pid)
+{
+	return filter_find(stream->show_event_filter, pid, true) &&
+	       filter_find(stream->hide_event_filter, pid, false);
+}
 
-	if (event_array) {
-		*event_array = calloc(n_rows, sizeof(**event_array));
-		if (!*event_array)
-			goto free_pid;
-	}
+static bool kshark_show_cpu(struct kshark_data_stream *stream, int cpu)
+{
+	return filter_find(stream->show_cpu_filter, cpu, true) &&
+	       filter_find(stream->hide_cpu_filter, cpu, false);
+}
 
-	return true;
+static struct kshark_hash_id *get_filter(struct kshark_context *kshark_ctx,
+					 int sd,
+					 enum kshark_filter_type filter_id)
+{
+	struct kshark_data_stream *stream;
 
- free_pid:
-	free_ptr(pid_array);
- free_ts:
-	free_ptr(ts_array);
- free_cpu:
-	free_ptr(cpu_array);
- free_offset:
-	free_ptr(offset_array);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return NULL;
 
-	fprintf(stderr, "Failed to allocate memory during data loading.\n");
-	return false;
+	return kshark_get_filter(stream, filter_id);
 }
 
 /**
- * @brief Load the content of the trace data file into a table / matrix made
- *	  of columns / arrays of data. The user is responsible for freeing the
- *	  elements of the outputted array
- *
- * @param kshark_ctx: Input location for the session context pointer.
- * @param offset_array: Output location for the array of record offsets.
- * @param cpu_array: Output location for the array of CPU Ids.
- * @param ts_array: Output location for the array of timestamps.
- * @param pid_array: Output location for the array of Process Ids.
- * @param event_array: Output location for the array of Event Ids.
+ * @brief Get an Id Filter.
  *
- * @returns The size of the outputted arrays in the case of success, or a
- *	    negative error code on failure.
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param filter_id: Identifier of the filter.
  */
-size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
-			       uint64_t **offset_array,
-			       uint16_t **cpu_array,
-			       uint64_t **ts_array,
-			       uint16_t **pid_array,
-			       int **event_array)
+struct kshark_hash_id *
+kshark_get_filter(struct kshark_data_stream *stream,
+		  enum kshark_filter_type filter_id)
 {
-	enum rec_type type = REC_ENTRY;
-	struct rec_list **rec_list;
-	ssize_t count, total = 0;
-	bool status;
-	int n_cpus;
-
-	total = get_records(kshark_ctx, &rec_list, type);
-	if (total < 0)
-		goto fail;
-
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
-
-	status = data_matrix_alloc(total, offset_array,
-					  cpu_array,
-					  ts_array,
-					  pid_array,
-					  event_array);
-	if (!status)
-		goto fail_free;
-
-	for (count = 0; count < total; count++) {
-		int next_cpu;
-
-		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
-		if (next_cpu >= 0) {
-			struct rec_list *rec = rec_list[next_cpu];
-			struct kshark_entry *e = &rec->entry;
-
-			if (offset_array)
-				(*offset_array)[count] = e->offset;
-
-			if (cpu_array)
-				(*cpu_array)[count] = e->cpu;
-
-			if (ts_array)
-				(*ts_array)[count] = e->ts;
-
-			if (pid_array)
-				(*pid_array)[count] = e->pid;
-
-			if (event_array)
-				(*event_array)[count] = e->event_id;
-
-			rec_list[next_cpu] = rec_list[next_cpu]->next;
-			free(rec);
-		}
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
 	}
-
-	/* There should be no entries left in rec_list. */
-	free_rec_list(rec_list, n_cpus, type);
-	return total;
-
- fail_free:
-	free_rec_list(rec_list, n_cpus, type);
-
- fail:
-	fprintf(stderr, "Failed to allocate memory during data loading.\n");
-	return -ENOMEM;
 }
 
-static const char *kshark_get_latency(struct tep_handle *pe,
-				      struct tep_record *record)
+/**
+ * @brief Add an Id value to the filter specified by "filter_id".
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param sd: Data stream identifier.
+ * @param filter_id: Identifier of the filter.
+ * @param id: Id value to be added to the filter.
+ */
+void kshark_filter_add_id(struct kshark_context *kshark_ctx, int sd,
+			  int filter_id, int id)
 {
-	if (!record)
-		return NULL;
+	struct kshark_hash_id *filter;
 
-	trace_seq_reset(&seq);
-	tep_print_event(pe, &seq, record, "%s", TEP_PRINT_LATENCY);
-	return seq.buffer;
+	filter = get_filter(kshark_ctx, sd, filter_id);
+	if (filter)
+		kshark_hash_id_add(filter, id);
 }
 
-static const char *kshark_get_info(struct tep_handle *pe,
-				   struct tep_record *record,
-				   struct tep_event *event)
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
 {
-	char *pos;
+	struct kshark_hash_id *filter;
 
-	if (!record || !event)
-		return NULL;
+	filter = get_filter(kshark_ctx, sd, filter_id);
+	if (filter) {
+		if (n)
+			*n = filter->count;
 
-	trace_seq_reset(&seq);
-	tep_print_event(pe, &seq, record, "%s", TEP_PRINT_INFO);
+		return kshark_hash_ids(filter);
+	}
 
-	/*
-	 * The event info string contains a trailing newline.
-	 * Remove this newline.
-	 */
-	if ((pos = strchr(seq.buffer, '\n')) != NULL)
-		*pos = '\0';
+	if (n)
+		*n = 0;
 
-	return seq.buffer;
+	return NULL;
 }
 
 /**
- * @brief This function allows for an easy access to the original value of the
- *	  Process Id as recorded in the tep_record object. The record is read
- *	  from the file only in the case of an entry being touched by a plugin.
- *	  Be aware that using the kshark_get_X_easy functions can be
- *	  inefficient if you need an access to more than one of the data fields
- *	  of the record.
- *
- * @param entry: Input location for the KernelShark entry.
+ * @brief Clear (reset) the filter specified by "filter_id".
  *
- * @returns The original value of the Process Id as recorded in the
- *	    tep_record object on success, otherwise negative error code.
- */
-int kshark_get_pid_easy(struct kshark_entry *entry)
-{
-	struct kshark_context *kshark_ctx = NULL;
-	struct tep_record *data;
-	int pid;
-
-	if (!kshark_instance(&kshark_ctx))
-		return -ENODEV;
-
-	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
-		pid = entry->pid;
-	} else {
-		/*
-		 * The entry has been touched by a plugin callback function.
-		 * Because of this we do not trust the value of "entry->pid".
-		 *
-		 * Currently the data reading operations are not thread-safe.
-		 * Use a mutex to protect the access.
-		 */
-		pthread_mutex_lock(&kshark_ctx->input_mutex);
-
-		data = tracecmd_read_at(kshark_ctx->handle, entry->offset,
-					NULL);
-		pid = tep_data_pid(kshark_ctx->pevent, data);
-		free_record(data);
-
-		pthread_mutex_unlock(&kshark_ctx->input_mutex);
-	}
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param sd: Data stream identifier.
+ * @param filter_id: Identifier of the filter.
+ */
+void kshark_filter_clear(struct kshark_context *kshark_ctx, int sd,
+			 int filter_id)
+{
+	struct kshark_hash_id *filter;
 
-	return pid;
+	filter = get_filter(kshark_ctx, sd, filter_id);
+	if (filter)
+		kshark_hash_id_clear(filter);
 }
 
 /**
- * @brief This function allows for an easy access to the original value of the
- *	  Task name as recorded in the tep_record object. The record is read
- *	  from the file only in the case of an entry being touched by a plugin.
- *	  Be aware that using the kshark_get_X_easy functions can be
- *	  inefficient if you need an access to more than one of the data fields
- *	  of the record.
+ * @brief Check if a given Id filter is set.
  *
- * @param entry: Input location for the KernelShark entry.
+ * @param filter: Input location for the Id filster.
  *
- * @returns The original name of the task, retrieved from the Process Id
- *	    recorded in the tep_record object on success, otherwise NULL.
+ * @returns True if the Id filter is set, otherwise False.
  */
-const char *kshark_get_task_easy(struct kshark_entry *entry)
+bool kshark_this_filter_is_set(struct kshark_hash_id *filter)
 {
-	struct kshark_context *kshark_ctx = NULL;
-	int pid = kshark_get_pid_easy(entry);
-
-	if (pid < 0)
-		return NULL;
-
-	kshark_instance(&kshark_ctx);
-	return tep_data_comm_from_pid(kshark_ctx->pevent, pid);
+	return filter && filter->count;
 }
 
 /**
- * @brief This function allows for an easy access to the latency information
- *	  recorded in the tep_record object. The record is read from the file
- *	  using the offset field of kshark_entry. Be aware that using the
- *	  kshark_get_X_easy functions can be inefficient if you need an access
- *	  to more than one of the data fields of the record.
+ * @brief Check if an Id filter is set.
  *
- * @param entry: Input location for the KernelShark entry.
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param sd: Data stream identifier.
  *
- * @returns On success the function returns a string showing the latency
- *	    information, coded into 5 fields:
- *	    interrupts disabled, need rescheduling, hard/soft interrupt,
- *	    preempt count and lock depth. On failure it returns NULL.
+ * @returns True if at least one Id filter of the stream is set, otherwise
+ *	    False.
  */
-const char *kshark_get_latency_easy(struct kshark_entry *entry)
+bool kshark_filter_is_set(struct kshark_context *kshark_ctx, int sd)
 {
-	struct kshark_context *kshark_ctx = NULL;
-	struct tep_record *data;
-	const char *lat;
-
-	if (!kshark_instance(&kshark_ctx))
-		return NULL;
-
-	if (entry->event_id < 0)
-		return NULL;
-
-	/*
-	 * Currently the data reading operations are not thread-safe.
-	 * Use a mutex to protect the access.
-	 */
-	pthread_mutex_lock(&kshark_ctx->input_mutex);
+	struct kshark_data_stream *stream;
 
-	data = tracecmd_read_at(kshark_ctx->handle, entry->offset, NULL);
-	lat = kshark_get_latency(kshark_ctx->pevent, data);
-	free_record(data);
-
-	pthread_mutex_unlock(&kshark_ctx->input_mutex);
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return false;
 
-	return lat;
+	return kshark_this_filter_is_set(stream->show_task_filter) ||
+	       kshark_this_filter_is_set(stream->hide_task_filter)  ||
+	       kshark_this_filter_is_set(stream->show_cpu_filter)   ||
+	       kshark_this_filter_is_set(stream->hide_cpu_filter)   ||
+	       kshark_this_filter_is_set(stream->show_event_filter) ||
+	       kshark_this_filter_is_set(stream->hide_event_filter);
 }
 
 /**
- * @brief This function allows for an easy access to the original value of the
- *	  Event Id as recorded in the tep_record object. The record is read
- *	  from the file only in the case of an entry being touched by a plugin.
- *	  Be aware that using the kshark_get_X_easy functions can be
- *	  inefficient if you need an access to more than one of the data fields
- *	  of the record.
+ * @brief Apply filters to a given entry.
  *
- * @param entry: Input location for the KernelShark entry.
- *
- * @returns The original value of the Event Id as recorded in the
- *	    tep_record object on success, otherwise negative error code.
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param entry: Input location for entry.
  */
-int kshark_get_event_id_easy(struct kshark_entry *entry)
+void kshark_apply_filters(struct kshark_context *kshark_ctx,
+			  struct kshark_data_stream *stream,
+			  struct kshark_entry *entry)
 {
-	struct kshark_context *kshark_ctx = NULL;
-	struct tep_record *data;
-	int event_id;
+	/* Apply event filtering. */
+	if (!kshark_show_event(stream, entry->event_id))
+		unset_event_filter_flag(kshark_ctx, entry);
 
-	if (!kshark_instance(&kshark_ctx))
-		return -ENODEV;
+	/* Apply CPU filtering. */
+	if (!kshark_show_cpu(stream, entry->cpu))
+		entry->visible &= ~kshark_ctx->filter_mask;
 
-	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
-		event_id = entry->event_id;
-	} else {
-		/*
-		 * The entry has been touched by a plugin callback function.
-		 * Because of this we do not trust the value of
-		 * "entry->event_id".
-		 *
-		 * Currently the data reading operations are not thread-safe.
-		 * Use a mutex to protect the access.
-		 */
-		pthread_mutex_lock(&kshark_ctx->input_mutex);
-
-		data = tracecmd_read_at(kshark_ctx->handle, entry->offset,
-					NULL);
-		event_id = tep_data_type(kshark_ctx->pevent, data);
-		free_record(data);
-
-		pthread_mutex_unlock(&kshark_ctx->input_mutex);
-	}
+	/* Apply task filtering. */
+	if (!kshark_show_task(stream, entry->pid))
+		entry->visible &= ~kshark_ctx->filter_mask;
+}
 
-	return (event_id == -1)? -EFAULT : event_id;
+static void set_all_visible(uint8_t *v) {
+	/*  Keep the original value of the PLUGIN_UNTOUCHED bit flag. */
+	*v |= 0xFF & ~KS_PLUGIN_UNTOUCHED_MASK;
 }
 
-/**
- * @brief This function allows for an easy access to the original name of the
- *	  trace event as recorded in the tep_record object. The record is read
- *	  from the file only in the case of an entry being touched by a plugin.
- *	  Be aware that using the kshark_get_X_easy functions can be
- *	  inefficient if you need an access to more than one of the data fields
- *	  of the record.
- *
- * @param entry: Input location for the KernelShark entry.
- *
- * @returns The mane of the trace event recorded in the tep_record object on
- *	    success, otherwise "[UNKNOWN EVENT]" or NULL.
- */
-const char *kshark_get_event_name_easy(struct kshark_entry *entry)
+static void filter_entries(struct kshark_context *kshark_ctx, int sd,
+			   struct kshark_entry **data, size_t n_entries)
 {
-	struct kshark_context *kshark_ctx = NULL;
-	struct tep_event *event;
-
-	int event_id = kshark_get_event_id_easy(entry);
-	if (event_id == -EFAULT)
-		return NULL;
+	struct kshark_data_stream *stream = NULL;
+	size_t i;
+
+	/* Sanity checks before starting. */
+	if (sd >= 0) {
+		/* We will filter particular Data stream. */
+		stream = kshark_get_data_stream(kshark_ctx, sd);
+		if (!stream)
+			return;
 
-	kshark_instance(&kshark_ctx);
+		if (stream->format == KS_TEP_DATA &&
+		    kshark_tep_filter_is_set(stream)) {
+			/* The advanced filter is set. */
+			fprintf(stderr,
+				"Failed to filter (sd = %i)!\n", sd);
+			fprintf(stderr,
+				"Reset the Advanced filter or reload the data.\n");
 
-	if (event_id < 0) {
-		switch (event_id) {
-		case KS_EVENT_OVERFLOW:
-			return missed_events_dump(kshark_ctx, entry, false);
-		default:
-			return NULL;
+			return;
 		}
+
+		if (!kshark_filter_is_set(kshark_ctx, sd))
+			return;
 	}
 
-	/*
-	 * Currently the data reading operations are not thread-safe.
-	 * Use a mutex to protect the access.
-	 */
-	pthread_mutex_lock(&kshark_ctx->input_mutex);
-	event = tep_find_event(kshark_ctx->pevent, event_id);
-	pthread_mutex_unlock(&kshark_ctx->input_mutex);
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
 
-	if (event)
-		return event->name;
+		/* Start with and entry which is visible everywhere. */
+		set_all_visible(&data[i]->visible);
 
-	return "[UNKNOWN EVENT]";
+		/* Apply Id filtering. */
+		kshark_apply_filters(kshark_ctx, stream, data[i]);
+	}
 }
 
 /**
- * @brief This function allows for an easy access to the tep_record's info
- *	  streang. The record is read from the file using the offset field of
- *	  kshark_entry. Be aware that using the kshark_get_X_easy functions can
- *	  be inefficient if you need an access to more than one of the data
- *	  fields of the record.
- *
- * @param entry: Input location for the KernelShark entry.
+ * @brief This function loops over the array of entries specified by "data"
+ *	  and "n_entries" and sets the "visible" fields of each entry from a
+ *	  given Data stream according to the criteria provided by the filters
+ *	  of the session's context. The field "filter_mask" of the session's
+ *	  context is used to control the level of visibility/invisibility of
+ *	  the entries which are filtered-out.
+ *	  WARNING: Do not use this function if the advanced filter is set.
+ *	  Applying the advanced filter requires access to prevent_record,
+ *	  hence the data has to be reloaded using kshark_load_data_entries().
  *
- * @returns A string showing the data output of the trace event on success,
- *	    otherwise NULL.
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param sd: Data stream identifier.
+ * @param data: Input location for the trace data to be filtered.
+ * @param n_entries: The size of the inputted data.
  */
-const char *kshark_get_info_easy(struct kshark_entry *entry)
+void kshark_filter_stream_entries(struct kshark_context *kshark_ctx,
+				  int sd,
+				  struct kshark_entry **data,
+				  size_t n_entries)
 {
-	struct kshark_context *kshark_ctx = NULL;
-	struct tep_event *event;
-	struct tep_record *data;
-	const char *info = NULL;
-	int event_id;
-
-	if (!kshark_instance(&kshark_ctx))
-		return NULL;
-
-	if (entry->event_id < 0) {
-		switch (entry->event_id) {
-		case KS_EVENT_OVERFLOW:
-			return missed_events_dump(kshark_ctx, entry, true);
-		default:
-			return NULL;
-		}
-	}
-
-	/*
-	 * Currently the data reading operations are not thread-safe.
-	 * Use a mutex to protect the access.
-	 */
-	pthread_mutex_lock(&kshark_ctx->input_mutex);
-
-	data = tracecmd_read_at(kshark_ctx->handle, entry->offset, NULL);
-	event_id = tep_data_type(kshark_ctx->pevent, data);
-	event = tep_find_event(kshark_ctx->pevent, event_id);
-	if (event)
-		info = kshark_get_info(kshark_ctx->pevent, data, event);
-
-	free_record(data);
-
-	pthread_mutex_unlock(&kshark_ctx->input_mutex);
-
-	return info;
+	if (sd >= 0)
+		filter_entries(kshark_ctx, sd, data, n_entries);
 }
 
 /**
- * @brief Convert the timestamp of the trace record (nanosecond precision) into
- *	  seconds and microseconds.
+ * @brief This function loops over the array of entries specified by "data"
+ *	  and "n_entries" and sets the "visible" fields of each entry from
+ *	  all Data stream according to the criteria provided by the filters
+ *	  of the session's context. The field "filter_mask" of the session's
+ *	  context is used to control the level of visibility/invisibility of
+ *	  the entries which are filtered-out.
+ *	  WARNING: Do not use this function if the advanced filter is set.
+ *	  Applying the advanced filter requires access to prevent_record,
+ *	  hence the data has to be reloaded using kshark_load_data_entries().
  *
- * @param time: Input location for the timestamp.
- * @param sec: Output location for the value of the seconds.
- * @param usec: Output location for the value of the microseconds.
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param data: Input location for the trace data to be filtered.
+ * @param n_entries: The size of the inputted data.
  */
-void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec)
+void kshark_filter_all_entries(struct kshark_context *kshark_ctx,
+			       struct kshark_entry **data, size_t n_entries)
 {
-	uint64_t s;
-
-	*sec = s = time / 1000000000ULL;
-	*usec = (time - s * 1000000000ULL) / 1000;
+	filter_entries(kshark_ctx, -1, data, n_entries);
 }
 
 /**
- * @brief Dump into a string the content a custom entry. The function allocates
- *	  a null terminated string and returns a pointer to this string.
+ * @brief This function loops over the array of entries specified by "data"
+ *	  and "n_entries" and resets the "visible" fields of each entry to
+ *	  the default value of "0xFF" (visible everywhere).
  *
  * @param kshark_ctx: Input location for the session context pointer.
- * @param entry: A Kernel Shark entry to be printed.
- * @param info_func:
- *
- * @returns The returned string contains a semicolon-separated list of data
- *	    fields. The user has to free the returned string.
+ * @param data: Input location for the trace data to be unfiltered.
+ * @param n_entries: The size of the inputted data.
  */
-char* kshark_dump_custom_entry(struct kshark_context *kshark_ctx,
-			       const struct kshark_entry *entry,
-			       kshark_custom_info_func info_func)
+void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
+			      struct kshark_entry **data,
+			      size_t n_entries)
 {
-	const char *event_name, *task, *info;
-	char *entry_str;
-	int size = 0;
-
-	task = tep_data_comm_from_pid(kshark_ctx->pevent, entry->pid);
-	event_name = info_func(kshark_ctx, entry, false);
-	info = info_func(kshark_ctx, entry, true);
-
-	size = asprintf(&entry_str, "%" PRIu64 "; %s-%i; CPU %i; ; %s; %s",
-			entry->ts,
-			task,
-			entry->pid,
-			entry->cpu,
-			event_name,
-			info);
-
-	if (size > 0)
-		return entry_str;
+	int i;
 
-	return NULL;
+	for (i = 0; i < n_entries; ++i)
+		set_all_visible(&data[i]->visible);
 }
 
 /**
- * @brief Dump into a string the content of one entry. The function allocates
- *	  a null terminated string and returns a pointer to this string. The
- *	  user has to free the returned string.
- *
- * @param entry: A Kernel Shark entry to be printed.
+ * @brief Time calibration of the timestamp of the entry.
  *
- * @returns The returned string contains a semicolon-separated list of data
- *	    fields.
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param entry: Output location for entry.
  */
-char* kshark_dump_entry(const struct kshark_entry *entry)
+void kshark_calib_entry(struct kshark_data_stream *stream,
+			struct kshark_entry *entry)
 {
-	const char *event_name, *task, *lat, *info;
-	struct kshark_context *kshark_ctx;
-	char *temp_str, *entry_str;
-	int size = 0;
-
-	kshark_ctx = NULL;
-	if (!kshark_instance(&kshark_ctx) || !init_thread_seq())
-		return NULL;
-
-	task = tep_data_comm_from_pid(kshark_ctx->pevent, entry->pid);
-
-	if (entry->event_id >= 0) {
-		struct tep_event *event;
-		struct tep_record *data;
-
-		data = tracecmd_read_at(kshark_ctx->handle, entry->offset,
-					NULL);
-
-		event = tep_find_event(kshark_ctx->pevent, entry->event_id);
-
-		event_name = event? event->name : "[UNKNOWN EVENT]";
-		lat = kshark_get_latency(kshark_ctx->pevent, data);
-
-		size = asprintf(&temp_str, "%" PRIu64 "; %s-%i; CPU %i; %s;",
-				entry->ts,
-				task,
-				entry->pid,
-				entry->cpu,
-				lat);
-
-		info = kshark_get_info(kshark_ctx->pevent, data, event);
-
-		if (size > 0) {
-			size = asprintf(&entry_str, "%s %s; %s; 0x%x",
-					temp_str,
-					event_name,
-					info,
-					entry->visible);
-
-			free(temp_str);
-		}
+	if (stream->calib && stream->calib_array) {
+		/* Calibrate the timestamp of the entry. */
+		stream->calib(&entry->ts, stream->calib_array);
+	}
+}
 
-		free_record(data);
-		if (size < 1)
-			entry_str = NULL;
-	} else {
-		switch (entry->event_id) {
-		case KS_EVENT_OVERFLOW:
-			entry_str = kshark_dump_custom_entry(kshark_ctx, entry,
-							     missed_events_dump);
-		default:
-			entry_str = NULL;
+/**
+ * @brief Process all registered event-specific plugin actions.
+ *
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param record: Input location for the trace record.
+ * @param entry: Output location for entry.
+ */
+void kshark_plugin_actions(struct kshark_data_stream *stream,
+			   void *record, struct kshark_entry *entry)
+{
+	if (stream->event_handlers) {
+		/* Execute all plugin-provided actions for this event (if any). */
+		struct kshark_event_proc_handler *evt_handler = stream->event_handlers;
+
+		while ((evt_handler = kshark_find_event_handler(evt_handler,
+								entry->event_id))) {
+			evt_handler->event_func(stream, record, entry);
+			evt_handler = evt_handler->next;
+			entry->visible &= ~KS_PLUGIN_UNTOUCHED_MASK;
 		}
 	}
-
-	return entry_str;
 }
 
 /**
- * @brief Binary search inside a time-sorted array of kshark_entries.
- *
- * @param time: The value of time to search for.
- * @param data: Input location for the trace data.
- * @param l: Array index specifying the lower edge of the range to search in.
- * @param h: Array index specifying the upper edge of the range to search in.
+ * @brief Post-process the content of the entry. This includes time calibration
+ *	  and all registered event-specific plugin actions.
  *
- * @returns On success, the first kshark_entry inside the range, having a
-	    timestamp equal or bigger than "time".
-	    If all entries inside the range have timestamps greater than "time"
-	    the function returns BSEARCH_ALL_GREATER (negative value).
-	    If all entries inside the range have timestamps smaller than "time"
-	    the function returns BSEARCH_ALL_SMALLER (negative value).
+ * @param stream: Input location for a Trace data stream pointer.
+ * @param record: Input location for the trace record.
+ * @param entry: Output location for entry.
  */
-ssize_t kshark_find_entry_by_time(uint64_t time,
-				 struct kshark_entry **data,
-				 size_t l, size_t h)
+void kshark_postprocess_entry(struct kshark_data_stream *stream,
+			      void *record, struct kshark_entry *entry)
 {
-	size_t mid;
+	kshark_calib_entry(stream, entry);
 
-	if (data[l]->ts > time)
-		return BSEARCH_ALL_GREATER;
+	kshark_plugin_actions(stream, record, entry);
+}
 
-	if (data[h]->ts < time)
-		return BSEARCH_ALL_SMALLER;
+/**
+ * @brief Convert the timestamp of the trace record (nanosecond precision) into
+ *	  seconds and microseconds.
+ *
+ * @param time: Input location for the timestamp.
+ * @param sec: Output location for the value of the seconds.
+ * @param usec: Output location for the value of the microseconds.
+ */
+void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec)
+{
+	uint64_t s;
 
-	/*
-	 * After executing the BSEARCH macro, "l" will be the index of the last
-	 * entry having timestamp < time and "h" will be the index of the first
-	 * entry having timestamp >= time.
-	 */
-	BSEARCH(h, l, data[mid]->ts < time);
-	return h;
+	*sec = s = time / 1000000000ULL;
+	*usec = (time - s * 1000000000ULL) / 1000;
 }
 
 /**
- * @brief Binary search inside a time-sorted array of tep_records.
+ * @brief Binary search inside a time-sorted array of kshark_entries.
  *
  * @param time: The value of time to search for.
  * @param data: Input location for the trace data.
  * @param l: Array index specifying the lower edge of the range to search in.
  * @param h: Array index specifying the upper edge of the range to search in.
  *
- * @returns On success, the first tep_record inside the range, having a
-	    timestamp equal or bigger than "time".
-	    If all entries inside the range have timestamps greater than "time"
-	    the function returns BSEARCH_ALL_GREATER (negative value).
-	    If all entries inside the range have timestamps smaller than "time"
-	    the function returns BSEARCH_ALL_SMALLER (negative value).
+ * @returns On success, the first kshark_entry inside the range, having a
+ *	    timestamp equal or bigger than "time".
+ *	    If all entries inside the range have timestamps greater than "time"
+ *	    the function returns BSEARCH_ALL_GREATER (negative value).
+ *	    If all entries inside the range have timestamps smaller than "time"
+ *	    the function returns BSEARCH_ALL_SMALLER (negative value).
  */
-ssize_t kshark_find_record_by_time(uint64_t time,
-				   struct tep_record **data,
-				   size_t l, size_t h)
+ssize_t kshark_find_entry_by_time(int64_t time,
+				  struct kshark_entry **data,
+				  size_t l, size_t h)
 {
 	size_t mid;
 
@@ -1573,8 +903,8 @@ ssize_t kshark_find_record_by_time(uint64_t time,
 
 	/*
 	 * After executing the BSEARCH macro, "l" will be the index of the last
-	 * record having timestamp < time and "h" will be the index of the
-	 * first record having timestamp >= time.
+	 * entry having timestamp < time and "h" will be the index of the first
+	 * entry having timestamp >= time.
 	 */
 	BSEARCH(h, l, data[mid]->ts < time);
 	return h;
@@ -1585,15 +915,16 @@ ssize_t kshark_find_record_by_time(uint64_t time,
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
@@ -1604,20 +935,80 @@ bool kshark_match_pid(struct kshark_context *kshark_ctx,
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
@@ -1626,8 +1017,9 @@ bool kshark_match_cpu(struct kshark_context *kshark_ctx,
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
@@ -1638,7 +1030,7 @@ bool kshark_match_cpu(struct kshark_context *kshark_ctx,
  */
 struct kshark_entry_request *
 kshark_entry_request_alloc(size_t first, size_t n,
-			   matching_condition_func cond, int val,
+			   matching_condition_func cond, int sd, int *values,
 			   bool vis_only, int vis_mask)
 {
 	struct kshark_entry_request *req = malloc(sizeof(*req));
@@ -1653,7 +1045,8 @@ kshark_entry_request_alloc(size_t first, size_t n,
 	req->first = first;
 	req->n = n;
 	req->cond = cond;
-	req->val = val;
+	req->sd = sd;
+	req->values = values;
 	req->vis_only = vis_only;
 	req->vis_mask = vis_mask;
 
@@ -1707,7 +1100,7 @@ get_entry(const struct kshark_entry_request *req,
 	 */
 	assert((inc > 0 && start < end) || (inc < 0 && start > end));
 	for (i = start; i != end; i += inc) {
-		if (req->cond(kshark_ctx, data[i], req->val)) {
+		if (req->cond(kshark_ctx, data[i], req->sd, req->values)) {
 			/*
 			 * Data satisfying the condition has been found.
 			 */
@@ -1790,3 +1183,74 @@ kshark_get_entry_back(const struct kshark_entry_request *req,
 
 	return get_entry(req, data, index, req->first, end, -1);
 }
+
+static inline void free_ptr(void *ptr)
+{
+	if (ptr)
+		free(*(void **)ptr);
+}
+
+/**
+ * @brief Allocate data arrays (matrix columns) to be used to load the tracing
+ *	  data into a data matrix form.
+ *
+ * @param n_rows: Number matrix rows to be allocated. Must be equal to the
+ *	 	  number of trace records.
+ * @param cpu_array: Output location for the CPU Id column.
+ * @param pid_array: Output location for the PID column.
+ * @param event_array: Output location for the Event Id column.
+ * @param offset_array: Output location for the record offset column.
+ * @param ts_array: Output location for the timestamp column.
+ *
+ * @returns True on success. Else false.
+ */
+bool kshark_data_matrix_alloc(size_t n_rows, int16_t **cpu_array,
+					     int32_t **pid_array,
+					     int32_t **event_array,
+					     int64_t **offset_array,
+					     int64_t **ts_array)
+{
+	if (offset_array) {
+		*offset_array = calloc(n_rows, sizeof(**offset_array));
+		if (!*offset_array)
+			return false;
+	}
+
+	if (cpu_array) {
+		*cpu_array = calloc(n_rows, sizeof(**cpu_array));
+		if (!*cpu_array)
+			goto free_offset;
+	}
+
+	if (ts_array) {
+		*ts_array = calloc(n_rows, sizeof(**ts_array));
+		if (!*ts_array)
+			goto free_cpu;
+	}
+
+	if (pid_array) {
+		*pid_array = calloc(n_rows, sizeof(**pid_array));
+		if (!*pid_array)
+			goto free_ts;
+	}
+
+	if (event_array) {
+		*event_array = calloc(n_rows, sizeof(**event_array));
+		if (!*event_array)
+			goto free_pid;
+	}
+
+	return true;
+
+ free_pid:
+	free_ptr(pid_array);
+ free_ts:
+	free_ptr(ts_array);
+ free_cpu:
+	free_ptr(cpu_array);
+ free_offset:
+	free_ptr(offset_array);
+
+	fprintf(stderr, "Failed to allocate memory during data loading.\n");
+	return false;
+}
diff --git a/src/libkshark.h b/src/libkshark.h
index 726f3d2..d7539e2 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -6,7 +6,7 @@
 
  /**
  *  @file    libkshark.h
- *  @brief   API for processing of FTRACE (trace-cmd) data.
+ *  @brief   API for processing of tracing data.
  */
 
 #ifndef _LIB_KSHARK_H
@@ -24,12 +24,6 @@
 extern "C" {
 #endif
 
-// trace-cmd
-#include "trace-cmd/trace-cmd.h"
-#include "trace-cmd/trace-filter-hash.h"
-#include "traceevent/event-parse.h"
-#include "tracefs/tracefs.h"
-
 // KernelShark
 #include "libkshark-plugin.h"
 
@@ -353,54 +347,16 @@ struct kshark_data_stream {
 	 */
 	struct kshark_data_stream_interface	interface;
 };
-
 /** Hard-coded maximum number of data stream. */
 #define KS_MAX_NUM_STREAMS	127
 
-/** Size of the task's hash table. */
-#define KS_TASK_HASH_SHIFT 16
-#define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
-
-/** Linked list of tasks. */
-struct kshark_task_list {
-	/** Pointer to the next task's PID. */
-	struct kshark_task_list	*next;
-
-	/** PID of a task. */
-	int			 pid;
-};
-
 /** Structure representing a kshark session. */
 struct kshark_context {
-	/** Input handle for the trace data file. */
-	struct tracecmd_input	*handle;
-
-	/** Page event used to parse the page. */
-	struct tep_handle	*pevent;
+	/** Array of data stream descriptors. */
+	struct kshark_data_stream	**stream;
 
-	/** Hash table of task PIDs. */
-	struct kshark_task_list	*tasks[KS_TASK_HASH_SIZE];
-
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
+	/** The number of data streams. */
+	int				n_streams;
 
 	/**
 	 * Bit mask, controlling the visibility of the entries after filtering.
@@ -409,72 +365,225 @@ struct kshark_context {
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
 
+	/** List of data readout interfaces. */
+	struct kshark_dri_list		*inputs;
+
+	/** The number of readout interfaces. */
+	int				n_inputs;
+
 	/** List of Plugins. */
 	struct kshark_plugin_list	*plugins;
 
-	/** List of Plugin Event handlers. */
-	struct kshark_event_handler	*event_handlers;
+	/** The number of plugins. */
+	int				n_plugins;
 };
 
 bool kshark_instance(struct kshark_context **kshark_ctx);
 
-bool kshark_open(struct kshark_context *kshark_ctx, const char *file);
+int kshark_open(struct kshark_context *kshark_ctx, const char *file);
 
-ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
-				 struct kshark_entry ***data_rows);
+int kshark_stream_open(struct kshark_data_stream *stream, const char *file);
 
-ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
-				 struct tep_record ***data_rows);
+int kshark_add_stream(struct kshark_context *kshark_ctx);
 
-size_t kshark_load_data_matrix(struct kshark_context *kshark_ctx,
-			       uint64_t **offset_array,
-			       uint16_t **cpu_array,
-			       uint64_t **ts_array,
-			       uint16_t **pid_array,
-			       int **event_array);
+static inline struct kshark_data_stream *
+kshark_get_data_stream(struct kshark_context *kshark_ctx, int sd)
+{
+	if (sd >= 0 && sd < KS_MAX_NUM_STREAMS)
+		return kshark_ctx->stream[sd];
 
-ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int **pids);
+	return NULL;
+}
 
-void kshark_close(struct kshark_context *kshark_ctx);
+static inline struct kshark_data_stream *
+kshark_get_stream_from_entry(const struct kshark_entry *entry)
+{
+	struct kshark_context *kshark_ctx = NULL;
 
-void kshark_free(struct kshark_context *kshark_ctx);
+	if (!kshark_instance(&kshark_ctx))
+		return NULL;
+
+	return kshark_get_data_stream(kshark_ctx, entry->stream_id);
+}
+
+int *kshark_all_streams(struct kshark_context *kshark_ctx);
 
-int kshark_get_pid_easy(struct kshark_entry *entry);
+ssize_t kshark_get_task_pids(struct kshark_context *kshark_ctx, int sd,
+			     int **pids);
 
-const char *kshark_get_task_easy(struct kshark_entry *entry);
+void kshark_close(struct kshark_context *kshark_ctx, int sd);
 
-const char *kshark_get_latency_easy(struct kshark_entry *entry);
+void kshark_close_all(struct kshark_context *kshark_ctx);
 
-int kshark_get_event_id_easy(struct kshark_entry *entry);
+void kshark_free(struct kshark_context *kshark_ctx);
 
-const char *kshark_get_event_name_easy(struct kshark_entry *entry);
+char *kshark_comm_from_pid(int sd, int pid);
 
-const char *kshark_get_info_easy(struct kshark_entry *entry);
+char *kshark_event_from_id(int sd, int event_id);
 
 void kshark_convert_nano(uint64_t time, uint64_t *sec, uint64_t *usec);
 
-char* kshark_dump_entry(const struct kshark_entry *entry);
+static inline int kshark_get_pid(const struct kshark_entry *entry)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return -1;
+
+	return stream->interface.get_pid(stream, entry);
+}
+
+static inline int kshark_get_event_id(const struct kshark_entry *entry)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return -1;
+
+	return stream->interface.get_event_id(stream, entry);
+}
+
+static inline int *kshark_get_all_event_ids(struct kshark_data_stream *stream)
+{
+	return stream->interface.get_all_event_ids(stream);
+}
+
+static inline char *kshark_get_event_name(const struct kshark_entry *entry)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return NULL;
+
+	return stream->interface.get_event_name(stream, entry);
+}
+
+static inline char *kshark_get_task(const struct kshark_entry *entry)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return NULL;
+
+	return stream->interface.get_task(stream, entry);
+}
+
+static inline char *kshark_get_latency(const struct kshark_entry *entry)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return NULL;
+
+	return stream->interface.get_latency(stream, entry);
+}
+
+static inline char *kshark_get_info(const struct kshark_entry *entry)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return NULL;
+
+	return stream->interface.get_info(stream, entry);
+}
+
+static inline int kshark_read_event_field(const struct kshark_entry *entry,
+					  const char* field, int64_t *val)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return -1;
+
+	return stream->interface.read_event_field_int64(stream, entry,
+							field, val);
+}
+
+static inline char *kshark_dump_entry(const struct kshark_entry *entry)
+{
+	struct kshark_data_stream *stream =
+		kshark_get_stream_from_entry(entry);
+
+	if (!stream)
+		return NULL;
+
+	return stream->interface.dump_entry(stream, entry);
+}
 
 /**
- * Custom entry info function type. To be user for dumping info for custom
- * KernelShark entryes.
+ * @brief Load the content of the trace data file asociated with a given
+ *	  Data stream identifie into an array of kshark_entries.
+ *	  If one or more filters are set, the "visible" fields of each entry
+ *	  is updated according to the criteria provided by the filters. The
+ *	  field "filter_mask" of the session's context is used to control the
+ *	  level of visibility/invisibility of the filtered entries.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param sd: Data stream identifier.
+ * @param data_rows: Output location for the trace data. The user is
+ *		     responsible for freeing the elements of the outputted
+ *		     array.
+ *
+ * @returns The size of the outputted data in the case of success, or a
+ *	    negative error code on failure.
  */
-typedef const char *(kshark_custom_info_func)(struct kshark_context *,
-					      const struct kshark_entry *,
-					      bool);
+static inline ssize_t kshark_load_entries(struct kshark_context *kshark_ctx,
+					  int sd,
+					  struct kshark_entry ***data_rows)
+{
+	struct kshark_data_stream *stream;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return -EBADF;
+
+	return stream->interface.load_entries(stream, kshark_ctx, data_rows);
+}
 
-char* kshark_dump_custom_entry(struct kshark_context *kshark_ctx,
-			       const struct kshark_entry *entry,
-			       kshark_custom_info_func info_func);
+/**
+ * @brief Load the content of the trace data file asociated with a given
+ *	  Data stream identifie into a data matrix.
+ *
+ * @param kshark_ctx: Input location for context pointer.
+ * @param sd: Data stream identifier.
+ * @param data_rows: Output location for the trace data. The user is
+ *		     responsible for freeing the elements of the outputted
+ *		     array.
+ *
+ * @returns The size of the outputted data in the case of success, or a
+ *	    negative error code on failure.
+ */
+static inline ssize_t kshark_load_matrix(struct kshark_context *kshark_ctx,
+					 int sd,
+					 int16_t **cpu_array,
+					 int32_t **pid_array,
+					 int32_t **event_array,
+					 int64_t **offset_array,
+					 int64_t **ts_array)
+{
+	struct kshark_data_stream *stream;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return -EBADF;
+
+	return stream->interface.load_matrix(stream, kshark_ctx, cpu_array,
+								 pid_array,
+								 event_array,
+								 offset_array,
+								 ts_array);
+}
 
 /** Bit masks used to control the visibility of the entry after filtering. */
 enum kshark_filter_masks {
@@ -541,29 +650,68 @@ enum kshark_filter_type {
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
+
+bool kshark_this_filter_is_set(struct kshark_hash_id *filter);
+
+bool kshark_filter_is_set(struct kshark_context *kshark_ctx, int sd);
+
+static inline void unset_event_filter_flag(struct kshark_context *kshark_ctx,
+					   struct kshark_entry *e)
+{
+	/*
+	 * All entries, filtered-out by the event filters, will be treated
+	 * differently, when visualized. Because of this, ignore the value
+	 * of the GRAPH_VIEW flag provided by the user via
+	 * stream->filter_mask. The value of the EVENT_VIEW flag in
+	 * stream->filter_mask will be used instead.
+	 */
+	int event_mask = kshark_ctx->filter_mask & ~KS_GRAPH_VIEW_FILTER_MASK;
+
+	e->visible &= ~event_mask;
+}
 
-bool kshark_this_filter_is_set(struct tracecmd_filter_id *filter);
+void kshark_apply_filters(struct kshark_context *kshark_ctx,
+			  struct kshark_data_stream *stream,
+			  struct kshark_entry *entry);
 
-bool kshark_filter_is_set(struct kshark_context *kshark_ctx);
+void kshark_filter_stream_entries(struct kshark_context *kshark_ctx, int sd,
+				  struct kshark_entry **data,
+				  size_t n_entries);
 
-void kshark_filter_entries(struct kshark_context *kshark_ctx,
-			   struct kshark_entry **data,
-			   size_t n_entries);
+void kshark_filter_all_entries(struct kshark_context *kshark_ctx,
+			       struct kshark_entry **data, size_t n_entries);
 
 void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
 			      struct kshark_entry **data,
 			      size_t n_entries);
 
+void kshark_calib_entry(struct kshark_data_stream *stream,
+			struct kshark_entry *entry);
+
+void kshark_plugin_actions(struct kshark_data_stream *stream,
+			   void *record, struct kshark_entry *entry);
+
+void kshark_postprocess_entry(struct kshark_data_stream *stream,
+			      void *record, struct kshark_entry *entry);
+
 /** Search failed identifiers. */
 enum kshark_search_failed {
-	/** All entries have timestamps greater timestamps. */
+	/** All entries have greater timestamps. */
 	BSEARCH_ALL_GREATER = -1,
 
-	/** All entries have timestamps smaller timestamps. */
+	/** All entries have smaller timestamps. */
 	BSEARCH_ALL_SMALLER = -2,
 };
 
@@ -579,19 +727,26 @@ enum kshark_search_failed {
 		}					\
 	})
 
-ssize_t kshark_find_entry_by_time(uint64_t time,
+ssize_t kshark_find_entry_by_time(int64_t time,
 				  struct kshark_entry **data_rows,
 				  size_t l, size_t h);
 
-ssize_t kshark_find_record_by_time(uint64_t time,
-				   struct tep_record **data_rows,
-				   size_t l, size_t h);
-
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
@@ -609,7 +764,7 @@ bool kshark_match_cpu(struct kshark_context *kshark_ctx,
 /** Matching condition function type. To be user for data requests */
 typedef bool (matching_condition_func)(struct kshark_context*,
 				       struct kshark_entry*,
-				       int);
+				       int, int*);
 
 /**
  * Data request structure, defining the properties of the required
@@ -631,10 +786,13 @@ struct kshark_entry_request {
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
@@ -648,7 +806,7 @@ struct kshark_entry_request {
 
 struct kshark_entry_request *
 kshark_entry_request_alloc(size_t first, size_t n,
-			   matching_condition_func cond, int val,
+			   matching_condition_func cond, int sd, int *values,
 			   bool vis_only, int vis_mask);
 
 void kshark_free_entry_request(struct kshark_entry_request *req);
@@ -665,8 +823,8 @@ kshark_get_entry_back(const struct kshark_entry_request *req,
 
 /**
  * Data collections are used to optimize the search for an entry having an
- * abstract property, defined by a Matching condition function and a value.
- * When a collection is processed, the data which is relevant for the
+ * abstract property, defined by a Matching condition function and an array of
+ * values. When a collection is processed, the data which is relevant for the
  * collection is enclosed in "Data intervals", defined by pairs of "Resume" and
  * "Break" points. It is guaranteed that the data outside of the intervals
  * contains no entries satisfying the abstract matching condition. However, the
@@ -683,11 +841,17 @@ struct kshark_entry_collection {
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
@@ -710,26 +874,30 @@ kshark_add_collection_to_list(struct kshark_context *kshark_ctx,
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
@@ -871,13 +1039,13 @@ bool kshark_export_adv_filters(struct kshark_context *kshark_ctx,
 bool kshark_import_adv_filters(struct kshark_context *kshark_ctx,
 			       struct kshark_config_doc *conf);
 
-bool kshark_export_event_filter(struct tep_handle *pevent,
-				struct tracecmd_filter_id *filter,
+bool kshark_export_event_filter(struct kshark_data_stream *stream,
+				enum kshark_filter_type filter_type,
 				const char *filter_name,
 				struct kshark_config_doc *conf);
 
-int kshark_import_event_filter(struct tep_handle *pevent,
-			       struct tracecmd_filter_id *filter,
+int kshark_import_event_filter(struct kshark_data_stream *stream,
+			       enum kshark_filter_type filter_type,
 			       const char *filter_name,
 			       struct kshark_config_doc *conf);
 
@@ -887,11 +1055,11 @@ bool kshark_export_user_mask(struct kshark_context *kshark_ctx,
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
 
@@ -928,6 +1096,12 @@ struct kshark_config_doc *kshark_open_config_file(const char *file_name,
 
 struct kshark_config_doc *kshark_json_to_conf(struct json_object *jobj);
 
+bool kshark_data_matrix_alloc(size_t n_rows, int16_t **cpu_array,
+					     int32_t **pid_array,
+					     int32_t **event_array,
+					     int64_t **offset_array,
+					     int64_t **ts_array);
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.25.1

