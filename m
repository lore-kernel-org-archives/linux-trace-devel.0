Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC48C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 02:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347921AbiCXC7G (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 22:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347907AbiCXC7C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 22:59:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58801939ED;
        Wed, 23 Mar 2022 19:57:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E50EAB8222D;
        Thu, 24 Mar 2022 02:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B47C340F6;
        Thu, 24 Mar 2022 02:57:28 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXDfD-007FL8-1x;
        Wed, 23 Mar 2022 22:57:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     williskung@google.com, kaleshsingh@google.com,
        linux-rt-users@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 04/12] trace-cmd analyze: Use sched_switch to find comm mappings
Date:   Wed, 23 Mar 2022 22:57:18 -0400
Message-Id: <20220324025726.1727204-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324025726.1727204-1-rostedt@goodmis.org>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

As the saved_cmdlines may miss a lot of comms, especially if the tracing
went for a while, to know what the comms mapping of PIDs are, use the
sched_switch event if it is present. If so, then update the task with the
comm and print that. This way we get more real names instead of just
"<...>".

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-analyze.c | 62 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-analyze.c b/tracecmd/trace-analyze.c
index 43e9ffa95687..dec705ce8e15 100644
--- a/tracecmd/trace-analyze.c
+++ b/tracecmd/trace-analyze.c
@@ -29,6 +29,10 @@ struct cpu_data {
 struct analysis_data {
 	unsigned long long	start_ts;
 	unsigned long long	last_ts;
+	struct tep_event	*switch_event;
+	struct tep_format_field	*prev_comm;
+	struct tep_format_field	*next_comm;
+	struct tep_format_field	*next_pid;
 	struct cpu_data		*cpu_data;
 	struct trace_hash	tasks;
 	int			nr_tasks;
@@ -39,6 +43,7 @@ struct analysis_data {
 struct task_item {
 	unsigned long long	runtime;
 	unsigned long long	start_ts;
+	char			*comm;
 	struct trace_hash_item	hash;
 	int			pid;
 };
@@ -253,11 +258,51 @@ static void update_first_pid(struct cpu_data *cpu_data)
 	cpu_data->start_ts = start_ts;
 }
 
+static void process_switch(struct analysis_data *data,
+			   struct tep_handle *tep, int pid,
+			   struct tep_record *record)
+{
+	struct cpu_data *cpu_data = &data->cpu_data[record->cpu];
+	struct task_cpu_item *cpu_task;
+	struct task_item *task;
+	const char *comm;
+
+	cpu_task = get_cpu_task(cpu_data, pid);
+	task = cpu_task->task;
+
+	/* Fill in missing comms */
+	if (pid && data->prev_comm && !task->comm) {
+		comm = (char *)(record->data + data->prev_comm->offset);
+		task->comm = strdup(comm);
+	}
+
+	if (data->next_pid) {
+		unsigned long long val;
+
+		tep_read_number_field(data->next_pid, record->data, &val);
+		pid = val;
+		cpu_task = get_cpu_task(cpu_data, pid);
+		task = cpu_task->task;
+
+		/* Fill in missing comms */
+		if (pid && data->next_comm && !task->comm) {
+			comm = (char *)(record->data + data->next_comm->offset);
+			task->comm = strdup(comm);
+		}
+	}
+}
+
+static bool match_type(int type, struct tep_event *event)
+{
+	return event && type == event->id;
+}
+
 static void process_cpu(struct analysis_data *data,
 			struct tep_handle *tep,
 			struct tep_record *record)
 {
 	struct cpu_data *cpu_data;
+	int type;
 	int pid;
 
 	pid = tep_data_pid(tep, record);
@@ -266,6 +311,10 @@ static void process_cpu(struct analysis_data *data,
 
 	cpu_data = get_cpu_data(data, record);
 	update_cpu_times(cpu_data, tep, pid, record);
+
+	type = tep_data_type(tep, record);
+	if (match_type(type, data->switch_event))
+		process_switch(data, tep, pid, record);
 }
 
 static int cmp_tasks(const void *A, const void *B)
@@ -374,7 +423,7 @@ static void print_cpu_data(struct tep_handle *tep, struct cpu_data *cpu_data)
 			printf("    ---------        --- \t     --------\n");
 		}
 		printf("%16s %8d\t",
-		       tep_data_comm_from_pid(tep, task->pid),
+		       task->comm ? : tep_data_comm_from_pid(tep, task->pid),
 		       task->pid);
 		print_time(cpu_tasks[i]->runtime, '_');
 		printf(" (%%%lld)\n", (task->runtime * 100) / total_time);
@@ -444,7 +493,7 @@ static void print_total(struct tep_handle *tep, struct analysis_data *data)
 			printf("    ---------        --- \t     --------\n");
 		}
 		printf("%16s %8d\t",
-		       tep_data_comm_from_pid(tep, tasks[i]->pid),
+		       tasks[i]->comm ? : tep_data_comm_from_pid(tep, tasks[i]->pid),
 		       tasks[i]->pid);
 		print_time(tasks[i]->runtime, '_');
 		printf(" (%%%lld)\n", (tasks[i]->runtime * 100) / total_time);
@@ -470,6 +519,7 @@ static void free_tasks(struct trace_hash *hash)
 		trace_hash_while_item(item, bucket) {
 			task = task_from_hash(item);
 			trace_hash_del(item);
+			free(task->comm);
 			free(task);
 		}
 	}
@@ -518,9 +568,17 @@ static void do_trace_analyze(struct tracecmd_input *handle)
 
 	trace_hash_init(&data.tasks, 128);
 
+	data.switch_event = tep_find_event_by_name(tep, "sched", "sched_switch");
+
 	/* Set to a very large number */
 	data.start_ts = -1ULL;
 
+	if (data.switch_event) {
+		data.next_pid = tep_find_field(data.switch_event, "next_pid");
+		data.next_comm = tep_find_field(data.switch_event, "next_comm");
+		data.prev_comm = tep_find_field(data.switch_event, "prev_comm");
+	}
+
 	do {
 		record = tracecmd_read_next_data(handle, NULL);
 		if (record)
-- 
2.35.1

