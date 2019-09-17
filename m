Return-Path: <SRS0=9KLN=XM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3449C4CECE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DE15214AF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbfIQNQE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 09:16:04 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:41983 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727736AbfIQNQE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 09:16:04 -0400
Received: by mail-wr1-f44.google.com with SMTP id h7so3103180wrw.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Sep 2019 06:15:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wZt3rg1ryVvdd6RIwNGxU2A1nzgEYOviPnqn5cNFjcs=;
        b=Or271F8kLqjUDnuOgoXeo3TpaM9X61s2QYcSCKlraUHOwu66fmbLEsT1na4ew5U7EP
         ySyMP8ypdnb4TA11yYETozrpoEeZ6Itx/IxiXoQSWFmkf9t8Mu+q6d9lV/WG4reQBTXr
         XrfDBO5MgVxpHv1sdPnajD1vh121ZO5xOCP5G9VAfpKokWL2ZaGK8Hc0awvvHvWXeR6c
         2YDol7/9y/B72Rss5J0ZNwfgElIFg2eotjV1vlbjjktS2W+cxMutRXkYJPLJp4xELWaZ
         ll0oN6S2Sy75Kmp4CtRJkU4eaUpQbFy5p3JWI8QdtOj8Mo3mKoXdHLT1kJf/C8tY8G6j
         /RbQ==
X-Gm-Message-State: APjAAAX/DYEpO3GFEdg7hzpS5jb8G53FN/qec72uzOTR17e/pnEQDNLL
        X8V/ETZ6C4qq/RE3q7GIWmk2sYe0kw==
X-Google-Smtp-Source: APXvYqwOnLWe9d4Nv1CG/K9Wp2v5dzvZw4sa8gEb35BINMN05t8F+A2jWmu1mjBcgq7caw6Oy+3jqQ==
X-Received: by 2002:a5d:540c:: with SMTP id g12mr3095852wrv.207.1568726158900;
        Tue, 17 Sep 2019 06:15:58 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d22sm1667265wmb.44.2019.09.17.06.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 06:15:58 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 12/13] trace-cmd: Add VM kernel tracing over FIFO transport
Date:   Tue, 17 Sep 2019 16:15:37 +0300
Message-Id: <20190917131538.31926-13-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190917131538.31926-1-kaslevs@vmware.com>
References: <20190917131538.31926-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add FIFO transport for trace-cmd VM kernel tracing if guest FIFOs are available
and attached to guest.

We can also do a direct splice from the transport FIFO to the output file
descriptor instead of two through an additional pipe buffer. This patch
implements specialized version for tracecmd_recorder data transfer for this
case.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h  | 11 +++--
 lib/trace-cmd/trace-msg.c      | 26 ++++++----
 lib/trace-cmd/trace-recorder.c | 73 ++++++++++++++++++++++++----
 tracecmd/include/trace-local.h |  4 +-
 tracecmd/trace-agent.c         | 39 +++++++++++++--
 tracecmd/trace-record.c        | 87 ++++++++++++++++++++++++++++++----
 6 files changed, 201 insertions(+), 39 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index bf8e8f4..265d328 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -275,8 +275,9 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
 
 enum {
 	TRACECMD_RECORD_NOSPLICE	= (1 << 0),	/* Use read instead of splice */
-	TRACECMD_RECORD_SNAPSHOT	= (1 << 1),	/* extract from snapshot */
+	TRACECMD_RECORD_SNAPSHOT	= (1 << 1),	/* Extract from snapshot */
 	TRACECMD_RECORD_BLOCK		= (1 << 2),	/* Block on splice write */
+	TRACECMD_RECORD_NOBRASS		= (1 << 3),	/* Splice directly without a brass pipe */
 };
 
 void tracecmd_free_recorder(struct tracecmd_recorder *recorder);
@@ -332,16 +333,16 @@ bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
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
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 67f955f..22abb11 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -156,6 +156,10 @@ static int msg_write(int fd, struct tracecmd_msg *msg)
 	return __do_write_check(fd, msg->buf, data_size);
 }
 
