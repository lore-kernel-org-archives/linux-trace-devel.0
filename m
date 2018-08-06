Return-Path: <SRS0=QejA=KV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37438 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730876AbeHFS34 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Aug 2018 14:29:56 -0400
Received: by mail-wm0-f65.google.com with SMTP id n11-v6so14906509wmc.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Aug 2018 09:20:05 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 1/6] kernel-shark-qt: Add generic instruments for searching inside the trace data
Date: Mon,  6 Aug 2018 19:19:22 +0300
Message-Id: <20180806161927.11206-2-y.karadz@gmail.com>
In-Reply-To: <20180806161927.11206-1-y.karadz@gmail.com>
References: <20180806161927.11206-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch introduces the instrumentation for data extraction used by the
visualization model of the Qt-based KernelShark. The effectiveness of these
instruments for searching has a dominant effect over the performance of the
model, so let's spend some time and explain this in detail.

The first type of instruments provide binary search inside a sorted in time
arrays of kshark_entries or trace_records. The search returns the first
element of the array, having timestamp bigger than a reference time value.
The time complexity of these searches is log(n).

The second type of instruments provide searching for the first (in time)
entry, satisfying an abstract Matching condition. Since the array is sorted
in time, but we search for an abstract property, for this search the array
is considered unsorted, thus we have to iterate and check all elements of the
array one by one. If we search for a type of entries, which are well presented
in the array, the time complexity of the search is constant, because no matter
how big is the array the search only goes through small number of entries at
the beginning of the array (or at the end, if we search backwards), before it
finds the first match. However if we search for sparse, or even nonexistent
entries, the time complexity becomes linear.

These explanations will start making more sense with the following patches.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 262 ++++++++++++++++++++++++++++++++
 kernel-shark-qt/src/libkshark.h |  93 ++++++++++++
 2 files changed, 355 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index c829aa9..879946b 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -925,3 +925,265 @@ char* kshark_dump_entry(const struct kshark_entry *entry)
 
 	return NULL;
 }
