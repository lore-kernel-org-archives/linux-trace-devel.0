Return-Path: <SRS0=9gE1=5R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA7F2C2D0F0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22E872063A
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:45:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aFPCOFwI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389621AbgDAQpB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 12:45:01 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37729 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389437AbgDAQpB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 12:45:01 -0400
Received: by mail-lj1-f195.google.com with SMTP id r24so180697ljd.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Apr 2020 09:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9tR8S7NJs+8YYAzE4321cWiF7yaVVB0ow2bqwWUb2zg=;
        b=aFPCOFwIMD/keAVBBMIZI1oe2uUm1/VWd+OB2didQmjf4sb2L0W1xllPY+IPON57+j
         m/1VWrokXd/5mMsnHEJ4d3kOH+lltDlBCTI2kPRNfiif0K3occYsW4X66gXITLuXVG4w
         sBgxFi6Rv6WnQwqYHzPjVJw+iVDQHdBhBNEpkrnWk0HuBPqmNfYMX5c+EaiCMrlZXEkQ
         boKjaG6fTESvudBh/kYZjkbhpSrp9zriCl2DL/h0Zyd8yoqAzznblifPoKbP28CwbCqP
         vBhwO6zqOsvzGpjDo5YBqIWzFnqE5/2udUpT4vl3yTWYJ/Ml0sZBBQjABKYYOElnybzq
         oo3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9tR8S7NJs+8YYAzE4321cWiF7yaVVB0ow2bqwWUb2zg=;
        b=KV/yMF+6VvtjoHmcavZXdr2uG0R1yH3MJJCIegZ6kaSt8Z4iAh/JZYx7IIhj0TE81x
         nsOSu8qZ5VZBTU1dz4/Fk/cIZrA0gNslDH9pWuYejW/7rpw/juaF+ZTGSPEB1eaOXuMD
         h3BeHDl1KGTnnrpTEVy5Pyc2cOoBTQvywATU8VsOST10y6TF55TM+2MvKwwcyeaFURQq
         yHv2EnocfIBra21rpA1U4BMeakuKiOOteGKXsB+5P4DZur9gv0qisdtR7nQmWPsL9kpy
         toS28f4UF8bF9HLBK7POVOVmXDY+lM2lzYHtQxEukdDYOA3kFgcyFUUTL3Lpr8YFO36I
         bcjg==
X-Gm-Message-State: AGi0PuaHADO/kmQzDBz6V822U1JSWrrufTkCOSUpYCOY4phkpvQr2/Ij
        eQLVAcp6qqMb/WippHloKqU=
X-Google-Smtp-Source: APiQypIJQGj2j2Vdwq1Z/4S623KBn8jttP9V80dR60lmPEQMODpsUnHx91QelolsWZL+/hqaaNlGow==
X-Received: by 2002:a2e:9b07:: with SMTP id u7mr13103561lji.110.1585759496810;
        Wed, 01 Apr 2020 09:44:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e4sm1982499lfn.80.2020.04.01.09.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 09:44:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/5] trace-cmd: Time stamp offset per host CPU
Date:   Wed,  1 Apr 2020 19:44:47 +0300
Message-Id: <20200401164451.191425-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401164451.191425-1-tz.stoyanov@gmail.com>
References: <20200401164451.191425-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The clock, used for trace time stamps, can vary between CPUs.
When synchronizing host and guest trace time stamps, these
variations could introduce inaccuracy.
The algorithm for host - guest trace time stamps synchronization
is modified to calculate the offset per each host CPU, depending
on the CPU affinity of host tasks, running the guest's VCPUs.
The calculated array per CPU is stored in the trace.dat file, using
TRACECMD_OPTION_TIME_SHIFT option.
The "trace-cmd dump --options" command and tracecmd_init_data() API
are adjusted to read the new format of this option.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h             |   6 +-
 lib/trace-cmd/include/trace-tsync-local.h |  16 +-
 lib/trace-cmd/trace-input.c               | 184 +++++++++++----
 lib/trace-cmd/trace-timesync.c            | 269 +++++++++++++++++++---
 tracecmd/include/trace-local.h            |   4 +
 tracecmd/trace-dump.c                     |  60 +++--
 tracecmd/trace-record.c                   |  18 ++
 tracecmd/trace-tsync.c                    | 141 ++++++------
 8 files changed, 516 insertions(+), 182 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 2574edd0..3d2d9ae1 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -431,6 +431,8 @@ struct tracecmd_time_sync {
 	char				*clock_str;
 	struct tracecmd_msg_handle	*msg_handle;
 	void				*context;
+	int				cpu_max;
+	int				*cpu_pid;
 };
 
 void tracecmd_tsync_init(void);
@@ -440,8 +442,10 @@ bool tsync_proto_is_supported(unsigned int proto_id);
 void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync);
 void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync);
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
-				int *count,
+				int cpu_index, int *cpu, int *count,
 				long long **ts, long long **offsets);
+int tracecmd_tsync_get_cpu_count(struct tracecmd_time_sync *tsync,
+				   int *cpu_count, int *max_cpu);
 void tracecmd_tsync_free(struct tracecmd_time_sync *tsync);
 
 /* --- Plugin handling --- */
diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index 1de9d5e5..583ef878 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -8,16 +8,22 @@
 
 #include <stdbool.h>
 
