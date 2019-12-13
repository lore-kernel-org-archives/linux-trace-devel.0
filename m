Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDE9C341BD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72D3E246D0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lq8EleBT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfLMPau (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:50 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39199 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727881AbfLMPau (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:50 -0500
Received: by mail-lj1-f193.google.com with SMTP id e10so3081305ljj.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xkGvQwjq2dEtMi6Fg8BPE+P62zCO5l2v8Ce5p4hd5+o=;
        b=lq8EleBTUBRsvIz67dQiZJemzH4cKbgRGIkS5UX79eAFxAk9ynnD2ew2wfbLsk67Go
         DuhicPo9KkXJPoEHuNwQ8NxCNhXM1D5gfJOrtykSvm9ss6RJCpPtKY59bBBU5+P0zs7q
         8j7qph854aOUuN42g1oJ+sYAdobDXU4jDdhzKNZJ7vfYpX7zEAja+8UtH/vZJ3hm0Uqa
         BISXv1RzhDLUOP4JbxkbGIH/fwPP4efwwq/R21DQ+Jbrhjoqj2UaJc0Zw/wNWUuBVYXN
         OcJq4NGuTcWN6FRUynvVTzhyJJMO6O0NwRQN4TmdK7nGcc+EsUmk1wgDnM+raRAJN4oX
         fCNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xkGvQwjq2dEtMi6Fg8BPE+P62zCO5l2v8Ce5p4hd5+o=;
        b=hzaE+HvdUgSUPZhT1Y7Sy7Vuxdwon1g6zIplohW87Rt9friXWcBP7KeeDSq8lQH9i7
         dCYe8DnvlOCROxgD1HDAmgiJ2U1YameXC1dFuKux6r6ap6O8sqVW0AelgP+cssPQfb6B
         q3K0k+NaTUF8LU1Ko2ruX5ycQVvAByHmHFPYZ/3Ge+QG2+XUKev/kNksEmfS0ZXmThYR
         sO5zH6KYAuBxlO1gWOFRQVOzOsubemo20vUAhh1bHt7aezotlWugz40NucNRzimLt5f9
         bWsMVVqRVtseB3w/CqDDRtYwcmpcpJvLDF0OeTlIsBfdOSlu4oQV0HYckJyf6QE6YOMq
         YMQw==
X-Gm-Message-State: APjAAAU4nRBmG0jrzkPz1wB6Zr4xq6cxD28XPCq6IiP8ZUD/QDmY4TuJ
        ByncAZ8/DMO+rwBEXtE+FKWPtU5WWPU=
X-Google-Smtp-Source: APXvYqxdeVNX6dKZ44dkS+YInaJwol1GkLke6rAC7i0G0sIA1iPkd6QSmt4LWjMUFCkEDgJ9OhBHyQ==
X-Received: by 2002:a2e:b52a:: with SMTP id z10mr9741649ljm.178.1576251047139;
        Fri, 13 Dec 2019 07:30:47 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:46 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 12/18] trace-cmd: Implement new option in trace.dat file: TRACECMD_OPTION_TIME_SHIFT
Date:   Fri, 13 Dec 2019 17:30:23 +0200
Message-Id: <20191213153029.133570-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213153029.133570-1-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

The TRACECMD_OPTION_TIME_SHIFT is used when synchronizing trace time stamps between
two trace.dat files. It contains multiple long long (time, offset) pairs, describing
time stamps _offset_, measured in the given local _time_. The content of the option
buffer is:
 8 bytes - long long integer, ID of the tracing session
 4 bytes - integer, count of timestamp offsets
 long long array of size _count_, local time in which the offset is measured
 long long array of size _count_, offset of the time stamps

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h |   3 +
 lib/trace-cmd/trace-input.c   | 182 +++++++++++++++++++++++++++++++++-
 2 files changed, 183 insertions(+), 2 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 23415e4..b06a0c3 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -87,6 +87,7 @@ enum {
 	TRACECMD_OPTION_VERSION,
 	TRACECMD_OPTION_PROCMAPS,
 	TRACECMD_OPTION_TRACEID,
+	TRACECMD_OPTION_TIME_SHIFT,
 };
 
 enum {
@@ -130,6 +131,8 @@ void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
 unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle);
+unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle);
+int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable);
 
 void tracecmd_parse_trace_clock(struct tracecmd_input *handle, char *file, int size);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 40d9825..e8db876 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -74,6 +74,18 @@ struct input_buffer_instance {
 	size_t			offset;
 };
 
