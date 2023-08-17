Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E956EC5320E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355011AbjHQUqC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355012AbjHQUpc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:45:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF5535B8
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:45:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C4C165D27
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 20:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2095FC433BB;
        Thu, 17 Aug 2023 20:45:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWjs1-000TqD-1n;
        Thu, 17 Aug 2023 16:45:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v4 19/20] libtraceeval samples: Update task-eval to use the histogram logic
Date:   Thu, 17 Aug 2023 16:45:27 -0400
Message-Id: <20230817204528.114577-20-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817204528.114577-1-rostedt@goodmis.org>
References: <20230817204528.114577-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Convert task-eval over to the new API.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 samples/Makefile    |   2 +-
 samples/task-eval.c | 743 +++++++++++++++++++++++++-------------------
 2 files changed, 426 insertions(+), 319 deletions(-)

diff --git a/samples/Makefile b/samples/Makefile
index 012301ec5542..eb14411189f6 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -19,7 +19,7 @@ $(sdir):
 
 $(TARGETS): $(sdir) $(LIBTRACEEVAL_STATIC)
 
-$(sdir)/%: $(bdir)/%.o
+$(sdir)/%: $(LIBTRACEEVAL_STATIC) $(bdir)/%.o
 	$(call do_sample_build,$@,$<)
 
 $(bdir)/%.o: $(bdir)/%.c
diff --git a/samples/task-eval.c b/samples/task-eval.c
index 9214777ee2e1..66d0c40dc0c8 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -5,7 +5,7 @@
 #include <getopt.h>
 #include <errno.h>
 #include <trace-cmd.h>
-#include <traceeval.h>
+#include <traceeval-hist.h>
 
 static char *argv0;
 
@@ -80,6 +80,79 @@ void pdie(const char *fmt, ...)
 	va_end(ap);
 }
 
