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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754C0C432BE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 12:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59C4661368
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 12:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbhHWMyp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 08:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbhHWMyo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 08:54:44 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA01C061575
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 05:54:02 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id u1so10496485wmm.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 05:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lcRAT9uatMWuoPKhISK7u8+gO7QvrVE+pXNHjzxluc0=;
        b=VIg03fO7qIoyXqLEtGV7jboy3Tlj9F7IqzG/BBTii1+ZV/Xs9eEtE1yrf+aQPTtqzU
         0klFDNVog1Lh22NNA7y8x2hxYF11Yq5xr+VcGLcUuJ820GSaKHYVv0dEF2jPaqI1lJSr
         yoXhgiv2WYrUj7JsBc18DonFROwYZ4+aWI4wIxQLygKdNoVByMvZHUIJf+45v+objOw3
         +cXxs9L94MIvumF3hpCG0fQ00qEIhQ41tfTq38WlhaOc66cMdHf0zwNjBn0FMR7berTt
         GeJ5ZzWwCkovW23XovJgVBwhO1O+fg1x0c8vpeO0HN0SmEuAn9C8dfGKxuQbZmdE1iG8
         xtlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lcRAT9uatMWuoPKhISK7u8+gO7QvrVE+pXNHjzxluc0=;
        b=Se3fP07daPMpPv3SsliKZFR2cNUfIayEKBmqKT/mL5rxHoC9X9GgbV95s0rRzuUIkK
         fXsxvn9tdjcOEwuZ0vTxhF99MA0cPPCS7PsMRQ/6/C573i8A8VVNlD0c23n/9t+BGQzF
         kSFMLkbX5Nez7C7IeRtkRZyl4VKJxph8bKoxM/bgXPIT2Pux/Y7BrW2wF4/4WYzPrOXI
         0bLR/YuFg0IJzANEsNJ+yjlY1mZAUVABaKGIRFVmhd5BNh2VDBs0amdDFfvp9VZiIydO
         UogNUsSy6DU09owRlpqiAcHUx00LIvdQ1OjmPOPkn1/aK4n7ULOVxwjRJtoPik5xAaeS
         tnlA==
X-Gm-Message-State: AOAM532AXQMFL7Zf3F8rUzJ3J9N1G3SeSBPdSogRQm4IoLDBfdbrX2mr
        zuPHI6iD1O1huwMhlzByjaca0i9GWfk=
X-Google-Smtp-Source: ABdhPJyEMHMMFuiLYaRwBaGTBPblGVzAD2rX5r1nSYqC1/NEPPwb+5aE1rv0e//a2sEOgVrGi8Iawg==
X-Received: by 2002:a1c:6a04:: with SMTP id f4mr16080094wmc.54.1629723240482;
        Mon, 23 Aug 2021 05:54:00 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id b10sm11469454wrt.43.2021.08.23.05.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 05:54:00 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] trace-cruncher: Print the tracefs log on an error
