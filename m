Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE485538D
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 05:15:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19027C433C8;
	Fri,  5 Jan 2024 05:15:33 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLcZU-00000000xXe-26Zw;
	Fri, 05 Jan 2024 00:16:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtracefs utest: Add more tests to test tracefs_sql()
Date: Fri,  5 Jan 2024 00:15:39 -0500
Message-ID: <20240105051639.228850-3-rostedt@goodmis.org>
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

After finding out that the "save" command of tracefs_sql() was broken for
some time, I decided that all the tracefs_sql() features should be tested.

Add tests to test: onmax, onchange, onmatch with trace, snapshot, save, and
"trace and snapshot". And all those combinations.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 317 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 293 insertions(+), 24 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 5bc0d45c8996..f5afec0e338a 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -37,42 +37,74 @@
 #define TRACE_ON	"tracing_on"
 #define TRACE_CLOCK	"trace_clock"
 
+/* Used to insert sql types and actions, must be big enough to hold them */
+#define SQL_REPLACE	"RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR"
+
 #define SQL_1_EVENT	"wakeup_1"
 #define SQL_1_SQL	"select sched_switch.next_pid as woke_pid, sched_waking.common_pid as waking_pid from sched_waking join sched_switch on sched_switch.next_pid = sched_waking.pid"
 #define SQL_1_MATCH	"echo 's:wakeup_1 pid_t woke_pid; s32 waking_pid;' >> /sys/kernel/tracing/dynamic_events\n" \
 			"echo 'hist:keys=pid:__arg_XXXXXXXX_1=common_pid' >> /sys/kernel/tracing/events/sched/sched_waking/trigger\n" \
-			"echo 'hist:keys=next_pid:__woke_pid_XXXXXXXX_2=next_pid,__waking_pid_XXXXXXXX_3=$__arg_XXXXXXXX_1:onmatch(sched.sched_waking).trace(wakeup_1,$__woke_pid_XXXXXXXX_2,$__waking_pid_XXXXXXXX_3)' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
+			"echo 'hist:keys=next_pid:__woke_pid_XXXXXXXX_2=next_pid,__waking_pid_XXXXXXXX_3=$__arg_XXXXXXXX_1:" SQL_REPLACE "' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
+#define SQL_1_VAR "$__waking_pid_XXXXXXXX_3"
+#define SQL_1_ONMATCH "onmatch(sched.sched_waking)"
+#define SQL_1_TRACE "trace(wakeup_1,$__woke_pid_XXXXXXXX_2,$__waking_pid_XXXXXXXX_3)"
+#define SQL_1_SAVE { "prev_prio" , "prev_state", NULL }
 
 #define SQL_2_EVENT	"wakeup_2"
 #define SQL_2_SQL	"select woke.next_pid as woke_pid, wake.common_pid as waking_pid from sched_waking as wake join sched_switch as woke on woke.next_pid = wake.pid"
 #define SQL_2_MATCH	"echo 's:wakeup_2 pid_t woke_pid; s32 waking_pid;' >> /sys/kernel/tracing/dynamic_events\n" \
 			"echo 'hist:keys=pid:__arg_XXXXXXXX_1=common_pid' >> /sys/kernel/tracing/events/sched/sched_waking/trigger\n" \
