Return-Path: <SRS0=D2WB=J3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:54224 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388038AbeGKNnh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Jul 2018 09:43:37 -0400
Received: by mail-wm0-f68.google.com with SMTP id b188-v6so2486798wme.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Jul 2018 06:39:10 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/6] kernel-shark-qt: Define Data collections
Date: Wed, 11 Jul 2018 16:38:12 +0300
Message-Id: <20180711133814.26854-5-y.karadz@gmail.com>
In-Reply-To: <20180711133814.26854-1-y.karadz@gmail.com>
References: <20180711133814.26854-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Data collections are used to optimize the search for an entry having
an abstract property, defined by a Matching condition function and a
value. When a collection is processed, the data which is relevant for
the collection is enclosed in "Data intervals", defined by pairs of
"Resume" and "Break" points. It is guaranteed that the data outside of
the intervals contains no entries satisfying the abstract matching
condition. Once defined, the Data collection can be used when searching
for an entry having the same abstract property. The collection allows to
ignore the irrelevant data, thus it eliminates the linear worst-case time
complexity of the search.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/CMakeLists.txt         |   3 +-
 kernel-shark-qt/src/libkshark-collection.c | 719 +++++++++++++++++++++
 kernel-shark-qt/src/libkshark.c            |  16 +
 kernel-shark-qt/src/libkshark.h            |  79 +++
 4 files changed, 816 insertions(+), 1 deletion(-)
 create mode 100644 kernel-shark-qt/src/libkshark-collection.c

