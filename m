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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB47C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8952F60FC0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbhIMMbb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240011AbhIMMbb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:31 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C707C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:15 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id w29so13651540wra.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=toMN7Gy7qiKlHDx5qzo4dMJk80onCA4nB44Bg+SUiec=;
        b=PrLSt5LkFcvOOOOzGSjZIjpUs3n8oxPMhqf24hGgFuLGQYXrZMGDnAdxE+izCuXQ7W
         2tjoH7EYkmlB6OOb2xaLP45TYYA6Jb4AOeORglj2Fri4P+Rs4EgLbn9Tas8LS6XzlLRT
         dImRTmEGBQCrw8+7jiBrg2RjMn5OACGyRWVF/51Fs8Gm8eeWIjVhqcF7j8LEGrr0n93V
         dgVg/dAAnqGKrK81rTiQLujRuobGNEloSMKj/czUMWoiThyP5WzfPAL4rC4WSnMVR9d2
         cO1ksEIp3WTreMaX07Kd3QaoVN8MBTI1bl4RVFgbo+4QIdmxsRQ2Dmq1GTCS6MN2E225
         l0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=toMN7Gy7qiKlHDx5qzo4dMJk80onCA4nB44Bg+SUiec=;
        b=5hNQ9b34GnUz+jcwkD39Kupl3SgWkQu+L47TQJ5AfF3DE241HLhthgHNG4V97udhEK
         P/8TysuUMLPxJm4XZGe+Zq67klAASBfzVZZKn7FoMCT1liLz7aS1kpiRrzV/78w4QKSJ
         nCIS/vZYVRGTin99JvPhn48CDkHGtdN9kgxZZZGfeAtm/+oOL9xIUKcSuKH+3YTHeKiM
         xrPELqXc22iKOOtv/ctLNo++BH3ZYzq1laFn481BilNDscQ31fv4Rktid4cdzC+3JckY
         /oiI5ntbkC+ooEVysmrS7KPRRCo9AvubC5R+9qZ41r2fkPRQzXCvMNsB+pCIdUkWleKe
         nhAQ==
X-Gm-Message-State: AOAM533MhlpwXcTbdAz2Wfq/Eu/stxIq9d3i3sNiB/BFFmPAdkp33AKM
        vs0ozqCpGox0N0et/5LXRh07oc/24fo=
X-Google-Smtp-Source: ABdhPJy/9lqhyItQ2alz6WHCjzBQyPmfOF4DxpnpfFtv839UqP/1Z7EXFhD96LI+IGF45Tpt3/eIyw==
X-Received: by 2002:a5d:4608:: with SMTP id t8mr11300993wrq.136.1631536213994;
        Mon, 13 Sep 2021 05:30:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:30:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 25/25] trace-cmd report: Add new parameter for trace file version
Date:   Mon, 13 Sep 2021 15:29:47 +0300
Message-Id: <20210913122947.3673239-26-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c | 21 +++++++++++++++++++++
 tracecmd/trace-usage.c  |  2 +-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f94eee6f..421bb7d4 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3698,6 +3698,8 @@ static struct tracecmd_output *create_net_output(struct common_record_context *c
 	out = tracecmd_output_allocate(-1);
 	if (!out)
 		return NULL;
+	if (ctx->file_version && tracecmd_output_set_version(out, ctx->file_version))
+		goto error;
 	if (tracecmd_output_set_msg(out, msg_handle))
 		goto error;
 	if (tracecmd_output_write_headers(out, listed_events))
@@ -3744,6 +3746,8 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		network_handle = tracecmd_output_allocate(msg_handle->fd);
 		if (!network_handle)
 			goto error;
+		if (tracecmd_output_set_version(network_handle, ctx->file_version))
+			goto error;
 		if (tracecmd_output_write_headers(network_handle, listed_events))
 			goto error;
 		tracecmd_set_quiet(network_handle, quiet);
@@ -4475,6 +4479,8 @@ static struct tracecmd_output *create_output(struct common_record_context *ctx)
 	out = tracecmd_output_allocate(fd);
 	if (!out)
 		goto error;
+	if (ctx->file_version && tracecmd_output_set_version(out, ctx->file_version))
+		goto error;
 	if (tracecmd_output_write_headers(out, listed_events))
 		goto error;
 	return out;
@@ -5785,6 +5791,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_file_ver		= 238,
 	OPT_verbose		= 239,
 	OPT_tsc2nsec		= 240,
 	OPT_fork		= 241,
@@ -6224,6 +6231,7 @@ static void parse_record_options(int argc,
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{"poll", no_argument, NULL, OPT_poll},
 			{"verbose", optional_argument, NULL, OPT_verbose},
+			{"file-version", required_argument, NULL, OPT_file_ver},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6649,6 +6657,19 @@ static void parse_record_options(int argc,
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
2.31.1

