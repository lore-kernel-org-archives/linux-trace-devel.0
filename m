Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC58C433FE
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 18:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbiDQSYh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 14:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbiDQSYg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 14:24:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D19E03D
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 11:21:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E6AAB80D8E
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5990CC385AD;
        Sun, 17 Apr 2022 18:21:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ng9X1-004MzQ-BS;
        Sun, 17 Apr 2022 14:21:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 6/7] trace-cmd library: Remove vsock dependency from tracecmd_tsync_with_host()
Date:   Sun, 17 Apr 2022 14:21:53 -0400
Message-Id: <20220417182154.1041513-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417182154.1041513-1-rostedt@goodmis.org>
References: <20220417182154.1041513-1-rostedt@goodmis.org>
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

This also requires changing tracecmd_tsync_get_session_params() to only
return the selected protocol as the tsync_port has already been established
before calling tracecmd_tsync_with_host(). Since it now only returns the
selected protocol, rename it to tracecmd_tsync_get_selected_proto().

This is needed to decouple vsockets from libtracecmd.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  8 +-
 lib/trace-cmd/trace-msg.c                     |  3 +-
 lib/trace-cmd/trace-timesync.c                | 94 ++-----------------
 tracecmd/trace-agent.c                        | 84 +++++++++++++++--
 tracecmd/trace-record.c                       |  7 +-
 5 files changed, 97 insertions(+), 99 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 06906b04fbd9..45ae1dded66d 100644
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
@@ -499,9 +500,8 @@ int tracecmd_tsync_with_guest_stop(struct tracecmd_time_sync *tsync);
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
index 2f812ca5fc74..823dcf21ba26 100644
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
@@ -1098,37 +1038,23 @@ int tracecmd_tsync_with_host_stop(struct tracecmd_time_sync *tsync)
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
index 151ca19c2270..bfa9a534f153 100644
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
@@ -163,10 +188,48 @@ static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *rcid)
 
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
 	return -1;
 }
+
+static inline int vsock_get_port(int sd, unsigned int *port)
+{
+	return -1;
+}
+
+static int vsock_get_port(int sd, unsigned int *port)
+{
+	return -ENOTSUP;
+}
 #endif
 
 static void agent_handle(int sd, int nr_cpus, int page_size)
@@ -185,6 +248,7 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 	bool use_fifos;
 	int *fds;
 	int ret;
+	int fd;
 
 	fds = calloc(nr_cpus, sizeof(*fds));
 	ports = calloc(nr_cpus, sizeof(*ports));
@@ -214,13 +278,19 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 			remote_id = -1;
 			local_id = -2;
 		}
-		tsync = tracecmd_tsync_with_host(tsync_protos,
-						 get_clock(argc, argv),
-						 remote_id, local_id);
-		if (tsync)
-			tracecmd_tsync_get_session_params(tsync, &tsync_proto, &tsync_port);
-		else
+		fd = vsock_make();
+		if (fd >= 0 && vsock_get_port(fd, &tsync_port) >= 0) {
+			tsync = tracecmd_tsync_with_host(fd, tsync_protos,
+							 get_clock(argc, argv),
+							 remote_id, local_id);
+		}
+		if (tsync) {
+			tracecmd_tsync_get_selected_proto(tsync, &tsync_proto);
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