diff --git a/kernel-shark-qt/src/CMakeLists.txt b/kernel-shark-qt/src/CMakeLists.txt
index ec22f63..cd42920 100644
--- a/kernel-shark-qt/src/CMakeLists.txt
+++ b/kernel-shark-qt/src/CMakeLists.txt
@@ -2,7 +2,8 @@ message("\n src ...")
 
 message(STATUS "libkshark")
 add_library(kshark SHARED libkshark.c
-                          libkshark-model.c)
+                          libkshark-model.c
+                          libkshark-collection.c)
 
 target_link_libraries(kshark ${CMAKE_DL_LIBS}
                              ${TRACEEVENT_LIBRARY}
diff --git a/kernel-shark-qt/src/libkshark-collection.c b/kernel-shark-qt/src/libkshark-collection.c
new file mode 100644
index 0000000..2051bcd
--- /dev/null
+++ b/kernel-shark-qt/src/libkshark-collection.c
@@ -0,0 +1,719 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2018 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+ /**
+  *  @file    libkshark-collection.c
+  *  @brief   Data Collections.
+  */
+
+//C
+#include <stdbool.h>
+#include <stdlib.h>
+#include <assert.h>
+
+// KernelShark
+#include "libkshark.h"
+
+/* Quiet warnings over documenting simple structures */
+//! @cond Doxygen_Suppress
+
+enum collection_point_type {
+	COLLECTION_RESUME,
+	COLLECTION_BREAK,
+	COLLECTION_IGNORE,
+};
+
+#define LAST_BIN		-3
+
+struct entry_list {
+	struct entry_list	*next;
+	size_t			index;
+	uint8_t			type;
+};
+
+//! @endcond
+
+static void collection_add_entry(struct entry_list **list,
+				 size_t i, uint8_t type)
+{
+	if ((*list)->type != COLLECTION_IGNORE) {
+		(*list)->next = malloc(sizeof(**list));
+		assert((*list)->next != NULL);
+		*list = (*list)->next;
+	}
+
+	(*list)->index = i;
+	(*list)->type = type;
+}
+
+static struct kshark_entry_collection *
+kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
+			     struct kshark_entry **data,
+			     size_t first,
+			     size_t n_rows,
+			     matching_condition_func cond,
+			     int val,
+			     size_t margin)
+{
+	struct entry_list *col_list = malloc(sizeof(*col_list));
+	struct kshark_entry *last_vis_entry = NULL;
+	struct kshark_entry_collection *col_ptr;
+	struct entry_list *temp = col_list;
+	size_t resume_count = 0, break_count = 0;
+	size_t i, j, end, last_added = 0;
+	bool good = false;
+
+	if (margin != 0) {
+		temp->index = first;
+		temp->type = COLLECTION_RESUME;
+		++resume_count;
+
+		collection_add_entry(&temp, first + margin - 1, COLLECTION_BREAK);
+		++break_count;
+	} else {
+		temp->type = COLLECTION_IGNORE;
+	}
+
+	end = first + n_rows - margin;
+	for (i = first + margin; i < end; ++i) {
+		if (!good && !cond(kshark_ctx, data[i], val)) {
+			/*
+			 * The entry is irrelevant for this collection.
+			 * Do nothing.
+			 */
+			continue;
+		}
+
+		if (!good && cond(kshark_ctx, data[i], val)) {
+			/*
+			 * Resume the collection here. Add some margin data
+			 * in front of the data of interest.
+			 */
+			good = true;
+			if (last_added == 0 || last_added < i - margin) {
+				collection_add_entry(&temp, i - margin,
+						 COLLECTION_RESUME);
+				++resume_count;
+			} else {
+				/* Ignore the last collection Brack point. */
+				temp->type = COLLECTION_IGNORE;
+				--break_count;
+			}
+		} else if (good &&
+			   cond(kshark_ctx, data[i], val) &&
+			   data[i]->next &&
+			   !cond(kshark_ctx, data[i]->next, val)) {
+			/*
+			 * Brack the collection here. Add some margin data
+			 * after the data of interest.
+			 */
+			good = false;
+			last_vis_entry = data[i];
+
+			/* Keep adding entries until the "next" record. */
+			j = i;
+			do {
+				++j;
+				if (j == end)
+					break;
+			} while  (last_vis_entry->next != data[j]);
+
+			/*
+			 * If the number of added entryes is smaller then the
+			 * number of margin entries requested, keep adding
+			 * until you fill the margin.
+			 */
+			if (i + margin < j)
+				i = j;
+			else
+				i += margin;
+
+			last_added = i;
+			collection_add_entry(&temp, i, COLLECTION_BREAK);
+			++break_count;
+		}
+	}
+
+	if (good) {
+		collection_add_entry(&temp, i, COLLECTION_BREAK);
+		++break_count;
+	}
+
+	if (margin != 0) {
+		collection_add_entry(&temp, first + n_rows - margin,
+				 COLLECTION_RESUME);
+
+		++resume_count;
+
+		collection_add_entry(&temp, first + n_rows,
+				 COLLECTION_BREAK);
+
+		++break_count;
+	}
+
+	/* Create the collection. */
+	col_ptr = malloc(sizeof(*col_ptr));
+	col_ptr->next = NULL;
+
+	col_ptr->resume_points = calloc(resume_count,
+					sizeof(*col_ptr->resume_points));
+
+	col_ptr->break_points = calloc(break_count,
+				       sizeof(*col_ptr->break_points));
+
+	col_ptr->cond = cond;
+	col_ptr->val = val;
+
+	/*
+	 * If everything is OK, we must have pairs of COLLECTION_RESUME
+	 * and COLLECTION_BREAK points.
+	 */
+	assert(break_count == resume_count);
+	col_ptr->size = resume_count;
+	for (i = 0; i < col_ptr->size; ++i) {
+		assert(col_list->type == COLLECTION_RESUME);
+		col_ptr->resume_points[i] = col_list->index;
+		temp = col_list;
+		col_list = col_list->next;
+		free(temp);
+
+		assert(col_list->type == COLLECTION_BREAK);
+		col_ptr->break_points[i] = col_list->index;
+		temp = col_list;
+		col_list = col_list->next;
+		free(temp);
+	}
+
+	return col_ptr;
+}
+
+static ssize_t
+map_collection_index_from_source(const struct kshark_entry_collection *col,
+				 size_t source_index)
+{
+	size_t l, h, mid;
+
+	if (!col->size || source_index > col->break_points[col->size - 1])
+		return KS_EMPTY_BIN;
+
+	l = 0;
+	h = col->size - 1;
+	if (source_index < col->resume_points[0])
+		return l;
+
+	if (source_index > col->resume_points[col->size - 1])
+		return LAST_BIN;
+
+	while (h - l > 1) {
+		mid = (l + h) / 2;
+		if (source_index > col->resume_points[mid])
+			l = mid;
+		else
+			h = mid;
+	}
+
+	return h;
+}
+
+static int
+map_collection_back_request(const struct kshark_entry_collection *col,
+			    struct kshark_entry_request **req)
+{
+	struct kshark_entry_request *req_tmp = *req;
+	size_t req_end = req_tmp->first - req_tmp->n + 1;
+	ssize_t col_index;
+	int req_count;
+
+	/*
+	 * Find the first Resume Point of the collection which is equal or
+	 * greater than the first index of this request.
+	 */
+	col_index = map_collection_index_from_source(col, req_tmp->first);
+
+	/*
+	 * The value of "col_index" is ambiguous. Deal with all possible
+	 * cases.
+	 */
+	if (col_index == KS_EMPTY_BIN) {
+		/*
+		 * No overlap between the request and the collection.
+		 * Do nothing.
+		 */
+		kshark_free_entry_request(*req);
+		*req = NULL;
+		return 0;
+	}
+
+	if (col_index == 0) {
+		if (req_tmp->first == col->resume_points[col_index]) {
+			/*
+			 * This is a special case. Because this is Back
+			 * Request, if the beginning of this request is at
+			 * the Resume Point of the interval, then there is
+			 * only one possible entry, to look into.
+			 */
+			req_tmp->n = 1;
+			return 1;
+		}
+
+		/*
+		 * No overlap between the request and the collection.
+		 * Do nothing.
+		 */
+		kshark_free_entry_request(*req);
+		*req = NULL;
+		return 0;
+	} else if (col_index > 0) {
+		/*
+		 * This is Back Request, so the "col_index" interval of the
+		 * collection is guaranteed to be outside the requested data,
+		 * except in one special case.
+		 */
+		if (req_tmp->first == col->resume_points[col_index]) {
+			/*
+			 * We still have to check the very first entry of the
+			 * "col_index" interval.
+			 */
+			if (req_end > col->break_points[col_index - 1]) {
+				/*
+				 * There is only one possible entry, to look
+				 * into.
+				 */
+				req_tmp->n = 1;
+				return 1;
+			}
+		}  else {
+			/* Move to the previous interval of the collection. */
+			--col_index;
+
+			if (req_tmp->first > col->break_points[col_index]) {
+				req_tmp->first = col->break_points[col_index];
+			}
+		}
+	} else if (col_index == LAST_BIN) {
+		col_index = col->size - 1;
+	}
+
+	/*
+	 * Now loop over the intervals of the collection going backwords
+	 * and create a separate request for each of those interest.
+	 */
+	req_count = 1;
+	while (req_end <= col->break_points[col_index] &&
+	       col_index >= 0) {
+		if (req_end >= col->resume_points[col_index]) {
+			/*
+			 * The last entry of the original request is inside
+			 * the "col_index" collection interval. Close the
+			 * collection request here and return.
+			 */
+			req_tmp->n = req_tmp->first - req_end + 1;
+			break;
+		}
+
+		/*
+		 * The last entry of the original request is outside this
+		 * collection interval (col_index). Close the collection
+		 * request at the end of the interval and move to the next
+		 * interval. Try to make another request there.
+		 */
+		req_tmp->n = req_tmp->first -
+		             col->resume_points[col_index] + 1;
+
+		--col_index;
+
+		if (req_end > col->break_points[col_index]) {
+			/*
+			 * The last entry of the original request comes berofe
+			 * the next collection interval. Stop here.
+			 */
+			break;
+		}
+
+		if (col_index > 0) {
+			/* Make a new request. */
+			req_tmp->next = malloc(sizeof(*req_tmp->next));
+			req_tmp = req_tmp->next;
+			req_tmp->next = NULL;
+			req_tmp->first = col->break_points[col_index];
+			++req_count;
+		}
+	}
+
+	return req_count;
+}
+
+static int
+map_collection_front_request(const struct kshark_entry_collection *col,
+			     struct kshark_entry_request **req)
+{
+	struct kshark_entry_request *req_tmp = *req;
+	size_t req_first, req_end;
+	ssize_t col_index;
+	int req_count;
+
+	/*
+	 * Find the first Resume Point of the collection which is equal or
+	 * greater than the first index of this request.
+	 */
+	req_end = req_tmp->first + req_tmp->n - 1;
+	col_index = map_collection_index_from_source(col, req_tmp->first);
+
+	/*
+	 * The value of "col_index" is ambiguous. Deal with all possible
+	 * cases.
+	 */
+	if (col_index == KS_EMPTY_BIN) {
+		/*
+		 * No overlap between the request and the collection.
+		 * Do nothing.
+		 */
+		kshark_free_entry_request(*req);
+		*req = NULL;
+		return 0;
+	}
+
+	if (col_index == 0) {
+		if (col->resume_points[col_index] > req_end) {
+			/*
+			 * No overlap between the request and the collection.
+			 * Do nothing.
+			 */
+			kshark_free_entry_request(*req);
+			*req = NULL;
+			return 0;
+		}
+
+		/*
+		 * The request overlaps with the "col_index" interval of the
+		 * collection. Start from here, using the Resume Point of
+		 * the interval as begining of the request.
+		 */
+		req_tmp->first = col->resume_points[col_index];
+	} else if (col_index > 0) {
+		if (req_end < col->resume_points[col_index] &&
+		    req_tmp->first > col->break_points[col_index - 1]) {
+			/*
+			 * No overlap between the request and the collection.
+			 * Do nothing.
+			 */
+			kshark_free_entry_request(*req);
+			*req = NULL;
+			return 0;
+		}
+
+		if (req_tmp->first <= col->break_points[col_index - 1]) {
+			/*
+			 * The begining of this request is inside the previous
+			 * interval of the collection. Start from there and
+			 * keep the original begining point.
+			 */
+			--col_index;
+		} else {
+			/*
+			 * The request overlaps with the "col_index" interval
+			 * of the collection. Start from here, using the Resume
+			 * Point of the interval as begining of the request.
+			 */
+			req_tmp->first = col->resume_points[col_index];
+		}
+	} else if (col_index == LAST_BIN) {
+		col_index = col->size - 1;
+	}
+
+	/*
+	 * Now loop over the intervals of the collection going forwards
+	 * and create a separate request for each of those interest.
+	 */
+	req_count = 1;
+	while (req_end >= col->resume_points[col_index] &&
+	       col_index < col->size) {
+		if (req_end <= col->break_points[col_index]) {
+			/*
+			 * The last entry of the original request is inside
+			 * the "col_index" collection interval.
+			 * Close the collection request here and return.
+			 */
+			req_tmp->n = req_end - req_tmp->first + 1;
+			break;
+		}
+
+		/*
+		 * The last entry of the original request is outside this
+		 * collection interval (col_index). Close the collection
+		 * request at the end of the interval and move to the next
+		 * interval. Try to make another request there.
+		 */
+		req_tmp->n = col->break_points[col_index] -
+			     req_tmp->first + 1;
+
+		++col_index;
+
+		if (req_end < col->resume_points[col_index]) {
+			/*
+			 * The last entry of the original request comes berofe
+			 * the begining of next collection interval. Stop here.
+			 */
+			break;
+		}
+
+		if (col_index < col->size) {
+			/* Make a new request. */
+			req_first = col->resume_points[col_index];
+
+			req_tmp->next =
+				kshark_entry_request_alloc(req_first,
+							   0,
+							   req_tmp->cond,
+							   req_tmp->val,
+							   req_tmp->vis_only,
+							   req_tmp->vis_mask);
+
+			req_tmp = req_tmp->next;
+			++req_count;
+		}
+	}
+
+	return req_count;
+}
+
+/**
+ * @brief Search for an entry satisfying the requirements of a given Data
+ *	  request. Start from the position provided by the request and go
+ *	  searching in the direction of the increasing timestamps (front).
+ *	  The search is performed only inside the intervals, defined by
+ *	  the data collection.
+ * @param req: Input location for Data request.
+ * @param data: Intput location for the trace data.
+ * @param col: Intput location for the Data collection.
+ * @param index: Optional output location for the index of the returned
+ *		 entry inside the array.
+ * @returns Pointer to the first entry satisfying the matching condition on
+ *	    success, or NULL on failure.
+ *	    In the special case when some entries, satisfying the Matching
+ *	    condition function have been found, but all these entries have
+ *	    been discarded because of the visibility criteria (filtered
+ *	    entries), the function returns a pointer to a special
+ *	    "Dummy entry".
+ */
+const struct kshark_entry *
+kshark_get_collection_entry_front(struct kshark_entry_request **req,
+				  struct kshark_entry **data,
+				  const struct kshark_entry_collection *col,
+				  ssize_t *index)
+{
+	const struct kshark_entry *entry = NULL;
+	int req_count;
+
+	/*
+	 * Use the intervals of the Data collection to redefine the data
+	 * request in a way which will ignore the data outside of the
+	 * intervals of the collection.
+	 */
+	req_count = map_collection_front_request(col, req);
+
+	if (index && !req_count)
+		*index = KS_EMPTY_BIN;
+
+	/*
+	 * Loop over the list of redefined requests and search until you find
+	 * the first matching entry.
+	 */
+	while (*req) {
+		entry = kshark_get_entry_front(*req, data, index);
+		if (entry)
+			break;
+
+		*req = (*req)->next;
+	}
+
+	return entry;
+}
+
+/**
+ * @brief Search for an entry satisfying the requirements of a given Data
+ *	  request. Start from the position provided by the request and go
+ *	  searching in the direction of the decreasing timestamps (back).
+ *	  The search is performed only inside the intervals, defined by
+ *	  the data collection.
+ * @param req: Input location for Data request.
+ * @param data: Intput location for the trace data.
+ * @param col: Intput location for the Data collection.
+ * @param index: Optional output location for the index of the returned
+ *		 entry inside the array.
+ * @returns Pointer to the first entry satisfying the matching condition on
+ *	    success, or NULL on failure.
+ *	    In the special case when some entries, satisfying the Matching
+ *	    condition function have been found, but all these entries have
+ *	    been discarded because of the visibility criteria (filtered
+ *	    entries), the function returns a pointer to a special
+ *	    "Dummy entry".
+ */
+const struct kshark_entry *
+kshark_get_collection_entry_back(struct kshark_entry_request **req,
+				 struct kshark_entry **data,
+				 const struct kshark_entry_collection *col,
+				 ssize_t *index)
+{
+	const struct kshark_entry *entry = NULL;
+	int req_count;
+
+	/*
+	 * Use the intervals of the Data collection to redefine the data
+	 * request in a way which will ignore the data outside of the
+	 * intervals of the collection.
+	 */
+	req_count = map_collection_back_request(col, req);
+
+	if (index && !req_count)
+		*index = KS_EMPTY_BIN;
+
+	/*
+	 * Loop over the list of redefined requests and search until you find
+	 * the first matching entry.
+	 */
+	while (*req) {
+		entry = kshark_get_entry_back(*req, data, index);
+		if (entry)
+			break;
+
+		*req = (*req)->next;
+	}
+
+	return entry;
+}
+
+/**
+ * @brief Search the list of Data collections and find the collection defined
+ *	  with a given Matching condition function and value.
+ * @param col: Intput location for the Data collection list.
+ * @param cond: Matching condition function.
+ * @param val: Matching condition value, used by the Matching condition
+ *	       function.
+ * @returns Pointer to a Data collections on success, or NULL on failure.
+ */
+struct kshark_entry_collection *
+kshark_find_data_collection(struct kshark_entry_collection *col,
+			    matching_condition_func cond,
+			    int val)
+{
+	while (col) {
+		if (col->cond == cond && col->val == val)
+			return col;
+
+		col = col->next;
+	}
+
+	return NULL;
+}
+
+/**
+ * @brief Clear all data intervals of the given Data collection.
+ * @param col: Intput location for the Data collection.
+ */
+void kshark_reset_data_collection(struct kshark_entry_collection *col)
+{
+	free(col->resume_points);
+	col->resume_points = NULL;
+
+	free(col->break_points);
+	col->break_points = NULL;
+
+	col->size = 0;
+}
+
+static void kshark_free_data_collection(struct kshark_entry_collection *col)
+{
+	if (col->size) {
+		free(col->resume_points);
+		free(col->break_points);
+	}
+
+	free(col);
+}
+
+/**
+ * @brief Allocate and process data collection, defined with a given Matching
+ *	  condition function and value. Add this collection to the list of
+ *	  collections used by the session.
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param data: Input location for the trace data.
+ * @param n_rows: The size of the inputted data.
+ * @param cond: Matching condition function for the collection to be
+ *	        registered.
+ * @param val: Matching condition value of for collection to be registered.
+ * @param margin: The size of the additional (margin) data which do not
+ *		  satisfying the data condition, but is added at the beginning
+ *		  and at the end of each interval of the collection. If "0",
+ *		  no margin data is added.
+ * @returns Pointer to the registered Data collections on success, or NULL
+ *	    on failure.
+ */
+struct kshark_entry_collection *
+kshark_register_data_collection(struct kshark_context *kshark_ctx,
+				struct kshark_entry **data,
+				size_t n_rows,
+				matching_condition_func cond,
+				int val,
+				size_t margin)
+{
+	struct kshark_entry_collection *col;
+
+	col = kshark_data_collection_alloc(kshark_ctx, data,
+					   0, n_rows,
+					   cond, val,
+					   margin);
+	if (!col)
+		return NULL;
+
+	col->next = kshark_ctx->collections;
+	kshark_ctx->collections = col;
+
+	return col;
+}
+
+/**
+ * @brief Search the list of Data collections for a collection defined
+ *	  with a given Matching condition function and value. If such a
+ *	  collection exists, unregister (remove and free) this collection
+ *	  from the list.
+ * @param col: Intput location for the Data collection list.
+ * @param cond: Matching condition function of the collection to be
+ *	        unregistered.
+ * @param val: Matching condition value of the collection to be unregistered.
+ */
+void kshark_unregister_data_collection(struct kshark_entry_collection **col,
+				       matching_condition_func cond,
+				       int val)
+{
+	struct kshark_entry_collection **last = col;
+	struct kshark_entry_collection *list;
+
+	for (list = *col; list; list = list->next) {
+		if (list->cond == cond && list->val == val) {
+			*last = list->next;
+			kshark_free_data_collection(list);
+			return;
+		}
+
+		last = &list->next;
+	}
+}
+
+/**
+ * @brief Free all Data collections in a given list.
+ * @param col: Intput location for the Data collection list.
+ */
+void kshark_free_collection_list(struct kshark_entry_collection *col)
+{
+	struct kshark_entry_collection *last;
+
+	while (col) {
+		last = col;
+		col = col->next;
+		kshark_free_data_collection(last);
+	}
+}
diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index b79d0ac..c1fdcf0 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -1038,6 +1038,7 @@ kshark_entry_request_alloc(size_t first, size_t n,
 		return NULL;
 	}
 
