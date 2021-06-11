Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A943BC48BD1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E525613CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhFKLnW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 07:43:22 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:45882 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhFKLnV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 07:43:21 -0400
Received: by mail-wm1-f50.google.com with SMTP id v206-20020a1cded70000b02901a586d3fa23so8311776wmg.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jun 2021 04:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tvHey6naGx5RbLxo7X2NtW7Y61cCTelRtZAx1SlPxag=;
        b=lY4DmxmdDQJwQ8XOQ9dz4sXRRYF4rp6S5CBSLz5gjtJobqEdK43ERBknIG/wKIZjcF
         SQGlMtu9qEfk4GgjsTUzCh4JNyOug4Ay4oL4bD1htMyTWvGpC/DjepdQQBVXLqbOnhF6
         6Do640UofP2MPITZYYiAfjRvyCLOYKtkMWLl0ltiKGfnhkl7O0mO35WUBT7ipNbpdOvU
         UlNW8GB5pfghHCd85NGUW9M6coTswHcyLQr4vGu7bwYRchEpF1WzB23sRwCwcHZVAoBs
         IGjJxZjbGEUyoy3OfxcDA3u654J5O3ysw0ltLCF2nl3C6C1nw+cXCgmNe1prT1pVCx7M
         h2EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tvHey6naGx5RbLxo7X2NtW7Y61cCTelRtZAx1SlPxag=;
        b=taw/NknvNQEbohfT/oIET0oKteoWh9IAhxV8vfTcF3IaU+pL12inNVhf5ILp0vO9n1
         IkjPnaaCEDNa/EpAUN1cGUE8Mc8G2ecc/RGiHJYAZBw16vrD1BnDznkuLD8QEbc78oGy
         C1L7mKBcKJAwtoJalv0lceRnHJWjet1DZDr4kUum5KD8mTrUmYMr4R6b5QFmxOM1raUN
         yWTtmSOvhKbjFllHAwrNuRa38JXN7NU4as6Mk6y1p821TsuVXOnQM2Z6LrncqaWxNqH5
         zZ60ifbWyR9KGIgY5g9m+9etjXXrqo0BuDQt5HuoKOtRAFnexW5roUFkEso6K9zTHmNC
         htoQ==
X-Gm-Message-State: AOAM532PrgtgLyMzvdsf3+/aawjMPm+j8OSNtremVxU8fS2z1oBC4ZYz
        y4yLqNpCBB078q97n4BDgGU9fCSZ/yc=
X-Google-Smtp-Source: ABdhPJwgXwMU8/YelHMnm+bSw/SEB968OGMzWD4DpsRmNz1lTY5Pb4P9g2G6QXF8ZPeG6xKJ1/4tnQ==
X-Received: by 2002:a1c:e4c2:: with SMTP id b185mr19595561wmh.156.1623411610777;
        Fri, 11 Jun 2021 04:40:10 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id c7sm6856464wrs.23.2021.06.11.04.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 04:40:10 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/9] trace-cruncher: Refactor the part that wraps ftrace
Date:   Fri, 11 Jun 2021 14:39:50 +0300
Message-Id: <20210611113958.38142-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611113958.38142-1-y.karadz@gmail.com>
References: <20210611113958.38142-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to be able to bulid the project as a native Python
package, which contains several sub-packages implement as C
extensions via the Python's C API, the part of the interface
that relies on libtracefs, libtraceevent (and libtracecmd in
the future) needs to be re-implemented as an extension called
"tracecruncher.ftracepy". Note that this new extension has
a stand-alone build that is completely decoupled from the
existing build system used by trace-cruncher.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 setup.py             |   68 ++
 src/common.h         |  105 +++
 src/ftracepy-utils.c | 1712 ++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  144 ++++
 src/ftracepy.c       |  292 +++++++
 5 files changed, 2321 insertions(+)
 create mode 100644 setup.py
 create mode 100644 src/common.h
 create mode 100644 src/ftracepy-utils.c
 create mode 100644 src/ftracepy-utils.h
 create mode 100644 src/ftracepy.c

