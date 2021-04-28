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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 938EEC43460
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DE5E606A5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236453AbhD1HrX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbhD1HrV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:47:21 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A104AC06138C
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:36 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id t4so9892023ejo.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7G682/KnhlYStPg0ZV0KAKS4OzGXjPQxgHk3OUPpD48=;
        b=TKBT79w/tjqn/ZAwBkFQTnnEvS68tYmrkyM6T9ytN8+nRU3As3Y8Rd4KFP56xcgLzq
         D/YIKX6w5w2Xw1AnShuZh6sDaLHolVy7q8AP48PTQ1vknCZw7O9U/zjBN2IdEOM99eyc
         VqKDBOLeqMnI0shYNb4YNUmSYUTMANWiQnYR1b/wI1OLkMAt5zicgY4LszowAHoGxMcF
         i3/ivvwhb597RYD8o/Fi36Am1H3cHWOEIUMs5YOWP9A2m9m6Zdh2uYWK2MwuZWokJg88
         WhgoYFP5u2pDcvPWhHNmB51kaKiUcZvQ34GOH3DtXdds//HyLFkl3etX1nFu7nGQRw/v
         Hvtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7G682/KnhlYStPg0ZV0KAKS4OzGXjPQxgHk3OUPpD48=;
        b=fwUhg9+Aw9JmIXo0NiWmKwxzIg+U+FKNLUIfg6K4r3QXmMUyj1MdseSyKxblmLgwYK
         xm8Dsq4wow9aeZkW2LJJDZwNA3H6iFglCF9H8yAxkAjqpqgFifVfQ1a9Q4GqsdgAJCAP
         u+gfd6Lj6nMkZLb4vBjPkIm1oNozbo+iMSWlhmEyxVqxz2+4IFiPYrZXZJ5VQSHF9zDQ
         O30rG2UdyO3fKWkTtAFL2y9fGWEGyMMMcJ2QVk5ASSqn0nkBF2fLy75s9xmAa8XeaFAa
         gN6gST+7UKk8/n5p7x1ardS/NMM1DES0ouqD1FsvO6Dh2qtjo/uF+BwmstVj0VHnlA6I
         Ldzw==
X-Gm-Message-State: AOAM530xI7d0ho5IDyXGaQiSWEzClY1bChcavsC/1dGI6Ag2ch0n/+xD
        t58+pbHZxScblrN7Gof75Ds=
X-Google-Smtp-Source: ABdhPJw9cVFj2NgSII3G8dpONpsBychxnzvJODpicYxTK3BH3A0TU/tmwIOuF7pUd81gEFzgW+oljw==
X-Received: by 2002:a17:906:2287:: with SMTP id p7mr20521931eja.377.1619595995395;
        Wed, 28 Apr 2021 00:46:35 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lc1sm1412556ejb.39.2021.04.28.00.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:46:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/7] trace-cmd check-events: Add --verbose
Date:   Wed, 28 Apr 2021 10:46:26 +0300
Message-Id: <20210428074630.757694-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074630.757694-1-tz.stoyanov@gmail.com>
References: <20210428074630.757694-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add new "trace-cmd check-events --verbose" argument for setting the desired
log level.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../trace-cmd/trace-cmd-check-events.1.txt       |  9 +++++++++
 tracecmd/trace-check-events.c                    | 16 +++++++++++++++-
 tracecmd/trace-usage.c                           |  1 +
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace-cmd/trace-cmd-check-events.1.txt b/Documentation/trace-cmd/trace-cmd-check-events.1.txt
index c98ff3c6..40c3c8cd 100644
--- a/Documentation/trace-cmd/trace-cmd-check-events.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-check-events.1.txt
@@ -24,6 +24,15 @@ OPTIONS
 -------
 *-N* - Don't load plugins
 
+*--verbose* 'level'::
+     Set the log level. Supported log levels are "none", "critical", "error", "warning",
+     "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
+     level to specific value enables all logs from that and all previous levels.
+
+     Example: enable all critical, error and warning logs
+
+      trace-cmd check-events --verbose warning
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-stop(1),
diff --git a/tracecmd/trace-check-events.c b/tracecmd/trace-check-events.c
index bd19feca..cf34912a 100644
--- a/tracecmd/trace-check-events.c
+++ b/tracecmd/trace-check-events.c
@@ -10,6 +10,10 @@
 #include "tracefs.h"
 #include "trace-local.h"
 
+enum {
+	OPT_verbose	= 255,
+};
+
 void trace_check_events(int argc, char **argv)
 {
 	const char *tracing;
@@ -18,8 +22,14 @@ void trace_check_events(int argc, char **argv)
 	struct tep_handle *pevent = NULL;
 	struct tep_plugin_list *list = NULL;
 	int open_flags = 0;
+	int option_index = 0;
+	static struct option long_options[] = {
+		{"verbose", required_argument, NULL, OPT_verbose},
+		{NULL, 0, NULL, 0}
+	};
+
 
-	while ((c = getopt(argc-1, argv+1, "+hN")) >= 0) {
+	while ((c = getopt_long(argc-1, argv+1, "+hN", long_options, &option_index)) >= 0) {
 		switch (c) {
 		case 'h':
 		default:
@@ -28,6 +38,10 @@ void trace_check_events(int argc, char **argv)
 		case 'N':
 			open_flags |= TRACECMD_FL_LOAD_NO_PLUGINS;
 			break;
+		case OPT_verbose:
+			if (trace_set_verbose(optarg) < 0)
+				die("invalid verbose level %s", optarg);
+			break;
 		}
 	}
 	tracing = tracefs_tracing_dir();
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 7019ab97..cacec3c5 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -363,6 +363,7 @@ static struct usage_help usage_help[] = {
 		"parse trace event formats",
 		" %s check-events [-N]\n"
 		"          -N do not load any plugins\n"
+		"          --verbose 'level' Set the desired log level\n"
 	},
 	{
 		"dump",
-- 
2.30.2

