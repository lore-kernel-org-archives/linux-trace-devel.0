Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B84C4332E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0492C238EC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbhAUHrz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 02:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727651AbhAUHpm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 02:45:42 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72139C0613CF
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:01 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id g10so747411wrx.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2rt1nrCP89FUKc3aOpbZvF9DEbmG3ozIZRgb/P09LY8=;
        b=CR3+l27Utui/VgPVAqW11nGOBJa+wYNfNad1VUJ0RV4EyxzoqXkJ3Z/ZpgbHSvWa6S
         78JFHAsKRyqDYYnLXH0WIuNtJ0wDeHEy6lcmI+9HjieGNb3+Bd2lEaucDOe4GX6cHEk4
         EBmWKxI5WMmEC+Vz4GoS58qxde1C6MMGdlhjalb/D48aeGBmfK5bYAMpnkDQuOBpBLQU
         rO2GIAnMOxUfKeJFuEFZgJ4KJtuX7TnpFHSz0eQz6ceSG5/Z2nLymXO2TXwE5oUqBpBX
         KpiNrGCoFshmeoBxftywQIpHbKunHrpMUP9jS3Wzic08uyedJ0n19OPslJWYxB3gHqT9
         oJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2rt1nrCP89FUKc3aOpbZvF9DEbmG3ozIZRgb/P09LY8=;
        b=UQmSBUqOdeyHRWvka4XA8Oui4y+OhihstjiJjU8SzZOnU6v8uIFIOyZ+o2DJr0nYn7
         l8HkTN+S1U39dJw+6XfGR1hczSXALO3eyJoGV9rlCjc8wythVAvm0TBURaUgryuYYUwx
         TzJkktpK+DaKin7qj58omkMM8Yj08AIQMM3yvqKF5f5H/0wKor7APk/gPsyUaH07Cn/f
         bfrcuc0AiddSCuOxY/xYQ7JGCeiqQCwWwoMTjlIVGgZ/FMrCdp0HM1oM6orpfRGpxT3X
         6ZTN6xBn68SXDRHtu9aisDkE8q61bNc1IZxp19wKU0v9TuAu5jvypGU6YHNoSwHT3n3t
         INHQ==
X-Gm-Message-State: AOAM533Q4hXDq4NDhxEMoqKMcNUmTAN3kfzbdJajAmnjAHc5BHtOk1Gg
        7qSvAvLechMXnZ1I2d51e34=
X-Google-Smtp-Source: ABdhPJw2CMX6JhtCTXPYeSwdcZGh+F+odrMMax7wvK1YJ0nXtL1hxy3fHhjXScID0+IkJpG5w09zYQ==
X-Received: by 2002:a5d:678d:: with SMTP id v13mr12804551wru.71.1611215100053;
        Wed, 20 Jan 2021 23:45:00 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm6788474wmj.32.2021.01.20.23.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 23:44:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v26 01/15] trace-cmd: Replace time sync protocol ID with string
Date:   Thu, 21 Jan 2021 09:44:42 +0200
Message-Id: <20210121074456.157658-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074456.157658-1-tz.stoyanov@gmail.com>
References: <20210121074456.157658-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Different timestamp synchronization algorithms will be implemented as
trace-cmd plugins. Using IDs for identifying these algorithms is
a problem, as these IDs must be defined in a single place. In order
to be more flexible, protocol IDs are replaced by protocol names -
strings that are part of the plugin code and are registered with
plugin initialisation.
The plugin names are limited up to 15 symbols, in order to simplify
the structure of sync messages.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  36 ++---
 lib/trace-cmd/include/trace-tsync-local.h     |  12 +-
 lib/trace-cmd/trace-msg.c                     | 112 ++++++++-----
 lib/trace-cmd/trace-timesync.c                | 152 +++++++++---------
 tracecmd/include/trace-local.h                |   6 +-
 tracecmd/trace-agent.c                        |  15 +-
 tracecmd/trace-record.c                       |  27 ++--
 tracecmd/trace-tsync.c                        |  20 +--
 8 files changed, 213 insertions(+), 167 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 64945815..08e98a50 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -334,6 +334,10 @@ struct tracecmd_msg_handle {
 	bool			done;
 };
 
+struct tracecmd_tsync_protos {
+	char **names;
+};
+
 struct tracecmd_msg_handle *
 tracecmd_msg_handle_alloc(int fd, unsigned long flags);
 
@@ -363,50 +367,44 @@ void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
 				int argc, char **argv, bool use_fifos,
 				unsigned long long trace_id,
