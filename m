Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E3EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Dec 2021 14:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhLGOc6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 09:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237856AbhLGOb5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 09:31:57 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D24C061756
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Dec 2021 06:28:26 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d9so29874283wrw.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Dec 2021 06:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5mntc0vhosG10WMV5xHBTZ0znfCGEgAACzGwNlutXsQ=;
        b=XFBoMEhvg+rG5/bwSfhs1GZIzO8MFmYF/z2bXc6W3pL36Qde0reYIoI35wkoMuv/VA
         8ILe+uuHlKUNWsBytNWefFcrt94E3GBl3vIUzSK6/CvL/HMlkZY2vwmiQp3likifrmhq
         D43D9dZs3Oo3c0NrbWGAak1awdyShFrMAoWLonqAHCocZiIgRcwFPgfaMKg7wNcUEqj0
         hWfHknMHJ4QNlwVBeUubUWlLUAu+slDFB8nyD3+Lvgs4GeEnnDYK3UJxaQ61K2sksFvv
         Ez9sgJOISpweocr+CdDGeRESSeTyL1/EUc7quUXlUIGWjDRh4I8QMq3vgtmUbTabJ7iB
         f6VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5mntc0vhosG10WMV5xHBTZ0znfCGEgAACzGwNlutXsQ=;
        b=BpoNsz2rVepEUq6qH6r7uXSiL4rwvI5LSaOghdqAxXeoNOwywdfRGCZEKgd8p2UqyQ
         3nTonObDlfvhdqm/qMoFFWD9JZsWZToTuZl2XF8SmuNUYpUW/GSNFTZ/8dNWwMYXbUeU
         EptwrNRgGfWY98L+qZZ2agmIa3I+Zg1/G/3RNla4UY0+dydrxpDt1D2O6UY8dbMa+zaY
         kO7tT7BgNo61RoPjxg1joPWl5PkHAqN5mDZmSOTj5HY9ZJy7mYKRcDhbx+u6XaC8hEhh
         /3PlQOgbLy4WlNF8iHgkactPvy0Y/RBYX7pPWoHh20PFCcYDt4mejaaxYeyb0TC0ik+G
         ZBPg==
X-Gm-Message-State: AOAM5331aQSs+Pw6eK2TVNW4qAiOxpdfdujbFCS9SGNwYlHfIzDp2E4G
        2lem/Otbo4/d414IT8FRkUxp9dN/UAM=
X-Google-Smtp-Source: ABdhPJz/8ZJY5gEW3WGOxn4KvhCt0BgCGgzpybPjoDX3cVCZvCjjD60LZGEBqmJFrEK9yVMQOpGDjA==
X-Received: by 2002:adf:e484:: with SMTP id i4mr53120167wrm.49.1638887305233;
        Tue, 07 Dec 2021 06:28:25 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id l4sm14301428wrv.94.2021.12.07.06.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:28:24 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/5] trace-cruncher: Add APIs to setup a histogram
Date:   Tue,  7 Dec 2021 16:28:09 +0200
Message-Id: <20211207142811.398929-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207142811.398929-1-y.karadz@gmail.com>
References: <20211207142811.398929-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

More methods for controlling the data acquisition of the histogram
are added.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 129 +++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |   9 +++
 src/ftracepy.c       |  15 +++++
 3 files changed, 153 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 65aca81..d7e6d6a 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -707,6 +707,135 @@ PyObject *PyTfsInstance_dir(PyTfsInstance *self)
 	return PyUnicode_FromString(tracefs_instance_get_dir(self->ptrObj));
 }
 
