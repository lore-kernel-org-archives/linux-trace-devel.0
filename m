Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE9FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85A926124D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbhKHIHB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 03:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237461AbhKHIHB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 03:07:01 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33422C061714
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Nov 2021 00:04:17 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id w1so59263179edd.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Nov 2021 00:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iDABhojhlXDeMm2SRz2t9YSOHVIBbxjegx4TCV1kuCc=;
        b=RQfLMiMUJnJOgiv4UuUt6/xcHhMbAr03IXJOoJCQ0Uq3DUTLbCHFEhsWT6LEKAwkxc
         EM9sdcU3E8LE3GzSstcgHpIuJXYUxaS4b7mgmpnMN5c5+sva7nwkPfmT4P1Z05o2GyEF
         e97UVurS1GSC9hVj9ATtlDGolSlBIdYG5Xw56pNiGdLG4apvxhTRAOQV6ehSj3iKKGfI
         tJLPF98kp7cBwYjCGdquQmD5kW6WnZOT/HhlOrhxJemveW9g2sG5uIVtihCNzuPhwRrw
         Tu5Z+b00PToyQwitcAdy87tRWDv9ph3cOtzLlts7vmRzIQ4XEtzZbty0260Jo2C0EDVn
         Dj/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iDABhojhlXDeMm2SRz2t9YSOHVIBbxjegx4TCV1kuCc=;
        b=f+R9qsC78lRk3Ck1DqGsCBA6tOzT6whknUG6Ur9gG7CtZGfoQzPBB7OXjI3eCYv9Xz
         RyVm/0/c9lfWFTmFkWEkJKUVLOFt6jRIv5Ve1KZGSqxrV+HFYckFkHuSCXvHq49WZ7ld
         2nu6elz4FCaoK1WH89g8l8f/yKPsat0PbdpaYkvOCggFbJZeIgVEh3JVk2TkVvm/AHc5
         t1UM7bsDDVZh3mGGnrDGKUQhVxf2P9nwRUTzpIxgdCm8HalUtW9eDZLpIs/6O9C8bMgu
         8w75yhiVwo5eWBoTvXsgFNoXjI4xHQQlOjffI42/30Df+Uui2rbWc62IhEpCrf2L+ev6
         L3uQ==
X-Gm-Message-State: AOAM5334cX88BeKrNFw5Ee896RkrvIaCzb0ZpXkTdLrcavKfpawI3ESy
        qvhgDdqpM1a5XoFVsPRNEGGvTr7ih7rEPg==
X-Google-Smtp-Source: ABdhPJwlI2s93hh4V2oVi1Oy/z8xEvvzr3+mIpRQXwfWoILxY/V1gB87DeeisMIttUovk3HUyBm05w==
X-Received: by 2002:a05:6402:b9d:: with SMTP id cf29mr98145974edb.115.1636358655804;
        Mon, 08 Nov 2021 00:04:15 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id mp5sm7962309ejc.68.2021.11.08.00.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:04:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 09/12] libtracefs: Add unit test for synthetic events
Date:   Mon,  8 Nov 2021 10:04:01 +0200
Message-Id: <20211108080404.55814-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211108080404.55814-1-tz.stoyanov@gmail.com>
References: <20211108080404.55814-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All tracefs library APIs should be covered in the unit test. There is
unit test section for the tracefs_sql* set of APIs, which use synthetic
events internally, but no tests for the tracefs_synthetic* APIs.
An initial unit test section is added for tracefs_synthetic* APIs. Not
all APIs are covered, that section should be extended. Unit tests for
basic tracefs_synthetic* APIs are added, to test the changes related to
dynamic events code in the library, related to synthetic events.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 95 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 75ac147..ac840d4 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -403,6 +403,100 @@ static struct tracefs_dynevent **get_dynevents_check(enum tracefs_dynevent_type
 	return devents;
 }
 
