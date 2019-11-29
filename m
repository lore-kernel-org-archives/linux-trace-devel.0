Return-Path: <SRS0=Qwo8=ZV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB2EC432C3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9390D217D6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:18:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L50sCOaG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfK2KSB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 05:18:01 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34065 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbfK2KSB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 05:18:01 -0500
Received: by mail-lj1-f194.google.com with SMTP id m6so24014778ljc.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Nov 2019 02:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vfYufrfz+TJl03tATisJcwAy1W48vHpI10kBVb0co+0=;
        b=L50sCOaGh9nMIwPjrY+UK3wzwlPK0rhFQW/BQ2fDvlQCTr1bK345kFsNWg3ALkquQ/
         qJpSzyp7rt+bE4AX16Kg5WFJ803p02TwGanNPpMh8+IvltWI0KweT1JM8YbdWoXFQDKE
         VxOUZqzRWel4jNas345ZKGXJlcGjvU1n/nHTI03wLOHYkkYRDwwPuy3ewFWBxQkQxwBZ
         mgQANPJe8i45b3dD2MyGN2+aQgtEj5Iq2Mt7TLMYFVRUS2DO8j8B60JpgKwH8vum4/oS
         8pBGvbx9jiwGgReEguEjsq5Ltjn8X2X6PLQ4CsfV2ObHsd5UHnvnDftir0gZhHxxMFYl
         AkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vfYufrfz+TJl03tATisJcwAy1W48vHpI10kBVb0co+0=;
        b=VYkmUzWd51tV+BB/Fe/XyFEnBXzQVr6+JcE1o3GBWTURPfqslGJw+mrb6rYtVehxg2
         negdQnMU5zLX3mfKqYMuQUdfmZNz3Dv5lmF4c3W1oT0dHTW3jHukvJGIticqo6x24R+X
         eEfY/AbNwa9gBfjIO/hFMlu8d6wBG8G6HTHvHT4DuBpmzO/t9lcqJbu507VYIEfZSHqL
         F5YhZNXa1lw4OEeeqqTdJKvHuW/eNO8Pq9AsnCAmrLOPs39N3xXKIic/WM0s0Pqbx1bQ
         c1NKN4n/HXzIu1wYHEB6JlPmQEFddkMQrGA+thfiJE+Bpyed2bYNCua9B//t7iEFLKhX
         0LoQ==
X-Gm-Message-State: APjAAAWRgiInWXoN9X2YUqXOCKSEmIyRAEquoZWdIakT26qKJ3ivHBj/
        2nn8TKSikigNBJ8cczb0PxA=
X-Google-Smtp-Source: APXvYqw4QQrP95xfQJ6vubFSbF0+mIe3Atrm09SYyZEr0pPGLyVdCUlPiFNDCXjTxEOMmZrLEIf6yg==
X-Received: by 2002:a2e:6a10:: with SMTP id f16mr37981163ljc.100.1575022676434;
        Fri, 29 Nov 2019 02:17:56 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x29sm11367935lfg.45.2019.11.29.02.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 02:17:55 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v16 17/18] trace-cmd: [POC] PTP-like algorithm for host - guest timestamp synchronization
Date:   Fri, 29 Nov 2019 12:17:32 +0200
Message-Id: <20191129101733.375808-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191129101733.375808-1-tz.stoyanov@gmail.com>
References: <20191129101733.375808-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

PTP protocol is designed for synchronizing clocks of machines in a local network.
The same approach can be used for host - guest timestamp synchronization.
This implementation uses ftrace raw markers to track trace timestamps of PTP events.
The patch is a POC, two different algorithms for PTP calculations are proposed:
  - Choosing the sample with the fastest response time for calculating the clocks offset.
  - Calculating the clocks offset using the average of all PTP samples.

