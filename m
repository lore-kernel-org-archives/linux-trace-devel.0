Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f47.google.com ([209.85.221.47]:46375 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbeHTRv3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:29 -0400
Received: by mail-wr1-f47.google.com with SMTP id a108-v6so10529349wrc.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:33 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 18/24] trace-cmd: Rename pevent_data_ APIs
Date: Mon, 20 Aug 2018 17:34:59 +0300
Message-Id: <20180820143505.11525-19-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_data_lat_fmt, pevent_data_type, pevent_data_event_from_type,
pevent_data_pid, pevent_data_preempt_count, pevent_data_flags,
pevent_data_comm_from_pid, pevent_data_pid_from_comm, pevent_cmdline_pid

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h      | 22 +++++++-------
 kernel-shark-qt/examples/datafilter.c |  4 +--
 kernel-shark-qt/examples/dataload.c   |  4 +--
 kernel-shark-qt/src/libkshark.c       | 14 ++++-----
 kernel-shark/kernel-shark.c           |  4 +--
 kernel-shark/trace-dialog.c           |  4 +--
 kernel-shark/trace-filter.c           |  2 +-
 kernel-shark/trace-graph.c            | 14 ++++-----
 kernel-shark/trace-plot-cpu.c         | 22 +++++++-------
 kernel-shark/trace-plot-task.c        | 26 ++++++++--------
 kernel-shark/trace-view-main.c        |  4 +--
 kernel-shark/trace-view-store.c       | 14 ++++-----
 lib/traceevent/event-parse.c          | 44 +++++++++++++--------------
 lib/traceevent/parse-filter.c         |  6 ++--
 plugins/plugin_blk.c                  |  8 ++---
 python/tracecmd.py                    | 22 +++++++-------
 tracecmd/trace-hist.c                 |  8 ++---
 tracecmd/trace-mem.c                  |  4 +--
 tracecmd/trace-profile.c              |  4 +--
 tracecmd/trace-read.c                 | 12 ++++----
 tracecmd/trace-record.c               |  4 +--
 21 files changed, 123 insertions(+), 123 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 9523143..9ad3208 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -693,18 +693,18 @@ pevent_find_event_by_name(struct tep_handle *pevent, const char *sys, const char
 struct event_format *
 pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
 
-void pevent_data_lat_fmt(struct tep_handle *pevent,
-			 struct trace_seq *s, struct tep_record *record);
-int pevent_data_type(struct tep_handle *pevent, struct tep_record *rec);
-struct event_format *pevent_data_event_from_type(struct tep_handle *pevent, int type);
-int pevent_data_pid(struct tep_handle *pevent, struct tep_record *rec);
-int pevent_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
-int pevent_data_flags(struct tep_handle *pevent, struct tep_record *rec);
-const char *pevent_data_comm_from_pid(struct tep_handle *pevent, int pid);
+void tep_data_lat_fmt(struct tep_handle *pevent,
+		      struct trace_seq *s, struct tep_record *record);
+int tep_data_type(struct tep_handle *pevent, struct tep_record *rec);
+struct event_format *tep_data_event_from_type(struct tep_handle *pevent, int type);
+int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec);
+int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
+int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec);
+const char *tep_data_comm_from_pid(struct tep_handle *pevent, int pid);
 struct cmdline;
