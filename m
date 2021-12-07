Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B29BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Dec 2021 14:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237846AbhLGOcR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 09:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237839AbhLGOb4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 09:31:56 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08807C061746
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Dec 2021 06:28:26 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id o19-20020a1c7513000000b0033a93202467so2392639wmc.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Dec 2021 06:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8WTjFjW876c7LlU+YgLkZPoPKQFSmCbeAnNAGsO90AY=;
        b=O/trcgVbVBKlaQh7qrBub0DIW9OJOKXzmCfpa5OIu5Ma6m13554lMmiNj8MnkamlkN
         Jdnk0dLwzPvcA7GXiGyaCtIQ/ZcMc+zixXoNQ27axMzcaRyEXpH4NpT2ZfueCAE9jijS
         6iVMPmuSi/04ULQEO0Vov7EknQwWkTPq/TDuBr/+Ufh8q2tXXGQZ2MNJqdXqCNmOHbFK
         LyHUWxQ5IhkWu6pFt8P0L4BY+GO7Oiz5KRfRsQm0wYEJYoF6XuLmi5wILUD/6dxyWWR/
         T10Wyc9MTYvhhOpiBQjEsbi+1hUU5Ikq1jRcGj12/AzWv2TSjB9G0XD29xlbrL5mzbag
         dOQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8WTjFjW876c7LlU+YgLkZPoPKQFSmCbeAnNAGsO90AY=;
        b=1MzM2Hn5Z6HqnwXguybQoXG9acNQn12QmtQJz1rBFJd5IegCAfcIpLbZQ5FRXNvz0e
         2S0ccVVhnxSwxemIYUIz06NS9ute6F0DakT5XU9QWhIHfHA5USYWGxnOu8ByRV/3W3Sq
         uOayps0HC5acONHO9H3KS1PHitnhEuDbvQiL65wD+AF9GgiTVWhQm/FZc4CmGCQ+3fdP
         F1ZloM29SgIgsF88HE5xaRfp9Zd+LoRUGzfg8JLT6lLxPJw+pDyy4r+J2EMnzKIwRX+4
         c9szJ/VvGASBktGaG8XUiCaLIdH8SogPZ5v5LypkXX2GF+ejMdXPimgBVU3BQtXufuo+
         GwRQ==
X-Gm-Message-State: AOAM530zTdDH6GXrceSJll0pj2gLmB8ivWVFJS9nkfpJ3dKxKxhV/crC
        K/T1Xh1GMSYN+W7N0CFQLrfjNRcRNHI=
X-Google-Smtp-Source: ABdhPJwMmndqmN29CxsY1KlkAXjO+LhGk+fqTBcqb0UDwToYvjivCymQ2cuuH13v+7MPWTg6Vj56WQ==
X-Received: by 2002:a05:600c:4f8a:: with SMTP id n10mr7233327wmq.54.1638887304341;
        Tue, 07 Dec 2021 06:28:24 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id l4sm14301428wrv.94.2021.12.07.06.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:28:24 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/5] trace-cruncher: Define constructor for trace histograms
Date:   Tue,  7 Dec 2021 16:28:08 +0200
Message-Id: <20211207142811.398929-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207142811.398929-1-y.karadz@gmail.com>
References: <20211207142811.398929-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A method for creating histogram objects is added. The optional arguments
of the method allows for variety of ways to create histograms.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/common.h         |  10 ++-
 src/ftracepy-utils.c | 195 +++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |   3 +
 src/ftracepy.c       |   5 ++
 4 files changed, 210 insertions(+), 3 deletions(-)

diff --git a/src/common.h b/src/common.h
index 9eee563..eacea7d 100644
--- a/src/common.h
+++ b/src/common.h
@@ -26,10 +26,9 @@ static const char *NO_ARG = "/NONE/";
 
 #define TC_NIL_MSG	"(nil)"
 
