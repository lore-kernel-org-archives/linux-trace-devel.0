Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE968C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C83DC610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237621AbhJHEWX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237676AbhJHEWX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:23 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB1FC061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:27 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id p13so31775337edw.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L1OQRoqkeIneJWurB0hMVlHEWrOtORdF17NbRrdv3k4=;
        b=jV5+FL/iPLAgl9A10aKz6K+r+BYyxXDc+O43Zp2at2qQ54jwZFNxNA7/olYBtf56Ip
         Wh7Y6RJvItAsiznPIFwbZw33/GVAQsqeIk0itYB9zYtG8Pvz0+M38oXIu1Po3tEXR5Kz
         sNLz829KuKRb3xcI8Fp7dsVdCOZ5rnLnad0YWBNV1nAzDXOHci6CDgU1+l5eau8VayVc
         mOVpj3HLx/zDhZ29dJWiPavFCPHBEJEKrEKOsdprvSG824HK6RNTAD0x9cACu7KsqBBp
         U5bl9hh1s13vcU3OK6R/TFVREs9woCt5vSQ7WmZIY5++dhwe++rYzHYvvLqNnJmSgUjG
         76GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L1OQRoqkeIneJWurB0hMVlHEWrOtORdF17NbRrdv3k4=;
        b=HD8dgQb/e3Q72PODWRJguPT9IM+ne3YjmAjqGPH+gB69sxswHElv4AKTRT3MMvi017
         OYVTxS/hIXo1Y4g2Fa4sV8ovDdikXXidwQ8S6GMUwWWRiNOIPPIpTZNq0Ey4FPy16mqk
         mmWkvvRYUY4HOYW7VxxTMLNi9f4xSfxq5dJs2ls2AHVIOxvs6CRR/WmFbP/t/Y9nTWpN
         CArdbPota/g8DGEroi79eVqUnxtEIHHDu0mFmH/RyyP0J5X/yENAvz0x+E3JAWLgG5rJ
         ZtcxkVb6nwG+iepCFHoEvcoWt7pJ0cActHqOaECdWJ8J8huxtoWge0xQCFYcm5p5471s
         hPjg==
X-Gm-Message-State: AOAM531k3LxL/Pje5iTROEHG4bIztBrN9dYcWU+2tNk7jyX/OAIWh/Y2
        BNQQJFK1SD/N2+2zIcXQ0IKtYuGvPDTXOA==
X-Google-Smtp-Source: ABdhPJye+Ul+ZqcJfDBsmD+ekQUKx09uedpFJ/QbK/LqwKz+JzAGm5yNObtZ4GujcP9c5siWda7CgA==
X-Received: by 2002:a17:907:3312:: with SMTP id ym18mr1299456ejb.370.1633666826482;
        Thu, 07 Oct 2021 21:20:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 25/25] trace-cmd report: Add new parameter for trace file version
Date:   Fri,  8 Oct 2021 07:19:58 +0300
Message-Id: <20211008041958.976309-26-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
2.31.1

