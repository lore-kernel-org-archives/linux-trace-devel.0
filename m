Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3D7C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E189B23976
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbhAUHrG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 02:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbhAUHq7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 02:46:59 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81ABAC061796
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:10 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id l12so746151wry.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wCTW1LrmucZ935W8ywfgNhVLrZoebD/zycJ/NkzVjrc=;
        b=ICuqVCWiXgsBZmF1H3cN48hL6dOYdgzYS4hktDonyjVPPhKIWPfG8oWjzD1VPGBxA4
         /2KEPSoSR4IIS5vfShc7UFl6wVZiis1KuX7/wk6HVbP7ihzdo1F3Q+sj8+K1l/V7BbVR
         lG3eQMAWGh075UdUTXEXXDPbwTkM0yarzXnC3+qXOVuAkj33jIr9lBisMycxKNUZHqB0
         Ik4gx+hxhKkE9QIXRDFRhpSf3nVn4AQTjeONZ8E5WvSVel93UtuRdVXF1SFnlrG+9/oA
         PXe0wiix2ddb3r9+/r6JL8UnLuY/eJAnzh2dhM7U/JhRA7xT8J8FCgGToHFZkpno2Sla
         +ERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wCTW1LrmucZ935W8ywfgNhVLrZoebD/zycJ/NkzVjrc=;
        b=BYpu15OYS4fIDijYGma1mTdMtYrNYW+h8HwJhpRHGjH9jrRMu1pPTqHj9DTehFNNoz
         /p0M7aHy8Dnux8vAK33TpWA7Xz2O7uFWxC/zB1bA0r5HthTO4dnr9y1JjzbM59W1VYbH
         kepQH1SFjCXTF+nffAf2EjSVfhpp3FEWxFSd2V2D8qqB0azwKi+4j3ktEFZLJcikFSxu
         tib5yVwoPlCtIiW0IsNa0DnMUsM4eInweRcWa+AB1otGpFFWlI8IvvF1AF6uvHrqNQtd
         kGf1BLACbnJydT0fAGNv4F+aME+v6pVWQpiaZB3GgeZ07mu03WloBVryjE7y4B9r2mgl
         Ff0A==
X-Gm-Message-State: AOAM533fOkFQciPea8fe/Wvq0DboPQLa2Yd9BuVEbCo28UQnZIYdxWWh
        K3hIlQy4ZbyVGHQKw7KjKDU=
X-Google-Smtp-Source: ABdhPJydzLKQoPEnJglGO1EyvW3io1UfPCYV85ctHjMwVisyuN6LTcr41fZkY6IQfmT6ozuxVEO5OQ==
X-Received: by 2002:a5d:4e51:: with SMTP id r17mr12965546wrt.94.1611215109234;
        Wed, 20 Jan 2021 23:45:09 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm6788474wmj.32.2021.01.20.23.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 23:45:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v26 09/15] trace-cmd: Add time sync protocol flags
Date:   Thu, 21 Jan 2021 09:44:50 +0200
Message-Id: <20210121074456.157658-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074456.157658-1-tz.stoyanov@gmail.com>
References: <20210121074456.157658-1-tz.stoyanov@gmail.com>
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
   min offset for all timestamps within the interval.

These flags are set by the timestamp synchronization protocols at the
protocol initialization time.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  5 ++
 lib/trace-cmd/include/trace-tsync-local.h     |  2 +-
 lib/trace-cmd/trace-input.c                   | 48 ++++++++++++-------
 lib/trace-cmd/trace-timesync.c                | 28 ++++++++++-
 tracecmd/trace-dump.c                         |  3 ++
 tracecmd/trace-tsync.c                        | 20 +++++---
 6 files changed, 81 insertions(+), 25 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 00f8d11e..d6176337 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -436,6 +436,9 @@ struct tracecmd_time_sync {
 	int				vcpu_count;
 };
 
+/* Timestamp synchronization flags */
+#define TRACECMD_TSYNC_FLAG_INTERPOLATE	0x1
+
 void tracecmd_tsync_init(void);
 int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const char *clock, int role);
 const char *tracecmd_tsync_proto_select(struct tracecmd_tsync_protos *protos, char *clock,
@@ -446,6 +449,8 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
 				int *count, long long **ts,
 				long long **offsets, long long **scalings);
+int tracecmd_tsync_get_proto_flags(struct tracecmd_time_sync *tsync,
+				   unsigned int *flags);
 void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
 
 /* --- Plugin handling --- */
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index c34d9ab7..83d1721a 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -33,7 +33,7 @@ struct clock_sync_context {
 };
 
 int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int roles,
-				  int supported_clocks,
+				  int supported_clocks, unsigned int flags,
 				  int (*init)(struct tracecmd_time_sync *),
 				  int (*free)(struct tracecmd_time_sync *),
 				  int (*calc)(struct tracecmd_time_sync *,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 1ce26563..7d28254e 100644
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
index 9b12e20f..9cbed775 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -28,6 +28,7 @@ struct tsync_proto {
 	enum tracecmd_time_sync_role roles;
 	int accuracy;
 	int supported_clocks;
+	unsigned int flags;
 
 	int (*clock_sync_init)(struct tracecmd_time_sync *clock_context);
 	int (*clock_sync_free)(struct tracecmd_time_sync *clock_context);
@@ -53,7 +54,7 @@ static struct tsync_proto *tsync_proto_find(const char *proto_name)
 }
 
 int tracecmd_tsync_proto_register(const char *proto_name, int accuracy, int roles,
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
index 83954b82..438c60bb 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -135,7 +135,8 @@ out:
 static void write_guest_time_shift(struct buffer_instance *instance)
 {
 	struct tracecmd_output *handle;
-	struct iovec vector[5];
+	struct iovec vector[6];
+	unsigned int flags;
 	long long *scalings = NULL;
 	long long *offsets = NULL;
 	long long *ts = NULL;
@@ -148,6 +149,9 @@ static void write_guest_time_shift(struct buffer_instance *instance)
 					 &ts, &offsets, &scalings);
 	if (ret < 0 || !count || !ts || !offsets || !scalings)
 		return;
+	ret = tracecmd_tsync_get_proto_flags(&instance->tsync, &flags);
+	if (ret < 0)
+		return;
 
 	file = instance->output_file;
 	fd = open(file, O_RDWR);
@@ -157,14 +161,16 @@ static void write_guest_time_shift(struct buffer_instance *instance)
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
2.29.2

