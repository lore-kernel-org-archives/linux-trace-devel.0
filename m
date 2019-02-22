Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6F6C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 376A02075A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfBVO2s (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:28:48 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38430 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfBVO2r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 09:28:47 -0500
Received: by mail-wr1-f67.google.com with SMTP id v13so2603663wrw.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 06:28:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FpmFn+eSKyDCh89HNlwUJFpBfqqHYHWj1ZJ8cKffFu8=;
        b=QUSEngevR69CEmC+B3jxcl6DGif5D+KKR8SPpM60c+bAtkTiC/tzfx2/2NCSSva97n
         ydy9x3w8u//HT4K05T4JqSCO8/Y3muwF29hvc+rTebIVXkeJH+I0RGdZqYV7K7XfQkrc
         khr6333CBo37J8ziv/y5fD69Ap1611R2wRWSpO17OzD47R8NhpO3+TBvMSggnqnwA3YP
         CtlP8lFS682VrDA++znoyHcCkgwI2gaX1BGeZn9viVgtMRECLOSAh/G/JppSKjrqzRvp
         SwiBpENW6uRNLzCgImo9aexzVEChIR4VT0Cjzp+yv2U3n5+wFq+IpxBv2dQM9ZqeUfuX
         HH8w==
X-Gm-Message-State: AHQUAuYKtFEkqqQOxDQdLc3Uy8ND4nvWjpYMurwZX6UNAZazrGCvqydJ
        sJeW/cg0HxXYYCktVr+Byg4=
X-Google-Smtp-Source: AHgI3IaJ0vuPInTYDxJGpviyMZ1VyuGCTnNyoSiXvV1YHP6cwrTyd9RwChxjn1Eq9zlTMBcGkuOoJw==
X-Received: by 2002:a5d:500e:: with SMTP id e14mr3034824wrt.219.1550845724575;
        Fri, 22 Feb 2019 06:28:44 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q9sm848987wrv.26.2019.02.22.06.28.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Feb 2019 06:28:43 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 7/7] trace-cmd [POC]: Implemented timestamps synch algorithm, using vsock events.
Date:   Fri, 22 Feb 2019 16:28:36 +0200
Message-Id: <20190222142836.12596-8-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222142836.12596-1-tstoyanov@vmware.com>
References: <20190222142836.12596-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a POC patch, implementing an algorithm for syncing
timestamps between host and guest machines, using vsock
trace events to catch the host / guest time.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h  |   4 +
 tracecmd/include/trace-local.h |  13 +
 tracecmd/trace-listen.c        |   3 +
 tracecmd/trace-msg.c           | 477 ++++++++++++++++++++++++++++++++-
 tracecmd/trace-record.c        | 156 ++++++++++-
 5 files changed, 634 insertions(+), 19 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 3f0ab4f..5469dee 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -346,6 +346,10 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
 				 unsigned int **ports, bool *use_fifos);
 
+int tracecmd_msg_rcv_time_sync(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_snd_time_sync(struct tracecmd_msg_handle *msg_handle,
+			       char *clock_str, long long *toffset);
+
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index ef6848f..948cb06 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -236,6 +236,19 @@ void show_instance_file(struct buffer_instance *instance, const char *name);
 
 int count_cpus(void);
 
+struct clock_synch_event_descr {
+	char *file;
+	char *set;
+	char *reset;
+};
+struct buffer_instance *clock_synch_enable(char *clock, unsigned int cid,
+					   struct clock_synch_event_descr *events);
+void clock_synch_disable(struct buffer_instance *instance,
+			 struct clock_synch_event_descr *events);
+struct tep_handle *clock_synch_get_tep(struct buffer_instance *instance,
+				       char **systems);
+void get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
+			unsigned int *rcid, unsigned int *rport);
 #define VCPUS_MAX	256
 int *get_guest_vcpu_pids(int cid);
 
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 8bd7bad..7103a88 100644
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
index 065a01e..fddd327 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -18,16 +18,22 @@
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
 #include "trace-msg.h"
 
