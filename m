Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A82C43612
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 13:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 702882082F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 13:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390606AbfAPNn1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 08:43:27 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43455 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733175AbfAPNn1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 08:43:27 -0500
Received: by mail-wr1-f67.google.com with SMTP id r10so6946703wrs.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jan 2019 05:43:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9+GF+jrI4TNjak2yGXa8jMFomUvzyDNqUDFXxev7EiI=;
        b=c3zNzp7SVFhc5R8uYSmjWMMcXZUFad36lYVioLr4gxfu3xBREjkPqnv4zUyIYpA/bQ
         wS06r3BP/lqCyoF0l29I7N76Z+CjG7HBiO5K1rij8X8WxPTfbkg8kmZxdqve3R/TvvTw
         4x7BjAvThbwMh0+3g2Pze8UStqhwKboKLhAatpQnrkM6Kwo7dPxW6XDZu2SEMYzMxpcV
         +L7/K5rG06UWOzqq8Np4CgAlytNDDHeRBuPvSZ6Wsv8iRkydnXdHZGTjMdsPrBpKxMZP
         T4KgSiEeC4U2cK/rAtFQcaVzaPStMYHBz0KEvIgRncUl1bYEtz6v+O4B1D1H1WdXys/g
         VwaQ==
X-Gm-Message-State: AJcUukeuQkQfhLheTyfI+u7EzzLLVO1FoshJwb+yq8T1zN/YnwIGbJUC
        XqQ+09CVnpyloW746xE6F82l+rY0xfpl
X-Google-Smtp-Source: ALg8bN7mQStdI79pRKCucOJcRTfRO72oCZpX2/pHS2CLefLtgK6th1ZdLVR7zRG29+4zhLXW1sypaw==
X-Received: by 2002:adf:be0f:: with SMTP id n15mr7880948wrh.267.1547646198866;
        Wed, 16 Jan 2019 05:43:18 -0800 (PST)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y13sm34636460wme.2.2019.01.16.05.43.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 05:43:15 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v4 1/8] trace-cmd: Minor refactoring
Date:   Wed, 16 Jan 2019 15:43:00 +0200
Message-Id: <20190116134307.4185-2-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190116134307.4185-1-kaslevs@vmware.com>
References: <20190116134307.4185-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Pass `struct common_record_context` in trace-record.c instead of explicitly
passing necessary options through additional arguments.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 91 +++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 45 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 01330ee..a8c3464 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -191,6 +191,36 @@ enum {
 	RESET_HIGH_PRIO		= 100000,
 };
 
+enum trace_cmd {
+	CMD_extract,
+	CMD_start,
+	CMD_stream,
+	CMD_profile,
+	CMD_record,
+	CMD_record_agent,
+};
+
+struct common_record_context {
+	enum trace_cmd curr_cmd;
+	struct buffer_instance *instance;
+	const char *output;
+	char *date2ts;
+	char *max_graph_depth;
+	int data_flags;
+
+	int record_all;
+	int total_disable;
+	int disable;
+	int events;
+	int global;
+	int filtered;
+	int date;
+	int manual;
+	int topt;
+	int do_child;
+	int run_command;
+};
+
 static void add_reset_file(const char *file, const char *val, int prio)
 {
 	struct reset_file *reset;
@@ -2880,10 +2910,10 @@ again:
 	return msg_handle;
 }
 
-static void add_options(struct tracecmd_output *handle, char *date2ts, int flags);
+static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx);
 
 static struct tracecmd_msg_handle *
-setup_connection(struct buffer_instance *instance, char *date2ts, int flags)
+setup_connection(struct buffer_instance *instance, struct common_record_context *ctx)
 {
 	struct tracecmd_msg_handle *msg_handle;
 	struct tracecmd_output *network_handle;
@@ -2893,7 +2923,7 @@ setup_connection(struct buffer_instance *instance, char *date2ts, int flags)
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
 		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events);
-		add_options(network_handle, date2ts, flags);
+		add_options(network_handle, ctx);
 		tracecmd_write_cpus(network_handle, instance->cpu_count);
 		tracecmd_write_options(network_handle);
 		tracecmd_msg_finish_sending_data(msg_handle);
@@ -2915,7 +2945,7 @@ static void finish_network(struct tracecmd_msg_handle *msg_handle)
 	free(host);
 }
 
