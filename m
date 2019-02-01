Return-Path: <SRS0=aEXj=QI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA7DC282D8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 13:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 017552084C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 13:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730205AbfBANpr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Feb 2019 08:45:47 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35046 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbfBANpr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Feb 2019 08:45:47 -0500
Received: by mail-wr1-f65.google.com with SMTP id r17so1195430wrp.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Feb 2019 05:45:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DDPHLX9eaMTqLJQTXQMe9XyltETeW2phSskHN+UtqUk=;
        b=LOwFjnqVWpR7EWv+NU5tB6evYt6aWId5oCjBkhHeM5uZDDMXzQqnYJP2SoUQTywaak
         SABtX4iGCbceNcgJhsxEQ6B3/KSlW6PaRFlW0/EJfWhawXTu68KimYmkW0UJkPy+wnjT
         1bNJGz4lwpR67j9YVO6SrNB6Vgr53Z8/D6qBkVZjaPNdZNGJpEtitvVJ5y6fYAREfmwL
         E31t1EfaPXQnlSX/tDAERUELLBwtobynKHboa/PU60sZXIE8MiMCZpiGJjE85/eIZ7Qk
         WslDxrncl+CnXnnLXhAKkuRjCjuRm0qzHlkYzR+rFPMJqI43S40Mu7kz3EdjF2/26R8D
         KHgQ==
X-Gm-Message-State: AJcUukerGgEZ96qBp2/KeAYz+TsQSLEl9mukxlTLcsQ6svDp++NcQnkS
        viwLyjT0ZBQQFrOpHncwj8P6EvE1
X-Google-Smtp-Source: ALg8bN7AYx0k54538mfrQkxXC7Z8kv9aKEVW0Rrp6QOWV6lyJt3G9Oku+JBC9kJrWWGkaySOUIgfCQ==
X-Received: by 2002:adf:fdc2:: with SMTP id i2mr40082583wrs.117.1549028744094;
        Fri, 01 Feb 2019 05:45:44 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v26sm1468732wrv.78.2019.02.01.05.45.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Feb 2019 05:45:43 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 6/6] trace-cmd [POC]: Implemented timestamps synch PTP-like algorithm, using vsock events.
Date:   Fri,  1 Feb 2019 15:45:35 +0200
Message-Id: <20190201134535.2979-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190201134535.2979-1-tstoyanov@vmware.com>
References: <20190201134535.2979-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a POC patch, implementing a PTP-like algorithm for syncing timestamps between
host and guest machines, using vsock trace events to catch the host / guest time.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h  |   4 +
 tracecmd/include/trace-local.h |   5 +
 tracecmd/trace-listen.c        |   3 +
 tracecmd/trace-msg.c           | 307 +++++++++++++++++++++++++++++++--
 tracecmd/trace-record.c        | 207 +++++++++++++++++++++-
 5 files changed, 507 insertions(+), 19 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index da225b4..7f7e1fc 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -351,6 +351,10 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
 				 unsigned int **ports);
 
+int tracecmd_msg_rcv_time_sync(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_snd_time_sync(struct tracecmd_msg_handle *msg_handle,
+			       char *clock_str, long long *toffset);
+
 int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
 
 /* --- Plugin handling --- */
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 823d323..c502c70 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -225,6 +225,11 @@ void show_instance_file(struct buffer_instance *instance, const char *name);
 
 int count_cpus(void);
 
+struct buffer_instance *clock_synch_enable(int fd, char *clock,
+					   int *tx_event, int *rx_event);
+void clock_synch_disable(int fd, struct buffer_instance *instance);
+struct tep_handle *clock_synch_get_tep(struct buffer_instance *instance);
+
 /* No longer in event-utils.h */
 void __noreturn die(const char *fmt, ...); /* Can be overriden */
 void *malloc_or_die(unsigned int size); /* Can be overridden */
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 9b50147..7783a68 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -404,6 +404,9 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle)
 
 		msg_handle->version = V3_PROTOCOL;
 
+		/* time sync with the v3 client */
+		tracecmd_msg_rcv_time_sync(msg_handle);
+
 		/* read the CPU count, the page size, and options */
 		if ((pagesize = tracecmd_msg_initial_setting(msg_handle)) < 0)
 			goto out;
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 46b18aa..e264f10 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -18,9 +18,11 @@
 #include <stdarg.h>
 #include <string.h>
 #include <unistd.h>
