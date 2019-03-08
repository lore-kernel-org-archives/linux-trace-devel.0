Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD02BC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 691D620661
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfCHNoi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:44:38 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41404 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbfCHNoi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:44:38 -0500
Received: by mail-wr1-f66.google.com with SMTP id n2so21416393wrw.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:44:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9J0pLuIwycnbheXqWs2CljoyxQT/CDliz18qPVqA9Ho=;
        b=PNQXhH7uQFg+T24/7Vv44FTf0D5EOw8YUFsT6NrWDEdl2pS3OQzjAAkTemMfyRwH38
         X+Ek4J74XKrzb2dzQNcJ1n9RcD8cPechfLHpDMOAtCw+pOomTJm8rUj/u6oohpMO4dgO
         sd/BuvKc72PwcPFnA58SMSUKkY53DRvVfq19PjP78h3mfdf0RBT/7lYVZM05XvU8/upj
         fXZ/OwKvhvAQ3qo7Ql+NUAZn5rG35Y0I9FxDHbQT2GSXqzwZ8T6R1dqpUQ+taiPlky5O
         dBV/qv7YmpYaOxz+CBi3bkq9JLVGAJOy+N+OaSAqxxJRpfRPwQX1P3yaz7lxDdzddviv
         SjkQ==
X-Gm-Message-State: APjAAAUdQHhgyOzA+wI03pR61JmtSsjGcJ0/rCuOy7Pp498KWSGPoH78
        U33704G2omt2iwkz2yh9qoM98lRc
X-Google-Smtp-Source: APXvYqzurkldzqf1ZwFmagtsfYZXtT4gXoSp2T7FR5XJT5J+xOGH14FxCfqm/AX48wTALTY13nI+YA==
X-Received: by 2002:adf:b784:: with SMTP id s4mr10922231wre.155.1552052673606;
        Fri, 08 Mar 2019 05:44:33 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w4sm11631872wmg.8.2019.03.08.05.44.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:44:33 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 9/9] trace-cmd [POC]: Implemented timestamps synch PTP-like algorithm, using vsock events.
Date:   Fri,  8 Mar 2019 15:44:23 +0200
Message-Id: <20190308134423.22008-10-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308134423.22008-1-tstoyanov@vmware.com>
References: <20190308134423.22008-1-tstoyanov@vmware.com>
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
 include/trace-cmd/trace-cmd.h  |   9 +
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |  50 +++
 tracecmd/trace-msg.c           | 284 ++++++++++++++-
 tracecmd/trace-record.c        |  72 +++-
 tracecmd/trace-timesync.c      | 622 +++++++++++++++++++++++++++++++++
 6 files changed, 1024 insertions(+), 14 deletions(-)
 create mode 100644 tracecmd/trace-timesync.c

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index cea6bb9..dbfbe14 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -352,6 +352,15 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
 				 unsigned int **ports, bool *use_fifos);
 
+struct tracecmd_clock_sync;
+
+int tracecmd_msg_rcv_time_sync(struct tracecmd_msg_handle *msg_handle,
+			       struct tracecmd_clock_sync *clock_sync,
+			       long long *toffset, long long *ts_offset);
+int tracecmd_msg_snd_time_sync(struct tracecmd_msg_handle *msg_handle,
+			       struct tracecmd_clock_sync *clock_sync,
+			       long long *toffset, long long *ts_offset);
+
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
index 62f5e47..ba0b06d 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -214,6 +214,11 @@ struct buffer_instance {
 	int			port;
 	int			*fds;
 	bool			use_fifos;
+
+	struct tracecmd_clock_sync *clock_sync;
+	int			time_sync_count;
+	long long		*time_sync_ts;
+	long long		*time_sync_ofssets;
 };
 
 extern struct buffer_instance top_instance;
@@ -227,6 +232,37 @@ extern struct buffer_instance *first_instance;
 #define is_agent(instance)	((instance)->flags & BUFFER_FL_AGENT)
 #define is_guest(instance)	((instance)->flags & BUFFER_FL_GUEST)
 