+struct clock_sync_cpu {
+	int		cpu;
+	int		sync_size;	/* Allocated size of sync_ts and sync_offsets */
+	int		sync_count;	/* Number of elements in sync_ts and sync_offsets */
+	long long	*sync_ts;
+	long long	*sync_offsets;
+};
+
 struct clock_sync_context {
 	void				*proto_data;	/* time sync protocol specific data */
 	bool				is_server;	/* server side time sync role */
 	struct tracefs_instance		*instance;	/* ftrace buffer, used for time sync events */
 
-	/* Arrays with calculated time offsets at given time */
-	int				sync_size;	/* Allocated size of sync_ts and sync_offsets */
-	int				sync_count;	/* Number of elements in sync_ts and sync_offsets */
-	long long			*sync_ts;
-	long long			*sync_offsets;
+	/* Arrays with calculated time offsets at given time, per each host CPU */
+	int cpu_sync_size;
+	struct clock_sync_cpu *cpu_sync;
 
 	/* Identifiers of local and remote time sync peers: cid and port */
 	unsigned int			local_cid;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index c1531410..0726b364 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -82,6 +82,11 @@ struct ts_offset_sample {
 	long long	offset;
 };
 
+struct ts_offset_cpu {
+	int			ts_samples_count;
+	struct ts_offset_sample	*ts_samples;
+};
+
 struct guest_trace_info {
 	struct guest_trace_info	*next;
 	char			*name;
@@ -93,8 +98,8 @@ struct guest_trace_info {
 struct host_trace_info {
 	unsigned long long	trace_id;
 	bool			sync_enable;
-	int			ts_samples_count;
-	struct ts_offset_sample	*ts_samples;
+	int			cpu_count;
+	struct ts_offset_cpu	*cpu_time_offsets;
 };
 
 struct tracecmd_input {
@@ -1117,7 +1122,9 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 					    struct tracecmd_input *handle)
 {
 	struct host_trace_info	*host = &handle->host;
+	struct ts_offset_cpu *cpu_offset = NULL;
 	int min, mid, max;
+	int i;
 
 	if (handle->ts_offset)
 		return ts + handle->ts_offset;
@@ -1125,39 +1132,49 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 	if (!host->sync_enable)
 		return ts;
 
+	/* ToDo - find actual host CPU of this guest ts */
+	for (i = 0; i < host->cpu_count; i++) {
+		if (host->cpu_time_offsets[i].ts_samples_count) {
+			cpu_offset = &host->cpu_time_offsets[i];
+			break;
+		}
+	}
+	if (!cpu_offset)
+		return ts;
+
 	/* We have one sample, nothing to calc here */
-	if (host->ts_samples_count == 1)
-		return ts + host->ts_samples[0].offset;
+	if (cpu_offset->ts_samples_count == 1)
+		return ts + cpu_offset->ts_samples[0].offset;
 
 	/* We have two samples, nothing to search here */
-	if (host->ts_samples_count == 2)
-		return timestamp_correction_calc(ts, &host->ts_samples[0],
-						 &host->ts_samples[1]);
+	if (cpu_offset->ts_samples_count == 2)
+		return timestamp_correction_calc(ts, &cpu_offset->ts_samples[0],
+						 &cpu_offset->ts_samples[1]);
 
 	/* We have more than two samples */
-	if (ts <= host->ts_samples[0].time)
+	if (ts <= cpu_offset->ts_samples[0].time)
 		return timestamp_correction_calc(ts,
-						 &host->ts_samples[0],
-						 &host->ts_samples[1]);
-	else if (ts >= host->ts_samples[host->ts_samples_count-1].time)
+						 &cpu_offset->ts_samples[0],
+						 &cpu_offset->ts_samples[1]);
+	else if (ts >= cpu_offset->ts_samples[cpu_offset->ts_samples_count - 1].time)
 		return timestamp_correction_calc(ts,
-						 &host->ts_samples[host->ts_samples_count-2],
-						 &host->ts_samples[host->ts_samples_count-1]);
+						 &cpu_offset->ts_samples[cpu_offset->ts_samples_count - 2],
+						 &cpu_offset->ts_samples[cpu_offset->ts_samples_count - 1]);
 	min = 0;
-	max = host->ts_samples_count-1;
+	max = cpu_offset->ts_samples_count - 1;
 	mid = (min + max)/2;
 	while (min <= max) {
-		if (ts < host->ts_samples[mid].time)
+		if (ts < cpu_offset->ts_samples[mid].time)
 			max = mid - 1;
-		else if (ts > host->ts_samples[mid].time)
+		else if (ts > cpu_offset->ts_samples[mid].time)
 			min = mid + 1;
 		else
 			break;
 		mid = (min + max)/2;
 	}
 
-	return timestamp_correction_calc(ts, &host->ts_samples[mid],
-					 &host->ts_samples[mid+1]);
+	return timestamp_correction_calc(ts, &cpu_offset->ts_samples[mid],
+					 &cpu_offset->ts_samples[mid+1]);
 }
 
 /*
@@ -2149,34 +2166,112 @@ static int tsync_offset_cmp(const void *a, const void *b)
 	return 0;
 }
 
-static void tsync_offset_load(struct tracecmd_input *handle, char *buf)
+
+static int tsync_offset_load_cpu(struct tracecmd_input *handle,
+			      char *buf, int buf_size,
+			      int cpu, int sample_count)
 {
 	struct host_trace_info *host = &handle->host;
-	long long *buf8 = (long long *)buf;
+	struct ts_offset_sample *ts_samples = NULL;
+	struct ts_offset_cpu *cpu_offsets;
+	int read = 0;
 	int i, j;
 
-	for (i = 0; i < host->ts_samples_count; i++) {
-		host->ts_samples[i].time = tep_read_number(handle->pevent,
-							   buf8 + i, 8);
-		host->ts_samples[i].offset = tep_read_number(handle->pevent,
-						buf8 + host->ts_samples_count+i, 8);
+	if (host->cpu_count <= cpu) {
+		cpu_offsets = realloc(host->cpu_time_offsets,
+				      (cpu + 1) * sizeof(struct host_trace_info));
+		if (!cpu_offsets)
+			goto error;
+		for (i = host->cpu_count; i <= cpu; i++)
+			memset(cpu_offsets + i, 0, sizeof(struct ts_offset_cpu));
+		host->cpu_time_offsets = cpu_offsets;
+		host->cpu_count = cpu + 1;
+	}
+
+	ts_samples = calloc(sample_count, sizeof(struct ts_offset_sample));
+	if (!ts_samples)
+		goto error;
+	for (i = 0; i < sample_count; i++) {
+		if (buf_size < 8)
+			goto error;
+		ts_samples[i].time = tep_read_number(handle->pevent, buf, 8);
+		buf += 8;
+		buf_size -= 8;
+		read += 8;
 	}
-	qsort(host->ts_samples, host->ts_samples_count,
+	for (i = 0; i < sample_count; i++) {
+		if (buf_size < 8)
+			goto error;
+		ts_samples[i].offset = tep_read_number(handle->pevent, buf, 8);
+		buf += 8;
+		buf_size -= 8;
+		read += 8;
+	}
+
+	qsort(ts_samples, sample_count,
 	      sizeof(struct ts_offset_sample), tsync_offset_cmp);
 	/* Filter possible samples with equal time */
-	for (i = 0, j = 0; i < host->ts_samples_count; i++) {
-		if (i == 0 || host->ts_samples[i].time != host->ts_samples[i-1].time)
-			host->ts_samples[j++] = host->ts_samples[i];
+	for (i = 0, j = 0; i < sample_count; i++) {
+		if (i == 0 || ts_samples[i].time != ts_samples[i-1].time)
+			ts_samples[j++] = ts_samples[i];
+	}
+
+	host->cpu_time_offsets[cpu].ts_samples_count = j;
+	host->cpu_time_offsets[cpu].ts_samples = ts_samples;
+	return read;
+
+error:
+	free(ts_samples);
+	return -1;
+}
+
+static int tsync_offset_load(struct tracecmd_input *handle,
+			      char *buf, int buf_size, int cpus)
+{
+	struct host_trace_info *host = &handle->host;
+	int count, cpu;
+	int ret;
+	int i;
+
+	for (i = 0; i < cpus; i++) {
+		if (buf_size < 8)
+			break;
+		cpu = tep_read_number(handle->pevent, buf, 4);
+		buf += 4;
+		count = tep_read_number(handle->pevent, buf, 4);
+		buf += 4;
+		buf_size -= 8;
+		if (buf_size < count * 16) /* 8 time + 8 offset */
+			break;
+		if (cpu < 0) {
+			if (cpus > 1) {
+				warning("Invalid time stamp correction for CPU %d", cpu);
+				return -1;
+			}
+			cpu = 0;
+		}
+		ret = tsync_offset_load_cpu(handle, buf, buf_size, cpu, count);
+		if (ret < 0)
+			break;
+		buf_size -= ret;
+		buf += ret;
 	}
-	host->ts_samples_count = j;
-	if (j)
+
+	if (host->cpu_count)
 		host->sync_enable = true;
+	return 0;
 }
 
 static void trace_tsync_offset_free(struct host_trace_info *host)
 {
-	free(host->ts_samples);
-	host->ts_samples = NULL;
+	int i;
+
+	for (i = 0; i < host->cpu_count; i++)
+		free(host->cpu_time_offsets[i].ts_samples);
+
+	free(host->cpu_time_offsets);
+	host->cpu_time_offsets = NULL;
+	host->cpu_count = 0;
 }
 
 static int trace_pid_map_cmp(const void *a, const void *b)
@@ -2431,7 +2526,6 @@ static int handle_options(struct tracecmd_input *handle)
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
-	int samples_size;
 	int cpus;
 
 	/* By default, use usecs, unless told otherwise */
@@ -2482,27 +2576,19 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_TIME_SHIFT:
 			/*
 			 * long long int (8 bytes) trace session ID
+			 * int (4 bytes) number of CPUs with calculated time offsets
+			 * For each CPU:
+			 * int (4 bytes) CPU id.
 			 * int (4 bytes) count of timestamp offsets.
-			 * long long array of size [count] of times,
-			 *      when the offsets were calculated.
+			 * long long array of size [count] of timestamps,
 			 * long long array of size [count] of timestamp offsets.
 			 */
 			if (size < 12 || handle->flags & TRACECMD_FL_IGNORE_DATE)
 				break;
 			handle->host.trace_id = tep_read_number(handle->pevent,
 								buf, 8);
-			handle->host.ts_samples_count = tep_read_number(handle->pevent,
-									buf + 8, 4);
-			samples_size = (8 * handle->host.ts_samples_count);
-			if (size != (12 + (2 * samples_size))) {
-				warning("Failed to extract Time Shift information from the file: found size %d, expected is %d",
-					size, 12 + (2 * samples_size));
-				break;
-			}
-			handle->host.ts_samples = malloc(2 * samples_size);
-			if (!handle->host.ts_samples)
-				return -ENOMEM;
-			tsync_offset_load(handle, buf + 12);
+			cpus = tep_read_number(handle->pevent, buf + 8, 4);
+			tsync_offset_load(handle, buf + 12, size - 12, cpus);
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
@@ -3741,7 +3827,7 @@ unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle)
 int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable)
 {
 	if (enable &&
-	    (!handle->host.ts_samples || !handle->host.ts_samples_count))
+	    (!handle->host.cpu_count || !handle->host.cpu_time_offsets))
 		return -1;
 
 	handle->host.sync_enable = enable;
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index e294698b..194a48af 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -35,6 +35,40 @@ struct tsync_proto {
 
 static struct tsync_proto *tsync_proto_list;
 
+struct tsync_probe_msg {
+	int cpu;
+};
+
+static int pin_to_cpu(int cpu, pid_t pid)
+{
+	static size_t size;
+	static int cpus;
+	cpu_set_t *mask;
+	int ret;
+
+	if (!cpus) {
+		cpus = tracecmd_count_cpus();
+		size = CPU_ALLOC_SIZE(cpus);
+	}
+	if (cpu >= cpus)
+		return -1;
+
+	mask = CPU_ALLOC(cpus);
+	if (!mask)
+		return  -1;
+
+	CPU_ZERO_S(size, mask);
+	CPU_SET_S(cpu, size, mask);
+	ret = pthread_setaffinity_np(pthread_self(), size, mask);
+	if (!ret && pid >= 0)
+		ret = sched_setaffinity(pid, size, mask);
+	CPU_FREE(mask);
+
+	if (ret)
+		return -1;
+	return 0;
+}
+
 static struct tsync_proto *tsync_proto_find(unsigned int proto_id)
 {
 	struct tsync_proto *proto;
@@ -103,9 +137,47 @@ bool tsync_proto_is_supported(unsigned int proto_id)
 }
 
 /**
- * tracecmd_tsync_get_offsets - Return the calculated time offsets
+ * tracecmd_tsync_get_cpu_count - Return the number of CPUs with
+ *				  calculated time offsets
  *
  * @tsync: Pointer to time sync context
+ * @cpu_count: Returns the number of CPUs with calculated time offsets
+ * @max_cpu: Returns the maximum CPU id
+ *
+ * Retuns -1 in case of an error, or 0 otherwise
+ */
+int tracecmd_tsync_get_cpu_count(struct tracecmd_time_sync *tsync,
+				   int *cpu_count, int *max_cpu)
+{
+	struct clock_sync_context *tsync_context;
+	int i;
+
+	if (!tsync || !tsync->context)
+		return -1;
+	tsync_context = (struct clock_sync_context *)tsync->context;
+
+	if (max_cpu)
+		*max_cpu = tsync_context->cpu_sync_size;
+	if (cpu_count) {
+		*cpu_count = 0;
+		for (i = 0; i < tsync_context->cpu_sync_size; i++) {
+			if (!tsync_context->cpu_sync[i].sync_count ||
+			    !tsync_context->cpu_sync[i].sync_offsets ||
+			    !tsync_context->cpu_sync[i].sync_ts)
+				continue;
+			(*cpu_count)++;
+		}
+	}
+	return 0;
+}
+
+/**
+ * tracecmd_tsync_get_offsets - Return the calculated time offsets, per CPU
+ *
+ * @tsync: Pointer to time sync context
+ * @cpu_index: Index of the CPU, number between 0 and the one returned by
+ *		tracecmd_tsync_get_cpu_count() API
+ * @cpu: Returns the CPU id
  * @count: Returns the number of calculated time offsets
  * @ts: Array of size @count containing timestamps of callculated offsets
  * @offsets: array of size @count, containing offsets for each timestamp
@@ -113,7 +185,7 @@ bool tsync_proto_is_supported(unsigned int proto_id)
  * Retuns -1 in case of an error, or 0 otherwise
  */
 int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
-				int *count,
+				int cpu_index, int *cpu, int *count,
 				long long **ts, long long **offsets)
 {
 	struct clock_sync_context *tsync_context;
@@ -121,12 +193,16 @@ int tracecmd_tsync_get_offsets(struct tracecmd_time_sync *tsync,
 	if (!tsync || !tsync->context)
 		return -1;
 	tsync_context = (struct clock_sync_context *)tsync->context;
+	if (cpu_index >= tsync_context->cpu_sync_size)
+		return -1;
+	if (cpu)
+		*cpu = tsync_context->cpu_sync[cpu_index].cpu;
 	if (count)
-		*count = tsync_context->sync_count;
+		*count = tsync_context->cpu_sync[cpu_index].sync_count;
 	if (ts)
-		*ts = tsync_context->sync_ts;
+		*ts = tsync_context->cpu_sync[cpu_index].sync_ts;
 	if (offsets)
-		*offsets = tsync_context->sync_offsets;
+		*offsets = tsync_context->cpu_sync[cpu_index].sync_offsets;
 	return 0;
 }
 
@@ -317,6 +393,7 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 {
 	struct clock_sync_context *tsync_context;
 	struct tsync_proto *proto;
+	int i;
 
 	if (!tsync->context)
 		return;
@@ -329,12 +406,13 @@ void tracecmd_tsync_free(struct tracecmd_time_sync *tsync)
 	clock_synch_delete_instance(tsync_context->instance);
 	tsync_context->instance = NULL;
 
-	free(tsync_context->sync_ts);
-	free(tsync_context->sync_offsets);
-	tsync_context->sync_ts = NULL;
-	tsync_context->sync_offsets = NULL;
-	tsync_context->sync_count = 0;
-	tsync_context->sync_size = 0;
+	for (i = 0; i < tsync_context->cpu_sync_size; i++) {
+		free(tsync_context->cpu_sync[i].sync_ts);
+		free(tsync_context->cpu_sync[i].sync_offsets);
+	}
+	free(tsync_context->cpu_sync);
+	tsync_context->cpu_sync = NULL;
+	tsync_context->cpu_sync_size = 0;
 	pthread_mutex_destroy(&tsync->lock);
 	pthread_cond_destroy(&tsync->cond);
 	free(tsync->clock_str);
@@ -364,9 +442,12 @@ int tracecmd_tsync_send(struct tracecmd_time_sync *tsync,
  */
 void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync)
 {
+	struct tsync_probe_msg probe;
 	struct tsync_proto *proto;
 	unsigned int protocol;
 	unsigned int command;
+	unsigned int size;
+	char *msg;
 	int ret;
 
 	proto = tsync_proto_find(tsync->sync_proto);
@@ -377,15 +458,26 @@ void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync)
 	if (!tsync->context)
 		return;
 
+	msg = (char *)&probe;
+	size = sizeof(probe);
 	while (true) {
 		ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
 						  &protocol, &command,
-						  NULL, NULL);
-
+						  &size, &msg);
 		if (ret ||
 		    protocol != TRACECMD_TIME_SYNC_PROTO_NONE ||
 		    command != TRACECMD_TIME_SYNC_CMD_PROBE)
 			break;
+		probe.cpu = ntohl(probe.cpu);
+		if (probe.cpu >= 0) {
+			if (pin_to_cpu(probe.cpu, -1))
+				probe.cpu = -1;
+		}
+		probe.cpu = htonl(probe.cpu);
+		ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
+						  TRACECMD_TIME_SYNC_PROTO_NONE,
+						  TRACECMD_TIME_SYNC_CMD_PROBE,
+						  sizeof(probe), (char *)&probe);
 		ret = tracecmd_tsync_send(tsync, proto);
 		if (ret)
 			break;
