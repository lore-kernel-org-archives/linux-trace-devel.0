Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D53C07E99
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Jul 2021 13:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 819796143A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Jul 2021 13:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbhGHNzk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Jul 2021 09:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhGHNzk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Jul 2021 09:55:40 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE8BC061574
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Jul 2021 06:52:58 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id hc16so9753036ejc.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Jul 2021 06:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cc18VpBxfl4wvXkFzF2C3NBEWSjk9WYoWf5nehYfJwg=;
        b=vC7qGfcpTXKEMSTV0Ln6e2Y4MxdYwhiVv4ibfw17O3sEJNPv4PMX8IIyvgiLNavXnJ
         henl6lIdvH73gJe08UkU3W1GKuoMpmCR2v2Ob0ceHx6DR3SplBuxAnvuY53S9gaHX3L3
         nh3jU8jlBjWqoGijlA5IcIqj9ZHxI+WeyoEwiNTymNBDbxTbuZD9U+Buin7TjkABF+GN
         7bIcJ23zcO58Z1MIAZ5HdAXl1bE4b7OuQ5aib5KrPrfUo0w9tbJfIy40FEAZd8S6NKH2
         oxX3JgmoHuT7zfvf8mhmi9PUV1rh12wd3+og4Yxm931vjpVdZk7k7Mw1r7wN6rgzFv8a
         bEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cc18VpBxfl4wvXkFzF2C3NBEWSjk9WYoWf5nehYfJwg=;
        b=TmMChjtc0n2+G4I1kjwpTwvtjTdCnTCloM9rIlK3JYvloQh5S0n4z/JlwC/o9ORiBj
         OUbpem8mcW2LyJUN7zVH22LabHwmgBiWWc0zQ3ftbQxh4LmeqnmkQ0N+XaOUvZ8V4ISL
         cwYVyK1+Ksm/hk5RL25WvvMDhkrQHPEa4xbFGnPBVN1DuASqcq/isXt0p7F09HOjosKR
         tENh8Vz31or+ap2JqkUx4Usm/pWrl49Ku4uFGYOcTwOV00UaMfarpiNS8m1GyyCI48e/
         693jkhx4yW+RYfYU8uS3UkvpNNMnpQh3tnN51jnAojDaKjVYP/hxB5Hkdtm0+W1ub7LB
         pk/A==
X-Gm-Message-State: AOAM530tJOKRsmAe04AWoJ4fo9xjdzQILZZorLs65Z93NUUAbtgl34GU
        qPtlM64Vm0R+IKraxOiGhqRCekDJl9k=
X-Google-Smtp-Source: ABdhPJzGvopnQWecq8zP28mkloeHPfTY8Cli6nl6lrd19p7+QWpgKBBwvQ4cAasvr7tATXVhQvLwTw==
X-Received: by 2002:a17:906:794f:: with SMTP id l15mr18855573ejo.462.1625752376910;
        Thu, 08 Jul 2021 06:52:56 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.215])
        by smtp.gmail.com with ESMTPSA id hz7sm996487ejc.27.2021.07.08.06.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 06:52:56 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/3] trace-cruncher: Add support for Kprobes
