Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D894C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 11:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238411AbiDOLiS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Apr 2022 07:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiDOLiR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Apr 2022 07:38:17 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AC95DE59
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 04:35:49 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id u29so3432455pfg.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 04:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WMrODVBsGRyM4+QYINpCjIdNlQlEJhUuj3LX69iaB3c=;
        b=m6fX89CAzN47fL6grcW0NDliZeyfFO/NIO712Zk08EJPS+/X5DMNppFjTWCwCShjzy
         BBsKKvyrgTBFTpcM9JfqslwXvfqK/gNpAFNAyNvby+VZyPsk4AsDH+/fZaj2kRp1oVWM
         Tf5HDx1eeJZuKRglBX3a20tH4WZUKTE0rhwFjGFNhhtU4979J396SmR3Qn4M+U54wf3l
         QQwf0dohiHKXxoraIHa+WIS7m4hcc2igYKN6I4iEPSz8L4RUQTByeyWHslYjRGdI0gYl
         WlATR4Ag0iie2T3m9VyPk/JXzUVrs4SfHeVnUdwksvv/Mg9dytGu/LgtQJ4y7IlvdT0R
         HtVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WMrODVBsGRyM4+QYINpCjIdNlQlEJhUuj3LX69iaB3c=;
        b=uVnmBQjLtADdNEJdFMeA1Kj470M+2MuStSO35ufPBq7pu/eJzFg2+jgC4Oxx65jt8Q
         nTcPZrK0X+mkMBaXV8Hpmn4EMikKkKmUFwIPAvOQ/T0FAjBHrMJfK8d9eO4KI9E0mr7F
         3okr87yQeRPhpJrAtFNnnHykcWPp7VICoyuv5sD4JRt7C1n3QsRHdkzFgQziw294rtdU
         AnnWzqh/kpe9gQ6qoFIuQgPShR25nSnHIbqKoVfCRuEJhbL13zCWhr3SaqccktH3pFjW
         W6bsBdotL3SbQad+KXov1G9c2WS7PARXKOPggBZqvqL+0Ejjd76t36t3v5l/ff17Wqtt
         MoBg==
X-Gm-Message-State: AOAM533uWW6Hb65GYJN9CP1dp8dq0fMrzZreOYqk724CCm1gKfUGEexT
        3k1yFqrc6KRomJJXPtMutYqQu8JVrZtbzQ+mhkNpS55AxOI=
X-Google-Smtp-Source: ABdhPJzeOdCalucRMITjEJe3WIdtydJQ/xaOg6YWUhCneLlAC2YUOvS0abXMvay8CnI2pEgsuqG9iBLUS+sGeL/ZGQY=
X-Received: by 2002:a05:6a00:2186:b0:4f7:5544:1cc9 with SMTP id
 h6-20020a056a00218600b004f755441cc9mr19300993pfi.62.1650022548544; Fri, 15
 Apr 2022 04:35:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220408100339.594358-1-tz.stoyanov@gmail.com>
 <20220408100339.594358-3-tz.stoyanov@gmail.com> <79acf6d4-bd13-12b0-e6f6-7b014caf124f@gmail.com>
