Return-Path: <SRS0=DRQG=3U=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5203FC33CB7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 030C520CC7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="erIicSGz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgAaMLj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 07:11:39 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33299 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728511AbgAaMLj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 07:11:39 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so4744593lfl.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 31 Jan 2020 04:11:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yu8o6voIK/6i50xVs2cgk6jCCYlQky5wPbjvr9xSI10=;
        b=erIicSGz0vKKV2cPLmnb8d55LXACph1s6FTim3J1G7RqLNTQo6C6/Pq0y4AbaTkwlI
         EVKyAekvfdjMp3fPdvULFY1o8vk2Kfq61PHZmFBLNuKHJwDlrfcP6WRnEUhioP/DMVlz
         d9+zZ95c5yWToYwZS5fUCZWoRynkMyUNcz3idMxwrIqhHPARxFeRuZbHuhDUgG8uMaPK
         AQWhsihyjQyEQqVpTEtL1AGV872ljyKzuWPJj6iDF8PlWc25m3PM4kNNoop2+WBuncSw
         l5p223n91gEjzfw0tScyGwuaAx4BmLO2QI8yrgllG5dJNJuSKXCCH/IMaVMPHr6WSAih
         jT9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yu8o6voIK/6i50xVs2cgk6jCCYlQky5wPbjvr9xSI10=;
        b=MR5N41I6W8SpvClufYMlf1nxyq5FjBX9GQzP72G9Czu42IcV2Hz2BW0xpXNHwSKUnd
         a+dI5HqbF204liOqIq/sZg/yRfKAxIAEvfmYfshp4zxcf0KamI7zc5yYJOjG8Ed1Iq2V
         kRgxCyYQDSYsbACYDnlnYvNk4e01qZrHpU+DqUKMqurEDdPrERQ1JEUa2YMv1cDteXCy
         YWJQ5lk3pPyQiOfjY/gmd5jFSyBqEW8XL90IjsQEY/jtpIKpvN6vacXO9ec8eH4rcmDr
         CY2ytxzlOY01BOz5L/sgHCGNz1C5/nnwIAJAT1aSEsmQwAd+JZMMDeH6g0QE46dOYraL
         C6sA==
X-Gm-Message-State: APjAAAV4MAaUtL38hJWipztWlDt3g4FbvfONTCQHT5yK82bv+CM/v1jG
        In7Ka1Wrb3Mhv09BA+NNi0laoon0Saw=
X-Google-Smtp-Source: APXvYqwjYcVLVBH1FlhUKV232bhYR5LPED/0eSu89AGDRQF0l8NfJ2GdzpzStBGnzBNcoGz3cgRyWQ==
X-Received: by 2002:a19:4a92:: with SMTP id x140mr5461996lfa.29.1580472693570;
        Fri, 31 Jan 2020 04:11:33 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i19sm4559965lfj.17.2020.01.31.04.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:11:32 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v19 13/15] trace-cmd: Basic infrastructure for host - guest timestamp synchronization
Date:   Fri, 31 Jan 2020 14:11:09 +0200
Message-Id: <20200131121111.130355-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131121111.130355-1-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The infrastructure for host - guest timestamp synchronization is divided
in two parts:
 - logic in libtracecmd
 - logic in trace-cmd application

The libtracecmd is extended with new trace message, MSG_TIME_SYNC, used to
exchange time synch information between host and guest. The trace request and
response messages are extended to handle the time synch negotiation. The logic
is implemented in trace-timesync.c file:
 - Register / unregister time sync protocols.
 - Choosing what protocol will be used for a tracing session.
 - Init common context, used by all protocols - a ftrace instance, vsockets.
 - Invoke protocol routines to perform time synchronization.
 - Store calculated offsets in an array.

The trace-cmd application is extended to perform timestamp synchronization.
The main logic is in trace-tsync.c file
 - Negotiate what time synch algorithm will be used for the tracing session.
 - Run pthreads, to do continuous timestamp synchronization, during the trace.
 - Store calculated offsets in guest's trace.dat file, using TRACECMD_OPTION_TIME_SHIFT option
 - A new trace-cmd option is added, to control the timestamp synchronization:
      --tsync-interval: set the time sync loop interval, in ms. The default
   value is 0 - timestamp synchronization is performed twice, before and after
   the trace. If a negative number is specified, the timestamp synchronization
   is disabled.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd-record.1.txt      |   7 +
 include/trace-cmd/trace-cmd.h             |  58 ++-
 lib/trace-cmd/Makefile                    |   1 +
 lib/trace-cmd/include/trace-tsync-local.h |  38 ++
 lib/trace-cmd/trace-msg.c                 | 395 ++++++++++++++---
 lib/trace-cmd/trace-timesync.c            | 498 ++++++++++++++++++++++
 tracecmd/Makefile                         |   3 +-
 tracecmd/include/trace-local.h            |  11 +
 tracecmd/trace-agent.c                    |  39 +-
 tracecmd/trace-record.c                   |  40 +-
 tracecmd/trace-tsync.c                    | 272 ++++++++++++
 tracecmd/trace-usage.c                    |   4 +
 12 files changed, 1299 insertions(+), 67 deletions(-)
 create mode 100644 lib/trace-cmd/include/trace-tsync-local.h
 create mode 100644 lib/trace-cmd/trace-timesync.c
 create mode 100644 tracecmd/trace-tsync.c

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index 0d75e43..f5ecad5 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -338,6 +338,13 @@ OPTIONS
     the offset will also be in nanoseconds even if the displayed units are
     in microseconds.
 
+*--tsync-interval*::
+    Set the loop interval, in ms, for timestamps synchronization with guests:
+        If a negative number is specified, timestamps synchronization is disabled
+        If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
+        at the beginning and at the end of the trace.
+        Timestamps synchronization with guests works only if there is support for VSOCK.\n"
+
 *--stderr*::
     Have output go to stderr instead of stdout, but the output of the command
     executed will not be changed. This is useful if you want to monitor the
diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 0375f50..42b47e2 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -379,19 +379,69 @@ void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 
 int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
 				int argc, char **argv, bool use_fifos,
-				unsigned long long trace_id);
+				unsigned long long trace_id,
+				char *tsync_protos,
+				int tsync_protos_size);
 int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 				int *argc, char ***argv, bool *use_fifos,
-				unsigned long long *trace_id);
+				unsigned long long *trace_id,
+				char **tsync_protos,
+				unsigned int *tsync_protos_size);
 
 int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int nr_cpus, int page_size,
 				 unsigned int *ports, bool use_fifos,
-				 unsigned long long trace_id);
+				 unsigned long long trace_id,
+				 unsigned int tsync_proto,
+				 unsigned int tsync_port);
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
 				 unsigned int **ports, bool *use_fifos,
