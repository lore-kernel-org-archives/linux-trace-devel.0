Return-Path: <SRS0=hWWP=JT=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:56952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933117AbeGCQYd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Jul 2018 12:24:33 -0400
Message-Id: <20180703162432.316240087@goodmis.org>
Date: Tue, 03 Jul 2018 12:21:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and load_data_records
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The two functions kshark_load_data_entries() and
kshark_load_data_records() contain a lot of similar code. Adding helper
functions can simplify it, and keep bugs from happening in one and not
the other (bugs will happen in both! but they will be consistent).

Add some helper functions used by the two functions above.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark-qt/src/libkshark.c | 232 +++++++++++++++++++-------------
 1 file changed, 137 insertions(+), 95 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index e38ddebbbe41..680949077b7f 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -500,6 +500,72 @@ static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
 	entry->pid = pevent_data_pid(kshark_ctx->pevent, record);
 }
 
+struct rec_list {
+	struct pevent_record	*rec;
+	struct rec_list		*next;
+};
+
+static void free_rec_list(struct rec_list **rec_list, int n_cpus)
+{
+	struct rec_list *temp_rec;
+	int cpu;
+
+	for (cpu = 0; cpu < n_cpus; ++cpu) {
+		while (rec_list[cpu]) {
+			temp_rec = rec_list[cpu];
+			rec_list[cpu] = temp_rec->next;
+			free(temp_rec);
+		}
+	}
+	free(rec_list);
+}
+
+static size_t get_records(struct kshark_context *kshark_ctx,
+			  struct rec_list ***rec_list)
+{
+	struct pevent_record *rec;
+	struct rec_list **temp_next;
+	struct rec_list **cpu_list;
+	struct rec_list *temp_rec;
+	size_t count, total = 0;
+	int n_cpus;
+	int cpu;
+
+	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+	cpu_list = calloc(n_cpus, sizeof(*cpu_list));
+	if (!cpu_list)
+		return -ENOMEM;
+
+	for (cpu = 0; cpu < n_cpus; ++cpu) {
+		count = 0;
+		cpu_list[cpu] = NULL;
+		temp_next = &cpu_list[cpu];
+
+		rec = tracecmd_read_cpu_first(kshark_ctx->handle, cpu);
+		while (rec) {
+			*temp_next = temp_rec = malloc(sizeof(*temp_rec));
+			if (!temp_rec)
+				goto fail;
+
+			temp_rec->rec = rec;
+			temp_rec->next = NULL;
+			temp_next = &temp_rec->next;
+
+			++count;
+			rec = tracecmd_read_data(kshark_ctx->handle, cpu);
+		}
+
+		total += count;
+	}
+
+	*rec_list = cpu_list;
+	return total;
+
+ fail:
+	free_rec_list(cpu_list, n_cpus);
+	return -ENOMEM;
+}
+
 /**
  * @brief Load the content of the trace data file into an array of
  *	  kshark_entries. This function provides fast loading, however the
@@ -521,9 +587,11 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 				struct kshark_entry ***data_rows)
 {
 	struct event_filter *adv_filter = kshark_ctx->advanced_event_filter;
-	struct kshark_entry **cpu_list, **rows;
-	struct kshark_entry *entry, **next;
 	struct kshark_task_list *task;
+	struct kshark_entry **rows;
+	struct kshark_entry *entry;
+	struct rec_list **rec_list;
+	struct rec_list *temp_rec;
 	struct pevent_record *rec;
 	int cpu, n_cpus, next_cpu;
 	size_t count, total = 0;
@@ -533,24 +601,41 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 	if (*data_rows)
 		free(*data_rows);
 
+	total = get_records(kshark_ctx, &rec_list);
+	if (total < 0)
+		goto fail;
+
+	rows = calloc(total, sizeof(struct kshark_entry *));
+	if(!rows)
+		goto fail;
+
 	n_cpus = tracecmd_cpus(kshark_ctx->handle);
-	cpu_list = calloc(n_cpus, sizeof(struct kshark_entry *));
 
-	for (cpu = 0; cpu < n_cpus; ++cpu) {
-		count = 0;
-		cpu_list[cpu] = NULL;
-		next = &cpu_list[cpu];
+	for (count = 0; count < total; count++) {
+		ts = 0;
+		next_cpu = -1;
+		for (cpu = 0; cpu < n_cpus; ++cpu) {
+			if (!rec_list[cpu])
+				continue;
 
-		rec = tracecmd_read_cpu_first(kshark_ctx->handle, cpu);
-		while (rec) {
-			*next = entry = malloc(sizeof(struct kshark_entry));
+			if (!ts || rec_list[cpu]->rec->ts < ts) {
+				ts = rec_list[cpu]->rec->ts;
+				next_cpu = cpu;
+			}
+		}
+
+		if (next_cpu >= 0) {
+			entry = malloc(sizeof(struct kshark_entry));
 			if (!entry)
-				goto fail;
+				goto fail_free;
+
+			rec = rec_list[next_cpu]->rec;
+			rows[count] = entry;
 
 			kshark_set_entry_values(kshark_ctx, rec, entry);
 			task = kshark_add_task(kshark_ctx, entry->pid);
 			if (!task)
-				goto fail;
+				goto fail_free;
 
 			/* Apply event filtering. */
 			ret = FILTER_NONE;
