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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D729C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55EE86108D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239334AbhHSNJX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 09:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239300AbhHSNJX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 09:09:23 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E32C061575
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:46 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l24-20020a05600c089800b002e71a10130eso768847wmp.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=af0/veNZR2GRMAsWeYJBmwt/TJhy86GjtwveRyzlLTw=;
        b=BAPyGkWLiny55YOG7qPd2kRKBVtrydHPEutGDf04a/ZZ6tQssdNRIBrzpn9HvQLmzH
         1tJl2PeTvuys0c5uy8p4cjBRpRG/38l41c5cE3HiWK6NHK1kiQH/CwYp1qrUlwL2ZKsp
         WrZ8rs61zd2oCW75qf8qVpEkOCSxtL/gESQN+IglYK2V1ItHD7tuO5XHd6opHr4qQUdS
         AfhW9t/5TxnxvV2wuZAqFtjVcA1Ccl0R4mrLhWjtQFNnW4zDiI7INnnnosyPNXu/5wZi
         Gag4mn+N39dMz6z/nfx2meAlU/05fv5m89sO8uFiDvBmmpE0ncd4YdQ+zgzcmf+YYlgA
         X8pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=af0/veNZR2GRMAsWeYJBmwt/TJhy86GjtwveRyzlLTw=;
        b=Ux2V8VVZUs+IaSsVNGEgbj6JW/4cWqJIozKjgcwSubGcwwf5rN2hcV3J0AORidcFNf
         59rWUV4Z3KLIG7ZzdQeFrpCRhfyDJvsn92i6W+iPki5YK3h6E3g5urP7qd0JtKaQ9XoG
         mv6UPgW1ETYELggR6CM5+wvDSbrm9Cpi6jP+zginCiqTfx0noZftOnWkG6xW4FzBFarY
         Ay/PVlOAiLoYhRjhRZ0Lsz1e9VJ4pFcCf8qk4hePqpnUKSMqz8g7o5gRdLuDOQYIQKEQ
         4QiWpQzdq8FDaospBrLTZXq231k2Tsc5kUMxPnTRn6y5dygnqtL95neYJjdben6IHyzj
         kt9w==
X-Gm-Message-State: AOAM532ofoekv0R5Sg9nR9HqyOZt/oaOLAkS7tfzn2UqlCaRzTAS1Q9Q
        0wJQd6BeEjjJb3tbrpeJFZObinse5P8=
X-Google-Smtp-Source: ABdhPJxdzJ+qizHZ7yXwxX1HT5Y7iMZGTxREwuElqP+Qgcah3DFQ2XzthxotUOdO39IkI9WWLBC7bw==
X-Received: by 2002:a1c:9dd0:: with SMTP id g199mr13966586wme.12.1629378525075;
        Thu, 19 Aug 2021 06:08:45 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id f17sm2889978wrt.49.2021.08.19.06.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:08:44 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 7/7] trace-cruncher: Refactor the way kprobes are handled
Date:   Thu, 19 Aug 2021 16:08:27 +0300
Message-Id: <20210819130827.12327-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210819130827.12327-1-y.karadz@gmail.com>
References: <20210819130827.12327-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently all kprobes, created by trace-cruncher, are stored in a
binary search tree. The ordering in the tree is based on a string
comparison. The tree is used for bookkeeping and to cleanup all
created kprobes when the module exits (garbage collection). In
this refactoring we eliminate the need of the tree by switching to
using the custom Python type for kprobes. The new type is defined
in the C extension of the module.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c                  | 260 ++++++++++----------------
 src/ftracepy-utils.h                  |  39 ++--
 src/ftracepy.c                        |  69 +++----
 tests/1_unit/test_01_ftracepy_unit.py |  53 ++----
 tracecruncher/ft_utils.py             |  14 +-
 5 files changed, 165 insertions(+), 270 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index b8bcb4c..581432d 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1349,16 +1349,6 @@ PyObject *PyFtrace_supported_options(PyObject *self, PyObject *args,
 	return get_option_list(instance, false);
 }
 
