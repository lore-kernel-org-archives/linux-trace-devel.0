Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A8DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Mar 2022 16:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238285AbiC1QKA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Mar 2022 12:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241279AbiC1QJ5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Mar 2022 12:09:57 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEC1263E
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Mar 2022 09:08:15 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d7so21096554wrb.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Mar 2022 09:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nJMHlcyoTLlne0LIj2BKpuVcj+nXOIhLS33OceL/VMU=;
        b=OHFnlBiGKaFEE5SVqGbQBH1bnsfnEb8jVC7Vd1O23RshtlcJf3jwgSxS69bpcPUYkB
         JxfLQUr5ID22+PqEEGtKBD3gAmo8bn9ISLe0Fc3s3wNmTIE26LOMX4V2oIgDhdGHF07/
         McA7iMAVzTCPGACFkTuHSyZ0Gzkgs9PTGTkcgMg0Cp82RXB5RyUhwa4DeMZS4s5UhMiy
         4mq0ZstRzgt8tMf81ULmeraRTxlwlLb/1cTbJ2GJyR74K28YlJwRzwRMK1h3xcdopfzG
         NhJ/WfO5RdP5noh4zQgsG2vglTkNUT/QCKzsUuPDYFQDjP/acAjDfEULmKZniQcojQxA
         wEMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nJMHlcyoTLlne0LIj2BKpuVcj+nXOIhLS33OceL/VMU=;
        b=0EFrhWSRAR9DKYQmJVpZcsF3haRvo3cSGR7UKULmT+zSDtLTkNVjqFGQiKlvxVaem2
         7c8GCdjwqLFXNAheA9C3AUoeihPTmS3tEj9g1hwU4UALHEeAU8bxwLzDORz7R1+Bm1Gi
         OvznpVyXv+VrbkIIrHp7uQ+DK8xGDYV3ck84unY/tgjiD62C9jbYjF1YQp5RWBZKMbwU
         V9qhytqZAcnV0DZ7Ej60UvULUNsYUMdKwGxfYZnrMtCK8hVbpnGmS5xov/2ThKKHxQzb
         VJXuYe4ROqjvbW5XOf78FeMKRR7mCyc4wMfPoziSm/t6uert19QHm271G2uH00d7UQkv
         ER4g==
X-Gm-Message-State: AOAM530F9fF6bXW4qYfofiojFLgVUW++DEMelpJUlBHnA3QIhVWyAlTF
        Dl86OH7N55M5LHQdZwtVi1a0DyYQ/itOzHE4breguA==
X-Google-Smtp-Source: ABdhPJxS6hOqJMCgc1N5F7xW8foS66tcvFvv791Erm8/11kLP07KkxREn1DVHaUC9unaafvcqItlonfd9QGxFVkCVaU=
X-Received: by 2002:a05:6000:1864:b0:205:a10a:8b11 with SMTP id
 d4-20020a056000186400b00205a10a8b11mr19640340wri.577.1648483693798; Mon, 28
 Mar 2022 09:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220324025726.1727204-1-rostedt@goodmis.org> <20220324025726.1727204-2-rostedt@goodmis.org>
In-Reply-To: <20220324025726.1727204-2-rostedt@goodmis.org>
From:   Kalesh Singh <kaleshsingh@google.com>
Date:   Mon, 28 Mar 2022 09:08:02 -0700
Message-ID: <CAC_TJvfrQMyhSRHh7_z_Vx_6KDELQhyYnapyTBRDMBtKvCuitw@mail.gmail.com>
Subject: Re: [PATCH 01/12] trace-cmd: Add trace-cmd analyze
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, williskung@google.com,
        linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 23, 2022 at 7:57 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> Add a new trace-cmd command "analyze" that will look at a trace.dat file
