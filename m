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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 009FEC4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Aug 2021 09:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA45610F8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Aug 2021 09:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbhHYJYc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 05:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239525AbhHYJYb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 05:24:31 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0ACC0617AE
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Aug 2021 02:23:41 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d26so15008746wrc.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Aug 2021 02:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HqLTsN6OHrWDUH75sQ09xb0pG2VxgsvmRLY4Uz0MwhQ=;
        b=HI13yudUqwZNd9uLUQQnz4a4lP2dAxmumNvpX2xn+La6qMz/mX6n1Mq+YIdyrN3eth
         6GXvha2NjnnMjM1ElBTuCXmPsakj+UGY34iaHN432DHoaAzF7zLvSlXrJz/rRHQc64zJ
         ES9g36827vVuHFZhmFAx5yK4n3fZTe6gaJx6vGxg8ORl4wqfs98GQveWqij70o4nUm+q
         FkE22WlZEf6ephW5rpyyTXh6b48as0/5d9DcMgMH0/IuBfNZbPQd6Uq0Njk5aYkDJGV4
         U+ufUpc8Tz+W3O+u8jGyl6VVIXFqF+QxVzpQmj637i8dW+NVjBHw4xG2aGYWtqak9d0v
         U5ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HqLTsN6OHrWDUH75sQ09xb0pG2VxgsvmRLY4Uz0MwhQ=;
        b=PVjgdDUwPD2YwA7e9MYQSKyNiTbBJ5p4JAxY8WwzbJTPYwsYL3k8DmObEYyfh0FtGA
         bEBqA+ED7pZPt3iSprTFUimGH6e+yOLiUHEHtU+DUS8HtQvLpRup7izWjV2nB8+QIK5D
         AdM3UFvhbmEMlVGbyFpAtjxcaC2hg2qLRzgW5wLYJ7watnBXhZV4k5dz+i3HqgIjKn4x
         uflwWVxrJhXyENUDN8rs2BYY65ySjhLwgvaM2YoPBtzT1rMo/qsY6xq8pOvZPD+rWI2J
         BBTLvVMkMHrLdXuhTpUjXXyqqhM+Gj8M6jMvgdUXIcuqnEQ72QHJCmqBMAy4Qe3aUGum
         cL8A==
X-Gm-Message-State: AOAM532eyQAHyc8SKtFXsDWip8keyei5HQ3n+U/1bKz4B+Bw+tGXXoTT
        iE2VyRDY+e0AgRi12fdX+g9KPHjL7Uo=
X-Google-Smtp-Source: ABdhPJwk/2jXnztzNFa/+uOy81ROPaGXfRpmjPo/ZzM3E3iTCS9QH/ZoBAwGX1/zWcI3acFnk+mHOQ==
X-Received: by 2002:adf:f403:: with SMTP id g3mr12544413wro.206.1629883420131;
        Wed, 25 Aug 2021 02:23:40 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id w9sm4599323wmc.19.2021.08.25.02.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 02:23:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/3] trace-cruncher: Print the tracefs log on an error
Date:   Wed, 25 Aug 2021 12:23:26 +0300
Message-Id: <20210825092326.45804-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825092326.45804-1-y.karadz@gmail.com>
References: <20210825092326.45804-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Every time when an error is related to the usage of 'libtracefs' we check
the tracefs error log and if it contains a message, this message is added
to the stack of the Python error messages.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 114 ++++++++++++++++++++++++++++---------------
 1 file changed, 76 insertions(+), 38 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 88b069c..8e0ca42 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -55,6 +55,45 @@ static bool tfs_clear_error_log(struct tracefs_instance *instance)
 	return true;
 }
 
