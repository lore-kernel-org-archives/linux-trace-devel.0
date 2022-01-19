Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331E5C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352411AbiASIZh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352408AbiASIZh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:37 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B9EC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:36 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id m4so7481745edb.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PKE/iqsNAP0FZpe28XX1pe1Bkh82bLkG/AT8vfLqXfM=;
        b=QMqvzmn1eEQwq9uZ+b3Y/W+CSmBTB8TjrPJ8GEWwsE64PCG2YhXk5KcFkGcU2aw08q
         RO1ZgsHiR2bRvpYO5cYGCfTgLw26d0waBZJ+FggaJMeLNmC5zRTdqPAIZ7M7JV8knY+S
         VkrbW2czw53f8TODZotS4fLJWc81OVUe6FEc8sp4Xh+MJmTJGIDGGinWtFjLCcmItEwQ
         lwjQrsgx0MK6+N4O10+nJcHvaysyY4aVUHKsM23Osqpgt3/C1TIfQ92vVB/T1+LhPT9n
         u5Q7Mimc95p1XTYbLJrlPJsZ3AmOIoc0iQdTydbSd+2zaFVSP/LEhL51nB0gcbRCt1x6
         fWqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PKE/iqsNAP0FZpe28XX1pe1Bkh82bLkG/AT8vfLqXfM=;
        b=NGETHWgmWW/k90KWcRESHkFI5C/AuTQHL2/mqcGOK353gPbRWXPFpzUfqiLAxl/fjY
         x4zP2leFvWBeL+LyqfU1mXYmUEPkVWcldrH1hHF4RFgZyUmwlEzlctUy8lWVGJMAhHFt
         XQKci9xWBzzzN796Ia030MwMt02tfsWI+q1QzgIPvwTGcDQvUuac1YoIE4GJmdRIAL7h
         0JPCccwTotxbKIe5xYh1OwV0fMvNIM/d2F94qdlMxytJNmux3fjW5r5BdeVI6lDALtji
         8fKQOTqLH/FtmYyrfZ+S3s+t1+8BX/Mm0WkXXaADElR1Jb542BCpKvtWD4y/qy4ebJ6p
         LegA==
X-Gm-Message-State: AOAM533egX2pFcbzVO6Efq1K6wNnrLMfa34LRwMevx9HoXE8vtePjmDx
        NdiLbGWopiWbMrRJkONsRh3TmJAamh4=
X-Google-Smtp-Source: ABdhPJxNxNTo06xCc5k/KpW8rSKUm03AupLGRnby/Kmx+cEFzP6WcBzB5tIY7V7Cke6XxpF5HeMX2w==
X-Received: by 2002:a17:906:4fcc:: with SMTP id i12mr23897772ejw.529.1642580735537;
        Wed, 19 Jan 2022 00:25:35 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:35 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 25/25] trace-cmd record: Add new parameter for trace file version
Date:   Wed, 19 Jan 2022 10:25:07 +0200
Message-Id: <20220119082507.245600-26-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

By default, "trace-cmd record" writes in trace file version 6.
A new parameter is added, which can be used to set desired version
the output trace file.

 "trace-cmd record --file-version <version>"

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 20 +++++++++++++++++++-
 tracecmd/trace-usage.c  |  2 +-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8567ae5c..4cf48c86 100644
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
 
@@ -6644,6 +6651,17 @@ static void parse_record_options(int argc,
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--poll");
 			recorder_flags |= TRACECMD_RECORD_POLL;
 			break;
+		case OPT_file_ver:
+			if (ctx->curr_cmd != CMD_record && ctx->curr_cmd != CMD_record_agent)
+				die("--file_version has no effect with the command %s\n",
+				    *(argv+1));
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
2.34.1

