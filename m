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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72EEC433EC
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A2961A0D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbhCXNFa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbhCXNEo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:44 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31213C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:44 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so1148909wmi.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MpH8LyKwbje/aQPtMTItjN3p/dZCO7Xx1rGgpNhlQyU=;
        b=uL9vb5RJz5JNsGcv5SpbERaLpWH8BZKW8/x0HC5RKevlWPAdlV3VX6vkxnosB+oML0
         LFgsql7xImO+MKIgTmdgVotwzQu4SztnvPRbJerh42XvKeZvOxl5AAjXz5CF9w74l9ep
         hYTZRJnWxUXwQ5P3lpsTaLWwP5c0BmIvDUl3p4F2QJn7ch/3xjuGf4JSkPMszf36fCD0
         zel7uiWpjkDvrQrNW3Yxd/l6cU8qfQs1GLyXtMhN4mQK7UaXbtYwifRl+xsXwikgYw99
         gK/iogkDYPO+qjjMIdW6Pp33oVFC7toInqmkWAnroRL2/3zR1f3D016cfc11QEUWQDh/
         +muw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MpH8LyKwbje/aQPtMTItjN3p/dZCO7Xx1rGgpNhlQyU=;
        b=demZL9kYSJQcy+PH/6Cq/P8bGhmdoL0r+OMuklbwA0AMSeERBrIamu8uIA6gkRAe2I
         bARJBa6WjQiHOmhN/AH4y40hQdpRtYSmIxIQLtDmMzIhP9iGoAkJN7g3PCcT0Fb+BFCJ
         KN8ahvVXh9SCuhvRyE1aFmiGnZ/+LbI3gbqXWxGVk/+uwvnHRdAUFj4yKdQHthKRlHyz
         2bstInMidixeEPWR5t75SN6zE8BcaOOuOZ53ktnHTSoRGlKk1YzBxol8rgtIUiUoXqhg
         m9dHG8FW2ukHsiwn8/XmLMSGLo7S7HoscJxEGqp0NWOETCL2cRbsIpOoOzWg4g8NYfqS
         RULA==
X-Gm-Message-State: AOAM531b5vFpCj+NKj7PdNqYtMWIe+fQv1z1XS8qmvzU7tO2whmkj4fn
        r+pyHek1J4inzuLsaLNQQEMNHbmObmZavQ==
X-Google-Smtp-Source: ABdhPJx8OeWNF4nWi1ps1M2J6o/Hcdt8IOvmYi+XX1SS/oxMJtBOccMPfEZEYQ6h29DoyJvpQRoGiQ==
X-Received: by 2002:a1c:bd55:: with SMTP id n82mr2823370wmf.3.1616591082439;
        Wed, 24 Mar 2021 06:04:42 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 15/23] trace-cmd: Set order and priorities when applying timestamp corrections
Date:   Wed, 24 Mar 2021 15:04:10 +0200
Message-Id: <20210324130418.436206-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
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

