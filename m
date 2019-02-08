Return-Path: <SRS0=blm6=QP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA98C282CB
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 13:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A06420869
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 13:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfBHNtf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:49:35 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51157 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbfBHNtf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Feb 2019 08:49:35 -0500
Received: by mail-wm1-f67.google.com with SMTP id z5so3504974wmf.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Feb 2019 05:49:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=No0GyVWGgDRVFOoljcUd65w2OkIUt2UOdbhqatIhwGI=;
        b=AOD6Gx+a5iEDGjvNs5VIc6Mv065tbJcC1jsxvCWEcjqlWlD5NSRUw0sy2+0pH/0AZf
         1+3jgy6x29G58aVyF/6hsQGDHJqiDtIUzXZFF3flNoqsKvqhYCXjbgBYkgSgVHr+PgS3
         u60VYh//N7DFSEB/vQiWUy68P+m7MaN17vu4tV6IwuB5eT8JcvHSIymOH9V+uvH/rSWS
         8ne5goqmTeEDkwoiCBGrQ/1pIpWJHSXtUJRdpz6iW89jq8D4oMpM7Ih7ebeCk7RAkoML
         j67y/5tFrKZlT8tjeExG/d7oEXCuDKocP2oWjVNXR+8hEQawkShgrfLjSfV+vOMQO131
         /vaw==
X-Gm-Message-State: AHQUAubMnH08AV+9xQudSYf+F8V2kKC7KAxOWqfsmCKPV8WwWLEnr0gB
        5Ied/9ns0eEOySW4uo/p/HI=
X-Google-Smtp-Source: AHgI3Ib4dOEsUBPQR9hKL1pW2SzljHr+Xu/mc08g1dSKT+3PmuobNuhSXPwIxXsg4/GClSl6uPzzYg==
X-Received: by 2002:a7b:c181:: with SMTP id y1mr11861017wmi.10.1549633771316;
        Fri, 08 Feb 2019 05:49:31 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a184sm2534796wmh.37.2019.02.08.05.49.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Feb 2019 05:49:30 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 7/7] trace-cmd [POC]: Implemented timestamps synch PTP-like algorithm, using vsock events.
Date:   Fri,  8 Feb 2019 15:49:18 +0200
Message-Id: <20190208134918.5618-8-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208134918.5618-1-tstoyanov@vmware.com>
References: <20190208134918.5618-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a POC patch, implementing a PTP-like algorithm
for syncing timestamps between host and guest machines,
using vsock trace events to catch the host / guest time.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h  |   4 +
 tracecmd/include/trace-local.h |   6 +
 tracecmd/trace-listen.c        |   3 +
 tracecmd/trace-msg.c           | 543 ++++++++++++++++++++++++++++++++-
 tracecmd/trace-record.c        | 234 +++++++++++++-
 5 files changed, 778 insertions(+), 12 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index b2ff6f9..b54ff18 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -351,6 +351,10 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
 				 unsigned int **ports, bool *use_fifos);
 
