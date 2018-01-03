Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751121AbeACRxl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:41 -0500
Message-Id: <20180103175340.225782044@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 37/38] trace-cmd: Have keep and profile be flags of buffer instance
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0037-trace-cmd-Have-keep-and-profile-be-flags-of-buffer-i.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Instead of having separate ints for true or false fields in the buffer
instance, have them be flags. This will allow us to easily add new ones.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 trace-local.h  |  9 +++++++--
 trace-record.c | 29 +++++++++++++++--------------
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/trace-local.h b/trace-local.h
index 0665ec3c11c5..d45c66c31dca 100644
--- a/trace-local.h
+++ b/trace-local.h
@@ -160,6 +160,12 @@ char *strstrip(char *str);
 
 /* --- instance manipulation --- */
 
+enum buffer_instance_flags {
+	BUFFER_FL_KEEP		= 1 << 0,
+	BUFFER_FL_PROFILE	= 1 << 1,
+	BUFFER_FL_GUEST		= 1 << 2,
+};
+
 struct func_list {
 	struct func_list *next;
 	const char *func;
@@ -191,11 +197,10 @@ struct buffer_instance {
 
 	struct tracecmd_msg_handle *msg_handle;
 
+	int			flags;
 	int			tracing_on_init_val;
 	int			tracing_on_fd;
-	int			keep;
 	int			buffer_size;
-	int			profile;
 	int			cpu_count;
 };
 
diff --git a/trace-record.c b/trace-record.c
index e0dd5570a536..814c7e112285 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -177,7 +177,7 @@ static struct reset_file *reset_files;
 /* Triggers need to be cleared in a special way */
 static struct reset_file *reset_triggers;
 
-struct buffer_instance top_instance = { .keep = 1 };
+struct buffer_instance top_instance = { .flags = BUFFER_FL_KEEP };
 struct buffer_instance *buffer_instances;
 struct buffer_instance *first_instance;
 
@@ -3806,7 +3806,7 @@ static void make_instances(void)
 				die("mkdir %s", path);
 		} else
 			/* Don't delete instances that already exist */
-			instance->keep = 1;
+			instance->flags |= BUFFER_FL_KEEP;
 		tracecmd_put_tracing_file(path);
 	}
 }
@@ -3819,7 +3819,7 @@ void tracecmd_remove_instances(void)
 
 	for_each_instance(instance) {
 		/* Only delete what we created */
-		if (instance->keep)
+		if (instance->flags & BUFFER_FL_KEEP)
 			continue;
 		if (instance->tracing_on_fd > 0) {
 			close(instance->tracing_on_fd);
@@ -3901,7 +3901,8 @@ static void check_function_plugin(void)
 
 static int __check_doing_something(struct buffer_instance *instance)
 {
-	return instance->profile || instance->plugin || instance->events;
+	return (instance->flags & BUFFER_FL_PROFILE) ||
+		instance->plugin || instance->events;
 }
 
 static void check_doing_something(void)
@@ -4429,7 +4430,7 @@ void trace_reset(int argc, char **argv)
 				die("Failed to create instance");
 			add_instance(instance, local_cpu_count);
 			/* -d will remove keep */
-			instance->keep = 1;
+			instance->flags |= BUFFER_FL_KEEP;
 			break;
 		case 't':
 			/* Force to use top instance */
@@ -4441,18 +4442,18 @@ void trace_reset(int argc, char **argv)
 			last_specified_all = 1;
 			add_all_instances();
 			for_each_instance(instance) {
-				instance->keep = 1;
+				instance->flags |= BUFFER_FL_KEEP;
 			}
 			break;
 		case 'd':
 			if (last_specified_all) {
 				for_each_instance(inst) {
-					inst->keep = 0;
+					instance->flags &= ~BUFFER_FL_KEEP;
 				}
 			} else {
 				if (is_top_instance(instance))
 					die("Can not delete top level buffer");
-				instance->keep = 0;
+				instance->flags &= ~BUFFER_FL_KEEP;
 			}
 			break;
 		}
@@ -4769,7 +4770,7 @@ static void parse_record_options(int argc,
 				die("Failed to create instance");
 			add_instance(ctx->instance, local_cpu_count);
 			if (IS_PROFILE(ctx))
-				ctx->instance->profile = 1;
+				ctx->instance->flags |= BUFFER_FL_PROFILE;
 			break;
 		case 'k':
 			keep = 1;
@@ -4791,7 +4792,7 @@ static void parse_record_options(int argc,
 			break;
 		case OPT_profile:
 			handle_init = trace_init_profile;
-			ctx->instance->profile = 1;
+			ctx->instance->flags |= BUFFER_FL_PROFILE;
 			ctx->events = 1;
 			break;
 		case OPT_stderr:
@@ -4895,7 +4896,7 @@ static void finalize_record_trace(struct common_record_context *ctx)
 
 	/* If tracing_on was enabled before we started, set it on now */
 	for_all_instances(instance) {
-		if (instance->keep)
+		if (instance->flags & BUFFER_FL_KEEP)
 			write_tracing_on(instance,
 					 instance->tracing_on_init_val);
 	}
@@ -4933,7 +4934,7 @@ static void record_trace(int argc, char **argv,
 	/* Save the state of tracing_on before starting */
 	for_all_instances(instance) {
 
-		if (!ctx->manual && instance->profile)
+		if (!ctx->manual && instance->flags & BUFFER_FL_PROFILE)
 			enable_profile(instance);
 
 		instance->tracing_on_init_val = read_tracing_on(instance);
@@ -5052,7 +5053,7 @@ void trace_extract(int argc, char **argv)
 	/* Save the state of tracing_on before starting */
 	for_all_instances(instance) {
 
-		if (!ctx.manual && instance->profile)
+		if (!ctx.manual && instance->flags & BUFFER_FL_PROFILE)
 			enable_profile(ctx.instance);
 
 		instance->tracing_on_init_val = read_tracing_on(instance);
@@ -5124,7 +5125,7 @@ void trace_profile(int argc, char **argv)
 	 * If no instances were set, then enable profiling on the top instance.
 	 */
 	if (!buffer_instances)
-		top_instance.profile = 1;
+		top_instance.flags |= BUFFER_FL_PROFILE;
 
 	record_trace(argc, argv, &ctx);
 	do_trace_profile();
-- 
2.13.2
