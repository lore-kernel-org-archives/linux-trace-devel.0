Return-Path: <SRS0=LYCJ=3F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B522AC33CB1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jan 2020 15:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 800FB206D9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jan 2020 15:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgAPPsJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 10:48:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgAPPsJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 10:48:09 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C67DF206D9;
        Thu, 16 Jan 2020 15:48:06 +0000 (UTC)
Date:   Thu, 16 Jan 2020 10:48:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Daniel Black <daniel@linux.ibm.com>
Subject: [RFC PATCH] trace-cmd: Add sqldump
Message-ID: <20200116104804.5d2f71e2@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In order to be able to test sql commands on the command line to convert
to histogram logic, I wanted a real sql database to play with that
contain events. I decided to modify trace-cmd to create a sqldump
command that would dump the contents of the trace.dat file into a
mysqldump file format.

It looks at all the events in the trace.dat file that has instances,
and then creates a table for each event.

 $ trace-cmd sqldump > dump
 $ mysql events < dump

MariaDB [events]> show tables;
+-----------------------------+
| Tables_in_events            |
+-----------------------------+
| sched_migrate_task          |
| sched_move_numa             |
| sched_process_exec          |
| sched_process_exit          |
| sched_stat_runtime          |
| sched_switch                |
| sched_wake_idle_without_ipi |
| sched_wakeup                |
| sched_waking                |
+-----------------------------+
9 rows in set (0.001 sec)

MariaDB [events]> select * from sched_move_numa;
+-------------------+-------------+--------------+----------------------+------------+-------+-------+-------+---------+---------+---------+---------+
| common_timestamp  | common_type | common_flags | common_preempt_count | common_pid | pid   | tgid  | ngid  | src_cpu | src_nid | dst_cpu | dst_nid |
+-------------------+-------------+--------------+----------------------+------------+-------+-------+-------+---------+---------+---------+---------+
| 14943901721165973 |         305 |            0 |                    0 |      27451 | 27451 | 27451 | 27451 |       5 |       1 |      22 |       0 |
| 14943901722548756 |         305 |            0 |                    0 |       3684 |  3684 |  3684 |  3684 |      23 |       1 |      22 |       0 |
| 14943901779987828 |         305 |            0 |                    0 |      13693 | 13693 | 13677 | 13693 |       7 |       1 |      22 |       0 |
+-------------------+-------------+--------------+----------------------+------------+-------+-------+-------+---------+---------+---------+---------+
3 rows in set (0.001 sec)

I then tried this (which would be what we would convert to a histogram string):

MariaDB [events]> select first.end_time as start_time, next.common_timestamp as end_time, first.pid,
   (next.common_timestamp - first.end_time) as delta2,
   (next.common_timestamp - first.end_time + first.delta) as total_delta
      from (select start.common_timestamp as start_time, end.common_timestamp as end_time, start.pid,
                   (end.common_timestamp - start.common_timestamp) as delta
            from sched_waking as start
            join sched_switch as end
              on start.pid = end.next_pid and start.common_timestamp < end.common_timestamp limit 20)
              as first
      join sched_switch as next
        on first.pid = next.prev_pid and first.end_time < next.common_timestamp limit 20;

+-------------------+-------------------+-------+---------+-------------+
| start_time        | end_time          | pid   | delta2  | total_delta |
+-------------------+-------------------+-------+---------+-------------+
| 14943901178093512 | 14943901178103431 |    22 |    9919 |       14926 |
| 14943901178148697 | 14943901178198198 |  9164 |   49501 |       71413 |
| 14943901178148777 | 14943901178215204 |  8024 |   66427 |       82776 |
| 14943901178166361 | 14943901178251623 | 10398 |   85262 |       98307 |
| 14943901178337032 | 14943901178348191 |  3550 |   11159 |       17083 |
| 14943901178148697 | 14943901178671539 |  9164 |  522842 |      544754 |
| 14943901178645272 | 14943901178671539 |  9164 |   26267 |      544754 |
| 14943901178645272 | 14943901178671539 |  9164 |   26267 |       41732 |
| 14943901178148697 | 14943901179165293 |  9164 | 1016596 |     1038508 |
| 14943901178645272 | 14943901179165293 |  9164 |  520021 |     1038508 |
| 14943901178645272 | 14943901179165293 |  9164 |  520021 |      535486 |
| 14943901179144479 | 14943901179165293 |  9164 |   20814 |     1038508 |
| 14943901179144479 | 14943901179165293 |  9164 |   20814 |      535486 |
| 14943901179144479 | 14943901179165293 |  9164 |   20814 |       28893 |
| 14943901179161559 | 14943901179173582 | 13770 |   12023 |       17585 |
| 14943901178337032 | 14943901179440909 |  3550 | 1103877 |     1109801 |
| 14943901179429686 | 14943901179440909 |  3550 |   11223 |     1109801 |
| 14943901179429686 | 14943901179440909 |  3550 |   11223 |       27031 |
| 14943901179464159 | 14943901179528026 | 13366 |   63867 |      108018 |
| 14943901179496693 | 14943901179528477 | 13367 |   31784 |       44695 |
+-------------------+-------------------+-------+---------+-------------+
20 rows in set (0.037 sec)

