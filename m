Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA934C7EE24
	for <linux-trace-devel@archiver.kernel.org>; Sat,  3 Jun 2023 21:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjFCVLB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 3 Jun 2023 17:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjFCVLA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 3 Jun 2023 17:11:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3536EB8
        for <linux-trace-devel@vger.kernel.org>; Sat,  3 Jun 2023 14:10:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA93560FFA
        for <linux-trace-devel@vger.kernel.org>; Sat,  3 Jun 2023 21:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04CDC433EF;
        Sat,  3 Jun 2023 21:10:57 +0000 (UTC)
Date:   Sat, 3 Jun 2023 17:10:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     keiichiw@google.com, takayas@google.com, uekawa@google.com
Subject: [PATCH] tracefs: Add tracefs_time_conversion() API
Message-ID: <20230603171056.255eb566@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a helper function that does a perf system call to extract how the
kernel calculates nanoseconds from the raw time stamp counter. It
returns the shift, multiplier, and offset for a given CPU.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-guest.txt | 67 ++++++++++++++++++++-
 Makefile                           |  8 ++-
 include/tracefs.h                  |  3 +
 src/Makefile                       |  3 +
 src/tracefs-perf.c                 | 93 ++++++++++++++++++++++++++++++
 5 files changed, 172 insertions(+), 2 deletions(-)
 create mode 100644 src/tracefs-perf.c

diff --git a/Documentation/libtracefs-guest.txt b/Documentation/libtracefs-guest.txt
index 1c527b0..16ce020 100644
--- a/Documentation/libtracefs-guest.txt
+++ b/Documentation/libtracefs-guest.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_find_cid_pid, tracefs_instance_find_cid_pid -
+tracefs_find_cid_pid, tracefs_instance_find_cid_pid, tracefs_time_conversion -
 helper functions to handle tracing guests
 
 SYNOPSIS
@@ -14,6 +14,7 @@ SYNOPSIS
 
 char pass:[*]*tracefs_find_cid_pid*(int _cid_);
 char pass:[*]*tracefs_instance_find_cid_pid*(struct tracefs_instance pass:[*]_instance_, int _cid_);
+int *tracefs_time_conversion*(int _cpu_, int pass:[*]_shift_, int pass:[*]_multi_, long long pass:[*]offset);
 --
 
 DESCRIPTION
@@ -27,6 +28,11 @@ The *tracefs_instance_find_cid_pid*() is the same as *tracefs_find_cid_pid*() bu
 the instance to use to perform the tracing in. If NULL it will use the top level
 buffer to perform the tracing.
 
+The *tracefs_time_conversion*() will return the values used by the kernel to convert
+the raw time stamp counter into nanoseconds for the given _cpu_. Pointers for _shift_, _multi_
+and _offset_ can be NULL to be ignored, otherwise they are set with the shift, multiplier
+and offset repectively.
+
 RETURN VALUE
 ------------
 Both *tracefs_find_cid_pid*() and *tracefs_instance_find_cid_pid*() will return the
@@ -76,8 +82,67 @@ static int find_cids(void)
 	return 0;
 }
 
+struct time_info {
+	int		shift;
+	int		multi;
+};
+
+static void show_time_conversion(void)
+{
+	struct time_info *tinfo;
+	int cpus;
+	int cpu;
+	int ret;
+
+	cpus = sysconf(_SC_NPROCESSORS_CONF);
+	tinfo = calloc(cpus, sizeof(*tinfo));
+	if (!tinfo)
+		exit(-1);
+
+	for (cpu = 0; cpu < cpus; cpu++) {
+		ret  = tracefs_time_conversion(cpu,
+						&tinfo[cpu].shift,
+						&tinfo[cpu].multi,
+						NULL);
+		if (ret)
+			break;
+	}
+	if (cpu != cpus) {
+		if (!cpu) {
+			perror("tracefs_time_conversion");
+			exit(-1);
+		}
+		printf("Only read %d of %d CPUs", cpu, cpus);
+		cpus = cpu + 1;
+	}
+
+	/* Check if all the shift and mult values are the same */
+	for (cpu = 1; cpu < cpus; cpu++) {
+		if (tinfo[cpu - 1].shift != tinfo[cpu].shift)
+			break;
+		if (tinfo[cpu - 1].multi != tinfo[cpu].multi)
+			break;
+	}
+
+	if (cpu == cpus) {
+		printf("All cpus have:\n");
+		printf(" shift:  %d\n", tinfo[0].shift);
+		printf(" multi:  %d\n", tinfo[0].multi);
+		printf("\n");
+		return;
+	}
+
+	for (cpu = 0; cpu < cpus; cpu++) {
+		printf("CPU: %d\n", cpu);
+		printf(" shift:  %d\n", tinfo[cpu].shift);
+		printf(" multi:  %d\n", tinfo[cpu].multi);
+		printf("\n");
+	}
+}
+
 int main(int argc, char *argv[])
 {
+	show_time_conversion();
 	find_cids();
 	exit(0);
 }
diff --git a/Makefile b/Makefile
index 1e5fe77..f3b2753 100644
--- a/Makefile
+++ b/Makefile
@@ -79,13 +79,19 @@ else
 VSOCK_DEFINED := 0
 endif
 
