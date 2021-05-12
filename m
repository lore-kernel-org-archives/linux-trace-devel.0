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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA475C43462
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C285D617C9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhELGju (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbhELGjt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:49 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEECC06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:41 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id a25so1571398edr.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/BGJ1mbLjfC7/Y5pZ3u3hKYzrbdXuGnvDfbI2PrCQDs=;
        b=pJ618sSZs1oKF5+hv5yehOqWnwBQMf1ErfELjceRZPw57Jh0tdJ30o/huoQpR/UPPr
         6vp2RFuhCT32pIUj1BebkW+QyyFfQ+a5wPAFSqoyhAv5j0St7Sq/tJM5teqymCcSHMO1
         SpYj5a+6fSRDGwNESZ/fAyhXzxuKwnX+aN+FyTALo4Gy8k9vuKKhjItJ18NQIUVaCLy9
         vZHeiFfmDpKhwzgaYhZWYa6lpo7kLqiSPnyUf3eDLtfiFNrAux5K16ACsohFl//h88xY
         eW9fbwuVE7aKWkfOrDKL5mhxoGbkU7lrxg4iQS2dVxPy84kzUsr/NzhXEkgfYVbNPZhT
         Kwtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/BGJ1mbLjfC7/Y5pZ3u3hKYzrbdXuGnvDfbI2PrCQDs=;
        b=VwzblpMQzb5KKlmYUE+5JkRoNum9/hPpESP61afSlpDbZBe3Jl+DOT73c2+Vzn//0j
         OV/jeJ5GAA/SOzrx6jEsWC9qyLJMEWiZmfJwoNsu+ZUTzg7mWysJoKG4iwm+zemh0JRc
         7pA9Bc8NHwFmj9CS55hwrZKW/lbnG+I1NzNo5f2w5EsZxbu7if9PGpQXLpZVaNgWMbuQ
         9Gs7xTEbpy4b3KUxMdQw3jYpwhJ+Fsb8uLKVbbCfEx5Q8+aN2DTCIyDJTTAFp/M/T2jX
         crOJhUtAaMjYTg7dq8N1cXhs0Pkz3kdQCa7ura+up41Hyij4CbtsYx64p35sm93CJWm6
         uYfA==
X-Gm-Message-State: AOAM531njJEbtOoAILjI4e9Fm1pDga83s2elGbFzXV1IvJHtms/Evyhk
        nG4+XSf5uiXsuFTh9xljY/Q=
X-Google-Smtp-Source: ABdhPJyY3jP8wwnvbbC2f3DZogC4FFNMafDx+skaxoihDtfdOyfN1UHIM2NQwaSkDGTTReWxRWE9gQ==
X-Received: by 2002:a05:6402:1547:: with SMTP id p7mr41505344edx.319.1620801519786;
        Tue, 11 May 2021 23:38:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 15/25] trace-cmd record: Add new parameter --compression
Date:   Wed, 12 May 2021 09:38:13 +0300
Message-Id: <20210512063823.324610-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
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

