Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D9BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Mar 2022 09:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239632AbiC1JFk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Mar 2022 05:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239637AbiC1JFi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Mar 2022 05:05:38 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5FE6356
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Mar 2022 02:03:55 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id u26so16057509eda.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Mar 2022 02:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4cQlmkS7/uVCOtTEk8cBfqFy5x6T1JTgV+3GShSO0KI=;
        b=Fe6TwUiljdxIYdJxTRf8oeNNlYEnq5dJMTxS5NvriqySviel97BxTfjm/dg+9wDJAJ
         fjGVyKe7hgIYP1EMUilIPIQ6BnsdO91Z+dTk3S09U/cyprA9ul5AS/P4DDtiOmtHr+vt
         cxosgzETjQmucUlyHVwWh2QWetSAKuizsbl5KTchB1/RtZC1+Dt0U0VQmSW27pWHVbDt
         QzIglqzh4grt/T3fSZQ94NK+P9xiELapZ7YGaeTml7xYbwLQZCuUyPyDqm6ePXLqW39n
         zSrh0IWnzfImi/04MdZGh0GFHloTluQ0y5PmrRcvCprzsagSob0+WeRp6o2zPylyj4n/
         Lkmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4cQlmkS7/uVCOtTEk8cBfqFy5x6T1JTgV+3GShSO0KI=;
        b=vsy08KZxWnqVLm1UQDs0EKs/RH15IbTUh32yA7U7hFlFhDTRlstAhoeFweV+GHC1ap
         MqyKRN0NtZzNBLUM9vjziprLuCBpXb7G6lsz+VXIL4rnXeX3Y52jfHAidHosXJ5RtoV5
         dMDlyGPXlxX3u88BNBCqD4XNEBmV17T5MtPrdJMx9g1FuWsOondCBrQL1F4CaN1h1Ck5
         P6Ty4vH6Xa+bsSingZkgPzEVZTGJ5j/BM4lvK7jBYdvPYEK2mJcSnJPLrqEA8bsCE/e9
         ybxEg7MvgOTinypr+9AqQ1ptydfTBR57BGpBxNvC30E5CE4opDgcAd14ho759Z8YN44A
         XH7g==
X-Gm-Message-State: AOAM532YUjQy1cus6GvtZAoe7RZQQYMmHDKd3Inub88kJSc6Ck8Bvey/
        PY+e1W5rcKlhBSIjXq6OWv/JgOCGi90=
X-Google-Smtp-Source: ABdhPJz+HoZTYolv6giDHYYlrdQ4++Q6+IsZZdn52Z/paGA7Lz7slRa599Hao1HCIc4DKidhagFs2w==
X-Received: by 2002:a05:6402:492:b0:404:c4bf:8b7e with SMTP id k18-20020a056402049200b00404c4bf8b7emr14425248edv.318.1648458233560;
        Mon, 28 Mar 2022 02:03:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dm11-20020a170907948b00b006cf488e72e3sm5647973ejc.25.2022.03.28.02.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 02:03:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] libtracefs: Unit tests for uprobes APIs
Date:   Mon, 28 Mar 2022 12:03:47 +0300
Message-Id: <20220328090347.107849-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220328090347.107849-1-tz.stoyanov@gmail.com>
References: <20220328090347.107849-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The newly introduced uprobes APIs should be covered by the library unit
tests.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/tracefs-utest.c | 74 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 7042fa9..3f63837 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -873,6 +873,79 @@ static void test_eprobes(void)
 	test_eprobes_instance(test_instance);
 }
 
+#define FOFFSET 1000ll
+static void test_uprobes_instance(struct tracefs_instance *instance)
+{
+	struct probe_test utests[] = {
+		{ TRACEFS_DYNEVENT_UPROBE, "p", "utest", "utest_u", NULL, "arg1=$stack2" },
+		{ TRACEFS_DYNEVENT_URETPROBE, "r", "utest", "utest_r", NULL, "arg1=$retval" },
+	};
+	int count = sizeof(utests) / sizeof((utests)[0]);
+	struct tracefs_dynevent **duprobes;
+	struct tracefs_dynevent **duvents;
+	char self[PATH_MAX] = { 0 };
+	struct tep_handle *tep;
+	char *target = NULL;
+	int i;
+
+	tep = tep_alloc();
+	CU_TEST(tep != NULL);
+
+	duprobes = calloc(count + 1, sizeof(*duvents));
+	CU_TEST(duprobes != NULL);
+	CU_TEST(readlink("/proc/self/exe", self, sizeof(self)) > 0);
+	CU_TEST(asprintf(&target, "%s:0x%0*llx", self, (int)(sizeof(void *) * 2), FOFFSET) > 0);
+
+	for (i = 0; i < count; i++)
+		utests[i].address = target;
+
+	/* Invalid parameters */
+	CU_TEST(tracefs_uprobe_alloc(NULL, NULL, self, 0, NULL) == NULL);
+	CU_TEST(tracefs_uprobe_alloc(NULL, "test", NULL, 0, NULL) == NULL);
+	CU_TEST(tracefs_uretprobe_alloc(NULL, NULL, self, 0, NULL) == NULL);
+	CU_TEST(tracefs_uretprobe_alloc(NULL, "test", NULL, 0, NULL) == NULL);
+
+	for (i = 0; i < count; i++) {
+		if (utests[i].type == TRACEFS_DYNEVENT_UPROBE)
+			duprobes[i] = tracefs_uprobe_alloc(utests[i].system, utests[i].event,
+							   self, FOFFSET, utests[i].format);
+		else
+			duprobes[i] = tracefs_uretprobe_alloc(utests[i].system, utests[i].event,
+							      self, FOFFSET, utests[i].format);
+		CU_TEST(duprobes[i] != NULL);
+	}
+	duprobes[i] = NULL;
+
+	get_dynevents_check(TRACEFS_DYNEVENT_UPROBE | TRACEFS_DYNEVENT_URETPROBE, 0);
+	CU_TEST(check_probes(utests, count, duprobes, false, instance, tep));
+
+	for (i = 0; i < count; i++) {
+		CU_TEST(tracefs_dynevent_create(duprobes[i]) == 0);
+	}
+
+	duvents = get_dynevents_check(TRACEFS_DYNEVENT_UPROBE | TRACEFS_DYNEVENT_URETPROBE, count);
+	CU_TEST(check_probes(utests, count, duvents, true, instance, tep));
+	tracefs_dynevent_list_free(duvents);
+
+	for (i = 0; i < count; i++) {
+		CU_TEST(tracefs_dynevent_destroy(duprobes[i], false) == 0);
+	}
+	get_dynevents_check(TRACEFS_DYNEVENT_UPROBE | TRACEFS_DYNEVENT_URETPROBE, 0);
+	CU_TEST(check_probes(utests, count, duprobes, false, instance, tep));
+
+	for (i = 0; i < count; i++)
+		tracefs_dynevent_free(duprobes[i]);
+
+	free(duprobes);
+	free(target);
+	tep_free(tep);
+}
+
+static void test_uprobes(void)
+{
+	test_uprobes_instance(test_instance);
+}
+
 static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
@@ -1708,4 +1781,5 @@ void test_tracefs_lib(void)
 	CU_add_test(suite, "kprobes", test_kprobes);
 	CU_add_test(suite, "synthetic events", test_synthetic);
 	CU_add_test(suite, "eprobes", test_eprobes);
+	CU_add_test(suite, "uprobes", test_uprobes);
 }
-- 
2.35.1

