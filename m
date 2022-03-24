Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E089AC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 02:57:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347916AbiCXC7D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 22:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347898AbiCXC7B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 22:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5EA939F2;
        Wed, 23 Mar 2022 19:57:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C2FF619B6;
        Thu, 24 Mar 2022 02:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD6BC340F9;
        Thu, 24 Mar 2022 02:57:28 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXDfD-007FLW-6m;
        Wed, 23 Mar 2022 22:57:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     williskung@google.com, kaleshsingh@google.com,
        linux-rt-users@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 10/12] trace-cmd analyze: Add counting of page faults
Date:   Wed, 23 Mar 2022 22:57:24 -0400
Message-Id: <20220324025726.1727204-11-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324025726.1727204-1-rostedt@goodmis.org>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the page_fault_user event is found, then add counting of page faults
for each task and display them.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-analyze.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-analyze.c b/tracecmd/trace-analyze.c
index 7cf63923b962..2603c360c404 100644
--- a/tracecmd/trace-analyze.c
+++ b/tracecmd/trace-analyze.c
@@ -34,6 +34,7 @@ struct analysis_data {
 	unsigned long long	last_ts;
 	struct tep_event	*switch_event;
 	struct tep_event	*wakeup_event;
+	struct tep_event	*page_fault_event;
 	struct tep_format_field	*prev_comm;
 	struct tep_format_field	*prev_state;
 	struct tep_format_field	*next_comm;
@@ -58,6 +59,7 @@ struct task_item {
 	unsigned long long	runtime;
 	unsigned long long	start_ts;
 	unsigned long long	migrated;
+	unsigned long long	faulted;
 	struct sched_timings	preempt;
 	struct sched_timings	sleep;
 	struct sched_timings	blocked;
@@ -449,6 +451,19 @@ static void process_wakeup(struct analysis_data *data,
 	task->woken = true;
 }
 
+static void process_page_fault(struct analysis_data *data,
+			       struct tep_handle *tep, int pid,
+			       struct tep_record *record)
+{
+	struct cpu_data *cpu_data = &data->cpu_data[record->cpu];
+	struct task_cpu_item *cpu_task;
+	struct task_item *task;
+
+	cpu_task = get_cpu_task(cpu_data, pid);
+	task = cpu_task->task;
+	task->faulted++;
+}
+
 static bool match_type(int type, struct tep_event *event)
 {
 	return event && type == event->id;
@@ -475,6 +490,9 @@ static void process_cpu(struct analysis_data *data,
 
 	else if (match_type(type, data->wakeup_event))
 		process_wakeup(data, tep, record);
+
+	else if (match_type(type, data->page_fault_event))
+		process_page_fault(data, tep, pid, record);
 }
 
 static int cmp_tasks(const void *A, const void *B)
@@ -664,7 +682,9 @@ static void print_task(struct tep_handle *tep, struct task_item *task)
 	print_time(task->runtime, '_');
 	printf("\n");
 	if (task->migrated)
-		printf("Migrated:\t%llu\n", task->migrated);
+		printf("Migrated: %8llu\n", task->migrated);
+	if (task->faulted)
+		printf("Faulted:  %8llu\n", task->faulted);
 	print_timings_title("Type");
 	print_sched_timings("Wakeup", &task->wakeup);
 	print_sched_timings("Preempted", &task->preempt);
@@ -821,6 +841,7 @@ static void do_trace_analyze(struct tracecmd_input *handle)
 	data.wakeup_event = tep_find_event_by_name(tep, "sched", "sched_waking");
 	if (!data.wakeup_event)
 		data.wakeup_event = tep_find_event_by_name(tep, "sched", "sched_wakeup");
+	data.page_fault_event = tep_find_event_by_name(tep, "exceptions", "page_fault_user");
 
 	/* Set to a very large number */
 	data.start_ts = -1ULL;
-- 
2.35.1