-				 unsigned long long *trace_id);
+				 unsigned long long *trace_id,
+				 unsigned int *tsync_proto,
+				 unsigned int *tsync_port);
+
+int tracecmd_msg_send_time_sync(struct tracecmd_msg_handle *msg_handle,
+				unsigned int sync_protocol,
+				unsigned int sync_msg_id,
+				unsigned int payload_size, char *payload);
+int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
+				unsigned int *sync_protocol,
+				unsigned int *sync_msg_id,
+				unsigned int *payload_size, char **payload);
+
+/* --- Timestamp synchronization --- */
+
+enum{
+	TRACECMD_TIME_SYNC_PROTO_NONE	= 0,
+};
+enum{
+	TRACECMD_TIME_SYNC_CMD_PROBE	= 1,
+	TRACECMD_TIME_SYNC_CMD_STOP	= 2,
+};
+
+#define TRACECMD_TIME_SYNC_PROTO_PTP_WEIGHT	10
+
+struct tracecmd_time_sync {
+	unsigned int			sync_proto;
+	int				loop_interval;
+	pthread_mutex_t			lock;
+	pthread_cond_t			cond;
+	char				*clock_str;
+	struct tracecmd_msg_handle	*msg_handle;
+	void				*context;
+};
+
+void tracecmd_tsync_init(void);
+int tracecmd_tsync_proto_getall(char **proto_mask, int *words);
+unsigned int tracecmd_tsync_proto_select(char *proto_mask, int words);
+bool tsync_proto_is_supported(unsigned int proto_id);
+void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
+void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
+int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
+				int *count,
+				long long **ts, long long **offsets);
+void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
 
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 29c36ca..ab7440a 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -16,6 +16,7 @@ OBJS += trace-util.o
 OBJS += trace-filter-hash.o
 OBJS += trace-msg.o
 OBJS += trace-plugin.o
+OBJS += trace-timesync.o
 
 # Additional util objects
 OBJS += trace-blk-hack.o
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
new file mode 100644
index 0000000..1de9d5e
--- /dev/null
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#ifndef _TRACE_TSYNC_LOCAL_H
+#define _TRACE_TSYNC_LOCAL_H
+
+#include <stdbool.h>
+
+struct clock_sync_context {
+	void				*proto_data;	/* time sync protocol specific data */
+	bool				is_server;	/* server side time sync role */
+	struct tracefs_instance		*instance;	/* ftrace buffer, used for time sync events */
+
+	/* Arrays with calculated time offsets at given time */
+	int				sync_size;	/* Allocated size of sync_ts and sync_offsets */
+	int				sync_count;	/* Number of elements in sync_ts and sync_offsets */
+	long long			*sync_ts;
+	long long			*sync_offsets;
+
+	/* Identifiers of local and remote time sync peers: cid and port */
+	unsigned int			local_cid;
+	unsigned int			local_port;
+	unsigned int			remote_cid;
+	unsigned int			remote_port;
+};
+
+int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
+				int (*init)(struct tracecmd_time_sync *),
+				int (*free)(struct tracecmd_time_sync *),
+				int (*calc)(struct tracecmd_time_sync *,
+					    long long *, long long *));
+int tracecmd_tsync_proto_unregister(unsigned int proto_id);
+
+int ptp_clock_sync_register(void);
+
+#endif /* _TRACE_TSYNC_LOCAL_H */
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index d6a68ac..5a00dbf 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -29,6 +29,8 @@
 
 typedef __u32 u32;
 typedef __be32 be32;
+typedef __u64 u64;
+typedef __s64 s64;
 
 static inline void dprint(const char *fmt, ...)
 {
@@ -61,6 +63,18 @@ struct tracecmd_msg_rinit {
 	be32 cpus;
 } __attribute__((packed));
 
+#define TRACE_REQ_PARAM_SIZE  (2 * sizeof(int))
+enum trace_req_params {
+	TRACE_REQUEST_ARGS,
+	TRACE_REQUEST_TSYNC_PROTOS,
+};
+
+struct tracecmd_msg_trace_req_param {
+	int id;
+	int length;
+	char *value;
+};
+
 struct tracecmd_msg_trace_req {
 	be32 flags;
 	be32 argc;
@@ -72,6 +86,13 @@ struct tracecmd_msg_trace_resp {
 	be32 cpus;
 	be32 page_size;
 	u64 trace_id;
+	be32 tsync_proto;
+	be32 tsync_port;
+} __attribute__((packed));
+
+struct tracecmd_msg_tsync {
+	be32 sync_protocol;
+	be32 sync_msg_id;
 } __attribute__((packed));
 
 struct tracecmd_msg_header {
@@ -89,7 +110,8 @@ struct tracecmd_msg_header {
 	C(NOT_SUPP,	5,	0),					\
 	C(TRACE_REQ,	6,	sizeof(struct tracecmd_msg_trace_req)),	\
 	C(TRACE_RESP,	7,	sizeof(struct tracecmd_msg_trace_resp)),\
-	C(CLOSE_RESP,	8,	0),
+	C(CLOSE_RESP,	8,	0),					\
+	C(TIME_SYNC,	9,	sizeof(struct tracecmd_msg_tsync)),
 
 #undef C
 #define C(a,b,c)	MSG_##a = b
@@ -123,6 +145,7 @@ struct tracecmd_msg {
 		struct tracecmd_msg_rinit	rinit;
 		struct tracecmd_msg_trace_req	trace_req;
 		struct tracecmd_msg_trace_resp	trace_resp;
+		struct tracecmd_msg_tsync	tsync;
 	};
 	char					*buf;
 } __attribute__((packed));
@@ -265,6 +288,17 @@ static int tracecmd_msg_send(int fd, struct tracecmd_msg *msg)
 	return ret;
 }
 
+static int msg_send_nofree(int fd, struct tracecmd_msg *msg)
+{
+	int ret = 0;
+
+	ret = msg_write(fd, msg);
+	if (ret < 0)
+		ret = -ECOMM;
+
+	return ret;
+}
+
 static int msg_read(int fd, void *buf, u32 size, int *n)
 {
 	ssize_t r;
@@ -814,81 +848,141 @@ int tracecmd_msg_wait_close_resp(struct tracecmd_msg_handle *msg_handle)
 	return tracecmd_msg_wait_for_cmd(msg_handle, MSG_CLOSE_RESP);
 }
 
-static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
-			  bool use_fifos, unsigned long long trace_id)
+static int make_trace_req_protos(char **buf, int *size,
+				 int protos_size, char *tsync_protos)
 {
-	size_t args_size = 0;
+	size_t buf_size;
+	char *nbuf;
+	char *p;
+
+	buf_size = TRACE_REQ_PARAM_SIZE + protos_size;
+	nbuf = realloc(*buf, *size + buf_size);
+	if (!nbuf)
+		return -1;
+
+	p = nbuf + *size;
+	memset(p, 0, buf_size);
+
+	*(unsigned int *)p = htonl(TRACE_REQUEST_TSYNC_PROTOS);
+	p += sizeof(int);
+	*(unsigned int *)p = htonl(protos_size);
+	p += sizeof(int);
+
+	memcpy(p, tsync_protos, protos_size);
+
+	*size += buf_size;
+	*buf = nbuf;
+	return 0;
+}
+
+static int make_trace_req_args(char **buf, int *size, int argc, char **argv)
+{
+	size_t args_size;
+	size_t buf_size;
+	char *nbuf;
 	char *p;
 	int i;
 
+	args_size = sizeof(int);
 	for (i = 0; i < argc; i++)
 		args_size += strlen(argv[i]) + 1;
 
-	msg->hdr.size = htonl(ntohl(msg->hdr.size) + args_size);
-	msg->trace_req.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
-	msg->trace_req.argc = htonl(argc);
-	msg->trace_req.trace_id = htonll(trace_id);
-	msg->buf = calloc(args_size, 1);
-	if (!msg->buf)
-		return -ENOMEM;
+	buf_size = TRACE_REQ_PARAM_SIZE + args_size;
+	nbuf = realloc(*buf, *size + buf_size);
+	if (!nbuf)
+		return -1;
+
+	p = nbuf + *size;
+	memset(p, 0, buf_size);
+
+	*(unsigned int *)p = htonl(TRACE_REQUEST_ARGS);
+	p += sizeof(int);
+	*(unsigned int *)p = htonl(args_size);
+	p += sizeof(int);
 
-	p = msg->buf;
+	*(unsigned int *)p = htonl(argc);
+	p += sizeof(int);
 	for (i = 0; i < argc; i++)
 		p = stpcpy(p, argv[i]) + 1;
 
+	*size += buf_size;
+	*buf = nbuf;
+	return 0;
+}
+
+static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
+			  bool use_fifos, unsigned long long trace_id,
+			  char *tsync_protos, int tsync_protos_size)
+{
+	int size = 0;
+	char *buf = NULL;
+
+	msg->trace_req.flags = 0;
+	if (use_fifos)
+		msg->trace_req.flags |= MSG_TRACE_USE_FIFOS;
+	msg->trace_req.flags = htonl(msg->trace_req.flags);
+	msg->trace_req.trace_id = htonll(trace_id);
+
+	if (argc && argv)
+		make_trace_req_args(&buf, &size, argc, argv);
+	if (tsync_protos_size && tsync_protos)
+		make_trace_req_protos(&buf, &size,
+				      tsync_protos_size, tsync_protos);
+
+	msg->buf = buf;
+	msg->hdr.size = htonl(ntohl(msg->hdr.size) + size);
+
 	return 0;
 }
 
 int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
 				int argc, char **argv, bool use_fifos,
