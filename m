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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7380EC433F8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5050461A27
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhCYGlk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbhCYGlT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:19 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12E4C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:18 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d191so526199wmd.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xDsomzgCbP0yJx9Jw3t5GvX1UHU45XtloLwQV6bcNQs=;
        b=oq0mhN9Ciz5Xb0GvBoozEXLk4c7QkzZVOEw83cQdF5UHlD68YR1A/Wxe/CJq73qkb9
         vQUijcDTLTLOZFs8ylej3wGeK/XxMkcXdnUDoS+jVXi6xr7j/ZP1AzXKbIvEBqqrrKer
         uwzjHsW8u3yxEcQUtq0V9uo1uRfxpxwFf2BOHlerpMKlAyONfPAhyG5QKl1Hma7Os4yE
         P29xKQx6lnvFRO9evSfizABH5CZ+uiYCgFRtpYdLPU1lZZcfv6Zws9E2FMFZLkAeDYgM
         ezoemEs55wPnxUuKy5R2xYLVjRnEvMEffegefHmyycGHizy0Fuj4lI2f+QpEJTsPK+ae
         Bk6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xDsomzgCbP0yJx9Jw3t5GvX1UHU45XtloLwQV6bcNQs=;
        b=BRFiYO8wCEwJc1+oB5BUwYjgm+u1dAPcAKUBPj/y8IkL6ZSrm79nKQeTNf7nveTNo5
         x3/gLqo2sCUg/Ypo/faMOxX6lf7rL7cGjH+YA9xfUs7MSA7lb0SlgJSWOwkgPQ0KHn1/
         lptjKWVxalqaqrZmZmNej3tBAuJ2xGMV9V/b8lDhw6i3a3Wd4BsipsUqvWDCF5er9FXi
         DYjsmb11oAjHAdDulq1+7gRk5PrVXvp+PtIjAKlNajsUV1U9bjqEioLycopCG9h/BJfd
         ZtEXXPeDsWR10f54qj6y9snxlIgUt+oVi4mE7mQX6nUiHKnbWQT1MqhkI9jyh7nBF83c
         NOig==
X-Gm-Message-State: AOAM532hZoIbIqggEXA20WeyMuJN1c+mR2vuse9eeW3EqFxGAuqJ2zl5
        0ZUabTp7pc7qFdkFgVuHt7367ap9OfcBUw==
X-Google-Smtp-Source: ABdhPJwMKjaw3Mpqd1RYYsOBiS3+RpCJ1dykk1H1hJVRwp/FR99pqLGcllt9lpsO+fRvde9IhBBvLQ==
X-Received: by 2002:a7b:cb89:: with SMTP id m9mr6253233wmi.27.1616654477436;
        Wed, 24 Mar 2021 23:41:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 21/23] trace-cmd: Get current clock for host-guest tracing session
Date:   Thu, 25 Mar 2021 08:40:53 +0200
Message-Id: <20210325064055.539554-22-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
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
should be rertieved from the "trace_clock" file of the first host trace
instance, used in the tracing session.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 49 ++++++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d794f1af..4f412e8d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4128,6 +4128,23 @@ static void print_stat(struct buffer_instance *instance)
 		trace_seq_do_printf(&instance->s_print[cpu]);
 }
 
+static char *get_trace_clock(bool selected)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance) {
+		if (is_guest(instance))
+			continue;
+		break;
+	}
+
+	if (selected)
+		return tracefs_get_clock(instance ? instance->tracefs : NULL);
+	else
+		return tracefs_instance_file_read(instance ? instance->tracefs : NULL,
+						  "trace_clock", NULL);
+}
+
 enum {
 	DATA_FL_NONE		= 0,
 	DATA_FL_DATE		= 1,
@@ -6460,11 +6477,12 @@ static void get_tsc_offset(struct common_record_context *ctx)
 
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
@@ -6473,18 +6491,27 @@ static void set_tsync_params(struct common_record_context *ctx)
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
+		} else { /* Use the current clock of the first host instance */
+			clock = get_trace_clock(true);
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
@@ -6506,6 +6533,8 @@ static void set_tsync_params(struct common_record_context *ctx)
 		}
 		instance->tsync_loop_interval = ctx->tsync_loop_interval;
 	}
+out:
+	free(clock);
 }
 
 /*
-- 
2.30.2