The implementation can be tuned using those parameters:
 - #define FASTEST_RESPONSE - is defined, the sample with the fastest response time
    is used for calculating the clocks offset. Otherwise the average of all samples is used.
 - #define PTP_SYNC_LOOP 340 - defines the number of samples, used for one calculation.
 - --tsync-interval - a trace-cmd argument, choose the intervals between offset calculations,
	performed continuously during the trace.
 - #define TSYNC_DEBUG - if defined, a debug information is collected and stored in files,
   in the guest machine:
     s-cid*.txt - For each offset calculation: host and guest clocks and calculated offset.
     res-cid*.txt - For each tracing session: all calculated clock offsets.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h      |   2 +
 lib/trace-cmd/Makefile             |   1 +
 lib/trace-cmd/trace-timesync-ptp.c | 666 +++++++++++++++++++++++++++++
 lib/trace-cmd/trace-timesync.c     |   8 +
 tracecmd/trace-agent.c             |   2 +
 tracecmd/trace-record.c            |  25 +-
 6 files changed, 696 insertions(+), 8 deletions(-)
 create mode 100644 lib/trace-cmd/trace-timesync-ptp.c

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6abcc9f..013160a 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -427,6 +427,7 @@ int tracecmd_iterate_raw_events(struct tep_handle *tep,
 
 enum{
 	TRACECMD_TIME_SYNC_PROTO_NONE	= 0,
+	TRACECMD_TIME_SYNC_PROTO_PTP	= 1 << 0,
 };
 enum{
 	TRACECMD_TIME_SYNC_CMD_PROBE	= 1,
@@ -444,6 +445,7 @@ struct tracecmd_time_sync {
 	void				*context;
 };
 
+void tracecmd_tsync_init(void);
 unsigned int tracecmd_tsync_proto_getall(void);
 unsigned int tracecmd_tsync_proto_select(unsigned int protos);
 void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 6221b36..a2b9d08 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -17,6 +17,7 @@ OBJS += trace-instance.o
 OBJS += trace-filter-hash.o
 OBJS += trace-msg.o
 OBJS += trace-timesync.o
+OBJS += trace-timesync-ptp.o
 
 # Additional util objects
 OBJS += trace-blk-hack.o
diff --git a/lib/trace-cmd/trace-timesync-ptp.c b/lib/trace-cmd/trace-timesync-ptp.c
new file mode 100644
index 0000000..15808f4
--- /dev/null
+++ b/lib/trace-cmd/trace-timesync-ptp.c
@@ -0,0 +1,666 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2019, VMware, Tzvetomir Stoyanov tz.stoyanov@gmail.com>
+ *
+ */
+
+#include <fcntl.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <linux/vm_sockets.h>
+#include <sys/types.h>
+#include <linux/types.h>
+#include <time.h>
+#include <sched.h>
+#include "trace-cmd.h"
+#include "trace-tsync-local.h"
+#include "trace-msg.h"
+
+typedef __be32 be32;
+typedef __u64 u64;
+typedef __s64 s64;
+
+#define PTP_SYNC_LOOP	340
+
+#define PTP_SYNC_PKT_START	1
+#define PTP_SYNC_PKT_PROBE	2
+#define PTP_SYNC_PKT_PROBES	3
+#define PTP_SYNC_PKT_OFFSET	4
+#define PTP_SYNC_PKT_END	5
+
+#define TSYNC_DEBUG
+
+struct ptp_clock_sync {
+	struct tep_handle	*tep;
+	int			raw_id;
+	int			marker_fd;
+	int			series_id;
+	int			debug_fd;
+
+};
+
+struct ptp_clock_start_msg {
+	be32	series_id;
+} __attribute__((packed));
+
+struct ptp_clock_sample {
+	s64		ts;
+	be32		id;
+} __attribute__((packed));
+
+struct ptp_clock_result_msg {
+	be32			series_id;
+	be32			count;
+	struct ptp_clock_sample	samples[2*PTP_SYNC_LOOP];
+} __attribute__((packed));
+
+struct ptp_clock_offset_msg {
+	s64	ts;
+	s64	offset;
+};
+
+struct ptp_markers_context {
+	struct clock_sync_context	*clock;
+	struct ptp_clock_sync		*ptp;
+	int				size;
+	struct ptp_clock_result_msg	msg;
+};
+
+struct ptp_marker_buf {
+	int local_cid;
+	int remote_cid;
+	int count;
+	int packet_id;
+} __attribute__((packed));
+
+struct ptp_marker{
+	int series_id;
+	struct ptp_marker_buf data;
+} __attribute__((packed));
+
+static int ptp_clock_sync_init(struct tracecmd_time_sync *tsync)
+{
+	const char *systems[] = { "ftrace", NULL};
+	struct clock_sync_context *clock_context;
+	struct ptp_clock_sync *ptp;
+	struct tep_event *raw;
+	char *path;
+
+	if (!tsync || !tsync->context)
+		return -1;
+	clock_context = (struct clock_sync_context *)tsync->context;
+	if (clock_context->proto_data)
+		return 0;
+
+	ptp = calloc(1, sizeof(struct ptp_clock_sync));
+	if (!ptp)
+		return -1;
+
+	ptp->marker_fd = -1;
+	ptp->debug_fd = -1;
+
+	path = tracecmd_get_instance_dir(clock_context->vinst);
+	if (!path)
+		goto error;
+	ptp->tep = tracecmd_local_events_system(path, systems);
+	tracecmd_put_tracing_file(path);
+	if (!ptp->tep)
+		goto error;
+	raw = tep_find_event_by_name(ptp->tep, "ftrace", "raw_data");
+	if (!raw)
+		goto error;
+
+	ptp->raw_id = raw->id;
+	tep_set_file_bigendian(ptp->tep, tracecmd_host_bigendian());
+	tep_set_local_bigendian(ptp->tep, tracecmd_host_bigendian());
+
+	path = tracecmd_get_instance_file(clock_context->vinst, "trace_marker_raw");
+	if (!path)
+		goto error;
+	ptp->marker_fd = open(path, O_WRONLY);
+	tracecmd_put_tracing_file(path);
+
+	clock_context->proto_data = ptp;
+
+#ifdef TSYNC_DEBUG
+	if (clock_context->server) {
+		char buff[256];
+		int res_fd;
+
+		sprintf(buff, "res-cid%d.txt", clock_context->remote_cid);
+
+		res_fd = open(buff, O_CREAT|O_WRONLY|O_TRUNC, 0644);
+		if (res_fd > 0)
+			close(res_fd);
+	}
+#endif
+
+	return 0;
+
+error:
+	if (ptp) {
+		tep_free(ptp->tep);
+		if (ptp->marker_fd >= 0)
+			close(ptp->marker_fd);
+	}
+	free(ptp);
+	return -1;
+}
+
+static int ptp_clock_sync_free(struct tracecmd_time_sync *tsync)
+{
+	struct clock_sync_context *clock_context;
+	struct ptp_clock_sync *ptp;
+
+	if (!tsync || !tsync->context)
+		return -1;
+	clock_context = (struct clock_sync_context *)tsync->context;
+
+	if (clock_context && clock_context->proto_data) {
+		ptp = (struct ptp_clock_sync *)clock_context->proto_data;
+		tep_free(ptp->tep);
+		if (ptp->marker_fd >= 0)
+			close(ptp->marker_fd);
+		if (ptp->debug_fd >= 0)
+			close(ptp->debug_fd);
+		free(clock_context->proto_data);
+		clock_context->proto_data = NULL;
+	}
+	return 0;
+}
+
+static int ptp_marker_find(struct tep_event *event, struct tep_record *record,
+			   int cpu, void *context)
+{
+	struct ptp_markers_context *ctx;
+	struct tep_format_field *field;
+	struct tep_format_field *id;
+	struct ptp_marker *marker;
+	int index = -1;
+
+	ctx = (struct ptp_markers_context *)context;
+
+	/* Make sure this is our event */
+	if (event->id != ctx->ptp->raw_id)
+		return 0;
+	id = tep_find_field(event, "id");
+	field = tep_find_field(event, "buf");
+	if (field && id &&
+	    record->size >= (id->offset + sizeof(struct ptp_marker))) {
+		marker = (struct ptp_marker *)(record->data + id->offset);
+		if (marker->data.local_cid == ctx->clock->local_cid &&
+		    marker->data.remote_cid == ctx->clock->remote_cid &&
+		    marker->series_id == ctx->ptp->series_id &&
+		    marker->data.count) {
+			if (marker->data.packet_id == 'r' &&
+			    marker->data.count <= ctx->size) {
+				index = marker->data.count - 1;
+			} else if (marker->data.packet_id == 's' &&
+				  marker->data.count*2 <= ctx->size){
+				index = ctx->size / 2 + marker->data.count - 1;
+			}
+		}
+		if (index >= 0) {
+			ctx->msg.samples[index].id = marker->data.count;
+			ctx->msg.samples[index].ts = record->ts;
+			ctx->msg.count++;
+		}
+	}
+
+	return 0;
+}
+
+#define FASTEST_RESPONSE
+
+#ifdef FASTEST_RESPONSE
+static int ptp_calc_offset(struct clock_sync_context *clock,
+			   struct ptp_clock_result_msg *server,
+			   struct ptp_clock_result_msg *client,
+			   long long *offset_ret, long long *ts_ret,
+			   int *bad_probes)
+{
+	struct ptp_clock_sample *sample_send;
+	long long delta_min = 0;
+	long long offset = 0;
+	long long delta = 0;
+	long long ts = 0;
+	int i;
+
+	*bad_probes = 0;
+	sample_send = server->samples + (server->count / 2);
+	for (i = 0; i * 2 < server->count && i < client->count; i++) {
+		if (!server->samples[i].ts ||
+		    !sample_send[i].ts ||
+		    !client->samples[i].ts ||
+		    server->samples[i].id != sample_send[i].id ||
+		    server->samples[i].id != client->samples[i].id) {
+			(*bad_probes)++;
+			continue;
+		}
+
+		ts = (sample_send[i].ts + server->samples[i].ts) / 2;
+		offset = client->samples[i].ts - ts;
+
+		delta = server->samples[i].ts - sample_send[i].ts;
+		if (!delta_min || delta_min > delta) {
+			delta_min = delta;
+			*offset_ret = offset;
+			*ts_ret = ts;
+		}
+#ifdef TSYNC_DEBUG
+		{
+			struct ptp_clock_sync *ptp;
+
+			ptp = (struct ptp_clock_sync *)clock->proto_data;
+			if (ptp && ptp->debug_fd > 0) {
+				char buff[256];
+
+				sprintf(buff, "%lld %lld %lld\n",
+					ts, client->samples[i].ts, offset);
+				write(ptp->debug_fd, buff, strlen(buff));
+			}
+		}
+#endif
+	}
+
+	return 0;
+}
+
+#else /* average offset */
+
+static int ptp_calc_offset(struct clock_sync_context *clock,
+			   struct ptp_clock_result_msg *server,
+			   struct ptp_clock_result_msg *client,
+			   long long *offset_ret, long long *ts_ret,
+			   int *bad_probes)
+{
+	long long timestamps[PTP_SYNC_LOOP];
+	long long offsets[PTP_SYNC_LOOP];
+	struct ptp_clock_sample *sample_send;
+	long long offset_max = 0;
+	long long offset_min = 0;
+	long long offset_av = 0;
+	long long offset = 0;
+	long long time = 0;
+	long long  tresch;
+	int i, j, k = 0;
+
+	*bad_probes = 0;
+	sample_send = server->samples + (server->count / 2);
+	for (i = 0; i * 2 < server->count && i < client->count; i++) {
+		if (!server->samples[i].ts ||
+		    !sample_send[i].ts ||
+		    !client->samples[i].ts ||
+		    server->samples[i].id != sample_send[i].id ||
+		    server->samples[i].id != client->samples[i].id) {
+			(*bad_probes)++;
+			continue;
+		}
+
+		timestamps[k] = (sample_send[i].ts + server->samples[i].ts) / 2;
+		offsets[k] = client->samples[i].ts - timestamps[k];
+		offset_av += offsets[k];
+		if (!offset_max || offset_max < llabs(offsets[k]))
+			offset_max = llabs(offsets[k]);
+		if (!offset_min || offset_min > llabs(offsets[k]))
+			offset_min = llabs(offsets[k]);
+#ifdef TSYNC_DEBUG
+		{
+			struct ptp_clock_sync *ptp;
+
+			ptp = (struct ptp_clock_sync *)clock->proto_data;
+
+			if (ptp && ptp->debug_fd > 0) {
+				char buff[256];
+
+				sprintf(buff, "%lld %lld %lld\n",
+					timestamps[k],
+					client->samples[i].ts, offsets[k]);
+				write(ptp->debug_fd, buff, strlen(buff));
+			}
+		}
+#endif
+		k++;
+	}
+	if (k)
+		offset_av /= (long long)k;
+
+	offset = 0;
+	tresch = (long long)((offset_max - offset_min)/10);
+	for (i = 0, j = 0; i < k; i++) {
+		/* filter the offsets with deviation up to 10% */
+		if (llabs(offsets[i] - offset_av) < tresch) {
+			offset += offsets[i];
+			j++;
+		} else
+			(*bad_probes)++;
+	}
+	if (j)
+		offset /= (long long)j;
+
+	tresch = 0;
+	for (i = 0; i < k; i++) {
+		if ((!tresch || tresch > llabs(offset - offsets[i]))) {
+			tresch = llabs(offset - offsets[i]);
+			time = timestamps[i];
+		}
+	}
+	if (offset_ret)
+		*offset_ret = offset;
+	if (ts_ret)
+		*ts_ret = time;
+
+	return 0;
+}
+
+#endif
+
+static void ntoh_ptp_results(struct ptp_clock_result_msg *msg)
+{
+	int i;
+
+	msg->count = ntohl(msg->count);
+	for (i = 0; i < msg->count; i++) {
+		msg->samples[i].id = ntohl(msg->samples[i].id);
+		msg->samples[i].ts = ntohll(msg->samples[i].ts);
+	}
+	msg->series_id = ntohl(msg->series_id);
+}
+
+
+static void hton_ptp_results(struct ptp_clock_result_msg *msg)
+{
+	int i;
+
+	for (i = 0; i < msg->count; i++) {
+		msg->samples[i].id = htonl(msg->samples[i].id);
+		msg->samples[i].ts = htonll(msg->samples[i].ts);
+	}
+	msg->series_id = htonl(msg->series_id);
+	msg->count = htonl(msg->count);
+}
+
+static int ptp_clock_client(struct tracecmd_time_sync *tsync,
+			    long long *offset, long long *timestamp)
+{
+	struct clock_sync_context *clock_context;
+	struct ptp_clock_offset_msg res_offset;
+	unsigned int sync_proto, sync_msg;
+	struct ptp_clock_start_msg start;
+	struct ptp_markers_context ctx;
+	struct ptp_clock_sync *ptp;
+	struct ptp_marker marker;
+	unsigned int size;
+	char *msg;
+	int count;
+	int ret;
+	int lcount = 0;
+
+	if (!tsync || !tsync->context || !tsync->msg_handle)
+		return -1;
+
+	clock_context = (struct clock_sync_context *)tsync->context;
+	if (clock_context->proto_data == NULL)
+		return -1;
+
+	ptp = (struct ptp_clock_sync *)clock_context->proto_data;
+	size = sizeof(start);
+	msg = (char *)&start;
+	ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+					  &sync_proto, &sync_msg,
+					  &size, &msg);
+	if (ret || sync_proto != TRACECMD_TIME_SYNC_PROTO_PTP ||
+	    sync_msg != PTP_SYNC_PKT_START)
+		return -1;
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
+					 TRACECMD_TIME_SYNC_PROTO_PTP,
+					 PTP_SYNC_PKT_START, sizeof(start),
+					 (char *)&start);
+	marker.data.local_cid = clock_context->local_cid;
+	marker.data.remote_cid = clock_context->remote_cid;
+	marker.series_id = ntohl(start.series_id);
+	ptp->series_id = marker.series_id;
+	msg = (char *)&count;
+	size = sizeof(count);
+	while (true) {
+		count = 0;
+		lcount++;
+		ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+					&sync_proto, &sync_msg, &size, &msg);
+		if (ret || sync_proto != TRACECMD_TIME_SYNC_PROTO_PTP ||
+		    sync_msg != PTP_SYNC_PKT_PROBE || !ntohl(count))
+			break;
+
+		marker.data.count = ntohl(count);
+		marker.data.packet_id = 'r';
+		write(ptp->marker_fd, &marker, sizeof(marker));
+		ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
+						 TRACECMD_TIME_SYNC_PROTO_PTP,
+						 PTP_SYNC_PKT_PROBE,
+						 sizeof(count), (char *)&count);
+		if (ret)
+			break;
+	}
+
+	if (sync_proto != TRACECMD_TIME_SYNC_PROTO_PTP ||
+	    sync_msg != PTP_SYNC_PKT_END)
+		return -1;
+
+	ctx.size = PTP_SYNC_LOOP;
+	ctx.ptp = ptp;
+	ctx.clock = clock_context;
+	ctx.msg.count = 0;
+	ctx.msg.series_id = ptp->series_id;
+	tracecmd_iterate_raw_events(ptp->tep, clock_context->vinst,
+				    ptp_marker_find, &ctx);
+	hton_ptp_results(&ctx.msg);
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
+					  TRACECMD_TIME_SYNC_PROTO_PTP,
+					  PTP_SYNC_PKT_PROBES,
+					  sizeof(ctx.msg), (char *)&ctx.msg);
+
+	msg = (char *)&res_offset;
+	size = sizeof(res_offset);
+	ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+					  &sync_proto, &sync_msg,
+					  &size, (char **)&msg);
+	if (ret || sync_proto != TRACECMD_TIME_SYNC_PROTO_PTP ||
+	    sync_msg != PTP_SYNC_PKT_OFFSET)
+		return -1;
+
+	*offset = ntohll(res_offset.offset);
+	*timestamp = ntohll(res_offset.ts);
+
+	return 0;
+}
+
+
+static int ptp_clock_server(struct tracecmd_time_sync *tsync,
+			    long long *offset, long long *timestamp)
+{
+	struct ptp_clock_result_msg *results = NULL;
+	struct clock_sync_context *clock_context;
+	struct ptp_clock_offset_msg res_offset;
+	unsigned int sync_proto, sync_msg;
+	struct ptp_clock_start_msg start;
+	struct ptp_markers_context ctx;
+	int sync_loop = PTP_SYNC_LOOP;
+	struct ptp_clock_sync *ptp;
+	struct ptp_marker marker;
+	unsigned int size;
+	int bad_probes;
+	int count = 1;
+	int msg_count;
+	int msg_ret;
+	char *msg;
+	int ret;
+
+	if (!tsync || !tsync->context || !tsync->msg_handle)
+		return -1;
+
+	clock_context = (struct clock_sync_context *)tsync->context;
+	if (clock_context->proto_data == NULL)
+		return -1;
+
+	ptp = (struct ptp_clock_sync *)clock_context->proto_data;
+	start.series_id = htonl(ptp->series_id + 1);
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
+					 TRACECMD_TIME_SYNC_PROTO_PTP,
+					 PTP_SYNC_PKT_START, sizeof(start),
+					 (char *)&start);
+	if (!ret)
+		ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+						  &sync_proto, &sync_msg,
+						  NULL, NULL);
+	if (ret || sync_proto != TRACECMD_TIME_SYNC_PROTO_PTP ||
+	    sync_msg != PTP_SYNC_PKT_START)
+		return -1;
+
+	tracecmd_write_instance_file(clock_context->vinst, "trace", "\0", NULL);
+
+	ptp->series_id++;
+	marker.data.local_cid = clock_context->local_cid;
+	marker.data.remote_cid = clock_context->remote_cid;
+	marker.series_id = ptp->series_id;
+	msg = (char *)&msg_ret;
+	size = sizeof(msg_ret);
+	do {
+		marker.data.count = count++;
+		marker.data.packet_id = 's';
+		msg_count = htonl(marker.data.count);
+		write(ptp->marker_fd, &marker, sizeof(marker));
+		ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
+						 TRACECMD_TIME_SYNC_PROTO_PTP,
+						 PTP_SYNC_PKT_PROBE,
+						 sizeof(msg_count),
+						 (char *)&msg_count);
+		if (!ret)
+			ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+							  &sync_proto, &sync_msg,
+							  &size, &msg);
+
+		marker.data.packet_id = 'r';
+		write(ptp->marker_fd, &marker, sizeof(marker));
+		if (ret || sync_proto != TRACECMD_TIME_SYNC_PROTO_PTP ||
+		    sync_msg != PTP_SYNC_PKT_PROBE ||
+		    ntohl(msg_ret) != marker.data.count)
+			break;
+	} while (--sync_loop);
+
+	if (sync_loop)
+		return -1;
+
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
+					  TRACECMD_TIME_SYNC_PROTO_PTP,
+					  PTP_SYNC_PKT_END, 0, NULL);
+
+	size = 0;
+	ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+					  &sync_proto, &sync_msg,
+					  &size, (char **)&results);
+	if (ret || sync_proto != TRACECMD_TIME_SYNC_PROTO_PTP ||
+	    sync_msg != PTP_SYNC_PKT_PROBES || size == 0 || results == NULL)
+		return -1;
+
+	ntoh_ptp_results(results);
+
+	ctx.size = 2*PTP_SYNC_LOOP;
+	ctx.ptp = ptp;
+	ctx.clock = clock_context;
+	ctx.msg.count = 0;
+	ctx.msg.series_id = ptp->series_id;
+	tracecmd_iterate_raw_events(ptp->tep, clock_context->vinst,
+				    ptp_marker_find, &ctx);
+
+	ptp_calc_offset(clock_context, &ctx.msg, results, offset,
+			timestamp, &bad_probes);
+
+#ifdef TSYNC_DEBUG
+	{
+		char buff[256];
+		int res_fd;
+
+		sprintf(buff, "res-cid%d.txt", clock_context->remote_cid);
+
+		res_fd = open(buff, O_WRONLY|O_APPEND, 0644);
+		if (res_fd > 0) {
+			if (*offset && *timestamp) {
+				sprintf(buff, "%d %lld %lld\n",
+					ptp->series_id, *offset, *timestamp);
+				write(res_fd, buff, strlen(buff));
+			}
+			close(res_fd);
+		}
+
+		printf("\n calculated offset %d: %lld, %d probes, filtered out %d\n\r",
+			ptp->series_id, *offset, results->count, bad_probes);
+		if (ptp && ptp->debug_fd > 0) {
+			sprintf(buff, "%lld %lld 0\n", *offset, *timestamp);
+			write(ptp->debug_fd, buff, strlen(buff));
+			close(ptp->debug_fd);
+			ptp->debug_fd = -1;
+		}
+
+	}
+#endif
+
+	res_offset.offset = htonll(*offset);
+	res_offset.ts = htonll(*timestamp);
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
+					  TRACECMD_TIME_SYNC_PROTO_PTP,
+					  PTP_SYNC_PKT_OFFSET,
+					  sizeof(res_offset),
+					  (char *)&res_offset);
+
+	free(results);
+	return 0;
+}
+
+static int ptp_clock_sync_calc(struct tracecmd_time_sync *tsync,
+			       long long *offset, long long *timestamp)
+{
+	struct clock_sync_context *clock_context;
+	int ret;
+
+	if (!tsync || !tsync->context)
+		return -1;
+	clock_context = (struct clock_sync_context *)tsync->context;
+
+#ifdef TSYNC_DEBUG
+	if (clock_context->server) {
+		struct ptp_clock_sync *ptp;
+		char buff[256];
+
+		ptp = (struct ptp_clock_sync *)clock_context->proto_data;
+		if (ptp->debug_fd > 0)
+			close(ptp->debug_fd);
+		sprintf(buff, "s-cid%d_%d.txt",
+				clock_context->remote_cid, ptp->series_id+1);
+		ptp->debug_fd = open(buff, O_CREAT|O_WRONLY|O_TRUNC, 0644);
+	}
+#endif
+
+
+	if (clock_context->server)
+		ret = ptp_clock_server(tsync, offset, timestamp);
+	else
+		ret = ptp_clock_client(tsync, offset, timestamp);
+
+	return ret;
+}
+
+int ptp_clock_sync_register(void)
+{
+	return tracecmd_tsync_proto_register(TRACECMD_TIME_SYNC_PROTO_PTP,
+					     TRACECMD_TIME_SYNC_PROTO_PTP_WEIGHT,
+					     ptp_clock_sync_init,
+					     ptp_clock_sync_free,
+					     ptp_clock_sync_calc);
+
+}
+
+int ptp_clock_sync_unregister(void)
+{
+	return tracecmd_tsync_proto_unregister(TRACECMD_TIME_SYNC_PROTO_PTP);
+}
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 073423d..5458c4f 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -42,6 +42,14 @@ static struct tsync_proto *tsync_proto_get(unsigned int proto_id)
 	return NULL;
 }
 
