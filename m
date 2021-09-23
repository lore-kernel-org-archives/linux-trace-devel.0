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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2908C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 09:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9F9E61250
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 09:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240219AbhIWJrS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 Sep 2021 05:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240244AbhIWJrE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 05:47:04 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED8CC061764
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 Sep 2021 02:45:32 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u18so15422250wrg.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 Sep 2021 02:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sbUpbRewVtZ4OErhCZmXhtXATMGDVmkr7t/v1SocD+Y=;
        b=U+CwAgF2E9W330Ik1Ra3N6IOCEl/wzpe8MWkBINII7n8jb9+xeRZfh3KetwNb1fvwe
         9R834tNu5KqOTymTnkI0sryTdHyuk/ikq+PYY2K0eN1PtQp5u8IZOpqLnXU6w3RRqQMx
         g7X2YCXD4lrcFU0b934HHKcoTKJ3Xg1MDFL8XgcCRPVeZQlMaY7cXxVFivvIO5YRGoI4
         Fhoh18jCItwVvMw6EuJ5KviB0jjKscMkzek9uR13yHA0F0nJ00qgEmXOh5vpgLkb8bWz
         htD+jFrXqybA7Er1Xux9cgLRrBGKsTz91rRqvUbNLwuoJjEAv4URLLXz3oyiEJ17g09b
         Kc3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sbUpbRewVtZ4OErhCZmXhtXATMGDVmkr7t/v1SocD+Y=;
        b=YRQ+aUyhNDkckk58m3mQn1wniBS9X8wB0SD7lFCw4+zoSkDRrewJLLMb4WkU+5RlN2
         FtWCQe3WNFdGrPrBjGdJoPsmyzdgqp7qoDeYkkDFwH7qBU80cEYWR1L7FY/oK8FYut1r
         TtP+IpUCntwHeyU0NapOsEBIKoGxlIFQdC0zi4ZqzmM1UuaketCuWWbj9dWCdUrWbOyc
         luUJbYnb4+Upc2dz0Cg3auh4XoqccKreebr/t66WV5/3R31S2yzuU8vCZl03mm88+3ij
         A6QwII6f2SfvE1xMdCO02zfimiqPSPZV187HbFN9HwFXJTzYiKUwx4tRbu1+61gYatrl
         SkAQ==
X-Gm-Message-State: AOAM532I47oxjNY0JH0xZqvnszs2ZsNbeOBJnunVgj8RNfqC6oeQIWIB
        F+udKC2togAzKPkzTHdYPXmp3FtTv/zHow==
X-Google-Smtp-Source: ABdhPJxle74NsTfCUgRjak44CRbOUA6oez6bmqR6vGH8Vd7rvy/CdeKV239LMj4C6jtgTctkJjtUXg==
X-Received: by 2002:a05:6000:18a4:: with SMTP id b4mr4023612wri.288.1632390330898;
        Thu, 23 Sep 2021 02:45:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d7sm4969523wrh.13.2021.09.23.02.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 02:45:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] trace-cmd: Read and use fraction bits from TRACECMD_OPTION_TIME_SHIFT
Date:   Thu, 23 Sep 2021 12:45:25 +0300
Message-Id: <20210923094526.765059-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923094526.765059-1-tz.stoyanov@gmail.com>
References: <20210923094526.765059-1-tz.stoyanov@gmail.com>
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
index ac57bc4f..996f9707 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -83,6 +83,7 @@ struct ts_offset_sample {
 	long long	time;
 	long long	offset;
 	long long	scaling;
+	long long	fraction;
 };
 
 struct guest_trace_info {
@@ -1235,7 +1236,6 @@ timestamp_correction_calc(unsigned long long ts, unsigned int flags,
 			  struct ts_offset_sample *min,
 			  struct ts_offset_sample *max)
 {
-	long long scaling;
 	long long tscor;
 
 	if (flags & TRACECMD_TSYNC_FLAG_INTERPOLATE) {
@@ -1243,15 +1243,12 @@ timestamp_correction_calc(unsigned long long ts, unsigned int flags,
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
 
@@ -2337,37 +2334,16 @@ static int tsync_offset_cmp(const void *a, const void *b)
 
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
@@ -2375,17 +2351,36 @@ static int tsync_cpu_offsets_load(struct tracecmd_input *handle, char *buf, int
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
 
@@ -2715,6 +2710,10 @@ static int handle_options(struct tracecmd_input *handle)
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

