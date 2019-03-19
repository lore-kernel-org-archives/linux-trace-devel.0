Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E08C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C14420857
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 15:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbfCSPzx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:55:53 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35447 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfCSPzw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 11:55:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id f8so2394192wmh.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Mar 2019 08:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gFPtOC6UbJobu4UqaKvyttjQcPV/utC96CPdvk5r6F8=;
        b=c7+Y96pBln+BS5ky3+Uuh9YvJdavOefn8Bj7Qs5bmyocjmNVikaHpxxotHqbj7Ett6
         KlvyWQun+/8RZ4k6KOa4nCQ8J0f3spGvsBAnqiEy5nFNhPco+O0XL/D+tfGl8/FzQXwc
         TSWnTQjv9m+tB+xsNtpezrneaf8GV7dRC1ArLw0Lm1cFBaBRANAnLMnxIzF11DpHp695
         nq5zA/xxt6Slf2UhAFJ5+CY0N0FuiATAi2zUMX2pfzQ32Zlozj2gb4l3sW8vkXNVU+RK
         0N/Qodd4pmftm7UoHO5/EK0YTvmWA4XMctFb6BABj8yfeMHJUt14fvyR3cswRNQgTT//
         53Qw==
X-Gm-Message-State: APjAAAWdDotSmeYf7feziUu5pPeqtULRGM2rNpaIdxWHzGb5InwPvhU9
        fu5dP+VhissfiGoUHrMCnKo=
X-Google-Smtp-Source: APXvYqz4s8FKp/GU1hekzuWEzio2h2/s0EVkMkahOsObSiNoFA87LvUzbfzA7j07zwafKyhA9mJIGw==
X-Received: by 2002:a1c:7d8c:: with SMTP id y134mr4443257wmc.102.1553010947657;
        Tue, 19 Mar 2019 08:55:47 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t15sm9365911wrr.16.2019.03.19.08.55.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 08:55:46 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 9/9] trace-cmd [POC]: Implemented timestamps synch  algorithm, using vsock events.
Date:   Tue, 19 Mar 2019 17:55:36 +0200
Message-Id: <20190319155536.19381-10-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190319155536.19381-1-tstoyanov@vmware.com>
References: <20190319155536.19381-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a POC patch, implementing an algorithm for syncing timestamps between
host and guest machines, using vsock trace events to catch the host / guest time.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h  |  21 +-
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |  33 +-
 tracecmd/trace-agent.c         |  13 +-
 tracecmd/trace-msg.c           | 208 ++++++++-
 tracecmd/trace-record.c        |  85 +++-
 tracecmd/trace-timesync.c      | 825 +++++++++++++++++++++++++++++++++
 7 files changed, 1150 insertions(+), 36 deletions(-)
 create mode 100644 tracecmd/trace-timesync.c

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 5552396..905f3ec 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -341,16 +341,29 @@ bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 
 int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int argc, char **argv, bool use_fifos);
+				int argc, char **argv, bool use_fifos,
+				bool do_tsync);
 int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int *argc, char ***argv, bool *use_fifos);
+				int *argc, char ***argv, bool *use_fifos,
+				bool *do_tsync);
 
 int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int nr_cpus, int page_size,
-				 unsigned int *ports, bool use_fifos);
+				 unsigned int *ports, bool use_fifos,
+				 bool do_tsync);
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
-				 unsigned int **ports, bool *use_fifos);
+				 unsigned int **ports, bool *use_fifos,
+				 bool *do_tsync);
+
+struct tracecmd_clock_sync;
+
+int tracecmd_msg_rcv_time_sync(struct tracecmd_msg_handle *msg_handle,
+			       struct tracecmd_clock_sync *clock_sync,
+			       long long *offset, long long *timestamp);
+int tracecmd_msg_snd_time_sync(struct tracecmd_msg_handle *msg_handle,
+			       struct tracecmd_clock_sync *clock_sync,
+			       long long *offset, long long *timestamp);
 
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index d3e3080..8a73bf7 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -32,6 +32,7 @@ TRACE_CMD_OBJS += trace-list.o
 TRACE_CMD_OBJS += trace-output.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-msg.o
+TRACE_CMD_OBJS += trace-timesync.o
 
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-agent.o
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 62f5e47..7688b02 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -26,6 +26,7 @@ extern int quiet;
 typedef unsigned long long u64;
 
 struct buffer_instance;
+struct tracecmd_clock_sync;
 
 /* for local shared information with trace-cmd executable */
 
@@ -101,7 +102,7 @@ void trace_usage(int argc, char **argv);
 
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
-		       int argc, char **argv, bool use_fifos);
+		       int argc, char **argv, bool use_fifos, bool do_tsync);
 
 struct hook_list;
 
@@ -214,6 +215,12 @@ struct buffer_instance {
 	int			port;
 	int			*fds;
 	bool			use_fifos;
+	bool			do_tsync;
+
+	struct tracecmd_clock_sync *clock_sync;
+	int			time_sync_count;
+	long long		*time_sync_ts;
+	long long		*time_sync_offsets;
 };
 
 extern struct buffer_instance top_instance;
@@ -235,6 +242,30 @@ void update_first_instance(struct buffer_instance *instance, int topt);
 void show_instance_file(struct buffer_instance *instance, const char *name);
 
 int count_cpus(void);
+
+struct tracecmd_time_sync_event {
+	int			id;
+	int			cpu;
+	int			pid;
+	unsigned long long	ts;
+};
+
+int tracecmd_clock_get_peer(struct tracecmd_clock_sync *clock_context,
+			    unsigned int *remote_cid, unsigned int *remote_port);
+bool tracecmd_time_sync_check(void);
+void tracecmd_clock_context_free(struct buffer_instance *instance);
+int tracecmd_clock_find_event(struct tracecmd_clock_sync *clock, int cpu,
+			      struct tracecmd_time_sync_event *event);
+void tracecmd_clock_synch_enable(struct tracecmd_clock_sync *clock_context);
+void tracecmd_clock_synch_disable(struct tracecmd_clock_sync *clock_context);
+void tracecmd_clock_synch_calc_reset(struct tracecmd_clock_sync *clock_context);
+void tracecmd_clock_synch_calc_probe(struct tracecmd_clock_sync *clock_context,
+				     long long ts_local, long long ts_remote);
+int tracecmd_clock_synch_calc(struct tracecmd_clock_sync *clock_context,
+			       long long *offset_ret, long long *time_ret);
+void sync_time_with_host_v3(struct buffer_instance *instance);
+void sync_time_with_guest_v3(struct buffer_instance *instance);
+
 void write_tracing_on(struct buffer_instance *instance, int on);
 char *get_instance_dir(struct buffer_instance *instance);
 int write_instance_file(struct buffer_instance *instance,
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 7389f72..2189bc1 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -116,6 +116,7 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 	char **argv = NULL;
 	int argc = 0;
 	bool use_fifos;
+	bool do_tsync;
 	int *fds;
 	int ret;
 
@@ -128,7 +129,8 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 	if (!msg_handle)
 		die("Failed to allocate message handle");
 
-	ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv, &use_fifos);
+	ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv,
+					  &use_fifos, &do_tsync);
 	if (ret < 0)
 		die("Failed to receive trace request");
 
