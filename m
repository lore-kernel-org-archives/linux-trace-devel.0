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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF48C433EB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B45E61972
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhCVKAe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbhCVKAD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 06:00:03 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1190C061756
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 03:00:02 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u9so20180787ejj.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 03:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wc2CNDZfCEfTInFqm/4fuSskdmNZbg2Y7JHAZmXVQWo=;
        b=YJBepcmpuoSbFcSuwcwhTzEH5c7154a73Me5Nqy2si5cIr5SVqMnRBdJaeX4raSlvv
         NzHGytJkfJlGHi4X79OscVaTnqlRR8JSvbTFZktvnMld8Ddr1j/AI8LMkcR9TJ/QmEnf
         2Fywwh0voh+g4KWxjyWkY7d3PAfM/m4N0sLkVoFW25MX6xRGBBkxKLkkY6Pe5eqX9Uwz
         x9Hp5kjAKZl1MbhTv48MQJ9EukAScWskdt2tWWgUczuIwJvrYECtZwgds/v9Sgjfxetp
         7du2MzpChAD3k5wPqd00PTq2YVi6Fdcxp+To1UAttTGYblfWggQVvRihw7xSXWkHkXEE
         C/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wc2CNDZfCEfTInFqm/4fuSskdmNZbg2Y7JHAZmXVQWo=;
        b=t+wsyvy5nXQA8X3gUax6j5J/APHs78g6wJXmyA7B7bI5u0eBZFUdr7eILj2KbwBQoc
         fTM+T7T0KPq1nhmR8BZApbb5ju8no2xjnC//Vb0Rh6s/lvA6eGQISP5Y+qnjCJtXmPEB
         vgPakgKILOYNZt7PVH5+iODCSa6uSGM2TA/GA8aDLLEpJPxcJg4o2B8ZorEVLqBHP9/N
         zIZelIIt+IKKXd7fiz3NfCUtBu2k5v2g6QBiR1lqjYdt+owYsIeJ1kCatYOZ8UbuDKmI
         1T1Tj4Go3/1lcBJpgiBfaCMIWNI4HDi/Qcz1iqFkYKBPP/f7lE0wgPMIruzODCMtV+8n
         /iag==
X-Gm-Message-State: AOAM532lB9/Ycv298LaQLB6pjNo0vpCB6GCo+SYgihgo89d8KI7eQOmd
        5V/M1dtwysmu5zwUPg3JK5492qODmf65uw==
X-Google-Smtp-Source: ABdhPJz/sg73/MAYRP4ARNOSS4M2uxfUwGSInPAodaSlZwVyE/N3BwGe5rNoLMlRswULDiliz4J0fw==
X-Received: by 2002:a17:907:9862:: with SMTP id ko2mr17993018ejc.222.1616407201544;
        Mon, 22 Mar 2021 03:00:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.03.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 03:00:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 15/18] trace-cmd: Add new parameter "--raw-ts" to "trace-cmd report" command
Date:   Mon, 22 Mar 2021 11:59:42 +0200
Message-Id: <20210322095945.259300-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
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
index 88007cde..256431f0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2934,6 +2934,10 @@ static void extract_trace_clock(struct tracecmd_input *handle, char *line)
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

