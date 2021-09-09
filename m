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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B25CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 15:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BB5B61101
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Sep 2021 15:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhIIQBE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Sep 2021 12:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhIIQBD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Sep 2021 12:01:03 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D492C061574
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Sep 2021 08:59:54 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id i6so3345641edu.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Sep 2021 08:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+B7TjtJ2TuV7Vlr4BSSrikg5QWGmsBqlxQ+bxn9Wqbc=;
        b=npwqXnQafSuD153vEVr7QdjvdpzdLlCfYeDw+C8HpvLRZNDE9V8QzwTLbtNV2OGI/j
         7uekHdapnKVAlXxTEbl76oB5PzwK9pFdXNHTgnJOtGoD+Pkk04u2t5cxyGvSdL8pGj5O
         O4tqily5NH5ejzVIbbwO04MqXqc37prV4v9xZWceAuocxUTo874aNM03eZathWkr4afi
         loxlrB0vFY+DYwZfGLplnohESk+Ml15xLM3JLEhAux2NkL8cwONz/QObbvIdx0sSMi4+
         xg2FuPFPJeH/ejqONiZL1xgLxzFy51iTCnylz1H1LJefzUFT3hFqeB5RcFpyF2AQqQHn
         D2qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+B7TjtJ2TuV7Vlr4BSSrikg5QWGmsBqlxQ+bxn9Wqbc=;
        b=qoaeWlMbAZ4cnIgMaeMXBp27ydZpdsBF8b9dbTsr1WM+32+YlesgtsFI/aA1J6E8tp
         YFDrP8+nvrP0kkyhgcfoF0hy25kdgLFdF+uJL51M/8kGJVAtYNvCSHmcNZ5+ub/mi3Z7
         XYC5tSAztet9N0qmEegExCfuPalvJMVP+MBwYtjRo8u7ljwYyy3nzKbccydUFY48Mb5D
         KtV1T9NTAGk2+ZUOd5k/byilC41oajmrzKoMUdwFJ6JD1gQ3vYyPGhjx+GQZvfE/f6aK
         zGAaeOsW7Gk/1fzESDcNdtPFZjETCg35YsYr5ZSeHedQOQopMMTO0iWy80sRZ58j/IZN
         csrQ==
X-Gm-Message-State: AOAM533kMJS6WWTvFZX3m9grsOp7tuaYcglVh7JHhtcf+kdldsV3X3NQ
        KD3Js6cxg0Yh6JBHCFsGtgnUHs8fIxA=
X-Google-Smtp-Source: ABdhPJwDF1UE0qcEkJNuZpt7si1f4cENbsnwRUt5lPqx0pMyHhoXFC42uHdbEfnclpm3hYAcN6YPKQ==
X-Received: by 2002:a05:6402:10cc:: with SMTP id p12mr3879473edu.328.1631203192504;
        Thu, 09 Sep 2021 08:59:52 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id d22sm1158036ejk.5.2021.09.09.08.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 08:59:52 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] trace-cruncher: Add attach()
Date:   Thu,  9 Sep 2021 18:59:41 +0300
Message-Id: <20210909155941.271165-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909155941.271165-1-y.karadz@gmail.com>
References: <20210909155941.271165-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Here we add mechanisms that will make possible to reattach object to
the ftracepy module. This means that the object will be properly
destroyed when the module exits.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c                           | 18 ++++++++++++++----
 src/ftracepy-utils.h                           |  2 ++
 src/ftracepy.c                                 |  5 +++++
 .../tests/1_unit/test_01_ftracepy_unit.py      | 13 +++++++++++++
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index bf811ae..d4fa59e 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -507,24 +507,34 @@ static void set_destroy_flag(PyObject *py_obj, bool val)
 	obj_head->destroy = val;
 }
 
-PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs)
+static PyObject *set_destroy(PyObject *args, PyObject *kwargs, bool destroy)
 {
 	static char *kwlist[] = {"object", NULL};
-	PyObject *py_obj = NULL;
+	PyObject *py_obj;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
 					 "O",
 					 kwlist,
 					 &py_obj)) {
-		return false;
+		return NULL;
 	}
 
-	set_destroy_flag(py_obj, false);
+	set_destroy_flag(py_obj, destroy);
 
 	Py_RETURN_NONE;
 }
 
+PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	return set_destroy(args, kwargs, false);
+}
+
+PyObject *PyFtrace_attach(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	return set_destroy(args, kwargs, true);
+}
+
 static char aname_pool[] =
 	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
 
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index c1eec21..be1b37c 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -83,6 +83,8 @@ PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
 
+PyObject *PyFtrace_attach(PyObject *self, PyObject *args, PyObject *kwargs);
+
 PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
 						   PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index e48adb6..763a7d2 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -150,6 +150,11 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Detach object from the \'ftracepy\' module."
 	},
+	{"attach",
+	 (PyCFunction) PyFtrace_attach,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Attach object to the \'ftracepy\' module."
+	},
 	{"create_instance",
 	 (PyCFunction) PyFtrace_create_instance,
 	 METH_VARARGS | METH_KEYWORDS,
diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index a7010e2..d3e3960 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -48,6 +48,19 @@ class InstanceTestCase(unittest.TestCase):
             inst_2 = ft.find_instance(another_instance_name)
         self.assertTrue(err in str(context.exception))
 
+    def test_1_detach(self):
+        inst = ft.create_instance(instance_name)
+        ft.detach(inst)
+
+    def test_2_attach(self):
+        inst = ft.find_instance(instance_name)
+        ft.attach(inst)
+
+    def test_3_attach(self):
+        tracefs_dir = ft.dir();
+        instance_dir = tracefs_dir + '/instances/' + instance_name
+        self.assertFalse(os.path.isdir(instance_dir))
+
 
 class PyTepTestCase(unittest.TestCase):
     def test_init_local(self):
-- 
2.30.2

