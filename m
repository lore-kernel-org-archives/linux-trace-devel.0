Return-Path: <SRS0=entZ=EE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65586C2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAF76207DE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JzEZr7Hm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbgJ2LSh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727621AbgJ2LSg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:18:36 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E25FC0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:36 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id c18so1987540wme.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GFmJWqSrBeXK6HVG0PK9BM+SuOjw1FTFkb77Gkja/Bc=;
        b=JzEZr7HmtXVeTZFBYl2xgvZVPeB200Pa+p/H5ZDTcpPDXW7vTVlSY8uvl1oYkmpfkm
         AY1aP91SR6aljsuv7VgSEQGIhudHhqp4W/YxrS+neDQnvjUsSLqs8bRBHA5zBgiVMLvJ
         iyxNhFycS+W+F5vHdYysft+GyNG0K1YBSJNJWtlspWU9+TULnvgD76m9hvcIMJLT4PT8
         rfNkVxUh5g9FtBi+L82R37YONZ9odS19GUwgE1llDGU1juT5wUB1Lmipx3GSQiqizNcj
         SG6jIlY3JsZ+rX8RzNG63WSmx/l9B3zu3pWXtlGtlxfo18YBO/iruABV7jeajmTO1pFl
         6VjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GFmJWqSrBeXK6HVG0PK9BM+SuOjw1FTFkb77Gkja/Bc=;
        b=haTflWi/uLui21idICgL/jlK59jLObfd2NWKIFSVOmuH6CRVo7O/JtNFMe/T5Eii0S
         UGlTmYeqhIpv68SB4qn/e66sZ2FkPEGqK3/XdvoLxk5b6gdehtxEdA4uCzJMZQ1nZImp
         fQzGaNNXccWM8ohRkRop9kHBqr3L6jB21RfKv3ooasI7/SML6rYjObrWr5vEtM7Yr0vI
         1m22+/7g2ZajWlaGFINJ3ilAm4xyzZ5eUm36Qm6ZDBbdm5RynttVTE1fH0UpEHCtZyEO
         eUFGC/0H1rjSaaA9HCILkcnPAqbWMnxWcFFldVE20LHo59cendhN9d4swB6wncIFAccl
         7kDA==
X-Gm-Message-State: AOAM530sVvkpRxZTGDMoszeG8zDo0ivwK6lYpyO4goFEd4UKIxuqy3bi
        iMVxgWbrALk6wHAq7Rc2LoL5CPEyzQmc/+bq
X-Google-Smtp-Source: ABdhPJzfFaeX10ZxsVzSaU4jLI2XNQ2B+sFbSeXHegQtrJUr+v+218AQfk9JCLrIMrGhgCP8DWyZAg==
X-Received: by 2002:a1c:2601:: with SMTP id m1mr3659456wmm.12.1603970314915;
        Thu, 29 Oct 2020 04:18:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a199sm4308067wmd.8.2020.10.29.04.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:18:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v25 14/16] trace-cmd: [POC] PTP-like algorithm for host - guest timestamp synchronization
Date:   Thu, 29 Oct 2020 13:18:14 +0200
Message-Id: <20201029111816.247241-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029111816.247241-1-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 lib/trace-cmd/Makefile             |   1 +
 lib/trace-cmd/trace-timesync-ptp.c | 714 +++++++++++++++++++++++++++++
 lib/trace-cmd/trace-timesync.c     |   2 +-
 3 files changed, 716 insertions(+), 1 deletion(-)
 create mode 100644 lib/trace-cmd/trace-timesync-ptp.c

diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 666a1ebf..7cab7514 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -18,6 +18,7 @@ OBJS += trace-msg.o
 OBJS += trace-plugin.o
 ifeq ($(VSOCK_DEFINED), 1)
 OBJS += trace-timesync.o
+OBJS += trace-timesync-ptp.o
 endif
 
 # Additional util objects