Well, the output isn't exactly what we want as it will match all start
rows with the same pid and a timestamp less than the end event. But for
our purposes it is enough.

What the above syntax does is to match three events:

  sched_waking -> sched_switch (pid scheduling in) -> sched_switch (pid scheduling out).

And gives two deltas: One between the first and second event, and the total time.

The trace-cmd start --sql '...' of the above should create the following:

 # echo 'table u64 start_time u64 end_time pid_t pid u64 delta u64 total_delta' > synthetic_events
 # echo 'first u64 start_time u64 end_time pid_t pid u64 delta' >> synthetic_events 
 # echo 'hist:keys=pid:start=common_timestamp' > events/sched/sched_waking/trigger 
 # echo 'hist:keys=next_pid:start2=$start,delta=common_timestamp-$start:onmatch(sched.sched_waking).trace(first,$start2,common_timestamp,next_pid,$delta)' > events/sched/sched_switch/trigger
 # echo 'hist:keys=prev_pid:start3=$start2,delta2=$delta,delta3=common_timestamp-$start2:onmatch(synthetic.first).trace(table,$start3,common_timestamp,prev_pid,$delta3,$delta2)' >> events/sched/sched_switch/trigger

Note, the above will eventually work with:

 trace-cmd start --sql 'select first.end_time as start_time, next.common_timestamp as end_time, first.pid,
   (next.common_timestamp - first.end_time) as delta2,
   (next.common_timestamp - first.end_time + first.delta) as total_delta
      from (select start.common_timestamp as start_time, end.common_timestamp as end_time, start.pid,
                   (end.common_timestamp - start.common_timestamp) as delta
            from sched_waking as start
            join sched_switch as end
              on start.pid = end.next_pid) as first
      join sched_switch as next
        on first.pid = next.prev_pid'

Or broken into two statements (probably start with this):

 trace-cmd start \
    --sql '(select start.common_timestamp as start_time, end.common_timestamp as end_time, start.pid,
                   (end.common_timestamp - start.common_timestamp) as delta
            from sched_waking as start
            join sched_switch as end
              on start.pid = end.next_pid) as first' \
                        \
    --sql '(select first.end_time as start_time, next.common_timestamp as end_time, first.pid,
   (next.common_timestamp - first.end_time) as delta2,
   (next.common_timestamp - first.end_time + first.delta) as total_delta
      from first
      join sched_switch as next
        on first.pid = next.prev_pid) as table'


That is, the above is a very complex one to test the algorithm with.
Normally, someone would probably only do the first sql statement:

 trace-cmd start \
    --sql '(select start.common_timestamp as start_time, end.common_timestamp as end_time, start.pid,
                   (end.common_timestamp - start.common_timestamp) as delta
            from sched_waking as start
            join sched_switch as end
              on start.pid = end.next_pid) as first'

Which would generate:

 # echo 'first u64 start_time u64 end_time pid_t pid u64 delta' >> synthetic_events 
 # echo 'hist:keys=pid:start=common_timestamp' > events/sched/sched_waking/trigger 
 # echo 'hist:keys=next_pid:start2=$start,delta=common_timestamp-$start:onmatch(sched.sched_waking).trace(first,$start2,common_timestamp,next_pid,$delta)' > events/sched/sched_switch/trigger


