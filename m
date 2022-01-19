Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF13C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352472AbiASI1m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352483AbiASI1i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:38 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D17C061747
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:38 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id j2so7541282edj.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g9Z+lPTqfjjx1/lJ4Ho6epL2jahPAOSSVxlt4Bx/vek=;
        b=HgiXzHhQqH5guah8aaMCBG2lqWJGdUt7240w0lX7/ZkjEfvpmp+8XnM2k/qKF1LeA4
         s2IAnrizNtRSNhLZIaEeIK29a3WisnjHhLsEg931MO+Y6DaZA5zM7VHJg2wlDfjz1Kxe
         ysyyx99u7vsmV1uxFDlmdYZKVA2hbynOIGIBNVc0nxM2/G+vOMn2Qp+jAWGOMPSoKNip
         tSfTsytsv7d6G7kt4yGIPT0Sb6EWrAxbqXOsDf10p/hoQdPiLTTaiHXOtM5Rfd64Uti2
         ECMFcHOEVxSkZBzOO3o0cyJd3vQWDGqExJS7/HybFurCY0XX1YtWMjFRcTBSQihJ5CYB
         r1GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g9Z+lPTqfjjx1/lJ4Ho6epL2jahPAOSSVxlt4Bx/vek=;
        b=TxFGoY1El1o+l0LyjWhzRWPKdMr/HMjELK9ww+DSkrWBnEC/YOj83FR3QcC9reyWW4
         zCsQ4FshU9zOA/5UnCJ6TpwEys85KzUX4Cebrfxu/inxnoBcABw9zUFA8RTzl3FUmIuq
         WZwXwfI8M338X8jjxWSzmx3fGMRBzjkqeG7vpB/HTY6zIzw92GMBkyT3iqoPs5qVM4Kg
         9yNPDcrbnyUSFE3ryqMc/IdgCkaKHSG1PEsIDsN8EdytMdLAj/Vvu6yfGNCHR6EFNOAN
         XW04nZmOtC98u7EhenqSRK+myiuYLmYMCeY0Sc3ubnj7yniHCt/eN2D/Y63IvL2WEfkX
         QmLg==
X-Gm-Message-State: AOAM530ixt7NtEV7lzsa9C/MfmBXJd2BQYVjRx3123tY3YZNAMoEnOp6
        oGV/NtNgsrFV7OIJfutB5uBN09c5Rbs=
X-Google-Smtp-Source: ABdhPJziB9EcpZkY9QnGIKwtSULnln8YF5hUj5VzYrMSArwtDafkJSqwYzGkm5SyXbU0FK8/9d40aQ==
X-Received: by 2002:a17:906:3e8a:: with SMTP id a10mr23195359ejj.612.1642580856641;
        Wed, 19 Jan 2022 00:27:36 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:36 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 20/20] trace-cmd report: Add new parameter for trace file compression
Date:   Wed, 19 Jan 2022 10:27:15 +0200
Message-Id: <20220119082715.245846-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
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
index f1dfe458..d862c7fe 100644
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
 			if (ctx->curr_cmd != CMD_record && ctx->curr_cmd != CMD_record_agent)
 				die("--file_version has no effect with the command %s\n",
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
2.34.1