@@ -137,13 +139,18 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 
 	if (!use_fifos)
 		make_vsocks(nr_cpus, fds, ports);
+	if (do_tsync) {
+		do_tsync = tracecmd_time_sync_check();
+		if (!do_tsync)
+			warning("Failed to negotiate timestamps synchronization with the host");
+	}
 
 	ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size,
-					   ports, use_fifos);
+					   ports, use_fifos, do_tsync);
 	if (ret < 0)
 		die("Failed to send trace response");
 
-	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv, use_fifos);
+	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv, use_fifos, do_tsync);
 
 	free(argv[0]);
 	free(argv);
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 065a01e..bb3c060 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -26,8 +26,12 @@
 #include "trace-local.h"
 #include "trace-msg.h"
 
+typedef __u16 u16;
+typedef __s16 s16;
 typedef __u32 u32;
 typedef __be32 be32;
+typedef __u64 u64;
+typedef __s64 s64;
 
 static inline void dprint(const char *fmt, ...)
 {
@@ -50,6 +54,9 @@ static inline void dprint(const char *fmt, ...)
 
 unsigned int page_size;
 
+/* Try a few times to get an accurate time sync */
+#define TSYNC_TRIES 300
+
 struct tracecmd_msg_opt {
 	be32 size;
 	be32 opt_cmd;
@@ -76,6 +83,20 @@ struct tracecmd_msg_trace_resp {
 	be32 page_size;
 } __attribute__((packed));
 
+struct tracecmd_msg_tsync_stop {
+	long long offset;
+	long long timestamp;
+} __attribute__((packed));
+
+struct tracecmd_msg_tsync_req {
+	u16 cpu;
+} __attribute__((packed));
+
+struct tracecmd_msg_tsync_resp {
+	u64 time;
+} __attribute__((packed));
+
+
 struct tracecmd_msg_header {
 	be32	size;
 	be32	cmd;
@@ -83,14 +104,19 @@ struct tracecmd_msg_header {
 } __attribute__((packed));
 
 #define MSG_MAP								\
-	C(CLOSE,	0,	0),					\
-	C(TINIT,	1,	sizeof(struct tracecmd_msg_tinit)),	\
-	C(RINIT,	2,	sizeof(struct tracecmd_msg_rinit)),	\
-	C(SEND_DATA,	3,	0),					\
-	C(FIN_DATA,	4,	0),					\
-	C(NOT_SUPP,	5,	0),					\
-	C(TRACE_REQ,	6,	sizeof(struct tracecmd_msg_trace_req)),	\
-	C(TRACE_RESP,	7,	sizeof(struct tracecmd_msg_trace_resp)),
+	C(CLOSE,	  0,	0),					\
+	C(TINIT,	  1,	sizeof(struct tracecmd_msg_tinit)),	\
+	C(RINIT,	  2,	sizeof(struct tracecmd_msg_rinit)),	\
+	C(SEND_DATA,	  3,	0),					\
+	C(FIN_DATA,	  4,	0),					\
+	C(NOT_SUPP,	  5,	0),					\
+	C(TRACE_REQ,	  6,	sizeof(struct tracecmd_msg_trace_req)),	\
+	C(TRACE_RESP,	  7,	sizeof(struct tracecmd_msg_trace_resp)),\
+	C(TSYNC_START,	  8,	0),					\
+	C(TSYNC_STOP,	  9,	sizeof(struct tracecmd_msg_tsync_stop)),\
+	C(TSYNC_PROBE,	  11,	0),					\
+	C(TSYNC_REQ,	  11,	sizeof(struct tracecmd_msg_tsync_req)),	\
+	C(TSYNC_RESP,	  12,	sizeof(struct tracecmd_msg_tsync_resp)),
 
 #undef C
 #define C(a,b,c)	MSG_##a = b
@@ -120,10 +146,13 @@ static const char *cmd_to_name(int cmd)
 struct tracecmd_msg {
 	struct tracecmd_msg_header		hdr;
 	union {
-		struct tracecmd_msg_tinit	tinit;
-		struct tracecmd_msg_rinit	rinit;
-		struct tracecmd_msg_trace_req	trace_req;
-		struct tracecmd_msg_trace_resp	trace_resp;
+		struct tracecmd_msg_tinit		tinit;
+		struct tracecmd_msg_rinit		rinit;
+		struct tracecmd_msg_trace_req		trace_req;
+		struct tracecmd_msg_trace_resp		trace_resp;
+		struct tracecmd_msg_tsync_stop		ts_stop;
+		struct tracecmd_msg_tsync_req		ts_req;
+		struct tracecmd_msg_tsync_resp		ts_resp;
 	};
 	union {
 		struct tracecmd_msg_opt		*opt;
@@ -161,6 +190,7 @@ static int msg_write(int fd, struct tracecmd_msg *msg)
 
 enum msg_trace_flags {
 	MSG_TRACE_USE_FIFOS = 1 << 0,
+	MSG_TRACE_DO_TSYNC =  1 << 1,
 };
 
 enum msg_opt_command {
@@ -744,7 +774,8 @@ error:
 	return ret;
 }
 
-static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv, bool use_fifos)
+static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
+			  bool use_fifos, bool do_tsync)
 {
 	size_t args_size = 0;
 	char *p;
@@ -754,7 +785,12 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv, bool
 		args_size += strlen(argv[i]) + 1;
 
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + args_size);
-	msg->trace_req.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
+	msg->trace_req.flags = 0;
+	if (use_fifos)
+		msg->trace_req.flags |= MSG_TRACE_USE_FIFOS;
+	if (do_tsync)
+		msg->trace_req.flags |= MSG_TRACE_DO_TSYNC;
+	msg->trace_req.flags = htonl(msg->trace_req.flags);
 	msg->trace_req.argc = htonl(argc);
 	msg->buf = calloc(args_size, 1);
 	if (!msg->buf)
@@ -768,13 +804,14 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv, bool
 }
 
 int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int argc, char **argv, bool use_fifos)
+				int argc, char **argv, bool use_fifos,
+				bool do_tsync)
 {
 	struct tracecmd_msg msg;
 	int ret;
 
 	tracecmd_msg_init(MSG_TRACE_REQ, &msg);
-	ret = make_trace_req(&msg, argc, argv, use_fifos);
+	ret = make_trace_req(&msg, argc, argv, use_fifos, do_tsync);
 	if (ret < 0)
 		return ret;
 
@@ -787,7 +824,8 @@ int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
   *     free(argv);
   */
 int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int *argc, char ***argv, bool *use_fifos)
