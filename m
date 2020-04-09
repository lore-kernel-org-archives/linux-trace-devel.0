Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8464AC2BA2B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46C2E20857
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AxFxYtx0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgDIN25 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:28:57 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36818 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgDIN25 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 09:28:57 -0400
Received: by mail-lf1-f66.google.com with SMTP id w145so7907796lff.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 06:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OfQwRUg0iQKCa/Dihf+ePvuT0brBpeZ0WPt7THKKL3g=;
        b=AxFxYtx022kEyYcQMz9V0hNs+0MuTAdmxfkrt5KjE/qXAFfdjzdJ8ip4krykeK/uO1
         IZ6e3bsTkE7CWjCpuyJhlukQTZEi2dK2O5vPg/Bz0EyD5vuYy/4BdzHV8XHhwEfO/3h0
         eVHhL9n6S74laLtdkxwVE2j606DDdViKHVbf6Z0yC/IcUZXnk0cWha6TnZ8KygEkejS9
         im3ahLSVQdQBBR3526eSXSzJw7UCAgd/XFWbB5OE5SRBONTggmwPO1Ws3ENPGAt2pHrf
         peXcPZiJvSPILgG6mpyTRbapJlTLLK+tsZbtV8Jm8qTj1y/RxS52aM2ReckZcjGrZfnJ
         9Tlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OfQwRUg0iQKCa/Dihf+ePvuT0brBpeZ0WPt7THKKL3g=;
        b=in1W3wVdKoXPtDZ/MraTzgBcWMZ7sJ+U0XUHwijiNHvB1HIqFbQj0OgwS5P8D0hzJp
         s2NjiiViYHnNE2OYTFzp2eVHPndVM5a0YFmh1vOHvnzxo0QWLO1qFOqlMGQjAiWFuUbp
         9YtovTWxoACGTibL4/ln1VDVNlnhas2ZU57lpn/JiUZAoMVhW/PGn2pUBN/B/hBpzXCa
         6+85F0BagHX6yr0uGQny50yvAtUV+RKSXHp4Kb+b97r7xv6Bb0uMdskMGG2ie6sNk3Lc
         9xb64UssEEFnIhOBgSHAJ07tOP1Xjs43yk5wzPtFkgx6HOJLDCQ3AjCDeWxVXd5OodpN
         wXmg==
X-Gm-Message-State: AGi0PuYBwQuxE6m5QhgGcEa2XlCymdrFK50Ia5a6RjKBwJAzII+8Wm7p
        PylB5TTcegIUYOoes71fDOo=
X-Google-Smtp-Source: APiQypJzkCZrNI6/XbptessJXBPuft/O3jsF23r0q+pw6UAXVrhPCWIyppzFIuM5S2Z0JlpgRAEypA==
X-Received: by 2002:a05:6512:3091:: with SMTP id z17mr7815644lfd.42.1586438934265;
        Thu, 09 Apr 2020 06:28:54 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w16sm3716849lfk.49.2020.04.09.06.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 06:28:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 3/3] trace-cmd: Use per CPU synchronization data when calculating timestamps offsets
Date:   Thu,  9 Apr 2020 16:28:47 +0300
Message-Id: <20200409132847.79592-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409132847.79592-1-tz.stoyanov@gmail.com>
References: <20200409132847.79592-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When per CPU synchronization data is available in trace.dat file, use them when
synchronizing event timestamps between host and guest machines.
This change is for testing purposes only, the code is not optimized and relies
on few assumptions. To use the per CPU data, the host sched events of tasks, running
each guest VCPU, must be available in the host tracing file. The host tracing must be recorded
with at least the "-e sched" option. The migration of VCPUs between host CPUs is extracted
using these events from the host trace file. This information is mandatory for the algorithm.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 269 +++++++++++++++++++++++++++++++++---
 1 file changed, 249 insertions(+), 20 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 0c898100..d9195428 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -77,6 +77,16 @@ struct input_buffer_instance {
 	size_t			offset;
 };
 
