Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A00C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jan 2022 18:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbiA1SVR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jan 2022 13:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244651AbiA1SVQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jan 2022 13:21:16 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5579CC06173B
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jan 2022 10:21:16 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id f17so12514804wrx.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jan 2022 10:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HHetTWONN+R98r08NI7jIE8wyollHS0rlDTpu/zUFIQ=;
        b=Q3IS+8L2LjsiqKRfchkfHPUpJYPUoPCDjcV2kJq8YcEq9lYavduhzDxKUaF8PCP4J4
         aZZilZYn6rgVjlCwgLNUOJszIRoi51jfD0CMrwYkzK9P+/XoSdz/F7dtk8banJCaU5t8
         o0t+l3NyBu6XETLs8yfP1XFui2gxPYfapZaXqzJP2/gWlInssINYkQrl7fVgHPiRNQhQ
         f2LmnLmix55Elbr5USA5gIdm/CZTME8Z9FCqlxcrnwOpvmW+7PmouYq3XcxgiZmNM2UF
         MivYEdYHHTjj9XZINMQxrBz29DwseUbcjoF4Pz2t7l2nGFQy4NpcuOUeCmtybAePxKlk
         mTUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HHetTWONN+R98r08NI7jIE8wyollHS0rlDTpu/zUFIQ=;
        b=Gf207Ipyr2zcyM1jJgCVqVE7qJYFDqW/tI3Tb7NZway9EtZJCxWwCNKvq65Co14lFI
         EWfszQgAu+Zq7ipvfQHydTcOMB/5Je4h8mQiLoJme+oTDH24AOh//+UNoturKB4lnseb
         +lbw1OYhKvLChi/DtGgOqpQECCRvvLN8esHBF404nyKLcRO+8Ix6vY8i3f+CdWLH4am9
         AsGe7FkeaVclw2Pb19guz7eintmNKkqukySOXIL4A6Mj3mnnhhNqx4Y5GjtBDzchVegk
         OKl5nf+evFIXDOoG3qB7kryxxh0cP62qvzMrAWSIkt+X/8qfzhRWSSfF/6hIfK6CWEPO
         4kHg==
X-Gm-Message-State: AOAM533f+VGC0KPAxyxYTLh3hbav+qs+q5Ak7cbgJwlxrA8v7TKiKp5n
        CWjbWo8qe7CtLMwtwDXDHGhBWnQ//Q0=
X-Google-Smtp-Source: ABdhPJwvBALCSy5mxgW3X0475EpWHYfbmRRWDDf+fBEi97xwj0OAeMYaSdt/Eu9KvXODqrKmR73vxw==
X-Received: by 2002:a05:6000:1acc:: with SMTP id i12mr8098836wry.482.1643394074599;
        Fri, 28 Jan 2022 10:21:14 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id o14sm6220698wry.104.2022.01.28.10.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 10:21:14 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] trace-cruncher: Add (un)register methods for dynamic events
Date:   Fri, 28 Jan 2022 20:21:01 +0200
Message-Id: <20220128182102.8672-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220128182102.8672-1-y.karadz@gmail.com>
References: <20220128182102.8672-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently the allocation of the Python object and the registration of
the new dynamic event are both done in the corresponding constructor for
kprobe, kretprobe or eprobe. Originally, this was done with the idea to
simplify the usage, however it turns that this can be an issue in the
case when these events are used in conjuction with synthetic events. In
such a case, the order in which the events are registered cannot be
arbitrary, because of the intrinsic dependencies between those events.
And the order used to create the events must be reverced when destroying
them. However, this requirement collides with way the Python automatic
garbage collection works, where the objects are destroyed in the same
order of there creation. The problem gets solved by decoupling the
allocation of the Python objects from the registration of the
corresponding events on the system. With this, we can create the objects
in one order and register in another.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c                          | 90 ++++++++++++++-----
 src/ftracepy-utils.h                          |  4 +
 src/ftracepy.c                                | 15 +++-
 tracecruncher/ft_utils.py                     |  2 +
 .../tests/1_unit/test_01_ftracepy_unit.py     |  7 +-
 5 files changed, 93 insertions(+), 25 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 19e237b..888e29b 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2234,11 +2234,54 @@ PyObject *PyDynevent_probe(PyDynevent *self)
 	return dynevent_info2py(buff, type);
 }
 
