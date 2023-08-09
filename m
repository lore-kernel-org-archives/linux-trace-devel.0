Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91DFC04A94
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 03:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjHIDN1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 23:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjHIDNV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 23:13:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3B41FD0
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 20:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AE7C62EF6
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 03:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39200C433C7;
        Wed,  9 Aug 2023 03:13:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qTZdL-005Rvv-39;
        Tue, 08 Aug 2023 23:13:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6/6] libtraceeval samples: Update task-eval to use the histogram logic
Date:   Tue,  8 Aug 2023 23:13:13 -0400
Message-Id: <20230809031313.1298605-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230809031313.1298605-1-rostedt@goodmis.org>
References: <20230809031313.1298605-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Convert task-eval over to the new API.

Note, it still requires some functions for displaying the output, but
those were added just as stubs to get an idea on how to use it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |   1 +
 samples/Makefile         |   2 +-
 samples/task-eval.c      | 683 ++++++++++++++++++++++-----------------
 3 files changed, 388 insertions(+), 298 deletions(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index b3427c662d99..c363444f7fae 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -74,6 +74,7 @@ typedef int (*traceeval_data_cmp_fn)(struct traceeval *teval,
 				     const struct traceeval_type *type,
 				     const union traceeval_data *A,
 				     const union traceeval_data *B);
+
 /*
  * struct traceeval_type - Describes the type of a traceevent_data instance
  * @type: The enum type that describes the traceeval_data
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
index 26e48c376f45..f5515df9fef2 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -5,7 +5,7 @@
 #include <getopt.h>
 #include <errno.h>
 #include <trace-cmd.h>
-#include <traceeval.h>
+#include <traceeval-hist.h>
 
 static char *argv0;
 
@@ -80,6 +80,83 @@ void pdie(const char *fmt, ...)
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
+static struct traceeval_type process_vals[] = {
+	{
+		.type = TRACEEVAL_TYPE_NUMBER_64,
+		.name = "delta",
+	},
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
@@ -90,14 +167,18 @@ enum sched_state {
 };
 
 struct process_data {
+	struct traceeval	*teval_cpus_start;
 	struct traceeval	*teval_cpus;
+	struct traceeval	*teval_threads_start;
 	struct traceeval	*teval_threads;
 	char			*comm;
 	int			state;
 };
 
 struct task_data {
+	struct traceeval	*teval_cpus_start;
 	struct traceeval	*teval_cpus;
+	struct traceeval	*teval_processes_start;
 	struct traceeval	*teval_processes;
 	char			*comm;
 };
@@ -111,28 +192,45 @@ static void update_process(struct task_data *tdata, const char *comm,
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
+			.number		= state,
+		},
+	};
+	union traceeval_data vals[] = {
+		{
+			.number_64	= ts,
+		},
+		{
+			.number		= (long)NULL, /* data */
 		}
 	};
+	union traceeval_data *results;
+	unsigned long long delta;
 	int ret;
 
 	switch (cmd) {
 	case START:
-		ret = traceeval_n_start(tdata->teval_processes, keys, ts);
+		ret = traceeval_insert(tdata->teval_processes_start, keys, vals);
 		if (ret < 0)
 			pdie("Could not start process");
 		return;
 	case STOP:
-		ret = traceeval_n_stop(tdata->teval_processes, keys, ts);
+		ret = traceeval_query(tdata->teval_processes_start, keys, &results);
+		if (ret < 0)
+			return;
+
+		delta = ts - results[0].number_64;
+		results[0].number_64 = delta;
+
+		ret = traceeval_insert(tdata->teval_processes, keys, results);
 		if (ret < 0)
 			pdie("Could not stop process");
+
+		traceeval_results_release(tdata->teval_processes_start, results);
 		return;
 	}
 }
@@ -152,105 +250,145 @@ static void stop_process(struct task_data *tdata, const char *comm,
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
-					     
-	return traceeval_n_get_private(tdata->teval_processes, keys);
+	union traceeval_data *results;
+	void *data;
+	int ret;
+
+	ret = traceeval_query(tdata->teval_processes, keys, &results);
+	if (ret < 0)
+		return NULL;
+
+	data = (void *)results[1].number;
+	traceeval_results_release(tdata->teval_processes, results);
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
+	union traceeval_data *results;
 	int ret;
-					     
-	ret = traceeval_n_set_private(tdata->teval_processes, keys, data);
+
+	ret = traceeval_query(tdata->teval_processes_start, keys, &results);
+	if (ret < 0)
+		return;
+
+	results[1].number = (long)data;
+	ret = traceeval_insert(tdata->teval_processes_start, keys, results);
 	if (ret < 0)
 		pdie("Failed to set process data");
+
+	traceeval_results_release(tdata->teval_processes_start, results);
 }
 