@@ -393,43 +485,88 @@ void tracecmd_tsync_with_host(struct tracecmd_time_sync *tsync)
 }
 
 static int tsync_get_sample(struct tracecmd_time_sync *tsync,
-			    struct tsync_proto *proto, int array_step)
+			    struct tsync_proto *proto, int cpu, int vcpu,
+			    int array_step)
 {
 	struct clock_sync_context *clock;
+	struct clock_sync_cpu *cpu_sync;
 	long long *sync_offsets = NULL;
+	struct tsync_probe_msg probe;
 	long long *sync_ts = NULL;
 	long long timestamp = 0;
+	unsigned int protocol;
+	unsigned int command;
 	long long offset = 0;
+	unsigned int size;
+	int cpu_index;
+	char *msg;
 	int ret;
+	int i;
+
+	probe.cpu = htonl(vcpu);
+	ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
+					  TRACECMD_TIME_SYNC_PROTO_NONE,
+					  TRACECMD_TIME_SYNC_CMD_PROBE,
+					  sizeof(probe), (char *)&probe);
+	msg = (char *)&probe;
+	size = sizeof(probe);
+	ret = tracecmd_msg_recv_time_sync(tsync->msg_handle,
+					  &protocol, &command,
+					  &size, &msg);
+	if (ret ||
+	    protocol != TRACECMD_TIME_SYNC_PROTO_NONE ||
+	    command != TRACECMD_TIME_SYNC_CMD_PROBE)
+		return -1;
 