+PyObject *PyDynevent_register(PyDynevent *self)
+{
+	if (tracefs_dynevent_create(self->ptrObj) < 0) {
+		char *evt;
+		int type;
+
+		type = tracefs_dynevent_info(self->ptrObj, NULL, &evt, NULL, NULL, NULL);
+		TfsError_fmt(NULL, "Failed to register dynamic event '%s'.",
+		type != TRACEFS_DYNEVENT_UNKNOWN ? evt : "UNKNOWN");
+		free(evt);
+		return NULL;
+	}
+
+	/*
+	 * Here the dynamic event gets added to the system.
+	 * Hence we need to 'destroy' this event at exit.
+	 */
+	set_destroy_flag((PyObject *)self, true);
+	Py_RETURN_NONE;
+}
+
+PyObject *PyDynevent_unregister(PyDynevent *self)
+{
+	if (tracefs_dynevent_destroy(self->ptrObj, true) < 0) {
+		char *evt;
+		int type;
+
+		type = tracefs_dynevent_info(self->ptrObj, NULL, &evt, NULL, NULL, NULL);
+		TfsError_fmt(NULL, "Failed to unregister dynamic event '%s'.",
+		type != TRACEFS_DYNEVENT_UNKNOWN ? evt : "UNKNOWN");
+		free(evt);
+		return NULL;
+	}
+
+	/*
+	 * Here the synthetic event gets removed from the system.
+	 * Hence we no loger need to 'destroy' this event at exit.
+	 */
+	set_destroy_flag((PyObject *)self, false);
+	Py_RETURN_NONE;
+}
+
 PyObject *PyFtrace_kprobe(PyObject *self, PyObject *args, PyObject *kwargs)
 {
 	static char *kwlist[] = {"event", "function", "probe", NULL};
 	const char *event, *function, *probe;
 	struct tracefs_dynevent *kprobe;
+	PyObject *py_dyn;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
@@ -2256,13 +2299,14 @@ PyObject *PyFtrace_kprobe(PyObject *self, PyObject *args, PyObject *kwargs)
 		return NULL;
 	}
 
-	if (tracefs_dynevent_create(kprobe) < 0) {
-		TfsError_fmt(NULL, "Failed to create kprobe '%s'", event);
-		tracefs_dynevent_free(kprobe);
-		return NULL;
-	}
-
-	return PyDynevent_New(kprobe);
+	py_dyn = PyDynevent_New(kprobe);
+	/*
+	 * Here we only allocated and initializes a dynamic event object.
+	 * However, no dynamic event is added to the system yet. Hence,
+	 * there is no need to 'destroy' this event at exit.
+	 */
+	set_destroy_flag(py_dyn, false);
+	return py_dyn;
 }
 
 PyObject *PyFtrace_kretprobe(PyObject *self, PyObject *args, PyObject *kwargs)
@@ -2270,6 +2314,7 @@ PyObject *PyFtrace_kretprobe(PyObject *self, PyObject *args, PyObject *kwargs)
 	static char *kwlist[] = {"event", "function", "probe", NULL};
 	const char *event, *function, *probe = "$retval";
 	struct tracefs_dynevent *kprobe;
+	PyObject *py_dyn;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
@@ -2287,13 +2332,14 @@ PyObject *PyFtrace_kretprobe(PyObject *self, PyObject *args, PyObject *kwargs)
 		return NULL;
 	}
 
-	if (tracefs_dynevent_create(kprobe) < 0) {
-		TfsError_fmt(NULL, "Failed to create kretprobe '%s'", event);
-		tracefs_dynevent_free(kprobe);
-		return NULL;
-	}
-
-	return PyDynevent_New(kprobe);
+	py_dyn = PyDynevent_New(kprobe);
+	/*
+	 * Here we only allocated and initializes a dynamic event object.
+	 * However, no dynamic event is added to the system yet. Hence,
+	 * there is no need to 'destroy' this event at exit.
+	 */
+	set_destroy_flag(py_dyn, false);
+	return py_dyn;
 }
 
 struct tep_event *dynevent_get_event(PyDynevent *event,
@@ -2323,6 +2369,7 @@ PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs)
 	static char *kwlist[] = {"event", "target_system", "target_event", "fetchargs", NULL};
 	const char *event, *target_system, *target_event, *fetchargs;
 	struct tracefs_dynevent *eprobe;
+	PyObject *py_dyn;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
@@ -2341,13 +2388,14 @@ PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs)
 		return NULL;
 	}
 