+
+/**
+ * @brief Binary search inside a time-sorted array of kshark_entries.
+ *
+ * @param time: The value of time to search for.
+ * @param data: Input location for the trace data.
+ * @param l: Array index specifying the lower edge of the range to search in.
+ * @param h: Array index specifying the upper edge of the range to search in.
+ *
+ * @returns On success, the first kshark_entry inside the range, having a
+	    timestamp equal or bigger than "time".
+	    If all entries inside the range have timestamps greater than "time"
+	    the function returns BSEARCH_ALL_GREATER (negative value).
+	    If all entries inside the range have timestamps smaller than "time"
+	    the function returns BSEARCH_ALL_SMALLER (negative value).
+ */
+ssize_t kshark_find_entry_by_time(uint64_t time,
+				 struct kshark_entry **data,
+				 size_t l, size_t h)
+{
+	size_t mid;
+
+	if (data[l]->ts > time)
+		return BSEARCH_ALL_GREATER;
+
+	if (data[h]->ts < time)
+		return BSEARCH_ALL_SMALLER;
+
+	/*
+	 * After executing the BSEARCH macro, "l" will be the index of the last
+	 * entry having timestamp < time and "h" will be the index of the first
+	 * entry having timestamp >= time.
+	 */
+	BSEARCH(h, l, data[mid]->ts < time);
+	return h;
+}
+
+/**
+ * @brief Binary search inside a time-sorted array of pevent_records.
+ *
+ * @param time: The value of time to search for.
+ * @param data: Input location for the trace data.
+ * @param l: Array index specifying the lower edge of the range to search in.
+ * @param h: Array index specifying the upper edge of the range to search in.
+ *
+ * @returns On success, the first pevent_record inside the range, having a
+	    timestamp equal or bigger than "time".
+	    If all entries inside the range have timestamps greater than "time"
+	    the function returns BSEARCH_ALL_GREATER (negative value).
+	    If all entries inside the range have timestamps smaller than "time"
+	    the function returns BSEARCH_ALL_SMALLER (negative value).
+ */
+ssize_t kshark_find_record_by_time(uint64_t time,
+				   struct pevent_record **data,
+				   size_t l, size_t h)
+{
+	size_t mid;
+
+	if (data[l]->ts > time)
+		return BSEARCH_ALL_GREATER;
+
+	if (data[h]->ts < time)
+		return BSEARCH_ALL_SMALLER;
+
+	/*
+	 * After executing the BSEARCH macro, "l" will be the index of the last
+	 * record having timestamp < time and "h" will be the index of the
+	 * first record having timestamp >= time.
+	 */
+	BSEARCH(h, l, data[mid]->ts < time);
+	return h;
+}
+
+/**
+ * @brief Simple Pid matching function to be user for data requests.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param e: kshark_entry to be checked.
+ * @param pid: Matching condition value.
+ *
+ * @returns True if the Pid of the entry matches the value of "pid".
+ *	    Else false.
+ */
+bool kshark_match_pid(struct kshark_context *kshark_ctx,
+		      struct kshark_entry *e, int pid)
+{
+	if (e->pid == pid)
+		return true;
+
+	return false;
+}
+
+/**
+ * @brief Simple Cpu matching function to be user for data requests.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param e: kshark_entry to be checked.
+ * @param cpu: Matching condition value.
+ *
+ * @returns True if the Cpu of the entry matches the value of "cpu".
+ *	    Else false.
+ */
+bool kshark_match_cpu(struct kshark_context *kshark_ctx,
+		      struct kshark_entry *e, int cpu)
+{
+	if (e->cpu == cpu)
+		return true;
+
+	return false;
+}
+
+/**
+ * @brief Create Data request. The request defines the properties of the
+ *	  requested kshark_entry.
+ *
+ * @param first: Array index specifying the position inside the array from
+ *		 where the search starts.
+ * @param n: Number of array elements to search in.
+ * @param cond: Matching condition function.
+ * @param val: Matching condition value, used by the Matching condition
+ *	       function.
+ * @param vis_only: If true, a visible entry is requested.
+ * @param vis_mask: If "vis_only" is true, use this mask to specify the level
+ *		    of visibility of the requested entry.
+ *
+ * @returns Pointer to kshark_entry_request on success, or NULL on failure.
+ *	    The user is responsible for freeing the returned
+ *	    kshark_entry_request.
+ */
+struct kshark_entry_request *
+kshark_entry_request_alloc(size_t first, size_t n,
+			   matching_condition_func cond, int val,
+			   bool vis_only, int vis_mask)
+{
+	struct kshark_entry_request *req = malloc(sizeof(*req));
+
+	if (!req) {
+		fprintf(stderr,
+			"Failed to allocate memory for entry request.\n");
+		return NULL;
+	}
+
+	req->first = first;
+	req->n = n;
+	req->cond = cond;
+	req->val = val;
+	req->vis_only = vis_only;
+	req->vis_mask = vis_mask;
+
+	return req;
+}
+
+/** Dummy entry, used to indicate the existence of filtered entries. */
+const struct kshark_entry dummy_entry = {
+	.next		= NULL,
+	.visible	= 0x00,
+	.cpu		= KS_FILTERED_BIN,
+	.pid		= KS_FILTERED_BIN,
+	.event_id	= -1,
+	.offset		= 0,
+	.ts		= 0
+};
+
+static const struct kshark_entry *
+get_entry(const struct kshark_entry_request *req,
+          struct kshark_entry **data,
+          ssize_t *index, size_t start, ssize_t end, int inc)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	const struct kshark_entry *e = NULL;
+	ssize_t i;
+
+	if (index)
+		*index = KS_EMPTY_BIN;
+
+	if (!kshark_instance(&kshark_ctx))
+		return e;
+
+	for (i = start; i != end; i += inc) {
+		if (req->cond(kshark_ctx, data[i], req->val)) {
+			/*
+			 * Data satisfying the condition has been found.
+			 */
+			if (req->vis_only &&
+			    !(data[i]->visible & req->vis_mask)) {
+				/* This data entry has been filtered. */
+				e = &dummy_entry;
+			} else {
+				e = data[i];
+				break;
+			}
+		}
+	}
+
+	if (index) {
+		if (e)
+			*index = (e->event_id >= 0)? i : KS_FILTERED_BIN;
+		else
+			*index = KS_EMPTY_BIN;
+	}
+
+	return e;
+}
+
+/**
+ * @brief Search for an entry satisfying the requirements of a given Data
+ *	  request. Start from the position provided by the request and go
+ *	  searching in the direction of the increasing timestamps (front).
+ *
+ * @param req: Input location for Data request.
+ * @param data: Input location for the trace data.
+ * @param index: Optional output location for the index of the returned
+ *		 entry inside the array.
+ *
+ * @returns Pointer to the first entry satisfying the matching conditionon
+ *	    success, or NULL on failure.
+ *	    In the special case when some entries, satisfying the Matching
+ *	    condition function have been found, but all these entries have
+ *	    been discarded because of the visibility criteria (filtered
+ *	    entries), the function returns a pointer to a special
+ *	    "Dummy entry".
+ */
+const struct kshark_entry *
+kshark_get_entry_front(const struct kshark_entry_request *req,
+                       struct kshark_entry **data,
+                       ssize_t *index)
+{
+	ssize_t end = req->first + req->n;
+
+	return get_entry(req, data, index, req->first, end, +1);
+}
+
+/**
+ * @brief Search for an entry satisfying the requirements of a given Data
+ *	  request. Start from the position provided by the request and go
+ *	  searching in the direction of the decreasing timestamps (back).
+ *
+ * @param req: Input location for Data request.
+ * @param data: Input location for the trace data.
+ * @param index: Optional output location for the index of the returned
+ *		 entry inside the array.
+ *
+ * @returns Pointer to the first entry satisfying the matching conditionon
+ *	    success, or NULL on failure.
+ *	    In the special case when some entries, satisfying the Matching
+ *	    condition function have been found, but all these entries have
+ *	    been discarded because of the visibility criteria (filtered
+ *	    entries), the function returns a pointer to a special
+ *	    "Dummy entry".
+ */
+const struct kshark_entry *
+kshark_get_entry_back(const struct kshark_entry_request *req,
+                      struct kshark_entry **data,
+                      ssize_t *index)
+{
+	ssize_t end = req->first - req->n;
+
+	if (end < 0)
+		end = -1;
+
+	return get_entry(req, data, index, req->first, end, -1);
+}
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index eda0a83..4860e74 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -190,6 +190,99 @@ void kshark_filter_entries(struct kshark_context *kshark_ctx,
 			   struct kshark_entry **data,
 			   size_t n_entries);
 
