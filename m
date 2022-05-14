Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4064FC4332F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiENCz1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiENCzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0632F34A37B
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0921061E17
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B081DC341C5;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XMt-Jo;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 15/26] trace-cmd record: Add trace_tsync_as_host() helper
Date:   Fri, 13 May 2022 22:47:45 -0400
Message-Id: <20220514024756.1319681-16-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In the process of adding an agent proxy, it will be useful to have a
function that will allow the agent to synchronize as the host. Move the
code to do so into a helper function that can be used by the agent. This
will be later moved to a separate file.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 57 +++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f05ad09c9723..2c595a7918f0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3979,12 +3979,42 @@ static void stop_mapping_vcpus(int cpu_count, struct trace_guest *guest)
 	tracefs_instance_free(guest->instance);
 }
 
+static struct tracecmd_time_sync *
+trace_tsync_as_host(int fd, unsigned long long trace_id,
+		    int loop_interval, int guest_id,
+		    int guest_cpus, const char *proto_name,
+		    const char *clock)
+{
+	struct tracecmd_time_sync *tsync;
+	struct trace_guest *guest;
+	int guest_pid = -1;
+
+	if (fd < 0)
+		return NULL;
+
+	if (guest_id >= 0) {
+		guest = trace_get_guest(guest_id, NULL);
+		if (guest == NULL)
+			return NULL;
+		guest_pid = guest->pid;
+		start_mapping_vcpus(guest);
+	}
+
+	tsync = tracecmd_tsync_with_guest(trace_id, loop_interval, fd,
+					  guest_pid, guest_cpus, proto_name,
+					  clock);
+
+	if (guest_id >= 0)
+		stop_mapping_vcpus(guest_cpus, guest);
+
+	return tsync;
+}
+
 static int host_tsync(struct common_record_context *ctx,
 		      struct buffer_instance *instance,
 		      unsigned int tsync_port, char *proto)
 {
-	struct trace_guest *guest;
-	int guest_pid = -1;
+	int guest_id = -1;
 	int fd;
 
 	if (!proto)
@@ -3994,27 +4024,16 @@ static int host_tsync(struct common_record_context *ctx,
 		fd = connect_port(instance->name, tsync_port,
 				  instance->port_type);
 	} else {
-		guest = trace_get_guest(instance->cid, NULL);
-		if (guest == NULL)
-			return -1;
-
-		guest_pid = guest->pid;
-		start_mapping_vcpus(guest);
+		guest_id = instance->cid;
 		fd = trace_vsock_open(instance->cid, tsync_port);
 	}
 
-	instance->tsync = tracecmd_tsync_with_guest(top_instance.trace_id,
-						    instance->tsync_loop_interval,
-						    fd, guest_pid,
-						    instance->cpu_count,
-						    proto, ctx->clock);
-	if (!is_network(instance))
-		stop_mapping_vcpus(instance->cpu_count, guest);
+	instance->tsync = trace_tsync_as_host(fd, top_instance.trace_id,
+					      instance->tsync_loop_interval,
+					      guest_id, instance->cpu_count,
+					      proto, ctx->clock);
 
-	if (!instance->tsync)
-		return -1;
-
-	return 0;
+	return instance->tsync ? 0 : -1;
 }
 
 static void connect_to_agent(struct common_record_context *ctx,
-- 
2.35.1

