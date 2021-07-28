Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A50C432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FE3261019
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236798AbhG1Ne0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236808AbhG1Ne0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:26 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9040CC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:23 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id v21so4691915ejg.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mbrlD10Y1hBDYOmV/4CQJbgk1L4szY/IgjNe1kinDHA=;
        b=FqMAUFEkyir5JssUPVC8CLwBWKKuwV4KvFVD9PX+UWE1MMwvwLm3uLtiTC+dMcca+t
         /xxArb12KJRHOlS0OAC+KWYliLXZPd7XszTdecE9cy1yoNVFPXkYhKN+ag4HGKKy4AtS
         EMst9Hquul71+TxOSumAqi6k3PnrIJp3Ds41keVUz4tk7G+r0uPhEYJg9CChGklTlwfu
         5uuzYuG3fsbvhgUJBMBrUb2g5rAjlL2ayWTQ3nTPrPaKLzWm400+Ihc+CqXoCqLBiw15
         pMx800bwmD1Np10+YX2oKKaww5PPOg+7IN943kAbdirHKFw7IUV30ZQEc266CBaKPIcE
         ng2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mbrlD10Y1hBDYOmV/4CQJbgk1L4szY/IgjNe1kinDHA=;
        b=fYzhh7r4JMnbrnP2PCzZrwwK8+oJtel76IThEk9Yi+8n7bqx5Tr7Nl10JMwyM4DaXX
         DW9vWb8qJoiPpBgrmv67wm6Z5JRtvGAI8PrXyKb8REWEfR6m/zFiJWdYXHKzbT2uif32
         vzyUNaFCJDokCcxP2Jzp/dxIJnW1Mmk/HpCTrGRxc5cMVTep0Rp9a57CPSIXjQj51PHI
         k98p6kRddH6zB94s2bw1e12vtomIzh3Bv276wk6HNwYnIf7EIIx+VAT86vPh/zj3/nXE
         qJjceCdpv0ISNoEgJ8vCa2uUfcCCA0MRiNhhJxq7W/FokqjrGclLGxVHYukZC8q3jTlw
         ag/Q==
X-Gm-Message-State: AOAM533q4EgWdTlx9n04FLRi+SHEhEbqEket2GHSuq3UkPqk9swttQ57
        6qZZpbv0E80opGoch/AXp54=
X-Google-Smtp-Source: ABdhPJxS+irBc182pGoGcOPOHkzJ0ri+qIBkDOBdDgs3vQST4ANvrt+czop2VbPfy8oZ+rE/Qr/XXg==
X-Received: by 2002:a17:906:4310:: with SMTP id j16mr27946999ejm.182.1627479262208;
        Wed, 28 Jul 2021 06:34:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 83/87] trace-cmd report: Add new parameters for version 7 trace files
Date:   Wed, 28 Jul 2021 16:32:46 +0300
Message-Id: <20210728133250.234140-84-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

By default, "trace-cmd report" writes in trace file version 7 and no
trace file compression. A new parameters are added, which can be used to
set desired verrsion and compression of the output trace file.
 "trace-cmd report --file-version <version> --compression <compression>"

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 28 ++++++++++++++++++++++++++++
 tracecmd/trace-usage.c  |  7 ++++++-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ddab7798..7013aee3 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5810,6 +5810,8 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_file_ver		= 237,
+	OPT_comporession	= 238,
 	OPT_verbose		= 239,
 	OPT_tsc2nsec		= 240,
 	OPT_fork		= 241,
@@ -6249,6 +6251,8 @@ static void parse_record_options(int argc,
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{"poll", no_argument, NULL, OPT_poll},
 			{"verbose", optional_argument, NULL, OPT_verbose},
+			{"compression", required_argument, NULL, OPT_comporession},
+			{"file-version", required_argument, NULL, OPT_file_ver},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6674,6 +6678,30 @@ static void parse_record_options(int argc,
 			cmd_check_die(ctx, CMD_set, *(argv+1), "--poll");
 			recorder_flags |= TRACECMD_RECORD_POLL;
 			break;
+		case OPT_comporession:
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
index 9eb13ecb..ec0af46f 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -69,7 +69,12 @@ static struct usage_help usage_help[] = {
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
 		"          --poll don't block while reading from the trace buffer\n"
-		"          --verbose 'level' Set the desired log level\n"
+		"          --file-version set the desired trace file version\n"
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