-	ret = proto->clock_sync_calc(tsync, &offset, &timestamp);
+	if (!ret)
+		ret = proto->clock_sync_calc(tsync, &offset, &timestamp);
 	if (ret) {
 		warning("Failed to synchronize timestamps with guest");
 		return -1;
 	}
+	if (vcpu != ntohl(probe.cpu)) {
+		ret = 1;
+		cpu = -1;
+	} else
+		ret = 0;
 	if (!offset || !timestamp)
-		return 0;
+		return ret;
 	clock = tsync->context;
-	if (clock->sync_count >= clock->sync_size) {
-		sync_ts = realloc(clock->sync_ts,
-				  (clock->sync_size + array_step) * sizeof(long long));
-		sync_offsets = realloc(clock->sync_offsets,
-				       (clock->sync_size + array_step) * sizeof(long long));
+	if (cpu < 0)
+		cpu_index = 0;
+	else
+		cpu_index = cpu;
+	if (cpu_index >= clock->cpu_sync_size) {
+		cpu_sync = realloc(clock->cpu_sync,
+				   (cpu_index + 1) * sizeof(struct clock_sync_cpu));
+		if (!cpu_sync)
+			return -1;
+		for (i = clock->cpu_sync_size; i <= cpu_index; i++)
+			memset(&cpu_sync[i], 0, sizeof(struct clock_sync_cpu));
+		clock->cpu_sync = cpu_sync;
+		clock->cpu_sync_size = cpu_index + 1;
+	}
+	cpu_sync = &clock->cpu_sync[cpu_index];
+	if (cpu_sync->sync_count >= cpu_sync->sync_size) {
+		sync_ts = realloc(cpu_sync->sync_ts,
+				  (cpu_sync->sync_size + array_step) * sizeof(long long));
+		sync_offsets = realloc(cpu_sync->sync_offsets,
+				       (cpu_sync->sync_size + array_step) * sizeof(long long));
 		if (!sync_ts || !sync_offsets) {
 			free(sync_ts);
 			free(sync_offsets);
 			return -1;
 		}
-		clock->sync_size += array_step;
-		clock->sync_ts = sync_ts;
-		clock->sync_offsets = sync_offsets;
+		cpu_sync->sync_size += array_step;
+		cpu_sync->sync_ts = sync_ts;
+		cpu_sync->sync_offsets = sync_offsets;
 	}
+	cpu_sync->cpu = cpu;
+	cpu_sync->sync_ts[cpu_sync->sync_count] = timestamp;
+	cpu_sync->sync_offsets[cpu_sync->sync_count] = offset;
+	cpu_sync->sync_count++;
 
-	clock->sync_ts[clock->sync_count] = timestamp;
-	clock->sync_offsets[clock->sync_count] = offset;
-	clock->sync_count++;
-
-	return 0;
+	return ret;
 }
 
 #define TIMER_SEC_NANO 1000000000LL
