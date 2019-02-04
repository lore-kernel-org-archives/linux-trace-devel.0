Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB257C282C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB6F320811
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfBDG7T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:59:19 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55310 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbfBDG7T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 01:59:19 -0500
Received: by mail-wm1-f67.google.com with SMTP id y139so11840271wmc.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 22:59:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mBlvW4CmqBj+ocrg5C0wUec027NrzRu734wMyiTXNig=;
        b=N9Sw35lU3X9dPqf9VCFsj/tJZMY1YiqMbgwObqAE6hdSaE7prmWnkZJsndmkz1e/I0
         IBUa+ZRKAjQ0sT187yqwQuAJSkFX6eFBXK2J4N0d342/VM5ITNqNbHPPjebKas2YJ7bF
         lA9OeL0IFIGxU2GLnxfxHLChPTt2YlLJ9YMbZBhoIT6f3NGT242E9v13CgVTrdV6/LPH
         49LtGQw5EXw5It5nZTLFCxybZRo4fJWTpLd735mBvLRcTLWKKl045/fFFn1EFbDumiqy
         EqAqAWtygz8BLFXE6HcLmeglJrhHe6TzRDLg4vlqtD5tDiZX4tVohWxBcuom1KR3DCg4
         xWJA==
X-Gm-Message-State: AHQUAuZTMuClyo+PxC+WQz7Hmsdxz72aEfM8SeNR2ccnH7kYA/azJLzH
        0LGqDa7yqWKwRcL+cFit5+m3WYhgDg==
X-Google-Smtp-Source: AHgI3IbModxaIbQPmeL989zKOqnlKlSoaedFT3dv7P4CqHxXK1he4S8+9Bev5Wh102O1G06yT8UBRg==
X-Received: by 2002:a7b:c76b:: with SMTP id x11mr11602771wmk.37.1549263555427;
        Sun, 03 Feb 2019 22:59:15 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id q12sm12596809wrx.31.2019.02.03.22.59.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:59:14 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [RFC PATCH v5 11/11] trace-cmd: Add VM tracing over FIFOs transport
Date:   Mon,  4 Feb 2019 08:58:48 +0200
Message-Id: <20190204065848.8248-12-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204065848.8248-1-kaslevs@vmware.com>
References: <20190204065848.8248-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

FIFOs offer ~3x the throughput of vsockets. This patch adds support for using
FIFOs to stream tracing data back to the host when tracing VMs.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h  |  8 ++--
 tracecmd/include/trace-local.h |  4 +-
 tracecmd/trace-agent.c         | 40 ++++++++++++++--
 tracecmd/trace-msg.c           | 26 +++++++----
 tracecmd/trace-record.c        | 84 ++++++++++++++++++++++++++++------
 5 files changed, 131 insertions(+), 31 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 7664074..84dc95a 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -338,16 +338,16 @@ bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 
 int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int argc, char **argv);
+				int argc, char **argv, bool use_fifos);
 int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int *argc, char ***argv);
+				int *argc, char ***argv, bool *use_fifos);
 
 int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int nr_cpus, int page_size,
-				 unsigned int *ports);
+				 unsigned int *ports, bool use_fifos);
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
-				 unsigned int **ports);
+				 unsigned int **ports, bool *use_fifos);
 
 int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
 
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index b23130e..8bf7c8e 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -17,6 +17,7 @@
 #define GUEST_PIPE_NAME		"trace-pipe-cpu"
 #define GUEST_DIR_FMT		"/var/lib/trace-cmd/virt/%s"
 #define GUEST_FIFO_FMT		GUEST_DIR_FMT "/" GUEST_PIPE_NAME "%d"
+#define VIRTIO_FIFO_FMT		"/dev/virtio-ports/" GUEST_PIPE_NAME "%d"
 
 extern int debug;
 extern int quiet;
@@ -100,7 +101,7 @@ void trace_usage(int argc, char **argv);
 
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
-		       int argc, char **argv);
+		       int argc, char **argv, bool use_fifos);
 
 struct hook_list;
 
