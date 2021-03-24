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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1161CC433EB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4AF261A11
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbhCXNFe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbhCXNEv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:51 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B896C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:50 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id c8so11467213wrq.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yzsSYk49mVd/1rqHdSfH2WsUIqsYGxDwkah8P2Avg9c=;
        b=cq58uxhbu2U8dP/4k8uQXJ5ZWrYRObEWCqIvQqzebMpp5uvXz+9HpjVibxk8qZD2JZ
         UlrFdHsTURdN4OzpD3uHkqULcZVQUEyOQ69Vcc8AagoUq9kNRYX2driMW7m6Yjvk5QvL
         zn2VsWm5QCWRM65EUr0AMhkHxtVt0IaY7d0Rr9KvhYFnV3olaBh3SBjZ8gHTPP1MVxxF
         eJM5uZm+kcjz207FckeS7qUGsd9nCi1HmTJ/K2XWNkSzOsbSe7KhSHD6+EA6cibk94Pk
         ZDbCjtZea1mIx502Q4eqDEmfuUsclXFtAcEaw6TWFcYxuEEoU0777UpskpMXv+TU6TNX
         4HDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yzsSYk49mVd/1rqHdSfH2WsUIqsYGxDwkah8P2Avg9c=;
        b=XJpncsmy5hSpTVpMJKiI9A0FdAqbqTGbFaUvXUOYB1ZjIf+Lfso/kgvLoHbWBW3wkv
         FdR+2WZWf96IZCh7gnE4mDAYDgTgY+4tm9DfhZF2Jo6BZKgeWSQE7iqnV8RP5xmo6wMb
         WxOIQIAE/OePG+Nx0UZfLOl+1lgX50Uycv32+tGHaj51fbmQwHbnllKse+GBzUmSQMgQ
         w1Bki64SqTYTOVU0Cqvdak+1v+kUbCEhyUYFTJek8rawsxmvknKkgZSUJQ2A1i3ievWK
         jsNM+V/RcEFgl4ESmnucuTLkvSQmeYq5vUTXz8r3xs1Whz3jdGWtmvAI2wB8hC7GycFs
         adLA==
X-Gm-Message-State: AOAM532ZqKGTqNtoQC3RtP6UY1Hndr7eK2wAQNioLgBVVG1jW96vGwM5
        M+q7Aj04Bd5B82Td4L/9FJA=
X-Google-Smtp-Source: ABdhPJzBiEp9f7NWElYpiRFfO44YBBEEIti9ynFy6cWgZJXJW64C/boPSNlMQCGpmzTwIgz8bmLLdw==
X-Received: by 2002:adf:e38f:: with SMTP id e15mr3256483wrm.321.1616591089426;
        Wed, 24 Mar 2021 06:04:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 21/23] trace-cmd: Get current clock for host-guest tracing session
Date:   Wed, 24 Mar 2021 15:04:16 +0200
Message-Id: <20210324130418.436206-22-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
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
index f90fdbe4..2fc6723a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6455,11 +6455,12 @@ static void get_tsc_offset(struct common_record_context *ctx)
 
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
@@ -6468,18 +6469,35 @@ static void set_tsync_params(struct common_record_context *ctx)
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
@@ -6501,6 +6519,8 @@ static void set_tsync_params(struct common_record_context *ctx)
 		}
 		instance->tsync_loop_interval = ctx->tsync_loop_interval;
 	}
+out:
+	free(clock);
 }
 
 /*
-- 
2.30.2

