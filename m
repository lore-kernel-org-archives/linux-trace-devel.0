Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7DFFA3741
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Oct 2022 18:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiJYScG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 14:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbiJYScF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 14:32:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7360BC4D83
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 11:32:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D1C07CE1EB4
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Oct 2022 18:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3D0C433C1;
        Tue, 25 Oct 2022 18:32:01 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1onOij-007RzC-1J;
        Tue, 25 Oct 2022 14:32:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 4/5] libtracefs utest: Make helper functions for affinity
Date:   Tue, 25 Oct 2022 14:32:11 -0400
Message-Id: <20221025183212.1775523-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221025183212.1775523-1-rostedt@goodmis.org>
References: <20221025183212.1775523-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add helper functions for setting and restoring affinity so that other
tests do not need to reimplement them.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 49 ++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 14 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index f3c06eb3218b..ef59e10431a4 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -87,20 +87,45 @@ static int test_callback(struct tep_event *event, struct tep_record *record,
 	return 0;
 }
 
+static cpu_set_t *cpuset_save;
+static cpu_set_t *cpuset;
+static int cpu_size;
+
+static void save_affinity(void)
+{
+	int cpus;
+
+	cpus = sysconf(_SC_NPROCESSORS_CONF);
+	cpuset_save = CPU_ALLOC(cpus);
+	cpuset = CPU_ALLOC(cpus);
+	CU_TEST(cpuset_save != NULL && cpuset != NULL);
+	CU_TEST(sched_getaffinity(0, cpu_size, cpuset_save) == 0);
+}
+
+static void reset_affinity(void)
+{
+	sched_setaffinity(0, cpu_size, cpuset_save);
+	CPU_FREE(cpuset_save);
+	CPU_FREE(cpuset);
+}
+
+static void set_affinity(int cpu)
+{
+	CPU_ZERO_S(cpu_size, cpuset);
+	CPU_SET_S(cpu, cpu_size, cpuset);
+	CU_TEST(sched_setaffinity(0, cpu_size, cpuset) == 0);
+	sched_yield(); /* Force schedule */
+}
+
 static void test_iter_write(struct tracefs_instance *instance)
 {
-	int cpus = sysconf(_SC_NPROCESSORS_CONF);
-	cpu_set_t *cpuset, *cpusave;
-	int cpu_size;
 	char *path;
 	int i, fd;
+	int cpus;
 	int ret;
-	cpuset = CPU_ALLOC(cpus);
-	cpusave = CPU_ALLOC(cpus);
-	cpu_size = CPU_ALLOC_SIZE(cpus);
-	CPU_ZERO_S(cpu_size, cpuset);
 
-	sched_getaffinity(0, cpu_size, cpusave);
+	cpus = sysconf(_SC_NPROCESSORS_CONF);
+	save_affinity();
 
 	path = tracefs_instance_get_file(instance, "trace_marker");
 	CU_TEST(path != NULL);
@@ -114,17 +139,13 @@ static void test_iter_write(struct tracefs_instance *instance)
 		if (!test_array[i].value)
 			test_array[i].value++;
 		CU_TEST(test_array[i].cpu < cpus);
-		CPU_ZERO_S(cpu_size, cpuset);
-		CPU_SET(test_array[i].cpu, cpuset);
-		sched_setaffinity(0, cpu_size, cpuset);
+		set_affinity(test_array[i].cpu);
 		ret = write(fd, test_array + i, sizeof(struct test_sample));
 		CU_TEST(ret == sizeof(struct test_sample));
 	}
 
-	sched_setaffinity(0, cpu_size, cpusave);
+	reset_affinity();
 	close(fd);
-	CPU_FREE(cpuset);
-	CPU_FREE(cpusave);
 }
 
 
-- 
2.35.1

