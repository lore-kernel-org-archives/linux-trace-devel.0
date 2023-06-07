Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE73C77B7A
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jun 2023 01:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbjFGBRH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 21:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbjFGBRF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 21:17:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF99172D
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Jun 2023 18:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A9916300E
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jun 2023 01:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D23CC433D2;
        Wed,  7 Jun 2023 01:17:00 +0000 (UTC)
Date:   Tue, 6 Jun 2023 21:16:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     keiichiw@google.com, takayas@google.com, uekawa@google.com
Subject: [PATCH v2] trace-cmd attach: Add new command "attach"
Message-ID: <20230606211658.580d3063@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

\From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a new trace-cmd command called "attach". This will attach a trace.dat
file created on a guest to a trace.dat file created on the host at the
same time. In some cases, trace-cmd agent isn't possible. This gives the
ability to do a trace on the guest with trace-cmd record, and on the host
as well, and then combine the two such that the guest events are
interleaved properly within the host events.

There's some requirements for the traces. The host side needs to enable
kvm_exit/entry events as well as to use the tsc2nsec clock. The guest
needs to use the x86-tsc clock.

As can be seen by the above requirements, this currently works only for
x86, but when other architectures have raw clocks that can do the same,
then they will be supported.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
Changes since v1: https://lore.kernel.org/linux-trace-devel/20230606200016.2b605d59@gandalf.local.home

  - Fixed a few memory leaks
  - Removed some debug printf()s
  - Fixed the cmp operation to use the correct pointers

 .../trace-cmd/trace-cmd-attach.1.txt          | 124 +++++
 Documentation/trace-cmd/trace-cmd.1.txt       |   5 +-
 tracecmd/Makefile                             |   1 +
 tracecmd/include/trace-local.h                |   4 +
 tracecmd/trace-attach.c                       | 500 ++++++++++++++++++
 tracecmd/trace-cmd.c                          |  22 +
 tracecmd/trace-usage.c                        |   9 +
 7 files changed, 664 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/trace-cmd/trace-cmd-attach.1.txt
 create mode 100644 tracecmd/trace-attach.c