Date:   Thu,  8 Jul 2021 16:52:41 +0300
Message-Id: <20210708135243.25229-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210708135243.25229-1-y.karadz@gmail.com>
References: <20210708135243.25229-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Kprobes is a built-in debugging mechanism for the Linux kernel,
which can be used extract monitoring data from a running
production system. Here we add to trace-cruncher a basic support
for using Kprobes.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c                  | 366 ++++++++++++++++++++++++--
 src/ftracepy-utils.h                  |  30 +++
 src/ftracepy.c                        |  55 ++++
 tests/1_unit/test_01_ftracepy_unit.py |  56 ++++
 4 files changed, 489 insertions(+), 18 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 91a319e..dfb0669 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -100,6 +100,7 @@ PyObject *PyTepEvent_parse_record_field(PyTepEvent* self, PyObject *args,
 							  PyObject *kwargs)
 {
 	struct tep_format_field *field;
+	int field_offset, field_size;
 	const char *field_name;
 	PyTepRecord *record;
 
@@ -124,11 +125,24 @@ PyObject *PyTepEvent_parse_record_field(PyTepEvent* self, PyObject *args,
 		return NULL;
 	}
 
-	if (!field->size)
+	if (field->flags & TEP_FIELD_IS_DYNAMIC) {
+		unsigned long long val;
+
+		val = tep_read_number(self->ptrObj->tep,
+				      record->ptrObj->data + field->offset,
+				      field->size);
+		field_offset = val & 0xffff;
+		field_size = val >> 16;
+	} else {
+		field_offset = field->offset;
+		field_size = field->size;
+	}
+
+	if (!field_size)
 		return PyUnicode_FromString("(nil)");
 
 	if (field->flags & TEP_FIELD_IS_STRING) {
-		char *val_str = record->ptrObj->data + field->offset;
+		char *val_str = record->ptrObj->data + field_offset;
 		return PyUnicode_FromString(val_str);
 	} else if (is_number(field)) {
 		unsigned long long val;
@@ -136,7 +150,7 @@ PyObject *PyTepEvent_parse_record_field(PyTepEvent* self, PyObject *args,
 		tep_read_number_field(field, record->ptrObj->data, &val);
 		return PyLong_FromLong(val);
 	} else if (field->flags & TEP_FIELD_IS_POINTER) {
-		void *val = record->ptrObj->data + field->offset;
+		void *val = record->ptrObj->data + field_offset;
 		char ptr_string[11];
 
 		sprintf(ptr_string, "%p", val);
@@ -1058,14 +1072,33 @@ PyObject *PyFtrace_disable_events(PyObject *self, PyObject *args,
 	Py_RETURN_NONE;
 }
 
+static PyObject *event_is_enabled(struct tracefs_instance *instance,
+				  const char *system, const char *event)
+{
+	char *file, *val;
+	PyObject *ret;
+
+	if (!get_event_enable_file(instance, system, event, &file))
+		return NULL;
+
+	if (read_from_file(instance, file, &val) <= 0)
+		return NULL;
+
+	trim_new_line(val);
+	ret = PyUnicode_FromString(val);
+
+	free(file);
+	free(val);
+
+	return ret;
+}
+
 PyObject *PyFtrace_event_is_enabled(PyObject *self, PyObject *args,
 						    PyObject *kwargs)
 {
 	static char *kwlist[] = {"instance", "system", "event", NULL};
 	const char *instance_name, *system, *event;
 	struct tracefs_instance *instance;
-	char *file, *val;
-	PyObject *ret;
 
 	instance_name = system = event = NO_ARG;
 	if (!PyArg_ParseTupleAndKeywords(args,
@@ -1081,19 +1114,7 @@ PyObject *PyFtrace_event_is_enabled(PyObject *self, PyObject *args,
 	if (!get_optional_instance(instance_name, &instance))
 		return false;
 
-	if (!get_event_enable_file(instance, system, event, &file))
-		return NULL;
-
-	if (read_from_file(instance, file, &val) <= 0)
-		return NULL;
-
-	trim_new_line(val);
-	ret = PyUnicode_FromString(val);
-
-	free(file);
-	free(val);
-
-	return ret;
+	return event_is_enabled(instance, system, event);
 }
 
 PyObject *PyFtrace_set_event_filter(PyObject *self, PyObject *args,
@@ -1472,6 +1493,314 @@ PyObject *PyFtrace_supported_options(PyObject *self, PyObject *args,
 	return get_option_list(instance, false);
 }
 
+static void *kprobe_root = NULL;
+
+static int kprobe_compare(const void *a, const void *b)
+{
+	const char *ca = (const char *) a;
+	const char *cb = (const char *) b;
+
+	return strcmp(ca, cb);
+}
+
+#define TC_SYS	"tcrunch"
+
+PyObject *PyFtrace_tc_event_system(PyObject *self)
+{
+	return PyUnicode_FromString(TC_SYS);
+}
+
+static int unregister_kprobe(const char *event)
+{
+	return tracefs_kprobe_clear_probe(TC_SYS, event, true);
+}
+
+void kprobe_free(void *kp)
+{
+	char *event = kp;
+
+	if (unregister_kprobe(event) < 0)
+		fprintf(stderr, "\ntfs_error: Failed to unregister kprobe \'%s\'.\n",
+		        event);
+
+	free(kp);
+}
+
+static void destroy_all_kprobes(void)
+{
+	tdestroy(kprobe_root, kprobe_free);
+	kprobe_root = NULL;
+}
+
+bool store_new_kprobe(const char *event)
+{
+	char *ptr = strdup(event);
+	char **val;
+
+	if (!ptr) {
+		MEM_ERROR;
+		return false;
+	}
+
+	val = tsearch(ptr, &kprobe_root, kprobe_compare);
+	if (!val || strcmp(*val, ptr) != 0) {
+		PyErr_Format(TFS_ERROR, "Failed to store new kprobe \'%s\'.",
+			     event);
+		return false;
+	}
+
+	return true;
+}
+
+PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
+						   PyObject *kwargs)
+{
+	static char *kwlist[] = {"event", "function", "probe", NULL};
+	const char *event, *function, *probe;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "sss",
+					 kwlist,
+					 &event,
+					 &function,
+					 &probe)) {
+		return NULL;
+	}
+
+	if (tracefs_kprobe_raw(TC_SYS, event, function, probe) < 0) {
+		PyErr_Format(TFS_ERROR, "Failed to register kprobe \'%s\'.",
+			     event);
+		return NULL;
+	}
+
+	if (!store_new_kprobe(event))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
+						      PyObject *kwargs)
+{
+	static char *kwlist[] = {"event", "function", "probe", NULL};
+	const char *event, *function, *probe = "$retval";
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "ss|s",
+					 kwlist,
+					 &event,
+					 &function,
+					 &probe)) {
+		return NULL;
+	}
+
+	if (tracefs_kretprobe_raw(TC_SYS, event, function, probe) < 0) {
+		PyErr_Format(TFS_ERROR, "Failed to register kretprobe \'%s\'.",
+			     event);
+		return NULL;
+	}
+
+	if (!store_new_kprobe(event))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_unregister_kprobe(PyObject *self, PyObject *args,
+						     PyObject *kwargs)
+{
+	static char *kwlist[] = {"event", "force",  NULL};
+	const char *event;
+	int force = false;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "s|p",
+					 kwlist,
+					 &event,
+					 &force)) {
+		return NULL;
+	}
+
+	if (is_all(event)) {
+		if (force) {
+			/* Clear all register kprobes. */
+			if (tracefs_kprobe_clear_all(force) < 0)
+				goto fail;
+		} else {
+			/*
+			 * Clear only the kprobes registered by
+			 * trace-cruncher.
+			 */
+			destroy_all_kprobes();
+		}
+	} else {
+		tdelete(event, &kprobe_root, kprobe_compare);
+		if (unregister_kprobe(event) < 0)
+			goto fail;
+	}
+
+	Py_RETURN_NONE;
+
+ fail:
+	PyErr_Format(TFS_ERROR, "Failed to unregister kprobe \'%s\'.", event);
+	return NULL;
+}
+
+PyObject *PyFtrace_registered_kprobe_names(PyObject *self)
+{
+	char **list = tracefs_get_kprobes(TRACEFS_ALL_KPROBES);
+	return tfs_list2py_list(list);
+}
+
+PyObject *PyFtrace_registered_kprobes(PyObject *self)
+{
+	const char *file = "kprobe_events";
+	PyObject *list = PyList_New(0);
+	char *probes, *token;
+	int size;
+
+	size = read_from_file(NULL, file, &probes);
+	if (size < 0)
+		return NULL;
+
+	if (size == 0 || !probes)
+		return list;
+
+	token = strtok(probes, "\n");
+	while (token != NULL) {
+		PyList_Append(list, PyUnicode_FromString(token));
+		token = strtok(NULL, "\n");
+	}
+
+	return list;
+}
+
+PyObject *PyFtrace_set_kprobe_filter(PyObject *self, PyObject *args,
+						     PyObject *kwargs)
+{
+	const char *instance_name = NO_ARG, *event, *filter;
+	struct tracefs_instance *instance;
+	char path[PATH_MAX];
+
+	static char *kwlist[] = {"event", "filter", "instance", NULL};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "ss|s",
+					 kwlist,
+					 &event,
+					 &filter,
+					 &instance_name)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	sprintf(path, "events/%s/%s/filter", TC_SYS, event);
+	if (!write_to_file_and_check(instance, path, filter)) {
+		PyErr_SetString(TFS_ERROR, "Failed to set kprobe filter.");
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_clear_kprobe_filter(PyObject *self, PyObject *args,
+						       PyObject *kwargs)
+{
+	const char *instance_name = NO_ARG, *event;
+	struct tracefs_instance *instance;
+	char path[PATH_MAX];
+
+	static char *kwlist[] = {"event", "instance", NULL};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "s|s",
+					 kwlist,
+					 &event,
+					 &instance_name)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	sprintf(path, "events/%s/%s/filter", TC_SYS, event);
+	if (!write_to_file(instance, path, OFF)) {
+		PyErr_SetString(TFS_ERROR, "Failed to clear kprobe filter.");
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
+static bool enable_kprobe(PyObject *self, PyObject *args, PyObject *kwargs,
+			  bool enable)
+{
+	static char *kwlist[] = {"event", "instance", NULL};
+	struct tracefs_instance *instance;
+	const char *instance_name, *event;
+
+	instance_name = event = NO_ARG;
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "s|s",
+					 kwlist,
+					 &event,
+					 &instance_name)) {
+		return false;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return false;
+
+	return event_enable_disable(instance, TC_SYS, event, enable);
+}
+
+PyObject *PyFtrace_enable_kprobe(PyObject *self, PyObject *args,
+						 PyObject *kwargs)
+{
+	if (!enable_kprobe(self, args, kwargs, true))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_disable_kprobe(PyObject *self, PyObject *args,
+						  PyObject *kwargs)
+{
+	if (!enable_kprobe(self, args, kwargs, false))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_kprobe_is_enabled(PyObject *self, PyObject *args,
+						     PyObject *kwargs)
+{
+	static char *kwlist[] = {"event", "instance", NULL};
+	struct tracefs_instance *instance;
+	const char *instance_name, *event;
+
+	instance_name = event = NO_ARG;
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "s|s",
+					 kwlist,
+					 &event,
+					 &instance_name)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	return event_is_enabled(instance, TC_SYS, event);
+}
+
 static bool set_fork_options(struct tracefs_instance *instance, bool enable)
 {
 	if (enable) {
@@ -1865,5 +2194,6 @@ PyObject *PyFtrace_hook2pid(PyObject *self, PyObject *args, PyObject *kwargs)
 
 void PyFtrace_at_exit(void)
 {
+	destroy_all_kprobes();
 	destroy_all_instances();
 }
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 3699aaa..d826427 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -125,6 +125,36 @@ PyObject *PyFtrace_supported_options(PyObject *self, PyObject *args,
 PyObject *PyFtrace_enabled_options(PyObject *self, PyObject *args,
 						   PyObject *kwargs);
 
+PyObject *PyFtrace_tc_event_system(PyObject *self);
+
+PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
+						   PyObject *kwargs);
+
+PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
+						      PyObject *kwargs);
+
+PyObject *PyFtrace_unregister_kprobe(PyObject *self, PyObject *args,
+						     PyObject *kwargs);
+
+PyObject *PyFtrace_registered_kprobes(PyObject *self);
+
+PyObject *PyFtrace_registered_kprobe_names(PyObject *self);
+
+PyObject *PyFtrace_set_kprobe_filter(PyObject *self, PyObject *args,
+						     PyObject *kwargs);
+
+PyObject *PyFtrace_clear_kprobe_filter(PyObject *self, PyObject *args,
+						       PyObject *kwargs);
+
+PyObject *PyFtrace_enable_kprobe(PyObject *self, PyObject *args,
+						 PyObject *kwargs);
+
+PyObject *PyFtrace_disable_kprobe(PyObject *self, PyObject *args,
+						  PyObject *kwargs);
+
+PyObject *PyFtrace_kprobe_is_enabled(PyObject *self, PyObject *args,
+						     PyObject *kwargs);
+
 PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
 						 PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 5dd61e4..e5fcd54 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -214,6 +214,61 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Gat a list of all supported options."
 	},
+	{"tc_event_system",
+	 (PyCFunction) PyFtrace_tc_event_system,
+	 METH_NOARGS,
+	 "Get the name of the event system used by trace-cruncher."
+	},
+	{"register_kprobe",
+	 (PyCFunction) PyFtrace_register_kprobe,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define a kprobe."
+	},
+	{"register_kretprobe",
+	 (PyCFunction) PyFtrace_register_kretprobe,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define a kretprobe."
+	},
+	{"unregister_kprobe",
+	 (PyCFunction) PyFtrace_unregister_kprobe,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define a kprobe."
+	},
+	{"registered_kprobes",
+	 (PyCFunction) PyFtrace_registered_kprobes,
+	 METH_NOARGS,
+	 "Get all registered kprobes."
+	},
+	{"registered_kprobe_names",
+	 (PyCFunction) PyFtrace_registered_kprobe_names,
+	 METH_NOARGS,
+	 "Get the names of all registered kprobes."
+	},
+	{"set_kprobe_filter",
+	 (PyCFunction) PyFtrace_set_kprobe_filter,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define a filter for a kprobe."
+	},
+	{"clear_kprobe_filter",
+	 (PyCFunction) PyFtrace_clear_kprobe_filter,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Clear the filter of a kprobe."
+	},
+	{"enable_kprobe",
+	 (PyCFunction) PyFtrace_enable_kprobe,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Enable kprobe event."
+	},
+	{"disable_kprobe",
+	 (PyCFunction) PyFtrace_disable_kprobe,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Disable kprobe event."
+	},
+	{"kprobe_is_enabled",
+	 (PyCFunction) PyFtrace_kprobe_is_enabled,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Check if kprobe event is enabled."
+	},
 	{"trace_process",
 	 (PyCFunction) PyFtrace_trace_process,
 	 METH_VARARGS | METH_KEYWORDS,
diff --git a/tests/1_unit/test_01_ftracepy_unit.py b/tests/1_unit/test_01_ftracepy_unit.py
index e11c034..8c19ae3 100644
--- a/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tests/1_unit/test_01_ftracepy_unit.py
@@ -441,6 +441,62 @@ class OptionsTestCase(unittest.TestCase):
 
         ft.destroy_all_instances()
 
+class KprobeTestCase(unittest.TestCase):
+    def test_register_kprobe(self):
+        evt1 = 'mkdir'
+        evt1_func = 'do_mkdirat'
+        evt1_prove = 'path=+u0($arg2):ustring'
+        evt2 = 'open'
+        evt2_func = 'do_sys_openat2'
+        evt2_prove = 'file=+u0($arg2):ustring'
+
+        ft.register_kprobe(event=evt1, function=evt1_func,
+                           probe=evt1_prove)
+        all_kprobes = ft.get_registered_kprobes()
+        self.assertEqual(len(all_kprobes), 1)
+        self.assertTrue(evt1 in all_kprobes[0])
+        self.assertTrue(evt1_func in all_kprobes[0])
+        self.assertTrue(evt1_prove in all_kprobes[0])
+
+        ft.unregister_kprobe(event=evt1)
+        all_kprobes = ft.get_registered_kprobes()
+        self.assertEqual(len(all_kprobes), 0)
+
+        ft.register_kprobe(event=evt1, function=evt1_func,
+                           probe=evt1_prove)
+        ft.register_kprobe(event=evt2, function=evt2_func,
+                           probe=evt2_prove)
+        all_kprobes = ft.get_registered_kprobes()
+        self.assertEqual(len(all_kprobes), 2)
+        self.assertTrue(evt1 in all_kprobes[0])
+        self.assertTrue(evt1_func in all_kprobes[0])
+        self.assertTrue(evt1_prove in all_kprobes[0])
+        self.assertTrue(evt2 in all_kprobes[1])
+        self.assertTrue(evt2_func in all_kprobes[1])
+        self.assertTrue(evt2_prove in all_kprobes[1])
+
+        ft.unregister_kprobe(event='ALL')
+        all_kprobes = ft.get_registered_kprobes()
+        self.assertEqual(len(all_kprobes), 0)
+
+    def test_register_kprobe(self):
+        evt1 = 'mkdir'
+        evt1_func = 'do_mkdirat'
+        evt1_prove = 'path=+u0($arg2):ustring'
+
+        ft.register_kprobe(event=evt1, function=evt1_func,
+                           probe=evt1_prove)
+        ft.create_instance(instance_name)
+        ft.enable_kprobe(instance=instance_name, event=evt1)
+        ret = ft.kprobe_is_enabled(instance=instance_name, event=evt1)
+        self.assertEqual(ret, '1')
+
+        ft.disable_kprobe(instance=instance_name, event=evt1)
+        ret = ft.kprobe_is_enabled(instance=instance_name, event=evt1)
+        self.assertEqual(ret, '0')
+
+        ft.unregister_kprobe(event='ALL')
+        ft.destroy_all_instances()
 
 class TracingOnTestCase(unittest.TestCase):
     def test_ON_OF(self):
-- 
2.27.0

