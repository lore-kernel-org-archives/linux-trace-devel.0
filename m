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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E9F7C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46EC3208C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lWhPSK7M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgAGRD5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:03:57 -0500
Received: from mail-lj1-f182.google.com ([209.85.208.182]:43344 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728427AbgAGRD4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:03:56 -0500
Received: by mail-lj1-f182.google.com with SMTP id a13so296674ljm.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 09:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OJLLPohVI6IFX7QUrGNPXztXCVZUmuK0fIA3rDXc+kY=;
        b=lWhPSK7MpBC1INUTNPp9wlJff55ROde3KN2rC9RGkA6gO7BjcoylzvAQu4ogStxK1p
         D8YJ7oQvqg8IMRnjqgULz2qLk0Vq0FyAeF5D2OIc5vH3xvvI+Plrn1oVBwbVPguT08id
         8zmzYUT01P/6JtN9y5kdffOFe8iNV6wkp2BVtBbeCJXTU/rahphg6UgH3l/0W4hJVQvT
         pBr8vw8W9ibmyb+iUVS+z/AFDcyGC11abAf10RoULpS3uA3Bu6aYZiX8P5AN+rWdxcfD
         xjBYuGhSb6ioIh+lu+i6/iTN04wsVpoc0QDgn8I5Lr8twA0zDoA1RiPoHN5NWxaDWwEN
         7vgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OJLLPohVI6IFX7QUrGNPXztXCVZUmuK0fIA3rDXc+kY=;
        b=fOpL7Psx928HQk0BYJueZWgKwlg608oK4/S1ykpGXetRCERPjgWvmgitXIMIKUfL6z
         Jy9orYs2IxbKnYqnMHKE34Zuoadn3p7LPhYtuwuEXorEAV2L9IyMilyzC27Ovhg/sawq
         GM9Z6Xhg7pn4R2wOdxc+WN6LLysGDHPueKPbzUhPDrY2pm4L+ULOEofPJBNpPZsuNm+B
         ixZ0dKAgiW+cCu7jDBJoEHlIy447whPN5JORYsc07Nc5SNvh9zB83wxp9Yd3ZrRe+WmC
         P6dUuNwXaaM4eB+WAiiE8T0TyYtRkiTFO/xBtPlyrqwiS3o7Czi23tsIvFq0JPhxcOie
         ybVg==
X-Gm-Message-State: APjAAAWa9SeA7uXJD/0yT6MFpDD+HBP+OPpyISsHsglZT98l4qHSOseM
        cibKBmJ8EsKN8y+BmxQUyZuSPZlM
X-Google-Smtp-Source: APXvYqwbetJaTPKI7UyuqpviuD594fLEa7y25H+migR+ZQYGgI880EU5MA1z8p39I8v6OuRBXBdPaw==
X-Received: by 2002:a05:651c:8f:: with SMTP id 15mr261695ljq.109.1578416632895;
        Tue, 07 Jan 2020 09:03:52 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d16sm140605lfa.16.2020.01.07.09.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:03:52 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Douglas.Raillard@arm.com,
        Valentin.Schneider@arm.com, nd@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 02/12] trace-cruncher: Refactor the part of the interface that relies on libtraceevent
Date:   Tue,  7 Jan 2020 19:03:02 +0200
Message-Id: <20200107170312.27116-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200107170312.27116-1-y.karadz@gmail.com>
References: <20200107170312.27116-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The part of the interface that relies on libtraceevent gets
re-implemented as an extension called "tracecruncher.ftracepy".
The new extension gets build together with the previously
implemented "tracecruncher.ksharkpy" extension.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 setup.py       |  11 ++-
 src/common.h   |   1 +
 src/ftracepy.c | 233 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 244 insertions(+), 1 deletion(-)
 create mode 100644 src/ftracepy.c

diff --git a/setup.py b/setup.py
index 1a89dc6..62912e2 100644
--- a/setup.py
+++ b/setup.py
@@ -12,6 +12,8 @@ from Cython.Build import cythonize
 
 def main():
     kshark_path = '/usr/local/lib/kernelshark'
