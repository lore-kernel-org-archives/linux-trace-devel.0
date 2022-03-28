Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C4CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Mar 2022 16:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242356AbiC1QgU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Mar 2022 12:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233969AbiC1QgT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Mar 2022 12:36:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4BF1CFD7;
        Mon, 28 Mar 2022 09:34:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B1B86142C;
        Mon, 28 Mar 2022 16:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7026FC004DD;
        Mon, 28 Mar 2022 16:34:36 +0000 (UTC)
Date:   Mon, 28 Mar 2022 12:34:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Kalesh Singh <kaleshsingh@google.com>
Cc:     linux-trace-devel@vger.kernel.org, williskung@google.com,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 01/12] trace-cmd: Add trace-cmd analyze
Message-ID: <20220328123434.301a5ce4@gandalf.local.home>
In-Reply-To: <CAC_TJvfrQMyhSRHh7_z_Vx_6KDELQhyYnapyTBRDMBtKvCuitw@mail.gmail.com>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
        <20220324025726.1727204-2-rostedt@goodmis.org>
        <CAC_TJvfrQMyhSRHh7_z_Vx_6KDELQhyYnapyTBRDMBtKvCuitw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 28 Mar 2022 09:08:02 -0700
Kalesh Singh <kaleshsingh@google.com> wrote:

