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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF97C5517A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E224B20796
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DBjuVX7D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgJ2LSc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbgJ2LSa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:18:30 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D4BC0613D6
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:30 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id g12so2295277wrp.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/8HbSdB54x7E8G2EXVhBEWSLLRb1LNpRPsHVyJ2xjTw=;
        b=DBjuVX7DUaia5Jh3oaxw2v+86UYIDmTZJ5SxNfKdxc7Pl70X+F4dxvpePoDB9ewiZF
         DCtcUv1tAt7UnW2i0uSDxaJxkHBujwf2rXXDf+baQFrD15qmb/M1P9yUSmz8SEj6oBAS
         h68XTLN8fSLZCWm0je8IRdhCRbZpus0VZWHKdttR2LrNNY3p1qKXVTFQgOWFhHUS37fn
         eOidl6mwc22ER8Dj/zT2gUNm2gequXN2oduR+8daG1JN3q9apW2ge/0jU7Vm8Cnjtyed
         A8oVYxL2TgTFwQOlXWN33cFvQTefAtnoMmjI5nwBusiFXcYyflx524k7PpTrryqoBi0Q
         DB8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/8HbSdB54x7E8G2EXVhBEWSLLRb1LNpRPsHVyJ2xjTw=;
        b=BzuSMmlEgSK6GC8i8ykl81BzV173+m8V7pgFs1+SiLUt57bvbHYxgJwJjr7Gy5fVBu
         Jj2o62fw3CW8D4A1r0u7jOI4lZy0T0rt45ybOc6eLReqAs/oi6C5UqYq0qlVXFZU9Q8V
         PAe1tmvZv1gV/hNlcFkxqdGXPTqX9VAMoS8sz3IoW1FzLx3HvbIMXipV2VlABE1DFIXX
         PxqmpXmWbKU3wuyu+38kYG+VrSDnPPTWU4kVWoE/OOMVgmU4Ejjo+Ql37BZbkvDDyiiX
         Z5lnJEwlIhZBBbPd95+UDtb8BcZXtr708yIoFw+u9OEZ+xnnU00I1r0lhU9mnDDOcDr8
         Qg3g==
X-Gm-Message-State: AOAM532cVWDY1RgiH3pbiV1U0SpMlqNrovJfIKbkeXRlPv1OcMVYwUXG
        1dtJqQBc7Xh+sBZSruiyv7n33YZFN66w/YuI
X-Google-Smtp-Source: ABdhPJx4pt+N7lbAmt8EG3ka66SWcSSHqkyTGnj4JHsM7UKPIKmbxK7uVaq9KBnzC94CrBTfFuZLiQ==
X-Received: by 2002:a5d:54d0:: with SMTP id x16mr4818396wrv.75.1603970309097;
        Thu, 29 Oct 2020 04:18:29 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a199sm4308067wmd.8.2020.10.29.04.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:18:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v25 09/16] trace-cmd: Add scaling ratio for timestamp correction
Date:   Thu, 29 Oct 2020 13:18:09 +0200
Message-Id: <20201029111816.247241-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029111816.247241-1-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some hypervisors support guest time scaling by given ratio, additional
to the time offset. The guest time is calculated using the formula:
 guest time = host time * scaling ratio + time offset
Scaling is useful in case of guest VM migration to a different host
machine.
The scaling parameter is added to timestamp synchronization algorithms.
It is saved in trace.dat file metadata and is used in timestamp
calculations when reading the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h             |  4 +--
 lib/trace-cmd/include/trace-tsync-local.h | 11 +++++---
 lib/trace-cmd/trace-input.c               |  8 +++++-
 lib/trace-cmd/trace-timesync.c            | 32 +++++++++++++++++------
 tracecmd/trace-dump.c                     | 11 ++++++--
 tracecmd/trace-tsync.c                    | 16 +++++++-----
 6 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 9629d074..6a6e4061 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -464,8 +464,8 @@ bool tsync_proto_is_supported(char *proto_name);
 void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
 void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
