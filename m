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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849FBC48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 662C561289
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhFNHyH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:54:07 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:38875 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbhFNHyG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:54:06 -0400
Received: by mail-ed1-f50.google.com with SMTP id d13so31702277edt.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cVvHmzASpCdfwkT4dhPnYQr3vlzUuxmkupRu990yC9Y=;
        b=Azbc5hq/ICqEJVfC+IN9XXOHjTQbjNy0Jmbr0cKAaCvDnQ6ZIU4MECr/NWbyN4GF+7
         CSHyNWs39GlGx/9mv5ef5q8LCLpXCEnawWKpGgul+CE9Q/dhn5pEZVQQYdLu/fz1L1mv
         EhwChEnQ3LWc2CBFUIWBpBY1gJNMYr40wqpD0iTdib/qdFETzaqJWc3nk0jAV50XON2W
         FbTREidqs2SMF69eAilJMBDLeljOBL0c6pS7uVcdCu19gdPzBOECmLyISTYruNeqGL9o
         eccHCt7bkp+hqNiCH/aG9L296q9InadGrzykXKBIVoiNURonzo/xfpLRWwX69Se1ZKp4
         tT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cVvHmzASpCdfwkT4dhPnYQr3vlzUuxmkupRu990yC9Y=;
        b=Gj1Qpw4DgZrO0fHZTeMa65W40mjOQ72d4+kQ1UqDTSM0MafSqskn41+dDKhPB5wG11
         ZrV8PZPL5hHVWHTV/SBaFz78tEAOy3dxmZaR2jSZVGAraqKzz6rU5LOeG4BNvP9Js9JG
         RV75a+QLd7LeRM6eRIA7yZ2zU4pg9dXq9aDUr01eU7CN3iU3oDGQHssi0shcqH6JgxGU
         UES127hjcmsErZNE3Uhpnf7KXc499MpmB4sHICaeJsOmx9x0VuXquAPnF3KI8FLsX/TG
         QT70K2q+gEVop1NPEnuqjv2rr0C/Wsjo7o8S5WaCrwfosWFj/VwDIEUqIgTRL6wlkYB5
         RcVQ==
X-Gm-Message-State: AOAM531rTqVm53tMeKdZ1tdwjPhih3Zkew5Zz2tNyu6MpkXa/hMPOcb3
        SH+6kB4twZ1j3Ioz5L2XbXDEJUruIWL1+g==
X-Google-Smtp-Source: ABdhPJwCErv90SBmiBjROQMG4o1GIg9+kqLq/UBeRINhm7wTZTusq+n+jwDG/I1bEjqTlrcv5buHZw==
X-Received: by 2002:a05:6402:27d1:: with SMTP id c17mr15486331ede.28.1623657046494;
        Mon, 14 Jun 2021 00:50:46 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 15/45] trace-cmd record: Add new parameter --compression
Date:   Mon, 14 Jun 2021 10:49:59 +0300
Message-Id: <20210614075029.598048-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c | 30 +++++++++++++++++++++++++-----
 tracecmd/trace-usage.c  |  5 +++++
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 29f84b7c..d3362e5b 100644
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
 
@@ -6597,6 +6605,18 @@ static void parse_record_options(int argc,
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--poll");
 			recorder_flags |= TRACECMD_RECORD_POLL;
 			break;
+		case OPT_comporession:
+			cmd_check_die(ctx, CMD_start, *(argv+1), "--compression");
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--compression");
+			cmd_check_die(ctx, CMD_extract, *(argv+1), "--compression");
+			cmd_check_die(ctx, CMD_stream, *(argv+1), "--compression");
+			cmd_check_die(ctx, CMD_profile, *(argv+1), "--compression");
+			cmd_check_die(ctx, CMD_record_agent, *(argv+1), "--compression");
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