+PyObject *PyTraceHist_add_value(PyTraceHist *self, PyObject *args,
+						   PyObject *kwargs)
+{
+	static char *kwlist[] = {"value", NULL};
+	const char *value;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "s",
+					 kwlist,
+					 &value)) {
+		return NULL;
+	}
+
+	if (tracefs_hist_add_value(self->ptrObj, value) < 0) {
+		MEM_ERROR
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
+const char *hist_noname = "unnamed";
+static inline const char *get_hist_name(struct tracefs_hist *hist)
+{
+	const char *name = tracefs_hist_get_name(hist);
+	return name ? name : hist_noname;
+}
+
+static bool add_sort_key(struct tracefs_hist *hist,
+			 const char *sort_key)
+{
+	if (tracefs_hist_add_sort_key(hist, sort_key) < 0) {
+		TfsError_fmt(NULL,
+			     "Failed to add sort key \'%s\'to histogram \'%s\'.",
+			     sort_key, get_hist_name(hist));
+		return false;
+	}
+
+	return true;
+}
+
+PyObject *PyTraceHist_sort_keys(PyTraceHist *self, PyObject *args,
+						   PyObject *kwargs)
+{
+	static char *kwlist[] = {"keys", NULL};
+	PyObject *py_obj;
+	const char *key;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "O",
+					 kwlist,
+					 &py_obj)) {
+		return NULL;
+	}
+
+	if (PyUnicode_Check(py_obj)) {
+		if (!add_sort_key(self->ptrObj, PyUnicode_DATA(py_obj)))
+			return NULL;
+	} else if (PyList_CheckExact(py_obj)) {
+		int i, n = PyList_Size(py_obj);
+
+		for (i = 0; i < n; ++i) {
+			key = str_from_list(py_obj, i);
+			if (!key ||
+			    !add_sort_key(self->ptrObj, key)) {
+				PyErr_SetString(TRACECRUNCHER_ERROR,
+						"Inconsistent \"keys\" argument.");
+				return NULL;
+			}
+		}
+	}
+
+	Py_RETURN_NONE;
+}
+
+static int sort_direction(PyObject *py_dir)
+{
+	int dir = -1;
+
+	if (PyLong_CheckExact(py_dir)) {
+		dir = PyLong_AsLong(py_dir);
+	} else if (PyUnicode_Check(py_dir)) {
+		const char *dir_str =  PyUnicode_DATA(py_dir);
+
+		if (lax_cmp(dir_str, "descending") ||
+		    lax_cmp(dir_str, "desc") ||
+		    lax_cmp(dir_str, "d"))
+			dir = 1;
+		else if (lax_cmp(dir_str, "ascending") ||
+			 lax_cmp(dir_str, "asc") ||
+			 lax_cmp(dir_str, "a"))
+			dir = 0;
+	}
+
+	return dir;
+}
+
+PyObject *PyTraceHist_sort_key_direction(PyTraceHist *self, PyObject *args,
+							    PyObject *kwargs)
+{
+	static char *kwlist[] = {"sort_key", "direction", NULL};
+	const char *sort_key;
+	PyObject *py_dir;
+	int dir;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "sO",
+					 kwlist,
+					 &sort_key,
+					 &py_dir)) {
+		return NULL;
+	}
+
+	dir = sort_direction(py_dir);
+
+	if (dir < 0 ||
+	    tracefs_hist_sort_key_direction(self->ptrObj, sort_key, dir) < 0) {
+		TfsError_fmt(NULL,
+			     "Failed to add sort direction to histogram \'%s\'.",
+			     get_hist_name(self->ptrObj));
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
 PyObject *PyFtrace_dir(PyObject *self)
 {
 	return PyUnicode_FromString(tracefs_tracing_dir());
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index f69a6d4..07d2cac 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -92,6 +92,15 @@ PyObject *PyDynevent_disable(PyDynevent *self, PyObject *args,
 PyObject *PyDynevent_is_enabled(PyDynevent *self, PyObject *args,
 					      PyObject *kwargs);
 
+PyObject *PyTraceHist_add_value(PyTraceHist *self, PyObject *args,
+						   PyObject *kwargs);
+
+PyObject *PyTraceHist_sort_keys(PyTraceHist *self, PyObject *args,
+						   PyObject *kwargs);
+
+PyObject *PyTraceHist_sort_key_direction(PyTraceHist *self, PyObject *args,
+							    PyObject *kwargs);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 7891b5e..b91cda9 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -169,6 +169,21 @@ C_OBJECT_WRAPPER(tracefs_dynevent, PyDynevent,
 		 tracefs_dynevent_free)
 
 static PyMethodDef PyTraceHist_methods[] = {
+	{"add_value",
+	 (PyCFunction) PyTraceHist_add_value,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Add value field."
+	},
+	{"sort_keys",
+	 (PyCFunction) PyTraceHist_sort_keys,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Set key felds or values to sort on."
+	},
+	{"sort_key_direction",
+	 (PyCFunction) PyTraceHist_sort_key_direction,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Set the direction of a sort key field."
+	},
 	{NULL, NULL, 0, NULL}
 };
 
-- 
2.32.0

