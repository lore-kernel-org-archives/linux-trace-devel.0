Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B4DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiENCzr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiENCzi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D8234A020
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF6E161E08
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9515BC3411D;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XMZ-FK;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 10/26] trace-cmd: Move selecting tsync protocol out of tracecmd_tsync_with_host()
Date:   Fri, 13 May 2022 22:47:40 -0400
Message-Id: <20220514024756.1319681-11-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

In preparation of the agent proxy, separate out the decision of what
protocol is used for time synchronization out of the communication with
the host. It should be done separately.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       |  9 ++--
 lib/trace-cmd/trace-timesync.c                | 51 ++++++++-----------
 tracecmd/trace-agent.c                        | 13 ++---
 3 files changed, 31 insertions(+), 42 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 3b84170f2258..77b387b494ee 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -497,9 +497,8 @@ void tracecmd_tsync_init(void);
 int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const char *clock, int role);
 bool tsync_proto_is_supported(const char *proto_name);
 struct tracecmd_time_sync *
-tracecmd_tsync_with_host(int fd,
-			 const struct tracecmd_tsync_protos *tsync_protos,
-			 const char *clock, int remote_id, int local_id);
+tracecmd_tsync_with_host(int fd, const char *proto, const char *clock,
+			 int remote_id, int local_id);
 int tracecmd_tsync_with_host_stop(struct tracecmd_time_sync *tsync);
 struct tracecmd_time_sync *
 tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
@@ -509,8 +508,8 @@ int tracecmd_tsync_with_guest_stop(struct tracecmd_time_sync *tsync);
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync, int cpu,
 			       int *count, long long **ts,
 			       long long **offsets, long long **scalings, long long **frac);
-int tracecmd_tsync_get_selected_proto(struct tracecmd_time_sync *tsync,
-				      char **selected_proto);
+const char *tracecmd_tsync_get_proto(const struct tracecmd_tsync_protos *protos,
+			 const char *clock);
 void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
 int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 				    struct tracecmd_time_sync *tsync);
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index cc44af38e8ad..966aa56c5cc0 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -239,6 +239,23 @@ tsync_proto_select(const struct tracecmd_tsync_protos *protos,
 	return NULL;
 }
 
+/**
+ * tracecmd_tsync_get_proto - return the appropriate synchronization protocol
+ * @protos: The list of synchronization protocols to choose from
+ * @clock: The clock that is being used (or NULL for unknown).
+ *
+ * Retuns pointer to a protocol name, that can be used with the peer, or NULL
+ *	  in case there is no match with supported protocols.
+ *	  The returned string MUST NOT be freed by the caller
+ */
+__hidden const char *
+tracecmd_tsync_get_proto(const struct tracecmd_tsync_protos *protos,
+			 const char *clock)
+{
+	return tsync_proto_select(protos, clock,
+				  TRACECMD_TIME_SYNC_ROLE_GUEST);
+}
+
 /**
  * tracecmd_tsync_proto_getall - Returns list of all supported
  *				 time sync protocols
@@ -948,7 +965,7 @@ out:
 /**
  * tracecmd_tsync_with_host - Synchronize timestamps with host
  * @fd: File descriptor connecting with the host
- * @tsync_protos: List of tsync protocols, supported by the host
+ * @proto: The selected protocol
  * @clock: Trace clock, used for that session
  * @port: returned, VSOCKET port, on which the guest listens for tsync requests
  * @remote_id: Identifier to uniquely identify the remote host
@@ -961,25 +978,19 @@ out:
  * until tracecmd_tsync_with_host_stop() is called.
  */
 struct tracecmd_time_sync *
-tracecmd_tsync_with_host(int fd,
-			 const struct tracecmd_tsync_protos *tsync_protos,
-			 const char *clock, int remote_id, int local_id)
+tracecmd_tsync_with_host(int fd, const char *proto, const char *clock,
+			 int remote_id, int local_id)
 {
 	struct tracecmd_time_sync *tsync;
 	cpu_set_t *pin_mask = NULL;
 	pthread_attr_t attrib;
 	size_t mask_size = 0;
-	const char *proto;
 	int ret;
 
 	tsync = calloc(1, sizeof(struct tracecmd_time_sync));
 	if (!tsync)
 		return NULL;
 
-	proto = tsync_proto_select(tsync_protos, clock,
-				   TRACECMD_TIME_SYNC_ROLE_GUEST);
-	if (!proto)
-		goto error;
 	tsync->proto_name = strdup(proto);
 	tsync->msg_handle = tracecmd_msg_handle_alloc(fd, 0);
 	if (clock)
@@ -1033,25 +1044,3 @@ int tracecmd_tsync_with_host_stop(struct tracecmd_time_sync *tsync)
 {
 	return pthread_join(tsync->thread, NULL);
 }
-
-/**
- * tracecmd_tsync_get_selected_proto - Return the seleceted time sync protocol
- * @tsync: Time sync context, representing a running time sync session
- * @selected_proto: return, name of the selected time sync protocol for this session
- *
- * Returns 0 on success, or -1 in case of an error.
- *
- */
-int tracecmd_tsync_get_selected_proto(struct tracecmd_time_sync *tsync,
-				      char **selected_proto)
-{
-	if (!tsync)
-		return -1;
-
-	if (selected_proto) {
-		if (!tsync->proto_name)
-			return -1;
-		(*selected_proto) = strdup(tsync->proto_name);
-	}
-	return 0;
-}
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index f0723a6601a4..2fe31f71e47a 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -127,7 +127,7 @@ static void agent_handle(int sd, int nr_cpus, int page_size, const char *network
 	struct tracecmd_tsync_protos *tsync_protos = NULL;
 	struct tracecmd_time_sync *tsync = NULL;
 	struct tracecmd_msg_handle *msg_handle;
-	char *tsync_proto = NULL;
+	const char *tsync_proto = NULL;
 	unsigned long long trace_id;
 	unsigned int remote_id;
 	unsigned int local_id;
@@ -155,12 +155,15 @@ static void agent_handle(int sd, int nr_cpus, int page_size, const char *network
 	if (ret < 0)
 		die("Failed to receive trace request");
 
+	tsync_proto = tracecmd_tsync_get_proto(tsync_protos,
+					       get_clock(argc, argv));
+
 	if (use_fifos && open_agent_fifos(nr_cpus, fds))
 		use_fifos = false;
 
 	if (!use_fifos)
 		make_sockets(nr_cpus, fds, ports, network);
-	if (tsync_protos && tsync_protos->names) {
+	if (tsync_proto) {
 		if (network) {
 			/* For now just use something */
 			remote_id = 2;
@@ -184,13 +187,11 @@ static void agent_handle(int sd, int nr_cpus, int page_size, const char *network
 			}
 		}
 		if (fd >= 0) {
-			tsync = tracecmd_tsync_with_host(fd, tsync_protos,
+			tsync = tracecmd_tsync_with_host(fd, tsync_proto,
 							 get_clock(argc, argv),
 							 remote_id, local_id);
 		}
-		if (tsync) {
-			tracecmd_tsync_get_selected_proto(tsync, &tsync_proto);
-		} else {
+		if (!tsync) {
 			warning("Failed to negotiate timestamps synchronization with the host");
 			if (fd >= 0)
 				close(fd);
-- 
2.35.1

