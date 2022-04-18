Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34917C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Apr 2022 11:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237920AbiDRL4p (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Apr 2022 07:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiDRL4o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Apr 2022 07:56:44 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF2C6301
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Apr 2022 04:54:04 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id c6so17181596edn.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Apr 2022 04:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j7RyTqbmLjTs3zM52O0OTjSkVlbpfUrR+1nKohcLIWg=;
        b=gYt3Gof7TcbmkmN4+iAOPOnHuaIzLdwanroMPPUryIkYDnp0t2tRYBYPQNg22/oKFL
         2+Nfa2NxqvkM7KIOX+lOWiH8hvuuB2MbT+m8vZOpswzMAY8JipX8cUBuu5QAqelENaxS
         KwVVOYszHy5DcSv3p4M7YkZnenxPDJbWgN/iB4gNM2OtUHv1UlRXIQ1VIf75N0IRdNYM
         17HB70hcOrbMmlnFftiWccOUHaNsYBVhRiu5xC/y2bAVdJJzhAwYxbRA+ijnTPCaLj8v
         VgOWfyMMnhfJBmBZYcB32h1NE+b48WO7mg8OkcV40yhxtUVU5SS3DLWstiz2GwQXJ5mW
         cR0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j7RyTqbmLjTs3zM52O0OTjSkVlbpfUrR+1nKohcLIWg=;
        b=IEf6eunw+CjGS3vZZlYCgIxNVhP74nocIB7E5hX+On7Ra+fuhOgxz/8tklv8bXp+Tn
         wRn0WsNmNyvddHN6dxZ/ZohUREkV9jVA9186x3Ji2cS90lb030JxHisoqz/A7MrBljMO
         68HrHaBXFCmjFLtuV/9XA21YmAFPI00W62SuHfx1mSSQc1IVaCge871rDx+msIAYJzcj
         JnM7lXc1AY+5hHL1TyFt4DmRvCI7vMaFtw6HaJuXQQW5kuS1bTGE3r0yYCtcI0Em3z0l
         XKoSbXgZiUJJeAuKi7dEP0EcnwI7wzE3UBsGzHcxt9JfQa2iH5shvd9A1V0Qo5GO0Igr
         /uaw==
X-Gm-Message-State: AOAM530BvPOqdjfYLjr9NdFm9lXiXEsQfIWx5gxLXbDBdaty++RX5s7K
        GWf8GzPDCHrCs5Mpv8NYaTQxTmn+pZw=
X-Google-Smtp-Source: ABdhPJwiF6+/GrDdr/3pKukzJdnbiEQxUMtQj6lbGfE3AVLLqMONrSesoy8HJSnWjkRI/NJmc1YJUg==
X-Received: by 2002:a50:9b5d:0:b0:41d:9252:87f8 with SMTP id a29-20020a509b5d000000b0041d925287f8mr12163718edj.181.1650282842811;
        Mon, 18 Apr 2022 04:54:02 -0700 (PDT)
Received: from [10.107.106.54] (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id 27-20020a17090600db00b006df6b34d9b8sm4500170eji.211.2022.04.18.04.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 04:54:02 -0700 (PDT)
Message-ID: <9a3fec37-e92c-6cde-f655-99a13b8695ef@gmail.com>
Date:   Mon, 18 Apr 2022 14:54:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v2 3/4] trace-cruncher: High level wrappers for ftrace
 uprobes
Content-Language: en-US
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
References: <20220415041012.36151-1-tz.stoyanov@gmail.com>
 <20220415041012.36151-4-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220415041012.36151-4-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 15.04.22 г. 7:10 ч., Tzvetomir Stoyanov (VMware) wrote:
> Using uprobes requires finding the offset of a user function within the
> binary file, where this functions is compiled. This is not a trivial
> task, especially in the cases when a bunch of uprobes to user functions
> should be added.
> A high level trace-cruncher API allows adding multiple user functions as
> uprobes or uretprobes. It supports wildcards for function names and
> adding uprobes for library functions, used by the applications.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   setup.py             |   4 +-
>   src/ftracepy-utils.c | 628 +++++++++++++++++++++++++++++++++++++++++++
>   src/ftracepy-utils.h |  17 ++
>   src/ftracepy.c       |  35 +++
>   4 files changed, 682 insertions(+), 2 deletions(-)
> 
> diff --git a/setup.py b/setup.py
> index 58561cf..464d3d2 100644
> --- a/setup.py
> +++ b/setup.py
> @@ -71,8 +71,8 @@ def extension(name, sources, libraries):
>   
>   def main():
>       module_ft = extension(name='tracecruncher.ftracepy',
> -                          sources=['src/ftracepy.c', 'src/ftracepy-utils.c'],
> -                          libraries=['traceevent', 'tracefs'])
> +                          sources=['src/ftracepy.c', 'src/ftracepy-utils.c', 'src/trace-obj-debug.c'],
> +                          libraries=['traceevent', 'tracefs', 'bfd'])
>   
>       cythonize('src/npdatawrapper.pyx', language_level = 3)
>       module_data = extension(name='tracecruncher.npdatawrapper',
> diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
> index b39459b..d420dce 100644
> --- a/src/ftracepy-utils.c
> +++ b/src/ftracepy-utils.c
> @@ -15,15 +15,46 @@
>   #include <sys/utsname.h>
>   #include <sys/wait.h>
>   #include <signal.h>
> +#include <semaphore.h>
>   #include <time.h>
>   
>   // trace-cruncher
>   #include "ftracepy-utils.h"
> +#include "trace-obj-debug.h"
>   
>   PyObject *TFS_ERROR;
>   PyObject *TEP_ERROR;
>   PyObject *TRACECRUNCHER_ERROR;
>   
> +#define UPROBES_SYSTEM "tc_uprobes"

Note that we already have

#define TC_SYS	"tcrunch"

Does it make sence to define a second trace-cruncher system?

> +
> +#define FTRACE_UPROBE		0x1
> +#define FTRACE_URETPROBE	0x2
> +
> +struct fprobes_list {
> +	int size;
> +	int count;
> +	void **data;
> +};
> +
> +struct utrace_func {
> +	int type;
> +	char *func_name;
> +	char *func_args;
> +};
> +
> +struct py_utrace_context {
> +	pid_t pid;
> +	char *fname;
> +	char **argv;
> +	char *usystem;
> +	uint32_t trace_time; /* in msec */
> +	struct fprobes_list fretprobes;
> +	struct fprobes_list ufuncs;
> +	struct fprobes_list uevents;
> +	struct dbg_trace_context *dbg;
> +};
> +
>   static char *kernel_version()
>   {
>   	struct utsname uts;
> @@ -3508,3 +3539,600 @@ void PyFtrace_at_exit(void)
>   	if (seq.buffer)
>   		trace_seq_destroy(&seq);
>   }
> +
> +#define INIT_SIZE	100
This name is too general. Try to make it clear what is to be initialized with this size.

> +static int utrace_list_add(struct fprobes_list *list, void *data)
> +{
> +	void **tmp;
> +	int size;
> +
> +	if (list->size <= list->count) {
> +		if (!list->size)
> +			size = INIT_SIZE;
> +		else
> +			size = 2 * list->size;
> +		tmp = realloc(list->data, size * sizeof(void *));
> +		if (!tmp)
> +			return -1;
> +		list->data = tmp;
> +		list->size = size;
> +	}
> +
> +	list->data[list->count] = data;
> +	list->count++;
> +	return list->count - 1;
> +}
> +
> +void py_utrace_free(struct py_utrace_context *utrace)
> +{
> +	struct utrace_func *f;
> +	int i;
> +
> +	if (!utrace)
> +		return;
> +	if (utrace->dbg)
> +		dbg_trace_context_destroy(utrace->dbg);
> +
> +	for (i = 0; i < utrace->ufuncs.count; i++) {
> +		f = utrace->ufuncs.data[i];
> +		free(f->func_name);
> +		free(f);
> +	}
> +	free(utrace->ufuncs.data);
> +	if (utrace->argv) {
> +		i = 0;
> +		while (utrace->argv[i])
> +			free(utrace->argv[i++]);
> +		free(utrace->argv);
> +	}
> +
> +	for (i = 0; i < utrace->uevents.count; i++)
> +		tracefs_dynevent_free(utrace->uevents.data[i]);
> +	free(utrace->uevents.data);
> +
> +	free(utrace->fname);
> +	free(utrace->usystem);
> +	free(utrace);
> +}
> +
> +/*
> + * All strings, used as ftrace system or event name must contain only
> + * alphabetic characters, digits or underscores.
> + */
> +static void fname_unify(char *fname)
> +{
> +	int i;
> +
> +	for (i = 0; fname[i]; i++)
> +		if (!isalnum(fname[i]) && fname[i] != '_')
> +			fname[i] = '_';
> +}
> +
> +int py_utrace_destroy(struct py_utrace_context *utrace)
> +{
> +	int i;
> +
> +	for (i = 0; i < utrace->uevents.count; i++)
> +		tracefs_dynevent_destroy(utrace->uevents.data[i], true);
> +
> +	return 0;
> +}
> +
> +static struct py_utrace_context *utrace_new(pid_t pid, char *fname, char **argv, bool libs)
> +{
> +	struct py_utrace_context *utrace;
> +	char *file;
> +
> +	utrace = calloc(1, sizeof(*utrace));
> +	if (!utrace)
> +		return NULL;
> +
> +	if (fname) {
> +		utrace->argv = argv;
> +		utrace->dbg = dbg_trace_context_create_file(fname, libs);
> +		if (!utrace->dbg)
> +			goto error;
> +		utrace->fname = strdup(fname);
> +		if (!utrace->fname)
> +			goto error;
> +		file = strrchr(fname, '/');
> +		if (file)
> +			file++;
> +		if (!file || *file == '\0')
> +			file = fname;
> +		if (asprintf(&utrace->usystem, "%s_%s", UPROBES_SYSTEM, file) <= 0)
> +			goto error;
> +	} else {
> +		utrace->pid = pid;
> +		utrace->dbg = dbg_trace_context_create_pid(pid, libs);
> +		if (!utrace->dbg)
> +			goto error;
> +		if (asprintf(&utrace->usystem, "%s_%d", UPROBES_SYSTEM, pid) <= 0)
> +			goto error;
> +	}
> +
> +	fname_unify(utrace->usystem);
> +	return utrace;
> +
> +error:
> +	py_utrace_free(utrace);
> +	return NULL;
> +}
> +
> +static int py_utrace_add_func(struct py_utrace_context *utrace, char *func, int type)
> +{
> +	struct utrace_func *p;
> +	int ret;
> +	int i;
> +
> +	for (i = 0; i < utrace->ufuncs.count; i++) {
> +		p = utrace->ufuncs.data[i];
> +		if (!strcmp(p->func_name, func)) {
> +			p->type |= type;
> +			return 0;
> +		}
> +	}
> +
> +	p = calloc(1, sizeof(*p));
> +	if (!p)
> +		return -1;
> +	p->func_name = strdup(func);
> +	if (!p->func_name)
> +		goto error;
> +	p->type = type;
> +
> +	ret = utrace_list_add(&utrace->ufuncs, p);
> +	if (ret < 0)
> +		goto error;
> +
> +	if (dbg_trace_add_resolve_symbol(utrace->dbg, 0, func, ret))
> +		goto error;
> +
> +	return 0;
> +
> +error:
> +	free(p->func_name);
> +	free(p);
> +	return -1;
> +}
> +
> +PyObject *PyUserTrace_add_function(PyUserTrace *self, PyObject *args,
> +				   PyObject *kwargs)
> +{
> +	struct py_utrace_context *utrace = self->ptrObj;
> +	static char *kwlist[] = {"fname", NULL};
> +	char *fname;
> +
> +	if (!PyArg_ParseTupleAndKeywords(args,
> +					 kwargs,
> +					 "s",
> +					 kwlist,
> +					 &fname)) {
> +		return NULL;
> +	}
> +
> +	if (py_utrace_add_func(utrace, fname, FTRACE_UPROBE) < 0) {
> +		MEM_ERROR
> +		return NULL;
> +	}
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyUserTrace_add_ret_function(PyUserTrace *self, PyObject *args,
> +				       PyObject *kwargs)
> +{
> +	struct py_utrace_context *utrace = self->ptrObj;
> +	static char *kwlist[] = {"fname", NULL};
> +	char *fname;
> +
> +	if (!PyArg_ParseTupleAndKeywords(args,
> +					 kwargs,
> +					 "s",
> +					 kwlist,
> +					 &fname)) {
> +		return NULL;
> +	}
> +
> +	if (py_utrace_add_func(utrace, fname, FTRACE_URETPROBE) < 0) {
> +		MEM_ERROR
> +		return NULL;
> +	}
> +
> +	Py_RETURN_NONE;
> +}
> +
> +/*
> + * max event name is 64 bytes, hard coded in the kernel.
> + * it can consists only of alphabetic characters, digits or underscores
> + */
Please start comments with capital and end with period.


> +#define FILENAME_TRUNCATE	10
> +#define FUNCAME_TRUNCATE	50
> +static char *uprobe_event_name(char *file, char *func, int type)
> +{
> +	char *event = NULL;
> +	char *fname;
> +
> +	fname = strrchr(file, '/');
> +	if (fname)
> +		fname++;
> +	if (!fname || *fname == '\0')
> +		fname = file;
> +
> +	asprintf(&event, "%s%.*s_%.*s",
> +		 type == FTRACE_URETPROBE ? "r_":"",
> +		 FILENAME_TRUNCATE, fname, FUNCAME_TRUNCATE, func);
> +	if (event)
> +		fname_unify(event);
> +
> +	return event;
> +}
> +
> +/*
> + * Create uprobe based on function name,
> + * file name and function offset within the file
> + */
> +static int utrace_event_create(struct py_utrace_context *utrace,
> +			       struct dbg_trace_symbols *sym, char *fecthargs,
> +			       int type)
> +{
> +	struct tracefs_dynevent *uevent = NULL;
> +	char *rname;
> +
> +	/* Generate uprobe event name, according to ftrace name requirements */
> +	rname = uprobe_event_name(sym->fname, sym->name, type);
> +	if (!rname)
> +		return -1;
> +
> +	if (type == FTRACE_URETPROBE)
> +		uevent = tracefs_uretprobe_alloc(utrace->usystem, rname,
> +						 sym->fname, sym->foffset, fecthargs);
> +	else
> +		uevent = tracefs_uprobe_alloc(utrace->usystem, rname,
> +					      sym->fname, sym->foffset, fecthargs);
> +
> +	free(rname);
> +	if (!uevent)
> +		return -1;
> +
> +	if (tracefs_dynevent_create(uevent)) {
> +		tracefs_dynevent_free(uevent);
> +		return -1;
> +	}
> +
> +	utrace_list_add(&utrace->uevents, uevent);
> +	return 0;
> +}
> +
> +/* callback, called on each resolved function */
> +static int symblos_walk(struct dbg_trace_symbols *sym, void *context)
> +{
> +	struct py_utrace_context *utrace = context;
> +	struct utrace_func *ufunc;
> +
> +	if (!sym->name || !sym->fname || !sym->foffset ||
> +	    sym->cookie < 0 || sym->cookie >= utrace->ufuncs.count)
> +		return 0;
> +
> +	ufunc = utrace->ufuncs.data[sym->cookie];
> +
> +	if (ufunc->type & FTRACE_UPROBE)
> +		utrace_event_create(utrace, sym, ufunc->func_args, FTRACE_UPROBE);
> +
> +	if (ufunc->type & FTRACE_URETPROBE)
> +		utrace_event_create(utrace, sym, ufunc->func_args, FTRACE_URETPROBE);
> +
> +	return 0;
> +}
> +
> +static void py_utrace_generate_uprobes(struct py_utrace_context *utrace)
> +{
> +	/* Find the exact name and file offset of each user function that should be traced */
> +	dbg_trace_resolve_symbols(utrace->dbg);
> +	dbg_trace_walk_resolved_symbols(utrace->dbg, symblos_walk, utrace);
> +}
> +
> +static int start_trace(struct py_utrace_context *utrace, struct tracefs_instance *instance)

The name is too general.

> +{
> +	PyObject *pPid = PyLong_FromLong(utrace->pid);
> +	bool ret;
> +
> +	if (!pPid)
> +		return -1;
> +
> +	/* Filter the trace only on desired pid(s) */
> +	ret = hook2pid(instance, PyLong_FromLong(utrace->pid), true);
> +	Py_DECREF(pPid);
> +	if (!ret) {
> +		PyErr_SetString(TRACECRUNCHER_ERROR,
> +				"Failed to set trace filter");
> +		return -1;
> +	}
> +
> +	/* Enable uprobes in the system */
> +	if (tracefs_event_enable(instance, utrace->usystem, NULL)) {
> +		PyErr_SetString(TRACECRUNCHER_ERROR,
> +				"Failed to enable trace events");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +#define PERF_EXEC_SYNC	"/TC_PERF_SYNC_XXXXXX"
> +static int utrace_exec_cmd(struct py_utrace_context *utrace, struct tracefs_instance *instance)
> +{
> +	char *envp[] = {NULL};
> +	char sname[strlen(PERF_EXEC_SYNC) + 1];
> +	sem_t *sem;
> +	pid_t pid;
> +	int ret;
> +
> +	strcpy(sname, PERF_EXEC_SYNC);
> +	mktemp(sname);
> +	sem = sem_open(sname, O_CREAT | O_EXCL, 0644, 0);
> +	sem_unlink(sname);
> +
> +	pid = fork();
> +	if (pid < 0) {
> +		PyErr_SetString(TRACECRUNCHER_ERROR, "Failed to fork");
> +		return -1;
> +	}
> +	if (pid == 0) {
> +		sem_wait(sem);
> +		execvpe(utrace->fname, utrace->argv, envp);
> +	} else {
> +		utrace->pid = pid;
> +		start_trace(utrace, instance);
> +		sem_post(sem);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int py_utrace_enable(struct py_utrace_context *utrace, struct tracefs_instance *instance)
> +{
> +	/* If uprobes on desired user functions are not yet generated, do it now */
> +	if (!utrace->uevents.count)
> +		py_utrace_generate_uprobes(utrace);
> +
> +	/* No functions are found in the given program / pid */
> +	if (!utrace->uevents.count) {
> +		PyErr_SetString(TRACECRUNCHER_ERROR,
> +				"Cannot find requested user functions");
> +		return -1;
> +	}
> +
> +	if (utrace->fname)
> +		utrace_exec_cmd(utrace, instance);
> +	else
> +		start_trace(utrace, instance);
> +
> +	return 0;
> +}
> +
> +static int py_utrace_disable(struct py_utrace_context *utrace, struct tracefs_instance *instance)
> +{
> +	/* Disable uprobes in the system */
> +	if (tracefs_event_disable(instance, utrace->usystem, NULL)) {
> +		PyErr_SetString(TRACECRUNCHER_ERROR,
> +				"Failed to disable trace events");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static bool tracing_run;
> +
> +static void tracing_stop(int sig)
> +{
> +	tracing_run = false;
> +}
> +
> +static void tracing_timer(int sig, siginfo_t *si, void *uc)
> +{
> +	tracing_run = false;
> +}
> +
> +#define PID_WAIT_CHECK_USEC	500000
> +#define TIMER_SEC_NANO		1000000000LL
> +static int utrace_wait_pid(struct py_utrace_context *utrace)
> +{
> +	struct itimerspec tperiod = {0};
> +	struct sigaction saction = {0};
> +	struct sigevent stime = {0};
> +	timer_t timer_id;
> +
> +	if (utrace->pid == 0)
> +		return -1;
> +
> +	tracing_run = true;
> +	signal(SIGINT, tracing_stop);
> +
> +	if (utrace->trace_time) {
> +		stime.sigev_notify = SIGEV_SIGNAL;
> +		stime.sigev_signo = SIGRTMIN;
> +		if (timer_create(CLOCK_MONOTONIC, &stime, &timer_id))
> +			return -1;
> +		saction.sa_flags = SA_SIGINFO;
> +		saction.sa_sigaction = tracing_timer;
> +		sigemptyset(&saction.sa_mask);
> +		if (sigaction(SIGRTMIN, &saction, NULL)) {
> +			timer_delete(timer_id);
> +			return -1;
> +		}
> +		/* covert trace_time from msec to sec, nsec */
> +		tperiod.it_value.tv_nsec = ((unsigned long long)utrace->trace_time * 1000000LL);
> +		if (tperiod.it_value.tv_nsec >= TIMER_SEC_NANO) {
> +			tperiod.it_value.tv_sec = tperiod.it_value.tv_nsec / TIMER_SEC_NANO;
> +			tperiod.it_value.tv_nsec %= TIMER_SEC_NANO;
> +		}
> +		if (timer_settime(timer_id, 0, &tperiod, NULL))
> +			return -1;
> +	}
> +
> +	do {
> +		if (utrace->fname) { /* wait for a child */
> +			if (waitpid(utrace->pid, NULL, WNOHANG) == (int)utrace->pid) {
> +				utrace->pid = 0;
> +				tracing_run = false;
> +			}
> +		} else { /* not a child, check if still exist */
> +			if (kill(utrace->pid, 0) == -1 && errno == ESRCH) {
> +				utrace->pid = 0;
> +				tracing_run = false;
> +			}
> +		}
> +		usleep(PID_WAIT_CHECK_USEC);
> +	} while (tracing_run);
> +
> +	if (utrace->trace_time)
> +		timer_delete(timer_id);
> +
> +	signal(SIGINT, SIG_DFL);
> +
> +	return 0;
> +}
> +
> +PyObject *PyUserTrace_enable(PyUserTrace *self, PyObject *args, PyObject *kwargs)
> +{
> +	struct py_utrace_context *utrace = self->ptrObj;
> +	static char *kwlist[] = {"instance", "wait", "time", NULL};
> +	struct tracefs_instance *instance = NULL;
> +	PyObject *py_inst = NULL;
> +	int wait = false;
> +	int ret;
> +
> +	if (!utrace) {
> +		PyErr_SetString(TRACECRUNCHER_ERROR,
> +				"Failed to get utrace context");
> +		return NULL;
> +	}
> +
> +	if (!PyArg_ParseTupleAndKeywords(args,
> +					 kwargs,
> +					 "|Ops",
> +					 kwlist,
> +					 &py_inst,
> +					 &wait,
> +					 &utrace->trace_time)) {
> +		PyErr_SetString(TRACECRUNCHER_ERROR,
> +				"Failed to parse input arguments");
> +		return NULL;
> +	}
> +
> +	if (!get_optional_instance(py_inst, &instance))
> +		return NULL;
> +
> +	ret = py_utrace_enable(utrace, instance);
> +	if (ret)
> +		return NULL;
> +
> +	if (wait) {
> +		utrace_wait_pid(utrace);
> +		py_utrace_disable(utrace, instance);
> +	}
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyUserTrace_disable(PyUserTrace *self, PyObject *args, PyObject *kwargs)
> +{
> +	struct py_utrace_context *utrace = self->ptrObj;
> +	static char *kwlist[] = {"instance", NULL};
> +	struct tracefs_instance *instance = NULL;
> +	PyObject *py_inst = NULL;
> +	int ret;
> +
> +	if (!utrace) {
> +		PyErr_SetString(TRACECRUNCHER_ERROR,
> +				"Failed to get utrace context");
> +		return NULL;
> +	}
> +
> +	if (!PyArg_ParseTupleAndKeywords(args,
> +					 kwargs,
> +					 "|O",
> +					 kwlist,
> +					 &py_inst)) {
> +		PyErr_SetString(TRACECRUNCHER_ERROR,
> +				"Failed to parse input arguments");
> +		return NULL;
> +	}
> +
> +	if (!get_optional_instance(py_inst, &instance))
> +		return NULL;
> +
> +	ret = py_utrace_disable(utrace, instance);
> +
> +	if (ret)
> +		return NULL;
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyFtrace_utrace(PyObject *self, PyObject *args, PyObject *kwargs)
This must be PyFtrace_user_trace()

> +{
> +	static char *kwlist[] = {"pid", "name", "follow_libs", "argv", NULL};

I still think the 'name' argument is redundant. It is the same as argv[0].

Note that when we use 'execvPe()', there is no need to provide the absolute path. All locations provided in $PATH will 
be searched, that is identical to calling 'shutil.which()' in the user code.

Even if we need the absolute path for something else, this path can be derived internally.


> +	struct py_utrace_context *utrace;
> +	char **argv = NULL;
> +	long long pid = 0;
> +	char *comm = NULL;
> +	int libs = 0;
> +	PyObject *py_utrace, *py_arg, *py_args = NULL;
> +	int i, argc;
> +
> +	if (!PyArg_ParseTupleAndKeywords(args,
> +					 kwargs,
> +					 "|KspO",
> +					 kwlist,
> +					 &pid,
> +					 &comm,
> +					 &libs,
> +					 &py_args)) {
> +		return NULL;
> +	}
> +
> +	if (pid == 0 && !comm) {
If both 'pid' and 'name' (argv) are provided, this must be considered error (not silently taking one of the two) and a 
proper error message must be printed. Also error in the case when 'pid' is negative.

Thanks!
Yordan

> +		PyErr_Format(TFS_ERROR,
> +			     "Process ID or program name should be specified");
> +		return NULL;
> +	}
> +
> +	if (comm && py_args) {
> +		if (!PyList_CheckExact(py_args)) {
> +			PyErr_SetString(TFS_ERROR, "Failed to parse argv list");
> +			return NULL;
> +		}
> +		argc = PyList_Size(py_args);
> +		argv = calloc(argc + 1, sizeof(char *));
> +		for (i = 0; i < argc; i++) {
> +			py_arg = PyList_GetItem(py_args, i);
> +			if (!PyUnicode_Check(py_arg))
> +				continue;
> +			argv[i] = strdup(PyUnicode_DATA(py_arg));
> +			if (!argv[i])
> +				goto error;
> +		}
> +		argv[i] = NULL;
> +	}
> +
> +	utrace = utrace_new(pid, comm, argv, libs);
> +	if (!utrace) {
> +		MEM_ERROR;
> +		goto error;
> +	}
> +	py_utrace = PyUserTrace_New(utrace);
> +
> +	return py_utrace;
> +
> +error:
> +	if (argv) {
> +		for (i = 0; i < argc; i++)
> +			free(argv[i]);
> +		free(argv);
> +	}
> +	return NULL;
> +}
> diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
> index e6fab69..0b5000b 100644
> --- a/src/ftracepy-utils.h
> +++ b/src/ftracepy-utils.h
> @@ -34,6 +34,21 @@ C_OBJECT_WRAPPER_DECLARE(tracefs_synth, PySynthEvent)
>   
>   PyObject *PyTepRecord_time(PyTepRecord* self);
>   
> +struct py_utrace_context;
> +void py_utrace_free(struct py_utrace_context *utrace);
> +int py_utrace_destroy(struct py_utrace_context *utrace);
> +C_OBJECT_WRAPPER_DECLARE(py_utrace_context, PyUserTrace);
> +
> +PyObject *PyUserTrace_add_function(PyUserTrace *self, PyObject *args,
> +				   PyObject *kwargs);
> +
> +PyObject *PyUserTrace_add_ret_function(PyUserTrace *self, PyObject *args,
> +				       PyObject *kwargs);
> +
> +PyObject *PyUserTrace_enable(PyUserTrace *self, PyObject *args, PyObject *kwargs);
> +
> +PyObject *PyUserTrace_disable(PyUserTrace *self, PyObject *args, PyObject *kwargs);
> +
>   PyObject *PyTepRecord_cpu(PyTepRecord* self);
>   
>   PyObject *PyTepEvent_name(PyTepEvent* self);
> @@ -270,6 +285,8 @@ PyObject *PyFtrace_synth(PyObject *self, PyObject *args,
>   PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
>   						       PyObject *kwargs);
>   
> +PyObject *PyFtrace_utrace(PyObject *self, PyObject *args, PyObject *kwargs);
> +
>   PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
>   						 PyObject *kwargs);
>   
> diff --git a/src/ftracepy.c b/src/ftracepy.c
> index 681d641..6ca9df0 100644
> --- a/src/ftracepy.c
> +++ b/src/ftracepy.c
> @@ -315,6 +315,32 @@ C_OBJECT_WRAPPER(tracefs_synth, PySynthEvent,
>   		 tracefs_synth_destroy,
>   		 tracefs_synth_free)
>   
> +static PyMethodDef PyUserTrace_methods[] = {
> +	{"add_function",
> +	 (PyCFunction) PyUserTrace_add_function,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Add tracepoint on user function."
> +	},
> +	{"add_ret_function",
> +	 (PyCFunction) PyUserTrace_add_ret_function,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Add tracepoint on user function return."
> +	},
> +	{"enable",
> +	 (PyCFunction) PyUserTrace_enable,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Enable tracing of the configured user tracepoints."
> +	},
> +	{"disable",
> +	 (PyCFunction) PyUserTrace_disable,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Disable tracing of the configured user tracepoints."
> +	},
> +	{NULL, NULL, 0, NULL}
> +};
> +C_OBJECT_WRAPPER(py_utrace_context, PyUserTrace,
> +		 py_utrace_destroy, py_utrace_free)
> +
>   static PyMethodDef ftracepy_methods[] = {
>   	{"dir",
>   	 (PyCFunction) PyFtrace_dir,
> @@ -501,6 +527,11 @@ static PyMethodDef ftracepy_methods[] = {
>   	 METH_VARARGS | METH_KEYWORDS,
>   	 "Define a synthetic event."
>   	},
> +	{"user_trace",
> +	 (PyCFunction) PyFtrace_utrace,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Create a context for tracing a user process using uprobes"
> +	},
>   	{"set_ftrace_loglevel",
>   	 (PyCFunction) PyFtrace_set_ftrace_loglevel,
>   	 METH_VARARGS | METH_KEYWORDS,
> @@ -575,6 +606,9 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
>   	if (!PySynthEventTypeInit())
>   		return NULL;
>   
> +	if (!PyUserTraceTypeInit())
> +		return NULL;
> +
>   	TFS_ERROR = PyErr_NewException("tracecruncher.ftracepy.tfs_error",
>   				       NULL, NULL);
>   
> @@ -593,6 +627,7 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
>   	PyModule_AddObject(module, "tracefs_dynevent", (PyObject *) &PyDyneventType);
>   	PyModule_AddObject(module, "tracefs_hist", (PyObject *) &PyTraceHistType);
>   	PyModule_AddObject(module, "tracefs_synth", (PyObject *) &PySynthEventType);
> +	PyModule_AddObject(module, "py_utrace_context", (PyObject *) &PyUserTraceType);
>   
>   	PyModule_AddObject(module, "tfs_error", TFS_ERROR);
>   	PyModule_AddObject(module, "tep_error", TEP_ERROR);