+struct tracecmd_ftrace_param {
+	char	*file;
+	char	*set;
+	char	*reset;
+};
+
+struct tracecmd_event_hit {
+	int			id;
+	int			cpu;
+	int			pid;
+	unsigned long long	ts;
+};
+
+enum clock_sync_conext {
+	CLOCK_KVM_X86_VSOCK_HOST,
+	CLOCK_KVM_X86_VSOCK_GUEST,
+	CLOCK_CONTEXT_MAX,
+};
+
+struct tracecmd_clock_sync {
+	enum clock_sync_conext		clock_context_id;
+	struct tracecmd_ftrace_param	*ftrace_params;
+	struct tracecmd_event_hit	*events;
+	struct tep_handle		*tep;
+	struct buffer_instance		*vinst;
+	unsigned int			local_cid;
+	unsigned int			local_port;
+	unsigned int			remote_cid;
+	unsigned int			remote_port;
+};
+
 struct buffer_instance *create_instance(const char *name);
 void add_instance(struct buffer_instance *instance, int cpu_count);
 char *get_instance_file(struct buffer_instance *instance, const char *file);
@@ -235,6 +271,20 @@ void update_first_instance(struct buffer_instance *instance, int topt);
 void show_instance_file(struct buffer_instance *instance, const char *name);
 
 int count_cpus(void);
