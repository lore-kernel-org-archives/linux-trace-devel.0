Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659BCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 06:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbiA0GaV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 01:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiA0GaU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 01:30:20 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507AAC061714
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 22:30:20 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id n10so2231650edv.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 22:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qt5VeCUclBzOARD/O+IJQ08OP736Lgb52kQedSTLwHM=;
        b=bHIyvJhfQgPi9hx2cklDrFB3R4dIfILaD7GS4Z0G5Y0QkdyQUlxf+7jj3AVgSEGvHZ
         Oknj4insy2xkpU+Cz9sJ17U22KaGjuWdJ4hBw0mTpxD6gtA/Hr80xV2+kTIwqo9d2BPz
         7MdF1XZpAGQiiPWejbjnlha0jCkgvYe6aiusM7JjztFEG1Lzg8vgAQZzhIyqxeC5y5bN
         YhVZRNiUTjZbJRHUMK5sP/IwZ2NMjasnCw3a9DzTfstz7+5kRi5h+2qNvINxxL/wG6G9
         Oj0FzGGLgHPnR/1Ulznt1R8yPWrS71/UUEf0jGcRJrg/LJ3x3o7gOqoi2EUuhlNn9h8q
         fTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qt5VeCUclBzOARD/O+IJQ08OP736Lgb52kQedSTLwHM=;
        b=lyvYFC15Hima7+9Zi9MKpXMc7+lOIMD9MB5zyziQeIHYlFyUhOZQgY0L8aP6Gf2Xcb
         nGcehqPx9mAzzcSfysX6XHb6PqxmtOOvaKFa8fij77Okrp7n5feO+9dWiyhAAnnSIvyP
         +2pisgtv9yTGHUuzOoWEzjwm79q1hqYhwlRCBWxgqklnxE/wGO0X3Gt8qhEgEcGoWtbA
         P59nhHhIpwElloN/LnDYg/BLdiKDCdK/3yc+J4JK9i53IdFrqrP71auRjDOcPEursb3k
         NUYDv3I/9R5bqJrWqkCcXkj88/7TM4RwCA+5rqKVcV5Mu4qVuaEGGoqyEKkIsRMg14Ue
         sZtA==
X-Gm-Message-State: AOAM531Rgaj2PhLM7Zvwn6Ik3x8pX3gsphdBUwfCadouWmdsSrqvwEtV
        WtZObmjLKkF88aLRq0LmwJj9lUqvifA=
X-Google-Smtp-Source: ABdhPJy0kZcrBtFuZWQ5v9vCweLHEPQEIPFonbCHNEHO9tROZ3FMIE4/5Wa5Mt6yiAmDPxCsgf3K6g==
X-Received: by 2002:a05:6402:1d49:: with SMTP id dz9mr2312907edb.238.1643265018880;
        Wed, 26 Jan 2022 22:30:18 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lc22sm8308776ejc.74.2022.01.26.22.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 22:30:18 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cruncher: Remove "register" from k(ret)probe APIs
Date:   Thu, 27 Jan 2022 08:30:17 +0200
Message-Id: <20220127063017.24436-1-tz.stoyanov@gmail.com>
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
 src/ftracepy-utils.c                                |  6 ++----
 src/ftracepy-utils.h                                |  6 ++----
 src/ftracepy.c                                      |  8 ++++----
 tracecruncher/ft_utils.py                           |  4 ++--
 tracecruncher/tests/1_unit/test_01_ftracepy_unit.py | 10 +++++-----
 5 files changed, 15 insertions(+), 19 deletions(-)

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
index 0c9f795..69f87a1 100644
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
index d23cb63..2f3d9f4 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -405,7 +405,7 @@ class OptionsTestCase(unittest.TestCase):
 
 
 class KprobeTestCase(unittest.TestCase):
-    def test_register_kprobe(self):
+    def test_kprobe(self):
         evt1 = 'mkdir'
         evt1_func = 'do_mkdirat'
         evt1_prove = 'path=+u0($arg2):ustring'
@@ -413,13 +413,13 @@ class KprobeTestCase(unittest.TestCase):
         evt2_func = 'do_sys_openat2'
         evt2_prove = 'file=+u0($arg2):ustring'
 
-        kp1 = ft.register_kprobe(event=evt1, function=evt1_func,
+        kp1 = ft.kprobe(event=evt1, function=evt1_func,
                                  probe=evt1_prove)
         self.assertEqual(evt1, kp1.event())
         self.assertEqual(evt1_func, kp1.address())
         self.assertEqual(evt1_prove, kp1.probe())
 
-        kp2 = ft.register_kprobe(event=evt2, function=evt2_func,
+        kp2 = ft.kprobe(event=evt2, function=evt2_func,
                                  probe=evt2_prove)
         self.assertEqual(evt2, kp2.event())
         self.assertEqual(evt2_func, kp2.address())
@@ -431,7 +431,7 @@ class KprobeTestCase(unittest.TestCase):
         evt1_prove = 'path=+u0($arg2):ustring'
         flt = 'path~\'/sys/fs/cgroup/*\''
 
-        kp1 = ft.register_kprobe(event=evt1, function=evt1_func,
+        kp1 = ft.kprobe(event=evt1, function=evt1_func,
                                  probe=evt1_prove)
         inst = ft.create_instance(instance_name)
 
@@ -447,7 +447,7 @@ class KprobeTestCase(unittest.TestCase):
         evt1_func = 'do_mkdirat'
         evt1_prove = 'path=+u0($arg2):ustring'
 
-        kp1 = ft.register_kprobe(event=evt1, function=evt1_func,
+        kp1 = ft.kprobe(event=evt1, function=evt1_func,
                                  probe=evt1_prove)
         inst = ft.create_instance(instance_name)
         kp1.enable(instance=inst)
-- 
2.34.1

