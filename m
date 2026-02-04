Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8061D27A476
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Feb 2026 17:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770224720; cv=none; b=pkqTt2kKTZLk41z5fohS1jLRvgLxZRiIgwfAFmD/Kgur06AaXmrM0SKGM4jOBxYXm6MdW4Gs1ALF5FxVJvTQSeiS3ReSBnv255HveRFfUWQo6uIC8dcds9OArupocBIEZj55CYkkTb4Pgjd58Fad/eQpygWsjXUeHv7ZLQzsq9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770224720; c=relaxed/simple;
	bh=zkYl0/iv1NdHH00Rk5MTQSQsW/ZfjU/MjI3gdMcWpc4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=kVaygqZRb0RanhdTgMINr8cr6hId/FaMPJ8SzsxixX3NlzGuD3ysfLWUvTN34pgmfRJFfgtJe1GSRZapyPyJSdH/S6VAqLpmmOTzbJcmZ7N05ZkhK/vsFIbrcEGGKwVfA/26tcleXvQFAmQlI78YrtkfNvu3G5TXRXl+O7m06OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9DDAE16027D;
	Wed,  4 Feb 2026 17:05:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 19F1620013;
	Wed,  4 Feb 2026 17:05:11 +0000 (UTC)
Date: Wed, 4 Feb 2026 12:05:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH] libtracefs: Add API for processing fprobes
Message-ID: <20260204120543.249126db@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w8fz1zjn35h1gu9jthqij9qbzyrcc8pf
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 19F1620013
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19Vi+5C4FMuEmzy0dEeisO/z5ww6Pja6CM=
X-HE-Tag: 1770224711-758268
X-HE-Meta: U2FsdGVkX1/HzWzCam7wZIOSwlrm5i93+kZjcIiYBSS2lpGYMkEIUTYOzaE6W4R5U1RwJPhlpLQbXThUYfzv0prOqVHBuZ+JPXGj4slE2FVRCaHj1QX01afhhlFllVlxOwgQ4RTBPOLCC4ciSJidENf6ojag0yYU5F3rpuRE3I8YZDABH1pj6fZXJF0w94kXChg1UFy/8+lPw9e3C1U/pC/KpNfufx0FGa7/+TY02d8smJCn/BiSt9nkNYBXQWqrZe+FC3IXIyihmVed2vXfhvIHLu2eiRTv64wQP9OaBpqbE25ks9kTYWNxg19SMQ4jh8ysYaTODuQyzSqk5LkASDjqqL1oYe7svkg7gtVfQGbTxDxN27kIpgZ0tvhhxKtwIaA5ebA35OAk0rfXjCK4eQ==

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the following API:

  tracefs_fprobe_alloc()
  tracefs_fprobe_raw()
  tracefs_fprobe_destroy()

To create and destroy Linux kernel fprobes.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-fprobes.txt | 245 +++++++++++++++++++++++++++
 Documentation/libtracefs.txt         |   9 +-
 include/tracefs.h                    |  10 +-
 samples/Makefile                     |   1 +
 src/tracefs-dynevents.c              |   1 +
 src/tracefs-kprobes.c                |  92 +++++++++-
 utest/tracefs-utest.c                |  90 ++++++++++
 7 files changed, 443 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/libtracefs-fprobes.txt

