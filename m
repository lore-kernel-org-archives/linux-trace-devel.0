Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88154C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Dec 2021 13:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhLGNtU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 08:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237286AbhLGNtT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 08:49:19 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D13C061746
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Dec 2021 05:45:49 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id o13so29514704wrs.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Dec 2021 05:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7LlIF2i0g6s0BijiIE4GJprgXJEbagqeZK9J65V/icQ=;
        b=LXIezapmWjKt76CiuTwZzYh4DNLZkbMiO+fRjHfNZvoSDDOdp/yvfK2E7KgXdBkrLm
         HlQZvs6KrGzmID5B8lMgB4CQybuRwY6emgu9vlQkvTZ0LkuRgQrqY1SpoP9jnuObqENR
         CV0fjKWKqKrQ7FRtM2WNi/zu0lYKGZ58aGgPpkte17oYMeBILc2e8tt1wuxBST8dr2GN
         WEMIpfzFTx1Ap65qajs5GlQQGur5YgytVhFTKEvCFQ//RqyqbmXiILRCIUIc7Xd4JQ/d
         Jx5O0eP/hJE7Fag0z4c6XlvBamZ7kHGyW2jMUCa7E/K6rMH2VLL1+zAk53unkeLoKas0
         IA5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7LlIF2i0g6s0BijiIE4GJprgXJEbagqeZK9J65V/icQ=;
        b=bdqT+lnfHFBuajseaRj3Bw5lhcxIn0NBqxmmsGlCgzOqzPIvgnMpgJcTMTbUxAZenH
         IMtmeaT0djPAKmJtB8XqT1ycodvRv3hW2oza02xoO4LYgkOFHdmXP4y7NKhR5fvAuFk6
         8yIkZtdH1CNiNXdRpEqSSXoZoVxKjwrKO9uV0d9KdOvZez+E2gdFXjkEhjahzs3E8PoU
         6FoYi8aUb8Z25DIse2al9Q9iYz+q2GC3rAzy1MawE9y6mYoSgvfpAc18Pnwlys0Ny8JV
         JRZHfn8PcI6LFn45i9A1+d+r4M5NsJYI8IHVgaBlchA42R2GBn8EItEXaYAzszP9K6Dp
         5Gbg==
X-Gm-Message-State: AOAM531FsYjx/YMkJ8sqdR84EMHUV5DTE5IJIWWQqZgr7CbTzpms+kf5
        Kihd68LHprj3L860N4zJ0hHjlcyJn0U=
X-Google-Smtp-Source: ABdhPJzbcp3NlOYEuVIZtzpGFS+RH7KkzIi2Nvs3o+5KK+9tubqX9h9yrI0IQzD+qUw6GgxVHKhx/g==
X-Received: by 2002:adf:aa08:: with SMTP id p8mr51291336wrd.572.1638884747458;
        Tue, 07 Dec 2021 05:45:47 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id m1sm2675606wme.39.2021.12.07.05.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 05:45:47 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2] trace-cruncher: Switch from kprobes to dynevents
Date:   Tue,  7 Dec 2021 15:44:59 +0200
Message-Id: <20211207134459.394546-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace-cruncher currently uses some untagged libtracefs APIs - in
particular the APIs for dealing with kprobes. Those libtracefs
APIs have been modified recently, so here we port those changes
into trace-cruncher.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---

Changes in v2:
 - adding a fix for the renamed tracefs_event_filter*() APIs.


 src/ftracepy-utils.c                          | 278 ++++++++++--------
 src/ftracepy-utils.h                          |  29 +-
 src/ftracepy.c                                |  60 ++--
 .../tests/1_unit/test_01_ftracepy_unit.py     |  20 +-
 .../test_01_ftracepy_integration.py           |   3 +-
 5 files changed, 226 insertions(+), 164 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index b5cdcee..7f3daca 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1668,117 +1668,55 @@ PyObject *PyFtrace_tc_event_system(PyObject *self)
 	return PyUnicode_FromString(TC_SYS);
 }
 
-struct ftracepy_kprobe {
-	char *event;
-	char *function;
-	char *probe;
-};
-
-static bool register_kprobe(const char *event,
-			    const char *function,
-			    const char *probe)
-{
-	if (tracefs_kprobe_raw(TC_SYS, event, function, probe) < 0) {
-		TfsError_fmt(NULL, "Failed to register kprobe \'%s\'.",
-			     event);
-		return false;
-	}
-
-	return true;
-}
-
-static bool register_kretprobe(const char *event,
-			       const char *function,
-			       const char *probe)
+static PyObject *dynevent_info2py(char *buff, int type)
 {
-	if (tracefs_kretprobe_raw(TC_SYS, event, function, probe) < 0) {
-		TfsError_fmt(NULL, "Failed to register kretprobe \'%s\'.",
-			     event);
-		return false;
-	}
-
-	return true;
-}
+	PyObject *ret;
 