@@ -212,6 +213,7 @@ struct buffer_instance {
 	int			cid;
 	int			port;
 	int			*fds;
+	bool			use_fifos;
 };
 
 extern struct buffer_instance top_instance;
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index b4b3bbb..34e6c0c 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -83,12 +83,39 @@ static void make_vsocks(int nr, int *fds, unsigned int *ports)
 	}
 }
 
+static int open_agent_fifos(int nr_cpus, int *fds)
+{
+	char path[PATH_MAX];
+	int i, fd, ret = 0;
+
+	for (i = 0; i < nr_cpus; i++) {
+		snprintf(path, sizeof(path), VIRTIO_FIFO_FMT, i);
+		fd = open(path, O_WRONLY);
+		if (fd < 0) {
+			ret = -1;
+			break;
+		}
+
+		fds[i] = fd;
+	}
+
+	if (!ret)
+		return ret;
+
+	/* We failed to open all FIFOs so clean up and return error */
+	while (--i >= 0)
+		close(fds[i]);
+
+	return ret;
+}
+
 static void agent_handle(int sd, int nr_cpus, int page_size)
 {
 	struct tracecmd_msg_handle *msg_handle;
 	unsigned int *ports;
 	char **argv = NULL;
 	int argc = 0;
+	bool use_fifos;
 	int *fds;
 	int ret;
 
@@ -101,17 +128,22 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 	if (!msg_handle)
 		die("Failed to allocate message handle");
 
-	ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv);
+	ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv, &use_fifos);
 	if (ret < 0)
 		die("Failed to receive trace request");
 
-	make_vsocks(nr_cpus, fds, ports);
+	if (use_fifos && open_agent_fifos(nr_cpus, fds))
+		use_fifos = false;
+
+	if (!use_fifos)
+		make_vsocks(nr_cpus, fds, ports);
 
-	ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size, ports);
+	ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size,
+					   ports, use_fifos);
 	if (ret < 0)
 		die("Failed to send trace response");
 
-	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv);
+	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv, use_fifos);
 
 	free(argv[0]);
 	free(argv);
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 7ffb8a7..c28d294 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -175,6 +175,10 @@ static int msg_write(int fd, struct tracecmd_msg *msg)
 	return __do_write_check(fd, msg->buf, data_size);
 }
 
+enum msg_trace_flags {
+	MSG_TRACE_USE_FIFOS = 1 << 0,
+};
+
 enum msg_opt_command {
 	MSGOPT_USETCP = 1,
 };
@@ -732,7 +736,7 @@ error:
 	return ret;
 }
 
-static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv)
+static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv, bool use_fifos)
 {
 	size_t args_size = 0;
 	char *p;
@@ -742,6 +746,7 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv)
 		args_size += strlen(argv[i]) + 1;
 
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + args_size);
+	msg->trace_req.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
 	msg->trace_req.argc = htonl(argc);
 	msg->buf = calloc(args_size, 1);
 	if (!msg->buf)
@@ -755,13 +760,13 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv)
 }
 
 int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int argc, char **argv)
+				int argc, char **argv, bool use_fifos)
 {
 	struct tracecmd_msg msg;
 	int ret;
 
 	tracecmd_msg_init(MSG_TRACE_REQ, &msg);
-	ret = make_trace_req(&msg, argc, argv);
+	ret = make_trace_req(&msg, argc, argv, use_fifos);
 	if (ret < 0)
 		return ret;
 
@@ -774,7 +779,7 @@ int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
   *     free(argv);
   */
 int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int *argc, char ***argv)
+				int *argc, char ***argv, bool *use_fifos)
 {
 	struct tracecmd_msg msg;
 	char *p, *buf_end, **args;
@@ -819,6 +824,7 @@ int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 	msg.buf = NULL;
 	*argc = nr_args;
 	*argv = args;
+	*use_fifos = ntohl(msg.trace_req.flags) & MSG_TRACE_USE_FIFOS;
 	ret = 0;
 
 out:
@@ -826,13 +832,14 @@ out:
 	return ret;
 }
 