diff --git a/Documentation/trace-cmd/trace-cmd-attach.1.txt b/Documentation/trace-cmd/trace-cmd-attach.1.txt
new file mode 100644
index 000000000000..1edef4a16f34
--- /dev/null
+++ b/Documentation/trace-cmd/trace-cmd-attach.1.txt
@@ -0,0 +1,124 @@
+TRACE-CMD-ATTACH(1)
+===================
+
+NAME
+----
+trace-cmd-attach - attach a guest trace.dat file to a host trace.dat file
+
+SYNOPSIS
+--------
+*trace-cmd attach* ['OPTIONS'] host-trace-file guest-trace-file guest-pid [guest-pid ...]
+
+DESCRIPTION
+-----------
+The trace-cmd(1) attach is used to take a trace.dat file created on a guest and
+attach it to a trace.dat file that was created on the host. In most cases,
+trace-cmd-agent(1) can be used to automate this, but if for some reason, the
+agent isn't appropriate, it may be required to start trace-cmd recording on
+the guest with trace-cmd-record(1). If the host recording is activated at the
+same time, one can use trace-cmd attach(1) to connect the guest and host files
+as if they were created by the trace-cmd agent.
+
+*host-trace-file*::
+    The trace.dat file created by the host. Must have kvm_exit and kvm_entry
+    events, and use the "tsc2nsec" clock.
+
+*guest-trace-file*::
+    The trace.dat file created by the guest. Must use the "x86-tsc" clock.
+    For now, this is only supported on x86, it may support other achitectures
+    later.
+
+*guest-pid*::
+    The process ID of the host thread that represents the guests threads.
+    Each process ID that represents all of the guest vCPUs should be listed.
+    Note, you can add more than just the threads that represent the guest
+    vCPUs, as the tool will search the *host-trace-file* for kvm_exit and
+    kvm_entry events to match these PIDs with the vCPUs that they represent.
+
+OPTIONS
+-------
+*-c* 'cpus'::
+    Specify a the number of CPUS the guest has.
+
+*-s* 'timeshift'::
+    A comma separated list of the format _offset_,_scale_,_frac_,_timestamp_
+    These values map to what are given in /sys/kernel/kvm/<pid>/vcpu/*
+
+    *offset*: Is the offset of the guest. "tsc-offest" in the directory. Note
+              that the value listed here is the negative of what is listed in
+              the directory.
+
+    *scale*:  The scaling factor. "tsc-scaling-ratio"
+
+    *frac*:   The fraction bits. "tsc-scaling-ratio-frac-bits"
+
+    *timestamp*: The timestamp to start using the above. In some cases, the
+              values may change over time. By adding a timestamp, it will
+              take effect after the timestamp has been hit. Normally
+              this would be zero.
+
+   Currently, only one timeshift is given per CPU. One *-s* option should be
+   given for each CPU. If there are less options than CPUs, then the last option
+   given will be used for the rest of the CPUs. If only one option is given, then
+   the values for that option will be used for all CPUs.
+
+EXAMPLES
+--------
+
+Enable all events for tracing:
+
+[source,shell]
+----
+  $ # find the process for a given guest
+  $ ps aux |grep qemu
+ libvirt+   63170  5.6  1.6 13994848 4257540 ?    Sl   May02 2884:49 /usr/bin/qemu-system-x86_64...
+
+  $ # Use 63170 to find all the PIDs for the give guest
+  $ ls /proc/63170/task
+ 1541591  63170  63198  63209  63211  63213  63214  63215  63216  63217  63218  63219  63234
+
+  $ # Find the tsc offset
+  $ su
+  # cat /sys/kernel/debug/kvm/63170-15/vcpu0/tsc-offset
+ -27950965013436847
+
+  # trace-cmd record -C tsc2nesc -e kvm -e sched -e irq -e timer
+
+# on guest:
+
+  # trace-cmd record -C x86-tsc -e sched -e irq -e timer sleep 10
+
+# back on host, hit Ctrl^C to stop tracing after the guest is done
+
+  # # Make the trace.dat user owned by your user account.
+  # chown user.user trace.dat
+  # exit
+
+  $ scp root@guest:trace.dat trace-guest.dat
+
+  $ # now attach the two files (guest has 8 CPUs)
+  $ trace-cmd attach -c 8 -s 27950965013436847 trace.dat trace-guest.dat 1541591  63170  63198  63209  63211  63213  63214  63215  63216  63217  63218  63219  63234
+
+  $ trace-cmd report -i trace.dat -i trace-guest.dat
+  $ # now you should see the guest trace interleaved within the host trace.
+----
+
+
+SEE ALSO
+--------
+trace-cmd(1), trace-cmd-report(1), trace-cmd-start(1), trace-cmd-stop(1),
+trace-cmd-extract(1), trace-cmd-reset(1), trace-cmd-split(1),
+trace-cmd-list(1), trace-cmd-listen(1), trace-cmd-profile(1)
+
+AUTHOR
+------
+Written by Steven Rostedt (Google) <rostedt@goodmis.org>
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+COPYING
+-------
+Copyright \(C) 2010 Red Hat, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/trace-cmd/trace-cmd.1.txt b/Documentation/trace-cmd/trace-cmd.1.txt
index 7e161273a553..ab25cc403297 100644
--- a/Documentation/trace-cmd/trace-cmd.1.txt
+++ b/Documentation/trace-cmd/trace-cmd.1.txt
@@ -76,6 +76,8 @@ COMMANDS
 
   convert   - convert trace files
 
+  attach   - attach a host trace.dat file to a guest trace.dat file
+
   dump    - read out the meta data from a trace file
 
 OPTIONS
@@ -92,7 +94,8 @@ trace-cmd-record(1), trace-cmd-report(1), trace-cmd-hist(1), trace-cmd-start(1),
 trace-cmd-stop(1), trace-cmd-extract(1), trace-cmd-reset(1),
 trace-cmd-restore(1), trace-cmd-stack(1), trace-cmd-convert(1),
 trace-cmd-split(1), trace-cmd-list(1), trace-cmd-listen(1),
-trace-cmd.dat(5), trace-cmd-check-events(1) trace-cmd-stat(1)
+trace-cmd.dat(5), trace-cmd-check-events(1), trace-cmd-stat(1),
+trace-cmd-attach(1)
 
 AUTHOR
 ------
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 66387526bc4b..eb9d2f62428d 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -37,6 +37,7 @@ TRACE_CMD_OBJS += trace-dump.o
 TRACE_CMD_OBJS += trace-clear.o
 TRACE_CMD_OBJS += trace-vm.o
 TRACE_CMD_OBJS += trace-convert.o
+TRACE_CMD_OBJS += trace-attach.o
 TRACE_CMD_OBJS += trace-agent.o
 TRACE_CMD_OBJS += trace-tsync.o
 TRACE_CMD_OBJS += trace-setup-guest.o
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index ae208fb6b593..8f18f6d5865c 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -118,6 +118,8 @@ void trace_usage(int argc, char **argv);
 
 void trace_dump(int argc, char **argv);
 
+void trace_attach(int argc, char **argv);
+
 void trace_convert(int argc, char **argv);
 
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
@@ -363,6 +365,8 @@ struct tracecmd_time_sync *
 trace_tsync_as_guest(int fd, const char *tsync_proto, const char *clock,
 	       unsigned int remote_id, unsigned int local_id);
 
+char *strparse(char *str, char delim, char **save);
+
 /* moved from trace-cmd.h */
 void tracecmd_remove_instances(void);
 int tracecmd_add_event(const char *event_str, int stack);
