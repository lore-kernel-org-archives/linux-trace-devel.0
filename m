Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32DCC4361A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Dec 2020 08:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96E7322795
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Dec 2020 08:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgLDIt5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Dec 2020 03:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgLDIt5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Dec 2020 03:49:57 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0616C061A4F
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Dec 2020 00:49:16 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id 3so6255843wmg.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 04 Dec 2020 00:49:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0X4eG/49OxbKTq7FhhZxQUnrSfRSMqzvazDVSEegpaA=;
        b=OvtCspQtEQT+ExjqNYh4vtRsttSOFjYg6M2AWyZ9XhmgGLgCFKVgz561u3ARHZNwQj
         xPcE1JobBdInt+42g6/h7oUXeUzh+1UGwC2b3T/yAEwY29pt3PcqXRdmBIrLch6LS60k
         dwZDl+/KSW8mwb3HI3E5Z3L0qGku/U16sGO1gURIdMlA9AihbtqfDAAaCaRmpTrEsYE3
         S0Zgf9i1ycIyRO7tW3lF7GHsyWz5HpvXMDbaGmiyKKl6jtlFxWtnoyOL+5li/8oln3qK
         VlzbJz18rMBV6QaZnKNiaJjbTr2GmgJ2mhDqQpvJkAtpDb3qkRSrCOE38xKvl7dzKjL4
         YmTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0X4eG/49OxbKTq7FhhZxQUnrSfRSMqzvazDVSEegpaA=;
        b=edy5c3vyE/vSqRlx8xzmzP9votq0o3IQp2QKgNg8MLexD7k5WxYxfP8vJYDaJX9ymG
         sd1ePk+tluyRsreRdQxjWbxWmdPq4mYG03XcjBhast6xQQNRZbmrCNV8lHtdCpqP3mAq
         HxeYA7X1ebprTvXS67Cpm6rMsBrGCvBJDfXKFaiVcrflrLre6Znj16I17E84flDh9zjp
         mXesAEtzCX9WrQ/NWtPVyOGOzsKg0kMKHuZ3XNtTBtHbqfuOpbQG9CkH3jdmCDot3Z/r
         EvBS+DFiMgHizK4DbnzQ5nbtyfY4wNu8VRVU+7mP4YFJDU6Fj96DFvKqtF6dSM1ytCxW
         0YTg==
X-Gm-Message-State: AOAM530VbtdRJoeut48gwpI4qHT8HuAJPYpwN4oFI68MIK9AZfIROLId
        H2epHEPl9d5vm8DODw9Qk11CWrTDV5/SD1Np
X-Google-Smtp-Source: ABdhPJxAYNUUR6NWGW0drl0PBikS74SKlALLfi8hwdy9fJ5Tv4hH3z1xiOlcxcaUz8MhILFEcHXD5Q==
X-Received: by 2002:a1c:e901:: with SMTP id q1mr3007058wmc.148.1607071755419;
        Fri, 04 Dec 2020 00:49:15 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y130sm2377007wmc.22.2020.12.04.00.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 00:49:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Unit test for tracefs_iterate_raw_events() per CPU
Date:   Fri,  4 Dec 2020 10:49:13 +0200
Message-Id: <20201204084913.555490-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

The tracefs_iterate_raw_events() unit test is extended to verify per CPU
iteration.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
This path depends on "libtracefs: Add unit tests" patch.

 utest/tracefs-utest.c | 89 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 70 insertions(+), 19 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 24ea0fc..941b9cf 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -18,25 +18,34 @@
 
 #define TRACEFS_SUITE		"trasefs library"
 #define TEST_INSTANCE_NAME	"cunit_test_iter"
-#define TEST_ARRAY_SIZE		50
+#define TEST_ARRAY_SIZE		500
 
 static struct tracefs_instance *test_instance;
 static struct tep_handle *test_tep;