-			"echo 'hist:keys=next_pid:__woke_pid_XXXXXXXX_2=next_pid,__waking_pid_XXXXXXXX_3=$__arg_XXXXXXXX_1:onmatch(sched.sched_waking).trace(wakeup_2,$__woke_pid_XXXXXXXX_2,$__waking_pid_XXXXXXXX_3)' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
+			"echo 'hist:keys=next_pid:__woke_pid_XXXXXXXX_2=next_pid,__waking_pid_XXXXXXXX_3=$__arg_XXXXXXXX_1:" SQL_REPLACE "' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
+#define SQL_2_MATCH_EVENT "sched.sched_waking"
+#define SQL_2_VAR "$__woke_pid_XXXXXXXX_2"
+#define SQL_2_ONMATCH "onmatch(sched.sched_waking)"
+#define SQL_2_TRACE "trace(wakeup_2,$__woke_pid_XXXXXXXX_2,$__waking_pid_XXXXXXXX_3)"
+#define SQL_2_SAVE { "prev_prio" , "prev_state", NULL }
 
 #define SQL_3_EVENT	"wakeup_lat"
 #define SQL_3_SQL	"select sched_switch.next_prio as prio, end.prev_prio as pprio, (sched.sched_waking.common_timestamp.usecs - end.TIMESTAMP_USECS) as lat from sched_waking as start join sched_switch as end on start.pid = end.next_pid"
 #define SQL_3_MATCH	"echo 's:wakeup_lat s32 prio; s32 pprio; u64 lat;' >> /sys/kernel/tracing/dynamic_events\n" \
 			"echo 'hist:keys=pid:__arg_XXXXXXXX_1=common_timestamp.usecs' >> /sys/kernel/tracing/events/sched/sched_waking/trigger\n" \
-			"echo 'hist:keys=next_pid:__prio_XXXXXXXX_2=next_prio,__pprio_XXXXXXXX_3=prev_prio,__lat_XXXXXXXX_4=common_timestamp.usecs-$__arg_XXXXXXXX_1:onmatch(sched.sched_waking).trace(wakeup_lat,$__prio_XXXXXXXX_2,$__pprio_XXXXXXXX_3,$__lat_XXXXXXXX_4)' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
+			"echo 'hist:keys=next_pid:__prio_XXXXXXXX_2=next_prio,__pprio_XXXXXXXX_3=prev_prio,__lat_XXXXXXXX_4=common_timestamp.usecs-$__arg_XXXXXXXX_1:" SQL_REPLACE "' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
+#define SQL_3_MATCH_EVENT "sched.sched_waking"
+#define SQL_3_VAR "$__lat_XXXXXXXX_4"
+#define SQL_3_ONMATCH "onmatch(sched.sched_waking)"
+#define SQL_3_TRACE "trace(wakeup_lat,$__prio_XXXXXXXX_2,$__pprio_XXXXXXXX_3,$__lat_XXXXXXXX_4)"
+#define SQL_3_SAVE { "prev_prio" , "prev_state", NULL }
 
 #define SQL_4_EVENT	"wakeup_lat_2"
 #define SQL_4_SQL	"select start.pid, end.next_prio as prio, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start join sched_switch as end on start.pid = end.next_pid where (start.prio >= 1 && start.prio < 100) || !(start.pid >= 0 && start.pid <= 1) && end.prev_pid != 0"
 #define SQL_4_MATCH	"echo 's:wakeup_lat_2 pid_t pid; s32 prio; u64 lat;' >> /sys/kernel/tracing/dynamic_events\n" \
 			"echo 'hist:keys=pid:__arg_XXXXXXXX_1=pid,__arg_XXXXXXXX_2=common_timestamp.usecs if (prio >= 1&&prio < 100)||!(pid >= 0&&pid <= 1)' >> /sys/kernel/tracing/events/sched/sched_waking/trigger\n" \
