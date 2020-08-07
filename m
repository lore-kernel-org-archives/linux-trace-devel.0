Return-Path: <SRS0=Thka=BR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 132ACC433E1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Aug 2020 12:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D881520866
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Aug 2020 12:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gb3rBnp9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgHGMHQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Aug 2020 08:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbgHGMHG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Aug 2020 08:07:06 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97500C06179E
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 Aug 2020 05:07:05 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c15so1433216wrs.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 Aug 2020 05:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=csEzAuP3ean2Jp0mTnPM+htImUkz22Uv0XCq/ZFQe8k=;
        b=Gb3rBnp9x230T9pjZZDA2GmSlarvAChVx4N9xLGs/46NHZCw/KSpSdHBQ0BSJOt9r0
         fM0nfxZfpTfXcMUYPsn0yr/B2op7zfQ3WcquiarOOUz0ZBefqDOvy2dQGnmZHP6EE/pX
         Bh4zdsGdUz9jSFOgWEcxkaPYYXTibBayG4PMiIPaHxDLOZdOSYAfhGwVA8HPclXyQsRD
         azDGDbLGSZA3yXGEwxMFHP0vBhNKJTdqDlI7jNHwCi5sBg7oRFuQ0UONV+18ih4tB6RY
         eR0APOw6AWo0C7uAIFBVSBxJFjpAJD5wPSVhhsPE/ephE9tV/gjuJ4y7+2Y6sKk/kgBP
         98SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=csEzAuP3ean2Jp0mTnPM+htImUkz22Uv0XCq/ZFQe8k=;
        b=G7ro0dND/wGX2PFr2QL75YzMkk+HiAOcLFYAhoTMtVRogWCusaPFKYn3vQ4u4mLZ4g
         kvl6NVeO7ClSSG+ZTlDG3LM4g5vgSjKIxpwCUb85I6tqVr3/kJmdZzvZmi5eB8yGAwiZ
         npyJ+5cu1mnnG8u3XtDfMRTNq+OOp7Eio0EkZn6SaYVg910zl3toUVvPRe2CYoX0HgB5
         dBCO0GQDbJg/UExAP4gmpgR4wESH0FRWfFFDe5el4muFLgfO4VZ+9tWflaqgk3Rm9qoO
         tifbc2iw9X4Pujzg3pzVE68lxwyUYxfT9hRv25dcmJUtZgE/Oab9W03JEs4mFVTCTU1A
         XqJA==
X-Gm-Message-State: AOAM533xjfcT/gqfojYuD9uaTZt0QBasZcmhs2IEPIgkGTStFnN1jcko
        VsxNfPtbqmhw2IMnQRyY5Kc=
X-Google-Smtp-Source: ABdhPJzSSgws8AH4UGsPguDZQxVL5uy2X3FUnxL1s3g0eEDV+S1aZ/LLY9/JWo7O1OV8aoUKqdjHIA==
X-Received: by 2002:adf:9526:: with SMTP id 35mr12579133wrs.326.1596802024052;
        Fri, 07 Aug 2020 05:07:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm10485303wmg.0.2020.08.07.05.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 05:07:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/4] trace-cmd: Add new subcomand "trace-cmd perf"
Date:   Fri,  7 Aug 2020 15:06:55 +0300
Message-Id: <20200807120655.797084-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200807120655.797084-1-tz.stoyanov@gmail.com>
References: <20200807120655.797084-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
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
 tracecmd/trace-perf.c          | 540 +++++++++++++++++++++++++++++++++
 4 files changed, 544 insertions(+)
 create mode 100644 tracecmd/trace-perf.c

diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index f9435558..64cd7430 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -32,6 +32,7 @@ TRACE_CMD_OBJS += trace-list.o
 TRACE_CMD_OBJS += trace-usage.o
 TRACE_CMD_OBJS += trace-dump.o
 TRACE_CMD_OBJS += trace-obj-debug.o