-				char *tsync_protos,
-				int tsync_protos_size);
+				struct tracecmd_tsync_protos *protos);
 int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 				int *argc, char ***argv, bool *use_fifos,
 				unsigned long long *trace_id,
-				char **tsync_protos,
-				unsigned int *tsync_protos_size);
+				struct tracecmd_tsync_protos **protos);
 
 int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int nr_cpus, int page_size,
 				 unsigned int *ports, bool use_fifos,
 				 unsigned long long trace_id,
-				 unsigned int tsync_proto,
-				 unsigned int tsync_port);
+				 const char *tsync_proto, unsigned int tsync_port);
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
 				 unsigned int **ports, bool *use_fifos,
 				 unsigned long long *trace_id,
-				 unsigned int *tsync_proto,
+				 char **tsync_proto,
 				 unsigned int *tsync_port);
 
 int tracecmd_msg_send_time_sync(struct tracecmd_msg_handle *msg_handle,
-				unsigned int sync_protocol,
-				unsigned int sync_msg_id,
+				char *sync_protocol, unsigned int sync_msg_id,
 				unsigned int payload_size, char *payload);
 int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
-				unsigned int *sync_protocol,
+				char *sync_protocol,
 				unsigned int *sync_msg_id,
 				unsigned int *payload_size, char **payload);
 
 /* --- Timestamp synchronization --- */
 
-enum{
-	TRACECMD_TIME_SYNC_PROTO_NONE	= 0,
-};
+#define TRACECMD_TSYNC_PNAME_LENGTH	16
+#define TRACECMD_TSYNC_PROTO_NONE	"none"
+
 enum{
 	TRACECMD_TIME_SYNC_CMD_PROBE	= 1,
 	TRACECMD_TIME_SYNC_CMD_STOP	= 2,
 };
 
-#define TRACECMD_TIME_SYNC_PROTO_PTP_WEIGHT	10
-
 struct tracecmd_time_sync {
-	unsigned int			sync_proto;
+	const char			*proto_name;
 	int				loop_interval;
 	pthread_mutex_t			lock;
 	pthread_cond_t			cond;
@@ -416,9 +414,9 @@ struct tracecmd_time_sync {
 };
 
 void tracecmd_tsync_init(void);
-int tracecmd_tsync_proto_getall(char **proto_mask, int *words);
-unsigned int tracecmd_tsync_proto_select(char *proto_mask, int words);
-bool tsync_proto_is_supported(unsigned int proto_id);
+int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos);
+const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos);
+bool tsync_proto_is_supported(const char *proto_name);
 void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
 void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 1de9d5e5..58841a4c 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -26,12 +26,12 @@ struct clock_sync_context {
 	unsigned int			remote_port;
 };
 
-int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
-				int (*init)(struct tracecmd_time_sync *),
-				int (*free)(struct tracecmd_time_sync *),
-				int (*calc)(struct tracecmd_time_sync *,
-					    long long *, long long *));
-int tracecmd_tsync_proto_unregister(unsigned int proto_id);
+int tracecmd_tsync_proto_register(const char *proto_name, int accuracy,
+				  int (*init)(struct tracecmd_time_sync *),
+				  int (*free)(struct tracecmd_time_sync *),
+				  int (*calc)(struct tracecmd_time_sync *,
+					      long long *, long long *));
+int tracecmd_tsync_proto_unregister(char *proto_name);
 
 int ptp_clock_sync_register(void);
 
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 4a0bfa93..e0cdf677 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -26,6 +26,7 @@
 #include "trace-cmd-local.h"
 #include "trace-local.h"
 #include "trace-msg.h"
+#include "trace-cmd.h"
 
 typedef __u32 u32;
 typedef __be32 be32;
@@ -85,12 +86,12 @@ struct tracecmd_msg_trace_resp {
 	be32 cpus;
 	be32 page_size;
 	u64 trace_id;
-	be32 tsync_proto;
+	char tsync_proto_name[TRACECMD_TSYNC_PNAME_LENGTH];
 	be32 tsync_port;
 } __attribute__((packed));
 
 struct tracecmd_msg_tsync {
-	be32 sync_protocol;
+	char sync_protocol_name[TRACECMD_TSYNC_PNAME_LENGTH];
 	be32 sync_msg_id;
 } __attribute__((packed));
 
