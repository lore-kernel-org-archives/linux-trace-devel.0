Return-Path: <SRS0=WdLK=LN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38361 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbeH3TLj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Aug 2018 15:11:39 -0400
Received: by mail-wm0-f67.google.com with SMTP id t25-v6so2374639wmi.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Aug 2018 08:09:03 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] Introduce new libtracevent API: tep_override_comm()
Date: Thu, 30 Aug 2018 18:09:00 +0300
Message-Id: <20180830150900.27412-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Added a new API of tracevent library: tep_override_comm()
It registers a pid / comm mapping. If a mapping with the same
pid already exists, the entry is updated with the new comm.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h |  1 +
 lib/traceevent/event-parse.c     | 67 +++++++++++++++++++++++++-------
 2 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 713a4e4..0dcc024 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -607,6 +607,7 @@ int tep_set_function_resolver(struct tep_handle *pevent,
 			      tep_func_resolver_t *func, void *priv);
 void tep_reset_function_resolver(struct tep_handle *pevent);
 int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid);
+int tep_override_comm(struct tep_handle *pevent, const char *comm, int pid);
 int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
 int tep_register_function(struct tep_handle *pevent, char *name,
 			  unsigned long long addr, char *mod);
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index ce1e202..e40f63c 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -230,10 +230,11 @@ int tep_pid_is_registered(struct tep_handle *pevent, int pid)
  * we must add this pid. This is much slower than when cmdlines
  * are added before the array is initialized.
  */
-static int add_new_comm(struct tep_handle *pevent, const char *comm, int pid)
+static int add_new_comm(struct tep_handle *pevent,
+			const char *comm, int pid, int overrite)
 {
 	struct cmdline *cmdlines = pevent->cmdlines;
-	const struct cmdline *cmdline;
+	struct cmdline *cmdline;
 	struct cmdline key;
 
 	if (!pid)
@@ -245,8 +246,18 @@ static int add_new_comm(struct tep_handle *pevent, const char *comm, int pid)
 	cmdline = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
 		       sizeof(*pevent->cmdlines), cmdline_cmp);
 	if (cmdline) {
-		errno = EEXIST;
-		return -1;
+		if (!overrite) {
+			errno = EEXIST;
+			return -1;
+		}
+		if (cmdline->comm)
+			free(cmdline->comm);
+		cmdline->comm = strdup(comm);
+		if(!cmdline->comm) {
+			errno = ENOMEM;
+			return -1;
+		}
+		return 0;
 	}
 
 	cmdlines = realloc(cmdlines, sizeof(*cmdlines) * (pevent->cmdline_count + 1));
@@ -273,21 +284,13 @@ static int add_new_comm(struct tep_handle *pevent, const char *comm, int pid)
 	return 0;
 }
 
-/**
- * tep_register_comm - register a pid / comm mapping
- * @pevent: handle for the pevent
- * @comm: the command line to register
- * @pid: the pid to map the command line to
- *
- * This adds a mapping to search for command line names with
- * a given pid. The comm is duplicated.
- */
-int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
+static int _tep_register_comm(struct tep_handle *pevent,
+			      const char *comm, int pid, int overrite)
 {
 	struct cmdline_list *item;
 
 	if (pevent->cmdlines)
-		return add_new_comm(pevent, comm, pid);
+		return add_new_comm(pevent, comm, pid, overrite);
 
 	item = malloc(sizeof(*item));
 	if (!item)
@@ -310,6 +313,40 @@ int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
 	return 0;
 }
 
+/**
+ * tep_register_comm - register a pid / comm mapping
+ * @pevent: handle for the pevent
+ * @comm: the command line to register
+ * @pid: the pid to map the command line to
+ *
+ * This adds a mapping to search for command line names with
+ * a given pid. The comm is duplicated. If a command with the same pid
+ * already exist, -1 is returned and errno is set to EEXIST
+ */
+int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
+{
+	return _tep_register_comm(pevent, comm, pid, 0);
+}
+
+/**
+ * tep_override_comm - register a pid / comm mapping
+ * @pevent: handle for the pevent
+ * @comm: the command line to register
+ * @pid: the pid to map the command line to
+ *
+ * This adds a mapping to search for command line names with
+ * a given pid. The comm is duplicated. If a command with the same pid
+ * already exist, the command string is udapted with the new one
+ */
+int tep_override_comm(struct tep_handle *pevent, const char *comm, int pid)
+{
+	if (!pevent->cmdlines && cmdline_init(pevent)) {
+		errno = ENOMEM;
+		return -1;
+	}
+	return _tep_register_comm(pevent, comm, pid, 1);
+}
+
 int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock)
 {
 	pevent->trace_clock = strdup(trace_clock);
-- 
2.17.1
