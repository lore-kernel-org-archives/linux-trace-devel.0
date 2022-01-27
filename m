Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAEE7C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 07:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236988AbiA0HCt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 02:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbiA0HCs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 02:02:48 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE78C061714
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:02:48 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id k25so3688992ejp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TqWuRfSg/SfvhLfa1aufc2+JhMMQa/pHcsQhEhs+vNY=;
        b=K2PRkN4wQ8RxmXjoP2boRQZxrRY6CvDHHY2HyGY1B28HgE99BZeiqCUt/4aOUo6jxa
         OwRYpGdeiSoA5F9Q30fMtaRi3opNi9+BremjLweRIVE6QuJV6ukBnuyvzM2XS4lOYsQa
         LWGedGQAM+SqCsfdYw+GoyGmtRahRd80gwWrJ+swLYV/1Q0B0TerfEXy9SMctPLN1zTe
         L+ITOO3xjEQHJJa3LO/i0IaVpE+5RutGKq1CKEshM+2oTV9kkXZ9MyjvkgTYMl29TrLr
         cmloD7gjyGqIZIy9wwqt6bdO8TLbiqtkCMzmK30EXo+msmaoOHKBAgKB2QIeDQVZntMg
         2FSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TqWuRfSg/SfvhLfa1aufc2+JhMMQa/pHcsQhEhs+vNY=;
        b=NdpbKjTvdkg+toqn37Wm5r+3v07Iu6wV/uGe13b5yESiSC/kX4VtzI/ujVQIPH451r
         8jYboBAzWPMe5MmyXijzkJ8LjMEpodZwnYCN/nUuVUvaHGu/RblsOG4+L50NB7wvxwDn
         p8FvSkPn1SEPT/XJROLRNppG6TLrNaivtf2JorW9Imb/3NcT5Cn/4XuoGYIvqRv0y7ZM
         H1Vi6Uk8hJDFsdfm21D2PqBbL1FJYMTenTdGby8OnP54yduNIHQfklP6fPPwddJUtxAt
         0Uf8gGOkthShMSIgRAnQ+9PPwW/sevj557SXbbENNeaGuvw1iSfuFZTDuRsc4RBHoyv/
         F8bw==
X-Gm-Message-State: AOAM532ksvmi21QUbEfTPGu7t4Y2bppay3JKu8ZybMRu1yKV5km/UgHj
        bB9chDaxF4dmNZF8e8EHQMrsdGMlBmQ=
X-Google-Smtp-Source: ABdhPJzWrmiual6ln21KWjtKjBEfQchn1ywNHzCgSds8muEQOd/C9dQTlWIQNFeVPsRPyKe0r3J+rA==
X-Received: by 2002:a17:906:99c5:: with SMTP id s5mr1474755ejn.373.1643266966759;
        Wed, 26 Jan 2022 23:02:46 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t6sm8192050ejd.85.2022.01.26.23.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 23:02:46 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cruncher: Remove "register" from k(ret)probe APIs
Date:   Thu, 27 Jan 2022 09:02:44 +0200
Message-Id: <20220127070244.27701-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to be consistent with the other trace-cruncher APIs for dynamic
events, renamed these APIs:
	register_kprobe to kprobe
	register_kretprobe to kretprobe

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
v2 changes:
 - Coding style fixes.

 src/ftracepy-utils.c                               |  6 ++----
 src/ftracepy-utils.h                               |  6 ++----
 src/ftracepy.c                                     |  8 ++++----
 tracecruncher/ft_utils.py                          |  4 ++--
 .../tests/1_unit/test_01_ftracepy_unit.py          | 14 +++++---------
 5 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 053b659..0a4092f 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2229,8 +2229,7 @@ PyObject *PyDynevent_probe(PyDynevent *self)
 	return dynevent_info2py(buff, type);
 }
 
-PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
-						   PyObject *kwargs)
+PyObject *PyFtrace_kprobe(PyObject *self, PyObject *args, PyObject *kwargs)
 {
 	static char *kwlist[] = {"event", "function", "probe", NULL};
 	const char *event, *function, *probe;
@@ -2261,8 +2260,7 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 	return PyDynevent_New(kprobe);
 }
 
-PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
-						      PyObject *kwargs)
+PyObject *PyFtrace_kretprobe(PyObject *self, PyObject *args, PyObject *kwargs)
 {
 	static char *kwlist[] = {"event", "function", "probe", NULL};
 	const char *event, *function, *probe = "$retval";
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index c96fd85..b7ce179 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -245,11 +245,9 @@ PyObject *PyFtrace_enabled_options(PyObject *self, PyObject *args,
 
 PyObject *PyFtrace_tc_event_system(PyObject *self);
 
-PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
-						   PyObject *kwargs);
+PyObject *PyFtrace_kprobe(PyObject *self, PyObject *args, PyObject *kwargs);
 
-PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
-						      PyObject *kwargs);
+PyObject *PyFtrace_kretprobe(PyObject *self, PyObject *args, PyObject *kwargs);
 
 PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 464e8d3..9207c70 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -450,13 +450,13 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_NOARGS,
 	 "Get the name of the event system used by trace-cruncher."
 	},
-	{"register_kprobe",
-	 (PyCFunction) PyFtrace_register_kprobe,
+	{"kprobe",
+	 (PyCFunction) PyFtrace_kprobe,
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Define a kprobe."
 	},
-	{"register_kretprobe",
-	 (PyCFunction) PyFtrace_register_kretprobe,
+	{"kretprobe",
+	 (PyCFunction) PyFtrace_kretprobe,
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Define a kretprobe."
 	},
diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index ed4bdcd..54cffe0 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -178,7 +178,7 @@ class kprobe(kprobe_base):
         """
         probe = ' '.join('{!s}={!s}'.format(key,val) for (key, val) in self.fields.items())
 
-        self.kp = ft.register_kprobe(event=self.name, function=self.func, probe=probe);
+        self.kp = ft.kprobe(event=self.name, function=self.func, probe=probe);
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
 
 
@@ -208,7 +208,7 @@ class kretval_probe(kprobe_base):
     def register(self):
         """ Register this probe to Ftrace.
         """
-        self.kp = ft.register_kprobe(event=self.name, function=self.func);
+        self.kp = ft.kprobe(event=self.name, function=self.func);
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
 
 
diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index d773acc..1ef8951 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -405,7 +405,7 @@ class OptionsTestCase(unittest.TestCase):
 
 
 class KprobeTestCase(unittest.TestCase):
-    def test_register_kprobe(self):
+    def test_kprobe(self):
         evt1 = 'mkdir'
         evt1_func = 'do_mkdirat'
         evt1_prove = 'path=+u0($arg2):ustring'
@@ -413,14 +413,12 @@ class KprobeTestCase(unittest.TestCase):
         evt2_func = 'do_sys_openat2'
         evt2_prove = 'file=+u0($arg2):ustring'
 
-        kp1 = ft.register_kprobe(event=evt1, function=evt1_func,
-                                 probe=evt1_prove)
+        kp1 = ft.kprobe(event=evt1, function=evt1_func, probe=evt1_prove)
         self.assertEqual(evt1, kp1.event())
         self.assertEqual(evt1_func, kp1.address())
         self.assertEqual(evt1_prove, kp1.probe())
 
-        kp2 = ft.register_kprobe(event=evt2, function=evt2_func,
-                                 probe=evt2_prove)
+        kp2 = ft.kprobe(event=evt2, function=evt2_func, probe=evt2_prove)
         self.assertEqual(evt2, kp2.event())
         self.assertEqual(evt2_func, kp2.address())
         self.assertEqual(evt2_prove, kp2.probe())
@@ -431,8 +429,7 @@ class KprobeTestCase(unittest.TestCase):
         evt1_prove = 'path=+u0($arg2):ustring'
         flt = 'path~\'/sys/fs/cgroup/*\''
 
-        kp1 = ft.register_kprobe(event=evt1, function=evt1_func,
-                                 probe=evt1_prove)
+        kp1 = ft.kprobe(event=evt1, function=evt1_func, probe=evt1_prove)
         inst = ft.create_instance(instance_name)
 
         kp1.set_filter(instance=inst, filter=flt)
@@ -447,8 +444,7 @@ class KprobeTestCase(unittest.TestCase):
         evt1_func = 'do_mkdirat'
         evt1_prove = 'path=+u0($arg2):ustring'
 
-        kp1 = ft.register_kprobe(event=evt1, function=evt1_func,
-                                 probe=evt1_prove)
+        kp1 = ft.kprobe(event=evt1, function=evt1_func, probe=evt1_prove)
         inst = ft.create_instance(instance_name)
         kp1.enable(instance=inst)
         ret = kp1.is_enabled(instance=inst)
-- 
2.34.1