@@ -447,6 +584,70 @@ static inline void get_ts_loop_delay(struct timespec *timeout, int delay_ms)
 }
 
 #define CLOCK_TS_ARRAY 5
+static int tsync_get_sample_cpu(struct tracecmd_time_sync *tsync,
+				struct tsync_proto *proto, int ts_array_size)
+{
+	static int cpus;
+	cpu_set_t *tsync_mask = NULL;
+	cpu_set_t *vcpu_mask = NULL;
+	cpu_set_t *cpu_save = NULL;
+	size_t mask_size;
+	int ret;
+	int i, j;
+
+	if (!cpus)
+		cpus = tracecmd_count_cpus();
+
+	cpu_save = CPU_ALLOC(cpus);
+	tsync_mask = CPU_ALLOC(cpus);
+	vcpu_mask = CPU_ALLOC(cpus);
+	if (!cpu_save || !tsync_mask || !vcpu_mask)
+		goto out;
+	mask_size = CPU_ALLOC_SIZE(cpus);
+	ret = pthread_getaffinity_np(pthread_self(), mask_size, cpu_save);
+	if (ret) {
+		CPU_FREE(cpu_save);
+		cpu_save = NULL;
+		goto out;
+	}
+	CPU_ZERO_S(mask_size, tsync_mask);
+
+	for (i = 0; i < tsync->cpu_max; i++) {
+		if (tsync->cpu_pid[i] < 0)
+			continue;
+		if (sched_getaffinity(tsync->cpu_pid[i], mask_size, vcpu_mask))
+			continue;
+		for (j = 0; j < cpus; j++) {
+			if (!CPU_ISSET_S(j, mask_size, vcpu_mask))
+				continue;
+			if (CPU_ISSET_S(j, mask_size, tsync_mask))
+				continue;
+			if (pin_to_cpu(j, tsync->cpu_pid[i]))
+				continue;
+
+			ret = tsync_get_sample(tsync, proto, j, i, ts_array_size);
+			if (!ret)
+				CPU_SET_S(j, mask_size, tsync_mask);
+		}
+		sched_setaffinity(tsync->cpu_pid[i], mask_size, vcpu_mask);
+	}
+out:
+	ret = -1;
+	if (cpu_save) {
+		pthread_setaffinity_np(pthread_self(), mask_size, cpu_save);
+		CPU_FREE(cpu_save);
+	}
+	if (tsync_mask) {
+		if (CPU_COUNT_S(mask_size, tsync_mask) > 0)
+			ret = 0;
+		CPU_FREE(tsync_mask);
+	}
+	if (vcpu_mask)
+		CPU_FREE(vcpu_mask);
+
+	return ret;
+}
+
 /**
  * tracecmd_tsync_with_guest - Synchronize timestamps with guest
  *
@@ -478,11 +679,11 @@ void tracecmd_tsync_with_guest(struct tracecmd_time_sync *tsync)
 
 	while (true) {
 		pthread_mutex_lock(&tsync->lock);
-		ret = tracecmd_msg_send_time_sync(tsync->msg_handle,
-						  TRACECMD_TIME_SYNC_PROTO_NONE,
-						  TRACECMD_TIME_SYNC_CMD_PROBE,
-						  0, NULL);
-		ret = tsync_get_sample(tsync, proto, ts_array_size);
+		if (tsync->cpu_pid)
+			ret = tsync_get_sample_cpu(tsync, proto, ts_array_size);
+		else
+			ret = tsync_get_sample(tsync, proto, -1, -1, ts_array_size);
+
 		if (ret || end)
 			break;
 		if (tsync->loop_interval > 0) {
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 49c52b17..5865f6e6 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -280,6 +280,10 @@ int trace_open_vsock(unsigned int cid, unsigned int port);
 
 char *trace_get_guest_file(const char *file, const char *guest);
 
+int trace_get_guest_cpu_mapping(unsigned int guest_cid,
+				int *cpu_max, int **cpu_pid);
+
+
 /* No longer in event-utils.h */
 void __noreturn die(const char *fmt, ...); /* Can be overriden */
 void *malloc_or_die(unsigned int size); /* Can be overridden */
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index ffb1c6b1..b0b027b0 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -373,13 +373,17 @@ static void dump_option_timeshift(int fd, int size)
 	long long *times = NULL;
 	long long trace_id;
 	unsigned int count;