In-Reply-To: <79acf6d4-bd13-12b0-e6f6-7b014caf124f@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 15 Apr 2022 14:35:32 +0300
Message-ID: <CAPpZLN7h-Pyg7x0DZh4PPvLhEp9CLXn+4sB2P_WYW-Ysh7YRnQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/3] trace-cruncher: Support for perf
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 14, 2022 at 3:58 PM Yordan Karadzhov <y.karadz@gmail.com> wrote=
:
>
>
>
> On 8.04.22 =D0=B3. 13:03 =D1=87., Tzvetomir Stoyanov (VMware) wrote:
> > Initial perf support for trace-cruncher, using libperf. As a first
> > stage, collecting of stack trace samples of given process is supported.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >   setup.py           |   9 +-
> >   src/perfpy-utils.c | 896 ++++++++++++++++++++++++++++++++++++++++++++=
+
> >   src/perfpy-utils.h |  43 +++
> >   src/perfpy.c       | 141 +++++++
> >   4 files changed, 1087 insertions(+), 2 deletions(-)
> >   create mode 100644 src/perfpy-utils.c
> >   create mode 100644 src/perfpy-utils.h
> >   create mode 100644 src/perfpy.c
> >
> [  .. ]
> > +int py_perf_handle_destroy(struct perf_handle *perf)
> > +{
> > +     if (!perf || !perf->running)
> > +             return 0;
> > +
> > +     perf->running =3D false;
> > +     pthread_join(perf->reader, NULL);
> > +     fsync(perf->fd);
> > +     if (perf->command && perf->pid > 0) {
> > +             kill(perf->pid, SIGINT);
> > +             perf->pid =3D 0;
>
> Maybe we can free 'perf->command' and set it to NULL here.

Freeing the command string should be done in py_perf_handle_free(), it
looks more logical. The py_perf_handle_destroy() disables the running
perf samples. It should be possible to run sampling again on the same
command, by calling PyPerf_enable().

>
> > +     }
> > +
> > +     return 0;
> > +}
> > +
[ ... ]
> > +
> > +PyObject *PyPerfSampler_new(PyObject *self, PyObject *args, PyObject *=
kwargs)
>
> The name of this function has to be 'PyPerf_sampler_instance'
> > +{
> > +     char *kwlist[] =3D {"pid", "command", "freq", "argv", NULL};
>
> 'command' argument look redundant. It is the same as argv[0]

There is a little difference between 'command' and argv[0]. The
'command' argument is supposed to include the full path to the
application file that should be traced, while argv[0] could be just
the file name, without the path. Resolving the full path of the file
is done in the python code and passed to the API. For example, in:
  ./perf_sampling.py ls -al
'command' is '/usr/bin/ls'
argv[0] is 'ls'

>
> > +     PyObject *py_perf, *py_arg, *py_args =3D NULL;
> > +     struct perf_handle *perf =3D NULL;
> > +     int freq =3D 10, pid =3D 0;
> > +     char *command =3D NULL;
> > +     char **argv =3D NULL;
> > +     int i, argc;
> > +
> > +     if (!PyArg_ParseTupleAndKeywords(args,
> > +                                      kwargs,
> > +                                      "|isiO",
> > +                                      kwlist,
> > +                                      &pid,
> > +                                      &command,
> > +                                      &freq,
> > +                                      &py_args
> > +                                      )) {
> > +             return NULL;
> > +     }
> > +
> > +     if (pid =3D=3D 0 && !command) {
>
> We have to handle also the case when both 'pid' and 'command' (argv) are =
provided.
> Also the case when 'pid' is negative.

I'll add a check for negative pid. In case both 'pid' and 'command'
are provided, 'command' is with higher priority - that logic is in
new_perf_sampling_handle().

>
> > +             PyErr_Format(PERF_ERROR, "PID or command must be specifie=
d");
> > +             return NULL;
> > +     }
> > +
> > +     if (command && py_args) {
> > +             if (!PyList_CheckExact(py_args)) {
> > +                     PyErr_SetString(PERF_ERROR, "Failed to parse argv=
 list");
> > +                     return NULL;
> > +             }
> > +             argc =3D PyList_Size(py_args);
> > +             argv =3D calloc(argc + 1, sizeof(char *));
> > +             for (i =3D 0; i < argc; i++) {
> > +                     py_arg =3D PyList_GetItem(py_args, i);
> > +                     if (!PyUnicode_Check(py_arg))
> > +                             continue;
> > +                     argv[i] =3D strdup(PyUnicode_DATA(py_arg));
> > +                     if (!argv[i])
> > +                             return NULL;
> > +             }
> > +             argv[i] =3D NULL;
> This was allocated using calloc(). No need to set it to NULL.
>
> > +     }
> > +
> > +     perf =3D new_perf_sampling_handle(freq, pid, command, argv);
> > +
> > +     if (!perf) {
> > +             PyErr_SetString(PERF_ERROR, "Failed create new perf conte=
xt");
> > +             return NULL;
> > +     }
> > +
> > +     py_perf =3D PyPerf_New(perf);
> > +
> > +     return py_perf;
> > +}
[ ... ]
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
>
> I wonder where this number 100 comes from?

It is just a safe step to increase the limit. Perf could use a lot of
file descriptors, on some systems the default limit is not enough.

>
> > +     }
> > +
> > +     return setrlimit(RLIMIT_NOFILE, &lim);
> > +}
> > +
> > +static int perf_maps_init(struct perf_handle *perf)
> > +{
> > +     int ret;
> > +
> > +     if (!perf->threads)
> > +             perf->threads =3D create_thread_map(perf);
> > +     if (!perf->threads)
> > +             return -1;
> > +
> > +     perf_evlist__set_maps(perf->evlist, perf->cpus, perf->threads);
> > +     do {
> > +             ret =3D perf_evlist__open(perf->evlist);
> > +             if (!ret)
> > +                     break;
> > +             if (ret !=3D -EMFILE)
> > +                     goto out;
> > +             ret =3D increase_file_limit();
> > +             if (ret)
> > +                     goto out;
> > +     } while (ret);
> > +
>
> This loops seems over-complicated. Something like this reads easier (at l=
east for me)
>
>         for(;;) {
>                 if (perf_evlist__open(perf->evlist) =3D=3D 0)
>                         break;
>
>                 if (ret !=3D -EMFILE)
>                         goto out;
>
>                 if (increase_file_limit() !=3D 0)
>                         goto out;
>         }
>

The return code should be preserved, as in case of an error it is
returned. Also, the error for not enough file descriptors should be
handled.

> > +     ret =3D perf_evlist__mmap(perf->evlist, 4);
> > +out:
> > +     if (ret)
> > +             perf_evlist__close(perf->evlist);
> > +     return ret;
> > +}
> > +
[  ... ]
> > +static PyMethodDef PyPerfEventSampler_methods[] =3D {
> > +     {"id",
> > +      (PyCFunction) PyPerfSampler_id,
> > +      METH_NOARGS,
> > +      "get sample id"
> > +     },
> > +     {"ip",
> > +      (PyCFunction) PyPerfSampler_ip,
> > +      METH_NOARGS,
> > +      "get sample ip"
> > +     },
> > +     {"pid",
> > +      (PyCFunction) PyPerfSampler_pid,
> > +      METH_NOARGS,
> > +      "get sample pid"
> > +     },
> > +     {"tid",
> > +      (PyCFunction) PyPerfSampler_tid,
> > +      METH_NOARGS,
> > +      "get sample tid"
> > +     },
> > +     {"tid_comm",
> > +      (PyCFunction) PyPerfSampler_tid_comm,
> > +      METH_VARARGS | METH_KEYWORDS,
> > +      "get sample tid"
> > +     },
> > +     {"time",
> > +      (PyCFunction) PyPerfSampler_time,
> > +      METH_NOARGS,
> > +      "get sample timestamp"
> > +     },
> > +     {"cpu",
> > +      (PyCFunction) PyPerfSampler_cpu,
> > +      METH_NOARGS,
> > +      "get sample cpu"
> > +     },
> > +     {"stack_count",
> > +      (PyCFunction) PyPerfSampler_nr,
> > +      METH_NOARGS,
> > +      "get sample stack count"
> > +     },
> > +     {"stack",
> > +      (PyCFunction) PyPerfSampler_ips,
> > +      METH_NOARGS,
> > +      "get sample stack"
> > +     },
> > +     {NULL}
>
> So far I've been using as a convention that the 'C' function that impleme=
nts a method of the Python module has a name
> that starts with the type of the module (or object from the module) as a =
prefix, followed by the name of the method itself.
>
> For example the name of the function that implements 'stack()' must be 'P=
yPerfEventSampler_stack()'.
>

Thanks for this clarification, I'll check the names of the methods.

> Thanks!
> Yordan
>

Thank you for that review! I'll address your comments in v2.

> > +};
> > +C_OBJECT_WRAPPER(perf_event_sample, PyPerfEventSampler, NO_DESTROY, py=
_perf_sample_free);
> > +
> > +static PyMethodDef perfpy_methods[] =3D {
> > +     {"sampler_instance",
> > +      (PyCFunction) PyPerfSampler_new,
> > +      METH_VARARGS | METH_KEYWORDS,
> > +      "Allocate new perf sampler instance"
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
> > +     if (!PyPerfEventSamplerTypeInit())
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
erfEventSamplerType);
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



--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
