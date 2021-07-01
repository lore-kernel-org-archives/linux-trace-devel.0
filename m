Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6BDC11F67
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FEC26140B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbhGALRE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 07:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbhGALRE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 07:17:04 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8FCC0617A8
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jul 2021 04:14:33 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l8so7649054wry.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Jul 2021 04:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=COkNS+uMLMdgPmbQr0vTvtLNRPn2aB0H/ghF/5B5Vw8=;
        b=QXxpfm4cUDOd2BbCIac//giznt+Qvi3RRJGq/yIny+L5Uo101LFO884gJ9ajG4skFs
         EdGn6SC2iJKYsARR5nGwnpOLckwDGnMuZGxuJh5inRI4tW5EAXseDTagK+MNWBDHkfSn
         DRz42EDs1W275szFTJmYbFucA5PmTkMmW754RugqS5mxhTseENADQ5RUZyBhgRukb7k7
         8G5TLplbXbs317EtdJhpp1qTd00oq6sNiBUAG6ZDFLIjNNHZJDdE3xURa2XjMRDn/sWE
         XAPIWgo4N+V5yaaqZbtZaFZumaks3Meii7mRxCTHGjk5rS2BCkbJVaoe1pQ0tmhWb3e+
         7E1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=COkNS+uMLMdgPmbQr0vTvtLNRPn2aB0H/ghF/5B5Vw8=;
        b=gwU/4pESdN+HuPwhcokhOwuz5oJzztBcZva3HJjQfZYC5Wczv16IVM8cFlqEh/vsiL
         MI73VR6P6vFFp5Fhe+q+QsclFvxKKq2cRCofLyEV7AnVP7QIpAN7jgt0mvu3CgWUUWtr
         +ZuLGwpLgxz+mgMSWjBzSiLM/nS1d7SvIiooOtTFIab5KvqGiCaQ9G9nxa5P2XeTG/NI
         scHWBF0ZhbXmfQP5mndmhLaGOAcj4MUkPa4D7ZeUa/fsT4pxDOzp9dxoAEUtitzeyW81
         U3m53/iihKMS7yKTueMsILb6k9391dmHCnKYPGwhdy8whrF0/FRjDkPAtwDucEqmYANL
         WRPw==
X-Gm-Message-State: AOAM533E1ai8e1aOIUyEdM7ZUP3x1CceF0JBkcK0OjgUZvo3rrGrBxZq
        GdutrMVz2daqvVxOBnQjECqnwjZ+lTI=
X-Google-Smtp-Source: ABdhPJx0GuMedN5/OBD3U0xKw6qSf5shUqyi78H4++rirqQJJXDnB9tYNazHA6r5HxmqskzzV8AxRA==
X-Received: by 2002:a5d:51ce:: with SMTP id n14mr28320373wrv.209.1625138072301;
        Thu, 01 Jul 2021 04:14:32 -0700 (PDT)
Received: from bucy.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id o17sm9223009wmh.19.2021.07.01.04.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 04:14:32 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, warthog9@eaglescrag.net,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 02/11] trace-cruncher: Add basic methods for tracing
Date:   Thu,  1 Jul 2021 14:14:09 +0300
Message-Id: <20210701111418.18386-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210701111418.18386-1-y.karadz@gmail.com>
References: <20210701111418.18386-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Here we define a set of basic methods for starting the tracing process
accessing the trace data.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 323 +++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  12 ++
 src/ftracepy.c       |  20 +++
 3 files changed, 355 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 865ac27..7537a6f 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1493,6 +1493,329 @@ static bool hook2pid(struct tracefs_instance *instance, PyObject *pid_val, int f
 	return false;
 }
 
