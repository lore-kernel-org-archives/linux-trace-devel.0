Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751243AbeACRxl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:41 -0500
Message-Id: <20180103175339.779446639@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 34/38] trace-cmd: Add option CPUCOUNT to buffer instance options
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0034-trace-cmd-Add-option-CPUCOUNT-to-buffer-instance-opt.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a new trace.dat option that allows buffer instances to have a different
number of CPUS than what the top level buffers have.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-cmd.h    |  3 ++-
 trace-input.c  | 27 +++++++++++++++++++++++++++
 trace-output.c | 11 ++++++++++-
 trace-record.c | 55 +++++++++++++++++++++++++++++++++++++++++--------------
 4 files changed, 80 insertions(+), 16 deletions(-)

diff --git a/trace-cmd.h b/trace-cmd.h
index a3d38ec27556..a5409887e6dd 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -93,6 +93,7 @@ enum {
 	TRACECMD_OPTION_UNAME,
 	TRACECMD_OPTION_HOOK,
 	TRACECMD_OPTION_OFFSET,
+	TRACECMD_OPTION_CPUCOUNT,
 };
 
 enum {
@@ -257,7 +258,7 @@ struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    unsigned short id, int size,
 					    const void *data);
 struct tracecmd_option *tracecmd_add_buffer_option(struct tracecmd_output *handle,
-						   const char *name);
+						   const char *name, int cpus);
 int tracecmd_update_option(struct tracecmd_output *handle,
 			   struct tracecmd_option *option, int size,
 			   const void *data);
diff --git a/trace-input.c b/trace-input.c
index 15d8c1b0b6d6..30b16bab43d7 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -2102,6 +2102,7 @@ static int handle_options(struct tracecmd_input *handle)
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
+	int cpus;
 
 	for (;;) {
 		if (do_read_check(handle, &option, 2))
@@ -2183,6 +2184,10 @@ static int handle_options(struct tracecmd_input *handle)
 			hook->next = handle->hooks;
 			handle->hooks = hook;
 			break;
+		case TRACECMD_OPTION_CPUCOUNT:
+			cpus = *(int *)buf;
+			handle->cpus = __data2host4(handle->pevent, cpus);
+			break;
 		default:
 			warning("unknown option %d", option);
 			break;
@@ -2206,11 +2211,14 @@ static int read_cpu_data(struct tracecmd_input *handle)
 	unsigned long long max_size = 0;
 	unsigned long long pages;
 	char buf[10];
+	int cpus;
 	int cpu;
 
 	if (do_read_check(handle, buf, 10))
 		return -1;
 
+	cpus = handle->cpus;
+
 	/* check if this handles options */
 	if (strncmp(buf, "options", 7) == 0) {
 		if (handle_options(handle) < 0)
@@ -2293,6 +2301,25 @@ static int read_cpu_data(struct tracecmd_input *handle)
 			goto out_free;
 	}
 
+	/*
+	 * It is possible that an option changed the number of CPUs.
+	 * If that happened, then there's "empty" cpu data saved for
+	 * backward compatibility.
+	 */
+	if (cpus < handle->cpus) {
+		unsigned long long ignore;
+		int once = 0;
+
+		read8(handle, &ignore); /* offset */
+		read8(handle, &ignore); /* size */
+		if (ignore != 0) {
+			if (!once) {
+				warning("ignored CPU data not zero size");
+				once++;
+			}
+		}
+	}
+
 	return 0;
 
  out_free:
diff --git a/trace-output.c b/trace-output.c
index cbacd5426963..02efeeb669d6 100644
--- a/trace-output.c
+++ b/trace-output.c
@@ -1029,7 +1029,8 @@ int tracecmd_update_option(struct tracecmd_output *handle,
 }
 
 struct tracecmd_option *
-tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name)
+tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
+			   int cpus)
 {
 	struct tracecmd_option *option;
 	char *buf;
@@ -1046,6 +1047,14 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name)
 	option = tracecmd_add_option(handle, TRACECMD_OPTION_BUFFER, size, buf);
 	free(buf);
 
+	/*
+	 * In case a buffer instance has different number of CPUs as the
+	 * local machine.
+	 */
+	if (cpus)
+		tracecmd_add_option(handle, TRACECMD_OPTION_CPUCOUNT,
+				    sizeof(int), &cpus);
+
 	return option;
 }
 
diff --git a/trace-record.c b/trace-record.c
index bcc6f2e79cb3..9b389e7d9134 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -2970,21 +2970,53 @@ static struct tracecmd_msg_handle *start_threads(enum trace_type type, int globa
 	return msg_handle;
 }
 
+static void touch_file(const char *file)
+{
+	int fd;
+
+	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
+	if (fd < 0)
+		die("could not create file %s\n", file);
+	close(fd);
+}
+
 static void append_buffer(struct tracecmd_output *handle,
 			  struct tracecmd_option *buffer_option,
 			  struct buffer_instance *instance,
 			  char **temp_files)
 {
+	int cpu_count = instance->cpu_count;
 	int i;
 
-	for (i = 0; i < instance->cpu_count; i++)
+	/*
+	 * Since we can record remote and virtual machines in the same file
+	 * as the host, the buffers may no longer have matching number of
+	 * CPU data as the host. For backward compatibility for older
+	 * trace-cmd versions, which will blindly read the number of CPUs
+	 * for each buffer instance as there are for the host, if there are
+	 * fewer CPUs on the remote machine than on the host, an "empty"
+	 * CPU is needed for each CPU that the host has that the remote does
+	 * not. If there are more CPUs on the remote, older executables will
+	 * simply ignore them (which is OK, we only need to guarantee that
+	 * old executables don't crash).
+	 */
+	if (instance->cpu_count < local_cpu_count)
+		cpu_count = local_cpu_count;
+
+	for (i = 0; i < cpu_count; i++) {
 		temp_files[i] = get_temp_file(instance, i);
+		if (i >= instance->cpu_count)
+			touch_file(temp_files[i]);
+	}
 
 	tracecmd_append_buffer_cpu_data(handle, buffer_option,
-					instance->cpu_count, temp_files);
+					cpu_count, temp_files);
 
-	for (i = 0; i < instance->cpu_count; i++)
+	for (i = 0; i < instance->cpu_count; i++) {
+		if (i >= instance->cpu_count)
+			delete_temp_file(instance, i);
 		put_temp_file(temp_files[i]);
+	}
 }
 
 static void
@@ -3039,16 +3071,6 @@ static void add_uname(struct tracecmd_output *handle)
 	free(str);
 }
 
-static void touch_file(const char *file)
-{
-	int fd;
-
-	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
-	if (fd < 0)
-		die("could not create file %s\n", file);
-	close(fd);
-}
-
 static void print_stat(struct buffer_instance *instance)
 {
 	int cpu;
@@ -3150,7 +3172,12 @@ static void record_data(struct tracecmd_msg_handle *msg_handle,
 				die("Failed to allocate buffer options");
 			i = 0;
 			for_each_instance(instance) {
-				buffer_options[i++] = tracecmd_add_buffer_option(handle, instance->name);
+				int cpus = instance->cpu_count != local_cpu_count ?
+					instance->cpu_count : 0;
+
+				buffer_options[i++] = tracecmd_add_buffer_option(handle,
+										 instance->name,
+										 cpus);
 				add_buffer_stat(handle, instance);
 			}
 		}
-- 
2.13.2