-				int *count,
-				long long **ts, long long **offsets);
+				int *count, long long **ts,
+				long long **offsets, long long **scalings);
 void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
 
 /* --- Plugin handling --- */
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 793737e8..492a0a90 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -15,10 +15,15 @@ struct clock_sync_context {
 	struct tracefs_instance		*instance;	/* ftrace buffer, used for time sync events */
 
 	/* Arrays with calculated time offsets at given time */
-	int				sync_size;	/* Allocated size of sync_ts and sync_offsets */
-	int				sync_count;	/* Number of elements in sync_ts and sync_offsets */
+	int				sync_size;	/* Allocated size of sync_ts,
+							 * sync_offsets and sync_scalings
+							 */
+	int				sync_count;	/* Number of elements in sync_ts,
+							 * sync_offsets and sync_scalings
+							 */
 	long long			*sync_ts;
 	long long			*sync_offsets;
+	long long			*sync_scalings;
 
 	/* Identifiers of local and remote time sync peers: cid and port */
 	unsigned int			local_cid;
@@ -32,7 +37,7 @@ int tracecmd_tsync_proto_register(char *proto_name, int accuracy, int roles,
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
 				  int (*calc)(struct tracecmd_time_sync *,
-					      long long *, long long *));
+					      long long *, long long *, long long *));
 int tracecmd_tsync_proto_unregister(char *proto_name);
 
 int ptp_clock_sync_register(void);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index af97883e..1ac50f48 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -80,6 +80,7 @@ struct input_buffer_instance {
 struct ts_offset_sample {
 	long long	time;
 	long long	offset;
+	long long	scaling;
 };
 
 struct guest_trace_info {
@@ -1123,12 +1124,14 @@ static inline unsigned long long
 timestamp_correction_calc(unsigned long long ts, struct ts_offset_sample *min,
 			  struct ts_offset_sample *max)
 {
+	long long scaling = (min->scaling + max->scaling) / 2;
 	long long offset = ((long long)ts - min->time) *
 			   (max->offset - min->offset);
 	long long delta = max->time - min->time;
 	long long tscor = min->offset +
 			(offset + delta / 2) / delta;
 
+	ts *= scaling;
 	if (tscor < 0)
 		return ts - llabs(tscor);
 
@@ -2181,7 +2184,9 @@ static void tsync_offset_load(struct tracecmd_input *handle, char *buf)
 		host->ts_samples[i].time = tep_read_number(handle->pevent,
 							   buf8 + i, 8);
 		host->ts_samples[i].offset = tep_read_number(handle->pevent,
-						buf8 + host->ts_samples_count+i, 8);
+						buf8 + host->ts_samples_count + i, 8);
+		host->ts_samples[i].scaling = tep_read_number(handle->pevent,
+						buf8 + (2 * host->ts_samples_count) + i, 8);
 	}
 	qsort(host->ts_samples, host->ts_samples_count,
 	      sizeof(struct ts_offset_sample), tsync_offset_cmp);
@@ -2534,6 +2539,7 @@ static int handle_options(struct tracecmd_input *handle)
 			 * long long array of size [count] of times,
 			 *      when the offsets were calculated.
 			 * long long array of size [count] of timestamp offsets.
+			 * long long array of size [count] of timestamp scaling ratios.*
 			 */
 			if (size < 12 || handle->flags & TRACECMD_FL_IGNORE_DATE)
 				break;
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 12e00686..1036917e 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -32,7 +32,8 @@ struct tsync_proto {
 	int (*clock_sync_init)(struct tracecmd_time_sync *clock_context);
 	int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
 	int (*clock_sync_calc)(struct tracecmd_time_sync *clock_context,
-			       long long *offset, long long *timestamp);
+			       long long *offset, long long *scaling,
+			       long long *timestamp);
 };
 
 static struct tsync_proto *tsync_proto_list;
@@ -56,7 +57,7 @@ int tracecmd_tsync_proto_register(char *proto_name, int accuracy, int roles,
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
 				  int (*calc)(struct tracecmd_time_sync *,
-					      long long *, long long *))
+					      long long *, long long *, long long *))
 {
 	struct tsync_proto *proto = NULL;
 
@@ -113,12 +114,13 @@ bool tsync_proto_is_supported(char *proto_name)
  * @count: Returns the number of calculated time offsets
  * @ts: Array of size @count containing timestamps of callculated offsets
  * @offsets: array of size @count, containing offsets for each timestamp
+ * @scalings: array of size @count, containing scaling ratios for each timestamp
  *
  * Retuns -1 in case of an error, or 0 otherwise
  */
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
-				int *count,
-				long long **ts, long long **offsets)
+				int *count, long long **ts,
+				long long **offsets, long long **scalings)
 {
 	struct clock_sync_context *tsync_context;
 
@@ -131,6 +133,9 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
 		*ts = tsync_context->sync_ts;
 	if (offsets)
 		*offsets = tsync_context->sync_offsets;
+	if (scalings)
+		*scalings = tsync_context->sync_scalings;
+
 	return 0;
 }
 
@@ -349,8 +354,10 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 
 	free(tsync_context->sync_ts);
 	free(tsync_context->sync_offsets);
+	free(tsync_context->sync_scalings);
 	tsync_context->sync_ts = NULL;
 	tsync_context->sync_offsets = NULL;
+	tsync_context->sync_scalings = NULL;
 	tsync_context->sync_count = 0;
 	tsync_context->sync_size = 0;
 	pthread_mutex_destroy(&tsync->lock);
@@ -362,10 +369,11 @@ int tracecmd_tsync_send(struct tracecmd_time_sync *tsync,
 				  struct tsync_proto *proto)
 {
 	long long timestamp = 0;
+	long long scaling = 0;
 	long long offset = 0;
 	int ret;
 
-	ret = proto->clock_sync_calc(tsync, &offset, &timestamp);
+	ret = proto->clock_sync_calc(tsync, &offset, &scaling, &timestamp);
 
 	return ret;
 }
