Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B21200D5
	for <linux-trace-devel@vger.kernel.org>; Fri,  6 Oct 2023 19:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0FCC433C7;
	Fri,  6 Oct 2023 19:07:39 +0000 (UTC)
Date: Fri, 6 Oct 2023 15:08:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Subject: [PATCH v2] libtraceeval: Add wake-lat sample code
Message-ID: <20231006150851.480bd35e@gandalf.local.home>
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

Add code that reads a trace.dat file and searches for the sched_waking and
sched_switch events. It then keeps track of the wake up latency of each
task as well as keeps statistics on that latency. At the end, it will
report the max/min total and count of each latency. For the max and min,
it also shows the timestamp of when they happened.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/linux-trace-devel/20231005181621.118120c3@gandalf.local.home

 - Added traceeval_iterator_put()

 samples/Makefile   |   1 +
 samples/wake-lat.c | 172 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 173 insertions(+)
 create mode 100644 samples/wake-lat.c

diff --git a/samples/Makefile b/samples/Makefile
index eb14411189f6..256018aab572 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -4,6 +4,7 @@ include $(src)/scripts/utils.mk
 
 TARGETS :=
 TARGETS += task-eval
+TARGETS += wake-lat
 
 sdir := $(obj)/bin
 
diff --git a/samples/wake-lat.c b/samples/wake-lat.c
new file mode 100644
index 000000000000..086f67d8fe49
--- /dev/null
+++ b/samples/wake-lat.c
@@ -0,0 +1,172 @@
+#include <unistd.h>
+#include <sys/wait.h>
+#include <trace-cmd.h>
+#include <traceeval.h>
+
+struct data {
+	struct traceeval		*teval_wakeup;
+	struct traceeval		*teval_sched;
+};
+
+struct traceeval_type wakeup_keys[] = {
+	{
+		.name		= "PID",
+		.type		= TRACEEVAL_TYPE_NUMBER,
+	}
+};
+
+struct traceeval_type wakeup_vals[] = {
+	{
+		.name		= "timestamp",
+		.flags		= TRACEEVAL_FL_TIMESTAMP,
+		.type		= TRACEEVAL_TYPE_NUMBER_64,
+	}
+};
+
+struct traceeval_type sched_keys[] = {
+	{
+		.name		= "COMM",
+		.type		= TRACEEVAL_TYPE_STRING,
+	},
+	{
+		.name		= "PID",
+		.type		= TRACEEVAL_TYPE_NUMBER,
+	}
+};
+
+struct traceeval_type sched_vals[] = {
+	{
+		.name		= "timestamp",
+		.flags		= TRACEEVAL_FL_TIMESTAMP,
+		.type		= TRACEEVAL_TYPE_NUMBER_64,
+	},
+	{
+		.name		= "delta",
+		.flags		= TRACEEVAL_FL_STAT,
+		.type		= TRACEEVAL_TYPE_NUMBER_64,
+	}
+};
+
+static int wakeup_callback(struct tracecmd_input *handle, struct tep_event *event,
+			   struct tep_record *record, int cpu, void *d)
+{
+	static struct tep_format_field *pid_field;
+	struct data *data = d;
+	unsigned long long val;
+	long pid;
+	struct traceeval_data keys[1];
+	struct traceeval_data vals[1];
+
+	if (!pid_field)
+		pid_field = tep_find_field(event, "pid");
+
+	tep_read_number_field(pid_field, record->data, &val);
+	pid = val;
+
+	TRACEEVAL_SET_NUMBER(keys[0], pid);
+	TRACEEVAL_SET_NUMBER_64(vals[0], record->ts);
+
+	traceeval_insert(data->teval_wakeup, keys, vals);
+
+	return 0;
+}
+
+static int sched_callback(struct tracecmd_input *handle, struct tep_event *event,
+			   struct tep_record *record, int cpu, void *d)
+{
+	static struct tep_format_field *next_pid_field;
+	static struct tep_format_field *next_comm_field;
+	struct data *data = d;
+	unsigned long long delta;
+	unsigned long long val;
+	long pid;
+	struct traceeval_data wakeup_keys[1];
+	struct traceeval_data keys[2];
+	struct traceeval_data vals[2];
+	const struct traceeval_data *results;
+
+	if (!next_pid_field) {
+		next_pid_field = tep_find_field(event, "next_pid");
+		next_comm_field = tep_find_field(event, "next_comm");
+	}
+
+	tep_read_number_field(next_pid_field, record->data, &val);
+	pid = val;
+
+	TRACEEVAL_SET_NUMBER(wakeup_keys[0], pid);
+
+	if (traceeval_query(data->teval_wakeup, wakeup_keys, &results) <= 0)
+		return 0;
+
+	delta = record->ts - results[0].number_64;
+	traceeval_results_release(data->teval_wakeup, results);
+
+	TRACEEVAL_SET_CSTRING(keys[0], record->data + next_comm_field->offset);
+	TRACEEVAL_SET_NUMBER(keys[1], pid);
+
+	TRACEEVAL_SET_NUMBER_64(vals[0], record->ts);
+	TRACEEVAL_SET_NUMBER_64(vals[1], delta);
+
+	traceeval_insert(data->teval_sched, keys, vals);
+
+	return 0;
+}
+
+static void show_latency(struct data *data)
+{
+	struct traceeval_iterator *iter = traceeval_iterator_get(data->teval_sched);
+	const struct traceeval_data *keys;
+
+	printf("\n");
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		struct traceeval_stat *stat;
+		unsigned long long val;
+		unsigned long long ts;
+
+		stat = traceeval_iterator_stat(iter, sched_vals[1].name);
+		if (!stat)
+			continue;
+
+		printf("%s-%ld\n", keys[0].string, keys[1].number);
+
+		val = traceeval_stat_max_timestamp(stat, &ts),
+
+		printf("\tmax:%lld at %lld\n", val, ts);
+
+		val = traceeval_stat_min_timestamp(stat, &ts);
+		printf("\tmin:%lld at %lld\n", val, ts);
+		printf("\ttotal:%lld count:%lld\n",
+		       traceeval_stat_total(stat),
+		       traceeval_stat_count(stat));
+	}
+	traceeval_iterator_put(iter);
+}
+
+int main (int argc, char **argv)
+{
+	struct tracecmd_input *handle;
+	struct data data;
+
+	if (argc < 2) {
+		printf("usage: wake-lat trace.dat\n");
+		exit(-1);
+	}
+
+	data.teval_wakeup = traceeval_init(wakeup_keys, wakeup_vals);
+	data.teval_sched = traceeval_init(sched_keys, sched_vals);
+
+	handle = tracecmd_open(argv[1], TRACECMD_FL_LOAD_NO_PLUGINS);
+	if (!handle) {
+		perror(argv[0]);
+		exit(-1);
+	}
+
+	tracecmd_follow_event(handle, "sched", "sched_waking", wakeup_callback, &data);
+	tracecmd_follow_event(handle, "sched", "sched_switch", sched_callback, &data);
+
+	tracecmd_iterate_events(handle, NULL, 0, NULL, NULL);
+
+	show_latency(&data);
+
+	return 0;
+}
-- 
2.40.1