+static struct traceeval_type cpu_keys[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "CPU",
+	},
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Schedule state",
+	},
+	{
+		.type = TRACEEVAL_TYPE_NONE
+	}
+};
+
+static struct traceeval_type process_keys[] = {
+	{
+		.type = TRACEEVAL_TYPE_STRING,
+		.name = "COMM"
+	},
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Schedule state"
+	},
+	{
+		.type	= TRACEEVAL_TYPE_NONE,
+	}
+};
+
+static struct traceeval_type process_data_vals[] = {
+	{
+		.type = TRACEEVAL_TYPE_POINTER,
+		.name = "data",
+	},
+	{
+		.type = TRACEEVAL_TYPE_NONE
+	}
+};
+
+static struct traceeval_type thread_keys[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "TID",
+	},
+	{
+		.type = TRACEEVAL_TYPE_NUMBER,
+		.name = "Schedule state",
+	},
+	{
+		.type = TRACEEVAL_TYPE_NONE,
+	}
+};
+
+static struct traceeval_type timestamp_vals[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER_64,
+		.name = "Timestamp",
+		.flags = TRACEEVAL_FL_TIMESTAMP,
+	},
+	{
+		.type = TRACEEVAL_TYPE_NONE
+	}
+};
+
+static struct traceeval_type delta_vals[] = {
+	{
+		.type	= TRACEEVAL_TYPE_NUMBER_64,
+		.name	= "delta",
+	},
+	{
+		.type	= TRACEEVAL_TYPE_NONE,
+	},
+};
+
 enum sched_state {
 	RUNNING,
 	BLOCKED,
@@ -89,16 +162,22 @@ enum sched_state {
 	OTHER
 };
 
+struct teval_pair {
+	struct traceeval	*start;
+	struct traceeval	*stop;
+};
+
 struct process_data {
-	struct traceeval	*teval_cpus;
-	struct traceeval	*teval_threads;
+	struct teval_pair	teval_cpus;
+	struct teval_pair	teval_threads;
 	char			*comm;
 	int			state;
 };
 
 struct task_data {
-	struct traceeval	*teval_cpus;
-	struct traceeval	*teval_processes;
+	struct teval_pair	teval_cpus;
+	struct teval_pair	teval_processes;
+	struct traceeval	*teval_processes_data;
 	char			*comm;
 };
 
@@ -111,30 +190,52 @@ static void update_process(struct task_data *tdata, const char *comm,
 			   enum sched_state state, enum command cmd,
 			   unsigned long long ts)
 {
-	struct traceeval_key keys[] = {
+	union traceeval_data keys[] = {
 		{
-			.type = TRACEEVAL_TYPE_STRING,
-			.string = comm,
+			.cstring	= comm,
 		},
 		{
-			.type = TRACEEVAL_TYPE_NUMBER,
-			.number = state,
-		}
+			.number		= state,
+		},
 	};
+	union traceeval_data vals[] = {
+		{
+			.number_64	= ts,
+		},
+	};
+	union traceeval_data new_vals[1] = { };
+	const union traceeval_data *results;
 	int ret;
 
 	switch (cmd) {
 	case START:
-		ret = traceeval_n_start(tdata->teval_processes, keys, ts);
+		ret = traceeval_insert(tdata->teval_processes.start, keys, vals);
 		if (ret < 0)
 			pdie("Could not start process");
 		return;
 	case STOP:
-		ret = traceeval_n_stop(tdata->teval_processes, keys, ts);
+		ret = traceeval_query(tdata->teval_processes.start, keys, &results);
+		if (ret < 0)
+			pdie("Could not query start process");
+		if (ret == 0)
+			return;
+		if (!results[0].number_64)
+			break;
+
+		new_vals[0].number_64 = ts - results[0].number_64;
+
+		ret = traceeval_insert(tdata->teval_processes.stop, keys, new_vals);
 		if (ret < 0)
 			pdie("Could not stop process");
-		return;
+
+		/* Reset the start */
+		new_vals[0].number_64 = 0;
+		ret = traceeval_insert(tdata->teval_processes.start, keys, new_vals);
+		if (ret < 0)
+			pdie("Could not start CPU");
+		break;
 	}
+	traceeval_results_release(tdata->teval_processes.start, results);
 }
 
 static void start_process(struct task_data *tdata, const char *comm,
@@ -152,105 +253,172 @@ static void stop_process(struct task_data *tdata, const char *comm,
 static struct process_data *
 get_process_data(struct task_data *tdata, const char *comm)
 {
-	struct traceeval_key keys[] = {
+	union traceeval_data keys[] = {
 		{
-			.type = TRACEEVAL_TYPE_STRING,
-			.string = comm,
+			.cstring = comm,
 		},
 		{
-			.type = TRACEEVAL_TYPE_NUMBER,
 			.number = RUNNING,
 		}
 	};
+	const union traceeval_data *results;
+	void *data;
+	int ret;
+
+	ret = traceeval_query(tdata->teval_processes_data, keys, &results);
+	if (ret < 0)
+		pdie("Could not query process data");
+	if (ret == 0)
+		return NULL;
 
-	return traceeval_n_get_private(tdata->teval_processes, keys);
+	data = results[0].pointer;
+	traceeval_results_release(tdata->teval_processes_data, results);
+	return data;
 }
 
 void set_process_data(struct task_data *tdata, const char *comm, void *data)
 {
-	struct traceeval_key keys[] = {
+	union traceeval_data keys[] = {
 		{
-			.type = TRACEEVAL_TYPE_STRING,
-			.string = comm,
+			.cstring = comm,
 		},
 		{
-			.type = TRACEEVAL_TYPE_NUMBER,
 			.number = RUNNING,
 		}
 	};
+	union traceeval_data new_vals[1] = { };
+	const union traceeval_data *results;
 	int ret;
 
-	ret = traceeval_n_set_private(tdata->teval_processes, keys, data);
+	ret = traceeval_query(tdata->teval_processes_data, keys, &results);
+	if (ret > 0)
+		goto out; /* It already exists ? */
+	if (ret < 0)
+		pdie("Could not query process data");
+
+	new_vals[0].pointer = data;
+	ret = traceeval_insert(tdata->teval_processes_data, keys, new_vals);
 	if (ret < 0)
 		pdie("Failed to set process data");
+
+ out:
+	traceeval_results_release(tdata->teval_processes_data, results);
 }
 
-static void update_cpu(struct traceeval *teval, int cpu,
+static void update_cpu(struct teval_pair *teval_pair, int cpu,
 		       enum sched_state state, enum command cmd,
 		       unsigned long long ts)
 {
-	struct traceeval_key keys[] = {
+	const union traceeval_data *results;
+	union traceeval_data keys[] = {
 		{
-			.type = TRACEEVAL_TYPE_NUMBER,
 			.number = cpu,
 		},
 		{
-			.type = TRACEEVAL_TYPE_NUMBER,
 			.number = state,
 		}
 	};
+	union traceeval_data vals[] = {
+		{
+			.number_64	= ts,
+		},
+	};
+	union traceeval_data new_vals[1] = { };
 	int ret;
 
 	switch (cmd) {
 	case START:
-		ret = traceeval_n_continue(teval, keys, ts);
+		/* Only set if the timestamp is zero (or doesn't exist) */
+		ret = traceeval_query(teval_pair->start, keys, &results);
+		if (ret > 0) {
+			if (results[0].number_64)
+				break;
+		}
+		if (ret < 0)
+			pdie("Could not query cpu start data");
+		ret = traceeval_insert(teval_pair->start, keys, vals);
 		if (ret < 0)
 			pdie("Could not start CPU");
-		return;
+		break;
 	case STOP:
-		ret = traceeval_n_stop(teval, keys, ts);
+		ret = traceeval_query(teval_pair->start, keys, &results);
+		if (ret < 0)
+			pdie("Could not query cpu stop data");
+		if (ret == 0)
+			return;
+
+		if (!results[0].number_64)
+			break;
+
+		new_vals[0].number_64 = ts - results[0].number_64;
+
+		ret = traceeval_insert(teval_pair->stop, keys, new_vals);
 		if (ret < 0)
 			pdie("Could not stop CPU");
-		return;
+
+		/* Reset the start */
+		new_vals[0].number_64 = 0;
+		ret = traceeval_insert(teval_pair->start, keys, new_vals);
+		if (ret < 0)
+			pdie("Could not start CPU");
+
+		break;
+		default:
+			return;
 	}
+	traceeval_results_release(teval_pair->start, results);
 }
 
-static void start_cpu(struct traceeval *teval, int cpu,
+static void start_cpu(struct teval_pair *teval_pair, int cpu,
 		      enum sched_state state,  unsigned long long ts)
 {
-	update_cpu(teval, cpu, state, START, ts);
+	update_cpu(teval_pair, cpu, state, START, ts);
 }
 
-static void stop_cpu(struct traceeval *teval, int cpu,
+static void stop_cpu(struct teval_pair *teval_pair, int cpu,
 		     enum sched_state state, unsigned long long ts)
 {
-	update_cpu(teval, cpu, state, STOP, ts);
+	update_cpu(teval_pair, cpu, state, STOP, ts);
 }
 
 static void update_thread(struct process_data *pdata, int tid,
 			  enum sched_state state, enum command cmd,
 			  unsigned long long ts)
 {
-	struct traceeval_key keys[] = {
+	const union traceeval_data *results;
+	union traceeval_data keys[] = {
 		{
-			.type = TRACEEVAL_TYPE_NUMBER,
 			.number = tid,
 		},
 		{
-			.type = TRACEEVAL_TYPE_NUMBER,
 			.number = state,
 		}
 	};
+	union traceeval_data vals[] = {
+		{
+			.number_64	= ts,
+		},
+	};
+	union traceeval_data new_vals[1] = { };
 	int ret;
 
 	switch (cmd) {
 	case START:
-		ret = traceeval_n_start(pdata->teval_threads, keys, ts);
+		ret = traceeval_insert(pdata->teval_threads.start, keys, vals);
 		if (ret < 0)
 			pdie("Could not start thread");
 		return;
 	case STOP:
-		ret = traceeval_n_stop(pdata->teval_threads, keys, ts);
+		ret = traceeval_query(pdata->teval_threads.start, keys, &results);
+		if (ret < 0)
+			pdie("Could not query thread start");
+		if (ret == 0)
+			return;
+
+		new_vals[0].number_64 = ts - results[0].number_64;
+
+		ret = traceeval_insert(pdata->teval_threads.stop, keys, new_vals);
+		traceeval_results_release(pdata->teval_threads.start, results);
 		if (ret < 0)
 			pdie("Could not stop thread");
 		return;
@@ -283,34 +451,21 @@ static struct tep_format_field *get_field(struct tep_event *event, const char *n
 
 static void init_process_data(struct process_data *pdata)
 {
-	struct traceeval_key_info cpu_info[] = {
-		{
-			.type = TRACEEVAL_TYPE_NUMBER,
-			.name = "CPU",
-		},
-		{
-			.type = TRACEEVAL_TYPE_NUMBER,
-			.name = "Schedule state",
-		}
-	};
-	struct traceeval_key_info thread_info[] = {
-		{
-			.type = TRACEEVAL_TYPE_NUMBER,
-			.name = "TID",
-		},
-		{
-			.type = TRACEEVAL_TYPE_NUMBER,
-			.name = "Schedule state",
-		}
-	};
 
-	pdata->teval_cpus = traceeval_2_alloc("CPUs", cpu_info);
-	if (!pdata->teval_cpus)
-		pdie("Creating trace eval");
+	pdata->teval_cpus.start = traceeval_init(cpu_keys, timestamp_vals);
+	if (!pdata->teval_cpus.start)
+		pdie("Creating trace eval cpus start");
+	pdata->teval_cpus.stop = traceeval_init(cpu_keys, delta_vals);
+	if (!pdata->teval_cpus.stop)
+		pdie("Creating trace eval cpus");
 
-	pdata->teval_threads = traceeval_2_alloc("Threads", thread_info);
-	if (!pdata->teval_threads)
-		pdie("Creating trace eval");
+	pdata->teval_threads.start = traceeval_init(thread_keys, timestamp_vals);
+	if (!pdata->teval_threads.start)
+		pdie("Creating trace eval threads start");
+
+	pdata->teval_threads.stop = traceeval_init(thread_keys, delta_vals);
+	if (!pdata->teval_threads.stop)
+		pdie("Creating trace eval threads");
 }
 
 static struct process_data *alloc_pdata(struct task_data *tdata, const char *comm)
@@ -344,7 +499,7 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	pid = val;
 	if (!pid) {
 		/* Record the runtime for the process CPUs */
-		stop_cpu(tdata->teval_cpus, record->cpu, IDLE, record->ts);
+		stop_cpu(&tdata->teval_cpus, record->cpu, IDLE, record->ts);
 		return;
 	}
 
@@ -381,10 +536,10 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	start_thread(pdata, pid, pdata->state, record->ts);
 
 	/* Record the runtime for the process CPUs */
-	stop_cpu(pdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	stop_cpu(&pdata->teval_cpus, record->cpu, RUNNING, record->ts);
 
 	/* Record the runtime for the all CPUs */
-	stop_cpu(tdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	stop_cpu(&tdata->teval_cpus, record->cpu, RUNNING, record->ts);
 }
 
 static void sched_in(struct task_data *tdata, const char *comm,
@@ -405,7 +560,7 @@ static void sched_in(struct task_data *tdata, const char *comm,
 	/* Ignore the idle task */
 	if (!pid) {
 		/* Record the runtime for the process CPUs */
-		start_cpu(tdata->teval_cpus, record->cpu, IDLE, record->ts);
+		start_cpu(&tdata->teval_cpus, record->cpu, IDLE, record->ts);
 		return;
 	}
 
@@ -415,7 +570,7 @@ static void sched_in(struct task_data *tdata, const char *comm,
 	pdata = get_process_data(tdata, comm);
 
 	/* Start recording the running time of process CPUs */
-	start_cpu(tdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	start_cpu(&tdata->teval_cpus, record->cpu, RUNNING, record->ts);
 
 	/* If there was no pdata, then this process did not go through sched out */
 	if (!pdata) {
@@ -427,7 +582,7 @@ static void sched_in(struct task_data *tdata, const char *comm,
 	start_thread(pdata, pid, RUNNING, record->ts);
 
 	/* Start recording the running time of process CPUs */
-	start_cpu(pdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	start_cpu(&pdata->teval_cpus, record->cpu, RUNNING, record->ts);
 
 	/* If it was just created, there's nothing to stop */
 	if (is_new)
@@ -482,32 +637,83 @@ static void print_microseconds(int idx, unsigned long long nsecs)
 		printf("%*d.%03lld\n", idx, 0, nsecs);
 }
 
+/*
+ * Sort all the processes by the RUNNING state.
+ *  If A and B have the same COMM, then sort by state.
+ *  else
+ *    Find the RUNNNIG state for A and B
+ *    If the RUNNING state does not exist, it's considered -1
+ *  If RUNNING is equal, then sort by COMM.
+ */
+static int compare_pdata(struct traceeval *teval_data,
+				const union traceeval_data *Akeys,
+				const union traceeval_data *Avals,
+				const union traceeval_data *Bkeys,
+				const union traceeval_data *Bvals,
+				void *data)
+{
+	struct traceeval *teval = data; /* The deltas are here */
+	union traceeval_data keysA[] = {
+		{ .cstring = Akeys[0].cstring }, { .number = RUNNING } };
+	union traceeval_data keysB[] = {
+		{ .cstring = Bkeys[0].cstring }, { .number = RUNNING } };
+	struct traceeval_stat *statA;
+	struct traceeval_stat *statB;
+	unsigned long long totalA = -1;
+	unsigned long long totalB = -1;
+
+	/* First check if we are on the same task */
+	if (strcmp(Akeys[0].cstring, Bkeys[0].cstring) == 0) {
+		/* Sort decending */
+		if (Bkeys[1].number > Akeys[1].number)
+			return -1;
+		return Bkeys[1].number != Akeys[1].number;
+	}
+
+	/* Get the RUNNING values for both processes */
+	statA = traceeval_stat(teval, keysA, &delta_vals[0]);
+	if (statA)
+		totalA = traceeval_stat_total(statA);
+
+	statB = traceeval_stat(teval, keysB, &delta_vals[0]);
+	if (statB)
+		totalB = traceeval_stat_total(statB);
+
+	if (totalB < totalA)
+		return -1;
+	if (totalB > totalA)
+		return 1;
+
+	return strcmp(Bkeys[0].cstring, Akeys[0].cstring);
+}
+
 static void display_cpus(struct traceeval *teval)
 {
-	struct traceeval_key_array *karray;
-	const struct traceeval_key *ckey;
-	const struct traceeval_key *skey;
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
+	const union traceeval_data *keys;
+	struct traceeval_stat *stat;
 	int last_cpu = -1;
-	int i, nr;
+
+	if (!iter)
+		pdie("Could not get iterator?");
 
 	printf("\n");
 
-	nr = traceeval_result_nr(teval);
-	if (!nr)
-		die("No result for CPUs\n");
+	traceeval_iterator_sort(iter, cpu_keys[0].name, 0, true);
+	traceeval_iterator_sort(iter, cpu_keys[1].name, 1, true);
 
-	for (i = 0; i < nr; i++) {
-		karray = traceeval_result_indx_key_array(teval, i);
-		if (!karray)
-			die("No cpu key for result %d\n", i);
-		ckey = traceeval_key_array_indx(karray, 0);
-		skey = traceeval_key_array_indx(karray, 1);
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		int state = keys[1].number;
+		int cpu = keys[0].number;
 
+		stat = traceeval_stat(teval, keys, &delta_vals[0]);
+		if (!stat)
+			continue; // die?
 
-		if (last_cpu != ckey->number)
-			printf("    CPU [%d]:\n", (int)ckey->number);
+		if (last_cpu != cpu)
+			printf("    CPU [%d]:\n", cpu);
 
-		switch (skey->number) {
+		switch (state) {
 		case RUNNING:
 			printf("       Running: ");
 			break;
@@ -518,256 +724,170 @@ static void display_cpus(struct traceeval *teval)
 		case PREEMPT:
 		case SLEEP:
 		case OTHER:
-			printf("         \?\?(%ld): ", skey->number);
+			printf("         \?\?(%d): ", state);
 			break;
 		}
 		printf(" time (us):");
-		print_microseconds(12, traceeval_result_indx_total(teval, i));
+		print_microseconds(12, traceeval_stat_total(stat));
 
-		last_cpu = ckey->number;
+		last_cpu = cpu;
 	}
+
+	if (last_cpu < 0)
+		die("No result for CPUs\n");
+
 }
 
-static void display_thread(struct traceeval *teval, int tid)
-{
-	struct traceeval_key keys[2] =
-		{
-			{
-				.type = TRACEEVAL_TYPE_NUMBER,
-				.number = tid,
-			},
-			{
-				.type = TRACEEVAL_TYPE_NUMBER,
-				.number = RUNNING,
-			}
-		};
-	ssize_t ret;
-
-	printf("\n    thread id: %d\n", tid);
-
-	printf("      Total run time (us):");
-	print_microseconds(14, (ret = traceeval_result_keys_total(teval, keys)) < 0 ? 0 : ret);
-
-	keys[1].number = PREEMPT;
-	printf("      Total preempt time (us):");
-	print_microseconds(10, (ret = traceeval_result_keys_total(teval, keys)) < 0 ? 0 : ret);
-
-	keys[1].number = BLOCKED;
-	printf("      Total blocked time (us):");
-	print_microseconds(10, (ret = traceeval_result_keys_total(teval, keys)) < 0 ? 0 : ret);
-
-	keys[1].number = SLEEP;
-	printf("      Total sleep time (us):");
-	print_microseconds(12, (ret = traceeval_result_keys_total(teval, keys)) < 0 ? 0 : ret);
-};
+static void display_state_times(int state, unsigned long long total)
+{
+	switch (state) {
+	case RUNNING:
+		printf("      Total run time (us):");
+		print_microseconds(14, total);
+		break;
+	case BLOCKED:
+		printf("      Total blocked time (us):");
+		print_microseconds(10, total);
+		break;
+	case PREEMPT:
+		printf("      Total preempt time (us):");
+		print_microseconds(10, total);
+		break;
+	case SLEEP:
+		printf("      Total sleep time (us):");
+		print_microseconds(12, total);
+	}
+}
 
 static void display_threads(struct traceeval *teval)
 {
-	struct traceeval_key_array *karray;
-	const struct traceeval_key *tkey;
-	struct traceeval_key keys[2];
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
+	const union traceeval_data *keys;
+	struct traceeval_stat *stat;
 	int last_tid = -1;
-	int i, nr;
 
-	nr = traceeval_result_nr(teval);
-	if (!nr)
-		die("No result for threads\n");
+	traceeval_iterator_sort(iter, thread_keys[0].name, 0, true);
+	traceeval_iterator_sort(iter, thread_keys[1].name, 1, true);
 
-	memset(keys, 0, sizeof(keys));
-	keys[1].type = TRACEEVAL_TYPE_NUMBER;
-
-	for (i = 0; i < nr; i++) {
-		karray = traceeval_result_indx_key_array(teval, i);
-		if (!karray)
-			die("No thread key for result %d\n", i);
-		tkey = traceeval_key_array_indx(karray, 0);
-		if (!tkey)
-			die("No thread keys for result?");
-
-		/*
-		 * All the TIDS should be together in the results,
-		 * as the results are sorted by the first key, which
-		 * is the comm.
-		 */
-		if (last_tid == tkey->number)
-			continue;
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		int state = keys[1].number;
+		int tid = keys[0].number;
+
+		stat = traceeval_stat(teval, keys, &delta_vals[0]);
+		if (!stat)
+			continue; // die?
+
+		if (last_tid != keys[0].number)
+			printf("\n    thread id: %d\n", tid);
 
-		last_tid = tkey->number;
+		last_tid = tid;
 
-		display_thread(teval, tkey->number);
+		display_state_times(state, traceeval_stat_total(stat));
 	}
+
+	if (last_tid < 0)
+		die("No result for threads\n");
+
 }
 
-static void display_process(struct traceeval *teval, struct process_data *pdata,
-			    const char *comm)
+static void display_process(struct process_data *pdata)
 {
-	struct traceeval_key keys[2] =
-		{
-			{
-				.type = TRACEEVAL_TYPE_STRING,
-				.string = comm,
-			},
-			{
-				.type = TRACEEVAL_TYPE_NUMBER,
-				.number = RUNNING,
-			}
-		};
-	ssize_t ret;
-
-	printf("Task: %s\n", comm);
-
-	printf("  Total run time (us):");
-	print_microseconds(18, (ret = traceeval_result_keys_total(teval, keys)) < 0 ? 0 : ret);
-
-	keys[1].number = PREEMPT;
-	printf("  Total preempt time (us):");
-	print_microseconds(14, (ret = traceeval_result_keys_total(teval, keys)) < 0 ? 0 : ret);
-
-	keys[1].number = BLOCKED;
-	printf("  Total blocked time (us):");
-	print_microseconds(14, (ret = traceeval_result_keys_total(teval, keys)) < 0 ? 0 : ret);
-
-	keys[1].number = SLEEP;
-	printf("  Total sleep time (us):");
-	print_microseconds(16, (ret = traceeval_result_keys_total(teval, keys)) < 0 ? 0 : ret);
-
-	display_threads(pdata->teval_threads);
-	display_cpus(pdata->teval_cpus);
+	display_threads(pdata->teval_threads.stop);
+	display_cpus(pdata->teval_cpus.stop);
 	printf("\n");
 }
 
-static int compare_pdata(struct traceeval *teval,
-			 const struct traceeval_key_array *A,
-			 const struct traceeval_key_array *B,
-			 void *data)
+static void display_process_stats(struct traceeval *teval,
+				  struct process_data *pdata, const char *comm)
 {
-	struct traceeval_key akeys[2];
-	struct traceeval_key bkeys[2];
-	const struct traceeval_key *akey;
-	const struct traceeval_key *bkey;
-	long long aval;
-	long long bval;
-	int ret;
-
-	/* Get the RUNNING values for this process */
-
-	akey = traceeval_key_array_indx(A, 0);
-	akeys[0] = *akey;
-	akeys[1].type = TRACEEVAL_TYPE_NUMBER;
-	akeys[1].number = RUNNING;
-
-	bkey = traceeval_key_array_indx(B, 0);
-	bkeys[0] = *bkey;
-	bkeys[1].type = TRACEEVAL_TYPE_NUMBER;
-	bkeys[1].number = RUNNING;
-
-	aval = traceeval_result_keys_total(teval, akey);
-	bval = traceeval_result_keys_total(teval, bkeys);
-
-	if (aval < 0)
-		return -1;
-	if (bval < 0)
-		return -1;
-
-	if (bval < aval)
-		return -1;
-	if (bval > aval)
-		return 1;
-
-	ret = strcmp(bkeys[0].string, akeys[0].string);
+	struct traceeval_stat *stat;
+	unsigned long long delta;
+	union traceeval_data keys[] = {
+		{
+			.cstring = comm,
+		},
+		{
+			.number = RUNNING,
+		}
+	};
 
-	/* If two different processes have the same runtime, sort by name */
-	if (ret)
-		return ret;
+	for (int i = 0; i < OTHER; i++) {
+		keys[1].number = i;
 
-	/* Same process, sort by state */
+		delta = 0;
+		stat = traceeval_stat(teval, keys, &delta_vals[0]);
+		if (stat)
+			delta = traceeval_stat_total(stat);
+		display_state_times(i, delta);
+	}
+}
 
-	akey = traceeval_key_array_indx(A, 1);
-	bkey = traceeval_key_array_indx(B, 1);
+static void display_processes(struct traceeval *teval,
+			      struct traceeval *teval_data)
+{
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval_data);
+	const union traceeval_data *keys;
+	int ret;
 
-	if (bkey->number < akey->number)
-		return -1;
+	traceeval_iterator_sort_custom(iter, compare_pdata, teval);
 
-	return bkey->number > akey->number;
-}
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		const union traceeval_data *results;
+		struct process_data *pdata = NULL;
+		const char *comm = keys[0].cstring;
 
-static void display_processes(struct traceeval *teval)
-{
-	struct traceeval_key_array *karray;
-	const struct traceeval_key *tkey;
-	struct traceeval_key keys[2];
-	struct process_data *pdata;
-	const char *last_comm = NULL;
-	int i, nr;
-
-	nr = traceeval_result_nr(teval);
-	if (!nr)
-		die("No result for processes\n");
-
-	memset(keys, 0, sizeof(keys));
-	keys[1].type = TRACEEVAL_TYPE_NUMBER;
-
-	for (i = 0; i < nr; i++) {
-		karray = traceeval_result_indx_key_array(teval, i);
-		if (!karray)
-			die("No process key for result %d\n", i);
-		tkey = traceeval_key_array_indx(karray, 0);
-		if (!tkey)
-			die("No process keys for result?");
-
-		/*
-		 * All the comms should be together in the results,
-		 * as the results are sorted by the first key, which
-		 * is the comm.
-		 */
-		if (last_comm && strcmp(tkey->string, last_comm) == 0)
-			continue;
+		ret = traceeval_query(teval_data, keys, &results);
+		if (ret < 0)
+			pdie("Could not query iterator");
+		if (ret < 1)
+			continue; /* ?? */
 
-		last_comm = tkey->string;
+		pdata = results[0].pointer;
+		traceeval_results_release(teval_data, results);
 
-		keys[0] = *tkey;
-		keys[1].number = RUNNING;
+		printf("Task: %s\n", comm);
 
-		/* All processes should have a running state */
-		pdata = traceeval_n_get_private(teval, keys);
+		display_process_stats(teval, pdata, comm);
 		if (pdata)
-			display_process(teval, pdata, keys[0].string);
+			display_process(pdata);
 	}
 }
 
 static void display(struct task_data *tdata)
 {
+	struct traceeval *teval = tdata->teval_cpus.stop;
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
+	const union traceeval_data *keys;
+	struct traceeval_stat *stat;
 	unsigned long long total_time = 0;
 	unsigned long long idle_time = 0;
-	struct traceeval_key_array *karray;
-	const struct traceeval_key *tkey;
-	unsigned long long val;
-	int i, nr;
 
-	if (tdata->comm)
-		return display_processes(tdata->teval_processes);
+	if (tdata->comm) {
+		return display_processes(tdata->teval_processes.stop,
+					 tdata->teval_processes_data);
+	}
 
 	printf("Total:\n");
 
-	nr = traceeval_result_nr(tdata->teval_cpus);
-	for (i = 0; i < nr; i++) {
-		karray = traceeval_result_indx_key_array(tdata->teval_cpus, i);
-		if (!karray)
-			die("No CPU keys for result %d\n", i);
-		tkey = traceeval_key_array_indx(karray, 1);
-		if (!tkey)
-			die("No state keys for CPU result %d?", i);
-
-		val = traceeval_result_indx_total(tdata->teval_cpus, i);
-		switch (tkey->number) {
+	if (!iter)
+		pdie("No cpus?");
+
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		int state = keys[1].number;
+
+		stat = traceeval_stat(teval, keys, &delta_vals[0]);
+		if (!stat)
+			continue;
+
+		switch (state) {
 		case RUNNING:
-			total_time += val;
+			total_time += traceeval_stat_total(stat);
 			break;
 		case IDLE:
-			idle_time += val;
+			idle_time += traceeval_stat_total(stat);
 			break;
 		default:
-			die("Invalid CPU state: %d\n", tkey->number);
+			die("Invalid CPU state: %d\n", state);
 		}
 	}
 
@@ -776,12 +896,10 @@ static void display(struct task_data *tdata)
 	printf("  Total idle time (us):");
 	print_microseconds(16, idle_time);
 
-	display_cpus(tdata->teval_cpus);
-
-	traceeval_sort_custom(tdata->teval_processes, compare_pdata, NULL);
+	display_cpus(tdata->teval_cpus.stop);
 
 	printf("\n");
-	display_processes(tdata->teval_processes);
+	display_processes(tdata->teval_processes.stop, tdata->teval_processes_data);
 }
 
 static void free_tdata(struct task_data *tdata)
@@ -792,26 +910,6 @@ int main (int argc, char **argv)
 {
 	struct tracecmd_input *handle;
 	struct task_data data;
-	struct traceeval_key_info cpu_tinfo[2] = {
-		{
-			.type = TRACEEVAL_TYPE_NUMBER,
-			.name = "CPU"
-		},
-		{
-			.type = TRACEEVAL_TYPE_NUMBER,
-			.name = "Schedule state"
-		}
-	};
-	struct traceeval_key_info process_tinfo[2] = {
-		{
-			.type = TRACEEVAL_TYPE_STRING,
-			.name = "COMM"
-		},
-		{
-			.type = TRACEEVAL_TYPE_NUMBER,
-			.name = "Schedule state"
-		}
-	};
 	int c;
 
 	memset(&data, 0, sizeof(data));
@@ -839,12 +937,21 @@ int main (int argc, char **argv)
 	if (!handle)
 		pdie("Error opening %s", argv[0]);
 
-	data.teval_processes = traceeval_2_alloc("Processes", process_tinfo);
-	if (!data.teval_processes)
+	data.teval_processes.start = traceeval_init(process_keys, timestamp_vals);
+	if (!data.teval_processes.start)
+		pdie("Creating trace eval start");
+	data.teval_processes_data = traceeval_init(process_keys, process_data_vals);
+	if (!data.teval_processes_data)
+		pdie("Creating trace eval data");
+	data.teval_processes.stop = traceeval_init(process_keys, delta_vals);
+	if (!data.teval_processes.stop)
 		pdie("Creating trace eval");
 
-	data.teval_cpus = traceeval_2_alloc("CPUs", cpu_tinfo);
-	if (!data.teval_cpus)
+	data.teval_cpus.start = traceeval_init(cpu_keys, timestamp_vals);
+	if (!data.teval_cpus.start)
+		pdie("Creating trace eval");
+	data.teval_cpus.stop = traceeval_init(cpu_keys, delta_vals);
+	if (!data.teval_cpus.stop)
 		pdie("Creating trace eval");
 
 	tracecmd_follow_event(handle, "sched", "sched_switch", switch_func, &data);
-- 
2.40.1

