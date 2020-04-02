Return-Path: <SRS0=JQUT=5S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFEBC2D0F3
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 15:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBF6F2072E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 15:06:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AQ23g97w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388910AbgDBPGS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Apr 2020 11:06:18 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41190 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389046AbgDBPGS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Apr 2020 11:06:18 -0400
Received: by mail-lf1-f66.google.com with SMTP id z23so3005139lfh.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Apr 2020 08:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eztQKml6A9oRYhhZ2uT49TFzeyIi7K4B/1RzQ46Mhd4=;
        b=AQ23g97wXMscQVb3xkSek/vviLOBx56WhwuwN+RU6J3M2k+Nkq64UW/sTYfEzv89c9
         zaHvPqaXvczeQSYM1q0076GcBQeyz3L2VCiEfrioD+3VvZfnzTq2Nf+Nxr7sKd3gHGbt
         vh9lBSgYdzCrm0YDRmGsjrA6zLcJDnFxDsp8aBADkXyIkPqmsNV/517WNAL3OBUpJs7v
         AarTNLBJbiGz/bfczGTqXFVlnAT39IOApUz6sOrrYIBgYMUODTD/Y6sJCn0a3cXqHzwz
         Q9AnQ6Rh9N02CnVh2SmuN1mV4e9qA2BlpFNGMeW4lABTabILWM3Ye5jNJA5Mj8Ox+yMm
         7bmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eztQKml6A9oRYhhZ2uT49TFzeyIi7K4B/1RzQ46Mhd4=;
        b=XRuJiwNd6W3orhvPNUMxzVD0EVpaqkRkev/xZYukkCsvhr/2j0CkqsoAQbavJF/2Tk
         0NAWUjlF8TWDWJ9q+kY1vEW8LpK71CszcIje8LPxJS0ptnv77iYbRbExGZxdPBnFFMqI
         HlMop6S1lD6rGx5EDog3v737wjVcEBdUi3OvbI9mA051otN8AmNZ2zEN5FVjsvZYkXTL
         XT7Snl1UgvYdkqJdE2CAT5MBOT10786mjoahfDJ6mvgOZ+I7vnHxzhnBkfswXCtpbTr/
         BrIVSCpiUhZd9/KAui1IwjB4iGMuoLYaty3iBE3v5LZRYw1sDDoqGoCdWsU69J99uXXT
         MMlA==
X-Gm-Message-State: AGi0PuYQqxlBBcFyhpG9KzNRl/i13xYsDka3U8K4TeDTNesFlNZNsAc1
        pWZAijdm2Eeih1Z4zkLHNOPn4JJaUW4=
X-Google-Smtp-Source: APiQypIWM1mQPxXJc2JJFe9adh/dFU5dLIsiKIXzx0nmAntpdSzJkeF9rW3YwCdeByGfKglgShmkIw==
X-Received: by 2002:a19:a40f:: with SMTP id q15mr2413144lfc.104.1585839974792;
        Thu, 02 Apr 2020 08:06:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v9sm3489562ljj.31.2020.04.02.08.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 08:06:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v23 1/2] trace-cmd: [POC] PTP-like algorithm for host - guest timestamp synchronization
