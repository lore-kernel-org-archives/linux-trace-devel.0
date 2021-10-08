Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE0EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A409060F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbhJHEYe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhJHEYd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:33 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33376C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:39 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g8so31262127edt.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DmZHkuLjsgT5eWVyHug1kQZkTbOA0cWVB3dmUNlEydc=;
        b=moW4N2QWQMRq1Kstpxc89Yrm0HzmaCbKxk6slB7kPCnvFPwDIHlsNdGSChUOJOGD8K
         KhnLc+zTEVRSNKTpVR1rUjIlvbuIGHPOoI6L7vS6ktQRxydOw6aRzDLVuiIRBsXPFVqG
         qmzUmN/C1Fq8dSq/HJYrSO39EiV0CcBXdFFGgIbnycrEDqLKYp0THAJ13q7g/P11ZLUS
         xUJoaNQ+bl/E2VyuBxgaoG3Ks58tIdaek/APEdxeK1oJ+2FE0At/fH8EgwBQmBG64oFV
         18s6NKsDN1hM03fG3M0miarqzxxm89TfoBYzQIXQjfFsvijeUXJ7EETCaxNA7PYKfQwy
         60/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DmZHkuLjsgT5eWVyHug1kQZkTbOA0cWVB3dmUNlEydc=;
        b=zkQ4eGGf3zSbSVmcIjhCNTcUhpQPX52I3r6HaaKoWzBbpOd181UmtHO7e+YMULMv6T
         jxTpIkdfY3tbf3AYREI05T4B4ZPzg1zASQbbX+3Nq7Gi+v77szyoZAxV9KyhYtxy1ZFn
         3ilQvK39am+9o7Lahu//HNN7DDLK8dkBJGrjyH5vBFSGusWn7usZQ2QSbE9H9fYyT2qs
         lIVG2jH03i8IoMjpZz9+SVN18s6JXjhN17jUzPu4JPQ9+ZjsHmh0CIYPDjEtGUvUhFds
         pEW2KOg1igWJnXuXG8+FoWZVRWu2JHNJQsz8B4LOL92sTLQHn5s6uNCQLahku4Hb/2v6
         avxg==
X-Gm-Message-State: AOAM530gM3ZVbUwndYZnTY458TTjWzus6tBGFMPeTcmdZLLD0ODfETAO
        9cs8+s75oXBepV1A9FNALg+zgx7CDrh9Kg==
X-Google-Smtp-Source: ABdhPJyO+nOfCOgbKdOMYPYFh+ZOhj/lhjfqi4PU1r0myZEvVx9+NzpV8juGaF5Fllhbhf0eWJm7Lg==
X-Received: by 2002:a17:906:2c57:: with SMTP id f23mr1344988ejh.474.1633666957821;
        Thu, 07 Oct 2021 21:22:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 20/20] trace-cmd report: Add new parameter for trace file compression
Date:   Fri,  8 Oct 2021 07:22:14 +0300
Message-Id: <20211008042214.977193-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
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
2.31.1