@@ -848,12 +849,20 @@ int tracecmd_msg_wait_close_resp(struct tracecmd_msg_handle *msg_handle)
 }
 
 static int make_trace_req_protos(char **buf, int *size,
-				 int protos_size, char *tsync_protos)
+				 struct tracecmd_tsync_protos *protos)
 {
+	int protos_size = 1;
 	size_t buf_size;
+	char **names;
 	char *nbuf;
 	char *p;
 
+	names = protos->names;
+	while (*names) {
+		protos_size += strlen(*names) + 1;
+		names++;
+	}
+
 	buf_size = TRACE_REQ_PARAM_SIZE + protos_size;
 	nbuf = realloc(*buf, *size + buf_size);
 	if (!nbuf)
@@ -867,7 +876,13 @@ static int make_trace_req_protos(char **buf, int *size,
 	*(unsigned int *)p = htonl(protos_size);
 	p += sizeof(int);
 
-	memcpy(p, tsync_protos, protos_size);
+	names = protos->names;
+	while (*names) {
+		strcpy(p, *names);
+		p += strlen(*names) + 1;
+		names++;
+	}
+	p = NULL;
 
 	*size += buf_size;
 	*buf = nbuf;
@@ -911,7 +926,7 @@ static int make_trace_req_args(char **buf, int *size, int argc, char **argv)
 
 static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
 			  bool use_fifos, unsigned long long trace_id,
-			  char *tsync_protos, int tsync_protos_size)
+			  struct tracecmd_tsync_protos *protos)
 {
 	int size = 0;
 	char *buf = NULL;
@@ -924,9 +939,8 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
 
 	if (argc && argv)
 		make_trace_req_args(&buf, &size, argc, argv);
-	if (tsync_protos_size && tsync_protos)
-		make_trace_req_protos(&buf, &size,
-				      tsync_protos_size, tsync_protos);
+	if (protos && protos->names)
+		make_trace_req_protos(&buf, &size, protos);
 
 	msg->buf = buf;
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + size);
@@ -937,15 +951,13 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
 int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
 				int argc, char **argv, bool use_fifos,
 				unsigned long long trace_id,
-				char *tsync_protos,
-				int tsync_protos_size)
+				struct tracecmd_tsync_protos *protos)
 {
 	struct tracecmd_msg msg;
 	int ret;
 
 	tracecmd_msg_init(MSG_TRACE_REQ, &msg);
-	ret = make_trace_req(&msg, argc, argv, use_fifos,
-			     trace_id, tsync_protos, tsync_protos_size);
+	ret = make_trace_req(&msg, argc, argv, use_fifos, trace_id, protos);
 	if (ret < 0)
 		return ret;
 
@@ -953,16 +965,44 @@ int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
 }
 
 static int get_trace_req_protos(char *buf, int length,
-				char **tsync_protos,
-				unsigned int *tsync_protos_size)
+				struct tracecmd_tsync_protos **protos)
 {
-	*tsync_protos = malloc(length);
-	if (!*tsync_protos)
-		return -1;
-	memcpy(*tsync_protos, buf, length);
-	*tsync_protos_size = length;
+	struct tracecmd_tsync_protos *plist = NULL;
+	int count = 0;
+	char *p;
+	int i, j;
+
+	i = length;
+	p = buf;
+	while (i > 0) {
+		i -= strlen(p) + 1;
+		count++;
+		p += strlen(p) + 1;
+	}
 
+	plist = calloc(1, sizeof(struct tracecmd_tsync_protos));
+	if (plist)
+		goto error;
+	plist->names = calloc(count + 1, sizeof(char *));
+	if (!plist->names)
+		goto error;
+	i = length;
+	p = buf;
+	j = 0;
+	while (i > 0 && j < (count - 1)) {
+		i -= strlen(p) + 1;
+		plist->names[j++] = strdup(p);
+		p += strlen(p) + 1;
+	}
+
+	*protos = plist;
 	return 0;
+error:
+	if (plist) {
+		free(plist->names);
+		free(plist);
+	}
+	return -1;
 }
 
 static int get_trace_req_args(char *buf, int length, int *argc, char ***argv)
@@ -1026,8 +1066,7 @@ out:
 int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 				int *argc, char ***argv, bool *use_fifos,
 				unsigned long long *trace_id,
