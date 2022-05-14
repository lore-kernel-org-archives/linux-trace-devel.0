Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69076C433FE
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiENCzf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiENCzV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BEA34A95C
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9083961E23
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B27C341CC;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XNL-OS;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 22/26] trace-cmd agent proxy: Allow agent to send more meta data after trace
Date:   Fri, 13 May 2022 22:47:52 -0400
Message-Id: <20220514024756.1319681-23-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The options of the agent proxy trace file will need to include timings
and guest data that is added after the trace has completed. Do not close
the network handle for the meta data before the trace. Keep it open for
the proxy agent and finish writing the options at the end of the trace.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  5 +++++
 tracecmd/trace-record.c        | 39 +++++++++++++++++++++++++++++-----
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 92d005c7b12c..295be5dda7b5 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -280,6 +280,8 @@ struct buffer_instance {
 	int			buffer_size;
 	int			cpu_count;
 
+	int			proxy_fd;
+
 	int			argc;
 	char			**argv;
 
@@ -308,6 +310,9 @@ extern struct buffer_instance *first_instance;
 #define is_guest(instance)	((instance)->flags & BUFFER_FL_GUEST)
 #define is_proxy(instance)	((instance)->flags & BUFFER_FL_PROXY)
 #define is_network(instance)	((instance)->flags & BUFFER_FL_NETWORK)
+#define is_proxy_server(instance)					\
+	((instance)->msg_handle &&					\
+	 (instance)->msg_handle->flags & TRACECMD_MSG_FL_PROXY)
 
 #define START_PORT_SEARCH 1500
 #define MAX_PORT_SEARCH 6000
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7ffea4c7c76c..a6829565a679 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -720,8 +720,15 @@ static void tell_guests_to_stop(struct common_record_context *ctx)
 
 	/* Send close message to guests */
 	for_all_instances(instance) {
-		if (is_guest(instance))
+		if (is_guest(instance)) {
 			tracecmd_msg_send_close_msg(instance->msg_handle);
+			if (is_proxy(instance) && instance->proxy_fd >= 0) {
+				/* The proxy will send more data now */
+				if (tracecmd_msg_read_data(instance->msg_handle, instance->proxy_fd))
+					warning("Failed receiving finishing metadata");
+				close(instance->proxy_fd);
+			}
+		}
 	}
 
 	for_all_instances(instance) {
@@ -3974,7 +3981,15 @@ static void setup_guest(struct buffer_instance *instance)
 	/* Start reading tracing metadata */
 	if (tracecmd_msg_read_data(msg_handle, fd))
 		die("Failed receiving metadata");
-	close(fd);
+
+	/*
+	 * If connected to a proxy, then it still needs to send
+	 * the host / guest timings from its POV.
+	 */
+	if (is_proxy(instance))
+		instance->proxy_fd = fd;
+	else
+		close(fd);
 }
 
 static void setup_agent(struct buffer_instance *instance,
@@ -3987,9 +4002,14 @@ static void setup_agent(struct buffer_instance *instance,
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
 	tracecmd_write_buffer_info(network_handle);
-	tracecmd_write_options(network_handle);
-	tracecmd_write_meta_strings(network_handle);
-	tracecmd_msg_finish_sending_data(instance->msg_handle);
+	if (instance->msg_handle->flags & TRACECMD_MSG_FL_PROXY) {
+		tracecmd_prepare_options(network_handle, 0, SEEK_CUR);
+		tracecmd_msg_flush_data(instance->msg_handle);
+	} else {
+		tracecmd_write_options(network_handle);
+		tracecmd_write_meta_strings(network_handle);
+		tracecmd_msg_finish_sending_data(instance->msg_handle);
+	}
 	instance->network_handle = network_handle;
 }
 
@@ -4016,6 +4036,9 @@ static void start_threads(enum trace_type type, struct common_record_context *ct
 		int *brass = NULL;
 		int x, pid;
 
+		/* May be set by setup_guest() but all others is -1 */
+		instance->proxy_fd = -1;
+
 		if (is_agent(instance)) {
 			setup_agent(instance, ctx);
 		} else if (is_guest(instance)) {
@@ -6892,6 +6915,12 @@ static void record_trace(int argc, char **argv,
 	if (!latency)
 		wait_threads();
 
+	if (is_proxy_server(ctx->instance) && ctx->instance->network_handle) {
+		tracecmd_write_options(ctx->instance->network_handle);
+		tracecmd_write_meta_strings(ctx->instance->network_handle);
+		tracecmd_msg_finish_sending_data(ctx->instance->msg_handle);
+	}
+
 	if (IS_RECORD(ctx)) {
 		record_data(ctx);
 		delete_thread_data();
-- 
2.35.1

