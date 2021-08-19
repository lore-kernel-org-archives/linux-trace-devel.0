Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C736AC4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADDD061152
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239151AbhHSNJX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 09:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239334AbhHSNJW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 09:09:22 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27D7C061757
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:45 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x12so9000160wrr.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cciFYLyq7aMFAOob86mDspLiwDNUue0Eur+CQfHphBU=;
        b=fJxwa8WNldtTzbUvzLa8mZIW4YaSrRLciSAsEXVEtq1qhbVYKC6A8i0XOCHpB/ZGkw
         hVKMkIPunrKFUCB072qka8TsgPHUpkdynXz6pfjwBsF8uTmdpjFqGRydJjPK1bCAnRZ9
         CI772Qfo4Mpib0KBK4PbHAhWRNvzXKloWAI6ddZx57K6IfpvoYhDMDCU3wcb6kWqAF05
         OAdMVJPO5zTBx1C/KqF2AN4G+b3qZHq7Rn9IGN4+HvKwBRGMQ6rYA2GPqTYdUgKlZlxd
         GGHbDW56VrGPmvaUoJjdro9Qlmr3/e/kn+E/53ohEmiXxF06dlo5hKab1NbrU168igUP
         8q6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cciFYLyq7aMFAOob86mDspLiwDNUue0Eur+CQfHphBU=;
        b=L/QCaAc+vnEb0y5MxyK4AFoq7BFtVlVJ1zoB8Fb3S4tFCEXj7ELDaaM6NIL6rgbfoW
         qJlHiSl/QjFpctsloQqFfP8ZQaErdDj45idglqc+rrH69r1oF/jeGKXbQM2puGV5RRID
         H6tGIH1ycBZPt+1SG+I4sbSk7Ms7Ke0Wero5j4TgmhWOqYkgh/CJNezfSKpJ5YAp8IUJ
         HDLwF1rwUkmt3gO5MrXzAvVk2em7ltBI6ozqUI3O+ceZChL13y+RP1r4q5Z3qj/QOdDu
         EOYmvRC04sPtF9nvwb5RdExKdhIzz6okYS3fzRC7Thpglm3C2MEE60PKII71eBYiGtLO
         jipw==
X-Gm-Message-State: AOAM530vfWk+Wchun47TqyMn54NxgNxJh8NuwSsulj0bZZOTFJ9D0vot
        +tAZJryGEmsMDjLIzkCjKpG08bIPii4=
X-Google-Smtp-Source: ABdhPJyQUtErlV9+diRnT6cREz3Ugbw0PEqcSVhRMmPVy6fgGF0ZkjLoz9pSz2LHuxRGKqEiKfvbrg==
X-Received: by 2002:a5d:4583:: with SMTP id p3mr3732308wrq.398.1629378523711;
        Thu, 19 Aug 2021 06:08:43 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id f17sm2889978wrt.49.2021.08.19.06.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:08:43 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 5/7] trace-cruncher: Refactor the way libtracefs instances are handled
Date:   Thu, 19 Aug 2021 16:08:25 +0300
Message-Id: <20210819130827.12327-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210819130827.12327-1-y.karadz@gmail.com>
References: <20210819130827.12327-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently all libtracefs instances created by trace-cruncher are
wrapped by a dedicated C structure and stored in a binary search
tree. The ordering in the tree is based on a string comparison. The
tree is used for accessing the created instances and for cleanup
when the module exits (garbage collection). In this refactoring we
eliminate the need of the tree by switching to using the custom
Python type for libtracefs instances. The new type is defined in
the C extension of the module.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c                          | 412 +++++-------------
 src/ftracepy-utils.h                          |  10 -
 src/ftracepy.c                                |  20 -
 tests/1_unit/test_01_ftracepy_unit.py         | 245 +++++------
 .../test_01_ftracepy_integration.py           |  56 +--
 5 files changed, 242 insertions(+), 501 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index a75f19b..5d7d9af 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -19,7 +19,6 @@
 // trace-cruncher
 #include "ftracepy-utils.h"
 
-static void *instance_root;
 PyObject *TFS_ERROR;
 PyObject *TEP_ERROR;
 PyObject *TRACECRUNCHER_ERROR;
@@ -419,118 +418,6 @@ static PyObject *tfs_list2py_list(char **list)
 	return py_list;
 }
 
