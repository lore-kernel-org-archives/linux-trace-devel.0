Return-Path: <SRS0=sAIo=JZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:41992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932770AbeGIQi0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jul 2018 12:38:26 -0400
Date: Mon, 9 Jul 2018 12:38:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark-qt: Make helper functions recognize data type
 to improve performance
Message-ID: <20180709123823.695b653a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a type enumerator and change rec_list into a union such that the helper
functions have more information about the type of data they are processing.
This will allow for the helper functions to be optimized such that they
perform better, and we can remove double allocations.

Some of the functionality of kshark_load_data_records() and
kshark_load_data_entries() have been moved into the helper functions with a
switch statement based on the type variable to know what to do with the
data.

The rec_list structure's entry element has been converted from a pointer,
that needs to be allocated, to a structure itself, such that it can be
allocated to store the entry data without having to allocate extra data.

The next field of the kshark_entry has been moved to the top of the
structure to match the rec_list next entry, so that they both have the link
list pointer as the first entry, and it does not matter if the rec_list is
used for kshark_entry's or for records.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark-qt/src/libkshark.c | 170 ++++++++++++++++++++++++----------------
 kernel-shark-qt/src/libkshark.h |   6 +-
 2 files changed, 105 insertions(+), 71 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index a79ed982..0c874643 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -500,15 +500,35 @@ static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
 	entry->pid = pevent_data_pid(kshark_ctx->pevent, record);
 }
 
-/* Quiet warnings over documenting simple structures */
-//! @cond Doxygen_Suppress
+/**
+ * rec_list is used to pass the data to the load functions.
+ * The rec_list will contain the list of entries from the source,
+ * and will be a link list of per CPU entries.
+ */
 struct rec_list {
-	struct pevent_record	*rec;
-	struct rec_list		*next;
+	union {
+		/* Used by kshark_load_data_records */
+		struct {
+			/** next pointer, matches entry->next */
+			struct rec_list		*next;
+			/** pointer to the raw record data */
+			struct pevent_record	*rec;
+		};
+		/** entry - Used for kshark_load_data_entries() */
+		struct kshark_entry		entry;
+	};
+};
+
+/**
+ * rec_type defines what type of rec_list is being used.
+ */
+enum rec_type {
+	REC_RECORD,
+	REC_ENTRY,
 };
-//! @endcond
 
-static void free_rec_list(struct rec_list **rec_list, int n_cpus)
+static void free_rec_list(struct rec_list **rec_list, int n_cpus,
+			  enum rec_type type)
 {
 	struct rec_list *temp_rec;
 	int cpu;
@@ -517,7 +537,8 @@ static void free_rec_list(struct rec_list **rec_list, int n_cpus)
 		while (rec_list[cpu]) {
 			temp_rec = rec_list[cpu];
 			rec_list[cpu] = temp_rec->next;
-			free_record(temp_rec->rec);
+			if (type == REC_RECORD)
+				free_record(temp_rec->rec);
 			free(temp_rec);
 		}
 	}
