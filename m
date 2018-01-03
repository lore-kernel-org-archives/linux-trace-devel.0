Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751244AbeACRxl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:41 -0500
Message-Id: <20180103175339.924196033@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 35/38] trace-cmd: Have msg_handle part of the buffer instance
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0035-trace-cmd-Have-msg_handle-part-of-the-buffer-instanc.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

To allow for recording of the host as well as for the network, we need to
have the msg_handle associated to the buffer instance and not global. This
also will allow for recording buffer instances to network and host, as well
as sending data to multiple hosts.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-local.h  |  2 ++
 trace-record.c | 56 +++++++++++++++++++++++++++++++++-----------------------
 2 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/trace-local.h b/trace-local.h
index 0d85fda416e2..0665ec3c11c5 100644
--- a/trace-local.h
+++ b/trace-local.h
@@ -189,6 +189,8 @@ struct buffer_instance {
 
 	struct tracecmd_input	*handle;
 
+	struct tracecmd_msg_handle *msg_handle;
+
 	int			tracing_on_init_val;
 	int			tracing_on_fd;
 	int			keep;
diff --git a/trace-record.c b/trace-record.c
index 9b389e7d9134..5f7231b0fda2 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -2912,21 +2912,14 @@ static void finish_network(struct tracecmd_msg_handle *msg_handle)
 	free(host);
 }
 
-static struct tracecmd_msg_handle *start_threads(enum trace_type type, int global)
+void start_threads(enum trace_type type, int global)
 {
-	struct tracecmd_msg_handle *msg_handle = NULL;
 	struct buffer_instance *instance;
 	int *brass = NULL;
 	int total_cpu_count = 0;
 	int i = 0;
 	int ret;
 
-	if (host) {
-		msg_handle = setup_connection();
-		if (!msg_handle)
-			die("Failed to make connection");
-	}
-
 	for_all_instances(instance)
 		total_cpu_count += instance->cpu_count;
 
@@ -2939,6 +2932,13 @@ static struct tracecmd_msg_handle *start_threads(enum trace_type type, int globa
 
 	for_all_instances(instance) {
 		int x, pid;
+
+		if (host) {
+			instance->msg_handle = setup_connection();
+			if (!instance->msg_handle)
+				die("Failed to make connection");
+		}
+
 		for (x = 0; x < instance->cpu_count; x++) {
 			if (type & TRACE_TYPE_STREAM) {
 				brass = pids[i].brass;
@@ -2966,8 +2966,6 @@ static struct tracecmd_msg_handle *start_threads(enum trace_type type, int globa
 		}
 	}
 	recorder_threads = i;
-
-	return msg_handle;
 }
 
 static void touch_file(const char *file)
@@ -3090,21 +3088,26 @@ enum {
 	DATA_FL_OFFSET		= 2,
 };
 
-static void record_data(struct tracecmd_msg_handle *msg_handle,
-			char *date2ts, int flags)
+static void record_data(char *date2ts, int flags)
 {
 	struct tracecmd_option **buffer_options;
 	struct tracecmd_output *handle;
 	struct buffer_instance *instance;
+	bool local = false;
 	int max_cpu_count = local_cpu_count;
 	char **temp_files;
 	int i;
 
-	if (msg_handle) {
-		finish_network(msg_handle);
-		return;
+	for_all_instances(instance) {
+		if (instance->msg_handle)
+			finish_network(instance->msg_handle);
+		else
+			local = true;
 	}
 
+	if (!local)
+		return;
+
 	if (latency)
 		handle = tracecmd_create_file_latency(output_file, local_cpu_count);
 	else {
@@ -3112,9 +3115,12 @@ static void record_data(struct tracecmd_msg_handle *msg_handle,
 			return;
 
 		/* Allocate enough temp files to handle each instance */
-		for_all_instances(instance)
+		for_all_instances(instance) {
+			if (instance->msg_handle)
+				continue;
 			if (instance->cpu_count > max_cpu_count)
 				max_cpu_count = instance->cpu_count;
+		}
 
 		temp_files = malloc(sizeof(*temp_files) * max_cpu_count);
 		if (!temp_files)
@@ -3128,7 +3134,7 @@ static void record_data(struct tracecmd_msg_handle *msg_handle,
 		 * If top_instance was not used, we still need to create
 		 * empty trace.dat files for it.
 		 */
-		if (no_top_instance()) {
+		if (no_top_instance() || top_instance.msg_handle) {
 			for (i = 0; i < local_cpu_count; i++)
 				touch_file(temp_files[i]);
 		}
@@ -3151,7 +3157,7 @@ static void record_data(struct tracecmd_msg_handle *msg_handle,
 		}
 
 		/* Only record the top instance under TRACECMD_OPTION_CPUSTAT*/
-		if (!no_top_instance()) {
+		if (!no_top_instance() && !top_instance.msg_handle) {
 			struct trace_seq *s = top_instance.s_save;
 
 			for (i = 0; i < local_cpu_count; i++)
@@ -3175,6 +3181,9 @@ static void record_data(struct tracecmd_msg_handle *msg_handle,
 				int cpus = instance->cpu_count != local_cpu_count ?
 					instance->cpu_count : 0;
 
+				if (instance->msg_handle)
+					continue;
+
 				buffer_options[i++] = tracecmd_add_buffer_option(handle,
 										 instance->name,
 										 cpus);
@@ -3182,7 +3191,7 @@ static void record_data(struct tracecmd_msg_handle *msg_handle,
 			}
 		}
 
-		if (!no_top_instance())
+		if (!no_top_instance() && !top_instance.msg_handle)
 			print_stat(&top_instance);
 
 		tracecmd_append_cpu_data(handle, local_cpu_count, temp_files);
@@ -3193,6 +3202,8 @@ static void record_data(struct tracecmd_msg_handle *msg_handle,
 		if (buffers) {
 			i = 0;
 			for_each_instance(instance) {
+				if (instance->msg_handle)
+					continue;
 				print_stat(instance);
 				append_buffer(handle, buffer_options[i++], instance, temp_files);
 			}
@@ -4895,7 +4906,6 @@ static void record_trace(int argc, char **argv,
 			 struct common_record_context *ctx)
 {
 	enum trace_type type = get_trace_cmd_type(ctx->curr_cmd);
-	struct tracecmd_msg_handle *msg_handle = NULL;
 	struct buffer_instance *instance;
 
 	/*
@@ -4968,7 +4978,7 @@ static void record_trace(int argc, char **argv,
 	if (type & (TRACE_TYPE_RECORD | TRACE_TYPE_STREAM)) {
 		signal(SIGINT, finish);
 		if (!latency)
-			msg_handle = start_threads(type, ctx->global);
+			start_threads(type, ctx->global);
 	} else {
 		update_task_filter();
 		tracecmd_enable_tracing();
@@ -4999,7 +5009,7 @@ static void record_trace(int argc, char **argv,
 		tracecmd_disable_all_tracing(0);
 
 	if (IS_RECORD(ctx)) {
-		record_data(msg_handle, ctx->date2ts, ctx->data_flags);
+		record_data(ctx->date2ts, ctx->data_flags);
 		delete_thread_data();
 	} else
 		print_stats();
@@ -5079,7 +5089,7 @@ void trace_extract(int argc, char **argv)
 		ctx.date2ts = get_date_to_ts();
 	}
 
-	record_data(NULL, ctx.date2ts, ctx.data_flags);
+	record_data(ctx.date2ts, ctx.data_flags);
 	delete_thread_data();
 	destroy_stats();
 	finalize_record_trace(&ctx);
-- 
2.13.2
