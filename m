Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF95DC7EE24
	for <linux-trace-devel@archiver.kernel.org>; Sat,  3 Jun 2023 20:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjFCUTQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 3 Jun 2023 16:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjFCUTQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 3 Jun 2023 16:19:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D49F123
        for <linux-trace-devel@vger.kernel.org>; Sat,  3 Jun 2023 13:19:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB09161517
        for <linux-trace-devel@vger.kernel.org>; Sat,  3 Jun 2023 20:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0D9C433D2;
        Sat,  3 Jun 2023 20:19:12 +0000 (UTC)
Date:   Sat, 3 Jun 2023 16:19:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     keiichiw@google.com, takayas@google.com, uekawa@google.com
Subject: [PATCH] libtracefs: Add tracefs_find_cid_pid() API
Message-ID: <20230603161909.411c60f2@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tracefs_find_cid_pid() to make it easier to find the process ID of
the main thread on the host that represents a guest. This can be used to
find the directory of /sys/kernel/debug/kvm/<PID>/ that holds
information of the given guest.

The above function will create an instance to work in. If that is
undesired and control of what tracing instance should be used,
then use tracefs_instance_find_cid_pid() to specify the instance to do
the work in.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-guest.txt | 123 +++++++++++++
 Makefile                           |   7 +
 include/tracefs.h                  |   4 +
 samples/Makefile                   |   1 +
 src/Makefile                       |   3 +
 src/tracefs-vsock.c                | 274 +++++++++++++++++++++++++++++
 6 files changed, 412 insertions(+)
 create mode 100644 Documentation/libtracefs-guest.txt
 create mode 100644 src/tracefs-vsock.c

diff --git a/Documentation/libtracefs-guest.txt b/Documentation/libtracefs-guest.txt
new file mode 100644
index 0000000..1c527b0
--- /dev/null
+++ b/Documentation/libtracefs-guest.txt
@@ -0,0 +1,123 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_find_cid_pid, tracefs_instance_find_cid_pid -
+helper functions to handle tracing guests
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+char pass:[*]*tracefs_find_cid_pid*(int _cid_);
+char pass:[*]*tracefs_instance_find_cid_pid*(struct tracefs_instance pass:[*]_instance_, int _cid_);
+--
+
+DESCRIPTION
+-----------
+The *tracefs_find_cid_pid*() will use tracing to follow the wakeups of connecting to
+the given _cid_ in order to find the pid of the guest thread that belongs to the vsocket cid.
+It will then read the proc file system to find the thread leader, and it will return
+the pid of the thread leader.
+
+The *tracefs_instance_find_cid_pid*() is the same as *tracefs_find_cid_pid*() but defines
+the instance to use to perform the tracing in. If NULL it will use the top level
+buffer to perform the tracing.
+
+RETURN VALUE
+------------
+Both *tracefs_find_cid_pid*() and *tracefs_instance_find_cid_pid*() will return the
+pid of the guest main thread that belongs to the _cid_, or -1 on error (or not found).
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <unistd.h>
+#include <tracefs.h>
+
+#define MAX_CID		256
+
+static void find_cid(struct tracefs_instance *instance, int cid)
+{
+	int pid;
+
+	pid = tracefs_instance_find_cid_pid(instance, cid);
+	if (pid >= 0)
+		printf("%d\t%d\n", cid, pid);
+}
+
+static int find_cids(void)
+{
+	struct tracefs_instance *instance;
+	char *name;
+	int cid;
+	int ret;
+
+	ret = asprintf(&name, "vsock_find-%d\n", getpid());
+	if (ret < 0)
+		return ret;
+
+	instance = tracefs_instance_create(name);
+	free(name);
+	if (!instance)
+		return -1;
+
+	for (cid = 0; cid < MAX_CID; cid++)
+		find_cid(instance, cid);
+
+	tracefs_event_disable(instance, NULL, NULL);
+	tracefs_instance_destroy(instance);
+	tracefs_instance_free(instance);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	find_cids();
+	exit(0);
+}
+--
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
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
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
diff --git a/Makefile b/Makefile
index 61ed976..1e5fe77 100644
--- a/Makefile
+++ b/Makefile
@@ -73,12 +73,19 @@ else
  endif
 endif
 
