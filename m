Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C711C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 02:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347899AbiCXC7E (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 22:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347903AbiCXC7B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 22:59:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F57B939E9;
        Wed, 23 Mar 2022 19:57:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2563B8222C;
        Thu, 24 Mar 2022 02:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C2EC340F5;
        Thu, 24 Mar 2022 02:57:28 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXDfD-007FLO-5C;
        Wed, 23 Mar 2022 22:57:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     williskung@google.com, kaleshsingh@google.com,
        linux-rt-users@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 08/12] trace-cmd analyze: Track migration
Date:   Wed, 23 Mar 2022 22:57:22 -0400
Message-Id: <20220324025726.1727204-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324025726.1727204-1-rostedt@goodmis.org>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Keep track of which CPU event task is at for every event, and if the CPU
changes, then mark it as a migration. Print out the number of times the
task migrated if it had migrated.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-analyze.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-analyze.c b/tracecmd/trace-analyze.c
index de776b76c343..4db93367727b 100644
--- a/tracecmd/trace-analyze.c
+++ b/tracecmd/trace-analyze.c
@@ -55,6 +55,7 @@ struct sched_timings {
 struct task_item {
 	unsigned long long	runtime;
 	unsigned long long	start_ts;
+	unsigned long long	migrated;
 	struct sched_timings	preempt;
 	struct sched_timings	sleep;
 	struct sched_timings	blocked;
@@ -62,6 +63,7 @@ struct task_item {
 	char			*comm;
 	struct trace_hash_item	hash;
 	int			pid;
+	int			last_cpu;
 	int			last_state;
 };
 
@@ -149,6 +151,7 @@ static struct task_item *get_task(struct cpu_data *cpu_data, int pid)
 		hash->key = find_pid;
 		cpu_data->data->nr_tasks++;
 		trace_hash_add(&cpu_data->data->tasks, hash);
+		task->last_cpu = cpu_data->cpu;
 		task->last_state = -1;
 	}
 
@@ -256,6 +259,10 @@ static void update_pid(struct cpu_data *cpu_data,
 
 	cpu_task = get_cpu_task(cpu_data, pid);
 	task = cpu_task->task;
+	if (task->last_cpu != cpu_data->cpu) {
+		task->last_cpu = cpu_data->cpu;
+		task->migrated++;
+	}
 
 	update_idle_task(cpu_data, task, record->ts);
 
@@ -383,6 +390,11 @@ static void process_switch(struct analysis_data *data,
 		task->start_ts = record->ts;
 		cpu_data->current_pid = pid;
 
+		if (task->last_cpu != cpu_data->cpu) {
+			task->last_cpu = cpu_data->cpu;
+			task->migrated++;
+		}
+
 		update_idle_task(cpu_data, task, record->ts);
 
 		switch (task->last_state) {
@@ -619,9 +631,11 @@ static void print_task(struct tep_handle *tep, struct task_item *task)
 {
 	printf("\nTask: %d : %s:\n",
 	       task->pid , task->comm ? : tep_data_comm_from_pid(tep, task->pid));
-	printf("Runtime: ");
+	printf("Runtime:    ");
 	print_time(task->runtime, '_');
 	printf("\n");
+	if (task->migrated)
+		printf("Migrated:\t%llu\n", task->migrated);
 	print_timings_title("Type");
 	print_sched_timings("Preempted", &task->preempt);
 	print_sched_timings("Blocked", &task->blocked);
-- 
2.35.1

