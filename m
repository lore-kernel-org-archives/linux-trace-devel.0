Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2895AC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 01:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiDOBC4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Apr 2022 21:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348330AbiDOBCj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Apr 2022 21:02:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC50827FC0
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 18:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57ADDB80DBB
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 01:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C24C385AE;
        Fri, 15 Apr 2022 01:00:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nfAJk-003w8j-Qr;
        Thu, 14 Apr 2022 21:00:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6/8] trace-cmd library: Remove dependency on vsocks from tracecmd_tsync_get_session_params()
Date:   Thu, 14 Apr 2022 21:00:05 -0400
Message-Id: <20220415010007.938408-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415010007.938408-1-rostedt@goodmis.org>
References: <20220415010007.938408-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The only thing the application needs to get from the tsync is really
just the selected protocol. The port can be found elsewhere. Decouple
the two from tracecmd_tsync_get_session_params() and rename it to
tracecmd_tsync_get_selected_proto() just to return the selected
protocol.

This is needed to decouple vsockets from libtracecmd.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  5 ++-
 lib/trace-cmd/trace-timesync.c                | 20 ++---------
 tracecmd/trace-agent.c                        | 34 ++++++++++++++++---
 3 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 06906b04fbd9..1839d82d4e11 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -499,9 +499,8 @@ int tracecmd_tsync_with_guest_stop(struct tracecmd_time_sync *tsync);
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync, int cpu,
 			       int *count, long long **ts,
 			       long long **offsets, long long **scalings, long long **frac);
-int tracecmd_tsync_get_session_params(struct tracecmd_time_sync *tsync,
-				      char **selected_proto,
-				      unsigned int *tsync_port);
+int tracecmd_tsync_get_selected_proto(struct tracecmd_time_sync *tsync,
+				      char **selected_proto);
 void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
 int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 				    struct tracecmd_time_sync *tsync);
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 2f812ca5fc74..6f16090c2eb4 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -1098,37 +1098,23 @@ int tracecmd_tsync_with_host_stop(struct tracecmd_time_sync *tsync)
 }
 
 /**
- * tracecmd_tsync_get_session_params - Get parameters of established time sync session
- *
+ * tracecmd_tsync_get_selected_proto - Return the seleceted time sync protocol
  * @tsync: Time sync context, representing a running time sync session
  * @selected_proto: return, name of the selected time sync protocol for this session
- * @tsync_port: return, a VSOCK port on which new time sync requests are accepted.
  *
  * Returns 0 on success, or -1 in case of an error.
  *
  */
-int tracecmd_tsync_get_session_params(struct tracecmd_time_sync *tsync,
-				      char **selected_proto,
-				      unsigned int *tsync_port)
+int tracecmd_tsync_get_selected_proto(struct tracecmd_time_sync *tsync,
+				      char **selected_proto)
 {
-	int ret;
-
 	if (!tsync)
 		return -1;
 
-	if (tsync_port) {
-		if (!tsync->msg_handle)
-			return -1;
-		ret = vsock_get_port(tsync->msg_handle->fd, tsync_port);
-		if (ret < 0)
-			return ret;
-	}
 	if (selected_proto) {
 		if (!tsync->proto_name)
 			return -1;
 		(*selected_proto) = strdup(tsync->proto_name);
-
 	}
-
 	return 0;
 }
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 151ca19c2270..1a9463fd4854 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -163,10 +163,32 @@ static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid)
 
 	return 0;
 }
+
+static int vsock_get_port(int sd, unsigned int *port)
+{
+	struct sockaddr_vm addr;
+	socklen_t addr_len = sizeof(addr);
+
+	if (getsockname(sd, (struct sockaddr *)&addr, &addr_len))
+		return -errno;
+
+	if (addr.svm_family != AF_VSOCK)
+		return -EINVAL;
+
+	if (port)
+		*port = addr.svm_port;
+
+	return 0;
+}
 #else
 static inline int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid) {
 	return -1;
 }
+
+static int vsock_get_port(int sd, unsigned int *port)
+{
+	return -ENOTSUP;
+}
 #endif
 
 static void agent_handle(int sd, int nr_cpus, int page_size)
@@ -214,11 +236,15 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 			remote_id = -1;
 			local_id = -2;
 		}
-		tsync = tracecmd_tsync_with_host(tsync_protos,
-						 get_clock(argc, argv),
-						 remote_id, local_id);
+		if (vsock_get_port(msg_handle->fd, &tsync_port) >= 0) {
+			tsync = tracecmd_tsync_with_host(tsync_protos,
+							 get_clock(argc, argv),
+							 remote_id, local_id);
+		} else {
+			tsync = NULL;
+		}
 		if (tsync)
-			tracecmd_tsync_get_session_params(tsync, &tsync_proto, &tsync_port);
+			tracecmd_tsync_get_selected_proto(tsync, &tsync_proto);
 		else
 			warning("Failed to negotiate timestamps synchronization with the host");
 	}
-- 
2.35.1

