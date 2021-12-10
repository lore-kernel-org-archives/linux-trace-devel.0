Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11B4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240134AbhLJLDf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240141AbhLJLDd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:33 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3938DC0617A2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:58 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id r25so28192152edq.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+wDebInUk6oMh6gDZ8LDaSc9uhgNRDbCGsd6OpAfeNE=;
        b=BQ4V445wBiXmmHeVAv60HD73ymkNUF6AJEU6p0bbE51yyAP+wDlzl4kFwBFJRCbLrQ
         /eMZcMV+FEuLxubaGcZ0pgJBKsL1oohXHc0ZWxCGMoDME5oHxq4j5mpJMcuvLjFoElFD
         C5rx3kLZa8V2E/TrGuWuCW5vISAHD1+WAH33rTU4qvogCWEnur+kc0TkKbIHuphPsSyU
         kJAXrLnDo/kToejeqS+J60q1ZJHHA0e4flBqxT2JoE8nIZz5ZTaveT3ll6MdKNPwkBdq
         96t6309EF6VTG1yryUbsCU4caxHfnpq6dQK0SC7RsEK3IA3BgS38eKAW8sJsE7zOhLUV
         qZxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+wDebInUk6oMh6gDZ8LDaSc9uhgNRDbCGsd6OpAfeNE=;
        b=THMe7W5dyKYNhrs5y0uPT7Tn7mO4lYZkOMmddu/6b8MKRDUGLqHP+W6P1Ufo2m9PKE
         eJoumYZZ7tynGMqAQ+fGGJxnY5fB/oZRmsmboVqi97WyPmgRUBrr8njcnFuDrINHij/s
         3XtsI3lYU9gpVexZuxHfFaQ/AVMwqeHhu1Td7vv5EO2SHkPAj62Kk0ZLdN9EHGz7/IaL
         3kFukoUmP9xIR7b6Ghkjx4+6B733d8nXF4F7ll3oWkAMwS18RD8DAHRnAy9eFSo+ZrOr
         sruoVFnHET4bRzFwzapiSbIg6oMIAoHB9Q5JYApSYxwod/Nb23WJlVlooNrxk2Rni+K1
         jtfA==
X-Gm-Message-State: AOAM533mWxs2vrTd0/TPxj95XgY/erqAsETzmBNsA+gSdwRTTX1SqQyq
        VaKRSMq3w2F4DLD0zonlh3dYgcrk8F4=
X-Google-Smtp-Source: ABdhPJz7/ucCxcKzfFbPmqqp2Lo1OGVCSTR4zaAmFVOJyBu8zB32vrgesrn7sDKVe8SvMkDfY8KYkg==
X-Received: by 2002:a05:6402:b26:: with SMTP id bo6mr39100197edb.207.1639133996831;
        Fri, 10 Dec 2021 02:59:56 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:56 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 20/20] trace-cmd report: Add new parameter for trace file compression
Date:   Fri, 10 Dec 2021 12:59:38 +0200
Message-Id: <20211210105938.98250-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new parameter is added, which can be used to set desired compression
the output trace file.
 "trace-cmd report --compression <compression>"
Where the <compression> string can be compression algorithm name, "any"
for the best available algorithm or "none" for no compression.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 13 +++++++++++++
 tracecmd/trace-usage.c  |  5 +++++
 2 files changed, 18 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 20a36a62..7ab8fec1 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5804,6 +5804,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_compression		= 237,
 	OPT_file_ver		= 238,
 	OPT_verbose		= 239,
 	OPT_tsc2nsec		= 240,
@@ -6244,6 +6245,7 @@ static void parse_record_options(int argc,
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{"poll", no_argument, NULL, OPT_poll},
 			{"verbose", optional_argument, NULL, OPT_verbose},
+			{"compression", required_argument, NULL, OPT_compression},
 			{"file-version", required_argument, NULL, OPT_file_ver},
 			{NULL, 0, NULL, 0}
 		};
@@ -6670,6 +6672,17 @@ static void parse_record_options(int argc,
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--poll");
 			recorder_flags |= TRACECMD_RECORD_POLL;
 			break;
+		case OPT_compression:
+			cmd_check_die(ctx, CMD_start, *(argv+1), "--compression");
+			cmd_check_die(ctx, CMD_set, *(argv+1), "--compression");
+			cmd_check_die(ctx, CMD_extract, *(argv+1), "--compression");
+			cmd_check_die(ctx, CMD_stream, *(argv+1), "--compression");
+			cmd_check_die(ctx, CMD_profile, *(argv+1), "--compression");
+			if (strcmp(optarg, "any") && strcmp(optarg, "none") &&
+			    !tracecmd_compress_is_supported(optarg, NULL))
+				die("Compression algorithm  %s is not supported", optarg);
+			ctx->compression = strdup(optarg);
+			break;
 		case OPT_file_ver:
 			cmd_check_die(ctx, CMD_start, *(argv+1), "--file_version");
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--file_version");
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 34c6cc35..77898c1c 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -70,6 +70,11 @@ static struct usage_help usage_help[] = {
 		"                                                         at the beginnig and at the end of the trace\n"
 		"          --poll don't block while reading from the trace buffer\n"
 		"          --file-version set the desired trace file version\n"
+		"          --compression compress the trace output file, one of these strings can be passed:\n"
+		"                            any  - auto select the best available compression algorithm\n"
+		"                            none - do not compress the trace file\n"
+		"                            name - the name of the desired compression algorithms\n"
+		"                        available algorithms can be listed with trace-cmd list -c\n"
 	},
 	{
 		"set",
-- 
2.33.1