-				unsigned long long trace_id)
+				unsigned long long trace_id,
+				char *tsync_protos,
+				int tsync_protos_size)
 {
 	struct tracecmd_msg msg;
 	int ret;
 
 	tracecmd_msg_init(MSG_TRACE_REQ, &msg);
-	ret = make_trace_req(&msg, argc, argv, use_fifos, trace_id);
+	ret = make_trace_req(&msg, argc, argv, use_fifos,
+			     trace_id, tsync_protos, tsync_protos_size);
 	if (ret < 0)
 		return ret;
 
 	return tracecmd_msg_send(msg_handle->fd, &msg);
 }
 
- /*
-  * NOTE: On success, the returned `argv` should be freed with:
-  *     free(argv[0]);
-  *     free(argv);
-  */
-int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int *argc, char ***argv, bool *use_fifos,
-				unsigned long long *trace_id)
+static int get_trace_req_protos(char *buf, int length,
+				char **tsync_protos,
+				unsigned int *tsync_protos_size)
 {
-	struct tracecmd_msg msg;
-	char *p, *buf_end, **args;
-	int i, ret, nr_args;
-	ssize_t buf_len;
+	*tsync_protos = malloc(length);
+	if (!*tsync_protos)
+		return -1;
+	memcpy(*tsync_protos, buf, length);
+	*tsync_protos_size = length;
 
-	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
-	if (ret < 0)
-		return ret;
+	return 0;
+}
 
-	if (ntohl(msg.hdr.cmd) != MSG_TRACE_REQ) {
-		ret = -ENOTSUP;
-		goto out;
-	}
+static int get_trace_req_args(char *buf, int length, int *argc, char ***argv)
+{
+	unsigned int nr_args;
+	char *p, *buf_end;
+	char **args = NULL;
+	char *vagrs = NULL;
+	int ret;
+	int i;
 
-	nr_args = ntohl(msg.trace_req.argc);
-	if (nr_args <= 0) {
+	if (length <= sizeof(int) || buf[length - 1] != '\0') {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
-	buf_end = (char *)msg.buf + buf_len;
-	if (buf_len <= 0 && ((char *)msg.buf)[buf_len-1] != '\0') {
-		ret = -EINVAL;
-		goto out;
-	}
+	nr_args = ntohl(*(unsigned int *)buf);
+	buf += sizeof(int);
+	length -= sizeof(int);
 
 	args = calloc(nr_args, sizeof(*args));
 	if (!args) {
@@ -896,10 +990,18 @@ int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 		goto out;
 	}
 
-	for (i = 0, p = msg.buf; i < nr_args; i++, p++) {
+	vagrs = calloc(length, sizeof(char));
+	if (!vagrs) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(vagrs, buf, length);
+	buf_end = vagrs + length;
+	for (i = 0, p = vagrs; i < nr_args; i++, p++) {
 		if (p >= buf_end) {
 			ret = -EINVAL;
-			goto out_args;
+			goto out;
 		}
 		args[i] = p;
 		p = strchr(p, '\0');
@@ -907,18 +1009,82 @@ int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 
 	*argc = nr_args;
 	*argv = args;
+	return 0;
+
+out:
+	free(args);
+	free(vagrs);
+	return ret;
+
+}
+
+/*
+ * NOTE: On success, the returned `argv` should be freed with:
+ *     free(argv[0]);
+ *     free(argv);
+ * and `tsync_protos` with free(tsync_protos);
+ */
+int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
+				int *argc, char ***argv, bool *use_fifos,
+				unsigned long long *trace_id,
+				char **tsync_protos,
+				unsigned int *tsync_protos_size)
+{
+	struct tracecmd_msg msg;
+	unsigned int param_id;
+	int param_length;
+	ssize_t buf_len;
+	char *p;
+	int ret;
+
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0)
+		return ret;
+
+	if (ntohl(msg.hdr.cmd) != MSG_TRACE_REQ) {
+		ret = -ENOTSUP;
+		goto out;
+	}
+
+	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
+	if (buf_len < 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	*use_fifos = ntohl(msg.trace_req.flags) & MSG_TRACE_USE_FIFOS;
 	*trace_id = ntohll(msg.trace_req.trace_id);
-	/*
-	 * On success we're passing msg.buf to the caller through argv[0] so we
-	 * reset it here before calling msg_free().
-	 */
-	msg.buf = NULL;
+	p = msg.buf;
+	while (buf_len > 2 * sizeof(int)) {
+		param_id = ntohl(*((unsigned int *)p));
+		p += sizeof(int);
+		buf_len -= sizeof(int);
+		param_length = ntohl(*((unsigned int *)p));
+		p += sizeof(int);
+		buf_len -= sizeof(int);
+		if (buf_len < param_length)
+			break;
+		ret = 0;
+		switch (param_id) {
+		case TRACE_REQUEST_ARGS:
+			ret = get_trace_req_args(p, param_length, argc, argv);
+			break;
+		case TRACE_REQUEST_TSYNC_PROTOS:
+			ret = get_trace_req_protos(p, param_length,
+						   tsync_protos, tsync_protos_size);
+			break;
+		default:
+			break;
+		}
+		if (ret)
+			break;
+		buf_len -= param_length;
+		p += param_length;
+	}
+
 	msg_free(&msg);
 	return 0;
 
-out_args:
-	free(args);
 out:
 	error_operation(&msg);
 	if (ret == -EOPNOTSUPP)
@@ -927,9 +1093,118 @@ out:
 	return ret;
 }
 
+/**
+ * tracecmd_msg_send_time_sync - Send a time sync packet
+ * @msg_handle: message handle, holding the communication context
+ * @sync_protocol: id of the time synch protocol
+ * @sync_msg_id: id if the time synch message, protocol dependent
+ * @payload_size: size of the packet payload, 0 in case of no payload
+ * @payload: pointer to the packet payload, or NULL in case of no payload
+ *
+ * Returns 0 if packet is sent successfully, or negative error otherwise.
+ */
+int tracecmd_msg_send_time_sync(struct tracecmd_msg_handle *msg_handle,
+				unsigned int sync_protocol,
+				unsigned int sync_msg_id,
+				unsigned int payload_size, char *payload)
+{
+	struct tracecmd_msg msg;
+
+	tracecmd_msg_init(MSG_TIME_SYNC, &msg);
+	msg.tsync.sync_protocol = htonl(sync_protocol);
+	msg.tsync.sync_msg_id = htonl(sync_msg_id);
+	msg.hdr.size = htonl(ntohl(msg.hdr.size) + payload_size);
+
+	msg.buf = payload;
+	return msg_send_nofree(msg_handle->fd, &msg);
+}
+
+/**
+ * tracecmd_msg_recv_time_sync - Receive a time sync packet
+ * @msg_handle: message handle, holding the communication context
+ * @sync_protocol: return the id of the packet's time synch protocol
+ * @sync_msg_id: return the id of the packet's time synch message
+ * @payload_size: size of the packet's payload, can be:
+ *		 NULL - the payload is not interested and should be ignored
+ *		 pointer to int, with value 0 - update with the size of the payload
+ *						allocate memory and cpy the payload
+ *						into it
+ *		 pointer to int, with value greater than 0 - expected size of the
+ *							     payload, preallocated
+ *							     memory is passed to the API
+ *							     with that size
+ *@payload: pointer to the packet payload, can be:
+ *	     NULL - the payload is not interested and should be ignored
+ *	     pointer to char *, with value NULL - a new memory is allocated and returned
+ *						  here, containing the packet's payload
+ *						  the @payload_size is updated with the
+ *						  size of the allocated memory. It must be
+ *						  freed by free()
+ *	     pointer to char *, with no-NULL value - A prealocated array is passed, with size
+ *						     @payload_size. If payload's size is equal
+ *						     or less, it will be copied here.
+ *
+ * Returns 0 if packet is received successfully, or negative error otherwise.
+ */
+int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
+				unsigned int *sync_protocol,
+				unsigned int *sync_msg_id,
+				unsigned int *payload_size, char **payload)
+{
+	struct tracecmd_msg msg;
+	int ret = -1;
+	int buf_size;
+
+	memset(&msg, 0, sizeof(msg));
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0)
+		goto out;
+
+	if (ntohl(msg.hdr.cmd) != MSG_TIME_SYNC) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (sync_protocol)
+		*sync_protocol = ntohl(msg.tsync.sync_protocol);
+	if (sync_msg_id)
+		*sync_msg_id = ntohl(msg.tsync.sync_msg_id);
+
+	buf_size = msg_buf_len(&msg);
+	if (buf_size < 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (buf_size && payload && payload_size) {
+		if (*payload_size) {
+			if (*payload_size < buf_size || *payload == NULL) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			memcpy(*payload, msg.buf, buf_size);
+			goto out;
+		}
+
+		*payload = malloc(buf_size);
+		if (*payload == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		*payload_size = buf_size;
+		memcpy(*payload, msg.buf, buf_size);
+	}
+
+out:
+	msg_free(&msg);
+	return ret;
+}
+
 static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
 			   unsigned int *ports, bool use_fifos,
-			   unsigned long long trace_id)
+			   unsigned long long trace_id,
+			   unsigned int tsync_proto,
+			   unsigned int tsync_port)
 {
 	int data_size;
 
@@ -940,7 +1215,11 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
 	write_uints(msg->buf, data_size, ports, nr_cpus);
 
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + data_size);
-	msg->trace_resp.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
+	msg->trace_req.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
+	msg->trace_resp.flags = htonl(msg->trace_resp.flags);
+	msg->trace_resp.tsync_proto = htonl(tsync_proto);
+	msg->trace_resp.tsync_port = htonl(tsync_port);
+
 	msg->trace_resp.cpus = htonl(nr_cpus);
 	msg->trace_resp.page_size = htonl(page_size);
 	msg->trace_resp.trace_id = htonll(trace_id);
@@ -951,14 +1230,16 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
 int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int nr_cpus, int page_size,
 				 unsigned int *ports, bool use_fifos,
-				 unsigned long long trace_id)
+				 unsigned long long trace_id,
+				 unsigned int tsync_proto,
+				 unsigned int tsync_port)
 {
 	struct tracecmd_msg msg;
 	int ret;
 
 	tracecmd_msg_init(MSG_TRACE_RESP, &msg);
 	ret = make_trace_resp(&msg, page_size, nr_cpus, ports,
-			      use_fifos, trace_id);
+			      use_fifos, trace_id, tsync_proto, tsync_port);
 	if (ret < 0)
 		return ret;
 