+enum msg_trace_flags {
+	MSG_TRACE_USE_FIFOS = 1 << 0,
+};
+
 static int make_tinit(struct tracecmd_msg_handle *msg_handle,
 		      struct tracecmd_msg *msg)
 {
@@ -807,7 +811,7 @@ int tracecmd_msg_wait_close_resp(struct tracecmd_msg_handle *msg_handle)
 	return tracecmd_msg_wait_for_cmd(msg_handle, MSG_CLOSE_RESP);
 }
 
-static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv)
+static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv, bool use_fifos)
 {
 	size_t args_size = 0;
 	char *p;
@@ -817,6 +821,7 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv)
 		args_size += strlen(argv[i]) + 1;
 
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + args_size);
+	msg->trace_req.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
 	msg->trace_req.argc = htonl(argc);
 	msg->buf = calloc(args_size, 1);
 	if (!msg->buf)
@@ -830,13 +835,13 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv)
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
 
@@ -849,7 +854,7 @@ int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
   *     free(argv);
   */
 int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int *argc, char ***argv)
+				int *argc, char ***argv, bool *use_fifos)
 {
 	struct tracecmd_msg msg;
 	char *p, *buf_end, **args;
@@ -895,6 +900,7 @@ int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 
 	*argc = nr_args;
 	*argv = args;
+	*use_fifos = ntohl(msg.trace_req.flags) & MSG_TRACE_USE_FIFOS;
 
 	/*
 	 * On success we're passing msg.buf to the caller through argv[0] so we
@@ -914,8 +920,8 @@ out:
 	return ret;
 }
 
-static int make_trace_resp(struct tracecmd_msg *msg,
-			   int page_size, int nr_cpus, unsigned int *ports)
+static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
+			   unsigned int *ports, bool use_fifos)
 {
 	int data_size;
 
@@ -926,6 +932,7 @@ static int make_trace_resp(struct tracecmd_msg *msg,
 	write_uints(msg->buf, data_size, ports, nr_cpus);
 
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + data_size);
+	msg->trace_resp.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
 	msg->trace_resp.cpus = htonl(nr_cpus);
 	msg->trace_resp.page_size = htonl(page_size);
 
@@ -934,13 +941,13 @@ static int make_trace_resp(struct tracecmd_msg *msg,
 
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
 
@@ -949,7 +956,7 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
-				 unsigned int **ports)
+				 unsigned int **ports, bool *use_fifos)
 {
 	struct tracecmd_msg msg;
 	char *p, *buf_end;
@@ -971,6 +978,7 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 		goto out;
 	}
 
+	*use_fifos = ntohl(msg.trace_resp.flags) & MSG_TRACE_USE_FIFOS;
 	*nr_cpus = ntohl(msg.trace_resp.cpus);
 	*page_size = ntohl(msg.trace_resp.page_size);
 	*ports = calloc(*nr_cpus, sizeof(**ports));
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index d57a5d6..bbba14c 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -8,6 +8,7 @@
 #include <stdlib.h>
 #include <fcntl.h>
 #include <time.h>
+#include <poll.h>
 #include <unistd.h>
 #include <errno.h>
 
@@ -26,6 +27,8 @@
 # define SPLICE_F_GIFT		8
 #endif
 
+#define POLL_TIMEOUT_MS		1000
+
 struct tracecmd_recorder {
 	int		fd;
 	int		fd1;
@@ -40,6 +43,7 @@ struct tracecmd_recorder {
 	int		pages;
 	int		count;
 	unsigned	fd_flags;
+	unsigned	trace_fd_flags;
 	unsigned	flags;
 };
 
@@ -127,6 +131,8 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	if (!(recorder->flags & TRACECMD_RECORD_BLOCK))
 		recorder->fd_flags |= SPLICE_F_NONBLOCK;
 
+	recorder->trace_fd_flags = SPLICE_F_MOVE;
+
 	/* Init to know what to free and release */
 	recorder->trace_fd = -1;
 	recorder->brass[0] = -1;
@@ -171,7 +177,8 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 			goto out_free;
 	}
 