-static bool unregister_kprobe(const char *event)
-{
-	if (tracefs_kprobe_clear_probe(TC_SYS, event, true) < 0) {
-		TfsError_fmt(NULL, "Failed to unregister kprobe \'%s\'.",
-			     event);
-		return false;
+	if (type == TRACEFS_DYNEVENT_UNKNOWN) {
+		PyErr_SetString(TFS_ERROR, "Failed to get dynevent info.");
+		return NULL;
 	}
 
-	return true;
-}
+	ret = PyUnicode_FromString(buff);
+	free(buff);
 
-PyObject *PyKprobe_event(PyKprobe *self)
-{
-	return PyUnicode_FromString(self->ptrObj->event);
+	return ret;
 }
 
-PyObject *PyKprobe_system(PyKprobe *self)
+PyObject *PyDynevent_system(PyDynevent *self)
 {
-	return PyUnicode_FromString(TC_SYS);
-}
+	char *buff;
+	int type;
 
-PyObject *PyKprobe_function(PyKprobe *self)
-{
-	return PyUnicode_FromString(self->ptrObj->function);
+	type = tracefs_dynevent_info(self->ptrObj, &buff, NULL, NULL, NULL, NULL);
+	return dynevent_info2py(buff, type);
 }
 
-PyObject *PyKprobe_probe(PyKprobe *self)
+PyObject *PyDynevent_event(PyDynevent *self)
 {
-	return PyUnicode_FromString(self->ptrObj->probe);
-}
+	char *buff;
+	int type;
 
-int ftracepy_kprobe_destroy(struct ftracepy_kprobe *kp)
-{
-	return tracefs_kprobe_clear_probe(TC_SYS, kp-> event, true);
+	type = tracefs_dynevent_info(self->ptrObj, NULL, &buff, NULL, NULL, NULL);
+	return dynevent_info2py(buff, type);
 }
 
-void ftracepy_kprobe_free(struct ftracepy_kprobe *kp)
+PyObject *PyDynevent_address(PyDynevent *self)
 {
-	free(kp->event);
-	free(kp->function);
-	free(kp->probe);
-	free(kp);
+	char *buff;
+	int type;
+
+	type = tracefs_dynevent_info(self->ptrObj, NULL, NULL, NULL, &buff, NULL);
+	return dynevent_info2py(buff, type);
 }
 
-static struct ftracepy_kprobe *
-kprobe_new(const char *event, const char *function, const char *probe,
-	   bool retprobe)
+PyObject *PyDynevent_probe(PyDynevent *self)
 {
-	struct ftracepy_kprobe *new_kprobe;
+	char *buff;
+	int type;
 
-	if (retprobe) {
-		if (!register_kretprobe(event, function, probe))
-			return NULL;
-	} else {
-		if (!register_kprobe(event, function, probe))
-			return NULL;
-	}
-
-	new_kprobe = calloc(1, sizeof(*new_kprobe));
-	if (!new_kprobe) {
-		MEM_ERROR;
-		unregister_kprobe(event);
-
-		return NULL;
-	}
-
-	new_kprobe->event = strdup(event);
-	new_kprobe->function = strdup(function);
-	new_kprobe->probe = strdup(probe);
-	if (!new_kprobe->event ||
-	    !new_kprobe->function ||
-	    !new_kprobe->probe) {
-		MEM_ERROR;
-		ftracepy_kprobe_free(new_kprobe);
-
-		return NULL;
-	}
-
-	return new_kprobe;
+	type = tracefs_dynevent_info(self->ptrObj, NULL, NULL, NULL, NULL, &buff);
+	return dynevent_info2py(buff, type);
 }
 
 PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
@@ -1786,7 +1724,7 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 {
 	static char *kwlist[] = {"event", "function", "probe", NULL};
 	const char *event, *function, *probe;
-	struct ftracepy_kprobe *kprobe;
+	struct tracefs_dynevent *kprobe;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
@@ -1798,11 +1736,19 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 		return NULL;
 	}
 
-	kprobe = kprobe_new(event, function, probe, false);
-	if (!kprobe)
+	kprobe = tracefs_kprobe_alloc(TC_SYS, event, function, probe);
+	if (!kprobe) {
+		MEM_ERROR;
 		return NULL;
+	}
+
+	if (tracefs_dynevent_create(kprobe) < 0) {
+		TfsError_fmt(NULL, "Failed to create kprobe '%s'", event);
+		tracefs_dynevent_free(kprobe);
+		return NULL;
+	}
 
-	return PyKprobe_New(kprobe);
+	return PyDynevent_New(kprobe);
 }
 
 PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
