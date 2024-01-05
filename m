Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAFB538D
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 05:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5BFC433C7;
	Fri,  5 Jan 2024 05:15:33 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLcZU-00000000xXb-1yBu;
	Fri, 05 Jan 2024 00:16:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtracefs utest: Add matches to trace_sql() tests
Date: Fri,  5 Jan 2024 00:15:38 -0500
Message-ID: <20240105051639.228850-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240105051639.228850-1-rostedt@goodmis.org>
References: <20240105051639.228850-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add code to test the output of trace_sql(). Need to handle the hashed variables
too.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 96 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index f338a9153c0a..5bc0d45c8996 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -11,6 +11,7 @@
 #include <time.h>
 #include <dirent.h>
 #include <ftw.h>
+#include <ctype.h>
 #include <libgen.h>
 #include <kbuffer.h>
 #include <pthread.h>
@@ -38,22 +39,40 @@
 
 #define SQL_1_EVENT	"wakeup_1"
 #define SQL_1_SQL	"select sched_switch.next_pid as woke_pid, sched_waking.common_pid as waking_pid from sched_waking join sched_switch on sched_switch.next_pid = sched_waking.pid"
+#define SQL_1_MATCH	"echo 's:wakeup_1 pid_t woke_pid; s32 waking_pid;' >> /sys/kernel/tracing/dynamic_events\n" \
+			"echo 'hist:keys=pid:__arg_XXXXXXXX_1=common_pid' >> /sys/kernel/tracing/events/sched/sched_waking/trigger\n" \
+			"echo 'hist:keys=next_pid:__woke_pid_XXXXXXXX_2=next_pid,__waking_pid_XXXXXXXX_3=$__arg_XXXXXXXX_1:onmatch(sched.sched_waking).trace(wakeup_1,$__woke_pid_XXXXXXXX_2,$__waking_pid_XXXXXXXX_3)' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
 
 #define SQL_2_EVENT	"wakeup_2"
 #define SQL_2_SQL	"select woke.next_pid as woke_pid, wake.common_pid as waking_pid from sched_waking as wake join sched_switch as woke on woke.next_pid = wake.pid"
+#define SQL_2_MATCH	"echo 's:wakeup_2 pid_t woke_pid; s32 waking_pid;' >> /sys/kernel/tracing/dynamic_events\n" \
+			"echo 'hist:keys=pid:__arg_XXXXXXXX_1=common_pid' >> /sys/kernel/tracing/events/sched/sched_waking/trigger\n" \
+			"echo 'hist:keys=next_pid:__woke_pid_XXXXXXXX_2=next_pid,__waking_pid_XXXXXXXX_3=$__arg_XXXXXXXX_1:onmatch(sched.sched_waking).trace(wakeup_2,$__woke_pid_XXXXXXXX_2,$__waking_pid_XXXXXXXX_3)' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
 
 #define SQL_3_EVENT	"wakeup_lat"
 #define SQL_3_SQL	"select sched_switch.next_prio as prio, end.prev_prio as pprio, (sched.sched_waking.common_timestamp.usecs - end.TIMESTAMP_USECS) as lat from sched_waking as start join sched_switch as end on start.pid = end.next_pid"
+#define SQL_3_MATCH	"echo 's:wakeup_lat s32 prio; s32 pprio; u64 lat;' >> /sys/kernel/tracing/dynamic_events\n" \
+			"echo 'hist:keys=pid:__arg_XXXXXXXX_1=common_timestamp.usecs' >> /sys/kernel/tracing/events/sched/sched_waking/trigger\n" \
+			"echo 'hist:keys=next_pid:__prio_XXXXXXXX_2=next_prio,__pprio_XXXXXXXX_3=prev_prio,__lat_XXXXXXXX_4=common_timestamp.usecs-$__arg_XXXXXXXX_1:onmatch(sched.sched_waking).trace(wakeup_lat,$__prio_XXXXXXXX_2,$__pprio_XXXXXXXX_3,$__lat_XXXXXXXX_4)' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
 
 #define SQL_4_EVENT	"wakeup_lat_2"
 #define SQL_4_SQL	"select start.pid, end.next_prio as prio, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start join sched_switch as end on start.pid = end.next_pid where (start.prio >= 1 && start.prio < 100) || !(start.pid >= 0 && start.pid <= 1) && end.prev_pid != 0"