-			"echo 'hist:keys=next_pid:__pid_XXXXXXXX_3=$__arg_XXXXXXXX_1,__prio_XXXXXXXX_4=next_prio,__lat_XXXXXXXX_5=common_timestamp.usecs-$__arg_XXXXXXXX_2:onmatch(sched.sched_waking).trace(wakeup_lat_2,$__pid_XXXXXXXX_3,$__prio_XXXXXXXX_4,$__lat_XXXXXXXX_5) if prev_pid != 0' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
+			"echo 'hist:keys=next_pid:__pid_XXXXXXXX_3=$__arg_XXXXXXXX_1,__prio_XXXXXXXX_4=next_prio,__lat_XXXXXXXX_5=common_timestamp.usecs-$__arg_XXXXXXXX_2:" SQL_REPLACE " if prev_pid != 0' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
+#define SQL_4_MATCH_EVENT "sched.sched_waking"
+#define SQL_4_VAR "$__lat_XXXXXXXX_5"
+#define SQL_4_ONMATCH "onmatch(sched.sched_waking)"
+#define SQL_4_TRACE "trace(wakeup_lat_2,$__pid_XXXXXXXX_3,$__prio_XXXXXXXX_4,$__lat_XXXXXXXX_5)"
+#define SQL_4_SAVE { "prev_prio" , "prev_state", NULL }
 
 #define SQL_5_EVENT	"irq_lat"
 #define SQL_5_SQL	"select end.common_pid as pid, (end.common_timestamp.usecs - start.common_timestamp.usecs) as irq_lat from irq_disable as start join irq_enable as end on start.common_pid = end.common_pid, start.parent_offs == end.parent_offs where start.common_pid != 0"
 #define SQL_5_START	"irq_disable"
 #define SQL_5_MATCH	"echo 's:irq_lat s32 pid; u64 irq_lat;' >> /sys/kernel/tracing/dynamic_events\n" \
 			"echo 'hist:keys=common_pid,parent_offs:__arg_XXXXXXXX_1=common_timestamp.usecs if common_pid != 0' >> /sys/kernel/tracing/events/preemptirq/irq_disable/trigger\n" \
-			"echo 'hist:keys=common_pid,parent_offs:__pid_XXXXXXXX_2=common_pid,__irq_lat_XXXXXXXX_3=common_timestamp.usecs-$__arg_XXXXXXXX_1:onmatch(preemptirq.irq_disable).trace(irq_lat,$__pid_XXXXXXXX_2,$__irq_lat_XXXXXXXX_3)' >> /sys/kernel/tracing/events/preemptirq/irq_enable/trigger\n"
+			"echo 'hist:keys=common_pid,parent_offs:__pid_XXXXXXXX_2=common_pid,__irq_lat_XXXXXXXX_3=common_timestamp.usecs-$__arg_XXXXXXXX_1:" SQL_REPLACE "' >> /sys/kernel/tracing/events/preemptirq/irq_enable/trigger\n"
+#define SQL_5_MATCH_EVENT "preemptirq.irq_disable"
+#define SQL_5_VAR "$__irq_lat_XXXXXXXX_3"
+#define SQL_5_ONMATCH "onmatch(preemptirq.irq_disable)"
+#define SQL_5_TRACE "trace(irq_lat,$__pid_XXXXXXXX_2,$__irq_lat_XXXXXXXX_3)"
+#define SQL_5_SAVE { "caller_offs", NULL }
 
 #define SQL_6_EVENT	"wakeup_lat_3"
 #define SQL_6_SQL	"select start.pid, end.next_prio as prio, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start join sched_switch as end on start.pid = end.next_pid where (start.prio >= 1 && start.prio < 100) || !(start.pid >= 0 && start.pid <= 1) && end.prev_pid != 0"
 #define SQL_6_MATCH	"echo 's:wakeup_lat_3 pid_t pid; s32 prio; u64 lat;' >> /sys/kernel/tracing/dynamic_events\n" \
 			"echo 'hist:keys=pid:__arg_XXXXXXXX_1=pid,__arg_XXXXXXXX_2=common_timestamp.usecs if (prio >= 1&&prio < 100)||!(pid >= 0&&pid <= 1)' >> /sys/kernel/tracing/events/sched/sched_waking/trigger\n" \