+/** Search failed identifiers. */
+enum kshark_search_failed {
+	/** All entries have timestamps greater timestamps. */
+	BSEARCH_ALL_GREATER = -1,
+
+	/** All entries have timestamps smaller timestamps. */
+	BSEARCH_ALL_SMALLER = -2,
+};
+
+/** General purpose Binary search macro. */
+#define BSEARCH(h, l, cond) 				\
+	({						\
+		while (h - l > 1) {			\
+			mid = (l + h) / 2;		\
+			if (cond)			\
+				l = mid;		\
+			else				\
+				h = mid;		\
+		}					\
+	})
+
+ssize_t kshark_find_entry_by_time(uint64_t time,
+				  struct kshark_entry **data_rows,
+				  size_t l, size_t h);
+
+ssize_t kshark_find_record_by_time(uint64_t time,
+				   struct pevent_record **data_rows,
+				   size_t l, size_t h);
+
+bool kshark_match_pid(struct kshark_context *kshark_ctx,
+		      struct kshark_entry *e, int pid);
+
+bool kshark_match_cpu(struct kshark_context *kshark_ctx,
+		      struct kshark_entry *e, int cpu);
+
+/** Empty bin identifier. */
+#define KS_EMPTY_BIN		-1
+
+/** Filtered bin identifier. */
+#define KS_FILTERED_BIN		-2
+
+/** Matching condition function type. To be user for data requests */
+typedef bool (matching_condition_func)(struct kshark_context*,
+				       struct kshark_entry*,
+				       int);
+
+/**
+ * Data request structure, defining the properties of the required
+ * kshark_entry.
+ */
+struct kshark_entry_request {
+	/**
+	 * Array index specifying the position inside the array from where
+	 * the search starts.
+	 */
+	size_t first;
+
+	/** Number of array elements to search in. */
+	size_t n;
+
+	/** Matching condition function. */
+	matching_condition_func *cond;
+
+	/**
+	 * Matching condition value, used by the Matching condition function.
+	 */
+	int val;
+
+	/** If true, a visible entry is requested. */
+	bool vis_only;
+
+	/**
+	 * If "vis_only" is true, use this mask to specify the level of
+	 * visibility of the requested entry.
+	 */
+	uint8_t vis_mask;
+};
+
+struct kshark_entry_request *
+kshark_entry_request_alloc(size_t first, size_t n,
+			   matching_condition_func cond, int val,
+			   bool vis_only, int vis_mask);
+
+const struct kshark_entry *
+kshark_get_entry_front(const struct kshark_entry_request *req,
+		       struct kshark_entry **data,
+		       ssize_t *index);
+
+const struct kshark_entry *
+kshark_get_entry_back(const struct kshark_entry_request *req,
+		      struct kshark_entry **data,
+		      ssize_t *index);
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.17.1