@@ -413,18 +421,20 @@ static int tsync_get_sample(struct tracecmd_time_sync *tsync,
 			    struct tsync_proto *proto, int array_step)
 {
 	struct clock_sync_context *clock;
+	long long *sync_scalings = NULL;
 	long long *sync_offsets = NULL;
 	long long *sync_ts = NULL;
 	long long timestamp = 0;
+	long long scaling = 0;
 	long long offset = 0;
 	int ret;
 
-	ret = proto->clock_sync_calc(tsync, &offset, &timestamp);
+	ret = proto->clock_sync_calc(tsync, &offset, &scaling, &timestamp);
 	if (ret) {
 		warning("Failed to synchronize timestamps with guest");
 		return -1;
 	}
-	if (!offset || !timestamp)
+	if (!offset || !timestamp || !scaling)
 		return 0;
 	clock = tsync->context;
 	if (clock->sync_count >= clock->sync_size) {
@@ -432,18 +442,24 @@ static int tsync_get_sample(struct tracecmd_time_sync *tsync,
 				  (clock->sync_size + array_step) * sizeof(long long));
 		sync_offsets = realloc(clock->sync_offsets,
 				       (clock->sync_size + array_step) * sizeof(long long));
-		if (!sync_ts || !sync_offsets) {
+		sync_scalings = realloc(clock->sync_scalings,
+				       (clock->sync_size + array_step) * sizeof(long long));
+
+		if (!sync_ts || !sync_offsets || !sync_scalings) {
 			free(sync_ts);
 			free(sync_offsets);
+			free(sync_scalings);
 			return -1;
 		}
 		clock->sync_size += array_step;
 		clock->sync_ts = sync_ts;
 		clock->sync_offsets = sync_offsets;
+		clock->sync_scalings = sync_scalings;
 	}
 
 	clock->sync_ts[clock->sync_count] = timestamp;
 	clock->sync_offsets[clock->sync_count] = offset;
+	clock->sync_scalings[clock->sync_count] = scaling;
 	clock->sync_count++;
 
 	return 0;
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 5642f12a..0117f979 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -369,6 +369,7 @@ static void dump_option_xlong(int fd, int size, char *desc)
 
 static void dump_option_timeshift(int fd, int size)
 {
+	long long *scalings = NULL;
 	long long *offsets = NULL;
 	long long *times = NULL;
 	long long trace_id;
@@ -397,19 +398,25 @@ static void dump_option_timeshift(int fd, int size)
 	offsets = calloc(count, sizeof(long long));
 	if (!offsets)
 		goto out;
+	scalings = calloc(count, sizeof(long long));
+	if (!scalings)
+		goto out;
 
 	for (i = 0; i < count; i++)
 		read_file_number(fd, times + i, 8);
 	for (i = 0; i < count; i++)
 		read_file_number(fd, offsets + i, 8);
+	for (i = 0; i < count; i++)
+		read_file_number(fd, scalings + i, 8);
 
 	for (i = 0; i < count; i++)
-		do_print(OPTIONS, "\t%lld %lld [offset @ time]\n",
-			 offsets[i], times[i]);
+		do_print(OPTIONS, "\t%lld * %lld %lld [offset * scaling @ time]\n",
+			 offsets[i], scalings[1], times[i]);
 
 out:
 	free(times);
 	free(offsets);
+	free(scalings);
 }
 
 void dump_option_guest(int fd, int size)
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index bc5c744e..6d0a9e85 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -132,16 +132,18 @@ out:
 static void write_guest_time_shift(struct buffer_instance *instance)
 {
 	struct tracecmd_output *handle;
-	struct iovec vector[4];
-	long long *offsets;
-	long long *ts;
+	struct iovec vector[5];
+	long long *scalings = NULL;
+	long long *offsets = NULL;
+	long long *ts = NULL;
 	const char *file;
 	int count;
 	int ret;
 	int fd;
 
-	ret = tracecmd_tsync_get_offsets(&instance->tsync, &count, &ts, &offsets);
-	if (ret < 0 || !count || !ts || !offsets)
+	ret = tracecmd_tsync_get_offsets(&instance->tsync, &count,
+					 &ts, &offsets, &scalings);
+	if (ret < 0 || !count || !ts || !offsets || !scalings)
 		return;
 
 	file = instance->output_file;
@@ -157,7 +159,9 @@ static void write_guest_time_shift(struct buffer_instance *instance)
 	vector[2].iov_base = ts;
 	vector[3].iov_len = 8 * count;
 	vector[3].iov_base = offsets;
-	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 4);
+	vector[4].iov_len = 8 * count;
+	vector[4].iov_base = scalings;
+	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 5);
 	tracecmd_append_options(handle);
 	tracecmd_output_close(handle);
 #ifdef TSYNC_DEBUG
-- 
2.26.2

