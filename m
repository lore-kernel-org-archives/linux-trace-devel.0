Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751096AbeACRxl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:41 -0500
Message-Id: <20180103175339.631944908@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 33/38] trace-cmd: Have cpu_count reside in instances and not be global
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0033-trace-cmd-Have-cpu_count-reside-in-instances-and-not.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In order to be able to record remote machines (virtual or network) and
interleave it with the host traces, we need to support various amounts of
cpu counts. Move the CPU count from being global, to being in the instance.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-cmd.h    |   2 +-
 trace-local.h  |   3 +-
 trace-msg.c    |   9 +++--
 trace-record.c | 115 ++++++++++++++++++++++++++++++++-------------------------
 trace-stat.c   |   2 +-
 5 files changed, 73 insertions(+), 58 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index ca030fc0df01..a3d38ec27556 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -328,7 +328,7 @@ void tracecmd_msg_handle_close(struct tracecmd_msg_handle *msg_handle);
 
 /* for clients */
 int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
-				int total_cpus, int **client_ports);
+				int **client_ports);
 int tracecmd_msg_metadata_send(struct tracecmd_msg_handle *msg_handle,
 			       const char *buf, int size);
 int tracecmd_msg_finish_sending_metadata(struct tracecmd_msg_handle *msg_handle);
diff --git a/trace-local.h b/trace-local.h
index b03ce54e6cf4..0d85fda416e2 100644
--- a/trace-local.h
+++ b/trace-local.h
@@ -194,6 +194,7 @@ struct buffer_instance {
 	int			keep;
 	int			buffer_size;
 	int			profile;
+	int			cpu_count;
 };
 
 extern struct buffer_instance top_instance;
@@ -205,7 +206,7 @@ extern struct buffer_instance *first_instance;
 				  i = i == &top_instance ? buffer_instances : (i)->next)
 
 struct buffer_instance *create_instance(const char *name);
-void add_instance(struct buffer_instance *instance);
+void add_instance(struct buffer_instance *instance, int cpu_count);
 char *get_instance_file(struct buffer_instance *instance, const char *file);
 void update_first_instance(struct buffer_instance *instance, int topt);
 
diff --git a/trace-msg.c b/trace-msg.c
index a439c8f030a4..fe9622a040f2 100644
--- a/trace-msg.c
+++ b/trace-msg.c
@@ -195,9 +195,10 @@ enum msg_opt_command {
 };
 
 static int make_tinit(struct tracecmd_msg_handle *msg_handle,
-		      struct tracecmd_msg *msg, int total_cpus)
+		      struct tracecmd_msg *msg)
 {
 	struct tracecmd_msg_opt *opt;
+	int cpu_count = msg_handle->cpu_count;
 	int opt_num = 0;
 	int size = MIN_TINIT_SIZE;
 
@@ -212,7 +213,7 @@ static int make_tinit(struct tracecmd_msg_handle *msg_handle,
 		size += sizeof(*opt);
 	}
 
-	msg->tinit.cpus = htonl(total_cpus);
+	msg->tinit.cpus = htonl(cpu_count);
 	msg->tinit.page_size = htonl(page_size);
 	msg->tinit.opt_num = htonl(opt_num);
 
@@ -419,7 +420,7 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
 }
 
 int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