@@ -525,14 +546,17 @@ static void free_rec_list(struct rec_list **rec_list, int n_cpus)
 }
 
 static size_t get_records(struct kshark_context *kshark_ctx,
-			  struct rec_list ***rec_list)
+			  struct rec_list ***rec_list, enum rec_type type)
 {
+	struct event_filter *adv_filter;
+	struct kshark_task_list *task;
 	struct pevent_record *rec;
 	struct rec_list **temp_next;
 	struct rec_list **cpu_list;
 	struct rec_list *temp_rec;
 	size_t count, total = 0;
 	int n_cpus;
+	int pid;
 	int cpu;
 
 	n_cpus = tracecmd_cpus(kshark_ctx->handle);
@@ -540,6 +564,10 @@ static size_t get_records(struct kshark_context *kshark_ctx,
 	if (!cpu_list)
 		return -ENOMEM;
 
+	/* Just to shorten the name */
+	if (type == REC_ENTRY)
+		adv_filter = kshark_ctx->advanced_event_filter;
+
 	for (cpu = 0; cpu < n_cpus; ++cpu) {
 		count = 0;
 		cpu_list[cpu] = NULL;
@@ -547,12 +575,49 @@ static size_t get_records(struct kshark_context *kshark_ctx,
 
 		rec = tracecmd_read_cpu_first(kshark_ctx->handle, cpu);
 		while (rec) {
-			*temp_next = temp_rec = malloc(sizeof(*temp_rec));
+			*temp_next = temp_rec = calloc(1, sizeof(*temp_rec));
 			if (!temp_rec)
 				goto fail;
 
-			temp_rec->rec = rec;
 			temp_rec->next = NULL;
+
+			switch (type) {
+			case REC_RECORD:
+				temp_rec->rec = rec;
+				pid = pevent_data_pid(kshark_ctx->pevent, rec);
+				break;
+			case REC_ENTRY: {
+				struct kshark_entry *entry;
+				int ret;
+
+				entry = &temp_rec->entry;
+				kshark_set_entry_values(kshark_ctx, rec, entry);
+				pid = entry->pid;
+				/* Apply event filtering. */
+				ret = FILTER_NONE;
+				if (adv_filter->filters)
+					ret = pevent_filter_match(adv_filter, rec);
+
+				if (!kshark_show_event(kshark_ctx, entry->event_id) ||
+				    ret != FILTER_MATCH) {
+					unset_event_filter_flag(kshark_ctx, entry);
+				}
+
+				/* Apply task filtering. */
+				if (!kshark_show_task(kshark_ctx, entry->pid)) {
+					entry->visible &= ~kshark_ctx->filter_mask;
+				}
+				free_record(rec);
+				break;
+			} /* REC_ENTRY */
+			}
+
+			task = kshark_add_task(kshark_ctx, pid);
+			if (!task) {
+				free_record(rec);
+				goto fail;
+			}
+
 			temp_next = &temp_rec->next;
 
 			++count;
@@ -566,13 +631,15 @@ static size_t get_records(struct kshark_context *kshark_ctx,
 	return total;
 
  fail:
-	free_rec_list(cpu_list, n_cpus);
+	free_rec_list(cpu_list, n_cpus, type);
 	return -ENOMEM;
 }
 
-static int pick_next_cpu(struct rec_list **rec_list, int n_cpus)
+static int pick_next_cpu(struct rec_list **rec_list, int n_cpus,
+			 enum rec_type type)
 {
 	uint64_t ts = 0;
+	uint64_t rec_ts;
 	int next_cpu = -1;
 	int cpu;
 
@@ -580,8 +647,16 @@ static int pick_next_cpu(struct rec_list **rec_list, int n_cpus)
 		if (!rec_list[cpu])
 			continue;
 
-		if (!ts || rec_list[cpu]->rec->ts < ts) {
-			ts = rec_list[cpu]->rec->ts;
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
 			next_cpu = cpu;
 		}
 	}
@@ -610,16 +685,11 @@ static int pick_next_cpu(struct rec_list **rec_list, int n_cpus)
 ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 				struct kshark_entry ***data_rows)
 {
-	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
-	struct kshark_task_list *task;
 	struct kshark_entry **rows;
-	struct kshark_entry *entry;
 	struct rec_list **rec_list;
-	struct rec_list *temp_rec;
-	struct pevent_record *rec;
+	enum rec_type type = REC_ENTRY;
 	size_t count, total = 0;
 	int n_cpus;
-	int ret;
 
 	if (*data_rows)
 		free(*data_rows);
@@ -631,63 +701,33 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 	 *	 code simplier. We should revisit to see if we can
 	 *	 bring back the performance.
 	 */
-	total = get_records(kshark_ctx, &rec_list);
+	total = get_records(kshark_ctx, &rec_list, type);
 	if (total < 0)
 		goto fail;
 
+	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+
 	rows = calloc(total, sizeof(struct kshark_entry *));
 	if(!rows)
-		goto fail;
-
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+		goto fail_free;
 
 	for (count = 0; count < total; count++) {
 		int next_cpu;
 
-		next_cpu = pick_next_cpu(rec_list, n_cpus);
+		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
 
 		if (next_cpu >= 0) {
-			entry = malloc(sizeof(struct kshark_entry));
-			if (!entry)
-				goto fail_free;
-
-			rec = rec_list[next_cpu]->rec;
-			rows[count] = entry;
-
-			kshark_set_entry_values(kshark_ctx, rec, entry);
-			task = kshark_add_task(kshark_ctx, entry->pid);
-			if (!task)
-				goto fail_free;
-
-			/* Apply event filtering. */
-			ret = FILTER_NONE;
-			if (adv_filter->filters)
-				ret = pevent_filter_match(adv_filter, rec);
-
-			if (!kshark_show_event(kshark_ctx, entry->event_id) ||
-			    ret != FILTER_MATCH) {
-				unset_event_filter_flag(kshark_ctx, entry);
-			}
-
-			/* Apply task filtering. */
-			if (!kshark_show_task(kshark_ctx, entry->pid)) {
-				entry->visible &= ~kshark_ctx->filter_mask;
-			}
-
-			temp_rec = rec_list[next_cpu];
+			rows[count] = &rec_list[next_cpu]->entry;
 			rec_list[next_cpu] = rec_list[next_cpu]->next;
-			free(temp_rec);
-			/* The record is no longer be referenced */
-			free_record(rec);
 		}
 	}
 
-	free_rec_list(rec_list, n_cpus);
+	free_rec_list(rec_list, n_cpus, type);
 	*data_rows = rows;
 	return total;
 
  fail_free:
-	free_rec_list(rec_list, n_cpus);
+	free_rec_list(rec_list, n_cpus, type);
 	for (count = 0; count < total; count++) {
 		if (!rows[count])
 			break;
@@ -712,16 +752,15 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 				struct pevent_record ***data_rows)
 {
-	struct kshark_task_list *task;
 	struct pevent_record **rows;
 	struct pevent_record *rec;
 	struct rec_list **rec_list;
 	struct rec_list *temp_rec;
+	enum rec_type type = REC_RECORD;
 	size_t count, total = 0;
 	int n_cpus;
-	int pid;
 
-	total = get_records(kshark_ctx, &rec_list);
+	total = get_records(kshark_ctx, &rec_list, REC_RECORD);
 	if (total < 0)
 		goto fail;
 
@@ -734,17 +773,12 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	for (count = 0; count < total; count++) {
 		int next_cpu;
 
-		next_cpu = pick_next_cpu(rec_list, n_cpus);
+		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
 
 		if (next_cpu >= 0) {
 			rec = rec_list[next_cpu]->rec;
 			rows[count] = rec;
 
-			pid = pevent_data_pid(kshark_ctx->pevent, rec);
-			task = kshark_add_task(kshark_ctx, pid);
-			if (!task)
-				goto fail;
-
 			temp_rec = rec_list[next_cpu];
 			rec_list[next_cpu] = rec_list[next_cpu]->next;
 			free(temp_rec);
@@ -753,7 +787,7 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	}
 
 	/* There should be no records left in rec_list */
-	free_rec_list(rec_list, n_cpus);
+	free_rec_list(rec_list, n_cpus, type);
 	*data_rows = rows;
 	return total;
 
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index 6ed2a1ea..2e265522 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -33,6 +33,9 @@ extern "C" {
  * info etc.) is available on-demand via the offset into the trace file.
  */
 struct kshark_entry {
+	/** Pointer to the next (in time) kshark_entry on the same CPU core. */
+	struct kshark_entry *next; /* MUST BE FIRST ENTRY */
+
 	/**
 	 * A bit mask controlling the visibility of the entry. A value of OxFF
 	 * would mean that the entry is visible everywhere. Use
@@ -60,9 +63,6 @@ struct kshark_entry {
 	 * started.
 	 */
 	uint64_t	ts;
-
-	/** Pointer to the next (in time) kshark_entry on the same CPU core. */
-	struct kshark_entry *next;
 };
 
 /** Size of the task's hash table. */
-- 
2.13.6