+#include <time.h>
 #include <arpa/inet.h>
 #include <sys/types.h>
 #include <linux/types.h>
+#include <linux/vm_sockets.h>
 
 #include "trace-cmd-local.h"
 #include "trace-local.h"
@@ -28,6 +30,8 @@
 
 typedef __u32 u32;
 typedef __be32 be32;
+typedef __u64 u64;
+typedef __s64 s64;
 
 static inline void dprint(const char *fmt, ...)
 {
@@ -50,11 +54,20 @@ static inline void dprint(const char *fmt, ...)
 
 unsigned int page_size;
 
+/* Try a few times to get an accurate time sync */
+#define TSYNC_TRIES 5000
+#define TSYNC_TRESCH 10000
+
 struct tracecmd_msg_server {
 	struct tracecmd_msg_handle handle;
 	int			done;
 };
 
+struct clock_synch_event {
+	int			id;
+	unsigned long long	ts;
+};
+
 static struct tracecmd_msg_server *
 make_server(struct tracecmd_msg_handle *msg_handle)
 {
@@ -90,6 +103,16 @@ struct tracecmd_msg_trace_resp {
 	be32 page_size;
 } __attribute__((packed));
 
+struct tracecmd_msg_time_sync_init {
+	char clock[32];
+	s64  toffset;
+} __attribute__((packed));
+
+struct tracecmd_msg_time_sync {
+	u64 tlocal_rx;
+	u64 tlocal_tx;
+} __attribute__((packed));
+
 struct tracecmd_msg_header {
 	be32	size;
 	be32	cmd;
@@ -97,13 +120,15 @@ struct tracecmd_msg_header {
 } __attribute__((packed));
 
 #define MSG_MAP								\
-	C(CLOSE,	0,	0),					\
-	C(TINIT,	1,	sizeof(struct tracecmd_msg_tinit)),	\
-	C(RINIT,	2,	sizeof(struct tracecmd_msg_rinit)),	\
-	C(SEND_DATA,	3,	0),					\
-	C(FIN_DATA,	4,	0),					\
-	C(TRACE_REQ,	5,	sizeof(struct tracecmd_msg_trace_req)),	\
-	C(TRACE_RESP,	6,	sizeof(struct tracecmd_msg_trace_resp)),
+	C(CLOSE,		0, 0),					\
+	C(TINIT,		1, sizeof(struct tracecmd_msg_tinit)),	\
+	C(RINIT,		2, sizeof(struct tracecmd_msg_rinit)),	\
+	C(SEND_DATA,		3, 0),					\
+	C(FIN_DATA,		4, 0),					\
+	C(TRACE_REQ,		5, sizeof(struct tracecmd_msg_trace_req)),\
+	C(TRACE_RESP,		6, sizeof(struct tracecmd_msg_trace_resp)),\
+	C(TIME_SYNC_INIT,	7, sizeof(struct tracecmd_msg_time_sync_init)),\
+	C(TIME_SYNC,		8, sizeof(struct tracecmd_msg_time_sync)),
 
 #undef C
 #define C(a,b,c)	MSG_##a = b
@@ -133,10 +158,12 @@ static const char *cmd_to_name(int cmd)
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
+		struct tracecmd_msg_time_sync_init	time_sync_init;
+		struct tracecmd_msg_time_sync		time_sync;
 	};
 	union {
 		struct tracecmd_msg_opt		*opt;
@@ -825,6 +852,264 @@ out:
 	return ret;
 }
 
+static int
+find_events_in_page(struct tep_handle *pevent, void *page,
+		    int size, struct clock_synch_event *events)
+{
+	struct tep_event *event = NULL;
+	struct tep_record *last_record = NULL;
+	struct tep_record *record;
+	int id, i, j, cnt = 0;
+
+	if (size <= 0)
+		return 0;
+	for (i = 0; events[i].id; i++) {
+		if (!events[i].ts)
+			cnt++;
+	}
+
+	while (cnt) {
+		event = NULL;
+		record = tracecmd_read_page_record(pevent, page, size,
+						   last_record);
+		if (!record)
+			break;
+		free_record(last_record);
+		id = tep_data_type(pevent, record);
+		for (i = 0; events[i].id; i++)
+			if (!events[i].ts && events[i].id == id) {
+				event = tep_data_event_from_type(pevent, id);
+				break;
+			}
+		if (event) {
+			for (j = 0; j < i; j++)
+				if (events[j].ts && events[j].ts > record->ts)
+					break;
+			if (j == i) {
+				events[i].ts = record->ts;
+				cnt--;
+			}
+		}
+		last_record = record;
+	}
+	free_record(last_record);
+
+	return cnt;
+}
+
+static int clock_synch_find_events(struct tep_handle *tep,
+				   struct buffer_instance *instance,
+				   struct clock_synch_event *events)
+{
+	struct dirent *dent;
+	int ts = 0;
+	void *page;
+	char *path;
+	char *file;
+	DIR *dir;
+	int len;
+	int fd;
+	int r;
+
+	page_size = getpagesize();
+
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
+	page = malloc(page_size);
+	if (!file || !page)
+		die("Failed to allocate time_stamp info");
+
+	while ((dent = readdir(dir))) {
+
+		const char *name = dent->d_name;
+
+		if (strncmp(name, "cpu", 3) != 0)
+			continue;
+		sprintf(file, "%s/%s/trace_pipe_raw", path, name);
+		fd = open(file, O_RDONLY | O_NONBLOCK);
+		if (fd < 0)
+			continue;
+		do {
+			r = read(fd, page, page_size);
+			if (r > 0) {
+				ts = find_events_in_page(tep, page, r, events);
+				if (!ts)
+					break;
+			}
+		} while (r > 0);
+		close(fd);
+	}
+
+	free(file);
+	free(page);
+	closedir(dir);
+
+ out:
+	tracecmd_put_tracing_file(path);
+	return ts;
+}
+
+extern struct tep_handle *clock_synch_get_tep(struct buffer_instance *instance);
+
+int tracecmd_msg_rcv_time_sync(struct tracecmd_msg_handle *msg_handle)
+{
+	struct buffer_instance *vinst;
+	struct tracecmd_msg msg;
+	struct tep_handle *tep;
+	int ret;
+	char *clock;
+	struct clock_synch_event events[3];
+
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0 || ntohl(msg.hdr.cmd) != MSG_TIME_SYNC_INIT)
+		return 0;
+	if (!msg.time_sync_init.clock[0])
+		return 0;
+
+	clock = strdup(msg.time_sync_init.clock);
+	events[2].id = 0;
+	vinst = clock_synch_enable(msg_handle->fd, clock,
+				   &events[1].id, &events[0].id);
+	tep = clock_synch_get_tep(vinst);
+	tracecmd_msg_init(MSG_TIME_SYNC_INIT, &msg);
+	tracecmd_msg_send(msg_handle->fd, &msg);
+
+	do {
+		events[0].ts = 0;
+		events[1].ts = 0;
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+		if (ret < 0 || ntohl(msg.hdr.cmd) != MSG_TIME_SYNC)
+			break;
+
+		tracecmd_msg_send(msg_handle->fd, &msg);
+		clock_synch_find_events(tep, vinst, events);
+		tracecmd_msg_init(MSG_TIME_SYNC, &msg);
+		msg.time_sync.tlocal_tx = htonll(events[1].ts);
+		msg.time_sync.tlocal_rx = htonll(events[0].ts);
+		tracecmd_msg_send(msg_handle->fd, &msg);
+	} while (true);
+	clock_synch_disable(msg_handle->fd, vinst);
+	msg_free(&msg);
+	tep_free(tep);
+	free(clock);
+	return ret;
+}
+
+int tracecmd_msg_snd_time_sync(struct tracecmd_msg_handle *msg_handle,
+			       char *clock_str, long long *toffset)
+{
+	static struct buffer_instance *vinst;
+	struct clock_synch_event events[4];
+	long long *offsets, *replies;
+	struct tracecmd_msg msg_resp;
+	struct tracecmd_msg msg_req;
+	int sync_loop = TSYNC_TRIES;
+	long long ms_diff, sm_diff;
+	int j= 0, i = 0, ret = 0;
+	struct tep_handle *tep;
+	long long m_t1, m_t4;
+	long long s_t2, s_t3;
+	long long t_offs = 0;
+	long long min_p=0;
+	char *clock;
+
+	clock = clock_str;
+	if (!clock)
+		clock = "local";
+
+	tracecmd_msg_init(MSG_TIME_SYNC_INIT, &msg_req);
+	if (toffset == NULL) {
+		msg_req.time_sync_init.clock[0] = 0;
+		tracecmd_msg_send(msg_handle->fd, &msg_req);
+		return 0;
+	}
+	offsets = calloc(sizeof(long long), TSYNC_TRIES);
+	replies = calloc(sizeof(long long), TSYNC_TRIES);
+	if (!offsets || !replies) {
+		free(offsets);
+		free(replies);
+		return 0;
+	}
+
+	strncpy(msg_req.time_sync_init.clock, clock, 16);
+	tracecmd_msg_send(msg_handle->fd, &msg_req);
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg_resp);
+	if (ret < 0 || ntohl(msg_resp.hdr.cmd) != MSG_TIME_SYNC_INIT) {
+		free(offsets);
+		free(replies);
+		return 0;
+	}
+	events[3].id = 0;
+	vinst = clock_synch_enable(msg_handle->fd, clock_str,
+				   &events[0].id, &events[1].id);
+	tep = clock_synch_get_tep(vinst);
+	*toffset = 0;
+
+	do {
+		memset(&msg_resp, 0, sizeof(msg_resp));
+		events[0].ts = 0;
+		events[1].ts = 0;
+		events[2].ts = 0;
+		tracecmd_msg_init(MSG_TIME_SYNC, &msg_req);
+
+		tracecmd_msg_send(msg_handle->fd, &msg_req);
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg_resp);
+		if (ret < 0 || ntohl(msg_resp.hdr.cmd) != MSG_TIME_SYNC)
+			break;
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg_resp);
+		if (ret < 0 || ntohl(msg_resp.hdr.cmd) != MSG_TIME_SYNC)
+			break;
+		clock_synch_find_events(tep, vinst, events);
+		m_t1 = events[0].ts;
+		m_t4 = events[1].ts;
+		s_t2 = htonll(msg_resp.time_sync.tlocal_rx);
+		s_t3 = ntohll(msg_resp.time_sync.tlocal_tx);
+		if (!m_t1 || !m_t4 || !s_t2 || !s_t3)
+			continue;
+		if ( m_t1 >= m_t4) 
+			continue;
+		ms_diff = s_t2 - m_t1;
+		sm_diff = m_t4 - s_t3;
+		offsets[i] = (ms_diff - sm_diff)/2;
+		replies[i] = abs(sm_diff);
+		if (!min_p || min_p > replies[i])
+			min_p = replies[i];
+		i++;
+	} while (--sync_loop);
+	clock_synch_disable(msg_handle->fd, vinst);
+
+	for (i=0; i<TSYNC_TRIES; i++) {
+		if (replies[i] && replies[i] < (TSYNC_TRESCH+min_p)) {
+			t_offs += offsets[i];
+			j++;
+		}
+	}
+	if(j)
+		t_offs /= j;
+
+	tracecmd_msg_init(MSG_TIME_SYNC_INIT, &msg_req);
+	msg_req.time_sync_init.clock[0] = 0;
+	msg_req.time_sync_init.toffset = t_offs;
+	tracecmd_msg_send(msg_handle->fd, &msg_req);
+
+	msg_free(&msg_req);
+	msg_free(&msg_resp);
+	free(offsets);
+	free(replies);
+
+	*toffset = t_offs;
+
+	return ret;
+}
+
 static int make_trace_resp(struct tracecmd_msg *msg,
 			   int page_size, int nr_cpus, unsigned int *ports)
 {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 6d67858..af442fe 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3157,7 +3157,41 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 	}
 }
 