-			"echo 'hist:keys=next_pid:__pid_XXXXXXXX_3=$__arg_XXXXXXXX_1,__prio_XXXXXXXX_4=next_prio,__lat_XXXXXXXX_5=common_timestamp.usecs-$__arg_XXXXXXXX_2:onmatch(sched.sched_waking).trace(wakeup_lat_3,$__pid_XXXXXXXX_3,$__prio_XXXXXXXX_4,$__lat_XXXXXXXX_5) if prev_pid != 0' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
+			"echo 'hist:keys=next_pid:__pid_XXXXXXXX_3=$__arg_XXXXXXXX_1,__prio_XXXXXXXX_4=next_prio,__lat_XXXXXXXX_5=common_timestamp.usecs-$__arg_XXXXXXXX_2:" SQL_REPLACE " if prev_pid != 0' >> /sys/kernel/tracing/events/sched/sched_switch/trigger\n"
+#define SQL_6_MATCH_EVENT "sched.sched_waking"
+#define SQL_6_VAR "$__lat_XXXXXXXX_5"
+#define SQL_6_ONMATCH "onmatch(sched.sched_waking)"
+#define SQL_6_TRACE "trace(wakeup_lat_3,$__pid_XXXXXXXX_3,$__prio_XXXXXXXX_4,$__lat_XXXXXXXX_5)"
+#define SQL_6_SAVE { "prev_prio" , "prev_state", NULL }
 
 #define DEBUGFS_DEFAULT_PATH "/sys/kernel/debug"
 #define TRACEFS_DEFAULT_PATH "/sys/kernel/tracing"
@@ -431,8 +463,10 @@ static void replace_str(char *str, char *rep, char *with, int rep_len, int with_
 	int delta = rep_len - with_len;
 
 	CU_TEST(delta >= 0);
-	if (delta < 0)
+	if (delta < 0) {
+		printf("rep_len:%d with_len:%d\n", rep_len, with_len);
 		return;
+	}
 
 	strncpy(find, rep, rep_len + 1);
 	find[rep_len] = '\0';
@@ -448,19 +482,81 @@ static void replace_str(char *str, char *rep, char *with, int rep_len, int with_
 	}
 }
 
