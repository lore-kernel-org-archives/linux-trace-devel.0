Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F220BC43219
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Dec 2021 14:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbhLGOc7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 09:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237866AbhLGOb6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 09:31:58 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989F6C061574
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Dec 2021 06:28:27 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id o29so10897784wms.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Dec 2021 06:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=86EnBuBtzOkEEQl6woqYAHGPHxdw2X57ltfWql36Swo=;
        b=MN3eWgWq6pPTr9eVpm7CsYB5oyeG51t8gIVL/JscoDRH4kEYBArJNdp8uDJIHQIDMj
         gaDRIkIzzNri1GnfFQQaclOIroZx3zAr5DTBHPBmwI7RG+rzt2Nj0ehrJbu58EVVkzTM
         pEWVGWaKSp0KdwqarOdKGM8YUIvs3YA+Xh2CvSjRiFaa+0oeoCA+vn5Boe8LbzE6Xwmz
         ocbvSh4YHssDMx0mqFqQ5vkJGkjQLTag8S62l+wGTeMncj0bBzAtyC2Il0vjn+hMd76E
         pfWT37lDxj5B5p8PF1Qi69uw92yYcpOFz1x7zZaAEbOk3NECe3hLfJgbsbK1MI4lBzBq
         GvjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=86EnBuBtzOkEEQl6woqYAHGPHxdw2X57ltfWql36Swo=;
        b=VNu5ytE5DO1a0QPH+Od77sDu2663Kd3MPkf51hPANc3slPRypBAc7SS41uC9Z2Ki8t
         4aCkyA1vEZH5PSpHGP/AOQh3EuEgq/HQdigN841eN4jpWWEpXWxEBbFFIU+jaKCf9YfZ
         w2IeNAByza5cpvvUcae3f8+WLrPeMYIfnCIbslNqsKQBvV32kHOQR4bswAya5X9Lanj6
         N756C3lTMpj5KbAZBe9ykA9+Ww3EssxvktOUBoEUi06JvADnCpqOiq+wlPkixCHZa6DJ
         uXtNvXC7xuTb0yyIP4S16iJo+fCJfPhnPZEXeOdq55PQV+ci+qw4pLfiUJj5/poGAh17
         5bXA==
X-Gm-Message-State: AOAM530ttQ5ZwZYfrMEJGBp6+pgzZyZ3Drw0r13U2HCafmT5i3tFV2wd
        Z0mjJUvU0WfzriYEBsaHMwZtZZFBdmw=
X-Google-Smtp-Source: ABdhPJxNnVrvCwJ5rZ/2Za7V7Dg5dFnhRxXJ/wMN0Lwx4KaOyTUfxp6QdDgMPs2fV1siBtrjObBtkA==
X-Received: by 2002:a05:600c:500b:: with SMTP id n11mr7514965wmr.38.1638887306027;
        Tue, 07 Dec 2021 06:28:26 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id l4sm14301428wrv.94.2021.12.07.06.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:28:25 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/5] trace-cruncher: Add APIs for histogram control
Date:   Tue,  7 Dec 2021 16:28:10 +0200
Message-Id: <20211207142811.398929-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207142811.398929-1-y.karadz@gmail.com>
References: <20211207142811.398929-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is an almost direct wrapping of the corresponding APIs defined in
libtracefs. The 'continue' API (tracefs_hist_continue()) gets renamed
to resume(), because 'continue' is a keyword in Python.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 202 ++++++++++++++++++++++++++++++++++---------
 src/ftracepy-utils.h |  18 ++++
 src/ftracepy.c       |  30 +++++++
 3 files changed, 207 insertions(+), 43 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index d7e6d6a..a735d88 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -836,6 +836,165 @@ PyObject *PyTraceHist_sort_key_direction(PyTraceHist *self, PyObject *args,
 	Py_RETURN_NONE;
 }
 
