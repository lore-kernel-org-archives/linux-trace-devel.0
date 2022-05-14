Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D15C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiENCzd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiENCzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DDA34A949
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3972961E07
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E78C341D2;
        Sat, 14 May 2022 02:47:59 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XNb-R1;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 26/26] trace-cmd: Have the host agent proxy control the time synchronization
Date:   Fri, 13 May 2022 22:47:56 -0400
Message-Id: <20220514024756.1319681-27-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The time synchronization logic between agent and recorder made the
assumption that the host is running the recorder and the guest is
running the agent. This is very limiting, especially for environments
where you have a streamlined host that has no disk space, and a guest
that is "privileged".

Have the agent proxy handle the time synchronization for the host, and
the trace-cmd record running on the guest retrieve this information from
the host.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  5 ++--
 tracecmd/trace-agent.c         | 17 +++++++++---
 tracecmd/trace-record.c        | 47 ++++++++++++++++++++++++++--------
 tracecmd/trace-tsync.c         | 12 +++++----
 4 files changed, 60 insertions(+), 21 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index a86d22ca9ad8..3d025f86fb19 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -121,8 +121,9 @@ void trace_convert(int argc, char **argv);
 
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
-		       int argc, char **argv, bool use_fifos,
-		       unsigned long long trace_id, const char *host);
+		       int argc, char **argv,
+		       bool use_fifos, struct tracecmd_time_sync *tsync,
+		       unsigned long long trace_id, int rcid, const char *host);
 
 struct hook_list;
 
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 3098a1ea2b8b..ea41ad540701 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -238,17 +238,26 @@ static void agent_handle(int sd, int nr_cpus, int page_size,
 
 	if (tsync_proto) {
 		fd = wait_for_connection(fd);
-		tsync = trace_tsync_as_guest(fd, tsync_proto, get_clock(argc, argv),
-					     remote_id, local_id);
+
+		if (rcid >= 0) {
+			tsync = trace_tsync_as_host(fd, trace_id, 0, rcid,
+						    client_cpus, tsync_proto,
+						    get_clock(argc, argv));
+		} else {
+			tsync = trace_tsync_as_guest(fd, tsync_proto,
+						     get_clock(argc, argv),
+						     remote_id, local_id);
+		}
 		if (!tsync)
 			close(fd);
 	}
 
 	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv,
-			   use_fifos, trace_id, network);
+			   use_fifos, tsync, trace_id, rcid, network);
 
 	if (tsync) {
-		tracecmd_tsync_with_host_stop(tsync);
+		if (rcid < 0)
+			tracecmd_tsync_with_host_stop(tsync);
 		tracecmd_tsync_free(tsync);
 	}
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e0d2f2b0f554..541bce7298ce 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -686,6 +686,12 @@ add_tsc2nsec(struct tracecmd_output *handle, struct tsc_nsec *tsc2nsec)
 	tracecmd_add_option_v(handle, TRACECMD_OPTION_TSC2NSEC, vector, 3);
 }
 
+static void guest_tsync_complete(struct buffer_instance *instance)
+{
+	tracecmd_tsync_with_host_stop(instance->tsync);
+	tracecmd_tsync_free(instance->tsync);
+}
+
 static void host_tsync_complete(struct common_record_context *ctx,
 				struct buffer_instance *instance)
 {
@@ -732,8 +738,12 @@ static void tell_guests_to_stop(struct common_record_context *ctx)
 	}
 
 	for_all_instances(instance) {
-		if (is_guest(instance))
-			host_tsync_complete(ctx, instance);
+		if (is_guest(instance)) {
+			if (is_proxy(instance))
+				guest_tsync_complete(instance);
+			else
+				host_tsync_complete(ctx, instance);
+		}
 	}
 
 	/* Wait for guests to acknowledge */
@@ -3851,11 +3861,15 @@ static int host_tsync(struct common_record_context *ctx,
 		fd = trace_vsock_open(instance->cid, tsync_port);
 	}
 
