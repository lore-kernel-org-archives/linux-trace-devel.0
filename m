Return-Path: <SRS0=xHrW=KR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:53209 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732540AbeHBPyV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Aug 2018 11:54:21 -0400
Received: by mail-wm0-f66.google.com with SMTP id o11-v6so2647823wmh.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Aug 2018 07:02:58 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 18/24] tools/lib/traceevent: Rename pevent_data_ APIs
Date: Thu,  2 Aug 2018 17:02:18 +0300
Message-Id: <20180802140224.19070-19-tz.stoyanov@gmail.com>
In-Reply-To: <20180802140224.19070-1-tz.stoyanov@gmail.com>
References: <20180802140224.19070-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_data_lat_fmt, pevent_data_type, pevent_data_event_from_type,
pevent_data_pid, pevent_data_preempt_count, pevent_data_flags,
pevent_data_comm_from_pid, pevent_data_pid_from_comm, pevent_cmdline_pid

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c  | 44 ++++++++++++++---------------
 tools/lib/traceevent/event-parse.h  | 22 +++++++--------
 tools/lib/traceevent/parse-filter.c |  6 ++--
 3 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 0de470c07be9..4f924bf42b92 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5140,7 +5140,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 }
 
 /**
- * pevent_data_lat_fmt - parse the data for the latency format
+ * tep_data_lat_fmt - parse the data for the latency format
  * @pevent: a handle to the pevent
  * @s: the trace_seq to write to
  * @record: the record to read from
@@ -5149,8 +5149,8 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
  * need rescheduling, in hard/soft interrupt, preempt count
  * and lock depth) and places it into the trace_seq.
  */