> > +++ b/tracecmd/trace-analyze.c
> > @@ -0,0 +1,508 @@
> > +// SPDX-License-Identifier: LGPL-2.1
> > +/*
> > + * Copyright (C) 2022 Google Inc, Steven Rostedt <srostedt@redhat.com>
> > + */
> > +#define _LARGEFILE64_SOURCE
> > +#include <getopt.h>
> > +#include <stdlib.h>
> > +
> > +#include "trace-cmd-local.h"
> > +#include "trace-local.h"
> > +#include "trace-hash.h"
> > +#include "list.h"
> > +
> > +static bool time_in_nsecs;
> > +
> > +struct analysis_data;
> > +
> > +struct cpu_data {
> > +       unsigned long long      start_ts;
> > +       unsigned long long      last_ts;
> > +       struct analysis_data    *data;
> > +       struct trace_hash       tasks;
> > +       int                     nr_tasks;
> > +       int                     cpu;
> > +       int                     current_pid;
> > +       int                     first_pid;
> > +};
> > +
> > +struct analysis_data {
> > +       unsigned long long      start_ts;
> > +       unsigned long long      last_ts;
> > +       struct cpu_data         *cpu_data;
> > +       struct trace_hash       tasks;
> > +       int                     nr_tasks;
> > +       int                     allocated_cpus;
> > +       int                     cpus;  
> 
> Hi Steve,
> 
> I don't see analysis_data->cpus field ever used.

Probably not. I was debating about adding RFC to this series, but decided
not to. Now I regret that, because it really is an RFC (as well as I rushed
a lot of it).

> 
> > +};
> > +
> > +struct task_item {
> > +       unsigned long long      runtime;
> > +       unsigned long long      start_ts;
> > +       struct trace_hash_item  hash;
> > +       int                     pid;
> > +};
> > +
> > +struct task_cpu_item {
> > +       struct trace_hash_item  hash;
> > +       struct task_item        *task;
> > +};
> > +
> > +#define CPU_BLOCKS     32
> > +
> > +#define task_from_hash(item) container_of(item, struct task_item, hash)
> > +#define task_cpu_from_hash(item)  container_of(item, struct task_cpu_item, hash)
> > +
> > +static struct cpu_data *get_cpu_data(struct analysis_data *data,
> > +                                    struct tep_record *record)
> > +{
> > +       struct cpu_data *cpu_data;
> > +       int cpu = record->cpu;
> > +       int cnt;
> > +
> > +       if (cpu < data->allocated_cpus) {
> > +               cpu_data = &data->cpu_data[cpu];
> > +               if (!cpu_data->data)
> > +                       goto init_cpu_data;
> > +               return cpu_data;
> > +       }
> > +
> > +       /* Round up to CPU_BLOCKS multiplier */
> > +       cnt = ((cpu + CPU_BLOCKS) / CPU_BLOCKS) * CPU_BLOCKS;
> > +
> > +       cpu_data = realloc(data->cpu_data, sizeof(*cpu_data) * cnt);
> > +
> > +       if (!cpu_data)
> > +               die("Allocating cpu size %d for cpu %d", cnt, cpu);
> > +
> > +       memset(cpu_data + data->allocated_cpus, 0,
> > +              sizeof(*cpu_data) * (cnt - data->allocated_cpus));
> > +
> > +       data->allocated_cpus = cnt;
> > +
> > +       data->cpu_data = cpu_data;
> > +       cpu_data += cpu;
> > +
> > + init_cpu_data:
> > +       cpu_data->current_pid = -1;
> > +       cpu_data->cpu = cpu;
> > +       cpu_data->data = data;
> > +
> > +       trace_hash_init(&cpu_data->tasks, 32);  
> 
> nit: #define CPU_TASKS_HASH_SIZE 32?

Agreed.

> 
> > +
> > +       return cpu_data;
> > +}
> > +
> > +static int check_idle(struct cpu_data *cpu_data, int pid)
> > +{
> > +       if (pid)
> > +               return pid;
> > +
> > +       /*
> > +        * Since pid 0 is the per cpu swapper task that
> > +        * means several of these tasks have the same pid
> > +        * and only differentiate between CPUs. Set the pid
> > +        * that is stored in the hash as -2 - CPU id.
> > +        */
> > +
> > +       return -2 - cpu_data->cpu;
> > +}
> > +
> > +static struct task_item *get_task(struct cpu_data *cpu_data, int pid)
> > +{
> > +       struct trace_hash_item *hash;
> > +       struct task_item *task;
> > +       int find_pid;
> > +
> > +       find_pid = check_idle(cpu_data, pid);
> > +
> > +       hash = trace_hash_find(&cpu_data->data->tasks, find_pid, NULL, NULL);
> > +       if (!hash) {
> > +               task = calloc(sizeof(*task), 1);
> > +               if (!task)
> > +                       die("allocating task");
> > +               task->pid = find_pid;
> > +               hash = &task->hash;
> > +               hash->key = find_pid;
> > +               cpu_data->data->nr_tasks++;
> > +               trace_hash_add(&cpu_data->data->tasks, hash);
> > +       }
> > +
> > +       return task_from_hash(hash);
> > +}
> > +
> > +static struct task_cpu_item *get_cpu_task(struct cpu_data *cpu_data, int pid)
> > +{
> > +       struct trace_hash_item *hash;
> > +       struct task_cpu_item *task;
> > +
> > +       hash = trace_hash_find(&cpu_data->tasks, pid, NULL, NULL);
> > +       if (!hash) {
> > +               task = calloc(sizeof(*task), 1);
> > +               if (!task)
> > +                       die("allocating cpu task");
> > +               task->task = get_task(cpu_data, pid);
> > +               hash = &task->hash;
> > +               hash->key = pid;
> > +               cpu_data->nr_tasks++;
> > +               trace_hash_add(&cpu_data->tasks, hash);
> > +       }
> > +
> > +       return task_cpu_from_hash(hash);
> > +};
> > +
> > +/* Update times for a task scheduling off the CPU */
> > +static void update_cpu_task_times(struct cpu_data *cpu_data,
> > +                                 struct task_cpu_item *cpu_task,
> > +                                 unsigned long long ts)
> > +{
> > +       unsigned long long delta;
> > +       struct task_item *task = cpu_task->task;
> > +
> > +       /*
> > +        * If the last event was a sched switch where the previous task
> > +        * ran on another CPU, and migrated back to this CPU, and sched
> > +        * switch was not recorded (saying that this task scheduled off)
> > +        * It could be miscronstrued to still be on this CPU, and that
> > +        * its start_ts is later than the last_ts of this CPU.
> > +        */
> > +       if (ts < task->start_ts)
> > +               return;
> > +
> > +       delta = ts - task->start_ts;
> > +       task->runtime += delta;
> > +}
> > +
> > +static void update_pid(struct cpu_data *cpu_data,
> > +                      struct tep_record *record, int pid)
> > +{
> > +       struct task_cpu_item *cpu_task;
> > +       struct task_item *task;
> > +       int curr_pid = cpu_data->current_pid;
> > +       unsigned long long delta;
> > +
> > +       cpu_task = get_cpu_task(cpu_data, curr_pid);
> > +       task = cpu_task->task;
> > +
> > +       update_cpu_task_times(cpu_data, cpu_task, cpu_data->last_ts);
> > +
> > +       if (!record)
> > +               return;
> > +
> > +       cpu_task = get_cpu_task(cpu_data, pid);
> > +       task = cpu_task->task;
> > +
> > +       if (record->ts < cpu_data->last_ts) {
> > +               tracecmd_warning("task %d start time %llu greater than CPU time %llu",
> > +                                pid, record->ts, cpu_data->last_ts);  
> 
> Shouldn’t this say, ... start time %llu "less than" CPU time ...?

Yeah, that wording is confusing.

	"task %d CPU start time %llu is before last event %llu on CPU for a different task"

?

> 
> > +       } else {
> > +               delta = record->ts - cpu_data->last_ts;
> > +               task->runtime += delta;
> > +       }
> > +
> > +       cpu_data->last_ts = record->ts;
> > +
> > +       task->start_ts = cpu_data->last_ts;
> > +       cpu_data->current_pid = pid;
> > +}
> > +
> > +static void update_cpu_times(struct cpu_data *cpu_data,
> > +                            struct tep_handle *tep, int pid,
> > +                            struct tep_record *record)
> > +{
> > +       struct task_cpu_item *cpu_task;
> > +       struct task_item *task;
> > +
> > +       if (cpu_data->current_pid < 0) {
> > +               /* First time called */
> > +               cpu_data->start_ts = record->ts;
> > +               cpu_data->last_ts = record->ts;
> > +               cpu_data->current_pid = pid;
> > +               cpu_data->first_pid = pid;
> > +               cpu_task = get_cpu_task(cpu_data, pid);
> > +               task = cpu_task->task;
> > +               task->start_ts = record->ts;
> > +               if (record->ts < cpu_data->data->start_ts)
> > +                       cpu_data->data->start_ts = record->ts;
> > +               return;
> > +       }
> > +
> > +       if (pid != cpu_data->current_pid) {
> > +               update_pid(cpu_data, record, pid);
> > +               return;
> > +       }
> > +
> > +       cpu_data->last_ts = record->ts;
> > +}
> > +
> > +static void update_first_pid(struct cpu_data *cpu_data)
> > +{
> > +       struct task_cpu_item *cpu_task;
> > +       struct task_item *task;
> > +       unsigned long long start_ts = cpu_data->data->start_ts;
> > +       unsigned long long delta;
> > +
> > +       cpu_task = get_cpu_task(cpu_data, cpu_data->first_pid);
> > +       task = cpu_task->task;
> > +       delta = cpu_data->start_ts - start_ts;
> > +       task->runtime += delta;
> > +       cpu_data->start_ts = start_ts;
> > +}
> > +
> > +static void process_cpu(struct analysis_data *data,
> > +                       struct tep_handle *tep,
> > +                       struct tep_record *record)
> > +{
> > +       struct cpu_data *cpu_data;
> > +       int pid;
> > +
> > +       pid = tep_data_pid(tep, record);
> > +       if (pid < 0) /* Warn? */
> > +               return;
> > +
> > +       cpu_data = get_cpu_data(data, record);
> > +       update_cpu_times(cpu_data, tep, pid, record);
> > +}
> > +
> > +static void print_time(unsigned long long ts, char delim)
> > +{
> > +       unsigned long long secs;
> > +       unsigned long long msecs;
> > +       unsigned long long usecs;
> > +       unsigned long long nsecs;
> > +
> > +       secs = ts / 1000000000;
> > +       ts -= secs * 1000000000;
> > +
> > +       msecs = ts / 1000000;
> > +       ts -= msecs * 1000000;
> > +
> > +       usecs = ts / 1000;
> > +       ts -= usecs * 1000;
> > +
> > +       nsecs = ts;
> > +
> > +       if (delim) {
> > +               printf("%6llu.%03llu%c%03llu",
> > +                      secs, msecs, delim, usecs);
> > +               if (time_in_nsecs)
> > +                       printf("%c%03llu", delim, nsecs);
> > +       } else {
> > +               printf("%6llu.%03llu%03llu",
> > +                      secs, msecs, usecs);
> > +               if (time_in_nsecs)
> > +                       printf("%03llu", nsecs);
> > +       }
> > +}
> > +
> > +static void print_total(struct tep_handle *tep, struct analysis_data *data)
> > +{
> > +       unsigned long long total_time;
> > +       struct trace_hash_item **bucket;
> > +       struct trace_hash_item *item;
> > +       struct task_item **idle_tasks;
> > +       struct task_item *task;
> > +       bool first = true;
> > +       int cpu;
> > +       int i = 0;
> > +
> > +       total_time = data->last_ts - data->start_ts;
> > +       printf("\nTotal time: ");
> > +       print_time(total_time, '_');
> > +       printf("\n");
> > +
> > +       idle_tasks = calloc(sizeof(*idle_tasks), data->allocated_cpus);
> > +       if (!idle_tasks)
> > +               die("Could not allocate idle task array");
> > +
> > +       trace_hash_for_each_bucket(bucket, &data->tasks) {
> > +               trace_hash_for_each_item(item, bucket) {
> > +                       task = task_from_hash(item);
> > +                       if (task->pid < 0) {
> > +                               cpu = -2 - task->pid;
> > +                               idle_tasks[cpu] = task;
> > +                       }
> > +               }
> > +       }
> > +
> > +       for (i = 0; i < data->allocated_cpus; i++) {
> > +               if (!idle_tasks[i])
> > +                       continue;
> > +
> > +               if (first) {
> > +                       printf("\n Idle CPU\t     Run time\n");
> > +                       printf(" --------\t     --------\n");
> > +                       first = false;
> > +               }
> > +               printf("CPU %d idle:\t", i);
> > +               print_time(idle_tasks[i]->runtime, '_');
> > +               printf(" (%%%lld)\n", (idle_tasks[i]->runtime * 100) / total_time);
> > +       }
> > +       free(idle_tasks);
> > +}
> > +
> > +static void free_tasks(struct trace_hash *hash)
> > +{
> > +       struct trace_hash_item **bucket;
> > +       struct trace_hash_item *item;
> > +       struct task_item *task;
> > +
> > +       trace_hash_for_each_bucket(bucket, hash) {
> > +               trace_hash_while_item(item, bucket) {
> > +                       task = task_from_hash(item);
> > +                       trace_hash_del(item);
> > +                       free(task);
> > +               }
> > +       }
> > +       trace_hash_free(hash);
> > +}
> > +
> > +static void free_cpu_tasks(struct trace_hash *hash)
> > +{
> > +       struct trace_hash_item **bucket;
> > +       struct trace_hash_item *item;
> > +       struct task_cpu_item *cpu_task;
> > +
> > +       trace_hash_for_each_bucket(bucket, hash) {
> > +               trace_hash_while_item(item, bucket) {
> > +                       cpu_task = task_cpu_from_hash(item);
> > +                       trace_hash_del(item);
> > +                       free(cpu_task);
> > +               }
> > +       }
> > +       trace_hash_free(hash);
> > +}
> > +
> > +static void free_cpus(struct analysis_data *data)
> > +{
> > +       struct cpu_data *cpu_data;
> > +       int i;
> > +
> > +       for (i = 0; i < data->allocated_cpus; i++) {
> > +               cpu_data = &data->cpu_data[i];
> > +               if (!cpu_data->data)
> > +                       continue;
> > +               free_cpu_tasks(&cpu_data->tasks);
> > +       }
> > +       free(data->cpu_data);
> > +}
> > +
> > +static void do_trace_analyze(struct tracecmd_input *handle)
> > +{
> > +       struct tep_handle *tep = tracecmd_get_tep(handle);
> > +       struct tep_record *record;
> > +       struct analysis_data data;
> > +       struct cpu_data *cpu_data;
> > +       int i;
> > +
> > +       memset(&data, 0, sizeof(data));
> > +
> > +       trace_hash_init(&data.tasks, 128);
> > +
> > +       /* Set to a very large number */
> > +       data.start_ts = -1ULL;
> > +
> > +       do {
> > +               record = tracecmd_read_next_data(handle, NULL);
> > +               if (record)
> > +                       process_cpu(&data, tep, record);
> > +               tracecmd_free_record(record);
> > +       } while (record);
> > +
> > +       for (i = 0; i < data.allocated_cpus; i++) {
> > +               cpu_data = &data.cpu_data[i];
> > +               if (!cpu_data->data || !cpu_data->nr_tasks)
> > +                       continue;
> > +               if (cpu_data->last_ts > data.last_ts)
> > +                       data.last_ts = cpu_data->last_ts;
> > +       }
> > +
> > +       for (i = 0; i < data.allocated_cpus; i++) {
> > +               cpu_data = &data.cpu_data[i];
> > +               if (!cpu_data->data || !cpu_data->nr_tasks)
> > +                       continue;
> > +               cpu_data->last_ts = data.last_ts;
> > +               update_pid(cpu_data, NULL, -1);  
> 
> I think having update_last_pid() makes this easier to read.

You mean to add a helper function that does the last pid and have
update_pid() start with that?

I could do that.

Thanks for looking at this.

Note, I'm going to rewrite this so that this is actually part of the
library, to allow other applications to have access to this functionality.

-- Steve
