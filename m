Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DC7C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 02:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347901AbiCXC7B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 22:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347893AbiCXC7A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 22:59:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1399939E9;
        Wed, 23 Mar 2022 19:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94852619A9;
        Thu, 24 Mar 2022 02:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD02C340EE;
        Thu, 24 Mar 2022 02:57:27 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXDfD-007FKz-0N;
        Wed, 23 Mar 2022 22:57:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     williskung@google.com, kaleshsingh@google.com,
        linux-rt-users@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 02/12] trace-cmd analyze: Show what tasks are running the most
Date:   Wed, 23 Mar 2022 22:57:16 -0400
Message-Id: <20220324025726.1727204-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324025726.1727204-1-rostedt@goodmis.org>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Print out the tasks that are running the most on the system.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-analyze.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-analyze.c b/tracecmd/trace-analyze.c
index 4a17cf12eb07..2211079668e4 100644
--- a/tracecmd/trace-analyze.c
+++ b/tracecmd/trace-analyze.c
@@ -264,6 +264,17 @@ static void process_cpu(struct analysis_data *data,
 	update_cpu_times(cpu_data, tep, pid, record);
 }
 
+static int cmp_tasks(const void *A, const void *B)
+{
+	struct task_item * const *a = A;
+	struct task_item * const *b = B;
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
@@ -301,8 +312,10 @@ static void print_total(struct tep_handle *tep, struct analysis_data *data)
 	struct trace_hash_item **bucket;
 	struct trace_hash_item *item;
 	struct task_item **idle_tasks;
+	struct task_item **tasks;
 	struct task_item *task;
 	bool first = true;
+	int nr_tasks;
 	int cpu;
 	int i = 0;
 
@@ -311,6 +324,10 @@ static void print_total(struct tep_handle *tep, struct analysis_data *data)
 	print_time(total_time, '_');
 	printf("\n");
 
+	tasks = malloc(sizeof(*tasks) * data->nr_tasks);
+	if (!tasks)
+		die("Could not allocate task array");
+
 	idle_tasks = calloc(sizeof(*idle_tasks), data->allocated_cpus);
 	if (!idle_tasks)
 		die("Could not allocate idle task array");
@@ -321,9 +338,13 @@ static void print_total(struct tep_handle *tep, struct analysis_data *data)
 			if (task->pid < 0) {
 				cpu = -2 - task->pid;
 				idle_tasks[cpu] = task;
-			}
+			} else
+				tasks[i++] = task;
 		}
 	}
+	nr_tasks = i;
+
+	qsort(tasks, nr_tasks, sizeof(*tasks), cmp_tasks);
 
 	for (i = 0; i < data->allocated_cpus; i++) {
 		if (!idle_tasks[i])
@@ -339,6 +360,22 @@ static void print_total(struct tep_handle *tep, struct analysis_data *data)
 		printf(" (%%%lld)\n", (idle_tasks[i]->runtime * 100) / total_time);
 	}
 	free(idle_tasks);
+
+	printf("\n");
+	for (i = 0; i < nr_tasks; i++) {
+		if (!i) {
+			printf("    Task name        PID \t     Run time\n");
+			printf("    ---------        --- \t     --------\n");
+		}
+		printf("%16s %8d\t",
+		       tep_data_comm_from_pid(tep, tasks[i]->pid),
+		       tasks[i]->pid);
+		print_time(tasks[i]->runtime, '_');
+		printf(" (%%%lld)\n", (tasks[i]->runtime * 100) / total_time);
+	}
+	free(tasks);
+
+	printf("\n");
 }
 
 static void free_tasks(struct trace_hash *hash)
-- 
2.35.1

