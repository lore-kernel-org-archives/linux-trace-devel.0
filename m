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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA669C55178
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9698B20796
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nnaHVVHK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgJ2LSg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbgJ2LSd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:18:33 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844CCC0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:31 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id l8so2041035wmg.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IupXLA7IBeQyxCFOiA20qzTQeqnIO4IRnA132UuCuzM=;
        b=nnaHVVHKgM+O3I6ln4xtm6REfPRLweFIzp4wnlQqBIjB4vJJ4GghszziWcBK88TxGf
         3ZefKqmNNKmLlsOuVQhHl6P+h05lQa7Z7nWSbHMyXPPKFnq3WUBtMIeH33ntNWqoTkAe
         C4uIyVPuvja+VxgsfDV68g+6YTexblcAjCSZnoUU8UCkqCwtV1E2W7UjuLRYiBIwR2K9
         ryuUeffqD0phI8+0oRhHlUXIh17jho4/yh/iKyJ0+THTcri8O0ZQR37mOx30Voxm6mU/
         ndhwP2RH3AaHm1k3O9A2p9hr1KE/f9vwiRkQpn0QLNhxhVoKjLxkWKdiAd0aJ8GpvzcV
         mXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IupXLA7IBeQyxCFOiA20qzTQeqnIO4IRnA132UuCuzM=;
        b=IIvF3i/m3cVIAd9VgwyuMBdLWlWbPuWkovF8ASQYkiJmFm/n0j3knjgWZzjsWpKoB8
         aG7Gj7eGLdBR1Y0DTgDkWfJiFZng/Dz+s59M+uQUmGFgXYSRnSYvOoKZQ0etnHVJlIeo
         Y5q9HP1/vxfx8sqrmErry+g0Ybe5VgSvUqEkx9y+XLWFooT9TmpuFSRAYNRRFtCmyub2
         jD+SD3ycJhJCWtVDxyYwsc+Y2xUhB2SFaMYB2EEwOzYv0Nt7B298aOMvftBia5xg0gI5
         EnD/z/SC5ifgHi0toy6vNhK69oE1L/cYgxWPDVk+9Cm0gQblIDc3VhWKjuydNEIVUh+3
         ztGg==
X-Gm-Message-State: AOAM531N9k9XU0Swq9xhtl1o/Rnu+JGLPPDaR5qYilGagpAkzL1sG/Ko
        e8MiTvOYghXpOy+nhAVzVKgx2W1g71Bj97Jc
X-Google-Smtp-Source: ABdhPJy+TH8TFjsIXjrKQnGGNkBG2E2v9One7o5EaAkiNtFzJ0KJx9iHpXDmU+sHJFheC2yM7E+7eQ==
X-Received: by 2002:a1c:5401:: with SMTP id i1mr3818007wmb.124.1603970310144;
        Thu, 29 Oct 2020 04:18:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a199sm4308067wmd.8.2020.10.29.04.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:18:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v25 10/16] trace-cmd: Add time sync protocol flags
Date:   Thu, 29 Oct 2020 13:18:10 +0200
Message-Id: <20201029111816.247241-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029111816.247241-1-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added 32bit flags for the time synchronization protocols. The first added
flag is TRACECMD_TSYNC_FLAG_INTERPOLATE, used to specify how the
timestamps must be corrected.
 - If the flag is set, an interpolation is performed:
   Find the (min, max) interval from the offsets array and calculate
offset specific to the given timestamp using interpolation in that
interval.
 - If the flag is not set, do not interpolate:
   Find the (min, max) interval from the offsets array and use the
   min offset for all timespamps within the interval.

These flags are set by the timestamp synchronization protocols at the
protocol initialization time.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h             |  5 +++
 lib/trace-cmd/include/trace-tsync-local.h |  2 +-
 lib/trace-cmd/trace-input.c               | 48 +++++++++++++++--------
 lib/trace-cmd/trace-timesync.c            | 28 ++++++++++++-
 tracecmd/trace-dump.c                     |  3 ++
 tracecmd/trace-tsync.c                    | 20 ++++++----
 6 files changed, 81 insertions(+), 25 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6a6e4061..0a6c3ad9 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -456,6 +456,9 @@ struct tracecmd_time_sync {
 
 };
 
+/* Timestamp synchronization flags */
+#define TRACECMD_TSYNC_FLAG_INTERPOLATE	0x1
+
 void tracecmd_tsync_init(void);
 int tracecmd_tsync_proto_getall(char ***protos, const char *clock, int role);
 char *tracecmd_tsync_proto_select(char **protos, char *clock,
@@ -466,6 +469,8 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
 				int *count, long long **ts,
 				long long **offsets, long long **scalings);
