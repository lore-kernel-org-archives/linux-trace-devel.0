Return-Path: <SRS0=gflo=KP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:56287 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732160AbeGaPeQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Jul 2018 11:34:16 -0400
Received: by mail-wm0-f46.google.com with SMTP id f21-v6so3177542wmc.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Jul 2018 06:53:49 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 5/7] kernel-shark-qt: Define Data collections
Date: Tue, 31 Jul 2018 16:52:46 +0300
Message-Id: <20180731135248.30587-6-y.karadz@gmail.com>
In-Reply-To: <20180731135248.30587-1-y.karadz@gmail.com>
References: <20180731135248.30587-1-y.karadz@gmail.com>
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
 kernel-shark-qt/src/libkshark-collection.c | 827 +++++++++++++++++++++
 kernel-shark-qt/src/libkshark.c            |  16 +
 kernel-shark-qt/src/libkshark.h            |  79 ++
 4 files changed, 924 insertions(+), 1 deletion(-)
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
index 0000000..79ada7f
--- /dev/null
+++ b/kernel-shark-qt/src/libkshark-collection.c
@@ -0,0 +1,827 @@
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
+	COLLECTION_IGNORE = 0,
+	COLLECTION_RESUME,
+	COLLECTION_BREAK,
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
+static bool collection_add_entry(struct entry_list **list,
+				 size_t i, uint8_t type)
+{
+	struct entry_list *entry = *list;
+
+	if (entry->type != COLLECTION_IGNORE) {
+		entry->next = malloc(sizeof(*entry));
+		if (!entry->next)
+			return false;
+
+		entry = entry->next;
+		*list = entry;
+	}
+
+	entry->index = i;
+	entry->type = type;
+
+	return true;
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
+	struct kshark_entry_collection *col_ptr = NULL;
+	struct kshark_entry *last_vis_entry = NULL;
+	struct entry_list *col_list, *temp;
+	size_t resume_count = 0, break_count = 0;
+	size_t i, j, end, last_added = 0;
+	bool good_data = false;
+
+	col_list = malloc(sizeof(*col_list));
+	if (!col_list)
+		goto fail;
+
+	temp = col_list;
+
+	if (margin != 0) {
+		/*
+		 * If this collection includes margin data, add a margin data
+		 * interval at the very beginning of the data-set.
+		 */
+		temp->index = first;
+		temp->type = COLLECTION_RESUME;
+		++resume_count;
+
+		collection_add_entry(&temp, first + margin - 1,
+				     COLLECTION_BREAK);
+		++break_count;
+	} else {
+		temp->type = COLLECTION_IGNORE;
+	}
+
+	end = first + n_rows - margin;
+	for (i = first + margin; i < end; ++i) {
+		if (!cond(kshark_ctx, data[i], val)) {
+			/*
+			 * The entry is irrelevant for this collection.
+			 * Do nothing.
+			 */
+			continue;
+		}
+
+		/* The Matching condition is satisfed. */
+		if (!good_data) {
+			/*
+			 * Resume the collection here. Add some margin data
+			 * in front of the data of interest.
+			 */
+			good_data = true;
+			if (last_added == 0 || last_added < i - margin) {
+				collection_add_entry(&temp, i - margin,
+						 COLLECTION_RESUME);
+				++resume_count;
+			} else {
+				/*
+				 * Ignore the last collection Brack point.
+				 * Continue extending the previous data
+				 * interval.
+				 */
+				temp->type = COLLECTION_IGNORE;
+				--break_count;
+			}
+		} else if (good_data &&
+			   data[i]->next &&
+			   !cond(kshark_ctx, data[i]->next, val)) {
+			/*
+			 * Brack the collection here. Add some margin data
+			 * after the data of interest.
+			 */
+			good_data = false;
+			last_vis_entry = data[i];
+
+			/* Keep adding entries until the "next" record. */
+			for (j = i + 1;
+			     j != end && last_vis_entry->next != data[j];
+			     j++)
+				;
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
+	if (good_data) {
+		collection_add_entry(&temp, end - 1, COLLECTION_BREAK);
+		++break_count;
+	}
+
+	if (margin != 0) {
+		/*
+		 * If this collection includes margin data, add a margin data
+		 * interval at the very end of the data-set.
+		 */
+		collection_add_entry(&temp, first + n_rows - margin,
+				 COLLECTION_RESUME);
+
+		++resume_count;
+
+		collection_add_entry(&temp, first + n_rows - 1,
+				 COLLECTION_BREAK);
+
+		++break_count;
+	}
+
+	/*
+	 * If everything is OK, we must have pairs of COLLECTION_RESUME
+	 * and COLLECTION_BREAK points.
+	 */
+	assert(break_count == resume_count);
+
+	/* Create the collection. */
+	col_ptr = malloc(sizeof(*col_ptr));
+	if (!col_ptr)
+		goto fail;
+
+	col_ptr->next = NULL;
+
+	col_ptr->resume_points = calloc(resume_count,
+					sizeof(*col_ptr->resume_points));
+	if (!col_ptr->resume_points)
+		goto fail;
+
+	col_ptr->break_points = calloc(break_count,
+				       sizeof(*col_ptr->break_points));
+	if (!col_ptr->break_points) {
+		free(col_ptr->resume_points);
+		goto fail;
+	}
+
+	col_ptr->cond = cond;
+	col_ptr->val = val;
+
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
+
+fail:
+	fprintf(stderr, "Failed to allocate memory for Data collection.\n");
+
+	free(col_ptr);
+	for (i = 0; i < resume_count + break_count; ++i) {
+		temp = col_list;
+		col_list = col_list->next;
+		free(temp);
+	}
+
+	return NULL;
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
+	BSEARCH(h, l, (source_index > col->resume_points[mid]));
+
+	return h;
+}
+
+/*
+ * This finction uses the intervals of the Data collection to transform the
+ * inputted single data request into a list of data requests. The new list of
+ * request will ignore the data outside of the intervals of the collection.
+ */
+static int
+map_collection_back_request(const struct kshark_entry_collection *col,
+			    struct kshark_entry_request **req)
+{
+	struct kshark_entry_request *req_tmp = *req;
+	size_t req_first, req_end;
+	ssize_t col_index;
+	int req_count;
+
+	if (req_tmp->next || col->size == 0) {
+		fprintf(stderr, "Unexpected input in ");
+		fprintf(stderr, "map_collection_front_request()\n");
+		goto do_nothing;
+	}
+
+	req_end = req_tmp->first - req_tmp->n + 1;
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
+		goto do_nothing;
+	}
+
+	if (col_index == 0) {
+		if (req_tmp->first == col->resume_points[0]) {
+			/*
+			 * This is a special case. Because this is Back
+			 * Request, if the beginning of this request is at
+			 * the Resume Point of the first interval, then there
+			 * is only one possible entry, to look into.
+			 */
+			req_tmp->n = 1;
+			return 1;
+		}
+
+		/*
+		 * No overlap between the request and the collection.
+		 * Do nothing.
+		 */
+		goto do_nothing;
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
+				 * The inputted request ends before the
+				 * beginning of the previous interval. There
+				 * is only one possible entry in this interval
+				 * to look into.
+				 */
+				req_tmp->n = 1;
+				return 1;
+			}
+		}  else {
+			/* Move to the previous interval of the collection. */
+			--col_index;
+
+			if (req_tmp->first > col->break_points[col_index]) {
+				/*
+				 * The request overlaps with this interval of
+				 * the collection. Start from here, using the
+				 * Break Point of the interval as beginning of
+				 * the request.
+				 */
+				req_tmp->first = col->break_points[col_index];
+			}
+		}
+	} else if (col_index == LAST_BIN) {
+		/*
+		 * The inputted Back Request starts after the end of the last
+		 * interval of the collection.
+		 */
+		col_index = col->size - 1;
+		if (req_end > col->break_points[col_index]) {
+			/*
+			 * The inputted request ends after the end of the last
+			 * interval of the collection. There is no overlap
+			 * between the request and the collection. Do nothing.
+			 */
+			goto do_nothing;
+		}
+
+		/*
+		 * The request overlaps with last interval of the collection.
+		 * Start from here, using the Break Point of the last interval
+		 * as beginning of the request.
+		 */
+		req_tmp->first = col->break_points[col_index];
+	}
+
+	/*
+	 * Now loop over the intervals of the collection going backwords till
+	 * the end of the inputted request and create a separate request for
+	 * each of those interest.
+	 */
+	req_count = 1;
+	while (col_index >= 0 && req_end <= col->break_points[col_index]) {
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
+		 * The last entry of the original request is outside of the
+		 * "col_index" interval. Close the collection request at the
+		 * end of this interval and move to the next one. Try to make
+		 * another request there.
+		 */
+		req_tmp->n = req_tmp->first -
+		             col->resume_points[col_index] + 1;
+
+		--col_index;
+
+		if (req_end > col->break_points[col_index]) {
+			/*
+			 * The last entry of the original request comes before
+			 * the next collection interval. Stop here.
+			 */
+			break;
+		}
+
+		if (col_index > 0) {
+			/* Make a new request. */
+			req_first = col->break_points[col_index];
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
+
+do_nothing:
+	kshark_free_entry_request(*req);
+	*req = NULL;
+	return 0;
+}
+
+/*
+ * This finction uses the intervals of the Data collection to transform the
+ * inputted single data request into a list of data requests. The new list of
+ * request will ignore the data outside of the intervals of the collection.
+ */
+static int
+map_collection_front_request(const struct kshark_entry_collection *col,
+			     struct kshark_entry_request **req)
+{
+	struct kshark_entry_request *req_tmp = *req;
+	size_t req_first, req_end;
+	ssize_t col_index;
+	int req_count;
+
+	if (req_tmp->next || col->size == 0) {
+		fprintf(stderr, "Unexpected input in ");
+		fprintf(stderr, "map_collection_front_request()\n");
+		goto do_nothing;
+	}
+
+	req_end = req_tmp->first + req_tmp->n - 1;
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
+		goto do_nothing;
+	}
+
+	if (col_index == 0) {
+		if (col->resume_points[0] > req_end) {
+			/*
+			 * The inputted request is in the gap before the first
+			 * interval of the collection. No overlap between the
+			 * request and the collection. Do nothing.
+			 */
+			goto do_nothing;
+		}
+
+		/*
+		 * The request overlaps with the "col_index" interval of the
+		 * collection. Start from here, using the Resume Point of
+		 * the interval as beginning of the request.
+		 */
+		req_tmp->first = col->resume_points[col_index];
+	} else if (col_index > 0) {
+		if (req_tmp->first > col->break_points[col_index - 1] &&
+		    req_end < col->resume_points[col_index]) {
+			/*
+			 * The inputted request is in the gap between interval
+			 * "col_index" and "col_index - 1". No overlap between
+			 * the request and the collection. Do nothing.
+			 */
+			goto do_nothing;
+		}
+
+		if (req_tmp->first <= col->break_points[col_index - 1]) {
+			/*
+			 * The beginning of this request is inside the previous
+			 * interval of the collection. Start from there and
+			 * keep the original beginning point.
+			 */
+			--col_index;
+		} else {
+			/*
+			 * The request overlaps with the "col_index" interval
+			 * of the collection. Start from here, using the Resume
+			 * Point of the interval as beginning of the request.
+			 */
+			req_tmp->first = col->resume_points[col_index];
+		}
+	} else if (col_index == LAST_BIN) {
+		/*
+		 * The inputted Front Request starts after the end of the last
+		 * interval of the collection. Do nothing.
+		 */
+		goto do_nothing;
+	}
+
+	/*
+	 * Now loop over the intervals of the collection going forwards till
+	 * the end of the inputted request and create a separate request for
+	 * each of those interest.
+	 */
+	req_count = 1;
+	while (col_index < col->size &&
+	       req_end >= col->resume_points[col_index]) {
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
+			 * The last entry of the original request comes before
+			 * the beginning of next collection interval. Stop here.
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
+
+do_nothing:
+	kshark_free_entry_request(*req);
+	*req = NULL;
+	return 0;
+}
+
+/**
+ * @brief Search for an entry satisfying the requirements of a given Data
+ *	  request. Start from the position provided by the request and go
+ *	  searching in the direction of the increasing timestamps (front).
+ *	  The search is performed only inside the intervals, defined by
+ *	  the data collection.
+ * @param req: Input location for a single Data request. The imputed request
+ *	       will be transformed into a list of requests. This new list of
+ *	       requests will ignore the data outside of the intervals of the
+ *	       collection.
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
+ * @param req: Input location for Data request. The imputed request
+ *	       will be transformed into a list of requests. This new list of
+ *	       requests will ignore the data outside of the intervals of the
+ *	       collection.
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
+	free(col->resume_points);
+	free(col->break_points);
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
+ *		  satisfy the matching condition, but is added at the
+ *		  beginning and at the end of each interval of the collection
+ *		  as well as at the beginning and at the end of data-set. If
+ *		  "0", no margin data is added.
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
+
+	if (col) {
+		col->next = kshark_ctx->collections;
+		kshark_ctx->collections = col;
+	}
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
index 1796bf8..d383b95 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -1024,6 +1024,7 @@ kshark_entry_request_alloc(size_t first, size_t n,
 		return NULL;
 	}
 
+	req->next = NULL;
 	req->first = first;
 	req->n = n;
 	req->cond = cond;
@@ -1034,6 +1035,21 @@ kshark_entry_request_alloc(size_t first, size_t n,
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
 const struct kshark_entry dummy_entry = {
 	.next		= NULL,
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index adbd392..f3a63ce 100644
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
@@ -232,6 +235,9 @@ typedef bool (matching_condition_func)(struct kshark_context*,
  * kshark_entry.
  */
 struct kshark_entry_request {
+	/** Pointer to the next Data request. */
+	struct kshark_entry_request *next;
+
 	/**
 	 * Array index specifying the position inside the array from where
 	 * the search starts.
@@ -264,6 +270,8 @@ kshark_entry_request_alloc(size_t first, size_t n,
 			   matching_condition_func cond, int val,
 			   bool vis_only, int vis_mask);
 
+void kshark_free_entry_request(struct kshark_entry_request *req);
+
 const struct kshark_entry *
 kshark_get_entry_front(const struct kshark_entry_request *req,
 		       struct kshark_entry **data,
@@ -274,6 +282,77 @@ kshark_get_entry_back(const struct kshark_entry_request *req,
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