@@ -1810,7 +1756,7 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 {
 	static char *kwlist[] = {"event", "function", "probe", NULL};
 	const char *event, *function, *probe = "$retval";
-	struct ftracepy_kprobe *kprobe;
+	struct tracefs_dynevent *kprobe;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
@@ -1822,20 +1768,29 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 		return NULL;
 	}
 
-	kprobe = kprobe_new(event, function, probe, true);
-	if (!kprobe)
+	kprobe = tracefs_kretprobe_alloc(TC_SYS, event, function, probe, 0);
+	if (!kprobe) {
+		MEM_ERROR;
+		return NULL;
+	}
+
+	if (tracefs_dynevent_create(kprobe) < 0) {
+		TfsError_fmt(NULL, "Failed to create kretprobe '%s'", event);
+		tracefs_dynevent_free(kprobe);
 		return NULL;
+	}
 
-	return PyKprobe_New(kprobe);
+	return PyDynevent_New(kprobe);
 }
 
-PyObject *PyKprobe_set_filter(PyKprobe *self, PyObject *args,
-					      PyObject *kwargs)
+PyObject *PyDynevent_set_filter(PyDynevent *self, PyObject *args,
+						  PyObject *kwargs)
 {
 	struct tracefs_instance *instance;
 	PyObject *py_inst = NULL;
+	struct tep_handle * tep;
+	struct tep_event *event;
 	const char *filter;
-	char path[PATH_MAX];
 
 	static char *kwlist[] = {"filter", "instance", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
@@ -1850,72 +1805,153 @@ PyObject *PyKprobe_set_filter(PyKprobe *self, PyObject *args,
 	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
-	sprintf(path, "events/%s/%s/filter", TC_SYS, self->ptrObj->event);
-	if (!write_to_file_and_check(instance, path, filter)) {
-		TfsError_setstr(instance, "Failed to set kprobe filter.");
+	tep = tracefs_local_events(NULL);
+	if (!tep) {
+		TfsError_setstr(NULL, "Failed to get local events.");
+		return NULL;
+	}
+
+	event = tracefs_dynevent_get_event(tep, self->ptrObj);
+	if (!event) {
+		TfsError_setstr(NULL, "Failed to get event.");
+		return NULL;
+	}
+
+	if (tracefs_event_filter_apply(instance, event, filter) < 0) {
+		TfsError_fmt(NULL, "Failed to apply filter '%s' to event '%s'.",
+			     filter, event->name);
 		return NULL;
 	}
 
 	Py_RETURN_NONE;
 }
 
-PyObject *PyKprobe_clear_filter(PyKprobe *self, PyObject *args,
-						PyObject *kwargs)
+PyObject *PyDynevent_get_filter(PyDynevent *self, PyObject *args,
+						  PyObject *kwargs)
 {
+	char *evt_name, *evt_system, *filter = NULL;
 	struct tracefs_instance *instance;
+	PyObject *ret = NULL;
 	char path[PATH_MAX];
+	int type;
 
 	if (!get_instance_from_arg(args, kwargs, &instance))
 		return NULL;
 
-	sprintf(path, "events/%s/%s/filter", TC_SYS, self->ptrObj->event);
-	if (!write_to_file(instance, path, OFF)) {
-		TfsError_setstr(instance, "Failed to clear kprobe filter.");
+	type = tracefs_dynevent_info(self->ptrObj, &evt_system, &evt_name,
+				     NULL, NULL, NULL);
+	if (type == TRACEFS_DYNEVENT_UNKNOWN) {
+		PyErr_SetString(TFS_ERROR, "Failed to get dynevent info.");
+		return NULL;
+	}
+
+	sprintf(path, "events/%s/%s/filter", evt_system, evt_name);
+	if (read_from_file(instance, path, &filter) <= 0)
+		goto free;
+
+	trim_new_line(filter);
+	ret = PyUnicode_FromString(filter);
+ free:
+	free(evt_system);
+	free(evt_name);
+	free(filter);
+
+	return ret;
+}
+
+PyObject *PyDynevent_clear_filter(PyDynevent *self, PyObject *args,
+						    PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+	struct tep_handle * tep;
+	struct tep_event *event;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	tep = tracefs_local_events(NULL);
+	if (!tep) {
+		TfsError_setstr(NULL, "Failed to get local events.");
+		return NULL;
+	}
+
+	event = tracefs_dynevent_get_event(tep, self->ptrObj);
+	if (!event) {
+		TfsError_setstr(NULL, "Failed to get event.");
+		return NULL;
+	}
+
+	if (tracefs_event_filter_clear(instance, event) < 0) {
+		TfsError_fmt(NULL, "Failed to clear filter for event '%s'.",
+			     event->name);
 		return NULL;
 	}
 
 	Py_RETURN_NONE;
 }
 
-static bool enable_kprobe(PyKprobe *self, PyObject *args, PyObject *kwargs,
+static bool enable_dynevent(PyDynevent *self, PyObject *args, PyObject *kwargs,
 			  bool enable)
 {
 	struct tracefs_instance *instance;
+	char * evt_name;
+	int type;
+	bool ret;
 
 	if (!get_instance_from_arg(args, kwargs, &instance))
 		return false;
 
-	return event_enable_disable(instance, TC_SYS, self->ptrObj->event,
-				    enable);
+	type = tracefs_dynevent_info(self->ptrObj, NULL, &evt_name, NULL, NULL, NULL);
+	if (type == TRACEFS_DYNEVENT_UNKNOWN) {
+		PyErr_SetString(TFS_ERROR, "Failed to get dynevent info.");
+		return NULL;
+	}
+
+	ret = event_enable_disable(instance, TC_SYS, evt_name, enable);
+	free(evt_name);
+
+	return ret;
 }
 
-PyObject *PyKprobe_enable(PyKprobe *self, PyObject *args,
-					  PyObject *kwargs)
+PyObject *PyDynevent_enable(PyDynevent *self, PyObject *args,
+					      PyObject *kwargs)
 {
-	if (!enable_kprobe(self, args, kwargs, true))
+	if (!enable_dynevent(self, args, kwargs, true))
 		return NULL;
 
 	Py_RETURN_NONE;
 }
 
-PyObject *PyKprobe_disable(PyKprobe *self, PyObject *args,
-					   PyObject *kwargs)
+PyObject *PyDynevent_disable(PyDynevent *self, PyObject *args,
+					       PyObject *kwargs)
 {
-	if (!enable_kprobe(self, args, kwargs, false))
+	if (!enable_dynevent(self, args, kwargs, false))
 		return NULL;
 
 	Py_RETURN_NONE;
 }
 
-PyObject *PyKprobe_is_enabled(PyKprobe *self, PyObject *args,
+PyObject *PyDynevent_is_enabled(PyDynevent *self, PyObject *args,
 					      PyObject *kwargs)
 {
 	struct tracefs_instance *instance;
+	char * evt_name;
+	PyObject *ret;
+	int type;
 
 	if (!get_instance_from_arg(args, kwargs, &instance))
 		return NULL;
 
-	return event_is_enabled(instance, TC_SYS, self->ptrObj->event);
+	type = tracefs_dynevent_info(self->ptrObj, NULL, &evt_name, NULL, NULL, NULL);
+	if (type == TRACEFS_DYNEVENT_UNKNOWN) {
+		PyErr_SetString(TFS_ERROR, "Failed to get dynevent info.");
+		return NULL;
+	}
+
+	ret = event_is_enabled(instance, TC_SYS, evt_name);
+	free(evt_name);
+
+	return ret;
 }
 
 PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index a6133cf..70e86ff 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -24,13 +24,9 @@ C_OBJECT_WRAPPER_DECLARE(tep_handle, PyTep)
 
 C_OBJECT_WRAPPER_DECLARE(tracefs_instance, PyTfsInstance)
 
-struct ftracepy_kprobe;
+struct tracefs_dynevent;
 
-int ftracepy_kprobe_destroy(struct ftracepy_kprobe *kp);
-
-void ftracepy_kprobe_free(struct ftracepy_kprobe *kp);
-
-C_OBJECT_WRAPPER_DECLARE(ftracepy_kprobe, PyKprobe);
+C_OBJECT_WRAPPER_DECLARE(tracefs_dynevent, PyDynevent);
 
 PyObject *PyTepRecord_time(PyTepRecord* self);
 
@@ -68,27 +64,30 @@ PyObject *PyTep_short_kprobe_print(PyTep *self, PyObject *args,
 
 PyObject *PyTfsInstance_dir(PyTfsInstance *self);
 
-PyObject *PyKprobe_event(PyKprobe *self);
+PyObject *PyDynevent_event(PyDynevent *self);
 
-PyObject *PyKprobe_system(PyKprobe *self);
+PyObject *PyDynevent_system(PyDynevent *self);
 
-PyObject *PyKprobe_function(PyKprobe *self);
+PyObject *PyDynevent_address(PyDynevent *self);
 
-PyObject *PyKprobe_probe(PyKprobe *self);
+PyObject *PyDynevent_probe(PyDynevent *self);
 
-PyObject *PyKprobe_set_filter(PyKprobe *self, PyObject *args,
+PyObject *PyDynevent_set_filter(PyDynevent *self, PyObject *args,
 					      PyObject *kwargs);
 
-PyObject *PyKprobe_clear_filter(PyKprobe *self, PyObject *args,
+PyObject *PyDynevent_get_filter(PyDynevent *self, PyObject *args,
+						  PyObject *kwargs);
+
+PyObject *PyDynevent_clear_filter(PyDynevent *self, PyObject *args,
 						PyObject *kwargs);
 
-PyObject *PyKprobe_enable(PyKprobe *self, PyObject *args,
+PyObject *PyDynevent_enable(PyDynevent *self, PyObject *args,
 					  PyObject *kwargs);
 
-PyObject *PyKprobe_disable(PyKprobe *self, PyObject *args,
+PyObject *PyDynevent_disable(PyDynevent *self, PyObject *args,
 					   PyObject *kwargs);
 
-PyObject *PyKprobe_is_enabled(PyKprobe *self, PyObject *args,
+PyObject *PyDynevent_is_enabled(PyDynevent *self, PyObject *args,
 					      PyObject *kwargs);
 
 PyObject *PyFtrace_dir(PyObject *self);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index cbf0ce0..fcc69dd 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -106,58 +106,67 @@ C_OBJECT_WRAPPER(tracefs_instance, PyTfsInstance,
 		 tracefs_instance_destroy,
 		 tracefs_instance_free)
 
-static PyMethodDef PyKprobe_methods[] = {
+static PyMethodDef PyDynevent_methods[] = {
 	{"event",
-	 (PyCFunction) PyKprobe_event,
+	 (PyCFunction) PyDynevent_event,
 	 METH_NOARGS,
-	 "Get the name of the kprobe event."
+	 "Get the name of the dynamic event."
 	},
 	{"system",
-	 (PyCFunction) PyKprobe_system,
+	 (PyCFunction) PyDynevent_system,
 	 METH_NOARGS,
-	 "Get the system name of the kprobe event."
+	 "Get the system name of the dynamic event."
 	},
-	{"function",
-	 (PyCFunction) PyKprobe_function,
+	{"address",
+	 (PyCFunction) PyDynevent_address,
 	 METH_NOARGS,
-	 "Get the function name of the kprobe event."
+	 "Get the address / function name of the dynamic event."
 	},
 	{"probe",
-	 (PyCFunction) PyKprobe_probe,
+	 (PyCFunction) PyDynevent_probe,
 	 METH_NOARGS,
-	 "Get the kprobe event definition."
+	 "Get the event definition."
 	},
 	{"set_filter",
-	 (PyCFunction) PyKprobe_set_filter,
+	 (PyCFunction) PyDynevent_set_filter,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Define a filter for a kprobe."
+	 "Define a filter for a dynamic event."
+	},
+	{"get_filter",
+	 (PyCFunction) PyDynevent_get_filter,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get the filter of a dynamic event."
 	},
 	{"clear_filter",
-	 (PyCFunction) PyKprobe_clear_filter,
+	 (PyCFunction) PyDynevent_clear_filter,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Clear the filter of a kprobe."
+	 "Clear the filter of a dynamic event."
 	},
 	{"enable",
-	 (PyCFunction) PyKprobe_enable,
+	 (PyCFunction) PyDynevent_enable,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Enable kprobe event."
+	 "Enable dynamic event."
 	},
 	{"disable",
-	 (PyCFunction) PyKprobe_disable,
+	 (PyCFunction) PyDynevent_disable,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Disable kprobe event."
+	 "Disable dynamic event."
 	},
 	{"is_enabled",
-	 (PyCFunction) PyKprobe_is_enabled,
+	 (PyCFunction) PyDynevent_is_enabled,
 	 METH_VARARGS | METH_KEYWORDS,
-	 "Check if kprobe event is enabled."
+	 "Check if dynamic event is enabled."
 	},
 	{NULL, NULL, 0, NULL}
 };
 
-C_OBJECT_WRAPPER(ftracepy_kprobe, PyKprobe,
-		 ftracepy_kprobe_destroy,
-		 ftracepy_kprobe_free)
+static int dynevent_destroy(struct tracefs_dynevent *devt)
+{
+	return tracefs_dynevent_destroy(devt, true);
+}
+C_OBJECT_WRAPPER(tracefs_dynevent, PyDynevent,
+		 dynevent_destroy,
+		 tracefs_dynevent_free)
 
 static PyMethodDef ftracepy_methods[] = {
 	{"dir",
@@ -375,7 +384,7 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	if (!PyTfsInstanceTypeInit())
 		return NULL;
 
-	if (!PyKprobeTypeInit())
+	if (!PyDyneventTypeInit())
 		return NULL;
 
 	TFS_ERROR = PyErr_NewException("tracecruncher.ftracepy.tfs_error",
@@ -393,7 +402,8 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	PyModule_AddObject(module, "tep_event", (PyObject *) &PyTepEventType);
 	PyModule_AddObject(module, "tep_record", (PyObject *) &PyTepRecordType);
 	PyModule_AddObject(module, "tracefs_instance", (PyObject *) &PyTfsInstanceType);
-	PyModule_AddObject(module, "ftracepy_kprobe", (PyObject *) &PyKprobeType);
+	PyModule_AddObject(module, "tracefs_dynevent", (PyObject *) &PyDyneventType);
+
 
 	PyModule_AddObject(module, "tfs_error", TFS_ERROR);
 	PyModule_AddObject(module, "tep_error", TEP_ERROR);
diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index b9c8fd0..8a5881e 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -414,15 +414,31 @@ class KprobeTestCase(unittest.TestCase):
         kp1 = ft.register_kprobe(event=evt1, function=evt1_func,
                                  probe=evt1_prove)
         self.assertEqual(evt1, kp1.event())
-        self.assertEqual(evt1_func, kp1.function())
+        self.assertEqual(evt1_func, kp1.address())
         self.assertEqual(evt1_prove, kp1.probe())
 
         kp2 = ft.register_kprobe(event=evt2, function=evt2_func,
                                  probe=evt2_prove)
         self.assertEqual(evt2, kp2.event())
-        self.assertEqual(evt2_func, kp2.function())
+        self.assertEqual(evt2_func, kp2.address())
         self.assertEqual(evt2_prove, kp2.probe())
 
+    def test_filter_kprobe(self):
+        evt1 = 'mkdir'
+        evt1_func = 'do_mkdirat'
+        evt1_prove = 'path=+u0($arg2):ustring'
+        flt = 'path~\'/sys/fs/cgroup/*\''
+
+        kp1 = ft.register_kprobe(event=evt1, function=evt1_func,
+                                 probe=evt1_prove)
+        inst = ft.create_instance(instance_name)
+
+        kp1.set_filter(instance=inst, filter=flt)
+        flt_get =  kp1.get_filter(instance=inst)
+        self.assertEqual(flt, flt_get)
+        kp1.clear_filter(instance=inst)
+        flt_get =  kp1.get_filter(instance=inst)
+        self.assertEqual(flt_get, 'none')
 
     def test_enable_kprobe(self):
         evt1 = 'mkdir'
diff --git a/tracecruncher/tests/2_integration/test_01_ftracepy_integration.py b/tracecruncher/tests/2_integration/test_01_ftracepy_integration.py
index 1db5f0b..69aaea0 100755
--- a/tracecruncher/tests/2_integration/test_01_ftracepy_integration.py
+++ b/tracecruncher/tests/2_integration/test_01_ftracepy_integration.py
@@ -45,7 +45,8 @@ class InstanceTestCase(unittest.TestCase):
         instance_name = 'test_instance'
         inst = ft.create_instance(instance_name)
         systems = ft.available_event_systems(instance=inst)
-        systems.remove('ftrace')
+        if 'ftrace' in systems:
+            systems.remove('ftrace')
         for s in systems:
             ret = ft.event_is_enabled(instance=inst,
                                        system=s)
-- 
2.32.0