-	if ((recorder->flags & TRACECMD_RECORD_NOSPLICE) == 0) {
+	if (!(recorder->flags & (TRACECMD_RECORD_NOSPLICE |
+				 TRACECMD_RECORD_NOBRASS))) {
 		ret = pipe(recorder->brass);
 		if (ret < 0)
 			goto out_free;
@@ -380,7 +387,7 @@ static long splice_data(struct tracecmd_recorder *recorder)
 	long ret;
 
 	read = splice(recorder->trace_fd, NULL, recorder->brass[1], NULL,
-		      recorder->pipe_size, SPLICE_F_MOVE);
+		      recorder->pipe_size, recorder->trace_fd_flags);
 	if (read < 0) {
 		if (errno == EAGAIN || errno == EINTR || errno == ENOTCONN)
 			return 0;
@@ -409,6 +416,47 @@ static long splice_data(struct tracecmd_recorder *recorder)
 	return total_read;
 }
 
+/*
+ * Returns -1 on error.
+ *          or bytes of data read.
+ */
+static long direct_splice_data(struct tracecmd_recorder *recorder)
+{
+	struct pollfd pfd = {
+		.fd = recorder->trace_fd,
+		.events = POLLIN,
+	};
+	long read;
+	int ret;
+
+	/*
+	 * splice(2) in Linux used to not check O_NONBLOCK flag of pipe file
+	 * descriptors before [1]. To avoid getting blocked in the splice(2)
+	 * call below after the user had requested to stop tracing, we poll(2)
+	 * here. This poll() is not necessary on newer kernels.
+	 *
+	 * [1] https://github.com/torvalds/linux/commit/ee5e001196d1345b8fee25925ff5f1d67936081e
+	 */
+	ret = poll(&pfd, 1, POLL_TIMEOUT_MS);
+	if (ret < 0)
+		return -1;
+
+	if (!(pfd.revents | POLLIN))
+		return 0;
+
+	read = splice(recorder->trace_fd, NULL, recorder->fd, NULL,
+		      recorder->pipe_size, recorder->fd_flags);
+	if (read < 0) {
+		if (errno == EAGAIN || errno == EINTR || errno == ENOTCONN)
+			return 0;
+
+		warning("recorder error in splice input");
+		return -1;
+	}
+
+	return read;
+}
+
 /*
  * Returns -1 on error.
  *          or bytes of data read.
@@ -443,6 +491,17 @@ static long read_data(struct tracecmd_recorder *recorder)
 	return r;
 }
 
+static long move_data(struct tracecmd_recorder *recorder)
+{
+	if (recorder->flags & TRACECMD_RECORD_NOSPLICE)
+		return read_data(recorder);
+
+	if (recorder->flags & TRACECMD_RECORD_NOBRASS)
+		return direct_splice_data(recorder);
+
+	return splice_data(recorder);
+}
+
 static void set_nonblock(struct tracecmd_recorder *recorder)
 {
 	long flags;
@@ -465,10 +524,7 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder)
 	set_nonblock(recorder);
 
 	do {
-		if (recorder->flags & TRACECMD_RECORD_NOSPLICE)
-			ret = read_data(recorder);
-		else
-			ret = splice_data(recorder);
+		ret = move_data(recorder);
 		if (ret < 0)
 			return ret;
 		total += ret;
@@ -513,10 +569,7 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
 
 		read = 0;
 		do {
-			if (recorder->flags & TRACECMD_RECORD_NOSPLICE)
-				ret = read_data(recorder);
-			else
-				ret = splice_data(recorder);
+			ret = move_data(recorder);
 			if (ret < 0)
 				return ret;
 			read += ret;
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 4df8686..50e1a92 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -17,6 +17,7 @@
 #define GUEST_PIPE_NAME		"trace-pipe-cpu"
 #define GUEST_DIR_FMT		"/var/lib/trace-cmd/virt/%s"
 #define GUEST_FIFO_FMT		GUEST_DIR_FMT "/" GUEST_PIPE_NAME "%d"
+#define VIRTIO_FIFO_FMT		"/dev/virtio-ports/" GUEST_PIPE_NAME "%d"
 
 extern int quiet;
 
@@ -99,7 +100,7 @@ void trace_usage(int argc, char **argv);
 
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
-		       int argc, char **argv);
+		       int argc, char **argv, bool use_fifos);
 
 struct hook_list;
 
@@ -213,6 +214,7 @@ struct buffer_instance {
 	unsigned int		cid;
 	unsigned int		port;
 	int			*fds;
+	bool			use_fifos;
 };
 
 extern struct buffer_instance top_instance;
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 89e3568..93e3edf 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -100,12 +100,38 @@ static void make_vsocks(int nr, int *fds, unsigned int *ports)
 	}
 }
 
+static int open_agent_fifos(int nr_cpus, int *fds)
+{
+	char path[PATH_MAX];
+	int i, fd, ret;
+
+	for (i = 0; i < nr_cpus; i++) {
+		snprintf(path, sizeof(path), VIRTIO_FIFO_FMT, i);
+		fd = open(path, O_WRONLY);
+		if (fd < 0) {
+			ret = -errno;
+			goto cleanup;
+		}
+
+		fds[i] = fd;
+	}
+
+	return 0;
+
+cleanup:
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
 
@@ -118,17 +144,22 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
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
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4880f50..3aab6cb 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -77,6 +77,8 @@ static int buffers;
 /* Clear all function filters */
 static int clear_function_filters;
 
+static bool no_fifos;
+
 static char *host;
 
 /* Max size to let a per cpu file get */
@@ -2972,12 +2974,17 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 		int fd;
 		unsigned int flags;
 
-		fd = open_vsock(instance->cid, instance->client_ports[cpu]);
+		if (instance->use_fifos)
+			fd = instance->fds[cpu];
+		else
+			fd = open_vsock(instance->cid, instance->client_ports[cpu]);
 		if (fd < 0)
 			die("Failed to connect to agent");
 
 		flags = recorder_flags;
-		if (!can_splice_read_vsock())
+		if (instance->use_fifos)
+			flags |= TRACECMD_RECORD_NOBRASS;
+		else if (!can_splice_read_vsock())
 			flags |= TRACECMD_RECORD_NOSPLICE;
 		return tracecmd_create_recorder_virt(file, cpu, flags, fd);
 	}
