Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F1CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 08:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242515AbiAXI4u (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 03:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242513AbiAXI4u (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 03:56:50 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6330C06173B
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:49 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id k18so12151920wrg.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wbSbY5kMvK/xAJ4X+/0ppCRwgiYfl9PVGzfAMmaqSGo=;
        b=my22ImAYUnL8nmy1BJ71o+y3PY5t0uIMkdSOqZOh8xvmt0ggkWbonsYqo6allzicoz
         gKagR06cc3k7uZIwMOUgqi8Wj09fNsXyYNMXS/PPgtvc5vqlfMBfekIJWfWFW/sbk9Y1
         YbMTE4d3qrThhZnz4062/N2VgD+8mBpUQ4bZEp1F0QoaYt8kQQwSSVCjbEXu9RD114Oz
         VBx2v55GBImH50Rk+Kfu3MxVGKoEd2HhCNscRcxVaVlRLSkp4yR8rvU0Lz8f9QU6u0sO
         CGdE4O1Q3diH3T0Ms8DHO9+o3zVj7lf6Wc77ZFmkUWGHYWL11Uy5S9zbFolLxWUUVhTL
         5pWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wbSbY5kMvK/xAJ4X+/0ppCRwgiYfl9PVGzfAMmaqSGo=;
        b=rf3qeuoC2o1iPkF5+K4Sva0fEIS9BmfrJPVHzbkLjqfNwpomCUDrjUhVdF0qmV4sCG
         Aa7sUSMI09QYGFt1iDTazTPP1rLgccR5OMEUWHHLImAVHG412RGcOwSX3J9/jDlP1fmE
         l+L+t5GtDvmsmOWhE2uY7ZNRdH7czc/+ZcGLlSDNHRVx+xc9U9mbO+LaABUYcSU6gH2L
         olJ+4/9GTM4D16jN69H+veZfYz6YOCu94KrojrE1livQgX+eSAfVwLGNGwrqP7aTZIcB
         oqHYhBscxvfxez91Lq2rY53vSSgaR/9FWFRqr2dX7j1ByMHHGHxrzMt9YeJYeP9vsasu
         /BVw==
X-Gm-Message-State: AOAM530GxySaVMaVdEOeM30oAO/tIgznS4WdLS7mmo79DJIYxxfjFpoO
        yE8qQMagkRLnZVDg9VW/+yqklY5s8t8=
X-Google-Smtp-Source: ABdhPJxp3k9NKAA+f5J/cTUtuHi47KJ4HC6hjFIKwfZ1KyT7SK6WDP2NAZWsztb6VYlih4FOKc/e/Q==
X-Received: by 2002:adf:f083:: with SMTP id n3mr6865077wro.323.1643014607924;
        Mon, 24 Jan 2022 00:56:47 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id f14sm14828091wri.44.2022.01.24.00.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:56:47 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 01/10] trace-cruncher: Define Python type for synthetic events
Date:   Mon, 24 Jan 2022 10:56:16 +0200
Message-Id: <20220124085625.92297-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220124085625.92297-1-y.karadz@gmail.com>
References: <20220124085625.92297-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Addind new Python type and constructor for it:
synth()

The new type 'PySynthEvent will be used to implement APIs for working
with synthetic events.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 58 ++++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  5 ++++
 src/ftracepy.c       | 17 +++++++++++++
 3 files changed, 80 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index cecb180..1fcf2f8 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2426,6 +2426,64 @@ PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
 	return NULL;
 }
 
