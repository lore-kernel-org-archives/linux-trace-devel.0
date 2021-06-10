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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 276C6C48BDF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1312761407
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhFJLhs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:48 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:41821 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbhFJLhj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:39 -0400
Received: by mail-wr1-f46.google.com with SMTP id o3so1903825wri.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R1+fTqnmfQqIOk9aOZ4VXKr/VhZIoW38trAOjO96PI4=;
        b=bPAYDqBaq5ruwOyNVxUjfxA82hlLpgvtIv3blJhLXJWXeQ4dK81XikhW2vlj+GLSaI
         wg1M8/a+2pp0JnqIdAMNr4RZfl6n6IjgvT+LZ1CUCJ7K3Ur3ymb19vKYuw7G9CnrfZR3
         YdZ3fpWbqoII69ubQqVvmr215FYRsgOpAmhomFA95D143X5khxHob/aHFJqrL6QsGoIr
         F0ZyW5bOLm7yS51jYSWBuYjuUbTuTSYqOisvHdQCgNjAPzy07c1sxfV9ggumn/C6UdSx
         XOnhFKgHlB1pwtLVVzVmlKtlo8qg5g0qcTzKIBjI5adSGdvxrohw1wQ0qaHPc0vlTj15
         hpKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R1+fTqnmfQqIOk9aOZ4VXKr/VhZIoW38trAOjO96PI4=;
        b=m+BGAsLnzFnU4/ngo+KXEIbeGcabPeS25FC2ij8ttMru/97osyc2I7e14fb1dRhBzO
         9ZBi8S84lfUMtCl5nqG2sQ0yebB+xyg/jsco3CD2lm9n2feQ3t5r+z8YP3/jfLYv6khl
         nb3DpWwOEJkr1jZlFnbo89ORfwS1pj0DAZm0V2b/goLkKfijSY4fhBFWS3haeVBbRJF2
         q0eGq5/ucuS+qQmTwT1hyG04RrweeMJReZLTAPsKuWrnR9DgqwcExoJcY/CJNCVCmPLW
         lVyfqOA2VDXOBI0wywKLGfcBRDyUydTlGLqtbPlPjwlho16Ahu2BjDYxrdv5N6OfGy9X
         V7uQ==
X-Gm-Message-State: AOAM533YrPhMlVMLo1SbTcm5fCZ56X0yx1KrU9Vb4qE8jEFA/kc7DcSO
        7v6OxwDk+gxgbMlRTL4mnNmBwYzhkIbhPA==
X-Google-Smtp-Source: ABdhPJxh4NlN7O9k26GfCJY31QchOYFCk4ecIdP07gQR375gE+ZqHZCL/C5J8YrhZREK9NIsMz1YEg==
X-Received: by 2002:a5d:474f:: with SMTP id o15mr5013546wrs.298.1623324882704;
        Thu, 10 Jun 2021 04:34:42 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 15/40] trace-cmd record: Add new parameter --compression
Date:   Thu, 10 Jun 2021 14:34:01 +0300
Message-Id: <20210610113426.257931-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a new parameter "trace-cmd record --compression", can be used to
select the desired compression algorithm for the trace output file.
One of these strings can be passed:
 "any" - auto select the best available compression algorithm
 "none" - do not compress the trace file
 name - the name of the desired compression algorithms, available
        algorithms can be listed with "trace-cmd list -c"

If a compression is used, trace file version 7 is selected, otherwise
trace file version 6 is used.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 24 +++++++++++++++++++-----
 tracecmd/trace-usage.c  |  5 +++++
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 29f84b7c..8f8ea08b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -199,6 +199,7 @@ struct common_record_context {
 	char *date2ts;
 	char *user;
 	const char *clock;
+	const char *compression;
 	struct tsc_nsec tsc2nsec;
 	int data_flags;
 	int tsync_loop_interval;
@@ -3700,7 +3701,8 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
-		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events, NULL);
+		network_handle = tracecmd_create_init_fd_msg(msg_handle,
+							     listed_events, ctx->compression);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3718,7 +3720,8 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 	} else {
-		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd, listed_events, NULL);
+		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
+							      listed_events, ctx->compression);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -4066,7 +4069,8 @@ static void setup_agent(struct buffer_instance *instance,
 {
 	struct tracecmd_output *network_handle;
 
-	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle, listed_events, NULL);
+	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
+						     listed_events, ctx->compression);
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
@@ -4458,7 +4462,8 @@ static void record_data(struct common_record_context *ctx)
 		return;
 
 	if (latency) {
-		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count, NULL);
+		handle = tracecmd_create_file_latency(ctx->output,
+						      local_cpu_count, ctx->compression);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
@@ -4489,7 +4494,8 @@ static void record_data(struct common_record_context *ctx)
 				touch_file(temp_files[i]);
 		}
 
-		handle = tracecmd_create_init_file_glob(ctx->output, listed_events, NULL);
+		handle = tracecmd_create_init_file_glob(ctx->output,
+							listed_events, ctx->compression);
 		if (!handle)
 			die("Error creating output file");
 		tracecmd_set_quiet(handle, quiet);
@@ -5736,6 +5742,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_comporession	= 239,
 	OPT_tsc2nsec		= 240,
 	OPT_fork		= 241,
 	OPT_tsyncinterval	= 242,
@@ -6172,6 +6179,7 @@ static void parse_record_options(int argc,
 			{"fork", no_argument, NULL, OPT_fork},
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{"poll", no_argument, NULL, OPT_poll},
+			{"compression", required_argument, NULL, OPT_comporession},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6597,6 +6605,12 @@ static void parse_record_options(int argc,
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--poll");
 			recorder_flags |= TRACECMD_RECORD_POLL;
 			break;
+		case OPT_comporession:
+			if (strcmp(optarg, "any") && strcmp(optarg, "none") &&
+			    !tracecmd_compress_is_supported(optarg, NULL))
+				die("Compression algorithm  %s is not supported", optarg);
+			ctx->compression = strdup(optarg);
+			break;
 		case OPT_quiet:
 		case 'q':
 			quiet = true;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index cd8ca391..c70f9919 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -69,6 +69,11 @@ static struct usage_help usage_help[] = {
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
 		"          --poll don't block while reading from the trace buffer\n"
+		"          --compression compress the trace output file, one of these strings can be passed:\n"
+		"                            any  - auto select the best available compression algorithm\n"
+		"                            none - do not compress the trace file\n"
+		"                            name - the name of the desired compression algorithms\n"
+		"                        available algorithms can be listed with trace-cmd list -c\n"
 	},
 	{
 		"set",
-- 
2.31.1

