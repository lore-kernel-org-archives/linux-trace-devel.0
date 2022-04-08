Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33400C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Apr 2022 10:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbiDHKGW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 06:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbiDHKGJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 06:06:09 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79DDB823E
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Apr 2022 03:03:46 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id qh7so16203683ejb.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Apr 2022 03:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YLlUYDm8ZLWPWaM7h/AAbMyzjj5HGrmEPwefg0i7QWA=;
        b=FdlsThnzMepxHrMMr5lfirZTTDEz19nuJMom97koOqnaZaoq+bD6Lwg4tFL417oxdu
         72g/PvH7QWm7ebwlWDu0Lu0SHy/JpBTxFmJGxKf7DJ+OtQ6LIG5sPRVzO1OuligHdtK1
         3CVBUpkWy+oXTLJKSBEM4s7BlNqJ8uvbVy7SOEr8AJYuJVmitnC8MUcF61k3AjnjqYRW
         K3JChs1lQDF9xG5o6HYSuSVKFgl1LGYx7+al5E8xSMIgEf8OXBBUAxP4Hc8YkRjVAGeG
         WJKYfkVW1//DJNjJi6BMjuKvu5jdfrpfVR6YXY7SbCJlyVPgSQwgXlRh3+4+Rbcjskob
         Nc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YLlUYDm8ZLWPWaM7h/AAbMyzjj5HGrmEPwefg0i7QWA=;
        b=H4sFUxlAfnyeciySIyGMTqljNQZMv2q+NwNqFd8IEER5LpuUjbDyF4/+GYha7LsrXJ
         rHw1sb/L16MWpN9f6Ta9Bq0ZCh0ZbmX7upKT/fUBiEAdBRWty2GDrGkcQoG2tPbpVEVP
         3k4I4zv3VK46lry+jUWKLPPZ3paUFViybn2L+eHKqtWHEXm9Remxk0oVCJX8aE93WV0D
         8ZqnCgqcSQBnnunEPQUGm745WhsoC+stxVrmda/OY5M3bfliHgzY1TViiwhNycsFQoBc
         DFySX/2lDmhPSVNjNfcE+kWGcdPCGi3wawITj7tGpKxTIRjJqM/XvMMVUD4b/9vda2St
         fgyQ==
X-Gm-Message-State: AOAM5317gFhRTxILA9XYFrWcQ2qYT+vEKgRBxXUDuvdRZ42Ty+ZFVOiX
        P0trT+tUxPUQ6AhLHHRTuPxJmtXdZCM=
X-Google-Smtp-Source: ABdhPJxJwwTxLZimy04l9J01KxXc/327bctTlDbxO5edLgaunBINra/B0PEqUCjMkaPcNMMT1pbgiw==
X-Received: by 2002:a17:906:154c:b0:6ce:21d7:2826 with SMTP id c12-20020a170906154c00b006ce21d72826mr17309584ejd.9.1649412224988;
        Fri, 08 Apr 2022 03:03:44 -0700 (PDT)
Received: from oberon.zico.biz.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l17-20020a056402231100b0041d0718a3e3sm1860369eda.23.2022.04.08.03.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 03:03:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH v2 2/3] trace-cruncher: Support for perf
Date:   Fri,  8 Apr 2022 13:03:38 +0300
Message-Id: <20220408100339.594358-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220408100339.594358-1-tz.stoyanov@gmail.com>
References: <20220408100339.594358-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initial perf support for trace-cruncher, using libperf. As a first
stage, collecting of stack trace samples of given process is supported.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 setup.py           |   9 +-
 src/perfpy-utils.c | 896 +++++++++++++++++++++++++++++++++++++++++++++
 src/perfpy-utils.h |  43 +++
 src/perfpy.c       | 141 +++++++
 4 files changed, 1087 insertions(+), 2 deletions(-)
 create mode 100644 src/perfpy-utils.c
 create mode 100644 src/perfpy-utils.h
 create mode 100644 src/perfpy.c

diff --git a/setup.py b/setup.py
index 21c627f..8f9d006 100644
--- a/setup.py
+++ b/setup.py
@@ -41,7 +41,8 @@ def third_party_paths():
     include_dirs = [np.get_include()]
     libs_required = [('libtraceevent', '1.5.0'),
                      ('libtracefs',    '1.3.0'),
-                     ('libkshark',     '2.0.1')]
+                     ('libkshark',     '2.0.1'),
+                     ('libperf',     '0.0.1')]
     libs_found = []
 
     for lib in libs_required:
@@ -83,6 +84,10 @@ def main():
                           sources=['src/ksharkpy.c', 'src/ksharkpy-utils.c'],
                           libraries=['kshark'])
 
