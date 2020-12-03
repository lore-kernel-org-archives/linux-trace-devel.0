Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E604C83014
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 06:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D47A820665
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Dec 2020 06:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgLCGDX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Dec 2020 01:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729458AbgLCGDW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 01:03:22 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C31C061A54
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Dec 2020 22:02:36 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id cw27so813079edb.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Dec 2020 22:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BAoVmVe2gk8MVFvGtRORoG1rwkfi34qqEE291y0YmcQ=;
        b=svYcM5x8ZwJn6A411991iKYAG9agmqqGRvNppqzLYgLRLLE8AIh6eFO0u6z8tKPS5o
         BfurtruI4e6OuSfWBn+i0gmmzUcrLuPrEA/cON3erQ9YuWHfzmRfFkCJTdOWRhEc3PoU
         w5VbqSV6j3RgDYw5k7BYmMowHNvS3ITHxNqcHyfz2cqUFIiC0WelobbsAn+8EO9+d206
         pixu+VUOEZ2ocDJS2SLYZae89iv9ahGbrz53ZWBCuNHxNVEZh0RY4djFMAYcugp/HkdZ
         qQQTF0WeiuCz3jO2120He/9aXtQifid0sAAie22oVMeuWpJJ7mIwnzrp1cZ0vSbqT/hO
         ey8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BAoVmVe2gk8MVFvGtRORoG1rwkfi34qqEE291y0YmcQ=;
        b=VGCvugk5wx0FQ2KOqTnf46NXQPO4nGzhgIAaBhOQeWvKCg4J203D/A6m/CjM/m4RBT
         BfaVYJEcxHoFOv07Fy24HOEmiEw2oNuOHMN4qJu8EbaPLB9gLq8b0oq7gP5d4ufvndFT
         A+Pt/NRdb7DAcROhFWYPtWDTONMtFP5i1slyDZFu72Z8bQE62tYwBVZiGKfB8kZ4FKsn
         3X1XdyfWbayL5A2od2u8IMngC6biAhaWPVyfJbSRljOAbIQCY4Ycf2RTd9X7fKe1OCF0
         QCKABRBsBHaG6DhXmqGZ3J9OZxE0/HZkAreVqVMneYeDEY1DIUngyKsW8cVrHiDCzSpO
         TcPQ==
X-Gm-Message-State: AOAM533qiiTFwfoPKQyxewwWGBb2isHCWDkxPFXIhOeRB6L1DZR1mzI3
        K3nHkf6+y80WBku80zweYSM=
X-Google-Smtp-Source: ABdhPJznoaOl8ztCrGx4nA7LP6kzm/DhBT6Fkd2F9xDeCA3NetCx3EeMPhJ4p2S9ieu5/uNUGE0INQ==
X-Received: by 2002:aa7:db56:: with SMTP id n22mr1478963edt.4.1606975355153;
        Wed, 02 Dec 2020 22:02:35 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d9sm388629edk.86.2020.12.02.22.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 22:02:34 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/5] [WIP] trace-cmd: Add new subcomand "trace-cmd perf"
Date:   Thu,  3 Dec 2020 08:02:26 +0200
Message-Id: <20201203060226.476475-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201203060226.476475-1-tz.stoyanov@gmail.com>
References: <20201203060226.476475-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new sub command uses perf to collect performance information of the
selected process. It has one mandatory argument:
trace-cmd perf --pid <PID>

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/Makefile              |   1 +
 tracecmd/include/trace-local.h |   2 +
 tracecmd/trace-cmd.c           |   1 +
 tracecmd/trace-perf.c          | 726 +++++++++++++++++++++++++++++++++
 4 files changed, 730 insertions(+)
 create mode 100644 tracecmd/trace-perf.c

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 5a16a5e5..3fda6de8 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -33,6 +33,7 @@ TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-dump.o
 TRACE_CMD_OBJS += trace-clear.o
 TRACE_CMD_OBJS += trace-obj-debug.o
+TRACE_CMD_OBJS += trace-perf.o
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-tsync.o
 endif
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index cd2d34a4..b0d03900 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -102,6 +102,8 @@ void trace_usage(int argc, char **argv);
 
 void trace_dump(int argc, char **argv);
 