-	instance->tsync = trace_tsync_as_host(fd, top_instance.trace_id,
-					      instance->tsync_loop_interval,
-					      guest_id, instance->cpu_count,
-					      proto, ctx->clock);
-
+	if (is_proxy(instance)) {
+		instance->tsync = trace_tsync_as_guest(fd, proto, ctx->clock,
+						       guest_id, -1);
+	} else {
+		instance->tsync = trace_tsync_as_host(fd, top_instance.trace_id,
+						      instance->tsync_loop_interval,
+						      guest_id, instance->cpu_count,
+						      proto, ctx->clock);
+	}
 	return instance->tsync ? 0 : -1;
 }
 
@@ -4267,6 +4281,7 @@ enum {
 	DATA_FL_DATE		= 1,
 	DATA_FL_OFFSET		= 2,
 	DATA_FL_GUEST		= 4,
+	DATA_FL_PROXY		= 8,
 };
 
 static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
@@ -6235,6 +6250,11 @@ static void parse_record_options(int argc,
 			ctx->instance->name = name;
 			add_instance(ctx->instance, 0);
 			ctx->data_flags |= DATA_FL_GUEST;
+
+			/* Do not send a clock to a proxy */
+			if (is_proxy)
+				ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
+
 			break;
 		}
 		case 'F':
@@ -6706,6 +6726,8 @@ static void finalize_record_trace(struct common_record_context *ctx)
 			tracecmd_msg_wait(ctx->instance->msg_handle);
 			if (ctx->tsc2nsec.mult)
 				add_tsc2nsec(ctx->instance->network_handle, &ctx->tsc2nsec);
+			tracecmd_write_guest_time_shift(ctx->instance->network_handle,
+							ctx->instance->tsync);
 			tracecmd_msg_send_options(ctx->instance->msg_handle,
 						  ctx->instance->network_handle);
 		}
@@ -6821,7 +6843,7 @@ static void record_trace(int argc, char **argv,
 	if (!ctx->output)
 		ctx->output = DEFAULT_INPUT_FILE;
 
-	if (ctx->data_flags & DATA_FL_GUEST)
+	if (ctx->data_flags & (DATA_FL_GUEST | DATA_FL_PROXY))
 		set_tsync_params(ctx);
 
 	make_instances();
@@ -7129,8 +7151,9 @@ void trace_record(int argc, char **argv)
  */
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
-		       int argc, char **argv, bool use_fifos,
-		       unsigned long long trace_id, const char *host)
+		       int argc, char **argv,
+		       bool use_fifos, struct tracecmd_time_sync *tsync,
+		       unsigned long long trace_id, int rcid, const char *host)
 {
 	struct common_record_context ctx;
 	char **argv_plus;
@@ -7158,8 +7181,12 @@ int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 	ctx.instance->fds = fds;
 	ctx.instance->use_fifos = use_fifos;
 	ctx.instance->flags |= BUFFER_FL_AGENT;
+	if (rcid >= 0)
+		ctx.data_flags |= DATA_FL_PROXY;
 	ctx.instance->msg_handle = msg_handle;
 	ctx.instance->host = host;
+	ctx.instance->tsync = tsync;
+	ctx.instance->cid = rcid;
 	msg_handle->version = V3_PROTOCOL;
 	top_instance.trace_id = trace_id;
 	record_trace(argc, argv, &ctx);
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index 45ebb9c66a19..a96b4e43e0d9 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -228,15 +228,17 @@ struct tracecmd_time_sync *
 trace_tsync_as_guest(int fd, const char *tsync_proto, const char *clock,
 	       unsigned int remote_id, unsigned int local_id)
 {
-	struct tracecmd_time_sync *tsync;
+	struct tracecmd_time_sync *tsync = NULL;
 
 	if (fd < 0)
-		return NULL;
+		 return NULL;
 
-	tsync = tracecmd_tsync_with_host(fd, tsync_proto, clock,
-					 remote_id, local_id);
-	if (!tsync)
+	tsync = tracecmd_tsync_with_host(fd, tsync_proto,
+					 clock, remote_id, local_id);
+	if (!tsync) {
 		warning("Failed to negotiate timestamps synchronization with the host");
+		return NULL;
+	}
 
 	return tsync;
 }
-- 
2.35.1

