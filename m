Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE3EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Apr 2022 08:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349948AbiDSIZx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Apr 2022 04:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349947AbiDSIZw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Apr 2022 04:25:52 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BBF2D1C5
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Apr 2022 01:23:09 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id i24so292696pfa.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Apr 2022 01:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SOFY1lphQ05CDDeUehi74ALg0tr1MSOFZh3tKF0B+Ek=;
        b=fTBAumRKsajRFbyNvNuU22MrAAua9LfqriN5Jyvfr1X5WTr3tXCANm9PwheZtSK4gi
         YYxHSrEHpzkOkF/lR5QWDGGp2klcqupRqfWFUUbMGfZPl4kXCoc0HEp0ePoMYoFHgPAn
         pdFxSRQOwYX6C0Tu+GSVps44cGHYYHY8dFZ1F2g6QQRqh4Vt3Ohpvoc3ll/NvIjZKifQ
         X+IcfIjPsr15mqxHonYnFpghnBX5SYcszjisV+/3sjDl7RMYvd11MHfvyqJW992xzwzf
         6sInwX+KYCjcegp7JaddKnDBQcrhs6lsVf87nL2NB8P8EHE1JLg7Vr3Nlao0Ff7y3xp8
         oz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SOFY1lphQ05CDDeUehi74ALg0tr1MSOFZh3tKF0B+Ek=;
        b=rYTUmho64Hga3Y9Bk6a5QyWhKurUsk8koSXmZO3ZlTwb2a4oQqkUinc+wl6QrVCN51
         KNy3GtD46q/wXPs+rH/qp5I3hH/kKZizM28YcEoKBKlH33LMB7nDafhm3Bk/lYI90ZHl
         db46pGyG9+EHKQFAaMTl8gmozhRMO1gxCqZ935kS1RU8equrVI+Xubhwx+7/xV0ZZQTg
         iuWo4SIlJf3meT6U2QZO5aF5d6LaL0kd6Wv4OrjTSy+FOhod6mx5ro+DLxniA1WQ+Jvr
         fdj7lgwnKq0TKvfYkhmjPD1FzST1MWxQ3Y0HJ0Xo+EfBnXC8fTkFcheoN87f2dyH9+ux
         64hg==
X-Gm-Message-State: AOAM530IVfXvRmUSuKFui+ixKVeYoQ6qjukp+gXgJ4XjiOMnIMCyquiI
        RSypZQuOzMC9+WeQbEQlSNuzvDAZEDmvrVLsjNwXv4iDzBw=
X-Google-Smtp-Source: ABdhPJwj0AhcAWBneb/txJ5H9G+5F+x6o1gjm6DO0KNn0f0+iIU6usO2gxKx/BpfNHj0eXiKwdIxEjYlns2DDLochLI=
X-Received: by 2002:a65:5acd:0:b0:399:24bc:bbfd with SMTP id
 d13-20020a655acd000000b0039924bcbbfdmr13557517pgt.323.1650356589196; Tue, 19
 Apr 2022 01:23:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220415041012.36151-1-tz.stoyanov@gmail.com> <20220415041012.36151-4-tz.stoyanov@gmail.com>
 <9a3fec37-e92c-6cde-f655-99a13b8695ef@gmail.com>
