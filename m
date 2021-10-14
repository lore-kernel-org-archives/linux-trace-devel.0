Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBD4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Oct 2021 15:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1123D61039
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Oct 2021 15:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhJNPOM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Oct 2021 11:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbhJNPNN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 11:13:13 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7629C02B842
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Oct 2021 08:02:18 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e12so20470955wra.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Oct 2021 08:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=csEyGTT39DFEhMz5eIScBujJARqktc+05PV87kNIANk=;
        b=KVAJ16h5EXA/GHGDig0wRhDMOis+qVxvOxKBilAykXzHgCaOyBAENepFNYMYcejAX3
         LgHrHfR3qVq2W3WJ0zJu1OvFl8xB6/uP7uI31SoeQEqWimn+IQ9EAJG42gtj9HZX+EDu
         /FTqe7eNAhFqh8PQIWEztIfdDg5u4NsczNGCmKT/HxqLj4fMlyzXz+nHeS8MQFd8JIPx
         3dqb0FD/xS0DMqQMNezDoHg6uoY/GlMk7x4yJFTGlvUGBbFyOlbYSOnwFEgzB2szZ7Gi
         sLCb2WU4PQqH6mIOLjfsn1xrRNlpRehpucDgQ6flaVZZNVxV3uNOoGnWrFPRQy4lcbD9
         j6SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=csEyGTT39DFEhMz5eIScBujJARqktc+05PV87kNIANk=;
        b=uZ0vMGwuXTTKBjHKnPnLSLwHIicTYyclFbuRQ4D/DAy07aa5KnRPGyeEORsxfVOgoW
         fDQYwJOGxvNhLHVfVMBLugsZY/kJxKwDYBYCV1MtHkmVjePuc3aE3ouwizz/1jnSv6bv
         XpGMQyNHdVb2uBd1SQ1dwRYA+vi5n7SlXdV35CFdrFKjXQZ/ff/Yg846fYt6WN06RVUy
         W4/CxjEx5k7kFDWr/x10fukv3k2XtjEjO3Ruhec5tdQXsYSee8N1a/EURUWlyg/sC967
         ghBUsKtjjcYj7xYrG9Y61dLDMI6Q2V8Ds6/7yq2hKwbOjE5JsiGEur0r5f3ZEvlu7l3l
         6WdA==
X-Gm-Message-State: AOAM533kDULa8qywAYXMEDi3maobHNOFEovgDYV+NRpYXmlVtHqrO8kP
        ZoxKhg/THvdKyeGNEcJjQhc=
X-Google-Smtp-Source: ABdhPJy2ZzIJ4rf+ypPX5TZNVUM3cBdpOKJdr2CoumsvI2lhfWz8h1NsqDhxTAGSsh5cTM408QBR7Q==
X-Received: by 2002:a5d:6d8e:: with SMTP id l14mr7268146wrs.44.1634223732523;
        Thu, 14 Oct 2021 08:02:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm2738065wro.25.2021.10.14.08.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:02:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/4] trace-cmd library: Read and use fraction bits from TRACECMD_OPTION_TIME_SHIFT
