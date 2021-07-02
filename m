Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A32C07E9B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 18:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A0F56142C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 18:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhGBS6x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 14:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230198AbhGBS6v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 14:58:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BC3361422;
        Fri,  2 Jul 2021 18:56:18 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzOKn-000hgg-LP; Fri, 02 Jul 2021 14:56:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v6 10/10] libtracefs: Update the unit tests to use the kprobe API instead
Date:   Fri,  2 Jul 2021 14:56:16 -0400
Message-Id: <20210702185616.167778-11-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702185616.167778-1-rostedt@goodmis.org>
References: <20210702185616.167778-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Change the unit test from accessing the kprobe_events file directly and
instead use the new kprobe API instead, and test that.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 195 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 166 insertions(+), 29 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index a982b1d70ef5..49d4c51da1f4 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -28,10 +28,21 @@
 #define TRACE_ON	"tracing_on"
 #define TRACE_CLOCK	"trace_clock"
 
-#define KPROB_EVTS	"kprobe_events"
-#define KPROBE_1	"p:mkdir do_mkdirat path=+u0($arg2):ustring"
-#define KPROBE_1_RM	"-:mkdir"
-#define KPROBE_2	"p:open do_sys_openat2 file=+u0($arg2):ustring flags=+0($arg3):x64"
+#define KPROBE_EVENTS	"kprobe_events"
+
+#define KPROBE_1_NAME	"mkdir"
+#define KPROBE_1_GROUP	"kprobes"
+#define KPROBE_1_ADDR	"do_mkdirat"
+#define KPROBE_1_FMT	"path=+u0($arg2):ustring"
+
+#define KPROBE_2_NAME	"open"
+#define KPROBE_2_GROUP	"myprobe"
+#define KPROBE_2_ADDR	"do_sys_openat2"
+#define KPROBE_2_FMT	"file=+u0($arg2):ustring flags=+0($arg3):x64"
+
+#define KRETPROBE_NAME	"retopen"
+#define KRETPROBE_ADDR	"do_sys_openat2"
+#define KRETPROBE_FMT	"ret=$retval"
 
 static struct tracefs_instance *test_instance;
 static struct tep_handle *test_tep;
