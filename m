Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB963C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 08:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376597AbiDTIFC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376599AbiDTIFB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 04:05:01 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905CA3C4B4
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 01:02:14 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ks6so1887576ejb.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 01:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zwHwx0qQ/dip6b3JdqSp301udOyKQhlK2finJcZkHEI=;
        b=JGbfxF7/bjD9dUNtUshL4LO+/ha462vv42MdCLWAiHvk6aD1uItPfbDdbIaTQpnzuM
         +6zDvvDERgCBNi83nwaqdEGRfarpGZmEDjY0I7Yp/RmI+jn0jYhBA3UvNre9QfNlXF3h
         WofzDWM0LmbUMEDbJjqbpLfqoHCFN3t4l6MYatsD8nKmsRq7SK7144wP//G4r8ffWYMN
         aFhEXmCPW9kzF9LwGw9rI9woPJ3Iymb1NhkF9IJfQqSDWd3vS+Vg/a7Z8Zq5H0JTA6rr
         3+JG2bM5O8JmSA6uryEAA9OprwOCGJPUAefeZIuEg3ksRQdnIfg/NY4sr/kAsqCDWTIC
         Jcwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zwHwx0qQ/dip6b3JdqSp301udOyKQhlK2finJcZkHEI=;
        b=0pd6b/L1LPo8En6gA1MaIEXcCaZzNwUXD5WJ2JiP9DHGtME7/NIYUrRVibZThrsFMO
         5gaYAswOCnkUsBK/bhkCJXcYvoBzsTbqbYXsyNqprIIKVYi8WghoPnPTQewkbtvKaQxM
         4YpJ7+V2UTQp5nElyDZzuKBq51vTgsOhSTBAKI3V3P1L/+jPg5jgqJcfLeLeHZ5mOeOn
         ofmLIVvzezM2AOu/s0LemFCo4Aapv+Mv8VU14Gl9krE+wdCzZmWXuVBNPey+CsB/qV5y
         olSUq45DJv0fcd1O2tBjxEEZ2m/zITwTiWWIpOchKaoARcaPzKiL0K/zY1N4vIxZIGYC
         jRMw==
X-Gm-Message-State: AOAM53191c14PA/JxeNjYihWcIujF9xN9KFHbHCEmM8xJqfdJePptpVp
        awPe2Kkxj9XjWdsAPdBRgAo=
X-Google-Smtp-Source: ABdhPJxY0rdKxZcy1JyswXxUOn0ydnOrjHCE67+EVmXXnS89T755fmUtbAccpSuTJP0YPhUvUCJCHA==
X-Received: by 2002:a17:906:c0d6:b0:6ca:457e:f1b7 with SMTP id bn22-20020a170906c0d600b006ca457ef1b7mr16708177ejb.399.1650441732953;
        Wed, 20 Apr 2022 01:02:12 -0700 (PDT)
Received: from oberon.zico.biz.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t12-20020a1709067c0c00b006e86db76851sm6393763ejo.193.2022.04.20.01.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 01:02:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH v3 3/4] trace-cruncher: High level wrappers for ftrace uprobes
Date:   Wed, 20 Apr 2022 11:02:05 +0300
Message-Id: <20220420080206.252356-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220420080206.252356-1-tz.stoyanov@gmail.com>
References: <20220420080206.252356-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using uprobes requires finding the offset of a user function within the
binary file, where this functions is compiled. This is not a trivial
task, especially in the cases when a bunch of uprobes to user functions
should be added.
A high level trace-cruncher API allows adding multiple user functions as
uprobes or uretprobes. It supports wildcards for function names and
adding uprobes for library functions, used by the applications.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 setup.py             |   4 +-
 src/ftracepy-utils.c | 698 +++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  17 ++
 src/ftracepy.c       |  35 +++
 4 files changed, 752 insertions(+), 2 deletions(-)

