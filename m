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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BE9C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 235636108D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhHSNJV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 09:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhHSNJV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 09:09:21 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68996C061575
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:44 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id g138so3806881wmg.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zFRs/M9wMW+DUuDFVNtiPHd3qiwsxhy6U/N1IU6w4kk=;
        b=V062v8Zd4RrZeujxSSr/XjHcraOXeQ607MnefS92iXiu8QBwOM/XrWXlaYyyebJea2
         SNDtAQ4iWu0NEiANaEpPnGv2+ykBl2tDuBLjdu0Hs+/iczE4hV2nECGU6wxtO1BBWO7U
         Ge549AU6NUioke8rEeIFZADMsXj8IUZe31xV58cxXmddR5ptb8Ha+UOecYeqvR8ns/aQ
         1bQFFMQjhx+r49ctkbb0fVcxKaz1Vf3GJnu+MkZ/VxHGPT34L3ftldQkDGnwS7EdYa+u
         9uMjhJuWaYquVY9b5t1Y8zLsjvjaQsLBzJJAbUjdXckotnqsorsGAFCz/PfRGr+bC8G4
         bdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zFRs/M9wMW+DUuDFVNtiPHd3qiwsxhy6U/N1IU6w4kk=;
        b=XenO45UZiAHRPU9DrjxPxul+BgjQN0owZB/WPe8lydWvq+WYAhP9ICJq2kSe7w6GUa
         MSk5UX5pASvO+PgGlL1lplO+aHIjdhsD9VMk9WQy4aLgohuo0mnGaYD4kRcgQHAeVciY
         IVg06mReTaXQdRO6Xoxt6MV4NhZDkdEJSSOBcNNZPESfNnhrBBNRAzyhPdpDDTdoK2Oh
         uA16V3ZKJqBOQ9390KlYFHVZX0x6Vty9VkxpeFqO63HQoV905xPNgkq7MyRj153Ib4GX
         wj6Mp5oeYNJN8N85DtbCK1ZtYIfiZzOf6tU0o8FMGCEqnLwc6lK1hyH6gmllospnnshL
         r1GQ==
X-Gm-Message-State: AOAM532eAB0z3l99Vv0rHEVvQ6lSLM7tSpj7N5kbCCDQ4qrCZKbYfL9X
        QaEFP2akKppV0CMMUWwitDBnn0mI8I4=
X-Google-Smtp-Source: ABdhPJwAqCq+22ZcGH1j2pzELlg5DpFbeD4/5KJtonEWviSUyZDs2NMviWCH2ldfqb9I/u00+4HNUA==
X-Received: by 2002:a1c:730a:: with SMTP id d10mr13713675wmb.59.1629378522814;
        Thu, 19 Aug 2021 06:08:42 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id f17sm2889978wrt.49.2021.08.19.06.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:08:42 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 4/7] trace-cruncher: Define Python type for instances
Date:   Thu, 19 Aug 2021 16:08:24 +0300
Message-Id: <20210819130827.12327-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210819130827.12327-1-y.karadz@gmail.com>
References: <20210819130827.12327-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We add a custom Python type that wraps the 'tracefs_instance' object,
defined in libtracefs. This is a preparation for a general refactorung
of the way libtracefs instances are handled by trace-cruncher.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c |  5 +++++
 src/ftracepy-utils.h |  4 ++++
 src/ftracepy.c       | 17 +++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 197804b..a75f19b 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -531,6 +531,11 @@ bool get_instance_from_arg(PyObject *args, PyObject *kwargs,
 	return true;
 }
 
+PyObject *PyTfsInstance_dir(PyTfsInstance *self)
+{
+	return PyUnicode_FromString(tracefs_instance_get_dir(self->ptrObj));
+}
+
 PyObject *PyFtrace_dir(PyObject *self)
 {
 	return PyUnicode_FromString(tracefs_tracing_dir());
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 514c79b..c674804 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -22,6 +22,8 @@ C_OBJECT_WRAPPER_DECLARE(tep_event, PyTepEvent)
 
 C_OBJECT_WRAPPER_DECLARE(tep_handle, PyTep)
 
+C_OBJECT_WRAPPER_DECLARE(tracefs_instance, PyTfsInstance)
+
 PyObject *PyTepRecord_time(PyTepRecord* self);
 
 PyObject *PyTepRecord_cpu(PyTepRecord* self);
@@ -44,6 +46,8 @@ PyObject *PyTep_init_local(PyTep *self, PyObject *args,
 PyObject *PyTep_get_event(PyTep *self, PyObject *args,
 				       PyObject *kwargs);
 
+PyObject *PyTfsInstance_dir(PyTfsInstance *self);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 2296ec9..97b410f 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -73,6 +73,19 @@ static PyMethodDef PyTep_methods[] = {
 
 C_OBJECT_WRAPPER(tep_handle, PyTep, NO_DESTROY, tep_free)
 
+static PyMethodDef PyTfsInstance_methods[] = {
+	{"dir",
+	 (PyCFunction) PyTfsInstance_dir,
+	 METH_NOARGS,
+	 "Get the absolute path to the instance directory."
+	},
+	{NULL, NULL, 0, NULL}
+};
+
+C_OBJECT_WRAPPER(tracefs_instance, PyTfsInstance,
+		 tracefs_instance_destroy,
+		 tracefs_instance_free)
+
 static PyMethodDef ftracepy_methods[] = {
 	{"dir",
 	 (PyCFunction) PyFtrace_dir,
@@ -326,6 +339,9 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	if (!PyTepRecordTypeInit())
 		return NULL;
 
+	if (!PyTfsInstanceTypeInit())
+		return NULL;
+
 	TFS_ERROR = PyErr_NewException("tracecruncher.ftracepy.tfs_error",
 				       NULL, NULL);
 
@@ -340,6 +356,7 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	PyModule_AddObject(module, "tep_handle", (PyObject *) &PyTepType);
 	PyModule_AddObject(module, "tep_event", (PyObject *) &PyTepEventType);
 	PyModule_AddObject(module, "tep_record", (PyObject *) &PyTepRecordType);
+	PyModule_AddObject(module, "tracefs_instance", (PyObject *) &PyTfsInstanceType);
 
 	PyModule_AddObject(module, "tfs_error", TFS_ERROR);
 	PyModule_AddObject(module, "tep_error", TEP_ERROR);
-- 
2.30.2

