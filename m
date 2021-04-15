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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96547C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 08:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73026611F1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 08:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhDOIP4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 04:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhDOIP4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 04:15:56 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6255EC061756
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 01:15:33 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id g5so28816685ejx.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 01:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fZya1XWI/NQzc9cB2n37tHHzTY1PSChLFJmnzXElAGg=;
        b=ekFpKLUEFg2Me4ZiPVZ/RCBs6E+wHfbIyXdpyzXpswzSPiqiqvjytdX1wZrKKB1EAv
         5Tl8uYsSuQwkQ0cMnhPW24tOynJAAfClM0CQaL5KY/iW+qLpOfUKnEfZ/uBt14WHneIw
         IrYpftWEf4bWZ0OGNp54F3bic6b0+q/9OjO2+k4OPlDzdqACHg6ahgdP0BFpv0YHJ+CY
         TyEmiD9lXpx0B4IH5I01wLrzcTVMSde11+cXu4EaM06aSULgm261Bxp46d2luRFSgNgF
         odmTvjODxB1Ezap/venXsWqLa5umhSZ0C2UNVgojshLjlfgt36vDM/9n6B//gbnQGSv/
         MDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fZya1XWI/NQzc9cB2n37tHHzTY1PSChLFJmnzXElAGg=;
        b=HjHB9l2rAPO8LFbRgC5RtlQO7O/dInaleGDesYx+hcVu12Zp2SBCFXfOiDodPRIN4j
         wR21zBkyV799P9R9FJTiDnqvw/Xs5VMZnwM3Vu8DSUeH7sAQeNkM6VVDe9UkfnFJAMxF
         d2UYftETUJI9jR7ONCO7Fc4/tSu/u8cSH/tMaN3VxIkzlJpZ9m0nq/axnttuzRH1Y8Zl
         anoD/bH5UDGY5kTbDWTWr7edI+Dn2qmIQbqOq4cVcA0ponIeI6DdZhDuDSfY/SqLQX2t
         0NgG5TkOiS8EHDPzK+/HQz6fsw5cUxemLMH0rcg5dzekZ/Cv0Tp2dsCWaiIeVHLfvaw4
         3Opg==
X-Gm-Message-State: AOAM531UZducv/ewd6VW5Nwv9gvJl0WvJg08sNfJcQhew6U/686YNqek
        7bmhL+YzmMxvf3nk/bWnmLo=
X-Google-Smtp-Source: ABdhPJytf2Hk1RlZ1Ku01673ckJM6jhxqIRlxQnsGDNdZPnpMkkJl71gb2wMMVbAYaj8A3yBmd4e6A==
X-Received: by 2002:a17:906:77c5:: with SMTP id m5mr2049933ejn.201.1618474531910;
        Thu, 15 Apr 2021 01:15:31 -0700 (PDT)
Received: from oberon.zico.biz ([151.251.243.123])
        by smtp.gmail.com with ESMTPSA id r19sm1312840ejr.55.2021.04.15.01.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 01:15:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] trace-cmd library: Add new trace-cmd library APIs for guest ts corrections
Date:   Thu, 15 Apr 2021 11:15:24 +0300
Message-Id: <20210415081527.3483835-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415081527.3483835-1-tz.stoyanov@gmail.com>
References: <20210415081527.3483835-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The logic for converting guest to host timestamps is local to the trace-cmd
library and is used only when a trace file is opened. In order to reuse
that logic, a new APIs are added:
 tracecmd_tsync_get_proto_flags()
 tracecmd_tsync_get_offsets()
 tracecmd_guest_ts_calc()
 struct ts_offset_sample
 struct tracecmd_ts_corrections

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  18 ++-
 lib/trace-cmd/trace-input.c                   | 106 ++--------------
 lib/trace-cmd/trace-timesync.c                | 113 ++++++++++++++----
 3 files changed, 116 insertions(+), 121 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 42e739fa..56f82244 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -443,6 +443,17 @@ enum tracecmd_time_sync_role {
 /* Timestamp synchronization flags */
 #define TRACECMD_TSYNC_FLAG_INTERPOLATE	0x1
 
+struct ts_offset_sample {
+	long long	time;
+	long long	offset;
+	long long	scaling;
+};
+
+struct tracecmd_ts_corrections {
+	int	ts_samples_count;
+	struct ts_offset_sample	*ts_samples;
+};
+
 void tracecmd_tsync_init(void);
 int tracecmd_tsync_proto_getall(struct tracecmd_tsync_protos **protos, const char *clock, int role);
 bool tsync_proto_is_supported(const char *proto_name);
@@ -456,8 +467,8 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 			  int guest_cpus, const char *proto_name, const char *clock);
 int tracecmd_tsync_with_guest_stop(struct tracecmd_time_sync *tsync);
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync, int cpu,
-				int *count, long long **ts,
-				long long **offsets, long long **scalings);
+			       struct tracecmd_ts_corrections *offsets);
+int tracecmd_tsync_get_proto_flags(struct tracecmd_time_sync *tsync, unsigned int *flags);
 int tracecmd_tsync_get_session_params(struct tracecmd_time_sync *tsync,
 				      char **selected_proto,
 				      unsigned int *tsync_port);