-struct instance_wrapper {
-	struct tracefs_instance *ptr;
-	const char *name;
-};
-
-const char *instance_wrapper_get_name(const struct instance_wrapper *iw)
-{
-	if (!iw->ptr)
-		return iw->name;
-
-	return tracefs_instance_get_name(iw->ptr);
-}
-
-static int instance_compare(const void *a, const void *b)
-{
-	const struct instance_wrapper *iwa, *iwb;
-
-	iwa = (const struct instance_wrapper *) a;
-	iwb = (const struct instance_wrapper *) b;
-
-	return strcmp(instance_wrapper_get_name(iwa),
-		      instance_wrapper_get_name(iwb));
-}
-
-void instance_wrapper_free(void *ptr)
-{
-	struct instance_wrapper *iw;
-	if (!ptr)
-		return;
-
-	iw = ptr;
-	if (iw->ptr) {
-		if (tracefs_instance_destroy(iw->ptr) < 0)
-			fprintf(stderr,
-				"\ntfs_error: Failed to destroy instance '%s'.\n",
-				get_instance_name(iw->ptr));
-
-		free(iw->ptr);
-	}
-
-	free(ptr);
-}
-
-static void destroy_all_instances(void)
-{
-	tdestroy(instance_root, instance_wrapper_free);
-	instance_root = NULL;
-}
-
-static struct tracefs_instance *find_instance(const char *name)
-{
-	struct instance_wrapper iw, **iw_ptr;
-	if (!is_set(name))
-		return NULL;
-
-	if (!tracefs_instance_exists(name)) {
-		PyErr_Format(TFS_ERROR, "Trace instance \'%s\' does not exist.",
-			     name);
-		return NULL;
-	}
-
-	iw.ptr = NULL;
-	iw.name = name;
-	iw_ptr = tfind(&iw, &instance_root, instance_compare);
-	if (!iw_ptr || !(*iw_ptr) || !(*iw_ptr)->ptr ||
-	    strcmp(tracefs_instance_get_name((*iw_ptr)->ptr), name) != 0) {
-		PyErr_Format(TFS_ERROR, "Unable to find trace instances \'%s\'.",
-			     name);
-		return NULL;
-	}
-
-	return (*iw_ptr)->ptr;
-}
-
-bool get_optional_instance(const char *instance_name,
-			   struct tracefs_instance **instance)
-{
-	*instance = NULL;
-	if (is_set(instance_name)) {
-		*instance = find_instance(instance_name);
-		if (!instance) {
-			PyErr_Format(TFS_ERROR,
-				     "Failed to find instance \'%s\'.",
-				     instance_name);
-			return false;
-		}
-	}
-
-	return true;
-}
-
-bool get_instance_from_arg(PyObject *args, PyObject *kwargs,
-			   struct tracefs_instance **instance)
-{
-	const char *instance_name;
-
-	static char *kwlist[] = {"instance", NULL};
-	instance_name = NO_ARG;
-	if (!PyArg_ParseTupleAndKeywords(args,
-					 kwargs,
-					 "|s",
-					 kwlist,
-					 &instance_name)) {
-		return false;
-	}
-
-	if (!get_optional_instance(instance_name, instance))
-		return false;
-
-	return true;
-}
-
 PyObject *PyTfsInstance_dir(PyTfsInstance *self)
 {
 	return PyUnicode_FromString(tracefs_instance_get_dir(self->ptrObj));
@@ -590,7 +477,6 @@ static bool tracing_OFF(struct tracefs_instance *instance);
 PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
 						   PyObject *kwargs)
 {
-	struct instance_wrapper *iw, **iw_ptr;
 	struct tracefs_instance *instance;
 	const char *name = NO_ARG;
 	int tracing_on = true;
@@ -618,115 +504,53 @@ PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
 		return NULL;
 	}
 
-	iw = calloc(1, sizeof(*iw));
-	if (!iw) {
-		MEM_ERROR
-		return NULL;
-	}
-
-	iw->ptr = instance;
-	iw_ptr = tsearch(iw, &instance_root, instance_compare);
-	if (!iw_ptr || !(*iw_ptr) || !(*iw_ptr)->ptr ||
-	    strcmp(tracefs_instance_get_name((*iw_ptr)->ptr), name) != 0) {
-		PyErr_Format(TFS_ERROR,
-			     "Failed to store new trace instance \'%s\'.",
-			     name);
-		tracefs_instance_destroy(instance);
-		tracefs_instance_free(instance);
-		free(iw);
-
-		return NULL;
-	}
-
 	if (!tracing_on)
 		tracing_OFF(instance);
 
-	return PyUnicode_FromString(name);
+	return PyTfsInstance_New(instance);
 }
 