+	req->next = NULL;
 	req->first = first;
 	req->n = n;
 	req->cond = cond;
@@ -1048,6 +1049,21 @@ kshark_entry_request_alloc(size_t first, size_t n,
 	return req;
 }
 
+/**
+ * @brief Free all Data requests in a given list.
+ * @param req: Intput location for the Data request list.
+ */
+void kshark_free_entry_request(struct kshark_entry_request *req)
+{
+	struct kshark_entry_request *last;
+
+	while (req) {
+		last = req;
+		req = req->next;
+		free(last);
+	}
+}
+
 /** Dummy entry, used to indicate the existence of filtered entries. */
 const struct kshark_entry dummy_entry = {/* next */ NULL,
 					 /* visible */ 0x00,
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index 358d498..f65fa53 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -115,6 +115,9 @@ struct kshark_context {
 	 * the event.
 	 */
 	struct event_filter		*advanced_event_filter;
+
+	/** List of Data collections. */
+	struct kshark_entry_collection *collections;
 };
 
 bool kshark_instance(struct kshark_context **kshark_ctx);
@@ -220,6 +223,9 @@ typedef bool (matching_condition_func)(struct kshark_context*,
  * kshark_entry.
  */
 struct kshark_entry_request {
+	/** Pointer to the next Data request. */
+	struct kshark_entry_request *next;
+
 	/**
 	 * Array index specifying the position inside the array from where
 	 * the search starts.
@@ -252,6 +258,8 @@ kshark_entry_request_alloc(size_t first, size_t n,
 			   matching_condition_func cond, int val,
 			   bool vis_only, int vis_mask);
 
+void kshark_free_entry_request(struct kshark_entry_request *req);
+
 const struct kshark_entry *
 kshark_get_entry_front(const struct kshark_entry_request *req,
 		       struct kshark_entry **data,
@@ -262,6 +270,77 @@ kshark_get_entry_back(const struct kshark_entry_request *req,
 		      struct kshark_entry **data,
 		      ssize_t *index);
 
+/**
+ * Data collections are used to optimize the search for an entry having
+ * an abstract property, defined by a Matching condition function and a
+ * value. When a collection is processed, the data which is relevant for
+ * the collection is enclosed in "Data intervals", defined by pairs of
+ * "Resume" and "Break" points. It is guaranteed that the data outside of
+ * the intervals contains no entries satisfying the abstract matching
+ * condition. Once defined, the Data collection can be used when searching
+ * for an entry having the same abstract property. The collection allows to
+ * ignore the irrelevant data, thus it eliminates the linear worst-case time
+ * complexity of the search.
+ */
+struct kshark_entry_collection {
+	/** Pointer to the next Data collection. */
+	struct kshark_entry_collection *next;
+
+	/** Matching condition function, used to define the collections. */
+	matching_condition_func *cond;
+
+	/**
+	 * Matching condition value, used by the Matching condition finction
+	 * to define the collections.
+	 */
+	int val;
+
+	/**
+	 * Array of indexes defining the beginning of each individual data
+	 * interval.
+	 */
+	size_t *resume_points;
+
+	/**
+	 * Array of indexes defining the end of each individual data interval.
+	 */
+	size_t *break_points;
+
+	/** Number of data intervals in this collection. */
+	size_t size;
+};
+
+struct kshark_entry_collection *
+kshark_register_data_collection(struct kshark_context *kshark_ctx,
+				struct kshark_entry **data, size_t n_rows,
+				matching_condition_func cond, int val,
+				size_t margin);
+
+void kshark_unregister_data_collection(struct kshark_entry_collection **col,
+				       matching_condition_func cond,
+				       int val);
+
+struct kshark_entry_collection *
+kshark_find_data_collection(struct kshark_entry_collection *col,
+			    matching_condition_func cond,
+			    int val);
+
+void kshark_reset_data_collection(struct kshark_entry_collection *col);
+
+void kshark_free_collection_list(struct kshark_entry_collection *col);
+
+const struct kshark_entry *
+kshark_get_collection_entry_front(struct kshark_entry_request **req,
+				  struct kshark_entry **data,
+				  const struct kshark_entry_collection *col,
+				  ssize_t *index);
+
+const struct kshark_entry *
+kshark_get_collection_entry_back(struct kshark_entry_request **req,
+				 struct kshark_entry **data,
+				 const struct kshark_entry_collection *col,
+				 ssize_t *index);
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.17.1