diff --git a/lib/trace-cmd/trace-timesync-ptp.c b/lib/trace-cmd/trace-timesync-ptp.c
new file mode 100644
index 00000000..d043053f
--- /dev/null
+++ b/lib/trace-cmd/trace-timesync-ptp.c
@@ -0,0 +1,714 @@
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
+#include <limits.h>
+
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
+#define PTP_SYNC_LOOP	339
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
+	struct tep_format_field	*id;
+	int			raw_id;
+	int			marker_fd;
+	int			series_id;
+	int			flags;
+	int			debug_fd;
+};
+
+enum {
+/*
+ * Consider only the probe with fastest response time,
+ * otherwise make a histogram from all probes.
+ */
+	PTP_FLAG_FASTEST_RESPONSE		= (1 << 0),
+/*
+ * Use trace marker to get the clock,
+ * otherwise use the system clock directly.
+ */
+	PTP_FLAG_USE_MARKER			= (1 << 1),
+};
+static int ptp_flags = PTP_FLAG_FASTEST_RESPONSE | PTP_FLAG_USE_MARKER;
+
+/*
+ * Calculated using formula [CPU rate]*[calculated offset deviation]
+ * tested on 3GHz CPU, with x86-tsc trace clock and compare the calculated
+ * offset with /sys/kernel/debug/kvm/<VM ID>/vcpu0/tsc-offset
+ * measured 2000ns deviation
+ * using PTP flags PTP_FLAG_FASTEST_RESPONSE | PTP_FLAG_USE_MARKER
+*/
+#define PTP_ACCURACY	6000
+#define PTP_NAME	"ptp"
+
+struct ptp_clock_start_msg {
+	be32	series_id;
+	be32	flags;
+} __packed;
+
+struct ptp_clock_sample {
+	s64		ts;
+	be32		id;
+} __packed;
+
+struct ptp_clock_result_msg {
+	be32			series_id;
+	be32			count;
+	struct ptp_clock_sample	samples[2*PTP_SYNC_LOOP];
+} __packed;
+
+struct ptp_clock_offset_msg {
+	s64	ts;
+	s64	offset;
+};
+
+struct ptp_markers_context {
+	struct clock_sync_context	*clock;
+	struct ptp_clock_sync		*ptp;
+	struct ptp_clock_result_msg	msg;
+	int				size;
+};
+
+struct ptp_marker_buf {
+	int local_cid;
+	int remote_cid;
+	int count;
+	int packet_id;
+} __packed;
+
+struct ptp_marker {
+	int series_id;
+	struct ptp_marker_buf data;
+} __packed;
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
+	ptp->id = tep_find_field(raw, "id");
+	if (!ptp->id)
+		goto error;
+	ptp->raw_id = raw->id;
+
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
+/* Save the timestamps of sent ('s') and returned ('r') probes in the
+ * ctx->msg.samples[] array. Depending of the context (server or client), there
+ * may be only returned probes, or both sent and returned probes. The returned
+ * probes are saved first in the array, after them are the sent probes.
+ * Depending of the context, the array can be with size:
+ *  [0 .. max data.count] - holds only returned probes
+ *  [0 .. 2 * max data.count] - holds both returned and sent probes
+ *  */
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
+		  marker->data.count * 2 <= ctx->size){
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
+	struct ptp_marker *marker;
+
+	ctx = (struct ptp_markers_context *)context;
+
+	/* Make sure this is our event */
+	if (event->id != ctx->ptp->raw_id || !ctx->ptp->id)
+		return 0;
+	if (record->size >= (ctx->ptp->id->offset + sizeof(struct ptp_marker))) {
+		marker = (struct ptp_marker *)(record->data + ctx->ptp->id->offset);
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
+static inline bool good_probe(struct ptp_clock_sample *server_sample,
+			      struct ptp_clock_sample *send_sample,
+			      struct ptp_clock_sample *client_sample,
+			      int *bad_probes)
+{
+	if (server_sample->ts && send_sample->ts && client_sample->ts &&
+	    server_sample->id == send_sample->id &&
+	    server_sample->id == client_sample->id)
+		return true;
+	(*bad_probes)++;
+	return false;
+}
+
+static int ptp_calc_offset_fastest(struct clock_sync_context *clock,
+			   struct ptp_clock_result_msg *server,
+			   struct ptp_clock_result_msg *client,
+			   long long *offset_ret, long long *ts_ret,
+			   int *bad_probes)
+{
+	struct ptp_clock_sample *sample_send;
+	long long delta_min = LLONG_MAX;
+	long long offset = 0;
+	long long delta = 0;
+	long long ts = 0;
+	int max_i;
+	int i;
+
+	*bad_probes = 0;
+	sample_send = server->samples + (server->count / 2);
+	max_i = server->count / 2 < client->count ?
+		server->count / 2 : client->count;
+	for (i = 0; i < max_i; i++) {
+		if (!good_probe(&server->samples[i], &sample_send[i],
+		    &client->samples[i], bad_probes))
+			continue;
+		ts = (sample_send[i].ts + server->samples[i].ts) / 2;
+		offset = client->samples[i].ts - ts;
+
+		delta = server->samples[i].ts - sample_send[i].ts;
+		if (delta_min > delta) {
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
+	long long offset_min = LLONG_MAX;
+	long long offset_max = 0;
+	int hist[PTP_SYNC_LOOP];
+	int ind, max = 0;
+	long long bin;
+	int i, k = 0;
+
+	*bad_probes = 0;
+	memset(hist, 0, sizeof(int) * PTP_SYNC_LOOP);
+	sample_send = server->samples + (server->count / 2);
+	for (i = 0; i * 2 < server->count && i < client->count; i++) {
+		if (!good_probe(&server->samples[i], &sample_send[i],
+		    &client->samples[i], bad_probes))
+			continue;
+		timestamps[k] = (sample_send[i].ts + server->samples[i].ts) / 2;
+		offsets[k] = client->samples[i].ts - timestamps[k];
+		if (offset_max < llabs(offsets[k]))
+			offset_max = llabs(offsets[k]);
+		if (offset_min > llabs(offsets[k]))
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
+	char sync_proto[TRACECMD_TSYNC_PNAME_LENGTH];
+	struct clock_sync_context *clock_context;
+	struct ptp_clock_offset_msg res_offset;
+	struct ptp_clock_start_msg start;
+	struct ptp_markers_context ctx;
+	struct ptp_clock_sync *ptp;
+	struct ptp_marker marker;
+	unsigned int sync_msg;
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
+					  sync_proto, &sync_msg,
+					  &size, &msg);
+	if (ret || strncmp(sync_proto, PTP_NAME, TRACECMD_TSYNC_PNAME_LENGTH) ||
+	    sync_msg != PTP_SYNC_PKT_START)
+		return -1;
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle, PTP_NAME,
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
+						  sync_proto, &sync_msg,
+						  &size, &msg);
+		if (ret || strncmp(sync_proto, PTP_NAME, TRACECMD_TSYNC_PNAME_LENGTH) ||
+		    sync_msg != PTP_SYNC_PKT_PROBE || !ntohl(count))
+			break;
+		marker.data.count = ntohl(count);
+		ptp_track_clock(&ctx, &marker);
+		ret = tracecmd_msg_send_time_sync(tsync->msg_handle, PTP_NAME,
+						  PTP_SYNC_PKT_PROBE,
+						  sizeof(count), (char *)&count);
+		if (ret)
+			break;
+	}
+
+	if (strncmp(sync_proto, PTP_NAME, TRACECMD_TSYNC_PNAME_LENGTH) ||
+	    sync_msg != PTP_SYNC_PKT_END)
+		return -1;
+
+	if (ptp->flags & PTP_FLAG_USE_MARKER)
+		tracefs_iterate_raw_events(ptp->tep, clock_context->instance,
+					   ptp_marker_find, &ctx);
+
+	hton_ptp_results(&ctx.msg);
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle, PTP_NAME,
+					  PTP_SYNC_PKT_PROBES,
+					  sizeof(ctx.msg), (char *)&ctx.msg);
+
+	msg = (char *)&res_offset;
+	size = sizeof(res_offset);
+	ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+					  sync_proto, &sync_msg,
+					  &size, (char **)&msg);
+	if (ret || strncmp(sync_proto, PTP_NAME, TRACECMD_TSYNC_PNAME_LENGTH) ||
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
+	char sync_proto[TRACECMD_TSYNC_PNAME_LENGTH];
+	struct ptp_clock_result_msg *results = NULL;
+	struct clock_sync_context *clock_context;
+	struct ptp_clock_offset_msg res_offset;
+	struct ptp_clock_start_msg start;
+	struct ptp_markers_context ctx;
+	int sync_loop = PTP_SYNC_LOOP;
+	struct ptp_clock_sync *ptp;
+	struct ptp_marker marker;
+	unsigned int sync_msg;
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
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle, PTP_NAME,
+					 PTP_SYNC_PKT_START, sizeof(start),
+					 (char *)&start);
+	if (!ret)
+		ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+						  sync_proto, &sync_msg,
+						  NULL, NULL);
+	if (ret || strncmp(sync_proto, PTP_NAME, TRACECMD_TSYNC_PNAME_LENGTH) ||
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
+		ret = tracecmd_msg_send_time_sync(tsync->msg_handle, PTP_NAME,
+						 PTP_SYNC_PKT_PROBE,
+						 sizeof(msg_count),
+						 (char *)&msg_count);
+		if (!ret)
+			ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+							  sync_proto, &sync_msg,
+							  &size, &msg);
+
+		marker.data.packet_id = 'r';
+		ptp_track_clock(&ctx, &marker);
+		if (ret || strncmp(sync_proto, PTP_NAME, TRACECMD_TSYNC_PNAME_LENGTH) ||
+		    sync_msg != PTP_SYNC_PKT_PROBE ||
+		    ntohl(msg_ret) != marker.data.count)
+			break;
+	} while (--sync_loop);
+
+	if (sync_loop)
+		return -1;
+
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle, PTP_NAME,
+					  PTP_SYNC_PKT_END, 0, NULL);
+
+	size = 0;
+	ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+					  sync_proto, &sync_msg,
+					  &size, (char **)&results);
+	if (ret || strncmp(sync_proto, PTP_NAME, TRACECMD_TSYNC_PNAME_LENGTH) ||
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
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle, PTP_NAME,
+					  PTP_SYNC_PKT_OFFSET,
+					  sizeof(res_offset),
+					  (char *)&res_offset);
+
+	free(results);
+	return 0;
+}
+
+static int ptp_clock_sync_calc(struct tracecmd_time_sync *tsync,
+			       long long *offset, long long *scaling,
+			       long long *timestamp, unsigned int cpu)
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
+	if (scaling)
+		*scaling = 1;
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
+	return tracecmd_tsync_proto_register(PTP_NAME, PTP_ACCURACY,
+					     TRACECMD_TIME_SYNC_ROLE_GUEST |
+					     TRACECMD_TIME_SYNC_ROLE_HOST,
+					     0, TRACECMD_TSYNC_FLAG_INTERPOLATE,
+					     ptp_clock_sync_init,
+					     ptp_clock_sync_free,
+					     ptp_clock_sync_calc);
+
+}
+
+int ptp_clock_sync_unregister(void)
+{
+	return tracecmd_tsync_proto_unregister(PTP_NAME);
+}
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index c8c1f287..77d65f3b 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -64,7 +64,7 @@ static struct tsync_proto *tsync_proto_find(char *proto_name)
  */
 void tracecmd_tsync_init(void)
 {
-
+	ptp_clock_sync_register();
 }
 
 int tracecmd_tsync_proto_register(char *proto_name, int accuracy, int roles,
-- 
2.26.2