@@ -567,47 +652,26 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 				entry->visible &= ~kshark_ctx->filter_mask;
 			}
 
-			entry->next = NULL;
-			next = &entry->next;
+			temp_rec = rec_list[next_cpu];
+			rec_list[next_cpu] = rec_list[next_cpu]->next;
+			free(temp_rec);
 			free_record(rec);
-
-			++count;
-			rec = tracecmd_read_data(kshark_ctx->handle, cpu);
-		}
-
-		total += count;
-	}
-
-	rows = calloc(total, sizeof(struct kshark_entry *));
-	if (!rows)
-		goto fail;
-
-	count = 0;
-	while (count < total) {
-		ts = 0;
-		next_cpu = -1;
-		for (cpu = 0; cpu < n_cpus; ++cpu) {
-			if (!cpu_list[cpu])
-				continue;
-
-			if (!ts || cpu_list[cpu]->ts < ts) {
-				ts = cpu_list[cpu]->ts;
-				next_cpu = cpu;
-			}
-		}
-
-		if (next_cpu >= 0) {
-			rows[count] = cpu_list[next_cpu];
-			cpu_list[next_cpu] = cpu_list[next_cpu]->next;
 		}
-		++count;
 	}
 
-	free(cpu_list);
+	free_rec_list(rec_list, n_cpus);
 	*data_rows = rows;
 	return total;
 
-fail:
+ fail_free:
+	free_rec_list(rec_list, n_cpus);
+	for (count = 0; count < total; count++) {
+		if (!rows[count])
+			break;
+		free(rows[count]);
+	}
+	free(rows);
+ fail:
 	fprintf(stderr, "Failed to allocate memory during data loading.\n");
 	return -ENOMEM;
 }
@@ -625,82 +689,60 @@ fail:
 ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 				struct pevent_record ***data_rows)
 {
-	struct temp {
-		struct pevent_record	*rec;
-		struct temp		*next;
-	} **cpu_list, **temp_next, *temp_rec;
-
 	struct kshark_task_list *task;
 	struct pevent_record **rows;
-	struct pevent_record *data;
+	struct pevent_record *rec;
+	struct rec_list **rec_list;
+	struct rec_list *temp_rec;
 	int cpu, n_cpus, next_cpu;
 	size_t count, total = 0;
 	uint64_t ts;
 	int pid;
 
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
-	cpu_list = calloc(n_cpus, sizeof(struct temp *));
-
-	for (cpu = 0; cpu < n_cpus; ++cpu) {
-		count = 0;
-		cpu_list[cpu] = NULL;
-		temp_next = &cpu_list[cpu];
-
-		data = tracecmd_read_cpu_first(kshark_ctx->handle, cpu);
-		while (data) {
-			*temp_next = temp_rec = malloc(sizeof(*temp_rec));
-			if (!temp_rec)
-				goto fail;
-
-			pid = pevent_data_pid(kshark_ctx->pevent, data);
-			task = kshark_add_task(kshark_ctx, pid);
-			if (!task)
-				goto fail;
-
-			temp_rec->rec = data;
-			temp_rec->next = NULL;
-			temp_next = &(temp_rec->next);
-
-			++count;
-			data = tracecmd_read_data(kshark_ctx->handle, cpu);
-		}
-
-		total += count;
-	}
+	total = get_records(kshark_ctx, &rec_list);
+	if (total < 0)
+		goto fail;
 
 	rows = calloc(total, sizeof(struct pevent_record *));
-	if (!rows)
+	if(!rows)
 		goto fail;
 
-	count = 0;
-	while (count < total) {
+	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+
+	for (count = 0; count < total; count++) {
 		ts = 0;
 		next_cpu = -1;
 		for (cpu = 0; cpu < n_cpus; ++cpu) {
-			if (!cpu_list[cpu])
+			if (!rec_list[cpu])
 				continue;
 
-			if (!ts || cpu_list[cpu]->rec->ts < ts) {
-				ts = cpu_list[cpu]->rec->ts;
+			if (!ts || rec_list[cpu]->rec->ts < ts) {
+				ts = rec_list[cpu]->rec->ts;
 				next_cpu = cpu;
 			}
 		}
 
 		if (next_cpu >= 0) {
-			rows[count] = cpu_list[next_cpu]->rec;
-			temp_rec = cpu_list[next_cpu];
-			cpu_list[next_cpu] = cpu_list[next_cpu]->next;
-			free (temp_rec);
-		}
+			rec = rec_list[next_cpu]->rec;
+			rows[count] = rec;
 
-		++count;
+			pid = pevent_data_pid(kshark_ctx->pevent, rec);
+			task = kshark_add_task(kshark_ctx, pid);
+			if (!task)
+				goto fail;
+
+			temp_rec = rec_list[next_cpu];
+			rec_list[next_cpu] = rec_list[next_cpu]->next;
+			free(temp_rec);
+			free_record(rec);
+		}
 	}
 
-	free(cpu_list);
+	free_rec_list(rec_list, n_cpus);
 	*data_rows = rows;
 	return total;
 
-fail:
+ fail:
 	fprintf(stderr, "Failed to allocate memory during data loading.\n");
 	return -ENOMEM;
 }
-- 
2.17.1
