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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059ADC43461
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 04:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2CE261446
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 04:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhD2ECR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 00:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbhD2ECP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 00:02:15 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19BFC06138C
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 21:01:29 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id z5so40352371edr.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 21:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RLVirN8WZI8eB6p02Dt457R0Zc3l+ePoOZUR/rBIvJY=;
        b=SYpltgChO291U5pbrtmR/4unw6qmF8H8ZsbF0r/NGI+4Sf5jvSjL4hmTcDNCHlHSzI
         V4W68Z1L7dkJGiB/SjGyYxJjkFO482v32stVD7SdkxMW5mV9faa1s6MUMl1WHINamJBb
         GSKx8dCD/KO4UUYyywUyY9xAXQyiptFdiqxHah+uXvTtRkcwEyvHv48Tqr4gGNWHIzm0
         BSTw1WMZB6wc6YWJ4oEpmNONTL3JFFAdVDcpf0yKG8GgS73FNi+aGGbfk01+pu0FgIUH
         5oOuqDxWoLcCSczr936u991yNrK1XIJ6sKqpx0/fDbr1k5wDXIp4ev8SnoRPohkpIB6+
         XsKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RLVirN8WZI8eB6p02Dt457R0Zc3l+ePoOZUR/rBIvJY=;
        b=Or5LjaC3IPzV3GH4Ln4UY0EW7eHOrajo1ziGTk8/JYaeaIIhH1kTAqUd7aR3e96oA7
         RFJrYAG9Eff6nfFGvSPG73hIghSJwfReQ/eGt2pURVejxulTAW52k7YSmiRoBEDpTUdI
         Rt4eif6nMXv27jtSt9cs5DqVaU3SRBuc1xS/SyjuolOryaPSAn5g03N1KW0vjzZZKM1k
         s0cUZNbP7p6VDealOqmxoUkLkakT3RMgy04wQN3eRAKajUL1MTkFOBp6gVCZkKMZUlXI
         k44MrJo2Ui5N8FbB7ZkGC9H3VlRZX0XMlmdqZ9WVeyzyzDqOKQ/sLQDEE4r4/9T/cOzn
         4wag==
X-Gm-Message-State: AOAM531HWurm+meW4goCaFgqFdIb/qk/PnMTtFfoTZTDAO/W6nCGH9jX
        wvKS9Dk6OBBav/8GQGR1TuFc2/08EYHF0g==
X-Google-Smtp-Source: ABdhPJz6+0zLRqtZO51fTiGRblVEdJg/M5Rf03DSs/RleB2RLNvj6pSfam839qxIbOLheHOexwYziA==
X-Received: by 2002:aa7:dd96:: with SMTP id g22mr3603818edv.222.1619668888463;
        Wed, 28 Apr 2021 21:01:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z26sm1040740ejl.38.2021.04.28.21.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 21:01:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 7/7] trace-cmd record: Add new parameter --file-version
Date:   Thu, 29 Apr 2021 07:01:19 +0300
Message-Id: <20210429040119.843617-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210429040119.843617-1-tz.stoyanov@gmail.com>
References: <20210429040119.843617-1-tz.stoyanov@gmail.com>
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