+int tracecmd_msg_rcv_time_sync(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_snd_time_sync(struct tracecmd_msg_handle *msg_handle,
+			       char *clock_str, long long *toffset);
+
 int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
 
 /* --- Plugin handling --- */
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 4f6e239..424986c 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -233,6 +233,12 @@ void show_instance_file(struct buffer_instance *instance, const char *name);
 
 int count_cpus(void);
 
+struct buffer_instance *clock_synch_enable(int fd, char *clock,
+					   int *tx_event, int *rx_event,
+					   int *kvm_exit);
+void clock_synch_disable(int fd, struct buffer_instance *instance);
+struct tep_handle *clock_synch_get_tep(struct buffer_instance *instance);
+void get_vsocket_params(int fd, int *lcid, int *lport, int *rcid, int *rport);
 #define VCPUS_MAX	256
 int *get_guest_vcpu_pids(int cid);
 
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
index c28d294..433814e 100644
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
@@ -50,11 +54,22 @@ static inline void dprint(const char *fmt, ...)
 
 unsigned int page_size;
 
+/* Try a few times to get an accurate time sync */
+#define TSYNC_TRIES 5000
+
 struct tracecmd_msg_server {
 	struct tracecmd_msg_handle handle;
 	int			done;
 };
 
+struct clock_synch_event {
+
+	int				id;
+	int				cpu;
+	int				pid;
+	unsigned long long		ts;
+};
+
 static struct tracecmd_msg_server *
 make_server(struct tracecmd_msg_handle *msg_handle)
 {
@@ -91,6 +106,19 @@ struct tracecmd_msg_trace_resp {
 	be32 page_size;
 } __attribute__((packed));
 
+struct tracecmd_msg_time_sync_init {
+	char clock[32];
+} __attribute__((packed));
+
+struct tracecmd_msg_time_sync {
+	u64 tlocal_rx;
+	u32 tlocal_rx_cpu;
+	u64 tlocal_kvmex;
+	u64 tlocal_kvmex_cpu;
+	u64 tlocal_tx;
+	u32 tlocal_tx_cpu;
+} __attribute__((packed));
+
 struct tracecmd_msg_header {
 	be32	size;
 	be32	cmd;
@@ -98,13 +126,15 @@ struct tracecmd_msg_header {
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
@@ -134,10 +164,12 @@ static const char *cmd_to_name(int cmd)
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
@@ -832,6 +864,495 @@ out:
 	return ret;
 }
 
+#define EVENTS_CHUNK	10
+static int
+get_events_in_page(struct tep_handle *tep, void *page,
+		    int size, int cpu, struct clock_synch_event **events,
+		    int *events_count, int *events_size)
+{
+	struct clock_synch_event *events_array = NULL;
+	struct tep_record *last_record = NULL;
+	struct tep_event *event = NULL;
+	struct tep_record *record;
+	int id, cnt = 0;
+
+	if (size <= 0)
+		return 0;
+
+	if (*events == NULL) {
+		*events = malloc(EVENTS_CHUNK*sizeof(struct clock_synch_event));
+		*events_size = EVENTS_CHUNK;
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
+					(*events_size + EVENTS_CHUNK)*sizeof(struct clock_synch_event));
+				if (events_array) {
+					*events = events_array;
+					(*events_size) += EVENTS_CHUNK;
+				}
+			}
+
+			if (*events_count < *events_size) {
+				(*events)[*events_count].ts = record->ts;
+				(*events)[*events_count].cpu = cpu;
+				(*events)[*events_count].id = id;
+				(*events)[*events_count].pid = tep_data_pid(tep, record);
+				(*events_count)++;
+			}
+		}
+		last_record = record;
+	}
+	free_record(last_record);
+
+	return cnt;
+}
+
+static int
+find_sync_events(struct tep_handle *pevent, struct clock_synch_event *recorded,
+		 int rsize, struct clock_synch_event *events)
+{
+	int i = 0, j = 0;
+
+	while (i < rsize) {
+		if (!events[j].ts && events[j].id == recorded[i].id &&
+			(!events[j].pid || events[j].pid == recorded[i].pid)) {
+			events[j].cpu = recorded[i].cpu;
+			events[j].ts = recorded[i].ts;
+			j++;
+		} else if (j > 0 && events[j-1].id == recorded[i].id &&
+			  (!events[j].pid || events[j].pid == recorded[i].pid)) {
+			events[j-1].cpu = recorded[i].cpu;
+			events[j-1].ts = recorded[i].ts;
+		}
+		i++;
+	}
+	return j;
+}
+
+
+static int
+find_events_in_page(struct tep_handle *pevent, void *page,
+		    int size, int cpu, struct clock_synch_event *events)
+{
+	struct tep_record *last_record = NULL;
+	struct tep_event *event = NULL;
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
+	while (true) {
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
+static int sync_events_cmp(const void *a, const void *b)
+{
+	const struct clock_synch_event *ea = (const struct clock_synch_event *)a;
+	const struct clock_synch_event *eb = (const struct clock_synch_event *)b;
+
+	if (ea->ts > eb->ts)
+		return 1;
+	if (ea->ts < eb->ts)
+		return -1;
+	return 0;
+}
+
+
+static int clock_synch_find_events(struct tep_handle *tep,
+				   struct buffer_instance *instance,
+				   struct clock_synch_event *events)
+{
+	struct clock_synch_event *events_array = NULL;
+	int events_count = 0;
+	int events_size = 0;
+	struct dirent *dent;
+	int ts = 0;
+	void *page;
+	char *path;
+	char *file;
+	DIR *dir;
+	int cpu;
+	int len;
+	int fd;
+	int r;
+
+	page_size = getpagesize();
+#if 0
+	file = get_instance_file(instance, "trace");
+	if (!file)
+		return ts;
+	{
+		char *buf = NULL;
+		FILE *fp;
+		size_t n;
+		int r;
+
+		fp = fopen(file, "r");
+		while ((r = getline(&buf, &n, fp)) >= 0) {
+
+			if (buf[0] != '#')
+				printf("%s", buf);
+
+			free(buf);
+			buf = NULL;
+		}
+		fclose(fp);
+	}
+	tracecmd_put_tracing_file(file);
+#endif
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
+		cpu = atoi(&name[3]);
+#if 0
+		{
+			char *buf = NULL;
+			FILE *fp;
+			size_t n;
+			int r;
+
+			printf("Buff [%s]:\n\r", name);
+			sprintf(file, "%s/%s/trace", path, name);
+			fp = fopen(file, "r");
+			while ((r = getline(&buf, &n, fp)) >= 0) {
+					if (buf[0] != '#')
+						printf("%s", buf);
+
+					free(buf);
+					buf = NULL;
+			}
+			printf("[Buff %s end]\n\r", name);
+		}
+#endif
+
+		sprintf(file, "%s/%s/trace_pipe_raw", path, name);
+		fd = open(file, O_RDONLY | O_NONBLOCK);
+		if (fd < 0)
+			continue;
+		do {
+			r = read(fd, page, page_size);
+			if (r > 0) {
+				get_events_in_page(tep, page, r, cpu,
+						   &events_array, &events_count,
+						   &events_size);
+			}
+		} while (r > 0);
+		close(fd);
+	}
+
+	qsort(events_array, events_count, sizeof(*events_array), sync_events_cmp);
+	r = find_sync_events(tep, events_array, events_count, events);
+
+	free(events_array);
+
+	free(file);
+	free(page);
+	closedir(dir);
+
+ out:
+	tracecmd_put_tracing_file(path);
+	return r;
+}
+
+extern struct tep_handle *clock_synch_get_tep(struct buffer_instance *instance);
+
+int tracecmd_msg_rcv_time_sync(struct tracecmd_msg_handle *msg_handle)
+{
+	struct clock_synch_event events[4];
+	struct buffer_instance *vinst;
+	struct tracecmd_msg msg;
+	struct tep_handle *tep;
+	int *cpu_pid = NULL;
+	int guest_cid = 0;
+	char *clock;
+	int ret;
+
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0 || ntohl(msg.hdr.cmd) != MSG_TIME_SYNC_INIT)
+		return 0;
+	if (!msg.time_sync_init.clock[0])
+		return 0;
+	clock = strdup(msg.time_sync_init.clock);
+	memset(events, 0, sizeof(struct clock_synch_event)*4);
+
+	get_vsocket_params(msg_handle->fd, NULL, NULL, &guest_cid, NULL);
+	if (guest_cid)
+		cpu_pid = get_guest_vcpu_pids(guest_cid);
+
+	vinst = clock_synch_enable(msg_handle->fd, clock,
+				   &events[2].id, &events[1].id, &events[0].id);
+	tep = clock_synch_get_tep(vinst);
+	tracecmd_msg_init(MSG_TIME_SYNC_INIT, &msg);
+	tracecmd_msg_send(msg_handle->fd, &msg);
+
+	do {
+		events[0].ts = 0;	/* kvm exit event */
+		events[1].ts = 0;	/* vsock receive event */
+		events[2].ts = 0;	/* vsock send event */
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+		if (ret < 0 || ntohl(msg.hdr.cmd) != MSG_TIME_SYNC)
+			break;
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+		if (ret < 0 || ntohl(msg.hdr.cmd) != MSG_TIME_SYNC)
+			break;
+		tracecmd_msg_send(msg_handle->fd, &msg);
+		/* Get kvm_exit events related to the corresponding VCPU */
+		if (cpu_pid && ntohl(msg.time_sync.tlocal_tx_cpu) < VCPUS_MAX)
+			events[0].pid = cpu_pid[ntohl(msg.time_sync.tlocal_tx_cpu)];
+		ret = clock_synch_find_events(tep, vinst, events);
+		tracecmd_msg_init(MSG_TIME_SYNC, &msg);
+		msg.time_sync.tlocal_tx = htonll(events[2].ts);
+		msg.time_sync.tlocal_tx_cpu = htonl(events[2].cpu);
+		msg.time_sync.tlocal_rx = htonll(events[1].ts);
+		msg.time_sync.tlocal_rx_cpu = htonl(events[1].cpu);
+		msg.time_sync.tlocal_kvmex = htonll(events[0].ts);
+		msg.time_sync.tlocal_kvmex_cpu = htonl(events[0].cpu);
+
+		tracecmd_msg_send(msg_handle->fd, &msg);
+	} while (true);
+	clock_synch_disable(msg_handle->fd, vinst);
+	msg_free(&msg);
+	tep_free(tep);
+	free(clock);
+	return 0;
+}
+
+int tracecmd_msg_snd_time_sync(struct tracecmd_msg_handle *msg_handle,
+			       char *clock_str, long long *toffset)
+{
+	static struct buffer_instance *vinst;
+	struct clock_synch_event events_s[2];
+	struct clock_synch_event events[4];
+	long long *kvm_offsets, kvm_offset_av = 0;
+	int j = 0, i = 0, k = 0, ret = 0;
+	long long min_p = 0, max_p = 0;
+	long long min_kvm = 0, max_kvm = 0;
+	long long *offsets, *replies;
+	struct tracecmd_msg msg_resp;
+	struct tracecmd_msg msg_req;
+	int sync_loop = TSYNC_TRIES;
+	long long ms_diff, sm_diff;
+	long long kvm_tresch = 0;
+	struct tep_handle *tep;
+	long long m_t1, m_t4;
+	long long s_t2, s_t3;
+	long long ptp_offs = 0;
+	long long ptp_tresch = 0;
+	long long kvm_offs = 0;
+	long long repl_av = 0;
+	long long s_t2_kvm = 0;
+	char *clock;
+	char *str_offs = NULL;
+/* Write all ts in a file, used to analyze the raw data */
+int iFd;
+char buff[256];
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
+	kvm_offsets = calloc(sizeof(long long), TSYNC_TRIES);
+	if (!offsets || !replies || !kvm_offsets) {
+		free(offsets);
+		free(replies);
+		free(kvm_offsets);
+		return 0;
+	}
+
+	strncpy(msg_req.time_sync_init.clock, clock, 16);
+	tracecmd_msg_send(msg_handle->fd, &msg_req);
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg_resp);
+	if (ret < 0 || ntohl(msg_resp.hdr.cmd) != MSG_TIME_SYNC_INIT) {
+		free(offsets);
+		free(replies);
+		free(kvm_offsets);
+		return 0;
+	}
+	memset(events, 0, sizeof(struct clock_synch_event)*4);
+	memset(events_s, 0, sizeof(struct clock_synch_event)*2);
+	vinst = clock_synch_enable(msg_handle->fd, clock_str,
+				   &events[0].id, &events[1].id, NULL);
+	events[2].id = events[1].id;
+	events_s[0].id = events[0].id;
+	tep = clock_synch_get_tep(vinst);
+	*toffset = 0;
+
+sprintf(buff, "s-%s.txt", clock);
+iFd = open(buff, O_CREAT|O_WRONLY|O_TRUNC, 0644);
+
+	do {
+		memset(&msg_resp, 0, sizeof(msg_resp));
+		events[0].ts = 0;	/* vsock send event */
+		events[1].ts = 0;	/* vsock receive event */
+		events[2].ts = 0;	/* vsock receive event */
+		events_s[0].ts = 0;	/* vsock send event */
+		tracecmd_msg_init(MSG_TIME_SYNC, &msg_req);
+
+		tracecmd_msg_send(msg_handle->fd, &msg_req);
+		/* Get the ts and CPU of the send event */
+		clock_synch_find_events(tep, vinst, events_s);
+		tracecmd_msg_init(MSG_TIME_SYNC, &msg_req);
+		msg_req.time_sync.tlocal_tx = htonll(events_s[0].ts);
+		msg_req.time_sync.tlocal_tx_cpu = htonl(events_s[0].cpu);
+		tracecmd_msg_send(msg_handle->fd, &msg_req);
+
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg_resp);
+		if (ret < 0 || ntohl(msg_resp.hdr.cmd) != MSG_TIME_SYNC)
+			break;
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg_resp);
+		if (ret < 0 || ntohl(msg_resp.hdr.cmd) != MSG_TIME_SYNC)
+			break;
+		ret = clock_synch_find_events(tep, vinst, events);
+		m_t1 = events[0].ts; /* Server vsock send ts */
+		m_t4 = events[1].ts; /* Server vsock receive ts */
+		s_t2 = htonll(msg_resp.time_sync.tlocal_rx); /* Client vsock receive ts */
+		s_t3 = ntohll(msg_resp.time_sync.tlocal_tx); /* Client vsock send ts */
+		s_t2_kvm = htonll(msg_resp.time_sync.tlocal_kvmex); /* Client kvm exit ts */
+		if (!m_t1 || !m_t4 || !s_t2 || !s_t3 || !s_t2_kvm)
+			continue;
+		if (m_t1 >= m_t4 || s_t2 >= s_t3)
+			continue;
+		/* PTP calc*/
+		ms_diff = s_t2 - m_t1;
+		sm_diff = m_t4 - s_t3;
+		offsets[i] = (ms_diff - sm_diff)/2;
+		replies[i] = llabs(sm_diff);
+		repl_av += replies[i];
+		if (!min_p || min_p > replies[i])
+			min_p = replies[i];
+		if (!max_p || max_p < replies[i])
+			max_p = replies[i];
+
+		/* KVM calc*/
+		kvm_offsets[i] = s_t2_kvm - m_t1;
+		kvm_offset_av += kvm_offsets[i];
+		if (!min_kvm || min_kvm > llabs(kvm_offsets[i]))
+			min_kvm = llabs(kvm_offsets[i]);
+		if (!max_kvm || max_kvm < llabs(kvm_offsets[i]))
+			max_kvm = llabs(kvm_offsets[i]);
+		i++;
+sprintf(buff, "%lld %lld %lld %lld %lld\n", m_t1, s_t2, s_t3, m_t4, s_t2_kvm);
+write(iFd, buff, strlen(buff));
+	} while (--sync_loop);
+close(iFd);
+	clock_synch_disable(msg_handle->fd, vinst);
+	repl_av /= (long long)i;
+	ptp_tresch = (long long)((max_p - min_p)/10);
+	kvm_offset_av /= (long long)i;
+	kvm_tresch = (long long)((max_kvm - min_kvm)/10);
+	for (i = 0; i < TSYNC_TRIES; i++) {
+		/* PTP: filter the replies with deviation up to 10% */
+		if (replies[i] && llabs(replies[i] - repl_av) < ptp_tresch) {
+			ptp_offs += offsets[i];
+			j++;
+		}
+		/* KVM: filter the offsets with deviation up to 10% */
+		if (kvm_offsets[i] &&
+		    llabs(kvm_offsets[i] - kvm_offset_av) < kvm_tresch) {
+			kvm_offs += kvm_offsets[i];
+			k++;
+		}
+	}
+	if (j)
+		ptp_offs /= (long long)j;
+	if (k)
+		kvm_offs /= (long long)k;
+
+	tracecmd_msg_init(MSG_TIME_SYNC_INIT, &msg_req);
+	msg_req.time_sync_init.clock[0] = 0;
+	tracecmd_msg_send(msg_handle->fd, &msg_req);
+
+	msg_free(&msg_req);
+	msg_free(&msg_resp);
+	free(offsets);
+	free(replies);
+	free(kvm_offsets);
+#if 1
+	/* Write PTP offset in the trace file */
+	*toffset = ptp_offs;
+	str_offs = "PTP";
+#else
+	/* Write KVM offset in the trace file */
+	*toffset = kvm_offs;
+	str_offs = "KVM";
+#endif
+	printf("\n selected: %lld (%s offset), delta %lld, used clock %s\n\r",
+		*toffset, str_offs, ptp_offs-kvm_offs, clock);
+	printf("\t PTP: %lld, good probes: %d, threshold %lld\n\r",
+		ptp_offs, j, ptp_tresch);
+	printf("\t KVM: %lld, good probes: %d, threshold %lld\n\r",
+			kvm_offs, k, kvm_tresch);
+
+	return 0;
+}
+
 static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
 			   unsigned int *ports, bool use_fifos)
 {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ab3f97e..b170b6e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3216,6 +3216,39 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 	}
 }
 
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
 static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instance)
 {
 	struct tracecmd_msg_handle *msg_handle = NULL;
@@ -3453,6 +3486,8 @@ static void connect_to_agent(struct buffer_instance *instance)
 
 	/* the msg_handle now points to the guest fd */
 	instance->msg_handle = msg_handle;
+
+	tracecmd_msg_rcv_time_sync(msg_handle);
 }
 
 static void setup_guest(struct buffer_instance *instance)
