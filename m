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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FDBC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1446961407
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhD1HrW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236448AbhD1HrV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:47:21 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C281C06138A
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:34 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id q6so13740247edr.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MA7bV11KcfWFc08/JTkIxuPxVWjkBol++WE3NtkDah4=;
        b=T/Kr0vHCgHVlXWcWgloLbkop34LRdlZBbZ2sYyjJ78GQMmAvU1f6ThtbggEXc7K2JQ
         nau9sCdzG73YzMd0mlnDAT8yOzQ6Sxz2dWIDqxXjfgXNeu15mrAXnYH/1pgAd+zf38Ss
         b9XxGvG0K2bV2rW4xzbHq7I6aj60xMEBFea79nl6ZsmFBn0+HClf6YZvFc0JTPGt4Qdw
         NNfpNCOVGIjjkWd8Zw3Baqy+2GnCkS2iVih2lMK3C3Hy689yJm/KB8e+PJ9mqsLfbUcw
         NZHzM5fMDAVti46SaWMadojcL8Rh3uqUMijhZ8LgWc0JTktHbMDHpTUIpw4guE/up1HV
         /J2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MA7bV11KcfWFc08/JTkIxuPxVWjkBol++WE3NtkDah4=;
        b=h10G9ubSMA5k3HqzKunEzghXLD+T+ZJ7isaNbuCKa7ayZTXfXF1l0b3h5qtZTMwSYg
         ENxjnc6LsQ7yrwfPKqPEyF+StERs4nQhhrnpGrFKn+ImfbTlYq1QoJT8Yatkl3pxidm+
         83zxdZH0yAyQ13ms0y1UthYKYvZWCwd0rDYVZ52OsjwspDyFXZYxyWJU31RQL9Yqwnfr
         UvQ3eSXTxM7jBd8AKwz3e2Np/qPR42JlFWYEC4UKoDxvESD1Wy+ihFN/qQka4cqrLtos
         fUMPtvIZcH8HgaFgrjSu4Ord03NIDLChZ4VsZsgVMRjMDyZRSXGLtzh4hWEWtVo0uDsD
         qglg==
X-Gm-Message-State: AOAM533JYlzQ7wrrr7VmxsiiN0chaqujjuZPq8uEEcQrB3078DpJbcha
        duxNZ714bb/fxaWEqdl0Qi3NifYk+nOnRQ==
X-Google-Smtp-Source: ABdhPJwNho55WFdKm0GwPcxM09+jtDQtw6LAtQtTrJx1sxYOuUuS1PVjspmqb5ogV5Pu270MkGisuQ==
X-Received: by 2002:a05:6402:4388:: with SMTP id o8mr9184888edc.262.1619595993381;
        Wed, 28 Apr 2021 00:46:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lc1sm1412556ejb.39.2021.04.28.00.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:46:32 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/7] trace-cmd report: Add --verbose
Date:   Wed, 28 Apr 2021 10:46:24 +0300
Message-Id: <20210428074630.757694-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074630.757694-1-tz.stoyanov@gmail.com>
References: <20210428074630.757694-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add new "trace-cmd report --verbose" argument for setting the desired
log level.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-report.1.txt | 9 +++++++++
 tracecmd/trace-read.c                          | 6 ++++++
 tracecmd/trace-usage.c                         | 1 +
 3 files changed, 16 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
index 72b47065..e444e8c0 100644
--- a/Documentation/trace-cmd/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
@@ -312,6 +312,15 @@ OPTIONS
 *--raw-ts*::
      Display raw timestamps, without any corrections.
 
+*--verbose* 'level'::
+     Set the log level. Supported log levels are "none", "critical", "error", "warning",
+     "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
+     level to specific value enables all logs from that and all previous levels.
+
+     Example: enable all critical, error and warning logs
+
+      trace-cmd report --verbose warning
+
 EXAMPLES
 --------
 
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index aad57dae..146fdb3c 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1485,6 +1485,7 @@ static void add_hook(const char *arg)
 }
 
 enum {
+	OPT_verbose	= 235,
 	OPT_raw_ts	= 236,
 	OPT_version	= 237,
 	OPT_tscheck	= 238,
@@ -1578,6 +1579,7 @@ void trace_report (int argc, char **argv)
 			{"ts-diff", no_argument, NULL, OPT_tsdiff},
 			{"ts-check", no_argument, NULL, OPT_tscheck},
 			{"raw-ts", no_argument, NULL, OPT_raw_ts},
+			{"verbose", required_argument, NULL, OPT_verbose},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
 		};
@@ -1755,6 +1757,10 @@ void trace_report (int argc, char **argv)
 		case OPT_raw_ts:
 			raw_ts = 1;
 			break;
+		case OPT_verbose:
+			if (trace_set_verbose(optarg) < 0)
+				die("invalid verbose level %s", optarg);
+			break;
 		default:
 			usage(argv);
 		}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 98247074..edc43ba9 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -234,6 +234,7 @@ static struct usage_help usage_help[] = {
 		"          --ts-diff Show the delta timestamp between events.\n"
 		"          --ts-check Check to make sure no time stamp on any CPU goes backwards.\n"
 		"          --raw-ts Display raw timestamps, without any corrections.\n"
+		"          --verbose 'level' Set the desired log level\n"
 	},
 	{
 		"stream",
-- 
2.30.2