+static void start_tracing_procces(struct tracefs_instance *instance,
+				  char *const *argv,
+				  char *const *envp)
+{
+	PyObject *pid_val = PyList_New(1);
+
+	PyList_SET_ITEM(pid_val, 0, PyLong_FromLong(getpid()));
+	if(!hook2pid(instance, pid_val, true))
+		exit(1);
+
+	tracing_ON(instance);
+	if (execvpe(argv[0], argv, envp) < 0) {
+		PyErr_Format(TFS_ERROR, "Failed to exec \'%s\'",
+			     argv[0]);
+	}
+
+	exit(1);
+}
+
+static PyObject *get_callback_func(const char *plugin_name, const char * py_callback)
+{
+	PyObject *py_name, *py_module, *py_func;
+
+	py_name = PyUnicode_FromString(plugin_name);
+	py_module = PyImport_Import(py_name);
+	if (!py_module) {
+		PyErr_Format(TFS_ERROR, "Failed to import plugin \'%s\'",
+			     plugin_name);
+		return NULL;
+	}
+
+	py_func = PyObject_GetAttrString(py_module, py_callback);
+	if (!py_func || !PyCallable_Check(py_func)) {
+		PyErr_Format(TFS_ERROR,
+			     "Failed to import callback from plugin \'%s\'",
+			     plugin_name);
+		return NULL;
+	}
+
+	return py_func;
+}
+
+struct callback_context {
+	void	*py_callback;
+
+	bool	status;
+} callback_ctx;
+
+bool keep_going = true;
+
+static void finish(int sig)
+{
+	keep_going = false;
+}
+
+static int callback(struct tep_event *event, struct tep_record *record,
+		    int cpu, void *ctx_ptr)
+{
+	struct callback_context *ctx = ctx_ptr;
+	PyObject *ret;
+
+	record->cpu = cpu; // Remove when the bug in libtracefs is fixed.
+
+	PyObject *py_tep_event = PyTepEvent_New(event);
+	PyObject *py_tep_record = PyTepRecord_New(record);
+
+	PyObject *arglist = PyTuple_New(2);
+	PyTuple_SetItem(arglist, 0, py_tep_event);
+	PyTuple_SetItem(arglist, 1, py_tep_record);
+
+	ret = PyObject_CallObject((PyObject *)ctx->py_callback, arglist);
+	Py_DECREF(arglist);
+
+	if (ret) {
+		Py_DECREF(ret);
+	} else {
+		if (PyErr_Occurred()) {
+			if(PyErr_ExceptionMatches(PyExc_SystemExit)) {
+				PyErr_Clear();
+			} else {
+				PyErr_Print();
+			}
+		}
+
+		ctx->status = false;
+	}
+
+	return 0;
+}
+
+static bool notrace_this_pid(struct tracefs_instance *instance)
+{
+	int pid = getpid();
+
+	if(!pid2file(instance, "set_ftrace_notrace_pid", pid, true) ||
+	   !pid2file(instance, "set_event_notrace_pid", pid, true)) {
+		PyErr_SetString(TFS_ERROR,
+			        "Failed to desable tracing for \'this\' process.");
+		return false;
+	}
+
+	return true;
+}
+
+static void iterate_raw_events_waitpid(struct tracefs_instance *instance,
+				       struct tep_handle *tep,
+				       PyObject *py_func,
+				       pid_t pid)
+{
+	callback_ctx.py_callback = py_func;
+	callback_ctx.status = true;
+	do {
+		tracefs_iterate_raw_events(tep, instance, NULL, 0,
+					   callback, &callback_ctx);
+	} while (waitpid(pid, NULL, WNOHANG) != pid);
+}
+
+static bool init_callback_tep(struct tracefs_instance *instance,
+			      const char *plugin,
+			      const char *py_callback,
+			      struct tep_handle **tep,
+			      PyObject **py_func)
+{
+	if (!notrace_this_pid(instance))
+		return false;
+
+	*py_func = get_callback_func(plugin, py_callback);
+	if (!*py_func)
+		return false;
+
+	*tep = tracefs_local_events(tracefs_instance_get_dir(instance));
+	if (!*tep) {
+		PyErr_Format(TFS_ERROR,
+			     "Unable to get 'tep'event from instance \'%s\'.",
+			     get_instance_name(instance));
+		return false;
+	}
+
+	return true;
+}
+
+PyObject *PyFtrace_trace_shell_process(PyObject *self, PyObject *args,
+						       PyObject *kwargs)
+{
+	const char *plugin = "__main__", *py_callback = "callback", *instance_name;
+	static char *kwlist[] = {"process", "plugin", "callback", "instance", NULL};
+	struct tracefs_instance *instance;
+	struct tep_handle *tep;
+	PyObject *py_func;
+	char *process;
+	pid_t pid;
+
+	instance_name = NO_ARG;
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"s|sss",
+					kwlist,
+					&process,
+					&plugin,
+					&py_callback,
+					&instance_name)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	if (!init_callback_tep(instance, plugin, py_callback, &tep, &py_func))
+		return NULL;
+
+	pid = fork();
+	if (pid < 0) {
+		PyErr_SetString(TFS_ERROR, "Failed to fork");
+		return NULL;
+	}
+
+	if (pid == 0) {
+		char *argv[] = {getenv("SHELL"), "-c", process, NULL};
+		char *envp[] = {NULL};
+
+		start_tracing_procces(instance, argv, envp);
+	}
+
+	iterate_raw_events_waitpid(instance, tep, py_func, pid);
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
+						       PyObject *kwargs)
+{
+	const char *plugin = "__main__", *py_callback = "callback", *instance_name;
+	static char *kwlist[] = {"argv", "plugin", "callback", "instance", NULL};
+	struct tracefs_instance *instance;
+	struct tep_handle *tep;
+	PyObject *py_func, *py_argv, *py_arg;
+	pid_t pid;
+	int i, argc;
+
+	instance_name = NO_ARG;
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"O|sss",
+					kwlist,
+					&py_argv,
+					&plugin,
+					&py_callback,
+					&instance_name)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	if (!init_callback_tep(instance, plugin, py_callback, &tep, &py_func))
+		return NULL;
+
+	if (!PyList_CheckExact(py_argv)) {
+		PyErr_SetString(TFS_ERROR, "Failed to parse \'argv\' list");
+		return NULL;
+	}
+
+	argc = PyList_Size(py_argv);
+
+	pid = fork();
+	if (pid < 0) {
+		PyErr_SetString(TFS_ERROR, "Failed to fork");
+		return NULL;
+	}
+
+	if (pid == 0) {
+		char *argv[argc + 1];
+		char *envp[] = {NULL};
+
+		for (i = 0; i < argc; ++i) {
+			py_arg = PyList_GetItem(py_argv, i);
+			if (!PyUnicode_Check(py_arg))
+				return NULL;
+
+			argv[i] = PyUnicode_DATA(py_arg);
+		}
+		argv[argc] = NULL;
+		start_tracing_procces(instance, argv, envp);
+	}
+
+	iterate_raw_events_waitpid(instance, tep, py_func, pid);
+
+	Py_RETURN_NONE;
+}
+
+static struct tracefs_instance *read_instance;
+
+static void pipe_stop(int sig)
+{
+	signal(SIGINT, SIG_DFL);
+	tracefs_trace_pipe_stop(read_instance);
+}
+
+PyObject *PyFtrace_read_trace(PyObject *self, PyObject *args,
+					      PyObject *kwargs)
+{
+	if (!get_instance_from_arg(args, kwargs, &read_instance))
+		return NULL;
+
+	signal(SIGINT, pipe_stop);
+	if (tracefs_trace_pipe_print(read_instance, 0) < 0) {
+		PyErr_Format(TFS_ERROR,
+			     "Unable to read trace data from instance \'%s\'.",
+			     get_instance_name(read_instance));
+		signal(SIGINT, SIG_DFL);
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_iterate_trace(PyObject *self, PyObject *args,
+					         PyObject *kwargs)
+{
+	static char *kwlist[] = {"plugin", "callback", "instance", NULL};
+	const char *plugin = "__main__", *py_callback = "callback";
+	struct tracefs_instance *instance;
+	const char *instance_name;
+	struct tep_handle *tep;
+	PyObject *py_func;
+	int ret = 0;
+
+	instance_name = NO_ARG;
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"|sss",
+					kwlist,
+					&plugin,
+					&py_callback,
+					&instance_name)) {
+		return NULL;
+	}
+
+	py_func = get_callback_func(plugin, py_callback);
+	if (!py_func)
+		return NULL;
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	if (!notrace_this_pid(instance))
+		return NULL;
+
+	tep = tracefs_local_events(tracefs_instance_get_dir(instance));
+
+	signal(SIGINT, finish);
+	tracing_ON(instance);
+	callback_ctx.py_callback = py_func;
+	callback_ctx.status = true;
+	keep_going = true;
+
+	while(ret == 0 && callback_ctx.status && keep_going)
+		ret = tracefs_iterate_raw_events(tep, instance, NULL, 0,
+						 callback, &callback_ctx);
+
+	Py_RETURN_NONE;
+}
+
 PyObject *PyFtrace_hook2pid(PyObject *self, PyObject *args, PyObject *kwargs)
 {
 	static char *kwlist[] = {"pid", "fork", "instance", NULL};
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 44fceab..3699aaa 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -125,6 +125,18 @@ PyObject *PyFtrace_supported_options(PyObject *self, PyObject *args,
 PyObject *PyFtrace_enabled_options(PyObject *self, PyObject *args,
 						   PyObject *kwargs);
 
+PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
+						 PyObject *kwargs);
+
+PyObject *PyFtrace_trace_shell_process(PyObject *self, PyObject *args,
+						       PyObject *kwargs);
+
+PyObject *PyFtrace_read_trace(PyObject *self, PyObject *args,
+					      PyObject *kwargs);
+
+PyObject *PyFtrace_iterate_trace(PyObject *self, PyObject *args,
+						 PyObject *kwargs);
+
 PyObject *PyFtrace_hook2pid(PyObject *self, PyObject *args, PyObject *kwargs);
 
 void PyFtrace_at_exit(void);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 2cdcc33..5dd61e4 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -214,6 +214,26 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Gat a list of all supported options."
 	},
+	{"trace_process",
+	 (PyCFunction) PyFtrace_trace_process,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Trace a process."
+	},
+	{"trace_shell_process",
+	 (PyCFunction) PyFtrace_trace_shell_process,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Trace a process executed within a shell."
+	},
+	{"read_trace",
+	 (PyCFunction) PyFtrace_read_trace,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Trace a shell process."
+	},
+	{"iterate_trace",
+	 (PyCFunction) PyFtrace_iterate_trace,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Trace a shell process."
+	},
 	{"hook2pid",
 	 (PyCFunction) PyFtrace_hook2pid,
 	 METH_VARARGS | METH_KEYWORDS,
-- 
2.27.0