diff --git a/tracecmd/trace-attach.c b/tracecmd/trace-attach.c
new file mode 100644
index 000000000000..c20c75310f77
--- /dev/null
+++ b/tracecmd/trace-attach.c
@@ -0,0 +1,500 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
+ *
+ */
+#include <stdlib.h>
+#include <ctype.h>
+#include <getopt.h>
+#include <errno.h>
+
+#include "tracefs.h"
+#include "trace-local.h"
+
+struct timeshift_sample {
+	struct timeshift_sample *next;
+	long long		offset;
+	long long		scaling;
+	long long		timestamp;
+	long long		fract;
+};
+
+struct vcpu_pid {
+	struct vcpu_pid		*next;
+	int			pid;
+	int			cpu;
+};
+
+static unsigned int num_cpus;
+
+static void *vcpu_pids;
+
+static struct timeshift_sample *tshifts;
+static struct timeshift_sample **tshifts_next = &tshifts;
+
+static u64 set_value(const char *str, const char *type, u64 def)
+{
+	if (str && str[0] != '\0' && str[0] != '-' && !isdigit(str[0]))
+		die("Bad %s value", type);
+
+	if (str && str[0])
+		return strtoull(str, NULL, 0);
+
+	return def;
+}
+
+static void add_timeshift(char *shift)
+{
+	struct timeshift_sample *tshift;
+	char *timestamp_str;
+	char *offset_str;
+	char *scale_str;
+	char *fract_str;
+	char *saveptr;
+	u64 timestamp;
+	u64 offset;
+	u64 scale;
+	u64 fract;
+
+	offset_str = strparse(shift, ',', &saveptr);
+	scale_str = strparse(NULL, ',', &saveptr);
+	fract_str = strparse(NULL, ',', &saveptr);
+	timestamp_str = strparse(NULL, ',', &saveptr);
+
+	if (!offset_str)
+		die("Bad timeshift argument");
+
+	offset = set_value(offset_str, "offset", 0);
+	scale = set_value(scale_str, "scaling", 1);
+	fract = set_value(fract_str, "fraction", 0);
+	timestamp = set_value(timestamp_str, "timestamp", 0);
+
+	tshift = calloc(1, sizeof(*tshift));
+	if (!tshift)
+		die("Could not allocate timeshift");
+
+	*tshifts_next = tshift;
+	tshifts_next = &tshift->next;
+
+	tshift->offset = offset;
+	tshift->scaling = scale;
+	tshift->fract = fract;
+	tshift->timestamp = timestamp;
+}
+
+static void free_timeshifts(void)
+{
+	struct timeshift_sample *tshift;
+
+	while (tshifts) {
+		tshift = tshifts;
+		tshifts = tshift->next;
+		free(tshift);
+	}
+}
+
+static void add_vcpu_pid(const char *pid)
+{
+	struct vcpu_pid *vpid;
+
+	vpid = calloc(1, sizeof(*vpid));
+	vpid->pid = atoi(pid);
+	vpid->cpu = -1;
+	vpid->next = vcpu_pids;
+	vcpu_pids = vpid;
+}
+
+static void free_vcpu_pids(void)
+{
+	struct vcpu_pid *vpid;
+
+	while (vcpu_pids) {
+		vpid = vcpu_pids;
+		vcpu_pids = vpid->next;
+		free(vpid);
+	}
+}
+
+static inline int test_vcpu_id(struct tep_format_field **vcpu_id_field,
+				struct tep_event *event, struct tep_record *record)
+{
+	unsigned long long val;
+	struct vcpu_pid *vpid;
+	bool done = true;
+	int pid;
+	int cnt = 0;
+
+	if (!*vcpu_id_field) {
+		*vcpu_id_field = tep_find_field(event, "vcpu_id");
+		 if (!*vcpu_id_field)
+			 die("Could not find vcpu_id field");
+	}
+
+	pid = tep_data_pid(event->tep, record);
+	for (vpid = vcpu_pids; vpid; vpid = vpid->next) {
+		if (vpid->cpu < 0) {
+			done = false;
+		} else {
+			cnt++;
+			continue;
+		}
+		if (vpid->pid == pid)
+			break;
+	}
+
+	if (done || (num_cpus && cnt == num_cpus))
+		return -1;
+
+	if (!vpid)
+		return 0;
+
+	if (tep_read_number_field(*vcpu_id_field, record->data, &val))
+		die("Could not read data vcpu_id field");
+
+	vpid->cpu = (int)val;
+
+	return 0;
+}
+
+static int entry_callback(struct tracecmd_input *handle, struct tep_event *event,
+			  struct tep_record *record, int cpu, void *data)
+{
+	static struct tep_format_field *vcpu_id_field;
+
+	return test_vcpu_id(&vcpu_id_field, event, record);
+}
+
+static int exit_callback(struct tracecmd_input *handle, struct tep_event *event,
+			  struct tep_record *record, int cpu, void *data)
+{
+	static struct tep_format_field *vcpu_id_field;
+
+	return test_vcpu_id(&vcpu_id_field, event, record);
+}
+
+static int cmp_vcpus(const void *A, const void *B)
+{
+	struct vcpu_pid * const *a = A;
+	struct vcpu_pid * const *b = B;
+
+	if ((*a)->cpu < (*b)->cpu)
+		return -1;
+
+	return (*a)->cpu > (*b)->cpu;
+}
+
+static void update_end(char **end, void *data, int size, const char *stop)
+{
+	char *str = *end;
+
+	if (str + size > stop)
+		die("Error in calculating buffer size");
+
+	memcpy(str, data, size);
+	*end = str + size;
+}
+
+static void add_guest_to_host(struct tracecmd_output *host_ohandle,
+			      struct tracecmd_input *guest_ihandle)
+{
+	unsigned long long guest_id;
+	struct vcpu_pid **vcpu_list;
+	struct vcpu_pid *vpid;
+	char *name = ""; /* TODO, add name for guest */
+	char *stop;
+	char *buf;
+	char *end;
+	int cpus = 0;
+	int cpu;
+	int size;
+
+	guest_id = tracecmd_get_traceid(guest_ihandle);
+
+	for (vpid = vcpu_pids; vpid ; vpid = vpid->next) {
+		if (vpid->cpu < 0)
+			continue;
+		cpus++;
+	}
+
+	vcpu_list = calloc(cpus, sizeof(*vcpu_list));
+	if (!vcpu_list)
+		die("Could not allocate vCPU list");
+
+	cpus = 0;
+	for (vpid = vcpu_pids; vpid ; vpid = vpid->next) {
+		if (vpid->cpu < 0)
+			continue;
+		vcpu_list[cpus++] = vpid;
+	}
+
+	qsort(vcpu_list, cpus, sizeof(*vcpu_list), cmp_vcpus);
+
+	size = strlen(name) + 1;
+	size += sizeof(int) + sizeof(long long);
+	size += cpus * (sizeof(int) * 2);
+	buf = calloc(1, size);
+	if (!buf)
+		die("Failed allocation");
+
+	end = buf;
+	stop = buf + size;
+
+	/* TODO match endianess of existing file */
+	update_end(&end, name, strlen(name) + 1, stop);
+	update_end(&end, &guest_id, sizeof(guest_id), stop);
+	update_end(&end, &cpus, sizeof(cpus), stop);
+
+	for (cpu = 0; cpu < cpus; cpu++) {
+		int vcpu = vcpu_list[cpu]->cpu;
+		int pid = vcpu_list[cpu]->pid;
+		update_end(&end, &cpu, sizeof(vcpu), stop);
+		update_end(&end, &pid, sizeof(pid), stop);
+	}
+
+	if (tracecmd_add_option(host_ohandle, TRACECMD_OPTION_GUEST, size, buf) == NULL)
+		die("Failed to add GUEST option to host");
+
+	free(vcpu_list);
+	free(buf);
+}
+
+static void add_timeshift_to_guest(struct tracecmd_output *guest_ohandle,
+				   struct tracecmd_input *host_ihandle)
+{
+	struct timeshift_sample *tshift = tshifts;
+	struct timeshift_sample *last_tshift = NULL;
+	unsigned long long host_id;
+	char *stop;
+	char *end;
+	char *buf;
+	int proto;
+	int size = 0;
+	int cpus;
+	int cpu;
+
+	host_id = tracecmd_get_traceid(host_ihandle);
+	cpus = num_cpus;
+	proto = 0; /* For now we just have zero */
+
+	/*
+	 * option size is:
+	 *   trace id:		8 bytes
+	 *   protocol flags:	4 bytes
+	 *   CPU count:		4 bytes
+	 *
+	 * For each CPU:
+	 *   sample cnt:	4 bytes
+	 *   list of times:	8 bytes * sample cnt
+	 *   list of offsets:	8 bytes * sample cnt
+	 *   list of scaling:	8 bytes * sample cnt
+	 *
+	 * For each CPU:
+	 *    list of fract:	8 bytes * CPU count
+	 */
+	size = 8 + 4 + 4;
+
+	/* Include fraction bits here */
+	size += 8 * cpus;
+
+	/* We only have one sample per CPU (for now) */
+	size += (4 + 8 * 3) * cpus;
+
+	buf = calloc(1, size);
+	if (!buf)
+		die("Failed to allocate timeshift buffer");
+
+	end = buf;
+	stop = buf + size;
+	update_end(&end, &host_id, sizeof(host_id), stop);
+	update_end(&end, &proto, sizeof(proto), stop);
+	update_end(&end, &cpus, sizeof(cpus), stop);
+
+	for (cpu = 0; cpu < cpus; cpu++) {
+		struct timeshift_sample *tsample = tshift;
+		unsigned long long sample;
+		int cnt = 1;
+
+		if (!tsample)
+			tsample = last_tshift;
+
+		if (!tsample)
+			die("No samples given");
+
+		last_tshift = tsample;
+
+		update_end(&end, &cnt, sizeof(cnt), stop);
+		sample = tsample->timestamp;
+		update_end(&end, &sample, sizeof(sample), stop);
+
+		sample = tsample->offset;
+		update_end(&end, &sample, sizeof(sample), stop);
+
+		sample = tsample->scaling;
+		update_end(&end, &sample, sizeof(sample), stop);
+	}
+
+	tshift = tshifts;
+	last_tshift = NULL;
+
+	for (cpu = 0; cpu < cpus; cpu++) {
+		struct timeshift_sample *tsample = tshift;
+		unsigned long long sample;
+
+		if (!tsample)
+			tsample = last_tshift;
+		last_tshift = tsample;
+
+		sample = tsample->fract;
+
+		update_end(&end, &sample, sizeof(sample), stop);
+	}
+
+	if (tracecmd_add_option(guest_ohandle, TRACECMD_OPTION_TIME_SHIFT, size, buf) == NULL)
+		die("Failed to add TIME SHIFT option");
+
+	free(buf);
+}
+
+static void add_tsc2nsec_to_guest(struct tracecmd_output *guest_ohandle,
+				  struct tracecmd_input *host_ihandle)
+{
+	unsigned long long offset;
+	int mult;
+	int shift;
+	int ret;
+	char buf[sizeof(int) * 2 + sizeof(long long)];
+	char *stop;
+	char *end;
+	int size = sizeof(buf);
+
+	ret = tracecmd_get_tsc2nsec(host_ihandle, &mult, &shift, &offset);
+	if (ret < 0)
+		die("Host does not have tsc2nsec info");
+
+	end = buf;
+	stop = buf + size;
+	update_end(&end, &mult, sizeof(mult), stop);
+	update_end(&end, &shift, sizeof(shift), stop);
+	update_end(&end, &offset, sizeof(offset), stop);
+
+	if (tracecmd_add_option(guest_ohandle, TRACECMD_OPTION_TSC2NSEC, size, buf) == NULL)
+		die("Failed to add TSC2NSEC option");
+
+}
+
+static void map_cpus(struct tracecmd_input *handle)
+{
+	int entry_ret;
+	int exit_ret;
+
+	entry_ret = tracecmd_follow_event(handle, "kvm", "kvm_entry", entry_callback, NULL);
+	exit_ret = tracecmd_follow_event(handle, "kvm", "kvm_exit", exit_callback, NULL);
+
+	if (entry_ret < 0 && exit_ret < 0)
+		die("Host needs kvm_exit or kvm_entry events to attach");
+
+	tracecmd_iterate_events(handle, NULL, 0, NULL, NULL);
+}
+
+void trace_attach(int argc, char **argv)
+{
+	struct tracecmd_input *guest_ihandle;
+	struct tracecmd_input *host_ihandle;
+	struct tracecmd_output *guest_ohandle;
+	struct tracecmd_output *host_ohandle;
+	unsigned long long guest_id;
+	char *guest_file;
+	char *host_file;
+	int ret;
+	int fd;
+
+	for (;;) {
+		int c;
+
+		c = getopt(argc-1, argv+1, "c:s:h");
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case 'h':
+			usage(argv);
+			break;
+		case 's':
+			add_timeshift(optarg);
+			break;
+		case 'c':
+			num_cpus = atoi(optarg);
+			break;
+		default:
+			usage(argv);
+		}
+	}
+
+	/* Account for "attach" */
+	optind++;
+
+	if ((argc - optind) < 3)
+		usage(argv);
+
+	host_file = argv[optind++];
+	guest_file = argv[optind++];
+
+	for (; optind < argc; optind++)
+		add_vcpu_pid(argv[optind]);
+
+
+	host_ihandle = tracecmd_open(host_file,TRACECMD_FL_LOAD_NO_PLUGINS );
+	guest_ihandle = tracecmd_open(guest_file,TRACECMD_FL_LOAD_NO_PLUGINS );
+
+	if (!host_ihandle)
+		die("Could not read %s\n", host_file);
+
+	if (!guest_ihandle)
+		die("Could not read %s\n", guest_file);
+
+	guest_id = tracecmd_get_traceid(guest_ihandle);
+	if (!guest_id)
+		die("Guest data file does not contain traceid");
+
+	map_cpus(host_ihandle);
+
+	ret = tracecmd_get_guest_cpumap(host_ihandle, guest_id,
+					NULL, NULL, NULL);
+	if (ret == 0) {
+		printf("Guest is already mapped in host (id=0x%llx) .. skipping ...\n",
+		       guest_id);
+	} else {
+
+		fd = open(host_file, O_RDWR);
+		if (fd < 0)
+			die("Could not write %s", host_file);
+
+		host_ohandle = tracecmd_get_output_handle_fd(fd);
+		if (!host_ohandle)
+			die("Error setting up %s for write", host_file);
+
+		add_guest_to_host(host_ohandle, guest_ihandle);
+		tracecmd_output_close(host_ohandle);
+	}
+
+	fd = open(guest_file, O_RDWR);
+	if (fd < 0)
+		die("Could not write %s", guest_file);
+
+	guest_ohandle = tracecmd_get_output_handle_fd(fd);
+	if (!guest_ohandle)
+		die("Error setting up %s for write", guest_file);
+
+	add_timeshift_to_guest(guest_ohandle, host_ihandle);
+	add_tsc2nsec_to_guest(guest_ohandle, host_ihandle);
+
+	tracecmd_output_close(guest_ohandle);
+
+	tracecmd_close(guest_ihandle);
+	tracecmd_close(host_ihandle);
+
+	free_timeshifts();
+	free_vcpu_pids();
+
+	return;
+}
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 9646921ca268..df0b626f9b34 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -50,6 +50,27 @@ void *malloc_or_die(unsigned int size)
 	return data;
 }
 
