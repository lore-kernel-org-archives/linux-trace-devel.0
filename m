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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F57BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB070611EE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbhIJNwk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbhIJNwj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:39 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1EDC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:28 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id e21so4354021ejz.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=toMN7Gy7qiKlHDx5qzo4dMJk80onCA4nB44Bg+SUiec=;
        b=C2DP8y33fsc0gUbyelxMOW1q84NstuixbIgf8zHioFSqkcVWurcuaeWBxIXvWg77rJ
         gxJUkOl2jR80cRu+b/1xy4tWfegrP3ydHKFcfL1o1ghg06CycFuLEd9Y8t8XCOtUF3MR
         KDPIMzf5v7X0U4Tx5SMZxaQr+2EuoJPNgO+Tgf7B+AeZrc8CXVpRApjL8yKpyRA6vJAW
         1Z1Xb1V8IRNlYl4QShj3UA40V2G+vndWhRvbVoM8HARDYzTHouxr0ittMzyAYnANL3ea
         +BsHv8wF1atN3OiAYt/+6Nu+/01ID29CD+MbYA2gUh6flkwSDa8zbvzzOD6BmYtJEvpU
         wnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=toMN7Gy7qiKlHDx5qzo4dMJk80onCA4nB44Bg+SUiec=;
        b=WEr7ge7eJh+XT7mdtSxgCjHliV9pa1lqoNBvmx5T/nP0NnuqNSc+5b8BE8UMxBmMhy
         bqpmB4GVhULvZxsIWk5+eYLDChLFK2Lvu13Om4QbpOiUn6bZKW9i9ULXOt/Fu9+9EqAS
         oA2agl4SCEAIiy4qdUKOJDjJY7l9G5EOxBnu98VLH5p0qyWR/4VBUfymz0dnAVkX6GoK
         cs7uaC3amsEKM8AP3UkwKiHNoMjogDUPX5/TSSpPrfjiLv27H1xU1U+0+RBg5zTNVFeU
         tqNbtizRlqYm2a6n1TLcb3hamq7G/sQANGrBUcq9zKYdfs/ZFNDhbLRhhC5VpF33TDBw
         Mr+w==
X-Gm-Message-State: AOAM530BMljDHtbVEDoNJGIn8mlphfplD985nMdvgdYueUE1XTuWspVU
        JOpAbYjZvszFfW/a+xU+KdRpwLTeqTY=
X-Google-Smtp-Source: ABdhPJy4//XaP/kfo0+gDWTCclqxjTGZ7zJ7gvIoxX2ivMIWmMacu68pDvlM8G5T49KD997yJ0TbrA==
X-Received: by 2002:a17:906:ecb8:: with SMTP id qh24mr9706616ejb.88.1631281887228;
        Fri, 10 Sep 2021 06:51:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 25/25] trace-cmd report: Add new parameter for trace file version
Date:   Fri, 10 Sep 2021 16:51:01 +0300
Message-Id: <20210910135101.2865226-26-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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

