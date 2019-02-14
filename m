Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14007C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF44A2080A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbfBNOOI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:14:08 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40043 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404718AbfBNOOI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 09:14:08 -0500
Received: by mail-wm1-f65.google.com with SMTP id q21so6237219wmc.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Feb 2019 06:14:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g2rh+FVIWHH+god+uNx3wHjZh1YWG8SycP4X5s8WVYg=;
        b=g8MwqR/eNV3kHuExgdVU33LLVvlvFgsWWpVSnA+rZp9rDTCdBG4zPfhX6Ga+DFWBiL
         q/ZzilREoISuJYwytNK32c2Hl0s2FOkNMSt44Pj/t64uBELeV8bfGTblVr5CvKfqY/ys
         CAP4KRB7lBuUyGe++swUoJD6JnnPaO1MQoZMUv3CTtEaz2kSQQ6ziZzTJoRyKtlFgh7p
         kqNQqakVo7RepBQYLC8+WGBPjc2wMFtvXxXh/yB5fv3DqcthZ3g66O4kllzdDW0iNSyF
         jOD4XXTtLpU463QZJ35cA5lVqvkmF9nfsmiJyNgDNhU0kAW1keezpmPZqK1E4f6j9cdj
         DPcA==
X-Gm-Message-State: AHQUAuarV82ngd4iZwB5Bry0D5HGq8EDtBpqkyc+sHCdsrlazrSXyr8t
        i3BxyHVQlodKUs58WWB0Dg==
X-Google-Smtp-Source: AHgI3Ibx/LSl4WuMI15b7SMcML+RCK+2smStZMeikx0XTf4eJED9Zl0EkXbPldSLGCN/uKZBZ6O4Tg==
X-Received: by 2002:a1c:e1c4:: with SMTP id y187mr3019708wmg.50.1550153645132;
        Thu, 14 Feb 2019 06:14:05 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id m4sm1844840wml.2.2019.02.14.06.14.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 06:14:04 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v6 11/11] trace-cmd: Add VM tracing over FIFOs transport
Date:   Thu, 14 Feb 2019 16:13:35 +0200
Message-Id: <20190214141335.28144-12-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190214141335.28144-1-kaslevs@vmware.com>
References: <20190214141335.28144-1-kaslevs@vmware.com>
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
 include/trace-cmd/trace-cmd.h  |  8 +--
 tracecmd/include/trace-local.h |  4 +-
 tracecmd/trace-agent.c         | 40 +++++++++++++--
 tracecmd/trace-msg.c           | 26 ++++++----
 tracecmd/trace-record.c        | 93 +++++++++++++++++++++++++++++-----
 5 files changed, 140 insertions(+), 31 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 52962e9..27ba89d 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -333,16 +333,16 @@ bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
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
 
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
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
index 0c0873b..7389f72 100644
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
+			ret = -errno;
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
index 8b0a4e5..c5e047e 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -159,6 +159,10 @@ static int msg_write(int fd, struct tracecmd_msg *msg)
 	return __do_write_check(fd, msg->buf, data_size);
 }
 
+enum msg_trace_flags {
+	MSG_TRACE_USE_FIFOS = 1 << 0,
+};
+
 enum msg_opt_command {
 	MSGOPT_USETCP = 1,
 };
@@ -740,7 +744,7 @@ error:
 	return ret;
 }
 
-static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv)
+static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv, bool use_fifos)
 {
 	size_t args_size = 0;
 	char *p;
@@ -750,6 +754,7 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv)
 		args_size += strlen(argv[i]) + 1;
 
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + args_size);
+	msg->trace_req.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
 	msg->trace_req.argc = htonl(argc);
 	msg->buf = calloc(args_size, 1);
 	if (!msg->buf)
@@ -763,13 +768,13 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv)
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
 
@@ -782,7 +787,7 @@ int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
   *     free(argv);
   */
 int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int *argc, char ***argv)
+				int *argc, char ***argv, bool *use_fifos)
 {
 	struct tracecmd_msg msg;
 	char *p, *buf_end, **args;
@@ -838,6 +843,7 @@ int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 	 */
 	*argc = nr_args;
 	*argv = args;
+	*use_fifos = ntohl(msg.trace_req.flags) & MSG_TRACE_USE_FIFOS;
 	return 0;
 
 out_args:
@@ -850,13 +856,14 @@ out:
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
 
@@ -872,13 +879,13 @@ static int make_trace_resp(struct tracecmd_msg *msg,
 
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
 
@@ -887,7 +894,7 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
-				 unsigned int **ports)
+				 unsigned int **ports, bool *use_fifos)
 {
 	struct tracecmd_msg msg;
 	ssize_t buf_len;
@@ -909,6 +916,7 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 		goto out;
 	}
 