-static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instance)
+static void sync_time_with_listener_v3(struct tracecmd_msg_handle *msg_handle,
+				       struct common_record_context *ctx)
+{
+	struct buffer_instance	*instance;
+	long long toffset = 0;
+	char *clock = NULL;
+
+	instance = ctx->instance;
+	while (instance) {
+		clock = instance->clock;
+		if (clock)
+			break;
+		instance = instance->next;
+	}
+
+	if (ctx->data_flags & DATA_FL_DATE ||
+	    ctx->data_flags & DATA_FL_OFFSET) {
+		tracecmd_msg_snd_time_sync(msg_handle, clock, NULL);
+		return;
+	}
+
+	tracecmd_msg_snd_time_sync(msg_handle, clock, &toffset);
+
+	free(ctx->date2ts);
+	/* 20 digits + \0 */
+	ctx->date2ts = malloc(21);
+	if (ctx->date2ts) {
+		snprintf(ctx->date2ts, 21, "%lld", toffset);
+		ctx->data_flags |= DATA_FL_OFFSET;
+	}
+
+}
+
+static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instance,
+						 struct common_record_context *ctx)
 {
 	struct tracecmd_msg_handle *msg_handle = NULL;
 	struct addrinfo hints;
@@ -3292,12 +3326,13 @@ static void add_options(struct tracecmd_output *handle,
 }
 
 static struct tracecmd_msg_handle *
-setup_connection(struct buffer_instance *instance, struct common_record_context *ctx)
+setup_connection(struct buffer_instance *instance,
+		 struct common_record_context *ctx)
 {
 	struct tracecmd_msg_handle *msg_handle;
 	struct tracecmd_output *network_handle;
 
-	msg_handle = setup_network(instance);
+	msg_handle = setup_network(instance, ctx);
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
@@ -3324,7 +3359,8 @@ static void finish_network(struct tracecmd_msg_handle *msg_handle)
 	free(host);
 }
 
-static void connect_to_agent(struct buffer_instance *instance)
+static void connect_to_agent(struct buffer_instance *instance,
+			     struct common_record_context *ctx)
 {
 	struct tracecmd_msg_handle *msg_handle;
 	int sd, nr_cpus, page_size;
@@ -3350,9 +3386,12 @@ static void connect_to_agent(struct buffer_instance *instance)
 
 	/* the msg_handle now points to the guest fd */
 	instance->msg_handle = msg_handle;
+
+	tracecmd_msg_rcv_time_sync(msg_handle);
 }
 
-static void setup_guest(struct buffer_instance *instance)
+static void setup_guest(struct buffer_instance *instance,
+			struct common_record_context *ctx)
 {
 	struct tracecmd_msg_handle *msg_handle = instance->msg_handle;
 	char *file;
@@ -3374,10 +3413,13 @@ static void setup_guest(struct buffer_instance *instance)
 	close(fd);
 }
 
-static void setup_agent(struct buffer_instance *instance, struct common_record_context *ctx)
+static void setup_agent(struct buffer_instance *instance,
+			struct common_record_context *ctx)
 {
 	struct tracecmd_output *network_handle;
 
+	sync_time_with_listener_v3(instance->msg_handle, ctx);
+
 	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
 						     listed_events);
 	add_options(network_handle, ctx);
@@ -3397,7 +3439,7 @@ void start_threads(enum trace_type type, struct common_record_context *ctx)
 	for_all_instances(instance) {
 		/* Start the connection now to find out how many CPUs we need */
 		if (instance->flags & BUFFER_FL_GUEST)
-			connect_to_agent(instance);
+			connect_to_agent(instance, ctx);
 		total_cpu_count += instance->cpu_count;
 	}
 
@@ -3413,7 +3455,7 @@ void start_threads(enum trace_type type, struct common_record_context *ctx)
 		if (instance->flags & BUFFER_FL_AGENT) {
 			setup_agent(instance, ctx);
 		} else if (instance->flags & BUFFER_FL_GUEST) {
-			setup_guest(instance);
+			setup_guest(instance, ctx);
 		} else if (host) {
 			instance->msg_handle = setup_connection(instance, ctx);
 			if (!instance->msg_handle)
@@ -5769,3 +5811,152 @@ int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 	free(argv_plus);
 	return 0;
 }
+
+static void get_vsocket_params(int fd, int *lcid,
+			       int *lport, int *rcid, int *rport)
+{
+	struct sockaddr_vm addr;
+	socklen_t addr_len = sizeof(addr);
+
+	memset(&addr, 0, sizeof(addr));
+	if (getsockname(fd, (struct sockaddr *)&addr, &addr_len))
+		return;
+	if (addr.svm_family != AF_VSOCK)
+		return;
+	*lport = addr.svm_port;
+	*lcid = addr.svm_cid;
+
+	memset(&addr, 0, sizeof(addr));
+	addr_len = sizeof(addr);
+	if (getpeername(fd, (struct sockaddr *)&addr, &addr_len))
+		return;
+	if (addr.svm_family != AF_VSOCK)
+		return;
+
+	*rport = addr.svm_port;
+	*rcid = addr.svm_cid;
+}
+
+static void set_clock_synch_events(int cfd, struct buffer_instance *instance,
+				   bool enable, int *tx_event, int *rx_event)
+{
+	int lcid, lport, rcid, rport;
+	char buffer[255];
+	FILE *fp;
+	char *path;
+	int fd;
+
+	path = get_instance_file(instance, "events/vsock/enable");
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return;
+	if (enable)
+		write(fd, "1", 2);
+	else
+		write(fd, "0", 2);
+	close(fd);
+	tracecmd_put_tracing_file(path);
+
+	if (enable) {
+		get_vsocket_params(cfd, &lcid, &lport, &rcid, &rport);
+
+		snprintf(buffer, 255,
+			"src_cid==%d && src_port==%d && dst_cid==%d && dst_port==%d && len!=0",
+			rcid, rport, lcid, lport);
+		path = get_instance_file(instance,
+					 "events/vsock/virtio_transport_recv_pkt/filter");
+		fd = open(path, O_WRONLY);
+		write(fd, buffer, strlen(buffer)+1);
+		close(fd);
+		tracecmd_put_tracing_file(path);
+
+		snprintf(buffer, 255,
+			"src_cid==%d && src_port==%d && dst_cid==%d && dst_port==%d && len!=0",
+			lcid, lport, rcid, rport);
+		path = get_instance_file(instance,
+					 "events/vsock/virtio_transport_alloc_pkt/filter");
+		fd = open(path, O_WRONLY);
+		write(fd, buffer, strlen(buffer)+1);
+		close(fd);
+		tracecmd_put_tracing_file(path);
+
+		if (tx_event) {
+			path = get_instance_file(instance,
+						 "events/vsock/virtio_transport_alloc_pkt/id");
+			fp = fopen(path, "r");
+			fgets(buffer, 255, (FILE *) fp);
+			*tx_event = atoi(buffer);
+			fclose(fp);
+			tracecmd_put_tracing_file(path);
+		}
+		if (rx_event) {
+			path = get_instance_file(instance,
+						 "events/vsock/virtio_transport_recv_pkt/id");
+			fp = fopen(path, "r");
+			fgets(buffer, 255, (FILE *) fp);
+			*rx_event = atoi(buffer);
+			fclose(fp);
+			tracecmd_put_tracing_file(path);
+		}
+	}
+
+	path = get_instance_file(instance, "events/vsock/enable");
+
+	if (enable)
+		write_tracing_on(instance, 1);
+	else
+		write_tracing_on(instance, 0);
+}
+
+static void vsock_trace_reset(struct buffer_instance *vinst)
+{
+	char *path;
+	int fd;
+
+	path = get_instance_file(vinst, "trace");
+	fd = open(path, O_WRONLY);
+	tracecmd_put_tracing_file(path);
+	write(fd, "0", 2);
+	close(fd);
+}
+
+struct tep_handle *clock_synch_get_tep(struct buffer_instance *instance)
+{
+	struct tep_handle *tep = NULL;
+	char *systems[] = {"vsock", "kvm", NULL};
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
+struct buffer_instance *clock_synch_enable(int fd, char *clock,
+					   int *tx_event, int *rx_event)
+{
+	char inst_name[256];
+	struct buffer_instance *vinst;
+
+	snprintf(inst_name, 256, "clock_synch-%d", rand()%100);
+	vinst = create_instance(strdup(inst_name));
+	init_instance(vinst);
+	vinst->cpu_count = local_cpu_count;
+	make_one_instance(vinst);
+	vsock_trace_reset(vinst);
+	vinst->clock = strdup(clock);
+	set_clock(vinst);
+	set_clock_synch_events(fd, vinst, true, tx_event, rx_event);
+	return vinst;
+}
+
+void clock_synch_disable(int fd, struct buffer_instance *instance)
+{
+	set_clock_synch_events(fd, instance, false, NULL, NULL);
+	tracecmd_remove_one_instance(instance);
+	/* todo: clean up the instance */
+}
-- 
2.20.1

