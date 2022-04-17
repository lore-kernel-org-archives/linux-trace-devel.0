Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22ECAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Apr 2022 18:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbiDQSYe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Apr 2022 14:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234756AbiDQSYe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Apr 2022 14:24:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F3E13D02
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 11:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0200160C39
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Apr 2022 18:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4A8C385AB;
        Sun, 17 Apr 2022 18:21:56 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ng9X1-004MzM-Af;
        Sun, 17 Apr 2022 14:21:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 5/7] trace-cmd library: Have tracecmd_tsync_with_guest() not depend on cid/port
Date:   Sun, 17 Apr 2022 14:21:52 -0400
Message-Id: <20220417182154.1041513-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220417182154.1041513-1-rostedt@goodmis.org>
References: <20220417182154.1041513-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Have tracecmd_tsync_with_guest() get passed a file descriptor for
connecting with the guest instead of passing in the cid and port, as
this will allow it to be used for network connections as well.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  2 +-
 lib/trace-cmd/trace-timesync.c                | 36 ++-----------------
 tracecmd/trace-record.c                       |  7 ++--
 3 files changed, 9 insertions(+), 36 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 24295e4e09d3..06906b04fbd9 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -493,7 +493,7 @@ tracecmd_tsync_with_host(const struct tracecmd_tsync_protos *tsync_protos,
 int tracecmd_tsync_with_host_stop(struct tracecmd_time_sync *tsync);
 struct tracecmd_time_sync *
 tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
-			  unsigned int cid, unsigned int port, int guest_pid,
+			  unsigned int fd, int guest_pid,
 			  int guest_cpus, const char *proto_name, const char *clock);
 int tracecmd_tsync_with_guest_stop(struct tracecmd_time_sync *tsync);
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync, int cpu,
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index b41aece82082..2f812ca5fc74 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -345,25 +345,6 @@ error:
 }
 
 #ifdef VSOCK
-static int vsock_open(unsigned int cid, unsigned int port)
-{
-	struct sockaddr_vm addr = {
-		.svm_family = AF_VSOCK,
-		.svm_cid = cid,
-		.svm_port = port,
-	};
-	int sd;
-
-	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
-	if (sd < 0)
-		return -errno;
-
-	if (connect(sd, (struct sockaddr *)&addr, sizeof(addr)))
-		return -errno;
-
-	return sd;
-}
-
 static int vsock_make(void)
 {
 	struct sockaddr_vm addr = {
@@ -388,7 +369,7 @@ static int vsock_make(void)
 	return sd;
 }
 
-int __hidden vsock_get_port(int sd, unsigned int *port)
+static int vsock_get_port(int sd, unsigned int *port)
 {
 	struct sockaddr_vm addr;
 	socklen_t addr_len = sizeof(addr);
@@ -406,11 +387,6 @@ int __hidden vsock_get_port(int sd, unsigned int *port)
 }
 
 #else
-static int vsock_open(unsigned int cid, unsigned int port)
-{
-	return -ENOTSUP;
-}
-
 static int vsock_make(void)
 {
 	return -ENOTSUP;
@@ -811,8 +787,7 @@ static void *tsync_host_thread(void *data)
  * tracecmd_tsync_with_guest - Synchronize timestamps with guest
  *
  * @trace_id: Local ID for the current trace session
- * @cid: CID of the guest
- * @port: VSOCKET port, on which the guest listens for tsync requests
+ * @fd: file descriptor of guest
  * @guest_pid: PID of the host OS process, running the guest
  * @guest_cpus: Number of the guest VCPUs
  * @proto_name: Name of the negotiated time synchronization protocol
@@ -826,14 +801,13 @@ static void *tsync_host_thread(void *data)
  */
 struct tracecmd_time_sync *
 tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
-			  unsigned int cid, unsigned int port, int guest_pid,
+			  unsigned int fd, int guest_pid,
 			  int guest_cpus, const char *proto_name, const char *clock)
 {
 	struct tracecmd_time_sync *tsync;
 	cpu_set_t *pin_mask = NULL;
 	pthread_attr_t attrib;
 	size_t mask_size = 0;
-	int fd = -1;
 	int ret;
 
 	if (!proto_name)
@@ -846,9 +820,6 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 	tsync->trace_id = trace_id;
 	tsync->loop_interval = loop_interval;
 	tsync->proto_name = strdup(proto_name);
-	fd = vsock_open(cid, port);
-	if (fd < 0)
-		goto error;
 
 	tsync->msg_handle = tracecmd_msg_handle_alloc(fd, 0);
 	if (!tsync->msg_handle) {
@@ -1034,7 +1005,6 @@ out:
 
 /**
  * tracecmd_tsync_with_host - Synchronize timestamps with host
- *
  * @tsync_protos: List of tsync protocols, supported by the host
  * @clock: Trace clock, used for that session
  * @port: returned, VSOCKET port, on which the guest listens for tsync requests
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c3e52a48fa07..56fa5a798dcc 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3976,19 +3976,22 @@ static int host_tsync(struct common_record_context *ctx,
 		      unsigned int tsync_port, char *proto)
 {
 	struct trace_guest *guest;
+	int fd;
 
 	if (!proto)
 		return -1;
+
 	guest = trace_get_guest(instance->cid, NULL);
 	if (guest == NULL)
 		return -1;
 
 	start_mapping_vcpus(guest);
 
+	fd = trace_open_vsock(instance->cid, tsync_port);
 	instance->tsync = tracecmd_tsync_with_guest(top_instance.trace_id,
 						    instance->tsync_loop_interval,
-						    instance->cid, tsync_port,
-						    guest->pid, instance->cpu_count,
+						    fd, guest->pid,
+						    instance->cpu_count,
 						    proto, ctx->clock);
 	stop_mapping_vcpus(instance, guest);
 
-- 
2.35.1

