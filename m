Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B59CBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 31 Mar 2022 09:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiCaJ6O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 05:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiCaJ53 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 05:57:29 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F201AFEB2
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Mar 2022 02:55:41 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id w4so32925136wrg.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Mar 2022 02:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rsMxm732veSWj8I+mXtfO5iaGvtQ42UI9SJGV1N14gA=;
        b=TvIUJGMbGApYmPm634FhitVZvoNqF+CafzsYNgwzjUcWNnEnyBFWR5U19Hm7uVY0cq
         +JjrCjI1NuH0LUhY9GOfHtCD30RVDNkzT9WExZhQWRajfqO6hc5SpgXtAbTybZLO1nTu
         nrOI4IHMaKf07Vqb94pLqLdIK3LxS+WYkdKTmGNPa4VF9vNn/S7m9cwfHC0XzVm/49vt
         +n5HaZYTC/SOQsUySMAmbhRuvtmDxOOwtrOxONF5vv/gDnRmYxdDDmcqXPFXaBCqbv6F
         CweSTLk1I+iUtw7qHwuJg9QdF1QkN2n19cNlYt3H4G9itctbLxERO5iEWjDCwPXx/wTP
         YP9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rsMxm732veSWj8I+mXtfO5iaGvtQ42UI9SJGV1N14gA=;
        b=m2rTtuaPl6LRH3lcffW6EWSMb9b8lc0EOEqxtLLEntsN8YfGmBwfauAU3h37aW9WNs
         wsRX0L5lQOQGfBkY6RXyoOJExNifsyudNNrZS1M0YxKxmK+iKymRPOgtqPm5UZ1ymv2C
         ELQcuRlIiybgFYRxs6p7OpkrubE4NpHab8TFg7V3kNWNn2HtGP4Vb/ZRpNd6bFgKcaT8
         EQR6uYdvz9b13znvel7koD8tW1bB/irvSY9q1q9Zk6ASZP1HAfaOZaAidSKAzqnal1yF
         hPn3zM/x89iwkrLXVd72UPIl73GQvZ5l0tUOcNULzjxoNyDUaM6vdCs4kG6GfTiQbj/I
         3ZYw==
X-Gm-Message-State: AOAM531Jo86l/wOMnTFSnGDVzdi1SfNSVyZjq0sewO18GWPxGtAETzbA
        iHmqATFVmDEnhiIslB+Dv30=
X-Google-Smtp-Source: ABdhPJwHnRvJCdzDYyoTXExUtfC9DeA5i7jq8aJcaAbBmqdALVreE1SOxhU0wu6FR3wASnYrTsq4Dw==
X-Received: by 2002:adf:eb88:0:b0:205:e113:dcb5 with SMTP id t8-20020adfeb88000000b00205e113dcb5mr3423703wrn.598.1648720539787;
        Thu, 31 Mar 2022 02:55:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm11807493wmq.27.2022.03.31.02.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 02:55:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH 3/4] trace-cruncher: High level wrappers for ftrace uprobes
Date:   Thu, 31 Mar 2022 12:55:32 +0300
Message-Id: <20220331095533.75289-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220331095533.75289-1-tz.stoyanov@gmail.com>
References: <20220331095533.75289-1-tz.stoyanov@gmail.com>
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
 src/ftracepy-utils.h |  17 ++
 src/ftracepy.c       |  35 +++
 src/utrace-utils.c   | 509 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 563 insertions(+), 2 deletions(-)
 create mode 100644 src/utrace-utils.c

