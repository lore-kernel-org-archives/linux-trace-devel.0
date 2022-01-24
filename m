Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFEDC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 15:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238469AbiAXPU0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 10:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240824AbiAXPUZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 10:20:25 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31032C06173D
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 07:20:25 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id d10so22325846eje.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 07:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1f37gAs7jMh1EiOxfIEmNh4CGAV7feLrQz04KLWzViw=;
        b=C9dYk8cy1FCc70Naznj8WE6f4DkkzAbc36R2xypJY/fXJs4XepfitzAcObCbwxDIuR
         ByhraHiH6qHZr+UtS1AmscGyio8hn3Gpz2BxJglMHwv1Pcf7QWyjtJN8rlT10lCugE73
         jdRB0xQEyf+x21AbOfQLdMGE0FXEdoxFOwuzXtUZgpPsmw6oXAHcWS115eHpoapmyyr1
         8xuFT8bgoo6rnWZ5GcjolV8WdgHzpIp1fBwxLxm9ZRueasfDqXdwQ9/L4DKW1Vnw9Ymk
         dkr3X0xKYHOTooeE9ic1KChimjXiuEwpqfiH4wBDcg0gsdhSHC9Eo181vwXIF3b5wJGw
         FIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1f37gAs7jMh1EiOxfIEmNh4CGAV7feLrQz04KLWzViw=;
        b=rj94b/5o4DTEZmtwDTdve0HfXOw2jby5FbcQQndf2GLOWndwgXGTWIng5GcOQ+U8VK
         qmqBgdUqiVRhFBn/lfyA5wxKKwr8oIxI/FDy0dNknp3AiCjfGS387+bNjtFX95BLxklb
         4PXUEAn5msf/CdKFRyW3ZyglHM5L3N+DYyQ/4i95vuleyULq76tdWPelfRB15rhWKIiA
         VmMW9I3+EF0xbUzM28wuIGFsGN7BOUfNm5JNEm1AwlQ4/2qD5KlmG1+dDRSJBb7igwUT
         EZXnGxXYmn9CSbgAdv6+JOOPDmQZXSPjrnPUD5TunmXvrVSV1zv7QzdKMWtL4N+5iuHa
         Vbkw==
X-Gm-Message-State: AOAM532KRKJfBSqNdeQwX9yZ1e9TpHTuz8rutxhh7Iy6DVxBtjyjPmLE
        Qd80ycctDEtwMibte27iRINPyXx04z4=
X-Google-Smtp-Source: ABdhPJyNuhhqdmdqlVZr9wlAB2PiOamf2au28f6vdmqjImri/gA0UEijNhPCULNHosJSu0+39mBX8w==
X-Received: by 2002:a17:907:6d11:: with SMTP id sa17mr13122482ejc.473.1643037623608;
        Mon, 24 Jan 2022 07:20:23 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l3sm6699993edr.61.2022.01.24.07.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 07:20:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cruncher: Add support for event probes
Date:   Mon, 24 Jan 2022 17:20:20 +0200
Message-Id: <20220124152020.459405-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Event probe (eprobe) is a new type of ftrace dynamic events, introduced
in the Linux kernel 5.15 version. It is useful to have support for it in
trace-cruncher, as it allows more flexibility when printing event's
data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/ftracepy-utils.c                          | 34 ++++++++++++++++
 src/ftracepy-utils.h                          |  3 ++
 src/ftracepy.c                                |  5 +++
 .../tests/1_unit/test_01_ftracepy_unit.py     | 39 +++++++++++++++++++
 4 files changed, 81 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index cecb180..28ed7b9 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2064,6 +2064,40 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 	return PyDynevent_New(kprobe);
 }
 
