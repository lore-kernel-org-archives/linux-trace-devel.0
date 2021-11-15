Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FD8C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DB4D63210
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhKOKtW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 05:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237653AbhKOKtH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 05:49:07 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C5EC061766
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:11 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id g14so6181832edb.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5wrs7L2YT+2ElOEXCQbxcUq6Ky9y3xFO6bJvpEM+XDQ=;
        b=i6wseAwOnv32cw9QvxF2uOS5qVCWruwzmlw34nz7qCZJaQq8rFAqFgQsiYlkwpR3sz
         c9SGKIBoAxMwN5BOcfK3hU3KyGWSxU7HPvCgok/M00354NUz0WbLpdwMgMo26qiU+npP
         lvOCE2RVuPHgLGMT75b4UxfoBW7j8hjQyggUVAhIUmO6gCRChFbrvLoln/pKFEYtSdjv
         EiehHSpgN8/Npe4++T3VGo5ox2xdn7WObbVxdEmVqGXnFH3uE360TtPhOwl8FdPXQCnf
         n9wXAU2pUI8Kg/nVRzwp3YtzYbWpevxpcgjDNbWdxuve11xKexNzKUYOUUJfuzGmaTnn
         EDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5wrs7L2YT+2ElOEXCQbxcUq6Ky9y3xFO6bJvpEM+XDQ=;
        b=NUWcyrRK2fCJ947+8qLN7xD51Tm/0hlnqWcv9MyYE9pNA6Lwm9w6yi2am5Dpe9kapu
         dwfymwS1kbJc8l1wmU4b2RETCTQf7KnQUKDStGI1/0Lqt3Nicee8riJyLeVEeuymo+cm
         KvtgPEIaPI/jQa+WCeQn+z/wjmD7muguSXDF7gZNYNE/BKyrvS/qhBP5GF8+brsWSWpB
         UtJV/bA6ZPSZ4kiktGzyssJE1hFNk1LTGFkLd6xrynCQpuSDawT02kn7GoCyTVQPGmAl
         ZCeu6uV7nu8+F6daCEKEoLkLE4Yu13ybrs0tn4K/6FBgPYDN7FxBoi/KL40i72tSKcUT
         Tevg==
X-Gm-Message-State: AOAM532vuK/2IRND2fOkPxeTTQrJFviUugKdHOOOgeVqcMg/W0HCTrE/
        Szh7q+93RAXHgYj9JgIjUNSN2rA7kwogEg==
X-Google-Smtp-Source: ABdhPJzR90ccvZRIjrkDz+WfWftv46PmGV7yJ7sEDv8gW2zVCV9969GpuHy0xSx7nl2nTIn1kklHng==
X-Received: by 2002:a05:6402:1d56:: with SMTP id dz22mr54923727edb.44.1636973169961;
        Mon, 15 Nov 2021 02:46:09 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e12sm6315509ejs.86.2021.11.15.02.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 02:46:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 09/15] libtracefs: Add unit test for synthetic events
Date:   Mon, 15 Nov 2021 12:45:50 +0200
Message-Id: <20211115104556.121359-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115104556.121359-1-tz.stoyanov@gmail.com>
References: <20211115104556.121359-1-tz.stoyanov@gmail.com>
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
index dbb0d26..2e4084d 100644
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
@@ -1521,4 +1615,5 @@ void test_tracefs_lib(void)
 	CU_add_test(suite, "ftrace marker",
 		    test_ftrace_marker);
 	CU_add_test(suite, "kprobes", test_kprobes);
+	CU_add_test(suite, "syntetic events", test_synthetic);
 }
-- 
2.33.1

