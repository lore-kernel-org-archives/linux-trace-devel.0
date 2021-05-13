Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2767AC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 20:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA07D6143F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 May 2021 20:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbhEMUoc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 May 2021 16:44:32 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:52827 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231431AbhEMUoc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 May 2021 16:44:32 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 13 May 2021 13:43:16 -0700
Received: from vypre.com (unknown [10.21.244.58])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 30EDB20464;
        Thu, 13 May 2021 13:43:19 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 1/2] trace-cmd: Find PID of host-guest task from tracing vsock connection
Date:   Thu, 13 May 2021 16:43:14 -0400
Message-ID: <20210513204315.1206204-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210513204315.1206204-1-rostedt@goodmis.org>
References: <20210513204315.1206204-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When a CID is specified on the command line to connect to an agent running
in a KVM guest, in order to use the KVM information for the guest clock,
the main PID of that guest needs to be found.

The problem is that there's no interface that maps CIDs to tasks on the
host. Currently, the code has a hack to search all tasks, looking for
"qemu" tasks and then parsing its command line to see if it can find the
CID that it used. This is not robust and does not work for non qemu guests
running in a KVM environment.

Instead, trace the flow of "wake ups" from the trace-cmd task to a task
that does a "kvm_exit" when connecting to the given CID.

That is, when a connect() call is done on the give CID, tracing the
following flow:

 trace-cmd wakes up "vhost-<pid>"
 vhost-<pid> wakes up "CPUX/KVM"
 CPUX/KVM calls "kvm_exit"

Looking at only wake up events that happen outside of interrupt context
(interrupt wake ups can be for other tasks), finding the task that does
the "kvm_exit" is the task that is running a guest vCPU.

The CPUX/KVM is the task that runs the vCPU of the guest, but we still
need the task group leader of this task to find the task that KVM has
for timestamp offsets and multipliers. To do that, look at the proc
file system for the PID of the CPUX/KVM and read its status file.
This holds "Tgid:    <pid>" where "<pid>" is the PID of the task that

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
Changes since v2:
  - rewrote the change log.
  - Used some of the new APIs of libtracefs 1.2

 tracecmd/trace-vm.c | 227 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 226 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index c0333b67..163536ca 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -9,6 +9,7 @@
 #include <sys/types.h>
 #include <dirent.h>
 #include <limits.h>
+#include <unistd.h>
 
 #include "trace-local.h"
 #include "trace-msg.h"
@@ -87,6 +88,227 @@ static struct trace_guest *add_guest(unsigned int cid, const char *name)
 	return &guests[guests_len - 1];
 }
 
