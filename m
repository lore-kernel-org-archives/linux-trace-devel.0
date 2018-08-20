Return-Path: <SRS0=Itc8=LD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38089 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbeHTRvR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Aug 2018 13:51:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id w11-v6so10612227wrc.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Aug 2018 07:35:23 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 09/24] trace-cmd: Rename pevent_register_* APIs
Date: Mon, 20 Aug 2018 17:34:50 +0300
Message-Id: <20180820143505.11525-10-tz.stoyanov@gmail.com>
In-Reply-To: <20180820143505.11525-1-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_register_comm, pevent_register_print_string

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h |  6 +++---
 kernel-shark/trace-graph.c       |  4 ++--
 lib/trace-cmd/trace-util.c       |  4 ++--
 lib/traceevent/event-parse.c     | 10 +++++-----
 plugins/plugin_sched_switch.c    |  2 +-
 tracecmd/trace-hist.c            |  6 +++---
 6 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 97eb42d..c368a55 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -606,12 +606,12 @@ enum trace_flag_type {
 int pevent_set_function_resolver(struct tep_handle *pevent,
 				 tep_func_resolver_t *func, void *priv);
 void pevent_reset_function_resolver(struct tep_handle *pevent);
-int pevent_register_comm(struct tep_handle *pevent, const char *comm, int pid);
+int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid);
 int pevent_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
 int pevent_register_function(struct tep_handle *pevent, char *name,
 			     unsigned long long addr, char *mod);
-int pevent_register_print_string(struct tep_handle *pevent, const char *fmt,
-				 unsigned long long addr);
+int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
+			      unsigned long long addr);
 int pevent_pid_is_registered(struct tep_handle *pevent, int pid);
 
 void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
index 04f58f1..3fe0f83 100644
--- a/kernel-shark/trace-graph.c
+++ b/kernel-shark/trace-graph.c
@@ -1134,8 +1134,8 @@ int trace_graph_check_sched_switch(struct graph_info *ginfo,
 		 *  comm / pid mappings.
 		 */
 		if (!pevent_pid_is_registered(ginfo->pevent, *pid))
-			pevent_register_comm(ginfo->pevent,
-					     *comm, *pid);
+			tep_register_comm(ginfo->pevent,
+					  *comm, *pid);
 	}
 
 	return ret;
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 7d4a2a4..877907d 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -374,7 +374,7 @@ void tracecmd_parse_cmdlines(struct tep_handle *pevent,
 	line = strtok_r(file, "\n", &next);
 	while (line) {
 		sscanf(line, "%d %ms", &pid, &comm);
-		pevent_register_comm(pevent, comm, pid);
+		tep_register_comm(pevent, comm, pid);
 		free(comm);
 		line = strtok_r(NULL, "\n", &next);
 	}
@@ -473,7 +473,7 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent,
 		/* fmt still has a space, skip it */
 		printk = strdup(fmt+1);
 		line = strtok_r(NULL, "\n", &next);
-		pevent_register_print_string(pevent, printk, addr);
+		tep_register_print_string(pevent, printk, addr);
 		free(printk);
 	}
 }
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 3bcdde8..fcde4d1 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -274,7 +274,7 @@ static int add_new_comm(struct tep_handle *pevent, const char *comm, int pid)
 }
 
 /**
- * pevent_register_comm - register a pid / comm mapping
+ * tep_register_comm - register a pid / comm mapping
  * @pevent: handle for the pevent
  * @comm: the command line to register
  * @pid: the pid to map the command line to
@@ -282,7 +282,7 @@ static int add_new_comm(struct tep_handle *pevent, const char *comm, int pid)
  * This adds a mapping to search for command line names with
  * a given pid. The comm is duplicated.
  */
-int pevent_register_comm(struct tep_handle *pevent, const char *comm, int pid)
+int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
 {
 	struct cmdline_list *item;
 
@@ -671,7 +671,7 @@ find_printk(struct tep_handle *pevent, unsigned long long addr)
 }
 
 /**
- * pevent_register_print_string - register a string by its address
+ * tep_register_print_string - register a string by its address
  * @pevent: handle for the pevent
  * @fmt: the string format to register
  * @addr: the address the string was located at
@@ -679,8 +679,8 @@ find_printk(struct tep_handle *pevent, unsigned long long addr)
  * This registers a string by the address it was stored in the kernel.
  * The @fmt passed in is duplicated.
  */
-int pevent_register_print_string(struct tep_handle *pevent, const char *fmt,
-				 unsigned long long addr)
+int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
+			      unsigned long long addr)
 {
 	struct printk_list *item = malloc(sizeof(*item));
 	char *p;
diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index fa3add1..534e99c 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -46,7 +46,7 @@ static void write_and_save_comm(struct format_field *field,
 	comm = &s->buffer[len];
 
 	/* Help out the comm to ids. This will handle dups */
-	pevent_register_comm(field->event->pevent, comm, pid);
+	tep_register_comm(field->event->pevent, comm, pid);
 }
 
 static int sched_wakeup_handler(struct trace_seq *s, struct tep_record *record,
diff --git a/tracecmd/trace-hist.c b/tracecmd/trace-hist.c
index 87f96d8..e8bf434 100644
--- a/tracecmd/trace-hist.c
+++ b/tracecmd/trace-hist.c
@@ -501,7 +501,7 @@ process_sched_wakeup(struct tep_handle *pevent, struct tep_record *record, int t
 
 	pid = val;
 
-	pevent_register_comm(pevent, comm, pid);
+	tep_register_comm(pevent, comm, pid);
 }
 
 static void
@@ -517,14 +517,14 @@ process_sched_switch(struct tep_handle *pevent, struct tep_record *record)
 	if (ret < 0)
 		die("no prev_pid field in sched_switch?");
 	pid = val;
-	pevent_register_comm(pevent, comm, pid);
+	tep_register_comm(pevent, comm, pid);
 
 	comm = (char *)(record->data + sched_switch_next_field->offset);
 	ret = tep_read_number_field(sched_switch_next_pid_field, record->data, &val);
 	if (ret < 0)
 		die("no next_pid field in sched_switch?");
 	pid = val;
-	pevent_register_comm(pevent, comm, pid);
+	tep_register_comm(pevent, comm, pid);
 }
 
 static void
-- 
2.17.1