+/**
+ * tracecmd_tsync_init - Initialize the global, per task, time sync data.
+ */
+void tracecmd_tsync_init(void)
+{
+	ptp_clock_sync_register();
+}
+
 int tracecmd_tsync_proto_register(unsigned int proto_id, int weight,
 				int (*init)(struct tracecmd_time_sync *),
 				int (*free)(struct tracecmd_time_sync *),
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 1581de8..46874cf 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -242,6 +242,8 @@ static void agent_serve(unsigned int port)
 	if (sd < 0)
 		die("Failed to open vsocket");
 
+	tracecmd_tsync_init();
+
 	if (!get_local_cid(&cid))
 		printf("listening on @%u:%u\n", cid, port);
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e543c40..c29f1ce 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5944,10 +5944,7 @@ static void set_clock(struct buffer_instance *instance)
 		tracecmd_put_tracing_file(path);
 	}
 }
-/*
- * This function contains common code for the following commands:
- * record, start, stream, profile.
- */
+
 static void record_trace(int argc, char **argv,
 			 struct common_record_context *ctx)
 {
@@ -6080,12 +6077,24 @@ static void record_trace(int argc, char **argv,
 	finalize_record_trace(ctx);
 }
 
+/*
+ * This function contains common code for the following commands:
+ * record, start, stream, profile.
+ */
+static void record_trace_command(int argc, char **argv,
+				 struct common_record_context *ctx)
+{
+	tracecmd_tsync_init();
+	record_trace(argc, argv, ctx);
+}
+
+
 void trace_start(int argc, char **argv)
 {
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_start, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6165,7 +6174,7 @@ void trace_stream(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_stream, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6184,7 +6193,7 @@ void trace_profile(int argc, char **argv)
 	if (!buffer_instances)
 		top_instance.flags |= BUFFER_FL_PROFILE;
 
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	do_trace_profile();
 	exit(0);
 }
@@ -6203,7 +6212,7 @@ void trace_record(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_record, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
-- 
2.23.0