-	if (tracefs_dynevent_create(eprobe) < 0) {
-		TfsError_fmt(NULL, "Failed to create eprobe '%s'", event);
-		tracefs_dynevent_free(eprobe);
-		return NULL;
-	}
-
-	return PyDynevent_New(eprobe);
+	py_dyn = PyDynevent_New(eprobe);
+	/*
+	 * Here we only allocated and initializes a dynamic event object.
+	 * However, no dynamic event is added to the system yet. Hence,
+	 * there is no need to 'destroy' this event at exit.
+	 */
+	set_destroy_flag(py_dyn, false);
+	return py_dyn;;
 }
 
 static PyObject *set_filter(PyObject *args, PyObject *kwargs,
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 13b4c91..9491b18 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -76,6 +76,10 @@ PyObject *PyDynevent_address(PyDynevent *self);
 
 PyObject *PyDynevent_probe(PyDynevent *self);
 
+PyObject *PyDynevent_register(PyDynevent *self);
+
+PyObject *PyDynevent_unregister(PyDynevent *self);
+
 PyObject *PyDynevent_set_filter(PyDynevent *self, PyObject *args,
 					      PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 354c6d1..574bf38 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -127,6 +127,16 @@ static PyMethodDef PyDynevent_methods[] = {
 	 METH_NOARGS,
 	 "Get the event definition."
 	},
+	{"register",
+	 (PyCFunction) PyDynevent_register,
+	 METH_NOARGS,
+	 "Register dynamic event."
+	},
+	{"unregister",
+	 (PyCFunction) PyDynevent_unregister,
+	 METH_NOARGS,
+	 "Unregister dynamic event."
+	},
 	{"set_filter",
 	 (PyCFunction) PyDynevent_set_filter,
 	 METH_VARARGS | METH_KEYWORDS,
@@ -164,6 +174,7 @@ static int dynevent_destroy(struct tracefs_dynevent *devt)
 {
 	return tracefs_dynevent_destroy(devt, true);
 }
+
 C_OBJECT_WRAPPER(tracefs_dynevent, PyDynevent,
 		 dynevent_destroy,
 		 tracefs_dynevent_free)
@@ -255,12 +266,12 @@ static PyMethodDef PySynthEvent_methods[] = {
 	{"register",
 	 (PyCFunction) PySynthEvent_register,
 	 METH_NOARGS,
-	 "Register synth. event to a trace instance."
+	 "Register synth. event."
 	},
 	{"unregister",
 	 (PyCFunction) PySynthEvent_unregister,
 	 METH_NOARGS,
-	 "Unregister synth. event from a trace instance."
+	 "Unregister synth. event."
 	},
 	{"enable",
 	 (PyCFunction) PySynthEvent_enable,
diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index b7e2e73..26c06ec 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -157,6 +157,7 @@ class kprobe(kprobe_base):
         probe = ' '.join('{!s}={!s}'.format(key,val) for (key, val) in self.fields.items())
 
         self.kp = ft.kprobe(event=self.name, function=self.func, probe=probe);
+        self.kp.register();
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
 
 
@@ -187,6 +188,7 @@ class kretval_probe(kprobe_base):
         """ Register this probe to Ftrace.
         """
         self.kp = ft.kprobe(event=self.name, function=self.func);
+        self.kp.register();
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
 
 
diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index 1ef8951..f51bcc1 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -414,11 +414,13 @@ class KprobeTestCase(unittest.TestCase):
         evt2_prove = 'file=+u0($arg2):ustring'
 
         kp1 = ft.kprobe(event=evt1, function=evt1_func, probe=evt1_prove)
+        kp1.register()
         self.assertEqual(evt1, kp1.event())
         self.assertEqual(evt1_func, kp1.address())
         self.assertEqual(evt1_prove, kp1.probe())
 
         kp2 = ft.kprobe(event=evt2, function=evt2_func, probe=evt2_prove)
+        kp2.register()
         self.assertEqual(evt2, kp2.event())
         self.assertEqual(evt2_func, kp2.address())
         self.assertEqual(evt2_prove, kp2.probe())
@@ -430,6 +432,7 @@ class KprobeTestCase(unittest.TestCase):
         flt = 'path~\'/sys/fs/cgroup/*\''
 
         kp1 = ft.kprobe(event=evt1, function=evt1_func, probe=evt1_prove)
+        kp1.register()
         inst = ft.create_instance(instance_name)
 
         kp1.set_filter(instance=inst, filter=flt)
@@ -445,6 +448,7 @@ class KprobeTestCase(unittest.TestCase):
         evt1_prove = 'path=+u0($arg2):ustring'
 
         kp1 = ft.kprobe(event=evt1, function=evt1_func, probe=evt1_prove)
+        kp1.register()
         inst = ft.create_instance(instance_name)
         kp1.enable(instance=inst)
         ret = kp1.is_enabled(instance=inst)
@@ -458,8 +462,6 @@ class EprobeTestCase(unittest.TestCase):
     def test_eprobe(self):
         """ Event probes are introduced in Linux kernel 5.15
         """
-        if kernel_version < (5, 15):
-            return
 
         evt1 = 'sopen_in'
         evt1_tsys = 'syscalls'
@@ -495,6 +497,7 @@ class EprobeTestCase(unittest.TestCase):
 
         ep1 = ft.eprobe(event=evt1, target_system=evt1_tsys, target_event=evt1_tevent,
                         fetchargs=evt1_args)
+        ep1.register()
         inst = ft.create_instance(instance_name)
         ep1.enable(instance=inst)
         ret = ep1.is_enabled(instance=inst)
-- 
2.33.1

