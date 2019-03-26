Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33153C10F05
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 047072070D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731654AbfCZPHE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:07:04 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43557 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfCZPHE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 11:07:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id k17so6827245wrx.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Mar 2019 08:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ukoxtg+2FxxlqYYzmFb82zFrOxig6XaSNjnvYYLJ2gE=;
        b=ftRSDns4UvArCVZ79ire9JRHojr5py9yuwT+CPYllxpiR2neYomz4pmSH7h9YbT/t2
         9KU4m5nz9fbBH3ZRZFmsM+OeHGMLPfSpd6kPUV5iVjOfxim/KqcQnmwX6JKImrmol4KP
         Pj4sg5pZQJzb54lq7GhgCfGFAMxkuuoXR2pBW5d1iotEMsSWJqBtk2ybre52qjTSBfbd
         sMivmq5j/x/HNIeZZYrgTHVc8on1F1yYfZ1bZJ+K3ZFj1A+STamCmmu2AGz9IP0t2P67
         TIph2RtSDAYULZMrRQfRP5eAib117DuGqeB5PQly3zN4EH+x2jd0XClzZlBspa4JTohL
         aH+A==
X-Gm-Message-State: APjAAAUhjggIyd+rIxA42/QWdpTWXJS03ZRbFLKa2kTSQjT8vp9+aymQ
        +5ri+A4ZgekZIoHBaCrxmlA=
X-Google-Smtp-Source: APXvYqxe0dBnMZykdu4v7Pnu8v+YUZUPcxxAXUjGjO2LxUQ7qSoLu8cRn5l/7pT+rSKIF0XAL5YzyQ==
X-Received: by 2002:a5d:6883:: with SMTP id h3mr19433328wru.215.1553612822319;
        Tue, 26 Mar 2019 08:07:02 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 13sm6833631wmf.23.2019.03.26.08.07.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Mar 2019 08:07:01 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v10 8/9] trace-cmd: Implemented new option in trace.dat file: TRACECMD_OPTION_TIME_SHIFT
Date:   Tue, 26 Mar 2019 17:06:50 +0200
Message-Id: <20190326150651.25811-9-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190326150651.25811-1-tstoyanov@vmware.com>
References: <20190326150651.25811-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The TRACECMD_OPTION_TIME_SHIFT is used when synchronizing trace time stamps between
two trace.dat files. It contains multiple long long (time, offset) pairs, describing
time stamps _offset_, measured in the given local _time_. The content of the option
buffer is:
 first 4 bytes - integer, count of timestamp offsets
 long long array of size _count_, local time in which the offset is measured
 long long array of size _count_, offset of the time stamps

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h |   1 +
 lib/trace-cmd/trace-input.c   | 126 +++++++++++++++++++++++++++++++++-
 2 files changed, 125 insertions(+), 2 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index f7c043a..5552396 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -82,6 +82,7 @@ enum {
 	TRACECMD_OPTION_HOOK,
 	TRACECMD_OPTION_OFFSET,
 	TRACECMD_OPTION_CPUCOUNT,
+	TRACECMD_OPTION_TIME_SHIFT,
 };
 
 enum {
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 0a6e820..84dcdfb 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -75,6 +75,11 @@ struct input_buffer_instance {
 	size_t			offset;
 };
 
+struct ts_offset_sample {
+	long long	time;
+	long long	offset;
+};
+
 struct tracecmd_input {
 	struct tep_handle	*pevent;
 	struct tep_plugin_list	*plugin_list;
@@ -92,6 +97,8 @@ struct tracecmd_input {
 	bool			use_pipe;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
+	int			ts_samples_count;
+	struct ts_offset_sample	*ts_samples;
 	double			ts2secs;
 	char *			cpustats;
 	char *			uname;
@@ -1028,6 +1035,66 @@ static void free_next(struct tracecmd_input *handle, int cpu)
 	free_record(record);
 }
 
+static inline unsigned long long
+timestamp_correction_calc(unsigned long long ts, struct ts_offset_sample *min,
+			  struct ts_offset_sample *max)
+{
+	long long tscor = min->offset +
+			(((((long long)ts) - min->time)*
+			(max->offset-min->offset))/(max->time-min->time));
+
+	if (tscor < 0)
+		return ts - llabs(tscor);
+
+	return ts + tscor;
+
+}
+
+static unsigned long long timestamp_correct(unsigned long long ts,
+					    struct tracecmd_input *handle)
+{
+	int min, mid, max;
+
+	if (handle->ts_offset)
+		return ts + handle->ts_offset;
+	if (!handle->ts_samples_count || !handle->ts_samples)
+		return ts;
+
+	/* We have one sample, nothing to calc here */
+	if (handle->ts_samples_count == 1)
+		return ts + handle->ts_samples[0].offset;
+
+	/* We have two samples, nothing to search here */
+	if (handle->ts_samples_count == 2)
+		return timestamp_correction_calc(ts, &handle->ts_samples[0],
+						 &handle->ts_samples[1]);
+
+	/* We have more than two samples */
+	if (ts <= handle->ts_samples[0].time)
+		return timestamp_correction_calc(ts,
+						  &handle->ts_samples[0],
+						  &handle->ts_samples[1]);
+	else if (ts >= handle->ts_samples[handle->ts_samples_count-1].time)
+		return timestamp_correction_calc(ts,
+						 &handle->ts_samples[handle->ts_samples_count-2],
+						 &handle->ts_samples[handle->ts_samples_count-1]);
+	min = 0;
+	max = handle->ts_samples_count-1;
+	mid = (min + max)/2;
+	while (min <= max) {
+		if (ts < handle->ts_samples[mid].time)
+			max = mid - 1;
+		else if (ts > handle->ts_samples[mid].time)
+			min = mid + 1;
+		else
+			break;
+		mid = (min + max)/2;
+	}
+
+	return timestamp_correction_calc(ts, &handle->ts_samples[mid],
+					 &handle->ts_samples[mid+1]);
+}
+
 /*
  * Page is mapped, now read in the page header info.
  */
@@ -1049,7 +1116,7 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 		    kbuffer_subbuffer_size(kbuf));
 		return -1;
 	}
