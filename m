Return-Path: <SRS0=pI6O=2G=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D190BC43603
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Dec 2019 13:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90934206A5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 16 Dec 2019 13:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="haEHMyMw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfLPNkR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 08:40:17 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44844 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727609AbfLPNkR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 08:40:17 -0500
Received: by mail-lf1-f68.google.com with SMTP id v201so4232155lfa.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Dec 2019 05:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uO8xw4/iJWUiy3aS3Kl39F+0ALmwvjWvdi1rrkVfC4I=;
        b=haEHMyMw4QNz8CQ+ftJ4gzlHIB9QfMrd3t+UUg5u/T78MsTGumUxQ0SpUGoFf8WoQ+
         CPwXYfrkJ8xYgd0iCnO46jN6I0pCRQ7SLVkFjgCFUbxRBDOXkLSBk9DVQD9PJDJrXAI+
         mrWkjHlREThFXqSHPpmbJWtsQlltbhapBoQ3QS++dhya0ePu/HhBAKZZR9sAi5w4RVOE
         CXIXA+aq1DzTO6fCLNos20M8x+WQoOsaIJZh6MxWrpfC5r0Wt2rMH5gAZb4Oi4+zmtZ6
         /aq3pnR01EMZcDSlOU/SjwgGcSAdqDtSlbEHRoDsGNuwCeFXm9X1YlyHEaE4xDKe8lL1
         7udQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uO8xw4/iJWUiy3aS3Kl39F+0ALmwvjWvdi1rrkVfC4I=;
        b=c3R05jbrrogT+t2hNepXBNdEOVr9gPQcbdWymHBHe7lFemOyqUxTYv0ixxx6B+QulP
         9CCgVykes0OLqtUycFI20IX0SbvcFfgDpF9/bc2D3K96BB+qSoBafJggrdiJ9EepV7K3
         U3jj8OrK/QzO1izeNcfC/WKlZaeJgRHc5fBuDb8FHb5pWUITJRmbAkR0aVwtn8Qb0ogF
         QeDSNRHynSBmn/1zkIpJXKXrBE8k40rT03qTMtd5sobUMPW50Kw3Q4S9BxFILbKrEdQ6
         WeOdhxlbgcg8/MbMchDH/q9vBldLRYTknlSWZFPlkE6xiVo53KprYl3Z2vOeYhwhK45i
         jFNw==
X-Gm-Message-State: APjAAAW/HS2M6e2sKKOIhvn/YVZabk0x9SLbe9yRV/TU+UH+SPWR5vKa
        8tdER3r5BQCB75d2zqiWKEgW19gA
X-Google-Smtp-Source: APXvYqxxGF+uvmACq+BDMxilCeBKpQakVbzzp/fKYRWmtJZDX2GHKlYCwbzwAVPZuTQwFG68jis4AA==
X-Received: by 2002:ac2:54b5:: with SMTP id w21mr16387234lfk.175.1576503614401;
        Mon, 16 Dec 2019 05:40:14 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 204sm7506118lfj.47.2019.12.16.05.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 05:40:13 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/3] kernel-shark: Simplify the way collections handle data requests
Date:   Mon, 16 Dec 2019 15:39:15 +0200
Message-Id: <20191216133917.31690-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch initially intended to fix one potential memory leak in
libkshark-collection. However, as pointed out by Steven in his review
of the previous version, there is no need to carrying the address of
the pointer of the original data requests trough the entire procedure
of searching for a data entry. Instead we can always use copies of the
pointer and rely on the fact that the entire list of data requests will
be anyway freed at the end, regardless of the success or the failure of
the search.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/libkshark-collection.c | 114 ++++++++++++------------
 kernel-shark/src/libkshark-model.c      |  10 +--
 kernel-shark/src/libkshark.h            |   4 +-
 3 files changed, 62 insertions(+), 66 deletions(-)