-static int make_trace_resp(struct tracecmd_msg *msg,
-			   int page_size, int nr_cpus, unsigned int *ports)
+static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
+			   unsigned int *ports, bool use_fifos)
 {
 	int ports_size = nr_cpus * sizeof(*msg->port_array);
 	int i;
 
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + ports_size);
+	msg->trace_resp.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
 	msg->trace_resp.cpus = htonl(nr_cpus);
 	msg->trace_resp.page_size = htonl(page_size);
 
@@ -848,13 +855,13 @@ static int make_trace_resp(struct tracecmd_msg *msg,
 
 int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int nr_cpus, int page_size,
-				 unsigned int *ports)
+				 unsigned int *ports, bool use_fifos)
 {
 	struct tracecmd_msg msg;
 	int ret;
 
 	tracecmd_msg_init(MSG_TRACE_RESP, &msg);
-	ret = make_trace_resp(&msg, page_size, nr_cpus, ports);
+	ret = make_trace_resp(&msg, page_size, nr_cpus, ports, use_fifos);
 	if (ret < 0)
 		return ret;
 
@@ -863,7 +870,7 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
-				 unsigned int **ports)
+				 unsigned int **ports, bool *use_fifos)
 {
 	struct tracecmd_msg msg;
 	size_t buf_len;
@@ -885,6 +892,7 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 		goto out;
 	}
 
+	*use_fifos = ntohl(msg.trace_resp.flags) & MSG_TRACE_USE_FIFOS;
 	*nr_cpus = ntohl(msg.trace_resp.cpus);
 	*page_size = ntohl(msg.trace_resp.page_size);
 	*ports = calloc(*nr_cpus, sizeof(**ports));
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 71176d9..43d782e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -76,6 +76,8 @@ static int buffers;
 /* Clear all function filters */
 static int clear_function_filters;
 
+static bool no_fifos;
+
 static char *host;
 
 /* Max size to let a per cpu file get */
@@ -2914,17 +2916,20 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 	char *path;
 
 	if (instance->flags & BUFFER_FL_GUEST) {
-		int sd;
+		int fd;
 		unsigned int flags;
 
-		sd = open_vsock(instance->cid, instance->client_ports[cpu]);
-		if (sd < 0)
+		if (instance->use_fifos)
+			fd = instance->fds[cpu];
+		else
+			fd = open_vsock(instance->cid, instance->client_ports[cpu]);
+		if (fd < 0)
 			die("Failed to connect to agent");
 
 		flags = recorder_flags;
-		if (!can_splice_read_vsock())
+		if (!instance->use_fifos && !can_splice_read_vsock())
 			flags |= TRACECMD_RECORD_NOSPLICE;
-		return tracecmd_create_recorder_virt(file, cpu, flags, sd);
+		return tracecmd_create_recorder_virt(file, cpu, flags, fd);
 	}
 
 	if (brass)
@@ -2976,10 +2981,14 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		char *path = NULL;
 		int fd;
 
-		if (instance->flags & BUFFER_FL_AGENT)
-			fd = do_accept(instance->fds[cpu]);
-		else
+		if (instance->flags & BUFFER_FL_AGENT) {
+			if (instance->use_fifos)
+				fd = instance->fds[cpu];
+			else
+				fd = do_accept(instance->fds[cpu]);
+		} else {
 			fd = connect_port(host, instance->client_ports[cpu]);
+		}
 		if (fd < 0)
 			die("Failed connecting to client");
 		if (instance->name && !(instance->flags & BUFFER_FL_AGENT))
@@ -3260,11 +3269,36 @@ static void finish_network(struct tracecmd_msg_handle *msg_handle)
 	free(host);
 }
 