+    module_perf = extension(name='tracecruncher.perfpy',
+                            sources=['src/perfpy.c', 'src/perfpy-utils.c', 'src/trace-obj-debug.c'],
+                            libraries=['traceevent', 'perf', 'bfd'])
+
     setup(name='tracecruncher',
           version='0.2.0',
           description='Interface for accessing Linux tracing data in Python.',
@@ -91,7 +96,7 @@ def main():
           url='https://github.com/vmware/trace-cruncher',
           license='LGPL-2.1',
           packages=find_packages(),
-          ext_modules=[module_ft, module_data, module_ks],
+          ext_modules=[module_ft, module_data, module_ks, module_perf],
           classifiers=[
               'Development Status :: 4 - Beta',
               'Programming Language :: Python :: 3',
diff --git a/src/perfpy-utils.c b/src/perfpy-utils.c
new file mode 100644
index 0000000..4d30596
--- /dev/null
+++ b/src/perfpy-utils.c
@@ -0,0 +1,896 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
+ */
+
+#ifndef _GNU_SOURCE
+/** Use GNU C Library. */
+#define _GNU_SOURCE
+#endif // _GNU_SOURCE
+
+// C
+#include <stdio.h>
+#include <unistd.h>
+#include <pthread.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <fcntl.h>
+#include <dirent.h>
+#include <sys/resource.h>
+#include <semaphore.h>
+#include <signal.h>
+
+// libperf
+#include <linux/perf_event.h>
+#include <perf/evlist.h>
+#include <perf/evsel.h>
+#include <perf/cpumap.h>
+#include <perf/threadmap.h>
+#include <perf/mmap.h>
+#include <perf/core.h>
+#include <perf/event.h>
+
+// trace-cruncher
+#include "perfpy-utils.h"
+#include "trace-obj-debug.h"
+
+PyObject * PERF_ERROR;
+
+#define TMP_FILE "/tmp/perf_temp_data.XXXXXX"
+
+struct perf_scan_thread {
+	uint32_t tid;
+	char *comm;
+	struct perf_counts_values count;
+};
+
+struct perf_handle {
+	bool running;
+	bool debug_resolved;
+	pthread_t reader;
+	int fd;
+	int thr_count;
+	uint32_t pid;
+	uint32_t trace_time; /* in msec */
+	char *command;
+	char **argv;
+	struct perf_scan_thread *thr_map;
+	struct perf_evlist *evlist;
+	struct perf_evsel *evsel;
+	struct perf_event_attr attr;
+	struct perf_cpu_map *cpus;
+	struct dbg_trace_context *debug;
+	struct perf_thread_map *threads;
+};
+
+struct event_sample {
+	uint64_t		id;		/* PERF_SAMPLE_IDENTIFIER */
+	uint64_t		ip;		/* PERF_SAMPLE_IP */
+	uint32_t		pid, tid;	/* PERF_SAMPLE_TID */
+	uint64_t		time;		/* PERF_SAMPLE_TIME */
+	uint32_t		cpu, res;	/* PERF_SAMPLE_CPU */
+	uint64_t		nr;
+	uint64_t		ips[];		/* PERF_SAMPLE_CALLCHAIN */
+} __attribute__((packed));
+
+struct perf_event_sample {
+	struct event_sample	data;
+	struct perf_handle	*perf;
+	char			*ip;
+	char			*ips[];
+} __attribute__((packed));
+
+int py_perf_handle_destroy(struct perf_handle *perf)
+{
+	if (!perf || !perf->running)
+		return 0;
+
+	perf->running = false;
+	pthread_join(perf->reader, NULL);
+	fsync(perf->fd);
+	if (perf->command && perf->pid > 0) {
+		kill(perf->pid, SIGINT);
+		perf->pid = 0;
+	}
+
+	return 0;
+}
+
+void py_perf_handle_free(struct perf_handle *perf)
+{
+	int i;
+
+	if (!perf)
+		return;
+
+	if (perf->evlist)
+		perf_evlist__delete(perf->evlist);
+	if (perf->fd >= 0)
+		close(perf->fd);
+	if (perf->debug)
+		dbg_trace_context_destroy(perf->debug);
+	if (perf->cpus)
+		perf_cpu_map__put(perf->cpus);
+	if (perf->threads)
+		perf_thread_map__put(perf->threads);
+	if (perf->thr_map) {
+		for (i = 0; i < perf->thr_count; i++)
+			free(perf->thr_map[i].comm);
+		free(perf->thr_map);
+	}
+	if (perf->argv) {
+		i = 0;
+		while (perf->argv[i])
+			free(perf->argv[i++]);
+		free(perf->argv);
+	}
+	free(perf->command);
+
+	free(perf);
+}
+
+void py_perf_sample_free(struct perf_event_sample *sample)
+{
+	unsigned int i;
+
+	if (sample) {
+		free(sample->ip);
+		for (i = 0; i < sample->data.nr; i++)
+			free((char *)(sample->ips[i]));
+	}
+	free(sample);
+}
+
+static int pid_filter(const struct dirent *dir)
+{
+	const char *dname = dir->d_name;
+
+	if (!dname || dname[0] == '.')
+		return 0;
+
+	while (*dname) {
+		if (!isdigit(*dname))
+			return 0;
+		dname++;
+	}
+
+	return 1;
+}
+
+static  int str_read_file(const char *file, char **buffer)
+{
+	char stbuf[BUFSIZ];
+	char *buf = NULL;
+	int size = 0;
+	char *nbuf;
+	int fd;
+	int r;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	do {
+		r = read(fd, stbuf, BUFSIZ);
+		if (r <= 0)
+			continue;
+		nbuf = realloc(buf, size+r+1);
+		if (!nbuf) {
+			size = -1;
+			break;
+		}
+		buf = nbuf;
+		memcpy(buf+size, stbuf, r);
+		size += r;
+	} while (r > 0);
+
+	close(fd);
+	if (r == 0 && size > 0) {
+		buf[size] = '\0';
+		*buffer = buf;
+	} else
+		free(buf);
+
+	return size;
+}
+
+static void strip_control_chars(char *str)
+{
+	while (*str) {
+		if (iscntrl(*str)) {
+			*str = '\0';
+			break;
+		}
+		str++;
+	}
+}
+
+static struct perf_thread_map *create_thread_map(struct perf_handle *perf)
+{
+	struct perf_thread_map *tmap = NULL;
+	struct dirent **pids = NULL;
+	char path[PATH_MAX];
+	int i, count;
+
+	snprintf(path, PATH_MAX, "/proc/%d/task", perf->pid);
+	count = scandir(path, &pids, pid_filter, NULL);
+	if (count < 1)
+		goto out;
+
+	tmap = perf_thread_map__new_array(count, NULL);
+	if (!tmap)
+		goto out;
+	free(perf->thr_map);
+	perf->thr_map = calloc(count, sizeof(struct perf_scan_thread));
+	if (!perf->thr_map)
+		goto out;
+	perf->thr_count = count;
+
+	for (i = 0; i < count; i++) {
+		perf->thr_map[i].tid = atoi(pids[i]->d_name);
+		perf_thread_map__set_pid(tmap, i, perf->thr_map[i].tid);
+		snprintf(path, PATH_MAX, "/proc/%d/task/%s/comm", perf->pid, pids[i]->d_name);
+		str_read_file(path, &perf->thr_map[i].comm);
+		strip_control_chars(perf->thr_map[i].comm);
+	}
+
+out:
+	if (pids) {
+		for (i = 0; i < count; i++)
+			free(pids[i]);
+		free(pids);
+	}
+
+	return tmap;
+}
+
+static struct perf_handle *new_perf_sampling_handle(int freq, pid_t pid, char *command, char **argv)
+{
+	struct perf_handle *perf = NULL;
+	char *tmp_file = NULL;
+
+	perf = calloc(1, sizeof(*perf));
+	if (!perf)
+		return NULL;
+
+	perf->fd = -1;
+	perf->attr.type        = PERF_TYPE_HARDWARE;
+	perf->attr.config      = PERF_COUNT_HW_CPU_CYCLES;
+	perf->attr.disabled    = 1;
+	perf->attr.freq        = 1;
+	perf->attr.sample_freq = freq;
+	perf->attr.exclude_kernel = 1;
+	perf->attr.exclude_idle = 1;
+	perf->attr.exclude_callchain_kernel = 1;
+	perf->attr.comm = 1;
+	perf->attr.mmap2 = 1;
+	perf->attr.task = 1;
+	perf->attr.precise_ip = 0;
+	perf->attr.inherit = 1;
+	perf->attr.task = 1;
+	perf->attr.inherit_stat = 1;
+	perf->attr.read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
+				 PERF_FORMAT_TOTAL_TIME_RUNNING;
+	perf->attr.sample_type = PERF_SAMPLE_IDENTIFIER |
+				 PERF_SAMPLE_IP |
+				 PERF_SAMPLE_TID |
+				 PERF_SAMPLE_TIME |
+				 PERF_SAMPLE_CPU |
+				 PERF_SAMPLE_CALLCHAIN;
+
+	/* trace all CPUs in the system */
+	perf->cpus = perf_cpu_map__new(NULL);
+	if (!perf->cpus)
+		goto error;
+
+	if (command) {
+		perf->command = strdup(command);
+		if (!perf->command)
+			goto error;
+		perf->argv = argv;
+		perf->debug = dbg_trace_context_create_file(command, true);
+	} else {
+		perf->pid = pid;
+		perf->debug = dbg_trace_context_create_pid(pid, true);
+	}
+	if (!perf->debug)
+		goto error;
+	perf->debug_resolved = false;
+
+	perf->evlist = perf_evlist__new();
+	if (!perf->evlist)
+		goto error;
+
+	tmp_file = strdup(TMP_FILE);
+	if (!tmp_file)
+		goto error;
+
+	mktemp(tmp_file);
+	perf->fd = open(tmp_file, O_RDWR|O_CREAT|O_TRUNC, 0600);
+	unlink(tmp_file);
+	if (perf->fd < 0)
+		goto error;
+
+	perf->evsel = perf_evsel__new(&perf->attr);
+	if (!perf->evsel)
+		goto error;
+
+	perf_evlist__add(perf->evlist, perf->evsel);
+
+	free(tmp_file);
+	return perf;
+
+error:
+	py_perf_handle_free(perf);
+	free(tmp_file);
+	return NULL;
+}
+
+PyObject *PyPerfSampler_new(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	char *kwlist[] = {"pid", "command", "freq", "argv", NULL};
+	PyObject *py_perf, *py_arg, *py_args = NULL;
+	struct perf_handle *perf = NULL;
+	int freq = 10, pid = 0;
+	char *command = NULL;
+	char **argv = NULL;
+	int i, argc;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "|isiO",
+					 kwlist,
+					 &pid,
+					 &command,
+					 &freq,
+					 &py_args
+					 )) {
+		return NULL;
+	}
+
+	if (pid == 0 && !command) {
+		PyErr_Format(PERF_ERROR, "PID or command must be specified");
+		return NULL;
+	}
+
+	if (command && py_args) {
+		if (!PyList_CheckExact(py_args)) {
+			PyErr_SetString(PERF_ERROR, "Failed to parse argv list");
+			return NULL;
+		}
+		argc = PyList_Size(py_args);
+		argv = calloc(argc + 1, sizeof(char *));
+		for (i = 0; i < argc; i++) {
+			py_arg = PyList_GetItem(py_args, i);
+			if (!PyUnicode_Check(py_arg))
+				continue;
+			argv[i] = strdup(PyUnicode_DATA(py_arg));
+			if (!argv[i])
+				return NULL;
+		}
+		argv[i] = NULL;
+	}
+
+	perf = new_perf_sampling_handle(freq, pid, command, argv);
+
+	if (!perf) {
+		PyErr_SetString(PERF_ERROR, "Failed create new perf context");
+		return NULL;
+	}
+
+	py_perf = PyPerf_New(perf);
+
+	return py_perf;
+}
+
+static void perf_read_sample(struct perf_handle *perf, struct perf_record_sample *event)
+{
+	struct event_sample *sample;
+	uint64_t i;
+
+	sample = (struct event_sample *)(event->array);
+
+	/* check if the sample is for our PID */
+	if (sample->pid != perf->pid)
+		return;
+
+	if (perf->debug)
+		dbg_trace_add_resolve_symbol(perf->debug, sample->ip, NULL, 0);
+
+	if (write(perf->fd, sample, sizeof(*sample)) != sizeof(*sample))
+		return;
+
+	for (i = 0; i < sample->nr; i++) {
+		if (write(perf->fd, &sample->ips[i], sizeof(uint64_t)) != sizeof(uint64_t))
+			return;
+		if (perf->debug)
+			dbg_trace_add_resolve_symbol(perf->debug, sample->ips[i], NULL, 0);
+	}
+}
+
+/* A new memory is mapped to traced process */
+static void perf_read_mmap2(struct perf_handle *perf, struct perf_record_mmap2 *mmap)
+{
+	/* check if mmap is for our PID */
+	if (perf->pid != mmap->pid)
+		return;
+
+	/* check if executable memory is mapped */
+	if (mmap->header.misc & PERF_RECORD_MISC_MMAP_DATA)
+		return;
+
+	/*
+	 * A new dynamic library is dlopen() by the traced process,
+	 * store it for vma -> name resolving
+	 */
+	dbg_trace_context_add_file(perf->debug, mmap->filename,
+				   mmap->start, mmap->start + mmap->len, mmap->pgoff);
+}
+
+/* A new thread is started */
+static void perf_read_comm(struct perf_handle *perf, struct perf_record_comm *comm)
+{
+	struct perf_scan_thread *tmp;
+	int i;
+
+	/* check if the thread is started by PID */
+	if (perf->pid != comm->pid)
+		return;
+
+	for (i = 0; i < perf->thr_count; i++) {
+		if (perf->thr_map[i].tid == comm->tid) {
+			free(perf->thr_map[i].comm);
+			perf->thr_map[i].comm = strdup(comm->comm);
+			return;
+		}
+	}
+
+	tmp = realloc(perf->thr_map, (perf->thr_count + 1) * sizeof(struct perf_scan_thread));
+	if (!tmp)
+		return;
+
+	perf->thr_map = tmp;
+	perf->thr_map[perf->thr_count].tid = comm->tid;
+	perf->thr_map[perf->thr_count].comm = strdup(comm->comm);
+	perf->thr_count++;
+}
+
+static void *perf_reader_thread(void *data)
+{
+	struct perf_handle *perf = data;
+	struct perf_mmap *map;
+	union perf_event *event;
+
+	perf_evlist__enable(perf->evlist);
+
+	while (true) {
+		if (!perf->running)
+			break;
+		perf_evlist__for_each_mmap(perf->evlist, map, false) {
+			if (perf_mmap__read_init(map) < 0)
+				continue;
+
+			while ((event = perf_mmap__read_event(map)) != NULL) {
+
+				switch (event->sample.header.type) {
+				case PERF_RECORD_SAMPLE:
+					perf_read_sample(perf, (struct perf_record_sample *)event);
+					break;
+				case PERF_RECORD_COMM:
+					perf_read_comm(perf, (struct perf_record_comm *)event);
+					break;
+				case PERF_RECORD_MMAP2:
+					perf_read_mmap2(perf, (struct perf_record_mmap2 *)event);
+					break;
+				}
+
+				perf_mmap__consume(map);
+			}
+
+			perf_mmap__read_done(map);
+		}
+	}
+	perf_evlist__disable(perf->evlist);
+	pthread_exit(0);
+}
+
+static int increase_file_limit(void)
+{
+	struct rlimit lim;
+
+	if (getrlimit(RLIMIT_NOFILE, &lim))
+		return -1;
+
+	if (lim.rlim_cur < lim.rlim_max) {
+		lim.rlim_cur = lim.rlim_max;
+	} else {
+		lim.rlim_cur += 100;
+		lim.rlim_max += 100;
+	}
+
+	return setrlimit(RLIMIT_NOFILE, &lim);
+}
+
+static int perf_maps_init(struct perf_handle *perf)
+{
+	int ret;
+
+	if (!perf->threads)
+		perf->threads = create_thread_map(perf);
+	if (!perf->threads)
+		return -1;
+
+	perf_evlist__set_maps(perf->evlist, perf->cpus, perf->threads);
+	do {
+		ret = perf_evlist__open(perf->evlist);
+		if (!ret)
+			break;
+		if (ret != -EMFILE)
+			goto out;
+		ret = increase_file_limit();
+		if (ret)
+			goto out;
+	} while (ret);
+
+	ret = perf_evlist__mmap(perf->evlist, 4);
+out:
+	if (ret)
+		perf_evlist__close(perf->evlist);
+	return ret;
+}
+
+static int perf_reader_start(struct perf_handle *perf)
+{
+	pthread_attr_t attrib;
+	int ret;
+
+	pthread_attr_init(&attrib);
+	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
+	ret = pthread_create(&perf->reader, &attrib, perf_reader_thread, perf);
+	if (!ret)
+		perf->running = true;
+
+	pthread_attr_destroy(&attrib);
+	return ret;
+}
+
+#define PERF_EXEC_SYNC	"/TC_PERF_SYNC_XXXXXX"
+static int perf_run_cmd(struct perf_handle *perf)
+{
+	char *envp[] = {NULL};
+	char sname[strlen(PERF_EXEC_SYNC) + 1];
+	sem_t *sem;
+	pid_t pid;
+	int ret;
+
+	strcpy(sname, PERF_EXEC_SYNC);
+	mktemp(sname);
+	sem = sem_open(sname, O_CREAT | O_EXCL, 0644, 0);
+	sem_unlink(sname);
+
+	pid = fork();
+	if (pid < 0)
+		return -1;
+	if (pid == 0) {
+		sem_wait(sem);
+		execvpe(perf->command, perf->argv, envp);
+	} else {
+		perf->pid = pid;
+		ret = perf_maps_init(perf);
+		if (!ret)
+			ret = perf_reader_start(perf);
+		sem_post(sem);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int perf_start_sampling(struct perf_handle *perf)
+{
+	int ret;
+
+	if (perf->running)
+		return 0;
+
+	if (perf->command)
+		return perf_run_cmd(perf);
+
+	ret = perf_maps_init(perf);
+	if (!ret)
+		ret = perf_reader_start(perf);
+
+	return ret;
+}
+
+static bool sampling_run;
+
+static void sampling_stop(int sig)
+{
+	sampling_run = false;
+}
+
+static void sampling_timer(int sig, siginfo_t *si, void *uc)
+{
+	sampling_run = false;
+}
+
+#define PID_WAIT_CHECK_USEC	500000
+#define TIMER_SEC_NANO		1000000000LL
+static int perf_wait_pid(struct perf_handle *perf)
+{
+	struct itimerspec tperiod = {0};
+	struct sigaction saction = {0};
+	struct sigevent stime = {0};
+	timer_t timer_id;
+
+	if (perf->pid == 0)
+		return -1;
+
+	sampling_run = true;
+	signal(SIGINT, sampling_stop);
+
+	if (perf->trace_time) {
+		stime.sigev_notify = SIGEV_SIGNAL;
+		stime.sigev_signo = SIGRTMIN;
+		if (timer_create(CLOCK_MONOTONIC, &stime, &timer_id))
+			return -1;
+		saction.sa_flags = SA_SIGINFO;
+		saction.sa_sigaction = sampling_timer;
+		sigemptyset(&saction.sa_mask);
+		if (sigaction(SIGRTMIN, &saction, NULL)) {
+			timer_delete(timer_id);
+			return -1;
+		}
+		/* covert trace_time from msec to sec, nsec */
+		tperiod.it_value.tv_nsec = ((unsigned long long)perf->trace_time * 1000000LL);
+		if (tperiod.it_value.tv_nsec >= TIMER_SEC_NANO) {
+			tperiod.it_value.tv_sec = tperiod.it_value.tv_nsec / TIMER_SEC_NANO;
+			tperiod.it_value.tv_nsec %= TIMER_SEC_NANO;
+		}
+		if (timer_settime(timer_id, 0, &tperiod, NULL))
+			return -1;
+	}
+
+	do {
+		if (perf->command) { /* wait for a child */
+			if (waitpid(perf->pid, NULL, WNOHANG) == (int)perf->pid) {
+				perf->pid = 0;
+				sampling_run = false;
+			}
+		} else { /* not a child, check if still exist */
+			if (kill(perf->pid, 0) == -1 && errno == ESRCH) {
+				perf->pid = 0;
+				sampling_run = false;
+			}
+		}
+		usleep(PID_WAIT_CHECK_USEC);
+	} while (sampling_run);
+
+	if (perf->trace_time)
+		timer_delete(timer_id);
+
+	signal(SIGINT, SIG_DFL);
+
+	return 0;
+}
+
+PyObject *PyPerf_enable(PyPerf *self, PyObject *args, PyObject *kwargs)
+{
+	char *kwlist[] = {"wait", "time", NULL};
+	struct perf_handle *perf = self->ptrObj;
+	int wait = false;
+	int ret;
+
+	if (perf->running) {
+		PyErr_Format(PERF_ERROR, "Perf sampling is already started");
+		return NULL;
+	}
+
+	perf->trace_time = 0;
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "|pi",
+					 kwlist,
+					 &wait,
+					 &perf->trace_time)) {
+		return NULL;
+	}
+
+	ret = perf_start_sampling(perf);
+	if (ret) {
+		PyErr_Format(PERF_ERROR,
+			     "Failed to start perf sampling - %s", strerror(-ret));
+		return NULL;
+	}
+
+	if (wait) {
+		perf_wait_pid(perf);
+		py_perf_handle_destroy(perf);
+	}
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyPerf_disable(PyPerf *self)
+{
+	struct perf_handle *perf = self->ptrObj;
+
+	if (!perf->running) {
+		PyErr_Format(PERF_ERROR, "Perf reader is not started");
+		return NULL;
+	}
+
+	py_perf_handle_destroy(perf);
+
+	Py_RETURN_NONE;
+}
+
+struct symb_walk {
+	uint64_t ip;
+	char *name;
+};
+
+static int sym_get(struct dbg_trace_symbols *symb, void *data)
+{
+	struct symb_walk *s = (struct symb_walk *)data;
+
+	if (s->ip == symb->vma_near) {
+		if (symb->name)
+			asprintf(&s->name, "%s @ %s", symb->name, symb->fname);
+		else
+			asprintf(&s->name, "(0x%llX) @ %s", symb->vma_near, symb->fname);
+		return 1;
+	}
+	return 0;
+}
+
+static char *ip_name(struct perf_handle *perf, uint64_t ip)
+{
+	struct symb_walk symb;
+
+	symb.ip = ip;
+	symb.name = NULL;
+	if (perf && perf->debug)
+		dbg_trace_walk_resolved_symbols(perf->debug, sym_get, &symb);
+
+	if (!symb.name)
+		asprintf(&symb.name, "0x%lX", ip);
+
+	return symb.name;
+}
+
+PyObject *PyPerf_getSamples(PyPerf *self)
+{
+	struct perf_handle *perf = self->ptrObj;
+	struct event_sample sample;
+	struct perf_event_sample *store;
+	PyObject *slist, *sobject;
+	uint64_t i, ip;
+	int ca = 0, cs = 0;
+
+	if (perf->running) {
+		PyErr_Format(PERF_ERROR, "Perf reader is running");
+		return NULL;
+	}
+
+	if (perf->debug && !perf->debug_resolved) {
+		dbg_trace_resolve_symbols(perf->debug);
+		perf->debug_resolved = true;
+	}
+
+	if (lseek(perf->fd, 0, SEEK_SET) == (off_t)-1) {
+		PyErr_Format(PERF_ERROR, "No samples");
+		return NULL;
+	}
+
+	slist = PyList_New(0);
+	do {
+		if (read(perf->fd, &sample, sizeof(sample)) != sizeof(sample))
+			break;
+		ca++;
+		store = calloc(1, sizeof(*store) + (sample.nr * sizeof(char *)));
+		if (!store)
+			break;
+		memcpy(&store->data, &sample, sizeof(sample));
+		store->perf = perf;
+		store->ip = ip_name(perf, store->data.ip);
+		for (i = 0; i < sample.nr; i++) {
+			if (read(perf->fd, &ip, sizeof(uint64_t)) != sizeof(uint64_t))
+				break;
+			store->ips[i] = ip_name(perf, ip);
+		}
+		cs += sample.nr;
+		if (i < sample.nr)
+			break;
+		sobject = PyPerfEventSampler_New(store);
+		PyList_Append(slist, sobject);
+	} while (true);
+	ftruncate(perf->fd, 0);
+	return slist;
+}
+
+PyObject *PyPerfSampler_id(PyPerfEventSampler *self)
+{
+	struct perf_event_sample *sample = self->ptrObj;
+
+	return PyLong_FromUnsignedLongLong(sample->data.id);
+}
+
+PyObject *PyPerfSampler_pid(PyPerfEventSampler *self)
+{
+	struct perf_event_sample *sample = self->ptrObj;
+
+	return PyLong_FromUnsignedLong(sample->data.pid);
+}
+
+PyObject *PyPerfSampler_tid(PyPerfEventSampler *self)
+{
+	struct perf_event_sample *sample = self->ptrObj;
+
+	return PyLong_FromUnsignedLong(sample->data.tid);
+}
+
+PyObject *PyPerfSampler_time(PyPerfEventSampler *self)
+{
+	struct perf_event_sample *sample = self->ptrObj;
+
+	return PyLong_FromUnsignedLongLong(sample->data.time);
+}
+
+PyObject *PyPerfSampler_cpu(PyPerfEventSampler *self)
+{
+	struct perf_event_sample *sample = self->ptrObj;
+
+	return PyLong_FromUnsignedLong(sample->data.cpu);
+}
+
+PyObject *PyPerfSampler_nr(PyPerfEventSampler *self)
+{
+	struct perf_event_sample *sample = self->ptrObj;
+
+	return PyLong_FromUnsignedLongLong(sample->data.nr);
+}
+
+PyObject *PyPerfSampler_ip(PyPerfEventSampler *self)
+{
+	struct perf_event_sample *sample = self->ptrObj;
+
+	return PyUnicode_FromString(sample->ip);
+}
+
+PyObject *PyPerfSampler_tid_comm(PyPerfEventSampler *self, PyObject *args, PyObject *kwargs)
+{
+	struct perf_event_sample *sample = self->ptrObj;
+	char *name = NULL;
+	int i;
+
+	if (!sample->perf || !sample->perf->thr_count || !sample->perf->thr_map)
+		Py_RETURN_NONE;
+
+	for (i = 0; i < sample->perf->thr_count; i++)
+		if (sample->perf->thr_map[i].tid == sample->data.tid)
+			break;
+
+	if (i < sample->perf->thr_count && sample->perf->thr_map[i].comm)
+		name = sample->perf->thr_map[i].comm;
+
+	if (name)
+		return PyUnicode_FromString(name);
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyPerfSampler_ips(PyPerfEventSampler *self)
+{
+	struct perf_event_sample *sample = self->ptrObj;
+	PyObject *slist;
+	unsigned int i;
+
+	slist = PyList_New(0);
+	for (i = 0 ; i < sample->data.nr; i++)
+		PyList_Append(slist, PyUnicode_FromString((char *)sample->ips[i]));
+
+	return slist;
+}
diff --git a/src/perfpy-utils.h b/src/perfpy-utils.h
new file mode 100644
index 0000000..648a8ce
--- /dev/null
+++ b/src/perfpy-utils.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
+ */
+
+#ifndef _TC_PERF_PY_UTILS
+#define _TC_PERF_PY_UTILS
+
+// Python
+#include <Python.h>
+
+// trace-cruncher
+#include "common.h"
+
+struct perf_handle;
+struct perf_event_sample;
+
+C_OBJECT_WRAPPER_DECLARE(perf_handle, PyPerf);
+C_OBJECT_WRAPPER_DECLARE(perf_event_sample, PyPerfEventSampler);
+
+PyObject *PyPerfSampler_new(PyObject *self, PyObject *args, PyObject *kwargs);
+
+PyObject *PyPerf_enable(PyPerf *self, PyObject *args, PyObject *kwargs);
+PyObject *PyPerf_disable(PyPerf *self);
+PyObject *PyPerf_getSamples(PyPerf *self);
+
+PyObject *PyPerfSampler_id(PyPerfEventSampler *self);
+PyObject *PyPerfSampler_ip(PyPerfEventSampler *self);
+PyObject *PyPerfSampler_pid(PyPerfEventSampler *self);
+PyObject *PyPerfSampler_tid(PyPerfEventSampler *self);
+PyObject *PyPerfSampler_tid_comm(PyPerfEventSampler *self, PyObject *args, PyObject *kwargs);
+PyObject *PyPerfSampler_time(PyPerfEventSampler *self);
+PyObject *PyPerfSampler_cpu(PyPerfEventSampler *self);
+PyObject *PyPerfSampler_nr(PyPerfEventSampler *self);
+PyObject *PyPerfSampler_ips(PyPerfEventSampler *self);
+
+void py_perf_handle_free(struct perf_handle *perf);
+int py_perf_handle_destroy(struct perf_handle *perf);
+
+void py_perf_sample_free(struct perf_event_sample *sample);
+
+#endif
diff --git a/src/perfpy.c b/src/perfpy.c
new file mode 100644
index 0000000..a6b2042
--- /dev/null
+++ b/src/perfpy.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
+ */
+
+// Python
+#include <Python.h>
+
+// libperf
+#include <perf/core.h>
+#include <perf/evsel.h>
+#include <perf/mmap.h>
+#include <perf/event.h>
+
+// trace-cruncher
+#include "common.h"
+#include "perfpy-utils.h"
+
+extern PyObject *PERF_ERROR;
+
+static PyMethodDef PyPerf_methods[] = {
+	{"enable",
+	 (PyCFunction) PyPerf_enable,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "start sampling"
+	},
+	{"disable",
+	 (PyCFunction) PyPerf_disable,
+	 METH_NOARGS,
+	 "stop sampling"
+	},
+	{"get_samples",
+	 (PyCFunction) PyPerf_getSamples,
+	 METH_NOARGS,
+	 "get recorded samples"
+	},
+	{NULL}
+};
+C_OBJECT_WRAPPER(perf_handle, PyPerf, py_perf_handle_destroy, py_perf_handle_free);
+
+static PyMethodDef PyPerfEventSampler_methods[] = {
+	{"id",
+	 (PyCFunction) PyPerfSampler_id,
+	 METH_NOARGS,
+	 "get sample id"
+	},
+	{"ip",
+	 (PyCFunction) PyPerfSampler_ip,
+	 METH_NOARGS,
+	 "get sample ip"
+	},
+	{"pid",
+	 (PyCFunction) PyPerfSampler_pid,
+	 METH_NOARGS,
+	 "get sample pid"
+	},
+	{"tid",
+	 (PyCFunction) PyPerfSampler_tid,
+	 METH_NOARGS,
+	 "get sample tid"
+	},
+	{"tid_comm",
+	 (PyCFunction) PyPerfSampler_tid_comm,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "get sample tid"
+	},
+	{"time",
+	 (PyCFunction) PyPerfSampler_time,
+	 METH_NOARGS,
+	 "get sample timestamp"
+	},
+	{"cpu",
+	 (PyCFunction) PyPerfSampler_cpu,
+	 METH_NOARGS,
+	 "get sample cpu"
+	},
+	{"stack_count",
+	 (PyCFunction) PyPerfSampler_nr,
+	 METH_NOARGS,
+	 "get sample stack count"
+	},
+	{"stack",
+	 (PyCFunction) PyPerfSampler_ips,
+	 METH_NOARGS,
+	 "get sample stack"
+	},
+	{NULL}
+};
+C_OBJECT_WRAPPER(perf_event_sample, PyPerfEventSampler, NO_DESTROY, py_perf_sample_free);
+
+static PyMethodDef perfpy_methods[] = {
+	{"sampler_instance",
+	 (PyCFunction) PyPerfSampler_new,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Allocate new perf sampler instance"
+	},
+	{NULL}
+};
+
+static int perf_error_print(enum libperf_print_level level,
+			    const char *fmt, va_list ap)
+{
+	return vfprintf(stderr, fmt, ap);
+}
+
+static struct PyModuleDef perfpy_module = {
+	PyModuleDef_HEAD_INIT,
+	"perfpy",
+	"Python interface for Perf.",
+	-1,
+	perfpy_methods
+};
+
+PyMODINIT_FUNC PyInit_perfpy(void)
+{
+
+	if (!PyPerfTypeInit())
+		return NULL;
+	if (!PyPerfEventSamplerTypeInit())
+		return NULL;
+
+	PERF_ERROR = PyErr_NewException("tracecruncher.perfpy.perf_error",
+					NULL, NULL);
+
+	PyObject *module = PyModule_Create(&perfpy_module);
+
+	PyModule_AddObject(module, "perf_error", PERF_ERROR);
+	PyModule_AddObject(module, "perf_handle", (PyObject *) &PyPerfType);
+	PyModule_AddObject(module, "perf_event_sample", (PyObject *) &PyPerfEventSamplerType);
+
+	if (geteuid() != 0) {
+		PyErr_SetString(PERF_ERROR,
+				"Permission denied. Root privileges are required.");
+		return NULL;
+	}
+
+	libperf_init(perf_error_print);
+
+	return module;
+}
-- 
2.35.1