+ifndef NO_VSOCK
+VSOCK_DEFINED := $(shell if (echo "$(pound)include <linux/vm_sockets.h>" | $(CC) -E - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+else
+VSOCK_DEFINED := 0
+endif
+
 etcdir ?= /etc
 etcdir_SQ = '$(subst ','\'',$(etcdir))'
 
 export man_dir man_dir_SQ html_install html_install_SQ INSTALL
 export img_install img_install_SQ
 export DESTDIR DESTDIR_SQ
+export VSOCK_DEFINED
 
 pound := \#
 
diff --git a/include/tracefs.h b/include/tracefs.h
index a8e30a5..782dae2 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -640,4 +640,8 @@ int tracefs_cpu_flush(struct tracefs_cpu *tcpu, void *buffer);
 int tracefs_cpu_flush_write(struct tracefs_cpu *tcpu, int wfd);
 int tracefs_cpu_pipe(struct tracefs_cpu *tcpu, int wfd, bool nonblock);
 
+/* Mapping vsocket cids to pids using tracing */
+int tracefs_instance_find_cid_pid(struct tracefs_instance *instance, int cid);
+int tracefs_find_cid_pid(int cid);
+
 #endif /* _TRACE_FS_H */
diff --git a/samples/Makefile b/samples/Makefile
index 743bddb..fa88ffc 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -22,6 +22,7 @@ EXAMPLES += tracer
 EXAMPLES += stream
 EXAMPLES += instances-affinity
 EXAMPLES += cpu
+EXAMPLES += guest
 
 TARGETS :=
 TARGETS += sqlhist
diff --git a/src/Makefile b/src/Makefile
index e2965bc..90be7bc 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -15,6 +15,9 @@ OBJS += tracefs-dynevents.o
 OBJS += tracefs-eprobes.o
 OBJS += tracefs-uprobes.o
 OBJS += tracefs-record.o
+ifeq ($(VSOCK_DEFINED), 1)
+OBJS += tracefs-vsock.o
+endif
 
 # Order matters for the the three below
 OBJS += sqlhist-lex.o
diff --git a/src/tracefs-vsock.c b/src/tracefs-vsock.c
new file mode 100644
index 0000000..e171382
--- /dev/null
+++ b/src/tracefs-vsock.c
@@ -0,0 +1,274 @@
+#include <stdlib.h>
+#include <unistd.h>
+#include <ctype.h>
+#include <sys/socket.h>
+#include <linux/vm_sockets.h>
+
+#include <tracefs.h>
+
+static int open_vsock(unsigned int cid, unsigned int port)
+{
+	struct sockaddr_vm addr = {
+		.svm_family = AF_VSOCK,
+		.svm_cid = cid,
+		.svm_port = port,
+	};
+	int sd;
+
+	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	if (sd < 0)
+		return -1;
+
+	if (connect(sd, (struct sockaddr *)&addr, sizeof(addr)))
+		return -1;
+
+	return sd;
+}
+
+struct pids {
+	struct pids		*next;
+	int			pid;
+};
+
+struct trace_info {
+	struct tracefs_instance		*instance;
+	struct tep_handle		*tep;
+	struct tep_event		*wake_up;
+	struct tep_event		*kvm_exit;
+	struct tep_format_field		*wake_pid;
+	struct pids			*pids;
+	int				pid;
+};
+
+static void tear_down_trace(struct trace_info *info)
+{
+	tracefs_event_disable(info->instance, NULL, NULL);
+	tep_free(info->tep);
+	info->tep = NULL;
+}
+
+static int add_pid(struct pids **pids, int pid)
+{
+	struct pids *new_pid;
+
+	new_pid = malloc(sizeof(*new_pid));
+	if (!new_pid)
+		return -1;
+
+	new_pid->pid = pid;
+	new_pid->next = *pids;
+	*pids = new_pid;
+	return 0;
+}
+
+static bool match_pid(struct pids *pids, int pid)
+{
+	while (pids) {
+		if (pids->pid == pid)
+			return true;
+		pids = pids->next;
+	}
+	return false;
+}
+
+static int waking_callback(struct tep_event *event, struct tep_record *record,
+			   int cpu, void *data)
+{
+	struct trace_info *info = data;
+	unsigned long long val;
+	int flags;
+	int pid;
+	int ret;
+
+	pid = tep_data_pid(event->tep, record);
+	if (!match_pid(info->pids, pid))
+		return 0;
+
+	/* Ignore wakeups in interrupts */
+	flags = tep_data_flags(event->tep, record);
+	if (flags & (TRACE_FLAG_HARDIRQ | TRACE_FLAG_SOFTIRQ))
+		return 0;
+
+	if (!info->wake_pid) {
+		info->wake_pid = tep_find_field(event, "pid");
+
+		if (!info->wake_pid)
+			return -1;
+	}
+
+	ret = tep_read_number_field(info->wake_pid, record->data, &val);
+	if (ret < 0)
+		return -1;
+
+	return add_pid(&info->pids, (int)val);
+}
+
+static int exit_callback(struct tep_event *event, struct tep_record *record,
+			 int cpu, void *data)
+{
+	struct trace_info *info = data;
+	int pid;
+
+	pid = tep_data_pid(event->tep, record);
+	if (!match_pid(info->pids, pid))
+		return 0;
+
+	info->pid = pid;
+
+	/* Found the pid we are looking for, stop the trace */
+	return -1;
+}
+
+static int setup_trace(struct trace_info *info)
+{
+	const char *systems[] = { "sched", "kvm", NULL};
+	int ret;
+
+	info->pids = NULL;
+
+	tracefs_trace_off(info->instance);
+	info->tep = tracefs_local_events_system(NULL, systems);
+	if (!info->tep)
+		return -1;
+
+	/*
+	 * Follow the wake ups, starting with this pid, to find
+	 * the one that exits to the guest. That will be the thread
+	 * of the vCPU of the guest.
+	 */
+	ret = tracefs_follow_event(info->tep, info->instance,
+				   "sched", "sched_waking",
+				   waking_callback, info);
+	if (ret < 0)
+		goto fail;
+
+	ret = tracefs_follow_event(info->tep, info->instance,
+				   "kvm", "kvm_exit",
+				   exit_callback, info);
+	if (ret < 0)
+		goto fail;
+
+	ret = tracefs_event_enable(info->instance, "sched", "sched_waking");
+	if (ret < 0)
+		goto fail;
+
+	ret = tracefs_event_enable(info->instance, "kvm", "kvm_exit");
+	if (ret < 0)
+		goto fail;
+
+	return 0;
+fail:
+	tear_down_trace(info);
+	return -1;
+}
+
+
+static void free_pids(struct pids *pids)
+{
+	struct pids *next;
+
+	while (pids) {
+		next = pids;
+		pids = pids->next;
+		free(next);
+	}
+}
+
+static int find_thread_leader(int pid)
+{
+	FILE *fp;
+	char *path;
+	char *save;
+	char *buf = NULL;
+	size_t l = 0;
+	int tgid = -1;
+
+	if (asprintf(&path, "/proc/%d/status", pid) < 0)
+		return -1;
+
+	fp = fopen(path, "r");
+	free(path);
+	if (!fp)
+		return -1;
+
+	while (getline(&buf, &l, fp) > 0) {
+		char *tok;
+
+		if (strncmp(buf, "Tgid:", 5) != 0)
+			continue;
+		tok = strtok_r(buf, ":", &save);
+		if (!tok)
+			continue;
+		tok = strtok_r(NULL, ":", &save);
+		if (!tok)
+			continue;
+		while (isspace(*tok))
+			tok++;
+		tgid = strtol(tok, NULL, 0);
+		break;
+	}
+	free(buf);
+
+	return tgid > 0 ? tgid : -1;
+}
+
+int tracefs_instance_find_cid_pid(struct tracefs_instance *instance, int cid)
+{
+	struct trace_info info = {};
+	int this_pid = getpid();
+	int ret;
+	int fd;
+
+	info.instance = instance;
+
+	if (setup_trace(&info) < 0)
+		return -1;
+
+	ret = add_pid(&info.pids, this_pid);
+	if (ret < 0)
+		goto out;
+
+	tracefs_instance_file_clear(info.instance, "trace");
+	tracefs_trace_on(info.instance);
+	fd = open_vsock(cid, -1);
+	tracefs_trace_off(info.instance);
+	if (fd >= 0)
+		close(fd);
+	info.pid = -1;
+	ret = tracefs_iterate_raw_events(info.tep, info.instance,
+					 NULL, 0, NULL, &info);
+	if (info.pid <= 0)
+		ret = -1;
+	if (ret == 0)
+		ret = find_thread_leader(info.pid);
+
+ out:
+	free_pids(info.pids);
+	info.pids = NULL;
+	tear_down_trace(&info);
+
+	return ret;
+}
+
+int tracefs_find_cid_pid(int cid)
+{
+	struct tracefs_instance *instance;
+	char *name;
+	int ret;
+
+	ret = asprintf(&name, "_tracefs_vsock_find-%d\n", getpid());
+	if (ret < 0)
+		return ret;
+
+	instance = tracefs_instance_create(name);
+	free(name);
+	if (!instance)
+		return -1;
+
+	ret = tracefs_instance_find_cid_pid(instance, cid);
+
+	tracefs_instance_destroy(instance);
+	tracefs_instance_free(instance);
+
+	return ret;
+}
-- 
2.39.2