@@ -968,7 +1249,9 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
 				 unsigned int **ports, bool *use_fifos,
-				 unsigned long long *trace_id)
+				 unsigned long long *trace_id,
+				 unsigned int *tsync_proto,
+				 unsigned int *tsync_port)
 {
 	struct tracecmd_msg msg;
 	char *p, *buf_end;
@@ -994,6 +1277,8 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 	*nr_cpus = ntohl(msg.trace_resp.cpus);
 	*page_size = ntohl(msg.trace_resp.page_size);
 	*trace_id = ntohll(msg.trace_resp.trace_id);
+	*tsync_proto = ntohl(msg.trace_resp.tsync_proto);
+	*tsync_port = ntohl(msg.trace_resp.tsync_port);
 	*ports = calloc(*nr_cpus, sizeof(**ports));
 	if (!*ports) {
 		ret = -ENOMEM;
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
new file mode 100644
index 0000000..0534b14
--- /dev/null
+++ b/lib/trace-cmd/trace-timesync.c
@@ -0,0 +1,498 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+
+#include <fcntl.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <linux/vm_sockets.h>
+#include <linux/limits.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <time.h>
+#include <dirent.h>
+#include <errno.h>
+#include <pthread.h>
+
+#include "trace-cmd.h"
+#include "tracefs.h"
+#include "event-utils.h"
+#include "trace-tsync-local.h"
+
+struct tsync_proto {
+	struct tsync_proto *next;
+	unsigned int proto_id;
+	int	weight;
+
+	int (*clock_sync_init)(struct tracecmd_time_sync *clock_context);
+	int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
+	int (*clock_sync_calc)(struct tracecmd_time_sync *clock_context,
+			       long long *offset, long long *timestamp);
+};
+
+static struct tsync_proto *tsync_proto_list;
+
+static struct tsync_proto *tsync_proto_find(unsigned int proto_id)
+{
+	struct tsync_proto *proto;
+
+	for (proto = tsync_proto_list; proto; proto = proto->next)
+		if (proto->proto_id == proto_id)
+			return proto;
+
+	return NULL;
+}
+
+int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
+				int (*init)(struct tracecmd_time_sync *),
+				int (*free)(struct tracecmd_time_sync *),
+				int (*calc)(struct tracecmd_time_sync *,
+					    long long *, long long *))
+{
+	struct tsync_proto *proto;
+
+	if (tsync_proto_find(proto_id))
+		return -1;
+	proto = calloc(1, sizeof(struct tsync_proto));
+	if (!proto)
+		return -1;
+	proto->proto_id = proto_id;
+	proto->weight = weight;
+	proto->clock_sync_init = init;
+	proto->clock_sync_free = free;
+	proto->clock_sync_calc = calc;
+
+	proto->next = tsync_proto_list;
+	tsync_proto_list = proto;
+	return 0;
+}
+
+int tracecmd_tsync_proto_unregister(unsigned int proto_id)
+{
+	struct tsync_proto **last = &tsync_proto_list;
+
+	for (; *last; last = &(*last)->next) {
+		if ((*last)->proto_id == proto_id) {
+			struct tsync_proto *proto = *last;
+
+			*last = proto->next;
+			free(proto);
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+bool tsync_proto_is_supported(unsigned int proto_id)
+{
+	if (tsync_proto_find(proto_id))
+		return true;
+	return false;
+}
+
+/**
+ * tracecmd_tsync_get_offsets - Return the calculated time offsets
+ *
+ * @tsync: Pointer to time sync context
+ * @count: Returns the number of calculated time offsets
+ * @ts: Array of size @count containing timestamps of callculated offsets
+ * @offsets: array of size @count, containing offsets for each timestamp
+ *
+ * Retuns -1 in case of an error, or 0 otherwise
+ */
+int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
+				int *count,
+				long long **ts, long long **offsets)
+{
+	struct clock_sync_context *tsync_context;
+
+	if (!tsync || !tsync->context)
+		return -1;
+	tsync_context = (struct clock_sync_context *)tsync->context;
+	if (count)
+		*count = tsync_context->sync_count;
+	if (ts)
+		*ts = tsync_context->sync_ts;
+	if (offsets)
+		*offsets = tsync_context->sync_offsets;
+	return 0;
+}
+
+
+#define PROTO_MASK_SIZE (sizeof(char))
+/**
+ * tracecmd_tsync_proto_select - Select time sync protocol, to be used for
+ *		timestamp synchronization with a peer
+ *
+ * @proto_mask: bitmask array of time sync protocols, supported by the peer
+ * @length: size of the @protos array
+ *
+ * Retuns Id of a time sync protocol, that can be used with the peer, or 0
+ *	  in case there is no match with supported protocols
+ */
+unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length)
+{
+	struct tsync_proto *selected = NULL;
+	struct tsync_proto *proto;
+	int word;
+	int id;
+
+	for (word = 0; word < length; word++) {
+		for (proto = tsync_proto_list; proto; proto = proto->next) {
+			if (proto->proto_id < word * PROTO_MASK_SIZE)
+				continue;
+
+			id = proto->proto_id - word * PROTO_MASK_SIZE;
+			if (id >= PROTO_MASK_SIZE)
+				continue;
+
+			if ((1 << id) & proto_mask[word]) {
+				if (selected) {
+					if (selected->weight < proto->weight)
+						selected = proto;
+				} else
+					selected = proto;
+			}
+		}
+	}
+
+	if (selected)
+		return selected->proto_id;
+
+	return 0;
+}
+
+/**
+ * tracecmd_tsync_proto_getall - Returns bitmask of all supported
+ *				 time sync protocols
+ * @proto_mask: return, allocated bitmask array of time sync protocols,
+ *	       supported by the peer. Must be freed by free()
+ * @words: return, allocated size of the @protobits array
+ *
+ * If completed successfully 0 is returned and allocated array in @proto_mask of
+ * size @words. In case of an error, -1 is returned.
+ * @proto_mask must be freed with free()
+ */
+int tracecmd_tsync_proto_getall(char **proto_mask, int *words)
+{
+	struct tsync_proto *proto;
+	int proto_max = 0;
+	int count = 0;
+	char *protos;
+
+	for (proto = tsync_proto_list; proto; proto = proto->next)
+		if (proto->proto_id > proto_max)
+			proto_max = proto->proto_id;
+
+	count = proto_max / PROTO_MASK_SIZE + 1;
+	protos = calloc(count, sizeof(char));
+	if (!protos)
+		return -1;
+
+	for (proto = tsync_proto_list; proto; proto = proto->next) {
+		if ((proto->proto_id / PROTO_MASK_SIZE) >= count)
+			continue;
+		protos[proto->proto_id / PROTO_MASK_SIZE] |=
+				(1 << (proto->proto_id % PROTO_MASK_SIZE));
+	}
+
+	*proto_mask = protos;
+	*words = count;
+	return 0;
+}
+
+static int get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
+			      unsigned int *rcid, unsigned int *rport)
+{
+	struct sockaddr_vm addr;
+	socklen_t addr_len = sizeof(addr);
+
+	memset(&addr, 0, sizeof(addr));
+	if (getsockname(fd, (struct sockaddr *)&addr, &addr_len))
+		return -1;
+	if (addr.svm_family != AF_VSOCK)
+		return -1;
+	*lport = addr.svm_port;
+	*lcid = addr.svm_cid;
+
+	memset(&addr, 0, sizeof(addr));
+	addr_len = sizeof(addr);
+	if (getpeername(fd, (struct sockaddr *)&addr, &addr_len))
+		return -1;
+	if (addr.svm_family != AF_VSOCK)
+		return -1;
+	*rport = addr.svm_port;
+	*rcid = addr.svm_cid;
+
+	return 0;
+}
+
+static struct tracefs_instance *
+clock_synch_create_instance(const char *clock, unsigned int cid)
+{
+	struct tracefs_instance *instance;
+	char inst_name[256];
+
+	snprintf(inst_name, 256, "clock_synch-%d", cid);
+
+	instance = tracefs_instance_alloc(inst_name);
+	if (!instance)
+		return NULL;
+
+	tracefs_instance_create(instance);
+	tracefs_instance_file_write(instance, "trace", "\0");
+	if (clock)
+		tracefs_instance_file_write(instance, "trace_clock", clock);
+	return instance;
+}
+
+static void
+clock_synch_delete_instance(struct tracefs_instance *inst)
+{
+	if (!inst)
+		return;
+	tracefs_instance_destroy(inst);
+	tracefs_instance_free(inst);
+}
+
+static int clock_context_init(struct tracecmd_time_sync *tsync, bool server)
+{
+	struct clock_sync_context *clock = NULL;
+	struct tsync_proto *protocol;
+
+	if (tsync->context)
+		return 0;
+
+	protocol = tsync_proto_find(tsync->sync_proto);
+	if (!protocol)
+		return -1;
+
+	clock = calloc(1, sizeof(struct clock_sync_context));
+	if (!clock)
+		return -1;
+
+	clock->is_server = server;
+	if (get_vsocket_params(tsync->msg_handle->fd, &clock->local_cid,
+			       &clock->local_port, &clock->remote_cid,
+			       &clock->remote_port))
+		goto error;
+
+	clock->instance = clock_synch_create_instance(tsync->clock_str,
+						      clock->remote_cid);
+	if (!clock->instance)
+		goto error;
+
+	tsync->context = clock;
+	if (protocol->clock_sync_init && protocol->clock_sync_init(tsync) < 0)
+		goto error;
+
+	return 0;
+error:
+	tsync->context = NULL;
+	free(clock);
+	return -1;
+}
+
+/**
+ * tracecmd_tsync_free - Free time sync context, allocated by
+ *		tracecmd_tsync_with_host() or tracecmd_tsync_with_guest() APIs
+ *
+ * @tsync: Pointer to time sync context
+ *
+ */
+void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
+{
+	struct clock_sync_context *tsync_context;
+	struct tsync_proto *proto;
+
+	if (!tsync->context)
+		return;
+	tsync_context = (struct clock_sync_context *)tsync->context;
+
+	proto = tsync_proto_find(tsync->sync_proto);
+	if (proto && proto->clock_sync_free)
+		proto->clock_sync_free(tsync);
+
+	clock_synch_delete_instance(tsync_context->instance);
+	tsync_context->instance = NULL;
+
+	free(tsync_context->sync_ts);
+	free(tsync_context->sync_offsets);
+	tsync_context->sync_ts = NULL;
+	tsync_context->sync_offsets = NULL;
+	tsync_context->sync_count = 0;
+	tsync_context->sync_size = 0;
+	pthread_mutex_destroy(&tsync->lock);
+	pthread_cond_destroy(&tsync->cond);
+	free(tsync->clock_str);
+}
+
+int tracecmd_tsync_send(struct tracecmd_time_sync *tsync,
+				  struct tsync_proto *proto)
+{
+	long long timestamp = 0;
+	long long offset = 0;
+	int ret;
+
+	ret = proto->clock_sync_calc(tsync, &offset, &timestamp);
+
+	return ret;
+}
+
+/**
+ * tracecmd_tsync_with_host - Synchronize timestamps with host
+ *
+ * @tsync: Pointer to time sync context
+ *
+ * This API is supposed to be called in guest context. It waits for a time
+ * sync request from the host and replies with a time sample, until time sync
+ * stop command is received
+ *
+ */
+void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync)
+{
+	struct tsync_proto *proto;
+	unsigned int protocol;
+	unsigned int command;
+	int ret;
+
+	proto = tsync_proto_find(tsync->sync_proto);
+	if (!proto || !proto->clock_sync_calc)
+		return;
+
+	clock_context_init(tsync, true);
+	if (!tsync->context)
+		return;
+
+	while (true) {
+		ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+						  &protocol, &command,
+						  NULL, NULL);
+
+		if (ret ||
+		    protocol != TRACECMD_TIME_SYNC_PROTO_NONE ||
+		    command != TRACECMD_TIME_SYNC_CMD_PROBE)
+			break;
+		ret = tracecmd_tsync_send(tsync, proto);
+		if (ret)
+			break;
+	}
+}
+
+static int tsync_get_sample(struct tracecmd_time_sync *tsync,
+			    struct tsync_proto *proto, int array_step)
+{
+	struct clock_sync_context *clock;
+	long long *sync_offsets = NULL;
+	long long *sync_ts = NULL;
+	long long timestamp = 0;
+	long long offset = 0;
+	int ret;
+
+	ret = proto->clock_sync_calc(tsync, &offset, &timestamp);
+	if (ret) {
+		warning("Failed to synchronize timestamps with guest");
+		return -1;
+	}
+	if (!offset || !timestamp)
+		return 0;
+	clock = tsync->context;
+	if (clock->sync_count >= clock->sync_size) {
+		sync_ts = realloc(clock->sync_ts,
+				  (clock->sync_size + array_step) * sizeof(long long));
+		sync_offsets = realloc(clock->sync_offsets,
+				       (clock->sync_size + array_step) * sizeof(long long));
+		if (!sync_ts || !sync_offsets) {
+			free(sync_ts);
+			free(sync_offsets);
+			return -1;
+		}
+		clock->sync_size += array_step;
+		clock->sync_ts = sync_ts;
+		clock->sync_offsets = sync_offsets;
+	}
+
+	clock->sync_ts[clock->sync_count] = timestamp;
+	clock->sync_offsets[clock->sync_count] = offset;
+	clock->sync_count++;
+
+	return 0;
+}
+
+#define TIMER_SEC_NANO 1000000000LL
+static inline void get_ts_loop_delay(struct timespec *timeout, int delay_ms)
+{
+	memset(timeout, 0, sizeof(struct timespec));
+	clock_gettime(CLOCK_REALTIME, timeout);
+
+	timeout->tv_nsec += ((unsigned long long)delay_ms * 1000000LL);
+
+	if (timeout->tv_nsec >= TIMER_SEC_NANO) {
+		timeout->tv_sec += timeout->tv_nsec / TIMER_SEC_NANO;
+		timeout->tv_nsec %= TIMER_SEC_NANO;
+	}
+}
+
+#define CLOCK_TS_ARRAY 5
+/**
+ * tracecmd_tsync_with_guest - Synchronize timestamps with guest
+ *
+ * @tsync: Pointer to time sync context
+ *
+ * This API is supposed to be called in host context, in a separate thread
+ * It loops infinite, until the timesync semaphore is released
+ *
+ */
+void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
+{
+	int ts_array_size = CLOCK_TS_ARRAY;
+	struct tsync_proto *proto;
+	struct timespec timeout;
+	bool end = false;
+	int ret;
+
+	proto = tsync_proto_find(tsync->sync_proto);
+	if (!proto || !proto->clock_sync_calc)
+		return;
+
+	clock_context_init(tsync, false);
+	if (!tsync->context)
+		return;
+
+	if (tsync->loop_interval > 0 &&
+	    tsync->loop_interval < (CLOCK_TS_ARRAY * 1000))
+		ts_array_size = (CLOCK_TS_ARRAY * 1000) / tsync->loop_interval;
+
+	while (true) {
+		pthread_mutex_lock(&tsync->lock);
+		ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
+						  TRACECMD_TIME_SYNC_PROTO_NONE,
+						  TRACECMD_TIME_SYNC_CMD_PROBE,
+						  0, NULL);
+		ret = tsync_get_sample(tsync, proto, ts_array_size);
+		if (ret || end)
+			break;
+		if (tsync->loop_interval > 0) {
+			get_ts_loop_delay(&timeout, tsync->loop_interval);
+			ret = pthread_cond_timedwait(&tsync->cond, &tsync->lock, &timeout);
+			pthread_mutex_unlock(&tsync->lock);
+			if (ret && ret != ETIMEDOUT)
+				break;
+			else if (!ret)
+				end = true;
+		} else {
+			pthread_cond_wait(&tsync->cond, &tsync->lock);
+			end = true;
+			pthread_mutex_unlock(&tsync->lock);
+		}
+	};
+
+	tracecmd_msg_send_time_sync(tsync->msg_handle,
+				    TRACECMD_TIME_SYNC_PROTO_NONE,
+				    TRACECMD_TIME_SYNC_CMD_STOP,
+				    0, NULL);
+}
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 0976341..17e6760 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -31,6 +31,7 @@ TRACE_CMD_OBJS += trace-show.o
 TRACE_CMD_OBJS += trace-list.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-dump.o