+#define SQL_4_MATCH	"echo 's:wakeup_lat_2 pid_t pid; s32 prio; u64 lat;' >> /sys/kernel/tracing/dynamic_events\n" \
+			"echo 'hist:keys=pid:__arg_XXXXXXXX_1=pid,__arg_XXXXXXXX_2=common_timestamp.usecs if (prio >= 1&&prio < 100)||!(pid >= 0&&pid <= 1)' >> /sys/kernel/tracing/events/sched/sched_waking/trigger\n" \
+			"echo 'hist:keys=next_pid:__pid_XXXXXXXX_3=$__arg_XXXXXXXX_1,__prio_XXXXXXXX_4=next_prio,__lat_XXXXXXXX_5=common_timestamp.usecs-$__arg_XXXXXXXX_2:onmatch(sched.sched_waking).trace(wakeup_lat_2,$__pid_XXXXXXXX_3,$__prio_XXXXXXXX_4,$__lat_XXXXXXXX_5) if prev_pid != 0' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
 
 #define SQL_5_EVENT	"irq_lat"
 #define SQL_5_SQL	"select end.common_pid as pid, (end.common_timestamp.usecs - start.common_timestamp.usecs) as irq_lat from irq_disable as start join irq_enable as end on start.common_pid = end.common_pid, start.parent_offs == end.parent_offs where start.common_pid != 0"
 #define SQL_5_START	"irq_disable"
+#define SQL_5_MATCH	"echo 's:irq_lat s32 pid; u64 irq_lat;' >> /sys/kernel/tracing/dynamic_events\n" \
+			"echo 'hist:keys=common_pid,parent_offs:__arg_XXXXXXXX_1=common_timestamp.usecs if common_pid != 0' >> /sys/kernel/tracing/events/preemptirq/irq_disable/trigger\n" \
+			"echo 'hist:keys=common_pid,parent_offs:__pid_XXXXXXXX_2=common_pid,__irq_lat_XXXXXXXX_3=common_timestamp.usecs-$__arg_XXXXXXXX_1:onmatch(preemptirq.irq_disable).trace(irq_lat,$__pid_XXXXXXXX_2,$__irq_lat_XXXXXXXX_3)' >> /sys/kernel/tracing/events/preemptirq/irq_enable/trigger\n"
 
 #define SQL_6_EVENT	"wakeup_lat_3"
 #define SQL_6_SQL	"select start.pid, end.next_prio as prio, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start join sched_switch as end on start.pid = end.next_pid where (start.prio >= 1 && start.prio < 100) || !(start.pid >= 0 && start.pid <= 1) && end.prev_pid != 0"
+#define SQL_6_MATCH	"echo 's:wakeup_lat_3 pid_t pid; s32 prio; u64 lat;' >> /sys/kernel/tracing/dynamic_events\n" \
+			"echo 'hist:keys=pid:__arg_XXXXXXXX_1=pid,__arg_XXXXXXXX_2=common_timestamp.usecs if (prio >= 1&&prio < 100)||!(pid >= 0&&pid <= 1)' >> /sys/kernel/tracing/events/sched/sched_waking/trigger\n" \
+			"echo 'hist:keys=next_pid:__pid_XXXXXXXX_3=$__arg_XXXXXXXX_1,__prio_XXXXXXXX_4=next_prio,__lat_XXXXXXXX_5=common_timestamp.usecs-$__arg_XXXXXXXX_2:onmatch(sched.sched_waking).trace(wakeup_lat_3,$__pid_XXXXXXXX_3,$__prio_XXXXXXXX_4,$__lat_XXXXXXXX_5) if prev_pid != 0' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
 
 #define DEBUGFS_DEFAULT_PATH "/sys/kernel/debug"
 #define TRACEFS_DEFAULT_PATH "/sys/kernel/tracing"
