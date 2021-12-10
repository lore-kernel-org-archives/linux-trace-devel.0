Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330C5C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239819AbhLJK6t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239754AbhLJK6s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:48 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37CFC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:13 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x15so29245015edv.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3xi3xLrgOSx5KJeQKY/T3MVU6K2RpKYKC5Cg/1Zgn7o=;
        b=A36K3acNeSeldM2cUnTzE58sKGqAKtogSGBNwrFOs4pjGABOEn3mNyPjWDyxMTP12o
         WSescG9KsIc8rWj5XzgqIvr/ekL3oRVVUCeaAvMbjdbfHteVNuupuljWG4CqKCr1x1rb
         aTgcpYGc+J4mGC8bw4sMlF9AsmTYN48vsu5FD3lvhT5RmzY950HWb+ZS3VLNWog0HY2L
         DrCoRqXRsA1ycf87ZhUnIqbo6KedRKb1X773hIvQsGUA7MyV94ttYKky2trrD4UEQfC3
         hYEnzcEkPWITrSLi801Z2POQuUUo8a/Rx0tKJSyrtcAaxTxhI/7cV+uv0wsIJH1NXWnZ
         LZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3xi3xLrgOSx5KJeQKY/T3MVU6K2RpKYKC5Cg/1Zgn7o=;
        b=FQXHynEvtWMjBUaqdSlgdDo2l0E93JApX7vAWCM/gJJgdEDEoONPC4ewHEPt7vDAYY
         V70Nso5/lol/RW0rQPbi+KL+Zbpqzc3VPU0ua4gnJ3KGL0NtkB7jMWr0I1jUcgYeoc9F
         C+VQePN4ss0EK64tqThuvM7wIvgR5IRgYVPWZ6c3LgSxXAln16OLdrJs/ko7fYO5o88q
         l5QMN7dirpS2PDKL+R1SgXSix9bavox458Epm+h1eDcQYWZFcvAom+hkMGH4AV0zK5ec
         xItz9s5idQ76Qe5tDsy2QoOI0+DUuRwqJqQItAAo1oSko9N13vV+bR7y6XtrX7FRR+4Y
         xPZQ==
X-Gm-Message-State: AOAM533M4SylzSIIsRj3b/9We0yDlY1BgUBIrbx7JwRI/lD4oNHcbiLa
        UWZbG+9FL2rnlkTAkz1SjkYl3lT3vtM=
X-Google-Smtp-Source: ABdhPJw8LviUfEwe42bdY8v6BLv4m2XEhjMqM6SeEt162kDaHOM7/a+i+cySWwLbkF08ggwGhWqa3A==
X-Received: by 2002:a50:e003:: with SMTP id e3mr37222980edl.374.1639133712606;
        Fri, 10 Dec 2021 02:55:12 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:55:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 25/25] trace-cmd report: Add new parameter for trace file version
Date:   Fri, 10 Dec 2021 12:54:48 +0200
Message-Id: <20211210105448.97850-26-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

By default, "trace-cmd report" writes in trace file version 6.
A new parameter is added, which can be used to set desired version
the output trace file.
 "trace-cmd report --file-version <version>"

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 22 +++++++++++++++++++++-
 tracecmd/trace-usage.c  |  2 +-
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8567ae5c..1b806e78 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3698,6 +3698,8 @@ static struct tracecmd_output *create_net_output(struct common_record_context *c
 	out = tracecmd_output_create(NULL);
 	if (!out)
 		return NULL;
+	if (ctx->file_version && tracecmd_output_set_version(out, ctx->file_version))
+		goto error;
 	if (tracecmd_output_set_msg(out, msg_handle))
 		goto error;
 	if (tracecmd_output_write_headers(out, listed_events))
@@ -3744,6 +3746,8 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		network_handle = tracecmd_output_create_fd(msg_handle->fd);
 		if (!network_handle)
 			goto error;
+		if (tracecmd_output_set_version(network_handle, ctx->file_version))
+			goto error;
 		if (tracecmd_output_write_headers(network_handle, listed_events))
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -4471,7 +4475,8 @@ static struct tracecmd_output *create_output(struct common_record_context *ctx)
 	out = tracecmd_output_create(ctx->output);
 	if (!out)
 		goto error;
-
+	if (ctx->file_version && tracecmd_output_set_version(out, ctx->file_version))
+		goto error;
 	if (tracecmd_output_write_headers(out, listed_events))
 		goto error;
 
@@ -5780,6 +5785,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_file_ver		= 238,
 	OPT_verbose		= 239,
 	OPT_tsc2nsec		= 240,
 	OPT_fork		= 241,
@@ -6219,6 +6225,7 @@ static void parse_record_options(int argc,
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{"poll", no_argument, NULL, OPT_poll},
 			{"verbose", optional_argument, NULL, OPT_verbose},
+			{"file-version", required_argument, NULL, OPT_file_ver},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6644,6 +6651,19 @@ static void parse_record_options(int argc,
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--poll");
 			recorder_flags |= TRACECMD_RECORD_POLL;
 			break;
+		case OPT_file_ver:
+			cmd_check_die(ctx, CMD_start, *(argv+1), "--file_version");
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--file_version");
+			cmd_check_die(ctx, CMD_extract, *(argv+1), "--file_version");
+			cmd_check_die(ctx, CMD_stream, *(argv+1), "--file_version");
+			cmd_check_die(ctx, CMD_profile, *(argv+1), "--file_version");
+			ctx->file_version = atoi(optarg);
+			if (ctx->file_version < FILE_VERSION_MIN ||
+			    ctx->file_version > FILE_VERSION_MAX)
+				die("Unsupported file version %d, "
+				    "supported versions are from %d to %d",
+				    ctx->file_version, FILE_VERSION_MIN, FILE_VERSION_MAX);
+			break;
 		case OPT_quiet:
 		case 'q':
 			quiet = true;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 32b38bfd..ac12b066 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -69,7 +69,7 @@ static struct usage_help usage_help[] = {
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
 		"          --poll don't block while reading from the trace buffer\n"
-		"          --verbose 'level' Set the desired log level\n"
+		"          --file-version set the desired trace file version\n"
 	},
 	{
 		"set",
-- 
2.33.1