-	handle->cpu_data[cpu].timestamp = kbuffer_timestamp(kbuf) + handle->ts_offset;
+	handle->cpu_data[cpu].timestamp = timestamp_correct(kbuffer_timestamp(kbuf), handle);
 
 	if (handle->ts2secs)
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
@@ -1776,7 +1843,7 @@ read_again:
 		goto read_again;
 	}
 
-	handle->cpu_data[cpu].timestamp = ts + handle->ts_offset;
+	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
 
 	if (handle->ts2secs) {
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
@@ -2101,6 +2168,41 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
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
+	int i, j;
+	long long *buf8 = (long long *)buf;
+
+	for (i = 0; i < handle->ts_samples_count; i++) {
+		handle->ts_samples[i].time = tep_read_number(handle->pevent,
+							  buf8+i, 8);
+		handle->ts_samples[i].offset = tep_read_number(handle->pevent,
+						buf8+handle->ts_samples_count+i, 8);
+	}
+	qsort(handle->ts_samples,
+	      handle->ts_samples_count, sizeof(struct ts_offset_sample),
+	      tsync_offset_cmp);
+	/* Filter possible samples with equal time */
+	for (i = 0, j = 0; i < handle->ts_samples_count; i++) {
+		if (i == 0 ||
+		    handle->ts_samples[i].time != handle->ts_samples[i-1].time) {
+			handle->ts_samples[j++] = handle->ts_samples[i];
+		}
+	}
+}
+
 static int handle_options(struct tracecmd_input *handle)
 {
 	long long offset;
@@ -2111,6 +2213,7 @@ static int handle_options(struct tracecmd_input *handle)
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
+	int tsync;
 	int cpus;
 
 	for (;;) {
@@ -2155,6 +2258,25 @@ static int handle_options(struct tracecmd_input *handle)
 			offset = strtoll(buf, NULL, 0);
 			handle->ts_offset += offset;
 			break;
+		case TRACECMD_OPTION_TIME_SHIFT:
+			/*
+			 * int (4 bytes) count of timestamp offsets.
+			 * long long array of size [count] of times,
+			 *	when the offsets were calculated.
+			 * long long array of size [count] of timestamp offsets.
+			 */
+			if (handle->flags & TRACECMD_FL_IGNORE_DATE)
+				break;
+			handle->ts_samples_count = tep_read_number(handle->pevent,
+								buf, 4);
+			tsync = (sizeof(long long)*handle->ts_samples_count);
+			if (size != (4+(2*tsync)))
+				break;
+			handle->ts_samples = malloc(2*tsync);
+			if (!handle->ts_samples)
+				return -ENOMEM;
+			tsync_offset_load(handle, buf+4);
+			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
 			cpustats = realloc(cpustats, cpustats_size + size + 1);
-- 
2.20.1