+PyObject *PyFtrace_synth(PyObject *self, PyObject *args,
+					 PyObject *kwargs)
+{
+	const char *name, *start_match, *end_match, *match_name=NULL;
+	const char *start_sys, *start_evt, *end_sys, *end_evt;
+	static char *kwlist[] = {"name",
+				 "start_sys",
+				 "start_evt",
+				 "end_sys",
+				 "end_evt",
+				 "start_match",
+				 "end_match",
+				 "match_name",
+				 NULL};
+	static struct tracefs_synth *synth;
+	struct tep_handle *tep;
+	PyObject *py_synth;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "sssssss|s",
+					 kwlist,
+					 &name,
+					 &start_sys,
+					 &start_evt,
+					 &end_sys,
+					 &end_evt,
+					 &start_match,
+					 &end_match,
+					 &match_name)) {
+		return NULL;
+	}
+
+	tep = get_tep(NULL, NULL);
+	if (!tep)
+		return NULL;
+
+	synth = tracefs_synth_alloc(tep, name,
+				    start_sys, start_evt,
+				    end_sys, end_evt,
+				    start_match, end_match,
+				    match_name);
+	tep_free(tep);
+	if (!synth) {
+		MEM_ERROR;
+		return NULL;
+	}
+
+	py_synth = PySynthEvent_New(synth);
+	/*
+	 * Here we only allocated and initializes a synthetic event object.
+	 * However, no synthetic event is added to the system yet. Hence,
+	 * there is no need to 'destroy' this event at exit.
+	 */
+	set_destroy_flag(py_synth, false);
+	return py_synth;
+}
+
 PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
 						       PyObject *kwargs)
 {
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index fc5016c..e8db811 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -30,6 +30,8 @@ C_OBJECT_WRAPPER_DECLARE(tracefs_dynevent, PyDynevent);
 
 C_OBJECT_WRAPPER_DECLARE(tracefs_hist, PyTraceHist)
 
+C_OBJECT_WRAPPER_DECLARE(tracefs_synth, PySynthEvent)
+
 PyObject *PyTepRecord_time(PyTepRecord* self);
 
 PyObject *PyTepRecord_cpu(PyTepRecord* self);
@@ -210,6 +212,9 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
 					PyObject *kwargs);
 
+PyObject *PyFtrace_synth(PyObject *self, PyObject *args,
+					 PyObject *kwargs);
+
 PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
 						       PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index f59bd4c..f8b8b36 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -221,6 +221,14 @@ C_OBJECT_WRAPPER(tracefs_hist, PyTraceHist,
 		 NO_DESTROY,
 		 tracefs_hist_free)
 
+static PyMethodDef PySynthEvent_methods[] = {
+	{NULL, NULL, 0, NULL}
+};
+
+C_OBJECT_WRAPPER(tracefs_synth, PySynthEvent,
+		 tracefs_synth_destroy,
+		 tracefs_synth_free)
+
 static PyMethodDef ftracepy_methods[] = {
 	{"dir",
 	 (PyCFunction) PyFtrace_dir,
@@ -382,6 +390,11 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Define a histogram."
 	},
+	{"synth",
+	 (PyCFunction) PyFtrace_synth,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define a synthetic event."
+	},
 	{"set_ftrace_loglevel",
 	 (PyCFunction) PyFtrace_set_ftrace_loglevel,
 	 METH_VARARGS | METH_KEYWORDS,
@@ -453,6 +466,9 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	if (!PyTraceHistTypeInit())
 		return NULL;
 
+	if (!PySynthEventTypeInit())
+		return NULL;
+
 	TFS_ERROR = PyErr_NewException("tracecruncher.ftracepy.tfs_error",
 				       NULL, NULL);
 
@@ -470,6 +486,7 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	PyModule_AddObject(module, "tracefs_instance", (PyObject *) &PyTfsInstanceType);
 	PyModule_AddObject(module, "tracefs_dynevent", (PyObject *) &PyDyneventType);
 	PyModule_AddObject(module, "tracefs_hist", (PyObject *) &PyTraceHistType);
+	PyModule_AddObject(module, "tracefs_synth", (PyObject *) &PySynthEventType);
 
 	PyModule_AddObject(module, "tfs_error", TFS_ERROR);
 	PyModule_AddObject(module, "tep_error", TEP_ERROR);
-- 
2.32.0