+TRACE_CMD_OBJS += trace-tsync.o
 
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-agent.o
@@ -43,7 +44,7 @@ all_objs := $(sort $(ALL_OBJS))
 all_deps := $(all_objs:$(bdir)/%.o=$(bdir)/.%.d)
 
 CONFIG_INCLUDES =
-CONFIG_LIBS	= -lrt
+CONFIG_LIBS	= -lrt -lpthread
 CONFIG_FLAGS	=
 
 all: $(TARGETS)
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 95d0026..49c52b1 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -229,6 +229,10 @@ struct buffer_instance {
 	unsigned int		port;
 	int			*fds;
 	bool			use_fifos;
+
+	pthread_t		tsync_thread;
+	bool			tsync_thread_running;
+	struct tracecmd_time_sync tsync;
 };
 
 void init_top_instance(void);
@@ -263,6 +267,13 @@ void tracecmd_disable_tracing(void);
 void tracecmd_enable_tracing(void);
 void tracecmd_stat_cpu(struct trace_seq *s, int cpu);
 
+int tracecmd_host_tsync(struct buffer_instance *instance,
+			 unsigned int tsync_port);
+void tracecmd_host_tsync_complete(struct buffer_instance *instance);
+unsigned int tracecmd_guest_tsync(char *tsync_protos,
+				  unsigned int tsync_protos_size, char *clock,
+				  unsigned int *tsync_port, pthread_t *thr_id);
+
 int trace_make_vsock(unsigned int port);
 int trace_get_vsock_port(int sd, unsigned int *port);
 int trace_open_vsock(unsigned int cid, unsigned int port);
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index a8ef085..b581696 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -19,6 +19,7 @@
 #include <sys/wait.h>
 #include <unistd.h>
 #include <linux/vm_sockets.h>