+TRACE_CMD_OBJS += trace-perf.o
 ifeq ($(VSOCK_DEFINED), 1)
 TRACE_CMD_OBJS += trace-tsync.o
 endif
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index ccae61d4..2ab915ac 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -101,6 +101,8 @@ void trace_usage(int argc, char **argv);
 
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
index 00000000..0b100aa0
--- /dev/null
+++ b/tracecmd/trace-perf.c
@@ -0,0 +1,540 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2019, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
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
+
+
+#include "trace-local.h"
+#include "trace-cmd-local.h"
+
+#define BUF_SHIFT	8
+
+struct perf_stat {
+	__u64 count;
+	__u64 time_enabled;
+	__u64 time_running;
+	__u64 id;
+};
+
+struct perf_cpu {
+	int cpu;
+	int fd;
+	char *file;
+	pthread_t tid;
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
+	uint64_t id; //PERF_SAMPLE_IDENTIFIER
+	uint32_t pid, tid; //PERF_SAMPLE_TID
+	uint64_t time; //PERF_SAMPLE_TIME
+	uint32_t cpu, res; // PERF_SAMPLE_CPU
+	uint64_t period; // PERF_SAMPLE_PERIOD
+	uint64_t nr;
+	uint64_t ips[]; // PERF_SAMPLE_CALLCHAIN
+} __attribute__((packed));
+
+static void handle_event(struct perf_event_sample *sample,
+			 struct perf_cpu *cpu, int fd)
+{
+	int i;
+#if 0
+	printf(" Sample %d/%ld %d %d\n", sample->head.size,
+					  sizeof(struct perf_event_sample),
+					  sample->head.type, sample->head.misc);
+	printf("  ID %ld, TID (%d, %d), TIME %ld, CPU (%d, %d), PERIOD %ld, STACK %ld\n    ",
+			sample->id, sample->pid, sample->tid, sample->time,
+			sample->cpu, sample->res, sample->period, sample->nr);
+#endif
+	write(fd, &sample->time, sizeof(uint64_t));
+	write(fd, &sample->nr, sizeof(uint64_t));
+	for (i = 0; i < sample->nr; i++) {
+		write(fd, &sample->ips[i], sizeof(uint64_t));
+//		printf("0x%lx ", sample->ips[i]);
+	}
+//	printf("\n");
+}
+
+static void perf_event_read(struct perf_cpu *cpu, int fd)
+{
+	struct perf_event_header *header;
+	int rd = 0, all = 0;
+	unsigned char *data;
+
+
+	data = (unsigned char *)cpu->mpage + getpagesize();
+
+	while (cpu->mpage->data_tail != cpu->mpage->data_head) {
+		while (cpu->mpage->data_tail >= BUF_SHIFT * getpagesize())
+			cpu->mpage->data_tail -= BUF_SHIFT * getpagesize();
+
+		header = (struct perf_event_header *)(data + cpu->mpage->data_tail);
+		if (header->size == 0)
+			break;
+
+		cpu->mpage->data_tail += header->size;
+
+		while (cpu->mpage->data_tail >= BUF_SHIFT * getpagesize())
+			cpu->mpage->data_tail -= BUF_SHIFT * getpagesize();
+		all++;
+		if (header->type == PERF_RECORD_SAMPLE) {
+			rd++;
+			handle_event((struct perf_event_sample *)header, cpu, fd);
+		}
+	}
+	cpu->mpage->data_tail = cpu->mpage->data_head;
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
+	pe->sample_freq = 1000;
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
+		ret = ioctl(perf->fd, PERF_EVENT_IOC_RESET, 0);
+		ret = ioctl(perf->fd, PERF_EVENT_IOC_ENABLE, 0);
+	} else
+		ret = ioctl(perf->fd, PERF_EVENT_IOC_DISABLE, 0);
+
+	return ret;
+}
+
+static int perf_mmap(struct perf_cpu *perf)
+{
+	/* associate a buffer with the file */
+	perf->mpage = mmap(NULL, (BUF_SHIFT + 1)*getpagesize(),
+			PROT_READ | PROT_WRITE, MAP_SHARED, perf->fd, 0);
+	if (perf->mpage == MAP_FAILED)
+		return -1;
+	return 0;
+}
+
+static void perf_dump_stat(struct perf_cpu *perf)
+{
+	struct perf_stat stat;
+	int ret;
+
+	ret = read(perf->fd, &stat, sizeof(stat));
+	if (ret > 0)
+		printf("cpu %d: %lld %lld %lld %lld\n",
+			perf->cpu, stat.count,
+			stat.time_enabled, stat.time_running,
+			stat.id);
+}
+
+static void perf_session_destroy(struct perf_session *perf)
+{
+	int i;
+
+	if (perf->cpu_count && perf->cpus) {
+		for (i = 0; i < perf->cpu_count; i++) {
+			if (perf->cpus[i].fd >= 0)
+				close(perf->cpus[i].fd);
+			if (perf->cpus[i].mpage)
+				munmap(perf->cpus[i].mpage,
+				       (BUF_SHIFT + 1)*getpagesize());
+			if (perf->cpus[i].file) {
+				remove(perf->cpus[i].file);
+				free(perf->cpus[i].file);
+			}
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
+	template = strdup(TMP_FILE);
+	if (!template)
+		return NULL;
+	perf = calloc(cpus, sizeof(struct perf_session));
+	if (!perf)
+		return NULL;
+	perf->fdebug = trace_debug_obj_create_pid(pid);
+	if (!perf->fdebug)
+		goto error;
+	perf->cpus = calloc(cpus, sizeof(struct perf_cpu));
+	if (!cpus)
+		goto error;
+	for (i = 0; i < cpus; i++)
+		perf->cpus[i].fd = -1;
+
+	perf_init_pe(&pe);
+	for (i = 0; i < cpus; i++) {
+		perf->cpus[i].fd = perf_event_open(&pe, pid, i, -1, 0);
+		if (perf->cpus[i].fd < 0)
+			goto error;
+		fcntl(perf->cpus[i].fd, F_SETFL, O_NONBLOCK);
+		perf->cpus[i].cpu = i;
+		if (perf_mmap(&perf->cpus[i]) < 0)
+			goto error;
+		strcpy(template, TMP_FILE);
+		mktemp(template);
+		perf->cpus[i].file = strdup(template);
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
+	struct perf_stat stat;
+	fd_set rset;
+	int ret;
+	int fd;
+
+	fd = open(cpu->file, O_WRONLY|O_CREAT|O_TRUNC, 0600);
+	if (fd < 0)
+		return NULL;
+
+	perf_enable(cpu, true);
+
+	while (1) {
+//		FD_ZERO(&rset);
+//		FD_SET(cpu->fd, &rset);
+//		ret = select(cpu->fd + 1, &rset, NULL, NULL, NULL);
+		ret = read(cpu->fd, &stat, sizeof(stat));
+//		if ( ret > 0 && stat.count > 0) {
+//			printf("Got %lld on CPU %d\n", stat.count, cpu->cpu);
+			perf_event_read(cpu, fd);
+//		}
+	}
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
+	unsigned long long time, count, ip;
+	int fd, i;
+	int ret;
+
+	fd = open(perf->cpus[cpu].file, O_RDONLY, 0600);
+	if (fd < 0)
+		return;
+	do {
+		ret = read(fd, &time, sizeof(time));
+		if (ret != sizeof(time))
+			break;
+
+		ret = read(fd, &count, sizeof(count));
+		if (ret != sizeof(count))
+			break;
+
+		printf(" %lld %lld: ", time, count);
+		for (i = 0; i < count; i++) {
+			ret = read(fd, &ip, sizeof(ip));
+			if (ret != sizeof(ip))
+				break;
+			ret = trace_debug_add_resolve_symbol(perf->fdebug, ip, NULL);
+			if (ret < 0)
+				printf("0x%llx(unknown) ", ip);
+			else
+				printf("0x%llx ", ip);
+		}
+		printf("\n");
+		if (i < count)
+			break;
+	} while (1);
+	close(fd);
+}
+
+static int perf_collect(struct perf_session *perf)
+{
+	int i;
+
+	if (perf_run_readers(perf))
+		return -1;
+
+	printf("Collecting callstack of pid %d\n", perf->pid);
+	sleep(2);
+
+	for (i = 0; i < perf->cpu_count; i++)
+		perf_enable(&perf->cpus[i], false);
+
+	perf_stop_readers(perf);
+
+	for (i = 0; i < perf->cpu_count; i++) {
+		perf_dump_stat(&perf->cpus[i]);
+		perf_collect_results(perf, i);
+	}
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
+	perf_run(pid);
+}
-- 
2.26.2