diff --git a/Documentation/libtracefs-fprobes.txt b/Documentation/libtracefs-fprobes.txt
new file mode 100644
index 000000000000..dcf9f455ace1
--- /dev/null
+++ b/Documentation/libtracefs-fprobes.txt
@@ -0,0 +1,245 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_fprobe_alloc, tracefs_fprobe_raw, tracefs_fprobe_destroy -
+Allocate, get, create, and remove fprobes
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+struct tracefs_dynevent pass:[*]*tracefs_fprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_func_, const char pass:[*]_format_);
+int *tracefs_fprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_,
+		       const char pass:[*]_func_, const char pass:[*]_format_);
+int *tracefs_fprobe_destroy*(const char pass:[*]_system_, const char pass:[*]_event_,
+			   const char pass:[*]_func_, const char pass:[*]_format_, bool _force_);
+--
+
+DESCRIPTION
+-----------
+*tracefs_fprobe_alloc*() allocates a new fprobe context. The fbrobe is not configured in the system.
+The fprobe can be added to the system by passing in the returned descriptor into
+*tracefs_dynevent_create(3)*.
+The new fprobe will be in the _system_ group (or fprobes if _system_ is NULL) and have the name of
+_event_ (or _func_ if _event_ is NULL). The fprobe will be inserted to _func_ (function name),
+and the _format_ will define the format of the fprobe.
+
+See the Linux documentation file under: Documentation/trace/fprobetrace.rst
+
+*tracefs_fprobe_raw*() will create a fprobe event. If _system_ is NULL, then
+the default "fprobes" is used for the group (event system). Otherwise if _system_
+is specified then the fprobe will be created under the group by that name. The
+_event_ is the name of the fprobe event to create. The _func_ is a function name.
+This is where the location of the fprobe will be inserted in the kernel. The
+_format_ is the fprobe format as specified as FETCHARGS in the Linux kernel source
+in the Documentation/trace/fprobetrace.rst document.
+
+*tracefs_fprobe_destroy*() will destroy a specific fprobe created by
+*tracefs_fprobe_raw*() with the same parameters.
+
+RETURN VALUE
+------------
+
+*tracefs_fprobe_raw*() returns 0 on success, or -1 on error.
+If a parsing error occurs on *tracefs_fprobe_raw*() then
+*tracefs_error_last*(3) may be used to retrieve the error message explaining the parsing issue.
+
+The *tracefs_fprobe_alloc*() function returns a pointer to an allocated
+tracefs_dynevent structure, describing the probe. This pointer must be freed by
+*tracefs_dynevent_free*(3). Note, this only allocates a descriptor representing the fprobe. It does
+not modify the running system.
+
+The *tracefs_fprobe_destroy*() returns 0 on success or -1 on error if it was not able to
+successful destory (or find) the fprobe.
+
+
+ERRORS
+------
+The following errors are for all the above calls:
+
+*EPERM* Not run as root user
+
+*ENODEV* fprobe events are not configured for the running kernel.
+
+*ENOMEM* Memory allocation error.
+
+*tracefs_fprobe_raw*() and *tracefs_fprobe_alloc*() can fail with the following errors:
+
+*EBADMSG* if _func_ is NULL.
+
+*EINVAL*  Most likely a parsing error occurred (use *tracefs_error_last*(3) to possibly
+          see what that error was).
+
+Other errors may also happen caused by internal system calls.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/wait.h>
+
+#include <tracefs.h>
+
+static struct tep_event *open_event;
+static struct tep_format_field *file_field;
+
+static struct tep_event *openret_event;
+static struct tep_format_field *ret_field;
+
+static int callback(struct tep_event *event, struct tep_record *record,
+		    int cpu, void *data)
+{
+	struct trace_seq seq;
+
+	trace_seq_init(&seq);
+	tep_print_event(event->tep, &seq, record, "%d-%s: ", TEP_PRINT_PID, TEP_PRINT_COMM);
+
+	if (event->id == open_event->id) {
+		trace_seq_puts(&seq, "open file='");
+		tep_print_field(&seq, record->data, file_field);
+		trace_seq_puts(&seq, "'\n");
+	} else if (event->id == openret_event->id) {
+		unsigned long long ret;
+		tep_read_number_field(ret_field, record->data, &ret);
+		trace_seq_printf(&seq, "open ret=%lld\n", ret);
+	} else {
+		goto out;
+	}
+
+	trace_seq_terminate(&seq);
+	trace_seq_do_printf(&seq);
+out:
+	trace_seq_destroy(&seq);
+
+	return 0;
+}
+
+static pid_t run_exec(char **argv, char **env)
+{
+	pid_t pid;
+
+	pid = fork();
+	if (pid)
+		return pid;
+
+	execve(argv[0], argv, env);
+	perror("exec");
+	exit(-1);
+}
+
+const char *myfprobe = "my_fprobes";
+
+static void fprobe_create(const char *event, const char *func, const char *fmt)
+{
+	char *err;
+	int r;
+
+	r = tracefs_fprobe_raw(myfprobe, event, func, fmt);
+	if (r < 0) {
+		err = tracefs_error_last(NULL);
+		perror("Failed to create kprobe:");
+		if (err && strlen(err))
+			fprintf(stderr, "%s\n", err);
+	}
+}
+
+int main (int argc, char **argv, char **env)
+{
+	struct tracefs_instance *instance;
+	struct tep_handle *tep;
+	const char *sysnames[] = { myfprobe, NULL };
+	pid_t pid;
+
+	if (argc < 2) {
+		printf("usage: %s command\n", argv[0]);
+		exit(-1);
+	}
+
+	instance = tracefs_instance_create("exec_open");
+	if (!instance) {
+		perror("creating instance");
+		exit(-1);
+	}
+
+	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_FPROBE, true);
+
+	fprobe_create("open", "do_sys_openat2",
+		      "file=+0($arg2):ustring flags=+0($arg3):x64 mode=+8($arg3):x64\n");
+
+	fprobe_create("openret", "do_sys_openat2", "ret=$retval");
+
+	tep = tracefs_local_events_system(NULL, sysnames);
+	if (!tep) {
+		perror("reading events");
+		exit(-1);
+	}
+	open_event = tep_find_event_by_name(tep, myfprobe, "open");
+	file_field = tep_find_field(open_event, "file");
+
+	openret_event = tep_find_event_by_name(tep, myfprobe, "openret");
+	ret_field = tep_find_field(openret_event, "ret");
+
+	tracefs_event_enable(instance, myfprobe, NULL);
+	pid = run_exec(&argv[1], env);
+
+	/* Let the child start to run */
+	sched_yield();
+
+	do {
+		tracefs_load_cmdlines(NULL, tep);
+		tracefs_iterate_raw_events(tep, instance, NULL, 0, callback, NULL);
+	} while (waitpid(pid, NULL, WNOHANG) != pid);
+
+	/* Will disable the events */
+	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_FPROBE, true);
+	tracefs_instance_destroy(instance);
+	tep_free(tep);
+
+	return 0;
+}
+--
+
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2026 Google LLC. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 860e2be7d96a..84c70d23b5fd 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -210,10 +210,10 @@ Dynamic event generic APIs:
 	enum tracefs_dynevent_type *tracefs_dynevent_info*(struct tracefs_dynevent pass:[*]_dynevent_, char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_, char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_, char pass:[*]pass:[*]_format_);
 	struct tep_event pass:[*]*tracefs_dynevent_get_event*(struct tep_handle pass:[*]_tep_, struct tracefs_dynevent pass:[*]_dynevent_);
 