+struct ts_offset_sample {
+	long long	time;
+	long long	offset;
+};
+
+struct host_trace_info {
+	bool			sync_enable;
+	unsigned long long	trace_id;
+	int			ts_samples_count;
+	struct ts_offset_sample	*ts_samples;
+};
+
 struct tracecmd_input {
 	struct tep_handle	*pevent;
 	struct tep_plugin_list	*plugin_list;
@@ -92,6 +104,7 @@ struct tracecmd_input {
 	bool			use_pipe;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
+	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
 	char *			uname;
@@ -1072,6 +1085,69 @@ static void free_next(struct tracecmd_input *handle, int cpu)
 	free_record(record);
 }
 
+static inline unsigned long long
+timestamp_correction_calc(unsigned long long ts, struct ts_offset_sample *min,
+			  struct ts_offset_sample *max)
+{
+	long long offset = ((long long)ts - min->time) *
+			   (max->offset - min->offset);
+	long long delta = max->time - min->time;
+	long long tscor = min->offset +
+			(offset + delta / 2) / delta;
+
+	if (tscor < 0)
+		return ts - llabs(tscor);
+
+	return ts + tscor;
+}
+
+static unsigned long long timestamp_correct(unsigned long long ts,
+					    struct tracecmd_input *handle)
+{
+	struct host_trace_info	*host = &handle->host;
+	int min, mid, max;
+
+	if (handle->ts_offset)
+		return ts + handle->ts_offset;
+
+	if (!host->sync_enable)
+		return ts;
+
+	/* We have one sample, nothing to calc here */
+	if (host->ts_samples_count == 1)
+		return ts + host->ts_samples[0].offset;
+
+	/* We have two samples, nothing to search here */
+	if (host->ts_samples_count == 2)
+		return timestamp_correction_calc(ts, &host->ts_samples[0],
+						 &host->ts_samples[1]);
+
+	/* We have more than two samples */
+	if (ts <= host->ts_samples[0].time)
+		return timestamp_correction_calc(ts,
+						 &host->ts_samples[0],
+						 &host->ts_samples[1]);
+	else if (ts >= host->ts_samples[host->ts_samples_count-1].time)
+		return timestamp_correction_calc(ts,
+						 &host->ts_samples[host->ts_samples_count-2],
+						 &host->ts_samples[host->ts_samples_count-1]);
+	min = 0;
+	max = host->ts_samples_count-1;
+	mid = (min + max)/2;
+	while (min <= max) {
+		if (ts < host->ts_samples[mid].time)
+			max = mid - 1;
+		else if (ts > host->ts_samples[mid].time)
+			min = mid + 1;
+		else
+			break;
+		mid = (min + max)/2;
+	}
+
+	return timestamp_correction_calc(ts, &host->ts_samples[mid],
+					 &host->ts_samples[mid+1]);
+}
+
 /*
  * Page is mapped, now read in the page header info.
  */
@@ -1093,7 +1169,7 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 		    kbuffer_subbuffer_size(kbuf));
 		return -1;
 	}
-	handle->cpu_data[cpu].timestamp = kbuffer_timestamp(kbuf) + handle->ts_offset;
+	handle->cpu_data[cpu].timestamp = timestamp_correct(kbuffer_timestamp(kbuf), handle);
 
 	if (handle->ts2secs)
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
@@ -1820,7 +1896,7 @@ read_again:
 		goto read_again;
 	}
 
-	handle->cpu_data[cpu].timestamp = ts + handle->ts_offset;
+	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
 
 	if (handle->ts2secs) {
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
@@ -2143,6 +2219,48 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
 	handle->use_trace_clock = false;
 }
 