In-Reply-To: <9a3fec37-e92c-6cde-f655-99a13b8695ef@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 19 Apr 2022 11:22:53 +0300
Message-ID: <CAPpZLN7r_YVZwrq8_yLnRgbE1jj_qW2+Qn2n8kS8c5wZcnKckw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] trace-cruncher: High level wrappers for ftrace uprobes
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 18, 2022 at 2:54 PM Yordan Karadzhov <y.karadz@gmail.com> wrote=
:
>
>
>
> On 15.04.22 =D0=B3. 7:10 =D1=87., Tzvetomir Stoyanov (VMware) wrote:
> > Using uprobes requires finding the offset of a user function within the
> > binary file, where this functions is compiled. This is not a trivial
> > task, especially in the cases when a bunch of uprobes to user functions
> > should be added.
> > A high level trace-cruncher API allows adding multiple user functions a=
s
> > uprobes or uretprobes. It supports wildcards for function names and
> > adding uprobes for library functions, used by the applications.
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >   setup.py             |   4 +-
> >   src/ftracepy-utils.c | 628 ++++++++++++++++++++++++++++++++++++++++++=
+
> >   src/ftracepy-utils.h |  17 ++
> >   src/ftracepy.c       |  35 +++
> >   4 files changed, 682 insertions(+), 2 deletions(-)
> >
> > diff --git a/setup.py b/setup.py
> > index 58561cf..464d3d2 100644
> > --- a/setup.py
> > +++ b/setup.py
> > @@ -71,8 +71,8 @@ def extension(name, sources, libraries):
> >
> >   def main():
> >       module_ft =3D extension(name=3D'tracecruncher.ftracepy',
> > -                          sources=3D['src/ftracepy.c', 'src/ftracepy-u=
tils.c'],
> > -                          libraries=3D['traceevent', 'tracefs'])
> > +                          sources=3D['src/ftracepy.c', 'src/ftracepy-u=
tils.c', 'src/trace-obj-debug.c'],
> > +                          libraries=3D['traceevent', 'tracefs', 'bfd']=
)
> >
> >       cythonize('src/npdatawrapper.pyx', language_level =3D 3)
> >       module_data =3D extension(name=3D'tracecruncher.npdatawrapper',
> > diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
> > index b39459b..d420dce 100644
> > --- a/src/ftracepy-utils.c
> > +++ b/src/ftracepy-utils.c
> > @@ -15,15 +15,46 @@
> >   #include <sys/utsname.h>
> >   #include <sys/wait.h>
> >   #include <signal.h>
> > +#include <semaphore.h>
> >   #include <time.h>
> >
> >   // trace-cruncher
> >   #include "ftracepy-utils.h"
> > +#include "trace-obj-debug.h"
> >
> >   PyObject *TFS_ERROR;
> >   PyObject *TEP_ERROR;
> >   PyObject *TRACECRUNCHER_ERROR;
> >
> > +#define UPROBES_SYSTEM "tc_uprobes"
>
> Note that we already have
>
> #define TC_SYS  "tcrunch"
>
> Does it make sence to define a second trace-cruncher system?

Yes, actually this is a template of the system name, the real name is
"tc_uprobes_<pid>" or "tc_uprobes_<file>". I can use TC_SYS as
template, instead of adding another define, but the system name should
be unique for current uprobes trace session, as it is used to enable /
disable all dynamic events related to this session at once.

>
> > +
> > +#define FTRACE_UPROBE                0x1
> > +#define FTRACE_URETPROBE     0x2
> > +
> > +struct fprobes_list {
> > +     int size;
> > +     int count;
> > +     void **data;
> > +};
> > +
> > +struct utrace_func {
> > +     int type;
> > +     char *func_name;
> > +     char *func_args;
> > +};
> > +
> > +struct py_utrace_context {
> > +     pid_t pid;
> > +     char *fname;
> > +     char **argv;
> > +     char *usystem;
> > +     uint32_t trace_time; /* in msec */
> > +     struct fprobes_list fretprobes;
> > +     struct fprobes_list ufuncs;
> > +     struct fprobes_list uevents;
> > +     struct dbg_trace_context *dbg;
> > +};
> > +
> >   static char *kernel_version()
> >   {
> >       struct utsname uts;
> > @@ -3508,3 +3539,600 @@ void PyFtrace_at_exit(void)
> >       if (seq.buffer)
> >               trace_seq_destroy(&seq);
> >   }
> > +
> > +#define INIT_SIZE    100
> This name is too general. Try to make it clear what is to be initialized =
with this size.
>
> > +static int utrace_list_add(struct fprobes_list *list, void *data)
> > +{
> > +     void **tmp;
> > +     int size;
> > +
> > +     if (list->size <=3D list->count) {
> > +             if (!list->size)
> > +                     size =3D INIT_SIZE;
> > +             else
> > +                     size =3D 2 * list->size;
> > +             tmp =3D realloc(list->data, size * sizeof(void *));
> > +             if (!tmp)
> > +                     return -1;
> > +             list->data =3D tmp;
> > +             list->size =3D size;
> > +     }
> > +
> > +     list->data[list->count] =3D data;
> > +     list->count++;
> > +     return list->count - 1;
> > +}
> > +
> > +void py_utrace_free(struct py_utrace_context *utrace)
> > +{
> > +     struct utrace_func *f;
> > +     int i;
> > +
> > +     if (!utrace)
> > +             return;
> > +     if (utrace->dbg)
> > +             dbg_trace_context_destroy(utrace->dbg);
> > +
> > +     for (i =3D 0; i < utrace->ufuncs.count; i++) {
> > +             f =3D utrace->ufuncs.data[i];
> > +             free(f->func_name);
> > +             free(f);
> > +     }
> > +     free(utrace->ufuncs.data);
> > +     if (utrace->argv) {
> > +             i =3D 0;
> > +             while (utrace->argv[i])
> > +                     free(utrace->argv[i++]);
> > +             free(utrace->argv);
> > +     }
> > +
> > +     for (i =3D 0; i < utrace->uevents.count; i++)
> > +             tracefs_dynevent_free(utrace->uevents.data[i]);
> > +     free(utrace->uevents.data);
> > +
> > +     free(utrace->fname);
> > +     free(utrace->usystem);
> > +     free(utrace);
> > +}
> > +
> > +/*
> > + * All strings, used as ftrace system or event name must contain only
> > + * alphabetic characters, digits or underscores.
> > + */
> > +static void fname_unify(char *fname)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 0; fname[i]; i++)
> > +             if (!isalnum(fname[i]) && fname[i] !=3D '_')
> > +                     fname[i] =3D '_';
> > +}
> > +
> > +int py_utrace_destroy(struct py_utrace_context *utrace)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 0; i < utrace->uevents.count; i++)
> > +             tracefs_dynevent_destroy(utrace->uevents.data[i], true);
> > +
> > +     return 0;
> > +}
> > +
> > +static struct py_utrace_context *utrace_new(pid_t pid, char *fname, ch=
ar **argv, bool libs)
> > +{
> > +     struct py_utrace_context *utrace;
> > +     char *file;
> > +
> > +     utrace =3D calloc(1, sizeof(*utrace));
> > +     if (!utrace)
> > +             return NULL;
> > +
> > +     if (fname) {
> > +             utrace->argv =3D argv;
> > +             utrace->dbg =3D dbg_trace_context_create_file(fname, libs=
);
> > +             if (!utrace->dbg)
> > +                     goto error;
> > +             utrace->fname =3D strdup(fname);
> > +             if (!utrace->fname)
> > +                     goto error;
> > +             file =3D strrchr(fname, '/');
> > +             if (file)
> > +                     file++;
> > +             if (!file || *file =3D=3D '\0')
> > +                     file =3D fname;
> > +             if (asprintf(&utrace->usystem, "%s_%s", UPROBES_SYSTEM, f=
ile) <=3D 0)
> > +                     goto error;
> > +     } else {
> > +             utrace->pid =3D pid;
> > +             utrace->dbg =3D dbg_trace_context_create_pid(pid, libs);
> > +             if (!utrace->dbg)
> > +                     goto error;
> > +             if (asprintf(&utrace->usystem, "%s_%d", UPROBES_SYSTEM, p=
id) <=3D 0)
> > +                     goto error;
> > +     }
> > +
> > +     fname_unify(utrace->usystem);
> > +     return utrace;
> > +
> > +error:
> > +     py_utrace_free(utrace);
> > +     return NULL;
> > +}
> > +
> > +static int py_utrace_add_func(struct py_utrace_context *utrace, char *=
func, int type)
> > +{
> > +     struct utrace_func *p;
> > +     int ret;
> > +     int i;
> > +
> > +     for (i =3D 0; i < utrace->ufuncs.count; i++) {
> > +             p =3D utrace->ufuncs.data[i];
> > +             if (!strcmp(p->func_name, func)) {
> > +                     p->type |=3D type;
> > +                     return 0;
> > +             }
> > +     }
> > +
> > +     p =3D calloc(1, sizeof(*p));
> > +     if (!p)
> > +             return -1;
> > +     p->func_name =3D strdup(func);
> > +     if (!p->func_name)
> > +             goto error;
> > +     p->type =3D type;
> > +
> > +     ret =3D utrace_list_add(&utrace->ufuncs, p);
> > +     if (ret < 0)
> > +             goto error;
> > +
> > +     if (dbg_trace_add_resolve_symbol(utrace->dbg, 0, func, ret))
> > +             goto error;
> > +
> > +     return 0;
> > +
> > +error:
> > +     free(p->func_name);
> > +     free(p);
> > +     return -1;
> > +}
> > +
> > +PyObject *PyUserTrace_add_function(PyUserTrace *self, PyObject *args,
> > +                                PyObject *kwargs)
> > +{
> > +     struct py_utrace_context *utrace =3D self->ptrObj;
> > +     static char *kwlist[] =3D {"fname", NULL};
> > +     char *fname;
> > +
> > +     if (!PyArg_ParseTupleAndKeywords(args,
> > +                                      kwargs,
> > +                                      "s",
> > +                                      kwlist,
> > +                                      &fname)) {
> > +             return NULL;
> > +     }
> > +
> > +     if (py_utrace_add_func(utrace, fname, FTRACE_UPROBE) < 0) {
> > +             MEM_ERROR
> > +             return NULL;
> > +     }
> > +
> > +     Py_RETURN_NONE;
> > +}
> > +
> > +PyObject *PyUserTrace_add_ret_function(PyUserTrace *self, PyObject *ar=
gs,
> > +                                    PyObject *kwargs)
> > +{
> > +     struct py_utrace_context *utrace =3D self->ptrObj;
> > +     static char *kwlist[] =3D {"fname", NULL};
> > +     char *fname;
> > +
> > +     if (!PyArg_ParseTupleAndKeywords(args,
> > +                                      kwargs,
> > +                                      "s",
> > +                                      kwlist,
> > +                                      &fname)) {
> > +             return NULL;
> > +     }
> > +
> > +     if (py_utrace_add_func(utrace, fname, FTRACE_URETPROBE) < 0) {
> > +             MEM_ERROR
> > +             return NULL;
> > +     }
> > +
> > +     Py_RETURN_NONE;
> > +}
> > +
> > +/*
> > + * max event name is 64 bytes, hard coded in the kernel.
> > + * it can consists only of alphabetic characters, digits or underscore=
s
> > + */
> Please start comments with capital and end with period.
>
>
> > +#define FILENAME_TRUNCATE    10
> > +#define FUNCAME_TRUNCATE     50
> > +static char *uprobe_event_name(char *file, char *func, int type)
> > +{
> > +     char *event =3D NULL;
> > +     char *fname;
> > +
> > +     fname =3D strrchr(file, '/');
> > +     if (fname)
> > +             fname++;
> > +     if (!fname || *fname =3D=3D '\0')
> > +             fname =3D file;
> > +
> > +     asprintf(&event, "%s%.*s_%.*s",
> > +              type =3D=3D FTRACE_URETPROBE ? "r_":"",
> > +              FILENAME_TRUNCATE, fname, FUNCAME_TRUNCATE, func);
> > +     if (event)
> > +             fname_unify(event);
> > +
> > +     return event;
> > +}
> > +
> > +/*
> > + * Create uprobe based on function name,
> > + * file name and function offset within the file
> > + */
> > +static int utrace_event_create(struct py_utrace_context *utrace,
> > +                            struct dbg_trace_symbols *sym, char *fecth=
args,
> > +                            int type)
> > +{
> > +     struct tracefs_dynevent *uevent =3D NULL;
> > +     char *rname;
> > +
> > +     /* Generate uprobe event name, according to ftrace name requireme=
nts */
> > +     rname =3D uprobe_event_name(sym->fname, sym->name, type);
> > +     if (!rname)
> > +             return -1;
> > +
> > +     if (type =3D=3D FTRACE_URETPROBE)
> > +             uevent =3D tracefs_uretprobe_alloc(utrace->usystem, rname=
,
> > +                                              sym->fname, sym->foffset=
, fecthargs);
> > +     else
> > +             uevent =3D tracefs_uprobe_alloc(utrace->usystem, rname,
> > +                                           sym->fname, sym->foffset, f=
ecthargs);
> > +
> > +     free(rname);
> > +     if (!uevent)
> > +             return -1;
> > +
> > +     if (tracefs_dynevent_create(uevent)) {
> > +             tracefs_dynevent_free(uevent);
> > +             return -1;
> > +     }
> > +
> > +     utrace_list_add(&utrace->uevents, uevent);
> > +     return 0;
> > +}
> > +
> > +/* callback, called on each resolved function */
> > +static int symblos_walk(struct dbg_trace_symbols *sym, void *context)
> > +{
> > +     struct py_utrace_context *utrace =3D context;
> > +     struct utrace_func *ufunc;
> > +
> > +     if (!sym->name || !sym->fname || !sym->foffset ||
> > +         sym->cookie < 0 || sym->cookie >=3D utrace->ufuncs.count)
> > +             return 0;
> > +
> > +     ufunc =3D utrace->ufuncs.data[sym->cookie];
> > +
> > +     if (ufunc->type & FTRACE_UPROBE)
> > +             utrace_event_create(utrace, sym, ufunc->func_args, FTRACE=
_UPROBE);
> > +
> > +     if (ufunc->type & FTRACE_URETPROBE)
> > +             utrace_event_create(utrace, sym, ufunc->func_args, FTRACE=
_URETPROBE);
> > +
> > +     return 0;
> > +}
> > +
> > +static void py_utrace_generate_uprobes(struct py_utrace_context *utrac=
e)
> > +{
> > +     /* Find the exact name and file offset of each user function that=
 should be traced */
> > +     dbg_trace_resolve_symbols(utrace->dbg);
> > +     dbg_trace_walk_resolved_symbols(utrace->dbg, symblos_walk, utrace=
);
> > +}
> > +
> > +static int start_trace(struct py_utrace_context *utrace, struct tracef=
s_instance *instance)
>
> The name is too general.