-static inline bool is_all(const char *arg)
+static inline bool lax_cmp(const char *arg, const char *model)
 {
-	const char all[] = "all";
-	const char *p = &all[0];
+	const char *p = &model[0];
 
 	for (; *arg; arg++, p++) {
 		if (tolower(*arg) != *p)
@@ -38,6 +37,11 @@ static inline bool is_all(const char *arg)
 	return !(*p);
 }
 
+static inline bool is_all(const char *arg)
+{
+	return lax_cmp(arg, "all");
+}
+
 static inline bool is_no_arg(const char *arg)
 {
 	return arg[0] == '\0' || arg == NO_ARG;
diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 7f3daca..65aca81 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1954,6 +1954,201 @@ PyObject *PyDynevent_is_enabled(PyDynevent *self, PyObject *args,
 	return ret;
 }
 
+static enum tracefs_hist_key_type hist_key_type(PyObject * py_type)
+{
+	int type = -1;
+
+	if (PyUnicode_Check(py_type)) {
+		const char *type_str = PyUnicode_DATA(py_type);
+
+		if (lax_cmp(type_str, "normal") ||
+		    lax_cmp(type_str, "n") )
+			type = TRACEFS_HIST_KEY_NORMAL;
+		else if (lax_cmp(type_str, "hex") ||
+			 lax_cmp(type_str, "h") )
+			type = TRACEFS_HIST_KEY_HEX;
+		else if (lax_cmp(type_str, "sym"))
+			 type = TRACEFS_HIST_KEY_SYM;
+		else if (lax_cmp(type_str, "sym_offset") ||
+			 lax_cmp(type_str, "so"))
+			type = TRACEFS_HIST_KEY_SYM_OFFSET;
+		else if (lax_cmp(type_str, "syscall") ||
+			 lax_cmp(type_str, "sc"))
+			type = TRACEFS_HIST_KEY_SYSCALL;
+		else if (lax_cmp(type_str, "execname") ||
+			 lax_cmp(type_str, "e"))
+			 type = TRACEFS_HIST_KEY_EXECNAME;
+		else if (lax_cmp(type_str, "log") ||
+			 lax_cmp(type_str, "l"))
+			type = TRACEFS_HIST_KEY_LOG;
+		else if (lax_cmp(type_str, "users") ||
+			 lax_cmp(type_str, "u"))
+			type = TRACEFS_HIST_KEY_USECS;
+		else if (lax_cmp(type_str, "max") ||
+			 lax_cmp(type_str, "m"))
+			type = TRACEFS_HIST_KEY_MAX;
+		else {
+			TfsError_fmt(NULL, "Unknown axis type %s\n",
+				     type_str);
+		}
+	} else if (PyLong_CheckExact(py_type)) {
+		type = PyLong_AsLong(py_type);
+	} else {
+		TfsError_fmt(NULL, "Unknown axis type %s\n");
+	}
+
+	return type;
+}
+
+static struct tracefs_hist *hist_from_key(struct tep_handle *tep,
+					  const char *system, const char *event,
+					  PyObject *py_key, PyObject * py_type)
+{
+	struct tracefs_hist *hist = NULL;
+	int type = 0;
+
+	if (PyUnicode_Check(py_key)) {
+		if (py_type) {
+			type = hist_key_type(py_type);
+			if (type < 0)
+				return NULL;
+		}
+
+		hist = tracefs_hist_alloc(tep, system, event,
+					  PyUnicode_DATA(py_key), type);
+	} else if (PyList_CheckExact(py_key)) {
+		int i, n_keys = PyList_Size(py_key);
+		struct tracefs_hist_axis *axes;
+		PyObject *item_type;
+
+		if (py_type) {
+			/*
+			 * The format of the types have to match the format
+			 * of the keys.
+			 */
+			if (!PyList_CheckExact(py_key) ||
+			    PyList_Size(py_type) != n_keys)
+				return NULL;
+		}
+
+		axes = calloc(n_keys + 1, sizeof(*axes));
+		if (!axes) {
+			MEM_ERROR
+			return NULL;
+		}
+
+		for (i = 0; i < n_keys; ++i) {
+			axes[i].key = str_from_list(py_key, i);
+			if (!axes[i].key)
+				return NULL;
+
+			if (py_type) {
+				item_type = PyList_GetItem(py_type, i);
+				if (!PyLong_CheckExact(item_type))
+					return NULL;
+
+				type = hist_key_type(item_type);
+				if (type < 0)
+					return NULL;
+
+				axes[i].type = type;
+			}
+		}
+
+		hist = tracefs_hist_alloc_nd(tep, system, event, axes);
+		free(axes);
+	}
+
+	return hist;
+}
+
+static struct tracefs_hist *hist_from_axis(struct tep_handle *tep,
+					   const char *system, const char *event,
+					   PyObject *py_axes)
+{
+	struct tracefs_hist *hist = NULL;
+	struct tracefs_hist_axis *axes;
+	PyObject *key, *value;
+	Py_ssize_t i = 0;
+	int n_axes;
+
+	n_axes = PyDict_Size(py_axes);
+	if (PyErr_Occurred())
+		return NULL;
+
+	axes = calloc(n_axes + 1, sizeof(*axes));
+	if (!axes) {
+		MEM_ERROR
+		return NULL;
+	}
+
+	while (PyDict_Next(py_axes, &i, &key, &value)) {
+		axes[i - 1].key = PyUnicode_DATA(key);
+		axes[i - 1].type = hist_key_type(value);
+		if (PyErr_Occurred()) {
+			PyErr_Print();
+			free(axes);
+			return NULL;
+		}
+	}
+
+	hist = tracefs_hist_alloc_nd(tep, system, event, axes);
+	free(axes);
+
+	return hist;
+}
+
+PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
+					PyObject *kwargs)
+{
+	static char *kwlist[] =
+		{"system", "event", "key", "type", "axes", "name", NULL};
+	PyObject *py_axes = NULL, *py_key = NULL, *py_type = NULL;
+	const char *system, *event, *name = NULL;
+	struct tracefs_hist *hist = NULL;
+	struct tep_handle *tep;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "ss|OOOs",
+					 kwlist,
+					 &system,
+					 &event,
+					 &py_key,
+					 &py_type,
+					 &py_axes,
+					 &name)) {
+		return NULL;
+	}
+
+	tep = tracefs_local_events(tracefs_tracing_dir());
+	if (!tep)
+		goto fail;
+
+	if (py_key && ! py_axes) {
+		hist = hist_from_key(tep, system, event, py_key, py_type);
+	} else if (!py_key && py_axes) {
+		hist = hist_from_axis(tep, system, event, py_axes);
+	} else {
+		TfsError_setstr(NULL, "'key' or 'axis' must be provided.");
+		return NULL;
+	}
+
+	if (!hist)
+		goto fail;
+
+	if (name && tracefs_hist_add_name(hist, name) < 0)
+		goto fail;
+
+	return PyTraceHist_New(hist);
+
+ fail:
+	TfsError_fmt(NULL, "Failed to create histogram for %s/%s",
+		     system, event);
+	tracefs_hist_free(hist);
+	return NULL;
+}
+
 PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
 						       PyObject *kwargs)
 {
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index da31998..f69a6d4 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -178,6 +178,9 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 						      PyObject *kwargs);
 
+PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
+					PyObject *kwargs);
+
 PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
 						       PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 0f06796..7891b5e 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -327,6 +327,11 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Define a kretprobe."
 	},
+	{"hist",
+	 (PyCFunction) PyFtrace_hist,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define a histogram."
+	},
 	{"set_ftrace_loglevel",
 	 (PyCFunction) PyFtrace_set_ftrace_loglevel,
 	 METH_VARARGS | METH_KEYWORDS,
-- 
2.32.0