+PyObject *PyFtrace_register_eprobe(PyObject *self, PyObject *args,
+						   PyObject *kwargs)
+{
+	static char *kwlist[] = {"event", "target_system", "target_event", "fetchargs", NULL};
+	const char *event, *target_system, *target_event, *fetchargs;
+	struct tracefs_dynevent *eprobe;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "ssss",
+					 kwlist,
+					 &event,
+					 &target_system,
+					 &target_event,
+					 &fetchargs)) {
+		return NULL;
+	}
+
+	eprobe = tracefs_eprobe_alloc(TC_SYS, event, target_system, target_event, fetchargs);
+	if (!eprobe) {
+		MEM_ERROR;
+		return NULL;
+	}
+
+	if (tracefs_dynevent_create(eprobe) < 0) {
+		TfsError_fmt(NULL, "Failed to create eprobe '%s'", event);
+		tracefs_dynevent_free(eprobe);
+		return NULL;
+	}
+
+	return PyDynevent_New(eprobe);
+}
+
+
 PyObject *PyDynevent_set_filter(PyDynevent *self, PyObject *args,
 						  PyObject *kwargs)
 {
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index fc5016c..1030a50 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -207,6 +207,9 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 						      PyObject *kwargs);
 
+PyObject *PyFtrace_register_eprobe(PyObject *self, PyObject *args,
+						   PyObject *kwargs);
+
 PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
 					PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index f59bd4c..50ee4d3 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -377,6 +377,11 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Define a kretprobe."
 	},
+	{"register_eprobe",
+	 (PyCFunction) PyFtrace_register_eprobe,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define an eprobe."
+	},
 	{"hist",
 	 (PyCFunction) PyFtrace_hist,
 	 METH_VARARGS | METH_KEYWORDS,
diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index 51970d3..12b58a0 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -457,6 +457,45 @@ class KprobeTestCase(unittest.TestCase):
         ret = kp1.is_enabled(instance=inst)
         self.assertEqual(ret, '0')
 
+class EprobeTestCase(unittest.TestCase):
+    def test_register_eprobe(self):
+        evt1 = 'sopen_in'
+        evt1_tsys = 'syscalls'
+        evt1_tevent = 'sys_enter_openat'
+        evt1_args = 'file=+0($filename):ustring'
+        evt2 = 'sopen_out'
+        evt2_tsys = 'syscalls'
+        evt2_tevent = 'sys_exit_openat'
+        evt2_args = 'res=$ret:u64'
+
+        ep1 = ft.register_eprobe(event=evt1, target_system=evt1_tsys, target_event=evt1_tevent,
+                                 fetchargs=evt1_args)
+        self.assertEqual(evt1, ep1.event())
+        self.assertEqual("{}.{}".format(evt1_tsys, evt1_tevent), ep1.address())
+        self.assertEqual(evt1_args, ep1.probe())
+
+        ep2 = ft.register_eprobe(event=evt2, target_system=evt2_tsys, target_event=evt2_tevent,
+                                 fetchargs=evt2_args)
+        self.assertEqual(evt2, ep2.event())
+        self.assertEqual("{}.{}".format(evt2_tsys, evt2_tevent), ep2.address())
+        self.assertEqual(evt2_args, ep2.probe())
+
+    def test_enable_eprobe(self):
+        evt1 = 'sopen_out'
+        evt1_tsys = 'syscalls'
+        evt1_tevent = 'sys_exit_openat'
+        evt1_args = 'res=$ret:u64'
+
+        ep1 = ft.register_eprobe(event=evt1, target_system=evt1_tsys, target_event=evt1_tevent,
+                                 fetchargs=evt1_args)
+        inst = ft.create_instance(instance_name)
+        ep1.enable(instance=inst)
+        ret = ep1.is_enabled(instance=inst)
+        self.assertEqual(ret, '1')
+
+        ep1.disable(instance=inst)
+        ret = ep1.is_enabled(instance=inst)
+        self.assertEqual(ret, '0')
 
 class TracingOnTestCase(unittest.TestCase):
     def test_ON_OF(self):
-- 
2.34.1