+static int open_guest_fifos(const char *guest, int **fds)
+{
+	char path[PATH_MAX];
+	int i, fd;
+
+	for (i = 0; ; i++) {
+		snprintf(path, sizeof(path), GUEST_FIFO_FMT ".out", guest, i);
+		fd = open(path, O_RDONLY);
+		if (fd < 0)
+			break;
+
+		*fds = realloc(*fds, i + 1);
+		(*fds)[i] = fd;
+	}
+
+	return i;
+}
+
 static void connect_to_agent(struct buffer_instance *instance)
 {
 	struct tracecmd_msg_handle *msg_handle;
-	int sd, ret, nr_cpus, page_size;
+	int sd, ret, nr_fifos, nr_cpus, page_size;
 	unsigned int *ports;
+	int i, *fds = NULL;
+	bool use_fifos = false;
+
+	if (!no_fifos) {
+		nr_fifos = open_guest_fifos(instance->name, &fds);
+		use_fifos = nr_fifos > 0;
+	}
 
 	sd = open_vsock(instance->cid, instance->port);
 	if (sd < 0)
@@ -3275,15 +3309,32 @@ static void connect_to_agent(struct buffer_instance *instance)
 	if (!msg_handle)
 		die("Failed to allocate message handle");
 
-	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc, instance->argv);
+	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
+					  instance->argv, use_fifos);
 	if (ret < 0)
 		die("Failed to send trace request");
 
-	ret = tracecmd_msg_recv_trace_resp(msg_handle, &nr_cpus, &page_size, &ports);
+	ret = tracecmd_msg_recv_trace_resp(msg_handle, &nr_cpus, &page_size,
+					   &ports, &use_fifos);
 	if (ret < 0)
 		die("Failed to receive trace response");
 
-	instance->client_ports = ports;
+	if (use_fifos) {
+		if (nr_cpus != nr_fifos) {
+			warning("number of FIFOs for guest %s differs "
+				"from number of cpus", instance->name);
+			nr_cpus = nr_cpus < nr_fifos ? nr_cpus : nr_fifos;
+		}
+		free(ports);
+		instance->fds = fds;
+	} else {
+		for (i = 0; i < nr_fifos; i++)
+			close(fds[i]);
+		free(fds);
+		instance->client_ports = ports;
+	}
+
+	instance->use_fifos = use_fifos;
 	instance->cpu_count = nr_cpus;
 
 	/* the msg_handle now points to the guest fd */
@@ -4782,6 +4833,7 @@ enum {
 	OPT_funcstack		= 254,
 	OPT_date		= 255,
 	OPT_module		= 256,
+	OPT_nofifos		= 257,
 };
 
 void trace_stop(int argc, char **argv)
@@ -5043,6 +5095,7 @@ static void parse_record_options(int argc,
 			{"date", no_argument, NULL, OPT_date},
 			{"func-stack", no_argument, NULL, OPT_funcstack},
 			{"nosplice", no_argument, NULL, OPT_nosplice},
+			{"nofifos", no_argument, NULL, OPT_nofifos},
 			{"profile", no_argument, NULL, OPT_profile},
 			{"stderr", no_argument, NULL, OPT_stderr},
 			{"by-comm", no_argument, NULL, OPT_bycomm},
@@ -5328,6 +5381,9 @@ static void parse_record_options(int argc,
 		case OPT_nosplice:
 			recorder_flags |= TRACECMD_RECORD_NOSPLICE;
 			break;
+		case OPT_nofifos:
+			no_fifos = true;
+			break;
 		case OPT_profile:
 			handle_init = trace_init_profile;
 			ctx->instance->flags |= BUFFER_FL_PROFILE;
@@ -5724,7 +5780,8 @@ void trace_record(int argc, char **argv)
 
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
-		       int argc, char **argv)
+		       int argc, char **argv,
+		       bool use_fifos)
 {
 	struct common_record_context ctx;
 	char **argv_plus;
@@ -5750,6 +5807,7 @@ int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		return -EINVAL;
 
 	ctx.instance->fds = fds;
+	ctx.instance->use_fifos = use_fifos;
 	ctx.instance->flags |= BUFFER_FL_AGENT;
 	ctx.instance->msg_handle = msg_handle;
 	msg_handle->version = V3_PROTOCOL;
-- 
2.19.1

