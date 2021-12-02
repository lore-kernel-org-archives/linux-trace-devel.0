Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2B5C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhLBM2w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237026AbhLBM2v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:51 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52960C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:29 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id o20so114585151eds.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qi9ZOCkkrI67lvo79BJ1FoEwbE7E/NHK8slqqwg02jo=;
        b=Xy5ECM3AbItrKVrpsEMNlAX+b5R3ai66t1OxnTECOJ+rYdlpiKwFdYE7EabFHeud/C
         0ZSavHfND/Fn6vwk2PQGAuimDC6T5t5EZ+twlqwLU83tw5VYsoms9JxpQbGY6xSvoHSa
         zc1ZPH6ZmsRUbYQdqNkOW3fLIss//42JcV8m4B7NAHJiCUEjXodpRxrJYN5Mnj08bLgY
         7rzkBvy62jXLe2JkjXi3TtxXjCbsgRO+RkHCpE5ODToB+aem3rGS/aTzObW0I/cW2TCO
         kTyyifLx8J6/+E9NCtssCWzLIT2WT0RLpbJiVD9bJMWji5cPZfm8wB1fUUx1VO/D3r0u
         auUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qi9ZOCkkrI67lvo79BJ1FoEwbE7E/NHK8slqqwg02jo=;
        b=s/fXQCEITGNNeTuvPBI2gjYoXZsOw/AL4XCOaNMpJhYHKYwHuNcIvdFnIuP+eAAMuv
         k7TRGhUUPdctzrj6k6d9Z+HGMUY+fBqEqYGAkAsNK8v+H2C9HNqc16gDJWTIFWvPaH7H
         ZOYBc1B4ZHIbKpyY0V0/4eUQi73PmDVe86np2UO3dxWiLOB1HSfbresJtG3Eo1zEK+8l
         I0rKeS6JBPy42p8ePRh8gbaBlZquLkS6jMQRQ+Y2zeS6DoI9t12D/z8dqlVt9ieNKkvw
         4ijmFCsDRVMPUf9YoCypATud5o4UkmppoMiWLnefcqee0dsupzcVpD3dsm6wZ6iUms/G
         /svw==
X-Gm-Message-State: AOAM533j1Zf1pBMh5RH96YylWeBgKyQ/CcoHcckC/u/8BaCLhqohbIcV
        TGsuymDk7/XUpSnhbnc7XUymq0k2216p5Q==
X-Google-Smtp-Source: ABdhPJwz+FMsMU1cWWBDxpq3tm2qDX+aC27vOBhD8QapKpEkd+03JKSEDrM9UFuHWyhCV8iMxHabOg==
X-Received: by 2002:a05:6402:278e:: with SMTP id b14mr17370279ede.354.1638447927873;
        Thu, 02 Dec 2021 04:25:27 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 20/20] trace-cmd report: Add new parameter for trace file compression
Date:   Thu,  2 Dec 2021 14:25:07 +0200
Message-Id: <20211202122507.43572-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
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
index 9c799197..379b92d4 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5803,6 +5803,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_compression		= 237,
 	OPT_file_ver		= 238,
 	OPT_verbose		= 239,
 	OPT_tsc2nsec		= 240,
@@ -6243,6 +6244,7 @@ static void parse_record_options(int argc,
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
 			{"poll", no_argument, NULL, OPT_poll},
 			{"verbose", optional_argument, NULL, OPT_verbose},
+			{"compression", required_argument, NULL, OPT_compression},
 			{"file-version", required_argument, NULL, OPT_file_ver},
 			{NULL, 0, NULL, 0}
 		};
@@ -6669,6 +6671,17 @@ static void parse_record_options(int argc,
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

