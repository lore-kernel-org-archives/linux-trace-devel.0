Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0C56AA0
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC85C433CB;
	Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqPrt-007ZSi-1e;
	Tue, 10 Oct 2023 23:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 01/11] libtraceeval task-eval: Fix naming conventions of variables
Date: Tue, 10 Oct 2023 23:25:17 -0400
Message-ID: <20231011032640.1804571-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231011032640.1804571-1-rostedt@goodmis.org>
References: <20231011032640.1804571-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The naming is a bit confusing and makes it difficult to get the assigning
of the types and values of the traceevals correct. For instance, we have:

  data->teval_tasks

that is defined by process_types and process_keys.

Instead of calling it "process", call it "tasks" to match what its for.
That is, task_types and task_keys.

Also, instead of using "delta_vals" for the cpu_delta, call it
cpu_delta_vals and use that. The type and value definitions should have
the name of the teval it is defining.

Add "cpu_vals" and "thread_vals" instead of using a generic "delta_type"
for both, which is also confusing.

Finally, add a DELTA_NAME macro that is defined as "delta" which is the
name of the delta elements throughout the traceevals. This is the only
element that gets assigned a libtraceeval_stat. As retrieving a stat is
now done by name, it is much easier to just pass DELTA_NAME to it, and
guarantee that you are getting the right stat, instead of passing in the
vals[0].name, which could be wrong (and was in some cases, but luckily
what was used was the wrong value definition, but the right array index
which by luck gave the right name to use).

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/task-eval.c | 66 ++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 28 deletions(-)

diff --git a/samples/task-eval.c b/samples/task-eval.c
index 9c3bc7c6ef1e..3d748d16ee57 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -80,6 +80,9 @@ void pdie(const char *fmt, ...)
 	va_end(ap);
 }
 
+/* Used for stats */
+#define DELTA_NAME		"delta"
+
 static struct traceeval_type cpu_delta_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -87,6 +90,13 @@ static struct traceeval_type cpu_delta_keys[] = {
 	},
 };
 
+static struct traceeval_type cpu_delta_vals[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Schedule state",
+	},
+};
+
 static struct traceeval_type cpu_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
@@ -98,14 +108,21 @@ static struct traceeval_type cpu_keys[] = {
 	},
 };
 
-static struct traceeval_type process_delta_keys[] = {
+static struct traceeval_type cpu_vals[] = {
+	{
+		.type = TRACEEVAL_TYPE_DELTA,
+		.name = DELTA_NAME,
+	},
+};
+
+static struct traceeval_type task_delta_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
 		.name = "PID",
 	},
 };
 
-static struct traceeval_type process_delta_vals[] = {
+static struct traceeval_type task_delta_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_NUMBER,
 		.name = "Schedule state"
@@ -116,14 +133,7 @@ static struct traceeval_type process_delta_vals[] = {
 	},
 };
 
-static struct traceeval_type delta_vals[] = {
-	{
-		.type = TRACEEVAL_TYPE_NUMBER,
-		.name = "Schedule state"
-	},
-};
-
-static struct traceeval_type process_keys[] = {
+static struct traceeval_type task_keys[] = {
 	{
 		.type = TRACEEVAL_TYPE_STRING,
 		.name = "COMM"
@@ -134,14 +144,14 @@ static struct traceeval_type process_keys[] = {
 	},
 };
 
-static struct traceeval_type process_vals[] = {
+static struct traceeval_type task_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_POINTER,
 		.name = "data",
 	},
 	{
 		.type = TRACEEVAL_TYPE_DELTA,
-		.name = "delta",
+		.name = DELTA_NAME,
 	},
 };
 
@@ -156,10 +166,10 @@ static struct traceeval_type thread_keys[] = {
 	},
 };
 
