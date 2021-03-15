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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AF2C43332
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6A0064E12
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhCOGTA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhCOGSr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:47 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B12C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:47 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h13so15894751eds.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KkCYKVW+cBMkK0d6ssPH66zOJhQ5u7wM4k6hR5nJgpE=;
        b=eXL4klNAWEybYutEMIAhLbhabWzJ6aob9CNAhtKyCSHoc/ANrcBW27qXDgigJ0wBHy
         aPRaOGpyqAMYQyhqtxDlzpr5WwW/1TqsSig0Tuo27Q5CGbkebxMDD1tguMAmrP2Nw1Yx
         qsfwMjS75ZDFTof/mCdIj/PeABjlMlnn5/z6wig3r1UeIgom/iNCFLWh77BaL+PTcrjS
         ElHcDfJw9e1v/e3WmhO6tE1jP6+hxpDzxUaI3YDYLTM5BBlFQrAUkHLv4iPpdjZr7vjx
         VKrR0jq4uW4ifOJROZMQ6NsgtOcM7U2NPDV0XtLp44W51BIpNxABp1Z7NbOwrk/k96PR
         9FJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KkCYKVW+cBMkK0d6ssPH66zOJhQ5u7wM4k6hR5nJgpE=;
        b=qkwzoL6UfT1HA8HAdvm+bJU/wxdxp3Vq2UB28V5nzJV+gyGcxfdLGi9cBVnVnJpF+T
         +EKDx7gIE0TsC/cjigwP4eFdp6AaC5t6l3kr5oeBTB2rjGp4KYaUPnnxBHLUdzlNC59x
         2J+kE8cUYw1Q9TBRYRqKvYcAe/Hc9wVD++E4tqQ8rdpdzMSitYw0J1U8H4BGrbA/1xlH
         tKoSMQz6ZQKUk1o09Al504LUcDXRUaGHhwTmPwnp/NzIeC8j2U9CVkYZfP+UG+9xyeh4
         mrQsAy7I/DWILxdDHJt+dTT+0CISPe/xZzslPFcrxkdM440ADKZkcLuCVYiW4Lstk/2V
         9EiA==
X-Gm-Message-State: AOAM532KLIMAf1j6E2v9fEHRY1K3iQvR53hvAcU8Jl0Q2EmI/bjpCNY7
        E0bmOYeAOFJKD20s7Ia/tzQ=
X-Google-Smtp-Source: ABdhPJzdB3Dya3C3ZSPKRMvYeZMZKEeKi/5/TZK5ZuDwGKAGwoyvYBzitwLazXfFtmDiw2hm7Xon1g==
X-Received: by 2002:a05:6402:181a:: with SMTP id g26mr28055341edy.225.1615789125865;
        Sun, 14 Mar 2021 23:18:45 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id t6sm7468478edq.48.2021.03.14.23.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:45 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 10/12] trace-cmd: Set order and priorities when applying timestamp corrections
Date:   Mon, 15 Mar 2021 08:18:30 +0200
Message-Id: <20210315061832.168495-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061832.168495-1-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
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
index dc9ac1d3..1cffa0f5 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1224,21 +1224,12 @@ timestamp_correction_calc(unsigned long long ts, unsigned int flags,
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
@@ -1295,17 +1286,26 @@ static unsigned long long mul_u64_u32_shr(unsigned long long a,
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
 		t = mul_u64_u32_shr(t, handle->tsc_calc.mult, handle->tsc_calc.shift);
 		t += handle->tsc_calc.offset;
 	}
 
+	/* User specified time offset with --ts-offset or --date options */
+	if (handle->ts_offset)
+		t += handle->ts_offset;
+
 	return t;
 }
 
-- 
2.29.2