+				int *argc, char ***argv, bool *use_fifos,
+				bool *do_tsync)
 {
 	struct tracecmd_msg msg;
 	char *p, *buf_end, **args;
@@ -840,6 +878,7 @@ int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 	*argc = nr_args;
 	*argv = args;
 	*use_fifos = ntohl(msg.trace_req.flags) & MSG_TRACE_USE_FIFOS;
+	*do_tsync = ntohl(msg.trace_req.flags) & MSG_TRACE_DO_TSYNC;
 
 	/*
 	 * On success we're passing msg.buf to the caller through argv[0] so we
@@ -859,14 +898,136 @@ out:
 	return ret;
 }
 
+int tracecmd_msg_rcv_time_sync(struct tracecmd_msg_handle *msg_handle,
+			       struct tracecmd_clock_sync *clock_context,
+			       long long *offset, long long *timestamp)
+{
+	struct tracecmd_time_sync_event event;
+	unsigned int remote_cid = 0;
+	struct tracecmd_msg msg;
+	int cpu_pid, ret;
+
+	if (clock_context == NULL || msg_handle == NULL)
+		return 0;
+
+	if (offset)
+		*offset = 0;
+
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0 || ntohl(msg.hdr.cmd) == MSG_TSYNC_STOP)
+		return 0;
+	if (ntohl(msg.hdr.cmd) != MSG_TSYNC_START) {
+		handle_unexpected_msg(msg_handle, &msg);
+		return 0;
+	}
+
+	tracecmd_clock_get_peer(clock_context, &remote_cid, NULL);
+	tracecmd_msg_init(MSG_TSYNC_START, &msg);
+	tracecmd_msg_send(msg_handle->fd, &msg);
+	tracecmd_clock_synch_enable(clock_context);
+
+	do {
+		memset(&event, 0, sizeof(event));
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+		if (ret < 0 || ntohl(msg.hdr.cmd) == MSG_TSYNC_STOP)
+			break;
+		if (ntohl(msg.hdr.cmd) != MSG_TSYNC_PROBE) {
+			handle_unexpected_msg(msg_handle, &msg);
+			break;
+		}
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+		if (ret < 0 || ntohl(msg.hdr.cmd) == MSG_TSYNC_STOP)
+			break;
+		if (ntohl(msg.hdr.cmd) != MSG_TSYNC_REQ) {
+			handle_unexpected_msg(msg_handle, &msg);
+			break;
+		}
+		/* Get kvm event related to the corresponding VCPU context */
+		cpu_pid = get_guest_vcpu_pid(remote_cid, ntohs(msg.ts_req.cpu));
+		tracecmd_clock_find_event(clock_context, cpu_pid, &event);
+		tracecmd_msg_init(MSG_TSYNC_RESP, &msg);
+		msg.ts_resp.time = htonll(event.ts);
+		tracecmd_msg_send(msg_handle->fd, &msg);
+	} while (true);
+
+	tracecmd_clock_synch_disable(clock_context);
+
+	if (ret >= 0 && ntohl(msg.hdr.cmd) == MSG_TSYNC_STOP) {
+		if (offset)
+			*offset = ntohll(msg.ts_stop.offset);
+		if (timestamp)
+			*timestamp = ntohll(msg.ts_stop.timestamp);
+	}
+
+	msg_free(&msg);
+	return 0;
+}
+
+int tracecmd_msg_snd_time_sync(struct tracecmd_msg_handle *msg_handle,
+			       struct tracecmd_clock_sync *clock_context,
+			       long long *offset, long long *timestamp)
+{
+	struct tracecmd_time_sync_event event;
+	int sync_loop = TSYNC_TRIES;
+	struct tracecmd_msg msg;
+	int ret;
+
+	if (clock_context == NULL || msg_handle == NULL)
+		return 0;
+
+	tracecmd_msg_init(MSG_TSYNC_START, &msg);
+	tracecmd_msg_send(msg_handle->fd, &msg);
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0 || ntohl(msg.hdr.cmd) != MSG_TSYNC_START)
+		return 0;
+	tracecmd_clock_synch_calc_reset(clock_context);
+	tracecmd_clock_synch_enable(clock_context);
+
+	do {
+		tracecmd_msg_init(MSG_TSYNC_PROBE, &msg);
+		tracecmd_msg_send(msg_handle->fd, &msg);
+		/* Get the ts and CPU of the sent event */
+		ret = tracecmd_clock_find_event(clock_context, -1, &event);
+		tracecmd_msg_init(MSG_TSYNC_REQ, &msg);
+		msg.ts_req.cpu = htons(event.cpu);
+		tracecmd_msg_send(msg_handle->fd, &msg);
+		memset(&msg, 0, sizeof(msg));
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+		if (ret < 0)
+			break;
+		if (ntohl(msg.hdr.cmd) != MSG_TSYNC_RESP) {
+			handle_unexpected_msg(msg_handle, &msg);
+			break;
+		}
+		tracecmd_clock_synch_calc_probe(clock_context,
+						event.ts,
+						htonll(msg.ts_resp.time));
+	} while (--sync_loop);
+
+	tracecmd_clock_synch_disable(clock_context);
+	tracecmd_clock_synch_calc(clock_context, offset, timestamp);
+	tracecmd_msg_init(MSG_TSYNC_STOP, &msg);
+	msg.ts_stop.offset = htonll(*offset);
+	msg.ts_stop.timestamp = htonll(*timestamp);
+	tracecmd_msg_send(msg_handle->fd, &msg);
+
+	msg_free(&msg);
+	return 0;
+}
+
 static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
-			   unsigned int *ports, bool use_fifos)
+			   unsigned int *ports, bool use_fifos, bool do_tsync)
 {
 	int ports_size = nr_cpus * sizeof(*msg->port_array);
 	int i;
 
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + ports_size);
-	msg->trace_resp.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
+	msg->trace_resp.flags = 0;
+	if (use_fifos)
+		msg->trace_resp.flags |= MSG_TRACE_USE_FIFOS;
+	if (do_tsync)
+		msg->trace_resp.flags |= MSG_TRACE_DO_TSYNC;
+	msg->trace_resp.flags = htonl(msg->trace_resp.flags);
 	msg->trace_resp.cpus = htonl(nr_cpus);
 	msg->trace_resp.page_size = htonl(page_size);
 
@@ -882,13 +1043,14 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
 
 int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int nr_cpus, int page_size,
-				 unsigned int *ports, bool use_fifos)
+				 unsigned int *ports, bool use_fifos,
+				 bool do_tsync)
 {
 	struct tracecmd_msg msg;
 	int ret;
 
 	tracecmd_msg_init(MSG_TRACE_RESP, &msg);
-	ret = make_trace_resp(&msg, page_size, nr_cpus, ports, use_fifos);
+	ret = make_trace_resp(&msg, page_size, nr_cpus, ports, use_fifos, do_tsync);
 	if (ret < 0)
 		return ret;
 
@@ -897,7 +1059,8 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
-				 unsigned int **ports, bool *use_fifos)
+				 unsigned int **ports, bool *use_fifos,
+				 bool *do_tsync)
 {
 	struct tracecmd_msg msg;
 	ssize_t buf_len;
@@ -920,6 +1083,7 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 	}
 
 	*use_fifos = ntohl(msg.trace_resp.flags) & MSG_TRACE_USE_FIFOS;
