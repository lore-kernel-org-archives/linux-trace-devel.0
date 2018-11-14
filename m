Return-Path: <SRS0=0hTv=NZ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46245 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733180AbeKOBrV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Nov 2018 20:47:21 -0500
Received: by mail-wr1-f66.google.com with SMTP id l9so4926171wrt.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Nov 2018 07:43:35 -0800 (PST)
From: kaslevs@vmware.com
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Fix record --date flag when sending tracing data to a listener
Date: Wed, 14 Nov 2018 17:43:28 +0200
Message-Id: <20181114154328.14731-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Slavomir Kaslev <kaslevs@vmware.com>

Currently the `trace-cmd record` --date is not taken into account when tracing
data is sent to a remote host with the -N flag.

This patch fixes this by the writing output buffer options from the recording
side instead of on the listener side.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h |  1 +
 lib/traceevent/event-parse.c  |  2 +-
 tracecmd/trace-output.c       | 11 ++++++-
 tracecmd/trace-record.c       | 60 ++++++++++++++++++++---------------
 4 files changed, 46 insertions(+), 28 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 684ddb7..4107fea 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -245,6 +245,7 @@ struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    const void *data);
 struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handle,
 						   const char *name, int cpus);
+int tracecmd_write_options(struct tracecmd_output *handle, int cpus);
 int tracecmd_update_option(struct tracecmd_output *handle,
 			   struct tracecmd_option *option, int size,
 			   const void *data);
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 078ed5e..2e8031c 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5411,7 +5411,7 @@ void tep_event_info(struct trace_seq *s, struct tep_event_format *event,
 
 static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
 {
-	if (!use_trace_clock)
+	if (!trace_clock || !use_trace_clock)
 		return true;
 
 	if (!strcmp(trace_clock, "local") || !strcmp(trace_clock, "global")
diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index 99493e6..a846379 100644
--- a/tracecmd/trace-output.c
+++ b/tracecmd/trace-output.c
@@ -973,6 +973,15 @@ static int add_options(struct tracecmd_output *handle)
 	return 0;
 }
 
+int tracecmd_write_options(struct tracecmd_output *handle, int cpus)
+{
+	cpus = convert_endian_4(handle, cpus);
+	if (do_write_check(handle, &cpus, 4))
+		return -1;
+
+	return add_options(handle);
+}
+
 int tracecmd_update_option(struct tracecmd_output *handle,
 			   struct tracecmd_option *option, int size,
 			   const void *data)
@@ -1264,7 +1273,7 @@ int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files)
 	handle->page_size = tracecmd_page_size(ihandle);
 	list_head_init(&handle->options);
 
-	if (tracecmd_append_cpu_data(handle, cpus, cpu_data_files) >= 0)
+	if (__tracecmd_append_cpu_data(handle, cpus, cpu_data_files) >= 0)
 		ret = 0;
 
 	tracecmd_output_close(handle);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 6dd2ac0..e1e2f43 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2877,8 +2877,10 @@ again:
 	return msg_handle;
 }
 
+static void add_options(struct tracecmd_output *handle, char *date2ts, int flags);
+
 static struct tracecmd_msg_handle *
-setup_connection(struct buffer_instance *instance)
+setup_connection(struct buffer_instance *instance, char *date2ts, int flags)
 {
 	struct tracecmd_msg_handle *msg_handle;
 	struct tracecmd_output *network_handle;
@@ -2886,13 +2888,17 @@ setup_connection(struct buffer_instance *instance)
 	msg_handle = setup_network();
 
 	/* Now create the handle through this socket */
-	if (msg_handle->version == V2_PROTOCOL) {
+	if (msg_handle->version == V2_PROTOCOL)
 		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
-		tracecmd_msg_finish_sending_metadata(msg_handle);
-	} else
+	else
 		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
 							      listed_events);
 
+	add_options(network_handle, date2ts, flags);
+	tracecmd_write_options(network_handle, instance->cpu_count);
+	if (msg_handle->version == V2_PROTOCOL)
+		tracecmd_msg_finish_sending_metadata(msg_handle);
+
 	instance->network_handle = network_handle;
 
 	/* OK, we are all set, let'r rip! */
@@ -2907,7 +2913,7 @@ static void finish_network(struct tracecmd_msg_handle *msg_handle)
 	free(host);
 }
 
-void start_threads(enum trace_type type, int global)
+void start_threads(enum trace_type type, int global, char *date2ts, int flags)
 {
 	struct buffer_instance *instance;
 	int *brass = NULL;
@@ -2929,7 +2935,7 @@ void start_threads(enum trace_type type, int global)
 		int x, pid;
 
 		if (host) {
-			instance->msg_handle = setup_connection(instance);
+			instance->msg_handle = setup_connection(instance, date2ts, flags);
 			if (!instance->msg_handle)
 				die("Failed to make connection");
 		}
@@ -3083,6 +3089,26 @@ enum {
 	DATA_FL_OFFSET		= 2,
 };
 
+static void add_options(struct tracecmd_output *handle, char *date2ts, int flags)
+{
+	int type = 0;
+
+	if (date2ts) {
+		if (flags & DATA_FL_DATE)
+			type = TRACECMD_OPTION_DATE;
+		else if (flags & DATA_FL_OFFSET)
+			type = TRACECMD_OPTION_OFFSET;
+	}
+
+	if (type)
+		tracecmd_add_option(handle, type, strlen(date2ts)+1, date2ts);
+
+	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
+	add_option_hooks(handle);
+	add_uname(handle);
+
+}
+
 static void record_data(char *date2ts, int flags)
 {
 	struct tracecmd_option **buffer_options;
@@ -3138,18 +3164,7 @@ static void record_data(char *date2ts, int flags)
 		if (!handle)
 			die("Error creating output file");
 
-		if (date2ts) {
-			int type = 0;
-
-			if (flags & DATA_FL_DATE)
-				type = TRACECMD_OPTION_DATE;
-			else if (flags & DATA_FL_OFFSET)
-				type = TRACECMD_OPTION_OFFSET;
-
-			if (type)
-				tracecmd_add_option(handle, type,
-						    strlen(date2ts)+1, date2ts);
-		}
+		add_options(handle, date2ts, flags);
 
 		/* Only record the top instance under TRACECMD_OPTION_CPUSTAT*/
 		if (!no_top_instance() && !top_instance.msg_handle) {
@@ -3160,13 +3175,6 @@ static void record_data(char *date2ts, int flags)
 						    s[i].len+1, s[i].buffer);
 		}
 
-		tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK,
-				    0, NULL);
-
-		add_option_hooks(handle);
-
-		add_uname(handle);
-
 		if (buffers) {
 			buffer_options = malloc(sizeof(*buffer_options) * buffers);
 			if (!buffer_options)
@@ -4974,7 +4982,7 @@ static void record_trace(int argc, char **argv,
 	if (type & (TRACE_TYPE_RECORD | TRACE_TYPE_STREAM)) {
 		signal(SIGINT, finish);
 		if (!latency)
-			start_threads(type, ctx->global);
+			start_threads(type, ctx->global, ctx->date2ts, ctx->data_flags);
 	} else {
 		update_task_filter();
 		tracecmd_enable_tracing();
-- 
2.19.1
