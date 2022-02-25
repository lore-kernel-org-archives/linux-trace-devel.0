Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAAE7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Feb 2022 15:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236500AbiBYPjD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Feb 2022 10:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242242AbiBYPjD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Feb 2022 10:39:03 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D366EB35;
        Fri, 25 Feb 2022 07:38:27 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id y5so5003859pfe.4;
        Fri, 25 Feb 2022 07:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2gNgDEob0kwC7aV1qgb06VVuC0MGH8rmLi7G7W3tDTI=;
        b=HG0ZKhBUjgbI03ATsiDmQ5VOClq4S48SPaS1HKZryC+Ageji5HNsalpo8L6bqwUC4A
         LzuGwSLIBS0coaMuxzRmakibHpp2UowxitXkhg2yYxD2DwJP67sQq6cnwh+oyulIcYwV
         8/cG/NTIJBcPJQq0mcjrY2SDmvFAexyTMCSA2oGzaGKOTqf+jZvwUr/K1srVgntrt3iY
         rNkzcpQcFeM67bePmWGhk0pHy2ZH8iRpeCDaz0Ds1PTarZ5MFZrv/jGmnDtpU4uuJdgK
         HJQyCbaKU/+mhiFULPlV0PPh9PBbpwFgXceHSx/FaAlL55cIevQGEXFFflxF4LgnrC+H
         D6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2gNgDEob0kwC7aV1qgb06VVuC0MGH8rmLi7G7W3tDTI=;
        b=oXmmYTrhMLTotP2YqkaFSLK3YqSzN2IqNkYTpZ4dlZwNGRmgyiTdDlkZNttwa3wd9t
         leFmswmnYqxqQ+R4e4m3/yx/WYI7VJaRo9V1PyGt0CKTsLuCBzjR4mCFk0NgZFP69dSP
         t6BPyQ82rsPq7cNp0lZ4HlB7GVwbly1OMr++diGX0jcp0/c9OLrfasj1XAHQ7tKlYMHA
         rCWBjSzCWY8EwETplMuFz2EecMTdL1KQIu4GwqsIiXaWlqbm1SLrLs95THRLIQx/Vp82
         6dMTAQhuuMM4d7OujadMBS33IpUwb7xSmCnBSEzA7hdTbHZ11VBVDW8jBdO81qf7qy5V
         3o9g==
X-Gm-Message-State: AOAM533SIl5KucOnJ94ukE2mwxdrwLTQgxmdilXE8ZXAisGBA2SGKo1b
        6Eh1UzJYgZdud1W9RrXFk2EQ8XL8AvNw4YWbWTY=
X-Google-Smtp-Source: ABdhPJz1GLhyEbcHsEX2utzkVoBRTphKlLBI7cSDrInx/D3VvFSZHTLWmrerrnerNXKqEGM/E63+gzzIE/YfytKUU4I=
X-Received: by 2002:a63:4a46:0:b0:34c:5f9c:cda7 with SMTP id
 j6-20020a634a46000000b0034c5f9ccda7mr6644772pgl.297.1645803506816; Fri, 25
 Feb 2022 07:38:26 -0800 (PST)
MIME-Version: 1.0
References: <20220224163711.185308-1-tz.stoyanov@gmail.com>
 <20220224163711.185308-3-tz.stoyanov@gmail.com> <Yhjs95hpDvboLltB@kernel.org>
In-Reply-To: <Yhjs95hpDvboLltB@kernel.org>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 25 Feb 2022 17:38:10 +0200
Message-ID: <CAPpZLN7KcKMZtd899s-ePZ+q4SJXd0x6aCkbJ_GpD8ikE=ZUWg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] trace-cruncher: Support for perf
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Jiri Olsa <olsajiri@gmail.com>,
        Ian Rogers <irogers@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Feb 25, 2022 at 4:51 PM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Thu, Feb 24, 2022 at 06:37:10PM +0200, Tzvetomir Stoyanov (VMware) esc=
reveu:
> > Initial perf support for trace-cruncher, using libperf. As a first
> > stage, collecting of stack trace samples of given process is supported.
>
> Are you aware of tools/perf/util/python.c? It was done for use in tuna:
>
> https://git.kernel.org/pub/scm/utils/tuna/tuna.git/
>
> I think it is already used in other tools, IIRC tuned also uses it:
>
> https://github.com/redhat-performance/tuned
>
> yeah:
>
> =E2=AC=A2[acme@toolbox tuned]$ grep -r "import perf" *
> tuned/plugins/plugin_irqbalance.py:import perf
> tuned/plugins/plugin_scheduler.py:import perf
> =E2=AC=A2[acme@toolbox tuned]$
>
> Please consider looking at it and possibly adding what you need. It is av=
ailable in most distros, I think:
>

Awesome! We'll look at this, thanks Arnaldo!

> Fedora:
>
> python3-perf.x86_64 : Python bindings for apps which will manipulate perf=
 events
