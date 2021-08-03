Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B783FC4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CD8460EB9
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237568AbhHCRGV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 13:06:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237437AbhHCRGU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 13:06:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9AD261050;
        Tue,  3 Aug 2021 17:06:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxrj-002ube-Mw; Tue, 03 Aug 2021 13:06:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 06/22] libtracefs: Add unit test to test tracefs_sql() where clause
Date:   Tue,  3 Aug 2021 13:05:50 -0400
Message-Id: <20210803170606.694085-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803170606.694085-1-rostedt@goodmis.org>
References: <20210803170606.694085-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a test to test filtering of events via the WHERE clause.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 93bc6f16f99a..09bb8f29c191 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -53,6 +53,13 @@
 #define SQL_3_EVENT	"wakeup_lat"
 #define SQL_3_SQL	"select sched_switch.next_prio as prio, end.prev_prio as pprio, (sched.sched_waking.common_timestamp.usecs - end.TIMESTAMP_USECS) as lat from sched_waking as start join sched_switch as end on start.pid = end.next_pid"
 
+#define SQL_4_EVENT	"wakeup_lat_2"
+#define SQL_4_SQL	"select start.pid, end.next_prio as prio, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start join sched_switch as end on start.pid = end.next_pid where (start.prio >= 1 && start.prio < 100) || !(start.pid >= 0 && start.pid <= 1) && end.prev_pid != 0"
+
+#define SQL_5_EVENT	"irq_lat"
+#define SQL_5_SQL	"select end.common_pid as pid, (end.common_timestamp.usecs - start.common_timestamp.usecs) as irq_lat from irq_disable as start join irq_enable as end on start.common_pid = end.common_pid, start.parent_offs == end.parent_offs where start.common_pid != 0"
+#define SQL_5_START	"irq_disable"
+
 static struct tracefs_instance *test_instance;
 static struct tep_handle *test_tep;
 struct test_sample {
@@ -336,6 +343,7 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 	struct tracefs_synth *synth;
 	struct trace_seq seq;
 	struct tep_handle *tep;
+	struct tep_event *event;
 	int ret;
 
 	tep = tracefs_local_events(NULL);
@@ -364,6 +372,23 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
+	synth = tracefs_sql(tep, SQL_4_EVENT, SQL_4_SQL, NULL);
+	CU_TEST(synth != NULL);
+	ret = tracefs_synth_show(&seq, instance, synth);
+	CU_TEST(ret == 0);
+	tracefs_synth_free(synth);
+	trace_seq_reset(&seq);
+
+	event = tep_find_event_by_name(tep, NULL, SQL_5_START);
+	if (event) {
+		synth = tracefs_sql(tep, SQL_5_EVENT, SQL_5_SQL, NULL);
+		CU_TEST(synth != NULL);
+		ret = tracefs_synth_show(&seq, instance, synth);
+		CU_TEST(ret == 0);
+		tracefs_synth_free(synth);
+		trace_seq_reset(&seq);
+	}
+
 	tep_free(tep);
 	trace_seq_destroy(&seq);
 }
-- 
2.30.2

