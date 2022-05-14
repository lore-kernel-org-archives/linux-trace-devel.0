Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B93C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiENCzY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiENCzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9AD34A032
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A05461E1D
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE668C341C7;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XN1-LB;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 17/26] trace-cmd msg: Add PROXY communication
Date:   Fri, 13 May 2022 22:47:47 -0400
Message-Id: <20220514024756.1319681-18-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add communication for an agent proxy. When an agent is also running as a
proxy, it will be able to receive a TRACE_PROXY message. This will contain
the same data as a TRACE_REQ, but also include the number of CPUs the
recorder has (as the recorder may be running on the guest, and the agent
on the host), as well as the number of siblings guests that will be sent
afterward.

The sibling messages will come at a later time.

Currently there are no users of this API.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../include/private/trace-cmd-private.h       | 12 +++
 lib/trace-cmd/trace-msg.c                     | 90 ++++++++++++++++---
 2 files changed, 89 insertions(+), 13 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 77b387b494ee..8824dcae0b16 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -378,6 +378,7 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder);
 enum tracecmd_msg_flags {
 	TRACECMD_MSG_FL_USE_TCP		= 1 << 0,
 	TRACECMD_MSG_FL_USE_VSOCK	= 1 << 1,
+	TRACECMD_MSG_FL_PROXY		= 1 << 2,
 };
 
 #define MSG_CACHE_FILE "/tmp/trace_msg_cacheXXXXXX"
@@ -431,10 +432,21 @@ int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
 				int argc, char **argv, bool use_fifos,
 				unsigned long long trace_id,
 				struct tracecmd_tsync_protos *protos);
+int tracecmd_msg_send_trace_proxy(struct tracecmd_msg_handle *msg_handle,
+				  int argc, char **argv, bool use_fifos,
+				  unsigned long long trace_id,
+				  struct tracecmd_tsync_protos *protos,
+				  unsigned int nr_cpus,
+				  unsigned int siblings);
 int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 				int *argc, char ***argv, bool *use_fifos,
 				unsigned long long *trace_id,
 				struct tracecmd_tsync_protos **protos);
+int tracecmd_msg_recv_trace_proxy(struct tracecmd_msg_handle *msg_handle,
+				  int *argc, char ***argv, bool *use_fifos,
+				  unsigned long long *trace_id,
+				  struct tracecmd_tsync_protos **protos,
+				  unsigned int *cpus, unsigned int *siblings);
 
 int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int nr_cpus, int page_size,
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 9899fa8796e2..c16e8e81e50a 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -71,6 +71,12 @@ struct tracecmd_msg_trace_req {
 	u64 trace_id;
 } __packed;
 
+struct tracecmd_msg_trace_proxy {
+	struct tracecmd_msg_trace_req req;
+	be32 cpus;
+	be32 siblings;
+} __packed;
+
 struct tracecmd_msg_trace_resp {
 	be32 flags;
 	be32 cpus;
@@ -101,7 +107,8 @@ struct tracecmd_msg_header {
 	C(TRACE_REQ,	6,	sizeof(struct tracecmd_msg_trace_req)),	\
 	C(TRACE_RESP,	7,	sizeof(struct tracecmd_msg_trace_resp)),\
 	C(CLOSE_RESP,	8,	0),					\
-	C(TIME_SYNC,	9,	sizeof(struct tracecmd_msg_tsync)),
+	C(TIME_SYNC,	9,	sizeof(struct tracecmd_msg_tsync)),	\
+	C(TRACE_PROXY,	10,	sizeof(struct tracecmd_msg_trace_proxy)),
 
 #undef C
 #define C(a,b,c)	MSG_##a = b
@@ -134,6 +141,7 @@ struct tracecmd_msg {
 		struct tracecmd_msg_tinit	tinit;
 		struct tracecmd_msg_rinit	rinit;
 		struct tracecmd_msg_trace_req	trace_req;
+		struct tracecmd_msg_trace_proxy	trace_proxy;
 		struct tracecmd_msg_trace_resp	trace_resp;
 		struct tracecmd_msg_tsync	tsync;
 	};
@@ -1007,7 +1015,7 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
 	msg->buf = buf;
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + size);
 
-	return 0;
+	return size;
 }
 
 int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