+#include <pthread.h>
 
 #include "trace-local.h"
 #include "trace-msg.h"
@@ -125,11 +126,30 @@ cleanup:
 	return ret;
 }
 
+static char *get_clock(int argc, char **argv)
+{
+	int i;
+
+	if (!argc || !argv)
+		return NULL;
+
+	for (i = 0; i < argc - 1; i++) {
+		if (!strcmp("-C", argv[i]))
+			return argv[i+1];
+	}
+	return NULL;
+}
+
 static void agent_handle(int sd, int nr_cpus, int page_size)
 {
 	struct tracecmd_msg_handle *msg_handle;
+	unsigned int tsync_protos_size = 0;
+	unsigned int tsync_proto = 0;
 	unsigned long long trace_id;
+	unsigned int tsync_port = 0;
+	char *tsync_protos = NULL;
 	unsigned int *ports;
+	pthread_t sync_thr;
 	char **argv = NULL;
 	int argc = 0;
 	bool use_fifos;
@@ -146,7 +166,8 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 		die("Failed to allocate message handle");
 
 	ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv,
-					  &use_fifos, &trace_id);
+					  &use_fifos, &trace_id,
+					  &tsync_protos, &tsync_protos_size);
 	if (ret < 0)
 		die("Failed to receive trace request");
 
