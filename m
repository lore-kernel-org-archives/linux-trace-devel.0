Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E050C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6957661252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhKKPOb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbhKKPOb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:31 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D57AC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:42 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id m14so25737864edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2smVDvmkjZ6dm1UyFu0+cAFXuWC1Wi6DodePOZPCsYo=;
        b=fsEPA2m/vEXTBVxObfHM5rBGY3KF7D0/ltKYHuxV0uPgbEZUPhsw6TqWdZS9GK+FpN
         TbQ1msxmAMSuN1OTNvKlwcHAIbqO71BbR2WZIuBDcODOMX+7yedxNrAlAHivoKFpUDLe
         G+NxdAw3n1Zqs7xCDKNQb4482QMAzqRzdzChV8ZbekLMoqyHXO55CtoIvHkibOVdIgu7
         lz01PuHP2DF0P37N4+STfBaf94loxuNFTNEhPwcOIOiTfU9X1xqKGSEFdco0+fMJwMaV
         8bs78NDH2jn0/QVM81W2zvVyIqcCXkUOh7dEt126vZkcvTlCpj5omrlLsL2R3IbjYijf
         lr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2smVDvmkjZ6dm1UyFu0+cAFXuWC1Wi6DodePOZPCsYo=;
        b=uDKTGtdvba6qiQ5id4OOKj5N26ntmjxS4G1+rjP0okSHZcs2kSqbcokyIiQEwJDHo0
         YuPs6aBl1rBL/pmVNGRADCNh7BwzuRdoRMLOPiOyFwFnKI01fjMtYiIW668194y5tqME
         BSIKTJ3ioqQIPVGIaZmZWuyiwYJ0kpqyJfApfkkCs+xP6Paf3OOWs19X0FhUdpHPb/OP
         cop3fhdamYKTi3mGiVwVAaZ+MAGS2waGgRMOx8SFp5nTFvKY5alWV6P6O3c/EARQJPkX
         6ariLIcugHZgYxh7m1GNBhlFEf8ArTKHFR2/UT/9pmPWWYE/ArncE0ycSlqNjlIfaJ1U
         RUJg==
X-Gm-Message-State: AOAM530sBKZKRhBUbcSoQ/jAmbH1Djp/QPdFBP/Xd4pLxNZv+Ippm7+D
        UCKyfOYvHpqXqsp+7LuXwzkwXI1Wze4kNw==
X-Google-Smtp-Source: ABdhPJxEYLGwAy1JzoxRqI9kLr0rAb2kBdGpvhJnFLemtmzf1gNe6Q7QrhYzsxPevv/WdIK1tcLSIg==
X-Received: by 2002:a17:906:fb17:: with SMTP id lz23mr10239529ejb.149.1636643500731;
        Thu, 11 Nov 2021 07:11:40 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm967018edu.57.2021.11.11.07.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:40 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 25/25] trace-cmd report: Add new parameter for trace file version
Date:   Thu, 11 Nov 2021 17:11:33 +0200
Message-Id: <20211111151133.86788-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151133.86788-1-tz.stoyanov@gmail.com>
References: <20211111151133.86788-1-tz.stoyanov@gmail.com>
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
index 338a6a8a..fab34361 100644
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
2.33.1