+
+struct test_synth {
+	char *name;
+	char *start_system;
+	char *start_event;
+	char *end_system;
+	char *end_event;
+	char *start_match_field;
+	char *end_match_field;
+	char *match_name;
+};
+
+static void test_synth_compare(struct test_synth *synth, struct tracefs_dynevent **devents)
+{
+	enum tracefs_dynevent_type stype;
+	char *format;
+	char *event;
+	int i;
+
+	for (i = 0; devents && devents[i]; i++) {
+		stype = tracefs_dynevent_info(devents[i], NULL,
+					      &event, NULL, NULL, &format);
+		CU_TEST(stype == TRACEFS_DYNEVENT_SYNTH);
+		CU_TEST(strcmp(event, synth[i].name) == 0);
+		if (synth[i].match_name) {
+			CU_TEST(strstr(format, synth[i].match_name) != NULL);
+		}
+	}
+	CU_TEST(devents[i] == NULL);
+}
+
+static void test_instance_syntetic(struct tracefs_instance *instance)
+{
+	struct test_synth sevents[] = {
+		{"synth_1", "sched", "sched_waking", "sched", "sched_switch", "pid", "next_pid", "pid_match"},
+		{"synth_2", "syscalls", "sys_enter_openat2", "syscalls", "sys_exit_openat2", "__syscall_nr", "__syscall_nr", "nr_match"},
+	};
+	int sevents_count = sizeof(sevents) / sizeof((sevents)[0]);
+	struct tracefs_dynevent **devents;
+	struct tracefs_synth **synth;
+	struct tep_handle *tep;
+	int ret;
+	int i;
+
+	synth = calloc(sevents_count + 1, sizeof(*synth));
+
+	tep = tracefs_local_events(NULL);
+	CU_TEST(tep != NULL);
+
+	/* kprobes APIs */
+	ret = tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_SYNTH, true);
+	CU_TEST(ret == 0);
+	get_dynevents_check(TRACEFS_DYNEVENT_SYNTH, 0);
+
+	for (i = 0; i < sevents_count; i++) {
+		synth[i] = tracefs_synth_alloc(tep,  sevents[i].name,
+					       sevents[i].start_system, sevents[i].start_event,
+					       sevents[i].end_system, sevents[i].end_event,
+					       sevents[i].start_match_field, sevents[i].end_match_field,
+					       sevents[i].match_name);
+		CU_TEST(synth[i] != NULL);
+	}
+
+	get_dynevents_check(TRACEFS_DYNEVENT_SYNTH, 0);
+
+	for (i = 0; i < sevents_count; i++) {
+		ret = tracefs_synth_create(synth[i]);
+		CU_TEST(ret == 0);
+	}
+
+	devents = get_dynevents_check(TRACEFS_DYNEVENT_SYNTH, sevents_count);
+	CU_TEST(devents != NULL);
+	test_synth_compare(sevents, devents);
+	tracefs_dynevent_list_free(devents);
+
+	for (i = 0; i < sevents_count; i++) {
+		ret = tracefs_synth_destroy(synth[i]);
+		CU_TEST(ret == 0);
+	}
+
+	get_dynevents_check(TRACEFS_DYNEVENT_SYNTH, 0);
+
+	for (i = 0; i < sevents_count; i++)
+		tracefs_synth_free(synth[i]);
+
+	tep_free(tep);
+	free(synth);
+}
+
+static void test_synthetic(void)
+{
+	test_instance_syntetic(test_instance);
+}
+
 static void test_trace_file(void)
 {
 	const char *tmp = get_rand_str();
@@ -1525,4 +1619,5 @@ void test_tracefs_lib(void)
 	CU_add_test(suite, "ftrace marker",
 		    test_ftrace_marker);
 	CU_add_test(suite, "kprobes", test_kprobes);
+	CU_add_test(suite, "syntetic events", test_synthetic);
 }
-- 
2.31.1