-static void *kprobe_root = NULL;
-
-static int kprobe_compare(const void *a, const void *b)
-{
-	const char *ca = (const char *) a;
-	const char *cb = (const char *) b;
-
-	return strcmp(ca, cb);
-}
-
 #define TC_SYS	"tcrunch"
 
 PyObject *PyFtrace_tc_event_system(PyObject *self)
@@ -1372,6 +1362,43 @@ struct ftracepy_kprobe {
 	char *probe;
 };
 
+static bool register_kprobe(const char *event,
+			    const char *function,
+			    const char *probe)
+{
+	if (tracefs_kprobe_raw(TC_SYS, event, function, probe) < 0) {
+		PyErr_Format(TFS_ERROR, "Failed to register kprobe \'%s\'.",
+			     event);
+		return false;
+	}
+
+	return true;
+}
+
+static bool register_kretprobe(const char *event,
+			       const char *function,
+			       const char *probe)
+{
+	if (tracefs_kretprobe_raw(TC_SYS, event, function, probe) < 0) {
+		PyErr_Format(TFS_ERROR, "Failed to register kretprobe \'%s\'.",
+			     event);
+		return false;
+	}
+
+	return true;
+}
+
+static bool unregister_kprobe(const char *event)
+{
+	if (tracefs_kprobe_clear_probe(TC_SYS, event, true) < 0) {
+		PyErr_Format(TFS_ERROR, "Failed to unregister kprobe \'%s\'.",
+			     event);
+		return false;
+	}
+
+	return true;
+}
+
 PyObject *PyKprobe_event(PyKprobe *self)
 {
 	return PyUnicode_FromString(self->ptrObj->event);
@@ -1392,6 +1419,11 @@ PyObject *PyKprobe_probe(PyKprobe *self)
 	return PyUnicode_FromString(self->ptrObj->probe);
 }
 
+void ftracepy_kprobe_destroy(struct ftracepy_kprobe *kp)
+{
+	unregister_kprobe(kp->event);
+}
+
 void ftracepy_kprobe_free(struct ftracepy_kprobe *kp)
 {
 	free(kp->event);
@@ -1400,46 +1432,41 @@ void ftracepy_kprobe_free(struct ftracepy_kprobe *kp)
 	free(kp);
 }
 
-static int unregister_kprobe(const char *event)
-{
-	return tracefs_kprobe_clear_probe(TC_SYS, event, true);
-}
-
-void kprobe_free(void *kp)
+static struct ftracepy_kprobe *
+kprobe_new(const char *event, const char *function, const char *probe,
+	   bool retprobe)
 {
-	char *event = kp;
+	struct ftracepy_kprobe *new_kprobe;
 
-	if (unregister_kprobe(event) < 0)
-		fprintf(stderr, "\ntfs_error: Failed to unregister kprobe \'%s\'.\n",
-		        event);
-
-	free(kp);
-}
+	if (retprobe) {
+		if (!register_kretprobe(event, function, probe))
+			return NULL;
+	} else {
+		if (!register_kprobe(event, function, probe))
+			return NULL;
+	}
 
-static void destroy_all_kprobes(void)
-{
-	tdestroy(kprobe_root, kprobe_free);
-	kprobe_root = NULL;
-}
+	new_kprobe = calloc(1, sizeof(*new_kprobe));
+	if (!new_kprobe) {
+		MEM_ERROR;
+		unregister_kprobe(event);
 
-bool store_new_kprobe(const char *event)
-{
-	char *ptr = strdup(event);
-	char **val;
+		return NULL;
+	}
 
-	if (!ptr) {
+	new_kprobe->event = strdup(event);
+	new_kprobe->function = strdup(function);
+	new_kprobe->probe = strdup(probe);
+	if (!new_kprobe->event ||
+	    !new_kprobe->function ||
+	    !new_kprobe->probe) {
 		MEM_ERROR;
-		return false;
-	}
+		ftracepy_kprobe_free(new_kprobe);
 
-	val = tsearch(ptr, &kprobe_root, kprobe_compare);
-	if (!val || strcmp(*val, ptr) != 0) {
-		PyErr_Format(TFS_ERROR, "Failed to store new kprobe \'%s\'.",
-			     event);
-		return false;
+		return NULL;
 	}
 
-	return true;
+	return new_kprobe;
 }
 
 PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
@@ -1447,6 +1474,7 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 {
 	static char *kwlist[] = {"event", "function", "probe", NULL};
 	const char *event, *function, *probe;
+	struct ftracepy_kprobe *kprobe;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
@@ -1458,16 +1486,11 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 		return NULL;
 	}
 
-	if (tracefs_kprobe_raw(TC_SYS, event, function, probe) < 0) {
-		PyErr_Format(TFS_ERROR, "Failed to register kprobe \'%s\'.",
-			     event);
-		return NULL;
-	}
-
-	if (!store_new_kprobe(event))
+	kprobe = kprobe_new(event, function, probe, false);
+	if (!kprobe)
 		return NULL;
 
-	Py_RETURN_NONE;
+	return PyKprobe_New(kprobe);
 }
 
 PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
