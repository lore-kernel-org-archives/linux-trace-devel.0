Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01378C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3C6521872
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfCOIiH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 04:38:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54698 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbfCOIiH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 04:38:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id f3so5676075wmj.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Mar 2019 01:38:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a65R29ab84iU7FWh6wgt8gqgAlNMmfz17wQ37VVyd4c=;
        b=LXljd24Cmv4LcPQlVR6ZhCDI/WRdXSbKyICnIdteqCahCDGxWq374Lb8J5IembPp4y
         GrG6oVsRXyU7CSRbJL8Gvda1t3CLap4X+cvDWHxd5uWnWElqvaxUbyYTnQnm3x9YUAIM
         VbY6uWWPZ91p7g7siPdvqOo5IZiJDKclec/5RkEIPH1l0jw1uAaeXFlzNjhXRf18eYIz
         BIwJ2RWCEZPfkWtzMOTcMlbSgKgTWkvSsxl62/kYPDk9cs2rLGTLkcDqBU421dD7/emy
         uvu7+S2VatyfU3ITM5W0hdv8X94xkPt3ulaP+918Al5eEZboAwjzw5E8RVdzIyjw5+vl
         gUng==
X-Gm-Message-State: APjAAAUp6eEktGkB6pPgnLSB+hQ+sRdON3CQcTCbqQ02SsWmz+AhAvun
        pOE95LH52d5x+TsFBbyVCv0=
X-Google-Smtp-Source: APXvYqxVjwUyL1i9fSagw0BlMGn0a03Wvjn7/0jyWCag88KZGqcnIMny7fwvke1IceCvuOpyt/ckWA==
X-Received: by 2002:a1c:f61a:: with SMTP id w26mr1324151wmc.70.1552639084922;
        Fri, 15 Mar 2019 01:38:04 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o5sm979395wmh.12.2019.03.15.01.38.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Mar 2019 01:38:04 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 8/9] trace-cmd: Implemented new option in trace.dat file: TRACECMD_OPTION_TIME_SHIFT
Date:   Fri, 15 Mar 2019 10:37:53 +0200
Message-Id: <20190315083754.27532-9-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315083754.27532-1-tstoyanov@vmware.com>
References: <20190315083754.27532-1-tstoyanov@vmware.com>
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
 lib/trace-cmd/trace-input.c   | 119 +++++++++++++++++++++++++++++++++-
 2 files changed, 118 insertions(+), 2 deletions(-)

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
index 0a6e820..714f01c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -75,6 +75,11 @@ struct input_buffer_instance {
 	size_t			offset;
 };
 
+struct ts_offset_corr {
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
+	int			ts_corr_count;
+	struct ts_offset_corr	*ts_corr;
 	double			ts2secs;
 	char *			cpustats;
 	char *			uname;
@@ -1028,6 +1035,68 @@ static void free_next(struct tracecmd_input *handle, int cpu)
 	free_record(record);
 }
 
+static inline unsigned long long
+timestamp_correction_calc(unsigned long long ts, struct ts_offset_corr *min,
+			  struct ts_offset_corr *max)
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
+	static int min = -1;
+	static int max = -1;
+	int i;
+
+	if (handle->ts_offset)
+		return ts + handle->ts_offset;
+	if (!handle->ts_corr_count || !handle->ts_corr)
+		return ts;
+
+	/* We have only one offset, nothing to calc here */
+	if (handle->ts_corr_count == 1)
+		return ts + handle->ts_corr[0].offset;
+
+	/* We have two offsets, nothing to search here */
+	if (handle->ts_corr_count == 2)
+		return timestamp_correction_calc(ts, &handle->ts_corr[0],
+						 &handle->ts_corr[1]);
+
+	/* We have more than two offsets */
+	/* check if current ts fits in the last found time frame */
+	if (min >= 0 && max >= 0 &&
+	    ts >= handle->ts_corr[min].time &&
+	    ts <= handle->ts_corr[max].time) {
+		return timestamp_correction_calc(ts, &handle->ts_corr[min],
+						 &handle->ts_corr[max]);
+	}
+	min = -1;
+	max = -1;
+	for (i = 0; i < handle->ts_corr_count; i++) {
+		if (ts > handle->ts_corr[i].time)
+			min = i;
+		else if (ts <= handle->ts_corr[i].time) {
+			max = i;
+			break;
+		}
+	}
+	if (min >= 0 && max >= 0 && min != max &&
+	    min < handle->ts_corr_count && max < handle->ts_corr_count)
+		return timestamp_correction_calc(ts, &handle->ts_corr[min],
+						 &handle->ts_corr[max]);
+
+	return ts;
+}
+
 /*
  * Page is mapped, now read in the page header info.
  */
@@ -1049,7 +1118,7 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 		    kbuffer_subbuffer_size(kbuf));
 		return -1;
 	}
-	handle->cpu_data[cpu].timestamp = kbuffer_timestamp(kbuf) + handle->ts_offset;
+	handle->cpu_data[cpu].timestamp = timestamp_correct(kbuffer_timestamp(kbuf), handle);
 
 	if (handle->ts2secs)
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
@@ -1776,7 +1845,7 @@ read_again:
 		goto read_again;
 	}
 
-	handle->cpu_data[cpu].timestamp = ts + handle->ts_offset;
+	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
 
 	if (handle->ts2secs) {
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
@@ -2101,6 +2170,34 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
 	handle->use_trace_clock = false;
 }
 
+static int tsync_offset_cmp(const void *a, const void *b)
+{
+	struct ts_offset_corr *ts_a = (struct ts_offset_corr *)a;
+	struct ts_offset_corr *ts_b = (struct ts_offset_corr *)b;
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
+	int i;
+	long long *buf8 = (long long *)buf;
+
+	for (i = 0; i < handle->ts_corr_count; i++) {
+		handle->ts_corr[i].time = tep_read_number(handle->pevent,
+							  buf8+i, 8);
+		handle->ts_corr[i].offset = tep_read_number(handle->pevent,
+						buf8+handle->ts_corr_count+i, 8);
+	}
+	qsort(handle->ts_corr,
+	      handle->ts_corr_count, sizeof(struct ts_offset_corr),
+	      tsync_offset_cmp);
+}
+
 static int handle_options(struct tracecmd_input *handle)
 {
 	long long offset;
@@ -2111,6 +2208,7 @@ static int handle_options(struct tracecmd_input *handle)
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
+	int tsync;
 	int cpus;
 
 	for (;;) {
@@ -2155,6 +2253,23 @@ static int handle_options(struct tracecmd_input *handle)
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
+			handle->ts_corr_count = tep_read_number(handle->pevent,
+								buf, 4);
+			tsync = (sizeof(long long)*handle->ts_corr_count);
+			if (size != (4+(2*tsync)))
+				break;
+			handle->ts_corr = malloc(2*tsync);
+			if (!handle->ts_corr)
+				return -ENOMEM;
+			tsync_offset_load(handle, buf+4);
+			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
 			cpustats = realloc(cpustats, cpustats_size + size + 1);
-- 
2.20.1