-static int test_array[TEST_ARRAY_SIZE];
+struct test_sample {
+	int cpu;
+	int value;
+};
+static struct test_sample test_array[TEST_ARRAY_SIZE];
 static int test_found;
 
 static int test_callback(struct tep_event *event, struct tep_record *record,
 			  int cpu, void *context)
 {
 	struct tep_format_field *field;
-	int val, i;
+	struct test_sample *sample;
+	int *cpu_test = (int *)context;
+	int i;
 
+	if (cpu_test && *cpu_test >= 0 && *cpu_test != cpu)
+		return 0;
 	field = tep_find_field(event, "buf");
 	if (field) {
-		val = *((int *)(record->data + field->offset));
+		sample = ((struct test_sample *)(record->data + field->offset));
 		for (i = 0; i < TEST_ARRAY_SIZE; i++) {
-			if (test_array[i] == val) {
-				test_array[i] = 0;
+			if (test_array[i].value == sample->value &&
+			    test_array[i].cpu == cpu) {
+				test_array[i].value = 0;
 				test_found++;
 				break;
 			}
@@ -48,43 +57,85 @@ static int test_callback(struct tep_event *event, struct tep_record *record,
 
 static void test_iter_write(void)
 {
+	int cpus = sysconf(_SC_NPROCESSORS_CONF);
+	cpu_set_t *cpuset, *cpusave;
+	int cpu_size;
 	char *path;
 	int i, fd;
 	int ret;
+	cpuset = CPU_ALLOC(cpus);
+	cpusave = CPU_ALLOC(cpus);
+	cpu_size = CPU_ALLOC_SIZE(cpus);
+	CPU_ZERO_S(cpu_size, cpuset);
+
+	sched_getaffinity(0, cpu_size, cpusave);
 
 	path = tracefs_instance_get_file(test_instance, "trace_marker");
 	CU_TEST(path != NULL);
 	fd = open(path, O_WRONLY);
+	tracefs_put_tracing_file(path);
 	CU_TEST(fd >= 0);
 
 	for (i = 0; i < TEST_ARRAY_SIZE; i++) {
-		test_array[i] = random();
-		ret = write(fd, test_array + i, sizeof(int));
-		CU_TEST(ret == sizeof(int));
+		test_array[i].cpu = rand() % cpus;
+		test_array[i].value = random();
+		if (!test_array[i].value)
+			test_array[i].value++;
+		CU_TEST(test_array[i].cpu < cpus);
+		CPU_ZERO_S(cpu_size, cpuset);
+		CPU_SET(test_array[i].cpu, cpuset);
+		sched_setaffinity(0, cpu_size, cpuset);
+		ret = write(fd, test_array + i, sizeof(struct test_sample));
+		CU_TEST(ret == sizeof(struct test_sample));
 	}
 
-	tracefs_put_tracing_file(path);
+	sched_setaffinity(0, cpu_size, cpusave);
 	close(fd);
 }
 
 
+static void iter_raw_events_on_cpu(int cpu)
+{
+	int check = 0;
+	int ret;
+	int i;
+
+	test_found = 0;
+	test_iter_write();
+	ret = tracefs_iterate_raw_events(test_tep, test_instance, NULL, 0,
+					 test_callback, &cpu);
+	CU_TEST(ret == 0);
+	if (cpu < 0) {
+		CU_TEST(test_found == TEST_ARRAY_SIZE);
+	} else {
+		for (i = 0; i < TEST_ARRAY_SIZE; i++) {
+			if (test_array[i].cpu == cpu) {
+				check++;
+				CU_TEST(test_array[i].value == 0)
+			} else {
+				CU_TEST(test_array[i].value != 0)
+			}
+		}
+		CU_TEST(test_found == check);
+	}
+}
+
 static void test_iter_raw_events(void)
 {
+	int cpus = sysconf(_SC_NPROCESSORS_CONF);
 	int ret;
+	int i;
 
-	ret = tracefs_iterate_raw_events(NULL, test_instance, test_callback, NULL);
+	ret = tracefs_iterate_raw_events(NULL, test_instance, NULL, 0, test_callback, NULL);
 	CU_TEST(ret < 0);
-	ret = tracefs_iterate_raw_events(test_tep, NULL, test_callback, NULL);
+	ret = tracefs_iterate_raw_events(test_tep, NULL, NULL, 0, test_callback, NULL);
 	CU_TEST(ret == 0);
-	ret = tracefs_iterate_raw_events(test_tep, test_instance, NULL, NULL);
+	ret = tracefs_iterate_raw_events(test_tep, test_instance, NULL, 0, NULL, NULL);
 	CU_TEST(ret < 0);
 
-	test_found = 0;
-	test_iter_write();
-	ret = tracefs_iterate_raw_events(test_tep, test_instance,
-					 test_callback, NULL);
-	CU_TEST(ret == 0);
-	CU_TEST(test_found == TEST_ARRAY_SIZE);
+	iter_raw_events_on_cpu(-1);
+	for (i = 0; i < cpus; i++)
+		iter_raw_events_on_cpu(i);
 }
 
 #define RAND_STR_SIZE 20
-- 
2.28.0

