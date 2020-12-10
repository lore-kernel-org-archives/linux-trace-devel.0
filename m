Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A7CC4361B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48F0823C43
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Dec 2020 02:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgLJCbH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 21:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728686AbgLJCbG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 21:31:06 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA8C823D21;
        Thu, 10 Dec 2020 02:29:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1knBiB-0004An-Ql; Wed, 09 Dec 2020 21:29:43 -0500
Message-ID: <20201210022943.700735522@goodmis.org>
User-Agent: quilt/0.66
Date:   Wed, 09 Dec 2020 21:29:12 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir (VMware)  Stoyanov" <tz.stoyanov@gmail.com>
Subject: [PATCH 6/9] libtracefs: Unit test for tracefs_iterate_raw_events() per CPU
References: <20201210022906.112066412@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir (VMware) Stoyanov" <tz.stoyanov@gmail.com>

The tracefs_iterate_raw_events() unit test is extended to verify per CPU
iteration.

Link: https://lore.kernel.org/linux-trace-devel/20201204084913.555490-1-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 89 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 70 insertions(+), 19 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 78eda481190f..e7d637f523a7 100644
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
2.29.2