+void trace_perf(int argc, char **argv);
+
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
 		       int argc, char **argv, bool use_fifos,
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 7376c5a5..0c5b324f 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -104,6 +104,7 @@ struct command commands[] = {
 	{"list", trace_list},
 	{"help", trace_usage},
 	{"dump", trace_dump},
+	{"perf", trace_perf},
 	{"-h", trace_usage},
 };
 
diff --git a/tracecmd/trace-perf.c b/tracecmd/trace-perf.c
new file mode 100644
index 00000000..9b9f3519
--- /dev/null
+++ b/tracecmd/trace-perf.c
@@ -0,0 +1,726 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2020, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+ *
+ */
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <string.h>
+#include <getopt.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <pthread.h>
+#include <linux/perf_event.h>
+#include <asm/unistd.h>
+#include <sys/mman.h>
+#include <signal.h>
+
+#include "trace-local.h"
+#include "trace-cmd-local.h"
+
+#define SLEEP_USEC		1000
+#define SAMPLE_PER_SECOND	8000
+
+static volatile bool done;
+
+struct perf_stat {
+	__u64 count;
+	__u64 time_enabled;
+	__u64 time_running;
+	__u64 id;
+};
+
+struct perf_split_event {
+	int size;
+	int part_size;
+	char *buf;
+};
+
+struct perf_cpu {
+	int cpu;
+	int pid;
+	unsigned int prev_pos;
+	int perf_fd;
+	int sample_file_fd;
+	int mmap_file_fd;
+	char *sample_file;
+	char *mmap_file;
+	pthread_t tid;
+	struct perf_split_event split;
+	struct perf_event_mmap_page *mpage;
+};
+
+struct perf_session {
+	int pid;
+	int cpu_count;
+	struct perf_cpu *cpus;
+	struct trace_debug_object *fdebug;
+};
+
+static long perf_event_open(struct perf_event_attr *event, pid_t pid,
+			    int cpu, int group_fd, unsigned long flags)
+{
+	return syscall(__NR_perf_event_open, event, pid, cpu, group_fd, flags);
+}
+
+/*
+ * struct {
+ *	struct perf_event_header	header;
+ *
+ *	#
+ *	# Note that PERF_SAMPLE_IDENTIFIER duplicates PERF_SAMPLE_ID.
+ *	# The advantage of PERF_SAMPLE_IDENTIFIER is that its position
+ *	# is fixed relative to header.
+ *	#
+ *
+ *	{ u64			id;	  } && PERF_SAMPLE_IDENTIFIER
+ *	{ u64			ip;	  } && PERF_SAMPLE_IP
+ *	{ u32			pid, tid; } && PERF_SAMPLE_TID
+ *	{ u64			time;     } && PERF_SAMPLE_TIME
+ *	{ u64			addr;     } && PERF_SAMPLE_ADDR
+ *	{ u64			id;	  } && PERF_SAMPLE_ID
+ *	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
+ *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
+ *	{ u64			period;   } && PERF_SAMPLE_PERIOD
+ *
+ *	{ struct read_format	values;	  } && PERF_SAMPLE_READ
+ *
+ *	{ u64			nr,
+ *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
+ *
+ *	#
+ *	# The RAW record below is opaque data wrt the ABI
+ *	#
+ *	# That is, the ABI doesn't make any promises wrt to
+ *	# the stability of its content, it may vary depending
+ *	# on event, hardware, kernel version and phase of
+ *	# the moon.
+ *	#
+ *	# In other words, PERF_SAMPLE_RAW contents are not an ABI.
+ *	#
+ *
+ *	{ u32			size;
+ *	  char                  data[size];}&& PERF_SAMPLE_RAW
+ *
+ *	{ u64                   nr;
+ *	  { u64	hw_idx; } && PERF_SAMPLE_BRANCH_HW_INDEX
+ *        { u64 from, to, flags } lbr[nr];
+ *      } && PERF_SAMPLE_BRANCH_STACK
+ *
+ *	{ u64			abi; # enum perf_sample_regs_abi
+ *	  u64			regs[weight(mask)]; } && PERF_SAMPLE_REGS_USER
+ *
+ *	{ u64			size;
+ *	  char			data[size];
+ *	  u64			dyn_size; } && PERF_SAMPLE_STACK_USER
+ *
+ *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
+ *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
+ *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
+ *	{ u64			abi; # enum perf_sample_regs_abi
+ *	  u64			regs[weight(mask)]; } && PERF_SAMPLE_REGS_INTR
+ *	{ u64			phys_addr;} && PERF_SAMPLE_PHYS_ADDR
+ *	{ u64			size;
+ *	  char			data[size]; } && PERF_SAMPLE_AUX
+ * };
+ */
+
+struct perf_event_sample {
+	struct perf_event_header head;
+	uint64_t id;		/* PERF_SAMPLE_IDENTIFIER */
+	uint32_t pid, tid;	/* PERF_SAMPLE_TID */
+	uint64_t time;		/* PERF_SAMPLE_TIME */
+	uint32_t cpu, res;	/* PERF_SAMPLE_CPU */
+	uint64_t period;	/* PERF_SAMPLE_PERIOD */
+	uint64_t nr;
+	uint64_t ips[];		/* PERF_SAMPLE_CALLCHAIN */
+} __attribute__((packed));
+
+struct perf_event_mmap {
+	struct perf_event_header	header;
+
+	uint32_t			pid, tid;
+	uint64_t			addr;
+	uint64_t			len;
+	uint64_t			pgoff;
+	char				filename[];
+} __attribute__((packed));
+
+static int handle_event_sample(struct perf_event_sample *sample, struct perf_cpu *cpu)
+{
+	int i;
+
+	/* check if sample is for our PID */
+	if (sample->pid != cpu->pid)
+		return 0;
+
+	if (write(cpu->sample_file_fd, &sample->time, sizeof(uint64_t)) < 0)
+		return -1;
+	if (write(cpu->sample_file_fd, &sample->nr, sizeof(uint64_t)) < 0)
+		return -1;
+	for (i = 0; i < sample->nr; i++) {
+		if (write(cpu->sample_file_fd, &sample->ips[i], sizeof(uint64_t)) < 0)
+			return -1;
+	}
+
+	return 1;
+}
+
+static int handle_event_mmap(struct perf_event_mmap *event, struct perf_cpu *cpu)
+{
+	/* check if mmap is for our PID */
+	if (event->pid != cpu->pid)
+		return 0;
+	/* check if executable memory is mapped */
+	if (event->header.misc & PERF_RECORD_MISC_MMAP_DATA)
+		return 0;
+
+	if (write(cpu->mmap_file_fd, &event->addr, sizeof(uint64_t)) < 0)
+		return -1;
+	if (write(cpu->mmap_file_fd, &event->len, sizeof(uint64_t)) < 0)
+		return -1;
+	if (write(cpu->mmap_file_fd, &event->pgoff, sizeof(uint64_t)) < 0)
+		return -1;
+	if (write(cpu->mmap_file_fd, event->filename, strlen(event->filename) + 1) < 0)
+		return -1;
+
+	return 1;
+}
+
+#define NUM_PAGES 8
+static unsigned int mmap_mask;
+
+static int handle_event(struct perf_event_header *event, struct perf_cpu *cpu)
+{
+	int ret;
+
+	if (event->size == 0)
+		return -1;
+
+	switch (event->type) {
+	case PERF_RECORD_SAMPLE: /* new callstack sample */
+		ret = handle_event_sample((struct perf_event_sample *)event, cpu);
+		break;
+	case PERF_RECORD_MMAP: /* new memory mapped, may be a library is loaded ? */
+		ret = handle_event_mmap((struct perf_event_mmap *)event, cpu);
+		break;
+	default:
+		/* Got unknown perf event */
+		ret = 0;
+		break;
+	}
+	return ret;
+}
+
+static int perf_event_read_samples(struct perf_cpu *cpu, unsigned char *buf, int size)
+{
+	unsigned char *end = buf + size;
+	struct perf_event_header *h;
+	int csize = size;
+	int ret;
+
+	if (cpu->split.buf) {
+		/* partial read, check if there is enough data to complete it */
+		if ((cpu->split.size - cpu->split.part_size) > size)
+			return -1;
+		memcpy(cpu->split.buf + cpu->split.part_size,
+		       buf, cpu->split.size - cpu->split.part_size);
+		ret = handle_event((struct perf_event_header *)cpu->split.buf, cpu);
+		buf += (cpu->split.size - cpu->split.part_size);
+		free(cpu->split.buf);
+		memset(&cpu->split, 0, sizeof(struct perf_split_event));
+		if (ret < 0)
+			return -1; /* Failed to process the partial event */
+	}
+
+	while (buf < end) {
+		h = (struct perf_event_header *)buf;
+		if (h->size == 0)
+			return -1;
+		if (h->size > csize) {
+			/* part of the event is in the buffer, do partial read */
+			if (cpu->split.buf != NULL)
+				return -1; /* Previous partial read pending */
+			cpu->split.buf = calloc(1, h->size);
+			if (!cpu->split.buf)
+				return -1;
+			cpu->split.size = h->size;
+			cpu->split.part_size = csize;
+			memcpy(cpu->split.buf, buf, csize);
+			return csize;
+		}
+		if (handle_event(h, cpu) < 0)
+			return -1; /* Failed to process the event */
+		csize -= h->size;
+		buf += h->size;
+	}
+
+	return 0;
+}
+
+static int perf_event_read(struct perf_cpu *cpu)
+{
+	unsigned char *buf;
+	unsigned char *data;
+	unsigned int head;
+	int diff, size;
+	unsigned int old;
+
+	data = (unsigned char *)cpu->mpage + getpagesize();
+
+	head = cpu->mpage->data_head;
+	/* On SMP-capable platforms, after reading the data_head value,
+	 * user space should issue an rmb().
+	 */
+	__sync_synchronize();
+
+	old = cpu->prev_pos;
+	diff = head - old;
+	if (diff < 0)
+		old = head; /* buffer overrun, events lost */
+
+	size = head - old;
+	if ((old & mmap_mask) + size != (head & mmap_mask)) {
+		buf = data + (old & mmap_mask);
+		size = mmap_mask + 1 - (old & mmap_mask);
+		old += size;
+		perf_event_read_samples(cpu, buf, size);
+	}
+	buf = data + (old & mmap_mask);
+	size = head - old;
+	if (size)
+		perf_event_read_samples(cpu, buf, size);
+
+	old += size;
+	cpu->prev_pos = old;
+	/* reset the buffer */
+	cpu->mpage->data_tail = old;
+
+	return size;
+}
+
+static void perf_init_pe(struct perf_event_attr *pe)
+{
+	memset(pe, 0, sizeof(struct perf_event_attr));
+	pe->type = PERF_TYPE_HARDWARE;
+	pe->sample_type = PERF_SAMPLE_CALLCHAIN |
+			  PERF_SAMPLE_IDENTIFIER |
+			  PERF_SAMPLE_TID |
+			  PERF_SAMPLE_TIME |
+			  PERF_SAMPLE_CPU |
+			  PERF_SAMPLE_PERIOD;
+	pe->size = sizeof(struct perf_event_attr);
+	pe->config = PERF_COUNT_HW_CPU_CYCLES;
+	pe->disabled = 1;
+	pe->exclude_kernel = 1;
+	pe->freq = 1;
+	pe->sample_freq = SAMPLE_PER_SECOND;
+	pe->inherit = 1;
+	pe->mmap = 1;
+	pe->comm = 1;
+	pe->task = 1;
+	pe->precise_ip = 1;
+	pe->sample_id_all = 1;
+//	pe->mmap2 = 1;
+	pe->comm_exec = 1;
+	pe->ksymbol = 1;
+	pe->bpf_event = 1;
+	pe->read_format = PERF_FORMAT_ID |
+			PERF_FORMAT_TOTAL_TIME_ENABLED|
+			PERF_FORMAT_TOTAL_TIME_RUNNING;
+
+}
+
+static int perf_enable(struct perf_cpu *perf, bool enable)
+{
+	int ret;
+
+	if (enable) {
+		ret = ioctl(perf->perf_fd, PERF_EVENT_IOC_RESET, 0);
+		ret = ioctl(perf->perf_fd, PERF_EVENT_IOC_ENABLE, 0);
+	} else
+		ret = ioctl(perf->perf_fd, PERF_EVENT_IOC_DISABLE, 0);
+
+	return ret;
+}
+
+static int perf_mmap(struct perf_cpu *perf)
+{
+	mmap_mask = NUM_PAGES * getpagesize() - 1;
+
+	/* associate a buffer with the file */
+	perf->mpage = mmap(NULL, (NUM_PAGES + 1) * getpagesize(),
+			PROT_READ | PROT_WRITE, MAP_SHARED, perf->perf_fd, 0);
+	if (perf->mpage == MAP_FAILED)
+		return -1;
+	return 0;
+}
+
+static void perf_session_destroy(struct perf_session *perf)
+{
+	int i;
+
+	if (!perf)
+		return;
+
+	if (perf->cpu_count && perf->cpus) {
+		for (i = 0; i < perf->cpu_count; i++) {
+			if (perf->cpus[i].perf_fd >= 0)
+				close(perf->cpus[i].perf_fd);
+			if (perf->cpus[i].sample_file_fd >= 0)
+				close(perf->cpus[i].sample_file_fd);
+			if (perf->cpus[i].mmap_file_fd >= 0)
+				close(perf->cpus[i].mmap_file_fd);
+			if (perf->cpus[i].mpage)
+				munmap(perf->cpus[i].mpage,
+				       (NUM_PAGES + 1) * getpagesize());
+			if (perf->cpus[i].sample_file) {
+				remove(perf->cpus[i].sample_file);
+				free(perf->cpus[i].sample_file);
+			}
+			if (perf->cpus[i].mmap_file) {
+				remove(perf->cpus[i].mmap_file);
+				free(perf->cpus[i].mmap_file);
+			}
+			free(perf->cpus[i].split.buf);
+		}
+		free(perf->cpus);
+	}
+
+	if (perf->fdebug)
+		trace_debug_obj_destroy(perf->fdebug);
+
+	free(perf);
+}
+
+#define TMP_FILE "/tmp/perf_temp_data.XXXXXX"
+static struct perf_session *perf_session_new(int pid)
+{
+	int cpus = tracecmd_count_cpus();
+	struct perf_event_attr pe;
+	struct perf_session *perf;
+	char *template;
+	int i;
+
+	perf = calloc(cpus, sizeof(struct perf_session));
+	if (!perf)
+		return NULL;
+	template = strdup(TMP_FILE);
+	if (!template)
+		goto error;
+	perf->fdebug = trace_debug_obj_create_pid(pid);
+	if (!perf->fdebug)
+		goto error;
+	perf->cpus = calloc(cpus, sizeof(struct perf_cpu));
+	if (!cpus)
+		goto error;
+	for (i = 0; i < cpus; i++) {
+		perf->cpus[i].perf_fd = -1;
+		perf->cpus[i].sample_file_fd = -1;
+		perf->cpus[i].mmap_file_fd = -1;
+	}
+
+	perf_init_pe(&pe);
+	for (i = 0; i < cpus; i++) {
+		perf->cpus[i].perf_fd = perf_event_open(&pe, pid, i, -1, 0);
+		if (perf->cpus[i].perf_fd < 0)
+			goto error;
+		fcntl(perf->cpus[i].perf_fd, F_SETFL, O_NONBLOCK);
+		perf->cpus[i].cpu = i;
+		if (perf_mmap(&perf->cpus[i]) < 0)
+			goto error;
+		strcpy(template, TMP_FILE);
+		mktemp(template);
+		perf->cpus[i].sample_file = strdup(template);
+		strcpy(template, TMP_FILE);
+		mktemp(template);
+		perf->cpus[i].mmap_file = strdup(template);
+		perf->cpus[i].pid = pid;
+	}
+	perf->cpu_count = cpus;
+	perf->pid = pid;
+	free(template);
+	return perf;
+error:
+	free(template);
+	perf_session_destroy(perf);
+	return NULL;
+}
+
+void *perf_read_thread(void *context)
+{
+	struct perf_cpu *cpu = (struct perf_cpu *)context;
+	struct timespec swait;
+	sigset_t sig_set;
+	int ret;
+
+	swait.tv_sec = SLEEP_USEC / 1000000,
+	swait.tv_nsec = (SLEEP_USEC % 1000000) * 1000,
+
+	sigemptyset(&sig_set);
+	sigaddset(&sig_set, SIGINT);
+	sigaddset(&sig_set, SIGTERM);
+	pthread_sigmask(SIG_BLOCK, &sig_set, NULL);
+
+	cpu->sample_file_fd = open(cpu->sample_file, O_WRONLY|O_CREAT|O_TRUNC, 0600);
+	if (cpu->sample_file_fd < 0)
+		return NULL;
+	cpu->mmap_file_fd = open(cpu->mmap_file, O_WRONLY|O_CREAT|O_TRUNC, 0600);
+	if (cpu->mmap_file_fd < 0)
+		return NULL;
+
+	perf_enable(cpu, true);
+
+	while (1) {
+		ret = perf_event_read(cpu);
+		if (!ret) /* sleep if the buffer was empty */
+			nanosleep(&swait, NULL);
+	}
+
+	return NULL;
+}
+
+#define PERF_READER_SCHEDULER SCHED_RR
+static int perf_run_readers(struct perf_session *perf)
+{
+	struct sched_param sched;
+	pthread_attr_t attr;
+	int i;
+
+	sched.sched_priority = sched_get_priority_max(PERF_READER_SCHEDULER);
+	pthread_attr_init(&attr);
+	pthread_attr_setschedpolicy(&attr, PERF_READER_SCHEDULER);
+	pthread_attr_setschedparam(&attr, &sched);
+	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
+
+	for (i = 0; i < perf->cpu_count; i++) {
+		if (pthread_create(&perf->cpus[i].tid, &attr,
+				   perf_read_thread, &perf->cpus[i]))
+			return -1;
+	}
+
+	return 0;
+}
+
+static int perf_stop_readers(struct perf_session *perf)
+{
+	int i;
+
+	for (i = 0; i < perf->cpu_count; i++)
+		pthread_cancel(perf->cpus[i].tid);
+
+	for (i = 0; i < perf->cpu_count; i++)
+		pthread_join(perf->cpus[i].tid, NULL);
+
+	return 0;
+}
+
+static void perf_collect_results(struct perf_session *perf, int cpu)
+{
+	unsigned long long addr, len, pgoff;
+	unsigned long long time, count, ip;
+	char file[PATH_MAX];
+	int sfd, mfd, i;
+	int sall = 0;
+	int mall = 0;
+	int ret;
+
+	if (!perf->cpus[cpu].mmap_file || !perf->cpus[cpu].sample_file)
+		return;
+	mfd = open(perf->cpus[cpu].mmap_file, O_RDONLY, 0600);
+	if (mfd < 0)
+		return;
+	sfd = open(perf->cpus[cpu].sample_file, O_RDONLY, 0600);
+	if (sfd < 0)
+		return;
+	do {
+		/* Loop through all dynamically loaded libraries during the trace
+		 * and attach them to the debug object, to be used for symbols resolve.
+		 */
+		ret = read(mfd, &addr, sizeof(addr));
+		if (ret != sizeof(addr))
+			break;
+		ret = read(mfd, &len, sizeof(len));
+		if (ret != sizeof(len))
+			break;
+		ret = read(mfd, &pgoff, sizeof(pgoff));
+		if (ret != sizeof(pgoff))
+			break;
+		ret = trace_read_file_string(mfd, file, PATH_MAX);
+		if (ret < 0)
+			break;
+		trace_debug_obj_add_file(perf->fdebug, file, addr, addr + len, pgoff);
+		mall++;
+	} while (1);
+
+	do {
+		/* Loop through all collected calltraces and add addresses to
+		 * the debug object for function name resolving.
+		 */
+		ret = read(sfd, &time, sizeof(time));
+		if (ret != sizeof(time))
+			break;
+
+		ret = read(sfd, &count, sizeof(count));
+		if (ret != sizeof(count))
+			break;
+
+		for (i = 0; i < count; i++) {
+			ret = read(sfd, &ip, sizeof(ip));
+			if (ret != sizeof(ip))
+				break;
+			ret = trace_debug_add_resolve_symbol(perf->fdebug, ip, NULL);
+		}
+		sall++;
+		if (i < count)
+			break;
+	} while (1);
+	close(sfd);
+	close(mfd);
+
+	printf("Got %d samples and %d mmaps for CPU %d\n", sall, mall, cpu);
+}
+
+static void stop_perf(int sig)
+{
+	done = true;
+}
+
+static int perf_collect(struct perf_session *perf)
+{
+	int i;
+
+	signal(SIGINT, stop_perf);
+	signal(SIGTERM, stop_perf);
+
+	if (perf_run_readers(perf))
+		return -1;
+
+	printf("Collecting callstack of pid %d, hit Ctrl^C to stop recording\n",
+		perf->pid);
+
+	while (!done)
+		usleep(500000);
+
+	for (i = 0; i < perf->cpu_count; i++)
+		perf_enable(&perf->cpus[i], false);
+
+	perf_stop_readers(perf);
+
+	for (i = 0; i < perf->cpu_count; i++)
+		perf_collect_results(perf, i);
+
+	return 0;
+}
+
+struct symb_walk_context {
+	struct trace_seq *s;
+	int count;
+};
+
+static int perf_symbols_walk(struct tracecmd_debug_symbols *symb, void *data)
+{
+	struct symb_walk_context *context = (struct symb_walk_context *)data;
+
+	if (!symb->name)
+		printf("\t Failed to resolve %llx in %s\n",
+			symb->vma_near, symb->fname);
+
+	trace_seq_printf(context->s, "%s %s %llx %llx\n",
+			 symb->fname, symb->name,
+			 symb->vma_start, symb->vma_near);
+	context->count++;
+
+	return 0;
+}
+
+static void
+add_pid_symbols(struct tracecmd_output *handle, struct perf_session *perf)
+{
+	struct symb_walk_context context;
+	struct trace_seq body, head;
+
+	trace_seq_init(&body);
+	trace_seq_init(&head);
+	context.s = &body;
+	context.count = 0;
+	trace_debug_walk_resolved_symbols(perf->fdebug, perf_symbols_walk, &context);
+	trace_seq_printf(&head, "%x %d\n", perf->pid, context.count);
+	trace_seq_terminate(&head);
+	trace_seq_terminate(&body);
+	trace_seq_puts(&head, body.buffer);
+	if (handle && context.count)
+		tracecmd_add_option(handle, TRACECMD_OPTION_PID_SYMBOLS,
+				    head.len + 1, head.buffer);
+	else
+		trace_seq_do_printf(&head);
+	trace_seq_destroy(&body);
+}
+
+static int perf_resolve_trace(struct perf_session *perf)
+{
+	trace_debug_resolve_symbols(perf->fdebug);
+	add_pid_symbols(NULL, perf);
+
+	return 0;
+}
+
+int perf_run(int pid)
+{
+	struct perf_session *perf;
+
+	perf = perf_session_new(pid);
+	if (perf == NULL)
+		return -1;
+
+	perf_collect(perf);
+
+	perf_resolve_trace(perf);
+
+	perf_session_destroy(perf);
+	return 0;
+}
+
+enum {
+	OPT_pid	= 255,
+};
+
+void trace_perf(int argc, char **argv)
+{
+	int pid = 0;
+	int c;
+
+
+	if (strcmp(argv[1], "perf") != 0)
+		usage(argv);
+	for (;;) {
+		int option_index = 0;
+		static struct option long_options[] = {
+			{"pid", required_argument, NULL, OPT_pid},
+			{"help", no_argument, NULL, '?'},
+			{NULL, 0, NULL, 0}
+		};
+
+		c = getopt_long (argc-1, argv+1, "+hp:",
+				long_options, &option_index);
+		if (c == -1)
+			break;
+		switch (c) {
+
+		case OPT_pid:
+		case 'p':
+			pid = atoi(optarg);
+			break;
+		case 'h':
+		case '?':
+		default:
+			usage(argv);
+		}
+	}
+
+	if (perf_run(pid) < 0)
+		printf("Failed to run perf\n");
+}
-- 
2.28.0