@@ -155,16 +176,28 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 
 	if (!use_fifos)
 		make_vsocks(nr_cpus, fds, ports);
-
+	if (tsync_protos) {
+		tsync_proto = tracecmd_guest_tsync(tsync_protos,
+						   tsync_protos_size,
+						   get_clock(argc, argv),
+						   &tsync_port, &sync_thr);
+		if (!tsync_proto)
+			warning("Failed to negotiate timestamps synchronization with the host");
+	}
 	trace_id = tracecmd_generate_traceid();
 	ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size,
-					   ports, use_fifos, trace_id);
+					   ports, use_fifos, trace_id,
+					   tsync_proto, tsync_port);
 	if (ret < 0)
 		die("Failed to send trace response");
 
 	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv,
 			   use_fifos, trace_id);
 
+	if (tsync_proto)
+		pthread_join(sync_thr, NULL);
+
+	free(tsync_protos);
 	free(argv[0]);
 	free(argv);
 	free(ports);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bf81a89..f01e62a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -672,6 +672,11 @@ static void tell_guests_to_stop(void)
 			tracecmd_msg_send_close_msg(instance->msg_handle);
 	}
 
+	for_all_instances(instance) {
+		if (is_guest(instance))
+			tracecmd_host_tsync_complete(instance);
+	}
+
 	/* Wait for guests to acknowledge */
 	for_all_instances(instance) {
 		if (is_guest(instance)) {
@@ -3655,6 +3660,10 @@ static void connect_to_agent(struct buffer_instance *instance)
 {
 	struct tracecmd_msg_handle *msg_handle;
 	int sd, ret, nr_fifos, nr_cpus, page_size;
+	unsigned int tsync_protos_reply = 0;
+	unsigned int tsync_port = 0;
+	char *protos = NULL;
+	int protos_count = 0;
 	unsigned int *ports;
 	int i, *fds = NULL;
 	bool use_fifos = false;
@@ -3675,17 +3684,32 @@ static void connect_to_agent(struct buffer_instance *instance)
 	if (!msg_handle)
 		die("Failed to allocate message handle");
 
+	if (instance->tsync.loop_interval >= 0)
+		tracecmd_tsync_proto_getall(&protos, &protos_count);
+
 	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
 					  instance->argv, use_fifos,
-					  top_instance.trace_id);
+					  top_instance.trace_id,
+					  protos, protos_count);
 	if (ret < 0)
 		die("Failed to send trace request");
 
+	free(protos);
+
 	ret = tracecmd_msg_recv_trace_resp(msg_handle, &nr_cpus, &page_size,
 					   &ports, &use_fifos,
-					   &instance->trace_id);
+					   &instance->trace_id,
+					   &tsync_protos_reply, &tsync_port);
 	if (ret < 0)
