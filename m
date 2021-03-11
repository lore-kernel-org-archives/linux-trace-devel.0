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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C05EC43331
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60F0664FBB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhCKItt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhCKItX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 03:49:23 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D8FC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:23 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id dm8so1527553edb.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RICwZa/SJTEbfo0d3e5OR2tYOHLkAgRWMHeH7N1IA2Q=;
        b=DbYAeNB+19zFBs/9HDvdZlAn6NFEkfMj8RRZZvpSg90PKXkRnLgT8oSZkkVM3g7T8v
         cDbyJSirjl7/YenyRS2ujHxAgpVTRtEoAWyfpjzyOEECpEnmzujhJ0E5vYNgXH7baNR0
         CiF9FFig2a4ngYQ3U9Tq387VCg5OtbXEAHqm3jAMjJLGLSfwlGFvDUE9fWjVio52zGJJ
         Hc4qOHBF6nWfccsQkJ3S6ubGr8cUc0FV7FWd//XciE+PzehhtUXc/gN0nPCC9rbGo67j
         Dz1ekRvAswMcqpA0jhMEyICfJtqAW3GHpoav95Isd2ecNMnbm/2V1B9dpJ509tGkNavY
         bDrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RICwZa/SJTEbfo0d3e5OR2tYOHLkAgRWMHeH7N1IA2Q=;
        b=PMCIzX/ERrbrYAFtlJUe2rOynEg3l8JZRjF7omBkApVBJOYrkUBkvgbh/aPjJS8riB
         oGlZi3IZ32nTFHi5vWLli4+R9i4bOZIY9ipZ+v9GjTEhTzQ+dAPpqL75/TnrnWw7C+9N
         diete8WeohoqWG0y5CJZNb+bf7+/8bH1fxiBvTEoc5wWYQTIkaLITbj0ABf288Rh/6A1
         ohtDTiSBpKbjrq76T8x/eUMLA2yUTMaOn3zwfUhH4qjhUnWdxW1qCZnyF9eAVJbnhLgu
         X9X6XKaPQSBgmSwnLp2RghiAzqGL6OStNhKOC1m9VvOlMrYftHeRUZ6EQKa9I+xoRsjy
         7O+A==
X-Gm-Message-State: AOAM533PT4pNpT7L/679oy/npsUoXcKrSY7N2R0Kx8+5g1C3N8wLYRrD
        RQgLp3/HGiQuOHhxMA6cQFqrjcvQZRVp1Q==
X-Google-Smtp-Source: ABdhPJwPVNIMVAf3KpXdIMdE/etyETbgmK5nam01CdIlrzuEicVKwx9hBeUl+pyGNXvBFeAVL4pmCA==
X-Received: by 2002:a05:6402:51cd:: with SMTP id r13mr7513082edd.116.1615452562236;
        Thu, 11 Mar 2021 00:49:22 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id fi11sm901647ejb.73.2021.03.11.00.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 00:49:21 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v31 16/16] trace-cmd: Convert tsc timestamps to nanosecods when reading trace data from a file
Date:   Thu, 11 Mar 2021 10:48:57 +0200
Message-Id: <20210311084857.1919805-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
References: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If there is information for TSC to nanoseconds conversion in the trace
file metadata, use it to recalculate the timestamps of all events.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 60a59873..66483cc8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1287,17 +1287,37 @@ static unsigned long long timestamp_correct(unsigned long long ts, int cpu,
 					 &tsync->ts_samples[mid+1]);
 }
 
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
 static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
 					 struct tracecmd_input *handle)
 {
-	unsigned long long tstamp;
+	unsigned long long t;
 
-	tstamp = timestamp_correct(ts, cpu, handle);
+	t = timestamp_correct(ts, cpu, handle);
 
 	if (handle->ts2secs)
-		tstamp *= handle->ts2secs;
+		t *= handle->ts2secs;
+	else if (handle->tsc_calc.mult) {
+		t = mul_u64_u32_shr(t, handle->tsc_calc.mult, handle->tsc_calc.shift);
+		t += handle->tsc_calc.offset;
+	}
 
-	return tstamp;
+	return t;
 }
 
 /*
-- 
2.29.2

