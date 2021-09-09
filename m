Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CABC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 15:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FFEA61101
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 15:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhIIQBD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Sep 2021 12:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhIIQBC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Sep 2021 12:01:02 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C89C061574
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Sep 2021 08:59:53 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id i21so4627388ejd.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Sep 2021 08:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KwePf44Dn7kYUP56mSK85ni/eUEXjHYfr9PotsQ0EGQ=;
        b=IiDtp7czYHtLrDOcdFeIqxT+0GcNBPsmQxG95/H0FnCY5nKHi/7VTmPrrQHD2fpEZO
         C8WJCdt6VjzEJaWY0JITfq51s6FOWMAC1E1pngbNBQuE/GxQOGcJR+e5pnxTgw2F5SbV
         p2Ab/lYzMg4BYRBIEdt+LIfmIZZ/Uv5iRPMEUcMCNuzNB4ZT7jFmboXmZkoRITOFz7IU
         cb9r/Fvmu1eUHmch4Yj0f1ckr5+2Y7JJGHtIT+XDB+vaOiQAjkLv1KNWjc7IyIbJRbqD
         QTXHGmWluuPgKI4J9eVYB+dQmR6ua1slX2qMPQOXEZp3A47FOlWFzhgcybrAMjAxDYdg
         lKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KwePf44Dn7kYUP56mSK85ni/eUEXjHYfr9PotsQ0EGQ=;
        b=HC2k1uPuONxc2lxQrVcRjQZDftzTRmRuGWNZvYoDFn8ViCzDER5viAeQjo46GSq5Xg
         8aPHb/xRrr96elnyMu1Ep7xNS0arkRX/dqpKBfsLvRb9uMl+itS95u9cf7kUHVb7XOX4
         YM68MoPbwQtS3mOpyA452Uq0Bsnr/QvWexCFouyl8mYz6rpV5VhVtmta1TNmFxba5bYh
         XnvTMmMYj1zJGVLmovVLP/YArHw+BkoDdGC47csPHnYkq9nveajLyN9pYxpzuJu9c69d
         lkGNpsM0748ifLFyyH7cjrdMeLxz0jXBJ4wjpwOJ+ZhXC41I4XrbaYqkxGpPqPvCueBQ
         n7HA==
X-Gm-Message-State: AOAM531mR3/0isPoVoEqmS0w/c03zhgL1LI3KIuK3IFuxbFhA6JeYRdT
        bmvpON3IGW9ZP8+3O12/oldIG/FaqXE=
X-Google-Smtp-Source: ABdhPJwG2fjF2AGUtD3EV85L2ZZqxV7l19SsmqOkzapH4nMt+06KDR1KM96PLje9QORcdbhIoAzyyg==
X-Received: by 2002:a17:906:fcc4:: with SMTP id qx4mr4042576ejb.364.1631203191648;
        Thu, 09 Sep 2021 08:59:51 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id d22sm1158036ejk.5.2021.09.09.08.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 08:59:51 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] trace-cruncher: Add find_instance()
Date:   Thu,  9 Sep 2021 18:59:40 +0300
Message-Id: <20210909155941.271165-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The method allows create a Python instance object from an already
existing tracefs instance. The instance returned by the method is
detached from the Python module.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c                          | 40 +++++++++++++++++--
 src/ftracepy-utils.h                          |  3 ++
 src/ftracepy.c                                |  5 +++
 .../tests/1_unit/test_01_ftracepy_unit.py     | 12 ++++++
 4 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index b94745d..bf811ae 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -501,10 +501,15 @@ PyObject *PyFtrace_dir(PyObject *self)
 	return PyUnicode_FromString(tracefs_tracing_dir());
 }
 
+static void set_destroy_flag(PyObject *py_obj, bool val)
+{
+	PyFtrace_Object_HEAD *obj_head = (PyFtrace_Object_HEAD *)py_obj;
+	obj_head->destroy = val;
+}
+
 PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs)
 {
 	static char *kwlist[] = {"object", NULL};
-	PyFtrace_Object_HEAD *obj_head;
 	PyObject *py_obj = NULL;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
@@ -515,8 +520,7 @@ PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs)
 		return false;
 	}
 
-	obj_head = (PyFtrace_Object_HEAD *)py_obj;
-	obj_head->destroy = false;
+	set_destroy_flag(py_obj, false);
 
 	Py_RETURN_NONE;
 }
@@ -583,6 +587,36 @@ PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
 	return PyTfsInstance_New(instance);
 }
 
+PyObject *PyFtrace_find_instance(PyObject *self, PyObject *args,
+						 PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+	PyObject *py_inst;
+	const char *name;
+
+	static char *kwlist[] = {"name", NULL};
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "s",
+					 kwlist,
+					 &name)) {
+		return NULL;
+	}
+
+	instance = tracefs_instance_alloc(NULL, name);
+	if (!instance) {
+		TfsError_fmt(instance,
+			     "Failed to find trace instance \'%s\'.",
+			     name);
+		return NULL;
+	}
+
+	py_inst = PyTfsInstance_New(instance);
+	set_destroy_flag(py_inst, false);
+
+	return py_inst;
+}
+
 static bool get_optional_instance(PyObject *py_obj,
 				  struct tracefs_instance **instance)
 {
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 218dcb3..c1eec21 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -86,6 +86,9 @@ PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
 PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
 						   PyObject *kwargs);
 
+PyObject *PyFtrace_find_instance(PyObject *self, PyObject *args,
+						 PyObject *kwargs);
+
 PyObject *PyFtrace_available_tracers(PyObject *self, PyObject *args,
 						     PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index f03c488..e48adb6 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -155,6 +155,11 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Create new tracefs instance."
 	},
+	{"find_instance",
+	 (PyCFunction) PyFtrace_find_instance,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Find an existing ftrace instance."
+	},
 	{"available_tracers",
 	 (PyCFunction) PyFtrace_available_tracers,
 	 METH_VARARGS | METH_KEYWORDS,
diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index 710d3e1..a7010e2 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -36,6 +36,18 @@ class InstanceTestCase(unittest.TestCase):
         instance_dir = tracefs_dir + '/instances/' + instance_name
         self.assertEqual(instance_dir, inst.dir())
 
+    def test_find(self):
+        inst = ft.create_instance(instance_name)
+        tracefs_dir = ft.dir();
+        instance_dir = tracefs_dir + '/instances/' + instance_name
+        inst_1 = ft.find_instance(instance_name)
+        self.assertEqual(instance_dir, inst_1.dir())
+
+        err='Failed to find trace instance'
+        with self.assertRaises(Exception) as context:
+            inst_2 = ft.find_instance(another_instance_name)
+        self.assertTrue(err in str(context.exception))
+
 
 class PyTepTestCase(unittest.TestCase):
     def test_init_local(self):
-- 
2.30.2

