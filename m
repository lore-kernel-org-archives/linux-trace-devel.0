Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6E4C3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0BFE2339E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:57:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JXbA/KJ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfH1I57 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 04:57:59 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46324 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfH1I57 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 04:57:59 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so1607224wru.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Aug 2019 01:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bsSiUlLbkTiBJEfghxW68sYmB/mqaE3O66hKCM23NFk=;
        b=JXbA/KJ0wzeacwzrNz7VXQi1zh35udgR2HN2TjcbomjWlXALcOiZIktTE6q/XLIfd3
         pILDq1Nxcyl9J6E0m3rdbsCMxRppYqfj9kqFCIyk3b9K9R80j8ILaFJUPw5k8qFnm6fZ
         rdIU8vFZozqLaaH/+uYN4RmCSMNYWr5dvW0O+mNup1AWoe3RWDZbSUGxhb4iZfWRqzXT
         hfPmoDGyO2l5j2vdYIG3MSmxGJtPhBIWi+6FmFPyTKoq6dKR/kGezMbtuIyFAqrI+BF9
         6To18hg9WIl+YxjNpc/WriAUo6yC/RGkVQSdRNeYxcJIqBrwvMZexO/hjuozh3L3KuiB
         jGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bsSiUlLbkTiBJEfghxW68sYmB/mqaE3O66hKCM23NFk=;
        b=sClkaAFUvBPplNVPT5beDavnE8h4Hqtzp+beO4diYqonSqDvXbAeWyc27VjNNgtoF8
         WOIVYgR7IB8BTB54TULq3SvBi2BMM9ne+kH7ngGdt4KpyNcK2VnHurAc+PJFkVGFe0Mc
         5HxEAUbU5M/IqemKS7opKJvu4TkiQKAU55+C0RtOf5vmCPGKYRZ3LexACHp6A8VwnGAs
         zHfKpx3gUS1/vUWJEdlqXeSrFmasLGzWWScpyWQC/6ipQs9jdLq1fOXFDhAVXMtJjrxA
         1MG9f3QPMgi6bkCHTPXuPOL7JwlVk5ej5KmFRXHqc61IUXodhI2Mg1e9Ho3mWBVJLyUE
         PbTQ==
X-Gm-Message-State: APjAAAU9h0QrJ6OTJgtyYWIDXAV5w/OAw07HeXzJNuv71zp/g/bF8ShX
        gtLbDm0l+/DVD8ky+XTQJTU=
X-Google-Smtp-Source: APXvYqyr777MSfZt2wenBFs46bV3In3V/kbfKVFywFaNwkbTYdraTVbSPxmKOBGvAD2Unaj0yaExcA==
X-Received: by 2002:a5d:5591:: with SMTP id i17mr3203547wrv.280.1566982676403;
        Wed, 28 Aug 2019 01:57:56 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u186sm2579433wmu.26.2019.08.28.01.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 01:57:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 8/9] trace-cmd: Implemented new option in trace.dat file: TRACECMD_OPTION_TIME_SHIFT
Date:   Wed, 28 Aug 2019 11:57:45 +0300
Message-Id: <20190828085746.26231-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828085746.26231-1-tz.stoyanov@gmail.com>
References: <20190828085746.26231-1-tz.stoyanov@gmail.com>
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
 first 4 bytes - integer, count of timestamp offsets
 long long array of size _count_, local time in which the offset is measured
 long long array of size _count_, offset of the time stamps

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h |   1 +
 lib/trace-cmd/trace-input.c   | 127 +++++++++++++++++++++++++++++++++-
 2 files changed, 126 insertions(+), 2 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6f7bc2e..c202773 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -84,6 +84,7 @@ enum {
 	TRACECMD_OPTION_OFFSET,
 	TRACECMD_OPTION_CPUCOUNT,
 	TRACECMD_OPTION_VERSION,
+	TRACECMD_OPTION_TIME_SHIFT,
 };
 
 enum {
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 3bb17f9..5a5fe3b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -74,6 +74,11 @@ struct input_buffer_instance {
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
@@ -91,6 +96,8 @@ struct tracecmd_input {
 	bool			use_pipe;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
+	int			ts_samples_count;
+	struct ts_offset_sample	*ts_samples;
 	double			ts2secs;
 	char *			cpustats;
 	char *			uname;
@@ -1069,6 +1076,66 @@ static void free_next(struct tracecmd_input *handle, int cpu)
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
@@ -1090,7 +1157,7 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 		    kbuffer_subbuffer_size(kbuf));
 		return -1;
 	}
-	handle->cpu_data[cpu].timestamp = kbuffer_timestamp(kbuf) + handle->ts_offset;
+	handle->cpu_data[cpu].timestamp = timestamp_correct(kbuffer_timestamp(kbuf), handle);
 
 	if (handle->ts2secs)
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
@@ -1817,7 +1884,7 @@ read_again:
 		goto read_again;
 	}
 
-	handle->cpu_data[cpu].timestamp = ts + handle->ts_offset;
+	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
 
 	if (handle->ts2secs) {
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
@@ -2140,6 +2207,42 @@ void tracecmd_set_ts2secs(struct tracecmd_input *handle,
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
+	handle->ts_samples_count = j;
+}
+
 static int handle_options(struct tracecmd_input *handle)
 {
 	long long offset;
@@ -2150,6 +2253,7 @@ static int handle_options(struct tracecmd_input *handle)
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
+	int sampes_size;
 	int cpus;
 
 	for (;;) {
@@ -2194,6 +2298,25 @@ static int handle_options(struct tracecmd_input *handle)
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
+								   buf, 4);
+			sampes_size = (8*handle->ts_samples_count);
+			if (size != (4+(2*sampes_size)))
+				break;
+			handle->ts_samples = malloc(2*sampes_size);
+			if (!handle->ts_samples)
+				return -ENOMEM;
+			tsync_offset_load(handle, buf+4);
+			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
 			cpustats = realloc(cpustats, cpustats_size + size + 1);
-- 
2.21.0