+struct ts_sched_cpu {
+	unsigned long long	ts;
+	int			host_cpu;
+};
+
+struct vcpu_sched_data {
+	int			cpu_sched_count;
+	struct ts_sched_cpu	*cpu_sched;
+};
+
 struct ts_offset_sample {
 	long long	time;
 	long long	offset;
@@ -99,6 +109,8 @@ struct host_trace_info {
 	unsigned long long	peer_trace_id;
 	bool			sync_enable;
 	struct tracecmd_input	*peer_data;
+	int			vcpu_count;
+	struct vcpu_sched_data *vcpu_sched;
 	int			cpu_count;
 	struct ts_offset_cpu	*cpu_time_offsets;
 };
@@ -1140,27 +1152,12 @@ timestamp_correction_calc(unsigned long long ts, struct ts_offset_sample *min,
 	return ts + tscor;
 }
 
-static unsigned long long timestamp_correct(unsigned long long ts,
-					    struct tracecmd_input *handle)
+static unsigned long long timestamp_correct_cpu(unsigned long long ts,
+						struct ts_offset_cpu *cpu_offset)
 {
-	struct host_trace_info  *host = &handle->host;
-	struct ts_offset_cpu *cpu_offset = NULL;
 	int min, mid, max;
-	int i;
 
-	if (handle->ts_offset)
-		return ts + handle->ts_offset;
-
-	if (!host->sync_enable)
-		return ts;
 
-	/* ToDo - find actual host CPU of this guest ts */
-	for (i = 0; i < host->cpu_count; i++) {
-		if (host->cpu_time_offsets[i].ts_samples_count) {
-			cpu_offset = &host->cpu_time_offsets[i];
-				break;
-		}
-	}
 	if (!cpu_offset)
 		return ts;
 
@@ -1199,6 +1196,90 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 					 &cpu_offset->ts_samples[mid+1]);
 }
 
+static struct ts_offset_cpu *timestamp_host_cpu_offset(struct host_trace_info *host,
+						       int cpu)
+{
+	int i;
+
+	if (cpu >= 0 && cpu < host->cpu_count)
+		return host->cpu_time_offsets + cpu;
+
+	if (cpu < 0) {
+		for (i = 0; i < host->cpu_count; i++) {
+			if (host->cpu_time_offsets[i].ts_samples_count)
+				return host->cpu_time_offsets + i;
+		}
+	}
+
+	return NULL;
+}
+
+static int timestamp_vcpu_to_cpu_ts(struct host_trace_info *host,
+				    int vcpu, unsigned long long ts)
+{
+	struct vcpu_sched_data *sched;
+	int min, mid, max;
+
+	if (vcpu < 0 || vcpu >= host->vcpu_count || !host->vcpu_sched)
+		return -1;
+
+	sched = host->vcpu_sched + vcpu;
+	if (!sched)
+		return -1;
+
+	min = 0;
+	max = sched->cpu_sched_count - 1;
+	mid = (min + max)/2;
+	while (min <= max) {
+		if (ts < sched->cpu_sched[mid].ts)
+			max = mid - 1;
+		else if (ts > sched->cpu_sched[mid].ts)
+			min = mid + 1;
+		else
+			break;
+		mid = (min + max)/2;
+	}
+
+	return sched->cpu_sched[mid].host_cpu;
+
+}
+
+static int timestamp_vcpu_to_cpu(struct host_trace_info *host,
+				 int vcpu,
+				 unsigned long long ts)
+{
+	struct ts_offset_cpu *cpu_offset = NULL;
+	unsigned long long ts_guess;
+	int cpu;
+
+	cpu_offset = timestamp_host_cpu_offset(host, -1);
+	ts_guess = timestamp_correct_cpu(ts, cpu_offset);
+	cpu = timestamp_vcpu_to_cpu_ts(host, vcpu, ts_guess);
+
+	return cpu;
+}
+
+static unsigned long long timestamp_correct(unsigned long long ts, int cpu,
+					    struct tracecmd_input *handle)
+{
+	struct ts_offset_cpu *cpu_offset = NULL;
+	int host_cpu;
+
+	if (handle->ts_offset)
+		return ts + handle->ts_offset;
+
+	if (!handle->host.sync_enable)
+		return ts;
+	if (handle->host.cpu_count == 1)
+		host_cpu = 0;
+	else
+		host_cpu = timestamp_vcpu_to_cpu(&handle->host, cpu, ts);
+
+	cpu_offset = timestamp_host_cpu_offset(&handle->host, host_cpu);
+
+	return timestamp_correct_cpu(ts, cpu_offset);;
+}
+
 /*
  * Page is mapped, now read in the page header info.
  */
