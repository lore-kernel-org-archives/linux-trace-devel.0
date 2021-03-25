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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D46C433F2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1633A61A12
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhCYGlj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhCYGlN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:13 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D1CC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:13 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e18so1103060wrt.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MpH8LyKwbje/aQPtMTItjN3p/dZCO7Xx1rGgpNhlQyU=;
        b=Y7Y9cR9ikE45WYrgCBcAkPvQjVtBQog9dES8chXckiOOPSK5Y9Sfft2ZrQcZ1sKTWJ
         Pw7fyZKNH14wzB1jQEptn36SJas0inajqYO2pu3H5vxfgdmEthcMCYh9h5eRmtx/KFEc
         MgF7FjzTl7DVwgMGRDjHEkxuXv2jr2cGcE5spmVFLCXaOMOUs8ir+Lc4LPpDHyzegZij
         HnzPkMVqa5G0ojg5pdoq929GcijbShPJRfvj9XDlzxMmjfg27HuLN92ml3rrJCiMCVlF
         WF/fST1faf5sVIXTp01dA4KOASrkH+SUSSSp0iBpOu4MsxLyLSMHmAaw9BR8JNUa6Hs/
         hpvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MpH8LyKwbje/aQPtMTItjN3p/dZCO7Xx1rGgpNhlQyU=;
        b=OfBhhx37L5F794YYBC8JHpk4yDjWlC/oHB1NbUAMhXHTVtgbonicVOdIL+655h2NCa
         8ewuYbwI9YRN2WLmJxE64akk1bEE1LpR9bUBeCG0L+EhsyzvYnxkKFDWFq6+ei0LRj8q
         ta2807PdQXTZo5pgcpyezAro2i9cAwpzXGMzue0T0KL7LZk22Q0zzoB5J1YgxxtUjh9E
         FJyJLPPkuuchg5F2YRnDd86Vycwff5dn73KCEkugcpX9vlBip2cNiMA0LynWIk6qxjdZ
         4Cha+YKaUxF422gjuVpkWWKDRe0pAlmX3B+1mea7gWJQJmMuHtL7YvDCgwY9+/bYKz2I
         M8Ng==
X-Gm-Message-State: AOAM5305AUEJlsjE4SFEejfNpXvJxAdd2f0k6/VYKZwLhZct3FexA+LJ
        HlWBzAC4LXx6d/uXofDerN5XKNtxuSQYmA==
X-Google-Smtp-Source: ABdhPJxePsU4gY3FREiDsij9KNDADY6mgEIqIcFAa62ezXOMY/YFDe1e+O0JD2697I8c7Dxv/5KQrA==
X-Received: by 2002:a05:6000:1789:: with SMTP id e9mr7185428wrg.237.1616654471949;
        Wed, 24 Mar 2021 23:41:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 15/23] trace-cmd: Set order and priorities when applying timestamp corrections
Date:   Thu, 25 Mar 2021 08:40:47 +0200
Message-Id: <20210325064055.539554-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are multiple options that affect the event's timestamps while
recording trace or displaying the trace file. Some of these options can
be used together and the order and priorities for all of them should be
strictly defined:
 trace-cmd record --date , --ts-offset - only one of these can be used
 trace-cmd record host-guest trace - guest timestamps are auto
synchronized with host time stamps. If no trace clock is set by the user
and "kvm" synch plugin is available, then "x86-tsc" trace clock is used
and tsc timestamps are converted to nanoseconds in both host and guest
trace events.
 trace-cmd report --ts-offset, --ts2secs, --nodate

Event timestamps corrections are applied in this order, when the trace
file is opened for reading:
 1. If it is a guest trace file and there is information for
    synchronization with the host events and is this synchronization is
    enabled: synchronize guest events with host events.
 2. If the user has specified --ts2secs, apply it.
 3. If the user has not specified --ts2secs and there is information in
    the trace file metadata for tsc to nanosecond conversion, apply it.
 4. If the user has specified --ts-offset or --date, apply it. The
    offsets specified by "report" command have higher priority that the
    offsets specified by "record" command.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 266b0b0c..696e7bd8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1241,21 +1241,12 @@ timestamp_correction_calc(unsigned long long ts, unsigned int flags,
 	return ts + tscor;
 }
 
-static unsigned long long timestamp_correct(unsigned long long ts,
-					    struct tracecmd_input *handle)
+static unsigned long long timestamp_host_sync(unsigned long long ts,
+					      struct tracecmd_input *handle)
 {
 	struct host_trace_info	*host = &handle->host;
 	int min, mid, max;
 
-	if (handle->flags & TRACECMD_FL_IGNORE_DATE)
-		return ts;
-
-	if (handle->ts_offset)
-		return ts + handle->ts_offset;
-
-	if (!host->sync_enable)
-		return ts;
-
 	/* We have one sample, nothing to calc here */
 	if (host->ts_samples_count == 1)
 		return ts + host->ts_samples[0].offset;
@@ -1296,15 +1287,23 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 static unsigned long long timestamp_calc(unsigned long long ts,
 					 struct tracecmd_input *handle)
 {
-	ts = timestamp_correct(ts, handle);
+	/* Guest trace file, sync with host timestamps */
+	if (handle->host.sync_enable)
+		ts = timestamp_host_sync(ts, handle);
 
-	if (handle->ts2secs)
+	if (handle->ts2secs) {
+		/* user specified clock frequency */
 		ts *= handle->ts2secs;
-	else if (handle->tsc_calc.mult) {
+	} else if (handle->tsc_calc.mult) {
+		/* auto calculated TSC clock frequency */
 		ts -= handle->tsc_calc.offset;
 		ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
 	}
 
+	/* User specified time offset with --ts-offset or --date options */
+	if (handle->ts_offset)
+		ts += handle->ts_offset;
+
 	return ts;
 }
 
-- 
2.30.2

