Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40463 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729641AbeLNN6C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 08:58:02 -0500
Received: by mail-wm1-f65.google.com with SMTP id q26so5865695wmf.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 Dec 2018 05:58:00 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v4 2/3] trace-cmd: Fix record --date flag when sending tracing data to a listener
Date: Fri, 14 Dec 2018 15:57:48 +0200
Message-Id: <20181214135749.12328-3-kaslevs@vmware.com>
In-Reply-To: <20181214135749.12328-1-kaslevs@vmware.com>
References: <20181214135749.12328-1-kaslevs@vmware.com>
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

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h | 10 ++++-
 tracecmd/trace-listen.c       | 23 ++++++++---
 tracecmd/trace-output.c       | 76 +++++++++++++++++------------------
 tracecmd/trace-record.c       | 55 ++++++++++++++-----------
 4 files changed, 96 insertions(+), 68 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 7cce592..26c1180 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -245,6 +245,9 @@ struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    const void *data);
 struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handle,
 						   const char *name, int cpus);
+
+int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
+int tracecmd_write_options(struct tracecmd_output *handle);
 int tracecmd_update_option(struct tracecmd_output *handle,
 			   struct tracecmd_option *option, int size,
 			   const void *data);
@@ -252,13 +255,16 @@ void tracecmd_output_close(struct tracecmd_output *handle);
 void tracecmd_output_free(struct tracecmd_output *handle);
 struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 				      const char *file);
+
+int tracecmd_write_cpu_data(struct tracecmd_output *handle,
+			    int cpus, char * const *cpu_data_files);
 int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 			     int cpus, char * const *cpu_data_files);
 int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 				    struct tracecmd_option *option,
 				    int cpus, char * const *cpu_data_files);
-int tracecmd_attach_cpu_data(char *file, int cpus, char * const *cpu_data_files);
-int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files);
+
+struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
 
 /* --- Reading the Fly Recorder Trace --- */
 
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index a13b83b..57151ba 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -624,8 +624,9 @@ static void stop_all_readers(int cpus, int *pid_array)
 }
 
 static int put_together_file(int cpus, int ofd, const char *node,
-			      const char *port)
+			     const char *port, bool write_options)
 {
+	struct tracecmd_output *handle;
 	char **temp_files;
 	int cpu;
 	int ret = -ENOMEM;
@@ -641,9 +642,20 @@ static int put_together_file(int cpus, int ofd, const char *node,
 			goto out;
 	}
 
-	tracecmd_attach_cpu_data_fd(ofd, cpus, temp_files);
-	ret = 0;
- out:
+	handle = tracecmd_get_output_handle_fd(ofd);
+	if (!handle) {
+		ret = -1;
+		goto out;
+	}
+
+	if (write_options) {
+		tracecmd_write_cpus(handle, cpus);
+		tracecmd_write_options(handle);
+	}
+	ret = tracecmd_write_cpu_data(handle, cpus, temp_files);
+
+out:
+	tracecmd_output_close(handle);
 	for (cpu--; cpu >= 0; cpu--) {
 		put_temp_file(temp_files[cpu]);
 	}
@@ -692,7 +704,8 @@ static int process_client(struct tracecmd_msg_handle *msg_handle,
 	/* wait a little to have the readers clean up */
 	sleep(1);
 
-	ret = put_together_file(cpus, ofd, node, port);
+	ret = put_together_file(cpus, ofd, node, port,
+				msg_handle->version != 3);
 
 	destroy_all_readers(cpus, pid_array, node, port);
 
diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index 78a8fe6..656b064 100644
--- a/tracecmd/trace-output.c
+++ b/tracecmd/trace-output.c
@@ -932,7 +932,13 @@ tracecmd_add_option(struct tracecmd_output *handle,
 	return option;
 }
 
-static int add_options(struct tracecmd_output *handle)
+int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
+{
+	cpus = convert_endian_4(handle, cpus);
+	return do_write_check(handle, &cpus, 4);
+}
+
+int tracecmd_write_options(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
 	unsigned short option;
@@ -1052,11 +1058,11 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (!handle)
 		return NULL;
 
-	cpus = convert_endian_4(handle, cpus);
-	if (do_write_check(handle, &cpus, 4))
+
+	if (tracecmd_write_cpus(handle, cpus) < 0)
 		goto out_free;
 
-	if (add_options(handle) < 0)
+	if (tracecmd_write_options(handle) < 0)
 		goto out_free;
 
 	if (do_write_check(handle, "latency  ", 10))
@@ -1077,8 +1083,8 @@ out_free:
 	return NULL;
 }
 
-static int __tracecmd_append_cpu_data(struct tracecmd_output *handle,
-				      int cpus, char * const *cpu_data_files)
+int tracecmd_write_cpu_data(struct tracecmd_output *handle,
+			    int cpus, char * const *cpu_data_files)
 {
 	off64_t *offsets = NULL;
 	unsigned long long *sizes = NULL;
@@ -1186,16 +1192,17 @@ static int __tracecmd_append_cpu_data(struct tracecmd_output *handle,
 int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 			     int cpus, char * const *cpu_data_files)
 {
-	int endian4;
+	int ret;
 
-	endian4 = convert_endian_4(handle, cpus);
-	if (do_write_check(handle, &endian4, 4))
-		return -1;
+	ret = tracecmd_write_cpus(handle, cpus);
+	if (ret)
+		return ret;
 
-	if (add_options(handle) < 0)
-		return -1;
+	ret = tracecmd_write_options(handle);
+	if (ret)
+		return ret;
 
-	return __tracecmd_append_cpu_data(handle, cpus, cpu_data_files);
+	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files);
 }
 
 int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
@@ -1224,35 +1231,38 @@ int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 		return -1;
 	}
 
-	return __tracecmd_append_cpu_data(handle, cpus, cpu_data_files);
+	return tracecmd_write_cpu_data(handle, cpus, cpu_data_files);
 }
 