-static bool test_sql(struct trace_seq *seq, const char *match)
+enum sql_type {
+	SQL_ONMATCH,
+	SQL_ONMAX,
+	SQL_ONCHANGE,
+};
+
+enum sql_action {
+	SQL_TRACE,
+	SQL_SNAPSHOT,
+	SQL_SAVE,
+	SQL_TRACE_SNAPSHOT,
+};
+
+struct trace_sql_strings {
+	const char		*match;
+	const char		*onmatch;
+	const char		*var;
+	const char		*trace;
+	char			*save[4];
+};
+
+#define SQL_VAR_REPLACE		"_XXXXXXXX_"
+
+static bool test_sql(struct trace_seq *seq, struct trace_sql_strings *strings,
+		     enum sql_type stype, enum sql_action atype)
 {
-	char string[strlen(match) + 64]; /* add some buffer room */
+	char string[strlen(strings->match) + 256]; /* add a bunch for replacement */
+	char replace[1024];
+	char type[256];
 	char *p, *s, *e, *c = seq->buffer;
 	bool ret;
 
-	strcpy(string, match);
+	strcpy(string, strings->match);
 	s = string;
 
-	while ((p = strstr(s, "_XXXXXXXX_"))) {
+	switch (stype) {
+	case SQL_ONMATCH:
+		sprintf(type, "%s", strings->onmatch);
+		break;
+	case SQL_ONMAX:
+		sprintf(type, "onmax(%s)", strings->var);
+		break;
+	case SQL_ONCHANGE:
+		sprintf(type, "onchange(%s)", strings->var);
+		break;
+	}
+
+	switch (atype) {
+	case SQL_TRACE:
+		sprintf(replace, "%s.%s", type, strings->trace);
+		break;
+	case SQL_SNAPSHOT:
+		sprintf(replace, "%s.snapshot()", type);
+		break;
+	case SQL_SAVE:
+		sprintf(replace, "%s.save(", type);
+
+		for (int i = 0; strings->save[i]; i++) {
+			if (i)
+				strcat(replace, ",");
+			strcat(replace, strings->save[i]);
+		}
+		strcat(replace, ")");
+		break;
+	case SQL_TRACE_SNAPSHOT:
+		sprintf(replace, "%s.%s:%s.snapshot()", type, strings->trace, type);
+		break;
+	}
+
+	replace_str(string, SQL_REPLACE, replace, strlen(SQL_REPLACE), strlen(replace));
+
+	while ((p = strstr(s, SQL_VAR_REPLACE))) {
 		CU_TEST(ret = strncmp(c, s, p - s) == 0);
 		if (!ret) {
-			printf("\n'%*.s'\n\tdoes not match\n%*.s\n",
+			printf("\n\t'%*.s'\nDOES NOT MATCH\n\t%*.s\n",
 			       (int)(p - s), c, (int)(p - s), s);
 			return ret;
 		}
@@ -479,7 +575,7 @@ static bool test_sql(struct trace_seq *seq, const char *match)
 			e++;
 
 		/* Skip the "_XXXXXXXX_" */
-		s = p + 10;
+		s = p + strlen(SQL_VAR_REPLACE);
 		/* Skip the next numbers */
 		while (isdigit(*s))
 			s++;
@@ -490,69 +586,187 @@ static bool test_sql(struct trace_seq *seq, const char *match)
 		c = e;
 	}
 
-	return strcmp(s, c) == 0;
+	ret = strcmp(s, c) == 0;
+	if (!ret)
+		printf("\n\t'%s'\nDOES NOT MATCH\n\t%s\n", s, c);
+
+	return ret;
+}
+
+static void unhash_var(char *var, const char *hash_var)
+{
+	const char *p = hash_var + strlen(hash_var) - 1;
+	int len;
+
+	/* Skip $__ */
+	hash_var += 3;
+
+	/* Find the _XXXXXXXXX_ */
+	p = strstr(hash_var, SQL_VAR_REPLACE);
+	CU_TEST(p != NULL);
+
+	len = p - hash_var;
+
+	strncpy(var, hash_var, len);
+	var[len] = '\0';
+}
+
+static bool set_sql_type(struct tracefs_synth *synth, struct trace_sql_strings *strings,
+			 enum sql_type stype, enum sql_action atype)
+{
+	enum tracefs_synth_handler handler = 0;
+	char var[256];
+	int ret = 0;
+
+	switch (stype) {
+	case SQL_ONMATCH:
+		break;
+	case SQL_ONMAX:
+		handler = TRACEFS_SYNTH_HANDLE_MAX;
+		break;
+	case SQL_ONCHANGE:
+		handler = TRACEFS_SYNTH_HANDLE_CHANGE;
+		break;
+	}
+
+	unhash_var(var, strings->var);
+
+	switch (atype) {
+	case SQL_TRACE:
+		if (handler)
+			ret = tracefs_synth_trace(synth, handler, var);
+		break;
+	case SQL_SNAPSHOT:
+		ret = tracefs_synth_snapshot(synth, handler, var);
+		break;
+	case SQL_SAVE:
+		ret = tracefs_synth_save(synth, handler, var, strings->save);
+		break;
+	case SQL_TRACE_SNAPSHOT:
+		ret = tracefs_synth_trace(synth, handler, var);
+		ret |= tracefs_synth_snapshot(synth, handler, var);
+		break;
+	}
+
+	return ret == 0;
 }
 
-static void test_instance_trace_sql(struct tracefs_instance *instance)
+#define sql_assign_save(str, arr)			\
+	do {						\
+		char *__array__[] = arr;		\
+		int i;					\
+							\
+		for (i = 0; __array__[i]; i++) {	\
+			(str)[i] = __array__[i];	\
+		}					\
+		(str)[i] = NULL;			\
+	} while (0)
+
+static void test_instance_trace_sql(struct tracefs_instance *instance,
+				    enum sql_type stype, enum sql_action atype)
 {
 	struct tracefs_synth *synth;
 	struct trace_seq seq;
 	struct tep_handle *tep;
 	struct tep_event *event;
+	struct trace_sql_strings strings;
 	int ret;
 
 	tep = test_tep;
 
 	trace_seq_init(&seq);
 
+	strings.match = SQL_1_MATCH;
+	strings.var = SQL_1_VAR;
+	strings.onmatch = SQL_1_ONMATCH;
+	strings.trace = SQL_1_TRACE;
+	sql_assign_save(strings.save, SQL_1_SAVE);
+
 	synth = tracefs_sql(tep, SQL_1_EVENT, SQL_1_SQL, NULL);
 	CU_TEST(synth != NULL);
+	CU_TEST(set_sql_type(synth, &strings, stype, atype));
 	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
-	CU_TEST(test_sql(&seq, SQL_1_MATCH));
+	CU_TEST(test_sql(&seq, &strings, stype, atype));
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
+	strings.match = SQL_2_MATCH;
+	strings.var = SQL_2_VAR;
+	strings.onmatch = SQL_2_ONMATCH;
+	strings.trace = SQL_2_TRACE;
+	sql_assign_save(strings.save, SQL_2_SAVE);
+
 	synth = tracefs_sql(tep, SQL_2_EVENT, SQL_2_SQL, NULL);
 	CU_TEST(synth != NULL);
+	CU_TEST(set_sql_type(synth, &strings, stype, atype));
 	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
-	CU_TEST(test_sql(&seq, SQL_2_MATCH));
+	CU_TEST(test_sql(&seq, &strings, stype, atype));
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
+	strings.match = SQL_3_MATCH;
+	strings.var = SQL_3_VAR;
+	strings.onmatch = SQL_3_ONMATCH;
+	strings.trace = SQL_3_TRACE;
+	sql_assign_save(strings.save, SQL_3_SAVE);
+
 	synth = tracefs_sql(tep, SQL_3_EVENT, SQL_3_SQL, NULL);
 	CU_TEST(synth != NULL);
+	CU_TEST(set_sql_type(synth, &strings, stype, atype));
 	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
-	CU_TEST(test_sql(&seq, SQL_3_MATCH));
+	CU_TEST(test_sql(&seq, &strings, stype, atype));
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
+	strings.match = SQL_4_MATCH;
+	strings.var = SQL_4_VAR;
+	strings.onmatch = SQL_4_ONMATCH;
+	strings.trace = SQL_4_TRACE;
+	sql_assign_save(strings.save, SQL_4_SAVE);
+
 	synth = tracefs_sql(tep, SQL_4_EVENT, SQL_4_SQL, NULL);
 	CU_TEST(synth != NULL);
+	CU_TEST(set_sql_type(synth, &strings, stype, atype));
 	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
-	CU_TEST(test_sql(&seq, SQL_4_MATCH));
+	CU_TEST(test_sql(&seq, &strings, stype, atype));
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
 	event = tep_find_event_by_name(tep, NULL, SQL_5_START);
 	if (event) {
+
+		strings.match = SQL_5_MATCH;
+		strings.var = SQL_5_VAR;
+		strings.onmatch = SQL_5_ONMATCH;
+		strings.trace = SQL_5_TRACE;
+		sql_assign_save(strings.save, SQL_5_SAVE);
+
 		synth = tracefs_sql(tep, SQL_5_EVENT, SQL_5_SQL, NULL);
 		CU_TEST(synth != NULL);
+		CU_TEST(set_sql_type(synth, &strings, stype, atype));
 		ret = tracefs_synth_echo_cmd(&seq, synth);
 		CU_TEST(ret == 0);
-		CU_TEST(test_sql(&seq, SQL_5_MATCH));
+		CU_TEST(test_sql(&seq, &strings, stype, atype));
 		tracefs_synth_free(synth);
 		trace_seq_reset(&seq);
 	}
 
+	strings.match = SQL_6_MATCH;
+	strings.var = SQL_6_VAR;
+	strings.onmatch = SQL_6_ONMATCH;
+	strings.trace = SQL_6_TRACE;
+	sql_assign_save(strings.save, SQL_6_SAVE);
+
 	synth = tracefs_sql(tep, SQL_6_EVENT, SQL_6_SQL, NULL);
 	CU_TEST(synth != NULL);
+	CU_TEST(set_sql_type(synth, &strings, stype, atype));
 	ret = tracefs_synth_echo_cmd(&seq, synth);
 	CU_TEST(ret == 0);
-	CU_TEST(test_sql(&seq, SQL_6_MATCH));
+	CU_TEST(test_sql(&seq, &strings, stype, atype));
 	tracefs_synth_free(synth);
 	trace_seq_reset(&seq);
 
@@ -561,9 +775,50 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 
 static void test_trace_sql(void)
 {
-	test_instance_trace_sql(test_instance);
+	test_instance_trace_sql(test_instance, SQL_ONMATCH, SQL_TRACE);
+}
+
+static void test_trace_sql_trace_onmax(void)
+{
+	test_instance_trace_sql(test_instance, SQL_ONMAX, SQL_TRACE);
+}
+
+static void test_trace_sql_trace_onchange(void)
+{
+	test_instance_trace_sql(test_instance, SQL_ONCHANGE, SQL_TRACE);
 }
 
+static void test_trace_sql_snapshot_onmax(void)
+{
+	test_instance_trace_sql(test_instance, SQL_ONMAX, SQL_SNAPSHOT);
+}
+
+static void test_trace_sql_snapshot_onchange(void)
+{
+	test_instance_trace_sql(test_instance, SQL_ONCHANGE, SQL_SNAPSHOT);
+}
+
+static void test_trace_sql_save_onmax(void)
+{
+	test_instance_trace_sql(test_instance, SQL_ONMAX, SQL_SAVE);
+}
+
+static void test_trace_sql_save_onchange(void)
+{
+	test_instance_trace_sql(test_instance, SQL_ONCHANGE, SQL_SAVE);
+}
+
+static void test_trace_sql_trace_snapshot_onmax(void)
+{
+	test_instance_trace_sql(test_instance, SQL_ONMAX, SQL_TRACE_SNAPSHOT);
+}
+
+static void test_trace_sql_trace_snapshot_onchange(void)
+{
+	test_instance_trace_sql(test_instance, SQL_ONCHANGE, SQL_TRACE_SNAPSHOT);
+}
+
+
 static void call_getppid(int cnt)
 {
 	int i;
@@ -3319,8 +3574,6 @@ void test_tracefs_lib(void)
 	}
 
 	CU_add_test(suite, "Test tracefs/debugfs mounting", test_mounting);
-	CU_add_test(suite, "trace sql",
-		    test_trace_sql);
 	CU_add_test(suite, "trace cpu read",
 		    test_trace_cpu_read);
 	CU_add_test(suite, "trace cpu read_buf_percent",
@@ -3333,6 +3586,22 @@ void test_tracefs_lib(void)
 		    test_trace_function_pid_filter);
 	CU_add_test(suite, "trace sql",
 		    test_trace_sql);
+	CU_add_test(suite, "trace sql trace onmax",
+		    test_trace_sql_trace_onmax);
+	CU_add_test(suite, "trace sql trace onchange",
+		    test_trace_sql_trace_onchange);
+	CU_add_test(suite, "trace sql snapshot onmax",
+		    test_trace_sql_snapshot_onmax);
+	CU_add_test(suite, "trace sql snapshot onchange",
+		    test_trace_sql_snapshot_onchange);
+	CU_add_test(suite, "trace sql save onmax",
+		    test_trace_sql_save_onmax);
+	CU_add_test(suite, "trace sql save onchange",
+		    test_trace_sql_save_onchange);
+	CU_add_test(suite, "trace sql trace and snapshot onmax",
+		    test_trace_sql_trace_snapshot_onmax);
+	CU_add_test(suite, "trace sql trace and snapshot onchange",
+		    test_trace_sql_trace_snapshot_onchange);
 	CU_add_test(suite, "tracing file / directory APIs",
 		    test_trace_file);
 	CU_add_test(suite, "instance file / directory APIs",
-- 
2.42.0