-static void update_cpu(struct traceeval *teval, int cpu,
+static void update_cpu(struct traceeval *teval_start,
+		       struct traceeval *teval_stop, int cpu,
 		       enum sched_state state, enum command cmd,
 		       unsigned long long ts)
 {
-	struct traceeval_key keys[] = {
+	union traceeval_data *results;
+	unsigned long long delta;
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
 	int ret;
 
 	switch (cmd) {
 	case START:
-		ret = traceeval_n_continue(teval, keys, ts);
+		ret = traceeval_insert(teval_start, keys, vals);
 		if (ret < 0)
 			pdie("Could not start CPU");
 		return;
 	case STOP:
-		ret = traceeval_n_stop(teval, keys, ts);
+		ret = traceeval_query(teval_start, keys, &results);
+		if (ret < 0)
+			return;
+
+		delta = ts - results[0].number_64;
+		results[0].number_64 = delta;
+
+		ret = traceeval_insert(teval_stop, keys, results);
+		traceeval_results_release(teval_start, results);
 		if (ret < 0)
 			pdie("Could not stop CPU");
 		return;
 	}
 }
 
-static void start_cpu(struct traceeval *teval, int cpu,
-		      enum sched_state state,  unsigned long long ts)
+static void start_cpu(struct traceeval *teval_start, struct traceeval *teval,
+		      int cpu, enum sched_state state,  unsigned long long ts)
 {
-	update_cpu(teval, cpu, state, START, ts);
+	update_cpu(teval_start, teval, cpu, state, START, ts);
 }
 
-static void stop_cpu(struct traceeval *teval, int cpu,
-		     enum sched_state state, unsigned long long ts)
+static void stop_cpu(struct traceeval *teval_start, struct traceeval *teval,
+		     int cpu, enum sched_state state, unsigned long long ts)
 {
-	update_cpu(teval, cpu, state, STOP, ts);
+	update_cpu(teval_start, teval, cpu, state, STOP, ts);
 }
 
 static void update_thread(struct process_data *pdata, int tid,
 			  enum sched_state state, enum command cmd,
 			  unsigned long long ts)
 {
-	struct traceeval_key keys[] = {
+	union traceeval_data *results;
+	unsigned long long delta;
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
 	int ret;
 
 	switch (cmd) {
 	case START:
-		ret = traceeval_n_start(pdata->teval_threads, keys, ts);
+		ret = traceeval_insert(pdata->teval_threads_start, keys, vals);
 		if (ret < 0)
 			pdie("Could not start thread");
 		return;
 	case STOP:
-		ret = traceeval_n_stop(pdata->teval_threads, keys, ts);
+		ret = traceeval_query(pdata->teval_threads_start, keys, &results);
+		if (ret < 0)
+			return;
+
+		delta = ts - results[0].number_64;
+		results[0].number_64 = delta;
+
+		ret = traceeval_insert(pdata->teval_threads, keys, results);
+		traceeval_results_release(pdata->teval_threads_start, results);
 		if (ret < 0)
 			pdie("Could not stop thread");
 		return;
@@ -283,32 +421,15 @@ static struct tep_format_field *get_field(struct tep_event *event, const char *n
 
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
+	pdata->teval_cpus = traceeval_init(cpu_keys, timestamp_vals);
+	if (!pdata->teval_cpus)
+		pdie("Creating trace eval");
+	pdata->teval_cpus = traceeval_init(cpu_keys, timestamp_vals);
 	if (!pdata->teval_cpus)
 		pdie("Creating trace eval");
 
-	pdata->teval_threads = traceeval_2_alloc("Threads", thread_info);
+	pdata->teval_threads = traceeval_init(thread_keys, timestamp_vals);
 	if (!pdata->teval_threads)
 		pdie("Creating trace eval");
 }
@@ -344,7 +465,8 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	pid = val;
 	if (!pid) {
 		/* Record the runtime for the process CPUs */
-		stop_cpu(tdata->teval_cpus, record->cpu, IDLE, record->ts);
+		stop_cpu(tdata->teval_cpus_start, tdata->teval_cpus,
+			 record->cpu, IDLE, record->ts);
 		return;
 	}
 
@@ -381,10 +503,12 @@ static void sched_out(struct task_data *tdata, const char *comm,
 	start_thread(pdata, pid, pdata->state, record->ts);
 
 	/* Record the runtime for the process CPUs */
-	stop_cpu(pdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	stop_cpu(pdata->teval_cpus_start, pdata->teval_cpus,
+		 record->cpu, RUNNING, record->ts);
 
 	/* Record the runtime for the all CPUs */
-	stop_cpu(tdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	stop_cpu(tdata->teval_cpus_start, tdata->teval_cpus,
+		 record->cpu, RUNNING, record->ts);
 }
 
 static void sched_in(struct task_data *tdata, const char *comm,
@@ -405,7 +529,8 @@ static void sched_in(struct task_data *tdata, const char *comm,
 	/* Ignore the idle task */
 	if (!pid) {
 		/* Record the runtime for the process CPUs */
-		start_cpu(tdata->teval_cpus, record->cpu, IDLE, record->ts);
+		start_cpu(tdata->teval_cpus_start, tdata->teval_cpus,
+			  record->cpu, IDLE, record->ts);
 		return;
 	}
 
@@ -415,7 +540,8 @@ static void sched_in(struct task_data *tdata, const char *comm,
 	pdata = get_process_data(tdata, comm);
 
 	/* Start recording the running time of process CPUs */
-	start_cpu(tdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	start_cpu(tdata->teval_cpus_start, tdata->teval_cpus,
+		  record->cpu, RUNNING, record->ts);
 
 	/* If there was no pdata, then this process did not go through sched out */
 	if (!pdata) {
@@ -427,7 +553,8 @@ static void sched_in(struct task_data *tdata, const char *comm,
 	start_thread(pdata, pid, RUNNING, record->ts);
 
 	/* Start recording the running time of process CPUs */
-	start_cpu(pdata->teval_cpus, record->cpu, RUNNING, record->ts);
+	start_cpu(pdata->teval_cpus_start, pdata->teval_cpus,
+		  record->cpu, RUNNING, record->ts);
 
 	/* If it was just created, there's nothing to stop */
 	if (is_new)
@@ -482,32 +609,108 @@ static void print_microseconds(int idx, unsigned long long nsecs)
 		printf("%*d.%03lld\n", idx, 0, nsecs);
 }
 
+/* TODO */
+
+typedef int (*traceeval_cmp_fn)(struct traceeval *teval,
+				const union traceeval_data *Akeys,
+				const union traceeval_data *Avals,
+				const union traceeval_data *Bkeys,
+				const union traceeval_data *Bvals,
+				void *data);
+
+struct traceeval_iterator;
+struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval)
+{ return NULL; }
+
+int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_field,
+			    int level, bool ascending) { return 0; }
+
+int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
+				   traceeval_cmp_fn, void *data) { return 0; };
+
+int traceeval_iterator_next(struct traceeval_iterator *iter,
+			    const union traceeval_data **keys) {return 0; }
+int traceeval_stat(struct traceeval *teval, const union traceeval_data *keys,
+		   const char *field, struct traceeval_stat *stat) { return 0; }
+
+/*
+ * Sort all the processes by the RUNNING state.
+ *  If A and B have the same COMM, then sort by state.
+ *  else
+ *    Find the RUNNNIG state for A and B
+ *    If the RUNNING state does not exist, it's considered -1
+ *  If RUNNING is equal, then sort by COMM.
+ */
+static int compare_pdata(struct traceeval *teval,
+				const union traceeval_data *Akeys,
+				const union traceeval_data *Avals,
+				const union traceeval_data *Bkeys,
+				const union traceeval_data *Bvals,
+				void *data)
+{
+	union traceeval_data keysA[] = {
+		{ .cstring = Akeys[0].cstring }, { .number = RUNNING } };
+	union traceeval_data keysB[] = {
+		{ .cstring = Bkeys[0].cstring }, { .number = RUNNING } };
+	struct traceeval_stat statA;;
+	struct traceeval_stat statB;
+	unsigned long long totalA = -1;
+	unsigned long long totalB = -1;
+	int ret;
+
+	/* First check if we are on the same task */
+	if (strcmp(Akeys[0].cstring, Bkeys[0].cstring) == 0) {
+		/* Sort decending */
+		if (Akeys[1].number > Bkeys[1].number)
+			return -1;
+		return Akeys[1].number != Bkeys[1].number;
+	}
+
+	/* Get the RUNNING values for both processes */
+	ret = traceeval_stat(teval, keysA, process_keys[1].name, &statA);
+	if (ret > 0)
+		totalA = statA.total;
+
+	ret = traceeval_stat(teval, keysB, process_keys[1].name, &statB);
+	if (ret > 0)
+		totalB = statB.total;
+
+	if (totalA < totalB)
+		return -1;
+	if (totalA > totalB)
+		return 1;
+
+	return strcmp(Akeys[0].cstring, Bkeys[0].cstring);
+}
+
 static void display_cpus(struct traceeval *teval)
 {
-	struct traceeval_key_array *karray;
-	const struct traceeval_key *ckey;
-	const struct traceeval_key *skey;
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
+	const union traceeval_data *keys;
+	struct traceeval_stat stat;
 	int last_cpu = -1;
-	int i, nr;
+	int ret;
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
 
+		ret = traceeval_stat(teval, keys, delta_vals[0].name, &stat);
+		if (ret <= 0)
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
@@ -518,256 +721,158 @@ static void display_cpus(struct traceeval *teval)
 		case PREEMPT:
 		case SLEEP:
 		case OTHER:
-			printf("         \?\?(%ld): ", skey->number);
+			printf("         \?\?(%d): ", state);
 			break;
 		}
 		printf(" time (us):");
-		print_microseconds(12, traceeval_result_indx_total(teval, i));
+		print_microseconds(12, stat.total);
 
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
-	size_t ret;
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
+	case PREEMPT:
+		printf("      Total preempt time (us):");
+		print_microseconds(10, total);
+	case SLEEP:
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
+	struct traceeval_stat stat;
 	int last_tid = -1;
-	int i, nr;
+	int ret;
 
-	nr = traceeval_result_nr(teval);
-	if (!nr)
-		die("No result for threads\n");
+	traceeval_iterator_sort(iter, thread_keys[0].name, 0, true);
+	traceeval_iterator_sort(iter, thread_keys[1].name, 1, true);
 
-	memset(keys, 0, sizeof(keys));
-	keys[1].type = TRACEEVAL_TYPE_NUMBER;
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		int state = keys[1].number;
+		int tid = keys[0].number;
 
-	for (i = 0; i < nr; i++) {
-		karray = traceeval_result_indx_key_array(teval, i);
-		if (!karray)
-			die("No thread key for result %d\n", i);
-		tkey = traceeval_key_array_indx(karray, 0);
-		if (!tkey)
-			die("No thread keys for result?");
+		ret = traceeval_stat(teval, keys, delta_vals[0].name, &stat);
+		if (ret <= 0)
+			continue; // die?
 
-		/*
-		 * All the TIDS should be together in the results,
-		 * as the results are sorted by the first key, which
-		 * is the comm.
-		 */
-		if (last_tid == tkey->number)
-			continue;
+		if (last_tid != keys[0].number)
+			printf("\n    thread id: %d\n", tid);
 
-		last_tid = tkey->number;
+		last_tid = tid;
 
-		display_thread(teval, tkey->number);
+		display_state_times(state, stat.total);
 	}
+
+	if (last_tid < 0)
+		die("No result for threads\n");
+
 }
 
-static void display_process(struct traceeval *teval, struct process_data *pdata,
-			    const char *comm)
+static void display_process(struct process_data *pdata, const char *comm)
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
-	size_t ret;
 
 	printf("Task: %s\n", comm);
 
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
 	display_threads(pdata->teval_threads);
 	display_cpus(pdata->teval_cpus);
 	printf("\n");
 }
 
-static int compare_pdata(struct traceeval *teval,
-			 const struct traceeval_key_array *A,
-			 const struct traceeval_key_array *B,
-			 void *data)
-{
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
-
-	/* If two different processes have the same runtime, sort by name */
-	if (ret)
-		return ret;
-
-	/* Same process, sort by state */
-
-	akey = traceeval_key_array_indx(A, 1);
-	bkey = traceeval_key_array_indx(B, 1);
-
-	if (bkey->number < akey->number)
-		return -1;
-
-	return bkey->number > akey->number;
-}
-
 static void display_processes(struct traceeval *teval)
 {
-	struct traceeval_key_array *karray;
-	const struct traceeval_key *tkey;
-	struct traceeval_key keys[2];
-	struct process_data *pdata;
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
+	const union traceeval_data *keys;
+	union traceeval_data *results;
+	struct traceeval_stat stat;
+	struct process_data *pdata = NULL;
 	const char *last_comm = NULL;
-	int i, nr;
-
-	nr = traceeval_result_nr(teval);
-	if (!nr)
-		die("No result for processes\n");
+	int ret;
 
-	memset(keys, 0, sizeof(keys));
-	keys[1].type = TRACEEVAL_TYPE_NUMBER;
+	traceeval_iterator_sort_custom(iter, compare_pdata, NULL);
 
-	for (i = 0; i < nr; i++) {
-		karray = traceeval_result_indx_key_array(teval, i);
-		if (!karray)
-			die("No process key for result %d\n", i);
-		tkey = traceeval_key_array_indx(karray, 0);
-		if (!tkey)
-			die("No process keys for result?");
+	while (traceeval_iterator_next(iter, &keys) > 0) {
+		const char *comm = keys[0].cstring;
+		int state = keys[1].number;
 
 		/*
-		 * All the comms should be together in the results,
-		 * as the results are sorted by the first key, which
-		 * is the comm.
+		 * All the process should be together as they are
+		 * by the running times and then by comms.
 		 */
-		if (last_comm && strcmp(tkey->string, last_comm) == 0)
-			continue;
+		if (!last_comm || strcmp(comm, last_comm) != 0) {
+			if (pdata)
+				display_process(pdata, last_comm);
 
-		last_comm = tkey->string;
+			printf("Task: %s\n", comm);
+		}
 
-		keys[0] = *tkey;
-		keys[1].number = RUNNING;
+		last_comm = comm;
 
-		/* All processes should have a running state */
-		pdata = traceeval_n_get_private(teval, keys);
-		if (pdata)
-			display_process(teval, pdata, keys[0].string);
+		ret = traceeval_stat(teval, keys, delta_vals[0].name, &stat);
+		if (ret > 0)
+			display_state_times(state, stat.total);
+
+		last_comm = comm;
+
+		if (state == RUNNING) {
+			ret = traceeval_query(teval, keys, &results);
+			if (ret < 0)
+				continue;
+			pdata = results[1].pointer;
+		}
 	}
 }
 
 static void display(struct task_data *tdata)
 {
+	struct traceeval *teval = tdata->teval_cpus;
+	struct traceeval_iterator *iter = traceeval_iterator_get(teval);
+	const union traceeval_data *keys;
+	struct traceeval_stat stat;
 	unsigned long long total_time = 0;
 	unsigned long long idle_time = 0;
-	struct traceeval_key_array *karray;
-	const struct traceeval_key *tkey;
-	unsigned long long val;
-	int i, nr;
+	int ret;
 
 	if (tdata->comm)
 		return display_processes(tdata->teval_processes);
 
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
+		ret = traceeval_stat(teval, keys, delta_vals[0].name, &stat);
+		if (ret < 0)
+			continue;
+
+		switch (state) {
 		case RUNNING:
-			total_time += val;
+			total_time += stat.total;
 			break;
 		case IDLE:
-			idle_time += val;
+			idle_time += stat.total;
 			break;
 		default:
-			die("Invalid CPU state: %d\n", tkey->number);
+			die("Invalid CPU state: %d\n", state);
 		}
 	}
 
@@ -778,8 +883,6 @@ static void display(struct task_data *tdata)
 
 	display_cpus(tdata->teval_cpus);
 
-	traceeval_sort_custom(tdata->teval_processes, compare_pdata, NULL);
-
 	printf("\n");
 	display_processes(tdata->teval_processes);
 }
@@ -792,26 +895,6 @@ int main (int argc, char **argv)
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
@@ -839,11 +922,17 @@ int main (int argc, char **argv)
 	if (!handle)
 		pdie("Error opening %s", argv[0]);
 
-	data.teval_processes = traceeval_2_alloc("Processes", process_tinfo);
+	data.teval_processes_start = traceeval_init(process_keys, timestamp_vals);
+	if (!data.teval_processes_start)
+		pdie("Creating trace eval start");
+	data.teval_processes = traceeval_init(process_keys, process_vals);
 	if (!data.teval_processes)
 		pdie("Creating trace eval");
 
-	data.teval_cpus = traceeval_2_alloc("CPUs", cpu_tinfo);
+	data.teval_cpus_start = traceeval_init(cpu_keys, timestamp_vals);
+	if (!data.teval_cpus_start)
+		pdie("Creating trace eval");
+	data.teval_cpus = traceeval_init(cpu_keys, delta_vals);
 	if (!data.teval_cpus)
 		pdie("Creating trace eval");
 
-- 
2.40.1