@@ -405,6 +424,75 @@ static void test_ftrace_marker(void)
 	test_instance_ftrace_marker(test_instance);
 }
 
+static void replace_str(char *str, char *rep, char *with, int rep_len, int with_len)
+{
+	char find[rep_len + 1];
+	char *s = str;
+	int delta = rep_len - with_len;
+
+	CU_TEST(delta >= 0);
+	if (delta < 0)
+		return;
+
+	strncpy(find, rep, rep_len + 1);
+	find[rep_len] = '\0';
+
+	while ((s = strstr(s, find))) {
+		strncpy(s, with, with_len);
+		s += with_len;
+		if (delta) {
+			int new_len = strlen(s) - delta;
+			memmove(s, s + delta, new_len);
+			s[new_len] = '\0';
+		}
+	}
+}
+
+static bool test_sql(struct trace_seq *seq, const char *match)
+{
+	char string[strlen(match) + 64]; /* add some buffer room */
+	char *p, *s, *e, *c = seq->buffer;
+	bool ret;
+
+	strcpy(string, match);
+	s = string;
+
+	while ((p = strstr(s, "_XXXXXXXX_"))) {
+		CU_TEST(ret = strncmp(c, s, p - s) == 0);
+		if (!ret) {
+			printf("\n'%*.s'\n\tdoes not match\n%*.s\n",
+			       (int)(p - s), c, (int)(p - s), s);
+			return ret;
+		}
+
+		/* Move c passed what was matched */
+		c += p - s;
+
+		/* Set e to the next value */
+		e = c + 1;
+		while (isdigit(*e))
+			e++;
+		/* Skip the next '_' */
+		e++;
+		/* Skip the next numbers */
+		while (isdigit(*e))
+			e++;
+
+		/* Skip the "_XXXXXXXX_" */
+		s = p + 10;
+		/* Skip the next numbers */
+		while (isdigit(*s))
+			s++;
+
+		/* Now replace all of these */
+		replace_str(s, p, c, s - p, e - c);
+
+		c = e;
+	}
+
+	return strcmp(s, c) == 0;
+}
+
 static void test_instance_trace_sql(struct tracefs_instance *instance)
 {
 	struct tracefs_synth *synth;
@@ -421,6 +509,7 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 	CU_TEST(synth != NULL);
 	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
+	CU_TEST(test_sql(&seq, SQL_1_MATCH));
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
@@ -428,6 +517,7 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 	CU_TEST(synth != NULL);
 	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
+	CU_TEST(test_sql(&seq, SQL_2_MATCH));
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
@@ -435,6 +525,7 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 	CU_TEST(synth != NULL);
 	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
+	CU_TEST(test_sql(&seq, SQL_3_MATCH));
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
@@ -442,6 +533,7 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 	CU_TEST(synth != NULL);
 	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
+	CU_TEST(test_sql(&seq, SQL_4_MATCH));
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
@@ -451,6 +543,7 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 		CU_TEST(synth != NULL);
 		ret = tracefs_synth_echo_cmd(&seq, synth);
 		CU_TEST(ret == 0);
+		CU_TEST(test_sql(&seq, SQL_5_MATCH));
 		tracefs_synth_free(synth);
 		trace_seq_reset(&seq);
 	}
@@ -459,6 +552,7 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 	CU_TEST(synth != NULL);
 	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
+	CU_TEST(test_sql(&seq, SQL_6_MATCH));
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
@@ -3225,6 +3319,8 @@ void test_tracefs_lib(void)
 	}
 
 	CU_add_test(suite, "Test tracefs/debugfs mounting", test_mounting);
+	CU_add_test(suite, "trace sql",
+		    test_trace_sql);
 	CU_add_test(suite, "trace cpu read",
 		    test_trace_cpu_read);
 	CU_add_test(suite, "trace cpu read_buf_percent",
-- 
2.42.0

