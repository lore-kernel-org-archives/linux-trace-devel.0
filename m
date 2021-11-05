Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6891CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C4656125F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbhKEMTS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 08:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbhKEMTP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 08:19:15 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC967C061205
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Nov 2021 05:16:35 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r8so13371077wra.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Nov 2021 05:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f28Hri4UHVTUqfdUfWFtIVGUb3NTfrCa+wAJemj+UaU=;
        b=Vqd/IA492W79cHdMHKnRHYdiQi1sSEfNwgjMUKzO6Dy5fGEor2KHGqCw0p+2NTjlLN
         XIGUIBzmwDSUL8jez9VdBqWmfg1zXz7UZs7EBjRVygpT7zm1K52Yq5sjC3PDqkNpXkWn
         NIiLikN8/VboRpgauLl79w0P0761g+5dWGcYHuC6llydqZUquFUBoLH4dIw4mgE5qozB
         lvfD2GE5xn7XZcZolvOum0GjcRdY4K5PqDNeF2xxreuqIpx6dsL2zbK6PK58Q9nMdZK3
         Yvgoi+Ft1vEHmZWRQ0+UXGtAH6xBe1w1TIANUq0jQLhBpGqV7JbZw8IgfXCbBjuz2xNo
         0Hcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f28Hri4UHVTUqfdUfWFtIVGUb3NTfrCa+wAJemj+UaU=;
        b=ahU23C/My/UWNBWd8vCiBdpX7Z3tPUiGKAjDA1xsulEXk487n68+vgPjaEfOZ+RVjh
         DAxeOFFfLqyWtM7q4tHIDlFNynRJBa0ZNRP67T7jqp2hTiOekvbFlQ0DyE23TTJij1t0
         G9fgPOp1Wgem6ZlaftUXYhWxRKihp/GE1fyue5LklCk4Zaf06m61J/lbU4yuWGJ6ZMRz
         yWCHzsr6K4/oKZF7X+a4Mjgtl1vPKFPyDGmQ0csK8KLjrvQYiI+YwJ2OEXfY+kEKXCo4
         apNXkm+S+GfBfenH1xDW8APnl0VPmkKv9nWl9moMNLOk4Aj3tWIu24IXQwZIqBXo/PpS
         VmiA==
X-Gm-Message-State: AOAM531MDpIRVavhDWsWrvpCSUh/JH051kF/+CbwJ8Wdnww6otpMdaNG
        QxqhurDNBHNiXhq1cAWdA/mVSetErdwg2w==
X-Google-Smtp-Source: ABdhPJzGuR8tYUWfE1ptHGkNJnj/FyCUhCfWUj20r82knh4LLN/P1nCtxblAXa7LctSpitB++YJrwg==
X-Received: by 2002:adf:f551:: with SMTP id j17mr71466957wrp.392.1636114594638;
        Fri, 05 Nov 2021 05:16:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x13sm7936531wrr.47.2021.11.05.05.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 05:16:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 08/12] libtracefs: Add unit test for synthetic events
Date:   Fri,  5 Nov 2021 14:16:20 +0200
Message-Id: <20211105121624.398717-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211105121624.398717-1-tz.stoyanov@gmail.com>
References: <20211105121624.398717-1-tz.stoyanov@gmail.com>
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
index 5b656d4..6287f31 100644
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
+		ret = tracefs_synth_create(instance, synth[i]);
+		CU_TEST(ret == 0);
+	}
+
+	devents = get_dynevents_check(TRACEFS_DYNEVENT_SYNTH, sevents_count);
+	CU_TEST(devents != NULL);
+	test_synth_compare(sevents, devents);
+	tracefs_dynevent_list_free(devents);
+
+	for (i = 0; i < sevents_count; i++) {
+		ret = tracefs_synth_destroy(instance, synth[i]);
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

