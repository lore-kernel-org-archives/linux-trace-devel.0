Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E02BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 01:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244781AbiDOBC6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Apr 2022 21:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348325AbiDOBCi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Apr 2022 21:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A20129800
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 18:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EEB7621FA
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 01:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE02BC385AF;
        Fri, 15 Apr 2022 01:00:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nfAJk-003w8s-Rd;
        Thu, 14 Apr 2022 21:00:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 7/8] trace-cmd library: Remove vsock dependency from tracecmd_tsync_with_host()
Date:   Thu, 14 Apr 2022 21:00:06 -0400
Message-Id: <20220415010007.938408-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415010007.938408-1-rostedt@goodmis.org>
References: <20220415010007.938408-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The time synchronization works for networks too. In order to remove the
dependency of vsockets, have tracecmd_tsync_with_host() get the file
descriptor from the caller instead of creating one. This allows the
caller to either create a vsocket or a network interface and it will
still all work.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  3 +-
 lib/trace-cmd/trace-msg.c                     |  3 +-
 lib/trace-cmd/trace-timesync.c                | 74 ++-----------------
 tracecmd/trace-agent.c                        | 57 ++++++++++++--
 tracecmd/trace-record.c                       |  7 +-
 5 files changed, 65 insertions(+), 79 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 1839d82d4e11..45ae1dded66d 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -488,7 +488,8 @@ void tracecmd_tsync_init(void);
 int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const char *clock, int role);
 bool tsync_proto_is_supported(const char *proto_name);
 struct tracecmd_time_sync *
-tracecmd_tsync_with_host(const struct tracecmd_tsync_protos *tsync_protos,
+tracecmd_tsync_with_host(int fd,
+			 const struct tracecmd_tsync_protos *tsync_protos,
 			 const char *clock, int remote_id, int local_id);
 int tracecmd_tsync_with_host_stop(struct tracecmd_time_sync *tsync);
 struct tracecmd_time_sync *
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 03b853e4368b..726e9424c8fd 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -629,7 +629,8 @@ static int flush_cache(struct tracecmd_msg_handle *msg_handle)
 
 void tracecmd_msg_handle_close(struct tracecmd_msg_handle *msg_handle)
 {
-	close(msg_handle->fd);
+	if (msg_handle->fd >= 0)
+		close(msg_handle->fd);
 	if (msg_handle->cfd >= 0)
 		close(msg_handle->cfd);
 	free(msg_handle);
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 6f16090c2eb4..823dcf21ba26 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -344,61 +344,6 @@ error:
 	return -1;
 }
 
-#ifdef VSOCK
-static int vsock_make(void)
-{
-	struct sockaddr_vm addr = {
-		.svm_family = AF_VSOCK,
-		.svm_cid = VMADDR_CID_ANY,
-		.svm_port = VMADDR_PORT_ANY,
-	};
-	int sd;
-
-	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
-	if (sd < 0)
-		return -errno;
-
-	setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &(int){1}, sizeof(int));
-
-	if (bind(sd, (struct sockaddr *)&addr, sizeof(addr)))
-		return -errno;
-
-	if (listen(sd, SOMAXCONN))
-		return -errno;
-
-	return sd;
-}
-
-static int vsock_get_port(int sd, unsigned int *port)
-{
-	struct sockaddr_vm addr;
-	socklen_t addr_len = sizeof(addr);
-
-	if (getsockname(sd, (struct sockaddr *)&addr, &addr_len))
-		return -errno;
-
-	if (addr.svm_family != AF_VSOCK)
-		return -EINVAL;
-
-	if (port)
-		*port = addr.svm_port;
-
-	return 0;
-}
-
-#else
-static int vsock_make(void)
-{
-	return -ENOTSUP;
-
-}
-
-static int vsock_get_port(int sd, unsigned int *port)
-{
-	return -ENOTSUP;
-}
-#endif /* VSOCK */
-
 static struct tracefs_instance *
 clock_synch_create_instance(const char *clock, unsigned int cid)
 {
@@ -1005,6 +950,7 @@ out:
 
 /**
  * tracecmd_tsync_with_host - Synchronize timestamps with host
+ * @fd: File descriptor connecting with the host
  * @tsync_protos: List of tsync protocols, supported by the host
  * @clock: Trace clock, used for that session
  * @port: returned, VSOCKET port, on which the guest listens for tsync requests
@@ -1018,17 +964,16 @@ out:
  * until tracecmd_tsync_with_host_stop() is called.
  */
 struct tracecmd_time_sync *
-tracecmd_tsync_with_host(const struct tracecmd_tsync_protos *tsync_protos,
+tracecmd_tsync_with_host(int fd,
+			 const struct tracecmd_tsync_protos *tsync_protos,
 			 const char *clock, int remote_id, int local_id)
 {
 	struct tracecmd_time_sync *tsync;
 	cpu_set_t *pin_mask = NULL;
 	pthread_attr_t attrib;
 	size_t mask_size = 0;
-	unsigned int port;
 	const char *proto;
 	int ret;
-	int fd;
 
 	tsync = calloc(1, sizeof(struct tracecmd_time_sync));
 	if (!tsync)
@@ -1039,12 +984,6 @@ tracecmd_tsync_with_host(const struct tracecmd_tsync_protos *tsync_protos,
 	if (!proto)
 		goto error;
 	tsync->proto_name = strdup(proto);
-	fd = vsock_make();
-	if (fd < 0)
-		goto error;
-
-	if (vsock_get_port(fd, &port) < 0)
-		goto error;
 	tsync->msg_handle = tracecmd_msg_handle_alloc(fd, 0);
 	if (clock)
 		tsync->clock_str = strdup(clock);
@@ -1072,10 +1011,11 @@ tracecmd_tsync_with_host(const struct tracecmd_tsync_protos *tsync_protos,
 
 error:
 	if (tsync) {
-		if (tsync->msg_handle)
+		if (tsync->msg_handle) {
+			/* Do not close the fd that was passed it */
+			tsync->msg_handle->fd = -1;
 			tracecmd_msg_handle_close(tsync->msg_handle);
-		else if (fd >= 0)
-			close(fd);
+		}
 		free(tsync->clock_str);
 		free(tsync);
 	}
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 1a9463fd4854..ff4a0884f619 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -141,6 +141,31 @@ static char *get_clock(int argc, char **argv)
 }
 
 #ifdef VSOCK
+
+static int vsock_make(void)
+{
+	struct sockaddr_vm addr = {
+		.svm_family = AF_VSOCK,
+		.svm_cid = VMADDR_CID_ANY,
+		.svm_port = VMADDR_PORT_ANY,
+	};
+	int sd;
+
+	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	if (sd < 0)
+		return -errno;
+
+	setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &(int){1}, sizeof(int));
+
+	if (bind(sd, (struct sockaddr *)&addr, sizeof(addr)))
+		return -errno;
+
+	if (listen(sd, SOMAXCONN))
+		return -errno;
+
+	return sd;
+}
+
 static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid)
 {
 	struct sockaddr_vm addr;
@@ -181,7 +206,22 @@ static int vsock_get_port(int sd, unsigned int *port)
 	return 0;
 }
 #else
-static inline int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid) {
+static inline bool can_splice_read_vsock(void)
+{
+	return false;
+}
+
+static inline int vsock_make(void)
+{
+	return -ENOTSUP;
+
+}
+
+static inline  int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid) {
+	return -1;
+}
+static inline int vsock_get_port(int sd, unsigned int *port)
+{
 	return -1;
 }
 
@@ -207,6 +247,7 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 	bool use_fifos;
 	int *fds;
 	int ret;
+	int fd;
 
 	fds = calloc(nr_cpus, sizeof(*fds));
 	ports = calloc(nr_cpus, sizeof(*ports));
@@ -236,17 +277,19 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 			remote_id = -1;
 			local_id = -2;
 		}