+static struct tracefs_instance *start_trace_connect(void)
+{
+	struct tracefs_instance *open_instance;
+
+	open_instance = tracefs_instance_create("vsock_find_pid");
+	if (!open_instance)
+		return NULL;
+
+	tracefs_event_enable(open_instance, "sched", "sched_waking");
+	tracefs_event_enable(open_instance, "kvm", "kvm_exit");
+	tracefs_trace_on(open_instance);
+	return open_instance;
+}
+
+struct pids {
+	struct pids		*next;
+	int			pid;
+};
+
+struct trace_fields {
+	struct tep_event		*sched_waking;
+	struct tep_event		*kvm_exit;
+	struct tep_format_field		*common_pid;
+	struct tep_format_field		*sched_next;
+	struct pids			*pids;
+	int				found_pid;
+};
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
+static void add_pid(struct pids **pids, int pid)
+{
+	struct pids *new_pid;
+
+	new_pid = malloc(sizeof(*new_pid));
+	if (!new_pid)
+		return;
+
+	new_pid->pid = pid;
+	new_pid->next = *pids;
+	*pids = new_pid;
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
+static int callback(struct tep_event *event, struct tep_record *record, int cpu,
+		    void *data)
+{
+	struct trace_fields *fields = data;
+	struct tep_handle *tep = event->tep;
+	unsigned long long val;
+	int flags;
+	int type;
+	int pid;
+	int ret;
+
+	ret = tep_read_number_field(fields->common_pid, record->data, &val);
+	if (ret < 0)
+		return 0;
+
+	flags = tep_data_flags(tep, record);
+
+	/* Ignore events in interrupts */
+	if (flags & (TRACE_FLAG_HARDIRQ | TRACE_FLAG_SOFTIRQ))
+		return 0;
+
+	/*
+	 * First make sure that this event comes from a PID from
+	 * this task (or a task woken by this task)
+	 */
+	pid = val;
+	if (!match_pid(fields->pids, pid))
+		return 0;
+
+	type = tep_data_type(tep, record);
+
+	/*
+	 * If this event is a kvm_exit, we have our PID
+	 * and we can stop processing.
+	 */
+	if (type == fields->kvm_exit->id) {
+		fields->found_pid = pid;
+		return -1;
+	}
+
+	if (type != fields->sched_waking->id)
+		return 0;
+
+	ret = tep_read_number_field(fields->sched_next, record->data, &val);
+	if (ret < 0)
+		return 0;
+
+	/* This is a task woken by our task or a chain of wake ups */
+	add_pid(&fields->pids, (int)val);
+	return 0;
+}
+
+static int find_tgid(int pid)
+{
+	FILE *fp;
+	char *path;
+	char *buf = NULL;
+	char *save;
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
+	fclose(fp);
+
+	return tgid;
+}
+
+static int stop_trace_connect(struct tracefs_instance *open_instance)
+{
+	const char *systems[] = { "kvm", "sched", NULL};
+	struct tep_handle *tep;
+	struct trace_fields trace_fields;
+	int tgid = -1;
+
+	if (!open_instance)
+		return -1;
+
+	/* The connection is finished, stop tracing, we have what we want */
+	tracefs_trace_off(open_instance);
+	tracefs_event_disable(open_instance, NULL, NULL);
+
+	tep = tracefs_local_events_system(NULL, systems);
+
+	trace_fields.sched_waking = tep_find_event_by_name(tep, "sched", "sched_waking");
+	if (!trace_fields.sched_waking)
+		goto out;
+	trace_fields.kvm_exit = tep_find_event_by_name(tep, "kvm", "kvm_exit");
+	if (!trace_fields.kvm_exit)
+		goto out;
+	trace_fields.common_pid = tep_find_common_field(trace_fields.sched_waking,
+							"common_pid");
+	if (!trace_fields.common_pid)
+		goto out;
+	trace_fields.sched_next = tep_find_any_field(trace_fields.sched_waking,
+							"pid");
+	if (!trace_fields.sched_next)
+		goto out;
+
+	trace_fields.found_pid = -1;
+	trace_fields.pids = NULL;
+	add_pid(&trace_fields.pids, getpid());
+	tracefs_iterate_raw_events(tep, open_instance, NULL, 0, callback, &trace_fields);
+	free_pids(trace_fields.pids);
+ out:
+	tracefs_instance_destroy(open_instance);
+	tracefs_instance_free(open_instance);
+
+	if (trace_fields.found_pid > 0)
+		tgid = find_tgid(trace_fields.found_pid);
+
+	return tgid;
+}
+
+/*
+ * In order to find the guest that is associated to the given cid,
+ * trace the sched_waking and kvm_exit events, connect to the cid
+ * (doesn't matter what port, use -1 to not connect to anything)
+ * and find what task gets woken up from this code and calls kvm_exit,
+ * then that is the task that is running the guest.
+ * Then look at the /proc/<guest-pid>/status file to find the task group
+ * id (Tgid), and this is the PID of the task running all the threads.
+ */
+static void find_pid_by_cid(struct trace_guest *guest)
+{
+	struct tracefs_instance *instance;
+	int fd;
+
+	instance = start_trace_connect();
+	fd = trace_open_vsock(guest->cid, -1);
+	guest->pid = stop_trace_connect(instance);
+	/* Just in case! */
+	if (fd >= 0)
+		close(fd);
+}
+
 struct trace_guest *trace_get_guest(unsigned int cid, const char *name)
 {
 	struct trace_guest *guest = NULL;
@@ -99,8 +321,11 @@ struct trace_guest *trace_get_guest(unsigned int cid, const char *name)
 
 	if (cid > 0) {
 		guest = get_guest_by_cid(cid);
-		if (!guest && name)
+		if (!guest && name) {
 			guest = add_guest(cid, name);
+			if (guest)
+				find_pid_by_cid(guest);
+		}
 	}
 	return guest;
 }
-- 
2.29.2

