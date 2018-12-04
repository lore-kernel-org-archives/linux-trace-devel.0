Return-Path: <SRS0=S9Jt=ON=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f44.google.com ([209.85.128.44]:52897 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbeLDKXg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Dec 2018 05:23:36 -0500
Received: by mail-wm1-f44.google.com with SMTP id r11-v6so8922065wmb.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 04 Dec 2018 02:23:35 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/3] trace-cmd: Fix record --date flag when sending tracing data to a listener
Date: Tue,  4 Dec 2018 12:23:20 +0200
Message-Id: <20181204102320.31609-4-kaslevs@vmware.com>
In-Reply-To: <20181204102320.31609-1-kaslevs@vmware.com>
References: <20181204102320.31609-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Currently the `trace-cmd record` --date is not taken into account when tracing
data is sent to a remote host with the -N flag.

This patch fixes this by the writing output buffer options from the recording
side instead of on the listener side.

We also provide backward compatibility by falling back to previous behavior when
we're not using protocol v3.
---
 include/trace-cmd/trace-cmd.h |  7 +++--
 tracecmd/trace-listen.c       |  7 +++--
 tracecmd/trace-output.c       | 24 ++++++++++++----
 tracecmd/trace-record.c       | 52 +++++++++++++++++++----------------
 4 files changed, 57 insertions(+), 33 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 7cce592..7dc1fb4 100644
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
@@ -257,8 +258,10 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 				    struct tracecmd_option *option,
 				    int cpus, char * const *cpu_data_files);
-int tracecmd_attach_cpu_data(char *file, int cpus, char * const *cpu_data_files);
-int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files);
+int tracecmd_attach_cpu_data(char *file, int cpus, char * const *cpu_data_files,
+			     bool write_options);
+int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files,
+				bool write_options);
 
 /* --- Reading the Fly Recorder Trace --- */
 
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index b5379f5..83fd5d1 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -624,7 +624,7 @@ static void stop_all_readers(int cpus, int *pid_array)
 }
 
 static int put_together_file(int cpus, int ofd, const char *node,
-			      const char *port)
+			     const char *port, bool write_options)
 {
 	char **temp_files;
 	int cpu;
@@ -641,7 +641,7 @@ static int put_together_file(int cpus, int ofd, const char *node,
 			goto out;
 	}
 
-	tracecmd_attach_cpu_data_fd(ofd, cpus, temp_files);
+	tracecmd_attach_cpu_data_fd(ofd, cpus, temp_files, write_options);
 	ret = 0;
  out:
 	for (cpu--; cpu >= 0; cpu--) {
@@ -692,7 +692,8 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 	/* wait a little to have the readers clean up */
 	sleep(1);
 
-	ret = put_together_file(cpus, ofd, node, port);
+	ret = put_together_file(cpus, ofd, node, port,
+				msg_handle->version != V3_PROTOCOL);
 
 	destroy_all_readers(cpus, pid_array, node, port);
 
diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index 78a8fe6..6ae2fe0 100644
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
@@ -1227,7 +1236,7 @@ int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 	return __tracecmd_append_cpu_data(handle, cpus, cpu_data_files);
 }
 
-int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files)
+int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files, bool write_options)
 {
 	struct tracecmd_input *ihandle;
 	struct tracecmd_output *handle;
@@ -1264,8 +1273,13 @@ int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files)
 	handle->page_size = tracecmd_page_size(ihandle);
 	list_head_init(&handle->options);
 
-	if (tracecmd_append_cpu_data(handle, cpus, cpu_data_files) >= 0)
-		ret = 0;
+	if (write_options) {
+		if (tracecmd_append_cpu_data(handle, cpus, cpu_data_files) >= 0)
+			ret = 0;
+	} else {
+		if (__tracecmd_append_cpu_data(handle, cpus, cpu_data_files) >= 0)
+			ret = 0;
+	}
 
 	tracecmd_output_close(handle);
  out_free:
@@ -1273,7 +1287,7 @@ int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files)
 	return ret;
 }
 
-int tracecmd_attach_cpu_data(char *file, int cpus, char * const *cpu_data_files)
+int tracecmd_attach_cpu_data(char *file, int cpus, char * const *cpu_data_files, bool write_options)
 {
 	int fd;
 
@@ -1281,7 +1295,7 @@ int tracecmd_attach_cpu_data(char *file, int cpus, char * const *cpu_data_files)
 	if (fd < 0)
 		return -1;
 
-	return tracecmd_attach_cpu_data_fd(fd, cpus, cpu_data_files);
+	return tracecmd_attach_cpu_data_fd(fd, cpus, cpu_data_files, write_options);
 }
 
 struct tracecmd_output *
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index eb3ce4e..ef210d7 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2879,8 +2879,10 @@ again:
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
@@ -2890,6 +2892,8 @@ setup_connection(struct buffer_instance *instance)
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
 		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
+		add_options(network_handle, date2ts, flags);
+		tracecmd_write_options(network_handle, instance->cpu_count);
 		tracecmd_msg_finish_sending_data(msg_handle);
 	} else
 		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
@@ -2909,7 +2913,7 @@ static void finish_network(struct tracecmd_msg_handle *msg_handle)
 	free(host);
 }
 
-void start_threads(enum trace_type type, int global)
+void start_threads(enum trace_type type, int global, char *date2ts, int flags)
 {
 	struct buffer_instance *instance;
 	int *brass = NULL;
@@ -2931,7 +2935,7 @@ void start_threads(enum trace_type type, int global)
 		int x, pid;
 
 		if (host) {
-			instance->msg_handle = setup_connection(instance);
+			instance->msg_handle = setup_connection(instance, date2ts, flags);
 			if (!instance->msg_handle)
 				die("Failed to make connection");
 		}
@@ -3085,6 +3089,26 @@ enum {
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
@@ -3140,18 +3164,7 @@ static void record_data(char *date2ts, int flags)
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
@@ -3162,13 +3175,6 @@ static void record_data(char *date2ts, int flags)
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
@@ -4976,7 +4982,7 @@ static void record_trace(int argc, char **argv,
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