>
> [root@five perf]# cat tools/perf/python/twatch.py
> #! /usr/bin/env python
> # SPDX-License-Identifier: GPL-2.0-only
> # -*- python -*-
> # -*- coding: utf-8 -*-
> #   twatch - Experimental use of the perf python interface
> #   Copyright (C) 2011 Arnaldo Carvalho de Melo <acme@redhat.com>
> #
>
> import perf
>
> def main(context_switch =3D 0, thread =3D -1):
>         cpus =3D perf.cpu_map()
>         threads =3D perf.thread_map(thread)
>         evsel =3D perf.evsel(type   =3D perf.TYPE_SOFTWARE,
>                            config =3D perf.COUNT_SW_DUMMY,
>                            task =3D 1, comm =3D 1, mmap =3D 0, freq =3D 0=
,
>                            wakeup_events =3D 1, watermark =3D 1,
>                            sample_id_all =3D 1, context_switch =3D contex=
t_switch,
>                            sample_type =3D perf.SAMPLE_PERIOD | perf.SAMP=
LE_TID | perf.SAMPLE_CPU)
>
>         """What we want are just the PERF_RECORD_ lifetime events for thr=
eads,
>          using the default, PERF_TYPE_HARDWARE + PERF_COUNT_HW_CYCLES & f=
req=3D1
>          (the default), makes perf reenable irq_vectors:local_timer_entry=
, when
>          disabling nohz, not good for some use cases where all we want is=
 to get
>          threads comes and goes... So use (perf.TYPE_SOFTWARE, perf_COUNT=
_SW_DUMMY,
>          freq=3D0) instead."""
>
>         evsel.open(cpus =3D cpus, threads =3D threads);
>         evlist =3D perf.evlist(cpus, threads)
>         evlist.add(evsel)
>         evlist.mmap()
>         while True:
>                 evlist.poll(timeout =3D -1)
>                 for cpu in cpus:
>                         event =3D evlist.read_on_cpu(cpu)
>                         if not event:
>                                 continue
>                         print("cpu: {0}, pid: {1}, tid: {2} {3}".format(e=
vent.sample_cpu,
>                                                                         e=
vent.sample_pid,
>                                                                         e=
vent.sample_tid,
>                                                                         e=
vent))
>
> if __name__ =3D=3D '__main__':
>     """
>         To test the PERF_RECORD_SWITCH record, pick a pid and replace
>         in the following line.
>
>         Example output:
>
> cpu: 3, pid: 31463, tid: 31593 { type: context_switch, next_prev_pid: 314=
63, next_prev_tid: 31593, switch_out: 1 }
> cpu: 1, pid: 31463, tid: 31489 { type: context_switch, next_prev_pid: 314=
63, next_prev_tid: 31489, switch_out: 1 }
> cpu: 2, pid: 31463, tid: 31496 { type: context_switch, next_prev_pid: 314=
63, next_prev_tid: 31496, switch_out: 1 }
> cpu: 3, pid: 31463, tid: 31491 { type: context_switch, next_prev_pid: 314=
63, next_prev_tid: 31491, switch_out: 0 }
>
>         It is possible as well to use event.misc & perf.PERF_RECORD_MISC_=
SWITCH_OUT
>         to figure out if this is a context switch in or out of the monito=
red threads.
>
>         If bored, please add command line option parsing support for thes=
e options :-)
>     """
>     # main(context_switch =3D 1, thread =3D 31463)
>     main()
> [root@five perf]# export PYTHONPATH=3D/tmp/build/perf/python_ext_build/li=
b/
> [root@five perf]# tools/perf/python/twatch.py
> cpu: 22, pid: 13290, tid: 3471647 { type: fork, pid: 13290, ppid: 13290, =
tid: 3471653, ptid: 3471647, time: 151504201166040}
> cpu: 27, pid: 13290, tid: 3471653 { type: comm, pid: 13290, tid: 3471653,=
 comm: MediaPD~oder #1 }
> cpu: 27, pid: 13290, tid: 3471653 { type: comm, pid: 13290, tid: 3471653,=
 comm: MediaPD~oder #1 }
> cpu: 27, pid: 13290, tid: 3471653 { type: fork, pid: 13290, ppid: 13290, =
tid: 3471654, ptid: 3471653, time: 151504201524181}
> cpu: 22, pid: 13290, tid: 3471654 { type: comm, pid: 13290, tid: 3471654,=
 comm: MediaPD~oder #2 }
> cpu: 22, pid: 13290, tid: 3471654 { type: comm, pid: 13290, tid: 3471654,=
 comm: MediaPD~oder #2 }
> cpu: 29, pid: 13290, tid: 3471653 { type: exit, pid: 13290, ppid: 12612, =
tid: 3471653, ptid: 12612, time: 151504213801994}
> cpu: 0, pid: 13290, tid: 3471654 { type: exit, pid: 13290, ppid: 12612, t=
id: 3471654, ptid: 12612, time: 151504213861954}
> cpu: 2, pid: 3471643, tid: 3471643 { type: exit, pid: 3471643, ppid: 1308=
0, tid: 3471643, ptid: 13080, time: 151505955082335}
> cpu: 20, pid: 13080, tid: 13080 { type: fork, pid: 3471655, ppid: 13080, =
tid: 3471655, ptid: 13080, time: 151505955346595}
> cpu: 20, pid: 13080, tid: 13080 { type: fork, pid: 3471656, ppid: 13080, =
tid: 3471656, ptid: 13080, time: 151505955523645}
> cpu: 20, pid: 13080, tid: 13080 { type: fork, pid: 3471657, ppid: 13080, =
tid: 3471657, ptid: 13080, time: 151505955649485}
> cpu: 9, pid: 3471656, tid: 3471656 { type: comm, pid: 3471656, tid: 34716=
56, comm: grep }
> cpu: 21, pid: 3471655, tid: 3471655 { type: comm, pid: 3471655, tid: 3471=
655, comm: sensors }
> cpu: 28, pid: 3471657, tid: 3471657 { type: comm, pid: 3471657, tid: 3471=
657, comm: sed }
> cpu: 21, pid: 3471655, tid: 3471655 { type: exit, pid: 3471655, ppid: 130=
80, tid: 3471655, ptid: 13080, time: 151505986031034}
> cpu: 20, pid: 3471656, tid: 3471656 { type: exit, pid: 3471656, ppid: 130=
80, tid: 3471656, ptid: 13080, time: 151505986154194}
> cpu: 22, pid: 3471657, tid: 3471657 { type: exit, pid: 3471657, ppid: 130=
80, tid: 3471657, ptid: 13080, time: 151505986292214}
> cpu: 23, pid: 13080, tid: 13080 { type: fork, pid: 3471658, ppid: 13080, =
tid: 3471658, ptid: 13080, time: 151505986418014}
> cpu: 27, pid: 3471658, tid: 3471658 { type: comm, pid: 3471658, tid: 3471=
658, comm: sleep }
> ^CTraceback (most recent call last):
>   File "/var/home/acme/git/perf/tools/perf/python/twatch.py", line 61, in=
 <module>
>     main()
>   File "/var/home/acme/git/perf/tools/perf/python/twatch.py", line 33, in=
 main
>     evlist.poll(timeout =3D -1)
> KeyboardInterrupt
>
> [root@five perf]#
>
>
>
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  setup.py           |   9 +-
> >  src/perfpy-utils.c | 699 +++++++++++++++++++++++++++++++++++++++++++++
> >  src/perfpy-utils.h |  41 +++
> >  src/perfpy.c       | 141 +++++++++
> >  4 files changed, 889 insertions(+), 1 deletion(-)
> >  create mode 100644 src/perfpy-utils.c
> >  create mode 100644 src/perfpy-utils.h
> >  create mode 100644 src/perfpy.c
> >
> > diff --git a/setup.py b/setup.py
> > index 4d7e727..31ca2e3 100644
> > --- a/setup.py
> > +++ b/setup.py
> > @@ -19,18 +19,21 @@ def third_party_paths():
> >      pkg_ftracepy =3D pkg.parse('libtracefs')
> >      pkg_tracecmd =3D pkg.parse('libtracecmd')
> >      pkg_kshark =3D pkg.parse('libkshark')
> > +    pkg_perf =3D pkg.parse('libperf')
> >
> >      include_dirs =3D [np.get_include()]
> >      include_dirs.extend(pkg_traceevent['include_dirs'])
> >      include_dirs.extend(pkg_ftracepy['include_dirs'])
> >      include_dirs.extend(pkg_tracecmd['include_dirs'])
> >      include_dirs.extend(pkg_kshark['include_dirs'])
> > +    include_dirs.extend(pkg_perf['include_dirs'])
> >
> >      library_dirs =3D []
> >      library_dirs.extend(pkg_traceevent['library_dirs'])
> >      library_dirs.extend(pkg_ftracepy['library_dirs'])
> >      library_dirs.extend(pkg_tracecmd['library_dirs'])
> >      library_dirs.extend(pkg_kshark['library_dirs'])
> > +    library_dirs.extend(pkg_perf['library_dirs'])
> >      library_dirs =3D list(set(library_dirs))
> >
> >      return include_dirs, library_dirs
> > @@ -61,6 +64,10 @@ def main():
> >                            sources=3D['src/ksharkpy.c', 'src/ksharkpy-u=
tils.c'],
> >                            libraries=3D['kshark'])
> >
> > +    module_perf =3D extension(name=3D'tracecruncher.perfpy',
> > +                            sources=3D['src/perfpy.c', 'src/perfpy-uti=
ls.c', 'src/trace-obj-debug.c'],
> > +                            libraries=3D['traceevent', 'perf', 'bfd'])
> > +
> >      setup(name=3D'tracecruncher',
> >            version=3D'0.1.0',
> >            description=3D'NumPy based interface for accessing tracing d=
ata in Python.',
> > @@ -69,7 +76,7 @@ def main():
> >            url=3D'https://github.com/vmware/trace-cruncher',
> >            license=3D'LGPL-2.1',
> >            packages=3Dfind_packages(),
> > -          ext_modules=3D[module_ft, module_data, module_ks],
> > +          ext_modules=3D[module_ft, module_data, module_ks, module_per=
f],
> >            classifiers=3D[
> >                'Development Status :: 3 - Alpha',
> >                'Programming Language :: Python :: 3',
> > diff --git a/src/perfpy-utils.c b/src/perfpy-utils.c
> > new file mode 100644
> > index 0000000..ae57a63
> > --- /dev/null
> > +++ b/src/perfpy-utils.c
> > @@ -0,0 +1,699 @@
> > +// SPDX-License-Identifier: LGPL-2.1
> > +
> > +/*
> > + * Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov=
@gmail.com>
> > + */
> > +
> > +#ifndef _GNU_SOURCE
> > +/** Use GNU C Library. */
> > +#define _GNU_SOURCE
> > +#endif // _GNU_SOURCE
> > +
> > +// C
> > +#include <stdio.h>
> > +#include <unistd.h>
> > +#include <pthread.h>
> > +#include <sys/stat.h>
> > +#include <fcntl.h>
> > +#include <dirent.h>
> > +#include <sys/resource.h>
> > +
> > +// libperf
> > +#include <linux/perf_event.h>
> > +#include <perf/evlist.h>
> > +#include <perf/evsel.h>
> > +#include <perf/cpumap.h>
> > +#include <perf/threadmap.h>
> > +#include <perf/mmap.h>
> > +#include <perf/core.h>
> > +#include <perf/event.h>
> > +
> > +// trace-cruncher
> > +#include "perfpy-utils.h"
> > +#include "trace-obj-debug.h"
> > +
> > +PyObject *PERF_ERROR;
> > +
> > +#define TMP_FILE "/tmp/perf_temp_data.XXXXXX"
> > +
> > +struct perf_scan_thread {
> > +     uint32_t tid;
> > +     char *comm;
> > +     struct perf_counts_values count;
> > +};
> > +
> > +struct perf_handle {
> > +     bool running;
> > +     pthread_t reader;
> > +     int fd;
> > +     int thr_count;
> > +     uint32_t pid;
> > +     struct perf_scan_thread *thr_map;
> > +     struct perf_evlist *evlist;
> > +     struct perf_evsel *evsel;
> > +     struct perf_event_attr attr;
> > +     struct perf_cpu_map *cpus;
> > +     struct trace_debug_object *debug;
> > +     struct perf_thread_map *threads;
> > +};
> > +
> > +struct event_sample {
> > +     uint64_t                id;             /* PERF_SAMPLE_IDENTIFIER=
 */
> > +     uint64_t                ip;             /* PERF_SAMPLE_IP */
> > +     uint32_t                pid, tid;       /* PERF_SAMPLE_TID */
> > +     uint64_t                time;           /* PERF_SAMPLE_TIME */
> > +     uint32_t                cpu, res;       /* PERF_SAMPLE_CPU */
> > +     uint64_t                nr;
> > +     uint64_t                ips[];          /* PERF_SAMPLE_CALLCHAIN =
*/
> > +} __attribute__((packed));
> > +
> > +struct perf_event_sample {
> > +     struct event_sample     data;
> > +     struct perf_handle      *perf;
> > +     char                    *ip;
> > +     char                    *ips[];
> > +} __attribute__((packed));
> > +
> > +static void perf_reader_stop(struct perf_handle *perf)
> > +{
> > +
> > +     if (!perf->running)
> > +             return;
> > +
> > +     perf->running =3D false;
> > +     pthread_join(perf->reader, NULL);
> > +     fsync(perf->fd);
> > +     if (perf->debug)
> > +             trace_debug_resolve_symbols(perf->debug);
> > +}
> > +
> > +void py_perf_handle_free(struct perf_handle *perf)
> > +{
> > +     int i;
> > +
> > +     if (perf) {
> > +             perf_reader_stop(perf);
> > +             perf_evlist__delete(perf->evlist);
> > +             if (perf->fd >=3D 0)
> > +                     close(perf->fd);
> > +             if (perf->debug)
> > +                     trace_debug_obj_destroy(perf->debug);
> > +             if (perf->thr_map) {
> > +                     for (i =3D 0; i < perf->thr_count; i++)
> > +                             free(perf->thr_map[i].comm);
> > +                     free(perf->thr_map);
> > +             }
> > +     }
> > +
> > +     free(perf);
> > +}
> > +
> > +void py_perf_sample_free(struct perf_event_sample *sample)
> > +{
> > +     unsigned int i;
> > +
> > +     if (sample) {
> > +             free(sample->ip);
> > +             for (i =3D 0; i < sample->data.nr; i++)
> > +                     free((char *)(sample->ips[i]));
> > +     }
> > +     free(sample);
> > +}
> > +
> > +static int pid_filter(const struct dirent *dir)
> > +{
> > +     const char *dname =3D dir->d_name;
> > +
> > +     if (!dname || dname[0] =3D=3D '.')
> > +             return 0;
> > +
> > +     while (*dname) {
> > +             if (!isdigit(*dname))
> > +                     return 0;
> > +             dname++;
> > +     }
> > +
> > +     return 1;
> > +}
> > +
> > +static  int str_read_file(const char *file, char **buffer)
> > +{
> > +     char stbuf[BUFSIZ];
> > +     char *buf =3D NULL;
> > +     int size =3D 0;
> > +     char *nbuf;
> > +     int fd;
> > +     int r;
> > +
> > +     fd =3D open(file, O_RDONLY);
> > +     if (fd < 0)
> > +             return -1;
> > +
> > +     do {
> > +             r =3D read(fd, stbuf, BUFSIZ);
> > +             if (r <=3D 0)
> > +                     continue;
> > +             nbuf =3D realloc(buf, size+r+1);
> > +             if (!nbuf) {
> > +                     size =3D -1;
> > +                     break;
> > +             }
> > +             buf =3D nbuf;
> > +             memcpy(buf+size, stbuf, r);
> > +             size +=3D r;
> > +     } while (r > 0);
> > +
> > +     close(fd);
> > +     if (r =3D=3D 0 && size > 0) {
> > +             buf[size] =3D '\0';
> > +             *buffer =3D buf;
> > +     } else
> > +             free(buf);
> > +
> > +     return size;
> > +}
> > +
> > +static void strip_control_chars(char *str)
> > +{
> > +     while (*str) {
> > +             if (iscntrl(*str)) {
> > +                     *str =3D '\0';
> > +                     break;
> > +             }
> > +             str++;
> > +     }
> > +}
> > +
> > +static struct perf_thread_map *create_thread_map(struct perf_handle *p=
erf, int pid)
> > +{
> > +     struct perf_thread_map *tmap =3D NULL;
> > +     struct dirent **pids =3D NULL;
> > +     char path[PATH_MAX];
> > +     int i, count;
> > +
> > +     snprintf(path, PATH_MAX, "/proc/%d/task", pid);
> > +     count =3D scandir(path, &pids, pid_filter, NULL);
> > +     if (count < 1)
> > +             goto out;
> > +
> > +     tmap =3D perf_thread_map__new_array(count, NULL);
> > +     if (!tmap)
> > +             goto out;
> > +     free(perf->thr_map);
> > +     perf->thr_map =3D calloc(count, sizeof(struct perf_scan_thread));
> > +     if (!perf->thr_map)
> > +             goto out;
> > +     perf->thr_count =3D count;
> > +
> > +     for (i =3D 0; i < count; i++) {
> > +             perf->thr_map[i].tid =3D atoi(pids[i]->d_name);
> > +             perf_thread_map__set_pid(tmap, i, perf->thr_map[i].tid);
> > +             snprintf(path, PATH_MAX, "/proc/%d/task/%s/comm", pid, pi=
ds[i]->d_name);
> > +             str_read_file(path, &perf->thr_map[i].comm);
> > +             strip_control_chars(perf->thr_map[i].comm);
> > +     }
> > +     perf_thread_map__read_comms(tmap);
> > +
> > +out:
> > +     if (pids) {
> > +             for (i =3D 0; i < count; i++)
> > +                     free(pids[i]);
> > +             free(pids);
> > +     }
> > +
> > +     return tmap;
> > +}
> > +
> > +static struct perf_handle *new_perf_sampling_handle(pid_t pid, int fre=
q)
> > +{
> > +     struct perf_handle *perf =3D NULL;
> > +     char *tmp_file =3D NULL;
> > +
> > +     perf =3D calloc(1, sizeof(*perf));
> > +     if (!perf)
> > +             return NULL;
> > +
> > +     perf->fd =3D -1;
> > +     perf->attr.type        =3D PERF_TYPE_HARDWARE;
> > +     perf->attr.config      =3D PERF_COUNT_HW_CPU_CYCLES;
> > +     perf->attr.disabled    =3D 1;
> > +     perf->attr.freq        =3D 1;
> > +     perf->attr.sample_freq =3D freq;
> > +     perf->attr.exclude_kernel =3D 1;
> > +     perf->attr.exclude_idle =3D 1;
> > +     perf->attr.exclude_callchain_kernel =3D 1;
> > +     perf->attr.comm =3D 1;
> > +     perf->attr.mmap2 =3D 1;
> > +     perf->attr.task =3D 1;
> > +     perf->attr.precise_ip =3D 0;
> > +     perf->attr.inherit =3D 1;
> > +     perf->attr.task =3D 1;
> > +     perf->attr.inherit_stat =3D 1;
> > +     perf->attr.read_format =3D PERF_FORMAT_TOTAL_TIME_ENABLED |
> > +                              PERF_FORMAT_TOTAL_TIME_RUNNING;
> > +     perf->attr.sample_type =3D PERF_SAMPLE_IDENTIFIER |
> > +                              PERF_SAMPLE_IP |
> > +                              PERF_SAMPLE_TID |
> > +                              PERF_SAMPLE_TIME |
> > +                              PERF_SAMPLE_CPU |
> > +                              PERF_SAMPLE_CALLCHAIN;
> > +
> > +     /* trace all CPUs in the system */
> > +     perf->cpus =3D perf_cpu_map__new(NULL);
> > +     if (!perf->cpus) {
> > +             PyErr_Format(PERF_ERROR, "Failed to create perf cpu map")=
;
> > +             goto error;
> > +     }
> > +
> > +     if (pid >=3D 0) {
> > +             perf->pid =3D pid;
> > +             perf->threads =3D create_thread_map(perf, pid);
> > +             if (!perf->threads) {
> > +                     PyErr_Format(PERF_ERROR, "Failed to create perf t=
hreads map");
> > +                     goto error;
> > +             }
> > +             perf->debug =3D trace_debug_obj_create_pid(pid);
> > +     }
> > +
> > +     perf->evlist =3D perf_evlist__new();
> > +     if (!perf->evlist) {
> > +             PyErr_Format(PERF_ERROR, "Failed to create perf events li=
st");
> > +             goto error;
> > +     }
> > +
> > +     tmp_file =3D strdup(TMP_FILE);
> > +     if (!tmp_file)
> > +             goto error;
> > +
> > +     mktemp(tmp_file);
> > +     perf->fd =3D open(tmp_file, O_RDWR|O_CREAT|O_TRUNC, 0600);
> > +     unlink(tmp_file);
> > +     if (perf->fd < 0)
> > +             goto error;
> > +
> > +     perf->evsel =3D perf_evsel__new(&perf->attr);
> > +     if (!perf->evsel) {
> > +             PyErr_Format(PERF_ERROR, "Failed to create perf cycles");
> > +             goto error;
> > +     }
> > +
> > +     perf_evlist__add(perf->evlist, perf->evsel);
> > +     perf_evlist__set_maps(perf->evlist, perf->cpus, perf->threads);
> > +
> > +     free(tmp_file);
> > +     return perf;
> > +
> > +error:
> > +     perf_cpu_map__put(perf->cpus);
> > +     perf_thread_map__put(perf->threads);
> > +     py_perf_handle_free(perf);
> > +     free(tmp_file);
> > +     return NULL;
> > +}
> > +
> > +PyObject *PyPerfSample_new(PyObject *self, PyObject *args, PyObject *k=
wargs)
> > +{
> > +     static char *kwlist[] =3D {"pid", "freq", NULL};
> > +     struct perf_handle *perf =3D NULL;
> > +     int freq =3D 10, pid =3D -1;
> > +
> > +     if (!PyArg_ParseTupleAndKeywords(args,
> > +                                      kwargs,
> > +                                      "i|i",
> > +                                      kwlist,
> > +                                      &pid,
> > +                                      &freq
> > +                                      )) {
> > +             return NULL;
> > +     }
> > +
> > +     perf =3D new_perf_sampling_handle(pid, freq);
> > +     if (!perf)
> > +             return NULL;
> > +
> > +     return PyPerf_New(perf);
> > +}
> > +
> > +static void perf_read_sample(struct perf_handle *perf, struct perf_rec=
ord_sample *event)
> > +{
> > +     struct event_sample *sample;
> > +     uint64_t i;
> > +
> > +     sample =3D (struct event_sample *)(event->array);
> > +
> > +     /* check if the sample is for our PID */
> > +     if (sample->pid !=3D perf->pid)
> > +             return;
> > +
> > +     if (perf->debug)
> > +             trace_debug_add_resolve_symbol(perf->debug, sample->ip, N=
ULL);
> > +
> > +     if (write(perf->fd, sample, sizeof(*sample)) !=3D sizeof(*sample)=
)
> > +             return;
> > +
> > +     for (i =3D 0; i < sample->nr; i++) {
> > +             if (write(perf->fd, &sample->ips[i], sizeof(uint64_t)) !=
=3D sizeof(uint64_t))
> > +                     return;
> > +             if (perf->debug)
> > +                     trace_debug_add_resolve_symbol(perf->debug, sampl=
e->ips[i], NULL);
> > +     }
> > +}
> > +
> > +/* A new memory is mapped to traced process */
> > +static void perf_read_mmap2(struct perf_handle *perf, struct perf_reco=
rd_mmap2 *mmap)
> > +{
> > +     /* check if mmap is for our PID */
> > +     if (perf->pid !=3D mmap->pid)
> > +             return;
> > +
> > +     /* check if executable memory is mapped */
> > +     if (mmap->header.misc & PERF_RECORD_MISC_MMAP_DATA)
> > +             return;
> > +
> > +     /*
> > +      * A new dynamic library is dlopen() by the traced process,
> > +      * store it for vma -> name resolving
> > +      */
> > +     trace_debug_obj_add_file(perf->debug, mmap->filename,
> > +                              mmap->start, mmap->start + mmap->len, mm=
ap->pgoff);
> > +}
> > +
> > +/* A new thread is started */
> > +static void perf_read_comm(struct perf_handle *perf, struct perf_recor=
d_comm *comm)
> > +{
> > +     struct perf_scan_thread *tmp;
> > +     int i;
> > +
> > +     /* check if the thread is started by PID */
> > +     if (perf->pid !=3D comm->pid)
> > +             return;
> > +
> > +     for (i =3D 0; i < perf->thr_count; i++) {
> > +             if (perf->thr_map[i].tid =3D=3D comm->tid) {
> > +                     free(perf->thr_map[i].comm);
> > +                     perf->thr_map[i].comm =3D strdup(comm->comm);
> > +                     return;
> > +             }
> > +     }
> > +
> > +     tmp =3D realloc(perf->thr_map, (perf->thr_count + 1) * sizeof(str=
uct perf_scan_thread));
> > +     if (!tmp)
> > +             return;
> > +
> > +     perf->thr_map =3D tmp;
> > +     perf->thr_map[perf->thr_count].tid =3D comm->tid;
> > +     perf->thr_map[perf->thr_count].comm =3D strdup(comm->comm);
> > +     perf->thr_count++;
> > +}
> > +
> > +static void *perf_reader_thread(void *data)
> > +{
> > +     struct perf_handle *perf =3D data;
> > +     struct perf_mmap *map;
> > +     union perf_event *event;
> > +
> > +     perf_evlist__enable(perf->evlist);
> > +
> > +     while (true) {
> > +             if (!perf->running)
> > +                     break;
> > +             perf_evlist__for_each_mmap(perf->evlist, map, false) {
> > +                     if (perf_mmap__read_init(map) < 0)
> > +                             continue;
> > +
> > +                     while ((event =3D perf_mmap__read_event(map)) !=
=3D NULL) {
> > +
> > +                             switch (event->sample.header.type) {
> > +                             case PERF_RECORD_SAMPLE:
> > +                                     perf_read_sample(perf, (struct pe=
rf_record_sample *)event);
> > +                                     break;
> > +                             case PERF_RECORD_COMM:
> > +                                     perf_read_comm(perf, (struct perf=
_record_comm *)event);
> > +                                     break;
> > +                             case PERF_RECORD_MMAP2:
> > +                                     perf_read_mmap2(perf, (struct per=
f_record_mmap2 *)event);
> > +                                     break;
> > +                             }
> > +
> > +                             perf_mmap__consume(map);
> > +                     }
> > +
> > +                     perf_mmap__read_done(map);
> > +             }
> > +     }
> > +     perf_evlist__disable(perf->evlist);
> > +     pthread_exit(0);
> > +}
> > +
> > +static int increase_file_limit(void)
> > +{
> > +     struct rlimit lim;
> > +
> > +     if (getrlimit(RLIMIT_NOFILE, &lim))
> > +             return -1;
> > +
> > +     if (lim.rlim_cur < lim.rlim_max) {
> > +             lim.rlim_cur =3D lim.rlim_max;
> > +     } else {
> > +             lim.rlim_cur +=3D 100;
> > +             lim.rlim_max +=3D 100;
> > +     }
> > +
> > +     return setrlimit(RLIMIT_NOFILE, &lim);
> > +}
> > +
> > +static int perf_reader_start(struct perf_handle *perf)
> > +{
> > +     pthread_attr_t attrib;
> > +     int err =3D 0;
> > +
> > +     if (perf->running)
> > +             return 0;
> > +
> > +     pthread_attr_init(&attrib);
> > +     pthread_attr_setdetachstate(&attrib, PTHREAD_CREATE_JOINABLE);
> > +
> > +     do {
> > +             err =3D perf_evlist__open(perf->evlist);
> > +             if (!err)
> > +                     break;
> > +             if (err !=3D -EMFILE)
> > +                     goto out;
> > +             if (increase_file_limit())
> > +                     goto out;
> > +     } while (err);
> > +
> > +     err =3D perf_evlist__mmap(perf->evlist, 4);
> > +     if (err)
> > +             goto out;
> > +
> > +     perf->running =3D true;
> > +     err =3D pthread_create(&perf->reader, &attrib, perf_reader_thread=
, perf);
> > +     if (err)
> > +             goto out;
> > +
> > +out:
> > +     pthread_attr_destroy(&attrib);
> > +     if (err) {
> > +             perf_evlist__close(perf->evlist);
> > +             perf->running =3D false;
> > +     }
> > +     return err;
> > +}
> > +
> > +PyObject *PyPerf_start(PyPerf *self)
> > +{
> > +     struct perf_handle *perf =3D self->ptrObj;
> > +     int err;
> > +
> > +     if (perf->running) {
> > +             PyErr_Format(PERF_ERROR, "Perf reader is already started"=
);
> > +             return NULL;
> > +     }
> > +
> > +     err =3D perf_reader_start(perf);
> > +     if (err) {
> > +             PyErr_Format(PERF_ERROR,
> > +                          "Failed to start perf reader - %s", strerror=
(-err));
> > +             return NULL;
> > +     }
> > +
> > +     Py_RETURN_NONE;
> > +}
> > +
> > +PyObject *PyPerf_stop(PyPerf *self)
> > +{
> > +     struct perf_handle *perf =3D self->ptrObj;
> > +
> > +     if (!perf->running) {
> > +             PyErr_Format(PERF_ERROR, "Perf reader is not started");
> > +             return NULL;
> > +     }
> > +
> > +     perf_reader_stop(perf);
> > +
> > +     Py_RETURN_NONE;
> > +}
> > +
> > +struct symb_walk {
> > +     uint64_t ip;
> > +     char *name;
> > +};
> > +
> > +static int sym_get(struct tracecmd_debug_symbols *symb, void *data)
> > +{
> > +     struct symb_walk *s =3D (struct symb_walk *)data;
> > +
> > +     if (s->ip =3D=3D symb->vma_near) {
> > +             if (symb->name)
> > +                     asprintf(&s->name, "%s @ %s", symb->name, symb->f=
name);
> > +             else
> > +                     asprintf(&s->name, "(0x%llX) @ %s", symb->vma_nea=
r, symb->fname);
> > +             return 1;
> > +     }
> > +     return 0;
> > +}
> > +
> > +static char *ip_name(struct perf_handle *perf, uint64_t ip)
> > +{
> > +     struct symb_walk symb;
> > +
> > +     symb.ip =3D ip;
> > +     symb.name =3D NULL;
> > +     if (perf && perf->debug)
> > +             trace_debug_walk_resolved_symbols(perf->debug, sym_get, &=
symb);
> > +
> > +     if (!symb.name)
> > +             asprintf(&symb.name, "0x%lX", ip);
> > +
> > +     return symb.name;
> > +}
> > +
> > +PyObject *PyPerf_getSamples(PyPerf *self)
> > +{
> > +     struct perf_handle *perf =3D self->ptrObj;
> > +     struct event_sample sample;
> > +     struct perf_event_sample *store;
> > +     PyObject *slist, *sobject;
> > +     uint64_t i, ip;
> > +     int ca =3D 0, cs =3D 0;
> > +
> > +     if (perf->running) {
> > +             PyErr_Format(PERF_ERROR, "Perf reader is running");
> > +             return NULL;
> > +     }
> > +
> > +     if (lseek(perf->fd, 0, SEEK_SET) =3D=3D (off_t)-1) {
> > +             PyErr_Format(PERF_ERROR, "No samples");
> > +             return NULL;
> > +     }
> > +
> > +     slist =3D PyList_New(0);
> > +     do {
> > +             if (read(perf->fd, &sample, sizeof(sample)) !=3D sizeof(s=
ample))
> > +                     break;
> > +             ca++;
> > +             store =3D calloc(1, sizeof(*store) + (sample.nr * sizeof(=
char *)));
> > +             if (!store)
> > +                     break;
> > +             memcpy(&store->data, &sample, sizeof(sample));
> > +             store->perf =3D perf;
> > +             store->ip =3D ip_name(perf, store->data.ip);
> > +             for (i =3D 0; i < sample.nr; i++) {
> > +                     if (read(perf->fd, &ip, sizeof(uint64_t)) !=3D si=
zeof(uint64_t))
> > +                             break;
> > +                     store->ips[i] =3D ip_name(perf, ip);
> > +             }
> > +             cs +=3D sample.nr;
> > +             if (i < sample.nr)
> > +                     break;
> > +             sobject =3D PyPerfEventSample_New(store);
> > +             PyList_Append(slist, sobject);
> > +     } while (true);
> > +     ftruncate(perf->fd, 0);
> > +     return slist;
> > +}
> > +
> > +PyObject *PyPerfSample_id(PyPerfEventSample *self)
> > +{
> > +     struct perf_event_sample *sample =3D self->ptrObj;
> > +
> > +     return PyLong_FromUnsignedLongLong(sample->data.id);
> > +}
> > +
> > +PyObject *PyPerfSample_pid(PyPerfEventSample *self)
> > +{
> > +     struct perf_event_sample *sample =3D self->ptrObj;
> > +
> > +     return PyLong_FromUnsignedLong(sample->data.pid);
> > +}
> > +
> > +PyObject *PyPerfSample_tid(PyPerfEventSample *self)
> > +{
> > +     struct perf_event_sample *sample =3D self->ptrObj;
> > +
> > +     return PyLong_FromUnsignedLong(sample->data.tid);
> > +}
> > +
> > +PyObject *PyPerfSample_time(PyPerfEventSample *self)
> > +{
> > +     struct perf_event_sample *sample =3D self->ptrObj;
> > +
> > +     return PyLong_FromUnsignedLongLong(sample->data.time);
> > +}
> > +
> > +PyObject *PyPerfSample_cpu(PyPerfEventSample *self)
> > +{
> > +     struct perf_event_sample *sample =3D self->ptrObj;
> > +
> > +     return PyLong_FromUnsignedLong(sample->data.cpu);
> > +}
> > +
> > +PyObject *PyPerfSample_nr(PyPerfEventSample *self)
> > +{
> > +     struct perf_event_sample *sample =3D self->ptrObj;
> > +
> > +     return PyLong_FromUnsignedLongLong(sample->data.nr);
> > +}
> > +
> > +PyObject *PyPerfSample_ip(PyPerfEventSample *self)
> > +{
> > +     struct perf_event_sample *sample =3D self->ptrObj;
> > +
> > +     return PyUnicode_FromString(sample->ip);
> > +}
> > +
> > +PyObject *PyPerfSample_tid_comm(PyPerfEventSample *self, PyObject *arg=
s, PyObject *kwargs)
> > +{
> > +     struct perf_event_sample *sample =3D self->ptrObj;
> > +     char *name =3D NULL;
> > +     int i;
> > +
> > +     if (!sample->perf || !sample->perf->thr_count || !sample->perf->t=
hr_map)
> > +             Py_RETURN_NONE;
> > +
> > +     for (i =3D 0; i < sample->perf->thr_count; i++)
> > +             if (sample->perf->thr_map[i].tid =3D=3D sample->data.tid)
> > +                     break;
> > +
> > +     if (i < sample->perf->thr_count && sample->perf->thr_map[i].comm)
> > +             name =3D sample->perf->thr_map[i].comm;
> > +
> > +     if (name)
> > +             return PyUnicode_FromString(name);
> > +
> > +     Py_RETURN_NONE;
> > +}
> > +
> > +PyObject *PyPerfSample_ips(PyPerfEventSample *self)
> > +{
> > +     struct perf_event_sample *sample =3D self->ptrObj;
> > +     PyObject *slist;
> > +     unsigned int i;
> > +
> > +     slist =3D PyList_New(0);
> > +     for (i =3D 0 ; i < sample->data.nr; i++)
> > +             PyList_Append(slist, PyUnicode_FromString((char *)sample-=
>ips[i]));
> > +
> > +     return slist;
> > +}
> > diff --git a/src/perfpy-utils.h b/src/perfpy-utils.h
> > new file mode 100644
> > index 0000000..0727a9a
> > --- /dev/null
> > +++ b/src/perfpy-utils.h
> > @@ -0,0 +1,41 @@
> > +/* SPDX-License-Identifier: LGPL-2.1 */
> > +
> > +/*
> > + * Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov=
@gmail.com>
> > + */
> > +
> > +#ifndef _TC_PERF_PY_UTILS
> > +#define _TC_PERF_PY_UTILS
> > +
> > +// Python
> > +#include <Python.h>
> > +
> > +// trace-cruncher
> > +#include "common.h"
> > +
> > +struct perf_handle;
> > +struct perf_event_sample;
> > +
> > +C_OBJECT_WRAPPER_DECLARE(perf_handle, PyPerf);
> > +C_OBJECT_WRAPPER_DECLARE(perf_event_sample, PyPerfEventSample);
> > +
> > +PyObject *PyPerfSample_new(PyObject *self, PyObject *args, PyObject *k=
wargs);
> > +
> > +PyObject *PyPerf_start(PyPerf *self);
> > +PyObject *PyPerf_stop(PyPerf *self);
> > +PyObject *PyPerf_getSamples(PyPerf *self);
> > +
> > +PyObject *PyPerfSample_id(PyPerfEventSample *self);
> > +PyObject *PyPerfSample_ip(PyPerfEventSample *self);
> > +PyObject *PyPerfSample_pid(PyPerfEventSample *self);
> > +PyObject *PyPerfSample_tid(PyPerfEventSample *self);
> > +PyObject *PyPerfSample_tid_comm(PyPerfEventSample *self, PyObject *arg=
s, PyObject *kwargs);
> > +PyObject *PyPerfSample_time(PyPerfEventSample *self);
> > +PyObject *PyPerfSample_cpu(PyPerfEventSample *self);
> > +PyObject *PyPerfSample_nr(PyPerfEventSample *self);
> > +PyObject *PyPerfSample_ips(PyPerfEventSample *self);
> > +
> > +void py_perf_handle_free(struct perf_handle *handle);
> > +void py_perf_sample_free(struct perf_event_sample *sample);
> > +
> > +#endif
> > diff --git a/src/perfpy.c b/src/perfpy.c
> > new file mode 100644
> > index 0000000..745d519
> > --- /dev/null
> > +++ b/src/perfpy.c
> > @@ -0,0 +1,141 @@
> > +// SPDX-License-Identifier: LGPL-2.1
> > +
> > +/*
> > + * Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov=
@gmail.com>
> > + */
> > +
> > +// Python
> > +#include <Python.h>
> > +
> > +// libperf
> > +#include <perf/core.h>
> > +#include <perf/evsel.h>
> > +#include <perf/mmap.h>
> > +#include <perf/event.h>
> > +
> > +// trace-cruncher
> > +#include "common.h"
> > +#include "perfpy-utils.h"
> > +
> > +extern PyObject *PERF_ERROR;
> > +
> > +static PyMethodDef PyPerf_methods[] =3D {
> > +     {"start",
> > +      (PyCFunction) PyPerf_start,
> > +      METH_NOARGS,
> > +      "start sampling"
> > +     },
> > +     {"stop",
> > +      (PyCFunction) PyPerf_stop,
> > +      METH_NOARGS,
> > +      "stop sampling"
> > +     },
> > +     {"get_samples",
> > +      (PyCFunction) PyPerf_getSamples,
> > +      METH_NOARGS,
> > +      "get recorded samples"
> > +     },
> > +     {NULL}
> > +};
> > +C_OBJECT_WRAPPER(perf_handle, PyPerf, NO_DESTROY, py_perf_handle_free)=
;
> > +
> > +static PyMethodDef PyPerfEventSample_methods[] =3D {
> > +     {"id",
> > +      (PyCFunction) PyPerfSample_id,
> > +      METH_NOARGS,
> > +      "get sample id"
> > +     },
> > +     {"ip",
> > +      (PyCFunction) PyPerfSample_ip,
> > +      METH_NOARGS,
> > +      "get sample ip"
> > +     },
> > +     {"pid",
> > +      (PyCFunction) PyPerfSample_pid,
> > +      METH_NOARGS,
> > +      "get sample pid"
> > +     },
> > +     {"tid",
> > +      (PyCFunction) PyPerfSample_tid,
> > +      METH_NOARGS,
> > +      "get sample tid"
> > +     },
> > +     {"tid_comm",
> > +      (PyCFunction) PyPerfSample_tid_comm,
> > +      METH_VARARGS | METH_KEYWORDS,
> > +      "get sample tid"
> > +     },
> > +     {"time",
> > +      (PyCFunction) PyPerfSample_time,
> > +      METH_NOARGS,
> > +      "get sample timestamp"
> > +     },
> > +     {"cpu",
> > +      (PyCFunction) PyPerfSample_cpu,
> > +      METH_NOARGS,
> > +      "get sample cpu"
> > +     },
> > +     {"stack_count",
> > +      (PyCFunction) PyPerfSample_nr,
> > +      METH_NOARGS,
> > +      "get sample stack count"
> > +     },
> > +     {"stack",
> > +      (PyCFunction) PyPerfSample_ips,
> > +      METH_NOARGS,
> > +      "get sample stack"
> > +     },
> > +     {NULL}
> > +};
> > +C_OBJECT_WRAPPER(perf_event_sample, PyPerfEventSample, NO_DESTROY, py_=
perf_sample_free);
> > +
> > +static PyMethodDef perfpy_methods[] =3D {
> > +     {"sample",
> > +      (PyCFunction) PyPerfSample_new,
> > +      METH_VARARGS | METH_KEYWORDS,
> > +      "new perf sample instance"
> > +     },
> > +     {NULL}
> > +};
> > +
> > +static int perf_error_print(enum libperf_print_level level,
> > +                         const char *fmt, va_list ap)
> > +{
> > +     return vfprintf(stderr, fmt, ap);
> > +}
> > +
> > +static struct PyModuleDef perfpy_module =3D {
> > +     PyModuleDef_HEAD_INIT,
> > +     "perfpy",
> > +     "Python interface for Perf.",
> > +     -1,
> > +     perfpy_methods
> > +};
> > +
> > +PyMODINIT_FUNC PyInit_perfpy(void)
> > +{
> > +
> > +     if (!PyPerfTypeInit())
> > +             return NULL;
> > +     if (!PyPerfEventSampleTypeInit())
> > +             return NULL;
> > +
> > +     PERF_ERROR =3D PyErr_NewException("tracecruncher.perfpy.perf_erro=
r",
> > +                                     NULL, NULL);
> > +
> > +     PyObject *module =3D PyModule_Create(&perfpy_module);
> > +
> > +     PyModule_AddObject(module, "perf_error", PERF_ERROR);
> > +     PyModule_AddObject(module, "perf_handle", (PyObject *) &PyPerfTyp=
e);
> > +     PyModule_AddObject(module, "perf_event_sample", (PyObject *) &PyP=
erfEventSampleType);
> > +
> > +     if (geteuid() !=3D 0) {
> > +             PyErr_SetString(PERF_ERROR,
> > +                             "Permission denied. Root privileges are r=
equired.");
> > +             return NULL;
> > +     }
> > +
> > +     libperf_init(perf_error_print);
> > +
> > +     return module;
> > +}
> > --
> > 2.34.1
>
> --
>
> - Arnaldo



--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