-				int total_cpus, int **client_ports)
+				int **client_ports)
 {
 	struct tracecmd_msg send_msg;
 	struct tracecmd_msg recv_msg;
@@ -431,7 +432,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 	*client_ports = NULL;
 
 	tracecmd_msg_init(MSG_TINIT, &send_msg);
-	ret = make_tinit(msg_handle, &send_msg, total_cpus);
+	ret = make_tinit(msg_handle, &send_msg);
 	if (ret < 0)
 		return ret;
 
diff --git a/trace-record.c b/trace-record.c
index 90e344d5c0c8..bcc6f2e79cb3 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -79,7 +79,6 @@ static const char *output_file = "trace.dat";
 
 static int latency;
 static int sleep_time = 1000;
-static int cpu_count;
 static int recorder_threads;
 static struct pid_record_data *pids;
 static int buffers;
@@ -102,6 +101,8 @@ static int do_ptrace;
 static int filter_task;
 static int filter_pid = -1;
 
+static int local_cpu_count;
+
 static int finished;
 
 /* setting of /proc/sys/kernel/ftrace_enabled */
@@ -286,13 +287,14 @@ static void reset_save_file_cond(const char *file, int prio,
  * add_instance - add a buffer instance to the internal list
  * @instance: The buffer instance to add
  */
-void add_instance(struct buffer_instance *instance)
+void add_instance(struct buffer_instance *instance, int cpu_count)
 {
 	init_instance(instance);
 	instance->next = buffer_instances;
 	if (first_instance == buffer_instances)
 		first_instance = instance;
 	buffer_instances = instance;
+	instance->cpu_count = cpu_count;
 	buffers++;
 }
 
@@ -392,7 +394,7 @@ static int __add_all_instances(const char *tracing_dir)
 		instance = create_instance(name);
 		if (!instance)
 			die("Failed to create instance");
-		add_instance(instance);
+		add_instance(instance, local_cpu_count);
 	}
 
 	closedir(dir);
@@ -522,7 +524,7 @@ static int kill_thread_instance(int start, struct buffer_instance *instance)
 	int n = start;
 	int i;
 
-	for (i = 0; i < cpu_count; i++) {
+	for (i = 0; i < instance->cpu_count; i++) {
 		if (pids[n].pid > 0) {
 			kill(pids[n].pid, SIGKILL);
 			delete_temp_file(instance, i);
@@ -573,7 +575,7 @@ static int delete_thread_instance(int start, struct buffer_instance *instance)
 	int n = start;
 	int i;
 
-	for (i = 0; i < cpu_count; i++) {
+	for (i = 0; i < instance->cpu_count; i++) {
 		if (pids) {
 			if (pids[n].pid) {
 				delete_temp_file(instance, i);
@@ -600,7 +602,7 @@ static void delete_thread_data(void)
 	 * isn't used.
 	 */
 	if (no_top_instance()) {
-		for (i = 0; i < cpu_count; i++)
+		for (i = 0; i < local_cpu_count; i++)
 			delete_temp_file(&top_instance, i);
 	}
 }
@@ -611,7 +613,7 @@ static void stop_threads(enum trace_type type)
 	int ret;
 	int i;
 
-	if (!cpu_count)
+	if (!recorder_threads)
 		return;
 
 	/* Tell all threads to finish up */
@@ -645,11 +647,8 @@ static void flush_threads(void)
 	long ret;
 	int i;
 
-	if (!cpu_count)
-		return;
-
 	for_all_instances(instance) {
-		for (i = 0; i < cpu_count; i++) {
+		for (i = 0; i < instance->cpu_count; i++) {
 			/* Extract doesn't support sub buffers yet */
 			ret = create_recorder(instance, i, TRACE_TYPE_EXTRACT, NULL);
 			if (ret < 0)
@@ -2100,14 +2099,14 @@ static void update_pid_event_filters(struct buffer_instance *instance)
 
 #define MASK_STR_MAX 4096 /* Don't expect more than 32768 CPUS */
 
-static char *alloc_mask_from_hex(const char *str)
+static char *alloc_mask_from_hex(struct buffer_instance *instance, const char *str)
 {
 	char *cpumask;
 
 	if (strcmp(str, "-1") == 0) {
 		/* set all CPUs */
-		int bytes = (cpu_count + 7) / 8;
-		int last = cpu_count % 8;
+		int bytes = (instance->cpu_count + 7) / 8;
+		int last = instance->cpu_count % 8;
 		int i;
 
 		cpumask = malloc(MASK_STR_MAX);
@@ -2648,7 +2647,7 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 			set_prio(rt_prio);
 
 		/* do not kill tasks on error */
-		cpu_count = 0;
+		instance->cpu_count = 0;
 	}
 
 	if (client_ports) {
@@ -2700,7 +2699,7 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 	check_first_msg_from_server(msg_handle);
 
 	/* write the number of CPUs we have (in ASCII) */
-	sprintf(buf, "%d", cpu_count);
+	sprintf(buf, "%d", local_cpu_count);
 
 	/* include \0 */
 	write(msg_handle->fd, buf, strlen(buf)+1);
@@ -2734,15 +2733,15 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 		/* No options */
 		write(msg_handle->fd, "0", 2);
 
-	client_ports = malloc(sizeof(int) * cpu_count);
+	client_ports = malloc(sizeof(int) * local_cpu_count);
 	if (!client_ports)
-		die("Failed to allocate client ports for %d cpus", cpu_count);
+		die("Failed to allocate client ports for %d cpus", local_cpu_count);
 
 	/*
 	 * Now we will receive back a comma deliminated list
 	 * of client ports to connect to.
 	 */
-	for (cpu = 0; cpu < cpu_count; cpu++) {
+	for (cpu = 0; cpu < local_cpu_count; cpu++) {
 		for (i = 0; i < BUFSIZ; i++) {
 			n = read(msg_handle->fd, buf+i, 1);
 			if (n != 1)
@@ -2759,7 +2758,7 @@ static void communicate_with_listener_v1(struct tracecmd_msg_handle *msg_handle)
 
 static void communicate_with_listener_v2(struct tracecmd_msg_handle *msg_handle)
 {
-	if (tracecmd_msg_send_init_data(msg_handle, cpu_count, &client_ports) < 0)
+	if (tracecmd_msg_send_init_data(msg_handle, &client_ports) < 0)
 		die("Cannot communicate with server");
 }
 
@@ -2864,6 +2863,7 @@ again:
 		if (!msg_handle)
 			die("Failed to allocate message handle");
 
+		msg_handle->cpu_count = local_cpu_count;
 		msg_handle->version = V2_PROTOCOL;
 	}
 
@@ -2917,6 +2917,7 @@ static struct tracecmd_msg_handle *start_threads(enum trace_type type, int globa
 	struct tracecmd_msg_handle *msg_handle = NULL;
 	struct buffer_instance *instance;
 	int *brass = NULL;
+	int total_cpu_count = 0;
 	int i = 0;
 	int ret;
 
@@ -2926,23 +2927,27 @@ static struct tracecmd_msg_handle *start_threads(enum trace_type type, int globa
 			die("Failed to make connection");
 	}
 
+	for_all_instances(instance)
+		total_cpu_count += instance->cpu_count;
+
 	/* make a thread for every CPU we have */
-	pids = malloc(sizeof(*pids) * cpu_count * (buffers + 1));
+	pids = malloc(sizeof(*pids) * total_cpu_count * (buffers + 1));
 	if (!pids)
-		die("Failed to allocat pids for %d cpus", cpu_count);
+		die("Failed to allocat pids for %d cpus", total_cpu_count);
 
-	memset(pids, 0, sizeof(*pids) * cpu_count * (buffers + 1));
+	memset(pids, 0, sizeof(*pids) * total_cpu_count * (buffers + 1));
 
 	for_all_instances(instance) {
 		int x, pid;
-		for (x = 0; x < cpu_count; x++) {
+		for (x = 0; x < instance->cpu_count; x++) {
 			if (type & TRACE_TYPE_STREAM) {
 				brass = pids[i].brass;
 				ret = pipe(brass);
 				if (ret < 0)
 					die("pipe");
 				pids[i].stream = trace_stream_init(instance, x,
-								   brass[0], cpu_count,
+								   brass[0],
+								   instance->cpu_count,
 								   hooks, handle_init,
 								   global);
 				if (!pids[i].stream)
@@ -2972,12 +2977,13 @@ static void append_buffer(struct tracecmd_output *handle,
 {
 	int i;
 
-	for (i = 0; i < cpu_count; i++)
+	for (i = 0; i < instance->cpu_count; i++)
 		temp_files[i] = get_temp_file(instance, i);
 
-	tracecmd_append_buffer_cpu_data(handle, buffer_option, cpu_count, temp_files);
+	tracecmd_append_buffer_cpu_data(handle, buffer_option,
+					instance->cpu_count, temp_files);
 
-	for (i = 0; i < cpu_count; i++)
+	for (i = 0; i < instance->cpu_count; i++)
 		put_temp_file(temp_files[i]);
 }
 
@@ -2993,7 +2999,7 @@ add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance
 			    s.len+1, s.buffer);
 	trace_seq_destroy(&s);
 
-	for (i = 0; i < cpu_count; i++)
+	for (i = 0; i < instance->cpu_count; i++)
 		tracecmd_add_option(handle, TRACECMD_OPTION_CPUSTAT,
 				    instance->s_save[i].len+1,
 				    instance->s_save[i].buffer);
@@ -3051,7 +3057,7 @@ static void print_stat(struct buffer_instance *instance)
 		if (!quiet)
 			printf("\nBuffer: %s\n\n", instance->name);
 
-	for (cpu = 0; cpu < cpu_count; cpu++)
+	for (cpu = 0; cpu < instance->cpu_count; cpu++)
 		if (!quiet)
 			trace_seq_do_printf(&instance->s_print[cpu]);
 }
@@ -3068,6 +3074,7 @@ static void record_data(struct tracecmd_msg_handle *msg_handle,
 	struct tracecmd_option **buffer_options;
 	struct tracecmd_output *handle;
 	struct buffer_instance *instance;
+	int max_cpu_count = local_cpu_count;
 	char **temp_files;
 	int i;
 
@@ -3077,16 +3084,22 @@ static void record_data(struct tracecmd_msg_handle *msg_handle,
 	}
 
 	if (latency)
-		handle = tracecmd_create_file_latency(output_file, cpu_count);
+		handle = tracecmd_create_file_latency(output_file, local_cpu_count);
 	else {
-		if (!cpu_count)
+		if (!local_cpu_count)
 			return;
 
-		temp_files = malloc(sizeof(*temp_files) * cpu_count);
+		/* Allocate enough temp files to handle each instance */
+		for_all_instances(instance)
+			if (instance->cpu_count > max_cpu_count)
+				max_cpu_count = instance->cpu_count;
+
+		temp_files = malloc(sizeof(*temp_files) * max_cpu_count);
 		if (!temp_files)
-			die("Failed to allocate temp_files for %d cpus", cpu_count);
+			die("Failed to allocate temp_files for %d cpus",
+			    local_cpu_count);
 
-		for (i = 0; i < cpu_count; i++)
+		for (i = 0; i < max_cpu_count; i++)
 			temp_files[i] = get_temp_file(&top_instance, i);
 
 		/*
@@ -3094,7 +3107,7 @@ static void record_data(struct tracecmd_msg_handle *msg_handle,
 		 * empty trace.dat files for it.
 		 */
 		if (no_top_instance()) {
-			for (i = 0; i < cpu_count; i++)
+			for (i = 0; i < local_cpu_count; i++)
 				touch_file(temp_files[i]);
 		}
 
@@ -3119,7 +3132,7 @@ static void record_data(struct tracecmd_msg_handle *msg_handle,
 		if (!no_top_instance()) {
 			struct trace_seq *s = top_instance.s_save;
 
-			for (i = 0; i < cpu_count; i++)
+			for (i = 0; i < local_cpu_count; i++)
 				tracecmd_add_option(handle, TRACECMD_OPTION_CPUSTAT,
 						    s[i].len+1, s[i].buffer);
 		}
@@ -3145,9 +3158,9 @@ static void record_data(struct tracecmd_msg_handle *msg_handle,
 		if (!no_top_instance())
 			print_stat(&top_instance);
 
-		tracecmd_append_cpu_data(handle, cpu_count, temp_files);
+		tracecmd_append_cpu_data(handle, local_cpu_count, temp_files);
 
-		for (i = 0; i < cpu_count; i++)
+		for (i = 0; i < max_cpu_count; i++)
 			put_temp_file(temp_files[i]);
 
 		if (buffers) {
@@ -3790,7 +3803,7 @@ void tracecmd_create_top_instance(char *name)
 	struct buffer_instance *instance;
 
 	instance = create_instance(name);
-	add_instance(instance);
+	add_instance(instance, local_cpu_count);
 	update_first_instance(instance, 0);
 	make_instances();
 }
@@ -3910,8 +3923,8 @@ static void allocate_seq(void)
 	struct buffer_instance *instance;
 
 	for_all_instances(instance) {
-		instance->s_save = malloc(sizeof(struct trace_seq) * cpu_count);
-		instance->s_print = malloc(sizeof(struct trace_seq) * cpu_count);
+		instance->s_save = malloc(sizeof(struct trace_seq) * instance->cpu_count);
+		instance->s_print = malloc(sizeof(struct trace_seq) * instance->cpu_count);
 		if (!instance->s_save || !instance->s_print)
 			die("Failed to allocate instance info");
 	}
@@ -3966,7 +3979,7 @@ static void record_stats(void)
 	for_all_instances(instance) {
 		s_save = instance->s_save;
 		s_print = instance->s_print;
-		for (cpu = 0; cpu < cpu_count; cpu++) {
+		for (cpu = 0; cpu < instance->cpu_count; cpu++) {
 			trace_seq_init(&s_save[cpu]);
 			trace_seq_init(&s_print[cpu]);
 			trace_seq_printf(&s_save[cpu], "CPU: %d\n", cpu);
@@ -3990,7 +4003,7 @@ static void destroy_stats(void)
 	int cpu;
 
 	for_all_instances(instance) {
-		for (cpu = 0; cpu < cpu_count; cpu++) {
+		for (cpu = 0; cpu < instance->cpu_count; cpu++) {
 			trace_seq_destroy(&instance->s_save[cpu]);
 			trace_seq_destroy(&instance->s_print[cpu]);
 		}
@@ -4272,7 +4285,7 @@ void trace_stop(int argc, char **argv)
 			instance = create_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
-			add_instance(instance);
+			add_instance(instance, local_cpu_count);
 			break;
 		case 'a':
 			add_all_instances();
@@ -4285,7 +4298,6 @@ void trace_stop(int argc, char **argv)
 		default:
 			usage(argv);
 		}
-
 	}
 	update_first_instance(instance, topt);
 	tracecmd_disable_tracing();
@@ -4313,7 +4325,7 @@ void trace_restart(int argc, char **argv)
 			instance = create_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
-			add_instance(instance);
+			add_instance(instance, local_cpu_count);
 			break;
 		case 'a':
 			add_all_instances();
@@ -4371,7 +4383,7 @@ void trace_reset(int argc, char **argv)
 			instance = create_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
-			add_instance(instance);
+			add_instance(instance, local_cpu_count);
 			/* -d will remove keep */
 			instance->keep = 1;
 			break;
@@ -4447,7 +4459,8 @@ static void init_common_record_context(struct common_record_context *ctx,
 	ctx->instance = &top_instance;
 	ctx->curr_cmd = curr_cmd;
 	init_instance(ctx->instance);
-	cpu_count = count_cpus();
+	local_cpu_count = count_cpus();
+	ctx->instance->cpu_count = local_cpu_count;
 }
 
 #define IS_EXTRACT(ctx) ((ctx)->curr_cmd == CMD_extract)
@@ -4695,7 +4708,7 @@ static void parse_record_options(int argc,
 			max_kb = atoi(optarg);
 			break;
 		case 'M':
-			ctx->instance->cpumask = alloc_mask_from_hex(optarg);
+			ctx->instance->cpumask = alloc_mask_from_hex(ctx->instance, optarg);
 			break;
 		case 't':
 			if (IS_EXTRACT(ctx))
@@ -4710,7 +4723,7 @@ static void parse_record_options(int argc,
 			ctx->instance = create_instance(optarg);
 			if (!ctx->instance)
 				die("Failed to create instance");
-			add_instance(ctx->instance);
+			add_instance(ctx->instance, local_cpu_count);
 			if (IS_PROFILE(ctx))
 				ctx->instance->profile = 1;
 			break;
diff --git a/trace-stat.c b/trace-stat.c
index fd1635470142..0fc510ab895f 100644
--- a/trace-stat.c
+++ b/trace-stat.c
@@ -907,7 +907,7 @@ void trace_stat (int argc, char **argv)
 			instance = create_instance(optarg);
 			if (!instance)
 				die("Failed to create instance");
-			add_instance(instance);
+			add_instance(instance, count_cpus());
 			/* top instance requires direct access */
 			if (!topt && is_top_instance(first_instance))
 				first_instance = instance;
-- 
2.13.2