-				char **tsync_protos,
-				unsigned int *tsync_protos_size)
+				struct tracecmd_tsync_protos **protos)
 {
 	struct tracecmd_msg msg;
 	unsigned int param_id;
@@ -1069,8 +1108,7 @@ int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 			ret = get_trace_req_args(p, param_length, argc, argv);
 			break;
 		case TRACE_REQUEST_TSYNC_PROTOS:
-			ret = get_trace_req_protos(p, param_length,
-						   tsync_protos, tsync_protos_size);
+			ret = get_trace_req_protos(p, param_length, protos);
 			break;
 		default:
 			break;
@@ -1095,7 +1133,8 @@ out:
 /**
  * tracecmd_msg_send_time_sync - Send a time sync packet
  * @msg_handle: message handle, holding the communication context
- * @sync_protocol: id of the time synch protocol
+ * @sync_protocol: name of the time synch protocol, string up to
+ *		   TRACECMD_TSYNC_PNAME_LENGTH characters length.
  * @sync_msg_id: id if the time synch message, protocol dependent
  * @payload_size: size of the packet payload, 0 in case of no payload
  * @payload: pointer to the packet payload, or NULL in case of no payload
@@ -1103,14 +1142,13 @@ out:
  * Returns 0 if packet is sent successfully, or negative error otherwise.
  */
 int tracecmd_msg_send_time_sync(struct tracecmd_msg_handle *msg_handle,
-				unsigned int sync_protocol,
-				unsigned int sync_msg_id,
+				char *sync_protocol, unsigned int sync_msg_id,
 				unsigned int payload_size, char *payload)
 {
 	struct tracecmd_msg msg;
 
 	tracecmd_msg_init(MSG_TIME_SYNC, &msg);
-	msg.tsync.sync_protocol = htonl(sync_protocol);
+	strncpy(msg.tsync.sync_protocol_name, sync_protocol, TRACECMD_TSYNC_PNAME_LENGTH);
 	msg.tsync.sync_msg_id = htonl(sync_msg_id);
 	msg.hdr.size = htonl(ntohl(msg.hdr.size) + payload_size);
 
@@ -1121,7 +1159,9 @@ int tracecmd_msg_send_time_sync(struct tracecmd_msg_handle *msg_handle,
 /**
  * tracecmd_msg_recv_time_sync - Receive a time sync packet
  * @msg_handle: message handle, holding the communication context
- * @sync_protocol: return the id of the packet's time synch protocol
+ * @sync_protocol: return the name of the packet's time synch protocol.
+ *		   It must point to a prealocated buffer with size
+ *		   TRACECMD_TSYNC_PNAME_LENGTH
  * @sync_msg_id: return the id of the packet's time synch message
  * @payload_size: size of the packet's payload, can be:
  *		 NULL - the payload is not interested and should be ignored
@@ -1146,7 +1186,7 @@ int tracecmd_msg_send_time_sync(struct tracecmd_msg_handle *msg_handle,
  * Returns 0 if packet is received successfully, or negative error otherwise.
  */
 int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
-				unsigned int *sync_protocol,
+				char *sync_protocol,
 				unsigned int *sync_msg_id,
 				unsigned int *payload_size, char **payload)
 {
@@ -1165,7 +1205,8 @@ int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
 	}
 
 	if (sync_protocol)
-		*sync_protocol = ntohl(msg.tsync.sync_protocol);
+		strncpy(sync_protocol, msg.tsync.sync_protocol_name,
+				TRACECMD_TSYNC_PNAME_LENGTH);
 	if (sync_msg_id)
 		*sync_msg_id = ntohl(msg.tsync.sync_msg_id);
 
@@ -1202,7 +1243,7 @@ out:
 static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
 			   unsigned int *ports, bool use_fifos,
 			   unsigned long long trace_id,
-			   unsigned int tsync_proto,
+			   const char *tsync_proto,
 			   unsigned int tsync_port)
 {
 	int data_size;
@@ -1216,7 +1257,7 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + data_size);
 	msg->trace_resp.flags = use_fifos ? MSG_TRACE_USE_FIFOS : 0;
 	msg->trace_resp.flags = htonl(msg->trace_resp.flags);
-	msg->trace_resp.tsync_proto = htonl(tsync_proto);
+	strncpy(msg->trace_resp.tsync_proto_name, tsync_proto, TRACECMD_TSYNC_PNAME_LENGTH);
 	msg->trace_resp.tsync_port = htonl(tsync_port);
 
 	msg->trace_resp.cpus = htonl(nr_cpus);
@@ -1230,8 +1271,7 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int nr_cpus, int page_size,
 				 unsigned int *ports, bool use_fifos,
 				 unsigned long long trace_id,
-				 unsigned int tsync_proto,
-				 unsigned int tsync_port)
+				 const char *tsync_proto, unsigned int tsync_port)
 {
 	struct tracecmd_msg msg;
 	int ret;
@@ -1249,7 +1289,7 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
 				 unsigned int **ports, bool *use_fifos,
 				 unsigned long long *trace_id,
-				 unsigned int *tsync_proto,
+				 char **tsync_proto,
 				 unsigned int *tsync_port)
 {
 	struct tracecmd_msg msg;
@@ -1276,7 +1316,7 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 	*nr_cpus = ntohl(msg.trace_resp.cpus);
 	*page_size = ntohl(msg.trace_resp.page_size);
 	*trace_id = ntohll(msg.trace_resp.trace_id);
-	*tsync_proto = ntohl(msg.trace_resp.tsync_proto);
+	*tsync_proto = strdup(msg.trace_resp.tsync_proto_name);
 	*tsync_port = ntohl(msg.trace_resp.tsync_port);
 	*ports = calloc(*nr_cpus, sizeof(**ports));
 	if (!*ports) {
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 390e9d99..c9fde0fa 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -24,8 +24,8 @@
 
 struct tsync_proto {
 	struct tsync_proto *next;
-	unsigned int proto_id;
-	int	weight;
+	char proto_name[TRACECMD_TSYNC_PNAME_LENGTH];
+	int accuracy;
 
 	int (*clock_sync_init)(struct tracecmd_time_sync *clock_context);
 	int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
@@ -35,32 +35,35 @@ struct tsync_proto {
 
 static struct tsync_proto *tsync_proto_list;
 
-static struct tsync_proto *tsync_proto_find(unsigned int proto_id)
+static struct tsync_proto *tsync_proto_find(const char *proto_name)
 {
 	struct tsync_proto *proto;
 
-	for (proto = tsync_proto_list; proto; proto = proto->next)
-		if (proto->proto_id == proto_id)
+	if (!proto_name)
+		return NULL;
+	for (proto = tsync_proto_list; proto; proto = proto->next) {
+		if (strlen(proto->proto_name) == strlen(proto_name) &&
+		     !strncmp(proto->proto_name, proto_name, TRACECMD_TSYNC_PNAME_LENGTH))
 			return proto;
-
+	}
 	return NULL;
 }
 
-int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
-				int (*init)(struct tracecmd_time_sync *),
-				int (*free)(struct tracecmd_time_sync *),
-				int (*calc)(struct tracecmd_time_sync *,
-					    long long *, long long *))
+int tracecmd_tsync_proto_register(const char *proto_name, int accuracy,
+				  int (*init)(struct tracecmd_time_sync *),
+				  int (*free)(struct tracecmd_time_sync *),
+				  int (*calc)(struct tracecmd_time_sync *,
+					      long long *, long long *))
 {
-	struct tsync_proto *proto;
+	struct tsync_proto *proto = NULL;
 
-	if (tsync_proto_find(proto_id))
+	if (tsync_proto_find(proto_name))
 		return -1;
 	proto = calloc(1, sizeof(struct tsync_proto));
 	if (!proto)
 		return -1;
-	proto->proto_id = proto_id;
-	proto->weight = weight;
+	strncpy(proto->proto_name, proto_name, TRACECMD_TSYNC_PNAME_LENGTH);
+	proto->accuracy = accuracy;
 	proto->clock_sync_init = init;
 	proto->clock_sync_free = free;
 	proto->clock_sync_calc = calc;
@@ -70,12 +73,16 @@ int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
 	return 0;
 }
 
-int tracecmd_tsync_proto_unregister(unsigned int proto_id)
+int tracecmd_tsync_proto_unregister(char *proto_name)
 {
 	struct tsync_proto **last = &tsync_proto_list;
 
+	if (!proto_name)
+		return -1;
+
 	for (; *last; last = &(*last)->next) {
-		if ((*last)->proto_id == proto_id) {
+		if (strlen((*last)->proto_name) == strlen(proto_name) &&
+		    !strncmp((*last)->proto_name, proto_name, TRACECMD_TSYNC_PNAME_LENGTH)) {
 			struct tsync_proto *proto = *last;
 
 			*last = proto->next;
@@ -87,9 +94,9 @@ int tracecmd_tsync_proto_unregister(unsigned int proto_id)
 	return -1;
 }
 
-bool tsync_proto_is_supported(unsigned int proto_id)
+bool tsync_proto_is_supported(const char *proto_name)
 {
-	if (tsync_proto_find(proto_id))
+	if (tsync_proto_find(proto_name))
 		return true;
 	return false;
 }
@@ -129,81 +136,79 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
  * tracecmd_tsync_proto_select - Select time sync protocol, to be used for
  *		timestamp synchronization with a peer
  *
- * @proto_mask: bitmask array of time sync protocols, supported by the peer
- * @length: size of the @protos array
+ * @protos: list of tsync protocol names
  *
- * Retuns Id of a time sync protocol, that can be used with the peer, or 0
- *	  in case there is no match with supported protocols
+ * Retuns pointer to a protocol name, that can be used with the peer, or NULL
+ *	  in case there is no match with supported protocols.
+ *	  The returned string MUST NOT be freed by the caller
  */
-unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length)
+const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos)
 {
 	struct tsync_proto *selected = NULL;
 	struct tsync_proto *proto;
-	int word;
-	int id;
+	char **pname;
 
-	for (word = 0; word < length; word++) {
-		for (proto = tsync_proto_list; proto; proto = proto->next) {
-			if (proto->proto_id < word * PROTO_MASK_SIZE)
-				continue;
+	if (!protos)
+		return NULL;
 
-			id = proto->proto_id - word * PROTO_MASK_SIZE;
-			if (id >= PROTO_MASK_BITS)
+	pname = protos->names;
+	while (*pname) {
+		for (proto = tsync_proto_list; proto; proto = proto->next) {
+			if (strncmp(proto->proto_name, *pname, TRACECMD_TSYNC_PNAME_LENGTH))
 				continue;
-
-			if ((1 << id) & proto_mask[word]) {
-				if (selected) {
-					if (selected->weight < proto->weight)
-						selected = proto;
-				} else
+			if (selected) {
+				if (selected->accuracy > proto->accuracy)
 					selected = proto;
-			}
+			} else
+				selected = proto;
 		}
+		pname++;
 	}
 
 	if (selected)
-		return selected->proto_id;
+		return selected->proto_name;
 
-	return 0;
+	return NULL;
 }
 
 /**
  * tracecmd_tsync_proto_getall - Returns bitmask of all supported
  *				 time sync protocols
- * @proto_mask: return, allocated bitmask array of time sync protocols,
+ * @protos: return, allocated list of time sync protocol names,
  *	       supported by the peer. Must be freed by free()
- * @words: return, allocated size of the @protobits array
  *
- * If completed successfully 0 is returned and allocated array in @proto_mask of
- * size @words. In case of an error, -1 is returned.
- * @proto_mask must be freed with free()
+ * If completed successfully 0 is returned and allocated list of strings in @protos.
+ * The last list entry is NULL. In case of an error, -1 is returned.
+ * @protos must be freed with free()
  */
-int tracecmd_tsync_proto_getall(char **proto_mask, int *words)
+int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos)
 {
+	struct tracecmd_tsync_protos *plist = NULL;
 	struct tsync_proto *proto;
-	int proto_max = 0;
-	int count = 0;
-	char *protos;
+	int count = 1;
+	int i;
 
 	for (proto = tsync_proto_list; proto; proto = proto->next)
-		if (proto->proto_id > proto_max)
-			proto_max = proto->proto_id;
-
-	count = proto_max / PROTO_MASK_SIZE + 1;
-	protos = calloc(count, sizeof(char));
-	if (!protos)
+		count++;
+	plist = calloc(1, sizeof(struct tracecmd_tsync_protos));
+	if (!plist)
+		goto error;
+	plist->names = calloc(count, sizeof(char *));
+	if (!plist->names)
 		return -1;
 
-	for (proto = tsync_proto_list; proto; proto = proto->next) {
-		if ((proto->proto_id / PROTO_MASK_SIZE) >= count)
-			continue;
-		protos[proto->proto_id / PROTO_MASK_SIZE] |=
-				(1 << (proto->proto_id % PROTO_MASK_SIZE));
-	}
+	for (i = 0, proto = tsync_proto_list; proto && i < (count - 1); proto = proto->next)
+		plist->names[i++] = proto->proto_name;
 
-	*proto_mask = protos;
-	*words = count;
+	*protos = plist;
 	return 0;
+
+error:
+	if (plist) {
+		free(plist->names);
+		free(plist);
+	}
+	return -1;
 }
 
 static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
@@ -267,7 +272,7 @@ static int clock_context_init(struct tracecmd_time_sync *tsync, bool server)
 	if (tsync->context)
 		return 0;
 
-	protocol = tsync_proto_find(tsync->sync_proto);
+	protocol = tsync_proto_find(tsync->proto_name);
 	if (!protocol)
 		return -1;
 
@@ -313,7 +318,7 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 		return;
 	tsync_context = (struct clock_sync_context *)tsync->context;
 
-	proto = tsync_proto_find(tsync->sync_proto);
+	proto = tsync_proto_find(tsync->proto_name);
 	if (proto && proto->clock_sync_free)
 		proto->clock_sync_free(tsync);
 
@@ -355,12 +360,12 @@ int tracecmd_tsync_send(struct tracecmd_time_sync *tsync,
  */
 void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync)
 {
+	char protocol[TRACECMD_TSYNC_PNAME_LENGTH];
 	struct tsync_proto *proto;
-	unsigned int protocol;
 	unsigned int command;
 	int ret;
 
-	proto = tsync_proto_find(tsync->sync_proto);
+	proto = tsync_proto_find(tsync->proto_name);
 	if (!proto || !proto->clock_sync_calc)
 		return;
 
@@ -370,11 +375,10 @@ void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync)
 
 	while (true) {
 		ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
-						  &protocol, &command,
+						  protocol, &command,
 						  NULL, NULL);
 
-		if (ret ||
-		    protocol != TRACECMD_TIME_SYNC_PROTO_NONE ||
+		if (ret || strncmp(protocol, TRACECMD_TSYNC_PROTO_NONE, TRACECMD_TSYNC_PNAME_LENGTH) ||
 		    command != TRACECMD_TIME_SYNC_CMD_PROBE)
 			break;
 		ret = tracecmd_tsync_send(tsync, proto);
@@ -455,7 +459,7 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
 	bool end = false;
 	int ret;
 
-	proto = tsync_proto_find(tsync->sync_proto);
+	proto = tsync_proto_find(tsync->proto_name);
 	if (!proto || !proto->clock_sync_calc)
 		return;
 
@@ -470,7 +474,7 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
 	while (true) {
 		pthread_mutex_lock(&tsync->lock);
 		ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
-						  TRACECMD_TIME_SYNC_PROTO_NONE,
+						  TRACECMD_TSYNC_PROTO_NONE,
 						  TRACECMD_TIME_SYNC_CMD_PROBE,
 						  0, NULL);
 		ret = tsync_get_sample(tsync, proto, ts_array_size);
@@ -492,7 +496,7 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
 	};
 
 	tracecmd_msg_send_time_sync(tsync->msg_handle,
-				    TRACECMD_TIME_SYNC_PROTO_NONE,
+				    TRACECMD_TSYNC_PROTO_NONE,
 				    TRACECMD_TIME_SYNC_CMD_STOP,
 				    0, NULL);
 }
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 85c7e03e..4089de4e 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -299,9 +299,9 @@ void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
 int tracecmd_host_tsync(struct buffer_instance *instance,
 			 unsigned int tsync_port);
 void tracecmd_host_tsync_complete(struct buffer_instance *instance);
-unsigned int tracecmd_guest_tsync(char *tsync_protos,
-				  unsigned int tsync_protos_size, char *clock,
-				  unsigned int *tsync_port, pthread_t *thr_id);
+const char *tracecmd_guest_tsync(struct tracecmd_tsync_protos *tsync_protos,
+				 char *clock, unsigned int *tsync_port,
+				 pthread_t *thr_id);
 
 int trace_make_vsock(unsigned int port);
 int trace_get_vsock_port(int sd, unsigned int *port);
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index b5816966..ff4a4e11 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -142,12 +142,11 @@ static char *get_clock(int argc, char **argv)
 
 static void agent_handle(int sd, int nr_cpus, int page_size)
 {
+	struct tracecmd_tsync_protos *tsync_protos = NULL;
 	struct tracecmd_msg_handle *msg_handle;
-	unsigned int tsync_protos_size = 0;
-	unsigned int tsync_proto = 0;
+	const char *tsync_proto = NULL;
 	unsigned long long trace_id;
 	unsigned int tsync_port = 0;
-	char *tsync_protos = NULL;
 	unsigned int *ports;
 	pthread_t sync_thr;
 	char **argv = NULL;
@@ -167,7 +166,7 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 
 	ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv,
 					  &use_fifos, &trace_id,
-					  &tsync_protos, &tsync_protos_size);
+					  &tsync_protos);
 	if (ret < 0)
 		die("Failed to receive trace request");
 
@@ -176,9 +175,8 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 
 	if (!use_fifos)
 		make_vsocks(nr_cpus, fds, ports);
-	if (tsync_protos) {
+	if (tsync_protos && tsync_protos->names) {
 		tsync_proto = tracecmd_guest_tsync(tsync_protos,
-						   tsync_protos_size,
 						   get_clock(argc, argv),
 						   &tsync_port, &sync_thr);
 		if (!tsync_proto)
@@ -197,7 +195,10 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 	if (tsync_proto)
 		pthread_join(sync_thr, NULL);
 
-	free(tsync_protos);
+	if (tsync_protos) {
+		free(tsync_protos->names);
+		free(tsync_protos);
+	}
 	free(argv[0]);
 	free(argv);
 	free(ports);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ade52421..9316bbde 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3852,12 +3852,11 @@ static int open_guest_fifos(const char *guest, int **fds)
 #ifdef VSOCK
 static void connect_to_agent(struct buffer_instance *instance)
 {
-	struct tracecmd_msg_handle *msg_handle;
+	struct tracecmd_tsync_protos *protos = NULL;
 	int sd, ret, nr_fifos, nr_cpus, page_size;
-	unsigned int tsync_protos_reply = 0;
+	struct tracecmd_msg_handle *msg_handle;
+	char *tsync_protos_reply = NULL;
 	unsigned int tsync_port = 0;
-	char *protos = NULL;
-	int protos_count = 0;
 	unsigned int *ports;
 	int i, *fds = NULL;
 	bool use_fifos = false;
@@ -3879,31 +3878,35 @@ static void connect_to_agent(struct buffer_instance *instance)
 		die("Failed to allocate message handle");
 
 	if (instance->tsync.loop_interval >= 0)
-		tracecmd_tsync_proto_getall(&protos, &protos_count);
+		tracecmd_tsync_proto_getall(&protos);
 
 	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
 					  instance->argv, use_fifos,
-					  top_instance.trace_id,
-					  protos, protos_count);
+					  top_instance.trace_id, protos);
 	if (ret < 0)
 		die("Failed to send trace request");
 
-	free(protos);
-
+	if (protos) {
+		free(protos->names);
+		free(protos);
+	}
 	ret = tracecmd_msg_recv_trace_resp(msg_handle, &nr_cpus, &page_size,
 					   &ports, &use_fifos,
 					   &instance->trace_id,
 					   &tsync_protos_reply, &tsync_port);
 	if (ret < 0)
 		die("Failed to receive trace response %d", ret);
-
-	if (protos_count && tsync_protos_reply) {
+	if (tsync_protos_reply && tsync_protos_reply[0]) {
 		if (tsync_proto_is_supported(tsync_protos_reply)) {
-			instance->tsync.sync_proto = tsync_protos_reply;
+			instance->tsync.proto_name = strdup(tsync_protos_reply);
+			printf("Negotiated %s time sync protocol with guest %s\n",
+				instance->tsync.proto_name,
+				tracefs_instance_get_name(instance->tracefs));
 			tracecmd_host_tsync(instance, tsync_port);
 		} else
 			warning("Failed to negotiate timestamps synchronization with the guest");
 	}
+	free(tsync_protos_reply);
 
 	if (use_fifos) {
 		if (nr_cpus != nr_fifos) {
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index 8b9083ae..5781cfd2 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -82,7 +82,7 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 	int ret;
 	int fd;
 
-	if (!instance->tsync.sync_proto)
+	if (!instance->tsync.proto_name)
 		return -1;
 
 	fd = trace_open_vsock(instance->cid, tsync_port);
@@ -210,22 +210,22 @@ out:
 	pthread_exit(0);
 }
 
-unsigned int tracecmd_guest_tsync(char *tsync_protos,
-				  unsigned int tsync_protos_size, char *clock,
-				  unsigned int *tsync_port, pthread_t *thr_id)
+const char *tracecmd_guest_tsync(struct tracecmd_tsync_protos *tsync_protos,
+				 char *clock, unsigned int *tsync_port,
+				 pthread_t *thr_id)
 {
 	struct tracecmd_time_sync *tsync = NULL;
 	cpu_set_t *pin_mask = NULL;
 	pthread_attr_t attrib;
 	size_t mask_size = 0;
-	unsigned int proto;
+	const char *proto;
 	int ret;
 	int fd;
 
 	fd = -1;
-	proto = tracecmd_tsync_proto_select(tsync_protos, tsync_protos_size);
+	proto = tracecmd_tsync_proto_select(tsync_protos);
 	if (!proto)
-		return 0;
+		return NULL;
 #ifdef VSOCK
 	fd = trace_make_vsock(VMADDR_PORT_ANY);
 	if (fd < 0)
@@ -235,7 +235,7 @@ unsigned int tracecmd_guest_tsync(char *tsync_protos,
 	if (ret < 0)
 		goto error;
 #else
-	return 0;
+	return NULL;
 #endif
 
 	tsync = calloc(1, sizeof(struct tracecmd_time_sync));
@@ -244,7 +244,7 @@ unsigned int tracecmd_guest_tsync(char *tsync_protos,
 		tsync->clock_str = strdup(clock);
 
 	pthread_attr_init(&attrib);
-	tsync->sync_proto = proto;
+	tsync->proto_name = proto;
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
 
 	ret = pthread_create(thr_id, &attrib, tsync_agent_thread, tsync);
@@ -272,5 +272,5 @@ error:
 	}
 	if (fd > 0)
 		close(fd);
-	return 0;
+	return NULL;
 }
-- 
2.29.2

