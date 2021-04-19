Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA86C43461
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B23561107
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 13:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhDSNCa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 09:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239332AbhDSNC1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 09:02:27 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D16DC061760
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 06:01:56 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e7so24981832wrs.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 06:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6cd21+D+GG8bC4ShVrEfOeAdncE6KGpG+t+NxnM7/2I=;
        b=FqiVCGE/+b4hj/tn9ml1k+42dRcQQkRkqbdrwquFX5ysMi9S6KTJAldT8h40km2UpE
         2gFGuRrJrKbkPi13rlWFk+cxhBRTG7enaNadVYE9jwtSE0klLgA3EABCo9jaHXcp7ZEj
         8Rz3Y7vbwtr7w6GyiolgQCY0EguGLiGy6bf360A0hnKJ0ECCMJIXwobaBE7U67x6CGP6
         eCeB+0yBgIThVwpBTPs+wtQfP3c0ZzTnhsMz9LReujrOD7iWH1KvIS4ov/3v1BSuCxzU
         f9MFCubsO968Zy1DucW53gGWoMUz5RJj2oYOTveFbQEX7chN4YPNKCqh410p96rzgiMe
         Yt1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6cd21+D+GG8bC4ShVrEfOeAdncE6KGpG+t+NxnM7/2I=;
        b=I1RVmvsZf1zwH1834z9lksJTjrcqEJuAj33lLUZZ6Wj+iPkeEq/dUrS+tkdv5J2EA6
         L3H+Pnqs66k1AG9qe6+K4WqVQRGqVwnSiUzrHaCWJdYVfZAduB1NtNGY4l8bdUESn/FX
         KRmT7F9inLgggkB8p+YLDIcQ5RYXj39PjtuJHp+7cm3GMCdZ+rTQbbsCaH9NhYxVDZqn
         LV7VpPNag/q/hRJqaj65NvJFJcj8HpFQirrzXZfw8NTHnJXGmGtmMxOezw/YA0//Lpes
         xFPOb7lT7MWlArvN/KKDNPw3mWs6sWOBNpi8qJZwdbzAcQEm3Pi0Yi0ihspytew5Lb9T
         X+Jw==
X-Gm-Message-State: AOAM531cxVB2NwW/YI/aWVp9vXo+n51LMl2B9nEq3/lfNe4eqMiE0q6y
        1/q0YC7ntoNh+wvDNbVdmyTzl9Zs0yo=
X-Google-Smtp-Source: ABdhPJwzZmOsReWSeW67Rdqy60v9h/iN3Fcx0mNpmypYtJ0Bzf2I2djIX/Z29Hd3z7gOko4Nn2lCUg==
X-Received: by 2002:a05:6000:181b:: with SMTP id m27mr14260240wrh.11.1618837314676;
        Mon, 19 Apr 2021 06:01:54 -0700 (PDT)
Received: from bucy.vmware.com ([84.40.93.28])
        by smtp.gmail.com with ESMTPSA id v7sm23164196wrs.2.2021.04.19.06.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 06:01:54 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/9] trace-cruncher: Refactor the part that wraps libkshark
Date:   Mon, 19 Apr 2021 16:01:33 +0300
Message-Id: <20210419130140.59140-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210419130140.59140-1-y.karadz@gmail.com>
References: <20210419130140.59140-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The part of the interface that relies on libkshark gets
re-implemented as an extension called "tracecruncher.ksharkpy".
The new extension gets build together with the previously
implemented "tracecruncher.ftracefy" extension.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 setup.py              |  17 +-
 src/ksharkpy-utils.c  | 411 ++++++++++++++++++++++++++++++++++++++++++
 src/ksharkpy-utils.h  |  41 +++++
 src/ksharkpy.c        |  94 ++++++++++
 src/npdatawrapper.pyx | 203 +++++++++++++++++++++
 src/trace2matrix.c    |  40 ++++
 6 files changed, 804 insertions(+), 2 deletions(-)
 create mode 100644 src/ksharkpy-utils.c
 create mode 100644 src/ksharkpy-utils.h
 create mode 100644 src/ksharkpy.c
 create mode 100644 src/npdatawrapper.pyx
 create mode 100644 src/trace2matrix.c

diff --git a/setup.py b/setup.py
index 450f043..c3d0352 100644
--- a/setup.py
+++ b/setup.py
@@ -11,22 +11,26 @@ from distutils.core import Extension
 from Cython.Build import cythonize
 
 import pkgconfig as pkg
