Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2EDC2D0C9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 09:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76B1A24654
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 09:03:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VSPGvaFF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbfLLJDF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 04:03:05 -0500
Received: from mail-lj1-f176.google.com ([209.85.208.176]:33006 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbfLLJDE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 04:03:04 -0500
Received: by mail-lj1-f176.google.com with SMTP id 21so1404871ljr.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Dec 2019 01:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qri2yookmjZui+Ee9/8tZUSYwPNQ8QXdi+ukzfXc778=;
        b=VSPGvaFFAjFmUlFjNT3a08SphsCCGeUw0TdwnER78vd3XejXfoWg7tNswwVoz8DkDz
         GGi+Fx4Hqjb88vF1qLujjSfdmobONHouxTxqt1NPgzzC2dhMKSBWNo1AcV4Fxa+YFMcD
         AgY1RiEPhTF+nciESKU+Hezpd3ogWXVwny5LlgGJGLEmNvTF3BC/RlpXeKEWqPRqblS1
         i1hH9O/8n5LUWQb/AQhh4KfCjhVBBsJxfCDofH3+GUppULalj4rqUfJbmXQrnuXJfw3x
         kzqFm6SGP8oLvi32VPCNy1YJM4iD1pC09lOMMPEFKQ8ChM0A9GFL97FeTya7KUjdmLNf
         p1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qri2yookmjZui+Ee9/8tZUSYwPNQ8QXdi+ukzfXc778=;
        b=HPH0ceynF19Cf4NxN4tGb8cGbzfOEgvoqEpAEVh0t5hL1f0nOj0Ycz6hws5gzWeziR
         OMiG8r0yuRUIK7aKCU+LEmJ6Rnw3BV7Av8lNPQop2GcVmdN+F9nNICLevPpsSME1GjGp
         AA2aYCz8xjSq+F+po/MTQMLZUJA6eZVir5Q6B9z19kmSHTqJnPykQiZWsvJ/04uPcbVD
         yVg6ycJO/CK/Zd5RHqnOqE6JjpqJbzTNK7U9WHaXsSJUovTzBd6ajaPYZT08JFWgZQ9o
         QQKTa5UcXzcnMRaQr5Cf5swQ6AFuV9qtEhFnOiMSLYYszkpw9xfOLgsqDsRaCE4bc6X2
         ruJg==
X-Gm-Message-State: APjAAAWwxHWXWEqe5wQHdIwL6jI7NQo4sk/dC9gIwvViRPKw4aqwNH7n
        lGFMa2mM27pSff8fqKtbkvZNzRoN
X-Google-Smtp-Source: APXvYqyaLtmb8xc0Lmlv2gw8l0hXFSpo/lW+ZhVOBsnMPtdR5dxMZph+Op7Y4Fv0Sf+liG4rIKEtIg==
X-Received: by 2002:a2e:9899:: with SMTP id b25mr4952634ljj.70.1576141381724;
        Thu, 12 Dec 2019 01:03:01 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u16sm2849908lfi.36.2019.12.12.01.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 01:03:01 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Valentin.Schneider@arm.com,
        douglas.raillard@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/5] Refactor the part of the interface that relies on libtraceevent
Date:   Thu, 12 Dec 2019 11:02:29 +0200
Message-Id: <20191212090232.24236-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212090232.24236-1-y.karadz@gmail.com>
References: <20191212090232.24236-1-y.karadz@gmail.com>
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
 src/ftracepy.c | 234 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 245 insertions(+), 1 deletion(-)
 create mode 100644 src/ftracepy.c

diff --git a/setup.py b/setup.py
index 6a1d2e8..dfe1d00 100644
--- a/setup.py
+++ b/setup.py
@@ -13,6 +13,8 @@ from Cython.Build import cythonize
 
 def main():
     kshark_path = '/usr/local/lib/kernelshark'
+    traceevent_path = '/usr/local/lib/traceevent/'
+    tracecmd_path = '/usr/local/lib/trace-cmd/'
 
     module_ks = Extension('tracecruncher.ksharkpy',
                           sources=['src/ksharkpy.c'],
@@ -25,6 +27,13 @@ def main():
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
@@ -33,7 +42,7 @@ def main():
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
index 0000000..e23b875
--- /dev/null
+++ b/src/ftracepy.c
@@ -0,0 +1,234 @@
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
+#include "kernelshark/libkshark-tepdata.h"
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
+	static char *kwlist[] = {"address"};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "i",
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
+	static char *kwlist[] = {"pid", "proc_addr"};
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

