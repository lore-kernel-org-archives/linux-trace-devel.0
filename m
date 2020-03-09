Return-Path: <SRS0=4xj7=42=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D55C10F29
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 19:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFD5B2465A
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 19:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgCITF3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Mar 2020 15:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727855AbgCITF2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Mar 2020 15:05:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1469A24655
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Mar 2020 19:05:28 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jBNiR-0033C6-0P
        for linux-trace-devel@vger.kernel.org; Mon, 09 Mar 2020 15:05:27 -0400
Message-Id: <20200309190526.886340672@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 09 Mar 2020 15:04:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Have instances include a copy of its output file
References: <20200309190449.207021960@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of having a global "output_file", store the output file in the
instance itself. That way it can be used instead of having to pass around
a global variable.

This also fixes a bug when an output file option is used, and it can break
the recording of the guest, as the tsync currently looks for the "default"
recording name. Instead, it can now look at the output file stored in the
instance (which will hold the guest name).

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  1 +
 tracecmd/trace-record.c        | 31 ++++++++++++++++---------------
 tracecmd/trace-tsync.c         |  6 ++----
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 5ef569f03553..0f58c7721b88 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -189,6 +189,7 @@ struct buffer_instance {
 	struct tracefs_instance	*tracefs;
 	unsigned long long	trace_id;
 	char			*cpumask;
+	char			*output_file;
 	struct event_list	*events;
 	struct event_list	**event_next;
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 280dc9ddf23a..c945a56ab7ab 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -69,8 +69,6 @@ static int rt_prio;
 
 static int keep;
 
-static const char *output_file = DEFAULT_INPUT_FILE;
-
 static int latency;
 static int sleep_time = 1000;
 static int recorder_threads;
@@ -524,6 +522,7 @@ static void reset_event_list(struct buffer_instance *instance)
 
 static char *get_temp_file(struct buffer_instance *instance, int cpu)
 {
+	const char *output_file = instance->output_file;
 	const char *name;
 	char *file = NULL;
 	int size;
@@ -572,6 +571,7 @@ static void put_temp_file(char *file)
 
 static void delete_temp_file(struct buffer_instance *instance, int cpu)
 {
+	const char *output_file = instance->output_file;
 	const char *name;
 	char file[PATH_MAX];
 
@@ -3777,6 +3777,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 static void setup_guest(struct buffer_instance *instance)
 {
 	struct tracecmd_msg_handle *msg_handle = instance->msg_handle;
+	const char *output_file = instance->output_file;
 	char *file;
 	int fd;
 
@@ -3786,8 +3787,10 @@ static void setup_guest(struct buffer_instance *instance)
 	if (!file)
 		die("Failed to allocate memory");
 
+	free(instance->output_file);
+	instance->output_file = file;
+
 	fd = open(file, O_CREAT|O_WRONLY|O_TRUNC, 0644);
-	put_temp_file(file);
 	if (fd < 0)
 		die("Failed to open", file);
 
@@ -4119,15 +4122,10 @@ static void write_guest_file(struct buffer_instance *instance)
 	char **temp_files;
 	int i, fd;
 
-	file = trace_get_guest_file(output_file,
-				    tracefs_instance_get_name(instance->tracefs));
-	if (!file)
-		die("Failed to allocate memory");
-
+	file = instance->output_file;
 	fd = open(file, O_RDWR);
 	if (fd < 0)
 		die("error opening %s", file);
-	put_temp_file(file);
 
 	handle = tracecmd_get_output_handle_fd(fd);
 	if (!handle)
@@ -4176,7 +4174,7 @@ static void record_data(struct common_record_context *ctx)
 		return;
 
 	if (latency) {
-		handle = tracecmd_create_file_latency(output_file, local_cpu_count);
+		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
@@ -4207,7 +4205,7 @@ static void record_data(struct common_record_context *ctx)
 				touch_file(temp_files[i]);
 		}
 
-		handle = tracecmd_create_init_file_glob(output_file, listed_events);
+		handle = tracecmd_create_init_file_glob(ctx->output, listed_events);
 		if (!handle)
 			die("Error creating output file");
 		tracecmd_set_quiet(handle, quiet);
@@ -6165,11 +6163,14 @@ static void record_trace(int argc, char **argv,
 	check_doing_something();
 	check_function_plugin();
 
-	if (ctx->output)
-		output_file = ctx->output;
+	if (!ctx->output)
+		ctx->output = DEFAULT_INPUT_FILE;
 
 	/* Save the state of tracing_on before starting */
 	for_all_instances(instance) {
+		instance->output_file = strdup(ctx->output);
+		if (!instance->output_file)
+			die("Failed to allocate output file name for instance");
 		if (!ctx->manual && instance->flags & BUFFER_FL_PROFILE)
 			enable_profile(instance);
 
@@ -6300,8 +6301,8 @@ void trace_extract(int argc, char **argv)
 	update_first_instance(ctx.instance, 1);
 	check_function_plugin();
 
-	if (ctx.output)
-		output_file = ctx.output;
+	if (!ctx.output)
+		ctx.output = DEFAULT_INPUT_FILE;
 
 	/* Save the state of tracing_on before starting */
 	for_all_instances(instance) {
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index eab2fda5b120..e639788d2f3f 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -130,7 +130,7 @@ static void write_guest_time_shift(struct buffer_instance *instance)
 	struct iovec vector[4];
 	long long *offsets;
 	long long *ts;
-	char *file;
+	const char *file;
 	int count;
 	int ret;
 	int fd;
@@ -139,12 +139,10 @@ static void write_guest_time_shift(struct buffer_instance *instance)
 	if (ret < 0 || !count || !ts || !offsets)
 		return;
 
-	file = trace_get_guest_file(DEFAULT_INPUT_FILE,
-				tracefs_instance_get_name(instance->tracefs));
+	file = instance->output_file;
 	fd = open(file, O_RDWR);
 	if (fd < 0)
 		die("error opening %s", file);
-	free(file);
 	handle = tracecmd_get_output_handle_fd(fd);
 	vector[0].iov_len = 8;
 	vector[0].iov_base = &top_instance.trace_id;
-- 
2.25.0


