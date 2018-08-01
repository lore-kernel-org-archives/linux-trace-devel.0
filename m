Return-Path: <SRS0=FUMn=KQ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51009 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389200AbeHAO2O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Aug 2018 10:28:14 -0400
Received: by mail-wm0-f68.google.com with SMTP id s12-v6so6845450wmc.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Aug 2018 05:42:35 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 09/24] tools/lib/traceevent, tools/perf: Rename pevent_register_* APIs
Date: Wed,  1 Aug 2018 15:41:41 +0300
Message-Id: <20180801124156.20894-10-tz.stoyanov@gmail.com>
In-Reply-To: <20180801124156.20894-1-tz.stoyanov@gmail.com>
References: <20180801124156.20894-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_" and not "pevent_". This changes
APIs: pevent_register_comm, pevent_register_print_string

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c         | 8 ++++----
 tools/lib/traceevent/event-parse.h         | 4 ++--
 tools/lib/traceevent/plugin_sched_switch.c | 2 +-
 tools/perf/util/trace-event-parse.c        | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index dacef9fdb512..50cc1ea10beb 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -288,7 +288,7 @@ static int add_new_comm(struct tep_handle *pevent, const char *comm, int pid)
 }
 
 /**
- * pevent_register_comm - register a pid / comm mapping
+ * tep_register_comm - register a pid / comm mapping
  * @pevent: handle for the pevent
  * @comm: the command line to register
  * @pid: the pid to map the command line to
@@ -296,7 +296,7 @@ static int add_new_comm(struct tep_handle *pevent, const char *comm, int pid)
  * This adds a mapping to search for command line names with
  * a given pid. The comm is duplicated.
  */
-int pevent_register_comm(struct tep_handle *pevent, const char *comm, int pid)
+int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
 {
 	struct cmdline_list *item;
 
@@ -685,7 +685,7 @@ find_printk(struct tep_handle *pevent, unsigned long long addr)
 }
 
 /**
- * pevent_register_print_string - register a string by its address
+ * tep_register_print_string - register a string by its address
  * @pevent: handle for the pevent
  * @fmt: the string format to register
  * @addr: the address the string was located at
@@ -693,7 +693,7 @@ find_printk(struct tep_handle *pevent, unsigned long long addr)
  * This registers a string by the address it was stored in the kernel.
  * The @fmt passed in is duplicated.
  */
-int pevent_register_print_string(struct tep_handle *pevent, const char *fmt,
+int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 				 unsigned long long addr)
 {
 	struct printk_list *item = malloc(sizeof(*item));
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 9f30a266c23d..98f3d7bc60f5 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -618,11 +618,11 @@ enum trace_flag_type {
 int pevent_set_function_resolver(struct tep_handle *pevent,
 				 tep_func_resolver_t *func, void *priv);
 void pevent_reset_function_resolver(struct tep_handle *pevent);
-int pevent_register_comm(struct tep_handle *pevent, const char *comm, int pid);
+int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid);
 int pevent_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
 int pevent_register_function(struct tep_handle *pevent, char *name,
 			     unsigned long long addr, char *mod);
-int pevent_register_print_string(struct tep_handle *pevent, const char *fmt,
+int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 				 unsigned long long addr);
 int pevent_pid_is_registered(struct tep_handle *pevent, int pid);
 
diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceevent/plugin_sched_switch.c
index 90d2ef293cf9..4d8eaab6ac15 100644
--- a/tools/lib/traceevent/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -61,7 +61,7 @@ static void write_and_save_comm(struct format_field *field,
 	comm = &s->buffer[len];
 
 	/* Help out the comm to ids. This will handle dups */
-	pevent_register_comm(field->event->pevent, comm, pid);
+	tep_register_comm(field->event->pevent, comm, pid);
 }
 
 static int sched_wakeup_handler(struct trace_seq *s,
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index a0e2b2c54567..920b1d58a068 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -157,7 +157,7 @@ void parse_ftrace_printk(struct tep_handle *pevent,
 		/* fmt still has a space, skip it */
 		printk = strdup(fmt+1);
 		line = strtok_r(NULL, "\n", &next);
-		pevent_register_print_string(pevent, printk, addr);
+		tep_register_print_string(pevent, printk, addr);
 	}
 }
 
@@ -172,7 +172,7 @@ void parse_saved_cmdline(struct tep_handle *pevent,
 	line = strtok_r(file, "\n", &next);
 	while (line) {
 		sscanf(line, "%d %ms", &pid, &comm);
-		pevent_register_comm(pevent, comm, pid);
+		tep_register_comm(pevent, comm, pid);
 		free(comm);
 		line = strtok_r(NULL, "\n", &next);
 	}
-- 
2.17.1
