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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F351C43460
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4E056142F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhDVHSF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbhDVHSE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:18:04 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F00DC06138D
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:28 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id w3so67259705ejc.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RLVirN8WZI8eB6p02Dt457R0Zc3l+ePoOZUR/rBIvJY=;
        b=ttqXf+5A0PPuV0kjGOzGgUXj81M360MqDVtM6z4xArMUgIAFA0+1/LVWH2jT19q4oF
         liqtfFF2aan0XVILC1NYR3kzKyJBCjGTBRMQCw02nCMK3rW21dweUYDbozX9Rn2tKXQZ
         qKrhpLG4p6qTp9rCAp6TXCmXrPgeb/DWXxWwMGhDAKO1ZqJkfglxlIv+/UxxypaU+oW2
         /aoGtMcdg1mYLtapV+9gBbg8nBFscUHio3jU74qmTQadfs9HAW0k3xe31YEOiwyhEqT5
         zuS5ggZdINmJCgTdHZ+B0qDBnWxNnSl6MCeFdUWJ1M95qRAHduhoeF3+ZkmBD8YL2/wv
         K4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RLVirN8WZI8eB6p02Dt457R0Zc3l+ePoOZUR/rBIvJY=;
        b=Izsvlj1F+kjuWEBeZ0uq9EXsQuGaWY21AC6k5gRO8orfa3EJuB5En2Q1lwyR9/B3Zf
         vpH/PqJpuNcnH5rKuE6QDFnJ/88KQ2r0XaOICh+FcfHycRCw3lroMJeUazx1TthYnfKM
         XaYnLlYXq+/39ZkWk0il8ebw8DWJLn+oEiekrbl5+DV7ZtFD2A3J0cYqA9sliRJX9Zpz
         6Og0GOol+DO23pQ8j0kQy2cHpglk/YzJLxzV52FLDwTDmLC28aFzprwXKooihlJmC7yw
         2+Gbbjtn2pfpg2aqz4krJ9qoJGQGWemeOyHbQjY4W0CSUwbXe2klw++QcRPsWZBWiSRJ
         a9uA==
X-Gm-Message-State: AOAM530z1pxKK4AVm2JFIvcDtbs5bBv6mp6TxSNpqu+ZyiIeOk2iGojR
        vEaINdqevffwHmI+sOBuuXg/J4FGfvhFRg==
X-Google-Smtp-Source: ABdhPJycvo2PLORuOwVb0z0z/nBP0M4HpYtoKnMIuV+Pw8y+qfKH0IABxEfQ572tHTpT+SFXoFIgGQ==
X-Received: by 2002:a17:906:cb88:: with SMTP id mf8mr1870631ejb.541.1619075847197;
        Thu, 22 Apr 2021 00:17:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k19sm1193958ejk.117.2021.04.22.00.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:17:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 6/6] trace-cmd record: Add new parameter --file-version
Date:   Thu, 22 Apr 2021 10:17:18 +0300
Message-Id: <20210422071718.483383-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422071718.483383-1-tz.stoyanov@gmail.com>
References: <20210422071718.483383-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a new optional parameter to "trace-cmd record", can be used to
select the desired file version of the trace output file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 23 ++++++++++++++++++-----
 tracecmd/trace-usage.c  |  1 +
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 6775338b..f95db0e4 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -199,6 +199,7 @@ struct common_record_context {
 	char *date2ts;
 	char *user;
 	const char *clock;
+	unsigned long file_version;
 	struct tsc_nsec tsc2nsec;
 	int data_flags;
 	int tsync_loop_interval;
@@ -3645,7 +3646,8 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
-		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events, 0);
+		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events,
+							     ctx->file_version);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3663,7 +3665,8 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 	} else {
-		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd, listed_events, 0);
+		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd, listed_events,
+							      ctx->file_version);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3850,7 +3853,8 @@ static void setup_agent(struct buffer_instance *instance,
 {
 	struct tracecmd_output *network_handle;
 
-	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle, listed_events, 0);
+	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle, listed_events,
+						     ctx->file_version);
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
@@ -4242,7 +4246,8 @@ static void record_data(struct common_record_context *ctx)
 		return;
 
 	if (latency) {
-		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count, 0);
+		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
+						      ctx->file_version);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
@@ -4273,7 +4278,8 @@ static void record_data(struct common_record_context *ctx)
 				touch_file(temp_files[i]);
 		}
 
-		handle = tracecmd_create_init_file_glob(ctx->output, listed_events, 0);
+		handle = tracecmd_create_init_file_glob(ctx->output, listed_events,
+							ctx->file_version);
 		if (!handle)
 			die("Error creating output file");
 		tracecmd_set_quiet(handle, quiet);
@@ -5499,6 +5505,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_file_version	= 239,
 	OPT_tsc2nsec		= 240,
 	OPT_fork		= 241,
 	OPT_tsyncinterval	= 242,
@@ -5933,6 +5940,7 @@ static void parse_record_options(int argc,
 			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
 			{"fork", no_argument, NULL, OPT_fork},
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
+			{"file-version", required_argument, NULL, OPT_file_version},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6354,6 +6362,11 @@ static void parse_record_options(int argc,
 				die("TSC to nanosecond is not supported");
 			ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
 			break;
+		case OPT_file_version:
+			ctx->file_version = atoi(optarg);
+			if (!tracecmd_is_version_supported(ctx->file_version))
+				die("File version %d is not supported", ctx->file_version);
+			break;
 		case OPT_quiet:
 		case 'q':
 			quiet = true;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 98247074..e5b54114 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -68,6 +68,7 @@ static struct usage_help usage_help[] = {
 		"               If a negative number is specified, timestamps synchronization is disabled"
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
+		"          --file-version select the desired version of the trace output file\n"
 	},
 	{
 		"set",
-- 
2.30.2

