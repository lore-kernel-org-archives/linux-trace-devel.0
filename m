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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530C2C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 406E2610A6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhINNS2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbhINNS1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:27 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC0EC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:09 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id b6so20150619wrh.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r6lgmGCkcNCWvC0yzxh7nAD0rs8LGbIWc6U6pt0m1uQ=;
        b=bJaVe0Ec51fgupu86UCtSZ84j1ckVCCcm30LqtA489LteI/DHXrnbSY8xeYVT3FxBV
         SyC9wcf698h8+kactdn9023VcJQriCSjFgnHSqhR59NR3M8+IALnSPwRpU6Lp6SbYA5M
         PSkKdxrT1OKk6VPhP79exTm0zzCj+SCrvPpxwCdzS3s54qxQcZTiF/19uk/ac6RX3NMF
         pu3JXuFP0XYKeahXmuZtfs+u7IvXJBJHVLSZJlvF2CSbBgHvoQrmya5nz/Q6DMghaDrU
         gR+x1frk0IMry0AKpgdErt7pWjWWyrxyYFvGIE4YBPxtE3DksQW0j7G8AgCWTmOdxnYC
         iTQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r6lgmGCkcNCWvC0yzxh7nAD0rs8LGbIWc6U6pt0m1uQ=;
        b=BTIYdFNG/Wqck2adH3WLDJg1Sx7kbJ12jUTMDRzn5t8tX6uut34jplZhn77byunzaj
         SAfuoWwhe+fwcR53wko8Yp0h78UOPHdCw2n3dTzkfWWuFK4Z1gimukR+T6gqjy9N0vlX
         G2mGHue4I3f46eSi7CH8LsQcNS6yae5mnJtxUGEG7YB7LQ0gsgR2Wf9AqnfApq+2GIcy
         QwfUPamdAVg9AmgzG8tyMFEnh3pRcJ9JLyAk7R90m8ifCDix+Ch41FlXnzxUHvPPe/7A
         fZV41nd4ywrSZLIqGiJjGb7v6Fr+weAw6e/kB8pR0oEUBPktqbj2++hE1Kp7tqfq9Dev
         23bg==
X-Gm-Message-State: AOAM532XwKG1nLIdnqUw49AAamrq3VCX0Zofxl5jMoF1U/cuS12W9mtf
        lICbserIvuuAHOmDI5zQL8b4qu7zEJ4=
X-Google-Smtp-Source: ABdhPJwf3lqLxazfYrg4PYFlzNdGyXX0NZ/3IgF/YpnkdNRTbhqgZAhEmjaDvTI1eemTZSQ57U5r/A==
X-Received: by 2002:a5d:66d1:: with SMTP id k17mr14331838wrw.200.1631625428412;
        Tue, 14 Sep 2021 06:17:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:17:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 20/20] trace-cmd report: Add new parameter for trace file compression
Date:   Tue, 14 Sep 2021 16:16:45 +0300
Message-Id: <20210914131645.3966308-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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

