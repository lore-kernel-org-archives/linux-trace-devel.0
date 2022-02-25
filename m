Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9F1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Feb 2022 14:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbiBYOwR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Feb 2022 09:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiBYOwQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Feb 2022 09:52:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5695526C1;
        Fri, 25 Feb 2022 06:51:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFC74B83021;
        Fri, 25 Feb 2022 14:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A68C340E7;
        Fri, 25 Feb 2022 14:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645800698;
        bh=PI49qctCInG00ut2HXZRKzB2FC3QUwteKCfdVYopRV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vspz8gXNscHiD0Jzu5wQhAE3nuhgBlxO173rLKZ4suuEpFSWF/Ncz9i8VqEzmYT1j
         JHRNY3eV6wJlmlv6gu7TvrWJnGvzMGBLjukiJ+DtWA8Pyh4L1gru8hiJVR7307tMHZ
         BpCNQOVc/GW1JpDTYDog0tnw+jUG3aU0uMj2R2zgqu5SwTAUeQOzrlNTRJw+iv2V1D
         NXIzQsDIrIoc09l4B+NXGNQjEfMzoJh9vZt7X0/SOfhdZoMj9eXb+/5ImTf/Va7CyR
         Lf0juqVJKz2km7BV7XrYk880+LQKs//OH2nwvc06LK6iQFoKnIQSPvgiYkXXaQxVKB
         N+/0u6FKun2Dw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 58511403C8; Fri, 25 Feb 2022 11:51:35 -0300 (-03)
Date:   Fri, 25 Feb 2022 11:51:35 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, olsajiri@gmail.com, irogers@google.com,
        rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] trace-cruncher: Support for perf
Message-ID: <Yhjs95hpDvboLltB@kernel.org>
References: <20220224163711.185308-1-tz.stoyanov@gmail.com>
 <20220224163711.185308-3-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220224163711.185308-3-tz.stoyanov@gmail.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Thu, Feb 24, 2022 at 06:37:10PM +0200, Tzvetomir Stoyanov (VMware) escreveu:
> Initial perf support for trace-cruncher, using libperf. As a first
> stage, collecting of stack trace samples of given process is supported.

Are you aware of tools/perf/util/python.c? It was done for use in tuna:

https://git.kernel.org/pub/scm/utils/tuna/tuna.git/

I think it is already used in other tools, IIRC tuned also uses it:

https://github.com/redhat-performance/tuned

yeah:

⬢[acme@toolbox tuned]$ grep -r "import perf" *
tuned/plugins/plugin_irqbalance.py:import perf
tuned/plugins/plugin_scheduler.py:import perf
⬢[acme@toolbox tuned]$

Please consider looking at it and possibly adding what you need. It is available in most distros, I think:

Fedora:

python3-perf.x86_64 : Python bindings for apps which will manipulate perf events

[root@five perf]# cat tools/perf/python/twatch.py
#! /usr/bin/env python
# SPDX-License-Identifier: GPL-2.0-only
# -*- python -*-
# -*- coding: utf-8 -*-
#   twatch - Experimental use of the perf python interface
#   Copyright (C) 2011 Arnaldo Carvalho de Melo <acme@redhat.com>
#

import perf

def main(context_switch = 0, thread = -1):
	cpus = perf.cpu_map()
	threads = perf.thread_map(thread)
	evsel = perf.evsel(type	  = perf.TYPE_SOFTWARE,
			   config = perf.COUNT_SW_DUMMY,
			   task = 1, comm = 1, mmap = 0, freq = 0,
			   wakeup_events = 1, watermark = 1,
			   sample_id_all = 1, context_switch = context_switch,
			   sample_type = perf.SAMPLE_PERIOD | perf.SAMPLE_TID | perf.SAMPLE_CPU)

	"""What we want are just the PERF_RECORD_ lifetime events for threads,
	 using the default, PERF_TYPE_HARDWARE + PERF_COUNT_HW_CYCLES & freq=1
	 (the default), makes perf reenable irq_vectors:local_timer_entry, when
	 disabling nohz, not good for some use cases where all we want is to get
	 threads comes and goes... So use (perf.TYPE_SOFTWARE, perf_COUNT_SW_DUMMY,
	 freq=0) instead."""

	evsel.open(cpus = cpus, threads = threads);
	evlist = perf.evlist(cpus, threads)
	evlist.add(evsel)
	evlist.mmap()
	while True:
		evlist.poll(timeout = -1)
		for cpu in cpus:
			event = evlist.read_on_cpu(cpu)
			if not event:
				continue
			print("cpu: {0}, pid: {1}, tid: {2} {3}".format(event.sample_cpu,
                                                                        event.sample_pid,
                                                                        event.sample_tid,
                                                                        event))

if __name__ == '__main__':
    """
	To test the PERF_RECORD_SWITCH record, pick a pid and replace
	in the following line.

	Example output:

cpu: 3, pid: 31463, tid: 31593 { type: context_switch, next_prev_pid: 31463, next_prev_tid: 31593, switch_out: 1 }
cpu: 1, pid: 31463, tid: 31489 { type: context_switch, next_prev_pid: 31463, next_prev_tid: 31489, switch_out: 1 }
cpu: 2, pid: 31463, tid: 31496 { type: context_switch, next_prev_pid: 31463, next_prev_tid: 31496, switch_out: 1 }
cpu: 3, pid: 31463, tid: 31491 { type: context_switch, next_prev_pid: 31463, next_prev_tid: 31491, switch_out: 0 }

	It is possible as well to use event.misc & perf.PERF_RECORD_MISC_SWITCH_OUT
	to figure out if this is a context switch in or out of the monitored threads.

	If bored, please add command line option parsing support for these options :-)
    """
    # main(context_switch = 1, thread = 31463)
    main()
