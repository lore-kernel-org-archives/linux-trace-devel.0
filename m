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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E66C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35EEE61007
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbhD1HrY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236901AbhD1HrY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:47:24 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607AAC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:38 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id mu3so2102193ejc.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gCPiQ92MV/40Nnh6Q8ttCVtErMfxn0E8juNOs7GG/SM=;
        b=o6Sb2+LI0AasmhZM61mPxVgAxcSscRwbs9oHu55h1zjDilw+4waGZDdHP9Z4rAB2h/
         fArXH7Mh8sN7y64OGKb5trSXVpykbDw+dVUMKGtOxfaOJG5LK3S4+pcCl3I4ao20NDKy
         z3kwkAVGGc/nuE8oYpeM+Ylza3/gQzNRgaZqgYvBGuKXGGqw5WmE0ryOKc9zqc0vsJCc
         yXSnVTb/9bmO5/XRvcomCJD4kEl0bbZo3un9TbQ5ndLtzJw9EzCHLgp9gKj6Dp+a3gAc
         xN6gytIrIdsCcFYRlOuFOh2uITVvR9UMzMMMAUjcHR8TTdlxh+i1Gwwfrb15TtOsFUSP
         HCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gCPiQ92MV/40Nnh6Q8ttCVtErMfxn0E8juNOs7GG/SM=;
        b=PYW4zqFOlHfLX282YNDOmaIL8MYtBG1XrGAq/v/4e28WfGVC1Y5QoXEQc5m2n2k9or
         4IWzHZudowdyk5r2qhH3aJsk76WItwPaz8Be7ZvXusSoMRCQBBqCo4pJQLqpOHZDDpfO
         uvmbHdlveqYeca/W25lWKtR4PKgHuDn1zGWTQdiTfxpQJQaDE6vijAG/81QVRpzRs3Nh
         jlheGP/frCqvJ+JDnt73xIJ/WE8Zt1YdGs+vPU4xI/Ry9Z2v64qi0d/zCuJ815j+EzeZ
         mW9SJjh6gDy9EdSwHGqZruXh/OoJ544+qGSdmNNJSViZG4ClSE96MOSisa9YQ7O6c5hD
         sR3w==
X-Gm-Message-State: AOAM530NEwSNsfQPz0AjBQ8dwExyXv8+/v7jTtibSCuWZM6Cx9QP5aFI
        rrIfZpVvQ36pg9QkxiBZ/4w=
X-Google-Smtp-Source: ABdhPJwMVpKGALIvggHNgwKEuLdWZ7cb9F/+HzV/q6Xh5U+ZRmhW9IObHAgRdcmMDyqaj2FbEDK0gA==
X-Received: by 2002:a17:906:4d07:: with SMTP id r7mr19858108eju.224.1619595997094;
        Wed, 28 Apr 2021 00:46:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lc1sm1412556ejb.39.2021.04.28.00.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:46:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/7] trace-cmd listen: Add --verbose
Date:   Wed, 28 Apr 2021 10:46:28 +0300
Message-Id: <20210428074630.757694-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074630.757694-1-tz.stoyanov@gmail.com>
References: <20210428074630.757694-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add new "trace-cmd listen --verbose" argument for setting the desired
log level.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-listen.1.txt | 8 ++++++++
 tracecmd/trace-listen.c                        | 6 ++++++
 tracecmd/trace-usage.c                         | 1 +
 3 files changed, 15 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-listen.1.txt b/Documentation/trace-cmd/trace-cmd-listen.1.txt
index 8697328c..da841867 100644
--- a/Documentation/trace-cmd/trace-cmd-listen.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-listen.1.txt
@@ -36,6 +36,14 @@ OPTIONS
 *-l* 'filename'::
     This option writes the output messages to a log file instead of standard output.
 
+*--verbose* 'level'::
+     Set the log level. Supported log levels are "none", "critical", "error", "warning",
+     "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
+     level to specific value enables all logs from that and all previous levels.
+
+     Example: enable all critical, error and warning logs
+
+      trace-cmd listen --verbose warning
 
 SEE ALSO
 --------
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 0ae1c948..a72365a2 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -916,6 +916,7 @@ static void start_daemon(void)
 }
 
 enum {
+	OPT_verbose	= 254,
 	OPT_debug	= 255,
 };
 
@@ -938,6 +939,7 @@ void trace_listen(int argc, char **argv)
 			{"port", required_argument, NULL, 'p'},
 			{"help", no_argument, NULL, '?'},
 			{"debug", no_argument, NULL, OPT_debug},
+			{"verbose", required_argument, NULL, OPT_verbose},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -967,6 +969,10 @@ void trace_listen(int argc, char **argv)
 		case OPT_debug:
 			tracecmd_set_debug(true);
 			break;
+		case OPT_verbose:
+			if (trace_set_verbose(optarg) < 0)
+				die("invalid verbose level %s", optarg);
+			break;
 		default:
 			usage(argv);
 		}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 10f06467..4c8b1300 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -300,6 +300,7 @@ static struct usage_help usage_help[] = {
 		"          -o file name to use for clients.\n"
 		"          -d directory to store client files.\n"
 		"          -l logfile to write messages to.\n"
+		"          --verbose 'level' Set the desired log level\n"
 	},
 #ifdef VSOCK
 	{
-- 
2.30.2