+
+struct tracecmd_clock_sync*
+tracecmd_clock_context_init(struct tracecmd_msg_handle *msg_handle,
+			    const char *clock_str,
+			    enum clock_sync_conext id);
+void tracecmd_clock_context_free(struct tracecmd_clock_sync *clock_context);
+int tracecmd_clock_find_event(struct tracecmd_clock_sync *clock, int cpu,
+			      struct tracecmd_event_hit *event);
+
+void tracecmd_clock_synch_enable(struct tracecmd_clock_sync *clock_context);
+void tracecmd_clock_synch_disable(struct tracecmd_clock_sync *clock_context);
+
+void sync_time_with_host_v3(struct buffer_instance *instance);
+void sync_time_with_guest_v3(struct buffer_instance *instance);
 void write_tracing_on(struct buffer_instance *instance, int on);
 char *get_instance_dir(struct buffer_instance *instance);
 int write_instance_file(struct buffer_instance *instance,
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 065a01e..0f1f071 100644
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
@@ -50,6 +56,9 @@ static inline void dprint(const char *fmt, ...)
 
 unsigned int page_size;
 
+/* Try a few times to get an accurate time sync */
+#define TSYNC_TRIES 300
+
 struct tracecmd_msg_opt {
 	be32 size;
 	be32 opt_cmd;
@@ -76,6 +85,16 @@ struct tracecmd_msg_trace_resp {
 	be32 page_size;
 } __attribute__((packed));
 
+struct tracecmd_msg_tsync_stop {
+	long long offset;
+	long long ts_offset;
+} __attribute__((packed));
+
+struct tracecmd_msg_tsync_pkt {
+	u64 tlocal;
+} __attribute__((packed));
+
+
 struct tracecmd_msg_header {
 	be32	size;
 	be32	cmd;
@@ -83,14 +102,18 @@ struct tracecmd_msg_header {
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
+	C(TSYNC_REQ,	  10,	sizeof(struct tracecmd_msg_tsync_pkt)),	\
+	C(TSYNC_RESP,	  11,	sizeof(struct tracecmd_msg_tsync_pkt)),
 
 #undef C
 #define C(a,b,c)	MSG_##a = b
@@ -120,10 +143,13 @@ static const char *cmd_to_name(int cmd)
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
+		struct tracecmd_msg_tsync_pkt		ts_req;
+		struct tracecmd_msg_tsync_pkt		ts_resp;
 	};
 	union {
 		struct tracecmd_msg_opt		*opt;
@@ -859,6 +885,240 @@ out:
 	return ret;
 }
 
+int tracecmd_msg_rcv_time_sync(struct tracecmd_msg_handle *msg_handle,
+			       struct tracecmd_clock_sync *clock_context,
+			       long long *toffset, long long *ts_offset)
+{
+	struct tracecmd_event_hit event;
+	struct tracecmd_msg msg;
+	int cpu_pid, ret;
+
+	if (clock_context == NULL || msg_handle == NULL)
+		return 0;
+
+	if (toffset)
+		*toffset = 0;
+
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+	if (ret < 0 || ntohl(msg.hdr.cmd) == MSG_TSYNC_STOP)
+		return 0;
+	if (ntohl(msg.hdr.cmd) != MSG_TSYNC_START) {
+		tracecmd_msg_init(MSG_NOT_SUPP, &msg);
+		tracecmd_msg_send(msg_handle->fd, &msg);
+		return 0;
+	}
+
+	tracecmd_msg_init(MSG_TSYNC_START, &msg);
+	tracecmd_msg_send(msg_handle->fd, &msg);
+	tracecmd_clock_synch_enable(clock_context);
+
+	do {
+		memset(&event, 0, sizeof(event));
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+		if (ret < 0 || ntohl(msg.hdr.cmd) == MSG_TSYNC_STOP)
+			break;
+		if (ntohl(msg.hdr.cmd) != MSG_TSYNC_REQ) {
+			tracecmd_msg_init(MSG_NOT_SUPP, &msg);
+			tracecmd_msg_send(msg_handle->fd, &msg);
+			break;
+		}
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
+		if (ret < 0 || ntohl(msg.hdr.cmd) == MSG_TSYNC_STOP)
+			break;
+		if (ntohl(msg.hdr.cmd) != MSG_TSYNC_REQ) {
+			tracecmd_msg_init(MSG_NOT_SUPP, &msg);
+			tracecmd_msg_send(msg_handle->fd, &msg);
+			break;
+		}
+		/* Get kvm_exit events related to the corresponding VCPU */
+		cpu_pid = get_guest_vcpu_pid(clock_context->remote_cid,
+					     ntohll(msg.ts_req.tlocal));
+		tracecmd_clock_find_event(clock_context, cpu_pid, &event);
+		tracecmd_msg_init(MSG_TSYNC_RESP, &msg);
+		msg.ts_resp.tlocal = htonll(event.ts);
+		tracecmd_msg_send(msg_handle->fd, &msg);
+	} while (true);
+	tracecmd_clock_synch_disable(clock_context);
+
+	if (ret >= 0 && ntohl(msg.hdr.cmd) == MSG_TSYNC_STOP) {
+		if (toffset)
+			*toffset = ntohll(msg.ts_stop.offset);
+		if (ts_offset)
+			*ts_offset = ntohll(msg.ts_stop.ts_offset);
+	}
+
+	msg_free(&msg);
+	return 0;
+}
+
+//#define TSYNC_DEBUG
+int tracecmd_msg_snd_time_sync(struct tracecmd_msg_handle *msg_handle,
+			       struct tracecmd_clock_sync *clock_context,
+			       long long *toffset, long long *ts_offset)
+{
+	struct tracecmd_event_hit event;
+	struct tracecmd_msg msg_resp;
+	struct tracecmd_msg msg_req;
+	int sync_loop = TSYNC_TRIES;
+	long long min = 0, max = 0;
+	long long  offset_av = 0;
+	long long ts_local = 0;
+	int k = 0, n, ret = 0;
+	long long tresch = 0;
+	long long offset = 0;
+	long long *ts_locals;
+	long long *offsets;
+	long long m_t1 = 0;
+	long long s_t2 = 0;
+	int probes = 0;
+#ifdef TSYNC_DEBUG
+/* Write all ts in a file, used to analyze the raw data */
+	struct timespec tsStart, tsEnd;
+	int zm = 0, zs = 0;
+	long long duration;
+	char buff[256];
+	int iFd;
+#endif
+
+	if (clock_context == NULL || msg_handle == NULL)
+		return 0;
+
+	if (toffset == NULL) {
+		/* No time sync needed, inform the client */
+		msg_req.ts_stop.offset = 0;
+		msg_req.ts_stop.ts_offset = 0;
+		tracecmd_msg_init(MSG_TSYNC_STOP, &msg_req);
+		tracecmd_msg_send(msg_handle->fd, &msg_req);
+		return 0;
+	}
+
+	*toffset = 0;
+	offsets = calloc(sizeof(long long), TSYNC_TRIES);
+	ts_locals = calloc(sizeof(long long), TSYNC_TRIES);
+	if (!offsets || !ts_locals) {
+		free(offsets);
+		free(ts_locals);
+		return 0;
+	}
+
+	tracecmd_msg_init(MSG_TSYNC_START, &msg_req);
+	tracecmd_msg_send(msg_handle->fd, &msg_req);
+	ret = tracecmd_msg_recv(msg_handle->fd, &msg_resp);
+	if (ret < 0 || ntohl(msg_resp.hdr.cmd) != MSG_TSYNC_START) {
+		free(offsets);
+		free(ts_locals);
+		return 0;
+	}
+
+#ifdef TSYNC_DEBUG
+	sprintf(buff, "s-cid%d.txt", clock_context->remote_cid);
+	iFd = open(buff, O_CREAT|O_WRONLY|O_TRUNC, 0644);
+	clock_gettime(CLOCK_MONOTONIC, &tsStart);
+#endif
+	tracecmd_clock_synch_enable(clock_context);
+	do {
+		memset(&msg_resp, 0, sizeof(msg_resp));
+		memset(&event, 0, sizeof(event));
+		tracecmd_msg_init(MSG_TSYNC_REQ, &msg_req);
+		tracecmd_msg_send(msg_handle->fd, &msg_req);
+		/* Get the ts and CPU of the sent event */
+		tracecmd_clock_find_event(clock_context, -1, &event);
+
+		tracecmd_msg_init(MSG_TSYNC_REQ, &msg_req);
+		msg_req.ts_req.tlocal = event.cpu;
+		msg_req.ts_req.tlocal = htonll(msg_req.ts_req.tlocal);
+		tracecmd_msg_send(msg_handle->fd, &msg_req);
+		ret = tracecmd_msg_recv(msg_handle->fd, &msg_resp);
+		if (ret < 0)
+			break;
+		if (ntohl(msg_resp.hdr.cmd) != MSG_TSYNC_RESP) {
+			tracecmd_msg_init(MSG_NOT_SUPP, &msg_req);
+			tracecmd_msg_send(msg_handle->fd, &msg_req);
+			break;
+		}
+		m_t1 = event.ts;
+		s_t2 = htonll(msg_resp.ts_resp.tlocal); /* Client rcv ts */
+#ifdef TSYNC_DEBUG
+		if (!s_t2)
+			zs++;
+		if (!m_t1)
+			zm++;
+#endif
+		if (!s_t2 || !m_t1)
+			continue;
+		offsets[probes] = s_t2 - m_t1;
+		ts_locals[probes] = m_t1;
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
+	tracecmd_clock_synch_disable(clock_context);
+
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
+	tresch = 0;
+	for (n = 0; n < TSYNC_TRIES; n++) {
+		if (offsets[n] &&
+		    (!tresch || tresch > llabs(offset-offsets[n]))) {
+			tresch = llabs(offset-offsets[n]);
+			ts_local = ts_locals[n];
+		}
+	}
+
+	tracecmd_msg_init(MSG_TSYNC_STOP, &msg_req);
+	msg_req.ts_stop.offset = htonll(offset);
+	msg_req.ts_stop.ts_offset = htonll(ts_local);
+	tracecmd_msg_send(msg_handle->fd, &msg_req);
+
+	msg_free(&msg_req);
+	msg_free(&msg_resp);
+	free(offsets);
+	free(ts_locals);
+
+	if (toffset)
+		*toffset = offset;
+	if (ts_offset)
+		*ts_offset = ts_local;
+
+#ifdef TSYNC_DEBUG
+	duration = tsEnd.tv_sec * 1000000000LL;
+	duration += tsEnd.tv_nsec;
+	duration -= (tsStart.tv_sec * 1000000000LL);
+	duration -= tsStart.tv_nsec;
+
+	printf("\n selected: %lld (in %lld ns), used %s clock, %d probes\n\r",
+		offset, duration,
+		clock_context->vinst->clock?clock_context->vinst->clock:"default",
+		probes);
+	printf("\t good probes: %d / %d, threshold %lld ns, Zm %d, Zs %d\n\r",
+			k, TSYNC_TRIES, tresch, zm, zs);
+#endif
+	return 0;
+}
+
 static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
 			   unsigned int *ports, bool use_fifos)
 {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d9e9c69..f07eb4d 100644
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
@@ -3417,6 +3428,8 @@ static void connect_to_agent(struct buffer_instance *instance)
 
 	/* the msg_handle now points to the guest fd */
 	instance->msg_handle = msg_handle;
+
+	sync_time_with_guest_v3(instance);
 }
 
 static void setup_guest(struct buffer_instance *instance)
@@ -3441,10 +3454,13 @@ static void setup_guest(struct buffer_instance *instance)
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
@@ -5619,6 +5635,42 @@ static bool has_local_instances(void)
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
+	vector[2].iov_base = instance->time_sync_ofssets;
+	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 3);
+	tracecmd_append_options(handle);
+	tracecmd_output_close(handle);
+#ifdef TSYNC_DEBUG
+	if (instance->time_sync_count > 1)
+		printf("\n\rDetected %lld ns ts offset drift in %lld ns for guest %s\n\r",
+			instance->time_sync_ofssets[instance->time_sync_count-1] -
+			instance->time_sync_ofssets[0],
+			instance->time_sync_ts[instance->time_sync_count-1]-
+			instance->time_sync_ts[0], instance->name);
+#endif
+}
+
 /*
  * This function contains common code for the following commands:
  * record, start, stream, profile.
@@ -5738,6 +5790,22 @@ static void record_trace(int argc, char **argv,
 	if (!latency)
 		wait_threads();
 
+	if (ctx->instance && is_agent(ctx->instance)) {
+		sync_time_with_host_v3(ctx->instance);
+		tracecmd_clock_context_free(ctx->instance->clock_sync);
+		ctx->instance->clock_sync = NULL;
+	} else {
+		for_all_instances(instance) {
+			if (is_guest(instance)) {
+				sync_time_with_guest_v3(instance);
+				write_guest_time_shift(instance);
+				tracecmd_clock_context_free(instance->clock_sync);
+				instance->clock_sync = NULL;
+			}
+		}
+	}
+	close_guests_handle();
+
 	if (IS_RECORD(ctx)) {
 		record_data(ctx);
 		delete_thread_data();
diff --git a/tracecmd/trace-timesync.c b/tracecmd/trace-timesync.c
new file mode 100644
index 0000000..f8366ed
--- /dev/null
+++ b/tracecmd/trace-timesync.c
@@ -0,0 +1,622 @@
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
+static int clock_sync_x86_host_init(struct tracecmd_clock_sync *clock_context);
+static int clock_sync_x86_host_free(struct tracecmd_clock_sync *clock_context);
+static int clock_sync_x86_host_find_events(struct tracecmd_clock_sync *clock,
+				    int cpu, struct tracecmd_event_hit *event);
+static int clock_sync_x86_guest_init(struct tracecmd_clock_sync *clock_context);
+static int clock_sync_x86_guest_free(struct tracecmd_clock_sync *clock_context);
+static int clock_sync_x86_guest_find_events(struct tracecmd_clock_sync *clock,
+					    int pid,
+					    struct tracecmd_event_hit *event);
+
+struct tracecmd_event_descr {
+	char			*system;
+	char			*name;
+};
+
+struct {
+	char *systems[3];
+	struct tracecmd_ftrace_param ftrace_params[5];
+	struct tracecmd_event_descr events[3];
+	int (*clock_sync_init)(struct tracecmd_clock_sync *clock_context);
+	int (*clock_sync_free)(struct tracecmd_clock_sync *clock_context);
+	int (*clock_sync_find_events)(struct tracecmd_clock_sync *clock_context,
+				      int pid,
+				      struct tracecmd_event_hit *event);
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
+#define EVENTS_CHUNK	10
+static int
+get_events_in_page(struct tep_handle *tep, void *page,
+		    int size, int cpu, struct tracecmd_event_hit **events,
+		    int *events_count, int *events_size)
+{
+	struct tracecmd_event_hit *events_array = NULL;
+	struct tep_record *last_record = NULL;
+	struct tep_event *event = NULL;
+	struct tep_record *record;
+	int id, cnt = 0;
+
+	if (size <= 0)
+		return 0;
+
+	if (*events == NULL) {
+		*events = malloc(EVENTS_CHUNK*sizeof(struct tracecmd_event_hit));
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
+					(*events_size + EVENTS_CHUNK)*
+					sizeof(struct tracecmd_event_hit));
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
+	const struct tracecmd_event_hit *ea = (const struct tracecmd_event_hit *)a;
+	const struct tracecmd_event_hit *eb = (const struct tracecmd_event_hit *)b;
+
+	if (ea->ts > eb->ts)
+		return 1;
+	if (ea->ts < eb->ts)
+		return -1;
+	return 0;
+}
+
+static int find_sync_events(struct tep_handle *pevent,
+			    struct tracecmd_event_hit *recorded,
+			    int rsize, struct tracecmd_event_hit *events)
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
+		    struct tracecmd_event_hit *events)
+{
+	struct tracecmd_event_hit *events_array = NULL;
+	int events_count = 0;
+	int events_size = 0;
+	struct dirent *dent;
+	unsigned int p_size;
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
+			r = read(fd, page, p_size);
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
+					   struct tracecmd_event_hit *event)
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
+					    struct tracecmd_event_hit *event)
+{
+	int ret;
+
+	ret = find_raw_events(clock->tep, clock->vinst, clock->events);
+	event->ts = clock->events[1].ts;
+	event->cpu = clock->events[0].cpu;
+	return ret;
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
+			      struct tracecmd_event_hit *event)
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
+	clock_context->events = calloc(i+1, sizeof(struct tracecmd_event_hit));
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
+					      char **systems)
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
+tracecmd_clock_context_init(struct tracecmd_msg_handle *msg_handle,
+			    const char *clock_str,
+			    enum clock_sync_conext id)
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
+	return clock_context;
+
+}
+
+void tracecmd_clock_context_free(struct tracecmd_clock_sync *clock_context)
+{
+	int i;
+
+	if (clock_context == NULL ||
+	    clock_context->clock_context_id >= CLOCK_CONTEXT_MAX)
+		return;
+	if (clock_sync[clock_context->clock_context_id].clock_sync_free)
+		clock_sync[clock_context->clock_context_id].clock_sync_free(clock_context);
+
+	i = 0;
+	while (clock_context->ftrace_params[i].file) {
+		free(clock_context->ftrace_params[i].file);
+		free(clock_context->ftrace_params[i].set);
+		free(clock_context->ftrace_params[i].reset);
+		i++;
+	}
+	free(clock_context->ftrace_params);
+	free(clock_context->events);
+	tracecmd_remove_instance(clock_context->vinst);
+	/* todo: clean up the instance */
+	tep_free(clock_context->tep);
+	free(clock_context);
+}
+
+void sync_time_with_host_v3(struct buffer_instance *instance)
+{
+	long long ts_local = 0;
+	long long toffset = 0;
+
+	if (instance->clock_sync == NULL)
+		instance->clock_sync = tracecmd_clock_context_init(instance->msg_handle,
+					instance->clock, CLOCK_KVM_X86_VSOCK_GUEST);
+
+	tracecmd_msg_snd_time_sync(instance->msg_handle, instance->clock_sync,
+				   &toffset, &ts_local);
+}
+
+void sync_time_with_guest_v3(struct buffer_instance *instance)
+{
+	long long ts_local = 0;
+	long long toffset = 0;
+	long long *sync_array_ts;
+	long long *sync_array_ofs;
+
+	if (instance->clock_sync == NULL)
+		instance->clock_sync = tracecmd_clock_context_init(instance->msg_handle,
+						top_instance.clock, CLOCK_KVM_X86_VSOCK_HOST);
+
+	tracecmd_msg_rcv_time_sync(instance->msg_handle,
+				   instance->clock_sync, &toffset, &ts_local);
+
+	sync_array_ts = realloc(instance->time_sync_ts,
+			    (instance->time_sync_count+1)*sizeof(long long));
+	sync_array_ofs = realloc(instance->time_sync_ofssets,
+			    (instance->time_sync_count+1)*sizeof(long long));
+
+	if (sync_array_ts && sync_array_ofs) {
+		sync_array_ts[instance->time_sync_count] = ts_local;
+		sync_array_ofs[instance->time_sync_count] = toffset;
+		instance->time_sync_count++;
+		instance->time_sync_ts = sync_array_ts;
+		instance->time_sync_ofssets = sync_array_ofs;
+
+	} else {
+		free(sync_array_ts);
+		free(sync_array_ofs);
+	}
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
+					params[i].set, NULL);
+		}
+		if (!enable && params[i].reset)
+			write_instance_file(instance, params[i].file,
+					params[i].reset, NULL);
+		i++;
+	}
+
+	if (enable)
+		write_tracing_on(instance, 1);
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
-- 
2.20.1