-struct cmdline *pevent_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
-					  struct cmdline *next);
-int pevent_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline);
+struct cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
+				       struct cmdline *next);
+int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline);
 
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct format_field *field);
diff --git a/kernel-shark-qt/examples/datafilter.c b/kernel-shark-qt/examples/datafilter.c
index 4b1e1e9..7129f37 100644
--- a/kernel-shark-qt/examples/datafilter.c
+++ b/kernel-shark-qt/examples/datafilter.c
@@ -47,8 +47,8 @@ int main(int argc, char **argv)
 	n_tasks = kshark_get_task_pids(kshark_ctx, &pids);
 	for (i = 0; i < n_tasks; ++i) {
 		const char *task_str =
-			pevent_data_comm_from_pid(kshark_ctx->pevent,
-						  pids[i]);
+			tep_data_comm_from_pid(kshark_ctx->pevent,
+					       pids[i]);
 
 		if (strcmp(task_str, "trace-cmd") == 0)
 			kshark_filter_add_id(kshark_ctx, KS_HIDE_TASK_FILTER,
diff --git a/kernel-shark-qt/examples/dataload.c b/kernel-shark-qt/examples/dataload.c
index 963bc08..0cbc0f6 100644
--- a/kernel-shark-qt/examples/dataload.c
+++ b/kernel-shark-qt/examples/dataload.c
@@ -45,8 +45,8 @@ int main(int argc, char **argv)
 	n_tasks = kshark_get_task_pids(kshark_ctx, &pids);
 	for (r = 0; r < n_tasks; ++r) {
 		const char *task_str =
-			pevent_data_comm_from_pid(kshark_ctx->pevent,
-						  pids[r]);
+			tep_data_comm_from_pid(kshark_ctx->pevent,
+					       pids[r]);
 
 		printf("task: %s-%i\n", task_str, pids[r]);
 	}
diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 4f8da8a..d07bdd8 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -504,7 +504,7 @@ static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
 	entry->ts = record->ts;
 
 	/* Event Id of the record */
-	entry->event_id = pevent_data_type(kshark_ctx->pevent, record);
+	entry->event_id = tep_data_type(kshark_ctx->pevent, record);
 
 	/*
 	 * Is visible mask. This default value means that the entry
@@ -513,7 +513,7 @@ static void kshark_set_entry_values(struct kshark_context *kshark_ctx,
 	entry->visible = 0xFF;
 
 	/* Process Id of the record */
-	entry->pid = pevent_data_pid(kshark_ctx->pevent, record);
+	entry->pid = tep_data_pid(kshark_ctx->pevent, record);
 }
 
 /**
@@ -600,7 +600,7 @@ static size_t get_records(struct kshark_context *kshark_ctx,
 			switch (type) {
 			case REC_RECORD:
 				temp_rec->rec = rec;
-				pid = pevent_data_pid(kshark_ctx->pevent, rec);
+				pid = tep_data_pid(kshark_ctx->pevent, rec);
 				break;
 			case REC_ENTRY: {
 				struct kshark_entry *entry;
@@ -841,7 +841,7 @@ static const char *kshark_get_latency(struct tep_handle *pe,
 		return NULL;
 
 	trace_seq_reset(&seq);
-	pevent_data_lat_fmt(pe, &seq, record);
+	tep_data_lat_fmt(pe, &seq, record);
 	return seq.buffer;
 }
 
@@ -892,11 +892,11 @@ char* kshark_dump_entry(const struct kshark_entry *entry)
 
 	data = kshark_read_at(kshark_ctx, entry->offset);
 
-	event_id = pevent_data_type(kshark_ctx->pevent, data);
-	event = pevent_data_event_from_type(kshark_ctx->pevent, event_id);
+	event_id = tep_data_type(kshark_ctx->pevent, data);
+	event = tep_data_event_from_type(kshark_ctx->pevent, event_id);
 
 	event_name = event? event->name : "[UNKNOWN EVENT]";
-	task = pevent_data_comm_from_pid(kshark_ctx->pevent, entry->pid);
+	task = tep_data_comm_from_pid(kshark_ctx->pevent, entry->pid);
 	lat = kshark_get_latency(kshark_ctx->pevent, data);
 
 	size = asprintf(&temp_str, "%li %s-%i; CPU %i; %s;",
diff --git a/kernel-shark/kernel-shark.c b/kernel-shark/kernel-shark.c
index 8a512fc..0da78be 100644
--- a/kernel-shark/kernel-shark.c
+++ b/kernel-shark/kernel-shark.c
@@ -1650,8 +1650,8 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 		record = tracecmd_read_at(info->handle, offset, &cpu);
 
 		if (record) {
-			pid = pevent_data_pid(ginfo->pevent, record);
-			comm = pevent_data_comm_from_pid(ginfo->pevent, pid);
+			pid = tep_data_pid(ginfo->pevent, record);
+			comm = tep_data_comm_from_pid(ginfo->pevent, pid);
 
 			if (info->sync_task_filters) {
 				if (trace_graph_filter_task_find_pid(ginfo, pid))
diff --git a/kernel-shark/trace-dialog.c b/kernel-shark/trace-dialog.c
index 9298078..50b4daf 100644
--- a/kernel-shark/trace-dialog.c
+++ b/kernel-shark/trace-dialog.c
@@ -401,8 +401,8 @@ void trace_show_record_dialog(GtkWindow *parent, struct tep_handle *pevent,
 
 	trace_seq_init(&s);
 
-	type = pevent_data_type(pevent, record);
-	event = pevent_data_event_from_type(pevent, type);
+	type = tep_data_type(pevent, record);
+	event = tep_data_event_from_type(pevent, type);
 
 	if (raw)
 		read_raw_events(&s, event, record);
diff --git a/kernel-shark/trace-filter.c b/kernel-shark/trace-filter.c
index 3145f99..b762d97 100644
--- a/kernel-shark/trace-filter.c
+++ b/kernel-shark/trace-filter.c
@@ -809,7 +809,7 @@ create_task_model(struct tep_handle *pevent,
 
 	for (i = 0; tasks[i] >= 0; i++) {
 
-		comm = pevent_data_comm_from_pid(pevent, tasks[i]);
+		comm = tep_data_comm_from_pid(pevent, tasks[i]);
 
 		gtk_tree_store_append(treestore, &iter, NULL);
 
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index 53f5e39..b6890e9 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -748,8 +748,8 @@ do_pop_up(GtkWidget *widget, GdkEventButton *event, gpointer data)
 	if (record) {
 
 		if (!trace_graph_check_sched_switch(ginfo, record, &pid, &comm)) {
-			pid = pevent_data_pid(ginfo->pevent, record);
-			comm = pevent_data_comm_from_pid(ginfo->pevent, pid);
+			pid = tep_data_pid(ginfo->pevent, record);
+			comm = tep_data_comm_from_pid(ginfo->pevent, pid);
 		}
 
 		len = strlen(comm) + 50;
@@ -1038,7 +1038,7 @@ int trace_graph_check_sched_wakeup(struct graph_info *ginfo,
 			return 0;
 	}
 
-	id = pevent_data_type(ginfo->pevent, record);
+	id = tep_data_type(ginfo->pevent, record);
 
 	if (id == ginfo->event_wakeup_id) {
 		/* We only want those that actually woke up the task */
@@ -1081,7 +1081,7 @@ int trace_graph_check_sched_switch(struct graph_info *ginfo,
 
 	if (ginfo->read_comms) {
 		/* record all pids, for task plots */
-		this_pid = pevent_data_pid(ginfo->pevent, record);
+		this_pid = tep_data_pid(ginfo->pevent, record);
 		add_task_hash(ginfo, this_pid);
 	}
 
@@ -1105,7 +1105,7 @@ int trace_graph_check_sched_switch(struct graph_info *ginfo,
 		}
 	}
 
-	id = pevent_data_type(ginfo->pevent, record);
+	id = tep_data_type(ginfo->pevent, record);
 	if (id == ginfo->event_sched_switch_id) {
 		tep_read_number_field(ginfo->event_pid_field, record->data, &val);
 		if (comm)
@@ -1221,7 +1221,7 @@ trace_graph_check_irq(struct graph_info *ginfo,
 		}
 	}
 
-	id = pevent_data_type(ginfo->pevent, record);
+	id = tep_data_type(ginfo->pevent, record);
 
 	for (i = 0; ginfo->hard_irq_exit_ids[i] != -1; i++)
 		if (id == ginfo->hard_irq_exit_ids[i])
@@ -1997,7 +1997,7 @@ static void draw_plots(struct graph_info *ginfo, gint new_width)
 			for (list = hash->plots; list; list = list->next)
 				draw_plot(ginfo, list->plot, record);
 		}