+	*do_tsync = ntohl(msg.trace_resp.flags) & MSG_TRACE_DO_TSYNC;
 	*nr_cpus = ntohl(msg.trace_resp.cpus);
 	*page_size = ntohl(msg.trace_resp.page_size);
 	*ports = calloc(*nr_cpus, sizeof(**ports));
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8c8e46f..0ae42b0 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -210,6 +210,8 @@ struct common_record_context {
 	char *date2ts;
 	char *max_graph_depth;
 	int data_flags;
+	int time_shift_count;
+	struct tracecmd_option *time_shift_option;
 
 	int record_all;
 	int total_disable;
@@ -649,11 +651,20 @@ static void tell_guests_to_stop(void)
 	for_all_instances(instance) {
 		if (is_guest(instance)) {
 			tracecmd_msg_send_close_msg(instance->msg_handle);
-			tracecmd_msg_handle_close(instance->msg_handle);
 		}
 	}
 }
 
+static void close_guests_handle(void)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance) {
+		if (is_guest(instance))
+			tracecmd_msg_handle_close(instance->msg_handle);
+	}
+}
+
 static void stop_threads(enum trace_type type)
 {
 	struct timeval tv = { 0, 0 };
@@ -3359,6 +3370,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 	unsigned int *ports;
 	int i, *fds = NULL;
 	bool use_fifos = false;
+	bool do_tsync, do_tsync_reply;
 
 	if (!no_fifos) {
 		nr_fifos = open_guest_fifos(instance->name, &fds);
@@ -3370,20 +3382,24 @@ static void connect_to_agent(struct buffer_instance *instance)
 		die("Failed to connect to vsocket @%d:%d",
 		    instance->cid, instance->port);
 
+	do_tsync = tracecmd_time_sync_check();
+
 	msg_handle = tracecmd_msg_handle_alloc(sd, 0);
 	if (!msg_handle)
 		die("Failed to allocate message handle");
 
 	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
-					  instance->argv, use_fifos);
+					  instance->argv, use_fifos, do_tsync);
 	if (ret < 0)
 		die("Failed to send trace request");
 
 	ret = tracecmd_msg_recv_trace_resp(msg_handle, &nr_cpus, &page_size,
-					   &ports, &use_fifos);
+					   &ports, &use_fifos, &do_tsync_reply);
 	if (ret < 0)
 		die("Failed to receive trace response");
-
+	if (do_tsync != do_tsync_reply)
+		warning("Failed to negotiate timestamps synchronization with the guest %s",
+			instance->name);
 	if (use_fifos) {
 		if (nr_cpus != nr_fifos) {
 			warning("number of FIFOs (%d) for guest %s differs "
@@ -3401,10 +3417,13 @@ static void connect_to_agent(struct buffer_instance *instance)
 	}
 
 	instance->use_fifos = use_fifos;
+	instance->do_tsync = do_tsync_reply;
 	instance->cpu_count = nr_cpus;
 
 	/* the msg_handle now points to the guest fd */
 	instance->msg_handle = msg_handle;
+
+	sync_time_with_guest_v3(instance);
 }
 
 static void setup_guest(struct buffer_instance *instance)
@@ -3429,10 +3448,13 @@ static void setup_guest(struct buffer_instance *instance)
 	close(fd);
 }
 
-static void setup_agent(struct buffer_instance *instance, struct common_record_context *ctx)
+static void setup_agent(struct buffer_instance *instance,
+			struct common_record_context *ctx)
 {
 	struct tracecmd_output *network_handle;
 
+	sync_time_with_host_v3(instance);
+
 	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
 						     listed_events);
 	add_options(network_handle, ctx);
@@ -5607,6 +5629,42 @@ static bool has_local_instances(void)
 	return false;
 }
 
