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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C50C43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 090C5613F2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbhDVHkB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235131AbhDVHj5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:39:57 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02545C061343
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:12 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id r20so17535272ejo.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kz7dz2usV0psVj3+MbC4zPkq0WY0aNTPsSqeVo2Kbm8=;
        b=t+xg/4WXlBEE0bkK8iZrU/dvVkWm0D7BfaqfIwGrnU87yp68AXxE6UJdx1zHsRdtDn
         2Z20hVt6UcZOymofplZ53JM37wgkfyjwR6s8aRlfiKUcTCfbR0Wzu8R6Bntpslx3SV1d
         1rEjm4AK6Fvh6qTyf9yPlJAcB63x+3dyIS7TiujaOvTA85bnyWkUpkU1wz2dluW7R9A2
         PeT4ikpV09mfp2mmGLCNmMqCJpLtU0Hd+91NteMwW2nS9X+jaRrgrBc55BEqrH3p10r0
         g9DsHBPrnC/m684YKuwJzduHkjagJEfQxWlEv334YgEtXxpT3MQrk8X6fhOpCoVs5+vJ
         +BuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kz7dz2usV0psVj3+MbC4zPkq0WY0aNTPsSqeVo2Kbm8=;
        b=sxyPKQ8HPaeSqYdi5vkIJCEuS1xGQF/awnuzU41VhljP6dMxk/v5l+MR73xGsSSLFi
         pSAiszfZYlVvLAeMQ2Y0OUqIishQvJimrI0L+l1vbfQPvOpzIFOTEOhLR4Z0xIDEqaO+
         FXxfbgs2+b3nrdHv+KEVhqurVTLl7fjVCAJO4E3l7slZ8sTkUJOjTGMxqUR21RoDwMSr
         J7otm+Xtc8eadg3/HvVxo7J5PkDSyP9Dq4vbMaxdtvnq8wmox81xY21uVal+E6tHYqLd
         n6ODOHItdvvZH7djxKB+qmW1BQuNcc1JADgwB6bV+f4zSIiJr26bu5gteNm37a3iQa0L
         53+w==
X-Gm-Message-State: AOAM532qW/KkQwQs3sh7S4veM3QtedmDtrJYNGu8ldx0dWesfQWmmsQe
        pVGMN5RxX2p3Cwjc2H6Nr+uQm+UzXrClWw==
X-Google-Smtp-Source: ABdhPJw+SuFqvnKGRVGAFoasTYrcx0sfKz+8MPV9uaFq9XYzr9AVx+jfHWIytLYc1eBLw0OkPq7H3A==
X-Received: by 2002:a17:906:7206:: with SMTP id m6mr1955106ejk.281.1619077151722;
        Thu, 22 Apr 2021 00:39:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s5sm1253692ejq.52.2021.04.22.00.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:39:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 08/10] trace-cmd record: Add new parameter --compression
Date:   Thu, 22 Apr 2021 10:39:00 +0300
Message-Id: <20210422073902.484953-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422073902.484953-1-tz.stoyanov@gmail.com>
References: <20210422073902.484953-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a new optional parameter to "trace-cmd record", can be used to
select the desired compression algorithm for the trace output file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 18 +++++++++++++-----
 tracecmd/trace-usage.c  |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b8126eae..9b01ee05 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -199,6 +199,7 @@ struct common_record_context {
 	char *date2ts;
 	char *user;
 	const char *clock;
+	const char *compression;
 	unsigned long file_version;
 	struct tsc_nsec tsc2nsec;
 	int data_flags;
@@ -3647,7 +3648,7 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
 		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events,
-							     ctx->file_version, NULL);
+							     ctx->file_version, ctx->compression);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3666,7 +3667,7 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 			goto error;
 	} else {
 		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd, listed_events,
-							      ctx->file_version, NULL);
+							      ctx->file_version, ctx->compression);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3854,7 +3855,7 @@ static void setup_agent(struct buffer_instance *instance,
 	struct tracecmd_output *network_handle;
 
 	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle, listed_events,
-						     ctx->file_version, NULL);
+						     ctx->file_version, ctx->compression);
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
@@ -4247,7 +4248,7 @@ static void record_data(struct common_record_context *ctx)
 
 	if (latency) {
 		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count,
-						      ctx->file_version, NULL);
+						      ctx->file_version, ctx->compression);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
@@ -4279,7 +4280,7 @@ static void record_data(struct common_record_context *ctx)
 		}
 
 		handle = tracecmd_create_init_file_glob(ctx->output, listed_events,
-							ctx->file_version, NULL);
+							ctx->file_version, ctx->compression);
 		if (!handle)
 			die("Error creating output file");
 		tracecmd_set_quiet(handle, quiet);
@@ -5505,6 +5506,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_comporession	= 238,
 	OPT_file_version	= 239,
 	OPT_tsc2nsec		= 240,
 	OPT_fork		= 241,
@@ -5941,6 +5943,7 @@ static void parse_record_options(int argc,
 			{"fork", no_argument, NULL, OPT_fork},
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{"file-version", required_argument, NULL, OPT_file_version},
+			{"compression", required_argument, NULL, OPT_comporession},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6367,6 +6370,11 @@ static void parse_record_options(int argc,
 			if (!tracecmd_is_version_supported(ctx->file_version))
 				die("File version %d is not supported", ctx->file_version);
 			break;
+		case OPT_comporession:
+			ctx->compression = strdup(optarg);
+			if (!tracecmd_compress_proto_get(ctx->compression, NULL))
+				die("Compression algorithm  %s is not supported", ctx->compression);
+			break;
 		case OPT_quiet:
 		case 'q':
 			quiet = true;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index e5b54114..f2383834 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -69,6 +69,7 @@ static struct usage_help usage_help[] = {
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
 		"          --file-version select the desired version of the trace output file\n"
+		"          --compression select the desired compression algorithm for the trace output file\n"
 	},
 	{
 		"set",
-- 
2.30.2