-		pid = pevent_data_pid(ginfo->pevent, record);
+		pid = tep_data_pid(ginfo->pevent, record);
 		hash = trace_graph_plot_find_task(ginfo, pid);
 		if (hash) {
 			for (list = hash->plots; list; list = list->next)
diff --git a/kernel-shark/trace-plot-cpu.c b/kernel-shark/trace-plot-cpu.c
index 39b96f7..b2ec987 100644
--- a/kernel-shark/trace-plot-cpu.c
+++ b/kernel-shark/trace-plot-cpu.c
@@ -84,7 +84,7 @@ static int filter_record(struct graph_info *ginfo,
 	int wake_pid;
 	int filter;
 
-	*orig_pid = pevent_data_pid(ginfo->pevent, record);
+	*orig_pid = tep_data_pid(ginfo->pevent, record);
 
 	filter = trace_graph_filter_on_task(ginfo, *orig_pid);
 
@@ -154,8 +154,8 @@ again:
 		return 0;
 
 	/* Must have the record we want */
-	type = pevent_data_type(ginfo->pevent, record);
-	event = pevent_data_event_from_type(ginfo->pevent, type);
+	type = tep_data_type(ginfo->pevent, record);
+	event = tep_data_event_from_type(ginfo->pevent, type);
 	/* Unlikely that the event was not saved */
 	if (!event)
 		goto again;
@@ -163,7 +163,7 @@ again:
 	if (is_sched_switch)
 		pid = sched_pid;
 	trace_seq_printf(s, "%s-%d\n%s\n",
-			 pevent_data_comm_from_pid(ginfo->pevent, pid),
+			 tep_data_comm_from_pid(ginfo->pevent, pid),
 			 pid, event->name);
 	free_record(record);
 
@@ -373,8 +373,8 @@ int cpu_plot_display_info(struct graph_info *ginfo,
 		record = tracecmd_read_cpu_last(ginfo->handle, cpu);
 		if (record && record->ts < time) {
 			if (!trace_graph_check_sched_switch(ginfo, record, &pid, &comm)) {
-				pid = pevent_data_pid(ginfo->pevent, record);
-				comm = pevent_data_comm_from_pid(ginfo->pevent, pid);
+				pid = tep_data_pid(ginfo->pevent, record);
+				comm = tep_data_comm_from_pid(ginfo->pevent, pid);
 			}
 
 			convert_nano(record->ts, &sec, &usec);
@@ -393,18 +393,18 @@ int cpu_plot_display_info(struct graph_info *ginfo,
 
 	pevent = ginfo->pevent;
 
-	pid = pevent_data_pid(ginfo->pevent, record);
-	comm = pevent_data_comm_from_pid(ginfo->pevent, pid);
+	pid = tep_data_pid(ginfo->pevent, record);
+	comm = tep_data_comm_from_pid(ginfo->pevent, pid);
 
 	if (record->ts > time - 2/ginfo->resolution &&
 	    record->ts < time + 2/ginfo->resolution) {
 
-		type = pevent_data_type(pevent, record);
-		event = pevent_data_event_from_type(pevent, type);
+		type = tep_data_type(pevent, record);
+		event = tep_data_event_from_type(pevent, type);
 		if (event) {
 			trace_seq_puts(s, event->name);
 			trace_seq_putc(s, '\n');
-			pevent_data_lat_fmt(pevent, s, record);
+			tep_data_lat_fmt(pevent, s, record);
 			trace_seq_putc(s, '\n');
 			tep_event_info(s, event, record);
 			trace_seq_putc(s, '\n');
diff --git a/kernel-shark/trace-plot-task.c b/kernel-shark/trace-plot-task.c
index ca62457..81ac157 100644
--- a/kernel-shark/trace-plot-task.c
+++ b/kernel-shark/trace-plot-task.c
@@ -54,7 +54,7 @@ static gboolean is_running(struct graph_info *ginfo, struct tep_record *record)
 	unsigned long long val;
 	int id;
 
-	id = pevent_data_type(ginfo->pevent, record);
+	id = tep_data_type(ginfo->pevent, record);
 	if (id != ginfo->event_sched_switch_id)
 		return FALSE;
 
@@ -73,7 +73,7 @@ static gboolean record_matches_pid(struct graph_info *ginfo,
 	*is_sched = FALSE;
 	*wakeup = FALSE;
 
-	*pid = pevent_data_pid(ginfo->pevent, record);
+	*pid = tep_data_pid(ginfo->pevent, record);
 	*sched_pid = *pid;
 
 	if (trace_graph_check_sched_switch(ginfo, record, sched_pid, &comm)) {
@@ -286,20 +286,20 @@ static int task_plot_display_last_event(struct graph_info *ginfo,
 			trace_seq_printf(s, "sched_switch\n"
 					 "CPU %d %s-%d\n",
 					 record->cpu,
-					 pevent_data_comm_from_pid(ginfo->pevent, pid),
+					 tep_data_comm_from_pid(ginfo->pevent, pid),
 					 pid);
 		}
 	} else {
 			
 		/* Must have the record we want */
-		type = pevent_data_type(ginfo->pevent, record);
-		event = pevent_data_event_from_type(ginfo->pevent, type);
+		type = tep_data_type(ginfo->pevent, record);
+		event = tep_data_event_from_type(ginfo->pevent, type);
 		if (pid == rec_pid)
 			trace_seq_printf(s, "CPU %d\n%s\n",
 					 record->cpu, event->name);
 		else
 			trace_seq_printf(s, "%s-%d\n%s\n",
-					 pevent_data_comm_from_pid(ginfo->pevent, rec_pid),
+					 tep_data_comm_from_pid(ginfo->pevent, rec_pid),
 					 rec_pid, event->name);
 	}
 	free_record(record);
@@ -330,7 +330,7 @@ static gboolean record_is_interrupt(struct graph_info *ginfo,
 	if (ginfo->no_irqs)
 		return FALSE;
 
-	in_irq = !!(pevent_data_flags(ginfo->pevent, record) &
+	in_irq = !!(tep_data_flags(ginfo->pevent, record) &
 		    (TRACE_FLAG_HARDIRQ | TRACE_FLAG_SOFTIRQ));
 
 	/*
@@ -751,7 +751,7 @@ int task_plot_display_info(struct graph_info *ginfo,
 
 	pevent = ginfo->pevent;
 
-	pid = pevent_data_pid(ginfo->pevent, record);
+	pid = tep_data_pid(ginfo->pevent, record);
 	cpu = record->cpu;
 
 	convert_nano(record->ts, &sec, &usec);
@@ -759,12 +759,12 @@ int task_plot_display_info(struct graph_info *ginfo,
 	if (record->ts > time - 2/ginfo->resolution &&
 	    record->ts < time + 2/ginfo->resolution) {
 
-		type = pevent_data_type(pevent, record);
-		event = pevent_data_event_from_type(pevent, type);
+		type = tep_data_type(pevent, record);
+		event = tep_data_event_from_type(pevent, type);
 		if (event) {
 			trace_seq_puts(s, event->name);
 			trace_seq_putc(s, '\n');
-			pevent_data_lat_fmt(pevent, s, record);
+			tep_data_lat_fmt(pevent, s, record);
 			trace_seq_putc(s, '\n');
 			tep_event_info(s, event, record);
 			trace_seq_putc(s, '\n');
@@ -907,7 +907,7 @@ void graph_plot_init_tasks(struct graph_info *ginfo)
 	/* Just for testing */
 	record = tracecmd_read_cpu_first(ginfo->handle, 0);
 	while (record) {
-		pid = pevent_data_pid(ginfo->pevent, record);
+		pid = tep_data_pid(ginfo->pevent, record);
 		free_record(record);
 		if (pid)
 			break;
@@ -936,7 +936,7 @@ void graph_plot_task(struct graph_info *ginfo, int pid, int pos)
 	task_info->last_records =
 		malloc_or_die(sizeof(struct tep_record *) * ginfo->cpus);
 	task_info->pid = pid;
-	comm = pevent_data_comm_from_pid(ginfo->pevent, pid);
+	comm = tep_data_comm_from_pid(ginfo->pevent, pid);
 
 	len = strlen(comm) + 100;
 	label = malloc_or_die(len);
diff --git a/kernel-shark/trace-view-main.c b/kernel-shark/trace-view-main.c
index 00f53e0..faaef99 100644
--- a/kernel-shark/trace-view-main.c
+++ b/kernel-shark/trace-view-main.c
@@ -377,8 +377,8 @@ do_tree_popup(GtkWidget *widget, GdkEventButton *event, gpointer data)
 
 		if (record) {
 			pevent = tracecmd_get_pevent(info->handle);
-			pid = pevent_data_pid(pevent, record);
-			comm = pevent_data_comm_from_pid(pevent, pid);
+			pid = tep_data_pid(pevent, record);
+			comm = tep_data_comm_from_pid(pevent, pid);
 
 			len = strlen(comm) + 50;
 
diff --git a/kernel-shark/trace-view-store.c b/kernel-shark/trace-view-store.c
index 8d4e05f..92ddf7e 100644
--- a/kernel-shark/trace-view-store.c
+++ b/kernel-shark/trace-view-store.c
@@ -467,26 +467,26 @@ trace_view_store_get_value (GtkTreeModel *tree_model,
 		switch (column) {
 		case TRACE_VIEW_STORE_COL_COMM:
 		case TRACE_VIEW_STORE_COL_PID:
-			val = pevent_data_pid(pevent, data);
+			val = tep_data_pid(pevent, data);
 			if (column == TRACE_VIEW_STORE_COL_PID)
 				g_value_set_uint(value, val);
 			else {
-				comm = pevent_data_comm_from_pid(pevent, val);
+				comm = tep_data_comm_from_pid(pevent, val);
 				g_value_set_string(value, comm);
 			}
 			break;
 
 		case TRACE_VIEW_STORE_COL_LAT:
 			trace_seq_init(&s);
-			pevent_data_lat_fmt(pevent, &s, data);
+			tep_data_lat_fmt(pevent, &s, data);
 			g_value_set_string(value, s.buffer);
 			trace_seq_destroy(&s);
 			break;
 
 		case TRACE_VIEW_STORE_COL_EVENT:
 		case TRACE_VIEW_STORE_COL_INFO:
-			val = pevent_data_type(pevent, data);
-			event = pevent_data_event_from_type(pevent, val);
+			val = tep_data_type(pevent, data);
+			event = tep_data_event_from_type(pevent, val);
 			if (!event) {
 				if (column == TRACE_VIEW_STORE_COL_EVENT)
 					g_value_set_string(value, "[UNKNOWN EVENT]");
@@ -1184,7 +1184,7 @@ static gboolean show_task(TraceViewStore *store, struct tep_handle *pevent,
 	if (view_task(store, pid))
 		return TRUE;
 
-	event_id = pevent_data_type(pevent, record);
+	event_id = tep_data_type(pevent, record);
 
 	if (store->sched_switch_next_field &&
 	    event_id == store->sched_switch_event->id) {
@@ -1265,7 +1265,7 @@ static void update_filter_tasks(TraceViewStore *store)
 				}
 			}
 
-			pid = pevent_data_pid(pevent, record);
+			pid = tep_data_pid(pevent, record);
 			if (show_task(store, pevent, record, pid))
 				store->cpu_list[cpu][i].visible = 1;
 			else
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 7f9c0b3..a140fbc 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5126,7 +5126,7 @@ out_failed:
 }
 
 /**
- * pevent_data_lat_fmt - parse the data for the latency format
+ * tep_data_lat_fmt - parse the data for the latency format
  * @pevent: a handle to the pevent
  * @s: the trace_seq to write to
  * @record: the record to read from
@@ -5135,8 +5135,8 @@ out_failed:
  * need rescheduling, in hard/soft interrupt, preempt count
  * and lock depth) and places it into the trace_seq.
  */
-void pevent_data_lat_fmt(struct tep_handle *pevent,
-			 struct trace_seq *s, struct tep_record *record)
+void tep_data_lat_fmt(struct tep_handle *pevent,
+		      struct trace_seq *s, struct tep_record *record)
 {
 	static int check_lock_depth = 1;
 	static int check_migrate_disable = 1;
@@ -5209,55 +5209,55 @@ void pevent_data_lat_fmt(struct tep_handle *pevent,
 }
 
 /**
- * pevent_data_type - parse out the given event type
+ * tep_data_type - parse out the given event type
  * @pevent: a handle to the pevent
  * @rec: the record to read from
  *
  * This returns the event id from the @rec.
  */
-int pevent_data_type(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_type(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return trace_parse_common_type(pevent, rec->data);
 }
 
 /**
- * pevent_data_event_from_type - find the event by a given type
+ * tep_data_event_from_type - find the event by a given type
  * @pevent: a handle to the pevent
  * @type: the type of the event.
  *
  * This returns the event form a given @type;
  */
-struct event_format *pevent_data_event_from_type(struct tep_handle *pevent, int type)
+struct event_format *tep_data_event_from_type(struct tep_handle *pevent, int type)
 {
 	return tep_find_event(pevent, type);
 }
 
 /**
- * pevent_data_pid - parse the PID from record
+ * tep_data_pid - parse the PID from record
  * @pevent: a handle to the pevent
  * @rec: the record to parse
  *
  * This returns the PID from a record.
  */
-int pevent_data_pid(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return parse_common_pid(pevent, rec->data);
 }
 
 /**
- * pevent_data_preempt_count - parse the preempt count from the record
+ * tep_data_preempt_count - parse the preempt count from the record
  * @pevent: a handle to the pevent
  * @rec: the record to parse
  *
  * This returns the preempt count from a record.
  */
-int pevent_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return parse_common_pc(pevent, rec->data);
 }
 
 /**
- * pevent_data_flags - parse the latency flags from the record
+ * tep_data_flags - parse the latency flags from the record
  * @pevent: a handle to the pevent
  * @rec: the record to parse
  *
@@ -5265,20 +5265,20 @@ int pevent_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec)
  *
  *  Use trace_flag_type enum for the flags (see event-parse.h).
  */
-int pevent_data_flags(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return parse_common_flags(pevent, rec->data);
 }
 
 /**
- * pevent_data_comm_from_pid - return the command line from PID
+ * tep_data_comm_from_pid - return the command line from PID
  * @pevent: a handle to the pevent
  * @pid: the PID of the task to search for
  *
  * This returns a pointer to the command line that has the given
  * @pid.
  */
-const char *pevent_data_comm_from_pid(struct tep_handle *pevent, int pid)
+const char *tep_data_comm_from_pid(struct tep_handle *pevent, int pid)
 {
 	const char *comm;
 
@@ -5303,7 +5303,7 @@ pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct cmdline *ne
 }
 
 /**
- * pevent_data_pid_from_comm - return the pid from a given comm
+ * tep_data_pid_from_comm - return the pid from a given comm
  * @pevent: a handle to the pevent
  * @comm: the cmdline to find the pid from
  * @next: the cmdline structure to find the next comm
@@ -5315,8 +5315,8 @@ pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct cmdline *ne
  * next pid.
  * Also, it does a linear seach, so it may be slow.
  */
-struct cmdline *pevent_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
-					  struct cmdline *next)
+struct cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
+				       struct cmdline *next)
 {
 	struct cmdline *cmdline;
 
@@ -5351,13 +5351,13 @@ struct cmdline *pevent_data_pid_from_comm(struct tep_handle *pevent, const char
 }
 
 /**
- * pevent_cmdline_pid - return the pid associated to a given cmdline
+ * tep_cmdline_pid - return the pid associated to a given cmdline
  * @cmdline: The cmdline structure to get the pid from
  *
  * Returns the pid for a give cmdline. If @cmdline is NULL, then
  * -1 is returned.
  */
-int pevent_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
+int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
 {
 	struct cmdline_list *cmdlist = (struct cmdline_list *)cmdline;
 
@@ -5377,7 +5377,7 @@ int pevent_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
 }
 
 /**
- * pevent_data_comm_from_pid - parse the data into the print format
+ * tep_event_info - parse the data into the print format
  * @s: the trace_seq to write to
  * @event: the handle to the event
  * @record: the record to read from
@@ -5497,7 +5497,7 @@ void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 	}
 
 	if (pevent->latency_format) {
-		pevent_data_lat_fmt(pevent, s, record);
+		tep_data_lat_fmt(pevent, s, record);
 	}
 
 	if (use_usec_format) {
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index df42e04..4cc539c 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -1691,8 +1691,8 @@ get_comm(struct event_format *event, struct tep_record *record)
 	const char *comm;
 	int pid;
 
-	pid = pevent_data_pid(event->pevent, record);
-	comm = pevent_data_comm_from_pid(event->pevent, pid);
+	pid = tep_data_pid(event->pevent, record);
+	comm = tep_data_comm_from_pid(event->pevent, pid);
 	return comm;
 }
 
@@ -2046,7 +2046,7 @@ enum tep_errno tep_filter_match(struct event_filter *filter,
 	if (!filter->filters)
 		return TEP_ERRNO__NO_FILTER;
 
-	event_id = pevent_data_type(pevent, record);
+	event_id = tep_data_type(pevent, record);
 
 	filter_type = find_filter_type(filter, event_id);
 	if (!filter_type)
diff --git a/plugins/plugin_blk.c b/plugins/plugin_blk.c
index 0e92546..f9bd743 100644
--- a/plugins/plugin_blk.c
+++ b/plugins/plugin_blk.c
@@ -191,7 +191,7 @@ static int blk_log_split(struct trace_seq *s, struct blk_data *data)
 {
 	const char *cmd;
 
-	cmd = pevent_data_comm_from_pid(data->event->pevent, data->pid);
+	cmd = tep_data_comm_from_pid(data->event->pevent, data->pid);
 
 	return trace_seq_printf(s, "%llu / %llu [%s]\n", data->sector,
 				get_pdu_int(data->pdu_data), cmd);
@@ -201,7 +201,7 @@ static int blk_log_plug(struct trace_seq *s, struct blk_data *data)
 {
 	const char *cmd;
 
-	cmd = pevent_data_comm_from_pid(data->event->pevent, data->pid);
+	cmd = tep_data_comm_from_pid(data->event->pevent, data->pid);
 
 	return trace_seq_printf(s, "[%s]\n", cmd);
 }
@@ -210,7 +210,7 @@ static int blk_log_unplug(struct trace_seq *s, struct blk_data *data)
 {
 	const char *cmd;
 
-	cmd = pevent_data_comm_from_pid(data->event->pevent, data->pid);
+	cmd = tep_data_comm_from_pid(data->event->pevent, data->pid);
 
 	return trace_seq_printf(s, "[%s] %llu\n", cmd, get_pdu_int(data->pdu_data));
 }
@@ -236,7 +236,7 @@ static int blk_log_generic(struct trace_seq *s, struct blk_data *data)
 {
 	const char *cmd;
 
-	cmd = pevent_data_comm_from_pid(data->event->pevent, data->pid);
+	cmd = tep_data_comm_from_pid(data->event->pevent, data->pid);
 
 	if (data->action & BLK_TC_ACT(BLK_TC_PC)) {
 		int ret;
diff --git a/python/tracecmd.py b/python/tracecmd.py
index 318887c..bc926c6 100644
--- a/python/tracecmd.py
+++ b/python/tracecmd.py
@@ -80,7 +80,7 @@ class Event(object, DictMixin):
 
     @cached_property
     def comm(self):
-        return pevent_data_comm_from_pid(self._pevent, self.pid)
+        return tep_data_comm_from_pid(self._pevent, self.pid)
 
     @cached_property
     def cpu(self):
@@ -92,7 +92,7 @@ class Event(object, DictMixin):
 
     @cached_property
     def pid(self):
-        return pevent_data_pid(self._pevent, self._record)
+        return tep_data_pid(self._pevent, self._record)
 
     @cached_property
     def ts(self):
@@ -100,7 +100,7 @@ class Event(object, DictMixin):
 
     @cached_property
     def type(self):
-        return pevent_data_type(self._pevent, self._record)
+        return tep_data_type(self._pevent, self._record)
 
     def num_field(self, name):
         f = tep_find_any_field(self._format, name)
@@ -203,8 +203,8 @@ class Trace(object):
     def read_event(self, cpu):
         rec = tracecmd_read_data(self._handle, cpu)
         if rec:
-            type = pevent_data_type(self._pevent, rec)
-            format = pevent_data_event_from_type(self._pevent, type)
+            type = tep_data_type(self._pevent, rec)
+            format = tep_data_event_from_type(self._pevent, type)
             # rec ownership goes over to Event instance
             return Event(self._pevent, rec, format)
         return None
@@ -215,8 +215,8 @@ class Trace(object):
         if isinstance(res, int):
             return None
         rec, cpu = res
-        type = pevent_data_type(self._pevent, rec)
-        format = pevent_data_event_from_type(self._pevent, type)
+        type = tep_data_type(self._pevent, rec)
+        format = tep_data_event_from_type(self._pevent, type)
         # rec ownership goes over to Event instance
         return Event(self._pevent, rec, format)
 
@@ -225,16 +225,16 @@ class Trace(object):
         if isinstance(res, int):
             return None
         rec, cpu = res
-        type = pevent_data_type(self._pevent, rec)
-        format = pevent_data_event_from_type(self._pevent, type)
+        type = tep_data_type(self._pevent, rec)
+        format = tep_data_event_from_type(self._pevent, type)
         return Event(self._pevent, rec, format)
 
     def peek_event(self, cpu):
         rec = tracecmd_peek_data_ref(self._handle, cpu)
         if rec is None:
             return None
-        type = pevent_data_type(self._pevent, rec)
-        format = pevent_data_event_from_type(self._pevent, type)
+        type = tep_data_type(self._pevent, rec)
+        format = tep_data_event_from_type(self._pevent, type)
         # rec ownership goes over to Event instance
         return Event(self._pevent, rec, format)
 
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index e8bf434..08e0449 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -541,7 +541,7 @@ process_event(struct tep_handle *pevent, struct tep_record *record, int type)
 		reset_pending_stack();
 	}
 		
-	event = pevent_data_event_from_type(pevent, type);
+	event = tep_data_event_from_type(pevent, type);
 	event_name = event->name;
 
 	ret = tep_read_number_field(common_pid_field, record->data, &val);
@@ -919,7 +919,7 @@ static void print_chains(struct tep_handle *pevent)
 			printf("  %%%3.2f  (%d) %s %30s #%d\n",
 			       get_percent(total_counts, chain->count),
 			       pid,
-			       pevent_data_comm_from_pid(pevent, pid),
+			       tep_data_comm_from_pid(pevent, pid),
 			       chain->func,
 			       chain->count);
 		printf(START);
@@ -951,8 +951,8 @@ static void do_trace_hist(struct tracecmd_input *handle)
 	if (!record)
 		die("No records found in file");
 
-	ret = pevent_data_type(pevent, record);
-	event = pevent_data_event_from_type(pevent, ret);
+	ret = tep_data_type(pevent, record);
+	event = tep_data_event_from_type(pevent, ret);
 
 	long_size = tracecmd_long_size(handle);
 
diff --git a/tracecmd/trace-mem.c b/tracecmd/trace-mem.c
index 1833d88..c4edc06 100644
--- a/tracecmd/trace-mem.c
+++ b/tracecmd/trace-mem.c
@@ -487,8 +487,8 @@ static void do_trace_mem(struct tracecmd_input *handle)
 	if (!record)
 		die("No records found in file");
 
-	ret = pevent_data_type(pevent, record);
-	event = pevent_data_event_from_type(pevent, ret);
+	ret = tep_data_type(pevent, record);
+	event = tep_data_event_from_type(pevent, ret);
 
 	common_type_field = tep_find_common_field(event, "common_type");
 	if (!common_type_field)
diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index 2b50d33..cf0eace 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -763,7 +763,7 @@ static void trace_profile_record(struct tracecmd_input *handle,
 
 	pevent = h->pevent;
 
-	id = pevent_data_type(pevent, record);
+	id = tep_data_type(pevent, record);
 
 	event_data = find_event_data(h, id);
 
@@ -2017,7 +2017,7 @@ static void output_task(struct handle_data *h, struct task_data *task)
 	if (task->comm)
 		comm = task->comm;
 	else
-		comm = pevent_data_comm_from_pid(h->pevent, task->pid);
+		comm = tep_data_comm_from_pid(h->pevent, task->pid);
 
 	if (task->pid < 0)
 		printf("%s\n", task->comm);
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 352ff11..fd5567e 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -432,15 +432,15 @@ static void convert_comm_filter(struct tracecmd_input *handle)
 
 	/* Seach for comm names and get their pids */
 	for (list = comm_list; list; list = list->next) {
-		cmdline = pevent_data_pid_from_comm(pevent, list->pid, NULL);
+		cmdline = tep_data_pid_from_comm(pevent, list->pid, NULL);
 		if (!cmdline) {
 			warning("comm: %s not in cmdline list", list->pid);
 			continue;
 		}
 		do {
-			sprintf(pidstr, "%d", pevent_cmdline_pid(pevent, cmdline));
+			sprintf(pidstr, "%d", tep_cmdline_pid(pevent, cmdline));
 			add_pid_filter(pidstr);
-			cmdline = pevent_data_pid_from_comm(pevent, list->pid,
+			cmdline = tep_data_pid_from_comm(pevent, list->pid,
 							    cmdline);
 		} while (cmdline);
 	}
@@ -669,7 +669,7 @@ static void process_wakeup(struct tep_handle *pevent, struct tep_record *record)
 	if (!show_wakeup)
 		return;
 
-	id = pevent_data_type(pevent, record);
+	id = tep_data_type(pevent, record);
 	if (id == wakeup_id) {
 		if (tep_read_number_field(wakeup_success, record->data, &val) == 0) {
 			if (!val)
@@ -883,7 +883,7 @@ test_filters(struct tep_handle *pevent, struct filter *event_filters,
 	int flags;
 
 	if (no_irqs || no_softirqs) {
-		flags = pevent_data_flags(pevent, record);
+		flags = tep_data_flags(pevent, record);
 		if (no_irqs && (flags & TRACE_FLAG_HARDIRQ))
 			return FILTER_MISS;
 		if (no_softirqs && (flags & TRACE_FLAG_SOFTIRQ))
@@ -976,7 +976,7 @@ test_stacktrace(struct handle_list *handles, struct tep_record *record,
 
 	cpu_info = &info->cpus[record->cpu];
 
-	id = pevent_data_type(pevent, record);
+	id = tep_data_type(pevent, record);
 
 	/*
 	 * Print the stack trace if the previous event was printed.
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 6952492..5a1d2a0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3362,8 +3362,8 @@ find_ts_in_page(struct tep_handle *pevent, void *page, int size)
 		if (!record)
 			break;
 		free_record(last_record);
-		id = pevent_data_type(pevent, record);
-		event = pevent_data_event_from_type(pevent, id);
+		id = tep_data_type(pevent, record);
+		event = tep_data_event_from_type(pevent, id);
 		if (event) {
 			/* Make sure this is our event */
 			field = tep_find_field(event, "buf");
-- 
2.17.1
