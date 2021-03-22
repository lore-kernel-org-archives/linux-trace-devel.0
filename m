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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8D2C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C5C86197F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhCVKAg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhCVKAF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 06:00:05 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498C4C061762
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 03:00:05 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a7so20182021ejs.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 03:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xp2ym0L+FMQ86HK5AO6GT6GFNdJ0XuaFnuA6AnGsXcg=;
        b=YtpMf22XGkcREi8WGifVsx4rvdLdEJZfOl1Bpuy6fGq2kbPIgE2vzSLFQUlgrZ8WUo
         I7SPXEsjvxucytT0gQi1QIz7PVJCArquVMWAgcu8AWpHxsZcrqvVXZ43ZrDnGXsKkazD
         8yZ68Qe4LlXtY6KY6E/WI9mVzWWJpFDcGRDfar3oG6kF/W1x6Dv2Lp6AAkUJPXEyWAOK
         xmsCmFKm1ec4sXHxHfDm76R3OqPvCVgpNsjwgcJLKv28AmtLuQnYwN4omqtblhlGhOGg
         t5jtZD4LlTkNdUwfNo9z85AMyA8HJOUDv+QwM4GvOGkL3/8mfy0QvImtJ11aA9zVVwVi
         KXHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xp2ym0L+FMQ86HK5AO6GT6GFNdJ0XuaFnuA6AnGsXcg=;
        b=SL5oHzmWjXbqTokF63SQMUEjx9yblQJJMSYWmosd2/wuNjbYeNjZ6OgwliPpwYeII6
         HebGDJvY5/BA+5l2bbjoh6mH97uFtRjDLNtJQyGdXex+THIYCeJWTdtTSqv4Y8AI/JWy
         PMk0/1pNInHWWcZUTvAHC6+ckjo64k2b8F9KacT4T6hZxoQFZRc9XOC9YkiUKYkl1La+
         MJklClhujP54NGTVapO8vC5gsFjYZ7B/KYy70gKZnPwNn/uuvc1K9Z3qjATIw3Vo5v1v
         jzHie+AiGL1EhpRUAvEdR3o7Xx+BgtOj82h6X7fmWAj+Gd7o7568Fv1iJ0pl6waWSidN
         Y+ng==
X-Gm-Message-State: AOAM531K/cnejVKJ1R0TwA6k9lYUxrAIr4+RLurlKNhvhCIT1LxyHFc/
        kHO8q2IV/HfIqlLeAElLHUueOefZLt8K1A==
X-Google-Smtp-Source: ABdhPJzoSn1zfGyrCIUku06hKdDY1Jr4DSrG5SUDp0v2A4OG/QY8ry93bjGBZSkmSjJBxLalBnoaQQ==
X-Received: by 2002:a17:907:1693:: with SMTP id hc19mr18150834ejc.28.1616407204095;
        Mon, 22 Mar 2021 03:00:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.03.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 03:00:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 18/18] trace-cmd: Get current clock for host-guest tracing session
Date:   Mon, 22 Mar 2021 11:59:45 +0200
Message-Id: <20210322095945.259300-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In host-guest tracing session, all peers should use the same tracing
clock. If there is no user configured trace clock, the current logic
assumes "local" clock for the session. This could be wrong, as other
clock than "local" could be already configured on the host, before
running trace-cmd. The default clock for host-guest tracing session
should be rertieved from the host's "trace_clock" file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 552be914..d0591e26 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6446,11 +6446,12 @@ static void get_tsc_offset(struct common_record_context *ctx)
 
 static void set_tsync_params(struct common_record_context *ctx)
 {
-	const char *clock = ctx->clock;
 	struct buffer_instance *instance;
 	int shift, mult;
 	bool force_tsc = false;
+	char *clock = NULL;
 
+	if (!ctx->clock) {
 	/*
 	 * If no clock is configured &&
 	 * KVM time sync protocol is available &&
@@ -6459,18 +6460,35 @@ static void set_tsync_params(struct common_record_context *ctx)
 	 * force using the x86-tsc clock for this host-guest tracing session
 	 * and store TSC to nsec multiplier and shift.
 	 */
-	if (!clock && tsync_proto_is_supported("kvm") &&
-	    clock_is_supported(NULL, TSC_CLOCK) &&
-	    !get_tsc_nsec(&shift, &mult) && mult) {
-		clock = TSC_CLOCK;
-		ctx->tsc2nsec.mult = mult;
-		ctx->tsc2nsec.shift = shift;
-		ctx->tsc2nsec.offset = get_clock_now(TSC_CLOCK);
-		force_tsc = true;
+		if (tsync_proto_is_supported("kvm") &&
+		    clock_is_supported(NULL, TSC_CLOCK) &&
+		    !get_tsc_nsec(&shift, &mult) && mult) {
+			clock = strdup(TSC_CLOCK);
+			if (!clock)
+				die("Cannot not allocate clock");
+			ctx->tsc2nsec.mult = mult;
+			ctx->tsc2nsec.shift = shift;
+			ctx->tsc2nsec.offset = get_clock_now(TSC_CLOCK);
+			force_tsc = true;
+		} else {
+		/*
+		 * Else, use the current clock of the first host instance
+		 */
+			for_all_instances(instance) {
+				if (is_guest(instance))
+					continue;
+				clock = tracefs_get_clock(instance->tracefs);
+				break;
+			}
+		}
+	} else {
+		clock = strdup(ctx->clock);
+		if (!clock)
+			die("Cannot not allocate clock");
 	}
 
 	if (!clock && !ctx->tsync_loop_interval)
-		return;
+		goto out;
 	for_all_instances(instance) {
 		if (clock && !(instance->flags & BUFFER_FL_HAS_CLOCK)) {
 			/* use the same clock in all tracing peers */
@@ -6492,6 +6510,8 @@ static void set_tsync_params(struct common_record_context *ctx)
 		}
 		instance->tsync_loop_interval = ctx->tsync_loop_interval;
 	}
+out:
+	free(clock);
 }
 
 /*
-- 
2.30.2