+static void TfsError_fmt(struct tracefs_instance *instance,
+			 const char *fmt, ...)
+{
+	char *tfs_err_log = tfs_error_log(instance, NULL);
+	va_list args;
+
+	va_start(args, fmt);
+	if (tfs_err_log) {
+		char *tc_err_log;
+
+		vasprintf(&tc_err_log, fmt, args);
+		va_end(args);
+
+		PyErr_Format(TEP_ERROR, "%s\ntfs_error: %s",
+			     tc_err_log, tfs_err_log);
+
+		tfs_clear_error_log(instance);
+		free(tfs_err_log);
+		free(tc_err_log);
+	} else {
+		PyErr_FormatV(TEP_ERROR, fmt, args);
+		va_end(args);
+	}
+}
+
+static void TfsError_setstr(struct tracefs_instance *instance,
+			    const char *msg)
+{
+	char *tfs_err_log = tfs_error_log(instance, NULL);
+
+	if (tfs_err_log) {
+		PyErr_Format(TEP_ERROR, "%s\ntfs_error: %s", msg, tfs_err_log);
+		tfs_clear_error_log(instance);
+		free(tfs_err_log);
+	} else {
+		PyErr_SetString(TEP_ERROR, msg);
+	}
+}
+
 PyObject *PyTepRecord_time(PyTepRecord* self)
 {
 	unsigned long ts = self->ptrObj ? self->ptrObj->ts : 0;
@@ -284,7 +323,7 @@ PyObject *PyTep_init_local(PyTep *self, PyObject *args,
 		const char **sys_names = get_arg_list(system_list);
 
 		if (!sys_names) {
-			PyErr_SetString(TFS_ERROR,
+			TfsError_setstr(NULL,
 					"Inconsistent \"systems\" argument.");
 			return NULL;
 		}
@@ -296,8 +335,7 @@ PyObject *PyTep_init_local(PyTep *self, PyObject *args,
 	}
 
 	if (!tep) {
-		PyErr_Format(TFS_ERROR,
-			     "Failed to get local events from \'%s\'.",
+		TfsError_fmt(NULL, "Failed to get local events from \'%s\'.",
 			     dir_str);
 		return NULL;
 	}
@@ -332,7 +370,7 @@ PyObject *PyTep_get_event(PyTep *self, PyObject *args,
 static bool check_file(struct tracefs_instance *instance, const char *file)
 {
 	if (!tracefs_file_exists(instance, file)) {
-		PyErr_Format(TFS_ERROR, "File %s does not exist.", file);
+		TfsError_fmt(instance, "File %s does not exist.", file);
 		return false;
 	}
 
@@ -342,7 +380,7 @@ static bool check_file(struct tracefs_instance *instance, const char *file)
 static bool check_dir(struct tracefs_instance *instance, const char *dir)
 {
 	if (!tracefs_dir_exists(instance, dir)) {
-		PyErr_Format(TFS_ERROR, "Directory %s does not exist.", dir);
+		TfsError_fmt(instance, "Directory %s does not exist.", dir);
 		return false;
 	}
 
@@ -367,7 +405,7 @@ static int write_to_file(struct tracefs_instance *instance,
 
 	size = tracefs_instance_file_write(instance, file, val);
 	if (size <= 0) {
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Can not write \'%s\' to file \'%s\' (inst: \'%s\').",
 			     val, file, get_instance_name(instance));
 		PyErr_Print();
@@ -387,7 +425,7 @@ static int append_to_file(struct tracefs_instance *instance,
 
 	size = tracefs_instance_file_append(instance, file, val);
 	if (size <= 0) {
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Can not append \'%s\' to file \'%s\' (inst: \'%s\').",
 			     val, file, get_instance_name(instance));
 		PyErr_Print();
@@ -407,7 +445,7 @@ static int read_from_file(struct tracefs_instance *instance,
 
 	*val = tracefs_instance_file_read(instance, file, &size);
 	if (size < 0)
-		PyErr_Format(TFS_ERROR, "Can not read from file %s", file);
+		TfsError_fmt(instance, "Can not read from file %s", file);
 
 	return size;
 }
@@ -530,7 +568,7 @@ PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
 	if (!instance ||
 	    !tracefs_instance_exists(name) ||
 	    !tracefs_instance_is_new(instance)) {
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Failed to create new trace instance \'%s\'.",
 			     name);
 		return NULL;
@@ -634,7 +672,7 @@ PyObject *PyFtrace_set_current_tracer(PyObject *self, PyObject *args,
 		}
 
 		if (!all_tracers || !all_tracers[i]) {
-			PyErr_Format(TFS_ERROR,
+			TfsError_fmt(instance,
 				     "Tracer \'%s\' is not available.",
 				     tracer);
 			return NULL;
@@ -644,7 +682,7 @@ PyObject *PyFtrace_set_current_tracer(PyObject *self, PyObject *args,
 	}
 
 	if (!write_to_file_and_check(instance, file, tracer)) {
-		PyErr_Format(TFS_ERROR, "Failed to enable tracer \'%s\'",
+		TfsError_fmt(instance, "Failed to enable tracer \'%s\'",
 			     tracer);
 		return NULL;
 	}
@@ -763,7 +801,7 @@ bool get_event_enable_file(struct tracefs_instance *instance,
  fail:
 	instance_name =
 		instance ? tracefs_instance_get_name(instance) : "top";
-	PyErr_Format(TFS_ERROR,
+	TfsError_fmt(instance,
 		     "Failed to locate event:\n Instance: %s  System: %s  Event: %s",
 		     instance_name, system, event);
 	free(buff);
@@ -789,7 +827,7 @@ static bool event_enable_disable(struct tracefs_instance *instance,
 		ret = tracefs_event_disable(instance, system, event);
 
 	if (ret != 0) {
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Failed to enable/disable event:\n System: %s  Event: %s",
 			     system ? system : "NULL",
 			     event ? event : "NULL");
@@ -879,7 +917,7 @@ static bool set_enable_events(PyObject *self, PyObject *args, PyObject *kwargs,
 		    is_all(PyUnicode_DATA(event_list))) {
 			return event_enable_disable(instance, NULL, NULL, enable);
 		} else {
-			PyErr_SetString(TFS_ERROR,
+			TfsError_setstr(instance,
 					"Failed to enable events for unspecified system");
 			return false;
 		}
@@ -887,7 +925,7 @@ static bool set_enable_events(PyObject *self, PyObject *args, PyObject *kwargs,
 
 	systems = get_arg_list(system_list);
 	if (!systems) {
-		PyErr_SetString(TFS_ERROR, "Inconsistent \"systems\" argument.");
+		TfsError_setstr(instance, "Inconsistent \"systems\" argument.");
 		return false;
 	}
 
@@ -927,7 +965,7 @@ static bool set_enable_events(PyObject *self, PyObject *args, PyObject *kwargs,
 	return true;
 
  fail_with_err:
-	PyErr_SetString(TFS_ERROR, "Inconsistent \"events\" argument.");
+	TfsError_setstr(instance, "Inconsistent \"events\" argument.");
 
  fail:
 	free(systems);
@@ -1026,7 +1064,7 @@ PyObject *PyFtrace_set_event_filter(PyObject *self, PyObject *args,
 
 	sprintf(path, "events/%s/%s/filter", system, event);
 	if (!write_to_file_and_check(instance, path, filter)) {
-		PyErr_SetString(TFS_ERROR, "Failed to set event filter");
+		TfsError_setstr(instance, "Failed to set event filter");
 		return NULL;
 	}
 
@@ -1057,7 +1095,7 @@ PyObject *PyFtrace_clear_event_filter(PyObject *self, PyObject *args,
 
 	sprintf(path, "events/%s/%s/filter", system, event);
 	if (!write_to_file(instance, path, OFF)) {
-		PyErr_SetString(TFS_ERROR, "Failed to clear event filter");
+		TfsError_setstr(instance, "Failed to clear event filter");
 		return NULL;
 	}
 
@@ -1073,7 +1111,7 @@ static bool tracing_ON(struct tracefs_instance *instance)
 		const char *instance_name =
 			instance ? tracefs_instance_get_name(instance) : "top";
 
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Failed to start tracing (Instance: %s)",
 			     instance_name);
 		return false;
@@ -1105,7 +1143,7 @@ static bool tracing_OFF(struct tracefs_instance *instance)
 		const char *instance_name =
 			instance ? tracefs_instance_get_name(instance) : "top";
 
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Failed to stop tracing (Instance: %s)",
 			     instance_name);
 		return false;
@@ -1142,7 +1180,7 @@ PyObject *PyFtrace_is_tracing_ON(PyObject *self, PyObject *args,
 		const char *instance_name =
 			instance ? tracefs_instance_get_name(instance) : "top";
 
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Failed to check if tracing is ON (Instance: %s)",
 			     instance_name);
 		return NULL;
@@ -1203,7 +1241,7 @@ static bool set_pid(struct tracefs_instance *instance,
 	return true;
 
  fail:
-	PyErr_Format(TFS_ERROR, "Failed to set PIDs for \"%s\"",
+	TfsError_fmt(instance, "Failed to set PIDs for \"%s\"",
 		     file);
 	return false;
 }
@@ -1267,7 +1305,7 @@ static bool set_opt(struct tracefs_instance *instance,
 
 	if (sprintf(file, "options/%s", opt) <= 0 ||
 	    !write_to_file_and_check(instance, file, val)) {
-		PyErr_Format(TFS_ERROR, "Failed to set option \"%s\"", opt);
+		TfsError_fmt(instance, "Failed to set option \"%s\"", opt);
 		return false;
 	}
 
@@ -1399,7 +1437,7 @@ static bool register_kprobe(const char *event,
 			    const char *probe)
 {
 	if (tracefs_kprobe_raw(TC_SYS, event, function, probe) < 0) {
-		PyErr_Format(TFS_ERROR, "Failed to register kprobe \'%s\'.",
+		TfsError_fmt(NULL, "Failed to register kprobe \'%s\'.",
 			     event);
 		return false;
 	}
@@ -1412,7 +1450,7 @@ static bool register_kretprobe(const char *event,
 			       const char *probe)
 {
 	if (tracefs_kretprobe_raw(TC_SYS, event, function, probe) < 0) {
-		PyErr_Format(TFS_ERROR, "Failed to register kretprobe \'%s\'.",
+		TfsError_fmt(NULL, "Failed to register kretprobe \'%s\'.",
 			     event);
 		return false;
 	}
@@ -1423,7 +1461,7 @@ static bool register_kretprobe(const char *event,
 static bool unregister_kprobe(const char *event)
 {
 	if (tracefs_kprobe_clear_probe(TC_SYS, event, true) < 0) {
-		PyErr_Format(TFS_ERROR, "Failed to unregister kprobe \'%s\'.",
+		TfsError_fmt(NULL, "Failed to unregister kprobe \'%s\'.",
 			     event);
 		return false;
 	}
@@ -1572,7 +1610,7 @@ PyObject *PyKprobe_set_filter(PyKprobe *self, PyObject *args,
 
 	sprintf(path, "events/%s/%s/filter", TC_SYS, self->ptrObj->event);
 	if (!write_to_file_and_check(instance, path, filter)) {
-		PyErr_SetString(TFS_ERROR, "Failed to set kprobe filter.");
+		TfsError_setstr(instance, "Failed to set kprobe filter.");
 		return NULL;
 	}
 
@@ -1600,7 +1638,7 @@ PyObject *PyKprobe_clear_filter(PyKprobe *self, PyObject *args,
 
 	sprintf(path, "events/%s/%s/filter", TC_SYS, self->ptrObj->event);
 	if (!write_to_file(instance, path, OFF)) {
-		PyErr_SetString(TFS_ERROR, "Failed to clear kprobe filter.");
+		TfsError_setstr(instance, "Failed to clear kprobe filter.");
 		return NULL;
 	}
 
@@ -1724,7 +1762,7 @@ static bool hook2pid(struct tracefs_instance *instance, PyObject *pid_val, int f
 	return true;
 
  fail:
-	PyErr_SetString(TFS_ERROR, "Failed to hook to PID");
+	TfsError_setstr(instance, "Failed to hook to PID");
 	PyErr_Print();
 	return false;
 }
@@ -1741,7 +1779,7 @@ static void start_tracing_procces(struct tracefs_instance *instance,
 
 	tracing_ON(instance);
 	if (execvpe(argv[0], argv, envp) < 0) {
-		PyErr_Format(TFS_ERROR, "Failed to exec \'%s\'",
+		TfsError_fmt(instance, "Failed to exec \'%s\'",
 			     argv[0]);
 	}
 
@@ -1755,14 +1793,14 @@ static PyObject *get_callback_func(const char *plugin_name, const char * py_call
 	py_name = PyUnicode_FromString(plugin_name);
 	py_module = PyImport_Import(py_name);
 	if (!py_module) {
-		PyErr_Format(TFS_ERROR, "Failed to import plugin \'%s\'",
+		TfsError_fmt(NULL, "Failed to import plugin \'%s\'",
 			     plugin_name);
 		return NULL;
 	}
 
 	py_func = PyObject_GetAttrString(py_module, py_callback);
 	if (!py_func || !PyCallable_Check(py_func)) {
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(NULL,
 			     "Failed to import callback from plugin \'%s\'",
 			     plugin_name);
 		return NULL;
@@ -1818,7 +1856,7 @@ static bool notrace_this_pid(struct tracefs_instance *instance)
 
 	if (!pid2file(instance, "set_ftrace_notrace_pid", pid, true) ||
 	    !pid2file(instance, "set_event_notrace_pid", pid, true)) {
-		PyErr_SetString(TFS_ERROR,
+		TfsError_setstr(instance,
 			        "Failed to desable tracing for \'this\' process.");
 		return false;
 	}
@@ -1850,7 +1888,7 @@ static bool init_callback_tep(struct tracefs_instance *instance,
 
 	*tep = tracefs_local_events(tracefs_instance_get_dir(instance));
 	if (!*tep) {
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Unable to get 'tep' event from instance \'%s\'.",
 			     get_instance_name(instance));
 		return false;
@@ -1893,7 +1931,7 @@ PyObject *PyFtrace_trace_shell_process(PyObject *self, PyObject *args,
 
 	pid = fork();
 	if (pid < 0) {
-		PyErr_SetString(TFS_ERROR, "Failed to fork");
+		TfsError_setstr(instance, "Failed to fork");
 		return NULL;
 	}
 
@@ -1939,7 +1977,7 @@ PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
 		return NULL;
 
 	if (!PyList_CheckExact(py_argv)) {
-		PyErr_SetString(TFS_ERROR, "Failed to parse \'argv\' list");
+		TfsError_setstr(instance, "Failed to parse \'argv\' list");
 		return NULL;
 	}
 
@@ -1947,7 +1985,7 @@ PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
 
 	pid = fork();
 	if (pid < 0) {
-		PyErr_SetString(TFS_ERROR, "Failed to fork");
+		TfsError_setstr(instance, "Failed to fork");
 		return NULL;
 	}
 
@@ -1989,7 +2027,7 @@ PyObject *PyFtrace_read_trace(PyObject *self, PyObject *args,
 
 	tracing_ON(pipe_instance);
 	if (tracefs_trace_pipe_print(pipe_instance, 0) < 0) {
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(pipe_instance,
 			     "Unable to read trace data from instance \'%s\'.",
 			     get_instance_name(pipe_instance));
 		return NULL;
-- 
2.30.2