As it was a static function in a uprobe specific file, I put a general
name. But when I moved the code to ftrace-utils.c file, didn't realize
that the code there is not uprobe specific. I'll change it to a more
unique name in the next version.

>
> > +{
> > +     PyObject *pPid =3D PyLong_FromLong(utrace->pid);
> > +     bool ret;
> > +
> > +     if (!pPid)
> > +             return -1;
> > +
> > +     /* Filter the trace only on desired pid(s) */
> > +     ret =3D hook2pid(instance, PyLong_FromLong(utrace->pid), true);
> > +     Py_DECREF(pPid);
> > +     if (!ret) {
> > +             PyErr_SetString(TRACECRUNCHER_ERROR,
> > +                             "Failed to set trace filter");
> > +             return -1;
> > +     }
> > +
> > +     /* Enable uprobes in the system */
> > +     if (tracefs_event_enable(instance, utrace->usystem, NULL)) {
> > +             PyErr_SetString(TRACECRUNCHER_ERROR,
> > +                             "Failed to enable trace events");
> > +             return -1;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +#define PERF_EXEC_SYNC       "/TC_PERF_SYNC_XXXXXX"
> > +static int utrace_exec_cmd(struct py_utrace_context *utrace, struct tr=
acefs_instance *instance)
> > +{
> > +     char *envp[] =3D {NULL};
> > +     char sname[strlen(PERF_EXEC_SYNC) + 1];
> > +     sem_t *sem;
> > +     pid_t pid;
> > +     int ret;
> > +
> > +     strcpy(sname, PERF_EXEC_SYNC);
> > +     mktemp(sname);
> > +     sem =3D sem_open(sname, O_CREAT | O_EXCL, 0644, 0);
> > +     sem_unlink(sname);
> > +
> > +     pid =3D fork();
> > +     if (pid < 0) {
> > +             PyErr_SetString(TRACECRUNCHER_ERROR, "Failed to fork");
> > +             return -1;
> > +     }
> > +     if (pid =3D=3D 0) {
> > +             sem_wait(sem);
> > +             execvpe(utrace->fname, utrace->argv, envp);
> > +     } else {
> > +             utrace->pid =3D pid;
> > +             start_trace(utrace, instance);
> > +             sem_post(sem);
> > +             return ret;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int py_utrace_enable(struct py_utrace_context *utrace, struct t=
racefs_instance *instance)
> > +{
> > +     /* If uprobes on desired user functions are not yet generated, do=
 it now */
> > +     if (!utrace->uevents.count)
> > +             py_utrace_generate_uprobes(utrace);
> > +
> > +     /* No functions are found in the given program / pid */
> > +     if (!utrace->uevents.count) {
> > +             PyErr_SetString(TRACECRUNCHER_ERROR,
> > +                             "Cannot find requested user functions");
> > +             return -1;
> > +     }
> > +
> > +     if (utrace->fname)
> > +             utrace_exec_cmd(utrace, instance);
> > +     else
> > +             start_trace(utrace, instance);
> > +
> > +     return 0;
> > +}
> > +
> > +static int py_utrace_disable(struct py_utrace_context *utrace, struct =
tracefs_instance *instance)
> > +{
> > +     /* Disable uprobes in the system */
> > +     if (tracefs_event_disable(instance, utrace->usystem, NULL)) {
> > +             PyErr_SetString(TRACECRUNCHER_ERROR,
> > +                             "Failed to disable trace events");
> > +             return -1;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static bool tracing_run;
> > +
> > +static void tracing_stop(int sig)
> > +{
> > +     tracing_run =3D false;
> > +}
> > +
> > +static void tracing_timer(int sig, siginfo_t *si, void *uc)
> > +{
> > +     tracing_run =3D false;
> > +}
> > +
> > +#define PID_WAIT_CHECK_USEC  500000
> > +#define TIMER_SEC_NANO               1000000000LL
> > +static int utrace_wait_pid(struct py_utrace_context *utrace)
> > +{
> > +     struct itimerspec tperiod =3D {0};
> > +     struct sigaction saction =3D {0};
> > +     struct sigevent stime =3D {0};
> > +     timer_t timer_id;
> > +
> > +     if (utrace->pid =3D=3D 0)
> > +             return -1;
> > +
> > +     tracing_run =3D true;
> > +     signal(SIGINT, tracing_stop);
> > +
> > +     if (utrace->trace_time) {
> > +             stime.sigev_notify =3D SIGEV_SIGNAL;
> > +             stime.sigev_signo =3D SIGRTMIN;
> > +             if (timer_create(CLOCK_MONOTONIC, &stime, &timer_id))
> > +                     return -1;
> > +             saction.sa_flags =3D SA_SIGINFO;
> > +             saction.sa_sigaction =3D tracing_timer;
> > +             sigemptyset(&saction.sa_mask);
> > +             if (sigaction(SIGRTMIN, &saction, NULL)) {
> > +                     timer_delete(timer_id);
> > +                     return -1;
> > +             }
> > +             /* covert trace_time from msec to sec, nsec */
> > +             tperiod.it_value.tv_nsec =3D ((unsigned long long)utrace-=
>trace_time * 1000000LL);
> > +             if (tperiod.it_value.tv_nsec >=3D TIMER_SEC_NANO) {
> > +                     tperiod.it_value.tv_sec =3D tperiod.it_value.tv_n=
sec / TIMER_SEC_NANO;
> > +                     tperiod.it_value.tv_nsec %=3D TIMER_SEC_NANO;
> > +             }
> > +             if (timer_settime(timer_id, 0, &tperiod, NULL))
> > +                     return -1;
> > +     }
> > +
> > +     do {
> > +             if (utrace->fname) { /* wait for a child */
> > +                     if (waitpid(utrace->pid, NULL, WNOHANG) =3D=3D (i=
nt)utrace->pid) {
> > +                             utrace->pid =3D 0;
> > +                             tracing_run =3D false;
> > +                     }
> > +             } else { /* not a child, check if still exist */
> > +                     if (kill(utrace->pid, 0) =3D=3D -1 && errno =3D=
=3D ESRCH) {
> > +                             utrace->pid =3D 0;
> > +                             tracing_run =3D false;
> > +                     }
> > +             }
> > +             usleep(PID_WAIT_CHECK_USEC);
> > +     } while (tracing_run);
> > +
> > +     if (utrace->trace_time)
> > +             timer_delete(timer_id);
> > +
> > +     signal(SIGINT, SIG_DFL);
> > +
> > +     return 0;
> > +}
> > +
> > +PyObject *PyUserTrace_enable(PyUserTrace *self, PyObject *args, PyObje=
ct *kwargs)
> > +{
> > +     struct py_utrace_context *utrace =3D self->ptrObj;
> > +     static char *kwlist[] =3D {"instance", "wait", "time", NULL};
> > +     struct tracefs_instance *instance =3D NULL;
> > +     PyObject *py_inst =3D NULL;
> > +     int wait =3D false;
> > +     int ret;
> > +
> > +     if (!utrace) {
> > +             PyErr_SetString(TRACECRUNCHER_ERROR,
> > +                             "Failed to get utrace context");
> > +             return NULL;
> > +     }
> > +
> > +     if (!PyArg_ParseTupleAndKeywords(args,
> > +                                      kwargs,
> > +                                      "|Ops",
> > +                                      kwlist,
> > +                                      &py_inst,
> > +                                      &wait,
> > +                                      &utrace->trace_time)) {
> > +             PyErr_SetString(TRACECRUNCHER_ERROR,
> > +                             "Failed to parse input arguments");
> > +             return NULL;
> > +     }
> > +
> > +     if (!get_optional_instance(py_inst, &instance))
> > +             return NULL;
> > +
> > +     ret =3D py_utrace_enable(utrace, instance);
> > +     if (ret)
> > +             return NULL;
> > +
> > +     if (wait) {
> > +             utrace_wait_pid(utrace);
> > +             py_utrace_disable(utrace, instance);
> > +     }
> > +
> > +     Py_RETURN_NONE;
> > +}
> > +
> > +PyObject *PyUserTrace_disable(PyUserTrace *self, PyObject *args, PyObj=
ect *kwargs)
> > +{
> > +     struct py_utrace_context *utrace =3D self->ptrObj;
> > +     static char *kwlist[] =3D {"instance", NULL};
> > +     struct tracefs_instance *instance =3D NULL;
> > +     PyObject *py_inst =3D NULL;
> > +     int ret;
> > +
> > +     if (!utrace) {
> > +             PyErr_SetString(TRACECRUNCHER_ERROR,
> > +                             "Failed to get utrace context");
> > +             return NULL;
> > +     }
> > +
> > +     if (!PyArg_ParseTupleAndKeywords(args,
> > +                                      kwargs,
> > +                                      "|O",
> > +                                      kwlist,
> > +                                      &py_inst)) {
> > +             PyErr_SetString(TRACECRUNCHER_ERROR,
> > +                             "Failed to parse input arguments");
> > +             return NULL;
> > +     }
> > +
> > +     if (!get_optional_instance(py_inst, &instance))
> > +             return NULL;
> > +
> > +     ret =3D py_utrace_disable(utrace, instance);
> > +
> > +     if (ret)
> > +             return NULL;
> > +
> > +     Py_RETURN_NONE;
> > +}
> > +
> > +PyObject *PyFtrace_utrace(PyObject *self, PyObject *args, PyObject *kw=
args)
> This must be PyFtrace_user_trace()
>
> > +{
> > +     static char *kwlist[] =3D {"pid", "name", "follow_libs", "argv", =
NULL};
>
> I still think the 'name' argument is redundant. It is the same as argv[0]=
.
>
> Note that when we use 'execvPe()', there is no need to provide the absolu=
te path. All locations provided in $PATH will
> be searched, that is identical to calling 'shutil.which()' in the user co=
de.
>
> Even if we need the absolute path for something else, this path can be de=
rived internally.
>

The absolute path is needed for the code that resolves function name
to address and file offset. As there is no elegant way to do that in
C, I did that in the python code. But You are right, the absolute path
is needed by internal logic and should not be part of the API. I'll
look for some hacky way to search the $PATH in the C code.

>
> > +     struct py_utrace_context *utrace;
> > +     char **argv =3D NULL;
> > +     long long pid =3D 0;
> > +     char *comm =3D NULL;
> > +     int libs =3D 0;
> > +     PyObject *py_utrace, *py_arg, *py_args =3D NULL;
> > +     int i, argc;
> > +
> > +     if (!PyArg_ParseTupleAndKeywords(args,
> > +                                      kwargs,
> > +                                      "|KspO",
> > +                                      kwlist,
> > +                                      &pid,
> > +                                      &comm,
> > +                                      &libs,
> > +                                      &py_args)) {
> > +             return NULL;
> > +     }
> > +
> > +     if (pid =3D=3D 0 && !comm) {
> If both 'pid' and 'name' (argv) are provided, this must be considered err=
or (not silently taking one of the two) and a
> proper error message must be printed. Also error in the case when 'pid' i=
s negative.
>
> Thanks!
> Yordan

I'll send the next version addressing your comments.
Thanks!

>
> > +             PyErr_Format(TFS_ERROR,
> > +                          "Process ID or program name should be specif=
ied");
> > +             return NULL;
> > +     }
> > +
> > +     if (comm && py_args) {
> > +             if (!PyList_CheckExact(py_args)) {
> > +                     PyErr_SetString(TFS_ERROR, "Failed to parse argv =
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
> > +                             goto error;
> > +             }
> > +             argv[i] =3D NULL;
> > +     }
> > +
> > +     utrace =3D utrace_new(pid, comm, argv, libs);
> > +     if (!utrace) {
> > +             MEM_ERROR;
> > +             goto error;
> > +     }
> > +     py_utrace =3D PyUserTrace_New(utrace);
> > +
> > +     return py_utrace;
> > +
> > +error:
> > +     if (argv) {
> > +             for (i =3D 0; i < argc; i++)
> > +                     free(argv[i]);
> > +             free(argv);
> > +     }
> > +     return NULL;
> > +}
> > diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
> > index e6fab69..0b5000b 100644
> > --- a/src/ftracepy-utils.h
> > +++ b/src/ftracepy-utils.h
> > @@ -34,6 +34,21 @@ C_OBJECT_WRAPPER_DECLARE(tracefs_synth, PySynthEvent=
)
> >
> >   PyObject *PyTepRecord_time(PyTepRecord* self);
> >
> > +struct py_utrace_context;
> > +void py_utrace_free(struct py_utrace_context *utrace);
> > +int py_utrace_destroy(struct py_utrace_context *utrace);
> > +C_OBJECT_WRAPPER_DECLARE(py_utrace_context, PyUserTrace);
> > +
> > +PyObject *PyUserTrace_add_function(PyUserTrace *self, PyObject *args,
> > +                                PyObject *kwargs);
> > +
> > +PyObject *PyUserTrace_add_ret_function(PyUserTrace *self, PyObject *ar=
gs,
> > +                                    PyObject *kwargs);
> > +
> > +PyObject *PyUserTrace_enable(PyUserTrace *self, PyObject *args, PyObje=
ct *kwargs);
> > +
> > +PyObject *PyUserTrace_disable(PyUserTrace *self, PyObject *args, PyObj=
ect *kwargs);
> > +
> >   PyObject *PyTepRecord_cpu(PyTepRecord* self);
> >
> >   PyObject *PyTepEvent_name(PyTepEvent* self);
> > @@ -270,6 +285,8 @@ PyObject *PyFtrace_synth(PyObject *self, PyObject *=
args,
> >   PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args=
,
> >                                                      PyObject *kwargs);
> >
> > +PyObject *PyFtrace_utrace(PyObject *self, PyObject *args, PyObject *kw=
args);
> > +
> >   PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
> >                                                PyObject *kwargs);
> >
> > diff --git a/src/ftracepy.c b/src/ftracepy.c
> > index 681d641..6ca9df0 100644
> > --- a/src/ftracepy.c
> > +++ b/src/ftracepy.c
> > @@ -315,6 +315,32 @@ C_OBJECT_WRAPPER(tracefs_synth, PySynthEvent,
> >                tracefs_synth_destroy,
> >                tracefs_synth_free)
> >
> > +static PyMethodDef PyUserTrace_methods[] =3D {
> > +     {"add_function",
> > +      (PyCFunction) PyUserTrace_add_function,
> > +      METH_VARARGS | METH_KEYWORDS,
> > +      "Add tracepoint on user function."
> > +     },
> > +     {"add_ret_function",
> > +      (PyCFunction) PyUserTrace_add_ret_function,
> > +      METH_VARARGS | METH_KEYWORDS,
> > +      "Add tracepoint on user function return."
> > +     },
> > +     {"enable",
> > +      (PyCFunction) PyUserTrace_enable,
> > +      METH_VARARGS | METH_KEYWORDS,
> > +      "Enable tracing of the configured user tracepoints."
> > +     },
> > +     {"disable",
> > +      (PyCFunction) PyUserTrace_disable,
> > +      METH_VARARGS | METH_KEYWORDS,
> > +      "Disable tracing of the configured user tracepoints."
> > +     },
> > +     {NULL, NULL, 0, NULL}
> > +};
> > +C_OBJECT_WRAPPER(py_utrace_context, PyUserTrace,
> > +              py_utrace_destroy, py_utrace_free)
> > +
> >   static PyMethodDef ftracepy_methods[] =3D {
> >       {"dir",
> >        (PyCFunction) PyFtrace_dir,
> > @@ -501,6 +527,11 @@ static PyMethodDef ftracepy_methods[] =3D {
> >        METH_VARARGS | METH_KEYWORDS,
> >        "Define a synthetic event."
> >       },
> > +     {"user_trace",
> > +      (PyCFunction) PyFtrace_utrace,
> > +      METH_VARARGS | METH_KEYWORDS,
> > +      "Create a context for tracing a user process using uprobes"
> > +     },
> >       {"set_ftrace_loglevel",
> >        (PyCFunction) PyFtrace_set_ftrace_loglevel,
> >        METH_VARARGS | METH_KEYWORDS,
> > @@ -575,6 +606,9 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
> >       if (!PySynthEventTypeInit())
> >               return NULL;
> >
> > +     if (!PyUserTraceTypeInit())
> > +             return NULL;
> > +
> >       TFS_ERROR =3D PyErr_NewException("tracecruncher.ftracepy.tfs_erro=
r",
> >                                      NULL, NULL);
> >
> > @@ -593,6 +627,7 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
> >       PyModule_AddObject(module, "tracefs_dynevent", (PyObject *) &PyDy=
neventType);
> >       PyModule_AddObject(module, "tracefs_hist", (PyObject *) &PyTraceH=
istType);
> >       PyModule_AddObject(module, "tracefs_synth", (PyObject *) &PySynth=
EventType);
> > +     PyModule_AddObject(module, "py_utrace_context", (PyObject *) &PyU=
serTraceType);
> >
> >       PyModule_AddObject(module, "tfs_error", TFS_ERROR);
> >       PyModule_AddObject(module, "tep_error", TEP_ERROR);



--=20
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
