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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C98E4C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE178611AB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhETDVm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhETDVm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:42 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAB2C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:20 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id u21so22884825ejo.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3rk++3Mb4YdRNFVxgxBrd/q2IYK7fq8ChT6DACQoplM=;
        b=KPLDVTCj24l7U/RkOMqieZF8TyNgtnQbl4K7KeBjE2zVkhavdaQTdqCtSNDiKnBkm1
         ZBamxl393FEEj4saXTM2CrHzcKueKHP1DWjjVVoenbalh7vY8dlLCpbeojhN5gav/A2/
         lmcM8LEkzoVLbkE9CkGI3D+lxVYWT+SGKmucd9iR2O2EUXs/hFekVtmrMCRzFJwXl0ia
         FBMzqmaHkcX9z65+eU50jRu0MIDMjiQwGZx7p9QC8IjhuV4DgX4EoCe5BpAfcpj9TxAz
         GfYj6hqbIsi1lD9+B64/mhJCPWYJ8/dJ3YU0e0nJyIsWlvooCP0hpTSbfXdGBNZ0N78v
         LH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3rk++3Mb4YdRNFVxgxBrd/q2IYK7fq8ChT6DACQoplM=;
        b=gIVBxCc2d4263Ohz1aQlKpEt3OCCnxj/fZUpxtusSI4Njahwx34j7vFMQ3I7vXD6B/
         M5+aCr8mPhTC7bhl9WNGmr65CkPTF9QpC4yzaf6H3v5y17WQ45nF9RtOvdgDS1nEUD8P
         HbiiUEaVsTboiUKoLt8EnF2S87ouj8Fa60hoLp43ddGSKzoM4w2L7AY6UMb5WuzrKKfW
         Tw2opBXOBm/TMcBZY7bd7w/bj4u9/M/UqO/U+n43lSuPAtK3SNxQ2fmia5Smsl6Xm9aQ
         a4nURArl+pramqQ54i/3l3j8ejgm30kGskEWJEEt62MuRYPVNAfTZAZmTXkEpCcw9BoC
         K8Aw==
X-Gm-Message-State: AOAM530qyqTLGyO4OhKvVZKNdnvCLwz6SwEtWOfI5XOqGmott+NigHh/
        egL4gyZdQ4NYzRBkjct7npM=
X-Google-Smtp-Source: ABdhPJzn1U9rW0SVp+/VdsAfllOK2CZohazgzLwq6czp2p5iOH4TV2MiWkDSPGEe9SxJTTERZDA4aQ==
X-Received: by 2002:a17:906:a245:: with SMTP id bi5mr2551277ejb.316.1621480818957;
        Wed, 19 May 2021 20:20:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 15/29] trace-cmd record: Add new parameter --compression
Date:   Thu, 20 May 2021 06:19:45 +0300
Message-Id: <20210520031959.346165-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
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
index 03d82377..b71c9608 100644
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
@@ -6170,6 +6177,7 @@ static void parse_record_options(int argc,
 			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
 			{"fork", no_argument, NULL, OPT_fork},
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
+			{"compression", required_argument, NULL, OPT_comporession},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6591,6 +6599,12 @@ static void parse_record_options(int argc,
 				die("TSC to nanosecond is not supported");
 			ctx->instance->flags |= BUFFER_FL_TSC2NSEC;
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
index c388eccd..a1d7799a 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -68,6 +68,11 @@ static struct usage_help usage_help[] = {
 		"               If a negative number is specified, timestamps synchronization is disabled"
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
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