And although I noticed that we can't use "start_time" and "end_time"
later in the statement with the mysql database, I think we may be able
to use it for our use case. That is:

 trace-cmd start \
    --sql '(select start.common_timestamp as start_time, end.common_timestamp as end_time, start.pid,
                   (start_time - end_time) as delta  <<<--- easier to read and write
            from sched_waking as start
            join sched_switch as end
              on start.pid = end.next_pid) as first'

Now for the sqldump patch.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |   6 +
 tracecmd/trace-cmd.c           |   1 +
 tracecmd/trace-read.c          |  50 ++++--
 tracecmd/trace-sqldump.c       | 268 +++++++++++++++++++++++++++++++++
 5 files changed, 316 insertions(+), 10 deletions(-)
 create mode 100644 tracecmd/trace-sqldump.c

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index bacbd0d5..874550a3 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -31,6 +31,7 @@ TRACE_CMD_OBJS += trace-show.o
 TRACE_CMD_OBJS += trace-list.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-dump.o
+TRACE_CMD_OBJS += trace-sqldump.o
 
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-agent.o
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 44f1e62a..b2fcb30c 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -103,6 +103,12 @@ int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
 		       int argc, char **argv, bool use_fifos);
 
+int trace_sql_record(struct tracecmd_input *handle, struct tep_record *record);
+
+int trace_sql_init(struct tracecmd_input *handle);
+
+int trace_sql_finish(struct tracecmd_input *handle);
+
 struct hook_list;
 
 void trace_init_profile(struct tracecmd_input *handle, struct hook_list *hooks,
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index dbfcc974..c61668f3 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -76,6 +76,7 @@ struct command {
  */
 struct command commands[] = {
 	{"report", trace_report},
+	{"sqldump", trace_report},
 	{"snapshot", trace_snapshot},
 	{"hist", trace_hist},
 	{"mem", trace_mem},
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 8c2b2ae3..778da6ad 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -70,6 +70,10 @@ struct pid_list {
 	int			free;
 } *pid_list;
 
+static const char *command;
+
+#define IS_SQLDUMP (strcmp(command, "sqldump") == 0)
+
 struct pid_list *comm_list;
 
 static unsigned int page_size;
@@ -1168,6 +1172,7 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 	struct tep_record *last_record;
 	struct tep_handle *pevent;
 	struct tep_event *event;
+	bool sqldump = IS_SQLDUMP;
 	int cpus;
 	int ret;
 
@@ -1184,7 +1189,8 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		cpus = tracecmd_cpus(handles->handle);
 		handles->cpus = cpus;
 		print_handle_file(handles);
-		printf("cpus=%d\n", cpus);
+		if (!sqldump)
+			printf("cpus=%d\n", cpus);
 
 		/* Latency trace is just all ASCII */
 		if (ret > 0) {
@@ -1216,13 +1222,15 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (event)
 			stacktrace_id = event->id;
 
-		init_wakeup(handles->handle);
-		if (last_hook)
-			last_hook->next = tracecmd_hooks(handles->handle);
-		else
-			hooks = tracecmd_hooks(handles->handle);
-		if (profile)
-			trace_init_profile(handles->handle, hooks, global);
+		if (!sqldump) {
+			init_wakeup(handles->handle);
+			if (last_hook)
+				last_hook->next = tracecmd_hooks(handles->handle);
+			else
+				hooks = tracecmd_hooks(handles->handle);
+			if (profile)
+				trace_init_profile(handles->handle, hooks, global);
+		}
 
 		process_filters(handles);
 
@@ -1245,9 +1253,20 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 				add_handle(new_handle, name);
 			}
 		}
+
+		if (sqldump) {
+			trace_sql_init(handles->handle);
+
+			while ((record = get_next_record(handles))) {
+				trace_sql_record(handles->handle, record);
+				free_handle_record(handles);
+			}
+
+			trace_sql_finish(handles->handle);
+		}
 	}
 
-	if (otype != OUTPUT_NORMAL)
+	if (otype != OUTPUT_NORMAL || sqldump)
 		return;
 
 	do {
@@ -1493,9 +1512,12 @@ void trace_report (int argc, char **argv)
 	if (argc < 2)
 		usage(argv);
 
-	if (strcmp(argv[1], "report") != 0)
+	if ((strcmp(argv[1], "report") != 0) &&
+	    (strcmp(argv[1], "sqldump") != 0))
 		usage(argv);
 
+	command = argv[1];
+
 	signal(SIGINT, sig_end);
 
 	for (;;) {
@@ -1662,9 +1684,13 @@ void trace_report (int argc, char **argv)
 			tracecmd_set_debug(true);
 			break;
 		case OPT_profile:
+			if (IS_SQLDUMP)
+				usage(argv);
 			profile = 1;
 			break;
 		case OPT_uname:
+			if (IS_SQLDUMP)
+				usage(argv);
 			show_uname = 1;
 			break;
 		case OPT_version:
@@ -1819,6 +1845,10 @@ void trace_report (int argc, char **argv)
 	/* and version overrides uname! */
 	if (show_version)
 		otype = OUTPUT_VERSION_ONLY;
+
+	if (IS_SQLDUMP && otype != OUTPUT_NORMAL)
+		usage(argv);
+
 	read_data_info(&handle_list, otype, global);
 
 	list_for_each_entry(handles, &handle_list, list) {
diff --git a/tracecmd/trace-sqldump.c b/tracecmd/trace-sqldump.c
new file mode 100644
index 00000000..4913ced2
--- /dev/null
+++ b/tracecmd/trace-sqldump.c
@@ -0,0 +1,268 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 VMware Inc, Steven Rostedt
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+
+#include "trace-cmd.h"
+#include "trace-local.h"
+
+extern void breakpoint(void);
+
+struct event_table {
+	struct tep_event	*event;
+	struct tep_format_field **event_fields;
+	int			*event_field_len;
+	size_t			cnt;
+	FILE			*fp;
+};
+
+static struct tep_format_field **event_common_fields;
+static int nr_event_common_fields;
+
+static struct event_table *event_table;
+static int event_table_size;
+
+int trace_sql_init(struct tracecmd_input *handle)
+{
+	struct tep_handle *tep;
+	struct tep_event **event_list;
+	struct tep_event *event;
+	struct event_table *et;
+	unsigned int max_id = 0;
+	int i, f;
+
+	tep = tracecmd_get_pevent(handle);
+	if (!tep)
+		return -1;
+
+	event_list = tep_list_events(tep, TEP_EVENT_SORT_ID);
+	if (!event_list)
+		return -1;
+
+	for (i = 0; event_list[i]; i++) {
+		event = event_list[i];
+
+		if (event->id > max_id)
+			max_id = event->id;
+	}
+
+	event_table = calloc(max_id + 1, sizeof(*event_table));
+	event_table_size = max_id + 1;
+
+	for (i = 0; event_list[i]; i++) {
+		int e;
+
+		event = event_list[i];
+
+		if (event->id == 302)
+			breakpoint();
+
+		et = &event_table[event->id];
+		et->event = event;
+
+		if (!event_common_fields) {
+			event_common_fields = tep_event_common_fields(event);
+			if (!event_common_fields)
+				goto fail;
+			for (f = 0; event_common_fields[f]; f++)
+				;
+			nr_event_common_fields = f + 1;
+		}
+
+		et->event_fields = tep_event_fields(event);
+		if (!et->event_fields)
+			goto fail;
+
+		for (e = 0; et->event_fields[e]; e++)
+			;
+		et->event_field_len = calloc(e, sizeof(*et->event_field_len));
+		if (!et->event_field_len)
+			goto fail;
+
+		et->fp = tmpfile();
+		if (!et->fp)
+			goto fail;
+	}
+	return 0;
+ fail:
+	die("done!\n");
+	return -1;
+}
+
+static void write_string(FILE *fp, const char *str, int len)
+{
+	if (!len)
+		len = strlen(str);
+
+	fputc('\'', fp);
+	fwrite(str, len, 1, fp);
+	fputc('\'', fp);
+}
+
+static void write_data(FILE *fp, struct tep_format_field *field,
+		       struct tep_record *record, int *elen)
+{
+	struct tep_handle *tep = field->event->tep;
+	unsigned int offset, len;
+	unsigned long long val;
+	char *data = record->data;
+	char buffer[64];
+
+	if (field->flags & TEP_FIELD_IS_ARRAY) {
+		offset = field->offset;
+		len = field->size;
+
+		if (field->flags & TEP_FIELD_IS_DYNAMIC) {
+			val = tep_read_number(tep, data + offset, len);
+			offset = val;
+			len = offset >> 16;
+			offset &= 0xffff;
+		}
+		if (field->flags & TEP_FIELD_IS_STRING) {
+			int l = strlen(data + offset);
+
+			if (l < len)
+				len = l;
+			write_string(fp, data + offset, len);
+		} else {
+			write_string(fp, "ARRAY", 0);
+			len = 5;
+		}
+		if (elen && (*elen) < len)
+			*elen = len;
+		return;
+	}
+	val = tep_read_number(tep, data + field->offset,
+			      field->size);
+	sprintf(buffer, "%lld", val);
+	fwrite(buffer, strlen(buffer), 1, fp);
+
+}
+
+int trace_sql_record(struct tracecmd_input *handle, struct tep_record *record)
+{
+	struct tep_handle *tep = tracecmd_get_pevent(handle);
+	struct tep_event *event = tep_find_event_by_record(tep, record);
+	struct event_table *et = &event_table[event->id];
+	char buffer[64];
+	int i;
+
+	if (event->id > event_table_size || !et->event)
+		return -1;
+
+	if (event->id == 302)
+		breakpoint();
+
+	if (et->cnt++)
+		fwrite(",(", 2, 1, et->fp);
+	else
+		fwrite("(", 1, 1, et->fp);
+
+	i = sprintf(buffer, "%lld", record->ts);
+	fwrite(buffer, i, 1, et->fp);
+
+	for (i = 0; event_common_fields[i]; i++) {
+		fwrite(",", 1, 1, et->fp);
+		write_data(et->fp, event_common_fields[i], record, NULL);
+	}
+
+	for (i = 0; et->event_fields[i]; i++) {
+		fwrite(",", 1, 1, et->fp);
+		write_data(et->fp, et->event_fields[i], record,
+			   &et->event_field_len[i]);
+	}
+
+	fwrite(")", 1, 1, et->fp);
+
+	return 0;
+}
+
+static void write_header(struct tep_format_field *field, int flen)
+{
+
+	printf("`%s` ", field->name);
+
+	if (field->flags & TEP_FIELD_IS_ARRAY) {
+		if (field->flags & TEP_FIELD_IS_STRING) {
+			if (field->flags & TEP_FIELD_IS_DYNAMIC) {
+				if (flen)
+					printf("VARCHAR(%d)", flen);
+				else
+					printf("VARCHAR(64)");
+			} else {
+				printf("CHAR(%d)", field->size);
+			}
+		} else {
+			printf("CHAR(5)");
+		}
+	} else {
+		printf("BIGINT");
+	}
+
+	printf(" NOT NULL");
+}
+
+static void print_sql_header(struct event_table *et)
+{
+	const char *name = et->event->name;
+	int i;
+
+	printf("\n---\n--- Table structure for table `%s`\n---\n\n", name);
+	printf("DROP TABLE IF EXISTS `%s`;\n", name);
+
+	printf("CREATE TABLE `%s` (\n", name);
+
+	printf("  `common_timestamp` BIGINT NOT NULL");
+
+	for (i = 0; event_common_fields[i]; i++) {
+		printf(",\n  ");
+		write_header(event_common_fields[i], 0);
+	}
+
+	for (i = 0; et->event_fields[i]; i++) {
+		printf(",\n  ");
+		write_header(et->event_fields[i], et->event_field_len[i]);
+	}
+
+	printf("\n) ENGINE=InnoDB DEFAULT CHARSET=utf8;\n");
+	printf("\n---\n--- Dumping data for table `%s`\n---\n\n", name);
+	printf("LOCK TABLES `%s` WRITE;\n", name);
+	printf("INSERT INTO `%s` VALUES ", name);
+
+	fflush(stdout);
+	fflush(et->fp);
+}
+
+int trace_sql_finish(struct tracecmd_input *handle)
+{
+	struct event_table *et;
+	char buffer[BUFSIZ];
+	int i, r;
+	int fd;
+
+	for (i = 0; i < event_table_size; i++) {
+		et = &event_table[i];
+		if (!et->cnt)
+			continue;
+
+		print_sql_header(et);
+
+		fd = fileno(et->fp);
+		lseek(fd, 0, SEEK_SET);
+		do {
+			r = read(fd, buffer, BUFSIZ);
+			if (r > 0)
+				write(1, buffer, r);
+		} while (r > 0);
+		fclose(et->fp);
+		printf(";\n");
+		printf("UNLOCK TABLES;\n");
+	}
+
+	return 0;
+}
-- 
2.20.1