Date:   Mon, 23 Aug 2021 15:53:48 +0300
Message-Id: <20210823125348.145615-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823125348.145615-1-y.karadz@gmail.com>
References: <20210823125348.145615-1-y.karadz@gmail.com>
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
index 4561a4d..208e21d 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -54,6 +54,45 @@ static bool tfs_clear_error_log(struct tracefs_instance *instance)
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
@@ -283,7 +322,7 @@ PyObject *PyTep_init_local(PyTep *self, PyObject *args,
 		const char **sys_names = get_arg_list(system_list);
 
 		if (!sys_names) {
-			PyErr_SetString(TFS_ERROR,
+			TfsError_setstr(NULL,
 					"Inconsistent \"systems\" argument.");
 			return NULL;
 		}
@@ -295,8 +334,7 @@ PyObject *PyTep_init_local(PyTep *self, PyObject *args,
 	}
 
 	if (!tep) {
-		PyErr_Format(TFS_ERROR,
-			     "Failed to get local events from \'%s\'.",
+		TfsError_fmt(NULL, "Failed to get local events from \'%s\'.",
 			     dir_str);
 		return NULL;
 	}
@@ -331,7 +369,7 @@ PyObject *PyTep_get_event(PyTep *self, PyObject *args,
 static bool check_file(struct tracefs_instance *instance, const char *file)
 {
 	if (!tracefs_file_exists(instance, file)) {
-		PyErr_Format(TFS_ERROR, "File %s does not exist.", file);
+		TfsError_fmt(instance, "File %s does not exist.", file);
 		return false;
 	}
 
@@ -341,7 +379,7 @@ static bool check_file(struct tracefs_instance *instance, const char *file)
 static bool check_dir(struct tracefs_instance *instance, const char *dir)
 {
 	if (!tracefs_dir_exists(instance, dir)) {
-		PyErr_Format(TFS_ERROR, "Directory %s does not exist.", dir);
+		TfsError_fmt(instance, "Directory %s does not exist.", dir);
 		return false;
 	}
 
@@ -366,7 +404,7 @@ static int write_to_file(struct tracefs_instance *instance,
 
 	size = tracefs_instance_file_write(instance, file, val);
 	if (size <= 0) {
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Can not write \'%s\' to file \'%s\' (inst: \'%s\').",
 			     val, file, get_instance_name(instance));
 		PyErr_Print();
@@ -386,7 +424,7 @@ static int append_to_file(struct tracefs_instance *instance,
 
 	size = tracefs_instance_file_append(instance, file, val);
 	if (size <= 0) {
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Can not append \'%s\' to file \'%s\' (inst: \'%s\').",
 			     val, file, get_instance_name(instance));
 		PyErr_Print();
@@ -406,7 +444,7 @@ static int read_from_file(struct tracefs_instance *instance,
 
 	*val = tracefs_instance_file_read(instance, file, &size);
 	if (size < 0)
-		PyErr_Format(TFS_ERROR, "Can not read from file %s", file);
+		TfsError_fmt(instance, "Can not read from file %s", file);
 
 	return size;
 }
@@ -529,7 +567,7 @@ PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
 	if (!instance ||
 	    !tracefs_instance_exists(name) ||
 	    !tracefs_instance_is_new(instance)) {
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Failed to create new trace instance \'%s\'.",
 			     name);
 		return NULL;
@@ -633,7 +671,7 @@ PyObject *PyFtrace_set_current_tracer(PyObject *self, PyObject *args,
 		}
 
 		if (!all_tracers || !all_tracers[i]) {
-			PyErr_Format(TFS_ERROR,
+			TfsError_fmt(instance,
 				     "Tracer \'%s\' is not available.",
 				     tracer);
 			return NULL;
@@ -643,7 +681,7 @@ PyObject *PyFtrace_set_current_tracer(PyObject *self, PyObject *args,
 	}
 
 	if (!write_to_file_and_check(instance, file, tracer)) {
-		PyErr_Format(TFS_ERROR, "Failed to enable tracer \'%s\'",
+		TfsError_fmt(instance, "Failed to enable tracer \'%s\'",
 			     tracer);
 		return NULL;
 	}
@@ -762,7 +800,7 @@ bool get_event_enable_file(struct tracefs_instance *instance,
  fail:
 	instance_name =
 		instance ? tracefs_instance_get_name(instance) : "top";
-	PyErr_Format(TFS_ERROR,
+	TfsError_fmt(instance,
 		     "Failed to locate event:\n Instance: %s  System: %s  Event: %s",
 		     instance_name, system, event);
 	free(buff);
@@ -788,7 +826,7 @@ static bool event_enable_disable(struct tracefs_instance *instance,
 		ret = tracefs_event_disable(instance, system, event);
 
 	if (ret != 0) {
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Failed to enable/disable event:\n System: %s  Event: %s",
 			     system ? system : "NULL",
 			     event ? event : "NULL");
@@ -878,7 +916,7 @@ static bool set_enable_events(PyObject *self, PyObject *args, PyObject *kwargs,
 		    is_all(PyUnicode_DATA(event_list))) {
 			return event_enable_disable(instance, NULL, NULL, enable);
 		} else {
-			PyErr_SetString(TFS_ERROR,
+			TfsError_setstr(instance,
 					"Failed to enable events for unspecified system");
 			return false;
 		}
@@ -886,7 +924,7 @@ static bool set_enable_events(PyObject *self, PyObject *args, PyObject *kwargs,
 
 	systems = get_arg_list(system_list);
 	if (!systems) {
-		PyErr_SetString(TFS_ERROR, "Inconsistent \"systems\" argument.");
+		TfsError_setstr(instance, "Inconsistent \"systems\" argument.");
 		return false;
 	}
 
@@ -926,7 +964,7 @@ static bool set_enable_events(PyObject *self, PyObject *args, PyObject *kwargs,
 	return true;
 
  fail_with_err:
-	PyErr_SetString(TFS_ERROR, "Inconsistent \"events\" argument.");
+	TfsError_setstr(instance, "Inconsistent \"events\" argument.");
 
  fail:
 	free(systems);
@@ -1025,7 +1063,7 @@ PyObject *PyFtrace_set_event_filter(PyObject *self, PyObject *args,
 
 	sprintf(path, "events/%s/%s/filter", system, event);
 	if (!write_to_file_and_check(instance, path, filter)) {
-		PyErr_SetString(TFS_ERROR, "Failed to set event filter");
+		TfsError_setstr(instance, "Failed to set event filter");
 		return NULL;
 	}
 
@@ -1056,7 +1094,7 @@ PyObject *PyFtrace_clear_event_filter(PyObject *self, PyObject *args,
 
 	sprintf(path, "events/%s/%s/filter", system, event);
 	if (!write_to_file(instance, path, OFF)) {
-		PyErr_SetString(TFS_ERROR, "Failed to clear event filter");
+		TfsError_setstr(instance, "Failed to clear event filter");
 		return NULL;
 	}
 
@@ -1072,7 +1110,7 @@ static bool tracing_ON(struct tracefs_instance *instance)
 		const char *instance_name =
 			instance ? tracefs_instance_get_name(instance) : "top";
 
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Failed to start tracing (Instance: %s)",
 			     instance_name);
 		return false;
@@ -1104,7 +1142,7 @@ static bool tracing_OFF(struct tracefs_instance *instance)
 		const char *instance_name =
 			instance ? tracefs_instance_get_name(instance) : "top";
 
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Failed to stop tracing (Instance: %s)",
 			     instance_name);
 		return false;
@@ -1141,7 +1179,7 @@ PyObject *PyFtrace_is_tracing_ON(PyObject *self, PyObject *args,
 		const char *instance_name =
 			instance ? tracefs_instance_get_name(instance) : "top";
 
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Failed to check if tracing is ON (Instance: %s)",
 			     instance_name);
 		return NULL;
@@ -1202,7 +1240,7 @@ static bool set_pid(struct tracefs_instance *instance,
 	return true;
 
  fail:
-	PyErr_Format(TFS_ERROR, "Failed to set PIDs for \"%s\"",
+	TfsError_fmt(instance, "Failed to set PIDs for \"%s\"",
 		     file);
 	return false;
 }
@@ -1266,7 +1304,7 @@ static bool set_opt(struct tracefs_instance *instance,
 
 	if (sprintf(file, "options/%s", opt) <= 0 ||
 	    !write_to_file_and_check(instance, file, val)) {
-		PyErr_Format(TFS_ERROR, "Failed to set option \"%s\"", opt);
+		TfsError_fmt(instance, "Failed to set option \"%s\"", opt);
 		return false;
 	}
 
@@ -1398,7 +1436,7 @@ static bool register_kprobe(const char *event,
 			    const char *probe)
 {
 	if (tracefs_kprobe_raw(TC_SYS, event, function, probe) < 0) {
-		PyErr_Format(TFS_ERROR, "Failed to register kprobe \'%s\'.",
+		TfsError_fmt(NULL, "Failed to register kprobe \'%s\'.",
 			     event);
 		return false;
 	}
@@ -1411,7 +1449,7 @@ static bool register_kretprobe(const char *event,
 			       const char *probe)
 {
 	if (tracefs_kretprobe_raw(TC_SYS, event, function, probe) < 0) {
-		PyErr_Format(TFS_ERROR, "Failed to register kretprobe \'%s\'.",
+		TfsError_fmt(NULL, "Failed to register kretprobe \'%s\'.",
 			     event);
 		return false;
 	}
@@ -1422,7 +1460,7 @@ static bool register_kretprobe(const char *event,
 static bool unregister_kprobe(const char *event)
 {
 	if (tracefs_kprobe_clear_probe(TC_SYS, event, true) < 0) {
-		PyErr_Format(TFS_ERROR, "Failed to unregister kprobe \'%s\'.",
+		TfsError_fmt(NULL, "Failed to unregister kprobe \'%s\'.",
 			     event);
 		return false;
 	}
@@ -1571,7 +1609,7 @@ PyObject *PyKprobe_set_filter(PyKprobe *self, PyObject *args,
 
 	sprintf(path, "events/%s/%s/filter", TC_SYS, self->ptrObj->event);
 	if (!write_to_file_and_check(instance, path, filter)) {
-		PyErr_SetString(TFS_ERROR, "Failed to set kprobe filter.");
+		TfsError_setstr(instance, "Failed to set kprobe filter.");
 		return NULL;
 	}
 
@@ -1599,7 +1637,7 @@ PyObject *PyKprobe_clear_filter(PyKprobe *self, PyObject *args,
 
 	sprintf(path, "events/%s/%s/filter", TC_SYS, self->ptrObj->event);
 	if (!write_to_file(instance, path, OFF)) {
-		PyErr_SetString(TFS_ERROR, "Failed to clear kprobe filter.");
+		TfsError_setstr(instance, "Failed to clear kprobe filter.");
 		return NULL;
 	}
 
@@ -1723,7 +1761,7 @@ static bool hook2pid(struct tracefs_instance *instance, PyObject *pid_val, int f
 	return true;
 
  fail:
-	PyErr_SetString(TFS_ERROR, "Failed to hook to PID");
+	TfsError_setstr(instance, "Failed to hook to PID");
 	PyErr_Print();
 	return false;
 }
@@ -1740,7 +1778,7 @@ static void start_tracing_procces(struct tracefs_instance *instance,
 
 	tracing_ON(instance);
 	if (execvpe(argv[0], argv, envp) < 0) {
-		PyErr_Format(TFS_ERROR, "Failed to exec \'%s\'",
+		TfsError_fmt(instance, "Failed to exec \'%s\'",
 			     argv[0]);
 	}
 
@@ -1754,14 +1792,14 @@ static PyObject *get_callback_func(const char *plugin_name, const char * py_call
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
@@ -1817,7 +1855,7 @@ static bool notrace_this_pid(struct tracefs_instance *instance)
 
 	if (!pid2file(instance, "set_ftrace_notrace_pid", pid, true) ||
 	    !pid2file(instance, "set_event_notrace_pid", pid, true)) {
-		PyErr_SetString(TFS_ERROR,
+		TfsError_setstr(instance,
 			        "Failed to desable tracing for \'this\' process.");
 		return false;
 	}
@@ -1849,7 +1887,7 @@ static bool init_callback_tep(struct tracefs_instance *instance,
 
 	*tep = tracefs_local_events(tracefs_instance_get_dir(instance));
 	if (!*tep) {
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(instance,
 			     "Unable to get 'tep' event from instance \'%s\'.",
 			     get_instance_name(instance));
 		return false;
@@ -1892,7 +1930,7 @@ PyObject *PyFtrace_trace_shell_process(PyObject *self, PyObject *args,
 
 	pid = fork();
 	if (pid < 0) {
-		PyErr_SetString(TFS_ERROR, "Failed to fork");
+		TfsError_setstr(instance, "Failed to fork");
 		return NULL;
 	}
 
@@ -1938,7 +1976,7 @@ PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
 		return NULL;
 
 	if (!PyList_CheckExact(py_argv)) {
-		PyErr_SetString(TFS_ERROR, "Failed to parse \'argv\' list");
+		TfsError_setstr(instance, "Failed to parse \'argv\' list");
 		return NULL;
 	}
 
@@ -1946,7 +1984,7 @@ PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
 
 	pid = fork();
 	if (pid < 0) {
-		PyErr_SetString(TFS_ERROR, "Failed to fork");
+		TfsError_setstr(instance, "Failed to fork");
 		return NULL;
 	}
 
@@ -1988,7 +2026,7 @@ PyObject *PyFtrace_read_trace(PyObject *self, PyObject *args,
 
 	tracing_ON(pipe_instance);
 	if (tracefs_trace_pipe_print(pipe_instance, 0) < 0) {
-		PyErr_Format(TFS_ERROR,
+		TfsError_fmt(pipe_instance,
 			     "Unable to read trace data from instance \'%s\'.",
 			     get_instance_name(pipe_instance));
 		return NULL;
-- 
2.30.2

