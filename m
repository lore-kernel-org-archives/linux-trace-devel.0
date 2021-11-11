Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31360C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B18A60F94
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhKKPPI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234012AbhKKPPH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:07 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40012C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:18 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id r12so25431942edt.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A0QbvQM6j2lXvTsVng1o2qq/PqDIx5UMKtM885ZAIJk=;
        b=EsVUA/LBZ4//3TJWWeUDmHsCxICRKgj1prdqFUKRH6TnpeQjc1XcCSecYNh/Mj4hI1
         Hm7x99aP5mzSbKMadV2WkcCmlGJdLl6ZoIoK4T4HjhKoioTZcHsTfhFo04m0K0YSTkKf
         RPt5gnJksEtybakSyzynrWh2SblRvzyVgPX1SYPCVoiTA6aoqUzauBJIQD2r9BBeKCAL
         UUANjZ+F1OG3D+p5RmeNGn/wpGv9zA9FYtS6Ae12UkCuJcah9K2fI4WODYByxRlZYM4h
         OAhmups1FXAGXVa5A3jrO4Ovv/VWAZHm9JIWKYVcZ/6whWa/50zKCpXI0WqaRfhsoyn2
         AtmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A0QbvQM6j2lXvTsVng1o2qq/PqDIx5UMKtM885ZAIJk=;
        b=J+elFJ/p6RzcYNFnjduLhsdLmN8IsXkNzFc2VP3iFGuEZpmKcpGKNvr4R8YHZnp8+k
         6WVDAcEFWeJTHopYtqf/dGZl9MPMhmTzr4aesQ16Vzx9bq8WMvBB4tJwvtlDBBoLZA/0
         Ttcs54IEDpeKsa7XpigigZGn3sb0Ih9egrNW8SCVmMCRnsNFddPJKKTbaiR/Tt7p5og+
         LneDZQClJPHls62/AWz6cUtoBA2xk6TVbiHl2NHEAxLLtuT5RL0+PSlJ/NX/GvuqQ+Fb
         L92jKrpXGu4FrKyrON0Jd8lsW5YuEbSJKqYquVME8I+bfrcFHaCRFKlVIccK6sJdUyXs
         hI/Q==
X-Gm-Message-State: AOAM533xc/H+d5bcINA87VCBm5zdvIafp0W4NPvDOo5CX+le7+LkUML/
        ig/oDNijrIlIATqDDzard0m2Uz323Du5GA==
X-Google-Smtp-Source: ABdhPJxZaxBiH5gh8SkFcIYU21aWRRNEGUdLVxDceF8kCPRgmGBvA8XZVqEisIQQ0Hdf0HGY2LKWIg==
X-Received: by 2002:a05:6402:50d0:: with SMTP id h16mr10678054edb.70.1636643536893;
        Thu, 11 Nov 2021 07:12:16 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 20/20] trace-cmd report: Add new parameter for trace file compression
Date:   Thu, 11 Nov 2021 17:11:53 +0200
Message-Id: <20211111151153.86855-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
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
index 98d663f1..cbf51418 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5810,6 +5810,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_compression		= 237,
 	OPT_file_ver		= 238,
 	OPT_verbose		= 239,
 	OPT_tsc2nsec		= 240,
@@ -6250,6 +6251,7 @@ static void parse_record_options(int argc,
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{"poll", no_argument, NULL, OPT_poll},
 			{"verbose", optional_argument, NULL, OPT_verbose},
+			{"compression", required_argument, NULL, OPT_compression},
 			{"file-version", required_argument, NULL, OPT_file_ver},
 			{NULL, 0, NULL, 0}
 		};
@@ -6676,6 +6678,17 @@ static void parse_record_options(int argc,
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