+typedef __u16 u16;
+typedef __s16 s16;
 typedef __u32 u32;
 typedef __be32 be32;
+typedef __u64 u64;
+typedef __s64 s64;
 
 static inline void dprint(const char *fmt, ...)
 {
@@ -50,6 +56,16 @@ static inline void dprint(const char *fmt, ...)
 
 unsigned int page_size;
 
+/* Try a few times to get an accurate time sync */
+#define TSYNC_TRIES 300
+
+struct clock_synch_event {
+	int			id;
+	int			cpu;
+	int			pid;
+	unsigned long long	ts;
+};
+
 struct tracecmd_msg_opt {
 	be32 size;
 	be32 opt_cmd;
@@ -76,6 +92,15 @@ struct tracecmd_msg_trace_resp {
 	be32 page_size;
 } __attribute__((packed));
 
+struct tracecmd_msg_time_sync_init {
+	char clock[32];
+} __attribute__((packed));
+
+struct tracecmd_msg_time_sync {
+	u64 tlocal_ts;
+	u16 tlocal_cpu;
+} __attribute__((packed));
+
 struct tracecmd_msg_header {
 	be32	size;
 	be32	cmd;
@@ -83,14 +108,16 @@ struct tracecmd_msg_header {
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
+	C(TIME_SYNC_INIT, 8,	sizeof(struct tracecmd_msg_time_sync_init)),\
+	C(TIME_SYNC,	  9,	sizeof(struct tracecmd_msg_time_sync)),
 
 #undef C
 #define C(a,b,c)	MSG_##a = b
@@ -120,10 +147,12 @@ static const char *cmd_to_name(int cmd)
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
@@ -859,6 +888,430 @@ out:
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
+			  (!events[j-1].pid || events[j-1].pid == recorded[i].pid)) {
+			events[j-1].cpu = recorded[i].cpu;
+			events[j-1].ts = recorded[i].ts;
+		}
+		i++;
+	}
+	return j;
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
+
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
+	qsort(events_array, events_count, sizeof(*events_array), sync_events_cmp);
+	r = find_sync_events(tep, events_array, events_count, events);
+#ifdef TSYNC_RBUFFER_DEBUG
+	len = 0;
+	while (events[len].id) {
+		printf("Found %d @ cpu %d: %lld\n\r",
+			events[len].id,  events[len].cpu, events[len].ts);
+		len++;
+	}
+#endif
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
+int tracecmd_msg_rcv_time_sync(struct tracecmd_msg_handle *msg_handle)
+{
+	unsigned int lcid, lport, rcid, rport;
+	struct clock_synch_event events[3];
+	struct buffer_instance *vinst;
+	char vsock_rx_filter[255];
+	struct tep_event *event;
+	struct tracecmd_msg msg;
+	struct tep_handle *tep;
+	int *cpu_pid = NULL;
+	int ret, cpu;
+	char *clock;
+	char *systems[] = {"vsock", "kvm", NULL};
+	struct clock_synch_event_descr events_descr[] = {
+		{"events/kvm/kvm_exit/enable", "1", "0"},
+		{"events/vsock/virtio_transport_recv_pkt/enable", "1", "0"},
+		{"events/vsock/virtio_transport_recv_pkt/filter", vsock_rx_filter, "\0"},
+		{NULL, NULL, NULL}
+	};
+
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0 || ntohl(msg.hdr.cmd) != MSG_TIME_SYNC_INIT)
+		return 0;
+	if (!msg.time_sync_init.clock[0])
+		return 0;
+	clock = strdup(msg.time_sync_init.clock);
+	memset(events, 0, sizeof(struct clock_synch_event)*3);
+
+	rcid = 0;
+	get_vsocket_params(msg_handle->fd, &lcid, &lport, &rcid, &rport);
+	if (rcid)
+		cpu_pid = get_guest_vcpu_pids(rcid);
+	snprintf(vsock_rx_filter, 255,
+		"src_cid==%u && src_port==%u && dst_cid==%u && dst_port==%u && len!=0",
+		rcid, rport, lcid, lport);
+
+	vinst = clock_synch_enable(clock, rcid, events_descr);
+	tep = clock_synch_get_tep(vinst, systems);
+	event = tep_find_event_by_name(tep, "kvm", "kvm_exit");
+	if (event)
+		events[0].id = event->id;
+	event = tep_find_event_by_name(tep, "vsock", "virtio_transport_recv_pkt");
+	if (event)
+		events[1].id = event->id;
+	tracecmd_msg_init(MSG_TIME_SYNC_INIT, &msg);
+	tracecmd_msg_send(msg_handle->fd, &msg);
+
+	do {
+		events[0].ts = 0;	/* kvm exit ts */
+		events[0].pid = 0;
+		events[1].ts = 0;	/* vsock receive ts */
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+		if (ret < 0 || ntohl(msg.hdr.cmd) != MSG_TIME_SYNC)
+			break;
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+		if (ret < 0 || ntohl(msg.hdr.cmd) != MSG_TIME_SYNC)
+			break;
+		/* Get kvm_exit events related to the corresponding VCPU */
+		cpu = ntohs(msg.time_sync.tlocal_cpu);
+		if (cpu_pid && cpu < VCPUS_MAX)
+			events[0].pid = cpu_pid[cpu];
+		ret = clock_synch_find_events(tep, vinst, events);
+		tracecmd_msg_init(MSG_TIME_SYNC, &msg);
+		msg.time_sync.tlocal_ts = htonll(events[0].ts);
+		tracecmd_msg_send(msg_handle->fd, &msg);
+	} while (true);
+	clock_synch_disable(vinst, events_descr);
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
+	struct clock_synch_event events_s[3];
+	struct tracecmd_msg msg_resp;
+	struct tracecmd_msg msg_req;
+	int sync_loop = TSYNC_TRIES;
+	long long min = 0, max = 0;
+	long long  offset_av = 0;
+	struct tep_event *event;
+	struct tep_handle *tep;
+	int k = 0, n, ret = 0;
+	long long tresch = 0;
+	long long offset = 0;
+	long long m_t1 = 0;
+	long long s_t2 = 0;
+	long long *offsets;
+	int probes = 0;
+	char *clock;
+	char vsock_tx_filter[255];
+	unsigned int lcid, lport, rcid, rport;
+	char *systems[] = {"vsock", "ftrace", NULL};
+	struct clock_synch_event_descr events_descr[] = {
+		{"set_ftrace_filter", "vp_notify", "\0"},
+		{"current_tracer", "function", "nop"},
+		{"events/vsock/virtio_transport_alloc_pkt/enable", "1", "0"},
+		{"events/vsock/virtio_transport_alloc_pkt/filter", vsock_tx_filter, "\0"},
+		{NULL, NULL, NULL}
+	};
+#ifdef TSYNC_DEBUG
+/* Write all ts in a file, used to analyze the raw data */
+	struct timespec tsStart, tsEnd;
+	int zm = 0, zs = 0;
+	long long duration;
+	char buff[256];
+	int iFd;
+#endif
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
+	if (!offsets)
+		return 0;
+
+	strncpy(msg_req.time_sync_init.clock, clock, 32);
+	tracecmd_msg_send(msg_handle->fd, &msg_req);
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg_resp);
+	if (ret < 0 || ntohl(msg_resp.hdr.cmd) != MSG_TIME_SYNC_INIT) {
+		free(offsets);
+		return 0;
+	}
+	get_vsocket_params(msg_handle->fd, &lcid, &lport, &rcid, &rport);
+	snprintf(vsock_tx_filter, 255,
+		"src_cid==%u && src_port==%u && dst_cid==%u && dst_port==%u && len!=0",
+		lcid, lport, rcid, rport);
+
+	memset(events_s, 0, sizeof(struct clock_synch_event)*3);
+	vinst = clock_synch_enable(clock_str, rcid, events_descr);
+	tep = clock_synch_get_tep(vinst, systems);
+	event = tep_find_event_by_name(tep, "vsock", "virtio_transport_alloc_pkt");
+	if (event)
+		events_s[0].id = event->id;
+	event = tep_find_event_by_name(tep, "ftrace", "function");
+	if (event)
+		events_s[1].id = event->id;
+
+	*toffset = 0;
+#ifdef TSYNC_DEBUG
+	sprintf(buff, "s-%s.txt", clock);
+	iFd = open(buff, O_CREAT|O_WRONLY|O_TRUNC, 0644);
+	clock_gettime(CLOCK_MONOTONIC, &tsStart);
+#endif
+	do {
+		memset(&msg_resp, 0, sizeof(msg_resp));
+		events_s[0].ts = 0;	/* vsock send ts */
+		events_s[0].cpu = 0;
+		events_s[1].ts = 0;	/* vp_notify ts */
+		events_s[1].cpu = 0;
+		tracecmd_msg_init(MSG_TIME_SYNC, &msg_req);
+		tracecmd_msg_send(msg_handle->fd, &msg_req);
+		/* Get the ts and CPU of the sent event */
+		clock_synch_find_events(tep, vinst, events_s);
+		tracecmd_msg_init(MSG_TIME_SYNC, &msg_req);
+		msg_req.time_sync.tlocal_ts = htonll(events_s[0].ts);
+		msg_req.time_sync.tlocal_cpu = htons(events_s[0].cpu);
+		tracecmd_msg_send(msg_handle->fd, &msg_req);
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg_resp);
+		if (ret < 0 || ntohl(msg_resp.hdr.cmd) != MSG_TIME_SYNC)
+			break;
+		m_t1 = events_s[1].ts;
+		s_t2 = htonll(msg_resp.time_sync.tlocal_ts); /* Client kvm exit ts */
+#ifdef TSYNC_DEBUG
+		if (!s_t2)
+			zs++;
+		if (!m_t1)
+			zm++;
+#endif
+		if (!s_t2 || !m_t1)
+			continue;
+		offsets[probes] = s_t2 - m_t1;
+		offset_av += offsets[probes];
+		if (!min || min > llabs(offsets[probes]))
+			min = llabs(offsets[probes]);
+		if (!max || max < llabs(offsets[probes]))
+			max = llabs(offsets[probes]);
+		probes++;
+#ifdef TSYNC_DEBUG
+		sprintf(buff, "%lld %lld\n", m_t1, s_t2);
+		write(iFd, buff, strlen(buff));
+#endif
+	} while (--sync_loop);
+
+#ifdef TSYNC_DEBUG
+	clock_gettime(CLOCK_MONOTONIC, &tsEnd);
+	close(iFd);
+#endif
+	clock_synch_disable(vinst, events_descr);
+	if (probes)
+		offset_av /= (long long)probes;
+	tresch = (long long)((max - min)/10);
+	for (n = 0; n < TSYNC_TRIES; n++) {
+		/* filter the offsets with deviation up to 10% */
+		if (offsets[n] &&
+		    llabs(offsets[n] - offset_av) < tresch) {
+			offset += offsets[n];
+			k++;
+		}
+	}
+	if (k)
+		offset /= (long long)k;
+
+	tracecmd_msg_init(MSG_TIME_SYNC_INIT, &msg_req);
+	msg_req.time_sync_init.clock[0] = 0;
+	tracecmd_msg_send(msg_handle->fd, &msg_req);
+
+	msg_free(&msg_req);
+	msg_free(&msg_resp);
+	free(offsets);
+
+	*toffset = offset;
+
+#ifdef TSYNC_DEBUG
+	duration = tsEnd.tv_sec * 1000000000LL;
+	duration += tsEnd.tv_nsec;
+	duration -= (tsStart.tv_sec * 1000000000LL);
+	duration -= tsStart.tv_nsec;
+
+	printf("\n selected: %lld (in %lld ns), used %s clock, %d probes\n\r",
+		*toffset, duration, clock, probes);
+	printf("\t good probes: %d / %d, threshold %lld, Zm %d, Zs %d\n\r",
+			k, TSYNC_TRIES, tresch, zm, zs);
+#endif
+	return 0;
+}
+
 static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
 			   unsigned int *ports, bool use_fifos)
 {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 59f0197..21be253 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -224,6 +224,12 @@ struct common_record_context {
 	int run_command;
 };
 
+enum {
+	DATA_FL_NONE		= 0,
+	DATA_FL_DATE		= 1,
+	DATA_FL_OFFSET		= 2,
+};
+
 static void add_reset_file(const char *file, const char *val, int prio)
 {
 	struct reset_file *reset;
@@ -3215,6 +3221,39 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
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
+	/* 21 digits + \0 */
+	ctx->date2ts = malloc(22);
+	if (ctx->date2ts) {
+		snprintf(ctx->date2ts, 22, "%lld", toffset);
+		ctx->data_flags |= DATA_FL_OFFSET;
+	}
+
+}
+
 static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instance)
 {
 	struct tracecmd_msg_handle *msg_handle = NULL;
@@ -3406,6 +3445,8 @@ static void connect_to_agent(struct buffer_instance *instance)
 
 	/* the msg_handle now points to the guest fd */
 	instance->msg_handle = msg_handle;
+
+	tracecmd_msg_rcv_time_sync(msg_handle);
 }
 
 static void setup_guest(struct buffer_instance *instance)
