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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADB6C43470
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BD8061007
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbhD1HrY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbhD1HrX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:47:23 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B0AC06138D
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:37 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ja3so17290481ejc.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gnDxFLUXv2fAb0N6Uy5BwAoWTKwHWyzzxSG6P10op0g=;
        b=t/qw2VX9ixjYe2f4yo0RxHtZ4347gpFFGJ4mrKAgiYvlldOiuA3M6Qf3CnAjubw0Yp
         izF4CGoDvewfvk6BGBfeN04ltdcwMMk9+K9ENkl/rdVK+B7mWHAyVEL1WgPPmH1+mUzd
         l79q7h+WTPQaKJ3URCkdqmCtUfVTrgmldLKEPqc7YAZu95n1K8KPcPX96JpIGRURz3dN
         zkQ2NBvvcCARt7cVtv9E3vA/DcrRiHVtEGq0eB02BIJzB6/lLA15Y+mKCWTuZ7KwsA1i
         dYMA6bRiFR4lnmBO0sTUuFBzxVcy/qEugO0UBJCwu5QPTRbWikL298ORMAtzMjE68oIh
         Xs9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gnDxFLUXv2fAb0N6Uy5BwAoWTKwHWyzzxSG6P10op0g=;
        b=kRTxvXtPdcO7QwAFUkxBs3TQ+7cxBO/8Crv8lhoBM8A62tj7kjl7OzkI4ZmSJg4h9T
         x42U1U6XTj6UZnmED5nT9Q6kL7tvKS+DZn6IRVMgp/RN1YHyn2lapQyzmrJ/heecnnvI
         3pdF+LlI24dTJYESXJ+V4QDHa6xOSZw+nsJvkcHCgypdf3SgTmUPJO3VD8wb8qgm7rBW
         Kxy6CrH1C+8yNz5a/pupUebUjlLT34yAK+OZdkxOIcIzt4C2ThOwxZejn012YaLBQ8UV
         BoOLhITPCNjgEgWPtvvk1TUWbKi7/AF4ppjfHUC7dx6vyghoKNLqHWWpPk8Jd5xl1nQN
         vXNA==
X-Gm-Message-State: AOAM532PuME9jsWIX+bpFOGpQV883C0dM9w9t3gwjDW21MNXGJ24DCCU
        tvHTm0Gw68FuML9tkPgVvP4=
X-Google-Smtp-Source: ABdhPJwFu6hzbSzCOfCqNAbDs/ZpJtID8wVbH4M8H8uhy8KoBjjkw5fgZN0ZiXTFfketxv0yrEHptA==
X-Received: by 2002:a17:906:4e93:: with SMTP id v19mr27127476eju.215.1619595996312;
        Wed, 28 Apr 2021 00:46:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lc1sm1412556ejb.39.2021.04.28.00.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:46:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/7] trace-cmd: Add --verbose to bunch of trace-cmd commands
Date:   Wed, 28 Apr 2021 10:46:27 +0300
Message-Id: <20210428074630.757694-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074630.757694-1-tz.stoyanov@gmail.com>
References: <20210428074630.757694-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add new "--verbose" argument for setting the desired log level to these
trace-cmd commands:
 start
 set
 extract
 stream
 profile
 record

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-extract.1.txt | 8 ++++++++
 Documentation/trace-cmd/trace-cmd-profile.1.txt | 9 +++++++++
 Documentation/trace-cmd/trace-cmd-record.1.txt  | 9 +++++++++
 Documentation/trace-cmd/trace-cmd-set.1.txt     | 9 +++++++++
 tracecmd/trace-record.c                         | 6 ++++++
 tracecmd/trace-usage.c                          | 6 ++++++
 6 files changed, 47 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-extract.1.txt b/Documentation/trace-cmd/trace-cmd-extract.1.txt
index 4444733d..88749da7 100644
--- a/Documentation/trace-cmd/trace-cmd-extract.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-extract.1.txt
@@ -67,6 +67,14 @@ OPTIONS
     this is the same as the default. But if *-B* or *-a* is used, this is
     required if the top level instance buffer should also be extracted.
 
+*--verbose* 'level'::
+     Set the log level. Supported log levels are "none", "critical", "error", "warning",
+     "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
+     level to specific value enables all logs from that and all previous levels.
+
+     Example: enable all critical, error and warning logs
+
+      trace-cmd extract --verbose warning
 
 SEE ALSO
 --------
diff --git a/Documentation/trace-cmd/trace-cmd-profile.1.txt b/Documentation/trace-cmd/trace-cmd-profile.1.txt
index 0d1dd8e8..0d285ff7 100644
--- a/Documentation/trace-cmd/trace-cmd-profile.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-profile.1.txt
@@ -90,6 +90,15 @@ These are the same as trace-cmd-record(1) with the *--profile* option.
     is not changed. This allows watching the command execute and saving the
     output of the profile to another file.
 