+static bool get_optional_instance(PyObject *py_obj,
+				  struct tracefs_instance **instance)
+{
+	PyTfsInstance *py_inst;
+
+	if (!py_obj) {
+		*instance = NULL;
+		return true;
+	}
+
+	if (!PyTfsInstance_Check(py_obj)) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Passing argument \'instance\' with incompatible type.");
+		return false;
+	}
+
+	py_inst = (PyTfsInstance *)py_obj;
+	*instance = py_inst->ptrObj;
+
+	return true;
+}
+
+bool get_instance_from_arg(PyObject *args, PyObject *kwargs,
+			   struct tracefs_instance **instance)
+{
+	static char *kwlist[] = {"instance", NULL};
+	PyObject *py_inst = NULL;
+	*instance = NULL;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "|O",
+					 kwlist,
+					 &py_inst)) {
+		return false;
+	}
+
+	if (!get_optional_instance(py_inst, instance))
+		return NULL;
+
+	return true;
+}
+
+static bool hist_cmd(PyTraceHist *self, PyObject *args, PyObject *kwargs,
+		     enum tracefs_hist_command cmd,
+		     const char *err_msg)
+{
+	struct tracefs_instance *instance;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	if (tracefs_hist_command(instance, self->ptrObj, cmd) < 0) {
+		char *buff;
+
+		if (asprintf(&buff, "%s %s",
+			     err_msg, get_hist_name(self->ptrObj)) <= 0) {
+			MEM_ERROR;
+			return false;
+		}
+
+		TfsError_setstr(instance, buff);
+		free(buff);
+
+		return false;
+	}
+
+	return true;
+}
+
+PyObject *PyTraceHist_start(PyTraceHist *self, PyObject *args,
+					       PyObject *kwargs)
+{
+	if (!hist_cmd(self, args, kwargs,
+		      TRACEFS_HIST_CMD_START,
+		      "Failed to start filling the histogram"))
+		return false;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyTraceHist_stop(PyTraceHist *self, PyObject *args,
+					      PyObject *kwargs)
+{
+	if (!hist_cmd(self, args, kwargs,
+		      TRACEFS_HIST_CMD_PAUSE,
+		      "Failed to stop filling the histogram"))
+		return false;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyTraceHist_resume(PyTraceHist *self, PyObject *args,
+						PyObject *kwargs)
+{
+	if (!hist_cmd(self, args, kwargs,
+		      TRACEFS_HIST_CMD_CONT,
+		      "Failed to resume filling the histogram"))
+		return false;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PyTraceHist_clear(PyTraceHist *self, PyObject *args,
+					       PyObject *kwargs)
+{
+	if (!hist_cmd(self, args, kwargs,
+		      TRACEFS_HIST_CMD_CLEAR,
+		      "Failed to clear the histogram"))
+		return false;
+
+	Py_RETURN_NONE;
+}
+
+static char *hist_read(PyTraceHist *self, PyObject *args,
+					  PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+	const char *hist_file = "hist";
+	char *data;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	data = tracefs_event_file_read(instance,
+				       tracefs_hist_get_system(self->ptrObj),
+				       tracefs_hist_get_event(self->ptrObj),
+				       hist_file,
+				       NULL);
+	if (!data) {
+		TfsError_fmt(instance,
+			     "Failed read data from histogram \'%s\'.",
+			     get_hist_name(self->ptrObj));
+	}
+
+	return data;
+}
+
+PyObject *PyTraceHist_read(PyTraceHist *self, PyObject *args,
+					      PyObject *kwargs)
+{
+	char *data = hist_read(self, args, kwargs);
+	PyObject *ret = PyUnicode_FromString(data);
+
+	free(data);
+	return ret;
+}
+
+PyObject *PyTraceHist_close(PyTraceHist *self, PyObject *args,
+					       PyObject *kwargs)
+{
+	if (!hist_cmd(self, args, kwargs,
+		      TRACEFS_HIST_CMD_DESTROY,
+		      "Failed to close the histogram"))
+		return false;
+
+	Py_RETURN_NONE;
+}
+
 PyObject *PyFtrace_dir(PyObject *self)
 {
 	return PyUnicode_FromString(tracefs_tracing_dir());
@@ -967,49 +1126,6 @@ PyObject *PyFtrace_find_instance(PyObject *self, PyObject *args,
 	return py_inst;
 }
 
-static bool get_optional_instance(PyObject *py_obj,
-				  struct tracefs_instance **instance)
-{
-	PyTfsInstance *py_inst;
-
-	if (!py_obj) {
-		*instance = NULL;
-		return true;
-	}
-
-	if (!PyTfsInstance_Check(py_obj)) {
-		PyErr_SetString(TRACECRUNCHER_ERROR,
-				"Passing argument \'instance\' with incompatible type.");
-		return false;
-	}
-
-	py_inst = (PyTfsInstance *)py_obj;
-	*instance = py_inst->ptrObj;
-
-	return true;
-}
-
-bool get_instance_from_arg(PyObject *args, PyObject *kwargs,
-			   struct tracefs_instance **instance)
-{
-	static char *kwlist[] = {"instance", NULL};
-	PyObject *py_inst = NULL;
-	*instance = NULL;
-
-	if (!PyArg_ParseTupleAndKeywords(args,
-					 kwargs,
-					 "|O",
-					 kwlist,
-					 &py_inst)) {
-		return false;
-	}
-
-	if (!get_optional_instance(py_inst, instance))
-		return NULL;
-
-	return true;
-}
-
 PyObject *PyFtrace_available_tracers(PyObject *self, PyObject *args,
 						     PyObject *kwargs)
 {
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 07d2cac..d09c8bf 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -101,6 +101,24 @@ PyObject *PyTraceHist_sort_keys(PyTraceHist *self, PyObject *args,
 PyObject *PyTraceHist_sort_key_direction(PyTraceHist *self, PyObject *args,
 							    PyObject *kwargs);
 
+PyObject *PyTraceHist_start(PyTraceHist *self, PyObject *args,
+					       PyObject *kwargs);
+
+PyObject *PyTraceHist_stop(PyTraceHist *self, PyObject *args,
+					      PyObject *kwargs);
+
+PyObject *PyTraceHist_resume(PyTraceHist *self, PyObject *args,
+						PyObject *kwargs);
+
+PyObject *PyTraceHist_clear(PyTraceHist *self, PyObject *args,
+					       PyObject *kwargs);
+
+PyObject *PyTraceHist_read(PyTraceHist *self, PyObject *args,
+					      PyObject *kwargs);
+
+PyObject *PyTraceHist_close(PyTraceHist *self, PyObject *args,
+					       PyObject *kwargs);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index b91cda9..b270b71 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -184,6 +184,36 @@ static PyMethodDef PyTraceHist_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Set the direction of a sort key field."
 	},
+	{"start",
+	 (PyCFunction) PyTraceHist_start,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Start acquiring data."
+	},
+	{"stop",
+	 (PyCFunction) PyTraceHist_stop,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Pause acquiring data."
+	},
+	{"resume",
+	 (PyCFunction) PyTraceHist_resume,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Continue acquiring data."
+	},
+	{"clear",
+	 (PyCFunction) PyTraceHist_clear,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Reset the histogram."
+	},
+	{"read",
+	 (PyCFunction) PyTraceHist_read,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Read the content of the histogram."
+	},
+	{"close",
+	 (PyCFunction) PyTraceHist_close,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Destroy the histogram."
+	},
 	{NULL, NULL, 0, NULL}
 };
 
-- 
2.32.0

