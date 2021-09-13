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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829FAC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F1EF60FF2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240008AbhIMMnk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239992AbhIMMnk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:40 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D46DC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:24 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q11so14461576wrr.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r6lgmGCkcNCWvC0yzxh7nAD0rs8LGbIWc6U6pt0m1uQ=;
        b=ZCGLHpsvrtpI2VCNABwY386iFJOmbObTlzVWnfH3kudJal7jVq9z4FkztEcINYrviF
         ythDJAZC4gSSImNefSc4MvQtmta4DgM+JOCIzh/lKf2hJJ95p3f8AGrAIBi6o9n2Tvsq
         s9kEByoEQdcVC1IzIejq2BpiiNVCa0zbqEDK0G4usTzcBeb6ZDpa6vXebW4Vj63AyCsU
         YDKCdBJcKbJFyVvRZY54IaleLGtItPkf4e2kSWEu02gNf6Jua4D/Wre0DXTxYPyRKvxx
         vzgmgGiyGkXgGWhAhhNfW6TPVdqAAk1q/V+Aa4apEdY7kqPOi/sN48HJhg3+VeKpbKyl
         s7gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r6lgmGCkcNCWvC0yzxh7nAD0rs8LGbIWc6U6pt0m1uQ=;
        b=26kOqvvNDz4wo2o8PXIb8HTRlayiVnrPQVgilOCjxFCcadg6zv9nshl00HitVg4Rzu
         DqogkvzoxQaPyWA3ZKG6ijh6qlJM01frFH/vtFo3VqFbpWVZ5sPepMvvzlo7d6m81H85
         TUu8ygtPwJuk37b3u3adQcs5mMMdPfuftYzUx/r5ro/m3KIiOVYc59Np6DOQVzzsLZTl
         UhhlUUSZ5ZVAUPFaYBPKQYXzZ/hnBT23uTjOLPPoPsOe+K/v+TUOBKWUxNJvtvhvpFKp
         P+ClrZB96br8Lw+XQ3QsZc1BNbgg9k1H8R/niBkPZcWK8w9PlT8yiF3quVuuMdb4gebh
         uS3g==
X-Gm-Message-State: AOAM530OK6HG1oDTWc7QMKGxeBj5WALJpkSdzEZfa1XB/oDF1H93EUT2
        hi191zzxnXNMDIVVeOYD4FfyGBYlncM=
X-Google-Smtp-Source: ABdhPJxoGKb0sMHRVD0dqC/Ci009jdAT4i30PA9o2trtv+VjfFrfLhT7IAXn5A5ub5mUOVanyv4GUw==
X-Received: by 2002:a5d:43c8:: with SMTP id v8mr12574336wrr.68.1631536942810;
        Mon, 13 Sep 2021 05:42:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u13sm7244290wrt.41.2021.09.13.05.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:42:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 20/20] trace-cmd report: Add new parameter for trace file compression
Date:   Mon, 13 Sep 2021 15:42:03 +0300
Message-Id: <20210913124203.3677760-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
References: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
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
index 72592c60..dceed783 100644
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
2.31.1