diff --git a/setup.py b/setup.py
new file mode 100644
index 0000000..450f043
--- /dev/null
+++ b/setup.py
@@ -0,0 +1,68 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+from setuptools import setup, find_packages
+from distutils.core import Extension
+from Cython.Build import cythonize
+
+import pkgconfig as pkg
+
+
+def third_party_paths():
+    pkg_traceevent = pkg.parse('libtraceevent')
+    pkg_ftracepy = pkg.parse('libtracefs')
+    pkg_tracecmd = pkg.parse('libtracecmd')
+
+    include_dirs = []
+    include_dirs.extend(pkg_traceevent['include_dirs'])
+    include_dirs.extend(pkg_ftracepy['include_dirs'])
+    include_dirs.extend(pkg_tracecmd['include_dirs'])
+
+    library_dirs = []
+    library_dirs.extend(pkg_traceevent['library_dirs'])
+    library_dirs.extend(pkg_ftracepy['library_dirs'])
+    library_dirs.extend(pkg_tracecmd['library_dirs'])
+    library_dirs = list(set(library_dirs))
+
+    return include_dirs, library_dirs
+
+include_dirs, library_dirs = third_party_paths()
+
+def extension(name, sources, libraries):
+    runtime_library_dirs = library_dirs
+    runtime_library_dirs.extend('$ORIGIN')
+    return Extension(name, sources=sources,
+                           include_dirs=include_dirs,
+                           library_dirs=library_dirs,
+                           runtime_library_dirs=runtime_library_dirs,
+                           libraries=libraries,
+                           )
+
+def main():
+    module_ft  = extension(name='tracecruncher.ftracepy',
+                            sources=['src/ftracepy.c', 'src/ftracepy-utils.c'],
+                            libraries=['traceevent', 'tracefs'])
+
+    setup(name='tracecruncher',
+          version='0.1.0',
+          description='NumPy based interface for accessing tracing data in Python.',
+          author='Yordan Karadzhov (VMware)',
+          author_email='y.karadz@gmail.com',
+          url='https://github.com/vmware/trace-cruncher',
+          license='LGPL-2.1',
+          packages=find_packages(),
+          ext_modules=[module_ft],
+          classifiers=[
+              'Development Status :: 3 - Alpha',
+              'Programming Language :: Python :: 3',
+              ]
+          )
+
+
+if __name__ == '__main__':
+    main()
diff --git a/src/common.h b/src/common.h
new file mode 100644
index 0000000..9985328
--- /dev/null
+++ b/src/common.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+#ifndef _TC_COMMON_H
+#define _TC_COMMON_H
+
+// C
+#include <stdbool.h>
+#include <string.h>
+
+#define TRACECRUNCHER_ERROR	tracecruncher_error
+#define KSHARK_ERROR		kshark_error
+#define TEP_ERROR		tep_error
+#define TFS_ERROR		tfs_error
+
+#define KS_INIT_ERROR \
+	PyErr_SetString(KSHARK_ERROR, "libshark failed to initialize");
+
+#define MEM_ERROR \
+	PyErr_SetString(TRACECRUNCHER_ERROR, "failed to allocate memory");
+
+static const char *NO_ARG = "/NONE/";
+
+static inline bool is_all(const char *arg)
+{
+	const char all[] = "all";
+	const char *p = &all[0];
+
+	for (; *arg; arg++, p++) {
+		if (tolower(*arg) != *p)
+			return false;
+	}
+	return !(*p);
+}
+
+static inline bool is_no_arg(const char *arg)
+{
+	return arg[0] == '\0' || arg == NO_ARG;
+}
+
+static inline bool is_set(const char *arg)
+{
+	return !(is_all(arg) || is_no_arg(arg));
+}
+
+static inline void no_free()
+{
+}
+
+#define NO_FREE		no_free
+
+#define STR(x) #x
+
+#define MAKE_TYPE_STR(x) STR(traceevent.x)
+
+#define MAKE_DIC_STR(x) STR(libtraceevent x object)
+
+#define C_OBJECT_WRAPPER_DECLARE(c_type, py_type)				\
+	typedef struct {							\
+	PyObject_HEAD								\
+	struct c_type *ptrObj;							\
+} py_type;									\
+PyObject *py_type##_New(struct c_type *evt_ptr);				\
+bool py_type##TypeInit();							\
+
+#define  C_OBJECT_WRAPPER(c_type, py_type, ptr_free)				\
+static PyTypeObject py_type##Type = {						\
+	PyVarObject_HEAD_INIT(NULL, 0) MAKE_TYPE_STR(c_type)			\
+};										\
+PyObject *py_type##_New(struct c_type *evt_ptr)					\
+{										\
+	py_type *newObject;							\
+	newObject = PyObject_New(py_type, &py_type##Type);			\
+	newObject->ptrObj = evt_ptr;						\
+	return (PyObject *) newObject;						\
+}										\
+static int py_type##_init(py_type *self, PyObject *args, PyObject *kwargs)	\
+{										\
+	self->ptrObj = NULL;							\
+	return 0;								\
+}										\
+static void py_type##_dealloc(py_type *self)					\
+{										\
+	ptr_free(self->ptrObj);							\
+	Py_TYPE(self)->tp_free(self);						\
+}										\
+bool py_type##TypeInit()							\
+{										\
+	py_type##Type.tp_new = PyType_GenericNew;				\
+	py_type##Type.tp_basicsize = sizeof(py_type);				\
+	py_type##Type.tp_init = (initproc) py_type##_init;			\
+	py_type##Type.tp_dealloc = (destructor) py_type##_dealloc;		\
+	py_type##Type.tp_flags = Py_TPFLAGS_DEFAULT;				\
+	py_type##Type.tp_doc = MAKE_DIC_STR(c_type);				\
+	py_type##Type.tp_methods = py_type##_methods;				\
+	if (PyType_Ready(&py_type##Type) < 0)					\
+		return false;							\
+	Py_INCREF(&py_type##Type);						\
+	return true;								\
+}										\
+
+#endif
diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
new file mode 100644
index 0000000..ff16156
--- /dev/null
+++ b/src/ftracepy-utils.c
@@ -0,0 +1,1712 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+#ifndef _GNU_SOURCE
+/** Use GNU C Library. */
+#define _GNU_SOURCE
+#endif // _GNU_SOURCE
+
+// C
+#include <search.h>
+#include <string.h>
+#include <sys/wait.h>
+
+// trace-cruncher
+#include "ftracepy-utils.h"
+
+static void *instance_root;
+PyObject *TFS_ERROR;
+PyObject *TEP_ERROR;
+PyObject *TRACECRUNCHER_ERROR;
+
+PyObject *PyTepRecord_time(PyTepRecord* self)
+{
+	unsigned long ts = self->ptrObj ? self->ptrObj->ts : 0;
+	return PyLong_FromLongLong(ts);
+}
+
+PyObject *PyTepRecord_cpu(PyTepRecord* self)
+{
+	int cpu = self->ptrObj ? self->ptrObj->cpu : -1;
+	return PyLong_FromLong(cpu);
+}
+
+PyObject *PyTepEvent_name(PyTepEvent* self)
+{
+	const char * name = self->ptrObj ? self->ptrObj->name : "nil";
+	return PyUnicode_FromString(name);
+}
+
+PyObject *PyTepEvent_id(PyTepEvent* self)
+{
+	int id = self->ptrObj ? self->ptrObj->id : -1;
+	return PyLong_FromLong(id);
+}
+
+PyObject *PyTepEvent_field_names(PyTepEvent* self)
+{
+	struct tep_format_field *field, **fields;
+	struct tep_event *event = self->ptrObj;
+	int i = 0, nr_fields;
+	PyObject *list;
+
+	nr_fields= event->format.nr_fields + event->format.nr_common;
+	list = PyList_New(nr_fields);
+
+	/* Get all common fields. */
+	fields = tep_event_common_fields(event);
+	if (!fields) {
+		PyErr_Format(TEP_ERROR,
+			     "Failed to get common fields for event \'%s\'",
+			     self->ptrObj->name);
+		return NULL;
+	}
+
+	for (field = *fields; field; field = field->next)
+		PyList_SET_ITEM(list, i++, PyUnicode_FromString(field->name));
+	free(fields);
+
+	/* Add all unique fields. */
+	fields = tep_event_fields(event);
+	if (!fields) {
+		PyErr_Format(TEP_ERROR,
+			     "Failed to get fields for event \'%s\'",
+			     self->ptrObj->name);
+		return NULL;
+	}
+
+	for (field = *fields; field; field = field->next)
+		PyList_SET_ITEM(list, i++, PyUnicode_FromString(field->name));
+	free(fields);
+
+	return list;
+}
+
+static bool is_number(struct tep_format_field *field)
+{
+	int number_field_mask = TEP_FIELD_IS_SIGNED |
+				TEP_FIELD_IS_LONG |
+				TEP_FIELD_IS_FLAG;
+
+	return !field->flags || field->flags & number_field_mask;
+}
+
+PyObject *PyTepEvent_parse_record_field(PyTepEvent* self, PyObject *args,
+							  PyObject *kwargs)
+{
+	struct tep_format_field *field;
+	const char *field_name;
+	PyTepRecord *record;
+
+	static char *kwlist[] = {"record", "field", NULL};
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"Os",
+					kwlist,
+					&record,
+					&field_name)) {
+		return NULL;
+	}
+
+	field = tep_find_field(self->ptrObj, field_name);
+	if (!field)
+		field = tep_find_common_field(self->ptrObj, field_name);
+
+	if (!field) {
+		PyErr_Format(TEP_ERROR,
+			     "Failed to find field \'%s\' in event \'%s\'",
+			     field_name, self->ptrObj->name);
+		return NULL;
+	}
+
+	if (!field->size)
+		return PyUnicode_FromString("(nil)");
+
+	if (field->flags & TEP_FIELD_IS_STRING) {
+		char *val_str = record->ptrObj->data + field->offset;
+		return PyUnicode_FromString(val_str);
+	} else if (is_number(field)) {
+		unsigned long long val;
+
+		tep_read_number_field(field, record->ptrObj->data, &val);
+		return PyLong_FromLong(val);
+	} else if (field->flags & TEP_FIELD_IS_POINTER) {
+		void *val = record->ptrObj->data + field->offset;
+		char ptr_string[11];
+
+		sprintf(ptr_string, "%p", val);
+		return PyUnicode_FromString(ptr_string);
+	}
+
+	PyErr_Format(TEP_ERROR,
+		     "Unsupported field format \"%li\" (TODO: implement this)",
+		     field->flags);
+	return NULL;
+}
+
+PyObject *PyTepEvent_get_pid(PyTepEvent* self, PyObject *args,
+					       PyObject *kwargs)
+{
+	static char *kwlist[] = {"record", NULL};
+	const char *field_name = "common_pid";
+	struct tep_format_field *field;
+	unsigned long long val = 0;
+	PyTepRecord *record;
+
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"O",
+					kwlist,
+					&record)) {
+		return NULL;
+	}
+
+	field = tep_find_common_field(self->ptrObj, field_name);
+	if (!field) {
+		PyErr_Format(TEP_ERROR,
+			     "Failed to find field \'s\' in event \'%s\'",
+			     field_name, self->ptrObj->name);
+		return NULL;
+	}
+
+	tep_read_number_field(field, record->ptrObj->data, &val);
+
+	return PyLong_FromLong(val);
+}
+
+static const char **get_arg_list(PyObject *py_list)
+{
+	const char **argv = NULL;
+	PyObject *arg_py;
+	int i, n;
+
+	if (!PyList_CheckExact(py_list))
+		goto fail;
+
+	n = PyList_Size(py_list);
+	argv = calloc(n + 1, sizeof(*argv));
+	for (i = 0; i < n; ++i) {
+		arg_py = PyList_GetItem(py_list, i);
+		if (!PyUnicode_Check(arg_py))
+			goto fail;
+
+		argv[i] = PyUnicode_DATA(arg_py);
+	}
+
+	return argv;
+
+ fail:
+	PyErr_SetString(TRACECRUNCHER_ERROR,
+			"Failed to parse argument list.");
+	free(argv);
+	return NULL;
+}
+
+PyObject *PyTep_init_local(PyTep *self, PyObject *args,
+					PyObject *kwargs)
+{
+	static char *kwlist[] = {"dir", "systems", NULL};
+	struct tep_handle *tep = NULL;
+	PyObject *system_list = NULL;
+	const char *dir_str;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "s|O",
+					 kwlist,
+					 &dir_str,
+					 &system_list)) {
+		return NULL;
+	}
+
+	if (system_list) {
+		const char **sys_names = get_arg_list(system_list);
+
+		if (!sys_names) {
+			PyErr_SetString(TFS_ERROR,
+					"Inconsistent \"systems\" argument.");
+			return NULL;
+		}
+
+		tep = tracefs_local_events_system(dir_str, sys_names);
+		free(sys_names);
+	} else {
+		tep = tracefs_local_events(dir_str);
+	}
+
+	if (!tep) {
+		PyErr_Format(TFS_ERROR,
+			     "Failed to get local events from \'%s\'.",
+			     dir_str);
+		return NULL;
+	}
+
+	tep_free(self->ptrObj);
+	self->ptrObj = tep;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyTep_get_event(PyTep *self, PyObject *args,
+				       PyObject *kwargs)
+{
+	static char *kwlist[] = {"system", "name", NULL};
+	const char *system, *event_name;
+	struct tep_event *event;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "ss",
+					 kwlist,
+					 &system,
+					 &event_name)) {
+		return NULL;
+	}
+
+	event = tep_find_event_by_name(self->ptrObj, system, event_name);
+
+	return PyTepEvent_New(event);
+}
+
+static bool check_file(struct tracefs_instance *instance, const char *file)
+{
+	if (!tracefs_file_exists(instance, file)) {
+		PyErr_Format(TFS_ERROR, "File %s does not exist.", file);
+		return false;
+	}
+
+	return true;
+}
+
+static bool check_dir(struct tracefs_instance *instance, const char *dir)
+{
+	if (!tracefs_dir_exists(instance, dir)) {
+		PyErr_Format(TFS_ERROR, "Directory %s does not exist.", dir);
+		return false;
+	}
+
+	return true;
+}
+
+const char *top_instance_name = "top";
+static const char *get_instance_name(struct tracefs_instance *instance)
+{
+	const char *name = tracefs_instance_get_name(instance);
+	return name ? name : top_instance_name;
+}
+
+static int write_to_file(struct tracefs_instance *instance,
+			 const char *file,
+			 const char *val)
+{
+	int size;
+
+	if (!check_file(instance, file))
+		return -1;
+
+	size = tracefs_instance_file_write(instance, file, val);
+	if (size <= 0) {
+		PyErr_Format(TFS_ERROR,
+			     "Can not write \'%s\' to file \'%s\' (inst: \'%s\').",
+			     val, file, get_instance_name(instance));
+		PyErr_Print();
+	}
+
+	return size;
+}
+
+static int append_to_file(struct tracefs_instance *instance,
+			  const char *file,
+			  const char *val)
+{
+	int size;
+
+	if (!check_file(instance, file))
+		return -1;
+
+	size = tracefs_instance_file_append(instance, file, val);
+	if (size <= 0) {
+		PyErr_Format(TFS_ERROR,
+			     "Can not append \'%s\' to file \'%s\' (inst: \'%s\').",
+			     val, file, get_instance_name(instance));
+		PyErr_Print();
+	}
+
+	return size;
+}
+
+static int read_from_file(struct tracefs_instance *instance,
+			  const char *file,
+			  char **val)
+{
+	int size;
+
+	if (!check_file(instance, file))
+		return -1;
+
+	*val = tracefs_instance_file_read(instance, file, &size);
+	if (size < 0)
+		PyErr_Format(TFS_ERROR, "Can not read from file %s", file);
+
+	return size;
+}
+
+static inline void trim_new_line(char *val)
+{
+	val[strlen(val) - 1] = '\0';
+}
+
+static bool write_to_file_and_check(struct tracefs_instance *instance,
+				    const char *file,
+				    const char *val)
+{
+	char *read_val;
+	int ret;
+
+	if (write_to_file(instance, file, val) <= 0)
+		return false;
+
+	if (read_from_file(instance, file, &read_val) <= 0)
+		return false;
+
+	trim_new_line(read_val);
+	ret = strcmp(read_val, val);
+	free(read_val);
+
+	return ret == 0 ? true : false;
+}
+
+static PyObject *tfs_list2py_list(char **list)
+{
+	PyObject *py_list = PyList_New(0);
+	int i;
+
+	for (i = 0; list && list[i]; i++)
+		PyList_Append(py_list, PyUnicode_FromString(list[i]));
+
+	tracefs_list_free(list);
+
+	return py_list;
+}
+
+struct instance_wrapper {
+	struct tracefs_instance *ptr;
+	const char *name;
+};
+
+const char *instance_wrapper_get_name(const struct instance_wrapper *iw)
+{
+	if (!iw->ptr)
+		return iw->name;
+
+	return tracefs_instance_get_name(iw->ptr);
+}
+
+static int instance_compare(const void *a, const void *b)
+{
+	const struct instance_wrapper *iwa, *iwb;
+
+	iwa = (const struct instance_wrapper *) a;
+	iwb = (const struct instance_wrapper *) b;
+
+	return strcmp(instance_wrapper_get_name(iwa),
+		      instance_wrapper_get_name(iwb));
+}
+
+void instance_wrapper_free(void *ptr)
+{
+	struct instance_wrapper *iw;
+	if (!ptr)
+		return;
+
+	iw = ptr;
+	if (iw->ptr)
+		tracefs_instance_destroy(iw->ptr);
+
+	free(ptr);
+}
+
+static void destroy_all_instances(void)
+{
+	tdestroy(instance_root, instance_wrapper_free);
+	instance_root = NULL;
+}
+
+static struct tracefs_instance *find_instance(const char *name)
+{
+	struct instance_wrapper iw, **iw_ptr;
+	if (!is_set(name))
+		return NULL;
+
+	if (!tracefs_instance_exists(name)) {
+		PyErr_Format(TFS_ERROR, "Trace instance \'%s\' does not exist.",
+			     name);
+		return NULL;
+	}
+
+	iw.ptr = NULL;
+	iw.name = name;
+	iw_ptr = tfind(&iw, &instance_root, instance_compare);
+	if (!iw_ptr || !(*iw_ptr) || !(*iw_ptr)->ptr ||
+	    strcmp(tracefs_instance_get_name((*iw_ptr)->ptr), name) != 0) {
+		PyErr_Format(TFS_ERROR, "Unable to find trace instances \'%s\'.",
+			     name);
+		return NULL;
+	}
+
+	return (*iw_ptr)->ptr;
+}
+
+bool get_optional_instance(const char *instance_name,
+			   struct tracefs_instance **instance)
+{
+	*instance = NULL;
+	if (is_set(instance_name)) {
+		*instance = find_instance(instance_name);
+		if (!instance) {
+			PyErr_Format(TFS_ERROR,
+				     "Failed to find instance \'%s\'.",
+				     instance_name);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+bool get_instance_from_arg(PyObject *args, PyObject *kwargs,
+			   struct tracefs_instance **instance)
+{
+	const char *instance_name;
+
+	static char *kwlist[] = {"instance", NULL};
+	instance_name = NO_ARG;
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"|s",
+					kwlist,
+					&instance_name)) {
+		return false;
+	}
+
+	if (!get_optional_instance(instance_name, instance))
+		return false;
+
+	return true;
+}
+
+PyObject *PyFtrace_dir(PyObject *self)
+{
+	return PyUnicode_FromString(tracefs_tracing_dir());
+}
+
+PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
+						   PyObject *kwargs)
+{
+	struct instance_wrapper *iw, **iw_ptr;
+	struct tracefs_instance *instance;
+	const char *name = NO_ARG;
+
+	static char *kwlist[] = {"name", NULL};
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"s",
+					kwlist,
+					&name)) {
+		return NULL;
+	}
+
+	if (!is_set(name)) {
+		PyErr_Format(TFS_ERROR,
+			     "\'%s\' is not a valid name for trace instance.",
+			     name);
+		return NULL;
+	}
+
+	instance = tracefs_instance_create(name);
+	if (!instance ||
+	    !tracefs_instance_exists(name) ||
+	    !tracefs_instance_is_new(instance)) {
+		PyErr_Format(TFS_ERROR,
+			     "Failed to create new trace instance \'%s\'.",
+			     name);
+		return NULL;
+	}
+
+	iw = calloc(1, sizeof(*iw));
+	if (!iw) {
+		MEM_ERROR
+		return NULL;
+	}
+
+	iw->ptr = instance;
+	iw_ptr = tsearch(iw, &instance_root, instance_compare);
+	if (!iw_ptr || !(*iw_ptr) || !(*iw_ptr)->ptr ||
+	    strcmp(tracefs_instance_get_name((*iw_ptr)->ptr), name) != 0) {
+		PyErr_Format(TFS_ERROR,
+			     "Failed to store new trace instance \'%s\'.",
+			     name);
+		tracefs_instance_destroy(instance);
+		tracefs_instance_free(instance);
+		free(iw);
+
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_destroy_instance(PyObject *self, PyObject *args,
+						    PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+	struct instance_wrapper iw;
+	char *name;
+
+	static char *kwlist[] = {"name", NULL};
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"s",
+					kwlist,
+					&name)) {
+		return NULL;
+	}
+
+	if (is_all(name)) {
+		destroy_all_instances();
+		Py_RETURN_NONE;
+	}
+
+	instance = find_instance(name);
+	if (!instance) {
+		PyErr_Format(TFS_ERROR,
+			     "Unable to destroy trace instances \'%s\'.",
+			     name);
+		return NULL;
+	}
+
+	iw.ptr = NULL;
+	iw.name = name;
+	tdelete(&iw, &instance_root, instance_compare);
+
+	tracefs_instance_destroy(instance);
+	tracefs_instance_free(instance);
+
+	Py_RETURN_NONE;
+}
+
+PyObject *instance_list;
+
+static void instance_action(const void *nodep, VISIT which, int depth)
+{
+	struct instance_wrapper *iw = *( struct instance_wrapper **) nodep;
+	const char *name;
+
+	switch(which) {
+	case preorder:
+	case endorder:
+		break;
+
+	case postorder:
+	case leaf:
+		name = tracefs_instance_get_name(iw->ptr);
+		PyList_Append(instance_list, PyUnicode_FromString(name));
+		break;
+	}
+}
+
+PyObject *PyFtrace_get_all_instances(PyObject *self)
+{
+	instance_list = PyList_New(0);
+	twalk(instance_root, instance_action);
+
+	return instance_list;
+}
+
+PyObject *PyFtrace_destroy_all_instances(PyObject *self)
+{
+	destroy_all_instances();
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_instance_dir(PyObject *self, PyObject *args,
+						PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	return PyUnicode_FromString(tracefs_instance_get_dir(instance));
+}
+
+PyObject *PyFtrace_available_tracers(PyObject *self, PyObject *args,
+						     PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+	char **list;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	list = tracefs_tracers(tracefs_instance_get_dir(instance));
+	if (!list)
+		return NULL;
+
+	return tfs_list2py_list(list);
+}
+
+PyObject *PyFtrace_set_current_tracer(PyObject *self, PyObject *args,
+						      PyObject *kwargs)
+{
+	const char *file = "current_tracer", *tracer, *instance_name;
+	struct tracefs_instance *instance;
+
+	static char *kwlist[] = {"tracer", "instance", NULL};
+	tracer = instance_name = NO_ARG;
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"|ss",
+					kwlist,
+					&tracer,
+					&instance_name)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	if (is_set(tracer) &&
+	    strcmp(tracer, "nop") != 0) {
+		char **all_tracers =
+			tracefs_tracers(tracefs_instance_get_dir(instance));
+		int i;
+
+		for (i = 0; all_tracers && all_tracers[i]; i++) {
+			if (!strcmp(all_tracers[i], tracer))
+				break;
+		}
+
+		if (!all_tracers || !all_tracers[i]) {
+			PyErr_Format(TFS_ERROR,
+				     "Tracer \'%s\' is not available.",
+				     tracer);
+			return NULL;
+		}
+	} else if (!is_set(tracer)) {
+		tracer = "nop";
+	}
+
+	if (!write_to_file_and_check(instance, file, tracer)) {
+		PyErr_Format(TFS_ERROR, "Failed to enable tracer \'%s\'",
+			     tracer);
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_get_current_tracer(PyObject *self, PyObject *args,
+						      PyObject *kwargs)
+{
+	const char *file = "current_tracer";
+	struct tracefs_instance *instance;
+	PyObject *ret;
+	char *tracer;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	if (read_from_file(instance, file, &tracer) <= 0)
+		return NULL;
+
+	trim_new_line(tracer);
+	ret = PyUnicode_FromString(tracer);
+	free(tracer);
+
+	return ret;
+}
+
+PyObject *PyFtrace_available_event_systems(PyObject *self, PyObject *args,
+							   PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+	char **list;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	list = tracefs_event_systems(tracefs_instance_get_dir(instance));
+	if (!list)
+		return NULL;
+
+	return tfs_list2py_list(list);
+}
+
+PyObject *PyFtrace_available_system_events(PyObject *self, PyObject *args,
+							   PyObject *kwargs)
+{
+	static char *kwlist[] = {"system", "instance", NULL};
+	const char *instance_name = NO_ARG, *system;
+	struct tracefs_instance *instance;
+	char **list;
+
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"s|s",
+					kwlist,
+					&system,
+					&instance_name)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	list = tracefs_system_events(tracefs_instance_get_dir(instance),
+				     system);
+	if (!list)
+		return NULL;
+
+	return tfs_list2py_list(list);
+}
+
+bool get_event_enable_file(struct tracefs_instance *instance,
+			   const char *system, const char *event,
+			   char **path)
+{
+	char *buff = calloc(PATH_MAX, 1);
+	const char *instance_name;
+
+	 if (!buff) {
+		MEM_ERROR
+		return false;
+	}
+
+	if ((is_all(system) && is_all(event)) ||
+	    (is_all(system) && is_no_arg(event)) ||
+	    (is_no_arg(system) && is_all(event))) {
+		strcpy(buff, "events/enable");
+
+		*path = buff;
+	} else if (is_set(system)) {
+		strcpy(buff, "events/");
+		strcat(buff, system);
+		if (!check_dir(instance, buff))
+			goto fail;
+
+		if (is_set(event)) {
+			strcat(buff, "/");
+			strcat(buff, event);
+			if (!check_dir(instance, buff))
+				goto fail;
+
+			strcat(buff, "/enable");
+		} else {
+			strcat(buff, "/enable");
+		}
+
+		*path = buff;
+	} else {
+		goto fail;
+	}
+
+	return true;
+
+ fail:
+	instance_name =
+		instance ? tracefs_instance_get_name(instance) : "top";
+	PyErr_Format(TFS_ERROR,
+		     "Failed to locate event:\n Instance: %s  System: %s  Event: %s",
+		     instance_name, system, event);
+	free(buff);
+	*path = NULL;
+	return false;
+}
+
+#define REGEX_SYMBOLS "*+^$?|.,:{}[]"
+
+static bool is_regex(const char *str)
+{
+	return str && strpbrk(str, REGEX_SYMBOLS);
+}
+
+static bool event_enable_disable(struct tracefs_instance *instance,
+				 const char *system, const char *event,
+				 bool enable, bool regex)
+{
+	char *sys = NULL, *evt = NULL;
+	int ret;
+
+	if (system && !is_set(system))
+		system = NULL;
+
+	if (event && !is_set(event))
+		event = NULL;
+
+	if (!regex) {
+		/* No "regex" pattern searching.*/
+		if (is_regex(system)) {
+			PyErr_Format(TFS_ERROR,
+				    "Regex symbols used in system=\'%s\' when regex is disabled.",
+				    system);
+			return false;
+		}
+		if (is_regex(event)) {
+			PyErr_Format(TFS_ERROR,
+				    "Regex symbols used in event=\'%s\' when regex is disabled.",
+				    event);
+			return false;
+		}
+
+		/* Enforce exact matching. */
+		if (event) {
+			if(asprintf(&evt, "^%s$", event) <= 0) {
+				MEM_ERROR
+				return false;
+			}
+			event = evt;
+		}
+
+		if (system) {
+			if(asprintf(&sys, "^%s$", system) <= 0) {
+				MEM_ERROR
+				return false;
+			}
+			system = sys;
+		}
+	}
+
+	if (enable)
+		ret = tracefs_event_enable(instance, system, event);
+	else
+		ret = tracefs_event_disable(instance, system, event);
+
+	free(evt);
+	free(sys);
+
+	if (ret == 0)
+		return true;
+
+	PyErr_Format(TFS_ERROR,
+		     "Failed to enable/disable event:\n System: %s  Event: %s",
+		     system ? system : "NULL",
+		     event ? event : "NULL");
+
+	return false;
+}
+
+static bool set_enable_event(PyObject *self,
+			     PyObject *args, PyObject *kwargs,
+			     bool enable)
+{
+	static char *kwlist[] = {"instance", "system", "event", "regex", NULL};
+	const char *instance_name, *system, *event;
+	struct tracefs_instance *instance;
+	int regex = 0;
+
+	instance_name = system = event = NO_ARG;
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"|sssp",
+					kwlist,
+					&instance_name,
+					&system,
+					&event,
+					&regex)) {
+		return false;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return false;
+
+	return event_enable_disable(instance, system, event, enable, regex);
+}
+
+#define ON	"1"
+#define OFF	"0"
+
+PyObject *PyFtrace_enable_event(PyObject *self, PyObject *args,
+						PyObject *kwargs)
+{
+	if (!set_enable_event(self, args, kwargs, true))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_disable_event(PyObject *self, PyObject *args,
+						 PyObject *kwargs)
+{
+	if (!set_enable_event(self, args, kwargs, false))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+static bool set_enable_events(PyObject *self, PyObject *args, PyObject *kwargs,
+			      bool enable)
+{
+	static char *kwlist[] = {"instance", "systems", "events", "regex", NULL};
+	PyObject *system_list = NULL, *event_list = NULL, *system_event_list;
+	const char **systems = NULL, **events = NULL;
+	struct tracefs_instance *instance;
+	const char *instance_name;
+	char *file = NULL;
+	int regex = 0;
+	int ret;
+
+	instance_name = NO_ARG;
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"|sOOp",
+					kwlist,
+					&instance_name,
+					&system_list,
+					&event_list,
+					&regex)) {
+		return false;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return false;
+
+	if (!system_list && !event_list)
+		return event_enable_disable(instance, NULL, NULL, enable, regex);
+
+	if (!system_list && event_list) {
+		if (PyUnicode_Check(event_list) &&
+		    is_all(PyUnicode_DATA(event_list))) {
+			return event_enable_disable(instance, NULL, NULL, enable, regex);
+		} else {
+			PyErr_SetString(TFS_ERROR,
+					"Failed to enable events for unspecified system");
+			return false;
+		}
+	}
+
+	systems = get_arg_list(system_list);
+	if (!systems) {
+		PyErr_SetString(TFS_ERROR, "Inconsistent \"systems\" argument.");
+		return false;
+	}
+
+	if (!event_list) {
+		for (int s = 0; systems[s]; ++s) {
+			ret = event_enable_disable(instance, systems[s], NULL,
+						   enable, regex);
+			if (ret < 0)
+				return false;
+		}
+
+		return true;
+	}
+
+	if (!PyList_CheckExact(event_list))
+		goto fail_with_err;
+
+	for (int s = 0; systems[s]; ++s) {
+		system_event_list = PyList_GetItem(event_list, s);
+		if (!system_event_list || !PyList_CheckExact(system_event_list))
+			goto fail_with_err;
+
+		events = get_arg_list(system_event_list);
+		if (!events)
+			goto fail_with_err;
+
+		for (int e = 0; events[e]; ++e) {
+			if (!event_enable_disable(instance, systems[s], events[e],
+						  enable, regex))
+				goto fail;
+		}
+
+		free(events);
+		events = NULL;
+	}
+
+	free(systems);
+
+	return true;
+
+ fail_with_err:
+	PyErr_SetString(TFS_ERROR, "Inconsistent \"events\" argument.");
+
+ fail:
+	free(systems);
+	free(events);
+	free(file);
+
+	return false;
+}
+
+PyObject *PyFtrace_enable_events(PyObject *self, PyObject *args,
+						 PyObject *kwargs)
+{
+	if (!set_enable_events(self, args, kwargs, true))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_disable_events(PyObject *self, PyObject *args,
+						  PyObject *kwargs)
+{
+	if (!set_enable_events(self, args, kwargs, false))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_event_is_enabled(PyObject *self, PyObject *args,
+						    PyObject *kwargs)
+{
+	static char *kwlist[] = {"instance", "system", "event", NULL};
+	const char *instance_name, *system, *event;
+	struct tracefs_instance *instance;
+	char *file, *val;
+	PyObject *ret;
+
+	instance_name = system = event = NO_ARG;
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"|sss",
+					kwlist,
+					&instance_name,
+					&system,
+					&event)) {
+		return false;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return false;
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
+PyObject *PyFtrace_set_event_filter(PyObject *self, PyObject *args,
+						    PyObject *kwargs)
+{
+	const char *instance_name = NO_ARG, *system, *event, *filter;
+	struct tracefs_instance *instance;
+	char path[PATH_MAX];
+
+	static char *kwlist[] = {"system", "event", "filter", "instance", NULL};
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"sss|s",
+					kwlist,
+					&system,
+					&event,
+					&filter,
+					&instance_name)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	sprintf(path, "events/%s/%s/filter", system, event);
+	if (!write_to_file_and_check(instance, path, filter)) {
+		PyErr_SetString(TFS_ERROR, "Failed to set event filter");
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_clear_event_filter(PyObject *self, PyObject *args,
+						      PyObject *kwargs)
+{
+	const char *instance_name = NO_ARG, *system, *event;
+	struct tracefs_instance *instance;
+	char path[PATH_MAX];
+
+	static char *kwlist[] = {"system", "event", "instance", NULL};
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"ss|s",
+					kwlist,
+					&system,
+					&event,
+					&instance_name)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	sprintf(path, "events/%s/%s/filter", system, event);
+	if (!write_to_file(instance, path, OFF)) {
+		PyErr_SetString(TFS_ERROR, "Failed to clear event filter");
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
+static bool tracing_ON(struct tracefs_instance *instance)
+{
+	int ret = tracefs_trace_on(instance);
+
+	if (ret < 0 ||
+	    tracefs_trace_is_on(instance) != 1) {
+		const char *instance_name =
+			instance ? tracefs_instance_get_name(instance) : "top";
+
+		PyErr_Format(TFS_ERROR,
+			     "Failed to start tracing (Instance: %s)",
+			     instance_name);
+		return false;
+	}
+
+	return true;
+}
+
+PyObject *PyFtrace_tracing_ON(PyObject *self, PyObject *args,
+					      PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	if (!tracing_ON(instance))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+static bool tracing_OFF(struct tracefs_instance *instance)
+{
+	int ret = tracefs_trace_off(instance);
+
+	if (ret < 0 ||
+	    tracefs_trace_is_on(instance) != 0) {
+		const char *instance_name =
+			instance ? tracefs_instance_get_name(instance) : "top";
+
+		PyErr_Format(TFS_ERROR,
+			     "Failed to stop tracing (Instance: %s)",
+			     instance_name);
+		return false;
+	}
+
+	return true;
+}
+
+PyObject *PyFtrace_tracing_OFF(PyObject *self, PyObject *args,
+					       PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	if (!tracing_OFF(instance))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_is_tracing_ON(PyObject *self, PyObject *args,
+						 PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+	int ret;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	ret = tracefs_trace_is_on(instance);
+	if (ret < 0) {
+		const char *instance_name =
+			instance ? tracefs_instance_get_name(instance) : "top";
+
+		PyErr_Format(TFS_ERROR,
+			     "Failed to check if tracing is ON (Instance: %s)",
+			     instance_name);
+		return NULL;
+	}
+
+	if (ret == 0)
+		Py_RETURN_FALSE;
+
+	Py_RETURN_TRUE;
+}
+
+static bool pid2file(struct tracefs_instance *instance,
+		     const char *file,
+		     int pid,
+		     bool append)
+{
+	char pid_str[100];
+
+	if (sprintf(pid_str, "%d", pid) <= 0)
+		return false;
+
+	if (append) {
+		if (!append_to_file(instance, file, pid_str))
+		        return false;
+	} else {
+		if (!write_to_file_and_check(instance, file, pid_str))
+		        return false;
+	}
+
+	return true;
+}
+
+static bool set_pid(struct tracefs_instance *instance,
+		    const char *file, PyObject *pid_val)
+{
+	PyObject *item;
+	int n, i, pid;
+
+	if (PyList_CheckExact(pid_val)) {
+		n = PyList_Size(pid_val);
+		for (i = 0; i < n; ++i) {
+			item = PyList_GetItem(pid_val, i);
+			if (!PyLong_CheckExact(item))
+				goto fail;
+
+			pid = PyLong_AsLong(item);
+			if (!pid2file(instance, file, pid, true))
+				goto fail;
+		}
+	} else if (PyLong_CheckExact(pid_val)) {
+		pid = PyLong_AsLong(pid_val);
+		if (!pid2file(instance, file, pid, true))
+			goto fail;
+	} else {
+		goto fail;
+	}
+
+	return true;
+
+ fail:
+	PyErr_Format(TFS_ERROR, "Failed to set PIDs for \"%s\"",
+		     file);
+	return false;
+}
+
+PyObject *PyFtrace_set_event_pid(PyObject *self, PyObject *args,
+						 PyObject *kwargs)
+{
+	const char *instance_name = NO_ARG;
+	struct tracefs_instance *instance;
+	PyObject *pid_val;
+
+	static char *kwlist[] = {"pid", "instance", NULL};
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"O|s",
+					kwlist,
+					&pid_val,
+					&instance_name)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	if (!set_pid(instance, "set_event_pid", pid_val))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_set_ftrace_pid(PyObject *self, PyObject *args,
+						  PyObject *kwargs)
+{
+	const char *instance_name = NO_ARG;
+	struct tracefs_instance *instance;
+	PyObject *pid_val;
+
+	static char *kwlist[] = {"pid", "instance", NULL};
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"O|s",
+					kwlist,
+					&pid_val,
+					&instance_name)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	if (!set_pid(instance, "set_ftrace_pid", pid_val))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+static bool set_opt(struct tracefs_instance *instance,
+		    const char *opt, const char *val)
+{
+	char file[PATH_MAX];
+
+	if (sprintf(file, "options/%s", opt) <= 0 ||
+	    !write_to_file_and_check(instance, file, val)) {
+		PyErr_Format(TFS_ERROR, "Failed to set option \"%s\"", opt);
+		return false;
+	}
+
+	return true;
+}
+
+static PyObject *set_option_py_args(PyObject *args, PyObject *kwargs,
+				   const char *val)
+{
+	const char *instance_name = NO_ARG, *opt;
+	struct tracefs_instance *instance;
+
+	static char *kwlist[] = {"option", "instance", NULL};
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"s|s",
+					kwlist,
+					&opt,
+					&instance_name)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	if (!set_opt(instance, opt, val))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_enable_option(PyObject *self, PyObject *args,
+						 PyObject *kwargs)
+{
+	return set_option_py_args(args, kwargs, ON);
+}
+
+PyObject *PyFtrace_disable_option(PyObject *self, PyObject *args,
+						  PyObject *kwargs)
+{
+	return set_option_py_args(args, kwargs, OFF);
+}
+
+PyObject *PyFtrace_option_is_set(PyObject *self, PyObject *args,
+						 PyObject *kwargs)
+{
+	const char *instance_name = NO_ARG, *opt;
+	struct tracefs_instance *instance;
+	enum tracefs_option_id opt_id;
+
+	static char *kwlist[] = {"option", "instance", NULL};
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"s|s",
+					kwlist,
+					&opt,
+					&instance_name)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	opt_id = tracefs_option_id(opt);
+	if (tracefs_option_is_enabled(instance, opt_id))
+		Py_RETURN_TRUE;
+
+	Py_RETURN_FALSE;
+}
+
+static PyObject *get_option_list(struct tracefs_instance *instance,
+				 bool enabled)
+{
+	const struct tracefs_options_mask *mask;
+	PyObject *list = PyList_New(0);
+	int i;
+
+	mask = enabled ? tracefs_options_get_enabled(instance) :
+			 tracefs_options_get_supported(instance);
+
+	for (i = 0; i < TRACEFS_OPTION_MAX; ++i)
+		if (tracefs_option_mask_is_set(mask, i)) {
+			const char *opt = tracefs_option_name(i);
+			PyList_Append(list, PyUnicode_FromString(opt));
+		}
+
+	return list;
+}
+
+PyObject *PyFtrace_enabled_options(PyObject *self, PyObject *args,
+						   PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	return get_option_list(instance, true);
+}
+
+PyObject *PyFtrace_supported_options(PyObject *self, PyObject *args,
+						     PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	return get_option_list(instance, false);
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
+static bool set_fork_options(struct tracefs_instance *instance, bool enable)
+{
+	if (enable) {
+		if (tracefs_option_enable(instance, TRACEFS_OPTION_EVENT_FORK) < 0 ||
+		    tracefs_option_enable(instance, TRACEFS_OPTION_FUNCTION_FORK) < 0)
+			return false;
+	} else {
+		if (tracefs_option_disable(instance, TRACEFS_OPTION_EVENT_FORK) < 0 ||
+		    tracefs_option_disable(instance, TRACEFS_OPTION_FUNCTION_FORK) < 0)
+			return false;
+	}
+
+	return true;
+}
+
+static bool hook2pid(struct tracefs_instance *instance, PyObject *pid_val, int fork)
+{
+	if (!set_pid(instance, "set_ftrace_pid", pid_val) ||
+	    !set_pid(instance, "set_event_pid", pid_val))
+		goto fail;
+
+	if (fork < 0)
+		return true;
+
+	if (!set_fork_options(instance, fork))
+		goto fail;
+
+	return true;
+
+ fail:
+	PyErr_SetString(TFS_ERROR, "Failed to hook to PID");
+	PyErr_Print();
+	return false;
+}
+
+static void start_tracing_procces(struct tracefs_instance *instance,
+				  char **argv, char **env)
+{
+	PyObject *pid_val = PyList_New(1);
+
+	PyList_SET_ITEM(pid_val, 0, PyLong_FromLong(getpid()));
+	if(!hook2pid(instance, pid_val, true))
+		exit(1);
+
+	tracing_ON(instance);
+	if (execve(argv[0], argv, env) < 0) {
+		PyErr_Format(TFS_ERROR, "Failed to exec \'%s\'",
+			     argv[0]);
+	}
+
+	exit(1);
+}
+
+struct callback_context {
+	void	*py_callback;
+
+	bool	status;
+} callback_ctx;
+
+static void finish(int sig)
+{
+	callback_ctx.status = false;
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
+	ret = PyObject_CallObject((PyObject *) ctx->py_callback, arglist);
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
+	py_func = get_callback_func(plugin, py_callback);
+	if (!py_func)
+		return NULL;
+
+	if (!get_optional_instance(instance_name, &instance))
+		return NULL;
+
+	tep = tracefs_local_events(tracefs_instance_get_dir(instance));
+
+	char *argv[] = {getenv("SHELL"), "-c", process, NULL};
+	char *env[] = {NULL};
+
+	pid = fork();
+	if (pid < 0) {
+		PyErr_SetString(TFS_ERROR, "Failed to fork");
+		return NULL;
+	}
+
+	if (pid == 0)
+		start_tracing_procces(instance, argv, env);
+
+	callback_ctx.py_callback = py_func;
+	callback_ctx.status = true;
+	do {
+		tracefs_iterate_raw_events(tep, instance, NULL, 0,
+					   callback, &callback_ctx);
+	} while (waitpid(pid, NULL, WNOHANG) != pid);
+
+	Py_RETURN_NONE;
+}
+
+static char *get_file_from_pid(int pid)
+{
+	char *name_file, exe[PATH_MAX], *buff;
+	int fd, r;
+
+	if (asprintf(&name_file, "/proc/%i/cmdline", pid) <= 0) {
+		MEM_ERROR
+		return NULL;
+	}
+
+	fd = open(name_file, O_RDONLY);
+	free(name_file);
+	if (fd < 0)
+		return NULL;
+
+	r = read(fd, exe, PATH_MAX);
+	close(fd);
+	if (r <= 0)
+		return NULL;
+
+	if (asprintf(&buff, "%s", exe) <= 0) {
+		MEM_ERROR
+		return NULL;
+	}
+
+	return buff;
+}
+
+PyObject *PyFtrace_file_from_pid(PyObject *self, PyObject *args,
+						 PyObject *kwargs)
+{
+	static char *kwlist[] = {"pid", NULL};
+	PyObject *file;
+	char *file_str;
+	int pid;
+
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"i",
+					kwlist,
+					&pid)) {
+		return NULL;
+	}
+
+	file_str = get_file_from_pid(pid);
+	if (file_str) {
+		file = PyUnicode_FromString(file_str);
+		free(file_str);
+	} else {
+		file = PyUnicode_FromString("(nil)");
+	}
+
+	return file;
+}
+
+void PyFtrace_at_exit(void)
+{
+	destroy_all_instances();
+}
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
new file mode 100644
index 0000000..2677cf4
--- /dev/null
+++ b/src/ftracepy-utils.h
@@ -0,0 +1,144 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2021 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+#ifndef _TC_FTRACE_PY_UTILS
+#define _TC_FTRACE_PY_UTILS
+
+// Python
+#include <Python.h>
+
+// libtracefs
+#include "tracefs.h"
+
+// trace-cruncher
+#include "common.h"
+
+C_OBJECT_WRAPPER_DECLARE(tep_record, PyTepRecord)
+
+C_OBJECT_WRAPPER_DECLARE(tep_event, PyTepEvent)
+
+C_OBJECT_WRAPPER_DECLARE(tep_handle, PyTep)
+
+PyObject *PyTepRecord_time(PyTepRecord* self);
+
+PyObject *PyTepRecord_cpu(PyTepRecord* self);
+
+PyObject *PyTepEvent_name(PyTepEvent* self);
+
+PyObject *PyTepEvent_id(PyTepEvent* self);
+
+PyObject *PyTepEvent_field_names(PyTepEvent* self);
+
+PyObject *PyTepEvent_parse_record_field(PyTepEvent* self, PyObject *args,
+							  PyObject *kwargs);
+
+PyObject *PyTepEvent_get_pid(PyTepEvent* self, PyObject *args,
+					       PyObject *kwargs);
+
+PyObject *PyTep_init_local(PyTep *self, PyObject *args,
+					PyObject *kwargs);
+
+PyObject *PyTep_get_event(PyTep *self, PyObject *args,
+				       PyObject *kwargs);
+
+PyObject *PyFtrace_dir(PyObject *self);
+
+PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
+						   PyObject *kwargs);
+
+PyObject *PyFtrace_destroy_instance(PyObject *self, PyObject *args,
+						    PyObject *kwargs);
+
+PyObject *PyFtrace_get_all_instances(PyObject *self);
+
+PyObject *PyFtrace_destroy_all_instances(PyObject *self);
+
+PyObject *PyFtrace_instance_dir(PyObject *self, PyObject *args,
+						PyObject *kwargs);
+
+PyObject *PyFtrace_available_tracers(PyObject *self, PyObject *args,
+						     PyObject *kwargs);
+
+PyObject *PyFtrace_set_current_tracer(PyObject *self, PyObject *args,
+						      PyObject *kwargs);
+
+PyObject *PyFtrace_get_current_tracer(PyObject *self, PyObject *args,
+						      PyObject *kwargs);
+
+PyObject *PyFtrace_available_event_systems(PyObject *self, PyObject *args,
+							   PyObject *kwargs);
+
+PyObject *PyFtrace_available_system_events(PyObject *self, PyObject *args,
+							   PyObject *kwargs);
+
+PyObject *PyFtrace_enable_event(PyObject *self, PyObject *args,
+						PyObject *kwargs);
+
+PyObject *PyFtrace_disable_event(PyObject *self, PyObject *args,
+						 PyObject *kwargs);
+
+PyObject *PyFtrace_enable_events(PyObject *self, PyObject *args,
+						 PyObject *kwargs);
+
+PyObject *PyFtrace_disable_events(PyObject *self, PyObject *args,
+						  PyObject *kwargs);
+
+PyObject *PyFtrace_event_is_enabled(PyObject *self, PyObject *args,
+						    PyObject *kwargs);
+
+PyObject *PyFtrace_set_event_filter(PyObject *self, PyObject *args,
+						    PyObject *kwargs);
+
+PyObject *PyFtrace_clear_event_filter(PyObject *self, PyObject *args,
+						      PyObject *kwargs);
+
+PyObject *PyFtrace_tracing_ON(PyObject *self, PyObject *args,
+					      PyObject *kwargs);
+
+PyObject *PyFtrace_tracing_OFF(PyObject *self, PyObject *args,
+					       PyObject *kwargs);
+
+PyObject *PyFtrace_is_tracing_ON(PyObject *self, PyObject *args,
+						 PyObject *kwargs);
+
+PyObject *PyFtrace_set_event_pid(PyObject *self, PyObject *args,
+						 PyObject *kwargs);
+
+PyObject *PyFtrace_set_ftrace_pid(PyObject *self, PyObject *args,
+						  PyObject *kwargs);
+
+PyObject *PyFtrace_enable_option(PyObject *self, PyObject *args,
+						 PyObject *kwargs);
+
+PyObject *PyFtrace_disable_option(PyObject *self, PyObject *args,
+						  PyObject *kwargs);
+
+PyObject *PyFtrace_option_is_set(PyObject *self, PyObject *args,
+						 PyObject *kwargs);
+
+PyObject *PyFtrace_supported_options(PyObject *self, PyObject *args,
+						     PyObject *kwargs);
+
+PyObject *PyFtrace_enabled_options(PyObject *self, PyObject *args,
+						   PyObject *kwargs);
+
+PyObject *PyFtrace_trace_shell_process(PyObject *self, PyObject *args,
+						       PyObject *kwargs);
+
+PyObject *PyFtrace_read_trace(PyObject *self, PyObject *args,
+					      PyObject *kwargs);
+
+PyObject *PyFtrace_pid_from_stat(PyObject *self, PyObject *args,
+						 PyObject *kwargs);
+
+PyObject *PyFtrace_file_from_pid(PyObject *self, PyObject *args,
+						 PyObject *kwargs);
+
+PyObject *PyFtrace_hook2pid(PyObject *self, PyObject *args, PyObject *kwargs);
+
+void PyFtrace_at_exit(void);
+
+#endif
diff --git a/src/ftracepy.c b/src/ftracepy.c
new file mode 100644
index 0000000..53b1c62
--- /dev/null
+++ b/src/ftracepy.c
@@ -0,0 +1,292 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+// trace-cruncher
+#include "ftracepy-utils.h"
+
+extern PyObject *TFS_ERROR;
+extern PyObject *TEP_ERROR;
+extern PyObject *TRACECRUNCHER_ERROR;
+
+static PyMethodDef PyTepRecord_methods[] = {
+	{"time",
+	 (PyCFunction) PyTepRecord_time,
+	 METH_NOARGS,
+	 "Get the time of the record."
+	},
+	{"CPU",
+	 (PyCFunction) PyTepRecord_cpu,
+	 METH_NOARGS,
+	 "Get the CPU Id of the record."
+	},
+	{NULL}
+};
+
+C_OBJECT_WRAPPER(tep_record, PyTepRecord, NO_FREE)
+
+static PyMethodDef PyTepEvent_methods[] = {
+	{"name",
+	 (PyCFunction) PyTepEvent_name,
+	 METH_NOARGS,
+	 "Get the name of the event."
+	},
+	{"id",
+	 (PyCFunction) PyTepEvent_id,
+	 METH_NOARGS,
+	 "Get the unique identifier of the event."
+	},
+	{"field_names",
+	 (PyCFunction) PyTepEvent_field_names,
+	 METH_NOARGS,
+	 "Get the names of all fields."
+	},
+	{"parse_record_field",
+	 (PyCFunction) PyTepEvent_parse_record_field,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get the content of a record field."
+	},
+	{"get_pid",
+	 (PyCFunction) PyTepEvent_get_pid,
+	 METH_VARARGS | METH_KEYWORDS,
+	},
+	{NULL}
+};
+
+C_OBJECT_WRAPPER(tep_event, PyTepEvent, NO_FREE)
+
+static PyMethodDef PyTep_methods[] = {
+	{"init_local",
+	 (PyCFunction) PyTep_init_local,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Initialize from local instance."
+	},
+	{"get_event",
+	 (PyCFunction) PyTep_get_event,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get a PyTepEvent object."
+	},
+	{NULL}
+};
+
+C_OBJECT_WRAPPER(tep_handle, PyTep, tep_free)
+
+static PyMethodDef ftracepy_methods[] = {
+	{"dir",
+	 (PyCFunction) PyFtrace_dir,
+	 METH_NOARGS,
+	 "Get the absolute path to the tracefs directory."
+	},
+	{"create_instance",
+	 (PyCFunction) PyFtrace_create_instance,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Create new tracefs instance."
+	},
+	{"get_all_instances",
+	 (PyCFunction) PyFtrace_get_all_instances,
+	 METH_NOARGS,
+	 "Get all existing tracefs instances."
+	},
+	{"destroy_instance",
+	 (PyCFunction) PyFtrace_destroy_instance,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Destroy existing tracefs instance."
+	},
+	{"destroy_all_instances",
+	 (PyCFunction) PyFtrace_destroy_all_instances,
+	 METH_NOARGS,
+	 "Destroy all existing tracefs instances."
+	},
+	{"instance_dir",
+	 (PyCFunction) PyFtrace_instance_dir,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get the absolute path to the instance directory."
+	},
+	{"available_tracers",
+	 (PyCFunction) PyFtrace_available_tracers,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get a list of available tracers."
+	},
+	{"set_current_tracer",
+	 (PyCFunction) PyFtrace_set_current_tracer,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Enable a tracer."
+	},
+	{"get_current_tracer",
+	 (PyCFunction) PyFtrace_get_current_tracer,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Check the enabled tracer."
+	},
+	{"available_event_systems",
+	 (PyCFunction) PyFtrace_available_event_systems,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get a list of available trace event systems."
+	},
+	{"available_system_events",
+	 (PyCFunction) PyFtrace_available_system_events,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get a list of available trace event for a given system."
+	},
+	{"enable_event",
+	 (PyCFunction) PyFtrace_enable_event,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Enable trece event."
+	},
+	{"disable_event",
+	 (PyCFunction) PyFtrace_disable_event,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Disable trece event."
+	},
+	{"enable_events",
+	 (PyCFunction) PyFtrace_enable_events,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Enable multiple trece event."
+	},
+	{"disable_events",
+	 (PyCFunction) PyFtrace_disable_events,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Disable multiple trece event."
+	},
+	{"event_is_enabled",
+	 (PyCFunction) PyFtrace_event_is_enabled,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Check if event is enabled."
+	},
+	{"set_event_filter",
+	 (PyCFunction) PyFtrace_set_event_filter,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define event filter."
+	},
+	{"clear_event_filter",
+	 (PyCFunction) PyFtrace_clear_event_filter,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Clear event filter."
+	},
+	{"tracing_ON",
+	 (PyCFunction) PyFtrace_tracing_ON,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Start tracing."
+	},
+	{"tracing_OFF",
+	 (PyCFunction) PyFtrace_tracing_OFF,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Stop tracing."
+	},
+	{"is_tracing_ON",
+	 (PyCFunction) PyFtrace_is_tracing_ON,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Check if tracing is ON."
+	},
+	{"set_event_pid",
+	 (PyCFunction) PyFtrace_set_event_pid,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "."
+	},
+	{"set_ftrace_pid",
+	 (PyCFunction) PyFtrace_set_ftrace_pid,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "."
+	},
+	{"enable_option",
+	 (PyCFunction) PyFtrace_enable_option,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Enable trece option."
+	},
+	{"disable_option",
+	 (PyCFunction) PyFtrace_disable_option,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Disable trece option."
+	},
+	{"option_is_set",
+	 (PyCFunction) PyFtrace_option_is_set,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Check if trece option is enabled."
+	},
+	{"supported_options",
+	 (PyCFunction) PyFtrace_supported_options,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Gat a list of all supported options."
+	},
+	{"enabled_options",
+	 (PyCFunction) PyFtrace_enabled_options,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Gat a list of all supported options."
+	},
+	{"trace_shell_process",
+	 (PyCFunction) PyFtrace_trace_shell_process,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Trace a shell process."
+	},
+	{"read_trace",
+	 (PyCFunction) PyFtrace_read_trace,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Trace a shell process."
+	},
+	{"file_from_pid",
+	 (PyCFunction) PyFtrace_file_from_pid,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get process name from PID (using /proc/[pid]/exe)."
+	},
+	{"pid_from_stat",
+	 (PyCFunction) PyFtrace_pid_from_stat,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get process Id from stat file (/proc/XXX/stat)."
+	},
+	{"hook2pid",
+	 (PyCFunction) PyFtrace_hook2pid,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Trace only particular process."
+	},
+	{NULL, NULL, 0, NULL}
+};
+
+static struct PyModuleDef ftracepy_module = {
+	PyModuleDef_HEAD_INIT,
+	"ftracepy",
+	"Python interface for Ftrace.",
+	-1,
+	ftracepy_methods
+};
+
+PyMODINIT_FUNC PyInit_ftracepy(void)
+{
+	if (!PyTepTypeInit())
+		return NULL;
+
+	if (!PyTepEventTypeInit())
+		return NULL;
+
+	if (!PyTepRecordTypeInit())
+		return NULL;
+
+	TFS_ERROR = PyErr_NewException("tracecruncher.ftracepy.tfs_error",
+				       NULL, NULL);
+
+	TEP_ERROR = PyErr_NewException("tracecruncher.ftracepy.tep_error",
+				       NULL, NULL);
+
+	TRACECRUNCHER_ERROR = PyErr_NewException("tracecruncher.tc_error",
+						 NULL, NULL);
+
+	PyObject *module =  PyModule_Create(&ftracepy_module);
+
+	PyModule_AddObject(module, "tep_handle", (PyObject *) &PyTepType);
+	PyModule_AddObject(module, "tep_event", (PyObject *) &PyTepEventType);
+	PyModule_AddObject(module, "tep_record", (PyObject *) &PyTepRecordType);
+
+	PyModule_AddObject(module, "tfs_error", TFS_ERROR);
+	PyModule_AddObject(module, "tep_error", TEP_ERROR);
+	PyModule_AddObject(module, "tc_error", TRACECRUNCHER_ERROR);
+
+	if (geteuid() != 0) {
+		PyErr_SetString(TFS_ERROR,
+				"Permission denied. Root privileges are required.");
+		return NULL;
+	}
+
+	Py_AtExit(PyFtrace_at_exit);
+
+	return module;
+}
-- 
2.27.0