@@ -1220,7 +1301,8 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 		    kbuffer_subbuffer_size(kbuf));
 		return -1;
 	}
-	handle->cpu_data[cpu].timestamp = timestamp_correct(kbuffer_timestamp(kbuf), handle);
+	handle->cpu_data[cpu].timestamp = timestamp_correct(kbuffer_timestamp(kbuf),
+							    cpu, handle);
 
 	if (handle->ts2secs)
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
@@ -1853,7 +1935,7 @@ read_again:
 		goto read_again;
 	}
 
-	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
+	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, cpu, handle);
 
 	if (handle->ts2secs) {
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
@@ -2247,10 +2329,146 @@ error:
 	return -1;
 }
 
+static int tsync_store_cpu_sched_data(unsigned long long ts, int cpu,
+				      int *sched_cpu_count,
+				      struct ts_sched_cpu **sched_array)
+{
+	struct ts_sched_cpu *sched;
+
+	sched = realloc(*sched_array,
+			(*sched_cpu_count + 1) * sizeof(struct ts_sched_cpu));
+	if (!sched)
+		return -1;
+
+	sched[*sched_cpu_count].ts = ts;
+	sched[*sched_cpu_count].host_cpu = cpu;
+	*sched_array = sched;
+	(*sched_cpu_count)++;
+	return 0;
+}
+
+static int tsync_compact_cpu_sched_data(int *sched_cpu_count,
+					struct ts_sched_cpu **sched_array)
+{
+	struct ts_sched_cpu *sched;
+	int cpu = -1;
+	int count;
+	int i, j;
+
+	for (j = 0, i = 0; i < *sched_cpu_count; i++) {
+		if (cpu == (*sched_array)[i].host_cpu)
+			continue;
+		cpu = (*sched_array)[i].host_cpu;
+		j++;
+	}
+	sched = calloc(j, sizeof(struct ts_sched_cpu));
+	if (!sched)
+		return -1;
+	count = j;
+	for (i = 0, j = 0; i < *sched_cpu_count && j < count; i++) {
+		if (cpu == (*sched_array)[i].host_cpu)
+			continue;
+		memcpy(sched + j, (*sched_array) + i, sizeof(struct ts_sched_cpu));
+		cpu = (*sched_array)[i].host_cpu;
+		j++;
+	}
+	*sched_cpu_count = j;
+	free(*sched_array);
+	*sched_array = sched;
+
+	return 0;
+}
+
+static int trace_pid_sched_cmp(const void *a, const void *b)
+{
+	struct ts_sched_cpu *m_a = (struct ts_sched_cpu *)a;
+	struct ts_sched_cpu *m_b = (struct ts_sched_cpu *)b;
+
+	if (m_a->ts > m_b->ts)
+		return 1;
+	if (m_a->ts < m_b->ts)
+		return -1;
+	return 0;
+}
+
+static int tsync_load_cpu_sched_data(struct host_trace_info *host,
+				     struct guest_trace_info *guest)
+{
+	struct tracecmd_input *peer = host->peer_data;
+	struct tep_format_field	*next_pid = NULL;
+	struct tep_event *sched_event;
+	unsigned long long pid;
+	struct tep_record *rec;
+	int i, j;
+	int ret = -1;
+	int *sched_cpu_count = NULL;
+	struct ts_sched_cpu **sched =  NULL;
+
+	if (!peer)
+		return -1;
+
+	sched_event = tep_find_event_by_name(peer->pevent,
+					     "sched", "sched_switch");
+	if (sched_event)
+		next_pid = tep_find_any_field(sched_event, "next_pid");
+	if (!next_pid)
+		return -1;
+	sched = calloc(guest->vcpu_count, sizeof(struct ts_sched_cpu *));
+	sched_cpu_count = calloc(guest->vcpu_count, sizeof(int));
+	if (!sched || !sched_cpu_count)
+		goto error;
+	for (i = 0; i < peer->cpus; i++) {
+		for (rec = tracecmd_read_cpu_first(peer, i);
+		     rec; rec = tracecmd_read_data(peer, i)) {
+			if (tep_data_type(peer->pevent, rec) != sched_event->id)
+				continue;
+			if (tep_read_number_field(next_pid, rec->data, &pid))
+				continue;
+			for (j = 0; j < guest->vcpu_count; j++) {
+				if (guest->cpu_pid[j] < 0)
+					continue;
+				if (pid != guest->cpu_pid[j])
+					continue;
+				ret = tsync_store_cpu_sched_data(rec->ts,
+								 rec->cpu,
+								 &sched_cpu_count[j],
+								 &sched[j]);
+				if (ret)
+					goto error;
+			}
+		}
+	}
+	host->vcpu_sched = calloc(guest->vcpu_count, sizeof(struct vcpu_sched_data));
+	if (!host->vcpu_sched)
+		goto error;
+	host->vcpu_count = guest->vcpu_count;
+	for (i = 0; i < guest->vcpu_count; i++) {
+		if (!sched[i])
+			continue;
+		qsort(sched[i], sched_cpu_count[i],
+			sizeof(struct ts_sched_cpu), trace_pid_sched_cmp);
+		tsync_compact_cpu_sched_data(&sched_cpu_count[i],
+					     &sched[i]);
+		host->vcpu_sched[i].cpu_sched = sched[i];
+		host->vcpu_sched[i].cpu_sched_count = sched_cpu_count[i];
+	}
+	ret = 0;
+
+error:
+	if (ret && sched) {
+		for (i = 0; i < guest->vcpu_count; i++)
+			free(sched[i]);
+	}
+	free(sched);
+	free(sched_cpu_count);
+	return ret;
+}
+
 static void tsync_check_enable(struct tracecmd_input *handle)
 {
 	struct host_trace_info	*host = &handle->host;
 	struct guest_trace_info *guest;
+	int ret;
 
 	host->sync_enable = false;
 
@@ -2268,7 +2486,12 @@ static void tsync_check_enable(struct tracecmd_input *handle)
 	if (!guest)
 		return;
 
-	host->sync_enable = true;
+	ret = 0;
+	if (host->cpu_count > 1)
+		ret = tsync_load_cpu_sched_data(host, guest);
+
+	if (!ret)
+		host->sync_enable = true;
 }
 
 static int tsync_offset_load(struct tracecmd_input *handle,
@@ -2311,11 +2534,17 @@ static void trace_tsync_offset_free(struct host_trace_info *host)
 
 	for (i = 0; i < host->cpu_count; i++)
 		free(host->cpu_time_offsets[i].ts_samples);
+	for (i = 0; i < host->vcpu_count; i++)
+		free(host->vcpu_sched[i].cpu_sched);
 
 	free(host->cpu_time_offsets);
 	host->cpu_time_offsets = NULL;
 	host->cpu_count = 0;
 
+	free(host->vcpu_sched);
+	host->vcpu_sched = NULL;
+	host->vcpu_count = 0;
+
 	if (host->peer_data) {
 		tracecmd_close(host->peer_data);
 		host->peer_data = NULL;
-- 
2.25.1

