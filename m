Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D646BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 01:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239380AbiDOBCz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Apr 2022 21:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348319AbiDOBCh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Apr 2022 21:02:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A69B27CCC
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 18:00:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 719A4621F7
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 01:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF1DC385A7;
        Fri, 15 Apr 2022 01:00:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nfAJk-003w8d-PC;
        Thu, 14 Apr 2022 21:00:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4/8] trace-cmd library: Remove dependency on vsocks for sync identifiers
Date:   Thu, 14 Apr 2022 21:00:03 -0400
Message-Id: <20220415010007.938408-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415010007.938408-1-rostedt@goodmis.org>
References: <20220415010007.938408-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In an effort to remove the dependency on vsockets from libtracecmd
and synchronization, move the creation of remote and local ids out of
the library and change tracecmd_tsync_with_host() to pass in those
identifiers.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  2 +-
 lib/trace-cmd/include/trace-tsync-local.h     |  2 +
 lib/trace-cmd/trace-timesync.c                | 42 ++++---------------
 tracecmd/trace-agent.c                        | 41 +++++++++++++++++-
 4 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 69343765c5ff..24295e4e09d3 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -489,7 +489,7 @@ int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const cha
 bool tsync_proto_is_supported(const char *proto_name);
 struct tracecmd_time_sync *
 tracecmd_tsync_with_host(const struct tracecmd_tsync_protos *tsync_protos,
-			 const char *clock);
+			 const char *clock, int remote_id, int local_id);
 int tracecmd_tsync_with_host_stop(struct tracecmd_time_sync *tsync);
 struct tracecmd_time_sync *
 tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 4340dfaf80ca..697c076c43a6 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -22,6 +22,8 @@ struct tracecmd_time_sync {
 	void				*context;
 	int				guest_pid;
 	int				vcpu_count;
+	int				remote_id;
+	int				local_id;
 };
 
 struct clock_sync_offsets {
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 594f660e2a40..b41aece82082 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -405,29 +405,6 @@ int __hidden vsock_get_port(int sd, unsigned int *port)
 	return 0;
 }
 
-static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid)
-{
-	struct sockaddr_vm addr;
-	socklen_t addr_len = sizeof(addr);
-
-	memset(&addr, 0, sizeof(addr));
-	if (getsockname(fd, (struct sockaddr *)&addr, &addr_len))
-		return -1;
-	if (addr.svm_family != AF_VSOCK)
-		return -1;
-	*lcid = addr.svm_cid;
-
-	memset(&addr, 0, sizeof(addr));
-	addr_len = sizeof(addr);
-	if (getpeername(fd, (struct sockaddr *)&addr, &addr_len))
-		return -1;
-	if (addr.svm_family != AF_VSOCK)
-		return -1;
-	*rcid = addr.svm_cid;
-
-	return 0;
-}
-
 #else
 static int vsock_open(unsigned int cid, unsigned int port)
 {
@@ -444,12 +421,6 @@ static int vsock_get_port(int sd, unsigned int *port)
 {
 	return -ENOTSUP;
 }
-
-static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid)
-{
-	return -ENOTSUP;
-}
-
 #endif /* VSOCK */
 
 static struct tracefs_instance *
@@ -498,12 +469,8 @@ static int clock_context_init(struct tracecmd_time_sync *tsync,
 	clock->is_guest = guest;
 	clock->is_server = clock->is_guest;
 
-	if (get_vsocket_params(tsync->msg_handle->fd, &clock->local_id,
-			       &clock->remote_id))
-		goto error;
-
 	clock->instance = clock_synch_create_instance(tsync->clock_str,
-						      clock->remote_id);
+						      tsync->remote_id);
 	if (!clock->instance)
 		goto error;
 
@@ -1071,6 +1038,8 @@ out:
  * @tsync_protos: List of tsync protocols, supported by the host
  * @clock: Trace clock, used for that session
  * @port: returned, VSOCKET port, on which the guest listens for tsync requests
+ * @remote_id: Identifier to uniquely identify the remote host
+ * @local_id: Identifier to uniquely identify the local machine
  *
  * On success, a pointer to time sync context is returned, or NULL in
  * case of an error. The context must be freed with tracecmd_tsync_free()
@@ -1080,7 +1049,7 @@ out:
  */
 struct tracecmd_time_sync *
 tracecmd_tsync_with_host(const struct tracecmd_tsync_protos *tsync_protos,
-			 const char *clock)
+			 const char *clock, int remote_id, int local_id)
 {
 	struct tracecmd_time_sync *tsync;
 	cpu_set_t *pin_mask = NULL;
@@ -1110,6 +1079,9 @@ tracecmd_tsync_with_host(const struct tracecmd_tsync_protos *tsync_protos,
 	if (clock)
 		tsync->clock_str = strdup(clock);
 
+	tsync->remote_id = remote_id;
+	tsync->local_id = local_id;
+
 	pthread_attr_init(&attrib);
 	tsync->vcpu_count = tracecmd_count_cpus();
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index a46feea3d3c7..151ca19c2270 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -140,6 +140,35 @@ static char *get_clock(int argc, char **argv)
 	return NULL;
 }
 
+#ifdef VSOCK
+static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid)
+{
+	struct sockaddr_vm addr;
+	socklen_t addr_len = sizeof(addr);
+
+	memset(&addr, 0, sizeof(addr));
+	if (getsockname(fd, (struct sockaddr *)&addr, &addr_len))
+		return -1;
+	if (addr.svm_family != AF_VSOCK)
+		return -1;
+	*lcid = addr.svm_cid;
+
+	memset(&addr, 0, sizeof(addr));
+	addr_len = sizeof(addr);
+	if (getpeername(fd, (struct sockaddr *)&addr, &addr_len))
+		return -1;
+	if (addr.svm_family != AF_VSOCK)
+		return -1;
+	*rcid = addr.svm_cid;
+
+	return 0;
+}
+#else
+static inline int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid) {
+	return -1;
+}
+#endif
+
 static void agent_handle(int sd, int nr_cpus, int page_size)
 {
 	struct tracecmd_tsync_protos *tsync_protos = NULL;
@@ -147,6 +176,8 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 	struct tracecmd_msg_handle *msg_handle;
 	char *tsync_proto = NULL;
 	unsigned long long trace_id;
+	unsigned int remote_id;
+	unsigned int local_id;
 	unsigned int tsync_port = 0;
 	unsigned int *ports;
 	char **argv = NULL;
@@ -176,8 +207,16 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 	if (!use_fifos)
 		make_vsocks(nr_cpus, fds, ports);
 	if (tsync_protos && tsync_protos->names) {
+		if (get_vsocket_params(msg_handle->fd, &local_id,
+				       &remote_id)) {
+			warning("Failed to get local and remote ids");
+			/* Just make something up */
+			remote_id = -1;
+			local_id = -2;
+		}
 		tsync = tracecmd_tsync_with_host(tsync_protos,
-						 get_clock(argc, argv));
+						 get_clock(argc, argv),
+						 remote_id, local_id);
 		if (tsync)
 			tracecmd_tsync_get_session_params(tsync, &tsync_proto, &tsync_port);
 		else
-- 
2.35.1

