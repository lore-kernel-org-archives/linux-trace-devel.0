Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14627C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F228E63218
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhKOKtr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 05:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbhKOKtN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 05:49:13 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350BBC0613B9
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:17 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id m14so70082705edd.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2vIoVHLstu25xuIXqAcJFEhZJRRGdjPstyMmOwVR1K4=;
        b=f9qc/qYNdo3C+VJRV64heXUFu1x99fMk37ADztY3smHbmg/peolXDOTMiNN9qmKctR
         HKEjyFLNFQqYNNar7BKKl6dPI1vRJViOyeAKbICmtgOZfVL7CDlkmL3+oOtkceiTrEwR
         +0VmyR801sdsoplCBChWNB9w8p6nf61ERbfGVc65As9YtxmVoZIUwMajVyikcLwwYH06
         c1zWOcWXB7xE2ek1Kmw1KvQPCRpj5D+1qHOTqhB7+sqPVKpu6xmhto3F7+yNz+H4+XNS
         jwSuEO8mCBXA5DEygoo2BWAMhonySrBB6mVgzUu+ZXmQmyd1p6h6HkHNV3hPHPHO8GvI
         3Tuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2vIoVHLstu25xuIXqAcJFEhZJRRGdjPstyMmOwVR1K4=;
        b=m7GSS+gFXKYOfLxsISsrdmYsDYieRlsqvln0ud63HDs8oMNtQczNuxwx0LlEXRQKTN
         zB2vK7EZ/KTpi7mkrKScCisWpX4wJFSRvLS1FfhYWHjFm1Wjpno1CfyqEuc8W3ITXdSw
         ySJec5hj/8fbpaWSQpiw9QhGS4nAUpAgc8rblq8uUyGacQqXfI6WLMUlMyomNYj4KuGg
         /oMv2Aihqi62dvyc+LbWrLS2w9jPxh+grpPC7FoS5zicySGAEMTTd/cI/0R7VW/V+NJa
         Yp2e48U8e2Cmmwmi12md0Uh2RdHD5TEmyx0LHfZ8ICXUeMcRUsIDC/Khb3arjHERyAtx
         55yQ==
X-Gm-Message-State: AOAM533r/NUHSwEsW0ast6ug9cR4xxlO4wcLqbf8UPLpjd4WQBNMNs6v
        fqZrlh82FRmwu7eP239kw/E=
X-Google-Smtp-Source: ABdhPJxIpSldL4UaovF+QFsWIXWvLSN4XN2vEIP2SwB0SwcTJRW/aZJTDEN1Sh+bJzsFs4YiG7UDoA==
X-Received: by 2002:a05:6402:3513:: with SMTP id b19mr54487313edd.351.1636973175815;
        Mon, 15 Nov 2021 02:46:15 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e12sm6315509ejs.86.2021.11.15.02.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 02:46:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 14/15] libtracefs: Add utest for event probes
Date:   Mon, 15 Nov 2021 12:45:55 +0200
Message-Id: <20211115104556.121359-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115104556.121359-1-tz.stoyanov@gmail.com>
References: <20211115104556.121359-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All library APIs should be covered by the library unit test, that's why
it is extended with new eeven probes tests.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 68 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 2e4084d..96b2baf 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -782,6 +782,73 @@ static void test_kprobes(void)
 	test_kprobes_instance(test_instance);
 }
 
+static void test_eprobes_instance(struct tracefs_instance *instance)
+{
+	struct probe_test etests[] = {
+		{ TRACEFS_DYNEVENT_EPROBE, "e", NULL, "sopen_in", "syscalls.sys_enter_openat",
+					   "file=+0($filename):ustring" },
+		{ TRACEFS_DYNEVENT_EPROBE, "e", "etest", "sopen_out", "syscalls.sys_exit_openat",
+					   "res=$ret:u64" },
+	};
+	int count = sizeof(etests) / sizeof((etests)[0]);
+	struct tracefs_dynevent **deprobes;
+	struct tracefs_dynevent **devents;
+	char *tsys, *tevent;
+	char *tmp, *sav;
+	int ret;
+	int i;
+
+	deprobes = calloc(count + 1, sizeof(*deprobes));
+
+	/* Invalid parameters */
+	CU_TEST(tracefs_eprobe_alloc("test", NULL, "test", "test", "test") == NULL);
+	CU_TEST(tracefs_eprobe_alloc("test", "test", NULL, "test", "test") == NULL);
+	CU_TEST(tracefs_eprobe_alloc("test", "test", "test", NULL, "test") == NULL);
+
+	ret = tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true);
+	CU_TEST(ret == 0);
+	get_dynevents_check(TRACEFS_DYNEVENT_EPROBE, 0);
+
+	for (i = 0; i < count; i++) {
+		tmp = strdup(etests[i].address);
+		tsys = strtok_r(tmp, "./", &sav);
+		tevent = strtok_r(NULL, "", &sav);
+		deprobes[i] = tracefs_eprobe_alloc(etests[i].system, etests[i].event,
+						   tsys, tevent, etests[i].format);
+		free(tmp);
+		CU_TEST(deprobes[i] != NULL);
+	}
+	deprobes[i] = NULL;
+
+	get_dynevents_check(TRACEFS_DYNEVENT_EPROBE, 0);
+	CU_TEST(check_probes(etests, count, deprobes, false, instance));
+
+	for (i = 0; i < count; i++) {
+		CU_TEST(tracefs_dynevent_create(deprobes[i]) == 0);
+	}
+
+	devents = get_dynevents_check(TRACEFS_DYNEVENT_EPROBE, count);
+	CU_TEST(check_probes(etests, count, devents, true, instance));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	for (i = 0; i < count; i++) {
+		CU_TEST(tracefs_dynevent_destroy(deprobes[i], false) == 0);
+	}
+	get_dynevents_check(TRACEFS_DYNEVENT_EPROBE, 0);
+	CU_TEST(check_probes(etests, count, deprobes, false, instance));
+
+	for (i = 0; i < count; i++)
+		tracefs_dynevent_free(deprobes[i]);
+
+	free(deprobes);
+}
+
+static void test_eprobes(void)
+{
+	test_eprobes_instance(test_instance);
+}
+
 static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
@@ -1616,4 +1683,5 @@ void test_tracefs_lib(void)
 		    test_ftrace_marker);
 	CU_add_test(suite, "kprobes", test_kprobes);
 	CU_add_test(suite, "syntetic events", test_synthetic);
+	CU_add_test(suite, "eprobes", test_eprobes);
 }
-- 
2.33.1