diff --git a/setup.py b/setup.py
index 58561cf..464d3d2 100644
--- a/setup.py
+++ b/setup.py
@@ -71,8 +71,8 @@ def extension(name, sources, libraries):
 
 def main():
     module_ft = extension(name='tracecruncher.ftracepy',
-                          sources=['src/ftracepy.c', 'src/ftracepy-utils.c'],
-                          libraries=['traceevent', 'tracefs'])
+                          sources=['src/ftracepy.c', 'src/ftracepy-utils.c', 'src/trace-obj-debug.c'],
+                          libraries=['traceevent', 'tracefs', 'bfd'])
 
     cythonize('src/npdatawrapper.pyx', language_level = 3)
     module_data = extension(name='tracecruncher.npdatawrapper',
diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index b39459b..9d9fa5d 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -10,20 +10,51 @@
 #endif // _GNU_SOURCE
 
 // C
+#include <unistd.h>
 #include <search.h>
 #include <string.h>
 #include <sys/utsname.h>
 #include <sys/wait.h>
 #include <signal.h>
+#include <semaphore.h>
 #include <time.h>
 
 // trace-cruncher
 #include "ftracepy-utils.h"
+#include "trace-obj-debug.h"
 
 PyObject *TFS_ERROR;
 PyObject *TEP_ERROR;
 PyObject *TRACECRUNCHER_ERROR;
 
+#define UPROBES_SYSTEM "tc_uprobes"
+
+#define FTRACE_UPROBE		0x1
+#define FTRACE_URETPROBE	0x2
+
+struct fprobes_list {
+	int size;
+	int count;
+	void **data;
+};
+
+struct utrace_func {
+	int type;
+	char *func_name;
+	char *func_args;
+};
+
+struct py_utrace_context {
+	pid_t pid;
+	char **cmd_argv;
+	char *usystem;
+	uint32_t trace_time; /* in msec */
+	struct fprobes_list fretprobes;
+	struct fprobes_list ufuncs;
+	struct fprobes_list uevents;
+	struct dbg_trace_context *dbg;
+};
+
 static char *kernel_version()
 {
 	struct utsname uts;
@@ -3508,3 +3539,670 @@ void PyFtrace_at_exit(void)
 	if (seq.buffer)
 		trace_seq_destroy(&seq);
 }
+
+#define UTRACE_LIST_INIT_SIZE	100
+static int utrace_list_add(struct fprobes_list *list, void *data)
+{
+	void **tmp;
+	int size;
+
+	if (list->size <= list->count) {
+		if (!list->size)
+			size = UTRACE_LIST_INIT_SIZE;
+		else
+			size = 2 * list->size;
+		tmp = realloc(list->data, size * sizeof(void *));
+		if (!tmp)
+			return -1;
+		list->data = tmp;
+		list->size = size;
+	}
+
+	list->data[list->count] = data;
+	list->count++;
+	return list->count - 1;
+}
+
+void py_utrace_free(struct py_utrace_context *utrace)
+{
+	struct utrace_func *f;
+	int i;
+
+	if (!utrace)
+		return;
+	if (utrace->dbg)
+		dbg_trace_context_destroy(utrace->dbg);
+
+	for (i = 0; i < utrace->ufuncs.count; i++) {
+		f = utrace->ufuncs.data[i];
+		free(f->func_name);
+		free(f);
+	}
+	free(utrace->ufuncs.data);
+	if (utrace->cmd_argv) {
+		i = 0;
+		while (utrace->cmd_argv[i])
+			free(utrace->cmd_argv[i++]);
+		free(utrace->cmd_argv);
+	}
+
+	for (i = 0; i < utrace->uevents.count; i++)
+		tracefs_dynevent_free(utrace->uevents.data[i]);
+	free(utrace->uevents.data);
+
+	free(utrace->usystem);
+	free(utrace);
+}
+
+/*
+ * All strings, used as ftrace system or event name must contain only
+ * alphabetic characters, digits or underscores.
+ */
+static void fname_unify(char *fname)
+{
+	int i;
+
+	for (i = 0; fname[i]; i++)
+		if (!isalnum(fname[i]) && fname[i] != '_')
+			fname[i] = '_';
+}
+
+int py_utrace_destroy(struct py_utrace_context *utrace)
+{
+	int i;
+
+	for (i = 0; i < utrace->uevents.count; i++)
+		tracefs_dynevent_destroy(utrace->uevents.data[i], true);
+
+	return 0;
+}
+
+static unsigned long long str_hash(char *s)
+{
+	unsigned long long sum = 0, add;
+	int i, len = strlen(s);
+
+	for (i = 0; i < len; i++) {
+		if (i + 8 < len)
+			add = *(long long *)(s+i);
+		else if (i + 4 < len)
+			add = *(long *)(s+i);
+		else
+			add = s[i];
+
+		sum += add;
+	}
+
+	return sum;
+}
+
+static struct py_utrace_context *utrace_new(pid_t pid, char **argv, bool libs)
+{
+	struct py_utrace_context *utrace;
+
+	utrace = calloc(1, sizeof(*utrace));
+	if (!utrace)
+		return NULL;
+
+	if (argv) {
+		utrace->cmd_argv = argv;
+		utrace->dbg = dbg_trace_context_create_file(argv[0], libs);
+		if (!utrace->dbg)
+			goto error;
+		if (asprintf(&utrace->usystem, "%s_%llX", UPROBES_SYSTEM, str_hash(argv[0])) <= 0)
+			goto error;
+	} else {
+		utrace->pid = pid;
+		utrace->dbg = dbg_trace_context_create_pid(pid, libs);
+		if (!utrace->dbg)
+			goto error;
+		if (asprintf(&utrace->usystem, "%s_%d", UPROBES_SYSTEM, pid) <= 0)
+			goto error;
+	}
+
+	fname_unify(utrace->usystem);
+	return utrace;
+
+error:
+	py_utrace_free(utrace);
+	return NULL;
+}
+
+static int py_utrace_add_func(struct py_utrace_context *utrace, char *func, int type)
+{
+	struct utrace_func *p;
+	int ret;
+	int i;
+
+	for (i = 0; i < utrace->ufuncs.count; i++) {
+		p = utrace->ufuncs.data[i];
+		if (!strcmp(p->func_name, func)) {
+			p->type |= type;
+			return 0;
+		}
+	}
+
+	p = calloc(1, sizeof(*p));
+	if (!p)
+		return -1;
+	p->func_name = strdup(func);
+	if (!p->func_name)
+		goto error;
+	p->type = type;
+
+	ret = utrace_list_add(&utrace->ufuncs, p);
+	if (ret < 0)
+		goto error;
+
+	if (dbg_trace_add_resolve_symbol(utrace->dbg, 0, func, ret))
+		goto error;
+
+	return 0;
+
+error:
+	free(p->func_name);
+	free(p);
+	return -1;
+}
+
+PyObject *PyUserTrace_add_function(PyUserTrace *self, PyObject *args,
+				   PyObject *kwargs)
+{
+	struct py_utrace_context *utrace = self->ptrObj;
+	static char *kwlist[] = {"fname", NULL};
+	char *fname;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "s",
+					 kwlist,
+					 &fname)) {
+		return NULL;
+	}
+
+	if (py_utrace_add_func(utrace, fname, FTRACE_UPROBE) < 0) {
+		MEM_ERROR
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyUserTrace_add_ret_function(PyUserTrace *self, PyObject *args,
+				       PyObject *kwargs)
+{
+	struct py_utrace_context *utrace = self->ptrObj;
+	static char *kwlist[] = {"fname", NULL};
+	char *fname;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "s",
+					 kwlist,
+					 &fname)) {
+		return NULL;
+	}
+
+	if (py_utrace_add_func(utrace, fname, FTRACE_URETPROBE) < 0) {
+		MEM_ERROR
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
+/*
+ * Max event name is 64 bytes, hard coded in the kernel.
+ * It can consist only of alphabetic characters, digits or underscores.
+ */
+#define FILENAME_TRUNCATE	10
+#define FUNCAME_TRUNCATE	50
+static char *uprobe_event_name(char *file, char *func, int type)
+{
+	char *event = NULL;
+	char *fname;
+
+	fname = strrchr(file, '/');
+	if (fname)
+		fname++;
+	if (!fname || *fname == '\0')
+		fname = file;
+
+	asprintf(&event, "%s%.*s_%.*s",
+		 type == FTRACE_URETPROBE ? "r_":"",
+		 FILENAME_TRUNCATE, fname, FUNCAME_TRUNCATE, func);
+	if (event)
+		fname_unify(event);
+
+	return event;
+}
+
+/*
+ * Create uprobe based on function name,
+ * file name and function offset within the file.
+ */
+static int utrace_event_create(struct py_utrace_context *utrace,
+			       struct dbg_trace_symbols *sym, char *fecthargs,
+			       int type)
+{
+	struct tracefs_dynevent *uevent = NULL;
+	char *rname;
+
+	/* Generate uprobe event name, according to ftrace name requirements. */
+	rname = uprobe_event_name(sym->fname, sym->name, type);
+	if (!rname)
+		return -1;
+
+	if (type == FTRACE_URETPROBE)
+		uevent = tracefs_uretprobe_alloc(utrace->usystem, rname,
+						 sym->fname, sym->foffset, fecthargs);
+	else
+		uevent = tracefs_uprobe_alloc(utrace->usystem, rname,
+					      sym->fname, sym->foffset, fecthargs);
+
+	free(rname);
+	if (!uevent)
+		return -1;
+
+	if (tracefs_dynevent_create(uevent)) {
+		tracefs_dynevent_free(uevent);
+		return -1;
+	}
+
+	utrace_list_add(&utrace->uevents, uevent);
+	return 0;
+}
+
+/* A callback, called on each resolved function. */
+static int symblos_walk(struct dbg_trace_symbols *sym, void *context)
+{
+	struct py_utrace_context *utrace = context;
+	struct utrace_func *ufunc;
+
+	if (!sym->name || !sym->fname || !sym->foffset ||
+	    sym->cookie < 0 || sym->cookie >= utrace->ufuncs.count)
+		return 0;
+
+	ufunc = utrace->ufuncs.data[sym->cookie];
+
+	if (ufunc->type & FTRACE_UPROBE)
+		utrace_event_create(utrace, sym, ufunc->func_args, FTRACE_UPROBE);
+
+	if (ufunc->type & FTRACE_URETPROBE)
+		utrace_event_create(utrace, sym, ufunc->func_args, FTRACE_URETPROBE);
+
+	return 0;
+}
+
+static void py_utrace_generate_uprobes(struct py_utrace_context *utrace)
+{
+	/* Find the exact name and file offset of each user function that should be traced. */
+	dbg_trace_resolve_symbols(utrace->dbg);
+	dbg_trace_walk_resolved_symbols(utrace->dbg, symblos_walk, utrace);
+}
+
+static int uprobe_start_trace(struct py_utrace_context *utrace, struct tracefs_instance *instance)
+{
+	PyObject *pPid = PyLong_FromLong(utrace->pid);
+	bool ret;
+
+	if (!pPid)
+		return -1;
+
+	/* Filter the trace only on desired pid(s). */
+	ret = hook2pid(instance, PyLong_FromLong(utrace->pid), true);
+	Py_DECREF(pPid);
+	if (!ret) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Failed to set trace filter");
+		return -1;
+	}
+
+	/* Enable uprobes in the system. */
+	if (tracefs_event_enable(instance, utrace->usystem, NULL)) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Failed to enable trace events");
+		return -1;
+	}
+
+	return 0;
+}
+
+#define PERF_EXEC_SYNC	"/TC_PERF_SYNC_XXXXXX"
+static int uprobe_exec_cmd(struct py_utrace_context *utrace, struct tracefs_instance *instance)
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
+	if (pid < 0) {
+		PyErr_SetString(TRACECRUNCHER_ERROR, "Failed to fork");
+		return -1;
+	}
+	if (pid == 0) {
+		sem_wait(sem);
+		execvpe(utrace->cmd_argv[0], utrace->cmd_argv, envp);
+	} else {
+		utrace->pid = pid;
+		uprobe_start_trace(utrace, instance);
+		sem_post(sem);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int py_utrace_enable(struct py_utrace_context *utrace, struct tracefs_instance *instance)
+{
+	/* If uprobes on desired user functions are not yet generated, do it now. */
+	if (!utrace->uevents.count)
+		py_utrace_generate_uprobes(utrace);
+
+	/* No functions are found in the given program / pid. */
+	if (!utrace->uevents.count) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Cannot find requested user functions");
+		return -1;
+	}
+
+	if (utrace->cmd_argv)
+		uprobe_exec_cmd(utrace, instance);
+	else
+		uprobe_start_trace(utrace, instance);
+
+	return 0;
+}
+
+static int py_utrace_disable(struct py_utrace_context *utrace, struct tracefs_instance *instance)
+{
+	/* Disable uprobes in the system. */
+	if (tracefs_event_disable(instance, utrace->usystem, NULL)) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Failed to disable trace events");
+		return -1;
+	}
+
+	return 0;
+}
+
+static bool tracing_run;
+
+static void tracing_stop(int sig)
+{
+	tracing_run = false;
+}
+
+static void tracing_timer(int sig, siginfo_t *si, void *uc)
+{
+	tracing_run = false;
+}
+
+#define PID_WAIT_CHECK_USEC	500000
+#define TIMER_SEC_NANO		1000000000LL
+static int utrace_wait_pid(struct py_utrace_context *utrace)
+{
+	struct itimerspec tperiod = {0};
+	struct sigaction saction = {0};
+	struct sigevent stime = {0};
+	timer_t timer_id;
+
+	if (utrace->pid == 0)
+		return -1;
+
+	tracing_run = true;
+	signal(SIGINT, tracing_stop);
+
+	if (utrace->trace_time) {
+		stime.sigev_notify = SIGEV_SIGNAL;
+		stime.sigev_signo = SIGRTMIN;
+		if (timer_create(CLOCK_MONOTONIC, &stime, &timer_id))
+			return -1;
+		saction.sa_flags = SA_SIGINFO;
+		saction.sa_sigaction = tracing_timer;
+		sigemptyset(&saction.sa_mask);
+		if (sigaction(SIGRTMIN, &saction, NULL)) {
+			timer_delete(timer_id);
+			return -1;
+		}
+		/* Convert trace_time from msec to sec, nsec. */
+		tperiod.it_value.tv_nsec = ((unsigned long long)utrace->trace_time * 1000000LL);
+		if (tperiod.it_value.tv_nsec >= TIMER_SEC_NANO) {
+			tperiod.it_value.tv_sec = tperiod.it_value.tv_nsec / TIMER_SEC_NANO;
+			tperiod.it_value.tv_nsec %= TIMER_SEC_NANO;
+		}
+		if (timer_settime(timer_id, 0, &tperiod, NULL))
+			return -1;
+	}
+
+	do {
+		if (utrace->cmd_argv) { /* Wait for a child. */
+			if (waitpid(utrace->pid, NULL, WNOHANG) == (int)utrace->pid) {
+				utrace->pid = 0;
+				tracing_run = false;
+			}
+		} else { /* Not a child, check if still exist. */
+			if (kill(utrace->pid, 0) == -1 && errno == ESRCH) {
+				utrace->pid = 0;
+				tracing_run = false;
+			}
+		}
+		usleep(PID_WAIT_CHECK_USEC);
+	} while (tracing_run);
+
+	if (utrace->trace_time)
+		timer_delete(timer_id);
+
+	signal(SIGINT, SIG_DFL);
+
+	return 0;
+}
+
+PyObject *PyUserTrace_enable(PyUserTrace *self, PyObject *args, PyObject *kwargs)
+{
+	struct py_utrace_context *utrace = self->ptrObj;
+	static char *kwlist[] = {"instance", "wait", "time", NULL};
+	struct tracefs_instance *instance = NULL;
+	PyObject *py_inst = NULL;
+	int wait = false;
+	int ret;
+
+	if (!utrace) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Failed to get utrace context");
+		return NULL;
+	}
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "|Ops",
+					 kwlist,
+					 &py_inst,
+					 &wait,
+					 &utrace->trace_time)) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Failed to parse input arguments");
+		return NULL;
+	}
+
+	if (!get_optional_instance(py_inst, &instance))
+		return NULL;
+
+	ret = py_utrace_enable(utrace, instance);
+	if (ret)
+		return NULL;
+
+	if (wait) {
+		utrace_wait_pid(utrace);
+		py_utrace_disable(utrace, instance);
+	}
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyUserTrace_disable(PyUserTrace *self, PyObject *args, PyObject *kwargs)
+{
+	struct py_utrace_context *utrace = self->ptrObj;
+	static char *kwlist[] = {"instance", NULL};
+	struct tracefs_instance *instance = NULL;
+	PyObject *py_inst = NULL;
+	int ret;
+
+	if (!utrace) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Failed to get utrace context");
+		return NULL;
+	}
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "|O",
+					 kwlist,
+					 &py_inst)) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Failed to parse input arguments");
+		return NULL;
+	}
+
+	if (!get_optional_instance(py_inst, &instance))
+		return NULL;
+
+	ret = py_utrace_disable(utrace, instance);
+
+	if (ret)
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+static char *find_in_path(const char *name)
+{
+	char *paths = strdup(getenv("PATH"));
+	char fullpath[PATH_MAX];
+	bool found = false;
+	char *tmp = paths;
+	const char *item;
+
+	if (!paths)
+		return NULL;
+
+	while ((item = strsep(&paths, ":")) != NULL) {
+		snprintf(fullpath, PATH_MAX, "%s/%s", item, name);
+		if (access(fullpath, F_OK|X_OK) == 0) {
+			found = true;
+			break;
+		}
+	}
+
+	free(tmp);
+
+	if (found)
+		return strdup(fullpath);
+
+	return NULL;
+}
+
+static char *get_full_name(char *name)
+{
+	bool resolve = false;
+	char *fname, *tmp;
+
+	if (!strchr(name, '/')) {
+		tmp = find_in_path(name);
+		if (!tmp)
+			return NULL;
+		resolve = true;
+	} else {
+		tmp = name;
+	}
+
+	fname = realpath(tmp, NULL);
+	if (resolve)
+		free(tmp);
+
+	return fname;
+}
+
+PyObject *PyFtrace_user_trace(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	static char *kwlist[] = {"pid", "argv", "follow_libs", NULL};
+	PyObject *py_utrace, *py_arg, *py_args = NULL;
+	struct py_utrace_context *utrace;
+	char **argv = NULL;
+	long long pid = 0;
+	int libs = 0;
+	int i, argc;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "|KOp",
+					 kwlist,
+					 &pid,
+					 &py_args,
+					 &libs)) {
+		return NULL;
+	}
+
+	if (pid <= 0 && !py_args) {
+		PyErr_Format(TFS_ERROR,
+			     "Process ID or program name should be specified");
+		return NULL;
+	}
+	if (pid > 0 && py_args) {
+		PyErr_Format(TFS_ERROR,
+			     "Only one of Process ID or program name should be specified");
+		return NULL;
+	}
+
+	if (py_args) {
+		if (!PyList_CheckExact(py_args)) {
+			PyErr_Format(TFS_ERROR, "Failed to parse argv list");
+			return NULL;
+		}
+		argc = PyList_Size(py_args);
+		argv = calloc(argc + 1, sizeof(char *));
+		for (i = 0; i < argc; i++) {
+			py_arg = PyList_GetItem(py_args, i);
+			if (!PyUnicode_Check(py_arg))
+				continue;
+
+			if (i == 0)
+				argv[i] = get_full_name(PyUnicode_DATA(py_arg));
+			else
+				argv[i] = strdup(PyUnicode_DATA(py_arg));
+
+			if (!argv[i]) {
+				if (i == 0)
+					PyErr_Format(TFS_ERROR,
+						     "Failed to find program with name %s",
+						     PyUnicode_DATA(py_arg));
+				goto error;
+			}
+		}
+		argv[i] = NULL;
+	}
+
+	utrace = utrace_new(pid, argv, libs);
+	if (!utrace) {
+		MEM_ERROR;
+		goto error;
+	}
+
+	py_utrace = PyUserTrace_New(utrace);
+	return py_utrace;
+
+error:
+	if (argv) {
+		for (i = 0; i < argc; i++)
+			free(argv[i]);
+		free(argv);
+	}
+	return NULL;
+}
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index e6fab69..3f9c906 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -34,6 +34,21 @@ C_OBJECT_WRAPPER_DECLARE(tracefs_synth, PySynthEvent)
 
 PyObject *PyTepRecord_time(PyTepRecord* self);
 