@@ -1475,6 +1498,7 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 {
 	static char *kwlist[] = {"event", "function", "probe", NULL};
 	const char *event, *function, *probe = "$retval";
+	struct ftracepy_kprobe *kprobe;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
@@ -1486,102 +1510,26 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 		return NULL;
 	}
 
-	if (tracefs_kretprobe_raw(TC_SYS, event, function, probe) < 0) {
-		PyErr_Format(TFS_ERROR, "Failed to register kretprobe \'%s\'.",
-			     event);
+	kprobe = kprobe_new(event, function, probe, true);
+	if (!kprobe)
 		return NULL;
-	}
-
-	if (!store_new_kprobe(event))
-		return NULL;
-
-	Py_RETURN_NONE;
-}
-
-PyObject *PyFtrace_unregister_kprobe(PyObject *self, PyObject *args,
-						     PyObject *kwargs)
-{
-	static char *kwlist[] = {"event", "force",  NULL};
-	const char *event;
-	int force = false;
-
-	if (!PyArg_ParseTupleAndKeywords(args,
-					 kwargs,
-					 "s|p",
-					 kwlist,
-					 &event,
-					 &force)) {
-		return NULL;
-	}
-
-	if (is_all(event)) {
-		if (force) {
-			/* Clear all register kprobes. */
-			if (tracefs_kprobe_clear_all(force) < 0)
-				goto fail;
-		} else {
-			/*
-			 * Clear only the kprobes registered by
-			 * trace-cruncher.
-			 */
-			destroy_all_kprobes();
-		}
-	} else {
-		tdelete(event, &kprobe_root, kprobe_compare);
-		if (unregister_kprobe(event) < 0)
-			goto fail;
-	}
-
-	Py_RETURN_NONE;
 
- fail:
-	PyErr_Format(TFS_ERROR, "Failed to unregister kprobe \'%s\'.", event);
-	return NULL;
-}
-
-PyObject *PyFtrace_registered_kprobe_names(PyObject *self)
-{
-	char **list = tracefs_get_kprobes(TRACEFS_ALL_KPROBES);
-	return tfs_list2py_list(list);
+	return PyKprobe_New(kprobe);
 }
 