> and report various statistics about the code.
>
> Start off by showing the amount each CPU is idle.
>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  tracecmd/Makefile              |   1 +
>  tracecmd/include/trace-local.h |   2 +
>  tracecmd/trace-analyze.c       | 508 +++++++++++++++++++++++++++++++++
>  tracecmd/trace-cmd.c           |   1 +
>  4 files changed, 512 insertions(+)
>  create mode 100644 tracecmd/trace-analyze.c
>
> diff --git a/tracecmd/Makefile b/tracecmd/Makefile
> index 355f04723ad7..895294d09092 100644
> --- a/tracecmd/Makefile
> +++ b/tracecmd/Makefile
> @@ -37,6 +37,7 @@ TRACE_CMD_OBJS +=3D trace-dump.o
>  TRACE_CMD_OBJS +=3D trace-clear.o
>  TRACE_CMD_OBJS +=3D trace-vm.o
>  TRACE_CMD_OBJS +=3D trace-convert.o
> +TRACE_CMD_OBJS +=3D trace-analyze.o
>
>  ifeq ($(VSOCK_DEFINED), 1)
>  TRACE_CMD_OBJS +=3D trace-agent.o
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-loca=
l.h
> index bb33de06bb58..f9d0745914fe 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -112,6 +112,8 @@ void trace_dump(int argc, char **argv);
>
>  void trace_convert(int argc, char **argv);
>
> +void trace_analyze(int argc, char **argv);
> +
>  int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
>                        int cpus, int *fds,
>                        int argc, char **argv, bool use_fifos,
> diff --git a/tracecmd/trace-analyze.c b/tracecmd/trace-analyze.c
> new file mode 100644
> index 000000000000..4a17cf12eb07
> --- /dev/null
> +++ b/tracecmd/trace-analyze.c
> @@ -0,0 +1,508 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +/*
> + * Copyright (C) 2022 Google Inc, Steven Rostedt <srostedt@redhat.com>
> + */
> +#define _LARGEFILE64_SOURCE
> +#include <getopt.h>
> +#include <stdlib.h>
> +
> +#include "trace-cmd-local.h"
> +#include "trace-local.h"
> +#include "trace-hash.h"
> +#include "list.h"
> +
> +static bool time_in_nsecs;
> +
> +struct analysis_data;
> +
> +struct cpu_data {
> +       unsigned long long      start_ts;
> +       unsigned long long      last_ts;
> +       struct analysis_data    *data;
> +       struct trace_hash       tasks;
> +       int                     nr_tasks;
> +       int                     cpu;
> +       int                     current_pid;
> +       int                     first_pid;
> +};
> +
> +struct analysis_data {
> +       unsigned long long      start_ts;
> +       unsigned long long      last_ts;
> +       struct cpu_data         *cpu_data;
> +       struct trace_hash       tasks;
> +       int                     nr_tasks;
> +       int                     allocated_cpus;
> +       int                     cpus;

Hi Steve,

I don't see analysis_data->cpus field ever used.

> +};
> +
> +struct task_item {
> +       unsigned long long      runtime;
> +       unsigned long long      start_ts;
> +       struct trace_hash_item  hash;
> +       int                     pid;
> +};
> +
> +struct task_cpu_item {
> +       struct trace_hash_item  hash;
> +       struct task_item        *task;
> +};
> +
> +#define CPU_BLOCKS     32
> +
> +#define task_from_hash(item) container_of(item, struct task_item, hash)
> +#define task_cpu_from_hash(item)  container_of(item, struct task_cpu_ite=
m, hash)
> +
> +static struct cpu_data *get_cpu_data(struct analysis_data *data,
> +                                    struct tep_record *record)
> +{
> +       struct cpu_data *cpu_data;
> +       int cpu =3D record->cpu;
> +       int cnt;
> +
> +       if (cpu < data->allocated_cpus) {
> +               cpu_data =3D &data->cpu_data[cpu];
> +               if (!cpu_data->data)
> +                       goto init_cpu_data;
> +               return cpu_data;
> +       }
> +
> +       /* Round up to CPU_BLOCKS multiplier */
> +       cnt =3D ((cpu + CPU_BLOCKS) / CPU_BLOCKS) * CPU_BLOCKS;
> +
> +       cpu_data =3D realloc(data->cpu_data, sizeof(*cpu_data) * cnt);
> +
> +       if (!cpu_data)
> +               die("Allocating cpu size %d for cpu %d", cnt, cpu);
> +
> +       memset(cpu_data + data->allocated_cpus, 0,
> +              sizeof(*cpu_data) * (cnt - data->allocated_cpus));
> +
> +       data->allocated_cpus =3D cnt;
> +
> +       data->cpu_data =3D cpu_data;
> +       cpu_data +=3D cpu;
> +
> + init_cpu_data:
> +       cpu_data->current_pid =3D -1;
> +       cpu_data->cpu =3D cpu;
> +       cpu_data->data =3D data;
> +
> +       trace_hash_init(&cpu_data->tasks, 32);

nit: #define CPU_TASKS_HASH_SIZE 32?

> +
> +       return cpu_data;
> +}
> +
> +static int check_idle(struct cpu_data *cpu_data, int pid)
> +{
> +       if (pid)
> +               return pid;
> +
> +       /*
> +        * Since pid 0 is the per cpu swapper task that
> +        * means several of these tasks have the same pid
> +        * and only differentiate between CPUs. Set the pid
> +        * that is stored in the hash as -2 - CPU id.
> +        */
> +
> +       return -2 - cpu_data->cpu;
> +}
> +
> +static struct task_item *get_task(struct cpu_data *cpu_data, int pid)
> +{
> +       struct trace_hash_item *hash;
> +       struct task_item *task;
> +       int find_pid;
> +
> +       find_pid =3D check_idle(cpu_data, pid);
> +
> +       hash =3D trace_hash_find(&cpu_data->data->tasks, find_pid, NULL, =
NULL);
> +       if (!hash) {
> +               task =3D calloc(sizeof(*task), 1);
> +               if (!task)
> +                       die("allocating task");
> +               task->pid =3D find_pid;
> +               hash =3D &task->hash;
> +               hash->key =3D find_pid;
> +               cpu_data->data->nr_tasks++;
> +               trace_hash_add(&cpu_data->data->tasks, hash);
> +       }
> +
> +       return task_from_hash(hash);
> +}
> +
> +static struct task_cpu_item *get_cpu_task(struct cpu_data *cpu_data, int=
 pid)
