Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEB9C43214
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4A3E61078
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbhHCRGW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 13:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234376AbhHCRGU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 13:06:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE93361029;
        Tue,  3 Aug 2021 17:06:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxrj-002ubR-Iu; Tue, 03 Aug 2021 13:06:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 02/22] tracefs: Add unit tests for tracefs_sql()
Date:   Tue,  3 Aug 2021 13:05:46 -0400
Message-Id: <20210803170606.694085-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803170606.694085-1-rostedt@goodmis.org>
References: <20210803170606.694085-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add basic unit test for tracefs_sql()...

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 2a99217b938a..89bb1cce61f7 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -44,6 +44,12 @@
 #define KRETPROBE_ADDR	"do_sys_openat2"
 #define KRETPROBE_FMT	"ret=$retval"
 
+#define SQL_1_EVENT	"wakeup_1"
+#define SQL_1_SQL	"select sched_switch.next_pid as woke_pid, sched_waking.common_pid as waking_pid from sched_waking join sched_switch on sched_switch.next_pid = sched_waking.pid"
+
+#define SQL_2_EVENT	"wakeup_2"
+#define SQL_2_SQL	"select woke.next_pid as woke_pid, wake.common_pid as waking_pid from sched_waking as wake join sched_switch as woke on woke.next_pid = wake.pid"
+
 static struct tracefs_instance *test_instance;
 static struct tep_handle *test_tep;
 struct test_sample {
@@ -322,6 +328,41 @@ static void test_ftrace_marker(void)
 	test_instance_ftrace_marker(test_instance);
 }
 
+static void test_instance_trace_sql(struct tracefs_instance *instance)
+{
+	struct tracefs_synth *synth;
+	struct trace_seq seq;
+	struct tep_handle *tep;
+	int ret;
+
+	tep = tracefs_local_events(NULL);
+	CU_TEST(tep != NULL);
+
+	trace_seq_init(&seq);
+
+	synth = tracefs_sql(tep, SQL_1_EVENT, SQL_1_SQL, NULL);
+	CU_TEST(synth != NULL);
+	ret = tracefs_synth_show(&seq, instance, synth);
+	CU_TEST(ret == 0);
+	tracefs_synth_free(synth);
+	trace_seq_reset(&seq);
+
+	synth = tracefs_sql(tep, SQL_2_EVENT, SQL_2_SQL, NULL);
+	CU_TEST(synth != NULL);
+	ret = tracefs_synth_show(&seq, instance, synth);
+	CU_TEST(ret == 0);
+	tracefs_synth_free(synth);
+	trace_seq_reset(&seq);
+
+	tep_free(tep);
+	trace_seq_destroy(&seq);
+}
+
+static void test_trace_sql(void)
+{
+	test_instance_trace_sql(test_instance);
+}
+
 static void test_trace_file(void)
 {
 	const char *tmp = get_rand_str();
@@ -1338,6 +1379,8 @@ void test_tracefs_lib(void)
 		fprintf(stderr, "Suite \"%s\" cannot be ceated\n", TRACEFS_SUITE);
 		return;
 	}
+	CU_add_test(suite, "trace sql",
+		    test_trace_sql);
 	CU_add_test(suite, "tracing file / directory APIs",
 		    test_trace_file);
 	CU_add_test(suite, "instance file / directory APIs",
-- 
2.30.2