-	int i;
+	unsigned int cpus;
+	int cpu;
+	int i, j;
 
 	/*
 	 * long long int (8 bytes) trace session ID
+	 * int (4 bytes) number of CPUs with calculated time offsets
+	 * For each CPU
+	 * int (4 bytes) CPU id.
 	 * int (4 bytes) count of timestamp offsets.
-	 * long long array of size [count] of times,
-	 *      when the offsets were calculated.
+	 * long long array of size [count] of timestamps,
 	 * long long array of size [count] of timestamp offsets.
 	 */
 	if (size < 12) {
@@ -388,25 +392,41 @@ static void dump_option_timeshift(int fd, int size)
 	}
 	do_print(OPTIONS, "\t\t[Option TimeShift, %d bytes]\n", size);
 	read_file_number(fd, &trace_id, 8);
+	size -= 8;
 	do_print(OPTIONS, "0x%llX [peer's trace id]\n", trace_id);
-	read_file_number(fd, &count, 4);
-	do_print(OPTIONS, "%lld [samples count]\n", count);
-	times = calloc(count, sizeof(long long));
-	if (!times)
-		goto out;
-	offsets = calloc(count, sizeof(long long));
-	if (!offsets)
-		goto out;
-
-	for (i = 0; i < count; i++)
-		read_file_number(fd, times + i, 8);
-	for (i = 0; i < count; i++)
-		read_file_number(fd, offsets + i, 8);
-
-	for (i = 0; i < count; i++)
-		do_print(OPTIONS, "\t%lld %lld [offset @ time]\n",
-			 offsets[i], times[i]);
+	read_file_number(fd, &cpus, 4);
+	size -= 4;
+	do_print(OPTIONS, "%lld [CPU count]\n", cpus);
 
