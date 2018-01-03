Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751040AbeACRxg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jan 2018 12:53:36 -0500
Message-Id: <20180103175335.324450316@goodmis.org>
Date: Wed, 03 Jan 2018 12:52:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/38] trace-cmd record: Fix clearing out the ctx->instance when used in
 for_all_instances()
References: <20180103175202.044283643@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-trace-cmd-record-Fix-clearing-out-the-ctx-instance-w.patch
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The for_all_instances() macro takes the variable passed to it and uses it as
an iterator descriptor. That is, it is set to each instance, and when the
loop is complete, the variable will be NULL.

The ctx->instance is suppose to hold the main instance, and by using it as
an iterator, it will be NULL at the end. Use a local variable instance.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 trace-record.c | 56 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/trace-record.c b/trace-record.c
index f128257662b4..5088f7ae0852 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -4784,6 +4784,8 @@ static enum trace_type get_trace_cmd_type(enum trace_cmd cmd)
 
 static void finalize_record_trace(struct common_record_context *ctx)
 {
+	struct buffer_instance *instance;
+
 	if (keep)
 		return;
 
@@ -4797,10 +4799,10 @@ static void finalize_record_trace(struct common_record_context *ctx)
 	tracecmd_remove_instances();
 
 	/* If tracing_on was enabled before we started, set it on now */
-	for_all_instances(ctx->instance) {
-		if (ctx->instance->keep)
-			write_tracing_on(ctx->instance,
-					 ctx->instance->tracing_on_init_val);
+	for_all_instances(instance) {
+		if (instance->keep)
+			write_tracing_on(instance,
+					 instance->tracing_on_init_val);
 	}
 
 	if (host)
@@ -4815,6 +4817,7 @@ static void record_trace(int argc, char **argv,
 			 struct common_record_context *ctx)
 {
 	enum trace_type type = get_trace_cmd_type(ctx->curr_cmd);
+	struct buffer_instance *instance;
 
 	/*
 	 * If top_instance doesn't have any plugins or events, then
@@ -4833,15 +4836,15 @@ static void record_trace(int argc, char **argv,
 		output_file = ctx->output;
 
 	/* Save the state of tracing_on before starting */
-	for_all_instances(ctx->instance) {
+	for_all_instances(instance) {
 
-		if (!ctx->manual && ctx->instance->profile)
-			enable_profile(ctx->instance);
+		if (!ctx->manual && instance->profile)
+			enable_profile(instance);
 
-		ctx->instance->tracing_on_init_val = read_tracing_on(ctx->instance);
+		instance->tracing_on_init_val = read_tracing_on(instance);
 		/* Some instances may not be created yet */
-		if (ctx->instance->tracing_on_init_val < 0)
-			ctx->instance->tracing_on_init_val = 1;
+		if (instance->tracing_on_init_val < 0)
+			instance->tracing_on_init_val = 1;
 	}
 
 	make_instances();
@@ -4854,21 +4857,21 @@ static void record_trace(int argc, char **argv,
 	fset = set_ftrace(!ctx->disable, ctx->total_disable);
 	tracecmd_disable_all_tracing(1);
 
-	for_all_instances(ctx->instance)
-		set_clock(ctx->instance);
+	for_all_instances(instance)
+		set_clock(instance);
 
 	/* Record records the date first */
 	if (IS_RECORD(ctx) && ctx->date)
 		ctx->date2ts = get_date_to_ts();
 
-	for_all_instances(ctx->instance) {
-		set_funcs(ctx->instance);
-		set_mask(ctx->instance);
+	for_all_instances(instance) {
+		set_funcs(instance);
+		set_mask(instance);
 	}
 
 	if (ctx->events) {
-		for_all_instances(ctx->instance)
-			enable_events(ctx->instance);
+		for_all_instances(instance)
+			enable_events(instance);
 	}
 
 	set_buffer_size();
@@ -4876,8 +4879,8 @@ static void record_trace(int argc, char **argv,
 	set_options();
 
 	if (ctx->max_graph_depth) {
-		for_all_instances(ctx->instance)
-			set_max_graph_depth(ctx->instance, ctx->max_graph_depth);
+		for_all_instances(instance)
+			set_max_graph_depth(instance, ctx->max_graph_depth);
 		free(ctx->max_graph_depth);
 	}
 
@@ -4938,6 +4941,7 @@ void trace_start(int argc, char **argv)
 void trace_extract(int argc, char **argv)
 {
 	struct common_record_context ctx;
+	struct buffer_instance *instance;
 	enum trace_type type;
 
 	parse_record_options(argc, argv, CMD_extract, &ctx);
@@ -4951,15 +4955,15 @@ void trace_extract(int argc, char **argv)
 		output_file = ctx.output;
 
 	/* Save the state of tracing_on before starting */
-	for_all_instances(ctx.instance) {
+	for_all_instances(instance) {
 
-		if (!ctx.manual && ctx.instance->profile)
+		if (!ctx.manual && instance->profile)
 			enable_profile(ctx.instance);
 
-		ctx.instance->tracing_on_init_val = read_tracing_on(ctx.instance);
+		instance->tracing_on_init_val = read_tracing_on(instance);
 		/* Some instances may not be created yet */
-		if (ctx.instance->tracing_on_init_val < 0)
-			ctx.instance->tracing_on_init_val = 1;
+		if (instance->tracing_on_init_val < 0)
+			instance->tracing_on_init_val = 1;
 	}
 
 	/* Extracting data records all events in the system. */
@@ -4974,8 +4978,8 @@ void trace_extract(int argc, char **argv)
 	set_options();
 
 	if (ctx.max_graph_depth) {
-		for_all_instances(ctx.instance)
-			set_max_graph_depth(ctx.instance, ctx.max_graph_depth);
+		for_all_instances(instance)
+			set_max_graph_depth(instance, ctx.max_graph_depth);
 		free(ctx.max_graph_depth);
 	}
 
-- 
2.13.2