[root@five perf]# export PYTHONPATH=/tmp/build/perf/python_ext_build/lib/
[root@five perf]# tools/perf/python/twatch.py
cpu: 22, pid: 13290, tid: 3471647 { type: fork, pid: 13290, ppid: 13290, tid: 3471653, ptid: 3471647, time: 151504201166040}
cpu: 27, pid: 13290, tid: 3471653 { type: comm, pid: 13290, tid: 3471653, comm: MediaPD~oder #1 }
cpu: 27, pid: 13290, tid: 3471653 { type: comm, pid: 13290, tid: 3471653, comm: MediaPD~oder #1 }
cpu: 27, pid: 13290, tid: 3471653 { type: fork, pid: 13290, ppid: 13290, tid: 3471654, ptid: 3471653, time: 151504201524181}
cpu: 22, pid: 13290, tid: 3471654 { type: comm, pid: 13290, tid: 3471654, comm: MediaPD~oder #2 }
cpu: 22, pid: 13290, tid: 3471654 { type: comm, pid: 13290, tid: 3471654, comm: MediaPD~oder #2 }
cpu: 29, pid: 13290, tid: 3471653 { type: exit, pid: 13290, ppid: 12612, tid: 3471653, ptid: 12612, time: 151504213801994}
cpu: 0, pid: 13290, tid: 3471654 { type: exit, pid: 13290, ppid: 12612, tid: 3471654, ptid: 12612, time: 151504213861954}
cpu: 2, pid: 3471643, tid: 3471643 { type: exit, pid: 3471643, ppid: 13080, tid: 3471643, ptid: 13080, time: 151505955082335}
cpu: 20, pid: 13080, tid: 13080 { type: fork, pid: 3471655, ppid: 13080, tid: 3471655, ptid: 13080, time: 151505955346595}
cpu: 20, pid: 13080, tid: 13080 { type: fork, pid: 3471656, ppid: 13080, tid: 3471656, ptid: 13080, time: 151505955523645}
cpu: 20, pid: 13080, tid: 13080 { type: fork, pid: 3471657, ppid: 13080, tid: 3471657, ptid: 13080, time: 151505955649485}
cpu: 9, pid: 3471656, tid: 3471656 { type: comm, pid: 3471656, tid: 3471656, comm: grep }
cpu: 21, pid: 3471655, tid: 3471655 { type: comm, pid: 3471655, tid: 3471655, comm: sensors }
cpu: 28, pid: 3471657, tid: 3471657 { type: comm, pid: 3471657, tid: 3471657, comm: sed }
cpu: 21, pid: 3471655, tid: 3471655 { type: exit, pid: 3471655, ppid: 13080, tid: 3471655, ptid: 13080, time: 151505986031034}
cpu: 20, pid: 3471656, tid: 3471656 { type: exit, pid: 3471656, ppid: 13080, tid: 3471656, ptid: 13080, time: 151505986154194}
cpu: 22, pid: 3471657, tid: 3471657 { type: exit, pid: 3471657, ppid: 13080, tid: 3471657, ptid: 13080, time: 151505986292214}
cpu: 23, pid: 13080, tid: 13080 { type: fork, pid: 3471658, ppid: 13080, tid: 3471658, ptid: 13080, time: 151505986418014}
cpu: 27, pid: 3471658, tid: 3471658 { type: comm, pid: 3471658, tid: 3471658, comm: sleep }
^CTraceback (most recent call last):
  File "/var/home/acme/git/perf/tools/perf/python/twatch.py", line 61, in <module>
    main()
  File "/var/home/acme/git/perf/tools/perf/python/twatch.py", line 33, in main
    evlist.poll(timeout = -1)
KeyboardInterrupt

[root@five perf]#


 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  setup.py           |   9 +-
>  src/perfpy-utils.c | 699 +++++++++++++++++++++++++++++++++++++++++++++
>  src/perfpy-utils.h |  41 +++
>  src/perfpy.c       | 141 +++++++++
>  4 files changed, 889 insertions(+), 1 deletion(-)
>  create mode 100644 src/perfpy-utils.c
>  create mode 100644 src/perfpy-utils.h
>  create mode 100644 src/perfpy.c
> 
> diff --git a/setup.py b/setup.py
> index 4d7e727..31ca2e3 100644
> --- a/setup.py
> +++ b/setup.py
> @@ -19,18 +19,21 @@ def third_party_paths():
>      pkg_ftracepy = pkg.parse('libtracefs')
>      pkg_tracecmd = pkg.parse('libtracecmd')
>      pkg_kshark = pkg.parse('libkshark')
> +    pkg_perf = pkg.parse('libperf')
>  
>      include_dirs = [np.get_include()]
>      include_dirs.extend(pkg_traceevent['include_dirs'])
>      include_dirs.extend(pkg_ftracepy['include_dirs'])
>      include_dirs.extend(pkg_tracecmd['include_dirs'])
>      include_dirs.extend(pkg_kshark['include_dirs'])
> +    include_dirs.extend(pkg_perf['include_dirs'])
>  
>      library_dirs = []
>      library_dirs.extend(pkg_traceevent['library_dirs'])
>      library_dirs.extend(pkg_ftracepy['library_dirs'])
>      library_dirs.extend(pkg_tracecmd['library_dirs'])
>      library_dirs.extend(pkg_kshark['library_dirs'])
> +    library_dirs.extend(pkg_perf['library_dirs'])
>      library_dirs = list(set(library_dirs))
>  
>      return include_dirs, library_dirs
> @@ -61,6 +64,10 @@ def main():
>                            sources=['src/ksharkpy.c', 'src/ksharkpy-utils.c'],
>                            libraries=['kshark'])
>  
> +    module_perf = extension(name='tracecruncher.perfpy',
> +                            sources=['src/perfpy.c', 'src/perfpy-utils.c', 'src/trace-obj-debug.c'],
> +                            libraries=['traceevent', 'perf', 'bfd'])
> +
>      setup(name='tracecruncher',
>            version='0.1.0',
>            description='NumPy based interface for accessing tracing data in Python.',
> @@ -69,7 +76,7 @@ def main():
>            url='https://github.com/vmware/trace-cruncher',
>            license='LGPL-2.1',
>            packages=find_packages(),
> -          ext_modules=[module_ft, module_data, module_ks],
> +          ext_modules=[module_ft, module_data, module_ks, module_perf],
>            classifiers=[
>                'Development Status :: 3 - Alpha',
>                'Programming Language :: Python :: 3',
> diff --git a/src/perfpy-utils.c b/src/perfpy-utils.c
> new file mode 100644
> index 0000000..ae57a63
> --- /dev/null
> +++ b/src/perfpy-utils.c
> @@ -0,0 +1,699 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> + */
> +
> +#ifndef _GNU_SOURCE
> +/** Use GNU C Library. */
> +#define _GNU_SOURCE
> +#endif // _GNU_SOURCE
> +
> +// C
> +#include <stdio.h>
> +#include <unistd.h>
> +#include <pthread.h>
> +#include <sys/stat.h>
> +#include <fcntl.h>
> +#include <dirent.h>
> +#include <sys/resource.h>
> +
> +// libperf
> +#include <linux/perf_event.h>
> +#include <perf/evlist.h>
> +#include <perf/evsel.h>
> +#include <perf/cpumap.h>
> +#include <perf/threadmap.h>
> +#include <perf/mmap.h>
> +#include <perf/core.h>
> +#include <perf/event.h>
> +
> +// trace-cruncher
> +#include "perfpy-utils.h"
> +#include "trace-obj-debug.h"
> +
> +PyObject *PERF_ERROR;
> +
> +#define TMP_FILE "/tmp/perf_temp_data.XXXXXX"
> +
> +struct perf_scan_thread {
> +	uint32_t tid;
> +	char *comm;
> +	struct perf_counts_values count;
> +};
> +
> +struct perf_handle {
> +	bool running;
> +	pthread_t reader;
> +	int fd;
> +	int thr_count;
> +	uint32_t pid;
> +	struct perf_scan_thread *thr_map;
> +	struct perf_evlist *evlist;
> +	struct perf_evsel *evsel;
> +	struct perf_event_attr attr;
> +	struct perf_cpu_map *cpus;
> +	struct trace_debug_object *debug;
> +	struct perf_thread_map *threads;
> +};
> +
> +struct event_sample {
> +	uint64_t		id;		/* PERF_SAMPLE_IDENTIFIER */
> +	uint64_t		ip;		/* PERF_SAMPLE_IP */
> +	uint32_t		pid, tid;	/* PERF_SAMPLE_TID */
> +	uint64_t		time;		/* PERF_SAMPLE_TIME */
> +	uint32_t		cpu, res;	/* PERF_SAMPLE_CPU */
> +	uint64_t		nr;
> +	uint64_t		ips[];		/* PERF_SAMPLE_CALLCHAIN */
> +} __attribute__((packed));
> +
> +struct perf_event_sample {
> +	struct event_sample	data;
> +	struct perf_handle	*perf;
> +	char			*ip;
> +	char			*ips[];
> +} __attribute__((packed));
> +
> +static void perf_reader_stop(struct perf_handle *perf)
> +{
> +
> +	if (!perf->running)
> +		return;
> +
> +	perf->running = false;
> +	pthread_join(perf->reader, NULL);
> +	fsync(perf->fd);
> +	if (perf->debug)
> +		trace_debug_resolve_symbols(perf->debug);
> +}
> +
> +void py_perf_handle_free(struct perf_handle *perf)
> +{
> +	int i;
> +
> +	if (perf) {
> +		perf_reader_stop(perf);
> +		perf_evlist__delete(perf->evlist);
> +		if (perf->fd >= 0)
> +			close(perf->fd);
> +		if (perf->debug)
> +			trace_debug_obj_destroy(perf->debug);
> +		if (perf->thr_map) {
> +			for (i = 0; i < perf->thr_count; i++)
> +				free(perf->thr_map[i].comm);
> +			free(perf->thr_map);
> +		}
> +	}
> +
> +	free(perf);
> +}
> +
> +void py_perf_sample_free(struct perf_event_sample *sample)
> +{
> +	unsigned int i;
> +
> +	if (sample) {
> +		free(sample->ip);
> +		for (i = 0; i < sample->data.nr; i++)
> +			free((char *)(sample->ips[i]));
> +	}
> +	free(sample);
> +}
> +
> +static int pid_filter(const struct dirent *dir)
> +{
> +	const char *dname = dir->d_name;
> +
> +	if (!dname || dname[0] == '.')
> +		return 0;
> +
> +	while (*dname) {
> +		if (!isdigit(*dname))
> +			return 0;
> +		dname++;
> +	}
> +
> +	return 1;
> +}
> +
> +static  int str_read_file(const char *file, char **buffer)
> +{
> +	char stbuf[BUFSIZ];
> +	char *buf = NULL;
> +	int size = 0;
> +	char *nbuf;
> +	int fd;
> +	int r;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0)
> +		return -1;
> +
> +	do {
> +		r = read(fd, stbuf, BUFSIZ);
> +		if (r <= 0)
> +			continue;
> +		nbuf = realloc(buf, size+r+1);
> +		if (!nbuf) {
> +			size = -1;
> +			break;
> +		}
> +		buf = nbuf;
> +		memcpy(buf+size, stbuf, r);
> +		size += r;
> +	} while (r > 0);
> +
> +	close(fd);
> +	if (r == 0 && size > 0) {
> +		buf[size] = '\0';
> +		*buffer = buf;
> +	} else
> +		free(buf);
> +
> +	return size;
> +}
> +
> +static void strip_control_chars(char *str)
> +{
> +	while (*str) {
> +		if (iscntrl(*str)) {
> +			*str = '\0';
> +			break;
> +		}
> +		str++;
> +	}
> +}
> +
> +static struct perf_thread_map *create_thread_map(struct perf_handle *perf, int pid)
> +{
> +	struct perf_thread_map *tmap = NULL;
> +	struct dirent **pids = NULL;
> +	char path[PATH_MAX];
> +	int i, count;
> +
> +	snprintf(path, PATH_MAX, "/proc/%d/task", pid);
> +	count = scandir(path, &pids, pid_filter, NULL);
> +	if (count < 1)
> +		goto out;
> +
> +	tmap = perf_thread_map__new_array(count, NULL);
> +	if (!tmap)
> +		goto out;
> +	free(perf->thr_map);
> +	perf->thr_map = calloc(count, sizeof(struct perf_scan_thread));
> +	if (!perf->thr_map)
> +		goto out;
> +	perf->thr_count = count;
> +
> +	for (i = 0; i < count; i++) {
> +		perf->thr_map[i].tid = atoi(pids[i]->d_name);
> +		perf_thread_map__set_pid(tmap, i, perf->thr_map[i].tid);
> +		snprintf(path, PATH_MAX, "/proc/%d/task/%s/comm", pid, pids[i]->d_name);
> +		str_read_file(path, &perf->thr_map[i].comm);
> +		strip_control_chars(perf->thr_map[i].comm);
> +	}
> +	perf_thread_map__read_comms(tmap);
> +
> +out:
> +	if (pids) {
> +		for (i = 0; i < count; i++)
> +			free(pids[i]);
> +		free(pids);
> +	}
> +
> +	return tmap;
> +}
> +
> +static struct perf_handle *new_perf_sampling_handle(pid_t pid, int freq)
> +{
> +	struct perf_handle *perf = NULL;
> +	char *tmp_file = NULL;
> +
> +	perf = calloc(1, sizeof(*perf));
> +	if (!perf)
> +		return NULL;
> +
> +	perf->fd = -1;
> +	perf->attr.type        = PERF_TYPE_HARDWARE;
> +	perf->attr.config      = PERF_COUNT_HW_CPU_CYCLES;
> +	perf->attr.disabled    = 1;
> +	perf->attr.freq        = 1;
> +	perf->attr.sample_freq = freq;
> +	perf->attr.exclude_kernel = 1;
> +	perf->attr.exclude_idle = 1;
> +	perf->attr.exclude_callchain_kernel = 1;
> +	perf->attr.comm = 1;
> +	perf->attr.mmap2 = 1;
> +	perf->attr.task = 1;
> +	perf->attr.precise_ip = 0;
> +	perf->attr.inherit = 1;
> +	perf->attr.task = 1;
> +	perf->attr.inherit_stat = 1;
> +	perf->attr.read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
> +				 PERF_FORMAT_TOTAL_TIME_RUNNING;
> +	perf->attr.sample_type = PERF_SAMPLE_IDENTIFIER |
> +				 PERF_SAMPLE_IP |
> +				 PERF_SAMPLE_TID |
> +				 PERF_SAMPLE_TIME |
> +				 PERF_SAMPLE_CPU |
> +				 PERF_SAMPLE_CALLCHAIN;
> +
> +	/* trace all CPUs in the system */
> +	perf->cpus = perf_cpu_map__new(NULL);
> +	if (!perf->cpus) {
> +		PyErr_Format(PERF_ERROR, "Failed to create perf cpu map");
> +		goto error;
> +	}
> +
> +	if (pid >= 0) {
> +		perf->pid = pid;
> +		perf->threads = create_thread_map(perf, pid);
> +		if (!perf->threads) {
> +			PyErr_Format(PERF_ERROR, "Failed to create perf threads map");
> +			goto error;
> +		}
> +		perf->debug = trace_debug_obj_create_pid(pid);
> +	}
> +
> +	perf->evlist = perf_evlist__new();
> +	if (!perf->evlist) {
> +		PyErr_Format(PERF_ERROR, "Failed to create perf events list");
> +		goto error;
> +	}
> +
> +	tmp_file = strdup(TMP_FILE);
> +	if (!tmp_file)
> +		goto error;
> +
> +	mktemp(tmp_file);
> +	perf->fd = open(tmp_file, O_RDWR|O_CREAT|O_TRUNC, 0600);
> +	unlink(tmp_file);
> +	if (perf->fd < 0)
> +		goto error;
> +
> +	perf->evsel = perf_evsel__new(&perf->attr);
> +	if (!perf->evsel) {
> +		PyErr_Format(PERF_ERROR, "Failed to create perf cycles");
> +		goto error;
> +	}
> +
> +	perf_evlist__add(perf->evlist, perf->evsel);
> +	perf_evlist__set_maps(perf->evlist, perf->cpus, perf->threads);
> +
> +	free(tmp_file);
> +	return perf;
> +
> +error:
> +	perf_cpu_map__put(perf->cpus);
> +	perf_thread_map__put(perf->threads);
> +	py_perf_handle_free(perf);
> +	free(tmp_file);
> +	return NULL;
> +}
> +
> +PyObject *PyPerfSample_new(PyObject *self, PyObject *args, PyObject *kwargs)
> +{
> +	static char *kwlist[] = {"pid", "freq", NULL};
> +	struct perf_handle *perf = NULL;
> +	int freq = 10, pid = -1;
> +
> +	if (!PyArg_ParseTupleAndKeywords(args,
> +					 kwargs,
> +					 "i|i",
> +					 kwlist,
> +					 &pid,
> +					 &freq
> +					 )) {
> +		return NULL;
> +	}
> +
> +	perf = new_perf_sampling_handle(pid, freq);
> +	if (!perf)
> +		return NULL;
> +
> +	return PyPerf_New(perf);
> +}
> +
> +static void perf_read_sample(struct perf_handle *perf, struct perf_record_sample *event)
> +{
> +	struct event_sample *sample;
> +	uint64_t i;
> +
> +	sample = (struct event_sample *)(event->array);
> +
> +	/* check if the sample is for our PID */
> +	if (sample->pid != perf->pid)
> +		return;
> +
> +	if (perf->debug)
> +		trace_debug_add_resolve_symbol(perf->debug, sample->ip, NULL);
> +
> +	if (write(perf->fd, sample, sizeof(*sample)) != sizeof(*sample))
> +		return;
> +
> +	for (i = 0; i < sample->nr; i++) {
> +		if (write(perf->fd, &sample->ips[i], sizeof(uint64_t)) != sizeof(uint64_t))
> +			return;
> +		if (perf->debug)
> +			trace_debug_add_resolve_symbol(perf->debug, sample->ips[i], NULL);
> +	}
> +}
> +
> +/* A new memory is mapped to traced process */
> +static void perf_read_mmap2(struct perf_handle *perf, struct perf_record_mmap2 *mmap)
> +{
> +	/* check if mmap is for our PID */
> +	if (perf->pid != mmap->pid)
> +		return;
> +
> +	/* check if executable memory is mapped */
> +	if (mmap->header.misc & PERF_RECORD_MISC_MMAP_DATA)
> +		return;
> +
> +	/*
> +	 * A new dynamic library is dlopen() by the traced process,
> +	 * store it for vma -> name resolving
> +	 */
> +	trace_debug_obj_add_file(perf->debug, mmap->filename,
> +				 mmap->start, mmap->start + mmap->len, mmap->pgoff);
> +}
> +
> +/* A new thread is started */
> +static void perf_read_comm(struct perf_handle *perf, struct perf_record_comm *comm)
> +{
> +	struct perf_scan_thread *tmp;
> +	int i;
> +
> +	/* check if the thread is started by PID */
> +	if (perf->pid != comm->pid)
> +		return;
> +
> +	for (i = 0; i < perf->thr_count; i++) {
> +		if (perf->thr_map[i].tid == comm->tid) {
> +			free(perf->thr_map[i].comm);
> +			perf->thr_map[i].comm = strdup(comm->comm);
> +			return;
> +		}
> +	}
> +
> +	tmp = realloc(perf->thr_map, (perf->thr_count + 1) * sizeof(struct perf_scan_thread));
> +	if (!tmp)
> +		return;
> +
> +	perf->thr_map = tmp;
> +	perf->thr_map[perf->thr_count].tid = comm->tid;
> +	perf->thr_map[perf->thr_count].comm = strdup(comm->comm);
> +	perf->thr_count++;
> +}
> +
> +static void *perf_reader_thread(void *data)
> +{
> +	struct perf_handle *perf = data;
> +	struct perf_mmap *map;
> +	union perf_event *event;
> +
> +	perf_evlist__enable(perf->evlist);
> +
> +	while (true) {
> +		if (!perf->running)
> +			break;
> +		perf_evlist__for_each_mmap(perf->evlist, map, false) {
> +			if (perf_mmap__read_init(map) < 0)
> +				continue;
> +
> +			while ((event = perf_mmap__read_event(map)) != NULL) {
> +
> +				switch (event->sample.header.type) {
> +				case PERF_RECORD_SAMPLE:
> +					perf_read_sample(perf, (struct perf_record_sample *)event);
> +					break;
> +				case PERF_RECORD_COMM:
> +					perf_read_comm(perf, (struct perf_record_comm *)event);
> +					break;
> +				case PERF_RECORD_MMAP2:
> +					perf_read_mmap2(perf, (struct perf_record_mmap2 *)event);
> +					break;
> +				}
> +
> +				perf_mmap__consume(map);
> +			}
> +
> +			perf_mmap__read_done(map);
> +		}
> +	}
> +	perf_evlist__disable(perf->evlist);
> +	pthread_exit(0);
> +}
> +
> +static int increase_file_limit(void)
> +{
> +	struct rlimit lim;
> +
> +	if (getrlimit(RLIMIT_NOFILE, &lim))
> +		return -1;
> +
> +	if (lim.rlim_cur < lim.rlim_max) {
> +		lim.rlim_cur = lim.rlim_max;
> +	} else {
> +		lim.rlim_cur += 100;
> +		lim.rlim_max += 100;
> +	}
> +
> +	return setrlimit(RLIMIT_NOFILE, &lim);
> +}
> +
> +static int perf_reader_start(struct perf_handle *perf)
> +{
> +	pthread_attr_t attrib;
> +	int err = 0;
> +
> +	if (perf->running)
> +		return 0;
> +
> +	pthread_attr_init(&attrib);
> +	pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
> +
> +	do {
> +		err = perf_evlist__open(perf->evlist);
> +		if (!err)
> +			break;
> +		if (err != -EMFILE)
> +			goto out;
> +		if (increase_file_limit())
> +			goto out;
> +	} while (err);
> +
> +	err = perf_evlist__mmap(perf->evlist, 4);
> +	if (err)
> +		goto out;
> +
> +	perf->running = true;
> +	err = pthread_create(&perf->reader, &attrib, perf_reader_thread, perf);
> +	if (err)
> +		goto out;
> +
> +out:
> +	pthread_attr_destroy(&attrib);
> +	if (err) {
> +		perf_evlist__close(perf->evlist);
> +		perf->running = false;
> +	}
> +	return err;
> +}
> +
> +PyObject *PyPerf_start(PyPerf *self)
> +{
> +	struct perf_handle *perf = self->ptrObj;
> +	int err;
> +
> +	if (perf->running) {
> +		PyErr_Format(PERF_ERROR, "Perf reader is already started");
> +		return NULL;
> +	}
> +
> +	err = perf_reader_start(perf);
> +	if (err) {
> +		PyErr_Format(PERF_ERROR,
> +			     "Failed to start perf reader - %s", strerror(-err));
> +		return NULL;
> +	}
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyPerf_stop(PyPerf *self)
> +{
> +	struct perf_handle *perf = self->ptrObj;
> +
> +	if (!perf->running) {
> +		PyErr_Format(PERF_ERROR, "Perf reader is not started");
> +		return NULL;
> +	}
> +
> +	perf_reader_stop(perf);
> +
> +	Py_RETURN_NONE;
> +}
> +
> +struct symb_walk {
> +	uint64_t ip;
> +	char *name;
> +};
> +
> +static int sym_get(struct tracecmd_debug_symbols *symb, void *data)
> +{
> +	struct symb_walk *s = (struct symb_walk *)data;
> +
> +	if (s->ip == symb->vma_near) {
> +		if (symb->name)
> +			asprintf(&s->name, "%s @ %s", symb->name, symb->fname);
> +		else
> +			asprintf(&s->name, "(0x%llX) @ %s", symb->vma_near, symb->fname);
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +static char *ip_name(struct perf_handle *perf, uint64_t ip)
> +{
> +	struct symb_walk symb;
> +
> +	symb.ip = ip;
> +	symb.name = NULL;
> +	if (perf && perf->debug)
> +		trace_debug_walk_resolved_symbols(perf->debug, sym_get, &symb);
> +
> +	if (!symb.name)
> +		asprintf(&symb.name, "0x%lX", ip);
> +
> +	return symb.name;
> +}
> +
> +PyObject *PyPerf_getSamples(PyPerf *self)
> +{
> +	struct perf_handle *perf = self->ptrObj;
> +	struct event_sample sample;
> +	struct perf_event_sample *store;
> +	PyObject *slist, *sobject;
> +	uint64_t i, ip;
> +	int ca = 0, cs = 0;
> +
> +	if (perf->running) {
> +		PyErr_Format(PERF_ERROR, "Perf reader is running");
> +		return NULL;
> +	}
> +
> +	if (lseek(perf->fd, 0, SEEK_SET) == (off_t)-1) {
> +		PyErr_Format(PERF_ERROR, "No samples");
> +		return NULL;
> +	}
> +
> +	slist = PyList_New(0);
> +	do {
> +		if (read(perf->fd, &sample, sizeof(sample)) != sizeof(sample))
> +			break;
> +		ca++;
> +		store = calloc(1, sizeof(*store) + (sample.nr * sizeof(char *)));
> +		if (!store)
> +			break;
> +		memcpy(&store->data, &sample, sizeof(sample));
> +		store->perf = perf;
> +		store->ip = ip_name(perf, store->data.ip);
> +		for (i = 0; i < sample.nr; i++) {
> +			if (read(perf->fd, &ip, sizeof(uint64_t)) != sizeof(uint64_t))
> +				break;
> +			store->ips[i] = ip_name(perf, ip);
> +		}
> +		cs += sample.nr;
> +		if (i < sample.nr)
> +			break;
> +		sobject = PyPerfEventSample_New(store);
> +		PyList_Append(slist, sobject);
> +	} while (true);
> +	ftruncate(perf->fd, 0);
> +	return slist;
> +}
> +
> +PyObject *PyPerfSample_id(PyPerfEventSample *self)
> +{
> +	struct perf_event_sample *sample = self->ptrObj;
> +
> +	return PyLong_FromUnsignedLongLong(sample->data.id);
> +}
> +
> +PyObject *PyPerfSample_pid(PyPerfEventSample *self)
> +{
> +	struct perf_event_sample *sample = self->ptrObj;
> +
> +	return PyLong_FromUnsignedLong(sample->data.pid);
> +}
> +
> +PyObject *PyPerfSample_tid(PyPerfEventSample *self)
> +{
> +	struct perf_event_sample *sample = self->ptrObj;
> +
> +	return PyLong_FromUnsignedLong(sample->data.tid);
> +}
> +
> +PyObject *PyPerfSample_time(PyPerfEventSample *self)
> +{
> +	struct perf_event_sample *sample = self->ptrObj;
> +
> +	return PyLong_FromUnsignedLongLong(sample->data.time);
> +}
> +
> +PyObject *PyPerfSample_cpu(PyPerfEventSample *self)
> +{
> +	struct perf_event_sample *sample = self->ptrObj;
> +
> +	return PyLong_FromUnsignedLong(sample->data.cpu);
> +}
> +
> +PyObject *PyPerfSample_nr(PyPerfEventSample *self)
> +{
> +	struct perf_event_sample *sample = self->ptrObj;
> +
> +	return PyLong_FromUnsignedLongLong(sample->data.nr);
> +}
> +
> +PyObject *PyPerfSample_ip(PyPerfEventSample *self)
> +{
> +	struct perf_event_sample *sample = self->ptrObj;
> +
> +	return PyUnicode_FromString(sample->ip);
> +}
> +
> +PyObject *PyPerfSample_tid_comm(PyPerfEventSample *self, PyObject *args, PyObject *kwargs)
> +{
> +	struct perf_event_sample *sample = self->ptrObj;
> +	char *name = NULL;
> +	int i;
> +
> +	if (!sample->perf || !sample->perf->thr_count || !sample->perf->thr_map)
> +		Py_RETURN_NONE;
> +
> +	for (i = 0; i < sample->perf->thr_count; i++)
> +		if (sample->perf->thr_map[i].tid == sample->data.tid)
> +			break;
> +
> +	if (i < sample->perf->thr_count && sample->perf->thr_map[i].comm)
> +		name = sample->perf->thr_map[i].comm;
> +
> +	if (name)
> +		return PyUnicode_FromString(name);
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyPerfSample_ips(PyPerfEventSample *self)
> +{
> +	struct perf_event_sample *sample = self->ptrObj;
> +	PyObject *slist;
> +	unsigned int i;
> +
> +	slist = PyList_New(0);
> +	for (i = 0 ; i < sample->data.nr; i++)
> +		PyList_Append(slist, PyUnicode_FromString((char *)sample->ips[i]));
> +
> +	return slist;
> +}
> diff --git a/src/perfpy-utils.h b/src/perfpy-utils.h
> new file mode 100644
> index 0000000..0727a9a
> --- /dev/null
> +++ b/src/perfpy-utils.h
> @@ -0,0 +1,41 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +
> +/*
> + * Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> + */
> +
> +#ifndef _TC_PERF_PY_UTILS
> +#define _TC_PERF_PY_UTILS
> +
> +// Python
> +#include <Python.h>
> +
> +// trace-cruncher
> +#include "common.h"
> +
> +struct perf_handle;
> +struct perf_event_sample;
> +
> +C_OBJECT_WRAPPER_DECLARE(perf_handle, PyPerf);
> +C_OBJECT_WRAPPER_DECLARE(perf_event_sample, PyPerfEventSample);
> +
> +PyObject *PyPerfSample_new(PyObject *self, PyObject *args, PyObject *kwargs);
> +
> +PyObject *PyPerf_start(PyPerf *self);
> +PyObject *PyPerf_stop(PyPerf *self);
> +PyObject *PyPerf_getSamples(PyPerf *self);
> +
> +PyObject *PyPerfSample_id(PyPerfEventSample *self);
> +PyObject *PyPerfSample_ip(PyPerfEventSample *self);
> +PyObject *PyPerfSample_pid(PyPerfEventSample *self);
> +PyObject *PyPerfSample_tid(PyPerfEventSample *self);
> +PyObject *PyPerfSample_tid_comm(PyPerfEventSample *self, PyObject *args, PyObject *kwargs);
> +PyObject *PyPerfSample_time(PyPerfEventSample *self);
> +PyObject *PyPerfSample_cpu(PyPerfEventSample *self);
> +PyObject *PyPerfSample_nr(PyPerfEventSample *self);
> +PyObject *PyPerfSample_ips(PyPerfEventSample *self);
> +
> +void py_perf_handle_free(struct perf_handle *handle);
> +void py_perf_sample_free(struct perf_event_sample *sample);
> +
> +#endif
> diff --git a/src/perfpy.c b/src/perfpy.c
> new file mode 100644
> index 0000000..745d519
> --- /dev/null
> +++ b/src/perfpy.c
> @@ -0,0 +1,141 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> + */
> +
> +// Python
> +#include <Python.h>
> +
> +// libperf
> +#include <perf/core.h>
> +#include <perf/evsel.h>
> +#include <perf/mmap.h>
> +#include <perf/event.h>
> +
> +// trace-cruncher
> +#include "common.h"
> +#include "perfpy-utils.h"
> +
> +extern PyObject *PERF_ERROR;
> +
> +static PyMethodDef PyPerf_methods[] = {
> +	{"start",
> +	 (PyCFunction) PyPerf_start,
> +	 METH_NOARGS,
> +	 "start sampling"
> +	},
> +	{"stop",
> +	 (PyCFunction) PyPerf_stop,
> +	 METH_NOARGS,
> +	 "stop sampling"
> +	},
> +	{"get_samples",
> +	 (PyCFunction) PyPerf_getSamples,
> +	 METH_NOARGS,
> +	 "get recorded samples"
> +	},
> +	{NULL}
> +};
> +C_OBJECT_WRAPPER(perf_handle, PyPerf, NO_DESTROY, py_perf_handle_free);
> +
> +static PyMethodDef PyPerfEventSample_methods[] = {
> +	{"id",
> +	 (PyCFunction) PyPerfSample_id,
> +	 METH_NOARGS,
> +	 "get sample id"
> +	},
> +	{"ip",
> +	 (PyCFunction) PyPerfSample_ip,
> +	 METH_NOARGS,
> +	 "get sample ip"
> +	},
> +	{"pid",
> +	 (PyCFunction) PyPerfSample_pid,
> +	 METH_NOARGS,
> +	 "get sample pid"
> +	},
> +	{"tid",
> +	 (PyCFunction) PyPerfSample_tid,
> +	 METH_NOARGS,
> +	 "get sample tid"
> +	},
> +	{"tid_comm",
> +	 (PyCFunction) PyPerfSample_tid_comm,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "get sample tid"
> +	},
> +	{"time",
> +	 (PyCFunction) PyPerfSample_time,
> +	 METH_NOARGS,
> +	 "get sample timestamp"
> +	},
> +	{"cpu",
> +	 (PyCFunction) PyPerfSample_cpu,
> +	 METH_NOARGS,
> +	 "get sample cpu"
> +	},
> +	{"stack_count",
> +	 (PyCFunction) PyPerfSample_nr,
> +	 METH_NOARGS,
> +	 "get sample stack count"
> +	},
> +	{"stack",
> +	 (PyCFunction) PyPerfSample_ips,
> +	 METH_NOARGS,
> +	 "get sample stack"
> +	},
> +	{NULL}
> +};
> +C_OBJECT_WRAPPER(perf_event_sample, PyPerfEventSample, NO_DESTROY, py_perf_sample_free);
> +
> +static PyMethodDef perfpy_methods[] = {
> +	{"sample",
> +	 (PyCFunction) PyPerfSample_new,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "new perf sample instance"
> +	},
> +	{NULL}
> +};
> +
> +static int perf_error_print(enum libperf_print_level level,
> +			    const char *fmt, va_list ap)
> +{
> +	return vfprintf(stderr, fmt, ap);
> +}
> +
> +static struct PyModuleDef perfpy_module = {
> +	PyModuleDef_HEAD_INIT,
> +	"perfpy",
> +	"Python interface for Perf.",
> +	-1,
> +	perfpy_methods
> +};
> +
> +PyMODINIT_FUNC PyInit_perfpy(void)
> +{
> +
> +	if (!PyPerfTypeInit())
> +		return NULL;
> +	if (!PyPerfEventSampleTypeInit())
> +		return NULL;
> +
> +	PERF_ERROR = PyErr_NewException("tracecruncher.perfpy.perf_error",
> +					NULL, NULL);
> +
> +	PyObject *module = PyModule_Create(&perfpy_module);
> +
> +	PyModule_AddObject(module, "perf_error", PERF_ERROR);
> +	PyModule_AddObject(module, "perf_handle", (PyObject *) &PyPerfType);
> +	PyModule_AddObject(module, "perf_event_sample", (PyObject *) &PyPerfEventSampleType);
> +
> +	if (geteuid() != 0) {
> +		PyErr_SetString(PERF_ERROR,
> +				"Permission denied. Root privileges are required.");
> +		return NULL;
> +	}
> +
> +	libperf_init(perf_error_print);
> +
> +	return module;
> +}
> -- 
> 2.34.1

-- 

- Arnaldo