+static int tsync_offset_cmp(const void *a, const void *b)
+{
+	struct ts_offset_sample *ts_a = (struct ts_offset_sample *)a;
+	struct ts_offset_sample *ts_b = (struct ts_offset_sample *)b;
+
+	if (ts_a->time > ts_b->time)
+		return 1;
+	if (ts_a->time < ts_b->time)
+		return -1;
+	return 0;
+}
+
+static void tsync_offset_load(struct tracecmd_input *handle, char *buf)
+{
+	struct host_trace_info *host = &handle->host;
+	long long *buf8 = (long long *)buf;
+	int i, j;
+
+	for (i = 0; i < host->ts_samples_count; i++) {
+		host->ts_samples[i].time = tep_read_number(handle->pevent,
+							   buf8 + i, 8);
+		host->ts_samples[i].offset = tep_read_number(handle->pevent,
+						buf8 + host->ts_samples_count+i, 8);
+	}
+	qsort(host->ts_samples, host->ts_samples_count,
+	      sizeof(struct ts_offset_sample), tsync_offset_cmp);
+	/* Filter possible samples with equal time */
+	for (i = 0, j = 0; i < host->ts_samples_count; i++) {
+		if (i == 0 || host->ts_samples[i].time != host->ts_samples[i-1].time)
+			host->ts_samples[j++] = host->ts_samples[i];
+	}
+	host->ts_samples_count = j;
+	if (j)
+		host->sync_enable = true;
+}
+
+static void trace_tsync_offset_free(struct host_trace_info *host)
+{
+	free(host->ts_samples);
+	host->ts_samples = NULL;
+}
+
 static int trace_pid_map_cmp(const void *a, const void *b)
 {
 	struct tracecmd_proc_addr_map *m_a = (struct tracecmd_proc_addr_map *)a;
@@ -2323,6 +2441,7 @@ static int handle_options(struct tracecmd_input *handle)
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
+	int samples_size;
 	int cpus;
 
 	/* By default, use usecs, unless told otherwise */
@@ -2370,6 +2489,28 @@ static int handle_options(struct tracecmd_input *handle)
 			offset = strtoll(buf, NULL, 0);
 			handle->ts_offset += offset;
 			break;
+		case TRACECMD_OPTION_TIME_SHIFT:
+			/*
+			 * long long int (8 bytes) trace session ID
+			 * int (4 bytes) count of timestamp offsets.
+			 * long long array of size [count] of times,
+			 *      when the offsets were calculated.
+			 * long long array of size [count] of timestamp offsets.
+			 */
+			if (size < 12 || handle->flags & TRACECMD_FL_IGNORE_DATE)
+				break;
+			handle->host.trace_id = tep_read_number(handle->pevent,
+								buf, 8);
+			handle->host.ts_samples_count = tep_read_number(handle->pevent,
+									buf + 8, 4);
+			samples_size = (8 * handle->host.ts_samples_count);
+			if (size != (12 + (2 * samples_size)))
+				break;
+			handle->host.ts_samples = malloc(2 * samples_size);
+			if (!handle->host.ts_samples)
+				return -ENOMEM;
+			tsync_offset_load(handle, buf + 12);
+			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
 			cpustats = realloc(cpustats, cpustats_size + size + 1);
@@ -3078,6 +3219,8 @@ void tracecmd_close(struct tracecmd_input *handle)
 	trace_pid_map_free(handle->pid_maps);
 	handle->pid_maps = NULL;
 
+	trace_tsync_offset_free(&handle->host);
+
 	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
 		tracecmd_close(handle->parent);
 	else {
@@ -3532,3 +3675,38 @@ unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle)
 {
 	return handle->trace_id;
 }
+
+/**
+ * tracecmd_get_tsync_peer - get the trace session id of the peer host
+ * @handle: input handle for the trace.dat file
+ *
+ * Returns the trace id of the peer host, written in the trace file
+ *
+ * This information is stored in guest trace.dat file
+ */
+unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle)
+{
+	return handle->host.trace_id;
+}
+
+/**
+ * tracecmd_enable_tsync - enable / disable the timestamps correction
+ * @handle: input handle for the trace.dat file
+ * @enable: enable / disable the timestamps correction
+ *
+ * Enables or disables timestamps correction on file load, using the array of
+ * recorded time offsets. If "enable" is true, but there are no time offsets,
+ * function fails and -1 is returned.
+ *
+ * Returns -1 in case of an error, or 0 otherwise
+ */
+int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable)
+{
+	if (enable &&
+	    (!handle->host.ts_samples || !handle->host.ts_samples_count))
+		return -1;
+
+	handle->host.sync_enable = enable;
+
+	return 0;
+}
-- 
2.23.0

