Return-Path: <SRS0=lN8X=JV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36209 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753345AbeGEPia (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jul 2018 11:38:30 -0400
Received: by mail-wr1-f66.google.com with SMTP id h9-v6so1420389wro.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Jul 2018 08:38:29 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC 1/3] kernel-shark-qt: Add generic instruments for searching inside the trace data
Date: Thu,  5 Jul 2018 18:37:42 +0300
Message-Id: <20180705153744.28356-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch introduces the instrumentation for data extraction, used by the
visualization model of the Qt-based KernelShark. The effectiveness of these
instruments for searching has a dominant effect over the performance of the
model, so let's spend some time and explain this in details.

The first type of instruments provides binary search inside a sorted in time
arrays of kshark_entries or trace_records. The search returns the first
element of the array, having timestamp bigger than a reference time value.
The time complexity of these searches is log(n).

The second type of instruments provides searching for the first (in time)
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
 kernel-shark-qt/src/libkshark.c | 261 +++++++++++++++++++++++++++++++-
 kernel-shark-qt/src/libkshark.h |  76 +++++++++-
 2 files changed, 334 insertions(+), 3 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 13d7e6d..ebd096a 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -761,7 +761,7 @@ static const char *kshark_get_info(struct pevent *pe,
  * @returns The returned string contains a semicolon-separated list of data
  *	    fields.
  */
-char* kshark_dump_entry(struct kshark_entry *entry)
+char* kshark_dump_entry(const struct kshark_entry *entry)
 {
 	const char *event_name, *task, *lat, *info;
 	struct kshark_context *kshark_ctx;
@@ -808,3 +808,262 @@ char* kshark_dump_entry(struct kshark_entry *entry)
 
 	return NULL;
 }
+
+/**
+ * @brief Binary search inside a time-sorted array of kshark_entries.
+ * @param time: The value of time to search for.
+ * @param data_rows: Input location for the trace data.
+ * @param l: Array index specifying the lower edge of the range to search in.
+ * @param h: Array index specifying the upper edge of the range to search in.
+ * @returns On success, the first kshark_entry inside the range, having a
+	    timestamp equal or bigger than "time". In the case when no
+	    kshark_entry has been found inside the range, the function will
+	    return the value of "l" or "h".
+ */
+size_t kshark_find_entry_by_time(uint64_t time,
+				 struct kshark_entry **data_rows,
+				 size_t l, size_t h)
+{
+	size_t mid;
+
+	if (data_rows[l]->ts >= time)
+		return l;
+
+	if (data_rows[h]->ts < time)
+		return h;
+
+	while (h - l > 1) {
+		mid = (l + h) / 2;
+		if (data_rows[mid]->ts < time)
+			l = mid;
+		else
+			h = mid;
+	}
+
+	return h;
+}
+
+/**
+ * @brief Binary search inside a time-sorted array of pevent_records.
+ * @param time: The value of time to search for.
+ * @param data: Input location for the trace data.
+ * @param l: Array index specifying the lower edge of the range to search in.
+ * @param h: Array index specifying the upper edge of the range to search in.
+ * @returns On success, the first pevent_record inside the range, having a
+	    timestamp equal or bigger than "time". In the case when no
+	    pevent_record has been found inside the range, the function will
+	    return the value of "l" or "h".
+ */
+size_t kshark_find_record_by_time(uint64_t time,
+				  struct pevent_record **data,
+				  size_t l, size_t h)
+{
+	size_t mid;
+
+	if (data[l]->ts >= time)
+		return l;
+
+	if (data[h]->ts < time)
+		return h;
+
+	while (h - l > 1) {
+		mid = (l + h) / 2;
+		if (data[mid]->ts < time)
+			l = mid;
+		else
+			h = mid;
+	}
+
+	return h;
+}
+
+/**
+ * @brief Simple Pid matching finction to be user for data requests.
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param e: kshark_entry to be checked.
+ * @param pid: Matching condition value.
+ * @returns True if the Pid of the entry matches the value of "pid".
+ *	    Else false.
+ */
+bool kshark_check_pid(struct kshark_context *kshark_ctx,
+		      struct kshark_entry *e, int pid)
+{
+	if (e->pid == pid)
+		return true;
+
+	return false;
+}
+
+/**
+ * @brief Simple Cpu matching finction to be user for data requests.
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param e: kshark_entry to be checked.
+ * @param cpu: Matching condition value.
+ * @returns True if the Cpu of the entry matches the value of "cpu".
+ *	    Else false.
+ */
+bool kshark_check_cpu(struct kshark_context *kshark_ctx,
+		      struct kshark_entry *e, int cpu)
+{
+	if (e->cpu == cpu)
+		return true;
+
+	return false;
+}
+
+/**
+ * @brief Create Data request. The user has to free the returned
+ *	  kshark_entry_request.
+ * @param first: Array index specifying the position inside the array from
+ *		 where the search starts.
+ * @param n: Number of array elements to search in.
+ * @param cond: Matching condition finction.
+ * @param val: Matching condition value, used by the Matching condition
+ *	       finction.
+ * @param vis_only: If true, a visible entry is requested.
+ * @param vis_mask: If "vis_only" is true, use this mask to specify the level
+ *		    of visibility of the requested entry
+ * @returns Pointer to kshark_entry_request on success, or NULL on failure.
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
+const struct kshark_entry dummy_entry = {/* visible */ 0x00,
+					 /* cpu */ KS_FILTERED_BIN,
+					 /* pid */ KS_FILTERED_BIN,
+					 /* event_id */ -1,
+					 /* offset */ 0,
+					 /* ts */ 0,
+					 /* next */ NULL};
+
+/**
+ * @brief Search for an entry satisfying the requirements of a given Data
+ *	  request. Start from the position provided by the request and go
+ *	  searching in the direction of the increasing timestamps (front).
+ * @param req: Input location for Data request.
+ * @param data: Input location for the trace data.
+ * @param index: Optional output location for the index of the returned
+ *		 entry inside the array.
+ * @returns Pointer to the first entry satisfying the matching condition.
+ *	    In the special case when some entries, satisfying the Matching
+ *	    condition finction have been found, but all these entries have
+ *	    been discarded because of the visibility criteria (filtered
+ *	    entries), the function returns a pointer to a special
+ *	    "Dummy entry".
+ */
+const struct kshark_entry *
+kshark_get_entry_front(const struct kshark_entry_request *req,
+		       struct kshark_entry **data,
+		       ssize_t *index)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	const struct kshark_entry *e = NULL;
+	size_t i, last;
+
+	if (!kshark_instance(&kshark_ctx))
+		return e;
+
+	last = req->first + req->n;
+	for (i = req->first; i < last; ++i) {
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
+ *	  searching in the direction of the decreasing timestamps (back).
+ * @param req: Input location for Data request.
+ * @param data: Input location for the trace data.
+ * @param index: Optional output location for the index of the returned
+ *		 entry inside the array.
+ * @returns Pointer to the first entry satisfying the matching condition.
+ *	    In the special case when some entries, satisfying the Matching
+ *	    condition finction , have been found, but all these entries have
+ *	    been discarded because of the visibility criteria (filtered
+ *	    entries), the function returns a pointer to a special
+ *	    "Dummy entry".
+ */
+const struct kshark_entry *
+kshark_get_entry_back(const struct kshark_entry_request *req,
+		      struct kshark_entry **data,
+		      ssize_t *index)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	const struct kshark_entry *e = NULL;
+	ssize_t i, last;
+
+	if (!kshark_instance(&kshark_ctx))
+		return e;
+
+	last = req->first - req->n + 1;
+	if (last < 0)
+		last = 0;
+
+	for (i = req->first; i >= last; --i) {
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
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index 6ed2a1e..3b62231 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -42,7 +42,7 @@ struct kshark_entry {
 	uint8_t		visible;
 
 	/** The CPU core of the record. */
-	uint8_t		cpu;
+	int8_t		cpu;
 
 	/** The PID of the task the record was generated. */
 	int16_t		pid;
@@ -133,7 +133,7 @@ void kshark_close(struct kshark_context *kshark_ctx);
 
 void kshark_free(struct kshark_context *kshark_ctx);
 
-char* kshark_dump_entry(struct kshark_entry *entry);
+char* kshark_dump_entry(const struct kshark_entry *entry);
 
 /** Bit masks used to control the visibility of the entry after filtering. */
 enum kshark_filter_masks {
@@ -190,6 +190,78 @@ void kshark_filter_entries(struct kshark_context *kshark_ctx,
 			   struct kshark_entry **data,
 			   size_t n_entries);
 
+size_t kshark_find_entry_by_time(uint64_t time,
+				 struct kshark_entry **data_rows,
+				 size_t l, size_t h);
+
+size_t kshark_find_record_by_time(uint64_t time,
+				  struct pevent_record **data_rows,
+				  size_t l, size_t h);
+
+bool kshark_check_pid(struct kshark_context *kshark_ctx,
+		      struct kshark_entry *e, int pid);
+
+bool kshark_check_cpu(struct kshark_context *kshark_ctx,
+		      struct kshark_entry *e, int cpu);
+
+/** Empty bin identifier. */
+#define KS_EMPTY_BIN		-1
+
+/** Filtered bin identifier. */
+#define KS_FILTERED_BIN		-2
+
+/** Matching condition finction type. To be user for data requests */
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
+	/** Matching condition finction. */
+	matching_condition_func *cond;
+
+	/**
+	 * Matching condition value, used by the Matching condition finction.
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