diff --git a/kernel-shark/src/libkshark-collection.c b/kernel-shark/src/libkshark-collection.c
index 02a014e..66cdbca 100644
--- a/kernel-shark/src/libkshark-collection.c
+++ b/kernel-shark/src/libkshark-collection.c
@@ -308,29 +308,28 @@ map_collection_index_from_source(const struct kshark_entry_collection *col,
 
 static ssize_t
 map_collection_request_init(const struct kshark_entry_collection *col,
-			    struct kshark_entry_request **req,
+			    struct kshark_entry_request *req,
 			    bool front, size_t *end)
 {
-	struct kshark_entry_request *req_tmp = *req;
 	int col_index_flag;
 	ssize_t col_index;
 	size_t req_end;
 
-	if (req_tmp->next || col->size == 0) {
+	if (req->next || col->size == 0) {
 		fprintf(stderr, "Unexpected input in ");
 		fprintf(stderr, "map_collection_request_init()\n");
 		goto do_nothing;
 	}
 
-	req_end = front ? req_tmp->first + req_tmp->n - 1 :
-			  req_tmp->first - req_tmp->n + 1;
+	req_end = front ? req->first + req->n - 1 :
+			  req->first - req->n + 1;
 
 	/*
 	 * Find the first Resume Point of the collection which is equal or
 	 * greater than the first index of this request.
 	 */
 	col_index = map_collection_index_from_source(col,
-						     req_tmp->first,
+						     req->first,
 						     &col_index_flag);
 
 	/*
@@ -370,8 +369,8 @@ map_collection_request_init(const struct kshark_entry_collection *col,
 		 * going backwards, so the proper place to start will be the
 		 * Break point of "col_index".
 		 */
-		req_tmp->first = front ? col->resume_points[++col_index] :
-					 col->break_points[col_index];
+		req->first = front ? col->resume_points[++col_index] :
+				     col->break_points[col_index];
 	}
 
 	if (col_index_flag == COLLECTION_BEFORE) {
@@ -403,8 +402,8 @@ map_collection_request_init(const struct kshark_entry_collection *col,
 		 * backwards, so the proper place to start will be the Break
 		 * point of "col_index - 1".
 		 */
-		req_tmp->first = front ? col->resume_points[col_index] :
-					 col->break_points[--col_index];
+		req->first = front ? col->resume_points[col_index] :
+				     col->break_points[--col_index];
 	}
 
 	*end = req_end;
@@ -412,8 +411,6 @@ map_collection_request_init(const struct kshark_entry_collection *col,
 	return col_index;
 
 do_nothing:
-	kshark_free_entry_request(*req);
-	*req = NULL;
 	*end = KS_EMPTY_BIN;
 
 	return KS_EMPTY_BIN;
@@ -426,9 +423,8 @@ do_nothing:
  */
 static int
 map_collection_back_request(const struct kshark_entry_collection *col,
-			    struct kshark_entry_request **req)
+			    struct kshark_entry_request *req)
 {
-	struct kshark_entry_request *req_tmp;
 	size_t req_first, req_end;
 	ssize_t col_index;
 	int req_count;
@@ -442,7 +438,6 @@ map_collection_back_request(const struct kshark_entry_collection *col,
 	 * the end of the inputted request and create a separate request for
 	 * each of those interest.
 	 */
-	req_tmp = *req;
 	req_count = 1;
 	while (col_index >= 0 && req_end <= col->break_points[col_index]) {
 		if (req_end >= col->resume_points[col_index]) {
@@ -451,7 +446,7 @@ map_collection_back_request(const struct kshark_entry_collection *col,
 			 * the "col_index" collection interval. Close the
 			 * collection request here and return.
 			 */
-			req_tmp->n = req_tmp->first - req_end + 1;
+			req->n = req->first - req_end + 1;
 			break;
 		}
 
@@ -461,8 +456,8 @@ map_collection_back_request(const struct kshark_entry_collection *col,
 		 * end of this interval and move to the next one. Try to make
 		 * another request there.
 		 */
-		req_tmp->n = req_tmp->first -
-		             col->resume_points[col_index] + 1;
+		req->n = req->first -
+			 col->resume_points[col_index] + 1;
 
 		--col_index;
 
@@ -478,18 +473,18 @@ map_collection_back_request(const struct kshark_entry_collection *col,
 			/* Make a new request. */
 			req_first = col->break_points[col_index];
 
-			req_tmp->next =
+			req->next =
 				kshark_entry_request_alloc(req_first,
 							   0,
-							   req_tmp->cond,
-							   req_tmp->val,
-							   req_tmp->vis_only,
-							   req_tmp->vis_mask);
+							   req->cond,
+							   req->val,
+							   req->vis_only,
+							   req->vis_mask);
 
-			if (!req_tmp->next)
+			if (!req->next)
 				goto fail;
 
-			req_tmp = req_tmp->next;
+			req = req->next;
 			++req_count;
 		}
 	}
@@ -497,10 +492,9 @@ map_collection_back_request(const struct kshark_entry_collection *col,
 	return req_count;
 
 fail:
-	fprintf(stderr, "Failed to allocate memory for ");
-	fprintf(stderr, "Collection data request.\n");
-	kshark_free_entry_request(*req);
-	*req = NULL;
+	fprintf(stderr,
+		"Failed to allocate memory for Collection data request.\n");
+
 	return -ENOMEM;
 }
 
@@ -511,9 +505,8 @@ fail:
  */
 static int
 map_collection_front_request(const struct kshark_entry_collection *col,
-			     struct kshark_entry_request **req)
+			     struct kshark_entry_request *req)
 {
-	struct kshark_entry_request *req_tmp;
 	size_t req_first, req_end;
 	ssize_t col_index;
 	int req_count;
@@ -528,7 +521,6 @@ map_collection_front_request(const struct kshark_entry_collection *col,
 	 * each of those interest.
 	 */
 	req_count = 1;
-	req_tmp = *req;
 	while (col_index < col->size &&
 	       req_end >= col->resume_points[col_index]) {
 		if (req_end <= col->break_points[col_index]) {
@@ -537,7 +529,7 @@ map_collection_front_request(const struct kshark_entry_collection *col,
 			 * the "col_index" collection interval.
 			 * Close the collection request here and return.
 			 */
-			req_tmp->n = req_end - req_tmp->first + 1;
+			req->n = req_end - req->first + 1;
 			break;
 		}
 
@@ -547,8 +539,8 @@ map_collection_front_request(const struct kshark_entry_collection *col,
 		 * request at the end of the interval and move to the next
 		 * interval. Try to make another request there.
 		 */
-		req_tmp->n = col->break_points[col_index] -
-			     req_tmp->first + 1;
+		req->n = col->break_points[col_index] -
+			 req->first + 1;
 
 		++col_index;
 
@@ -565,18 +557,18 @@ map_collection_front_request(const struct kshark_entry_collection *col,
 			/* Make a new request. */
 			req_first = col->resume_points[col_index];
 
-			req_tmp->next =
+			req->next =
 				kshark_entry_request_alloc(req_first,
 							   0,
-							   req_tmp->cond,
-							   req_tmp->val,
-							   req_tmp->vis_only,
-							   req_tmp->vis_mask);
+							   req->cond,
+							   req->val,
+							   req->vis_only,
+							   req->vis_mask);
 
-			if (!req_tmp->next)
+			if (!req->next)
 				goto fail;
 
-			req_tmp = req_tmp->next;
+			req = req->next;
 			++req_count;
 		}
 	}
@@ -584,10 +576,9 @@ map_collection_front_request(const struct kshark_entry_collection *col,
 	return req_count;
 
 fail:
-	fprintf(stderr, "Failed to allocate memory for ");
-	fprintf(stderr, "Collection data request.\n");
-	kshark_free_entry_request(*req);
-	*req = NULL;
+	fprintf(stderr,
+		"Failed to allocate memory for Collection data request.\n");
+
 	return -ENOMEM;
 }
 
@@ -616,7 +607,7 @@ fail:
  *	    "Dummy entry".
  */
 const struct kshark_entry *
-kshark_get_collection_entry_front(struct kshark_entry_request **req,
+kshark_get_collection_entry_front(struct kshark_entry_request *req,
 				  struct kshark_entry **data,
 				  const struct kshark_entry_collection *col,
 				  ssize_t *index)
@@ -624,26 +615,28 @@ kshark_get_collection_entry_front(struct kshark_entry_request **req,
 	const struct kshark_entry *entry = NULL;
 	int req_count;
 
+	if (index)
+		*index = KS_EMPTY_BIN;
+
 	/*
 	 * Use the intervals of the Data collection to redefine the data
 	 * request in a way which will ignore the data outside of the
 	 * intervals of the collection.
 	 */
 	req_count = map_collection_front_request(col, req);
-
-	if (index && !req_count)
-		*index = KS_EMPTY_BIN;
+	if (req_count <= 0)
+		return NULL;
 
 	/*
 	 * Loop over the list of redefined requests and search until you find
 	 * the first matching entry.
 	 */
-	while (*req) {
-		entry = kshark_get_entry_front(*req, data, index);
+	while (req) {
+		entry = kshark_get_entry_front(req, data, index);
 		if (entry)
 			break;
 
-		*req = (*req)->next;
+		req = req->next;
 	}
 
 	return entry;
@@ -674,7 +667,7 @@ kshark_get_collection_entry_front(struct kshark_entry_request **req,
  *	    "Dummy entry".
  */
 const struct kshark_entry *
-kshark_get_collection_entry_back(struct kshark_entry_request **req,
+kshark_get_collection_entry_back(struct kshark_entry_request *req,
 				 struct kshark_entry **data,
 				 const struct kshark_entry_collection *col,
 				 ssize_t *index)
@@ -682,25 +675,28 @@ kshark_get_collection_entry_back(struct kshark_entry_request **req,
 	const struct kshark_entry *entry = NULL;
 	int req_count;
 
+	if (index)
+		*index = KS_EMPTY_BIN;
+
 	/*
 	 * Use the intervals of the Data collection to redefine the data
 	 * request in a way which will ignore the data outside of the
 	 * intervals of the collection.
 	 */
 	req_count = map_collection_back_request(col, req);
-	if (index && !req_count)
-		*index = KS_EMPTY_BIN;
+	if (req_count <= 0)
+		return NULL;
 
 	/*
 	 * Loop over the list of redefined requests and search until you find
 	 * the first matching entry.
 	 */
-	while (*req) {
-		entry = kshark_get_entry_back(*req, data, index);
+	while (req) {
+		entry = kshark_get_entry_back(req, data, index);
 		if (entry)
 			break;
 
-		*req = (*req)->next;
+		req = req->next;
 	}
 
 	return entry;
diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index 6c54e1e..babac2a 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -918,7 +918,7 @@ ksmodel_get_entry_front(struct kshark_trace_histo *histo,
 		return NULL;
 
 	if (col && col->size)
-		entry = kshark_get_collection_entry_front(&req, histo->data,
+		entry = kshark_get_collection_entry_front(req, histo->data,
 							  col, index);
 	else
 		entry = kshark_get_entry_front(req, histo->data, index);
@@ -965,8 +965,8 @@ ksmodel_get_entry_back(struct kshark_trace_histo *histo,
 		return NULL;
 
 	if (col && col->size)
-		entry = kshark_get_collection_entry_back(&req, histo->data,
-							  col, index);
+		entry = kshark_get_collection_entry_back(req, histo->data,
+							 col, index);
 	else
 		entry = kshark_get_entry_back(req, histo->data, index);
 
@@ -1178,7 +1178,7 @@ bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
 	req->vis_mask = KS_EVENT_VIEW_FILTER_MASK;
 
 	if (col && col->size)
-		entry = kshark_get_collection_entry_front(&req, histo->data,
+		entry = kshark_get_collection_entry_front(req, histo->data,
 							  col, index);
 	else
 		entry = kshark_get_entry_front(req, histo->data, index);
@@ -1231,7 +1231,7 @@ bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
 	req->vis_mask = KS_EVENT_VIEW_FILTER_MASK;
 
 	if (col && col->size)
-		entry = kshark_get_collection_entry_front(&req, histo->data,
+		entry = kshark_get_collection_entry_front(req, histo->data,
 							  col, index);
 	else
 		entry = kshark_get_entry_front(req, histo->data, index);
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
index 3407db1..3b027c2 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -445,13 +445,13 @@ void kshark_reset_data_collection(struct kshark_entry_collection *col);
 void kshark_free_collection_list(struct kshark_entry_collection *col);
 
 const struct kshark_entry *
-kshark_get_collection_entry_front(struct kshark_entry_request **req,
+kshark_get_collection_entry_front(struct kshark_entry_request *req,
 				  struct kshark_entry **data,
 				  const struct kshark_entry_collection *col,
 				  ssize_t *index);
 
 const struct kshark_entry *
-kshark_get_collection_entry_back(struct kshark_entry_request **req,
+kshark_get_collection_entry_back(struct kshark_entry_request *req,
 				 struct kshark_entry **data,
 				 const struct kshark_entry_collection *col,
 				 ssize_t *index);
-- 
2.20.1