-PyObject *PyFtrace_destroy_instance(PyObject *self, PyObject *args,
-						    PyObject *kwargs)
+static bool get_optional_instance(PyObject *py_obj,
+				  struct tracefs_instance **instance)
 {
-	struct tracefs_instance *instance;
-	struct instance_wrapper iw;
-	char *name;
+	PyTfsInstance *py_inst;
 
-	static char *kwlist[] = {"name", NULL};
-	if (!PyArg_ParseTupleAndKeywords(args,
-					 kwargs,
-					 "s",
-					 kwlist,
-					 &name)) {
-		return NULL;
-	}
-
-	if (is_all(name)) {
-		destroy_all_instances();
-		Py_RETURN_NONE;
+	if (!py_obj) {
+		*instance = NULL;
+		return true;
 	}
 
-	instance = find_instance(name);
-	if (!instance) {
-		PyErr_Format(TFS_ERROR,
-			     "Unable to destroy trace instances \'%s\'.",
-			     name);
-		return NULL;
+	if (!PyTfsInstance_Check(py_obj)) {
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Passing argument \'instance\' with incompatible type.");
+		return false;
 	}
 
-	iw.ptr = NULL;
-	iw.name = name;
-	tdelete(&iw, &instance_root, instance_compare);
-
-	tracefs_instance_destroy(instance);
-	tracefs_instance_free(instance);
+	py_inst = (PyTfsInstance *)py_obj;
+	*instance = py_inst->ptrObj;
 
-	Py_RETURN_NONE;
+	return true;
 }
 
-PyObject *instance_list;
-
-static void instance_action(const void *nodep, VISIT which, int depth)
+bool get_instance_from_arg(PyObject *args, PyObject *kwargs,
+			   struct tracefs_instance **instance)
 {
-	struct instance_wrapper *iw = *( struct instance_wrapper **) nodep;
-	const char *name;
-
-	switch(which) {
-	case preorder:
-	case endorder:
-		break;
+	static char *kwlist[] = {"instance", NULL};
+	PyObject *py_inst = NULL;
+	*instance = NULL;
 
-	case postorder:
-	case leaf:
-		name = tracefs_instance_get_name(iw->ptr);
-		PyList_Append(instance_list, PyUnicode_FromString(name));
-		break;
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "|O",
+					 kwlist,
+					 &py_inst)) {
+		return false;
 	}
-}
-
-PyObject *PyFtrace_get_all_instances(PyObject *self)
-{
-	instance_list = PyList_New(0);
-	twalk(instance_root, instance_action);
-
-	return instance_list;
-}
-
-PyObject *PyFtrace_destroy_all_instances(PyObject *self)
-{
-	destroy_all_instances();
-
-	Py_RETURN_NONE;
-}
-
-PyObject *PyFtrace_instance_dir(PyObject *self, PyObject *args,
-						PyObject *kwargs)
-{
-	struct tracefs_instance *instance;
 
-	if (!get_instance_from_arg(args, kwargs, &instance))
+	if (!get_optional_instance(py_inst, instance))
 		return NULL;
 
-	return PyUnicode_FromString(tracefs_instance_get_dir(instance));
+	return true;
 }
 
 PyObject *PyFtrace_available_tracers(PyObject *self, PyObject *args,
@@ -748,21 +572,22 @@ PyObject *PyFtrace_available_tracers(PyObject *self, PyObject *args,
 PyObject *PyFtrace_set_current_tracer(PyObject *self, PyObject *args,
 						      PyObject *kwargs)
 {
-	const char *file = "current_tracer", *tracer, *instance_name;
+	static char *kwlist[] = {"tracer", "instance", NULL};
+	const char *file = "current_tracer", *tracer;
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
 
-	static char *kwlist[] = {"tracer", "instance", NULL};
-	tracer = instance_name = NO_ARG;
+	tracer = NO_ARG;
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "|ss",
+					 "|sO",
 					 kwlist,
 					 &tracer,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	if (is_set(tracer) &&
@@ -836,20 +661,21 @@ PyObject *PyFtrace_available_system_events(PyObject *self, PyObject *args,
 							   PyObject *kwargs)
 {
 	static char *kwlist[] = {"system", "instance", NULL};
-	const char *instance_name = NO_ARG, *system;
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
+	const char *system;
 	char **list;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "s|s",
+					 "s|O",
 					 kwlist,
 					 &system,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	list = tracefs_system_events(tracefs_instance_get_dir(instance),
@@ -947,21 +773,22 @@ static bool set_enable_event(PyObject *self,
 			     bool enable)
 {
 	static char *kwlist[] = {"instance", "system", "event", NULL};
-	const char *instance_name, *system, *event;
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
+	const char *system, *event;
 
-	instance_name = system = event = NO_ARG;
+	system = event = NO_ARG;
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "|sss",
+					 "|Oss",
 					 kwlist,
-					 &instance_name,
+					 &py_inst,
 					 &system,
 					 &event)) {
 		return false;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return false;
 
 	return event_enable_disable(instance, system, event, enable);
@@ -995,22 +822,21 @@ static bool set_enable_events(PyObject *self, PyObject *args, PyObject *kwargs,
 	PyObject *system_list = NULL, *event_list = NULL, *system_event_list;
 	const char **systems = NULL, **events = NULL;
 	struct tracefs_instance *instance;
-	const char *instance_name;
+	PyObject *py_inst = NULL;
 	char *file = NULL;
 	int ret, s, e;
 
-	instance_name = NO_ARG;
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "|sOO",
+					 "|OOO",
 					 kwlist,
-					 &instance_name,
+					 &py_inst,
 					 &system_list,
 					 &event_list)) {
 		return false;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return false;
 
 	if (!system_list && !event_list)
@@ -1122,21 +948,22 @@ PyObject *PyFtrace_event_is_enabled(PyObject *self, PyObject *args,
 						    PyObject *kwargs)
 {
 	static char *kwlist[] = {"instance", "system", "event", NULL};
-	const char *instance_name, *system, *event;
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
+	const char *system, *event;
 
-	instance_name = system = event = NO_ARG;
+	system = event = NO_ARG;
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "|sss",
+					 "|Oss",
 					 kwlist,
-					 &instance_name,
+					 &py_inst,
 					 &system,
 					 &event)) {
 		return false;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return false;
 
 	return event_is_enabled(instance, system, event);
@@ -1145,23 +972,24 @@ PyObject *PyFtrace_event_is_enabled(PyObject *self, PyObject *args,
 PyObject *PyFtrace_set_event_filter(PyObject *self, PyObject *args,
 						    PyObject *kwargs)
 {
-	const char *instance_name = NO_ARG, *system, *event, *filter;
+	const char *system, *event, *filter;
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
 	char path[PATH_MAX];
 
 	static char *kwlist[] = {"system", "event", "filter", "instance", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "sss|s",
+					 "ssO|)",
 					 kwlist,
 					 &system,
 					 &event,
 					 &filter,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	sprintf(path, "events/%s/%s/filter", system, event);
@@ -1176,22 +1004,23 @@ PyObject *PyFtrace_set_event_filter(PyObject *self, PyObject *args,
 PyObject *PyFtrace_clear_event_filter(PyObject *self, PyObject *args,
 						      PyObject *kwargs)
 {
-	const char *instance_name = NO_ARG, *system, *event;
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
+	const char *system, *event;
 	char path[PATH_MAX];
 
 	static char *kwlist[] = {"system", "event", "instance", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "ss|s",
+					 "ss|O",
 					 kwlist,
 					 &system,
 					 &event,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	sprintf(path, "events/%s/%s/filter", system, event);
@@ -1350,21 +1179,21 @@ static bool set_pid(struct tracefs_instance *instance,
 PyObject *PyFtrace_set_event_pid(PyObject *self, PyObject *args,
 						 PyObject *kwargs)
 {
-	const char *instance_name = NO_ARG;
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
 	PyObject *pid_val;
 
 	static char *kwlist[] = {"pid", "instance", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "O|s",
+					 "O|O",
 					 kwlist,
 					 &pid_val,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	if (!set_pid(instance, "set_event_pid", pid_val))
@@ -1376,21 +1205,21 @@ PyObject *PyFtrace_set_event_pid(PyObject *self, PyObject *args,
 PyObject *PyFtrace_set_ftrace_pid(PyObject *self, PyObject *args,
 						  PyObject *kwargs)
 {
-	const char *instance_name = NO_ARG;
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
 	PyObject *pid_val;
 
 	static char *kwlist[] = {"pid", "instance", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "O|s",
+					 "O|O",
 					 kwlist,
 					 &pid_val,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	if (!set_pid(instance, "set_ftrace_pid", pid_val))
@@ -1416,20 +1245,21 @@ static bool set_opt(struct tracefs_instance *instance,
 static PyObject *set_option_py_args(PyObject *args, PyObject *kwargs,
 				   const char *val)
 {
-	const char *instance_name = NO_ARG, *opt;
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
+	const char *opt;
 
 	static char *kwlist[] = {"option", "instance", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "s|s",
+					 "s|O",
 					 kwlist,
 					 &opt,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	if (!set_opt(instance, opt, val))
@@ -1453,21 +1283,22 @@ PyObject *PyFtrace_disable_option(PyObject *self, PyObject *args,
 PyObject *PyFtrace_option_is_set(PyObject *self, PyObject *args,
 						 PyObject *kwargs)
 {
-	const char *instance_name = NO_ARG, *opt;
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
 	enum tracefs_option_id opt_id;
+	const char *opt;
 
 	static char *kwlist[] = {"option", "instance", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "s|s",
+					 "s|O",
 					 kwlist,
 					 &opt,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	opt_id = tracefs_option_id(opt);
@@ -1706,22 +1537,23 @@ PyObject *PyFtrace_registered_kprobes(PyObject *self)
 PyObject *PyFtrace_set_kprobe_filter(PyObject *self, PyObject *args,
 						     PyObject *kwargs)
 {
-	const char *instance_name = NO_ARG, *event, *filter;
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
+	const char *event, *filter;
 	char path[PATH_MAX];
 
 	static char *kwlist[] = {"event", "filter", "instance", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "ss|s",
+					 "ss|O",
 					 kwlist,
 					 &event,
 					 &filter,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	sprintf(path, "events/%s/%s/filter", TC_SYS, event);
@@ -1736,21 +1568,22 @@ PyObject *PyFtrace_set_kprobe_filter(PyObject *self, PyObject *args,
 PyObject *PyFtrace_clear_kprobe_filter(PyObject *self, PyObject *args,
 						       PyObject *kwargs)
 {
-	const char *instance_name = NO_ARG, *event;
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
 	char path[PATH_MAX];
+	const char *event;
 
 	static char *kwlist[] = {"event", "instance", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "s|s",
+					 "s|O",
 					 kwlist,
 					 &event,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	sprintf(path, "events/%s/%s/filter", TC_SYS, event);
@@ -1767,19 +1600,19 @@ static bool enable_kprobe(PyObject *self, PyObject *args, PyObject *kwargs,
 {
 	static char *kwlist[] = {"event", "instance", NULL};
 	struct tracefs_instance *instance;
-	const char *instance_name, *event;
+	PyObject *py_inst = NULL;
+	const char *event = NO_ARG;
 
-	instance_name = event = NO_ARG;
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "s|s",
+					 "s|O",
 					 kwlist,
 					 &event,
-					 &instance_name)) {
+					 &py_inst)) {
 		return false;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return false;
 
 	return event_enable_disable(instance, TC_SYS, event, enable);
@@ -1808,19 +1641,19 @@ PyObject *PyFtrace_kprobe_is_enabled(PyObject *self, PyObject *args,
 {
 	static char *kwlist[] = {"event", "instance", NULL};
 	struct tracefs_instance *instance;
-	const char *instance_name, *event;
+	PyObject *py_inst = NULL;
+	const char *event = NO_ARG;
 
-	instance_name = event = NO_ARG;
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "s|s",
+					 "s|O",
 					 kwlist,
 					 &event,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	return event_is_enabled(instance, TC_SYS, event);
@@ -2023,27 +1856,27 @@ static bool init_callback_tep(struct tracefs_instance *instance,
 PyObject *PyFtrace_trace_shell_process(PyObject *self, PyObject *args,
 						       PyObject *kwargs)
 {
-	const char *plugin = "__main__", *py_callback = "callback", *instance_name;
+	const char *plugin = "__main__", *py_callback = "callback";
 	static char *kwlist[] = {"process", "plugin", "callback", "instance", NULL};
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
 	struct tep_handle *tep;
 	PyObject *py_func;
 	char *process;
 	pid_t pid;
 
-	instance_name = NO_ARG;
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "s|sss",
+					 "s|ssO",
 					 kwlist,
 					 &process,
 					 &plugin,
 					 &py_callback,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	if (!init_callback_tep(instance, plugin, py_callback, &tep, &py_func))
@@ -2070,27 +1903,27 @@ PyObject *PyFtrace_trace_shell_process(PyObject *self, PyObject *args,
 PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
 						 PyObject *kwargs)
 {
-	const char *plugin = "__main__", *py_callback = "callback", *instance_name;
+	const char *plugin = "__main__", *py_callback = "callback";
 	static char *kwlist[] = {"argv", "plugin", "callback", "instance", NULL};
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
 	struct tep_handle *tep;
 	PyObject *py_func, *py_argv, *py_arg;
 	pid_t pid;
 	int i, argc;
 
-	instance_name = NO_ARG;
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "O|sss",
+					 "O|ssO",
 					 kwlist,
 					 &py_argv,
 					 &plugin,
 					 &py_callback,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	if (!init_callback_tep(instance, plugin, py_callback, &tep, &py_func))
@@ -2173,8 +2006,7 @@ PyObject *PyFtrace_iterate_trace(PyObject *self, PyObject *args,
 	const char *plugin = "__main__", *py_callback = "callback";
 	bool *callback_status = &callback_ctx.status;
 	bool *keep_going = &iterate_keep_going;
-
-	const char *instance_name;
+	PyObject *py_inst = NULL;
 	struct tep_handle *tep;
 	PyObject *py_func;
 	int ret;
@@ -2182,20 +2014,19 @@ PyObject *PyFtrace_iterate_trace(PyObject *self, PyObject *args,
 	(*(volatile bool *)keep_going) = true;
 	signal(SIGINT, iterate_stop);
 
-	instance_name = NO_ARG;
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "|sss",
+					 "|ssO",
 					 kwlist,
 					 &plugin,
 					 &py_callback,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
 	py_func = get_callback_func(plugin, py_callback);
 	if (!py_func ||
-	    !get_optional_instance(instance_name, &itr_instance) ||
+	    !get_optional_instance(py_inst, &itr_instance) ||
 	    !notrace_this_pid(itr_instance))
 		return NULL;
 
@@ -2219,22 +2050,22 @@ PyObject *PyFtrace_iterate_trace(PyObject *self, PyObject *args,
 PyObject *PyFtrace_hook2pid(PyObject *self, PyObject *args, PyObject *kwargs)
 {
 	static char *kwlist[] = {"pid", "fork", "instance", NULL};
-	const char *instance_name = NO_ARG;
 	struct tracefs_instance *instance;
+	PyObject *py_inst = NULL;
 	PyObject *pid_val;
 	int fork = -1;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "O|ps",
+					 "O|pO",
 					 kwlist,
 					 &pid_val,
 					 &fork,
-					 &instance_name)) {
+					 &py_inst)) {
 		return NULL;
 	}
 
-	if (!get_optional_instance(instance_name, &instance))
+	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
 	if (!hook2pid(instance, pid_val, fork))
@@ -2246,5 +2077,4 @@ PyObject *PyFtrace_hook2pid(PyObject *self, PyObject *args, PyObject *kwargs)
 void PyFtrace_at_exit(void)
 {
 	destroy_all_kprobes();
-	destroy_all_instances();
 }
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index c674804..04de1f3 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -55,16 +55,6 @@ PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
 PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
 						   PyObject *kwargs);
 
-PyObject *PyFtrace_destroy_instance(PyObject *self, PyObject *args,
-						    PyObject *kwargs);
-
-PyObject *PyFtrace_get_all_instances(PyObject *self);
-
-PyObject *PyFtrace_destroy_all_instances(PyObject *self);
-
-PyObject *PyFtrace_instance_dir(PyObject *self, PyObject *args,
-						PyObject *kwargs);
-
 PyObject *PyFtrace_available_tracers(PyObject *self, PyObject *args,
 						     PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 97b410f..3c55e50 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -102,26 +102,6 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Create new tracefs instance."
 	},
-	{"get_all_instances",
-	 (PyCFunction) PyFtrace_get_all_instances,
-	 METH_NOARGS,
-	 "Get all existing tracefs instances."
-	},
-	{"destroy_instance",
-	 (PyCFunction) PyFtrace_destroy_instance,
-	 METH_VARARGS | METH_KEYWORDS,
-	 "Destroy existing tracefs instance."
-	},
-	{"destroy_all_instances",
-	 (PyCFunction) PyFtrace_destroy_all_instances,
-	 METH_NOARGS,
-	 "Destroy all existing tracefs instances."
-	},
-	{"instance_dir",
-	 (PyCFunction) PyFtrace_instance_dir,
-	 METH_VARARGS | METH_KEYWORDS,
-	 "Get the absolute path to the instance directory."
-	},
 	{"available_tracers",
 	 (PyCFunction) PyFtrace_available_tracers,
 	 METH_VARARGS | METH_KEYWORDS,
diff --git a/tests/1_unit/test_01_ftracepy_unit.py b/tests/1_unit/test_01_ftracepy_unit.py
index 0d62da2..57db0ad 100644
--- a/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tests/1_unit/test_01_ftracepy_unit.py
@@ -22,48 +22,20 @@ class InstanceTestCase(unittest.TestCase):
         self.assertTrue(os.path.isdir(instances_dir))
 
     def test_create_instance(self):
-        ft.create_instance(instance_name)
-        self.assertTrue(ft.is_tracing_ON(instance_name))
+        inst = ft.create_instance(instance_name)
+        self.assertTrue(ft.is_tracing_ON(inst))
         instances_dir = ft.dir() + '/instances/'
         self.assertTrue(os.path.isdir(instances_dir + instance_name))
 
         auto_inst = ft.create_instance(tracing_on=False)
         self.assertFalse(ft.is_tracing_ON(auto_inst))
-        ft.destroy_instance(auto_inst)
-
-    def test_destroy_instance(self):
-        ft.destroy_instance(instance_name)
-        instances_dir = ft.dir() + '/instances/'
-        self.assertFalse(os.path.isdir(instances_dir + instance_name))
-
-        err = 'Unable to destroy trace instances'
-        with self.assertRaises(Exception) as context:
-            ft.destroy_instance(instance_name)
-        self.assertTrue(err in str(context.exception))
-
-        ft.create_instance(instance_name)
-        ft.create_instance(another_instance_name)
-        ft.destroy_all_instances()
-        self.assertFalse(os.path.isdir(instances_dir + instance_name))
-
-        ft.create_instance(instance_name)
-        ft.create_instance(another_instance_name)
-        ft.destroy_instance('all')
-        self.assertFalse(os.path.isdir(instances_dir + instance_name))
-
-    def test_get_all(self):
-        ft.create_instance(instance_name)
-        ft.create_instance(another_instance_name)
-        self.assertEqual(ft.get_all_instances(),
-                         [instance_name, another_instance_name])
-        ft.destroy_all_instances()
 
     def test_instance_dir(self):
-        ft.create_instance(instance_name)
+        inst = ft.create_instance(instance_name)
         tracefs_dir = ft.dir();
         instance_dir = tracefs_dir + '/instances/' + instance_name
-        self.assertEqual(instance_dir, ft.instance_dir(instance_name))
-        ft.destroy_all_instances()
+        self.assertEqual(instance_dir, inst.dir())
+
 
 class PyTepTestCase(unittest.TestCase):
     def test_init_local(self):
@@ -73,8 +45,8 @@ class PyTepTestCase(unittest.TestCase):
 
         tep.init_local(dir=tracefs_dir, systems=['sched', 'irq']);
 
-        ft.create_instance(instance_name)
-        tracefs_dir = ft.instance_dir(instance_name)
+        inst = ft.create_instance(instance_name)
+        tracefs_dir = inst.dir()
         tep.init_local(dir=tracefs_dir, systems=['sched', 'irq']);
 
         err='function missing required argument \'dir\''
@@ -86,7 +58,6 @@ class PyTepTestCase(unittest.TestCase):
         with self.assertRaises(Exception) as context:
             tep.init_local(dir='no_dir', systems=['sched', 'irq']);
         self.assertTrue(err in str(context.exception))
-        ft.destroy_all_instances()
 
     def test_get_event(self):
         tracefs_dir = ft.dir()
@@ -144,302 +115,284 @@ class EventsTestCase(unittest.TestCase):
         self.assertTrue(len(systems) > 1)
         self.assertTrue('sched' in systems)
 
-        ft.create_instance(instance_name)
-        systems = ft.available_event_systems(instance_name)
+        inst = ft.create_instance(instance_name)
+        systems = ft.available_event_systems(inst)
         self.assertTrue(len(systems) > 1)
         self.assertTrue('sched' in systems)
 
-        ft.destroy_all_instances()
-
     def test_available_system_events(self):
         events = ft.available_system_events(system='sched')
         self.assertTrue(len(events) > 1)
         self.assertTrue('sched_switch' in events)
 
-        ft.create_instance(instance_name)
-        events = ft.available_system_events(instance=instance_name,
-                                              system='sched')
+        inst = ft.create_instance(instance_name)
+        events = ft.available_system_events(instance=inst,
+                                            system='sched')
         self.assertTrue(len(events) > 1)
         self.assertTrue('sched_switch' in events)
 
         err = 'function missing required argument'
         with self.assertRaises(Exception) as context:
-            ft.available_system_events(instance=instance_name)
+            ft.available_system_events(instance=inst)
         self.assertTrue(err in str(context.exception))
 
-        ft.destroy_all_instances()
-
     def test_enable_event(self):
-        ft.create_instance(instance_name)
-
-        ret = ft.event_is_enabled(instance=instance_name, system='all')
+        inst = ft.create_instance(instance_name)
+        ret = ft.event_is_enabled(instance=inst, system='all')
         self.assertEqual(ret, '0')
-        ft.enable_event(instance=instance_name, system='all')
-        ret = ft.event_is_enabled(instance=instance_name, system='all')
+        ft.enable_event(instance=inst, system='all')
+        ret = ft.event_is_enabled(instance=inst, system='all')
         self.assertEqual(ret, '1')
-        ft.disable_event(instance=instance_name, system='all')
-        ret = ft.event_is_enabled(instance=instance_name, system='all')
+        ft.disable_event(instance=inst, system='all')
+        ret = ft.event_is_enabled(instance=inst, system='all')
         self.assertEqual(ret, '0')
 
-        ret = ft.event_is_enabled(instance=instance_name, event='all')
+        ret = ft.event_is_enabled(instance=inst, event='all')
         self.assertEqual(ret, '0')
-        ft.enable_event(instance=instance_name, event='all')
-        ret = ft.event_is_enabled(instance=instance_name, event='all')
+        ft.enable_event(instance=inst, event='all')
+        ret = ft.event_is_enabled(instance=inst, event='all')
         self.assertEqual(ret, '1')
-        ft.disable_event(instance=instance_name, event='all')
-        ret = ft.event_is_enabled(instance=instance_name, event='all')
+        ft.disable_event(instance=inst, event='all')
+        ret = ft.event_is_enabled(instance=inst, event='all')
         self.assertEqual(ret, '0')
 
-        ret = ft.event_is_enabled(instance=instance_name, system='sched')
+        ret = ft.event_is_enabled(instance=inst, system='sched')
         self.assertEqual(ret, '0')
-        ft.enable_event(instance=instance_name, system='sched')
-        ret = ft.event_is_enabled(instance=instance_name, system='sched')
+        ft.enable_event(instance=inst, system='sched')
+        ret = ft.event_is_enabled(instance=inst, system='sched')
         self.assertEqual(ret, '1')
-        ft.disable_event(instance=instance_name, system='sched')
-        ret = ft.event_is_enabled(instance=instance_name, system='sched')
+        ft.disable_event(instance=inst, system='sched')
+        ret = ft.event_is_enabled(instance=inst, system='sched')
         self.assertEqual(ret, '0')
 
-        ft.enable_event(instance=instance_name,
+        ft.enable_event(instance=inst,
                         system='sched',
                         event='sched_switch')
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='sched_switch')
         self.assertEqual(ret, '1')
-        ft.disable_event(instance=instance_name,
+        ft.disable_event(instance=inst,
                          system='sched',
                          event='sched_switch')
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='sched_switch')
         self.assertEqual(ret, '0')
 
-        ft.enable_event(instance=instance_name,
+        ft.enable_event(instance=inst,
                         system='sched',
                         event='all')
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='all')
         self.assertEqual(ret, '1')
-        ft.disable_event(instance=instance_name,
+        ft.disable_event(instance=inst,
                          system='sched',
                          event='all')
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='all')
         self.assertEqual(ret, '0')
 
-        ft.enable_event(instance=instance_name,
+        ft.enable_event(instance=inst,
                         event='sched_switch')
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='sched_switch')
         self.assertEqual(ret, '1')
-        ft.disable_event(instance=instance_name,
+        ft.disable_event(instance=inst,
                          event='sched_switch')
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='sched_switch')
         self.assertEqual(ret, '0')
 
-        ft.enable_event(instance=instance_name,
+        ft.enable_event(instance=inst,
                         system='all',
                         event='sched_switch')
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='sched_switch')
         self.assertEqual(ret, '1')
-        ft.disable_event(instance=instance_name,
+        ft.disable_event(instance=inst,
                          system='all',
                          event='sched_switch')
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='sched_switch')
         self.assertEqual(ret, '0')
 
-        ft.destroy_all_instances()
-
     def test_enable_event_err(self):
-        ft.create_instance(instance_name)
+        inst = ft.create_instance(instance_name)
 
         err = 'Failed to enable/disable event'
         with self.assertRaises(Exception) as context:
-            ft.enable_event(instance=instance_name,
+            ft.enable_event(instance=inst,
                             system='zero')
         self.assertTrue(err in str(context.exception))
 
         with self.assertRaises(Exception) as context:
-            ft.enable_event(instance=instance_name,
+            ft.enable_event(instance=inst,
                             system='sched',
                             event='zero')
         self.assertTrue(err in str(context.exception))
 
-        ft.destroy_all_instances()
-
     def test_enable_events(self):
-        ft.create_instance(instance_name)
-        ft.enable_events(instance=instance_name,
+        inst = ft.create_instance(instance_name)
+        ft.enable_events(instance=inst,
                          events='all')
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   event='all')
         self.assertEqual(ret, '1')
-        ft.disable_events(instance=instance_name,
+        ft.disable_events(instance=inst,
                           events='all')
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   event='all')
         self.assertEqual(ret, '0')
 
-        ft.enable_events(instance=instance_name,
+        ft.enable_events(instance=inst,
                          systems=['sched', 'irq'])
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='all')
         self.assertEqual(ret, '1')
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='irq',
                                   event='all')
         self.assertEqual(ret, '1')
 
-        ft.disable_events(instance=instance_name,
+        ft.disable_events(instance=inst,
                           systems=['sched', 'irq'])
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='all')
         self.assertEqual(ret, '0')
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='irq',
                                   event='all')
         self.assertEqual(ret, '0')
 
-        ft.enable_events(instance=instance_name,
+        ft.enable_events(instance=inst,
                          systems=['sched', 'irq'],
                          events=[['sched_switch', 'sched_waking'],
                                  ['all']])
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='sched_switch')
         self.assertEqual(ret, '1')
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='sched_waking')
         self.assertEqual(ret, '1')
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='sched_wakeup')
         self.assertEqual(ret, '0')
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='irq',
                                   event='all')
         self.assertEqual(ret, '1')
 
-        ft.disable_events(instance=instance_name,
+        ft.disable_events(instance=inst,
                           systems=['sched', 'irq'],
                           events=[['sched_switch', 'sched_waking'],
                                   ['all']])
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='sched_switch')
         self.assertEqual(ret, '0')
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
                                   event='sched_waking')
         self.assertEqual(ret, '0')
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                   system='irq',
                                   event='all')
         self.assertEqual(ret, '0')
 
-        ft.destroy_all_instances()
-
     def test_enable_events_err(self):
-        ft.create_instance(instance_name)
+        inst = ft.create_instance(instance_name)
 
         err = 'Inconsistent \"events\" argument'
         with self.assertRaises(Exception) as context:
-            ft.enable_events(instance=instance_name,
+            ft.enable_events(instance=inst,
                              systems=['sched'],
                              events=['all'])
         self.assertTrue(err in str(context.exception))
 
         err = 'Failed to enable events for unspecified system'
         with self.assertRaises(Exception) as context:
-            ft.enable_events(instance=instance_name,
+            ft.enable_events(instance=inst,
                              events=['sched_switch', 'sched_wakeup'])
         self.assertTrue(err in str(context.exception))
 
         err = 'Failed to enable/disable event'
         with self.assertRaises(Exception) as context:
-            ft.enable_events(instance=instance_name,
+            ft.enable_events(instance=inst,
                              systems=['sched'],
                              events=[['no_event']])
         self.assertTrue(err in str(context.exception))
 
-        ft.destroy_all_instances()
-
 
 class OptionsTestCase(unittest.TestCase):
     def test_enable_option(self):
-        ft.create_instance(instance_name)
+        inst = ft.create_instance(instance_name)
         opt = 'event-fork'
-        ret = ft.option_is_set(instance=instance_name,
-                                   option=opt)
+        ret = ft.option_is_set(instance=inst,
+                               option=opt)
         self.assertFalse(ret)
 
-        ft.enable_option(instance=instance_name,
+        ft.enable_option(instance=inst,
                          option=opt)
-        ret = ft.option_is_set(instance=instance_name,
+        ret = ft.option_is_set(instance=inst,
                                option=opt)
         self.assertTrue(ret)
 
-        ft.disable_option(instance=instance_name,
+        ft.disable_option(instance=inst,
                           option=opt)
-        ret = ft.option_is_set(instance=instance_name,
+        ret = ft.option_is_set(instance=inst,
                                    option=opt)
         self.assertFalse(ret)
 
         opt = 'no-opt'
         err = 'Failed to set option \"no-opt\"'
         with self.assertRaises(Exception) as context:
-            ft.enable_option(instance=instance_name,
+            ft.enable_option(instance=inst,
                              option=opt)
         self.assertTrue(err in str(context.exception))
 
-        ft.destroy_all_instances()
-
     def test_supported_options(self):
-        ft.create_instance(instance_name)
-        opts = ft.supported_options(instance_name)
+        inst = ft.create_instance(instance_name)
+        opts = ft.supported_options(inst)
         self.assertTrue(len(opts) > 20)
         self.assertTrue('event-fork' in opts)
 
-        ft.destroy_all_instances()
-
     def test_enabled_options(self):
-        ft.create_instance(instance_name)
-        opts = ft.enabled_options(instance_name)
+        inst = ft.create_instance(instance_name)
+        opts = ft.enabled_options(inst)
         n = len(opts)
-        ft.enable_option(instance=instance_name, option='function-fork')
-        ft.enable_option(instance=instance_name, option='event-fork')
-        opts = ft.enabled_options(instance_name)
+        ft.enable_option(instance=inst, option='function-fork')
+        ft.enable_option(instance=inst, option='event-fork')
+        opts = ft.enabled_options(inst)
 
         self.assertEqual(len(opts), n + 2)
         self.assertTrue('event-fork' in opts)
         self.assertTrue('function-fork' in opts)
 
-        ft.destroy_all_instances()
 
 class KprobeTestCase(unittest.TestCase):
     def test_register_kprobe(self):
@@ -487,17 +440,17 @@ class KprobeTestCase(unittest.TestCase):
 
         ft.register_kprobe(event=evt1, function=evt1_func,
                            probe=evt1_prove)
-        ft.create_instance(instance_name)
-        ft.enable_kprobe(instance=instance_name, event=evt1)
-        ret = ft.kprobe_is_enabled(instance=instance_name, event=evt1)
+        inst = ft.create_instance(instance_name)
+        ft.enable_kprobe(instance=inst, event=evt1)
+        ret = ft.kprobe_is_enabled(instance=inst, event=evt1)
         self.assertEqual(ret, '1')
 
-        ft.disable_kprobe(instance=instance_name, event=evt1)
-        ret = ft.kprobe_is_enabled(instance=instance_name, event=evt1)
+        ft.disable_kprobe(instance=inst, event=evt1)
+        ret = ft.kprobe_is_enabled(instance=inst, event=evt1)
         self.assertEqual(ret, '0')
 
         ft.unregister_kprobe(event='ALL')
-        ft.destroy_all_instances()
+
 
 class TracingOnTestCase(unittest.TestCase):
     def test_ON_OF(self):
@@ -505,16 +458,14 @@ class TracingOnTestCase(unittest.TestCase):
         self.assertTrue(ft.is_tracing_ON())
         ft.tracing_OFF()
 
-        ft.create_instance(instance_name)
-        ft.tracing_ON(instance=instance_name)
-        self.assertTrue(ft.is_tracing_ON(instance=instance_name))
+        inst = ft.create_instance(instance_name)
+        ft.tracing_ON(instance=inst)
+        self.assertTrue(ft.is_tracing_ON(instance=inst))
         self.assertFalse(ft.is_tracing_ON())
-        ft.tracing_OFF(instance=instance_name)
-
-        ft.destroy_all_instances()
+        ft.tracing_OFF(instance=inst)
 
     def test_err(self):
-        err = 'returned a result with an error set'
+        err = 'incompatible type'
         with self.assertRaises(Exception) as context:
             ft.tracing_ON('zero')
         self.assertTrue(err in str(context.exception))
diff --git a/tests/2_integration/test_01_ftracepy_integration.py b/tests/2_integration/test_01_ftracepy_integration.py
index d3b2c6b..824decd 100755
--- a/tests/2_integration/test_01_ftracepy_integration.py
+++ b/tests/2_integration/test_01_ftracepy_integration.py
@@ -19,18 +19,9 @@ class InstanceTestCase(unittest.TestCase):
 
         for i in range(25) :
             instance_name = 'test_instance_%s' % i
-            ft.create_instance(instance_name)
+            inst = ft.create_instance(instance_name)
             self.assertTrue(os.path.isdir(instances_dir + instance_name))
 
-        for i in range(15) :
-            instance_name = 'test_instance_%s' % i
-            ft.destroy_instance(instance_name)
-            self.assertFalse(os.path.isdir(instances_dir + instance_name))
-
-        self.assertEqual(len(os.listdir(instances_dir)), 10)
-        ft.destroy_instance('all')
-        self.assertEqual(len(os.listdir(instances_dir)), 0)
-
     def test_current_tracer(self):
         current = ft.get_current_tracer()
         self.assertEqual(current, 'nop')
@@ -42,68 +33,67 @@ class InstanceTestCase(unittest.TestCase):
         ft.set_current_tracer()
 
         instance_name = 'test_instance'
-        ft.create_instance(instance_name)
-        current = ft.get_current_tracer(instance=instance_name)
+        inst = ft.create_instance(instance_name)
+        current = ft.get_current_tracer(instance=inst)
         self.assertEqual(current, 'nop')
-        ft.tracing_OFF(instance=instance_name)
-        ft.set_current_tracer(instance=instance_name, tracer=name)
-        current = ft.get_current_tracer(instance=instance_name)
+        ft.tracing_OFF(instance=inst)
+        ft.set_current_tracer(instance=inst, tracer=name)
+        current = ft.get_current_tracer(instance=inst)
         self.assertEqual(current, name)
-        ft.destroy_instance('all')
 
     def test_enable_events(self):
         instance_name = 'test_instance'
-        ft.create_instance(instance_name)
-        systems = ft.available_event_systems(instance=instance_name)
+        inst = ft.create_instance(instance_name)
+        systems = ft.available_event_systems(instance=inst)
         systems.remove('ftrace')
         for s in systems:
-            ret = ft.event_is_enabled(instance=instance_name,
+            ret = ft.event_is_enabled(instance=inst,
                                        system=s)
             self.assertEqual(ret, '0')
-            ft.enable_event(instance=instance_name,
+            ft.enable_event(instance=inst,
                              system=s)
-            ret = ft.event_is_enabled(instance=instance_name,
+            ret = ft.event_is_enabled(instance=inst,
                                        system=s)
             self.assertEqual(ret, '1')
 
-            ft.disable_event(instance=instance_name,
+            ft.disable_event(instance=inst,
                              system=s)
-            events = ft.available_system_events(instance=instance_name,
+            events = ft.available_system_events(instance=inst,
                                                  system=s)
             for e in events:
-                ret = ft.event_is_enabled(instance=instance_name,
+                ret = ft.event_is_enabled(instance=inst,
                                            system=s,
                                            event=e)
                 self.assertEqual(ret, '0')
-                ft.enable_event(instance=instance_name,
+                ft.enable_event(instance=inst,
                                  system=s,
                                  event=e)
-                ret = ft.event_is_enabled(instance=instance_name,
+                ret = ft.event_is_enabled(instance=inst,
                                            system=s,
                                            event=e)
                 self.assertEqual(ret, '1')
-                ret = ft.event_is_enabled(instance=instance_name,
+                ret = ft.event_is_enabled(instance=inst,
                                            system=s)
                 if e != events[-1]:
                     self.assertEqual(ret, 'X')
 
-            ret = ft.event_is_enabled(instance=instance_name,
+            ret = ft.event_is_enabled(instance=inst,
                                        system=s)
             self.assertEqual(ret, '1')
 
-        ret = ft.event_is_enabled(instance=instance_name,
+        ret = ft.event_is_enabled(instance=inst,
                                    system=s)
         self.assertEqual(ret, '1')
 
-        ft.disable_event(instance=instance_name, event='all')
+        ft.disable_event(instance=inst, event='all')
         for s in systems:
-            ret = ft.event_is_enabled(instance=instance_name,
+            ret = ft.event_is_enabled(instance=inst,
                                        system=s)
             self.assertEqual(ret, '0')
-            events = ft.available_system_events(instance=instance_name,
+            events = ft.available_system_events(instance=inst,
                                                  system=s)
             for e in events:
-                ret = ft.event_is_enabled(instance=instance_name,
+                ret = ft.event_is_enabled(instance=inst,
                                            system=s,
                                            event=e)
                 self.assertEqual(ret, '0')
-- 
2.30.2