@@ -1026,6 +1034,26 @@ int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
 	return tracecmd_msg_send(msg_handle, &msg);
 }
 
+int tracecmd_msg_send_trace_proxy(struct tracecmd_msg_handle *msg_handle,
+				  int argc, char **argv, bool use_fifos,
+				  unsigned long long trace_id,
+				  struct tracecmd_tsync_protos *protos,
+				  unsigned int nr_cpus,
+				  unsigned int siblings)
+{
+	struct tracecmd_msg msg;
+	int ret;
+
+	tracecmd_msg_init(MSG_TRACE_PROXY, &msg);
+	ret = make_trace_req(&msg, argc, argv, use_fifos, trace_id, protos);
+	if (ret < 0)
+		return ret;
+
+	msg.trace_proxy.cpus = htonl(nr_cpus);
+	msg.trace_proxy.siblings = htonl(siblings);
+	return tracecmd_msg_send(msg_handle, &msg);
+}
+
 static int get_trace_req_protos(char *buf, int length,
 				struct tracecmd_tsync_protos **protos)
 {
@@ -1119,16 +1147,12 @@ out:
 
 }
 
-/*
- * NOTE: On success, the returned `argv` should be freed with:
- *     free(argv[0]);
- *     free(argv);
- * and `tsync_protos` with free(tsync_protos);
- */
-int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int *argc, char ***argv, bool *use_fifos,
-				unsigned long long *trace_id,
-				struct tracecmd_tsync_protos **protos)
+static int msg_recv_trace_req_proxy(struct tracecmd_msg_handle *msg_handle,
+				    int *argc, char ***argv, bool *use_fifos,
+				    unsigned long long *trace_id,
+				    struct tracecmd_tsync_protos **protos,
+				    unsigned int *cpus,
+				    unsigned int *siblings)
 {
 	struct tracecmd_msg msg;
 	unsigned int param_id;
@@ -1141,7 +1165,16 @@ int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 	if (ret < 0)
 		return ret;
 
-	if (ntohl(msg.hdr.cmd) != MSG_TRACE_REQ) {
+	switch (ntohl(msg.hdr.cmd)) {
+	case MSG_TRACE_PROXY:
+		if (cpus)
+			*cpus = ntohl(msg.trace_proxy.cpus);
+		if (siblings)
+			*siblings = ntohl(msg.trace_proxy.siblings);
+		/* fall through */
+	case MSG_TRACE_REQ:
+		break;
+	default:
 		ret = -ENOTSUP;
 		goto out;
 	}
@@ -1192,6 +1225,37 @@ out:
 	return ret;
 }
 
+/*
+ * NOTE: On success, the returned `argv` should be freed with:
+ *     free(argv[0]);
+ *     free(argv);
+ * and `tsync_protos` with free(tsync_protos);
+ */
+int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
+				int *argc, char ***argv, bool *use_fifos,
+				unsigned long long *trace_id,
+				struct tracecmd_tsync_protos **protos)
+{
+	return msg_recv_trace_req_proxy(msg_handle, argc, argv, use_fifos,
+					trace_id, protos, NULL, NULL);
+}
+
+/*
+ * NOTE: On success, the returned `argv` should be freed with:
+ *     free(argv[0]);
+ *     free(argv);
+ * and `tsync_protos` with free(tsync_protos);
+ */
+int tracecmd_msg_recv_trace_proxy(struct tracecmd_msg_handle *msg_handle,
+				  int *argc, char ***argv, bool *use_fifos,
+				  unsigned long long *trace_id,
+				  struct tracecmd_tsync_protos **protos,
+				  unsigned int *cpus, unsigned int *siblings)
+{
+	return msg_recv_trace_req_proxy(msg_handle, argc, argv, use_fifos,
+					trace_id, protos, cpus, siblings);
+}
+
 /**
  * tracecmd_msg_send_time_sync - Send a time sync packet
  * @msg_handle: message handle, holding the communication context
-- 
2.35.1