+int tracecmd_tsync_get_proto_flags(struct tracecmd_time_sync *tsync,
+				   unsigned int *flags);
 void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
 
 /* --- Plugin handling --- */
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 492a0a90..54a85ee7 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -33,7 +33,7 @@ struct clock_sync_context {
 };
 
 int tracecmd_tsync_proto_register(char *proto_name, int accuracy, int roles,
-				  int supported_clocks,
+				  int supported_clocks, unsigned int flags,
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
 				  int (*calc)(struct tracecmd_time_sync *,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 1ac50f48..c38b634b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -93,6 +93,7 @@ struct guest_trace_info {
 
 struct host_trace_info {
 	unsigned long long	peer_trace_id;
+	unsigned int		flags;
 	bool			sync_enable;
 	struct tracecmd_input	*peer_data;
 	int			ts_samples_count;
@@ -1121,15 +1122,25 @@ static void free_next(struct tracecmd_input *handle, int cpu)
 }
 
 static inline unsigned long long
-timestamp_correction_calc(unsigned long long ts, struct ts_offset_sample *min,
+timestamp_correction_calc(unsigned long long ts, unsigned int flags,
+			  struct ts_offset_sample *min,
 			  struct ts_offset_sample *max)
 {
-	long long scaling = (min->scaling + max->scaling) / 2;
-	long long offset = ((long long)ts - min->time) *
-			   (max->offset - min->offset);
-	long long delta = max->time - min->time;
-	long long tscor = min->offset +
-			(offset + delta / 2) / delta;
+	long long scaling;
+	long long tscor;
+
+	if (flags & TRACECMD_TSYNC_FLAG_INTERPOLATE) {
+		long long delta = max->time - min->time;
+		long long offset = ((long long)ts - min->time) *
+				   (max->offset - min->offset);
+
+		scaling = (min->scaling + max->scaling) / 2;
+		tscor = min->offset + (offset + delta / 2) / delta;
+
+	} else {
+		scaling = min->scaling;
+		tscor = min->offset;
+	}
 
 	ts *= scaling;
 	if (tscor < 0)
@@ -1156,16 +1167,17 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 
 	/* We have two samples, nothing to search here */
 	if (host->ts_samples_count == 2)
-		return timestamp_correction_calc(ts, &host->ts_samples[0],
+		return timestamp_correction_calc(ts, host->flags,
+						 &host->ts_samples[0],
 						 &host->ts_samples[1]);
 
 	/* We have more than two samples */
 	if (ts <= host->ts_samples[0].time)
-		return timestamp_correction_calc(ts,
+		return timestamp_correction_calc(ts, host->flags,
 						 &host->ts_samples[0],
 						 &host->ts_samples[1]);
 	else if (ts >= host->ts_samples[host->ts_samples_count-1].time)
-		return timestamp_correction_calc(ts,
+		return timestamp_correction_calc(ts, host->flags,
 						 &host->ts_samples[host->ts_samples_count-2],
 						 &host->ts_samples[host->ts_samples_count-1]);
 	min = 0;
@@ -1181,7 +1193,8 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 		mid = (min + max)/2;
 	}
 
-	return timestamp_correction_calc(ts, &host->ts_samples[mid],
+	return timestamp_correction_calc(ts, host->flags,
+					 &host->ts_samples[mid],
 					 &host->ts_samples[mid+1]);
 }
 
@@ -2535,28 +2548,31 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_TIME_SHIFT:
 			/*
 			 * long long int (8 bytes) trace session ID
+			 * int (4 bytes) protocol flags.
 			 * int (4 bytes) count of timestamp offsets.
 			 * long long array of size [count] of times,
 			 *      when the offsets were calculated.
 			 * long long array of size [count] of timestamp offsets.
 			 * long long array of size [count] of timestamp scaling ratios.*
 			 */
-			if (size < 12 || handle->flags & TRACECMD_FL_IGNORE_DATE)
+			if (size < 16 || handle->flags & TRACECMD_FL_IGNORE_DATE)
 				break;
 			handle->host.peer_trace_id = tep_read_number(handle->pevent,
 								     buf, 8);
+			handle->host.flags = tep_read_number(handle->pevent,
+							     buf + 8, 4);
 			handle->host.ts_samples_count = tep_read_number(handle->pevent,
-									buf + 8, 4);
+									buf + 12, 4);
 			samples_size = (8 * handle->host.ts_samples_count);
-			if (size != (12 + (2 * samples_size))) {
+			if (size != (16 + (2 * samples_size))) {
 				warning("Failed to extract Time Shift information from the file: found size %d, expected is %d",
-					size, 12 + (2 * samples_size));
+					size, 16 + (2 * samples_size));
 				break;
 			}
 			handle->host.ts_samples = malloc(2 * samples_size);
 			if (!handle->host.ts_samples)
 				return -ENOMEM;
-			tsync_offset_load(handle, buf + 12);
+			tsync_offset_load(handle, buf + 16);
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 1036917e..0f3246c6 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -28,6 +28,7 @@ struct tsync_proto {
 	enum tracecmd_time_sync_role roles;
 	int accuracy;
 	int supported_clocks;
+	unsigned int flags;
 
 	int (*clock_sync_init)(struct tracecmd_time_sync *clock_context);
 	int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
@@ -53,7 +54,7 @@ static struct tsync_proto *tsync_proto_find(char *proto_name)
 }
 
 int tracecmd_tsync_proto_register(char *proto_name, int accuracy, int roles,
-				  int supported_clocks,
+				  int supported_clocks, unsigned int flags,
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
 				  int (*calc)(struct tracecmd_time_sync *,
@@ -139,6 +140,31 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
 	return 0;
 }
 
+/**
+ * tracecmd_tsync_get_proto_flags - Get protocol flags
+ *
+ * @tsync: Pointer to time sync context
+ * @flags: Returns the protocol flags, a combination of TRACECMD_TSYNC_FLAG_...
+ *
+ * Retuns -1 in case of an error, or 0 otherwise
+ */
+int tracecmd_tsync_get_proto_flags(struct tracecmd_time_sync *tsync,
+				   unsigned int *flags)
+{
+	struct tsync_proto *protocol;
+
+	if (!tsync)
+		return -1;
+	protocol = tsync_proto_find(tsync->proto_name);
+	if (!protocol)
+		return -1;
+
+	if (flags)
+		*flags = protocol->flags;
+
+	return 0;
+}
+
 
 #define PROTO_MASK_SIZE (sizeof(char))
 #define PROTO_MASK_BITS (PROTO_MASK_SIZE * 8)
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 0117f979..6172231e 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -374,6 +374,7 @@ static void dump_option_timeshift(int fd, int size)
 	long long *times = NULL;
 	long long trace_id;
 	unsigned int count;
+	unsigned int flags;
 	int i;
 
 	/*
@@ -390,6 +391,8 @@ static void dump_option_timeshift(int fd, int size)
 	do_print(OPTIONS, "\t\t[Option TimeShift, %d bytes]\n", size);
 	read_file_number(fd, &trace_id, 8);
 	do_print(OPTIONS, "0x%llX [peer's trace id]\n", trace_id);
+	read_file_number(fd, &flags, 4);
+	do_print(OPTIONS, "0x%llX [peer's protocol flags]\n", flags);
 	read_file_number(fd, &count, 4);
 	do_print(OPTIONS, "%lld [samples count]\n", count);
 	times = calloc(count, sizeof(long long));
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index 6d0a9e85..943a274a 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -132,7 +132,8 @@ out:
 static void write_guest_time_shift(struct buffer_instance *instance)
 {
 	struct tracecmd_output *handle;
-	struct iovec vector[5];
+	struct iovec vector[6];
+	unsigned int flags;
 	long long *scalings = NULL;
 	long long *offsets = NULL;
 	long long *ts = NULL;
@@ -145,6 +146,9 @@ static void write_guest_time_shift(struct buffer_instance *instance)
 					 &ts, &offsets, &scalings);
 	if (ret < 0 || !count || !ts || !offsets || !scalings)
 		return;
+	ret = tracecmd_tsync_get_proto_flags(&instance->tsync, &flags);
+	if (ret < 0)
+		return;
 
 	file = instance->output_file;
 	fd = open(file, O_RDWR);
@@ -154,14 +158,16 @@ static void write_guest_time_shift(struct buffer_instance *instance)
 	vector[0].iov_len = 8;
 	vector[0].iov_base = &top_instance.trace_id;
 	vector[1].iov_len = 4;
-	vector[1].iov_base = &count;
-	vector[2].iov_len = 8 * count;
-	vector[2].iov_base = ts;
+	vector[1].iov_base = &flags;
+	vector[2].iov_len = 4;
+	vector[2].iov_base = &count;
 	vector[3].iov_len = 8 * count;
-	vector[3].iov_base = offsets;
+	vector[3].iov_base = ts;
 	vector[4].iov_len = 8 * count;
-	vector[4].iov_base = scalings;
-	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 5);
+	vector[4].iov_base = offsets;
+	vector[5].iov_len = 8 * count;
+	vector[5].iov_base = scalings;
+	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 6);
 	tracecmd_append_options(handle);
 	tracecmd_output_close(handle);
 #ifdef TSYNC_DEBUG
-- 
2.26.2

