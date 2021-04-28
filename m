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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C0EC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72D2A61158
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236510AbhD1M3d (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 08:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236440AbhD1M3c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 08:29:32 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28103C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:28:48 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l4so94310226ejc.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E3/GLc9HOJghtk+5bbfMzNmXgDl+RfCWLyXeCvn0fco=;
        b=ttiKoRP5AYz9Zz53LyyVqj2PmeTIoGMKMSidLoGBmHo5j6coA8H9CdPI6222l8kp8t
         0cAIgxmjkntOph6lIfpCgQFC83MqpgU8qqOwCYFffwULgUKZqKE3NuOwT8f0ET6vwAg8
         baT0cnA+I/Vr8jZ41N/DVHHZyc4TSDo0IAHt3t5Pwrm9svQ5b5IHm5NYlqexdrbE5yCY
         1dHxkN0KF7dTioumEZh6ONg3gHK9R8Pz+dcy9y7dWbkaQFc4c8nm2DzHGjPKE8gyKBZq
         wlpOW+hXxB6z90rGzbEMQCPYmrCL/5lnjBUf8iZAZOvLdnY8hhaCfTs166P1GNQxzQp8
         79wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E3/GLc9HOJghtk+5bbfMzNmXgDl+RfCWLyXeCvn0fco=;
        b=KAWmki6jtnrJotiQSB8R0w67NJGIKbVOU/nmHWuALmj4oBTaFCs5nPfbb8SAYyfVBh
         tTWxesEPtQLpD3J6Yb+YKrin9nAT39r56GuYXilFdFb8MBnBfSmHNj3nm+o6fYQGHscQ
         Q/9yniSfDDY1VPGbEVM/f3isf9Ics3fllzDOClUoSKW3OJ8vMxnLVcTqvfneNA0Zkz8Z
         LYde7hHy0kimr09F4Vabnvx6RqjZED1YXzMG55492KgFipCEjfcCuuSddN6kQuiYyv4k
         LGJZwv4b7XE9XXu7YUVnY+ZrHCFvZKcXZxTUst8JzfghpbDUeMtGKKQOYMbW6zZULUbW
         xp1Q==
X-Gm-Message-State: AOAM531bvbl7Vf1BGcaHFMiRdJLFGNkKopWfQXSFHuHbsE0aCByGi0aJ
        ZZz6y2/OaCng2+7KyTSBWpU=
X-Google-Smtp-Source: ABdhPJxr94SHnneJvdh4DjMqdGmprKRuRnyhAmmcEAuRtgNvSbj5q/acpfB8ankadwex/N8D963yrg==
X-Received: by 2002:a17:907:7283:: with SMTP id dt3mr28580973ejc.47.1619612926911;
        Wed, 28 Apr 2021 05:28:46 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n10sm1846546ejg.124.2021.04.28.05.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 05:28:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/5] trace-cmd report: New option --align-ts
Date:   Wed, 28 Apr 2021 15:28:39 +0300
Message-Id: <20210428122839.805296-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428122839.805296-1-tz.stoyanov@gmail.com>
References: <20210428122839.805296-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new option is added:
 trace-cmd report --align-ts
It shows timestamps aligned to the first recorded event.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c  | 25 ++++++++++++++++++++++---
 tracecmd/trace-usage.c |  1 +
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index d962b671..4a7bdb9c 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1192,14 +1192,16 @@ enum output_type {
 };
 
 static void read_data_info(struct list_head *handle_list, enum output_type otype,
-			   int global)
+			   int global, int align_ts)
 {
+	unsigned long long ts, first_ts;
 	struct handle_list *handles;
 	struct handle_list *last_handle;
 	struct tep_record *record;
 	struct tep_record *last_record;
 	struct tep_handle *pevent;
 	struct tep_event *event;
+	int first = 1;
 	int ret;
 
 	list_for_each_entry(handles, handle_list, list) {
@@ -1218,7 +1220,12 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		ret = tracecmd_init_data(handles->handle);
 		if (ret < 0)
 			die("failed to init data");
-
+		if (align_ts) {
+			ts = tracecmd_get_first_ts(handles->handle);
+			if (first || first_ts > ts)
+				first_ts = ts;
+			first = 0;
+		}
 		print_handle_file(handles);
 		printf("cpus=%d\n", cpus);
 
@@ -1286,6 +1293,12 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 	if (otype != OUTPUT_NORMAL)
 		return;
 
+	if (align_ts) {
+		list_for_each_entry(handles, handle_list, list) {
+			tracecmd_add_ts_offset(handles->handle, -first_ts);
+		}
+	}
+
 	do {
 		last_handle = NULL;
 		last_record = NULL;
@@ -1485,6 +1498,7 @@ static void add_hook(const char *arg)
 }
 
 enum {
+	OPT_align_ts	= 235,
 	OPT_raw_ts	= 236,
 	OPT_version	= 237,
 	OPT_tscheck	= 238,
@@ -1536,6 +1550,7 @@ void trace_report (int argc, char **argv)
 	int nanosec = 0;
 	int no_date = 0;
 	int raw_ts = 0;
+	int align_ts = 0;
 	int global = 0;
 	int neg = 0;
 	int ret = 0;
@@ -1578,6 +1593,7 @@ void trace_report (int argc, char **argv)
 			{"ts-diff", no_argument, NULL, OPT_tsdiff},
 			{"ts-check", no_argument, NULL, OPT_tscheck},
 			{"raw-ts", no_argument, NULL, OPT_raw_ts},
+			{"align-ts", no_argument, NULL, OPT_align_ts},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
 		};
@@ -1753,6 +1769,9 @@ void trace_report (int argc, char **argv)
 		case OPT_raw_ts:
 			raw_ts = 1;
 			break;
+		case OPT_align_ts:
+			align_ts = 1;
+			break;
 		default:
 			usage(argv);
 		}
@@ -1883,7 +1902,7 @@ void trace_report (int argc, char **argv)
 	/* and version overrides uname! */
 	if (show_version)
 		otype = OUTPUT_VERSION_ONLY;
-	read_data_info(&handle_list, otype, global);
+	read_data_info(&handle_list, otype, global, align_ts);
 
 	list_for_each_entry(handles, &handle_list, list) {
 		tracecmd_close(handles->handle);
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 98247074..97b3aec0 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -234,6 +234,7 @@ static struct usage_help usage_help[] = {
 		"          --ts-diff Show the delta timestamp between events.\n"
 		"          --ts-check Check to make sure no time stamp on any CPU goes backwards.\n"
 		"          --raw-ts Display raw timestamps, without any corrections.\n"
+		"          --align-ts Display timestamps aligned to the first event.\n"
 	},
 	{
 		"stream",
-- 
2.30.2