-static struct traceeval_type delta_type[] = {
+static struct traceeval_type thread_vals[] = {
 	{
 		.type = TRACEEVAL_TYPE_DELTA,
-		.name = "delta",
+		.name = DELTA_NAME,
 	},
 };
 
@@ -191,11 +201,11 @@ enum command {
 
 static void init_process_data(struct process_data *pdata)
 {
-	pdata->teval_cpus = traceeval_init(cpu_keys, delta_type);
+	pdata->teval_cpus = traceeval_init(cpu_keys, cpu_vals);
 	if (!pdata->teval_cpus)
 		pdie("Creating trace eval cpus");
 
-	pdata->teval_threads = traceeval_init(thread_keys, delta_type);
+	pdata->teval_threads = traceeval_init(thread_keys, thread_vals);
 	if (!pdata->teval_threads)
 		pdie("Creating trace eval threads");
 }
@@ -421,7 +431,7 @@ static void sched_out(struct task_data *tdata, const char *comm,
 
 	ret = tep_read_number_field(prev_pid, record->data, &val);
 	if (ret < 0)
-		die("Could not read sched_switch next_pid for record");
+		die("Could not read sched_switch prev_pid for record");
 	pid = val;
 
 	/* Idle is handled by sched_in() */
@@ -587,11 +597,11 @@ static int compare_pdata(struct traceeval *teval,
 	}
 
 	/* Get the RUNNING values for both processes */
-	statA = traceeval_stat(teval, keysA, delta_type[0].name);
+	statA = traceeval_stat(teval, keysA, DELTA_NAME);
 	if (statA)
 		totalA = traceeval_stat_total(statA);
 
-	statB = traceeval_stat(teval, keysB, delta_type[0].name);
+	statB = traceeval_stat(teval, keysB, DELTA_NAME);
 	if (statB)
 		totalB = traceeval_stat_total(statB);
 
@@ -622,7 +632,7 @@ static void display_cpus(struct traceeval *teval)
 		int state = keys[1].number;
 		int cpu = keys[0].number;
 
-		stat = traceeval_iterator_stat(iter, delta_type[0].name);
+		stat = traceeval_iterator_stat(iter, DELTA_NAME);
 		if (!stat)
 			continue; // die?
 
@@ -688,7 +698,7 @@ static void display_threads(struct traceeval *teval)
 		int state = keys[1].number;
 		int tid = keys[0].number;
 
-		stat = traceeval_iterator_stat(iter, delta_type[0].name);
+		stat = traceeval_iterator_stat(iter, DELTA_NAME);
 		if (!stat)
 			continue; // die?
 
@@ -725,7 +735,7 @@ static void display_process_stats(struct traceeval *teval,
 		TRACEEVAL_SET_NUMBER(keys[1], i);
 
 		delta = 0;
-		stat = traceeval_stat(teval, keys, delta_type[0].name);
+		stat = traceeval_stat(teval, keys, DELTA_NAME);
 		if (stat)
 			delta = traceeval_stat_total(stat);
 		display_state_times(i, delta);
@@ -789,7 +799,7 @@ static void display(struct task_data *tdata)
 	while (traceeval_iterator_next(iter, &keys) > 0) {
 		int state = keys[1].number;
 
-		stat = traceeval_iterator_stat(iter, delta_type[0].name);
+		stat = traceeval_iterator_stat(iter, DELTA_NAME);
 		if (!stat)
 			continue;
 
@@ -895,19 +905,19 @@ int main (int argc, char **argv)
 	if (!handle)
 		pdie("Error opening %s", argv[0]);
 
-	data.teval_tasks = traceeval_init(process_keys, process_vals);
+	data.teval_tasks = traceeval_init(task_keys, task_vals);
 	if (!data.teval_tasks)
 		pdie("Creating trace eval processe data");
 
-	if (traceeval_delta_create(data.teval_tasks, process_delta_keys,
-				   process_delta_vals) < 0)
+	if (traceeval_delta_create(data.teval_tasks, task_delta_keys,
+				   task_delta_vals) < 0)
 		pdie("Creating trace delta threads");
 
-	data.teval_cpus = traceeval_init(cpu_keys, delta_type);
+	data.teval_cpus = traceeval_init(cpu_keys, cpu_vals);
 	if (!data.teval_cpus)
 		pdie("Creating trace eval");
 
-	if (traceeval_delta_create(data.teval_cpus, cpu_delta_keys, delta_vals) < 0)
+	if (traceeval_delta_create(data.teval_cpus, cpu_delta_keys, cpu_delta_vals) < 0)
 		pdie("Creating trace delta cpus");
 
 	tracecmd_follow_event(handle, "sched", "sched_switch", switch_func, &data);
-- 
2.42.0

