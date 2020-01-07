Return-Path: <SRS0=g3Xf=24=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA51C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D20DF208C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:03:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W8nAj1pX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgAGRDy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:03:54 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37008 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728389AbgAGRDy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:03:54 -0500
Received: by mail-lj1-f193.google.com with SMTP id o13so338640ljg.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 09:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CMy+xdAHTzaVs0eYAf0FikyjRMcLPts/9yGyyoGPqRA=;
        b=W8nAj1pXLcd5HzjRaI43ytD+y1/a/R+yZIv2/84ecC/S5jTfCyPzXlsTq7VZ/G4RHY
         f+FgRskWs9NWm1bp2hpJtbCAS2R9PuKBNR4QANnvXhY8dfUj4Q0BwdupEfqSmMo+pU1N
         WKM5gyw8iBmqGxhxlKzJDCGgquMEiuZmgYIlpkqmLBi68hcF6NWaueR9NvFR73LQBrN6
         KpW6FBCpZWWw41x07VEPslg9VSy8TErKYznPetevViFazKGUbzKtNlw0cO7A76RBb3hX
         ztzYFcPf1NGY2RhUVoGULch/b/Zj6PVjbFhpxZqdWTbinWAbstgKgeb/MA7NcxIERF8P
         rAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CMy+xdAHTzaVs0eYAf0FikyjRMcLPts/9yGyyoGPqRA=;
        b=QkjvRXhR3a7UPhEg08Wn6bjyYsWGaJZmHKbC8SPePiCjdKMbxZXQkSdRSH05PZ8e0k
         y0lTDG9TJQq6HWR0SeVeI65RXIqRCiy6XXjdlpHdQHkRdAJ7WKFyrId8T9SrJ+lq6N6b
         n089sDxupAHLofTMhS/To8wTOffAMZVen/ZFEU8h/nNbIyXIKTR3uMlR+1A+2dJpOr58
         pOiE6Yn3SW1mtbTkBSV8+joL/Y2444SNRMLRjmTZ1XdDSefrVIdt8nxUGvK5V/QNI59k
         UqhScIlqAeQvB2jjqm7rzJ70+Ov2b1+LjGJoYWO8mT87jcrocHVlybpmBwtHdmgeOdst
         INBw==
X-Gm-Message-State: APjAAAWzlQ0eBXEFdf7FuE8yvE4QtjsPZFiQFq4zE16Q/ZrXhOYPDtrQ
        G4thmzLW4SDsWTv+RabEoErJeli9
X-Google-Smtp-Source: APXvYqzDOYBf/MShQ4zVshNrysRlqg8GZIkPaPpkn4VWdKTqFSWDaGoZhZm+LyzELVERWVLPBhDPAA==
X-Received: by 2002:a2e:93d5:: with SMTP id p21mr316088ljh.50.1578416630930;
        Tue, 07 Jan 2020 09:03:50 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d16sm140605lfa.16.2020.01.07.09.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:03:50 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Douglas.Raillard@arm.com,
        Valentin.Schneider@arm.com, nd@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 01/12] trace-cruncher: Refactor the part of the interface that relies on libkshark
Date:   Tue,  7 Jan 2020 19:03:01 +0200
Message-Id: <20200107170312.27116-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200107170312.27116-1-y.karadz@gmail.com>
References: <20200107170312.27116-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is the first patch from a patch-set that aims to refactor
trace-cruncher completely. The goal it to be able to build the
project as a native Python package, which contains several
sub-packages implemented as C extensions via the Python's C API.
In this patch the part of the interface that relies on libkshark
gets re-implemented as an extension called "tracecruncher.ksharkpy".
Note that this new extension has a stand-alone build that is
completely decoupled from the existing build system used by
trace-cruncher.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 setup.py                  |  43 ++++++
 src/common.h              |  19 +++
 src/ksharkpy.c            | 267 ++++++++++++++++++++++++++++++++++++++
 tracecruncher/__init__.py |   0
 4 files changed, 329 insertions(+)
 create mode 100644 setup.py
 create mode 100644 src/common.h
 create mode 100644 src/ksharkpy.c
 create mode 100644 tracecruncher/__init__.py