+struct py_utrace_context;
+void py_utrace_free(struct py_utrace_context *utrace);
+int py_utrace_destroy(struct py_utrace_context *utrace);
+C_OBJECT_WRAPPER_DECLARE(py_utrace_context, PyUserTrace);
+
+PyObject *PyUserTrace_add_function(PyUserTrace *self, PyObject *args,
+				   PyObject *kwargs);
+
+PyObject *PyUserTrace_add_ret_function(PyUserTrace *self, PyObject *args,
+				       PyObject *kwargs);
+
+PyObject *PyUserTrace_enable(PyUserTrace *self, PyObject *args, PyObject *kwargs);
+
+PyObject *PyUserTrace_disable(PyUserTrace *self, PyObject *args, PyObject *kwargs);
+
 PyObject *PyTepRecord_cpu(PyTepRecord* self);
 
 PyObject *PyTepEvent_name(PyTepEvent* self);
@@ -270,6 +285,8 @@ PyObject *PyFtrace_synth(PyObject *self, PyObject *args,
 PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
 						       PyObject *kwargs);
 
+PyObject *PyFtrace_user_trace(PyObject *self, PyObject *args, PyObject *kwargs);
+
 PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
 						 PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 681d641..73f9245 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -315,6 +315,32 @@ C_OBJECT_WRAPPER(tracefs_synth, PySynthEvent,
 		 tracefs_synth_destroy,
 		 tracefs_synth_free)
 