@@ -465,6 +476,9 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
 int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 				    struct tracecmd_time_sync *tsync);
 
+unsigned long long tracecmd_guest_ts_calc(unsigned long long ts,
+					  struct tracecmd_ts_corrections *tsync, int flags);
+
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b17b36e0..974879e8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -78,12 +78,6 @@ struct input_buffer_instance {
 	size_t			offset;
 };
 
-struct ts_offset_sample {
-	long long	time;
-	long long	offset;
-	long long	scaling;
-};
-
 struct guest_trace_info {
 	struct guest_trace_info	*next;
 	char			*name;
@@ -92,19 +86,12 @@ struct guest_trace_info {
 	int			*cpu_pid;
 };
 
-struct timesync_offsets {
-	int	ts_samples_count;
-	struct ts_offset_sample	*ts_samples;
-};
-
 struct host_trace_info {
-	unsigned long long	peer_trace_id;
-	unsigned int		flags;
-	bool			sync_enable;
-	int			ts_samples_count;
-	struct ts_offset_sample	*ts_samples;
-	int			cpu_count;
-	struct timesync_offsets	*ts_offsets;
+	unsigned long long			peer_trace_id;
+	unsigned int				flags;
+	bool					sync_enable;
+	int					cpu_count;
+	struct tracecmd_ts_corrections		*ts_offsets;
 };
 
 struct tsc2nsec {
@@ -1227,81 +1214,6 @@ static unsigned long long mul_u64_u32_shr(unsigned long long a,
 	return ret;
 }
 
-static inline unsigned long long
-timestamp_correction_calc(unsigned long long ts, unsigned int flags,
-			  struct ts_offset_sample *min,
-			  struct ts_offset_sample *max)
-{
-	long long scaling;
-	long long tscor;
-
-	if (flags & TRACECMD_TSYNC_FLAG_INTERPOLATE) {
-		long long delta = max->time - min->time;
-		long long offset = ((long long)ts - min->time) *
-				   (max->offset - min->offset);
-
-		scaling = (min->scaling + max->scaling) / 2;
-		tscor = min->offset + (offset + delta / 2) / delta;
-
-	} else {
-		scaling = min->scaling;
-		tscor = min->offset;
-	}
-
-	ts *= scaling;
-	if (tscor < 0)
-		return ts - llabs(tscor);
-
-	return ts + tscor;
-}
-
-static unsigned long long timestamp_host_sync(unsigned long long ts, int cpu,
-					      struct tracecmd_input *handle)
-{
-	struct timesync_offsets *tsync;
-	int min, mid, max;
-
-	if (cpu >= handle->host.cpu_count)
-		return ts;
-	tsync = &handle->host.ts_offsets[cpu];
-
-	/* We have one sample, nothing to calc here */
-	if (tsync->ts_samples_count == 1)
-		return ts + tsync->ts_samples[0].offset;
-
-	/* We have two samples, nothing to search here */
-	if (tsync->ts_samples_count == 2)
-		return timestamp_correction_calc(ts, handle->host.flags,
-						 &tsync->ts_samples[0],
-						 &tsync->ts_samples[1]);
-
-	/* We have more than two samples */
-	if (ts <= tsync->ts_samples[0].time)
-		return timestamp_correction_calc(ts, handle->host.flags,
-						 &tsync->ts_samples[0],
-						 &tsync->ts_samples[1]);
-	else if (ts >= tsync->ts_samples[tsync->ts_samples_count-1].time)
-		return timestamp_correction_calc(ts, handle->host.flags,
-						 &tsync->ts_samples[tsync->ts_samples_count-2],
-						 &tsync->ts_samples[tsync->ts_samples_count-1]);
-	min = 0;
-	max = tsync->ts_samples_count-1;
-	mid = (min + max)/2;
-	while (min <= max) {
-		if (ts < tsync->ts_samples[mid].time)
-			max = mid - 1;
-		else if (ts > tsync->ts_samples[mid].time)
-			min = mid + 1;
-		else
-			break;
-		mid = (min + max)/2;
-	}
-
-	return timestamp_correction_calc(ts, handle->host.flags,
-					 &tsync->ts_samples[mid],
-					 &tsync->ts_samples[mid+1]);
-}
-
 static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
 					 struct tracecmd_input *handle)
 {
@@ -1310,8 +1222,8 @@ static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
 		return ts;
 
 	/* Guest trace file, sync with host timestamps */
-	if (handle->host.sync_enable)
-		ts = timestamp_host_sync(ts, cpu, handle);
+	if (handle->host.sync_enable && cpu < handle->host.cpu_count)
+		ts = tracecmd_guest_ts_calc(ts, &handle->host.ts_offsets[cpu], handle->host.flags);
 
 	if (handle->ts2secs) {
 		/* user specified clock frequency */
@@ -2329,7 +2241,7 @@ static int tsync_offset_cmp(const void *a, const void *b)
 	} while (0)
 
 static int tsync_offset_load(struct tep_handle	*tep,
-			     struct timesync_offsets *ts_offsets, char *buf, int size)
+			     struct tracecmd_ts_corrections *ts_offsets, char *buf, int size)
 {
 	int start_size = size;
 	int i, j;
@@ -2357,7 +2269,7 @@ static int tsync_cpu_offsets_load(struct tracecmd_input *handle, char *buf, int
 
 	safe_read(handle->host.cpu_count, 4);
 	handle->host.ts_offsets = calloc(handle->host.cpu_count,
-					 sizeof(struct timesync_offsets));
+					 sizeof(struct tracecmd_ts_corrections));
 	if (!handle->host.ts_offsets)
 		return -ENOMEM;
 	for (i = 0; i < handle->host.cpu_count; i++) {
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 19ca19d7..791a0964 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -133,36 +133,101 @@ bool __hidden tsync_proto_is_supported(const char *proto_name)
  *
  * @tsync: Pointer to time sync context
  * @cpu: CPU for which to get the calculated offsets
- * @count: Returns the number of calculated time offsets
- * @ts: Array of size @count containing timestamps of callculated offsets
- * @offsets: array of size @count, containing offsets for each timestamp
- * @scalings: array of size @count, containing scaling ratios for each timestamp
+ * @offsets: Returns the calculated timestamp offsets for the given @cpu
  *
  * Retuns -1 in case of an error, or 0 otherwise
  */
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync, int cpu,
-			       int *count, long long **ts,
-			       long long **offsets, long long **scalings)
+			       struct tracecmd_ts_corrections *offsets)
 {
 	struct clock_sync_context *tsync_context;
+	int i;
 
 	if (!tsync || !tsync->context)
 		return -1;
 	tsync_context = (struct clock_sync_context *)tsync->context;
 	if (cpu >= tsync_context->cpu_count || !tsync_context->offsets)
 		return -1;
-	if (count)
-		*count = tsync_context->offsets[cpu].sync_count;
-	if (ts)
-		*ts = tsync_context->offsets[cpu].sync_ts;
-	if (offsets)
-		*offsets = tsync_context->offsets[cpu].sync_offsets;
-	if (scalings)
-		*scalings = tsync_context->offsets[cpu].sync_scalings;
+	if (offsets) {
+		offsets->ts_samples = calloc(tsync_context->offsets[cpu].sync_count,
+					     sizeof(struct ts_offset_sample));
+		if (!offsets->ts_samples)
+			return -1;
+		offsets->ts_samples_count = tsync_context->offsets[cpu].sync_count;
+		for (i = 0; i < offsets->ts_samples_count; i++) {
+			offsets->ts_samples[i].time = tsync_context->offsets[cpu].sync_ts[i];
+			offsets->ts_samples[i].offset = tsync_context->offsets[cpu].sync_offsets[i];
+			offsets->ts_samples[i].scaling = tsync_context->offsets[cpu].sync_scalings[i];
+		}
+	}
 
 	return 0;
 }
 
+static inline unsigned long long correction_calc(unsigned long long ts, unsigned int flags,
+						struct ts_offset_sample *min,
+						struct ts_offset_sample *max)
+{
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
+
+	ts *= scaling;
+	if (tscor < 0)
+		return ts - llabs(tscor);
+
+	return ts + tscor;
+}
+
+
+unsigned long long tracecmd_guest_ts_calc(unsigned long long ts,
+					  struct tracecmd_ts_corrections *tsync, int flags)
+{
+	int min, mid, max;
+
+	/* We have one sample, nothing to calc here */
+	if (tsync->ts_samples_count == 1)
+		return ts + tsync->ts_samples[0].offset;
+
+	/* We have two samples, nothing to search here */
+	if (tsync->ts_samples_count == 2)
+		return correction_calc(ts, flags, &tsync->ts_samples[0], &tsync->ts_samples[1]);
+
+	/* We have more than two samples */
+	if (ts <= tsync->ts_samples[0].time)
+		return correction_calc(ts, flags, &tsync->ts_samples[0], &tsync->ts_samples[1]);
+	else if (ts >= tsync->ts_samples[tsync->ts_samples_count-1].time)
+		return correction_calc(ts, flags,
+				       &tsync->ts_samples[tsync->ts_samples_count-2],
+				       &tsync->ts_samples[tsync->ts_samples_count-1]);
+	min = 0;
+	max = tsync->ts_samples_count-1;
+	mid = (min + max)/2;
+	while (min <= max) {
+		if (ts < tsync->ts_samples[mid].time)
+			max = mid - 1;
+		else if (ts > tsync->ts_samples[mid].time)
+			min = mid + 1;
+		else
+			break;
+		mid = (min + max)/2;
+	}
+
+	return correction_calc(ts, flags, &tsync->ts_samples[mid], &tsync->ts_samples[mid+1]);
+}
+
 /**
  * tsync_get_proto_flags - Get protocol flags
  *
@@ -171,8 +236,7 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync, int cpu,
  *
  * Retuns -1 in case of an error, or 0 otherwise
  */
-static int tsync_get_proto_flags(struct tracecmd_time_sync *tsync,
-				 unsigned int *flags)
+int tracecmd_tsync_get_proto_flags(struct tracecmd_time_sync *tsync, unsigned int *flags)
 {
 	struct tsync_proto *protocol;
 
@@ -924,6 +988,7 @@ error:
 int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 				    struct tracecmd_time_sync *tsync)
 {
+	struct clock_sync_context *tsync_context;
 	struct iovec *vector = NULL;
 	unsigned int flags;
 	long long *scalings = NULL;
@@ -934,13 +999,15 @@ int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 	int i, j;
 	int ret = -1;
 
-	if (!tsync->vcpu_count)
+	if (!tsync || !tsync->context || !tsync->vcpu_count)
 		return -1;
+	tsync_context = (struct clock_sync_context *)tsync->context;
+
 	vcount = 3 + (4 * tsync->vcpu_count);
 	vector = calloc(vcount, sizeof(struct iovec));
 	if (!vector)
 		return -1;
-	ret = tsync_get_proto_flags(tsync, &flags);
+	ret = tracecmd_tsync_get_proto_flags(tsync, &flags);
 	if (ret < 0)
 		goto out;
 
@@ -952,11 +1019,13 @@ int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 	vector[j].iov_len = 4;
 	vector[j++].iov_base = &tsync->vcpu_count;
 	for (i = 0; i < tsync->vcpu_count; i++) {
-		if (j >= vcount)
+		if (j >= vcount || i >= tsync_context->cpu_count)
 			break;
-		ret = tracecmd_tsync_get_offsets(tsync, i, &count,
-						 &ts, &offsets, &scalings);
-		if (ret < 0 || !count || !ts || !offsets || !scalings)
+		count = tsync_context->offsets[i].sync_count;
+		ts = tsync_context->offsets[i].sync_ts;
+		offsets = tsync_context->offsets[i].sync_offsets;
+		scalings = tsync_context->offsets[i].sync_scalings;
+		if (!count || !ts || !offsets || !scalings)
 			break;
 		vector[j].iov_len = 4;
 		vector[j++].iov_base = &count;
-- 
2.30.2

