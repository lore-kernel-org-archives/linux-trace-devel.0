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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C028C43460
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E57D610CB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhEJGSA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhEJGR7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:17:59 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72642C061574
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:54 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id n2so22712990ejy.7
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/BGJ1mbLjfC7/Y5pZ3u3hKYzrbdXuGnvDfbI2PrCQDs=;
        b=oLVdW+krzA6gPmcx7WtscLHu7yNUOpcTzsC8//AwqVIYR4fPqZ6PKiJz2k6w8MGgr1
         geiU8z9ObqV1CEv32xRIdsgPx37r44IsXpoPSpmIcdqKdBDBJqpui60TWRElm+l6f5so
         2OerlFejDUgDlMPJc4B4sYvvdY90IyumZ0m3w9/zScRG/gHZFGiYvae/OLSkmnwdyfNK
         LqD5y1mb4ahbyuwPOPKJaNbSQg69uN8QeKLPQBjY/uc5rlUqF+jjNjk9slLt+UNrV5Wx
         39S47hxsngLUm9MdfVojhG3kC7ZoAf50YO4/u/Bv/4diXITHcnWqZ54DQ34KsmdpBOsD
         ncyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/BGJ1mbLjfC7/Y5pZ3u3hKYzrbdXuGnvDfbI2PrCQDs=;
        b=JyLApbuZXK4OltCvp+ZcRny0hZguRMHWeNFJLq4Dg4fWhPH4fGkJGWWB0tyLToFsqa
         bFEG7wRLs26IT0uLujKP6jDAfsw5RpFc1Y3gO0NvvATGlLqfLpS28utQKYWKVvffNLSS
         FftWXOKdaT+IYej3QIq3l6a9ksZFooJI+bY6x9SMb99ObBrKOG8lK4SQTQeZzro+BEzB
         vhDl8P+GcuDFkiOC+yVQSOnbMANqYLFXDpmOevS+FwRG8LkqbbeIoOCuh8uksplVcHqR
         3PmI0HKbrLgmGUOrs4ulrXkRoJYNX2jD8EniERjb5Et2wjXOJ/vegYxiStE/9FONOzFq
         qsWA==
X-Gm-Message-State: AOAM531QmyL23l1MpWHsSPmYZYM7h880w21jjK5AmVx7AOs4BexysXh0
        uzHjmnGr/+WRiiwnoNoRhdSEcbzWJ0/uSg==
X-Google-Smtp-Source: ABdhPJxlrRauzYlSe1SEpZXzf5OLz5JyZwqjRvpYXozfcVQZMkZEORA7MiHhk1CCzqv2P6NSUTNnPg==
X-Received: by 2002:a17:906:494d:: with SMTP id f13mr24303633ejt.490.1620627413220;
        Sun, 09 May 2021 23:16:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 15/21] trace-cmd record: Add new parameter --compression
Date:   Mon, 10 May 2021 09:16:30 +0300
Message-Id: <20210510061636.1794357-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
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
index e7a360a4..5e969dc7 100644
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
@@ -3642,7 +3643,8 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 
 	/* Now create the handle through this socket */
 	if (msg_handle->version == V3_PROTOCOL) {
-		network_handle = tracecmd_create_init_fd_msg(msg_handle, listed_events, NULL);
+		network_handle = tracecmd_create_init_fd_msg(msg_handle,
+							     listed_events, ctx->compression);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3660,7 +3662,8 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 	} else {
-		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd, listed_events, NULL);
+		network_handle = tracecmd_create_init_fd_glob(msg_handle->fd,
+							      listed_events, ctx->compression);
 		if (!network_handle)
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -3848,7 +3851,8 @@ static void setup_agent(struct buffer_instance *instance,
 {
 	struct tracecmd_output *network_handle;
 
-	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle, listed_events, NULL);
+	network_handle = tracecmd_create_init_fd_msg(instance->msg_handle,
+						     listed_events, ctx->compression);
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
@@ -4240,7 +4244,8 @@ static void record_data(struct common_record_context *ctx)
 		return;
 
 	if (latency) {
-		handle = tracecmd_create_file_latency(ctx->output, local_cpu_count, NULL);
+		handle = tracecmd_create_file_latency(ctx->output,
+						      local_cpu_count, ctx->compression);
 		tracecmd_set_quiet(handle, quiet);
 	} else {
 		if (!local_cpu_count)
@@ -4271,7 +4276,8 @@ static void record_data(struct common_record_context *ctx)
 				touch_file(temp_files[i]);
 		}
 
-		handle = tracecmd_create_init_file_glob(ctx->output, listed_events, NULL);
+		handle = tracecmd_create_init_file_glob(ctx->output,
+							listed_events, ctx->compression);
 		if (!handle)
 			die("Error creating output file");
 		tracecmd_set_quiet(handle, quiet);
@@ -5531,6 +5537,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_comporession	= 239,
 	OPT_tsc2nsec		= 240,
 	OPT_fork		= 241,
 	OPT_tsyncinterval	= 242,
@@ -5965,6 +5972,7 @@ static void parse_record_options(int argc,
 			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
 			{"fork", no_argument, NULL, OPT_fork},
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
+			{"compression", required_argument, NULL, OPT_comporession},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6386,6 +6394,12 @@ static void parse_record_options(int argc,
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