diff --git a/setup.py b/setup.py
new file mode 100644
index 0000000..1a89dc6
--- /dev/null
+++ b/setup.py
@@ -0,0 +1,43 @@
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
+def main():
+    kshark_path = '/usr/local/lib/kernelshark'
+
+    module_ks = Extension('tracecruncher.ksharkpy',
+                          sources=['src/ksharkpy.c'],
+                          library_dirs=[kshark_path],
+                          runtime_library_dirs=[kshark_path],
+                          libraries=['kshark'],
+                          define_macros=[
+                              ('LIB_KSHARK_PATH', '\"' + kshark_path + '/libkshark.so\"'),
+                              ('KS_PLUGIN_DIR',   '\"' + kshark_path + '/plugins\"')
+                              ],
+                          )
+
+    setup(name='tracecruncher',
+          version='0.1.0',
+          description='NumPy based interface for accessing tracing data in Python.',
+          author='Yordan Karadzhov (VMware)',
+          author_email='y.karadz@gmail.com',
+          url='https://github.com/vmware/trace-cruncher',
+          license='LGPL-2.1',
+          packages=find_packages(),
+          ext_modules=[module_ks],
+          classifiers=[
+              'Development Status :: 3 - Alpha',
+              'Programming Language :: Python :: 3',
+              ]
+          )
+
+if __name__ == '__main__':
+    main()
diff --git a/src/common.h b/src/common.h
new file mode 100644
index 0000000..d7d355a
--- /dev/null
+++ b/src/common.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+#ifndef _TC_COMMON_H
+#define _TC_COMMON_H
+
+#define TRACECRUNCHER_ERROR	tracecruncher_error
+#define KSHARK_ERROR		kshark_error
+
+#define KS_INIT_ERROR \
+	PyErr_SetString(KSHARK_ERROR, "libshark failed to initialize");
+
+#define KS_MEM_ERROR \
+	PyErr_SetString(TRACECRUNCHER_ERROR, "failed to allocate memory");
+
+#endif
diff --git a/src/ksharkpy.c b/src/ksharkpy.c
new file mode 100644
index 0000000..5a15a77
--- /dev/null
+++ b/src/ksharkpy.c
@@ -0,0 +1,267 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+/** Use GNU C Library. */
+#define _GNU_SOURCE 1
+
+// C
+#include <stdio.h>
+#include <dlfcn.h>
+
+// Python
+#include <Python.h>
+
+// KernelShark
+#include "kernelshark/libkshark.h"
+#include "kernelshark/libkshark-plugin.h"
+#include "kernelshark/libkshark-model.h"
+
+// trace-cruncher
+#include "common.h"
+
+static PyObject *KSHARK_ERROR = NULL;
+static PyObject *TRACECRUNCHER_ERROR = NULL;
+
+static PyObject *method_open(PyObject *self, PyObject *args,
+					     PyObject *kwargs)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	char *fname = NULL;
+
+	static char *kwlist[] = {"fname", NULL};
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"s",
+					kwlist,
+					&fname)) {
+		return NULL;
+	}
+
+	if (!kshark_instance(&kshark_ctx)) {
+		KS_INIT_ERROR
+		return NULL;
+	}
+
+	if (!kshark_open(kshark_ctx, fname))
+		return Py_False;
+
+	return Py_True;
+}
+
+static PyObject* method_close(PyObject* self, PyObject* noarg)
+{
+	struct kshark_context *kshark_ctx = NULL;
+
+	if (!kshark_instance(&kshark_ctx)) {
+		KS_INIT_ERROR
+		return NULL;
+	}
+
+	kshark_close(kshark_ctx);
+
+	Py_RETURN_NONE;
+}
+
+static int compare(const void *a, const void *b)
+{
+	int a_i, b_i;
+
+	a_i = *(const int *) a;
+	b_i = *(const int *) b;
+
+	if (a_i > b_i)
+		return +1;
+
+	if (a_i < b_i)
+		return -1;
+
+	return 0;
+}
+
+static PyObject* method_get_tasks(PyObject* self, PyObject* noarg)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	const char *comm;
+	int *pids;
+	ssize_t i, n;
+
+	if (!kshark_instance(&kshark_ctx)) {
+		KS_INIT_ERROR
+		return NULL;
+	}
+
+	n = kshark_get_task_pids(kshark_ctx, &pids);
+	if (n == 0) {
+		PyErr_SetString(KSHARK_ERROR,
+				"Failed to retrieve the PID-s of the tasks");
+		return NULL;
+	}
+
+	qsort(pids, n, sizeof(*pids), compare);
+
+	PyObject *tasks, *pid_list, *pid_val;
+
+	tasks = PyDict_New();
+	for (i = 0; i < n; ++i) {
+		comm = tep_data_comm_from_pid(kshark_ctx->pevent, pids[i]);
+		pid_val = PyLong_FromLong(pids[i]);
+		pid_list = PyDict_GetItemString(tasks, comm);
+		if (!pid_list) {
+			pid_list = PyList_New(1);
+			PyList_SET_ITEM(pid_list, 0, pid_val);
+			PyDict_SetItemString(tasks, comm, pid_list);
+		} else {
+			PyList_Append(pid_list, pid_val);
+		}
+	}
+
+	return tasks;
+}
+
+static PyObject *method_register_plugin(PyObject *self, PyObject *args,
+							PyObject *kwargs)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	char *plugin, *lib_file;
+	int ret;
+
+	static char *kwlist[] = {"plugin", NULL};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "s",
+					 kwlist,
+					 &plugin)) {
+		return NULL;
+	}
+
+	if (asprintf(&lib_file, "%s/plugin-%s.so", KS_PLUGIN_DIR, plugin) < 0) {
+		KS_MEM_ERROR
+		return NULL;
+	}
+
+	if (!kshark_instance(&kshark_ctx)) {
+		KS_INIT_ERROR
+		return NULL;
+	}
+
+	ret = kshark_register_plugin(kshark_ctx, lib_file);
+	free(lib_file);
+	if (ret < 0) {
+		PyErr_Format(KSHARK_ERROR,
+			     "libshark failed to load plugin '%s'",
+			     plugin);
+		return NULL;
+	}
+
+	if (kshark_handle_plugins(kshark_ctx, KSHARK_PLUGIN_INIT) < 0) {
+		PyErr_SetString(KSHARK_ERROR,
+				"libshark failed to handle its plugins");
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
+static PyObject *method_new_session_file(PyObject *self, PyObject *args,
+							 PyObject *kwargs)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_config_doc *session;
+	struct kshark_config_doc *filters;
+	struct kshark_config_doc *markers;
+	struct kshark_config_doc *model;
+	struct kshark_config_doc *file;
+	struct kshark_trace_histo histo;
+	const char *session_file, *data_file;
+
+	static char *kwlist[] = {"data_file", "session_file", NULL};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "ss",
+					 kwlist,
+					 &data_file,
+					 &session_file)) {
+		return NULL;
+	}
+
+	if (!kshark_instance(&kshark_ctx)) {
+		KS_INIT_ERROR
+		return NULL;
+	}
+
+	session = kshark_config_new("kshark.config.session",
+				    KS_CONFIG_JSON);
+
+	file = kshark_export_trace_file(data_file, KS_CONFIG_JSON);
+	kshark_config_doc_add(session, "Data", file);
+
+	filters = kshark_export_all_filters(kshark_ctx, KS_CONFIG_JSON);
+	kshark_config_doc_add(session, "Filters", filters);
+
+	ksmodel_init(&histo);
+	model = kshark_export_model(&histo, KS_CONFIG_JSON);
+	kshark_config_doc_add(session, "Model", model);
+
+	markers = kshark_config_new("kshark.config.markers", KS_CONFIG_JSON);
+	kshark_config_doc_add(session, "Markers", markers);
+
+	kshark_save_config_file(session_file, session);
+	kshark_free_config_doc(session);
+
+	Py_RETURN_NONE;
+}
+
+static PyMethodDef ksharkpy_methods[] = {
+	{"open",
+	 (PyCFunction) method_open,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Open trace data file"
+	},
+	{"close",
+	 (PyCFunction) method_close,
+	 METH_NOARGS,
+	 "Close trace data file"
+	},
+	{"get_tasks",
+	 (PyCFunction) method_get_tasks,
+	 METH_NOARGS,
+	 "Get all tasks recorded in a trace file"
+	},
+	{"register_plugin",
+	 (PyCFunction) method_register_plugin,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Load a plugin"
+	},
+	{"new_session_file",
+	 (PyCFunction) method_new_session_file,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Create new session description file"
+	},
+	{NULL, NULL, 0, NULL}
+};
+
+static struct PyModuleDef ksharkpy_module = {
+	PyModuleDef_HEAD_INIT,
+	"ksharkpy",
+	"",
+	-1,
+	ksharkpy_methods
+};
+
+PyMODINIT_FUNC PyInit_ksharkpy(void)
+{
+	PyObject *module = PyModule_Create(&ksharkpy_module);
+
+	KSHARK_ERROR = PyErr_NewException("tracecruncher.ksharkpy.ks_error",
+					  NULL, NULL);
+	PyModule_AddObject(module, "ks_error", KSHARK_ERROR);
+
+	TRACECRUNCHER_ERROR = PyErr_NewException("tracecruncher.tc_error",
+						 NULL, NULL);
+	PyModule_AddObject(module, "tc_error", TRACECRUNCHER_ERROR);
+
+	return module;
+}
diff --git a/tracecruncher/__init__.py b/tracecruncher/__init__.py
new file mode 100644
index 0000000..e69de29
-- 
2.20.1