-void start_threads(enum trace_type type, int global, char *date2ts, int flags)
+void start_threads(enum trace_type type, struct common_record_context *ctx)
 {
 	struct buffer_instance *instance;
 	int *brass = NULL;
@@ -2937,7 +2967,7 @@ void start_threads(enum trace_type type, int global, char *date2ts, int flags)
 		int x, pid;
 
 		if (host) {
-			instance->msg_handle = setup_connection(instance, date2ts, flags);
+			instance->msg_handle = setup_connection(instance, ctx);
 			if (!instance->msg_handle)
 				die("Failed to make connection");
 		}
@@ -2952,7 +2982,7 @@ void start_threads(enum trace_type type, int global, char *date2ts, int flags)
 								   brass[0],
 								   instance->cpu_count,
 								   hooks, handle_init,
-								   global);
+								   ctx->global);
 				if (!pids[i].stream)
 					die("Creating stream for %d", i);
 			} else
@@ -3091,19 +3121,19 @@ enum {
 	DATA_FL_OFFSET		= 2,
 };
 
-static void add_options(struct tracecmd_output *handle, char *date2ts, int flags)
+static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
 {
 	int type = 0;
 
-	if (date2ts) {
-		if (flags & DATA_FL_DATE)
+	if (ctx->date2ts) {
+		if (ctx->data_flags & DATA_FL_DATE)
 			type = TRACECMD_OPTION_DATE;
-		else if (flags & DATA_FL_OFFSET)
+		else if (ctx->data_flags & DATA_FL_OFFSET)
 			type = TRACECMD_OPTION_OFFSET;
 	}
 
 	if (type)
-		tracecmd_add_option(handle, type, strlen(date2ts)+1, date2ts);
+		tracecmd_add_option(handle, type, strlen(ctx->date2ts)+1, ctx->date2ts);
 
 	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
 	add_option_hooks(handle);
@@ -3111,7 +3141,7 @@ static void add_options(struct tracecmd_output *handle, char *date2ts, int flags
 
 }
 
-static void record_data(char *date2ts, int flags)
+static void record_data(struct common_record_context *ctx)
 {
 	struct tracecmd_option **buffer_options;
 	struct tracecmd_output *handle;
@@ -3166,7 +3196,7 @@ static void record_data(char *date2ts, int flags)
 		if (!handle)
 			die("Error creating output file");
 
-		add_options(handle, date2ts, flags);
+		add_options(handle, ctx);
 
 		/* Only record the top instance under TRACECMD_OPTION_CPUSTAT*/
 		if (!no_top_instance() && !top_instance.msg_handle) {
@@ -4469,35 +4499,6 @@ void trace_reset(int argc, char **argv)
 	exit(0);
 }
 
-enum trace_cmd {
-	CMD_extract,
-	CMD_start,
-	CMD_stream,
-	CMD_profile,
-	CMD_record
-};
-
-struct common_record_context {
-	enum trace_cmd curr_cmd;
-	struct buffer_instance *instance;
-	const char *output;
-	char *date2ts;
-	char *max_graph_depth;
-	int data_flags;
-
-	int record_all;
-	int total_disable;
-	int disable;
-	int events;
-	int global;
-	int filtered;
-	int date;
-	int manual;
-	int topt;
-	int do_child;
-	int run_command;
-};
-
 static void init_common_record_context(struct common_record_context *ctx,
 				       enum trace_cmd curr_cmd)
 {
@@ -4986,7 +4987,7 @@ static void record_trace(int argc, char **argv,
 	if (type & (TRACE_TYPE_RECORD | TRACE_TYPE_STREAM)) {
 		signal(SIGINT, finish);
 		if (!latency)
-			start_threads(type, ctx->global, ctx->date2ts, ctx->data_flags);
+			start_threads(type, ctx);
 	} else {
 		update_task_filter();
 		tracecmd_enable_tracing();
@@ -5017,7 +5018,7 @@ static void record_trace(int argc, char **argv,
 		tracecmd_disable_all_tracing(0);
 
 	if (IS_RECORD(ctx)) {
-		record_data(ctx->date2ts, ctx->data_flags);
+		record_data(ctx);
 		delete_thread_data();
 	} else
 		print_stats();
@@ -5097,7 +5098,7 @@ void trace_extract(int argc, char **argv)
 		ctx.date2ts = get_date_to_ts();
 	}
 
-	record_data(ctx.date2ts, ctx.data_flags);
+	record_data(&ctx);
 	delete_thread_data();
 	destroy_stats();
 	finalize_record_trace(&ctx);
-- 
2.19.1