-void pevent_data_lat_fmt(struct tep_handle *pevent,
-			 struct trace_seq *s, struct tep_record *record)
+void tep_data_lat_fmt(struct tep_handle *pevent,
+		      struct trace_seq *s, struct tep_record *record)
 {
 	static int check_lock_depth = 1;
 	static int check_migrate_disable = 1;
@@ -5223,55 +5223,55 @@ void pevent_data_lat_fmt(struct tep_handle *pevent,
 }
 
 /**
- * pevent_data_type - parse out the given event type
+ * tep_data_type - parse out the given event type
  * @pevent: a handle to the pevent
  * @rec: the record to read from
  *
  * This returns the event id from the @rec.
  */
-int pevent_data_type(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_type(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return trace_parse_common_type(pevent, rec->data);
 }
 
 /**
- * pevent_data_event_from_type - find the event by a given type
+ * tep_data_event_from_type - find the event by a given type
  * @pevent: a handle to the pevent
  * @type: the type of the event.
  *
  * This returns the event form a given @type;
  */
-struct event_format *pevent_data_event_from_type(struct tep_handle *pevent, int type)
+struct event_format *tep_data_event_from_type(struct tep_handle *pevent, int type)
 {
 	return tep_find_event(pevent, type);
 }
 
 /**
- * pevent_data_pid - parse the PID from record
+ * tep_data_pid - parse the PID from record
  * @pevent: a handle to the pevent
  * @rec: the record to parse
  *
  * This returns the PID from a record.
  */
-int pevent_data_pid(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return parse_common_pid(pevent, rec->data);
 }
 
 /**
- * pevent_data_preempt_count - parse the preempt count from the record
+ * tep_data_preempt_count - parse the preempt count from the record
  * @pevent: a handle to the pevent
  * @rec: the record to parse
  *
  * This returns the preempt count from a record.
  */
-int pevent_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return parse_common_pc(pevent, rec->data);
 }
 
 /**
- * pevent_data_flags - parse the latency flags from the record
+ * tep_data_flags - parse the latency flags from the record
  * @pevent: a handle to the pevent
  * @rec: the record to parse
  *
@@ -5279,20 +5279,20 @@ int pevent_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec)
  *
  *  Use trace_flag_type enum for the flags (see event-parse.h).
  */
-int pevent_data_flags(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec)
 {
 	return parse_common_flags(pevent, rec->data);
 }
 
 /**
- * pevent_data_comm_from_pid - return the command line from PID
+ * tep_data_comm_from_pid - return the command line from PID
  * @pevent: a handle to the pevent
  * @pid: the PID of the task to search for
  *
  * This returns a pointer to the command line that has the given
  * @pid.
  */
-const char *pevent_data_comm_from_pid(struct tep_handle *pevent, int pid)
+const char *tep_data_comm_from_pid(struct tep_handle *pevent, int pid)
 {
 	const char *comm;
 
@@ -5317,7 +5317,7 @@ pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct cmdline *ne
 }
 
 /**
- * pevent_data_pid_from_comm - return the pid from a given comm
+ * tep_data_pid_from_comm - return the pid from a given comm
  * @pevent: a handle to the pevent
  * @comm: the cmdline to find the pid from
  * @next: the cmdline structure to find the next comm
@@ -5329,8 +5329,8 @@ pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct cmdline *ne
  * next pid.
  * Also, it does a linear seach, so it may be slow.
  */
-struct cmdline *pevent_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
-					  struct cmdline *next)
+struct cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
+				       struct cmdline *next)
 {
 	struct cmdline *cmdline;
 
@@ -5365,13 +5365,13 @@ struct cmdline *pevent_data_pid_from_comm(struct tep_handle *pevent, const char
 }
 
 /**
- * pevent_cmdline_pid - return the pid associated to a given cmdline
+ * tep_cmdline_pid - return the pid associated to a given cmdline
  * @cmdline: The cmdline structure to get the pid from
  *
  * Returns the pid for a give cmdline. If @cmdline is NULL, then
  * -1 is returned.
  */
-int pevent_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
+int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
 {
 	struct cmdline_list *cmdlist = (struct cmdline_list *)cmdline;
 
@@ -5391,7 +5391,7 @@ int pevent_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
 }
 
 /**
- * pevent_data_comm_from_pid - parse the data into the print format
+ * tep_event_info - parse the data into the print format
  * @s: the trace_seq to write to
  * @event: the handle to the event
  * @record: the record to read from
@@ -5511,7 +5511,7 @@ void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 	}
 
 	if (pevent->latency_format) {
-		pevent_data_lat_fmt(pevent, s, record);
+		tep_data_lat_fmt(pevent, s, record);
 	}
 
 	if (use_usec_format) {
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index dc0d2d3b7c33..2c4da2f1d4ed 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -705,18 +705,18 @@ pevent_find_event_by_name(struct tep_handle *pevent, const char *sys, const char
 struct event_format *
 pevent_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
 
-void pevent_data_lat_fmt(struct tep_handle *pevent,
-			 struct trace_seq *s, struct tep_record *record);
-int pevent_data_type(struct tep_handle *pevent, struct tep_record *rec);
-struct event_format *pevent_data_event_from_type(struct tep_handle *pevent, int type);
-int pevent_data_pid(struct tep_handle *pevent, struct tep_record *rec);
-int pevent_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
-int pevent_data_flags(struct tep_handle *pevent, struct tep_record *rec);
-const char *pevent_data_comm_from_pid(struct tep_handle *pevent, int pid);
+void tep_data_lat_fmt(struct tep_handle *pevent,
+		      struct trace_seq *s, struct tep_record *record);
+int tep_data_type(struct tep_handle *pevent, struct tep_record *rec);
+struct event_format *tep_data_event_from_type(struct tep_handle *pevent, int type);
+int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec);
+int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
+int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec);
+const char *tep_data_comm_from_pid(struct tep_handle *pevent, int pid);
 struct cmdline;
-struct cmdline *pevent_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
-					  struct cmdline *next);
-int pevent_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline);
+struct cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
+				       struct cmdline *next);
+int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline);
 
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct format_field *field);
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index f3d812676169..474d820e97e1 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1705,8 +1705,8 @@ get_comm(struct event_format *event, struct tep_record *record)
 	const char *comm;
 	int pid;
 
-	pid = pevent_data_pid(event->pevent, record);
-	comm = pevent_data_comm_from_pid(event->pevent, pid);
+	pid = tep_data_pid(event->pevent, record);
+	comm = tep_data_comm_from_pid(event->pevent, pid);
 	return comm;
 }
 
@@ -2060,7 +2060,7 @@ enum tep_errno tep_filter_match(struct event_filter *filter,
 	if (!filter->filters)
 		return TEP_ERRNO__NO_FILTER;
 
-	event_id = pevent_data_type(pevent, record);
+	event_id = tep_data_type(pevent, record);
 
 	filter_type = find_filter_type(filter, event_id);
 	if (!filter_type)
-- 
2.17.1
