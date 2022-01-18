Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3BDC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jan 2022 01:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243960AbiARBMf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 20:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243926AbiARBMe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 20:12:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE44C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 17:12:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E755A6125B
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jan 2022 01:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06940C36AEC;
        Tue, 18 Jan 2022 01:12:32 +0000 (UTC)
Date:   Mon, 17 Jan 2022 20:12:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2] trace-cruncher: Add API to set tracing CPU affinity
Message-ID: <20220117201231.414a4799@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a set_affinity API that can let the user set what CPUs to enable
tracing on.

Example:

  import tracecruncher.ftracepy as ft

  ft.set_affinity(cpus=["0-1","3"]);

The above will set the top level instance affinity to 0,1,3 (or 0xb)

To reset back to online CPUs:

  ft.reset_affinity()

Where it will reset the top level instance back to all CPUS.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
Changes since v1:  https://lore.kernel.org/all/20211217182619.13db88f0@gandalf.local.home/

 - Added reset_affinity() to set the instance to all CPUs
   Note, I did not add a get_affinity() because that requires
     adding a get_affinity to libtracefs() first.

 - Will now error if cpus is not PyUnicode or PyList.

 - Fixed up one line description of set affinity.

 examples/reset-affinity.py |  5 ++
 examples/test-affinity.py  |  5 ++
 src/ftracepy-utils.c       | 93 ++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h       |  6 +++
 src/ftracepy.c             | 10 ++++
 5 files changed, 119 insertions(+)
 create mode 100755 examples/reset-affinity.py
 create mode 100755 examples/test-affinity.py

diff --git a/examples/reset-affinity.py b/examples/reset-affinity.py
new file mode 100755
index 0000000..2bca32e
--- /dev/null
+++ b/examples/reset-affinity.py
@@ -0,0 +1,5 @@
+#!/usr/bin/env python3
+
+import tracecruncher.ftracepy as ft
+
+ft.reset_affinity();
diff --git a/examples/test-affinity.py b/examples/test-affinity.py
new file mode 100755
index 0000000..1619931
--- /dev/null
+++ b/examples/test-affinity.py
@@ -0,0 +1,5 @@
+#!/usr/bin/env python3
+
+import tracecruncher.ftracepy as ft
+
+ft.set_affinity(cpus=["0-1","3"]);
diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index a735d88..e42f69c 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2394,6 +2394,99 @@ PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
 	return NULL;
 }
 
+PyObject *PyFtrace_reset_affinity(PyObject *self, PyObject *args,
+				  PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+	static char *kwlist[] = {"instance", NULL};
+	PyObject *py_inst = NULL;
+	int ret;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "|O",
+					 kwlist,
+					 &py_inst)) {
+		return NULL;
+	}
+
+	if (!get_optional_instance(py_inst, &instance))
+		goto err;
+
+	/* NULL for CPUs will set all available CPUS */
+	ret = tracefs_instance_set_affinity(instance, NULL);
+	if (ret < 0) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Failed to reset tracing affinity.");
+		goto err;
+	}
+
+	Py_RETURN_NONE;
+err:
+	return NULL;
+}
+
+PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
+						PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+	static char *kwlist[] = {"cpus", "instance", NULL};
+	PyObject *py_cpus;
+	PyObject *py_inst = NULL;
+	const char *cpu_str;
+	int ret;
+
+	if (!init_print_seq())
+		return false;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "O|O",
+					 kwlist,
+					 &py_cpus,
+					 &py_inst)) {
+		return NULL;
+	}
+
+	if (PyUnicode_Check(py_cpus)) {
+		cpu_str = (const char *)PyUnicode_DATA(py_cpus);
+		if (trace_seq_puts(&seq, cpu_str) < 0)
+			goto err_seq;
+	} else if (PyList_CheckExact(py_cpus)) {
+		int i, n = PyList_Size(py_cpus);
+
+		for (i = 0; i < n; ++i) {
+			cpu_str = str_from_list(py_cpus, i);
+			if (i)
+				trace_seq_putc(&seq, ',');
+			if (trace_seq_puts(&seq, cpu_str) < 0)
+				goto err_seq;
+		}
+	} else {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Invalid \"cpus\" type.");
+		goto err;
+	}
+
+	if (!get_optional_instance(py_inst, &instance))
+		goto err;
+
+	trace_seq_terminate(&seq);
+	ret = tracefs_instance_set_affinity(instance, seq.buffer);
+	if (ret < 0) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Invalid \"cpus\" argument.");
+		goto err;
+	}
+
+	Py_RETURN_NONE;
+err_seq:
+	PyErr_SetString(TRACECRUNCHER_ERROR,
+			"Internal processing string error.");
+err:
+	return NULL;
+}
+
 PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
 						       PyObject *kwargs)
 {
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index d09c8bf..4af557f 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -208,6 +208,12 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
 					PyObject *kwargs);
 
+PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
+						PyObject *kwargs);
+
+PyObject *PyFtrace_reset_affinity(PyObject *self, PyObject *args,
+						  PyObject *kwargs);
+
 PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
 						       PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index b270b71..cd5d382 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -372,11 +372,21 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Define a kretprobe."
 	},
+	{"reset_affinity",
+	 (PyCFunction) PyFtrace_reset_affinity,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Set an instance tracing affinity to all CPUs"
+	},
 	{"hist",
 	 (PyCFunction) PyFtrace_hist,
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Define a histogram."
 	},
+	{"set_affinity",
+	 (PyCFunction) PyFtrace_set_affinity,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Return tracing affinity of an instance."
+	},
 	{"set_ftrace_loglevel",
 	 (PyCFunction) PyFtrace_set_ftrace_loglevel,
 	 METH_VARARGS | METH_KEYWORDS,
-- 
2.31.1

