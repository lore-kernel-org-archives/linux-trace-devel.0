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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD80C433E8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDBBC61969
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCVKAc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhCVKAB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 06:00:01 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD37CC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:59 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a7so20181533ejs.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nbgnKU8GP1yKd2NkXfeHddUmXNX+593CNhTW2h6Pyng=;
        b=PWc8XJGgHbMh/XW4Lxt6s+KrGnnlwJK+zlf0d98l9sCYKZNu2+UHjLLKGWUGQQkXag
         aFAqaV96muvxcyBeimFGjO/k8+kufI2cEfdtIE1ZaQ/MLM3OypuTrLidEC4BRnMH9epa
         rLASM9ZLSM56oLSkf+PMD5cM7DtrD5vHDJXOdYOp3ntQ96Z6QHfIBx/u55e4Zt2grcIu
         dx2V1svlbd6DeGA0w5JOfik6TstgkgmIQOXNYFVAuS7Z8TBToP0P3pFt3p584wR6hTXP
         tDiT229CQZjXzFbAPt81E0SaYIzuE5YXoBEMdlIA/f0hAYqkElBwG5KqOHvHbXR2U3uE
         iDxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nbgnKU8GP1yKd2NkXfeHddUmXNX+593CNhTW2h6Pyng=;
        b=CT7T27c1OuklU727NufpZF80Ir60dyW/yZeqkG5J+T1OZh7JQJPVeeQfHDvxBp70nB
         Gzdvjl7PmS/a1qA+CzdB7Iu6DngpSC0bI3ITKyfxLMCfJqiMT7JJkZzk2qsDyhJBBzNV
         XhAgIYbV4XrDDE1v3kEpq04SYsKMpPX/bOODI7SsLI3nmTQZHgQ0oUB6iavHxF6OZs8u
         XIGyQr9GpWs4ez6Xh5m0PmOkXzGRsbSry+d0v6vx4q7PvhPFOE299kt88fMVc8XkbB/R
         mlxyeAlzhMAT4gIojY0Yl+qpx1TuRK7PW2C+lbGgiusdjF43Qz5LHtt1h+/ri9J+bTCI
         ji1w==
X-Gm-Message-State: AOAM531F7/RdnxA0uRDQwF1ozKrQUzInCrNP9cAnHcEA3zwq20efNJv/
        5M1kUMdjSBfFvAngIWSMWNHSmZgzOtAVYw==
X-Google-Smtp-Source: ABdhPJzHQAG5D2SdaRF2pbvY8j0Eq9O4ZkM7jGSBb/7lSGaYkR7C5bw966JA3+aa2DgBTriwxew6vA==
X-Received: by 2002:a17:906:33d9:: with SMTP id w25mr19186073eja.413.1616407198538;
        Mon, 22 Mar 2021 02:59:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:59:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 12/18] trace-cmd: Convert tsc timestamps to nanosecods when reading trace data from a file
Date:   Mon, 22 Mar 2021 11:59:39 +0200
Message-Id: <20210322095945.259300-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If there is information for TSC to nanoseconds conversion in the trace
file metadata, use it to recalculate the timestamps of all events.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index dfbe4af6..7ac81809 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1196,6 +1196,23 @@ static void free_next(struct tracecmd_input *handle, int cpu)
 	tracecmd_free_record(record);
 }
 
+/* This functions was taken from the Linux kernel */
+static unsigned long long mul_u64_u32_shr(unsigned long long a,
+					  unsigned long long mul, unsigned int shift)
+{
+	unsigned int ah, al;
+	unsigned long long ret;
+
+	al = a;
+	ah = a >> 32;
+
+	ret = (al * mul) >> shift;
+	if (ah)
+		ret += (ah * mul) << (32 - shift);
+
+	return ret;
+}
+
 static inline unsigned long long
 timestamp_correction_calc(unsigned long long ts, unsigned int flags,
 			  struct ts_offset_sample *min,
@@ -1279,14 +1296,18 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 static unsigned long long timestamp_calc(unsigned long long ts,
 					 struct tracecmd_input *handle)
 {
-	unsigned long long tstamp;
+	unsigned long long t;
 
-	tstamp = timestamp_correct(ts, handle);
+	t = timestamp_correct(ts, handle);
 
 	if (handle->ts2secs)
-		tstamp *= handle->ts2secs;
+		t *= handle->ts2secs;
+	else if (handle->tsc_calc.mult) {
+		t -= handle->tsc_calc.offset;
+		t = mul_u64_u32_shr(t, handle->tsc_calc.mult, handle->tsc_calc.shift);
+	}
 
-	return tstamp;
+	return t;
 }
 
 /*
-- 
2.30.2

