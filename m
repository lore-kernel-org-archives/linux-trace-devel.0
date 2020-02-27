Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C88C3F360
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53C99246AE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lOqspmBd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389666AbgB0OUU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:20:20 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45102 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389286AbgB0OUU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 09:20:20 -0500
Received: by mail-lj1-f195.google.com with SMTP id e18so3577988ljn.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2020 06:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EwRj2yp74oDuUS3UOfgzpdEPENlDRJZbNF/sDzc2IjY=;
        b=lOqspmBdU/qWIZt2jSxWItAep8i6SUou0irdvOVT8WomLTxkXe5vQ9baVnhMD+lg96
         bHYmGklqPYP3roZ5rnJ0kwD/lZtDCwfZ1VOyPjAYKAU3B4544cv9fquFAuDRx9NXE4qZ
         1ezemp+eSr5kLbAN3uxd7U/kFbSnLGlJRNw4zbWz9XULzK5t2N+E/65IhNZiSrpPRauh
         hZqOWP4XcaLUHnHnimPPmL6nH6kqthx6yglQqzGB35MWHrt7ypozvk3Gd7YLy4QLVQkR
         5toST+vNp++Ut40z+HU/U9s/jjS2RcfxEQx00kUyWIy/rbRK0FrS99TaGO+v4SQiJwed
         lliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EwRj2yp74oDuUS3UOfgzpdEPENlDRJZbNF/sDzc2IjY=;
        b=j+8RMicRGztzA8+cfWaVa/CIveItlRkcnkKzznI2NfFk5xIioCPeXNyTElWSUlsnu5
         MK69peWj4KyM+9cN93i0o1QYL1OxnPiMz+hl9ljSRgTJjdg4L/EjU8/C09TZG/oMZXjR
         5Sl+coaLSZ1CcPPd9YAKNCgnABTwwpSE8g9Yfoiod3uR6ayQ/ZUROJsl7NvRGPcTr1PU
         WILHpp+IbO4KojrMHVUKzNbeo7ChpE4ImqGnzFK5UVut461hpSWpyrTjO2wHPT/hxS8D
         mnBVq9s3TrkJiR0mhKoAthvy1FaGrYKPAjVV3WURF8zFuL81/vs5v3sI3d4kN11HX/5c
         E5Yg==
X-Gm-Message-State: ANhLgQ2PTXc8CnhRwAKlgPLTBRI+gDESpHjzFnqvtZOie+Rj1KytbLPQ
        550msQx1rM90bjsK7yElaSvB6VytLa0=
X-Google-Smtp-Source: ADFU+vuGS8BtHXaO6I3vC1OT1N+ysjBd9POnBO5YaLO9TbHK8rjL0E+tra88WLkAvskzHMXkyqalvw==
X-Received: by 2002:a2e:b4cf:: with SMTP id r15mr3035704ljm.52.1582813216264;
        Thu, 27 Feb 2020 06:20:16 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l3sm3306437lja.78.2020.02.27.06.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 06:20:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v20 09/15] trace-cmd: Implement new option in trace.dat file: TRACECMD_OPTION_TIME_SHIFT
Date:   Thu, 27 Feb 2020 16:19:55 +0200
Message-Id: <20200227142001.61577-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227142001.61577-1-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c   | 185 +++++++++++++++++++++++++++++++++-
 tracecmd/trace-dump.c         |  49 +++++++++
 3 files changed, 235 insertions(+), 2 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 55abd489..ac46637e 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -110,6 +110,7 @@ enum {
 	TRACECMD_OPTION_VERSION,
 	TRACECMD_OPTION_PROCMAPS,
 	TRACECMD_OPTION_TRACEID,
+	TRACECMD_OPTION_TIME_SHIFT,
 };
 
 enum {
@@ -153,6 +154,8 @@ void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
 unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle);
+unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle);
+int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable);
 
 void tracecmd_parse_trace_clock(struct tracecmd_input *handle, char *file, int size);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f5611b46..cf7be730 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -77,6 +77,18 @@ struct input_buffer_instance {
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
@@ -95,6 +107,7 @@ struct tracecmd_input {
 	bool			use_pipe;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
+	struct host_trace_info	host;
 	double			ts2secs;
 	char *			cpustats;
 	char *			uname;
@@ -1075,6 +1088,69 @@ static void free_next(struct tracecmd_input *handle, int cpu)
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
@@ -1096,7 +1172,7 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 		    kbuffer_subbuffer_size(kbuf));
 		return -1;
 	}
