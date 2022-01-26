Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B72C63697
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239373AbiAZJth (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiAZJth (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:37 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453C2C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:37 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r10so37154510edt.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o1dPS++T4SCzL6Tv2ykDGLR6+0iSblj6lg3YJUuewAM=;
        b=lPgQC1XGm1rcRwa08hfzQg9UxmSg00VMtyruRsbYPiq6qAw1csfQe3xfFUeh86+nCY
         EcyHSNxEGyrhpDJH8ZA9Q3IyevM0BaQUaze4h8+uMyX/MIvojxl7ETSsQ7356zinSg9Q
         LBdwfT1FGOf/SUSjz1rsN7VlwdWhDKerdQ+oOkJM35abK3zR19Ljxt0nf2pHay+9xdve
         wBKg7lrG7u8Os1Gi0kEjRkfVtwBGlpBvCe4dpDwjB9eWx4aGtwM7QxaVtoQk7Sy0k3Qb
         OUFsWlwhzqYJYsxUETC4100kve4Ruudm4Nx/0wHjdn47X6452xceD8RLQdW4fzbXbCUA
         UXKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o1dPS++T4SCzL6Tv2ykDGLR6+0iSblj6lg3YJUuewAM=;
        b=rhhnbOH7sWx5z542HYO1p7nCaRLB77i9aDZKLes8NCTl+gEwJGwysU/3Gao87q1C8E
         stVcQyaSs5n3tNYhleuo3Jx8CKFzIgsuuQGc1/nQzI5/ON5VBU9G71gHtajZ4U5Q1ZAs
         SdHzvxqQw8tSrQpqyice82qtUeLKtn7G7yp4r67XBwIMaPrLn8Z8vKJkM7OqXMDnHatP
         XIqb2gUfX+7jztEXig6zwG1S3XfpMoS8lcWFUasKrr5T5ltstH2D2KWAZOcP4y/vVXbW
         uh/4IScQIqYi9uK+j3vSv5vAffZyE8SnRGy1SboO7pX5Yt3W2Wy10HKAO3TBL9GkIGkY
         iM6w==
X-Gm-Message-State: AOAM532eLsp6CmVxqSJmsU3hh1pTyydA9GDY8aJ6//1pnUDga13vBGFV
        muIhZiWp4MkkDuIWF9tigP1cHIgucUY=
X-Google-Smtp-Source: ABdhPJyg+V4quOC3b8IM4BjG/iGC5wNvfvDuxafbxD8dTCWSluOeo9bPJp4S+TgsfySCzRZeN7qJUw==
X-Received: by 2002:a05:6402:1bc6:: with SMTP id ch6mr24438552edb.336.1643190575831;
        Wed, 26 Jan 2022 01:49:35 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:35 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 20/20] trace-cmd report: Add new parameter for trace file compression
Date:   Wed, 26 Jan 2022 11:49:06 +0200
Message-Id: <20220126094906.570451-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
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
index 4df97d7d..5dd769d1 100644
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