-PyObject *PyFtrace_registered_kprobes(PyObject *self)
-{
-	const char *file = "kprobe_events";
-	PyObject *list = PyList_New(0);
-	char *probes, *token;
-	int size;
-
-	size = read_from_file(NULL, file, &probes);
-	if (size < 0)
-		return NULL;
-
-	if (size == 0 || !probes)
-		return list;
-
-	token = strtok(probes, "\n");
-	while (token != NULL) {
-		PyList_Append(list, PyUnicode_FromString(token));
-		token = strtok(NULL, "\n");
-	}
-
-	return list;
-}
-
-PyObject *PyFtrace_set_kprobe_filter(PyObject *self, PyObject *args,
-						     PyObject *kwargs)
+PyObject *PyKprobe_set_filter(PyKprobe *self, PyObject *args,
+					      PyObject *kwargs)
 {
 	struct tracefs_instance *instance;
 	PyObject *py_inst = NULL;
-	const char *event, *filter;
+	const char *filter;
 	char path[PATH_MAX];
 
-	static char *kwlist[] = {"event", "filter", "instance", NULL};
+	static char *kwlist[] = {"filter", "instance", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "ss|O",
+					 "s|O",
 					 kwlist,
-					 &event,
 					 &filter,
 					 &py_inst)) {
 		return NULL;
@@ -1590,7 +1538,7 @@ PyObject *PyFtrace_set_kprobe_filter(PyObject *self, PyObject *args,
 	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
-	sprintf(path, "events/%s/%s/filter", TC_SYS, event);
+	sprintf(path, "events/%s/%s/filter", TC_SYS, self->ptrObj->event);
 	if (!write_to_file_and_check(instance, path, filter)) {
 		PyErr_SetString(TFS_ERROR, "Failed to set kprobe filter.");
 		return NULL;
@@ -1599,20 +1547,18 @@ PyObject *PyFtrace_set_kprobe_filter(PyObject *self, PyObject *args,
 	Py_RETURN_NONE;
 }
 
-PyObject *PyFtrace_clear_kprobe_filter(PyObject *self, PyObject *args,
-						       PyObject *kwargs)
+PyObject *PyKprobe_clear_filter(PyKprobe *self, PyObject *args,
+						PyObject *kwargs)
 {
 	struct tracefs_instance *instance;
 	PyObject *py_inst = NULL;
 	char path[PATH_MAX];
-	const char *event;
 
-	static char *kwlist[] = {"event", "instance", NULL};
+	static char *kwlist[] = {"instance", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "s|O",
+					 "|O",
 					 kwlist,
-					 &event,
 					 &py_inst)) {
 		return NULL;
 	}
@@ -1620,7 +1566,7 @@ PyObject *PyFtrace_clear_kprobe_filter(PyObject *self, PyObject *args,
 	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
-	sprintf(path, "events/%s/%s/filter", TC_SYS, event);
+	sprintf(path, "events/%s/%s/filter", TC_SYS, self->ptrObj->event);
 	if (!write_to_file(instance, path, OFF)) {
 		PyErr_SetString(TFS_ERROR, "Failed to clear kprobe filter.");
 		return NULL;
@@ -1629,19 +1575,17 @@ PyObject *PyFtrace_clear_kprobe_filter(PyObject *self, PyObject *args,
 	Py_RETURN_NONE;
 }
 
-static bool enable_kprobe(PyObject *self, PyObject *args, PyObject *kwargs,
+static bool enable_kprobe(PyKprobe *self, PyObject *args, PyObject *kwargs,
 			  bool enable)
 {
-	static char *kwlist[] = {"event", "instance", NULL};
+	static char *kwlist[] = {"instance", NULL};
 	struct tracefs_instance *instance;
 	PyObject *py_inst = NULL;
-	const char *event = NO_ARG;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "s|O",
+					 "|O",
 					 kwlist,
-					 &event,
 					 &py_inst)) {
 		return false;
 	}
@@ -1649,11 +1593,12 @@ static bool enable_kprobe(PyObject *self, PyObject *args, PyObject *kwargs,
 	if (!get_optional_instance(py_inst, &instance))
 		return false;
 
-	return event_enable_disable(instance, TC_SYS, event, enable);
+	return event_enable_disable(instance, TC_SYS, self->ptrObj->event,
+				    enable);
 }
 
-PyObject *PyFtrace_enable_kprobe(PyObject *self, PyObject *args,
-						 PyObject *kwargs)
+PyObject *PyKprobe_enable(PyKprobe *self, PyObject *args,
+					  PyObject *kwargs)
 {
 	if (!enable_kprobe(self, args, kwargs, true))
 		return NULL;
@@ -1661,8 +1606,8 @@ PyObject *PyFtrace_enable_kprobe(PyObject *self, PyObject *args,
 	Py_RETURN_NONE;
 }
 
-PyObject *PyFtrace_disable_kprobe(PyObject *self, PyObject *args,
-						  PyObject *kwargs)
+PyObject *PyKprobe_disable(PyKprobe *self, PyObject *args,
+					   PyObject *kwargs)
 {
 	if (!enable_kprobe(self, args, kwargs, false))
 		return NULL;
@@ -1670,19 +1615,17 @@ PyObject *PyFtrace_disable_kprobe(PyObject *self, PyObject *args,
 	Py_RETURN_NONE;
 }
 
-PyObject *PyFtrace_kprobe_is_enabled(PyObject *self, PyObject *args,
-						     PyObject *kwargs)
+PyObject *PyKprobe_is_enabled(PyKprobe *self, PyObject *args,
+					      PyObject *kwargs)
 {
-	static char *kwlist[] = {"event", "instance", NULL};
+	static char *kwlist[] = {"instance", NULL};
 	struct tracefs_instance *instance;
 	PyObject *py_inst = NULL;
-	const char *event = NO_ARG;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "s|O",
+					 "|O",
 					 kwlist,
-					 &event,
 					 &py_inst)) {
 		return NULL;
 	}
@@ -1690,7 +1633,7 @@ PyObject *PyFtrace_kprobe_is_enabled(PyObject *self, PyObject *args,
 	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
-	return event_is_enabled(instance, TC_SYS, event);
+	return event_is_enabled(instance, TC_SYS, self->ptrObj->event);
 }
 
 PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
@@ -2110,5 +2053,4 @@ PyObject *PyFtrace_hook2pid(PyObject *self, PyObject *args, PyObject *kwargs)
 
 void PyFtrace_at_exit(void)
 {
-	destroy_all_kprobes();
 }
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 17e07e5..4e04fb0 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -26,6 +26,8 @@ C_OBJECT_WRAPPER_DECLARE(tracefs_instance, PyTfsInstance)
 
 struct ftracepy_kprobe;
 
+void ftracepy_kprobe_destroy(struct ftracepy_kprobe *kp);
+
 void ftracepy_kprobe_free(struct ftracepy_kprobe *kp);
 
 C_OBJECT_WRAPPER_DECLARE(ftracepy_kprobe, PyKprobe);
@@ -62,6 +64,21 @@ PyObject *PyKprobe_function(PyKprobe *self);
 
 PyObject *PyKprobe_probe(PyKprobe *self);
 
+PyObject *PyKprobe_set_filter(PyKprobe *self, PyObject *args,
+					      PyObject *kwargs);
+
+PyObject *PyKprobe_clear_filter(PyKprobe *self, PyObject *args,
+						PyObject *kwargs);
+
+PyObject *PyKprobe_enable(PyKprobe *self, PyObject *args,
+					  PyObject *kwargs);
+
+PyObject *PyKprobe_disable(PyKprobe *self, PyObject *args,
+					   PyObject *kwargs);
+
+PyObject *PyKprobe_is_enabled(PyKprobe *self, PyObject *args,
+					      PyObject *kwargs);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
@@ -143,28 +160,6 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 						      PyObject *kwargs);
 
-PyObject *PyFtrace_unregister_kprobe(PyObject *self, PyObject *args,
-						     PyObject *kwargs);
-
-PyObject *PyFtrace_registered_kprobes(PyObject *self);
-
-PyObject *PyFtrace_registered_kprobe_names(PyObject *self);
-
-PyObject *PyFtrace_set_kprobe_filter(PyObject *self, PyObject *args,
-						     PyObject *kwargs);
-
-PyObject *PyFtrace_clear_kprobe_filter(PyObject *self, PyObject *args,
-						       PyObject *kwargs);
-
-PyObject *PyFtrace_enable_kprobe(PyObject *self, PyObject *args,
-						 PyObject *kwargs);
-
-PyObject *PyFtrace_disable_kprobe(PyObject *self, PyObject *args,
-						  PyObject *kwargs);
-
-PyObject *PyFtrace_kprobe_is_enabled(PyObject *self, PyObject *args,
-						     PyObject *kwargs);
-
 PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
 						       PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index c434af9..a4fba01 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -107,11 +107,36 @@ static PyMethodDef PyKprobe_methods[] = {
 	 METH_NOARGS,
 	 "Get the kprobe event definition."
 	},
+	{"set_filter",
+	 (PyCFunction) PyKprobe_set_filter,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define a filter for a kprobe."
+	},
+	{"clear_filter",
+	 (PyCFunction) PyKprobe_clear_filter,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Clear the filter of a kprobe."
+	},
+	{"enable",
+	 (PyCFunction) PyKprobe_enable,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Enable kprobe event."
+	},
+	{"disable",
+	 (PyCFunction) PyKprobe_disable,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Disable kprobe event."
+	},
+	{"is_enabled",
+	 (PyCFunction) PyKprobe_is_enabled,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Check if kprobe event is enabled."
+	},
 	{NULL, NULL, 0, NULL}
 };
 
 C_OBJECT_WRAPPER(ftracepy_kprobe, PyKprobe,
-		 NO_DESTROY,
+		 ftracepy_kprobe_destroy,
 		 ftracepy_kprobe_free)
 
 static PyMethodDef ftracepy_methods[] = {
@@ -255,46 +280,6 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Define a kretprobe."
 	},
-	{"unregister_kprobe",
-	 (PyCFunction) PyFtrace_unregister_kprobe,
-	 METH_VARARGS | METH_KEYWORDS,
-	 "Define a kprobe."
-	},
-	{"registered_kprobes",
-	 (PyCFunction) PyFtrace_registered_kprobes,
-	 METH_NOARGS,
-	 "Get all registered kprobes."
-	},
-	{"registered_kprobe_names",
-	 (PyCFunction) PyFtrace_registered_kprobe_names,
-	 METH_NOARGS,
-	 "Get the names of all registered kprobes."
-	},
-	{"set_kprobe_filter",
-	 (PyCFunction) PyFtrace_set_kprobe_filter,
-	 METH_VARARGS | METH_KEYWORDS,
-	 "Define a filter for a kprobe."
-	},
-	{"clear_kprobe_filter",
-	 (PyCFunction) PyFtrace_clear_kprobe_filter,
-	 METH_VARARGS | METH_KEYWORDS,
-	 "Clear the filter of a kprobe."
-	},
-	{"enable_kprobe",
-	 (PyCFunction) PyFtrace_enable_kprobe,
-	 METH_VARARGS | METH_KEYWORDS,
-	 "Enable kprobe event."
-	},
-	{"disable_kprobe",
-	 (PyCFunction) PyFtrace_disable_kprobe,
-	 METH_VARARGS | METH_KEYWORDS,
-	 "Disable kprobe event."
-	},
-	{"kprobe_is_enabled",
-	 (PyCFunction) PyFtrace_kprobe_is_enabled,
-	 METH_VARARGS | METH_KEYWORDS,
-	 "Check if kprobe event is enabled."
-	},
 	{"set_ftrace_loglevel",
 	 (PyCFunction) PyFtrace_set_ftrace_loglevel,
 	 METH_VARARGS | METH_KEYWORDS,
@@ -362,7 +347,7 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	TRACECRUNCHER_ERROR = PyErr_NewException("tracecruncher.tc_error",
 						 NULL, NULL);
 
-	PyObject *module =  PyModule_Create(&ftracepy_module);
+	PyObject *module = PyModule_Create(&ftracepy_module);
 
 	PyModule_AddObject(module, "tep_handle", (PyObject *) &PyTepType);
 	PyModule_AddObject(module, "tep_event", (PyObject *) &PyTepEventType);
diff --git a/tests/1_unit/test_01_ftracepy_unit.py b/tests/1_unit/test_01_ftracepy_unit.py
index 57db0ad..3411b3f 100644
--- a/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tests/1_unit/test_01_ftracepy_unit.py
@@ -403,34 +403,17 @@ class KprobeTestCase(unittest.TestCase):
         evt2_func = 'do_sys_openat2'
         evt2_prove = 'file=+u0($arg2):ustring'
 
-        ft.register_kprobe(event=evt1, function=evt1_func,
-                           probe=evt1_prove)
-        all_kprobes = ft.registered_kprobes()
-        self.assertEqual(len(all_kprobes), 1)
-        self.assertTrue(evt1 in all_kprobes[0])
-        self.assertTrue(evt1_func in all_kprobes[0])
-        self.assertTrue(evt1_prove in all_kprobes[0])
-
-        ft.unregister_kprobe(event=evt1)
-        all_kprobes = ft.registered_kprobes()
-        self.assertEqual(len(all_kprobes), 0)
-
-        ft.register_kprobe(event=evt1, function=evt1_func,
-                           probe=evt1_prove)
-        ft.register_kprobe(event=evt2, function=evt2_func,
-                           probe=evt2_prove)
-        all_kprobes = ft.registered_kprobes()
-        self.assertEqual(len(all_kprobes), 2)
-        self.assertTrue(evt1 in all_kprobes[0])
-        self.assertTrue(evt1_func in all_kprobes[0])
-        self.assertTrue(evt1_prove in all_kprobes[0])
-        self.assertTrue(evt2 in all_kprobes[1])
-        self.assertTrue(evt2_func in all_kprobes[1])
-        self.assertTrue(evt2_prove in all_kprobes[1])
-
-        ft.unregister_kprobe(event='ALL')
-        all_kprobes = ft.registered_kprobes()
-        self.assertEqual(len(all_kprobes), 0)
+        kp1 = ft.register_kprobe(event=evt1, function=evt1_func,
+                                 probe=evt1_prove)
+        self.assertEqual(evt1, kp1.event())
+        self.assertEqual(evt1_func, kp1.function())
+        self.assertEqual(evt1_prove, kp1.probe())
+
+        kp2 = ft.register_kprobe(event=evt2, function=evt2_func,
+                                 probe=evt2_prove)
+        self.assertEqual(evt2, kp2.event())
+        self.assertEqual(evt2_func, kp2.function())
+        self.assertEqual(evt2_prove, kp2.probe())
 
 
     def test_enable_kprobe(self):
@@ -438,19 +421,17 @@ class KprobeTestCase(unittest.TestCase):
         evt1_func = 'do_mkdirat'
         evt1_prove = 'path=+u0($arg2):ustring'
 
-        ft.register_kprobe(event=evt1, function=evt1_func,
-                           probe=evt1_prove)
+        kp1 = ft.register_kprobe(event=evt1, function=evt1_func,
+                                 probe=evt1_prove)
         inst = ft.create_instance(instance_name)
-        ft.enable_kprobe(instance=inst, event=evt1)
-        ret = ft.kprobe_is_enabled(instance=inst, event=evt1)
+        kp1.enable(instance=inst)
+        ret = kp1.is_enabled(instance=inst)
         self.assertEqual(ret, '1')
 
-        ft.disable_kprobe(instance=inst, event=evt1)
-        ret = ft.kprobe_is_enabled(instance=inst, event=evt1)
+        kp1.disable(instance=inst)
+        ret = kp1.is_enabled(instance=inst)
         self.assertEqual(ret, '0')
 
-        ft.unregister_kprobe(event='ALL')
-
 
 class TracingOnTestCase(unittest.TestCase):
     def test_ON_OF(self):
diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index 8c245b1..5caaa76 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -99,21 +99,13 @@ class kprobe_base(event):
         """
         super().__init__(system=ft.tc_event_system(), name=name, static=False)
         self.func = func
+        self.kp = None
 
     def set_function(self, name):
         """ Set the name of the function to be traced.
         """
         self.func = name
 
-    def unregister(self):
-        """ Unregister this probe from Ftrace.
-        """
-        inst_list = self.instance_list.copy()
-        for instance in inst_list:
-            self.disable(instance)
-
-        ft.unregister_kprobe(event=self.name);
-
 
 class kprobe(kprobe_base):
     def __init__(self, name, func=''):
@@ -176,7 +168,7 @@ class kprobe(kprobe_base):
         """
         probe = ' '.join('{!s}={!s}'.format(key,val) for (key, val) in self.fields.items())
 
-        ft.register_kprobe(event=self.name, function=self.func, probe=probe);
+        self.kp = ft.register_kprobe(event=self.name, function=self.func, probe=probe);
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
 
 
@@ -206,5 +198,5 @@ class kretval_probe(kprobe_base):
     def register(self):
         """ Register this probe to Ftrace.
         """
-        ft.register_kprobe(event=self.name, function=self.func);
+        self.kp = ft.register_kprobe(event=self.name, function=self.func);
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
-- 
2.30.2