+	for (j = 0; j < cpus; j++) {
+		if (size < 4)
+			goto out;
+		read_file_number(fd, &cpu, 4);
+		size -= 4;
+		do_print(OPTIONS, " %d [cpu id]\n", cpu);
+		read_file_number(fd, &count, 4);
+		size -= 4;
+		do_print(OPTIONS, " %d [samples count]\n", count);
+		if (size < (2 * count * sizeof(long long)))
+			goto out;
+		size -= (2 * count * sizeof(long long));
+		times = realloc(times, count * sizeof(long long));
+		if (!times)
+			goto out;
+		offsets = realloc(offsets, count * sizeof(long long));
+		if (!offsets)
+			goto out;
+		memset(times, 0, count * sizeof(long long));
+		memset(offsets, 0, count * sizeof(long long));
+		for (i = 0; i < count; i++)
+			read_file_number(fd, times + i, 8);
+		for (i = 0; i < count; i++)
+			read_file_number(fd, offsets + i, 8);
+
+		for (i = 0; i < count; i++)
+			do_print(OPTIONS, "\t%lld %lld [offset @ time]\n",
+					offsets[i], times[i]);
+	}
 out:
 	free(times);
 	free(offsets);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ffc91011..84b7ade8 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3088,6 +3088,24 @@ static struct guest *get_guest_info(unsigned int guest_cid)
 	return NULL;
 }
 
