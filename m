Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4244C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88F9761158
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhD1M3a (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 08:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbhD1M3a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 08:29:30 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12245C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:28:44 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u17so94454547ejk.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=paqJ12TSx/7K5HmjtNb5+XQ9nscLWH8EPsbfy8ABDHA=;
        b=cYqFKXiItSXMW7EhfF6Lu1/TEWwmCeRGqxbLVZFRk6T0W8ZswArlxWB5AFVQwI3UP2
         7rBUPkZehRoYDpXqUBVWq2y4rp4xxVQKQWLWRrYOYN2S7AODjF0VJXbonB2lWo0ASQJb
         90za965bQNJkZhUWrQX84QGN/xrN3Ila0APxVCT4kEntmMdKuNEpBqjJlv9JoqHPeL2c
         fFbaHJCgvlEWeK/6nJo0DcuLrqZvRvCq44eZseXVqdWbB0c9J2mNiDWRlu97JWbVLQ/1
         bsEsvIGbyC92AqVQ5jIszmN8ftTLqheo8l3qLFnhfA1RkXUYMbob+AQMmPbU8F8K9U+p
         MjHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=paqJ12TSx/7K5HmjtNb5+XQ9nscLWH8EPsbfy8ABDHA=;
        b=udTTsQn5lK26kXKPVXUAyFKgT/JzvtEXnarY4rjodWdmxDJSWpUsWDqbiOttpPxovl
         bNTd23yjMvnmJ/frdCLsrOAkY698S5KdRJdh2aIWoJp6aFJaRXrTg1asw9M17MQ5Fjs5
         QCRF1usu5RVAbcZ/T/Q6KWK1brOBK/7vLrEU1nGko/FuHYRhwXJPCTRSNypJbuTHcIJf
         n0pb8uBlRn2mUjgUYnidXtJcRhnXYVea8E9FOKiYwRscSYWAs5ZbtgIfZaZicMtEIqUm
         rwWzfTKZsGVlyzIbdRJ5YcSI7NZR9zFSN7QmIbrzjkWAbJAb9oL2yzDls1/cMI4CWcfv
         hDow==
X-Gm-Message-State: AOAM531uMRyH2r+5v2H4KyJypBDn8ZMzXTtTFbYYjzW3AiEatQMyEPGb
        H0/q70wsTS6laz+BEuwEYu0=
X-Google-Smtp-Source: ABdhPJwhuCTpAHzESFr/mwgm8ZNRauMYpECywiN5uEbc33Y7lqbWViSEenInwiCmhN324Vy2MsaILg==
X-Received: by 2002:a17:906:828b:: with SMTP id h11mr20630391ejx.305.1619612922837;
        Wed, 28 Apr 2021 05:28:42 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n10sm1846546ejg.124.2021.04.28.05.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 05:28:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/5] trace-cmd: Remove ts offset from tsc2nsec conversion
Date:   Wed, 28 Apr 2021 15:28:35 +0300
Message-Id: <20210428122839.805296-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428122839.805296-1-tz.stoyanov@gmail.com>
References: <20210428122839.805296-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Do not get, store and use offset when converting TSC to nanoseconds.
The logic for automatically detecting the TSC offset is not stable enough
and could introduce errors, which leads to problems when reading trace
files in some use cases. The offset is not mandatory for tsc2nsec
conversion.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c |  1 -
 tracecmd/trace-record.c     | 62 -------------------------------------
 2 files changed, 63 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a00fa982..e8a257db 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1319,7 +1319,6 @@ static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
 		ts *= handle->ts2secs;
 	} else if (handle->tsc_calc.mult) {
 		/* auto calculated TSC clock frequency */
-		ts -= handle->tsc_calc.offset;
 		ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
 	}
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index fd03a605..d732b394 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6483,65 +6483,6 @@ static bool has_local_instances(void)
 	return false;
 }
 
-/*
- * Get the current clock value
- */
-#define CLOCK_INST_NAME	"_clock_instance_"
-static unsigned long long get_clock_now(const char *clock)
-{
-	struct tracefs_instance *ts_instance = NULL;
-	unsigned long long ts = 0;
-	struct tep_handle *tep;
-	int tfd;
-	int ret;
-
-	/* Set up a tep to read the raw format */
-	tep = get_ftrace_tep();
-	if (!tep)
-		return 0;
-	ts_instance = tracefs_instance_create(CLOCK_INST_NAME);
-	if (!ts_instance)
-		goto out;
-	if (clock) {
-		ret = tracefs_instance_file_write(ts_instance, "trace_clock", clock);
-		if (ret < strlen(clock))
-			goto out;
-	}
-	tfd = tracefs_instance_file_open(ts_instance, "trace_marker", O_WRONLY);
-	if (tfd < 0)
-		goto out;
-	tracefs_trace_on(ts_instance);
-	ret = write(tfd, STAMP, 5);
-	tracefs_trace_off(ts_instance);
-	ts = find_time_stamp(tep, ts_instance);
-	close(tfd);
-
-out:
-	if (ts_instance) {
-		if (tracefs_instance_is_new(ts_instance))
-			tracefs_instance_destroy(ts_instance);
-		tracefs_instance_free(ts_instance);
-	}
-	tep_free(tep);
-
-	return ts;
-}
-
-static void get_tsc_offset(struct common_record_context *ctx)
-{
-	struct buffer_instance *instance;
-
-	for_all_instances(instance) {
-		if (is_guest(instance) || !instance->clock)
-			continue;
-
-		ctx->tsc2nsec.offset = get_clock_now(instance->clock);
-		return;
-	}
-
-	ctx->tsc2nsec.offset = get_clock_now(NULL);
-}
-
 static void set_tsync_params(struct common_record_context *ctx)
 {
 	struct buffer_instance *instance;
@@ -6566,7 +6507,6 @@ static void set_tsync_params(struct common_record_context *ctx)
 				die("Cannot not allocate clock");
 			ctx->tsc2nsec.mult = mult;
 			ctx->tsc2nsec.shift = shift;
-			ctx->tsc2nsec.offset = get_clock_now(TSC_CLOCK);
 			force_tsc = true;
 		} else { /* Use the current clock of the first host instance */
 			clock = get_trace_clock(true);
@@ -6661,8 +6601,6 @@ static void record_trace(int argc, char **argv,
 	for_all_instances(instance)
 		set_clock(instance);
 
-	if (ctx->tsc2nsec.mult)
-		get_tsc_offset(ctx);
 
 	/* Record records the date first */
 	if (ctx->date &&
-- 
2.30.2

