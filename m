Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CDEC4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D8146108E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhG3WTY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Jul 2021 18:19:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232956AbhG3WSk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Jul 2021 18:18:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B436361077;
        Fri, 30 Jul 2021 22:18:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m9apt-002V1C-F5; Fri, 30 Jul 2021 18:18:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 04/17] libtracefs: Add unit test to test tracefs_sql() compare
Date:   Fri, 30 Jul 2021 18:18:11 -0400
Message-Id: <20210730221824.595597-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730221824.595597-1-rostedt@goodmis.org>
References: <20210730221824.595597-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a test to test passing time from sched_waking to sched_switch to
show wake up latency.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 89bb1cce61f7..f4e1a6b90a46 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -50,6 +50,9 @@
 #define SQL_2_EVENT	"wakeup_2"
 #define SQL_2_SQL	"select woke.next_pid as woke_pid, wake.common_pid as waking_pid from sched_waking as wake join sched_switch as woke on woke.next_pid = wake.pid"
 
+#define SQL_3_EVENT	"wakeup_lat"
+#define SQL_3_SQL	"select start.pid, end.next_prio as prio, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start join sched_switch as end on start.pid = end.next_pid"
+
 static struct tracefs_instance *test_instance;
 static struct tep_handle *test_tep;
 struct test_sample {
@@ -354,6 +357,13 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
+	synth = tracefs_sql(tep, SQL_3_EVENT, SQL_3_SQL, NULL);
+	CU_TEST(synth != NULL);
+	ret = tracefs_synth_show(&seq, instance, synth);
+	CU_TEST(ret == 0);
+	tracefs_synth_free(synth);
+	trace_seq_reset(&seq);
+
 	tep_free(tep);
 	trace_seq_destroy(&seq);
 }
-- 
2.30.2