+    traceevent_path = '/usr/local/lib/traceevent/'
+    tracecmd_path = '/usr/local/lib/trace-cmd/'
 
     module_ks = Extension('tracecruncher.ksharkpy',
                           sources=['src/ksharkpy.c'],
@@ -24,6 +26,13 @@ def main():
                               ],
                           )
 
+    module_ft = Extension('tracecruncher.ftracepy',
+                          sources=['src/ftracepy.c'],
+                          library_dirs=[kshark_path, traceevent_path, tracecmd_path],
+                          runtime_library_dirs=[kshark_path, traceevent_path, tracecmd_path],
+                          libraries=['kshark', 'traceevent', 'tracecmd'],
+                          )
+
     setup(name='tracecruncher',
           version='0.1.0',
           description='NumPy based interface for accessing tracing data in Python.',
@@ -32,7 +41,7 @@ def main():
           url='https://github.com/vmware/trace-cruncher',
           license='LGPL-2.1',
           packages=find_packages(),
-          ext_modules=[module_ks],
+          ext_modules=[module_ks, module_ft],
           classifiers=[
               'Development Status :: 3 - Alpha',
               'Programming Language :: Python :: 3',
diff --git a/src/common.h b/src/common.h
index d7d355a..632e17a 100644
--- a/src/common.h
+++ b/src/common.h
@@ -9,6 +9,7 @@
 
 #define TRACECRUNCHER_ERROR	tracecruncher_error
 #define KSHARK_ERROR		kshark_error
+#define FTRACE_ERROR		ftrace_error
 
 #define KS_INIT_ERROR \
 	PyErr_SetString(KSHARK_ERROR, "libshark failed to initialize");
diff --git a/src/ftracepy.c b/src/ftracepy.c
new file mode 100644
index 0000000..fd0832b
--- /dev/null
+++ b/src/ftracepy.c
@@ -0,0 +1,233 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+ */
+
+// Python
+#include <Python.h>
+
+// trace-cmd
+#include "trace-cmd/trace-cmd.h"
+
+// KernelShark
+#include "kernelshark/libkshark.h"
+
+// trace-cruncher
+#include "common.h"
+
+static PyObject *KSHARK_ERROR = NULL;
+static PyObject *FTRACE_ERROR = NULL;
+
+static PyObject *method_event_id(PyObject *self, PyObject *args,
+						 PyObject *kwargs)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct tep_event *event;
+	const char *system, *name;
+
+	static char *kwlist[] = {"system", "event", NULL};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "ss",
+					 kwlist,
+					 &system,
+					 &name)) {
+		return NULL;
+	}
+
+	if (!kshark_instance(&kshark_ctx)) {
+		KS_INIT_ERROR
+		return NULL;
+	}
+
+	event = tep_find_event_by_name(kshark_ctx->pevent, system, name);
+	if (!event) {
+		PyErr_Format(FTRACE_ERROR,
+			     "Failed to find event '%s/%s'",
+			     system, name);
+	}
+
+	return PyLong_FromLong(event->id);
+}
+
+static PyObject *method_read_event_field(PyObject *self, PyObject *args,
+							 PyObject *kwargs)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct tep_format_field *evt_field;
+	struct tep_record *record;
+	struct tep_event *event;
+	unsigned long long val;
+	const char *field;
+	uint64_t offset;
+	int event_id, ret;
+
+	static char *kwlist[] = {"offset", "event_id", "field", NULL};
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"Lis",
+					kwlist,
+					&offset,
+					&event_id,
+					&field)) {
+		return NULL;
+	}
+
+	if (!kshark_instance(&kshark_ctx)) {
+		KS_INIT_ERROR
+		return NULL;
+	}
+
+	event = tep_find_event(kshark_ctx->pevent, event_id);
+	if (!event) {
+		PyErr_Format(FTRACE_ERROR,
+			     "Failed to find event '%i'",
+			     event_id);
+		return NULL;
+	}
+
+	evt_field = tep_find_any_field(event, field);
+	if (!evt_field) {
+		PyErr_Format(FTRACE_ERROR,
+			     "Failed to find field '%s' of event '%i'",
+			     field, event_id);
+		return NULL;
+	}
+
+	record = tracecmd_read_at(kshark_ctx->handle, offset, NULL);
+	if (!record) {
+		PyErr_Format(FTRACE_ERROR,
+			     "Failed to read record at offset '%i'",
+			     offset);
+		return NULL;
+	}
+
+	ret = tep_read_number_field(evt_field, record->data, &val);
+	free_record(record);
+
+	if (ret != 0) {
+		PyErr_Format(FTRACE_ERROR,
+			     "Failed to read field '%s' of event '%i'",
+			     field, event_id);
+		return NULL;
+	}
+
+	return PyLong_FromLong(val);
+}
+
+static PyObject *method_get_function(PyObject *self, PyObject *args,
+						     PyObject *kwargs)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	unsigned long long address;
+	const char *func;
+
+	static char *kwlist[] = {"address", NULL};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "L",
+					 kwlist,
+					 &address)) {
+		return NULL;
+	}
+
+	if (!kshark_instance(&kshark_ctx)) {
+		KS_INIT_ERROR
+		return NULL;
+	}
+
+	func = tep_find_function(kshark_ctx->pevent, address);
+	if (!func)
+		Py_RETURN_NONE;
+
+	return PyUnicode_FromString(func);
+}
+
+static PyObject *method_map_instruction_address(PyObject *self, PyObject *args,
+								PyObject *kwargs)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct tracecmd_proc_addr_map *mem_map;
+	unsigned long long proc_addr, obj_addr;
+	int pid;
+	PyObject *ret;
+
+	static char *kwlist[] = {"pid", "proc_addr", NULL};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "iL",
+					 kwlist,
+					 &pid,
+					 &proc_addr)) {
+		return NULL;
+	}
+
+	if (!kshark_instance(&kshark_ctx)) {
+		KS_INIT_ERROR
+		return NULL;
+	}
+
+	mem_map = tracecmd_search_task_map(kshark_ctx->handle,
+					   pid, proc_addr);
+
+	if (!mem_map)
+		Py_RETURN_NONE;
+
+	ret = PyDict_New();
+
+	PyDict_SetItemString(ret, "obj_file",
+			     PyUnicode_FromString(mem_map->lib_name));
+
+	obj_addr = proc_addr - mem_map->start;
+	PyDict_SetItemString(ret, "address", PyLong_FromLong(obj_addr));
+
+	return ret;
+}
+
+static PyMethodDef ftracepy_methods[] = {
+	{"event_id",
+	 (PyCFunction) method_event_id,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get the Id of the event from its name"
+	},
+	{"read_event_field",
+	 (PyCFunction) method_read_event_field,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get the value of an event field having a given name"
+	},
+	{"get_function",
+	 (PyCFunction) method_get_function,
+	 METH_VARARGS | METH_KEYWORDS,
+	 ""
+	},
+	{"map_instruction_address",
+	 (PyCFunction) method_map_instruction_address,
+	 METH_VARARGS | METH_KEYWORDS,
+	 ""
+	},
+	{NULL, NULL, 0, NULL}
+};
+
+static struct PyModuleDef ftracepy_module = {
+	PyModuleDef_HEAD_INIT,
+	"ftracepy",
+	"",
+	-1,
+	ftracepy_methods
+};
+
+PyMODINIT_FUNC PyInit_ftracepy(void)
+{
+	PyObject *module =  PyModule_Create(&ftracepy_module);
+
+	KSHARK_ERROR = PyErr_NewException("tracecruncher.ftracepy.ks_error",
+					  NULL, NULL);
+	PyModule_AddObject(module, "ks_error", KSHARK_ERROR);
+
+	FTRACE_ERROR = PyErr_NewException("tracecruncher.ftracepy.ft_error",
+					  NULL, NULL);
+	PyModule_AddObject(module, "ft_error", FTRACE_ERROR);
+
+	return module;
+}
-- 
2.20.1