+/* Same as strtok_r(), but allows empty tokens */
+char *strparse(char *str, char delim, char **save)
+{
+	char *next;
+
+	if (!str) {
+		str = *save;
+		if ((*save)[0] == '\0')
+			return NULL;
+	}
+
+	next = strchr(str, delim);
+	if (next) {
+		*next = '\0';
+		*save = next + 1;
+	} else {
+		*save = str + strlen(str);
+	}
+	return str;
+}
+
 void tracecmd_debug(const char *fmt, ...)
 {
 	va_list ap;
@@ -156,6 +177,7 @@ struct command commands[] = {
 	{"list", trace_list},
 	{"help", trace_usage},
 	{"dump", trace_dump},
+	{"attach", trace_attach},
 	{"convert", trace_convert},
 	{"-h", trace_usage},
 };
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 4fbbc545a5ef..ecb7cad1cf85 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -429,6 +429,15 @@ static struct usage_help usage_help[] = {
 		"          -h, --help show usage information\n"
 		"          --verbose 'level' Set the desired log level\n"
 	},
+	{
+		"attach",
+		"Attach a host and guest trace.dat file",
+		" %s attach [options] host_file guest_file vcpu_pid,...\n"
+		"          -s  offset,scale,fraction[,timestamp] conversion to sync guest timestamp\n"
+		"          host_file The trace.dat file from the host\n"
+		"          guest_file The trace.dat file from the guest\n"
+		"          vcpu_pid list of process ids from the host that represent the vCPUs of the guest\n"
+	},
 	{
 		"convert",
 		"convert trace file to different version",
-- 
2.39.2