@@ -3477,10 +3512,13 @@ static void setup_guest(struct buffer_instance *instance)
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
@@ -5879,3 +5917,197 @@ int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 	free(argv_plus);
 	return 0;
 }
+
+void get_vsocket_params(int fd, int *lcid,
+			int *lport, int *rcid, int *rport)
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
+static void set_clock_synch_events(int cfd, struct buffer_instance *instance,
+				   bool enable, int *tx_event, int *rx_event,
+				   int *kvm_exit)
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
+#if 1
+	/* Filter EPT_MISCONFIG exit reason */
+	snprintf(buffer, 255, "exit_reason==49");
+	path = get_instance_file(instance,
+				 "events/kvm/kvm_exit/filter");
+	fd = open(path, O_WRONLY);
+	if (fd > 0) {
+		write(fd, buffer, strlen(buffer)+1);
+		close(fd);
+	}
+	tracecmd_put_tracing_file(path);
+
+
+	path = get_instance_file(instance, "events/kvm/kvm_exit/enable");
+	fd = open(path, O_WRONLY);
+	if (fd > 0) {
+		if (enable)
+			write(fd, "1", 2);
+		else
+			write(fd, "0", 2);
+		close(fd);
+	}
+	tracecmd_put_tracing_file(path);
+	if (kvm_exit) {
+		path = get_instance_file(instance,
+					 "events/kvm/kvm_exit/id");
+		fp = fopen(path, "r");
+		if (fp) {
+			fgets(buffer, 255, (FILE *) fp);
+			*kvm_exit = atoi(buffer);
+			fclose(fp);
+		}
+		tracecmd_put_tracing_file(path);
+	}
+#endif
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
+	char *systems[] = {"vsock", "kvm", NULL};
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
+struct buffer_instance *clock_synch_enable(int fd, char *clock,
+					   int *tx_event, int *rx_event,
+					   int *kvm_exit)
+{
+	struct buffer_instance *vinst;
+	char inst_name[256];
+
+	snprintf(inst_name, 256, "clock_synch-%d", rand()%100);
+	vinst = create_instance(strdup(inst_name));
+	init_instance(vinst);
+	vinst->cpu_count = local_cpu_count;
+	make_one_instance(vinst);
+	vsock_trace_reset(vinst);
+	vinst->clock = strdup(clock);
+	set_clock(vinst);
+	set_clock_synch_events(fd, vinst, true, tx_event, rx_event, kvm_exit);
+	return vinst;
+}
+
+void clock_synch_disable(int fd, struct buffer_instance *instance)
+{
+	set_clock_synch_events(fd, instance, false, NULL, NULL, NULL);
+	tracecmd_remove_one_instance(instance);
+	/* todo: clean up the instance */
+}
-- 
2.20.1