Date:   Thu,  2 Apr 2020 18:06:09 +0300
Message-Id: <20200402150610.290703-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402150610.290703-1-tz.stoyanov@gmail.com>
References: <20200402150610.290703-1-tz.stoyanov@gmail.com>
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
    is used for calculating the clocks offset. Otherwise the histogram of all samples is used.
 - #define PTP_SYNC_LOOP 340 - defines the number of samples, used for one calculation.
 - --tsync-interval - a trace-cmd argument, choose the intervals between offset calculations,
	performed continuously during the trace.
 - #define TSYNC_DEBUG - if defined, a debug information is collected and stored in files,
   in the guest machine:
     s-cid*.txt - For each offset calculation: host and guest clocks and calculated offset.
     res-cid*.txt - For each tracing session: all calculated clock offsets.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h      |   1 +
 lib/trace-cmd/Makefile             |   1 +
 lib/trace-cmd/trace-timesync-ptp.c | 690 +++++++++++++++++++++++++++++
 lib/trace-cmd/trace-timesync.c     |   8 +
 tracecmd/trace-agent.c             |   2 +
 tracecmd/trace-record.c            |  23 +-
 6 files changed, 717 insertions(+), 8 deletions(-)
 create mode 100644 lib/trace-cmd/trace-timesync-ptp.c

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 595919d5..2574edd0 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -414,6 +414,7 @@ int tracecmd_msg_recv_time_sync(struct tracecmd_msg_handle *msg_handle,
 
 enum{
 	TRACECMD_TIME_SYNC_PROTO_NONE	= 0,
+	TRACECMD_TIME_SYNC_PROTO_PTP	= 1,
 };
 enum{
 	TRACECMD_TIME_SYNC_CMD_PROBE	= 1,
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index ab7440ac..79672529 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -17,6 +17,7 @@ OBJS += trace-filter-hash.o
 OBJS += trace-msg.o
 OBJS += trace-plugin.o
 OBJS += trace-timesync.o
+OBJS += trace-timesync-ptp.o
 
 # Additional util objects
 OBJS += trace-blk-hack.o
diff --git a/lib/trace-cmd/trace-timesync-ptp.c b/lib/trace-cmd/trace-timesync-ptp.c
new file mode 100644
index 00000000..19e2f647
--- /dev/null
+++ b/lib/trace-cmd/trace-timesync-ptp.c
@@ -0,0 +1,690 @@
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
+#include "tracefs.h"
+#include "trace-tsync-local.h"
+#include "trace-msg.h"
+#include "trace-cmd-local.h"
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
+/* print time sync debug messages */
+#define TSYNC_DEBUG
+
+struct ptp_clock_sync {
+	struct tep_handle	*tep;
+	int			raw_id;
+	int			marker_fd;
+	int			series_id;
+	int			flags;
+	int			debug_fd;
+};
+
+enum {
+/* Consider only the probe with fastest response time,
+ * otherwise make a histogram from all probes.
+ */
+	PTP_FLAG_FASTEST_RESPONSE		= (1 << 0),
+/* Use trace marker to get the clock,
+ * otherwise use directly the system clock
+ */
+	PTP_FLAG_USE_MARKER			= (1 << 1),
+};
+static int ptp_flags = PTP_FLAG_FASTEST_RESPONSE | PTP_FLAG_USE_MARKER;
+
+struct ptp_clock_start_msg {
+	be32	series_id;
+	be32	flags;
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
+struct ptp_marker {
+	int series_id;
+	struct ptp_marker_buf data;
+} __attribute__((packed));
+
+static int ptp_clock_sync_init(struct tracecmd_time_sync *tsync)
+{
+	const char *systems[] = {"ftrace", NULL};
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
+	path = tracefs_instance_get_dir(clock_context->instance);
+	if (!path)
+		goto error;
+	ptp->tep = tracefs_local_events_system(path, systems);
+	tracefs_put_tracing_file(path);
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
+	path = tracefs_instance_get_file(clock_context->instance, "trace_marker_raw");
+	if (!path)
+		goto error;
+	ptp->marker_fd = open(path, O_WRONLY);
+	tracefs_put_tracing_file(path);
+
+	clock_context->proto_data = ptp;
+
+#ifdef TSYNC_DEBUG
+	if (clock_context->is_server) {
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
+static void ptp_probe_store(struct ptp_markers_context *ctx,
+			    struct ptp_marker *marker,
+			    unsigned long long ts)
+{
+	int index = -1;
+
+	if (marker->data.packet_id == 'r' &&
+	    marker->data.count <= ctx->size) {
+		index = marker->data.count - 1;
+	} else if (marker->data.packet_id == 's' &&
+		  marker->data.count*2 <= ctx->size){
+		index = ctx->size / 2 + marker->data.count - 1;
+	}
+
+	if (index >= 0) {
+		ctx->msg.samples[index].id = marker->data.count;
+		ctx->msg.samples[index].ts = ts;
+		ctx->msg.count++;
+	}
+}
+
+static int ptp_marker_find(struct tep_event *event, struct tep_record *record,
+			   int cpu, void *context)
+{
+	struct ptp_markers_context *ctx;
+	struct tep_format_field *field;
+	struct tep_format_field *id;
+	struct ptp_marker *marker;
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
+		    marker->data.count)
+			ptp_probe_store(ctx, marker, record->ts);
+	}
+
+	return 0;
+}
+
+static int ptp_calc_offset_fastest(struct clock_sync_context *clock,
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
+static int ptp_calc_offset_hist(struct clock_sync_context *clock,
+			   struct ptp_clock_result_msg *server,
+			   struct ptp_clock_result_msg *client,
+			   long long *offset_ret, long long *ts_ret,
+			   int *bad_probes)
+{
+	struct ptp_clock_sample *sample_send;
+	long long timestamps[PTP_SYNC_LOOP];
+	long long offsets[PTP_SYNC_LOOP];
+	int hist[PTP_SYNC_LOOP];
+	long long offset_max = 0;
+	long long offset_min = 0;
+	int ind, max = 0;
+	long long bin;
+	int i, k = 0;
+
+	*bad_probes = 0;
+	memset(hist, 0, sizeof(int) * PTP_SYNC_LOOP);
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
+
+	bin = (offset_max - offset_min) / PTP_SYNC_LOOP;
+	for (i = 0; i < k; i++) {
+		ind = (llabs(offsets[i]) - offset_min) / bin;
+		if (ind < PTP_SYNC_LOOP) {
+			hist[ind]++;
+			if (max < hist[ind]) {
+				max = hist[ind];
+				*offset_ret = offsets[i];
+				*ts_ret = timestamps[i];
+			}
+		}
+	}
+
+	return 0;
+}
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
+static inline void ptp_track_clock(struct ptp_markers_context *ctx,
+				   struct ptp_marker *marker)
+{
+	if (ctx->ptp->flags & PTP_FLAG_USE_MARKER) {
+		write(ctx->ptp->marker_fd, marker, sizeof(struct ptp_marker));
+	} else {
+		struct timespec clock;
+		unsigned long long ts;
+
+		clock_gettime(CLOCK_MONOTONIC_RAW, &clock);
+		ts = clock.tv_sec * 1000000000LL;
+		ts += clock.tv_nsec;
+		ptp_probe_store(ctx, marker, ts);
+	}
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
+					  TRACECMD_TIME_SYNC_PROTO_PTP,
+					  PTP_SYNC_PKT_START, sizeof(start),
+					  (char *)&start);
+	marker.data.local_cid = clock_context->local_cid;
+	marker.data.remote_cid = clock_context->remote_cid;
+	marker.series_id = ntohl(start.series_id);
+	marker.data.packet_id = 'r';
+	ptp->series_id = marker.series_id;
+	ptp->flags = ntohl(start.flags);
+	msg = (char *)&count;
+	size = sizeof(count);
+	ctx.msg.count = 0;
+	ctx.size = PTP_SYNC_LOOP;
+	ctx.ptp = ptp;
+	ctx.clock = clock_context;
+	ctx.msg.series_id = ptp->series_id;
+	while (true) {
+		count = 0;
+		ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+						  &sync_proto, &sync_msg,
+						  &size, &msg);
+		if (ret || sync_proto != TRACECMD_TIME_SYNC_PROTO_PTP ||
+		    sync_msg != PTP_SYNC_PKT_PROBE || !ntohl(count))
+			break;
+		marker.data.count = ntohl(count);
+		ptp_track_clock(&ctx, &marker);
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
+	if (ptp->flags & PTP_FLAG_USE_MARKER)
+		tracefs_iterate_raw_events(ptp->tep, clock_context->instance,
+					   ptp_marker_find, &ctx);
+
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
+	ptp->flags = ptp_flags;
+	memset(&start, 0, sizeof(start));
+	start.series_id = htonl(ptp->series_id + 1);
+	start.flags = htonl(ptp->flags);
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
+	tracefs_instance_file_write(clock_context->instance, "trace", "\0");
+
+	ptp->series_id++;
+	marker.data.local_cid = clock_context->local_cid;
+	marker.data.remote_cid = clock_context->remote_cid;
+	marker.series_id = ptp->series_id;
+	msg = (char *)&msg_ret;
+	size = sizeof(msg_ret);
+	ctx.size = 2*PTP_SYNC_LOOP;
+	ctx.ptp = ptp;
+	ctx.clock = clock_context;
+	ctx.msg.count = 0;
+	ctx.msg.series_id = ptp->series_id;
+	do {
+		marker.data.count = count++;
+		marker.data.packet_id = 's';
+		msg_count = htonl(marker.data.count);
+		ptp_track_clock(&ctx, &marker);
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
+		ptp_track_clock(&ctx, &marker);
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
+	if (ptp->flags & PTP_FLAG_USE_MARKER)
+		tracefs_iterate_raw_events(ptp->tep, clock_context->instance,
+					   ptp_marker_find, &ctx);
+	if (ptp->flags & PTP_FLAG_FASTEST_RESPONSE)
+		ptp_calc_offset_fastest(clock_context, &ctx.msg, results, offset,
+					timestamp, &bad_probes);
+	else
+		ptp_calc_offset_hist(clock_context, &ctx.msg, results, offset,
+				     timestamp, &bad_probes);
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
+		printf("\n calculated offset %d: %lld, %d probes, filtered out %d, PTP flags 0x%X\n\r",
+			ptp->series_id, *offset, results->count, bad_probes, ptp->flags);
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
+	if (clock_context->is_server) {
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
+	if (clock_context->is_server)
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
index 35a41394..e294698b 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -46,6 +46,14 @@ static struct tsync_proto *tsync_proto_find(unsigned int proto_id)
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
index b5816966..2fd09dc3 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -247,6 +247,8 @@ static void agent_serve(unsigned int port)
 	if (sd < 0)
 		die("Failed to open vsocket");
 
+	tracecmd_tsync_init();
+
 	if (!get_local_cid(&cid))
 		printf("listening on @%u:%u\n", cid, port);
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c8c853f8..ffc91011 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6141,10 +6141,6 @@ static bool has_local_instances(void)
 	return false;
 }
 
-/*
- * This function contains common code for the following commands:
- * record, start, stream, profile.
- */
 static void record_trace(int argc, char **argv,
 			 struct common_record_context *ctx)
 {
@@ -6278,12 +6274,23 @@ static void record_trace(int argc, char **argv,
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
 void trace_start(int argc, char **argv)
 {
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_start, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6363,7 +6370,7 @@ void trace_stream(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_stream, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
@@ -6382,7 +6389,7 @@ void trace_profile(int argc, char **argv)
 	if (!buffer_instances)
 		top_instance.flags |= BUFFER_FL_PROFILE;
 
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	do_trace_profile();
 	exit(0);
 }
@@ -6401,7 +6408,7 @@ void trace_record(int argc, char **argv)
 	struct common_record_context ctx;
 
 	parse_record_options(argc, argv, CMD_record, &ctx);
-	record_trace(argc, argv, &ctx);
+	record_trace_command(argc, argv, &ctx);
 	exit(0);
 }
 
-- 
2.25.1

