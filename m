Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F8F58AA6
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881ABC433C7
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:24:27 +0000 (UTC)
Date: Thu, 11 Jan 2024 17:25:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd utests: Add more tests to test the iterating
Message-ID: <20240111172530.5a54859e@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add more tests to test tracecmd_iterate_events() and
tracecmd_iterate_events_reverse(), as well as stopping and restarting.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracecmd-utest.c | 110 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index d67678e36554..5dce3e94df6a 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -461,6 +461,15 @@ static int read_events(struct tracecmd_input *handle, struct tep_record *record,
 	return 0;
 }
 
+static int read_events_10(struct tracecmd_input *handle, struct tep_record *record,
+			  int cpu, void *data)
+{
+	struct callback_data *cd = data;
+
+	read_events(handle, record, cpu, data);
+	return  cd->counter < 10 ? 0 : 1;
+}
+
 static void test_trace_library_read(void)
 {
 	struct tracecmd_input *handle;
@@ -488,6 +497,103 @@ static void test_trace_library_read(void)
 	trace_seq_destroy(&data.seq);
 }
 
+static void test_trace_library_read_inc(void)
+{
+	struct tracecmd_input *handle;
+	struct callback_data data;
+	struct stat st;
+	long save_count;
+	long total = 0;
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
+	/* First read all again */
+	handle = tracecmd_open(TRACECMD_FILE, 0);
+	CU_TEST(handle != NULL);
+	ret = tracecmd_iterate_events(handle, NULL, 0, read_events, &data);
+	CU_TEST(ret == 0);
+	CU_TEST(data.counter > 0);
+
+	/* Save the counter */
+	save_count = data.counter;
+
+	tracecmd_iterate_reset(handle);
+
+	/* Read 10 at a time */
+	do {
+		data.counter = 0;
+		ret = tracecmd_iterate_events(handle, NULL, 0, read_events_10, &data);
+		CU_TEST(ret >= 0);
+		CU_TEST(data.counter <= 10);
+		total += data.counter;
+	} while (data.counter);
+	CU_TEST(ret == 0);
+
+	CU_TEST(total == save_count);
+
+	trace_seq_destroy(&data.seq);
+	tracecmd_close(handle);
+}
+
+static void test_trace_library_read_back(void)
+{
+	struct tracecmd_input *handle;
+	struct callback_data data;
+	struct stat st;
+	long save_count;
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
+	/* First read all again */
+	handle = tracecmd_open(TRACECMD_FILE, 0);
+	CU_TEST(handle != NULL);
+	ret = tracecmd_iterate_events(handle, NULL, 0, read_events, &data);
+	CU_TEST(ret == 0);
+	CU_TEST(data.counter > 0);
+
+	/* Save the counter */
+	save_count = data.counter;
+
+	tracecmd_iterate_reset(handle);
+
+	/* Read backwards */
+	data.counter = 0;
+	ret = tracecmd_iterate_events_reverse(handle, NULL, 0, read_events, &data, false);
+	CU_TEST(ret == 0);
+	CU_TEST(data.counter == save_count);
+
+	/* Read forward again */
+	data.counter = 0;
+	ret = tracecmd_iterate_events(handle, NULL, 0, read_events, &data);
+	CU_TEST(ret == 0);
+	CU_TEST(data.counter == save_count);
+
+	/* Read backwards from where we left off */
+	data.counter = 0;
+	ret = tracecmd_iterate_events_reverse(handle, NULL, 0, read_events, &data, true);
+	CU_TEST(ret == 0);
+	CU_TEST(data.counter == save_count);
+
+	trace_seq_destroy(&data.seq);
+	tracecmd_close(handle);
+}
+
 static int test_suite_destroy(void)
 {
 	unlink(TRACECMD_FILE);
@@ -540,6 +646,10 @@ void test_tracecmd_lib(void)
 		    test_trace_convert6);
 	CU_add_test(suite, "Use libraries to read file",
 		    test_trace_library_read);
+	CU_add_test(suite, "Use libraries to read file incremental",
+		    test_trace_library_read_inc);
+	CU_add_test(suite, "Use libraries to read file backwards",
+		    test_trace_library_read_back);
 	CU_add_test(suite, "Test max length",
 		    test_trace_record_max);
 }
-- 
2.43.0

