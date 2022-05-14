Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC82DC433FE
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiENCzb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiENCzV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B752234A94D
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 007B8B83263
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EA2C3411F;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XMd-Fv;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 11/26] trace-cmd: Move accepting tsync connection out of tracecmd_tsync_with_host()
Date:   Fri, 13 May 2022 22:47:41 -0400
Message-Id: <20220514024756.1319681-12-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In preparation for adding a agent proxy, move the acceptance of the tsync
socket out of tracecmd_tsync_with_host(). This will allow the agent to do
the accept and then act like a host.

A side effect of this is that currently if the host fails to connect to
the agent for time synchronization, the thread will never continue and be
stuck at the "accept()". This will also hang the agent when it tries to
join that thread. The recording on the host side would work as normal, but
this would leave the agent process stuck, and this could cause a leak of
processes.

By accepting before the sync, the agent would not continue, and this would
also make the host side fail (this is a good thing), and then this issue
will be detected right at the beginning.

This also requires moving the tracecmd_msg_send_trace_resp() before the
synchronization, otherwise there would be a deadlock (with the agent
waiting for the record to connect, and the record waiting for a response
from the agent).

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-timesync.c | 21 +----------------
 tracecmd/trace-agent.c         | 41 +++++++++++++++++++++++++++-------
 2 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 966aa56c5cc0..e192a74a1974 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -938,28 +938,9 @@ int tracecmd_tsync_with_guest_stop(struct tracecmd_time_sync *tsync)
 static void *tsync_agent_thread(void *data)
 {
 	struct tracecmd_time_sync *tsync = data;
-	long ret = 0;
-	int sd;
-
-	while (true) {
-		tracecmd_debug("Listening on fd:%d\n", tsync->msg_handle->fd);
-		sd = accept(tsync->msg_handle->fd, NULL, NULL);
-		tracecmd_debug("Accepted fd:%d\n", sd);
-		if (sd < 0) {
-			if (errno == EINTR)
-				continue;
-			ret = -1;
-			goto out;
-		}
-		break;
-	}
-	close(tsync->msg_handle->fd);
-	tsync->msg_handle->fd = sd;
 
 	tsync_with_host(tsync);
-
-out:
-	pthread_exit((void *)ret);
+	pthread_exit(NULL);
 }
 
 /**
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 2fe31f71e47a..7ee5fc8352c6 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -122,6 +122,28 @@ static void trace_print_connection(int fd, const char *network)
 		tracecmd_debug("Could not print connection fd:%d\n", fd);
 }
 
+static int wait_for_connection(int fd)
+{
+	int sd;
+
+	if (fd < 0)
+		return -1;
+
+	while (true) {
+		tracecmd_debug("Listening on fd:%d\n", fd);
+		sd = accept(fd, NULL, NULL);
+		tracecmd_debug("Accepted fd:%d\n", sd);
+		if (sd < 0) {
+			if (errno == EINTR)
+				continue;
+			return -1;
+		}
+		break;
+	}
+	close(fd);
+	return sd;
+}
+
 static void agent_handle(int sd, int nr_cpus, int page_size, const char *network)
 {
 	struct tracecmd_tsync_protos *tsync_protos = NULL;
@@ -186,23 +208,26 @@ static void agent_handle(int sd, int nr_cpus, int page_size, const char *network
 				fd = -1;
 			}
 		}
-		if (fd >= 0) {
+	}
+	trace_id = tracecmd_generate_traceid();
+	ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size,
+					   ports, use_fifos, trace_id,
+					   tsync_proto, tsync_port);
+	if (ret < 0)
+		die("Failed to send trace response");
+
+	if (tsync_proto) {
+		fd = wait_for_connection(fd);
+		if (fd >= 0)
 			tsync = tracecmd_tsync_with_host(fd, tsync_proto,
 							 get_clock(argc, argv),
 							 remote_id, local_id);
-		}
 		if (!tsync) {
 			warning("Failed to negotiate timestamps synchronization with the host");
 			if (fd >= 0)
 				close(fd);
 		}
 	}
-	trace_id = tracecmd_generate_traceid();
-	ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size,
-					   ports, use_fifos, trace_id,
-					   tsync_proto, tsync_port);
-	if (ret < 0)
-		die("Failed to send trace response");
 
 	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv,
 			   use_fifos, trace_id, network);
-- 
2.35.1