+static PyMethodDef PyUserTrace_methods[] = {
+	{"add_function",
+	 (PyCFunction) PyUserTrace_add_function,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Add tracepoint on user function."
+	},
+	{"add_ret_function",
+	 (PyCFunction) PyUserTrace_add_ret_function,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Add tracepoint on user function return."
+	},
+	{"enable",
+	 (PyCFunction) PyUserTrace_enable,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Enable tracing of the configured user tracepoints."
+	},
+	{"disable",
+	 (PyCFunction) PyUserTrace_disable,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Disable tracing of the configured user tracepoints."
+	},
+	{NULL, NULL, 0, NULL}
+};
+C_OBJECT_WRAPPER(py_utrace_context, PyUserTrace,
+		 py_utrace_destroy, py_utrace_free)
+
 static PyMethodDef ftracepy_methods[] = {
 	{"dir",
 	 (PyCFunction) PyFtrace_dir,
@@ -501,6 +527,11 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Define a synthetic event."
 	},
+	{"user_trace",
+	 (PyCFunction) PyFtrace_user_trace,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Create a context for tracing a user process using uprobes"
+	},
 	{"set_ftrace_loglevel",
 	 (PyCFunction) PyFtrace_set_ftrace_loglevel,
 	 METH_VARARGS | METH_KEYWORDS,
@@ -575,6 +606,9 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	if (!PySynthEventTypeInit())
 		return NULL;
 
+	if (!PyUserTraceTypeInit())
+		return NULL;
+
 	TFS_ERROR = PyErr_NewException("tracecruncher.ftracepy.tfs_error",
 				       NULL, NULL);
 
@@ -593,6 +627,7 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	PyModule_AddObject(module, "tracefs_dynevent", (PyObject *) &PyDyneventType);
 	PyModule_AddObject(module, "tracefs_hist", (PyObject *) &PyTraceHistType);
 	PyModule_AddObject(module, "tracefs_synth", (PyObject *) &PySynthEventType);
+	PyModule_AddObject(module, "py_utrace_context", (PyObject *) &PyUserTraceType);
 
 	PyModule_AddObject(module, "tfs_error", TFS_ERROR);
 	PyModule_AddObject(module, "tep_error", TEP_ERROR);
-- 
2.35.1