-Even probes (eprobes):
+Event probes (eprobes):
 	struct tracefs_dynevent pass:[*] *tracefs_eprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_target_system_, const char pass:[*]_target_event_, const char pass:[*]_fetchargs_);
 
-Uprobes, Kprobes and Kretprobes:
+Uprobes, Fprobes, Kprobes and Kretprobes:
 	struct tracefs_dynevent pass:[*] *tracefs_kprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
 	struct tracefs_dynevent pass:[*] *tracefs_kretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_, unsigned int _max_);
 	int *tracefs_kprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
@@ -224,6 +224,11 @@ Uprobes, Kprobes and Kretprobes:
 		     const char pass:[*]_file_, unsigned long long _offset_, const char pass:[*]_fetchargs_);
 	int *tracefs_kprobe_destroy*(const char pass:[*]_system_, const char pass:[*]_event_,
 			   const char pass:[*]_addr_, const char pass:[*]_format_, bool _force_);
+	struct tracefs_dynevent pass:[*]*tracefs_fprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_func_, const char pass:[*]_format_);
+	int *tracefs_fprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_,
+		       const char pass:[*]_func_, const char pass:[*]_format_);
+	int *tracefs_fprobe_destroy*(const char pass:[*]_system_, const char pass:[*]_event_,
+			   const char pass:[*]_func_, const char pass:[*]_format_, bool _force_);
 
 Synthetic events:
 	struct tracefs_synth pass:[*]*tracefs_sql*(struct tep_handle pass:[*]_tep_, const char pass:[*]_name_,
diff --git a/include/tracefs.h b/include/tracefs.h
index b6e0f6b3c851..392259c25496 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -321,7 +321,8 @@ enum tracefs_dynevent_type {
 	TRACEFS_DYNEVENT_URETPROBE	= 1 << 3,
 	TRACEFS_DYNEVENT_EPROBE		= 1 << 4,
 	TRACEFS_DYNEVENT_SYNTH		= 1 << 5,
-	TRACEFS_DYNEVENT_MAX		= 1 << 6,
+	TRACEFS_DYNEVENT_FPROBE		= 1 << 6,
+	TRACEFS_DYNEVENT_MAX		= 1 << 7,
 };
 
 #define TRACEFS_DYNEVENT_ALL		0xFFFFFFFF
@@ -363,6 +364,13 @@ int tracefs_kretprobe_raw(const char *system, const char *event,
 int tracefs_kprobe_destroy(const char *system, const char *event,
 			   const char *addr, const char *format, bool force);
 
+struct tracefs_dynevent *
+tracefs_fprobe_alloc(const char *system, const char *event, const char *func, const char *format);
+int tracefs_fprobe_raw(const char *system, const char *event,
+		       const char *func, const char *format);
+int tracefs_fprobe_destroy(const char *system, const char *event,
+			   const char *addr, const char *format, bool force);
+
 enum tracefs_hist_key_type {
 	TRACEFS_HIST_KEY_NORMAL = 0,
 	TRACEFS_HIST_KEY_HEX,
diff --git a/samples/Makefile b/samples/Makefile
index 7b68ae7ad34c..7f662a8d33da 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -12,6 +12,7 @@ EXAMPLES += dynevents
 EXAMPLES += kprobes
 EXAMPLES += eprobes
 EXAMPLES += uprobes
+EXAMPLES += fprobes
 EXAMPLES += synth
 EXAMPLES += error
 EXAMPLES += filter
diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index 330ef24e586f..5fdb723b6825 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -47,6 +47,7 @@ struct dyn_events_desc {
 	{TRACEFS_DYNEVENT_URETPROBE, UPROBE_EVENTS, "r", dyn_generic_del, dyn_generic_parse},
 	{TRACEFS_DYNEVENT_EPROBE,    "",            "e", dyn_generic_del, dyn_generic_parse},
 	{TRACEFS_DYNEVENT_SYNTH,     SYNTH_EVENTS, "", dyn_synth_del, dyn_synth_parse},
+	{TRACEFS_DYNEVENT_FPROBE,    "",            "f", dyn_generic_del, dyn_generic_parse},
 };
 
 static int dyn_generic_del(struct dyn_events_desc *desc, struct tracefs_dynevent *dyn)
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 09b09d7ace04..c85df9a06525 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -19,6 +19,7 @@
 
 #define KPROBE_EVENTS "kprobe_events"
 #define KPROBE_DEFAULT_GROUP "kprobes"
+#define FPROBE_DEFAULT_GROUP "fprobes"
 
 static struct tracefs_dynevent *
 kprobe_alloc(enum tracefs_dynevent_type type, const char *system, const char *event,
@@ -33,8 +34,10 @@ kprobe_alloc(enum tracefs_dynevent_type type, const char *system, const char *ev
 		errno = EBADMSG;
 		return NULL;
 	}
-	if (!sys)
-		sys = KPROBE_DEFAULT_GROUP;
+	if (!sys) {
+		sys = type == TRACEFS_DYNEVENT_FPROBE ?
+			FPROBE_DEFAULT_GROUP : KPROBE_DEFAULT_GROUP;
+	}
 
 	if (!event) {
 		ename = strdup(addr);
@@ -226,3 +229,88 @@ int tracefs_kprobe_destroy(const char *system, const char *event,
 
 	return ret;
 }
+
+/**
+ * tracefs_fprobe_alloc - Allocate new fprobe
+ * @system: The system name (NULL for the default fprobes)
+ * @event: The event to create (NULL to use @func for the event)
+ * @func: The function to insert the probe
+ * @format: The format string to define the probe.
+ *
+ * Allocate a fprobe context that will be in the @system group (or fprobes if
+ * @system is NULL). Have the name of @event (or @func if @event is NULL). Will
+ * be inserted to @func (function name). And the @format will define the format
+ * of the fprobe.
+ *
+ * See the Linux documentation file under:
+ *  Documentation/trace/fprobetrace.rst
+ *
+ * The fprobe is not created in the system.
+ *
+ * Return a pointer to a fprobe context on success, or NULL on error.
+ * The returned pointer must be freed with tracefs_dynevent_free()
+ *
+ * errno will be set to EBADMSG if addr is NULL.
+ */
+struct tracefs_dynevent *
+tracefs_fprobe_alloc(const char *system, const char *event, const char *func, const char *format)
+
+{
+	return kprobe_alloc(TRACEFS_DYNEVENT_FPROBE, system, event, func, format);
+}
+
+/**
+ * tracefs_fprobe_raw - Create a fprobe using raw format
+ * @system: The system name (NULL for the default fprobes)
+ * @event: The event to create (NULL to use @func for the event)
+ * @func: The function to insert the probe
+ * @format: The raw format string to define the probe.
+ *
+ * Create a fprobe that will be in the @system group (or fprobes if
+ * @system is NULL). Have the name of @event (or @func if @event is
+ * NULL). Will be inserted to @func (function name). And the @format
+ * will define the raw format of the fprobe.
+ *
+ * See the Linux documentation file under:
+ *    Documentation/trace/fprobetrace.rst
+ *
+ * Return 0 on success, or -1 on error.
+ *   If the syntex of @format was incorrect, running
+ *   tracefs_error_last(NULL) may show what went wrong.
+ *
+ * errno will be set to EBADMSG if addr or format is NULL.
+ */
+int tracefs_fprobe_raw(const char *system, const char *event,
+		       const char *func, const char *format)
+{
+	return kprobe_raw(TRACEFS_DYNEVENT_FPROBE, system, event, func, format);
+}
+
+/**
+ * tracefs_fprobe_destroy - Remove an individual fprobe
+ * @system: The system of the fprobe to remove (could be NULL)
+ * @event: The event of the fprobe to remove
+ * @func: The function used to create the fprobe
+ * @format: The format used to create the fprobe
+ * @force: If true, try to disable the fprobe first
+ *
+ * This removes the fprobe was created by tracefs_kprobe_raw().
+ *
+ * Returns 0 on success and -1 otherwise.
+ */
+int tracefs_fprobe_destroy(const char *system, const char *event,
+			   const char *func, const char *format, bool force)
+{
+	struct tracefs_dynevent *fp;
+	int ret;
+
+	fp = tracefs_fprobe_alloc(system, event, func, format);
+	if (!fp)
+		return -1;
+
+	ret = tracefs_dynevent_destroy(fp, force);
+
+	tracefs_dynevent_free(fp);
+
+	return ret;
+}
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 97a91dfcdb2c..353b3cbee199 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -2529,6 +2529,95 @@ static void test_eprobes(void)
 	test_eprobes_instance(test_instance);
 }
 
+static void test_fprobes_instance(struct tracefs_instance *instance)
+{
+	struct probe_test ftests[] = {
+		{ TRACEFS_DYNEVENT_FPROBE, "f", NULL, "mkdir", "do_mkdirat", "path=+u0($arg2):ustring" },
+		{ TRACEFS_DYNEVENT_FPROBE, "f", NULL, "close", "close_fd", NULL },
+		{ TRACEFS_DYNEVENT_FPROBE, "f", "ftest", "open2", "do_sys_openat2",
+				  "file=+u0($arg2):ustring flags=+0($arg3):x64" },
+	};
+	int fprobe_count = sizeof(ftests) / sizeof((ftests)[0]);
+	struct tracefs_dynevent **dfprobe;
+	struct tracefs_dynevent **devents;
+	struct tep_handle *tep;
+	int ret;
+	int i;
+
+	tep = tep_alloc();
+	CU_TEST(tep != NULL);
+
+	dfprobe = calloc(fprobe_count + 1, sizeof(*dfprobe));
+
+	/* Invalid parameters */
+	CU_TEST(tracefs_fprobe_alloc("test", NULL, NULL, "test") == NULL);
+	CU_TEST(tracefs_fprobe_raw("test", "test", NULL, "test") != 0);
+
+	/* fprobes APIs */
+	destroy_dynevents(TRACEFS_DYNEVENT_FPROBE);
+
+	for (i = 0; i < fprobe_count; i++) {
+		dfprobe[i] = tracefs_fprobe_alloc(ftests[i].system, ftests[i].event,
+						  ftests[i].address, ftests[i].format);
+		CU_TEST(dfprobe[i] != NULL);
+	}
+	dfprobe[i] = NULL;
+	get_dynevents_check(TRACEFS_DYNEVENT_FPROBE, 0);
+	CU_TEST(check_probes(ftests, fprobe_count, dfprobe, false, instance, tep));
+
+	for (i = 0; i < fprobe_count; i++) {
+		CU_TEST(tracefs_dynevent_create(dfprobe[i]) == 0);
+	}
+	devents = get_dynevents_check(TRACEFS_DYNEVENT_FPROBE, fprobe_count);
+	CU_TEST(check_probes(ftests, fprobe_count, devents, true, instance, tep));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	for (i = 0; i < fprobe_count; i++) {
+		CU_TEST(tracefs_dynevent_destroy(dfprobe[i], false) == 0);
+	}
+	get_dynevents_check(TRACEFS_DYNEVENT_FPROBE, 0);
+	CU_TEST(check_probes(ftests, fprobe_count, dfprobe, false, instance, tep));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	for (i = 0; i < fprobe_count; i++)
+		tracefs_dynevent_free(dfprobe[i]);
+
+	/* kprobes raw APIs */
+	destroy_dynevents(TRACEFS_DYNEVENT_FPROBE);
+
+	for (i = 0; i < fprobe_count; i++) {
+		ret = tracefs_fprobe_raw(ftests[i].system, ftests[i].event,
+					 ftests[i].address, ftests[i].format);
+		CU_TEST(ret == 0);
+	}
+
+	devents = get_dynevents_check(TRACEFS_DYNEVENT_FPROBE, fprobe_count);
+	CU_TEST(check_probes(ftests, fprobe_count, devents, true, instance, tep));
+	tracefs_dynevent_list_free(devents);
+	devents = NULL;
+
+	/* Try destroying all the events using tracefs_kprobe_destroy */
+	for (i = 0; i < fprobe_count; i++) {
+		ret = tracefs_fprobe_destroy(ftests[i].system, ftests[i].event,
+					     ftests[i].address, ftests[i].format, true);
+		CU_TEST(ret == 0);
+		devents = get_dynevents_check(TRACEFS_DYNEVENT_FPROBE,
+					      fprobe_count - (i + 1));
+		tracefs_dynevent_list_free(devents);
+	}
+	get_dynevents_check(TRACEFS_DYNEVENT_KPROBE, 0);
+
+	free(dfprobe);
+	tep_free(tep);
+}
+
+static void test_fprobes(void)
+{
+	test_fprobes_instance(test_instance);
+}
+
 #define FOFFSET 1000ll
 static void test_uprobes_instance(struct tracefs_instance *instance)
 {
@@ -3947,5 +4036,6 @@ void test_tracefs_lib(void)
 	CU_add_test(suite, "synthetic events", test_synthetic);
 	CU_add_test(suite, "eprobes", test_eprobes);
 	CU_add_test(suite, "uprobes", test_uprobes);
+	CU_add_test(suite, "fprobes", test_fprobes);
 	CU_add_test(suite, "multi probe test", test_multi_probes);
 }
-- 
2.51.0