-		die("Failed to receive trace response");
+		die("Failed to receive trace response %d", ret);
+
+	if (protos_count && tsync_protos_reply) {
+		if (tsync_proto_is_supported(tsync_protos_reply)) {
+			instance->tsync.sync_proto = tsync_protos_reply;
+			tracecmd_host_tsync(instance, tsync_port);
+		} else
+			warning("Failed to negotiate timestamps synchronization with the guest");
+	}
 
 	if (use_fifos) {
 		if (nr_cpus != nr_fifos) {
@@ -3733,7 +3757,8 @@ static void setup_guest(struct buffer_instance *instance)
 	close(fd);
 }
 
-static void setup_agent(struct buffer_instance *instance, struct common_record_context *ctx)
+static void setup_agent(struct buffer_instance *instance,
+			struct common_record_context *ctx)
 {
 	struct tracecmd_output *network_handle;
 
@@ -5258,6 +5283,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_tsyncinterval	= 242,
 	OPT_user		= 243,
 	OPT_procmap		= 244,
 	OPT_quiet		= 245,
@@ -5560,6 +5586,7 @@ static void parse_record_options(int argc,
 			{"proc-map", no_argument, NULL, OPT_procmap},
 			{"user", required_argument, NULL, OPT_user},
 			{"module", required_argument, NULL, OPT_module},
+			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -5902,6 +5929,10 @@ static void parse_record_options(int argc,
 			ctx->instance->filter_mod = optarg;
 			ctx->filtered = 0;
 			break;
+		case OPT_tsyncinterval:
+			top_instance.tsync.loop_interval = atoi(optarg);
+			guest_sync_set = true;
+			break;
 		case OPT_quiet:
 		case 'q':
 			quiet = true;
@@ -5932,6 +5963,7 @@ static void parse_record_options(int argc,
 					add_argv(instance, "-C", true);
 				}
 			}
+			instance->tsync.loop_interval = top_instance.tsync.loop_interval;
 		}
 	}
 
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
new file mode 100644
index 0000000..bf65e44
--- /dev/null
+++ b/tracecmd/trace-tsync.c
@@ -0,0 +1,272 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <sys/socket.h>
+#include <unistd.h>
+#include <linux/vm_sockets.h>
+#include <pthread.h>
+
+#include "tracefs.h"
+#include "trace-local.h"
+#include "trace-msg.h"
+
+static int get_first_cpu(cpu_set_t **pin_mask, size_t *m_size)
+{
+	int cpus = tracecmd_count_cpus();
+	cpu_set_t *cpu_mask;
+	int mask_size;
+	int i;
+
+	cpu_mask = CPU_ALLOC(cpus);
+	*pin_mask = CPU_ALLOC(cpus);
+	if (!cpu_mask || !*pin_mask || 1)
+		goto error;
+
+	mask_size = CPU_ALLOC_SIZE(cpus);
+	CPU_ZERO_S(mask_size, cpu_mask);
+	CPU_ZERO_S(mask_size, *pin_mask);
+
+	if (sched_getaffinity(0, mask_size, cpu_mask) == -1)
+		goto error;
+
+	for (i = 0; i < cpus; i++) {
+		if (CPU_ISSET_S(i, mask_size, cpu_mask)) {
+			CPU_SET_S(i, mask_size, *pin_mask);
+			break;
+		}
+	}
+
+	if (CPU_COUNT_S(mask_size, *pin_mask) < 1)
+		goto error;
+
+	CPU_FREE(cpu_mask);
+	*m_size = mask_size;
+	return 0;
+
+error:
+	if (cpu_mask)
+		CPU_FREE(cpu_mask);
+	if (*pin_mask)
+		CPU_FREE(*pin_mask);
+	*pin_mask = NULL;
+	*m_size = 0;
+	return -1;
+}
+
+static void *tsync_host_thread(void *data)
+{
+	struct tracecmd_time_sync *tsync = NULL;
+
+	tsync = (struct tracecmd_time_sync *)data;
+
+	tracecmd_tsync_with_guest(tsync);
+
+	tracecmd_msg_handle_close(tsync->msg_handle);
+	tsync->msg_handle = NULL;
+
+	pthread_exit(0);
+}
+
+int tracecmd_host_tsync(struct buffer_instance *instance,
+			 unsigned int tsync_port)
+{
+	struct tracecmd_msg_handle *msg_handle = NULL;
+	cpu_set_t *pin_mask = NULL;
+	pthread_attr_t attrib;
+	size_t mask_size = 0;
+	int ret;
+	int fd;
+
+	if (!instance->tsync.sync_proto)
+		return -1;
+
+	fd = trace_open_vsock(instance->cid, tsync_port);
+	if (fd < 0) {
+		ret = -1;
+		goto out;
+	}
+	msg_handle = tracecmd_msg_handle_alloc(fd, 0);
+	if (!msg_handle) {
+		ret = -1;
+		goto out;
+	}
+
+	instance->tsync.msg_handle = msg_handle;
+	if (top_instance.clock)
+		instance->tsync.clock_str = strdup(top_instance.clock);
+	pthread_mutex_init(&instance->tsync.lock, NULL);
+	pthread_cond_init(&instance->tsync.cond, NULL);
+
+	pthread_attr_init(&attrib);
+	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
+	if (!get_first_cpu(&pin_mask, &mask_size))
+		pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
+
+	ret = pthread_create(&instance->tsync_thread, &attrib,
+			     tsync_host_thread, &instance->tsync);
+	if (!ret)
+		instance->tsync_thread_running = true;
+	if (pin_mask)
+		CPU_FREE(pin_mask);
+	pthread_attr_destroy(&attrib);
+
+out:
+	if (ret) {
+		if (msg_handle)
+			tracecmd_msg_handle_close(msg_handle);
+	}
+
+	return ret;
+}
+
+static void write_guest_time_shift(struct buffer_instance *instance)
+{
+	struct tracecmd_output *handle;
+	struct iovec vector[4];
+	long long *offsets;
+	long long *ts;
+	char *file;
+	int count;
+	int ret;
+	int fd;
+
+	ret = tracecmd_tsync_get_offsets(&instance->tsync, &count, &ts, &offsets);
+	if (ret < 0 || !count || !ts || !offsets)
+		return;
+
+	file = trace_get_guest_file(DEFAUT_INPUT_FILE,
+				tracefs_instance_get_name(instance->tracefs));
+	fd = open(file, O_RDWR);
+	if (fd < 0)
+		die("error opening %s", file);
+	free(file);
+	handle = tracecmd_get_output_handle_fd(fd);
+	vector[0].iov_len = 8;
+	vector[0].iov_base = &top_instance.trace_id;
+	vector[1].iov_len = 4;
+	vector[1].iov_base = &count;
+	vector[2].iov_len = 8 * count;
+	vector[2].iov_base = ts;
+	vector[3].iov_len = 8 * count;
+	vector[3].iov_base = offsets;
+	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 4);
+	tracecmd_append_options(handle);
+	tracecmd_output_close(handle);
+#ifdef TSYNC_DEBUG
+	if (count > 1)
+		printf("Got %d timestamp synch samples for guest %s in %lld ns trace\n\r",
+			count, tracefs_instance_get_name(instance->tracefs),
+			ts[count - 1] - ts[0]);
+#endif
+}
+
+void tracecmd_host_tsync_complete(struct buffer_instance *instance)
+{
+	if (!instance->tsync_thread_running)
+		return;
+
+	/* Signal the time synchronization thread to complete and wait for it */
+	pthread_mutex_lock(&instance->tsync.lock);
+	pthread_cond_signal(&instance->tsync.cond);
+	pthread_mutex_unlock(&instance->tsync.lock);
+	pthread_join(instance->tsync_thread, NULL);
+	write_guest_time_shift(instance);
+	tracecmd_tsync_free(&instance->tsync);
+}
+
+static void *tsync_agent_thread(void *data)
+{
+	struct tracecmd_time_sync *tsync = NULL;
+	int sd;
+
+	tsync = (struct tracecmd_time_sync *)data;
+
+	while (true) {
+		sd = accept(tsync->msg_handle->fd, NULL, NULL);
+		if (sd < 0) {
+			if (errno == EINTR)
+				continue;
+			goto out;
+		}
+		break;
+	}
+	close(tsync->msg_handle->fd);
+	tsync->msg_handle->fd = sd;
+
+	tracecmd_tsync_with_host(tsync);
+
+out:
+	tracecmd_msg_handle_close(tsync->msg_handle);
+	tracecmd_tsync_free(tsync);
+	free(tsync);
+	close(sd);
+
+	pthread_exit(0);
+}
+
+unsigned int tracecmd_guest_tsync(char *tsync_protos,
+				  unsigned int tsync_protos_size, char *clock,
+				  unsigned int *tsync_port, pthread_t *thr_id)
+{
+	struct tracecmd_time_sync *tsync = NULL;
+	cpu_set_t *pin_mask = NULL;
+	pthread_attr_t attrib;
+	size_t mask_size = 0;
+	unsigned int proto;
+	int ret;
+	int fd;
+
+	fd = -1;
+	proto = tracecmd_tsync_proto_select(tsync_protos, tsync_protos_size);
+	if (!proto)
+		return 0;
+#ifdef VSOCK
+	fd = trace_make_vsock(VMADDR_PORT_ANY);
+	if (fd < 0)
+		goto error;
+
+	ret = trace_get_vsock_port(fd, tsync_port);
+	if (ret < 0)
+		goto error;
+#else
+	return 0;
+#endif
+
+	tsync = calloc(1, sizeof(struct tracecmd_time_sync));
+	tsync->msg_handle = tracecmd_msg_handle_alloc(fd, 0);
+	if (clock)
+		tsync->clock_str = strdup(clock);
+
+	pthread_attr_init(&attrib);
+	tsync->sync_proto = proto;
+	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
+	if (!get_first_cpu(&pin_mask, &mask_size))
+		pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
+
+	ret = pthread_create(thr_id, &attrib, tsync_agent_thread, tsync);
+
+	if (pin_mask)
+		CPU_FREE(pin_mask);
+	pthread_attr_destroy(&attrib);
+
+	if (ret)
+		goto error;
+
+	return proto;
+
+error:
+	if (tsync) {
+		if (tsync->msg_handle)
+			tracecmd_msg_handle_close(tsync->msg_handle);
+		free(tsync->clock_str);
+		free(tsync);
+	}
+	if (fd > 0)
+		close(fd);
+	return 0;
+}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 502a410..d43ca49 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -60,6 +60,10 @@ static struct usage_help usage_help[] = {
 		"          --no-filter include trace-cmd threads in the trace\n"
 		"          --proc-map save the traced processes address map into the trace.dat file\n"
 		"          --user execute the specified [command ...] as given user\n"
+		"          --tsync-interval set the loop interval, in ms, for timestamps synchronization with guests:"
+		"               If a negative number is specified, timestamps synchronization is disabled"
+		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
+		"                                                         at the beginnig and at the end of the trace\n"
 	},
 	{
 		"start",
-- 
2.24.1

