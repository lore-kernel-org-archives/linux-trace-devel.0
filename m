Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86257C25B0F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Aug 2022 15:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240710AbiHEPkv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Aug 2022 11:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240760AbiHEPks (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Aug 2022 11:40:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D6A25C54
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 08:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 455C8B82960
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Aug 2022 15:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFA7C433C1;
        Fri,  5 Aug 2022 15:40:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1oJzRJ-008S4S-35;
        Fri, 05 Aug 2022 11:40:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/9] tracecmd utest: Add test to test using the libraries to read
Date:   Fri,  5 Aug 2022 11:40:34 -0400
Message-Id: <20220805154040.2014381-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220805154040.2014381-1-rostedt@goodmis.org>
References: <20220805154040.2014381-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a test that uses tracecmd_open() and tracecmd_iterate_events() to read
a trace.dat file.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/Makefile         |  4 +++-
 utest/tracecmd-utest.c | 53 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/utest/Makefile b/utest/Makefile
index 2b8f85f21a24..d475bad5a0f9 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -10,7 +10,9 @@ OBJS =
 OBJS += trace-utest.o
 OBJS += tracecmd-utest.o
 
-LIBS += -lcunit $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS)
+LIBS += $(LIBTRACECMD_STATIC) -lcunit $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS)
+
+LIBS += $(ZLIB_LDLAGS) $(LIBZSTD_LDLAGS)
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index 7db5999e17f5..e45b3537365c 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -17,7 +17,7 @@
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
 
-#include <tracefs.h>
+#include <trace-cmd.h>
 
 #include "trace-utest.h"
 
@@ -244,6 +244,55 @@ static void test_trace_convert6(void)
 	CU_TEST(ret == 0);
 }
 
+struct callback_data {
+	long			counter;
+	struct trace_seq	seq;
+};
+
+static int read_events(struct tracecmd_input *handle, struct tep_record *record,
+		       int cpu, void *data)
+{
+	struct tep_handle *tep = tracecmd_get_tep(handle);
+	struct callback_data *cd = data;
+	struct trace_seq *seq = &cd->seq;
+
+	cd->counter++;
+
+	trace_seq_reset(seq);
+	tep_print_event(tep, seq, record, "%6.1000d", TEP_PRINT_TIME);
+	trace_seq_printf(seq, " [%03d] ", cpu);
+	tep_print_event(tep, seq, record, "%s-%d %s %s\n",
+			TEP_PRINT_COMM, TEP_PRINT_PID,
+			TEP_PRINT_NAME, TEP_PRINT_INFO);
+	trace_seq_do_printf(seq);
+	return 0;
+}
+
+static void test_trace_library_read(void)
+{
+	struct tracecmd_input *handle;
+	struct callback_data data;
+	struct stat st;
+	int ret;
+
+	data.counter = 0;
+	trace_seq_init(&data.seq);
+
+	/* If the trace data is already created, just use it, otherwise make it again */
+	if (stat(TRACECMD_FILE, &st) < 0) {
+		ret = run_trace("record", TRACECMD_OUT, "-e", "sched", "sleep", "1", NULL);
+		CU_TEST(ret == 0);
+	}
+
+	handle = tracecmd_open(TRACECMD_FILE, 0);
+	CU_TEST(handle != NULL);
+	ret = tracecmd_iterate_events(handle, NULL, 0, read_events, &data);
+	CU_TEST(ret == 0);
+
+	CU_TEST(data.counter > 0);
+	trace_seq_destroy(&data.seq);
+}
+
 static int test_suite_destroy(void)
 {
 	unlink(TRACECMD_FILE);
@@ -292,4 +341,6 @@ void test_tracecmd_lib(void)
 		    test_trace_record_report);
 	CU_add_test(suite, "Test convert from v7 to v6",
 		    test_trace_convert6);
+	CU_add_test(suite, "Use libraries to read file",
+		    test_trace_library_read);
 }
-- 
2.35.1

