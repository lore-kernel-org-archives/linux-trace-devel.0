Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C6DC433E8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87B3561A23
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhCYGli (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhCYGlI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:08 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7622DC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:08 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id o16so1158535wrn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=maircGKBgsmJQJ6smWACwE9U5aIc3Gre0Jp/o7zMKlQ=;
        b=Kp2jnLu+klOulH2H1TRsVmH/xeQjKpt0OZdLVhyiVUrYTem16uqDnN9gyJb9d24Qoh
         7pR8K6PnvqRCU/g1FIKUEOM78XP1m1BSCE7NGy+Gng8I/rQTMRluvhkDleLgy2D4ZU6t
         o69At4sfm8uetOa5bk4VihbuvEbapqrx6ddr4KNrNRyRjJCqRpdd5dJT4w20yv3MATFO
         tgnl4reYNA+JoiIsrRcov8ZQ4/dN+1mhe01YyH2erSyUB8TNjUr/LI+kdJS5tVGyH1Ib
         TE5Qn0lPbbm0hKjknQH8asA/T+h3qEz7cs87z6cGLfJg+A1p4dZU3KDrsT+sfHQXGTNl
         TVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=maircGKBgsmJQJ6smWACwE9U5aIc3Gre0Jp/o7zMKlQ=;
        b=bDstvaeguxXF4gCb3Hc/IBmWfrJSFPsGeHj6tZCYSnd2pbXvdq8KyJ+154Jzso+yzH
         zqa7heUQYKbff2mcvq/zhmXV0XqNokkr5QpOuuzyJ4TzHpNOhSExJCWJZi8+ZEttaWNz
         gluV6qqtsCCLaYIZriRs9HpiBsCfVSvtSeqHVmPpy40Z1OdFjp/4lkngbiJHOGDF8cFG
         tfmiDh+mKHsYig418hjZY5VHwUIxee9lSrLdoFsyWNJu1IaWf+2/pWTIZD9lja4oF9S0
         KTC8cA57JzLhZnvjKRe3+n11h8wtL3dp84HWwrh0n79Z/be9eh2ZLGJq7/pwNXXuuEJJ
         v4LA==
X-Gm-Message-State: AOAM532/hdZQOUVFImbBVQXE3Jdmt5CY7Gp4uvQrt0rcFPhIN/DHmrNV
        O4ytMcWYuqt8yXu35lyyJ8fWh/QI/86HQg==
X-Google-Smtp-Source: ABdhPJy1tp7+P02txI3d17DqGCcTOuOp7UE3s2aG0ForXqRRh2EfO7CUitk6U7D2/bkeOV8gX/J/rw==
X-Received: by 2002:a5d:4884:: with SMTP id g4mr7047730wrq.191.1616654467158;
        Wed, 24 Mar 2021 23:41:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 10/23] trace-cmd: Save tsc2nsec clock in trace.dat file
Date:   Thu, 25 Mar 2021 08:40:42 +0200
Message-Id: <20210325064055.539554-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When tsc2nsec clock is used, save it as selected clock in the trace.dat
file. When reading the file, in case of tsc2nsec clock show timestamps
in usec / nsec.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 ++
 lib/trace-cmd/trace-input.c                       | 2 +-
 tracecmd/trace-record.c                           | 9 +++++----
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ce3d8dc0..c33d067a 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -22,6 +22,8 @@
 #define TRACECMD_ERROR(ret)	((void *)((unsigned long)(ret) | TRACECMD_ERR_MSK))
 #define TRACECMD_PTR2ERR(ptr)	((unisgned long)(ptr) & ~TRACECMD_ERR_MSK)
 
+#define TSCNSEC_CLOCK	"tsc2nsec"
+
 void tracecmd_parse_cmdlines(struct tep_handle *pevent, char *file, int size);
 void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent, char *file, unsigned int size);
 void tracecmd_parse_ftrace_printk(struct tep_handle *pevent, char *file, unsigned int size);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ebc28f7b..67915f25 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2906,7 +2906,7 @@ static void extract_trace_clock(struct tracecmd_input *handle, char *line)
 	/* Clear usecs if not one of the specified clocks */
 	if (strcmp(clock, "local") && strcmp(clock, "global") &&
 	    strcmp(clock, "uptime") && strcmp(clock, "perf") &&
-	    strncmp(clock, "mono", 4))
+	    strncmp(clock, "mono", 4) && strcmp(clock, TSCNSEC_CLOCK))
 		handle->flags &= ~TRACECMD_FL_IN_USECS;
 }
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 9f8c4943..b7f6f438 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -58,7 +58,6 @@
 #define STAMP		"stamp"
 #define FUNC_STACK_TRACE "func_stack_trace"
 #define TSC_CLOCK	"x86-tsc"
-#define TSCNSEC_CLOCK	"tsc2nsec"
 
 enum trace_type {
 	TRACE_TYPE_RECORD	= 1,
@@ -4168,7 +4167,8 @@ static void write_guest_file(struct buffer_instance *instance)
 	handle = tracecmd_get_output_handle_fd(fd);
 	if (!handle)
 		die("error writing to %s", file);
-
+	if (instance->flags & BUFFER_FL_TSC2NSEC)
+		tracecmd_set_out_clock(handle, TSCNSEC_CLOCK);
 	temp_files = malloc(sizeof(*temp_files) * cpu_count);
 	if (!temp_files)
 		die("failed to allocate temp_files for %d cpus",
@@ -4290,9 +4290,10 @@ static void record_data(struct common_record_context *ctx)
 				add_guest_info(handle, instance);
 		}
 
-		if (ctx->tsc2nsec.mult)
+		if (ctx->tsc2nsec.mult) {
 			add_tsc2nsec(handle, &ctx->tsc2nsec);
-
+			tracecmd_set_out_clock(handle, TSCNSEC_CLOCK);
+		}
 		if (tracecmd_write_cmdlines(handle))
 			die("Writing cmdlines");
 
-- 
2.30.2