+ifndef NO_PERF
+PERF_DEFINED := $(shell if (echo "$(pound)include <linux/perf_event.h>" | $(CC) -E - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+else
+PREF_DEFINED := 0
+endif
+
 etcdir ?= /etc
 etcdir_SQ = '$(subst ','\'',$(etcdir))'
 
 export man_dir man_dir_SQ html_install html_install_SQ INSTALL
 export img_install img_install_SQ
 export DESTDIR DESTDIR_SQ
-export VSOCK_DEFINED
+export VSOCK_DEFINED PERF_DEFINED
 
 pound := \#
 
diff --git a/include/tracefs.h b/include/tracefs.h
index 782dae2..7c442e4 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -644,4 +644,7 @@ int tracefs_cpu_pipe(struct tracefs_cpu *tcpu, int wfd, bool nonblock);
 int tracefs_instance_find_cid_pid(struct tracefs_instance *instance, int cid);
 int tracefs_find_cid_pid(int cid);
 
+/* More guest helpers */
+int tracefs_time_conversion(int cpu, int *shift, int *mult, long long *offset);
+
 #endif /* _TRACE_FS_H */
diff --git a/src/Makefile b/src/Makefile
index 90be7bc..90bd88d 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,6 +18,9 @@ OBJS += tracefs-record.o
 ifeq ($(VSOCK_DEFINED), 1)
 OBJS += tracefs-vsock.o
 endif
+ifeq ($(PERF_DEFINED), 1)
+OBJS += tracefs-perf.o
+endif
 
 # Order matters for the the three below
 OBJS += sqlhist-lex.o
diff --git a/src/tracefs-perf.c b/src/tracefs-perf.c
new file mode 100644
index 0000000..96d12cd
--- /dev/null
+++ b/src/tracefs-perf.c
@@ -0,0 +1,93 @@
+#include <asm/unistd.h>
+#include <sys/mman.h>
+#include <signal.h>
+#include <linux/perf_event.h>
+
+#include <tracefs.h>
+
+static void perf_init_pe(struct perf_event_attr *pe)
+{
+	memset(pe, 0, sizeof(struct perf_event_attr));
+	pe->type = PERF_TYPE_SOFTWARE;
+	pe->sample_type = PERF_SAMPLE_CPU;
+	pe->size = sizeof(struct perf_event_attr);
+	pe->config = PERF_COUNT_HW_CPU_CYCLES;
+	pe->disabled = 1;
+	pe->exclude_kernel = 1;
+	pe->freq = 1;
+	pe->sample_freq = 1000;
+	pe->inherit = 1;
+	pe->mmap = 1;
+	pe->comm = 1;
+	pe->task = 1;
+	pe->precise_ip = 1;
+	pe->sample_id_all = 1;
+	pe->read_format = PERF_FORMAT_ID |
+			PERF_FORMAT_TOTAL_TIME_ENABLED|
+			PERF_FORMAT_TOTAL_TIME_RUNNING;
+
+}
+
+static long perf_event_open(struct perf_event_attr *event, pid_t pid,
+			    int cpu, int group_fd, unsigned long flags)
+{
+	return syscall(__NR_perf_event_open, event, pid, cpu, group_fd, flags);
+}
+
+#define MAP_SIZE (9 * getpagesize())
+
+static struct perf_event_mmap_page *perf_mmap(int fd)
+{
+	struct perf_event_mmap_page *perf_mmap;
+
+	/* associate a buffer with the file */
+	perf_mmap = mmap(NULL, MAP_SIZE,
+			PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (perf_mmap == MAP_FAILED)
+		return NULL;
+
+	return perf_mmap;
+}
+
+static int perf_read_maps(int cpu, int *shift, int *mult, long long *offset)
+{
+	struct perf_event_attr perf_attr;
+	struct perf_event_mmap_page *mpage;
+	int fd;
+
+	/* We succeed if theres' nothing to do! */
+	if (!shift && !mult && !offset)
+		return 0;
+
+	perf_init_pe(&perf_attr);
+	fd = perf_event_open(&perf_attr, getpid(), cpu, -1, 0);
+	if (fd < 0)
+		return -1;
+
+	mpage = perf_mmap(fd);
+	if (!mpage) {
+		close(fd);
+		return -1;
+	}
+
+	if (shift)
+		*shift = mpage->time_shift;
+	if (mult)
+		*mult = mpage->time_mult;
+	if (offset)
+		*offset = mpage->time_offset;
+	munmap(mpage, MAP_SIZE);
+	return 0;
+}
+
+/**
+ * tracefs_time_conversion - Find how the kernel converts the raw counters
+ * @cpu: The CPU to check for
+ * @shift: If non-NULL it will be set to the shift value
+ * @mult: If non-NULL it will be set to the multiplier value
+ * @offset: If non-NULL it will be set to the offset
+ */
+int tracefs_time_conversion(int cpu, int *shift, int *mult, long long *offset)
+{
+	return perf_read_maps(cpu, shift, mult, offset);
+}
-- 
2.39.2

