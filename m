Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 941F8C07E95
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77DD961C6D
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhGGNYy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 09:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhGGNYx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 09:24:53 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61685C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jul 2021 06:22:12 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id he13so3212288ejc.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Jul 2021 06:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yAOJEOGSgZGJrEmvR5zyladkX1kaN4RdEZ1mQ+YFzA0=;
        b=TLBhrjRSlPN0gGN6x07Xn8R0JqucFxC3qEWs4O/bC/91gASSVh9CP3gl4qmzTaSAIF
         XYGj5FjIrzLXkUTwfJKj1EmUtts2vN59TEJ19BB5n2Q14x6bVjkgzQyywuLD5YqcjKXP
         hCyV29Tee13Jo/obnoOP3/u1aBDocFYaDU9lm4qGrkYmjJqlw9bxEap9t3xoldFOGP4y
         4+BhlPcpZRlGBrjeXpJ25Q3D/ZfkmWokQhh8vTiGPKDDVSx73LvCmi3ZT/MVH5t/JTHa
         4BwnFr3VPG8M+hQHp/pVXipLJ2K+B2gIYcI5Lzu+IPuF0YJV3OuMkCE6GLMGth+r5+SD
         lwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yAOJEOGSgZGJrEmvR5zyladkX1kaN4RdEZ1mQ+YFzA0=;
        b=oxgMNK7p/B5D6SQ1b5HGq4/cFwbYB6VOI4XgM3gPeF2RR8CLDPNYoXKxtzt6FGrc2M
         kNqpN2oIawBO3Oc/6bPI1deqQFQqOdquBXFribams9TARJjCXAxHdTWRexUpsKWo8hLr
         db60euLmPOQd6vQH6d7WRJ3/aYBRIp5jwgj33ZpcgnPdqN7DdQV5Lms43FnjK9//dhoi
         3f1J+MGxBG66EXQkmGB84IgYbH83lTdWEzsCDvLZ2G7UGZ93blKfTh/cRNcGw1HFGe4D
         fxAIuF3yjYrj4HlBHBNq3N49A1ezfQwi0CWwxsxXjQn9jAng3GYOwbZSvULWDBI/MKxD
         o4ig==
X-Gm-Message-State: AOAM530h4p6TQGd6wq1eYVPUkXm2EG0AAz7hhnp0zz/q+qM9qdIzFjFD
        gucA2sOt7QCNbmyDZlhE3oqiY/3VqoQ=
X-Google-Smtp-Source: ABdhPJwm5v6MU2Gqp0Mv0gmXIP+6i8cxoaG0AEL4qrW2TAtLbtbMYdRrJZwkWqqTHYr63A9X9A6Rvg==
X-Received: by 2002:a17:906:99c4:: with SMTP id s4mr9486740ejn.380.1625664130619;
        Wed, 07 Jul 2021 06:22:10 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id eb9sm7064881ejc.32.2021.07.07.06.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 06:22:10 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 02/11] trace-cruncher: Add basic methods for tracing
Date:   Wed,  7 Jul 2021 16:21:48 +0300
Message-Id: <20210707132158.68520-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210707132158.68520-1-y.karadz@gmail.com>
References: <20210707132158.68520-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Here we define a set of basic methods for starting the tracing process
accessing the trace data.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 329 +++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  12 ++
 src/ftracepy.c       |  20 +++
 3 files changed, 361 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index b34c45b..91a319e 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1507,6 +1507,335 @@ static bool hook2pid(struct tracefs_instance *instance, PyObject *pid_val, int f
 	return false;
 }
 
+static void start_tracing_procces(struct tracefs_instance *instance,
+				  char *const *argv,
+				  char *const *envp)
+{
+	PyObject *pid_val = PyList_New(1);
+
+	PyList_SET_ITEM(pid_val, 0, PyLong_FromLong(getpid()));
+	if (!hook2pid(instance, pid_val, true))
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
+			if (PyErr_ExceptionMatches(PyExc_SystemExit)) {
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
+	if (!pid2file(instance, "set_ftrace_notrace_pid", pid, true) ||
+	    !pid2file(instance, "set_event_notrace_pid", pid, true)) {
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
+	*py_func = get_callback_func(plugin, py_callback);
+	if (!*py_func)
+		return false;
+
+	*tep = tracefs_local_events(tracefs_instance_get_dir(instance));
+	if (!*tep) {
+		PyErr_Format(TFS_ERROR,
+			     "Unable to get 'tep' event from instance \'%s\'.",
+			     get_instance_name(instance));
+		return false;
+	}
+
+	if (!notrace_this_pid(instance))
+		return false;
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
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "s|sss",
+					 kwlist,
+					 &process,
+					 &plugin,
+					 &py_callback,
+					 &instance_name)) {
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
+						 PyObject *kwargs)
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
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "O|sss",
+					 kwlist,
+					 &py_argv,
+					 &plugin,
+					 &py_callback,
+					 &instance_name)) {
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
+static struct tracefs_instance *pipe_instance;
+
+static void pipe_stop(int sig)
+{
+	tracefs_trace_pipe_stop(pipe_instance);
+}
+
+PyObject *PyFtrace_read_trace(PyObject *self, PyObject *args,
+					      PyObject *kwargs)
+{
+	signal(SIGINT, pipe_stop);
+
+	if (!get_instance_from_arg(args, kwargs, &pipe_instance) ||
+	    !notrace_this_pid(pipe_instance))
+		return NULL;
+
+	tracing_ON(pipe_instance);
+	if (tracefs_trace_pipe_print(pipe_instance, 0) < 0) {
+		PyErr_Format(TFS_ERROR,
+			     "Unable to read trace data from instance \'%s\'.",
+			     get_instance_name(pipe_instance));
+		return NULL;
+	}
+
+	signal(SIGINT, SIG_DFL);
+	Py_RETURN_NONE;
+}
+
+struct tracefs_instance *itr_instance;
+static bool iterate_keep_going;
+
+static void iterate_stop(int sig)
+{
+	iterate_keep_going = false;
+	tracefs_trace_pipe_stop(itr_instance);
+}
+
+PyObject *PyFtrace_iterate_trace(PyObject *self, PyObject *args,
+					         PyObject *kwargs)
+{
+	static char *kwlist[] = {"plugin", "callback", "instance", NULL};
+	const char *plugin = "__main__", *py_callback = "callback";
+	bool *callback_status = &callback_ctx.status;
+	bool *keep_going = &iterate_keep_going;
+
+	const char *instance_name;
+	struct tep_handle *tep;
+	PyObject *py_func;
+	int ret;
+
+	(*(volatile bool *)keep_going) = true;
+	signal(SIGINT, iterate_stop);
+
+	instance_name = NO_ARG;
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "|sss",
+					 kwlist,
+					 &plugin,
+					 &py_callback,
+					 &instance_name)) {
+		return NULL;
+	}
+
+	py_func = get_callback_func(plugin, py_callback);
+	if (!py_func ||
+	    !get_optional_instance(instance_name, &itr_instance) ||
+	    !notrace_this_pid(itr_instance))
+		return NULL;
+
+	tep = tracefs_local_events(tracefs_instance_get_dir(itr_instance));
+	(*(volatile bool *)callback_status) = true;
+	callback_ctx.py_callback = py_func;
+	tracing_ON(itr_instance);
+
+	while (*(volatile bool *)keep_going) {
+		ret = tracefs_iterate_raw_events(tep, itr_instance, NULL, 0,
+						 callback, &callback_ctx);
+
+		if (*(volatile bool *)callback_status == false || ret < 0)
+			break;
+	}
+
+	signal(SIGINT, SIG_DFL);
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

