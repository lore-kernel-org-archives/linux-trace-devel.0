Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B9CC43217
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 02:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238778AbiCXC7A (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 22:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347887AbiCXC67 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 22:58:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6B364EA;
        Wed, 23 Mar 2022 19:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F7C8619A6;
        Thu, 24 Mar 2022 02:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B7AC340F3;
        Thu, 24 Mar 2022 02:57:27 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXDfD-007FL4-18;
        Wed, 23 Mar 2022 22:57:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     williskung@google.com, kaleshsingh@google.com,
        linux-rt-users@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 03/12] trace-cmd analyze: Show how much tasks run on each CPU
Date:   Wed, 23 Mar 2022 22:57:17 -0400
Message-Id: <20220324025726.1727204-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324025726.1727204-1-rostedt@goodmis.org>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Display for each CPU that was traced, the amount of time tasks ran on
them. Listing the tasks from the longest runner to the least.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-analyze.c | 82 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/tracecmd/trace-analyze.c b/tracecmd/trace-analyze.c
index 2211079668e4..43e9ffa95687 100644
--- a/tracecmd/trace-analyze.c
+++ b/tracecmd/trace-analyze.c
@@ -44,6 +44,7 @@ struct task_item {
 };
 
 struct task_cpu_item {
+	unsigned long long	runtime;
 	struct trace_hash_item	hash;
 	struct task_item       	*task;
 };
@@ -171,6 +172,7 @@ static void update_cpu_task_times(struct cpu_data *cpu_data,
 
 	delta = ts - task->start_ts;
 	task->runtime += delta;
+	cpu_task->runtime += delta;
 }
 
 static void update_pid(struct cpu_data *cpu_data,
@@ -198,6 +200,7 @@ static void update_pid(struct cpu_data *cpu_data,
 	} else {
 		delta = record->ts - cpu_data->last_ts;
 		task->runtime += delta;
+		cpu_task->runtime += delta;
 	}
 
 	cpu_data->last_ts = record->ts;
@@ -246,6 +249,7 @@ static void update_first_pid(struct cpu_data *cpu_data)
 	task = cpu_task->task;
 	delta = cpu_data->start_ts - start_ts;
 	task->runtime += delta;
+	cpu_task->runtime += delta;
 	cpu_data->start_ts = start_ts;
 }
 
@@ -275,6 +279,17 @@ static int cmp_tasks(const void *A, const void *B)
 	return (*a)->runtime < (*b)->runtime;
 }
 
+static int cmp_cpu_tasks(const void *A, const void *B)
+{
+	struct task_cpu_item * const *a = A;
+	struct task_cpu_item * const *b = B;
+
+	if ((*a)->runtime > (*b)->runtime)
+		return -1;
+
+	return (*a)->runtime < (*b)->runtime;
+}
+
 static void print_time(unsigned long long ts, char delim)
 {
 	unsigned long long secs;
@@ -306,6 +321,67 @@ static void print_time(unsigned long long ts, char delim)
 	}
 }
 
+static void print_cpu_data(struct tep_handle *tep, struct cpu_data *cpu_data)
+{
+	unsigned long long total_time;
+	struct trace_hash_item **bucket;
+	struct trace_hash_item *item;
+	struct task_cpu_item **cpu_tasks;
+	struct task_cpu_item *cpu_task;
+	struct task_item *idle_task = NULL;
+	struct task_item *task;
+	struct analysis_data *data;
+	int nr_tasks;
+	int i = 0;
+
+	data = cpu_data->data;
+	total_time = data->last_ts - data->start_ts;
+
+	printf("\nCPU %d\n", cpu_data->cpu);
+	printf("-------\n");
+
+	cpu_tasks = malloc(sizeof(*cpu_tasks) * cpu_data->nr_tasks);
+
+	if (!cpu_tasks)
+		die("Could not allocate task array");
+
+	trace_hash_for_each_bucket(bucket, &cpu_data->tasks) {
+		trace_hash_for_each_item(item, bucket) {
+			cpu_task = task_cpu_from_hash(item);
+			if (cpu_task->task->pid <= 0)
+				idle_task = cpu_task->task;
+			else
+				cpu_tasks[i++] = cpu_task;
+		}
+	}
+	nr_tasks = i;
+
+	if (idle_task) {
+		printf("idle:\t");
+		print_time(idle_task->runtime, '_');
+		printf(" (%%%lld)\n", (idle_task->runtime * 100) / total_time);
+	} else {
+		printf("Never idle!\n");
+	}
+
+	qsort(cpu_tasks, nr_tasks, sizeof(*cpu_tasks), cmp_cpu_tasks);
+
+	for (i = 0; i < nr_tasks; i++) {
+		task = cpu_tasks[i]->task;
+
+		if (!i) {
+			printf("    Task name        PID \t     Run time\n");
+			printf("    ---------        --- \t     --------\n");
+		}
+		printf("%16s %8d\t",
+		       tep_data_comm_from_pid(tep, task->pid),
+		       task->pid);
+		print_time(cpu_tasks[i]->runtime, '_');
+		printf(" (%%%lld)\n", (task->runtime * 100) / total_time);
+	}
+	free(cpu_tasks);
+}
+
 static void print_total(struct tep_handle *tep, struct analysis_data *data)
 {
 	unsigned long long total_time;
@@ -376,6 +452,12 @@ static void print_total(struct tep_handle *tep, struct analysis_data *data)
 	free(tasks);
 
 	printf("\n");
+
+	for (i = 0; i < data->allocated_cpus; i++) {
+		if (!data->cpu_data[i].data)
+			continue;
+		print_cpu_data(tep, &data->cpu_data[i]);
+	}
 }
 
 static void free_tasks(struct trace_hash *hash)
-- 
2.35.1