@@ -3430,10 +3471,13 @@ static void setup_guest(struct buffer_instance *instance)
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
@@ -3620,12 +3664,6 @@ static void print_stat(struct buffer_instance *instance)
 		trace_seq_do_printf(&instance->s_print[cpu]);
 }
 
-enum {
-	DATA_FL_NONE		= 0,
-	DATA_FL_DATE		= 1,
-	DATA_FL_OFFSET		= 2,
-};
-
 static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
 {
 	int type = 0;
@@ -5895,3 +5933,107 @@ int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 	free(argv_plus);
 	return 0;
 }
+
+void get_vsocket_params(int fd, unsigned int *lcid, unsigned int *lport,
+			unsigned int *rcid, unsigned int *rport)
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
+static void set_clock_synch_events(struct buffer_instance *instance,
+				   struct clock_synch_event_descr *events,
+				   bool enable)
+{
+	int i = 0;
+
+	if (!enable)
+		write_tracing_on(instance, 0);
+
+	while (events[i].file) {
+		if (enable && events[i].set)
+			write_instance_file(instance, events[i].file,
+					    events[i].set, NULL);
+		if (!enable && events[i].reset)
+			write_instance_file(instance, events[i].file,
+					    events[i].reset, NULL);
+		i++;
+	}
+
+	if (enable)
+		write_tracing_on(instance, 1);
+}
+
+static void vsock_trace_reset(struct buffer_instance *vinst)
+{
+	write_instance_file(vinst, "trace", "\0", NULL);
+}
+
+struct tep_handle *clock_synch_get_tep(struct buffer_instance *instance, char **systems)
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
+struct buffer_instance *clock_synch_enable(char *clock, unsigned int cid,
+					   struct clock_synch_event_descr *events)
+{
+	struct buffer_instance *vinst;
+	char inst_name[256];
+
+	snprintf(inst_name, 256, "clock_synch-%d", cid);
+
+	vinst = create_instance(strdup(inst_name));
+	init_instance(vinst);
+	vinst->cpu_count = local_cpu_count;
+	make_instance(vinst);
+	vsock_trace_reset(vinst);
+	if (clock)
+		vinst->clock = strdup(clock);
+	set_clock(vinst);
+	set_clock_synch_events(vinst, events, true);
+	return vinst;
+}
+
+void clock_synch_disable(struct buffer_instance *instance,
+			 struct clock_synch_event_descr *events)
+{
+	set_clock_synch_events(instance, events, false);
+	tracecmd_remove_instance(instance);
+	/* todo: clean up the instance */
+}
-- 
2.20.1

