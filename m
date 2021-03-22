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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0397CC433E5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D32F76198B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCVKAb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhCVKAB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 06:00:01 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4669C061756
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 03:00:00 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id kt15so10700825ejb.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 03:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LerKyBc2du7sy0mCV9M4yVUHN1I0Ty2UesA34CkaMYo=;
        b=k8MEObFKur+6j0xpS1uDDVYqXhMXU8iJyAvmx9/WXVxTkYDtQW9/6mCIFGc34Untk5
         +t33gIrMATDulWpxSkYpJ0MYPgT4XhUV3yyKazv0kTuI93yHpWntWCnlvPomIZgipkqy
         q0B7uTfg4c6Q/LhyXdKPxd1FK17utHPExMKf81x4S3/lT5SFV7J6xG+UyTcfMiYJxn0C
         pt9ntKcAF9yvBkRmtGBzVqLzZzLu+Klr6YVrJGp/YKgW5XON+CRAmiTGhyQGCiXZkbyZ
         zeLpyNpA7+J98pZYWDKZOcjK704JBrYBQ5mpjPbZisRRzSbJesU7734HW3nBIjeLy0j5
         a2hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LerKyBc2du7sy0mCV9M4yVUHN1I0Ty2UesA34CkaMYo=;
        b=pS5X1Ck6UIeEFtMRD2YGrlINrQo5aOt2Y+Y3ROe0+IU23mqC4V7Ll+w2AYQIsY2pkf
         bgLqFXdgDG85khEIhjOpZqogcAivbBs+GgrlBgkWD8rSZHc75AfyGoP+ZtQiu44jawMJ
         0HfxvPKSwuYHRFidqUUvBjH2u43uhR92dNbkju/xxTIwsMRHeGOSaLjpcfruqjSloBxf
         TCHvnzKjvS1k/oTCngQnozNc5L44NZfpEkGTr1b2BZdqyyPd1vgwVMxQ4OJr6NyS7Xcx
         DxiIDoL5sU8w6Fnt8cs7XQAr0GFuJ3MbliByi4wUC4sT5yuvy1XHdW0AOJWpl0DE8YPu
         qFhA==
X-Gm-Message-State: AOAM530GpPs9DtXiki9STC1BvNtcni54fBLqLon4BpbviOw1XlGdy7Yl
        0eDpI8T48fgkrIImfSM24MM=
X-Google-Smtp-Source: ABdhPJyUAfx9uynEsdu61E8YoBelNbdW5PVTBp/SuNW/SnhuBDwLJfsryZICvuOIWwe68bZ0l9awRg==
X-Received: by 2002:a17:906:cb0a:: with SMTP id lk10mr18179156ejb.479.1616407199496;
        Mon, 22 Mar 2021 02:59:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:59:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 13/18] trace-cmd: Set order and priorities when applying timestamp corrections
Date:   Mon, 22 Mar 2021 11:59:40 +0200
Message-Id: <20210322095945.259300-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 7ac81809..5d03cd00 100644
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
@@ -1296,17 +1287,26 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 static unsigned long long timestamp_calc(unsigned long long ts,
 					 struct tracecmd_input *handle)
 {
-	unsigned long long t;
+	unsigned long long t = ts;
 
-	t = timestamp_correct(ts, handle);
 
-	if (handle->ts2secs)
+	/* Guest trace file, sync with host timestamps */
+	if (handle->host.sync_enable)
+		t = timestamp_host_sync(ts, handle);
+
+	if (handle->ts2secs) {
+		/* user specified clock frequency */
 		t *= handle->ts2secs;
-	else if (handle->tsc_calc.mult) {
+	} else if (handle->tsc_calc.mult) {
+		/* auto calculated TSC clock frequency */
 		t -= handle->tsc_calc.offset;
 		t = mul_u64_u32_shr(t, handle->tsc_calc.mult, handle->tsc_calc.shift);
 	}
 
+	/* User specified time offset with --ts-offset or --date options */
+	if (handle->ts_offset)
+		t += handle->ts_offset;
+
 	return t;
 }
 
-- 
2.30.2

