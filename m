Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BF0107BE
	for <linux-trace-devel@vger.kernel.org>; Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A53CC433BC;
	Thu, 28 Dec 2023 20:36:26 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rIx80-00000000Dto-0Bvr;
	Thu, 28 Dec 2023 15:37:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 20/23] libtracefs: Add TIMESTAMP_USECS_DELTA to simplify SQL timestamp compares
Date: Thu, 28 Dec 2023 15:35:42 -0500
Message-ID: <20231228203714.53294-21-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231228203714.53294-1-rostedt@goodmis.org>
References: <20231228203714.53294-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Since it is so common to have in the SQL synthetic event creation logic:

 (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as delta

for creating latency synthetic events, add a shortcut that does the above.

Now the user only needs to write:

 TIMESTAMP_USECS_DELTA as delta

and it will produce the same compare.

Note, TIMESTAMP_DELTA is also equivalent to: (end.TIMESTAMP - start.TIMESTAMP)

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-sql.txt | 16 ++++++++
 src/tracefs-sqlhist.c            | 64 +++++++++++++++++++++++++++++++-
 utest/tracefs-utest.c            | 10 +++++
 3 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index 62fd771b92bb..7921509f3825 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -127,6 +127,22 @@ The *TIMESTAMP_USECS* will truncate the time down to microseconds as the timesta
 recorded in the tracing buffer has nanosecond resolution. If you do not want that
 truncation, use *TIMESTAMP* instead of *TIMESTAMP_USECS*.
 
+Because it is so common to have:
+
+[source,c]
+--
+   (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS)
+--
+
+The above can be represented with *TIMESTAMP_USECS_DELTA* or if nanoseconds are OK, you can
+use *TIMESTAMP_DELTA*. That is, the previous select can also be represented by:
+
+[source,c]
+--
+select start.pid, TIMESTAMP_USECS_DELTA as lat from sched_waking as start JOIN sched_switch as end ON start.pid = end.next_pid
+--
+
+
 Finally, the *WHERE* clause can be added, that will let you add filters on either or both events.
 
 [source,c]
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 003592291cb8..3592000e038d 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -39,6 +39,13 @@ enum field_type {
 #define for_each_field(expr, field, table) \
 	for (expr = (table)->fields; expr; expr = (field)->next)
 
+#define TIMESTAMP_COMPARE "TIMESTAMP_DELTA"
+#define TIMESTAMP_USECS_COMPARE "TIMESTAMP_USECS_DELTA"
+#define EVENT_START	"__START_EVENT__"
+#define EVENT_END	"__END_EVENT__"
+#define TIMESTAMP_NSECS "TIMESTAMP"
+#define TIMESTAMP_USECS "TIMESTAMP_USECS"
+
 struct field {
 	struct expr		*next;	/* private link list */
 	const char		*system;
@@ -374,6 +381,44 @@ __hidden void *add_field(struct sqlhist_bison *sb,
 	struct sql_table *table = sb->table;
 	struct expr *expr;
 	struct field *field;
+	bool nsecs;
+
+	/* Check if this is a TIMESTAMP compare */
+	if ((nsecs = (strcmp(field_name, TIMESTAMP_COMPARE) == 0)) ||
+	    strcmp(field_name, TIMESTAMP_USECS_COMPARE) == 0) {
+		const char *field_nameA;
+		const char *field_nameB;
+		struct expr *exprA;
+		struct expr *exprB;
+		struct field *fieldA;
+		struct field *fieldB;
+
+		if (nsecs) {
+			field_nameA = EVENT_END "." TIMESTAMP_NSECS;
+			field_nameB = EVENT_START "." TIMESTAMP_NSECS;
+		} else {
+			field_nameA = EVENT_END "." TIMESTAMP_USECS;
+			field_nameB = EVENT_START "." TIMESTAMP_USECS;
+		}
+
+		exprA = find_field(sb, field_nameA, NULL);
+		if (!exprA) {
+			create_field(fieldA, &exprA);
+			fieldA->next = table->fields;
+			table->fields = exprA;
+			fieldA->raw = field_nameA;
+		}
+
+		exprB = find_field(sb, field_nameB, NULL);
+		if (!exprB) {
+			create_field(fieldB, &exprB);
+			fieldB->next = table->fields;
+			table->fields = exprB;
+			fieldB->raw = field_nameB;
+		}
+
+		return add_compare(sb, exprA, exprB, COMPARE_SUB);
+	}
 
 	expr = find_field(sb, field_name, label);
 	if (expr)
@@ -597,17 +642,25 @@ static int update_vars(struct tep_handle *tep,
 	enum field_type ftype = FIELD_NONE;
 	struct tep_event *event;
 	struct field *field;
+	const char *extra_label;
 	const char *label;
 	const char *raw = event_field->raw;
 	const char *event_name;
 	const char *system;
 	const char *p;
 	int label_len = 0, event_len, system_len;
+	int extra_label_len = 0;
 
-	if (expr == table->to)
+	if (expr == table->to) {
 		ftype = FIELD_TO;
-	else if (expr == table->from)
+		extra_label = EVENT_END;
+	} else if (expr == table->from) {
 		ftype = FIELD_FROM;
+		extra_label = EVENT_START;
+	}
+
+	if (extra_label)
+		extra_label_len = strlen(extra_label);
 
 	p = strchr(raw, '.');
 	if (p) {
@@ -673,6 +726,13 @@ static int update_vars(struct tep_handle *tep,
 			goto found;
 		}
 
+		len = extra_label_len;
+		if (extra_label && !strncmp(raw, extra_label, len) &&
+		    raw[len] == '.') {
+			/* Label matches and takes precedence */
+			goto found;
+		}
+
 		if (!strncmp(raw, system, system_len) &&
 		    raw[system_len] == '.') {
 			raw += system_len + 1;
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 6a817125419f..a94a1f28258a 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -49,6 +49,9 @@
 #define SQL_5_SQL	"select end.common_pid as pid, (end.common_timestamp.usecs - start.common_timestamp.usecs) as irq_lat from irq_disable as start join irq_enable as end on start.common_pid = end.common_pid, start.parent_offs == end.parent_offs where start.common_pid != 0"
 #define SQL_5_START	"irq_disable"
 
+#define SQL_6_EVENT	"wakeup_lat_3"
+#define SQL_6_SQL	"select start.pid, end.next_prio as prio, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start join sched_switch as end on start.pid = end.next_pid where (start.prio >= 1 && start.prio < 100) || !(start.pid >= 0 && start.pid <= 1) && end.prev_pid != 0"
+
 #define DEBUGFS_DEFAULT_PATH "/sys/kernel/debug"
 #define TRACEFS_DEFAULT_PATH "/sys/kernel/tracing"
 #define TRACEFS_DEFAULT2_PATH "/sys/kernel/debug/tracing"
@@ -420,6 +423,13 @@ static void test_instance_trace_sql(struct tracefs_instance *instance)
 		trace_seq_reset(&seq);
 	}
 
+	synth = tracefs_sql(tep, SQL_6_EVENT, SQL_6_SQL, NULL);
+	CU_TEST(synth != NULL);
+	ret = tracefs_synth_echo_cmd(&seq, synth);
+	CU_TEST(ret == 0);
+	tracefs_synth_free(synth);
+	trace_seq_reset(&seq);
+
 	trace_seq_destroy(&seq);
 }
 
-- 
2.42.0

