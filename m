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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01057C433E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4F2561A28
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhCYGlj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbhCYGlQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:16 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0612C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:15 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id d191so526135wmd.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uREccLdW/J8Jqi6p5cDdjIJ4wcHvy833wlG3mk+0/HU=;
        b=UUBzMWwHvVPXEhrlzrGc6/DdWriZ1DGMvF4cGd48Q40sUDxUS8BPxyCSLOnRxOWwJd
         zWJMmk3bL2gxmSybSYk58ZoaiXbyLu1Qu7347eQIdbVzPvq5UbEsP7qIehi1cROK7x3m
         dPwy8GAvphk6Bnmovv1V0/a7SEtfj0tbpAz7wojibuwgxgPcm5K3vqH9Z3yfWSLt8DWp
         093VkD+A3Zwoa7zXtBKUDB8YWdT7lCQ9tGI3/ZNMRY0ZJ3/5pwYvdJ3RtxbCzImFlcpX
         +WGUmppnb7Q8+fonjbnIDp1GrB/CO3jCxmNoie6PpmLpMZ1EN5p7EaHRZaIPYUcJPi9j
         loFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uREccLdW/J8Jqi6p5cDdjIJ4wcHvy833wlG3mk+0/HU=;
        b=Mh/rJHhlNEcfCkDdbnjUZBQOdl+XZx9SgPKHfKjY5uButEa56oiY20hholuBEJQgF0
         h5SGJxw+kf5dgJori6ZuXz8jrIoJmz0dEkWpzhQw6elDV7ezY+EsnY7rti6kwNnBMeHA
         rRBUXo9m+rhkrJJfPrlLaeTGu3xS1tBxQd9YnGpuwCqnVvcdNmNJtfBYmD0jf4hQZVUf
         7LfDm46Ff+Jf+U1Ke/3u2ySKiLZ0ZuRNUrgfXpxBFwObO0ZprHXg6xkcCM59ujCIA9Kc
         /cmdF5vIJidmVyWDsAq2sG7dUzn2hdc8ueTatEzDfc1QOwGwgw+psAncne8w6modrron
         NS9g==
X-Gm-Message-State: AOAM5329XBIl9lxDNWg7YweVwTUl5Amw8kvdbQ0AL0xZoA9G1x5nLsv2
        slZ7ps0txaXVZQytASHq8Kg=
X-Google-Smtp-Source: ABdhPJwNOr4OfYcB3msA20YmlKkKvxvKeeYesEqIKifXlco539GcGBQ10c2Z5QZuhEAYtmv3z9nj4g==
X-Received: by 2002:a1c:dd43:: with SMTP id u64mr6185252wmg.160.1616654474711;
        Wed, 24 Mar 2021 23:41:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 18/23] trace-cmd: Add new parameter "--raw-ts" to "trace-cmd report" command
Date:   Thu, 25 Mar 2021 08:40:50 +0200
Message-Id: <20210325064055.539554-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

"trace-cmd report --raw-ts" disables all corrections of event timestamps
from the trace file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 ++++
 tracecmd/trace-read.c       | 9 ++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index d9a2b6df..513f6cc3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2932,6 +2932,10 @@ static void extract_trace_clock(struct tracecmd_input *handle, char *line)
 	if (!clock)
 		return;
 
+	/* Clear usecs if raw timestamps are requested */
+	if (handle->flags & TRACECMD_FL_RAW_TS)
+		handle->flags &= ~TRACECMD_FL_IN_USECS;
+
 	/* Clear usecs if not one of the specified clocks */
 	if (strcmp(clock, "local") && strcmp(clock, "global") &&
 	    strcmp(clock, "uptime") && strcmp(clock, "perf") &&
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 22e8635c..1b99db1d 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1484,6 +1484,7 @@ static void add_hook(const char *arg)
 }
 
 enum {
+	OPT_raw_ts	= 236,
 	OPT_version	= 237,
 	OPT_tscheck	= 238,
 	OPT_tsdiff	= 239,
@@ -1533,6 +1534,7 @@ void trace_report (int argc, char **argv)
 	int print_events = 0;
 	int nanosec = 0;
 	int no_date = 0;
+	int raw_ts = 0;
 	int global = 0;
 	int neg = 0;
 	int ret = 0;
@@ -1574,6 +1576,7 @@ void trace_report (int argc, char **argv)
 			{"ts2secs", required_argument, NULL, OPT_ts2secs},
 			{"ts-diff", no_argument, NULL, OPT_tsdiff},
 			{"ts-check", no_argument, NULL, OPT_tscheck},
+			{"raw-ts", no_argument, NULL, OPT_raw_ts},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
 		};
@@ -1746,6 +1749,9 @@ void trace_report (int argc, char **argv)
 		case OPT_tscheck:
 			tscheck = 1;
 			break;
+		case OPT_raw_ts:
+			raw_ts = 1;
+			break;
 		default:
 			usage(argv);
 		}
@@ -1777,7 +1783,8 @@ void trace_report (int argc, char **argv)
 
 		if (no_date)
 			tracecmd_set_flag(handle, TRACECMD_FL_IGNORE_DATE);
-
+		if (raw_ts)
+			tracecmd_set_flag(handle, TRACECMD_FL_RAW_TS);
 		page_size = tracecmd_page_size(handle);
 
 		if (show_page_size) {
-- 
2.30.2