+*--verbose* 'level'::
+     Set the log level. Supported log levels are "none", "critical", "error", "warning",
+     "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
+     level to specific value enables all logs from that and all previous levels.
+
+     Example: enable all critical, error and warning logs
+
+      trace-cmd profile --verbose warning
+
 EXAMPLES
 --------
 
diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 55a8891b..4c4432de 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -360,6 +360,15 @@ OPTIONS
     executed will not be changed. This is useful if you want to monitor the
     output of the command being executed, but not see the output from trace-cmd.
 
+*--verbose* 'level'::
+     Set the log level. Supported log levels are "none", "critical", "error", "warning",
+     "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
+     level to specific value enables all logs from that and all previous levels.
+
+     Example: enable all critical, error and warning logs
+
+      trace-cmd record --verbose warning
+
 EXAMPLES
 --------
 
diff --git a/Documentation/trace-cmd/trace-cmd-set.1.txt b/Documentation/trace-cmd/trace-cmd-set.1.txt
index 931d3abd..50af7677 100644
--- a/Documentation/trace-cmd/trace-cmd-set.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-set.1.txt
@@ -227,6 +227,15 @@ OPTIONS
     unless the *--fork* option is specified. Then it will fork the command and
     return immediately.
 
+*--verbose* 'level'::
+     Set the log level. Supported log levels are "none", "critical", "error", "warning",
+     "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
+     level to specific value enables all logs from that and all previous levels.
+
+     Example: enable all critical, error and warning logs
+
+      trace-cmd set --verbose warning
+
 EXAMPLES
 --------
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8805b10e..5b1c0d19 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5515,6 +5515,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_verbose		= 239,
 	OPT_tsc2nsec		= 240,
 	OPT_fork		= 241,
 	OPT_tsyncinterval	= 242,
@@ -5949,6 +5950,7 @@ static void parse_record_options(int argc,
 			{"tsync-interval", required_argument, NULL, OPT_tsyncinterval},
 			{"fork", no_argument, NULL, OPT_fork},
 			{"tsc2nsec", no_argument, NULL, OPT_tsc2nsec},
+			{"verbose", required_argument, NULL, OPT_verbose},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -6374,6 +6376,10 @@ static void parse_record_options(int argc,
 		case 'q':
 			quiet = true;
 			break;
+		case OPT_verbose:
+			if (trace_set_verbose(optarg) < 0)
+				die("invalid verbose level %s", optarg);
+			break;
 		default:
 			usage(argv);
 		}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index cacec3c5..10f06467 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -68,6 +68,7 @@ static struct usage_help usage_help[] = {
 		"               If a negative number is specified, timestamps synchronization is disabled"
 		"               If 0 is specified, no loop is performed - timestamps offset is calculated only twice,"
 		"                                                         at the beginnig and at the end of the trace\n"
+		"          --verbose 'level' Set the desired log level\n"
 	},
 	{
 		"set",
@@ -104,6 +105,7 @@ static struct usage_help usage_help[] = {
 		"          --cmdlines-size change kernel saved_cmdlines_size\n"
 		"          --user execute the specified [command ...] as given user\n"
 		"          --fork return immediately if a command is specified\n"
+		"          --verbose 'level' Set the desired log level\n"
 	},
 	{
 		"start",
@@ -113,6 +115,7 @@ static struct usage_help usage_help[] = {
 		"          It only enables the tracing and exits\n"
 		"\n"
 		"        --fork: If a command is specified, then return right after it forks\n"
+		"        --verbose 'level' Set the desired log level\n"
 	},
 	{
 		"extract",
@@ -123,6 +126,7 @@ static struct usage_help usage_help[] = {
 		"          -B : extract a given buffer (more than one may be specified)\n"
 		"          -a : extract all buffers (except top one)\n"
 		"          -t : extract the top level buffer (useful with -B and -a)\n"
+		"          --verbose 'level' Set the desired log level\n"
 	},
 	{
 		"stop",
@@ -241,6 +245,7 @@ static struct usage_help usage_help[] = {
 		"Start tracing and read the output directly",
 		" %s stream [-e event][-p plugin][-d][-O option ][-P pid]\n"
 		"          Uses same options as record but does not write to files or the network.\n"
+		"          --verbose 'level' Set the desired log level\n"
 	},
 	{
 		"profile",
@@ -249,6 +254,7 @@ static struct usage_help usage_help[] = {
 		"    [-H [start_system:]start_event,start_match[,pid]/[end_system:]end_event,end_match[,flags]\n\n"
 		"          Uses same options as record --profile.\n"
 		"          -H Allows users to hook two events together for timings\n"
+		"          --verbose 'level' Set the desired log level\n"
 	},
 	{
 		"hist",
-- 
2.30.2

