Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AA417CF
	for <linux-trace-devel@vger.kernel.org>; Sat,  6 Jan 2024 04:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0B1C433CA;
	Sat,  6 Jan 2024 04:23:21 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLyEY-00000001AnB-0apx;
	Fri, 05 Jan 2024 23:24:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] trace-cmd utest: Add tests for trace-cmd sqlhist
Date: Fri,  5 Jan 2024 23:22:29 -0500
Message-ID: <20240106042428.279706-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240106042428.279706-1-rostedt@goodmis.org>
References: <20240106042428.279706-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tests to test the trace-cmd sqlhist command as well as the
trace-cmd show --hist and --trigger options.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracecmd-utest.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/utest/tracecmd-utest.c b/utest/tracecmd-utest.c
index 6ba2318eaeb4..d67678e36554 100644
--- a/utest/tracecmd-utest.c
+++ b/utest/tracecmd-utest.c
@@ -32,6 +32,13 @@ static char tracecmd_exec[PATH_MAX];
 #define TRACECMD_IN		"-i", TRACECMD_FILE
 #define TRACECMD_IN2		"-i", TRACECMD_FILE2
 
+#define TRACECMD_SQL_HIST	"SELECT irq FROM irq_handler_entry"
+#define TRACECMD_SQL_READ_HIST	"show", "--hist", "irq_handler_entry"
+
+#define SYNTH_EVENT		"wakeup"
+#define TRACECMD_SQL_SYNTH	"-e", "-n", SYNTH_EVENT, "SELECT start.pid AS this_pid, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) AS delta FROM sched_waking as start JOIN sched_switch AS end ON start.pid = end.next_pid"
+#define TRACECMD_SQL_START_SYNTH "start", "-e", SYNTH_EVENT
+
 static char **get_args(const char *cmd, va_list ap)
 {
 	const char *param;
@@ -326,6 +333,25 @@ static void test_trace_record_report(void)
 	CU_TEST(ret == 0);
 }
 
+static void test_trace_sqlhist_hist(void)
+{
+	int ret;
+
+	ret = run_trace("sqlhist", "-e", TRACECMD_SQL_HIST, NULL);
+	CU_TEST(ret == 0);
+	ret = grep_match(" *Hits: [0-9][0-9]*", TRACECMD_SQL_READ_HIST, NULL);
+	CU_TEST(ret == 0);
+	ret = run_trace("sqlhist", TRACECMD_SQL_SYNTH, NULL);
+	CU_TEST(ret == 0);
+	ret = run_trace(TRACECMD_SQL_START_SYNTH, NULL);
+	CU_TEST(ret == 0);
+	sleep(1);
+	ret = grep_match(SYNTH_EVENT ":", "show", NULL);
+	CU_TEST(ret == 0);
+
+	tracefs_instance_reset(NULL);
+}
+
 static int read_stats(const char *out, const char *match, const char *cmd, ...)
 {
 	struct do_grep_it gdata;
@@ -508,6 +534,8 @@ void test_tracecmd_lib(void)
 	}
 	CU_add_test(suite, "Simple record and report",
 		    test_trace_record_report);
+	CU_add_test(suite, "Create a histogram",
+		    test_trace_sqlhist_hist);
 	CU_add_test(suite, "Test convert from v7 to v6",
 		    test_trace_convert6);
 	CU_add_test(suite, "Use libraries to read file",
-- 
2.42.0