> +{
> +       struct trace_hash_item *hash;
> +       struct task_cpu_item *task;
> +
> +       hash =3D trace_hash_find(&cpu_data->tasks, pid, NULL, NULL);
> +       if (!hash) {
> +               task =3D calloc(sizeof(*task), 1);
> +               if (!task)
> +                       die("allocating cpu task");
> +               task->task =3D get_task(cpu_data, pid);
> +               hash =3D &task->hash;
> +               hash->key =3D pid;
> +               cpu_data->nr_tasks++;
> +               trace_hash_add(&cpu_data->tasks, hash);
> +       }
> +
> +       return task_cpu_from_hash(hash);
> +};
> +
> +/* Update times for a task scheduling off the CPU */
> +static void update_cpu_task_times(struct cpu_data *cpu_data,
> +                                 struct task_cpu_item *cpu_task,
> +                                 unsigned long long ts)
> +{
> +       unsigned long long delta;
> +       struct task_item *task =3D cpu_task->task;
> +
> +       /*
> +        * If the last event was a sched switch where the previous task
> +        * ran on another CPU, and migrated back to this CPU, and sched
> +        * switch was not recorded (saying that this task scheduled off)
> +        * It could be miscronstrued to still be on this CPU, and that
> +        * its start_ts is later than the last_ts of this CPU.
> +        */
> +       if (ts < task->start_ts)
> +               return;
> +
> +       delta =3D ts - task->start_ts;
> +       task->runtime +=3D delta;
> +}
> +
> +static void update_pid(struct cpu_data *cpu_data,
> +                      struct tep_record *record, int pid)
> +{
> +       struct task_cpu_item *cpu_task;
> +       struct task_item *task;
> +       int curr_pid =3D cpu_data->current_pid;
> +       unsigned long long delta;
> +
> +       cpu_task =3D get_cpu_task(cpu_data, curr_pid);
> +       task =3D cpu_task->task;
> +
> +       update_cpu_task_times(cpu_data, cpu_task, cpu_data->last_ts);
> +
> +       if (!record)
> +               return;
> +
> +       cpu_task =3D get_cpu_task(cpu_data, pid);
> +       task =3D cpu_task->task;
> +
> +       if (record->ts < cpu_data->last_ts) {
> +               tracecmd_warning("task %d start time %llu greater than CP=
U time %llu",
> +                                pid, record->ts, cpu_data->last_ts);

Shouldn=E2=80=99t this say, ... start time %llu "less than" CPU time ...?

> +       } else {
> +               delta =3D record->ts - cpu_data->last_ts;
> +               task->runtime +=3D delta;
> +       }
> +
> +       cpu_data->last_ts =3D record->ts;
> +
> +       task->start_ts =3D cpu_data->last_ts;
> +       cpu_data->current_pid =3D pid;
> +}
> +
> +static void update_cpu_times(struct cpu_data *cpu_data,
> +                            struct tep_handle *tep, int pid,
> +                            struct tep_record *record)
> +{
> +       struct task_cpu_item *cpu_task;
> +       struct task_item *task;
> +
> +       if (cpu_data->current_pid < 0) {
> +               /* First time called */
> +               cpu_data->start_ts =3D record->ts;
> +               cpu_data->last_ts =3D record->ts;
> +               cpu_data->current_pid =3D pid;
> +               cpu_data->first_pid =3D pid;
> +               cpu_task =3D get_cpu_task(cpu_data, pid);
> +               task =3D cpu_task->task;
> +               task->start_ts =3D record->ts;
> +               if (record->ts < cpu_data->data->start_ts)
> +                       cpu_data->data->start_ts =3D record->ts;
> +               return;
> +       }
> +
> +       if (pid !=3D cpu_data->current_pid) {
> +               update_pid(cpu_data, record, pid);
> +               return;
> +       }
> +
> +       cpu_data->last_ts =3D record->ts;
> +}
> +
> +static void update_first_pid(struct cpu_data *cpu_data)
> +{
> +       struct task_cpu_item *cpu_task;
> +       struct task_item *task;
> +       unsigned long long start_ts =3D cpu_data->data->start_ts;
> +       unsigned long long delta;
> +
> +       cpu_task =3D get_cpu_task(cpu_data, cpu_data->first_pid);
> +       task =3D cpu_task->task;
> +       delta =3D cpu_data->start_ts - start_ts;
> +       task->runtime +=3D delta;
> +       cpu_data->start_ts =3D start_ts;
> +}
> +
> +static void process_cpu(struct analysis_data *data,
> +                       struct tep_handle *tep,
> +                       struct tep_record *record)
> +{
> +       struct cpu_data *cpu_data;
> +       int pid;
> +
> +       pid =3D tep_data_pid(tep, record);
> +       if (pid < 0) /* Warn? */
> +               return;
> +
> +       cpu_data =3D get_cpu_data(data, record);
> +       update_cpu_times(cpu_data, tep, pid, record);
> +}
> +
> +static void print_time(unsigned long long ts, char delim)
> +{
> +       unsigned long long secs;
> +       unsigned long long msecs;
> +       unsigned long long usecs;
> +       unsigned long long nsecs;
> +
> +       secs =3D ts / 1000000000;
> +       ts -=3D secs * 1000000000;
> +
> +       msecs =3D ts / 1000000;
> +       ts -=3D msecs * 1000000;
> +
> +       usecs =3D ts / 1000;
> +       ts -=3D usecs * 1000;
> +
> +       nsecs =3D ts;
> +
> +       if (delim) {
> +               printf("%6llu.%03llu%c%03llu",
> +                      secs, msecs, delim, usecs);
> +               if (time_in_nsecs)
> +                       printf("%c%03llu", delim, nsecs);
> +       } else {
> +               printf("%6llu.%03llu%03llu",
> +                      secs, msecs, usecs);
> +               if (time_in_nsecs)
> +                       printf("%03llu", nsecs);
> +       }
> +}
> +
> +static void print_total(struct tep_handle *tep, struct analysis_data *da=
ta)
> +{
> +       unsigned long long total_time;
> +       struct trace_hash_item **bucket;
> +       struct trace_hash_item *item;
> +       struct task_item **idle_tasks;
> +       struct task_item *task;
> +       bool first =3D true;
> +       int cpu;
> +       int i =3D 0;
> +
> +       total_time =3D data->last_ts - data->start_ts;
> +       printf("\nTotal time: ");
> +       print_time(total_time, '_');
> +       printf("\n");
> +
> +       idle_tasks =3D calloc(sizeof(*idle_tasks), data->allocated_cpus);
> +       if (!idle_tasks)
> +               die("Could not allocate idle task array");
> +
> +       trace_hash_for_each_bucket(bucket, &data->tasks) {
> +               trace_hash_for_each_item(item, bucket) {
> +                       task =3D task_from_hash(item);
> +                       if (task->pid < 0) {
> +                               cpu =3D -2 - task->pid;
> +                               idle_tasks[cpu] =3D task;
> +                       }
> +               }
> +       }
> +
> +       for (i =3D 0; i < data->allocated_cpus; i++) {
> +               if (!idle_tasks[i])
> +                       continue;
> +
> +               if (first) {
> +                       printf("\n Idle CPU\t     Run time\n");
> +                       printf(" --------\t     --------\n");
> +                       first =3D false;
> +               }
> +               printf("CPU %d idle:\t", i);
> +               print_time(idle_tasks[i]->runtime, '_');
> +               printf(" (%%%lld)\n", (idle_tasks[i]->runtime * 100) / to=
tal_time);
> +       }
> +       free(idle_tasks);
> +}
> +
> +static void free_tasks(struct trace_hash *hash)
> +{
> +       struct trace_hash_item **bucket;
> +       struct trace_hash_item *item;
> +       struct task_item *task;
> +
> +       trace_hash_for_each_bucket(bucket, hash) {
> +               trace_hash_while_item(item, bucket) {
> +                       task =3D task_from_hash(item);
> +                       trace_hash_del(item);
> +                       free(task);
> +               }
> +       }
> +       trace_hash_free(hash);
> +}
> +
> +static void free_cpu_tasks(struct trace_hash *hash)
> +{
> +       struct trace_hash_item **bucket;
> +       struct trace_hash_item *item;
> +       struct task_cpu_item *cpu_task;
> +
> +       trace_hash_for_each_bucket(bucket, hash) {
> +               trace_hash_while_item(item, bucket) {
> +                       cpu_task =3D task_cpu_from_hash(item);
> +                       trace_hash_del(item);
> +                       free(cpu_task);
> +               }
> +       }
> +       trace_hash_free(hash);
> +}
> +
> +static void free_cpus(struct analysis_data *data)
> +{
> +       struct cpu_data *cpu_data;
> +       int i;
> +
> +       for (i =3D 0; i < data->allocated_cpus; i++) {
> +               cpu_data =3D &data->cpu_data[i];
> +               if (!cpu_data->data)
> +                       continue;
> +               free_cpu_tasks(&cpu_data->tasks);
> +       }
> +       free(data->cpu_data);
> +}
> +
> +static void do_trace_analyze(struct tracecmd_input *handle)
> +{
> +       struct tep_handle *tep =3D tracecmd_get_tep(handle);
> +       struct tep_record *record;
> +       struct analysis_data data;
> +       struct cpu_data *cpu_data;
> +       int i;
> +
> +       memset(&data, 0, sizeof(data));
> +
> +       trace_hash_init(&data.tasks, 128);
> +
> +       /* Set to a very large number */
> +       data.start_ts =3D -1ULL;
> +
> +       do {
> +               record =3D tracecmd_read_next_data(handle, NULL);
> +               if (record)
> +                       process_cpu(&data, tep, record);
> +               tracecmd_free_record(record);
> +       } while (record);
> +
> +       for (i =3D 0; i < data.allocated_cpus; i++) {
> +               cpu_data =3D &data.cpu_data[i];
> +               if (!cpu_data->data || !cpu_data->nr_tasks)
> +                       continue;
> +               if (cpu_data->last_ts > data.last_ts)
> +                       data.last_ts =3D cpu_data->last_ts;
> +       }
> +
> +       for (i =3D 0; i < data.allocated_cpus; i++) {
> +               cpu_data =3D &data.cpu_data[i];
> +               if (!cpu_data->data || !cpu_data->nr_tasks)
> +                       continue;
> +               cpu_data->last_ts =3D data.last_ts;
> +               update_pid(cpu_data, NULL, -1);

I think having update_last_pid() makes this easier to read.

Thanks,
Kalesh

> +               update_first_pid(cpu_data);
> +       }
> +
> +       print_total(tep, &data);
> +
> +       free_cpus(&data);
> +       free_tasks(&data.tasks);
> +}
> +
> +void trace_analyze(int argc, char **argv)
> +{
> +       struct tracecmd_input *handle;
> +       const char *input_file =3D NULL;
> +       int instances;
> +       int ret;
> +
> +       for (;;) {
> +               int c;
> +
> +               c =3D getopt(argc-1, argv+1, "+hti:");
> +               if (c =3D=3D -1)
> +                       break;
> +               switch (c) {
> +               case 'h':
> +                       usage(argv);
> +                       break;
> +               case 'i':
> +                       if (input_file)
> +                               die("Only one input for historgram");
> +                       input_file =3D optarg;
> +                       break;
> +               case 't':
> +                       time_in_nsecs =3D true;
> +                       break;
> +               default:
> +                       usage(argv);
> +               }
> +       }
> +
> +       if ((argc - optind) >=3D 2) {
> +               if (input_file)
> +                       usage(argv);
> +               input_file =3D argv[optind + 1];
> +       }
> +
> +       if (!input_file)
> +               input_file =3D DEFAULT_INPUT_FILE;
> +
> +       handle =3D tracecmd_alloc(input_file, 0);
> +       if (!handle)
> +               die("can't open %s\n", input_file);
> +
> +       ret =3D tracecmd_read_headers(handle, 0);
> +       if (ret)
> +               return;
> +
> +       ret =3D tracecmd_init_data(handle);
> +       if (ret < 0)
> +               die("failed to init data");
> +
> +       if (ret > 0)
> +               die("trace-cmd hist does not work with latency traces\n")=
;
> +
> +       do_trace_analyze(handle);
> +
> +       instances =3D tracecmd_buffer_instances(handle);
> +       if (instances) {
> +               struct tracecmd_input *new_handle;
> +               int i;
> +
> +               for (i =3D 0; i < instances; i++) {
> +                       new_handle =3D tracecmd_buffer_instance_handle(ha=
ndle, i);
> +                       if (!new_handle) {
> +                               warning("could not retrieve handle %d", i=
);
> +                               continue;
> +                       }
> +                       do_trace_analyze(new_handle);
> +                       tracecmd_close(new_handle);
> +               }
> +       }
> +
> +       tracecmd_close(handle);
> +}
> diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
> index a83a8d0bb9e4..d6e1f9dacc3c 100644
> --- a/tracecmd/trace-cmd.c
> +++ b/tracecmd/trace-cmd.c
> @@ -134,6 +134,7 @@ struct command commands[] =3D {
>         {"help", trace_usage},
>         {"dump", trace_dump},
>         {"convert", trace_convert},
> +       {"analyze", trace_analyze},
>         {"-h", trace_usage},
>  };
>
> --
> 2.35.1
>