-		if (vsock_get_port(msg_handle->fd, &tsync_port) >= 0) {
-			tsync = tracecmd_tsync_with_host(tsync_protos,
+		fd = vsock_make();
+		if (fd >= 0 && vsock_get_port(fd, &tsync_port) >= 0) {
+			tsync = tracecmd_tsync_with_host(fd, tsync_protos,
 							 get_clock(argc, argv),
 							 remote_id, local_id);
-		} else {
-			tsync = NULL;
 		}
-		if (tsync)
+		if (tsync) {
 			tracecmd_tsync_get_selected_proto(tsync, &tsync_proto);
-		else
+		} else {
 			warning("Failed to negotiate timestamps synchronization with the host");
+			if (fd >= 0)
+				close(fd);
+		}
 	}
 	trace_id = tracecmd_generate_traceid();
 	ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size,
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 56fa5a798dcc..8e89aa94977c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3228,8 +3228,7 @@ int trace_open_vsock(unsigned int cid, unsigned int port)
 	die("vsock is not supported");
 	return -1;
 }
-
-static bool can_splice_read_vsock(void)
+static inline bool can_splice_read_vsock(void)
 {
 	return false;
 }
@@ -3976,6 +3975,7 @@ static int host_tsync(struct common_record_context *ctx,
 		      unsigned int tsync_port, char *proto)
 {
 	struct trace_guest *guest;
+	int guest_pid = -1;
 	int fd;
 
 	if (!proto)
@@ -3985,12 +3985,13 @@ static int host_tsync(struct common_record_context *ctx,
 	if (guest == NULL)
 		return -1;
 
+	guest_pid = guest->pid;
 	start_mapping_vcpus(guest);
 
 	fd = trace_open_vsock(instance->cid, tsync_port);
 	instance->tsync = tracecmd_tsync_with_guest(top_instance.trace_id,
 						    instance->tsync_loop_interval,
-						    fd, guest->pid,
+						    fd, guest_pid,
 						    instance->cpu_count,
 						    proto, ctx->clock);
 	stop_mapping_vcpus(instance, guest);
-- 
2.35.1

