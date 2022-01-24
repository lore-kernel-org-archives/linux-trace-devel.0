Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE2FBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 08:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242521AbiAXI4v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 03:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242513AbiAXI4u (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 03:56:50 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D24C06173B
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:50 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id r22so4530002wra.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rajKJMk9i6OCX0+djnhFnxB55Z2bVgQHo2bOyQaRtxc=;
        b=FlQti5Y5s4Qg8j5jccKu2EJZk1cirGzco/JpeiA/hMOuGuQQu6p2x6HZNm3+bEyQBl
         YXrvddSA5LzLs/IJULGHMvAEUqPz5ASqZVmtHF78Phz6P3ZJ3zTiIrkhVe35L282LLJV
         eyGX2CDBQ0AJ5CdcPjya3/aTYHbrNtgMjSuG/8SEUo1UCGvpajXs15LCzHxPhnuo778n
         acnVUlpVc01fRXkx1B+u7UY95isubQgskg3DciUteslnpQjQjYbVaQRzh0nDUUznoKFE
         /LFTIzGjL8thVvMqugV4oNb1Jece0e8EI8b8fu8nuigG6hldpsIVrmjwBJjNFx36o2cU
         1ubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rajKJMk9i6OCX0+djnhFnxB55Z2bVgQHo2bOyQaRtxc=;
        b=8L7VYiCO/oPaavFx4zWteckLhL8TCTmFqjIOLYULyOefH53ibbc51tvC9kAVP22Dj2
         ezIRVPUgyseUMlumcFkNoXPuqERUEO7tEkZabjuf4AakT9YQ68naJibkAneXAoKjx96r
         3N9nS8RgGa7FS+HjrzQHcC5RvciOsmnI+Blo/nF42Frx9JxIA3MioN/3pffLW8c/lpfD
         zCai+T4IwqiQTW4gvwYT0ufPCsCC3aIgatQkDipGGjldfDO1FNSOrxtMRT1HF743GECj
         E2TmJMWKpq7Ha9ZUnhBupXgVeoETd9rFvqZ1MjaVSrm0At7QGVetelY8UkgLLUqVUB5W
         VPCg==
X-Gm-Message-State: AOAM532fdVFPGS5xiYxThFQIAFiuyivZjfReHGAkpdBRS3EyX14XgjDE
        IMuJfYiEoCl9PmR5nzwTAkrJqToMpeU=
X-Google-Smtp-Source: ABdhPJzHJQIOE4h3RF1mEocR485L13Pd87Ry3yJzm1hGqS9VTLwdH/U9QPHYyHm77KrzXJ4rNv9awA==
X-Received: by 2002:a05:6000:1846:: with SMTP id c6mr12114426wri.244.1643014608809;
        Mon, 24 Jan 2022 00:56:48 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id f14sm14828091wri.44.2022.01.24.00.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:56:48 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 02/10] trace-cruncher: APIs for adding start/end fields to synth. event
Date:   Mon, 24 Jan 2022 10:56:17 +0200
Message-Id: <20220124085625.92297-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220124085625.92297-1-y.karadz@gmail.com>
References: <20220124085625.92297-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Here we add the following methods to the Python type for synthetic
events:
add_start_fields()
add_end_fields()

The new APIs allows for adding fields from the original 'start' and
'end' events to the new synthetic event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 64 ++++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  6 +++++
 src/ftracepy.c       | 10 +++++++
 3 files changed, 80 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 1fcf2f8..42bd9d0 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1009,6 +1009,70 @@ PyObject *PyTraceHist_close(PyTraceHist *self, PyObject *args,
 	Py_RETURN_NONE;
 }
 
+typedef int (*add_field_ptr)(struct tracefs_synth *,
+			     const char *,
+			     const char *);
+
+PyObject *synth_add_fields(PySynthEvent *self, PyObject *args,
+					       PyObject *kwargs,
+					       bool to_start)
+{
+	static char *kwlist[] = {"fields", "names", NULL};
+	PyObject *py_fields, *py_names = NULL;
+	PyObject *item_field, *item_name;
+	add_field_ptr add_field_func;
+	const char *field, *name;
+	int ret, n, i;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "O|O",
+					 kwlist,
+					 &py_fields,
+					 &py_names)) {
+		return NULL;
+	}
+
+	add_field_func = to_start ? tracefs_synth_add_start_field:
+				    tracefs_synth_add_end_field;
+
+	n = PyList_Size(py_fields);
+	for (i = 0; i < n; ++i) {
+		item_field = PyList_GetItem(py_fields, i);
+		field = PyUnicode_DATA(item_field);
+
+		name = NULL;
+		if (py_names) {
+			item_name = PyList_GetItem(py_names, i);
+			if (item_name && item_name != Py_None)
+				name = PyUnicode_DATA(item_name);
+		}
+
+		ret = add_field_func(self->ptrObj, field, name);
+		if (ret < 0) {
+			TfsError_fmt(NULL,
+				     "Failed to add %s field '%s' to synth. event %s",
+				     to_start ? "start" : "end", field,
+				     tracefs_synth_get_name(self->ptrObj));
+			return NULL;
+		}
+	}
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PySynthEvent_add_start_fields(PySynthEvent *self, PyObject *args,
+							    PyObject *kwargs)
+{
+	return synth_add_fields(self, args, kwargs, true);
+}
+
+PyObject *PySynthEvent_add_end_fields(PySynthEvent *self, PyObject *args,
+							  PyObject *kwargs)
+{
+	return synth_add_fields(self, args, kwargs, false);
+}
+
 PyObject *PyFtrace_dir(PyObject *self)
 {
 	return PyUnicode_FromString(tracefs_tracing_dir());
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index e8db811..3c6c0f3 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -121,6 +121,12 @@ PyObject *PyTraceHist_read(PyTraceHist *self, PyObject *args,
 PyObject *PyTraceHist_close(PyTraceHist *self, PyObject *args,
 					       PyObject *kwargs);
 
+PyObject *PySynthEvent_add_start_fields(PySynthEvent *self, PyObject *args,
+							    PyObject *kwargs);
+
+PyObject *PySynthEvent_add_end_fields(PySynthEvent *self, PyObject *args,
+							  PyObject *kwargs);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index f8b8b36..44114f0 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -222,6 +222,16 @@ C_OBJECT_WRAPPER(tracefs_hist, PyTraceHist,
 		 tracefs_hist_free)
 
 static PyMethodDef PySynthEvent_methods[] = {
+	{"add_start_fields",
+	 (PyCFunction) PySynthEvent_add_start_fields,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Add fields from the start event to save."
+	},
+	{"add_end_fields",
+	 (PyCFunction) PySynthEvent_add_end_fields,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Add fields from the end event to save."
+	},
 	{NULL, NULL, 0, NULL}
 };
 
-- 
2.32.0

