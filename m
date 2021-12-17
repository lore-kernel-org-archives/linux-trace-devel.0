Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C35C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 23:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhLQXEy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 18:04:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50594 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhLQXEy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 18:04:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A027B82967
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 23:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF1DC36AE2
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 23:04:51 +0000 (UTC)
Date:   Fri, 17 Dec 2021 18:04:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add tracefs_instance_set_affinity() APIs
Message-ID: <20211217180450.12d3524b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

Add the APIs:

  tracefs_instance_set_affinity()
  tracefs_instance_set_affinity_set()
  tracefs_instance_set_affinity_raw()

To easily set the CPU affinity that an instance will limit what CPUs it
will trace to. The first API uses the simple string method of:

 "1,4,6-8"

To denote CPUs 1,4,6,7,8

The _set() version uses CPU_SETS and the _raw() version just writes
directly into the tracing_cpumask file.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../libtracefs-instances-affinity.txt         | 169 +++++++++++++++
 include/tracefs.h                             |   6 +
 samples/Makefile                              |   1 +
 src/tracefs-instance.c                        | 203 ++++++++++++++++++
 4 files changed, 379 insertions(+)
 create mode 100644 Documentation/libtracefs-instances-affinity.txt

diff --git a/Documentation/libtracefs-instances-affinity.txt b/Documentation/libtracefs-instances-affinity.txt
new file mode 100644
index 000000000000..af04e798e478
--- /dev/null
+++ b/Documentation/libtracefs-instances-affinity.txt
@@ -0,0 +1,169 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_instance_set_affinity, tracefs_instance_set_affinity_set, tracefs_set_affinity_raw -
+Sets the affinity for an instance or top level for what CPUs enable tracing.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int tracefs_instance_set_affinity(struct tracefs_instace pass:[*]_instance_, const char pass:[*]_cpu_str_);
+int tracefs_instance_set_affinity_set(struct tracefs_instace pass:[*]_instance_, cpu_set_t pass:[*]_set_, size_t _set_size_);
+int tracefs_instance_set_affinity_raw(struct tracefs_instace pass:[*]_instance_, const char pass:[*]_mask_);
+
+--
+
+DESCRIPTION
+-----------
+These functions set the CPU affinity that limits what CPUs will have tracing enabled
+for a given instance defined by the _instance_ parameter. If _instance_ is NULL, then
+the top level instance is affected.
+
+The _tracefs_instance_set_affinity()_ function takes a string _cpu_str_ that is a
+list of CPUs to set the affinity for. If _cpu_str_ is NULL, then all the CPUs in
+the system will be set. The format of _cpu_str_ is a comma deliminated string of
+decimal numbers with no spaces. A range may be specified by a hyphen.
+
+For example: "1,4,6-8"
+
+The numbers do not need to be in order except for ranges, where the second number
+must be equal to or greater than the first.
+
+The _tracefs_instance_set_affinity_set()_ function takes a CPU set defined by
+*CPU_SET(3)*. The size of the set defined by _set_size_ is the size in bytes of
+_set_. If _set_ is NULL then all the CPUs on the system will be set, and _set_size_
+is ignored.
+
+The _tracefs_instance_set_affinity_raw()_ function takes a string that holds
+a hexidecimal bitmask, where each 32 bits is separated by a comma. For a
+machine with more that 32 CPUs, to set CPUS 1-10 and CPU 40:
+
+ "100,000007fe"
+
+Where the above is a hex representation of bits 1-10 and bit 40 being set.
+
+RETURN VALUE
+------------
+All of these functions return 0 on success and -1 on error.
+
+ERRORS
+------
+The following errors are for all the above calls:
+
+*EFBIG* if a CPU is set that is greater than what is in the system.
+
+*EINVAL* One of the parameters was invalid.
+
+The following errors are for *tracefs_instance_set_affinity*() and *tracefs_instance_set_affinity_set*():
+
+*ENOMEM* Memory allocation error.
+
+*ENODEV* dynamic events of requested type are not configured for the running kernel.
+
+The following errors are just for *tracefs_instance_set_affinity*()
+
+*EACCES* The _cpu_str_ was modified by another thread when processing it.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <tracefs.h>
+
+int main (int argc, char **argv)
+{
+	struct trace_seq seq;
+	cpu_set_t *set;
+	size_t set_size;
+	char *c;
+	int cpu1;
+	int cpu2;
+	int i;
+
+	if (argc < 2) {
+		tracefs_instance_set_affinity(NULL, NULL);
+		exit(0);
+	}
+	/* Show example using a set */
+	if (argc == 2 && !strchr(argv[1],',')) {
+		cpu1 = atoi(argv[1]);
+		c = strchr(argv[1], '-');
+		if (c++)
+			cpu2 = atoi(c);
+		else
+			cpu2 = cpu1;
+		if (cpu2 < cpu1) {
+			fprintf(stderr, "Invalid CPU range\n");
+			exit(-1);
+		}
+		set = CPU_ALLOC(cpu2 + 1);
+		set_size = CPU_ALLOC_SIZE(cpu2 + 1);
+		CPU_ZERO_S(set_size, set);
+		for ( ; cpu1 <= cpu2; cpu1++)
+			CPU_SET(cpu1, set);
+		tracefs_instance_set_affinity_set(NULL, set, set_size);
+		CPU_FREE(set);
+		exit(0);
+	}
+
+	trace_seq_init(&seq);
+	for (i = 0; i < argc; i++) {
+		if (i)
+			trace_seq_putc(&seq, ',');
+		trace_seq_puts(&seq, argv[i]);
+	}
+	trace_seq_terminate(&seq);
+	tracefs_instance_set_affinity(NULL, seq.buffer);
+	trace_seq_destroy(&seq);
+	exit(0);
+
+	return 0;
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
diff --git a/include/tracefs.h b/include/tracefs.h
index 310ba9e2f1f2..bd758dcaa8fe 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -43,6 +43,12 @@ int tracefs_instance_file_read_number(struct tracefs_instance *instance,
 int tracefs_instance_file_open(struct tracefs_instance *instance,
 			       const char *file, int mode);
 int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
+int tracefs_instance_set_affinity_set(struct tracefs_instance *instance,
+				  cpu_set_t *set, size_t set_size);
+int tracefs_instance_set_affinity_raw(struct tracefs_instance *instance,
+				      const char *mask);
+int tracefs_instance_set_affinity(struct tracefs_instance *instance,
+				  const char *cpu_str);
 char **tracefs_instances(const char *regex);
 
 bool tracefs_instance_exists(const char *name);
diff --git a/samples/Makefile b/samples/Makefile
index ace93448ff4e..f03aff6c9ba8 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -19,6 +19,7 @@ EXAMPLES += hist
 EXAMPLES += hist-cont
 EXAMPLES += tracer
 EXAMPLES += stream
+EXAMPLES += instances-affinity
 
 TARGETS :=
 TARGETS += sqlhist
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 16681c5807b7..fab615eb49ca 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -771,3 +771,206 @@ out:
 	free(all_clocks);
 	return ret;
 }
+
+/**
+ * tracefs_instance_set_affinity_raw - write a hex bitmask into the affinity
+ * @instance: The instance to set affinity to (NULL for top level)
+ * @mask: String containing the hex value to set the tracing affinity to.
+ *
+ * Sets the tracing affinity CPU mask for @instance. The @mask is the raw
+ * value that is used to write into the tracing system.
+ *
+ * Return 0 on success and -1 on error.
+ */
+int tracefs_instance_set_affinity_raw(struct tracefs_instance *instance,
+				      const char *mask)
+{
+	return tracefs_instance_file_write(instance, "tracing_cpumask", mask);
+}
+
+/**
+ * tracefs_instance_set_affinity_set - use a cpu_set to define tracing affinity
+ * @instance: The instance to set affinity to (NULL for top level)
+ * @set: A CPU set that describes the CPU affinity to set tracing to.
+ * @set_size: The size in bytes of @set (use CPU_ALLOC_SIZE() to get this value)
+ *
+ * Sets the tracing affinity CPU mask for @instance. The bits in @set will be
+ * used to set the CPUs to have tracing on.
+ *
+ * If @set is NULL, then all CPUs defined by sysconf(_SC_NPROCESSORS_CONF)
+ * will be set, and @set_size is ignored.
+ *
+ * Return 0 on success and -1 on error.
+ */
+int tracefs_instance_set_affinity_set(struct tracefs_instance *instance,
+				      cpu_set_t *set, size_t set_size)
+{
+	struct trace_seq seq;
+	bool free_set = false;
+	bool hit = false;
+	int nr_cpus;
+	int cpu;
+	int ret = -1;
+	int w, n, i;
+
+	trace_seq_init(&seq);
+
+	/* NULL set means all CPUs to be set */
+	if (!set) {
+		nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
+		set = CPU_ALLOC(nr_cpus);
+		if (!set)
+			goto out;
+		set_size = CPU_ALLOC_SIZE(nr_cpus);
+		CPU_ZERO_S(set_size, set);
+		/* Set all CPUS */
+		for (cpu = 0; cpu < nr_cpus; cpu++)
+			CPU_SET_S(cpu, set_size, set);
+		free_set = true;
+	}
+	/* Convert to a bitmask hex string */
+	nr_cpus = (set_size + 1) * 8;
+	if (nr_cpus < 1) {
+		/* Must have at least one bit set */
+		errno = EINVAL;
+		goto out;
+	}
+	/* Start backwards from 32 bits */
+	for (w = ((nr_cpus + 31) / 32) - 1; w >= 0; w--) {
+		/* Now move one nibble at a time */
+		for (n = 7; n >= 0; n--) {
+			int nibble = 0;
+
+			if ((n * 4) + (w * 32) >= nr_cpus)
+				continue;
+
+			/* One bit at a time */
+			for (i = 3; i >= 0; i--) {
+				cpu = (w * 32) + (n * 4) + i;
+				if (cpu >= nr_cpus)
+					continue;
+				if (CPU_ISSET_S(cpu, set_size, set)) {
+					nibble |= 1 << i;
+					hit = true;
+				}
+			}
+			if (hit && trace_seq_printf(&seq, "%x", nibble) < 0)
+				goto out;
+		}
+		if (hit && w)
+			if (trace_seq_putc(&seq, ',') < 0)
+				goto out;
+	}
+	if (!hit) {
+		errno = EINVAL;
+		goto out;
+	}
+	trace_seq_terminate(&seq);
+	ret = tracefs_instance_set_affinity_raw(instance, seq.buffer);
+ out:
+	trace_seq_destroy(&seq);
+	if (free_set)
+		CPU_FREE(set);
+	return ret;
+}
+
+/**
+ * tracefs_instance_set_affinity - Set the affinity defined by CPU values.
+ * @instance: The instance to set affinity to (NULL for top level)
+ * @cpu_str: A string of values that define what CPUs to set.
+ *
+ * Sets the tracing affinity CPU mask for @instance. The @cpu_str is a set
+ * of decimal numbers used to state which CPU should be part of the affinity
+ * mask. A range may also be specified via a hyphen.
+ *
+ * For example, "1,4,6-8"
+ *
+ * The numbers do not need to be in order.
+ *
+ * If @cpu_str is NULL, then all CPUs defined by sysconf(_SC_NPROCESSORS_CONF)
+ * will be set.
+ *
+ * Return 0 on success and -1 on error.
+ */
+int tracefs_instance_set_affinity(struct tracefs_instance *instance,
+				  const char *cpu_str)
+{
+	cpu_set_t *set = NULL;
+	size_t set_size;
+	char *word;
+	char *cpus;
+	char *del;
+	char *c;
+	int max_cpu = 0;
+	int cpu1, cpu2;
+	int len;
+	int ret = -1;
+
+	/* NULL cpu_str means to set all CPUs in the mask */
+	if (!cpu_str)
+		return tracefs_instance_set_affinity_set(instance, NULL, 0);
+
+	/* First, find out how many CPUs are needed */
+	cpus = strdup(cpu_str);
+	if (!cpus)
+		return -1;
+	len = strlen(cpus) + 1;
+	for (word = strtok_r(cpus, ",", &del); word; word = strtok_r(NULL, ",", &del)) {
+		cpu1 = atoi(word);
+		if (cpu1 < 0) {
+			errno = EINVAL;
+			goto out;
+		}
+		if (cpu1 > max_cpu)
+			max_cpu = cpu1;
+		cpu2 = -1;
+		if ((c = strchr(word, '-'))) {
+			c++;
+			cpu2 = atoi(c);
+			if (cpu2 < cpu1) {
+				errno = EINVAL;
+				goto out;
+			}
+			if (cpu2 > max_cpu)
+				max_cpu = cpu2;
+		}
+	}
+	/*
+	 * Now ideally, cpus should fit cpu_str as it was orginally allocated
+	 * by strdup(). But I'm paranoid, and can imagine someone playing tricks
+	 * with threads, and changes cpu_str from another thread and messes
+	 * with this. At least only copy what we know is allocated.
+	 */
+	strncpy(cpus, cpu_str, len);
+
+	set = CPU_ALLOC(max_cpu + 1);
+	if (!set)
+		goto out;
+	set_size = CPU_ALLOC_SIZE(max_cpu + 1);
+	CPU_ZERO_S(set_size, set);
+
+	for (word = strtok_r(cpus, ",", &del); word; word = strtok_r(NULL, ",", &del)) {
+		cpu1 = atoi(word);
+		if (cpu1 < 0 || cpu1 > max_cpu) {
+			/* Someone playing games? */
+			errno = EACCES;
+			goto out;
+		}
+		cpu2 = cpu1;
+		if ((c = strchr(word, '-'))) {
+			c++;
+			cpu2 = atoi(c);
+			if (cpu2 < cpu1 || cpu2 > max_cpu) {
+				errno = EACCES;
+				goto out;
+			}
+		}
+		for ( ; cpu1 <= cpu2; cpu1++)
+			CPU_SET(cpu1, set);
+	}
+	ret = tracefs_instance_set_affinity_set(instance, set, set_size);
+ out:
+	free(cpus);
+	CPU_FREE(set);
+	return ret;
+}
-- 
2.33.0

