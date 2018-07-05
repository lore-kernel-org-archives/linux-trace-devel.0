Return-Path: <SRS0=lN8X=JV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:33228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753439AbeGEWFq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jul 2018 18:05:46 -0400
Date: Thu, 5 Jul 2018 18:05:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and
 load_data_records
Message-ID: <20180705180544.7210caad@gandalf.local.home>
In-Reply-To: <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
References: <20180703162432.316240087@goodmis.org>
        <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 4 Jul 2018 14:39:01 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> >   /**
> >    * @brief Load the content of the trace data file into an array of
> >    *	  kshark_entries. This function provides fast loading, however the  
> 
> Actually , after applying the patch for trace-input.c and this patch on 
> top kshark_load_data_entries() becomes slower than 
> kshark_load_data_records(). Just make this clear in the description of 
> the functions.
> 
> > @@ -521,9 +587,11 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
> >   				struct kshark_entry ***data_rows)

In my tests, it showed a 30% slowdown. I really didn't like that. So I
looked at why it was so slow, and it appeared two fold. One, was that I
was doing a double allocation (allocating for both the rec_list and the
entry), the other was that holding on to all records still appeared to
slow things down a bit. Even with the array of storage, it made it
slow.

I decided to make it closer to the original but still with helper
functions. The key was modifying the struct rec_list to be:

struct rec_list {
	union {
		struct kshark_entry		entry;
		struct {
			struct rec_list		*next; /* Matches entry->next */
			struct pevent_record	*rec;
		};
	};
};

And creating a enum:

enum rec_type {
	REC_RECORD,
	REC_ENTRY,
};


That would allow the functions to know what type it was dealing with.
Will this change affect your numpy work much? You can add a REC_NUMPY
if needed.

Try it out and see if it improves things on your end:

Oh, and I pushed my patches.

-- Steve

Index: trace-cmd.git/kernel-shark-qt/src/libkshark.c
===================================================================
--- trace-cmd.git.orig/kernel-shark-qt/src/libkshark.c
+++ trace-cmd.git/kernel-shark-qt/src/libkshark.c
@@ -503,12 +503,23 @@ static void kshark_set_entry_values(stru
 /* Quiet warnings over documenting simple structures */
 //! @cond Doxygen_Suppress
 struct rec_list {
-	struct pevent_record	*rec;
-	struct rec_list		*next;
+	union {
+		struct kshark_entry		entry;
+		struct {
+			struct rec_list		*next; /* Matches entry->next */
+			struct pevent_record	*rec;
+		};
+	};
 };
 //! @endcond
 
-static void free_rec_list(struct rec_list **rec_list, int n_cpus)
+enum rec_type {
+	REC_RECORD,
+	REC_ENTRY,
+};
+
+static void free_rec_list(struct rec_list **rec_list, int n_cpus,
+			  enum rec_type type)
 {
 	struct rec_list *temp_rec;
 	int cpu;
@@ -517,7 +528,8 @@ static void free_rec_list(struct rec_lis
 		while (rec_list[cpu]) {
 			temp_rec = rec_list[cpu];
 			rec_list[cpu] = temp_rec->next;
-			free_record(temp_rec->rec);
+			if (type == REC_RECORD)
+				free_record(temp_rec->rec);
 			free(temp_rec);
 		}
 	}
@@ -525,8 +537,9 @@ static void free_rec_list(struct rec_lis
 }
 
 static size_t get_records(struct kshark_context *kshark_ctx,
-			  struct rec_list ***rec_list)
+			  struct rec_list ***rec_list, enum rec_type type)
 {
+	struct event_filter *adv_filter = NULL;
 	struct pevent_record *rec;
 	struct rec_list **temp_next;
 	struct rec_list **cpu_list;
@@ -547,12 +560,50 @@ static size_t get_records(struct kshark_
 
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
+				break;
+			case REC_ENTRY: {
+				struct kshark_task_list *task;
+				struct kshark_entry *entry;
+				int ret;
+
+				if (!adv_filter)
+					adv_filter = kshark_ctx->advanced_event_filter;
+				entry = &temp_rec->entry;
+				kshark_set_entry_values(kshark_ctx, rec, entry);
+				task = kshark_add_task(kshark_ctx, entry->pid);
+				if (!task) {
+					free_record(rec);
+					goto fail;
+				}
+
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
 			temp_next = &temp_rec->next;
 
 			++count;
@@ -566,13 +617,15 @@ static size_t get_records(struct kshark_
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
 
@@ -580,8 +633,16 @@ static int pick_next_cpu(struct rec_list
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
@@ -610,16 +671,11 @@ static int pick_next_cpu(struct rec_list
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
@@ -631,63 +687,33 @@ ssize_t kshark_load_data_entries(struct
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
@@ -717,11 +743,12 @@ ssize_t kshark_load_data_records(struct
 	struct pevent_record *rec;
 	struct rec_list **rec_list;
 	struct rec_list *temp_rec;
+	enum rec_type type = REC_RECORD;
 	size_t count, total = 0;
 	int n_cpus;
 	int pid;
 
-	total = get_records(kshark_ctx, &rec_list);
+	total = get_records(kshark_ctx, &rec_list, REC_RECORD);
 	if (total < 0)
 		goto fail;
 
@@ -734,7 +761,7 @@ ssize_t kshark_load_data_records(struct
 	for (count = 0; count < total; count++) {
 		int next_cpu;
 
-		next_cpu = pick_next_cpu(rec_list, n_cpus);
+		next_cpu = pick_next_cpu(rec_list, n_cpus, type);
 
 		if (next_cpu >= 0) {
 			rec = rec_list[next_cpu]->rec;
@@ -753,7 +780,7 @@ ssize_t kshark_load_data_records(struct
 	}
 
 	/* There should be no records left in rec_list */
-	free_rec_list(rec_list, n_cpus);
+	free_rec_list(rec_list, n_cpus, type);
 	*data_rows = rows;
 	return total;
 
Index: trace-cmd.git/kernel-shark-qt/src/libkshark.h
===================================================================
--- trace-cmd.git.orig/kernel-shark-qt/src/libkshark.h
+++ trace-cmd.git/kernel-shark-qt/src/libkshark.h
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