-	handle->cpu_data[cpu].timestamp = kbuffer_timestamp(kbuf) + handle->ts_offset;
+	handle->cpu_data[cpu].timestamp = timestamp_correct(kbuffer_timestamp(kbuf), handle);
 
 	if (handle->ts2secs)
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
@@ -1729,7 +1805,7 @@ read_again:
 		goto read_again;
 	}
 
-	handle->cpu_data[cpu].timestamp = ts + handle->ts_offset;
+	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
 
 	if (handle->ts2secs) {
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
@@ -2052,6 +2128,48 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
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
@@ -2224,6 +2342,7 @@ static int handle_options(struct tracecmd_input *handle)
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
+	int samples_size;
 	int cpus;
 
 	/* By default, use usecs, unless told otherwise */
@@ -2271,6 +2390,30 @@ static int handle_options(struct tracecmd_input *handle)
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
+			if (size != (12 + (2 * samples_size))) {
+				warning("Failed to extract Time Shift information from the file, unexpected size %d", size);
+				break;
+			}
+			handle->host.ts_samples = malloc(2 * samples_size);
+			if (!handle->host.ts_samples)
+				return -ENOMEM;
+			tsync_offset_load(handle, buf + 12);
+			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
 			cpustats = realloc(cpustats, cpustats_size + size + 1);
@@ -2974,6 +3117,8 @@ void tracecmd_close(struct tracecmd_input *handle)
 	trace_pid_map_free(handle->pid_maps);
 	handle->pid_maps = NULL;
 
+	trace_tsync_offset_free(&handle->host);
+
 	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
 		tracecmd_close(handle->parent);
 	else {
@@ -3315,6 +3460,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 			return NULL;
 		}
 	}
+	memset(&new_handle->host, 0, sizeof(new_handle->host));
 	new_handle->parent = handle;
 	new_handle->cpustats = NULL;
 	new_handle->hooks = NULL;
@@ -3435,3 +3581,38 @@ unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle)
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
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 2dfeaa0f..b4beb8b2 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -366,6 +366,52 @@ static void dump_option_xlong(int fd, int size, char *desc)
 	read_file_number(fd, &val, size);
 	do_print(OPTIONS, "0x%llX\n", val);
 }
+
+static void dump_option_timeshift(int fd, int size)
+{
+	long long *offsets = NULL;
+	long long *times = NULL;
+	long long trace_id;
+	unsigned int count;
+	int i;
+
+	/*
+	 * long long int (8 bytes) trace session ID
+	 * int (4 bytes) count of timestamp offsets.
+	 * long long array of size [count] of times,
+	 *      when the offsets were calculated.
+	 * long long array of size [count] of timestamp offsets.
+	 */
+	if (size < 12) {
+		do_print(OPTIONS, "Broken time shift option, size %s", size);
+		return;
+	}
+	do_print(OPTIONS, "\t\t[Option TimeShift, %d bytes]\n", size);
+	read_file_number(fd, &trace_id, 8);
+	do_print(OPTIONS, "0x%llX [peer's trace id]\n", trace_id);
+	read_file_number(fd, &count, 4);
+	do_print(OPTIONS, "%lld [samples count]\n", count);
+	times = calloc(count, sizeof(long long));
+	if (!times)
+		goto out;
+	offsets = calloc(count, sizeof(long long));
+	if (!offsets)
+		goto out;
+
+	for (i = 0; i < count; i++)
+		read_file_number(fd, times + i, 8);
+	for (i = 0; i < count; i++)
+		read_file_number(fd, offsets + i, 8);
+
+	for (i = 0; i < count; i++)
+		do_print(OPTIONS, "\t%lld %lld [offset @ time]\n",
+			 offsets[i], times[i]);
+
+out:
+	free(times);
+	free(offsets);
+}
+
 static void dump_options(int fd)
 {
 	unsigned short option;
@@ -419,6 +465,9 @@ static void dump_options(int fd)
 		case TRACECMD_OPTION_TRACEID:
 			dump_option_xlong(fd, size, "TRACEID");
 			break;
+		case TRACECMD_OPTION_TIME_SHIFT:
+			dump_option_timeshift(fd, size);
+			break;
 		default:
 			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
 				 option, size);
-- 
2.24.1