+//#define TSYNC_DEBUG
+static void write_guest_time_shift(struct buffer_instance *instance)
+{
+	struct tracecmd_output *handle;
+	struct iovec vector[3];
+	char *file;
+	int fd;
+
+	if (!instance->time_sync_count)
+		return;
+
+	file = get_guest_file(output_file, instance->name);
+	fd = open(file, O_RDWR);
+	if (fd < 0)
+		die("error opening %s", file);
+	put_temp_file(file);
+	handle = tracecmd_get_output_handle_fd(fd);
+	vector[0].iov_len = sizeof(instance->time_sync_count);
+	vector[0].iov_base = &instance->time_sync_count;
+	vector[1].iov_len = sizeof(long long) * instance->time_sync_count;
+	vector[1].iov_base = instance->time_sync_ts;
+	vector[2].iov_len = sizeof(long long) * instance->time_sync_count;
+	vector[2].iov_base = instance->time_sync_offsets;
+	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 3);
+	tracecmd_append_options(handle);
+	tracecmd_output_close(handle);
+#ifdef TSYNC_DEBUG
+	if (instance->time_sync_count > 1)
+		printf("\n\rDetected %lld ns ts offset drift in %lld ns for guest %s\n\r",
+			instance->time_sync_offsets[instance->time_sync_count-1] -
+			instance->time_sync_offsets[0],
+			instance->time_sync_ts[instance->time_sync_count-1]-
+			instance->time_sync_ts[0], instance->name);
+#endif
+}
+
 /*
  * This function contains common code for the following commands:
  * record, start, stream, profile.
@@ -5726,6 +5784,20 @@ static void record_trace(int argc, char **argv,
 	if (!latency)
 		wait_threads();
 
+	if (ctx->instance && is_agent(ctx->instance)) {
+		sync_time_with_host_v3(ctx->instance);
+		tracecmd_clock_context_free(ctx->instance);
+	} else {
+		for_all_instances(instance) {
+			if (is_guest(instance)) {
+				sync_time_with_guest_v3(instance);
+				write_guest_time_shift(instance);
+				tracecmd_clock_context_free(instance);
+			}
+		}
+	}
+	close_guests_handle();
+
 	if (IS_RECORD(ctx)) {
 		record_data(ctx);
 		delete_thread_data();
@@ -5864,7 +5936,7 @@ void trace_record(int argc, char **argv)
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
 		       int argc, char **argv,
-		       bool use_fifos)
+		       bool use_fifos, bool do_tsync)
 {
 	struct common_record_context ctx;
 	char **argv_plus;
@@ -5891,6 +5963,7 @@ int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 
 	ctx.instance->fds = fds;
 	ctx.instance->use_fifos = use_fifos;
+	ctx.instance->do_tsync = do_tsync;
 	ctx.instance->flags |= BUFFER_FL_AGENT;
 	ctx.instance->msg_handle = msg_handle;
 	msg_handle->version = V3_PROTOCOL;
diff --git a/tracecmd/trace-timesync.c b/tracecmd/trace-timesync.c
new file mode 100644
index 0000000..c9b6241
--- /dev/null
+++ b/tracecmd/trace-timesync.c
@@ -0,0 +1,825 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tstoyanov@vmware.com>
+ *
+ */
+
+#include <fcntl.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <linux/vm_sockets.h>
+#include "trace-local.h"
+
+//#define TSYNC_DEBUG
+
+static int clock_sync_x86_host_init(struct tracecmd_clock_sync *clock_context);
+static int clock_sync_x86_host_free(struct tracecmd_clock_sync *clock_context);
+static int clock_sync_x86_host_find_events(struct tracecmd_clock_sync *clock,
+				    int cpu, struct tracecmd_time_sync_event *event);
+static int clock_sync_x86_guest_init(struct tracecmd_clock_sync *clock_context);
+static int clock_sync_x86_guest_free(struct tracecmd_clock_sync *clock_context);
+static int clock_sync_x86_guest_find_events(struct tracecmd_clock_sync *clock,
+					    int pid,
+					    struct tracecmd_time_sync_event *event);
+
+struct tracecmd_event_descr {
+	char			*system;
+	char			*name;
+};
+
+struct tracecmd_ftrace_param {
+	char	*file;
+	char	*set;
+	char	*reset;
+};
+
+enum clock_sync_context {
+	CLOCK_KVM_X86_VSOCK_HOST,
+	CLOCK_KVM_X86_VSOCK_GUEST,
+	CLOCK_CONTEXT_MAX,
+};
+
+struct tracecmd_clock_sync {
+	enum clock_sync_context		clock_context_id;
+	struct tracecmd_ftrace_param	*ftrace_params;
+	struct tracecmd_time_sync_event	*events;
+	int				events_count;
+	struct tep_handle		*tep;
+	struct buffer_instance		*vinst;
+
+	int				probes_count;
+	int				bad_probes;
+	int				probes_size;
+	long long			*times;
+	long long			*offsets;
+	long long			offset_av;
+	long long			offset_min;
+	long long			offset_max;
+	int				debug_fd;
+
+	unsigned int			local_cid;
+	unsigned int			local_port;
+	unsigned int			remote_cid;
+	unsigned int			remote_port;
+};
+
+struct {
+	const char *systems[3];
+	struct tracecmd_ftrace_param ftrace_params[5];
+	struct tracecmd_event_descr events[3];
+	int (*clock_sync_init)(struct tracecmd_clock_sync *clock_context);
+	int (*clock_sync_free)(struct tracecmd_clock_sync *clock_context);
+	int (*clock_sync_find_events)(struct tracecmd_clock_sync *clock_context,
+				      int pid,
+				      struct tracecmd_time_sync_event *event);
+	int (*clock_sync_load)(struct tracecmd_clock_sync *clock_context);
+	int (*clock_sync_unload)(struct tracecmd_clock_sync *clock_context);
+} static clock_sync[CLOCK_CONTEXT_MAX] = {
+	{ /* CLOCK_KVM_X86_VSOCK_HOST */
+	  .systems = {"vsock", "ftrace", NULL},
+	  .ftrace_params = {
+	  {"set_ftrace_filter", "vmx_read_l1_tsc_offset\nsvm_read_l1_tsc_offset", "\0"},
+	  {"current_tracer", "function", "nop"},
+	  {"events/vsock/virtio_transport_recv_pkt/enable", "1", "0"},
+	  {"events/vsock/virtio_transport_recv_pkt/filter", NULL, "\0"},
+	  {NULL, NULL, NULL} },
+	  .events = {
+	  {.system = "ftrace", .name = "function"},
+	  {.system = "vsock", .name = "virtio_transport_recv_pkt"},
+	  {.system = NULL, .name = NULL} },
+	 clock_sync_x86_host_init,
+	 clock_sync_x86_host_free,
+	 clock_sync_x86_host_find_events,
+	},
+
+	{ /* CLOCK_KVM_X86_VSOCK_GUEST */
+	 .systems = { "vsock", "ftrace", NULL},
+	 .ftrace_params = {
+	  {"set_ftrace_filter", "vp_notify", "\0"},
+	  {"current_tracer", "function", "nop"},
+	  {"events/vsock/virtio_transport_alloc_pkt/enable", "1", "0"},
+	  {"events/vsock/virtio_transport_alloc_pkt/filter", NULL, "\0"},
+	  {NULL, NULL, NULL},
+	  },
+	  .events = {
+	  {.system = "vsock", .name = "virtio_transport_alloc_pkt"},
+	  {.system = "ftrace", .name = "function"},
+	  {.system = NULL, .name = NULL}
+	 },
+	  clock_sync_x86_guest_init,
+	  clock_sync_x86_guest_free,
+	  clock_sync_x86_guest_find_events,
+	}
+};
+
+static int clock_sync_x86_host_init(struct tracecmd_clock_sync *clock_context)
+{
+	char vsock_filter[255];
+
+	snprintf(vsock_filter, 255,
+		"src_cid==%u && src_port==%u && dst_cid==%u && dst_port==%u && len!=0",
+		clock_context->remote_cid, clock_context->remote_port,
+		clock_context->local_cid, clock_context->local_port);
+
+	clock_context->ftrace_params[3].set = strdup(vsock_filter);
+	return 1;
+}
+
+static int clock_sync_x86_host_free(struct tracecmd_clock_sync *clock_context)
+{
+	free(clock_context->ftrace_params[3].set);
+	clock_context->ftrace_params[3].set = NULL;
+	return 1;
+}
+
+static int clock_sync_x86_guest_init(struct tracecmd_clock_sync *clock_context)
+{
+	char vsock_filter[255];
+
+	snprintf(vsock_filter, 255,
+		"src_cid==%u && src_port==%u && dst_cid==%u && dst_port==%u && len!=0",
+		clock_context->local_cid, clock_context->local_port,
+		clock_context->remote_cid, clock_context->remote_port);
+
+	clock_context->ftrace_params[3].set = strdup(vsock_filter);
+	return 1;
+}
+
+static int clock_sync_x86_guest_free(struct tracecmd_clock_sync *clock_context)
+{
+	free(clock_context->ftrace_params[3].set);
+	clock_context->ftrace_params[3].set = NULL;
+	return 1;
+}
+
+static int
+get_events_in_page(struct tep_handle *tep, void *page,
+		    int size, int cpu, struct tracecmd_time_sync_event **events,
+		    int *events_count, int *events_size)
+{
+	struct tracecmd_time_sync_event *events_array = NULL;
+	struct tep_record *last_record = NULL;
+	struct tep_event *event = NULL;
+	struct tep_record *record;
+	int id, cnt = 0;
+
+	if (size <= 0)
+		return 0;
+
+	if (*events == NULL) {
+		*events = malloc(10*sizeof(struct tracecmd_time_sync_event));
+		*events_size = 10;
+		*events_count = 0;
+	}
+
+	while (true) {
+		event = NULL;
+		record = tracecmd_read_page_record(tep, page, size,
+						   last_record);
+		if (!record)
+			break;
+		free_record(last_record);
+		id = tep_data_type(tep, record);
+		event = tep_data_event_from_type(tep, id);
+		if (event) {
+			if (*events_count >= *events_size) {
+				events_array = realloc(*events,
+					((3*(*events_size))/2)*
+					sizeof(struct tracecmd_time_sync_event));
+				if (events_array) {
+					*events = events_array;
+					(*events_size) = (((*events_size)*3)/2);
+				}
+			}
+
+			if (*events_count < *events_size) {
+				(*events)[*events_count].ts = record->ts;
+				(*events)[*events_count].cpu = cpu;
+				(*events)[*events_count].id = id;
+				(*events)[*events_count].pid = tep_data_pid(tep, record);
+				(*events_count)++;
+				cnt++;
+			}
+		}
+		last_record = record;
+	}
+	free_record(last_record);
+
+	return cnt;
+}
+
+static int sync_events_cmp(const void *a, const void *b)
+{
+	const struct tracecmd_time_sync_event *ea = (const struct tracecmd_time_sync_event *)a;
+	const struct tracecmd_time_sync_event *eb = (const struct tracecmd_time_sync_event *)b;
+
+	if (ea->ts > eb->ts)
+		return 1;
+	if (ea->ts < eb->ts)
+		return -1;
+	return 0;
+}
+
+static int find_sync_events(struct tep_handle *pevent,
+			    struct tracecmd_time_sync_event *recorded,
+			    int rsize, struct tracecmd_time_sync_event *events)
+{
+	int i = 0, j = 0;
+
+	while (i < rsize) {
+		if (!events[j].ts && events[j].id == recorded[i].id &&
+		    (events[j].pid < 0 || events[j].pid == recorded[i].pid)) {
+			events[j].cpu = recorded[i].cpu;
+			events[j].ts = recorded[i].ts;
+			j++;
+		} else if (j > 0 && events[j-1].id == recorded[i].id &&
+			  (events[j-1].pid < 0 || events[j-1].pid == recorded[i].pid)) {
+			events[j-1].cpu = recorded[i].cpu;
+			events[j-1].ts = recorded[i].ts;
+		}
+		i++;
+	}
+	return j;
+}
+
+//#define TSYNC_RBUFFER_DEBUG
+static int find_raw_events(struct tep_handle *tep,
+		    struct buffer_instance *instance,
+		    struct tracecmd_time_sync_event *events)
+{
+	struct tracecmd_time_sync_event *events_array = NULL;
+	int events_count = 0;
+	int events_size = 0;
+	unsigned int p_size;
+	int ts = 0;
+	void *page;
+	char *path;
+	char *file;
+	DIR *dir;
+	int len;
+	int fd;
+	int i;
+	int r;
+
+	p_size = getpagesize();
+#ifdef TSYNC_RBUFFER_DEBUG
+	file = get_instance_file(instance, "trace");
+	if (!file)
+		return ts;
+	{
+		char *buf = NULL;
+		FILE *fp;
+		size_t n;
+		int r;
+
+		printf("Events:\n\r");
+		fp = fopen(file, "r");
+		while ((r = getline(&buf, &n, fp)) >= 0) {
+
+			if (buf[0] != '#')
+				printf("%s", buf);
+			free(buf);
+			buf = NULL;
+		}
+		fclose(fp);
+	}
+	tracecmd_put_tracing_file(file);
+#endif /* TSYNC_RBUFFER_DEBUG */
+	path = get_instance_file(instance, "per_cpu");
+	if (!path)
+		return ts;
+
+	dir = opendir(path);
+	if (!dir)
+		goto out;
+
+	len = strlen(path);
+	file = malloc(len + strlen("trace_pipe_raw") + 32);
+	page = malloc(p_size);
+	if (!file || !page)
+		die("Failed to allocate time_stamp info");
+	for (i = 0; i < instance->cpu_count; i++) {
+		sprintf(file, "%s/cpu%d/trace_pipe_raw", path, i);
+		fd = open(file, O_RDONLY | O_NONBLOCK);
+		if (fd < 0)
+			continue;
+		do {
+			r = read(fd, page, p_size);
+			if (r > 0) {
+				get_events_in_page(tep, page, r, i,
+						   &events_array, &events_count,
+						   &events_size);
+			}
+		} while (r > 0);
+		close(fd);
+	}
+	qsort(events_array, events_count, sizeof(*events_array), sync_events_cmp);
+	r = find_sync_events(tep, events_array, events_count, events);
+#ifdef TSYNC_RBUFFER_DEBUG
+	len = 0;
+	while (events[len].id) {
+		printf("Found %d @ cpu %d: %lld pid %d\n\r",
+			events[len].id,  events[len].cpu,
+			events[len].ts, events[len].pid);
+		len++;
+	}
+#endif
+
+	free(events_array);
+	free(file);
+	free(page);
+	closedir(dir);
+
+ out:
+	tracecmd_put_tracing_file(path);
+	return r;
+}
+
+static int clock_sync_x86_host_find_events(struct tracecmd_clock_sync *clock,
+					   int pid,
+					   struct tracecmd_time_sync_event *event)
+{
+	int ret;
+
+	clock->events[0].pid = pid;
+	ret = find_raw_events(clock->tep, clock->vinst, clock->events);
+	event->ts = clock->events[0].ts;
+	event->cpu = clock->events[0].cpu;
+	return ret;
+
+}
+
+static int clock_sync_x86_guest_find_events(struct tracecmd_clock_sync *clock,
+					    int pid,
+					    struct tracecmd_time_sync_event *event)
+{
+	int ret;
+
+	ret = find_raw_events(clock->tep, clock->vinst, clock->events);
+	if (ret != clock->events_count)
+		return 0;
+	event->ts = clock->events[1].ts;
+	event->cpu = clock->events[0].cpu;
+	return 1;
+
+}
+
+static void tracecmd_clock_sync_reset(struct tracecmd_clock_sync *clock_context)
+{
+	int i = 0;
+
+	while (clock_context->events[i].id) {
+		clock_context->events[i].cpu = 0;
+		clock_context->events[i].ts = 0;
+		clock_context->events[i].pid = -1;
+		i++;
+	}
+}
+
+int tracecmd_clock_find_event(struct tracecmd_clock_sync *clock, int pid,
+			      struct tracecmd_time_sync_event *event)
+{
+	int ret = 0;
+	int id;
+
+	if (clock == NULL ||
+	    clock->clock_context_id >= CLOCK_CONTEXT_MAX)
+		return 0;
+
+	id = clock->clock_context_id;
+	if (clock_sync[id].clock_sync_find_events)
+		ret = clock_sync[id].clock_sync_find_events(clock, pid, event);
+
+	tracecmd_clock_sync_reset(clock);
+	return ret;
+}
+
+static void clock_context_copy(struct tracecmd_clock_sync *clock_context,
+			       struct tracecmd_ftrace_param *params,
+			       struct tracecmd_event_descr *events)
+{
+	int i;
+
+	i = 0;
+	while (params[i].file)
+		i++;
+	clock_context->ftrace_params = calloc(i+1, sizeof(struct tracecmd_ftrace_param));
+	i = 0;
+	while (params[i].file) {
+		clock_context->ftrace_params[i].file = strdup(params[i].file);
+		if (params[i].set)
+			clock_context->ftrace_params[i].set = strdup(params[i].set);
+		if (params[i].reset)
+			clock_context->ftrace_params[i].reset = strdup(params[i].reset);
+		i++;
+	}
+
+	i = 0;
+	while (events[i].name)
+		i++;
+	clock_context->events = calloc(i+1, sizeof(struct tracecmd_time_sync_event));
+	clock_context->events_count = i;
+}
+
+void trace_instance_reset(struct buffer_instance *vinst)
+{
+	write_instance_file(vinst, "trace", "\0", NULL);
+}
+
+static struct buffer_instance *
+clock_synch_create_instance(const char *clock, unsigned int cid)
+{
+	struct buffer_instance *vinst;
+	char inst_name[256];
+
+	snprintf(inst_name, 256, "clock_synch-%d", cid);
+
+	vinst = create_instance(strdup(inst_name));
+	tracecmd_init_instance(vinst);
+	vinst->cpu_count = tracecmd_local_cpu_count();
+	tracecmd_make_instance(vinst);
+	trace_instance_reset(vinst);
+	if (clock)
+		vinst->clock = strdup(clock);
+	tracecmd_set_clock(vinst);
+	return vinst;
+}
+
+static struct tep_handle *clock_synch_get_tep(struct buffer_instance *instance,
+					      const char * const *systems)
+{
+	struct tep_handle *tep = NULL;
+	char *path;
+
+	path = get_instance_dir(instance);
+	tep = tracecmd_local_events_system(path, systems);
+	tracecmd_put_tracing_file(path);
+
+	tep_set_file_bigendian(tep, tracecmd_host_bigendian());
+	tep_set_host_bigendian(tep, tracecmd_host_bigendian());
+
+	return tep;
+}
+
+static void get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
+			       unsigned int *rcid, unsigned int *rport)
+{
+	struct sockaddr_vm addr;
+	socklen_t addr_len = sizeof(addr);
+
+	if (lcid || lport) {
+		memset(&addr, 0, sizeof(addr));
+		if (getsockname(fd, (struct sockaddr *)&addr, &addr_len))
+			return;
+		if (addr.svm_family != AF_VSOCK)
+			return;
+		if (lport)
+			*lport = addr.svm_port;
+		if (lcid)
+			*lcid = addr.svm_cid;
+	}
+
+	if (rcid || rport) {
+		memset(&addr, 0, sizeof(addr));
+		addr_len = sizeof(addr);
+		if (getpeername(fd, (struct sockaddr *)&addr, &addr_len))
+			return;
+		if (addr.svm_family != AF_VSOCK)
+			return;
+
+		if (rport)
+			*rport = addr.svm_port;
+		if (rcid)
+			*rcid = addr.svm_cid;
+	}
+}
+
+struct tracecmd_clock_sync*
+tracecmd_clock_context_new(struct tracecmd_msg_handle *msg_handle,
+			    const char *clock_str,
+			    enum clock_sync_context id)
+{
+	struct tracecmd_clock_sync *clock_context;
+	struct tep_event *event;
+	unsigned int i = 0;
+
+	switch (id) {
+#ifdef VSOCK
+	case CLOCK_KVM_X86_VSOCK_HOST:
+	case CLOCK_KVM_X86_VSOCK_GUEST:
+		break;
+#endif
+	default: /* not supported clock sync context */
+		return NULL;
+	}
+
+	if (id >= CLOCK_CONTEXT_MAX || NULL == msg_handle)
+		return NULL;
+	clock_context = calloc(1, sizeof(struct tracecmd_clock_sync));
+	if (!clock_context)
+		return NULL;
+	clock_context->clock_context_id = id;
+	clock_context_copy(clock_context,
+			   clock_sync[id].ftrace_params, clock_sync[id].events);
+
+	get_vsocket_params(msg_handle->fd,
+			   &(clock_context->local_cid),
+			   &(clock_context->local_port),
+			   &(clock_context->remote_cid),
+			   &(clock_context->remote_port));
+
+	if (clock_sync[id].clock_sync_init)
+		clock_sync[id].clock_sync_init(clock_context);
+
+	clock_context->vinst = clock_synch_create_instance(clock_str, clock_context->remote_cid);
+	clock_context->tep = clock_synch_get_tep(clock_context->vinst,
+						 clock_sync[id].systems);
+	i = 0;
+	while (clock_sync[id].events[i].name) {
+		event = tep_find_event_by_name(clock_context->tep,
+					       clock_sync[id].events[i].system,
+					       clock_sync[id].events[i].name);
+		if (!event)
+			break;
+		clock_context->events[i].id = event->id;
+		i++;
+	}
+#ifdef TSYNC_DEBUG
+	clock_context->debug_fd = -1;
+#endif
+
+	return clock_context;
+
+}
+
+void tracecmd_clock_context_free(struct buffer_instance *instance)
+{
+	int i;
+
+	if (instance->clock_sync == NULL ||
+	    instance->clock_sync->clock_context_id >= CLOCK_CONTEXT_MAX)
+		return;
+	if (clock_sync[instance->clock_sync->clock_context_id].clock_sync_free)
+		clock_sync[instance->clock_sync->clock_context_id].clock_sync_free(instance->clock_sync);
+
+	i = 0;
+	while (instance->clock_sync->ftrace_params[i].file) {
+		free(instance->clock_sync->ftrace_params[i].file);
+		free(instance->clock_sync->ftrace_params[i].set);
+		free(instance->clock_sync->ftrace_params[i].reset);
+		i++;
+	}
+	free(instance->clock_sync->ftrace_params);
+	free(instance->clock_sync->events);
+	tracecmd_remove_instance(instance->clock_sync->vinst);
+	/* todo: clean up the instance */
+	tep_free(instance->clock_sync->tep);
+
+	free(instance->clock_sync->offsets);
+	free(instance->clock_sync->times);
+#ifdef TSYNC_DEBUG
+	if (instance->clock_sync->debug_fd >= 0) {
+		close(instance->clock_sync->debug_fd);
+		instance->clock_sync->debug_fd = -1;
+	}
+#endif
+	free(instance->clock_sync);
+	instance->clock_sync = NULL;
+}
+
+bool tracecmd_time_sync_check(void)
+{
+#ifdef VSOCK
+	return true;
+#endif
+	return false;
+}
+
+void sync_time_with_host_v3(struct buffer_instance *instance)
+{
+	long long timestamp = 0;
+	long long offset = 0;
+
+	if (!instance->do_tsync)
+		return;
+
+	if (instance->clock_sync == NULL)
+		instance->clock_sync = tracecmd_clock_context_new(instance->msg_handle,
+					instance->clock, CLOCK_KVM_X86_VSOCK_GUEST);
+
+	tracecmd_msg_snd_time_sync(instance->msg_handle, instance->clock_sync,
+				   &offset, &timestamp);
+	if (!offset && !timestamp)
+		warning("Failed to synchronize timestamps with the host");
+}
+
+void sync_time_with_guest_v3(struct buffer_instance *instance)
+{
+	long long timestamp = 0;
+	long long offset = 0;
+	long long *sync_array_ts;
+	long long *sync_array_offs;
+
+	if (!instance->do_tsync)
+		return;
+
+	if (instance->clock_sync == NULL)
+		instance->clock_sync = tracecmd_clock_context_new(instance->msg_handle,
+						top_instance.clock, CLOCK_KVM_X86_VSOCK_HOST);
+
+	tracecmd_msg_rcv_time_sync(instance->msg_handle,
+				   instance->clock_sync, &offset, &timestamp);
+
+	if (!offset && !timestamp) {
+		warning("Failed to synchronize timestamps with guest %s",
+			instance->name);
+		return;
+	}
+
+	sync_array_ts = realloc(instance->time_sync_ts,
+			    (instance->time_sync_count+1)*sizeof(long long));
+	sync_array_offs = realloc(instance->time_sync_offsets,
+			    (instance->time_sync_count+1)*sizeof(long long));
+
+	if (sync_array_ts && sync_array_offs) {
+		sync_array_ts[instance->time_sync_count] = timestamp;
+		sync_array_offs[instance->time_sync_count] = offset;
+		instance->time_sync_count++;
+		instance->time_sync_ts = sync_array_ts;
+		instance->time_sync_offsets = sync_array_offs;
+
+	} else {
+		free(sync_array_ts);
+		free(sync_array_offs);
+	}
+
+}
+
+static void set_clock_synch_events(struct buffer_instance *instance,
+				   struct tracecmd_ftrace_param *params,
+				   bool enable)
+{
+	int i = 0;
+
+	if (!enable)
+		write_tracing_on(instance, 0);
+
+	while (params[i].file) {
+		if (enable && params[i].set) {
+			write_instance_file(instance, params[i].file,
+					    params[i].set, NULL);
+		}
+		if (!enable && params[i].reset)
+			write_instance_file(instance, params[i].file,
+					    params[i].reset, NULL);
+		i++;
+	}
+
+	if (enable)
+		write_tracing_on(instance, 1);
+}
+
+int tracecmd_clock_get_peer(struct tracecmd_clock_sync *clock_context,
+			    unsigned int *remote_cid, unsigned int *remote_port)
+{
+	if (!clock_context)
+		return 0;
+	if (remote_cid)
+		*remote_cid = clock_context->remote_cid;
+	if (remote_port)
+		*remote_cid = clock_context->remote_port;
+	return 1;
+}
+
+void tracecmd_clock_synch_enable(struct tracecmd_clock_sync *clock_context)
+{
+	set_clock_synch_events(clock_context->vinst,
+			       clock_context->ftrace_params, true);
+}
+
+void tracecmd_clock_synch_disable(struct tracecmd_clock_sync *clock_context)
+{
+	set_clock_synch_events(clock_context->vinst,
+			       clock_context->ftrace_params, false);
+}
+
+int tracecmd_clock_synch_calc(struct tracecmd_clock_sync *clock_context,
+			       long long *offset_ret, long long *time_ret)
+{
+	int i, j = 0;
+	long long av, tresch, offset = 0, time = 0;
+
+	if (!clock_context || !clock_context->probes_count)
+		return 0;
+	av = clock_context->offset_av / clock_context->probes_count;
+	tresch = (long long)((clock_context->offset_max - clock_context->offset_min)/10);
+
+	for (i = 0; i < clock_context->probes_count; i++) {
+		/* filter the offsets with deviation up to 10% */
+		if (llabs(clock_context->offsets[i] - av) < tresch) {
+			offset += clock_context->offsets[i];
+			j++;
+		}
+	}
+	if (j)
+		offset /= (long long)j;
+
+	tresch = 0;
+	for (i = 0; i < clock_context->probes_count; i++) {
+		if ((!tresch || tresch > llabs(offset-clock_context->offsets[i]))) {
+			tresch = llabs(offset-clock_context->offsets[i]);
+			time = clock_context->times[i];
+		}
+	}
+	if (offset_ret)
+		*offset_ret = offset;
+	if (time_ret)
+		*time_ret = time;
+#ifdef TSYNC_DEBUG
+	printf("\n calculated offset: %lld, %d/%d probes\n\r",
+		*offset_ret, clock_context->probes_count,
+		clock_context->probes_count + clock_context->bad_probes);
+#endif
+	return 1;
+}
+
+void tracecmd_clock_synch_calc_reset(struct tracecmd_clock_sync *clock_context)
+{
+	if (!clock_context)
+		return;
+
+	clock_context->probes_count = 0;
+	clock_context->bad_probes = 0;
+	clock_context->offset_av = 0;
+	clock_context->offset_min = 0;
+	clock_context->offset_max = 0;
+#ifdef TSYNC_DEBUG
+	if (clock_context->debug_fd >= 0) {
+		close(clock_context->debug_fd);
+		clock_context->debug_fd = -1;
+	}
+#endif
+
+}
+
+void tracecmd_clock_synch_calc_probe(struct tracecmd_clock_sync *clock_context,
+				     long long ts_local, long long ts_remote)
+{
+	int count;
+#ifdef TSYNC_DEBUG
+	char buff[256];
+#endif
+
+	if (!clock_context || !ts_local || !ts_remote)
+		return;
+	if (!ts_local || !ts_remote) {
+		clock_context->bad_probes++;
+		return;
+	}
+
+	if (!clock_context->offsets && !clock_context->times) {
+		clock_context->offsets = calloc(10, sizeof(long long));
+		clock_context->times = calloc(10, sizeof(long long));
+		clock_context->probes_size = 10;
+	}
+
+	if (clock_context->probes_size == clock_context->probes_count) {
+		clock_context->probes_size = (3*clock_context->probes_size)/2;
+		clock_context->offsets = realloc(clock_context->offsets,
+						 clock_context->probes_size *
+						 sizeof(long long));
+		clock_context->times = realloc(clock_context->times,
+					       clock_context->probes_size*
+					       sizeof(long long));
+	}
+
+	if (!clock_context->offsets || !clock_context->times) {
+		clock_context->probes_size = 0;
+		tracecmd_clock_synch_calc_reset(clock_context);
+		return;
+	}
+#ifdef TSYNC_DEBUG
+	if (clock_context->debug_fd < 0) {
+		sprintf(buff, "s-cid%d.txt", clock_context->remote_cid);
+		clock_context->debug_fd = open(buff, O_CREAT|O_WRONLY|O_TRUNC, 0644);
+	}
+#endif
+	count = clock_context->probes_count;
+	clock_context->probes_count++;
+	clock_context->offsets[count] = ts_remote - ts_local;
+	clock_context->times[count] = ts_local;
+	clock_context->offset_av += clock_context->offsets[count];
+
+	if (!clock_context->offset_min ||
+	    clock_context->offset_min > llabs(clock_context->offsets[count]))
+		clock_context->offset_min = llabs(clock_context->offsets[count]);
+	if (!clock_context->offset_max ||
+	    clock_context->offset_max < llabs(clock_context->offsets[count]))
+		clock_context->offset_max = llabs(clock_context->offsets[count]);
+#ifdef TSYNC_DEBUG
+	sprintf(buff, "%lld %lld\n", ts_local, ts_remote);
+	write(clock_context->debug_fd, buff, strlen(buff));
+#endif
+
+}
-- 
2.20.1

