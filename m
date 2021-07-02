Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C89C11F67
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65E3461416
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 03:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhGBDNA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 23:13:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234829AbhGBDM6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 23:12:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3F3561410;
        Fri,  2 Jul 2021 03:10:26 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lz9ZR-000e8Z-PN; Thu, 01 Jul 2021 23:10:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 7/7] libtracefs: Add man pages for kprobe functions
Date:   Thu,  1 Jul 2021 23:10:22 -0400
Message-Id: <20210702031022.154146-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702031022.154146-1-rostedt@goodmis.org>
References: <20210702031022.154146-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add man pages that describe the following functions:

    tracefs_kprobe_raw
    tracefs_kretprobe_raw
    tracefs_get_kprobes
    tracefs_kprobe_clear_all
    tracefs_kprobe_clear_probe

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-kprobes.txt | 275 +++++++++++++++++++++++++++
 1 file changed, 275 insertions(+)
 create mode 100644 Documentation/libtracefs-kprobes.txt

diff --git a/Documentation/libtracefs-kprobes.txt b/Documentation/libtracefs-kprobes.txt
new file mode 100644
index 000000000000..0787382ae8b2
--- /dev/null
+++ b/Documentation/libtracefs-kprobes.txt
@@ -0,0 +1,275 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_kprobe_raw, tracefs_kretprobe_raw, tracefs_get_kprobes, tracefs_kprobe_clear_all, tracefs_kprobe_clear_probe - Create, list, and destroy kprobes
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int tracefs_kprobe_raw(const char pass:[*]system, const char pass:[*]event, const char pass:[*]addr, const char pass:[*]format);
+int tracefs_kretprobe_raw(const char pass:[*]system, const char pass:[*]event, const char pass:[*]addr, const char pass:[*]format);
+char pass:[*]pass:[*]tracefs_get_kprobes(void);
+int tracefs_kprobe_clear_all(bool force);
+int tracefs_kprobe_clear_probe(const char pass:[*]system, const char pass:[*]event, bool force);
+--
+
+DESCRIPTION
+-----------
+*tracefs_kprobe_raw*() will create a kprobe event. If _system_ is NULL, then
+the default "kprobes" is used for the group (event system). Otherwise if _system_
+is specified then the kprobe will be created under the group by that name. The
+_event_ is the name of the kprobe event to create. The _addr_ can be a function,
+a function and offset, or a kernel address. This is where the location of the
+kprobe will be inserted in the kernel. The _format_ is the kprobe format as
+specified as FETCHARGS in the Linux kernel source in the Documentation/trace/kprobetrace.rst
+document.
+
+*tracefs_kretprobe_raw*() is the same as *tracefs_kprobe_raw()*, except that it
+creates a kretprobe instead of a kprobe. The difference is also described
+in the Linux kernel source in the Documentation/trace/kprobetrace.rst file.
+
+*tracefs_get_kprobes*() returns an array of strings (char pass:[*]) that contain
+the registered kprobes and kretprobes. The names are in the "system/event" format.
+That is, one string holds both the kprobe's name as well as the group it is
+defined under. These strings are allocated and may be modified with the
+*strtok*(3) and *strtok_r*(3) functions. The string returned must be freed with
+*tracefs_list_free*(3).
+
+*tracefs_kprobe_clear_all*() will try to remove all kprobes that have been
+registered. If the @force flag is set, it will then disable those kprobe events
+if they are enabled and then try to clear the kprobes.
+
+*tracefs_kprobe_clear_probe*() will try to clear specified kprobes. If _system_
+is NULL, then it will only clear the default kprobes under the "kprobes" group.
+If _event_ is NULL, it will clear all kprobes under the given _system_. If the
+_force_ flag is set, then it will disable the given kprobe events before clearing
+them.
+
+RETURN VALUE
+------------
+
+*tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*(), *tracefs_kprobe_clear_all*(),
+and *tracefs_kprobe_clear_probe*() return 0 on success, or -1 on error.
+
+If a parsing error occurs on *tracefs_kprobe_raw*() or *tracefs_kretprobe_raw*()
+then *tracefs_error_last*(3) may be used to retrieve the error message explaining
+the parsing issue.
+
+*tracefs_get_kprobes*() returns an allocate string list of allocated strings
+on success that must be freed with *tracefs_list_free*(3) and returns
+NULL on error.
+
+ERRORS
+------
+The following errors are for all the above calls:
+
+*EPERM* Not run as root user
+
+*ENODEV* Kprobe events are not configured for the running kernel.
+
+*ENOMEM* Memory allocation error.
+
+*tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*() can fail with the following errors:
+
+*EBADMSG* Either _addr_ or _format_ are NULL.
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
+#include <tracefs/tracefs.h>
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
+const char *mykprobe = "my_kprobes";
+
+enum kprobe_type {
+	KPROBE,
+	KRETPROBE,
+};
+
+static void __kprobe_create(enum kprobe_type type, const char *event,
+			    const char *addr, const char *fmt)
+{
+	char *err;
+	int r;
+
+	if (type == KPROBE)
+		r = tracefs_kprobe_raw(mykprobe, event, addr, fmt);
+	else
+		r = tracefs_kretprobe_raw(mykprobe, event, addr, fmt);
+	if (r < 0) {
+		err = tracefs_error_last(NULL);
+		perror("Failed to create kprobe:");
+		if (err && strlen(err))
+			fprintf(stderr, "%s\n", err);
+	}
+}
+
+static void kprobe_create(const char *event, const char *addr,
+			  const char *fmt)
+{
+	__kprobe_create(KPROBE, event, addr, fmt);
+}
+
+static void kretprobe_create(const char *event, const char *addr,
+			     const char *fmt)
+{
+	__kprobe_create(KRETPROBE, event, addr, fmt);
+}
+
+int main (int argc, char **argv, char **env)
+{
+	struct tracefs_instance *instance;
+	struct tep_handle *tep;
+	const char *sysnames[] = { mykprobe, NULL };
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
+	tracefs_kprobe_clear_probe(mykprobe, NULL, true);
+
+	kprobe_create("open", "do_sys_openat2",
+		      "file=+0($arg2):ustring flags=+0($arg3):x64 mode=+8($arg3):x64\n");
+
+	kretprobe_create("openret", "do_sys_openat2", "ret=%ax");
+
+	tep = tracefs_local_events_system(NULL, sysnames);
+	if (!tep) {
+		perror("reading events");
+		exit(-1);
+	}
+	open_event = tep_find_event_by_name(tep, mykprobe, "open");
+	file_field = tep_find_field(open_event, "file");
+
+	openret_event = tep_find_event_by_name(tep, mykprobe, "openret");
+	ret_field = tep_find_field(openret_event, "ret");
+
+	tracefs_event_enable(instance, mykprobe, NULL);
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
+	tracefs_kprobe_clear_probe(mykprobe, NULL, true);
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
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
+*sameeruddin shaik* <sameeruddin.shaik8@gmail.com>
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
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.30.2