Date:   Thu, 14 Oct 2021 18:02:03 +0300
Message-Id: <20211014150204.2485499-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211014150204.2485499-1-tz.stoyanov@gmail.com>
References: <20211014150204.2485499-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If there is array with guest time scaling fraction bits in
TRACECMD_OPTION_TIME_SHIFT option, read that information.
The formula for calculating guest timestamps is aligned with the formula
used in the kernel:
 guest_tsc = tsc-offset + (host_tsc * tsc-scaling-ratio) >> tsc-scaling-ratio-frac-bits

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 79 ++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 40 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ec4c6e55..df2e42bd 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -83,6 +83,7 @@ struct ts_offset_sample {
 	long long	time;
 	long long	offset;
 	long long	scaling;
+	long long	fraction;
 };
 
 struct guest_trace_info {
@@ -1245,7 +1246,6 @@ timestamp_correction_calc(unsigned long long ts, unsigned int flags,
 			  struct ts_offset_sample *min,
 			  struct ts_offset_sample *max)
 {
-	long long scaling;
 	long long tscor;
 
 	if (flags & TRACECMD_TSYNC_FLAG_INTERPOLATE) {
@@ -1253,15 +1253,12 @@ timestamp_correction_calc(unsigned long long ts, unsigned int flags,
 		long long offset = ((long long)ts - min->time) *
 				   (max->offset - min->offset);
 
-		scaling = (min->scaling + max->scaling) / 2;
 		tscor = min->offset + (offset + delta / 2) / delta;
-
 	} else {
-		scaling = min->scaling;
 		tscor = min->offset;
 	}
 
-	ts *= scaling;
+	ts = (ts * min->scaling) >> min->fraction;
 	if (tscor < 0)
 		return ts - llabs(tscor);
 
@@ -2347,37 +2344,16 @@ static int tsync_offset_cmp(const void *a, const void *b)
 
 #define safe_read_loop(type)						\
 	do {								\
-		int i;							\
-		for (i = 0; i < ts_offsets->ts_samples_count; i++)	\
-			safe_read(ts_offsets->ts_samples[i].type, 8);	\
+		int ii;							\
+		for (ii = 0; ii < ts_offsets->ts_samples_count; ii++)	\
+			safe_read(ts_offsets->ts_samples[ii].type, 8);	\
 	} while (0)
 
-static int tsync_offset_load(struct tep_handle	*tep,
-			     struct timesync_offsets *ts_offsets, char *buf, int size)
-{
-	int start_size = size;
-	int i, j;
-
-	safe_read_loop(time);
-	safe_read_loop(offset);
-	safe_read_loop(scaling);
-	qsort(ts_offsets->ts_samples, ts_offsets->ts_samples_count,
-	      sizeof(struct ts_offset_sample), tsync_offset_cmp);
-	/* Filter possible samples with equal time */
-	for (i = 0, j = 0; i < ts_offsets->ts_samples_count; i++) {
-		if (i == 0 || ts_offsets->ts_samples[i].time != ts_offsets->ts_samples[i-1].time)
-			ts_offsets->ts_samples[j++] = ts_offsets->ts_samples[i];
-	}
-	ts_offsets->ts_samples_count = j;
-
-	return start_size - size;
-}
-
 static int tsync_cpu_offsets_load(struct tracecmd_input *handle, char *buf, int size)
 {
 	struct tep_handle *tep = handle->pevent;
-	int ret;
-	int i;
+	struct timesync_offsets *ts_offsets;
+	int i, j, k;
 
 	safe_read(handle->host.cpu_count, 4);
 	handle->host.ts_offsets = calloc(handle->host.cpu_count,
@@ -2385,17 +2361,36 @@ static int tsync_cpu_offsets_load(struct tracecmd_input *handle, char *buf, int
 	if (!handle->host.ts_offsets)
 		return -ENOMEM;
 	for (i = 0; i < handle->host.cpu_count; i++) {
-		safe_read(handle->host.ts_offsets[i].ts_samples_count, 4);
-		handle->host.ts_offsets[i].ts_samples = calloc(handle->host.ts_offsets[i].ts_samples_count,
-							       sizeof(struct ts_offset_sample));
-		if (!handle->host.ts_offsets[i].ts_samples)
+		ts_offsets = &handle->host.ts_offsets[i];
+		safe_read(ts_offsets->ts_samples_count, 4);
+		ts_offsets->ts_samples = calloc(ts_offsets->ts_samples_count,
+						sizeof(struct ts_offset_sample));
+		if (!ts_offsets->ts_samples)
 			return -ENOMEM;
-		ret = tsync_offset_load(tep, &handle->host.ts_offsets[i], buf, size);
-		if (ret <= 0)
-			return -EFAULT;
-		size -= ret;
-		buf += ret;
+		safe_read_loop(time);
+		safe_read_loop(offset);
+		safe_read_loop(scaling);
 	}
+
+	if (size > 0) {
+		for (i = 0; i < handle->host.cpu_count; i++) {
+			ts_offsets = &handle->host.ts_offsets[i];
+			safe_read_loop(fraction);
+		}
+	}
+
+	for (i = 0; i < handle->host.cpu_count; i++) {
+		ts_offsets = &handle->host.ts_offsets[i];
+		qsort(ts_offsets->ts_samples, ts_offsets->ts_samples_count,
+		      sizeof(struct ts_offset_sample), tsync_offset_cmp);
+		/* Filter possible samples with equal time */
+		for (k = 0, j = 0; k < ts_offsets->ts_samples_count; k++) {
+			if (k == 0 || ts_offsets->ts_samples[k].time != ts_offsets->ts_samples[k-1].time)
+				ts_offsets->ts_samples[j++] = ts_offsets->ts_samples[k];
+		}
+		ts_offsets->ts_samples_count = j;
+	}
+
 	return 0;
 }
 
@@ -2722,6 +2717,10 @@ static int handle_options(struct tracecmd_input *handle)
 			 *  long long array of size [count] of timestamp offsets.
 			 *  long long array of size [count] of timestamp scaling ratios.*
 			 * ]
+			 * array of size [CPU count]:
+			 * [
+			 *  long long array of size [count] of timestamp scaling fraction bits.*
+			 * ]*
 			 */
 			if (size < 16 || (handle->flags & TRACECMD_FL_RAW_TS))
 				break;
-- 
2.31.1