diff --git a/setup.py b/setup.py
index 21c627f..acfa676 100644
--- a/setup.py
+++ b/setup.py
@@ -71,8 +71,8 @@ def extension(name, sources, libraries):
 
 def main():
     module_ft = extension(name='tracecruncher.ftracepy',
-                          sources=['src/ftracepy.c', 'src/ftracepy-utils.c'],
-                          libraries=['traceevent', 'tracefs'])
+                          sources=['src/ftracepy.c', 'src/ftracepy-utils.c', 'src/utrace-utils.c', 'src/trace-obj-debug.c'],
+                          libraries=['traceevent', 'tracefs', 'bfd'])
 
     cythonize('src/npdatawrapper.pyx', language_level = '3')
     module_data = extension(name='tracecruncher.npdatawrapper',
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index e6fab69..60d2743 100644
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
+PyObject *PyUserTrace_start(PyUserTrace *self, PyObject *args, PyObject *kwargs);
+
+PyObject *PyUserTrace_stop(PyUserTrace *self, PyObject *args, PyObject *kwargs);
+
 PyObject *PyTepRecord_cpu(PyTepRecord* self);
 
 PyObject *PyTepEvent_name(PyTepEvent* self);
@@ -270,6 +285,8 @@ PyObject *PyFtrace_synth(PyObject *self, PyObject *args,
 PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
 						       PyObject *kwargs);
 
+PyObject *PyFtrace_utrace(PyObject *self, PyObject *args, PyObject *kwargs);
+
 PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
 						 PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 681d641..107b78f 100644
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
+	{"start",
+	 (PyCFunction) PyUserTrace_start,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Add tracepoint on user function return."
+	},
+	{"stop",
+	 (PyCFunction) PyUserTrace_stop,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Add tracepoint on user function return."
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
+	 (PyCFunction) PyFtrace_utrace,
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
diff --git a/src/utrace-utils.c b/src/utrace-utils.c
new file mode 100644
index 0000000..b528407
--- /dev/null
+++ b/src/utrace-utils.c
@@ -0,0 +1,509 @@
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
+#include <stdlib.h>
+#include <unistd.h>
+
+// trace-cruncher
+#include "ftracepy-utils.h"
+#include "trace-obj-debug.h"
+
+extern PyObject *TFS_ERROR;
+extern PyObject *TRACECRUNCHER_ERROR;
+
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
+	char *fname;
+	char *usystem;
+	struct fprobes_list fretprobes;
+	struct fprobes_list ufuncs;
+	struct fprobes_list uevents;
+	struct trace_debug_object *dbg;
+};
+
+#define EXPAND_CHUNK	10
+static int utrace_list_add(struct fprobes_list *list, void *data)
+{
+	void **tmp;
+
+	if (list->size <= list->count) {
+		tmp = realloc(list->data, (list->size + EXPAND_CHUNK) * sizeof(void *));
+		if (!tmp)
+			return -1;
+		list->data = tmp;
+		list->size += EXPAND_CHUNK;
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
+		trace_debug_obj_destroy(utrace->dbg);
+
+	for (i = 0; i < utrace->ufuncs.count; i++) {
+		f = utrace->ufuncs.data[i];
+		free(f->func_name);
+		free(f);
+	}
+	free(utrace->ufuncs.data);
+
+	for (i = 0; i < utrace->uevents.count; i++)
+		tracefs_dynevent_free(utrace->uevents.data[i]);
+	free(utrace->uevents.data);
+
+	free(utrace->fname);
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
+		if (!isalpha(fname[i]) && !isdigit(fname[i]) && fname[i] != '_')
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
+static struct py_utrace_context *utrace_new(pid_t pid, char *fname, bool libs)
+{
+	struct py_utrace_context *utrace;
+	char *file;
+
+	utrace = calloc(1, sizeof(*utrace));
+	if (!utrace)
+		return NULL;
+
+	if (fname) {
+
+		utrace->dbg = trace_debug_obj_create_file(fname, libs);
+		if (!utrace->dbg)
+			goto error;
+		utrace->fname = strdup(fname);
+		if (!utrace->fname)
+			goto error;
+		file = strrchr(fname, '/');
+		if (file)
+			file++;
+		if (!file || *file == '\0')
+			file = fname;
+		if (asprintf(&utrace->usystem, "%s_%s", UPROBES_SYSTEM, file) <= 0)
+			goto error;
+	} else {
+		utrace->pid = pid;
+		utrace->dbg = trace_debug_obj_create_pid(pid, libs);
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
+		if (!strcmp(p->func_name, func))
+			break;
+	}
+
+	if (i < utrace->ufuncs.count) {
+		p->type |= type;
+		return 0;
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
+	if (trace_debug_add_resolve_symbol(utrace->dbg, 0, func, ret))
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
+ * max event name is 64 bytes, hard coded in the kernel.
+ * it can consists only of alphabetic characters, digits or underscores
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
+ * file name and function offset within the file
+ */
+static int utrace_event_create(struct py_utrace_context *utrace,
+			       struct tracecmd_debug_symbols *sym, char *fecthargs,
+			       int type)
+{
+	struct tracefs_dynevent *uevent = NULL;
+	char *rname;
+
+	/* Generate uprobe event name, according to ftrace name requirements */
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
+/* callback, called on each resolved function */
+static int symblos_walk(struct tracecmd_debug_symbols *sym, void *context)
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
+	/* Find the exact name and file offset of each user function that should be traced */
+	trace_debug_resolve_symbols(utrace->dbg);
+	trace_debug_walk_resolved_symbols(utrace->dbg, symblos_walk, utrace);
+}
+
+static int py_utrace_set_filter(struct py_utrace_context *utrace, struct tracefs_instance *instance)
+{
+	char pids[BUFSIZ];
+	int ret;
+
+	snprintf(pids, BUFSIZ, "%d", utrace->pid);
+	ret = tracefs_instance_file_write(instance, "set_event_pid", pids);
+	if (ret < 0)
+		return -1;
+
+	/* Trace all forks also */
+	ret = tracefs_option_enable(instance, TRACEFS_OPTION_EVENT_FORK);
+	if (ret)
+		return -1;
+
+	return 0;
+}
+
+static int start_trace(struct py_utrace_context *utrace, struct tracefs_instance *instance)
+{
+	/* Filter the trace only on desired pid(s) */
+	if (py_utrace_set_filter(utrace, instance)) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Failed to set trace filter");
+		return -1;
+	}
+
+	/* Enable uprobes in the system */
+	if (tracefs_event_enable(instance, utrace->usystem, NULL)) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Failed to enable trace events");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int utrace_exec_cmd(struct py_utrace_context *utrace, struct tracefs_instance *instance)
+{
+	pid_t pid;
+
+	pid = fork();
+	if (pid < 0) {
+		PyErr_SetString(TRACECRUNCHER_ERROR, "Failed to fork");
+		return -1;
+	}
+
+	if (pid == 0) {
+		char *argv[] = {getenv("SHELL"), "-c", utrace->fname, NULL};
+		char *envp[] = {NULL};
+
+		utrace->pid = getpid();
+		start_trace(utrace, instance);
+		if (execvpe(argv[0], argv, envp) < 0)
+			PyErr_SetString(TRACECRUNCHER_ERROR, "Failed to exec command");
+	}
+
+	return pid;
+}
+
+static int py_utrace_start(struct py_utrace_context *utrace, struct tracefs_instance *instance)
+{
+	/* If uprobes on desired user functions are not yet generated, do it now */
+	if (!utrace->uevents.count)
+		py_utrace_generate_uprobes(utrace);
+
+	/* No functions are found in the given program / pid */
+	if (!utrace->uevents.count) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Cannot find requested user functions");
+		return -1;
+	}
+
+	if (utrace->fname)
+		utrace_exec_cmd(utrace, instance);
+	else
+		start_trace(utrace, instance);
+
+	return 0;
+}
+
+static int py_utrace_stop(struct py_utrace_context *utrace, struct tracefs_instance *instance)
+{
+	/* Disable uprobes in the system */
+	if (tracefs_event_disable(instance, utrace->usystem, NULL)) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Failed to disable trace events");
+		return -1;
+	}
+
+	return 0;
+}
+
+static PyObject *PyUserTrace_trigger(PyUserTrace *self, PyObject *args, PyObject *kwargs, bool start)
+{
+	struct py_utrace_context *utrace = self->ptrObj;
+	static char *kwlist[] = {"instance", NULL};
+	struct tracefs_instance *instance = NULL;
+	PyObject *py_inst = NULL;
+	int ret;
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
+	if (py_inst) {
+		if (!PyTfsInstance_Check(py_inst)) {
+			PyErr_SetString(TRACECRUNCHER_ERROR,
+					"Input argument \'instance\' is from incompatible type.");
+			return NULL;
+		}
+		instance = ((PyTfsInstance *)py_inst)->ptrObj;
+	}
+
+	if (start)
+		ret = py_utrace_start(utrace, instance);
+	else
+		ret = py_utrace_stop(utrace, instance);
+
+	if (ret)
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyUserTrace_start(PyUserTrace *self, PyObject *args, PyObject *kwargs)
+{
+	return PyUserTrace_trigger(self, args, kwargs, true);
+}
+
+PyObject *PyUserTrace_stop(PyUserTrace *self, PyObject *args, PyObject *kwargs)
+{
+	return PyUserTrace_trigger(self, args, kwargs, false);
+}
+
+PyObject *PyFtrace_utrace(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	static char *kwlist[] = {"pid", "name", "follow_libs", NULL};
+	struct py_utrace_context *utrace;
+	long long pid = -1;
+	char *comm = NULL;
+	int libs = 0;
+	PyObject *py_utrace;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "|Ksp",
+					 kwlist,
+					 &pid,
+					 &comm,
+					 &libs)) {
+		return NULL;
+	}
+
+	if (pid == -1 && !comm) {
+		PyErr_Format(TFS_ERROR,
+			     "Process ID or program name should be specified");
+		return NULL;
+	}
+
+	utrace = utrace_new(pid, comm, libs);
+	if (!utrace) {
+		MEM_ERROR;
+		return NULL;
+	}
+	py_utrace = PyUserTrace_New(utrace);
+
+	return py_utrace;
+}
-- 
2.35.1