+int trace_get_guest_cpu_mapping(unsigned int guest_cid,
+				int *cpu_max, int **cpu_pid)
+{
+	struct guest *guest;
+
+	guest = get_guest_info(guest_cid);
+	if (!guest)
+		return -1;
+
+	if (cpu_pid)
+		*cpu_pid = guest->cpu_pid;
+	if (cpu_max)
+		*cpu_max = guest->cpu_max;
+
+	return 0;
+}
+
+
 static char *get_qemu_guest_name(char *arg)
 {
 	char *tok, *end = arg;
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index bf65e441..d44c3850 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -15,48 +15,7 @@
 #include "trace-local.h"
 #include "trace-msg.h"
 
-static int get_first_cpu(cpu_set_t **pin_mask, size_t *m_size)
-{
-	int cpus = tracecmd_count_cpus();
-	cpu_set_t *cpu_mask;
-	int mask_size;
-	int i;
-
-	cpu_mask = CPU_ALLOC(cpus);
-	*pin_mask = CPU_ALLOC(cpus);
-	if (!cpu_mask || !*pin_mask || 1)
-		goto error;
-
-	mask_size = CPU_ALLOC_SIZE(cpus);
-	CPU_ZERO_S(mask_size, cpu_mask);
-	CPU_ZERO_S(mask_size, *pin_mask);
-
-	if (sched_getaffinity(0, mask_size, cpu_mask) == -1)
-		goto error;
-
-	for (i = 0; i < cpus; i++) {
-		if (CPU_ISSET_S(i, mask_size, cpu_mask)) {
-			CPU_SET_S(i, mask_size, *pin_mask);
-			break;
-		}
-	}
-
-	if (CPU_COUNT_S(mask_size, *pin_mask) < 1)
-		goto error;
-
-	CPU_FREE(cpu_mask);
-	*m_size = mask_size;
-	return 0;
-
-error:
-	if (cpu_mask)
-		CPU_FREE(cpu_mask);
-	if (*pin_mask)
-		CPU_FREE(*pin_mask);
-	*pin_mask = NULL;
-	*m_size = 0;
-	return -1;
-}
+#define TSYNC_DEBUG
 
 static void *tsync_host_thread(void *data)
 {
@@ -78,7 +37,6 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 	struct tracecmd_msg_handle *msg_handle = NULL;
 	cpu_set_t *pin_mask = NULL;
 	pthread_attr_t attrib;
-	size_t mask_size = 0;
 	int ret;
 	int fd;
 
@@ -96,16 +54,19 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 		goto out;
 	}
 
+	ret = trace_get_guest_cpu_mapping(instance->cid,
+					  &instance->tsync.cpu_max,
+					  &instance->tsync.cpu_pid);
+
 	instance->tsync.msg_handle = msg_handle;
 	if (top_instance.clock)
 		instance->tsync.clock_str = strdup(top_instance.clock);
-	pthread_mutex_init(&instance->tsync.lock, NULL);
-	pthread_cond_init(&instance->tsync.cond, NULL);
+	ret = pthread_mutex_init(&instance->tsync.lock, NULL);
+	if (!ret)
+		ret = pthread_cond_init(&instance->tsync.cond, NULL);
 
 	pthread_attr_init(&attrib);
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
-	if (!get_first_cpu(&pin_mask, &mask_size))
-		pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
 
 	ret = pthread_create(&instance->tsync_thread, &attrib,
 			     tsync_host_thread, &instance->tsync);
@@ -126,18 +87,31 @@ out:
 
 static void write_guest_time_shift(struct buffer_instance *instance)
 {
-	struct tracecmd_output *handle;
-	struct iovec vector[4];
+	struct tracecmd_output *handle = NULL;
+	struct iovec *vector = NULL;
 	long long *offsets;
+	int vector_count;
+	int *count = NULL;
+	int *cpu = NULL;
 	long long *ts;
+	int cpu_count;
+	int max_cpu;
 	char *file;
-	int count;
+	int i, j, k;
 	int ret;
 	int fd;
 
-	ret = tracecmd_tsync_get_offsets(&instance->tsync, &count, &ts, &offsets);
-	if (ret < 0 || !count || !ts || !offsets)
+	ret = tracecmd_tsync_get_cpu_count(&instance->tsync,
+					   &cpu_count, &max_cpu);
+	if (ret < 0 || cpu_count < 1)
 		return;
+	vector_count = 2;
+	vector_count += (4 * cpu_count);
+	vector = calloc(vector_count, sizeof(struct iovec));
+	count = calloc(cpu_count, sizeof(int));
+	cpu = calloc(cpu_count, sizeof(int));
+	if (!vector || !count || !cpu)
+		goto out;
 
 	file = trace_get_guest_file(DEFAUT_INPUT_FILE,
 				tracefs_instance_get_name(instance->tracefs));
@@ -145,24 +119,51 @@ static void write_guest_time_shift(struct buffer_instance *instance)
 	if (fd < 0)
 		die("error opening %s", file);
 	free(file);
+
+	i = 0;
+	vector[i].iov_len = 8;
+	vector[i].iov_base = &top_instance.trace_id;
+	i++;
+	vector[i].iov_len = 4;
+	vector[i].iov_base = &cpu_count;
+	i++;
+	for (j = 0, k = 0; j < max_cpu && i <= (vector_count - 4) && k < cpu_count; j++) {
+		ret = tracecmd_tsync_get_offsets(&instance->tsync, j, &cpu[k],
+						 &count[k], &ts, &offsets);
+		if (ret < 0)
+			return;
+		if (!count[k] || !ts || !offsets)
+			continue;
+
+		vector[i].iov_len = 4;
+		vector[i].iov_base = &cpu[k];
+		vector[i + 1].iov_len = 4;
+		vector[i + 1].iov_base = &count[k];
+		vector[i + 2].iov_len = 8 * count[k];
+		vector[i + 2].iov_base = ts;
+		vector[i + 3].iov_len = 8 * count[k];
+		vector[i + 3].iov_base = offsets;
+		i += 4;
+#ifdef TSYNC_DEBUG
+		printf("Got %d timestamp synch samples for guest %s, host cpu %d in %lld ns trace\n\r",
+			count[k], tracefs_instance_get_name(instance->tracefs),
+			cpu[k], ts[count[k] - 1] - ts[0]);
+#endif
+		k++;
+	}
+
 	handle = tracecmd_get_output_handle_fd(fd);
-	vector[0].iov_len = 8;
-	vector[0].iov_base = &top_instance.trace_id;
-	vector[1].iov_len = 4;
-	vector[1].iov_base = &count;
-	vector[2].iov_len = 8 * count;
-	vector[2].iov_base = ts;
-	vector[3].iov_len = 8 * count;
-	vector[3].iov_base = offsets;
-	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 4);
+	if (!handle) {
+		close(fd);
+		goto out;
+	}
+	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, i);
 	tracecmd_append_options(handle);
+out:
 	tracecmd_output_close(handle);
-#ifdef TSYNC_DEBUG
-	if (count > 1)
-		printf("Got %d timestamp synch samples for guest %s in %lld ns trace\n\r",
-			count, tracefs_instance_get_name(instance->tracefs),
-			ts[count - 1] - ts[0]);
-#endif
+	free(vector);
+	free(count);
+	free(cpu);
 }
 
 void tracecmd_host_tsync_complete(struct buffer_instance *instance)
@@ -214,9 +215,7 @@ unsigned int tracecmd_guest_tsync(char *tsync_protos,
 				  unsigned int *tsync_port, pthread_t *thr_id)
 {
 	struct tracecmd_time_sync *tsync = NULL;
-	cpu_set_t *pin_mask = NULL;
 	pthread_attr_t attrib;
-	size_t mask_size = 0;
 	unsigned int proto;
 	int ret;
 	int fd;
@@ -245,13 +244,9 @@ unsigned int tracecmd_guest_tsync(char *tsync_protos,
 	pthread_attr_init(&attrib);
 	tsync->sync_proto = proto;
 	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
-	if (!get_first_cpu(&pin_mask, &mask_size))
-		pthread_attr_setaffinity_np(&attrib, mask_size, pin_mask);
 
 	ret = pthread_create(thr_id, &attrib, tsync_agent_thread, tsync);
 
-	if (pin_mask)
-		CPU_FREE(pin_mask);
 	pthread_attr_destroy(&attrib);
 
 	if (ret)
-- 
2.25.1