+	*use_fifos = ntohl(msg.trace_resp.flags) & MSG_TRACE_USE_FIFOS;
 	*nr_cpus = ntohl(msg.trace_resp.cpus);
 	*page_size = ntohl(msg.trace_resp.page_size);
 	*ports = calloc(*nr_cpus, sizeof(**ports));
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e48b270..4b88ab1 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -76,6 +76,8 @@ static int buffers;
 /* Clear all function filters */
 static int clear_function_filters;
 
+static bool no_fifos;
+
 static char *host;
 
 /* Max size to let a per cpu file get */
@@ -2918,17 +2920,22 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
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
+		if (instance->use_fifos)
+			flags |= TRACECMD_RECORD_NOBRASS;
+		else if (!can_splice_read_vsock())
 			flags |= TRACECMD_RECORD_NOSPLICE;
-		return tracecmd_create_recorder_virt(file, cpu, flags, sd);
+		return tracecmd_create_recorder_virt(file, cpu, flags, fd);
 	}
 
 	if (brass)
@@ -2980,10 +2987,14 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
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
@@ -3264,11 +3275,42 @@ static void finish_network(struct tracecmd_msg_handle *msg_handle)
 	free(host);
 }
 
+static int open_guest_fifos(const char *guest, int **fds)
+{
+	char path[PATH_MAX];
+	int i, fd, flags;
+
+	for (i = 0; ; i++) {
+		snprintf(path, sizeof(path), GUEST_FIFO_FMT ".out", guest, i);
+
+		/* O_NONBLOCK so we don't wait for writers */
+		fd = open(path, O_RDONLY | O_NONBLOCK);
+		if (fd < 0)
+			break;
+
+		/* Success, now clear O_NONBLOCK */
+		flags = fcntl(fd, F_GETFL);
+		fcntl(fd, F_SETFL, flags & ~O_NONBLOCK);
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
@@ -3279,15 +3321,33 @@ static void connect_to_agent(struct buffer_instance *instance)
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
+			warning("number of FIFOs (%d) for guest %s differs "
+				"from number of virtual CPUs (%d)",
+				nr_fifos, instance->name, nr_cpus);
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
@@ -4786,6 +4846,7 @@ enum {
 	OPT_funcstack		= 254,
 	OPT_date		= 255,
 	OPT_module		= 256,
+	OPT_nofifos		= 257,
 };
 
 void trace_stop(int argc, char **argv)
@@ -5047,6 +5108,7 @@ static void parse_record_options(int argc,
 			{"date", no_argument, NULL, OPT_date},
 			{"func-stack", no_argument, NULL, OPT_funcstack},
 			{"nosplice", no_argument, NULL, OPT_nosplice},
+			{"nofifos", no_argument, NULL, OPT_nofifos},
 			{"profile", no_argument, NULL, OPT_profile},
 			{"stderr", no_argument, NULL, OPT_stderr},
 			{"by-comm", no_argument, NULL, OPT_bycomm},
@@ -5332,6 +5394,9 @@ static void parse_record_options(int argc,
 		case OPT_nosplice:
 			recorder_flags |= TRACECMD_RECORD_NOSPLICE;
 			break;
+		case OPT_nofifos:
+			no_fifos = true;
+			break;
 		case OPT_profile:
 			handle_init = trace_init_profile;
 			ctx->instance->flags |= BUFFER_FL_PROFILE;
@@ -5731,7 +5796,8 @@ void trace_record(int argc, char **argv)
 
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
-		       int argc, char **argv)
+		       int argc, char **argv,
+		       bool use_fifos)
 {
 	struct common_record_context ctx;
 	char **argv_plus;
@@ -5757,6 +5823,7 @@ int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		return -EINVAL;
 
 	ctx.instance->fds = fds;
+	ctx.instance->use_fifos = use_fifos;
 	ctx.instance->flags |= BUFFER_FL_AGENT;
 	ctx.instance->msg_handle = msg_handle;
 	msg_handle->version = V3_PROTOCOL;
-- 
2.19.1