@@ -3032,10 +3039,14 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		char *path = NULL;
 		int fd;
 
-		if (is_agent(instance))
-			fd = do_accept(instance->fds[cpu]);
-		else
+		if (is_agent(instance)) {
+			if (instance->use_fifos)
+				fd = instance->fds[cpu];
+			else
+				fd = do_accept(instance->fds[cpu]);
+		} else {
 			fd = connect_port(host, instance->client_ports[cpu]);
+		}
 		if (fd < 0)
 			die("Failed connecting to client");
 		if (instance->name && !is_agent(instance))
@@ -3316,11 +3327,42 @@ static void finish_network(struct tracecmd_msg_handle *msg_handle)
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
@@ -3331,15 +3373,33 @@ static void connect_to_agent(struct buffer_instance *instance)
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
@@ -4868,6 +4928,7 @@ enum {
 	OPT_funcstack		= 254,
 	OPT_date		= 255,
 	OPT_module		= 256,
+	OPT_nofifos		= 257,
 };
 
 void trace_stop(int argc, char **argv)
@@ -5138,6 +5199,7 @@ static void parse_record_options(int argc,
 			{"date", no_argument, NULL, OPT_date},
 			{"func-stack", no_argument, NULL, OPT_funcstack},
 			{"nosplice", no_argument, NULL, OPT_nosplice},
+			{"nofifos", no_argument, NULL, OPT_nofifos},
 			{"profile", no_argument, NULL, OPT_profile},
 			{"stderr", no_argument, NULL, OPT_stderr},
 			{"by-comm", no_argument, NULL, OPT_bycomm},
@@ -5429,6 +5491,9 @@ static void parse_record_options(int argc,
 		case OPT_nosplice:
 			recorder_flags |= TRACECMD_RECORD_NOSPLICE;
 			break;
+		case OPT_nofifos:
+			no_fifos = true;
+			break;
 		case OPT_profile:
 			handle_init = trace_init_profile;
 			ctx->instance->flags |= BUFFER_FL_PROFILE;
@@ -5836,7 +5901,8 @@ void trace_record(int argc, char **argv)
 
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
-		       int argc, char **argv)
+		       int argc, char **argv,
+		       bool use_fifos)
 {
 	struct common_record_context ctx;
 	char **argv_plus;
@@ -5862,6 +5928,7 @@ int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		return -EINVAL;
 
 	ctx.instance->fds = fds;
+	ctx.instance->use_fifos = use_fifos;
 	ctx.instance->flags |= BUFFER_FL_AGENT;
 	ctx.instance->msg_handle = msg_handle;
 	msg_handle->version = V3_PROTOCOL;
-- 
2.20.1