-int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files)
+struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 {
+	struct tracecmd_output *handle = NULL;
 	struct tracecmd_input *ihandle;
-	struct tracecmd_output *handle;
 	struct tep_handle *pevent;
-	int ret = -1;
+	int fd2;
 
 	/* Move the file descriptor to the beginning */
 	if (lseek(fd, 0, SEEK_SET) == (off_t)-1)
-		return -1;
+		return NULL;
+
+	/* dup fd to be used by the ihandle bellow */
+	fd2 = dup(fd);
+	if (fd2 < 0)
+		return NULL;
 
 	/* get a input handle from this */
-	ihandle = tracecmd_alloc_fd(fd);
+	ihandle = tracecmd_alloc_fd(fd2);
 	if (!ihandle)
-		return -1;
+		return NULL;
 
 	/* move the file descriptor to the end */
 	if (lseek(fd, 0, SEEK_END) == (off_t)-1)
 		goto out_free;
 
 	/* create a partial output handle */
-
-	handle = malloc(sizeof(*handle));
+	handle = calloc(1, sizeof(*handle));
 	if (!handle)
 		goto out_free;
-	memset(handle, 0, sizeof(*handle));
 
 	handle->fd = fd;
 
@@ -1264,24 +1274,14 @@ int tracecmd_attach_cpu_data_fd(int fd, int cpus, char * const *cpu_data_files)
 	handle->page_size = tracecmd_page_size(ihandle);
 	list_head_init(&handle->options);
 
-	if (tracecmd_append_cpu_data(handle, cpus, cpu_data_files) >= 0)
-		ret = 0;
-
-	tracecmd_output_close(handle);
- out_free:
 	tracecmd_close(ihandle);
-	return ret;
-}
-
-int tracecmd_attach_cpu_data(char *file, int cpus, char * const *cpu_data_files)
-{
-	int fd;
 
-	fd = open(file, O_RDWR);
-	if (fd < 0)
-		return -1;
+	return handle;
 
-	return tracecmd_attach_cpu_data_fd(fd, cpus, cpu_data_files);
+ out_free:
+	tracecmd_close(ihandle);
+	free(handle);
+	return NULL;
 }
 
 struct tracecmd_output *
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 129f36a..f19341b 100644
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
@@ -2890,6 +2892,11 @@ setup_connection(struct buffer_instance *instance)
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
 		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
+		if (msg_handle->version == 3) {
+			add_options(network_handle, date2ts, flags);
+			tracecmd_write_cpus(network_handle, instance->cpu_count);
+			tracecmd_write_options(network_handle);
+		}
 		tracecmd_msg_finish_sending_data(msg_handle);
 	} else
 		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
@@ -2909,7 +2916,7 @@ static void finish_network(struct tracecmd_msg_handle *msg_handle)
 	free(host);
 }
 
-void start_threads(enum trace_type type, int global)
+void start_threads(enum trace_type type, int global, char *date2ts, int flags)
 {
 	struct buffer_instance *instance;
 	int *brass = NULL;
@@ -2931,7 +2938,7 @@ void start_threads(enum trace_type type, int global)
 		int x, pid;
 
 		if (host) {
-			instance->msg_handle = setup_connection(instance);
+			instance->msg_handle = setup_connection(instance, date2ts, flags);
 			if (!instance->msg_handle)
 				die("Failed to make connection");
 		}
@@ -3085,6 +3092,26 @@ enum {
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
@@ -3140,18 +3167,7 @@ static void record_data(char *date2ts, int flags)
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
@@ -3162,13 +3178,6 @@ static void record_data(char *date2ts, int flags)
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
@@ -4977,7 +4986,7 @@ static void record_trace(int argc, char **argv,
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