+import numpy as np
 
 
 def third_party_paths():
     pkg_traceevent = pkg.parse('libtraceevent')
     pkg_ftracepy = pkg.parse('libtracefs')
     pkg_tracecmd = pkg.parse('libtracecmd')
+    pkg_kshark = pkg.parse('libkshark')
 
-    include_dirs = []
+    include_dirs = [np.get_include()]
     include_dirs.extend(pkg_traceevent['include_dirs'])
     include_dirs.extend(pkg_ftracepy['include_dirs'])
     include_dirs.extend(pkg_tracecmd['include_dirs'])
+    include_dirs.extend(pkg_kshark['include_dirs'])
 
     library_dirs = []
     library_dirs.extend(pkg_traceevent['library_dirs'])
     library_dirs.extend(pkg_ftracepy['library_dirs'])
     library_dirs.extend(pkg_tracecmd['library_dirs'])
+    library_dirs.extend(pkg_kshark['library_dirs'])
     library_dirs = list(set(library_dirs))
 
     return include_dirs, library_dirs
@@ -48,6 +52,15 @@ def main():
                             sources=['src/ftracepy.c', 'src/ftracepy-utils.c'],
                             libraries=['traceevent', 'tracefs'])
 
+    cythonize('src/npdatawrapper.pyx', language_level = "3")
+    module_data = extension(name='tracecruncher.npdatawrapper',
+                            sources=['src/npdatawrapper.c'],
+                            libraries=['kshark'])
+
+    module_ks   = extension(name='tracecruncher.ksharkpy',
+                            sources=['src/ksharkpy.c', 'src/ksharkpy-utils.c'],
+                            libraries=['kshark'])
+
     setup(name='tracecruncher',
           version='0.1.0',
           description='NumPy based interface for accessing tracing data in Python.',
@@ -56,7 +69,7 @@ def main():
           url='https://github.com/vmware/trace-cruncher',
           license='LGPL-2.1',
           packages=find_packages(),
-          ext_modules=[module_ft],
+          ext_modules=[module_ft, module_data, module_ks],
           classifiers=[
               'Development Status :: 3 - Alpha',
               'Programming Language :: Python :: 3',
diff --git a/src/ksharkpy-utils.c b/src/ksharkpy-utils.c
new file mode 100644
index 0000000..12972fb
--- /dev/null
+++ b/src/ksharkpy-utils.c
@@ -0,0 +1,411 @@
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
+#include <string.h>
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
+#include "libkshark-model.h"
+#include "libkshark-tepdata.h"
+
+// trace-cruncher
+#include "ksharkpy-utils.h"
+
+PyObject *KSHARK_ERROR = NULL;
+PyObject *TRACECRUNCHER_ERROR = NULL;
+
+PyObject *PyKShark_open(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	char *fname;
+	int sd;
+
+	static char *kwlist[] = {"file_name", NULL};
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
+	sd = kshark_open(kshark_ctx, fname);
+	if (sd < 0) {
+		PyErr_Format(KSHARK_ERROR, "Failed to open file \'%s\'", fname);
+		return NULL;
+	}
+
+	return PyLong_FromLong(sd);
+}
+
+PyObject *PyKShark_close(PyObject* self, PyObject* noarg)
+{
+	struct kshark_context *kshark_ctx = NULL;
+
+	if (!kshark_instance(&kshark_ctx)) {
+		KS_INIT_ERROR
+		return NULL;
+	}
+
+	kshark_close_all(kshark_ctx);
+
+	Py_RETURN_NONE;
+}
+
+static bool is_tep_data(const char *file_name)
+{
+	if (!kshark_tep_check_data(file_name)) {
+		PyErr_Format(KSHARK_ERROR, "\'%s\' is not a TEP data file.",
+			     file_name);
+		return false;
+	}
+
+	return true;
+}
+
+PyObject *PyKShark_open_tep_buffer(PyObject *self, PyObject *args,
+						   PyObject *kwargs)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	char *file_name, *buffer_name;
+	int sd, sd_top;
+
+	static char *kwlist[] = {"file_name", "buffer_name", NULL};
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"ss",
+					kwlist,
+					&file_name,
+					&buffer_name)) {
+		return NULL;
+	}
+
+	if (!kshark_instance(&kshark_ctx)) {
+		KS_INIT_ERROR
+		return NULL;
+	}
+
+	if (!is_tep_data(file_name))
+		return NULL;
+
+	sd_top = kshark_tep_find_top_stream(kshark_ctx, file_name);
+	if (sd_top < 0) {
+		/* The "top" steam has to be initialized first. */
+		sd_top = kshark_open(kshark_ctx, file_name);
+	}
+
+	if (sd_top < 0)
+		return NULL;
+
+	sd = kshark_tep_open_buffer(kshark_ctx, sd_top, buffer_name);
+	if (sd < 0) {
+		PyErr_Format(KSHARK_ERROR,
+			     "Failed to open buffer \'%s\' in file \'%s\'",
+			     buffer_name, file_name);
+		return NULL;
+	}
+
+	return PyLong_FromLong(sd);
+}
+
+static struct kshark_data_stream *get_stream(int stream_id)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_data_stream *stream;
+
+	if (!kshark_instance(&kshark_ctx)) {
+		KS_INIT_ERROR
+		return NULL;
+	}
+
+	stream = kshark_get_data_stream(kshark_ctx, stream_id);
+	if (!stream) {
+		PyErr_Format(KSHARK_ERROR,
+			     "No data stream %i loaded.",
+			     stream_id);
+		return NULL;
+	}
+
+	return stream;
+}
+
+PyObject *PyKShark_set_clock_offset(PyObject* self, PyObject* args,
+						    PyObject *kwargs)
+{
+	struct kshark_data_stream *stream;
+	int64_t offset;
+	int stream_id;
+
+	static char *kwlist[] = {"stream_id", "offset", NULL};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "iL",
+					 kwlist,
+					 &stream_id,
+					 &offset)) {
+		return NULL;
+	}
+
+	stream = get_stream(stream_id);
+	if (!stream)
+		return NULL;
+
+	if (stream->calib_array)
+		free(stream->calib_array);
+
+	stream->calib_array = malloc(sizeof(*stream->calib_array));
+	if (!stream->calib_array) {
+		MEM_ERROR
+		return NULL;
+	}
+
+	stream->calib_array[0] = offset;
+	stream->calib_array_size = 1;
+
+	stream->calib = kshark_offset_calib;
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
+PyObject *PyKShark_get_tasks(PyObject* self, PyObject* args, PyObject *kwargs)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	const char *comm;
+	int sd, *pids;
+	ssize_t i, n;
+
+	static char *kwlist[] = {"stream_id", NULL};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "i",
+					 kwlist,
+					 &sd)) {
+		return NULL;
+	}
+
+	if (!kshark_instance(&kshark_ctx)) {
+		KS_INIT_ERROR
+		return NULL;
+	}
+
+	n = kshark_get_task_pids(kshark_ctx, sd, &pids);
+	if (n <= 0) {
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
+		comm = kshark_comm_from_pid(sd, pids[i]);
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
+PyObject *PyKShark_event_id(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	struct kshark_data_stream *stream;
+	int stream_id, event_id;
+	const char *name;
+
+	static char *kwlist[] = {"stream_id", "name", NULL};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "is",
+					 kwlist,
+					 &stream_id,
+					 &name)) {
+		return NULL;
+	}
+
+	stream = get_stream(stream_id);
+	if (!stream)
+		return NULL;
+
+	event_id = kshark_find_event_id(stream, name);
+	if (event_id < 0) {
+		PyErr_Format(KSHARK_ERROR,
+			     "Failed to retrieve the Id of event \'%s\' in stream \'%s\'",
+			     name, stream->file);
+		return NULL;
+	}
+
+	return PyLong_FromLong(event_id);
+}
+
+PyObject *PyKShark_event_name(PyObject *self, PyObject *args,
+					      PyObject *kwargs)
+{
+	struct kshark_data_stream *stream;
+	struct kshark_entry entry;
+	int stream_id, event_id;
+	PyObject *ret;
+	char *name;
+
+	static char *kwlist[] = {"stream_id", "event_id", NULL};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "ii",
+					 kwlist,
+					 &stream_id,
+					 &event_id)) {
+		return NULL;
+	}
+
+	stream = get_stream(stream_id);
+	if (!stream)
+		return NULL;
+
+	entry.event_id = event_id;
+	entry.stream_id = stream_id;
+	entry.visible = 0xFF;
+	name = kshark_get_event_name(&entry);
+	if (!name) {
+		PyErr_Format(KSHARK_ERROR,
+			     "Failed to retrieve the name of event \'id=%i\' in stream \'%s\'",
+			     event_id, stream->file);
+		return NULL;
+	}
+
+	ret = PyUnicode_FromString(name);
+	free(name);
+
+	return ret;
+}
+
+PyObject *PyKShark_read_event_field(PyObject *self, PyObject *args,
+						    PyObject *kwargs)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_entry entry;
+	int event_id, ret, sd;
+	const char *field;
+	int64_t offset;
+	int64_t val;
+
+	static char *kwlist[] = {"stream_id", "offset", "event_id", "field", NULL};
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"iLis",
+					kwlist,
+					&sd,
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
+	entry.event_id = event_id;
+	entry.offset = offset;
+	entry.stream_id = sd;
+
+	ret = kshark_read_event_field_int(&entry, field, &val);
+	if (ret != 0) {
+		PyErr_Format(KSHARK_ERROR,
+			     "Failed to read field '%s' of event '%i'",
+			     field, event_id);
+		return NULL;
+	}
+
+	return PyLong_FromLong(val);
+}
+
+PyObject *PyKShark_new_session_file(PyObject *self, PyObject *args,
+						    PyObject *kwargs)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_config_doc *session;
+	struct kshark_config_doc *plugins;
+	struct kshark_config_doc *markers;
+	struct kshark_config_doc *model;
+	struct kshark_trace_histo histo;
+	const char *session_file;
+
+	static char *kwlist[] = {"session_file", NULL};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "s",
+					 kwlist,
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
+	kshark_ctx->filter_mask = KS_TEXT_VIEW_FILTER_MASK |
+				  KS_GRAPH_VIEW_FILTER_MASK |
+				  KS_EVENT_VIEW_FILTER_MASK;
+
+	kshark_export_all_dstreams(kshark_ctx, &session);
+
+	ksmodel_init(&histo);
+	model = kshark_export_model(&histo, KS_CONFIG_JSON);
+	kshark_config_doc_add(session, "Model", model);
+
+	markers = kshark_config_new("kshark.config.markers", KS_CONFIG_JSON);
+	kshark_config_doc_add(session, "Markers", markers);
+
+	plugins = kshark_config_new("kshark.config.plugins", KS_CONFIG_JSON);
+	kshark_config_doc_add(session, "User Plugins", plugins);
+
+	kshark_save_config_file(session_file, session);
+	kshark_free_config_doc(session);
+
+	Py_RETURN_NONE;
+}
diff --git a/src/ksharkpy-utils.h b/src/ksharkpy-utils.h
new file mode 100644
index 0000000..6d17d2e
--- /dev/null
+++ b/src/ksharkpy-utils.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2021 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ */
+
+#ifndef _TC_KSHARK_PY_UTILS
+#define _TC_KSHARK_PY_UTILS
+
+// Python
+#include <Python.h>
+
+// trace-cruncher
+#include "common.h"
+
+C_OBJECT_WRAPPER_DECLARE(kshark_data_stream, PyKSharkStream)
+
+PyObject *PyKShark_open(PyObject *self, PyObject *args, PyObject *kwargs);
+
+PyObject *PyKShark_close(PyObject* self, PyObject* noarg);
+
+PyObject *PyKShark_open_tep_buffer(PyObject *self, PyObject *args,
+						   PyObject *kwargs);
+
+PyObject *PyKShark_set_clock_offset(PyObject* self, PyObject* args,
+						    PyObject *kwargs);
+
+PyObject *PyKShark_get_tasks(PyObject* self, PyObject* args, PyObject *kwargs);
+
+PyObject *PyKShark_event_id(PyObject *self, PyObject *args, PyObject *kwargs);
+
+PyObject *PyKShark_event_name(PyObject *self, PyObject *args,
+					      PyObject *kwargs);
+
+PyObject *PyKShark_read_event_field(PyObject *self, PyObject *args,
+						    PyObject *kwargs);
+
+PyObject *PyKShark_new_session_file(PyObject *self, PyObject *args,
+						    PyObject *kwargs);
+
+#endif
diff --git a/src/ksharkpy.c b/src/ksharkpy.c
new file mode 100644
index 0000000..7cfb94b
--- /dev/null
+++ b/src/ksharkpy.c
@@ -0,0 +1,94 @@
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
+// trace-cruncher
+#include "ksharkpy-utils.h"
+#include "common.h"
+
+extern PyObject *KSHARK_ERROR;
+extern PyObject *TRACECRUNCHER_ERROR;
+
+static PyMethodDef ksharkpy_methods[] = {
+	{"open",
+	 (PyCFunction) PyKShark_open,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Open trace data file"
+	},
+	{"close",
+	 (PyCFunction) PyKShark_close,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Close trace data file"
+	},
+	{"open_tep_buffer",
+	 (PyCFunction) PyKShark_open_tep_buffer,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Open trace data buffer"
+	},
+	{"set_clock_offset",
+	 (PyCFunction) PyKShark_set_clock_offset,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Set the clock offset of the data stream"
+	},
+	{"get_tasks",
+	 (PyCFunction) PyKShark_get_tasks,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get all tasks recorded in a trace file"
+	},
+	{"event_id",
+	 (PyCFunction) PyKShark_event_id,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get the Id of the event from its name"
+	},
+	{"event_name",
+	 (PyCFunction) PyKShark_event_name,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get the name of the event from its Id number"
+	},
+	{"read_event_field",
+	 (PyCFunction) PyKShark_read_event_field,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get the value of an event field having a given name"
+	},
+	{"new_session_file",
+	 (PyCFunction) PyKShark_new_session_file,
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
diff --git a/src/npdatawrapper.pyx b/src/npdatawrapper.pyx
new file mode 100644
index 0000000..da55d67
--- /dev/null
+++ b/src/npdatawrapper.pyx
@@ -0,0 +1,203 @@
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import ctypes
+
+# Import the Python-level symbols of numpy
+import numpy as np
+# Import the C-level symbols of numpy
+cimport numpy as np
+
+import json
+
+from libcpp cimport bool
+
+from libc.stdlib cimport free
+
+from cpython cimport PyObject, Py_INCREF
+
+from libc cimport stdint
+ctypedef stdint.int16_t int16_t
+ctypedef stdint.uint16_t uint16_t
+ctypedef stdint.int32_t int32_t
+ctypedef stdint.uint32_t uint32_t
+ctypedef stdint.int64_t int64_t
+ctypedef stdint.uint64_t uint64_t
+
+cdef extern from 'numpy/ndarraytypes.h':
+    int NPY_ARRAY_CARRAY
+
+# Numpy must be initialized!!!
+np.import_array()
+
+cdef extern from 'trace2matrix.c':
+    ssize_t trace2matrix(int stream_id,
+                         int16_t **event_array,
+                         int16_t **cpu_array,
+                         int32_t **pid_array,
+                         int64_t **offset_array,
+                         int64_t **ts_array)
+
+data_columns = ['event', 'cpu', 'pid', 'offset', 'time']
+
+data_column_types = {
+    data_columns[0]: np.NPY_INT16,
+    data_columns[1]: np.NPY_INT16,
+    data_columns[2]: np.NPY_INT32,
+    data_columns[3]: np.NPY_INT64,
+    data_columns[4]: np.NPY_UINT64
+    }
+
+cdef class KsDataWrapper:
+    cdef int item_size
+    cdef int data_size
+    cdef int data_type
+    cdef void* data_ptr
+
+    cdef init(self, int data_type,
+                    int data_size,
+                    int item_size,
+                    void* data_ptr):
+        """ This initialization cannot be done in the constructor because
+            we use C-level arguments.
+        """
+        self.item_size = item_size
+        self.data_size = data_size
+        self.data_type = data_type
+        self.data_ptr = data_ptr
+
+    def __array__(self):
+        """ Here we use the __array__ method, that is called when numpy
+            tries to get an array from the object.
+        """
+        cdef np.npy_intp shape[1]
+        shape[0] = <np.npy_intp> self.data_size
+
+        ndarray = np.PyArray_New(np.ndarray,
+                                 1, shape,
+                                 self.data_type,
+                                 NULL,
+                                 self.data_ptr,
+                                 self.item_size,
+                                 NPY_ARRAY_CARRAY,
+                                 <object>NULL)
+
+        return ndarray
+
+    def __dealloc__(self):
+        """ Free the data. This is called by Python when all the references to
+            the object are gone.
+        """
+        free(<void*>self.data_ptr)
+
+
+def load(stream_id, evt_data=True, cpu_data=True, pid_data=True,
+                    ofst_data=True, ts_data=True):
+    """ Python binding of the 'kshark_load_data_matrix' function that does not
+        copy the data. The input parameters can be used to avoid loading the
+        data from the unnecessary fields.
+    """
+    cdef int16_t *evt_c
+    cdef int16_t *cpu_c
+    cdef int32_t *pid_c
+    cdef int64_t *ofst_c
+    cdef int64_t *ts_c
+
+    cdef np.ndarray evt, cpu, pid, ofst, ts
+
+    if not evt_data:
+        evt_c = NULL
+
+    if not cpu_data:
+        cpu_c = NULL
+
+    if not pid_data:
+        pid_c = NULL
+
+    if not ofst_data:
+        ofst_c = NULL
+
+    if not ts_data:
+        ts_c = NULL
+
+    data_dict = {}
+
+    cdef ssize_t size
+
+    size = trace2matrix(stream_id, &evt_c, &cpu_c, &pid_c, &ofst_c, &ts_c)
+    if size <= 0:
+        raise Exception('No data has been loaded.')
+
+    if evt_data:
+        column = 'event'
+        array_wrapper_evt = KsDataWrapper()
+        array_wrapper_evt.init(data_type=data_column_types[column],
+                               data_size=size,
+                               item_size=0,
+                               data_ptr=<void *>evt_c)
+
+        evt = np.array(array_wrapper_evt, copy=False)
+        evt.base = <PyObject *> array_wrapper_evt
+        data_dict.update({column: evt})
+        Py_INCREF(array_wrapper_evt)
+
+    if cpu_data:
+        column = 'cpu'
+        array_wrapper_cpu = KsDataWrapper()
+        array_wrapper_cpu.init(data_type=data_column_types[column],
+                               data_size=size,
+                               item_size=0,
+                               data_ptr=<void *> cpu_c)
+
+        cpu = np.array(array_wrapper_cpu, copy=False)
+        cpu.base = <PyObject *> array_wrapper_cpu
+        data_dict.update({column: cpu})
+        Py_INCREF(array_wrapper_cpu)
+
+    if pid_data:
+        column = 'pid'
+        array_wrapper_pid = KsDataWrapper()
+        array_wrapper_pid.init(data_type=data_column_types[column],
+                               data_size=size,
+                               item_size=0,
+                               data_ptr=<void *>pid_c)
+
+        pid = np.array(array_wrapper_pid, copy=False)
+        pid.base = <PyObject *> array_wrapper_pid
+        data_dict.update({column: pid})
+        Py_INCREF(array_wrapper_pid)
+
+    if ofst_data:
+        column = 'offset'
+        array_wrapper_ofst = KsDataWrapper()
+        array_wrapper_ofst.init(data_type=data_column_types[column],
+                                data_size=size,
+                                item_size=0,
+                                data_ptr=<void *> ofst_c)
+
+
+        ofst = np.array(array_wrapper_ofst, copy=False)
+        ofst.base = <PyObject *> array_wrapper_ofst
+        data_dict.update({column: ofst})
+        Py_INCREF(array_wrapper_ofst)
+
+    if ts_data:
+        column = 'time'
+        array_wrapper_ts = KsDataWrapper()
+        array_wrapper_ts.init(data_type=data_column_types[column],
+                              data_size=size,
+                              item_size=0,
+                              data_ptr=<void *> ts_c)
+
+        ts = np.array(array_wrapper_ts, copy=False)
+        ts.base = <PyObject *> array_wrapper_ts
+        data_dict.update({column: ts})
+        Py_INCREF(array_wrapper_ts)
+
+    return data_dict
+
+def columns():
+    return data_columns
diff --git a/src/trace2matrix.c b/src/trace2matrix.c
new file mode 100644
index 0000000..1151ebe
--- /dev/null
+++ b/src/trace2matrix.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright 2019 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+// KernelShark
+#include "libkshark.h"
+
+ssize_t trace2matrix(int sd,
+		     int16_t **event_array,
+		     int16_t **cpu_array,
+		     int32_t **pid_array,
+		     int64_t **offset_array,
+		     int64_t **ts_array)
+{
+	struct kshark_generic_stream_interface *interface;
+	struct kshark_context *kshark_ctx = NULL;
+	struct kshark_data_stream *stream;
+	ssize_t total = 0;
+
+	if (!kshark_instance(&kshark_ctx))
+		return -1;
+
+	stream = kshark_get_data_stream(kshark_ctx, sd);
+	if (!stream)
+		return -1;
+
+	interface = stream->interface;
+	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
+	    interface->load_matrix) {
+		total = interface->load_matrix(stream, kshark_ctx, event_array,
+								   cpu_array,
+								   pid_array,
+								   offset_array,
+								   ts_array);
+	}
+
+	return total;
+}
-- 
2.27.0