@@ -374,19 +385,24 @@ static void test_instance_file(void)
 {
 	struct tracefs_instance *instance = NULL;
 	struct tracefs_instance *second = NULL;
+	enum tracefs_kprobe_type type;
 	const char *name = get_rand_str();
 	const char *inst_name = NULL;
 	const char *tdir;
 	char *inst_file;
 	char *inst_dir;
 	struct stat st;
-	char *kprobes;
+	char **kprobes;
+	char *kformat;
+	char *ktype;
+	char *kaddr;
 	char *fname;
 	char *file1;
 	char *file2;
 	char *tracer;
 	int size;
 	int ret;
+	int i;
 
 	tdir  = tracefs_tracing_dir();
 	CU_TEST(tdir != NULL);
@@ -449,31 +465,152 @@ static void test_instance_file(void)
 	free(file1);
 	free(file2);
 
-	ret = tracefs_instance_file_write(NULL, KPROB_EVTS, KPROBE_1);
-	CU_TEST(ret == strlen(KPROBE_1));
-	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
-	CU_TEST_FATAL(kprobes != NULL);
-	CU_TEST(strstr(kprobes, &KPROBE_1[2]) != NULL);
-	free(kprobes);
-
-	ret = tracefs_instance_file_append(NULL, KPROB_EVTS, KPROBE_2);
-	CU_TEST(ret == strlen(KPROBE_2));
-	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
-	CU_TEST_FATAL(kprobes != NULL);
-	CU_TEST(strstr(kprobes, &KPROBE_2[2]) != NULL);
-	free(kprobes);
-
-	ret = tracefs_instance_file_append(NULL, KPROB_EVTS, KPROBE_1_RM);
-	CU_TEST(ret == strlen(KPROBE_1_RM));
-	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
-	CU_TEST_FATAL(kprobes != NULL);
-	CU_TEST(strstr(kprobes, &KPROBE_1[2]) == NULL);
-	free(kprobes);
-
-	ret = tracefs_instance_file_clear(NULL, KPROB_EVTS);
+	ret = tracefs_kprobe_clear_all(true);
+	CU_TEST(ret == 0);
+	ret = tracefs_kprobe_raw(NULL, KPROBE_1_NAME, KPROBE_1_ADDR, KPROBE_1_FMT);
+	CU_TEST(ret == 0);
+	ret = tracefs_kprobe_raw(KPROBE_2_GROUP, KPROBE_2_NAME, KPROBE_2_ADDR,
+				 KPROBE_2_FMT);
+	CU_TEST(ret == 0);
+
+	ret = tracefs_kretprobe_raw(KPROBE_2_GROUP, KRETPROBE_NAME, KRETPROBE_ADDR,
+				 KRETPROBE_FMT);
 	CU_TEST(ret == 0);
-	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
-	CU_TEST(kprobes == NULL);
+
+	type = tracefs_kprobe_info(KPROBE_1_GROUP, KPROBE_1_NAME, &ktype,
+				   &kaddr, &kformat);
+	CU_TEST(type == TRACEFS_KPROBE);
+	CU_TEST(ktype && *ktype == 'p');
+	CU_TEST(kaddr && strcmp(kaddr, KPROBE_1_ADDR));
+	CU_TEST(kformat && strcmp(kformat, KPROBE_1_FMT));
+	free(ktype);
+	free(kaddr);
+	free(kformat);
+
+	type = tracefs_kprobe_info(KPROBE_2_GROUP, KPROBE_2_NAME, &ktype,
+				   &kaddr, &kformat);
+	CU_TEST(type == TRACEFS_KPROBE);
+	CU_TEST(ktype && *ktype == 'p');
+	CU_TEST(kaddr && strcmp(kaddr, KPROBE_2_ADDR));
+	CU_TEST(kformat && strcmp(kformat, KPROBE_2_FMT));
+	free(ktype);
+	free(kaddr);
+	free(kformat);
+
+	type = tracefs_kprobe_info(KPROBE_2_GROUP, KRETPROBE_NAME, &ktype,
+				   &kaddr, &kformat);
+	CU_TEST(type == TRACEFS_KRETPROBE);
+	CU_TEST(ktype && *ktype == 'r');
+	CU_TEST(kaddr && strcmp(kaddr, KRETPROBE_ADDR));
+	CU_TEST(kformat && strcmp(kformat, KRETPROBE_FMT));
+	free(ktype);
+	free(kaddr);
+	free(kformat);
+
+	kprobes = tracefs_get_kprobes(TRACEFS_ALL_KPROBES);
+	CU_TEST(kprobes != NULL);
+
+	for (i = 0; kprobes[i]; i++) {
+		char *system = strtok(kprobes[i], "/");
+		char *event = strtok(NULL, "");
+		bool found = false;
+		if (!strcmp(system, KPROBE_1_GROUP)) {
+			CU_TEST(!strcmp(event, KPROBE_1_NAME));
+			found = true;
+		} else if (!strcmp(system, KPROBE_2_GROUP)) {
+			switch (tracefs_kprobe_info(system, event, NULL, NULL, NULL)) {
+			case TRACEFS_KPROBE:
+				CU_TEST(!strcmp(event, KPROBE_2_NAME));
+				found = true;
+				break;
+			case TRACEFS_KRETPROBE:
+				CU_TEST(!strcmp(event, KRETPROBE_NAME));
+				found = true;
+				break;
+			default:
+				break;
+			}
+		}
+		CU_TEST(found);
+	}
+	tracefs_list_free(kprobes);
+	CU_TEST(i == 3);
+
+	kprobes = tracefs_get_kprobes(TRACEFS_KPROBE);
+	CU_TEST(kprobes != NULL);
+
+	for (i = 0; kprobes[i]; i++) {
+		char *system = strtok(kprobes[i], "/");
+		char *event = strtok(NULL, "");
+		bool found = false;
+		if (!strcmp(system, KPROBE_1_GROUP)) {
+			CU_TEST(!strcmp(event, KPROBE_1_NAME));
+			found = true;
+		} else if (!strcmp(system, KPROBE_2_GROUP)) {
+			CU_TEST(!strcmp(event, KPROBE_2_NAME));
+			found = true;
+		}
+		CU_TEST(found);
+	}
+	tracefs_list_free(kprobes);
+	CU_TEST(i == 2);
+
+	kprobes = tracefs_get_kprobes(TRACEFS_KRETPROBE);
+	CU_TEST(kprobes != NULL);
+
+	for (i = 0; kprobes[i]; i++) {
+		char *system = strtok(kprobes[i], "/");
+		char *event = strtok(NULL, "");
+		bool found = false;
+		if (!strcmp(system, KPROBE_2_GROUP)) {
+			CU_TEST(!strcmp(event, KRETPROBE_NAME));
+			found = true;
+		}
+		CU_TEST(found);
+	}
+	tracefs_list_free(kprobes);
+	CU_TEST(i == 1);
+
+	ret = tracefs_event_enable(instance, KPROBE_1_GROUP, KPROBE_1_NAME);
+	CU_TEST(ret == 0);
+	ret = tracefs_event_enable(instance, KPROBE_2_GROUP, KPROBE_2_NAME);
+	CU_TEST(ret == 0);
+	ret = tracefs_event_enable(instance, KPROBE_2_GROUP, KRETPROBE_NAME);
+	CU_TEST(ret == 0);
+
+	ret = tracefs_kprobe_clear_all(false);
+	CU_TEST(ret < 0);
+
+	ret = tracefs_kprobe_clear_probe(KPROBE_2_GROUP, NULL, false);
+	CU_TEST(ret < 0);
+
+	ret = tracefs_kprobe_clear_probe(KPROBE_2_GROUP, NULL, true);
+	CU_TEST(ret == 0);
+
+	kprobes = tracefs_get_kprobes(TRACEFS_ALL_KPROBES);
+	CU_TEST(kprobes != NULL);
+
+	for (i = 0; kprobes[i]; i++) {
+		char *system = strtok(kprobes[i], "/");
+		char *event = strtok(NULL, "");
+		bool found = false;
+		if (!strcmp(system, KPROBE_1_GROUP)) {
+			CU_TEST(!strcmp(event, KPROBE_1_NAME));
+			found = true;
+		}
+		CU_TEST(found);
+	}
+	tracefs_list_free(kprobes);
+	CU_TEST(i == 1);
+
+	ret = tracefs_kprobe_clear_all(true);
+	CU_TEST(ret == 0);
+
+	kprobes = tracefs_get_kprobes(TRACEFS_ALL_KPROBES);
+	CU_TEST(kprobes != NULL);
+
+	CU_TEST(kprobes[0] == NULL);
+	tracefs_list_free(kprobes);
 
 	tracefs_put_tracing_file(inst_file);
 	free(fname);
-- 
2.30.2

