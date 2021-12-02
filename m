Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C075EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358014AbhLBM0Z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358111AbhLBMZm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:42 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBB4C0613F1
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:18 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x15so115105567edv.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KH2Sen9boB8o6K2Juh/7bubbw9PC9Vc8MbUMk3gEf3k=;
        b=Rs/51ZSLPopMtZywWuXq9mDkjiUVVr/GXelQBNnVU9tCkCa2/n5ytjTbxtT5corSim
         ccOiBwKdWBFj93htDLK0n0RmAIRl+RLFedHDQwEfcbnHmHmVfKDI32U5SRM4Z2swxqCy
         K/HG9i8b0fDCGcP1pkLpPUn95OCkgvGBj7HcyAgH1KSt5aMznFiaf6l6eqZBTVAFW/m4
         qJwn+Qjwtt7BpxqLHrborDfKzDWmjxRpWoWwzIGH1x160AQuWtxZ8vHQ/G54+FAXqpzL
         vXI2k9GSR9eGfgK19pMH1GLTqTNglCsvD4ERFlZ2wRplL3yW814Voa0BzFXtEPTIuTG4
         E9Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KH2Sen9boB8o6K2Juh/7bubbw9PC9Vc8MbUMk3gEf3k=;
        b=bjQ0kvqKchT1z/vc0CL7pa41o7ONP+6CcUybHur4V7OFT2xdZHqboJnjsZqqlrlqcR
         rUCw/IeDc9jcGmXjKEz11PBFvQCTmNXlhtzpktlqt3QwnwtItGt5qJWGXBLKYtjqtrIK
         ngDapremZDergUpcXvjhIy5MoHl/7xbhlwt6TD+jjUtZgge09cvl0Ui62Spj8fRRM0vG
         MxYCyeq1KJf/wj/KlOaKHtWMhggpLGxsxFmdV9eYjN43H0lgHedreSo43j6FtI4KQcvA
         KuUcdPNlIc2hlrosC6ZdO+XkXf3j73NWlOaqpe2ITUvP5rBZjgELFdGz5qOP/yuDnRHq
         LPcg==
X-Gm-Message-State: AOAM530Se/xdo4aPx7GVAsGq1AEbuZRnRnXyakal7joz2bYqLjjc6F/X
        uP90vxnEW/xoLfafH3JfaIYlnWHg1L2vLg==
X-Google-Smtp-Source: ABdhPJzd6rXoGa33uoKRFoN57BwKfpfb9P5WqE70gN85we+3aZfzQ8KJWR1T5a0uPKecE6lEeSpxjA==
X-Received: by 2002:a17:907:3c7:: with SMTP id su7mr15011035ejb.87.1638447737139;
        Thu, 02 Dec 2021 04:22:17 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 23/23] trace-cmd report: Add new parameter for trace file version
Date:   Thu,  2 Dec 2021 14:21:52 +0200
Message-Id: <20211202122152.43275-24-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
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
index 442e55bd..ead2c107 100644
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
@@ -4470,7 +4474,8 @@ static struct tracecmd_output *create_output(struct common_record_context *ctx)
 	out = tracecmd_output_create(ctx->output);
 	if (!out)
 		goto error;
-
+	if (ctx->file_version && tracecmd_output_set_version(out, ctx->file_version))
+		goto error;
 	if (tracecmd_output_write_headers(out, listed_events))
 		goto error;
 
@@ -5779,6 +5784,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_file_ver		= 238,
 	OPT_verbose		= 239,
 	OPT_tsc2nsec		= 240,
 	OPT_fork		= 241,
@@ -6218,6 +6224,7 @@ static void parse_record_options(int argc,
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{"poll", no_argument, NULL, OPT_poll},
 			{"verbose", optional_argument, NULL, OPT_verbose},
+			{"file-version", required_argument, NULL, OPT_file_ver},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6643,6 +6650,19 @@ static void parse_record_options(int argc,
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

