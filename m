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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D01BC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 459C261152
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238460AbhHSNJU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 09:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhHSNJT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 09:09:19 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A436AC061575
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:43 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l24-20020a05600c089800b002e71a10130eso768784wmp.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w6Bx292jRooy4aRoWEgGqgTm8rpQYiL/U8yEpITgcY8=;
        b=rZmwOX4js8gzDTbvtA8tPaV0w3MCbB3xyZn/F1j07GxPvblsGA2gJs/GNORvBwBUCk
         9jkjsujhrInpjV0FnqArtWZ85/54BFjM15BZbRy6+sFR1ES/TTAtCvFZ+75ij7vvN3x2
         IokCU70+C7g9zhRTFsB/V/14A66kefFw/ad2uHtxAEGZkqQ/mXxhATq71ut8V+kIoyYT
         3RAaoxB4rF709pcTrSuDRM5d5vr/YVpHMJbl3h5rC0Ib6sENzByRRQ6YYDwrizr9k/lx
         2imq6AkZrvJ4puBE64IpsvYvF0k4wNZqAQY6tDG6wswNRWteZ8gs/DG0JcEalPNPY4zK
         GmQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w6Bx292jRooy4aRoWEgGqgTm8rpQYiL/U8yEpITgcY8=;
        b=AJUbNlyoxt68ftPgoDH/gtaosliEbImKTYtizANcPVOKcVjpvWQMSbEwoeZVsU4o2O
         2eigeQh3NBpA7TCrHR8ynrtHsdBNeG14+hBCthnyUBVaqOEeBIhz1Zshf/SWBXpA4/g1
         Ua7gNFltClfn7JLWtFd+R4C2FSQBRWnZLt1RfD2Reu5lIQ4qq2hivKAsADQqw28nysUS
         3qo9oOgfsgIAPk1CUDcV1HsPl+TXH4B/eljU2exl/vuVH+AKPdHS9v5Go6Ad0HMylULZ
         bieQXo3IvXOl7wtuiOp2djRUAJm6CohjM/OnIJekfpk0STsSqRfiyf5xxdAalVSTRrMi
         ub4A==
X-Gm-Message-State: AOAM5312ioRRLCsiWg3jtUQ1e0caMbqFzoiqog1dFkyTyCnMOScInXnG
        xm+AWbvm3NRL/kVgXAYQgB4gJkt3pHw=
X-Google-Smtp-Source: ABdhPJz1uorkd+7iyptq+SVmZqKS8GvsOFQSHwAz7orRxUEKhjeeDyRrVFmP3IOQwsAXcOJr3zdPnw==
X-Received: by 2002:a05:600c:4a29:: with SMTP id c41mr13493410wmp.86.1629378522080;
        Thu, 19 Aug 2021 06:08:42 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id f17sm2889978wrt.49.2021.08.19.06.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:08:41 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/7] trace-cruncher: Allow for detachable custom objects
Date:   Thu, 19 Aug 2021 16:08:23 +0300
Message-Id: <20210819130827.12327-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210819130827.12327-1-y.karadz@gmail.com>
References: <20210819130827.12327-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

libtracefs distinguishes between freeing the resources managed
by an object and the freeing of object itself. One can take
tracefs_instance_destroy() and tracefs_instance_free() as
example. The user can call tracefs_instance_free() without calling
tracefs_instance_destroy(). In this case no memory will leak, but
the instance will continue to exist after the program exits (will
be 'detached'). Here we add mechanisms that will make possible to
detach object from the ftracepy module.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/common.h         | 19 +++++++++++++++++--
 src/ftracepy-utils.c | 20 ++++++++++++++++++++
 src/ftracepy-utils.h |  2 ++
 src/ftracepy.c       | 11 ++++++++---
 4 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/src/common.h b/src/common.h
index fa64696..b7f6a87 100644
--- a/src/common.h
+++ b/src/common.h
@@ -46,28 +46,40 @@ static inline bool is_set(const char *arg)
 	return !(is_all(arg) || is_no_arg(arg));
 }
 
-static inline void no_free()
+static inline void no_free(void *ptr)
 {
 }
 
 #define NO_FREE		no_free
 
+static inline void no_destroy(void *ptr)
+{
+}
+
+#define NO_DESTROY	no_destroy
+
 #define STR(x) #x
 
 #define MAKE_TYPE_STR(x) STR(trace.x)
 
 #define MAKE_DIC_STR(x) STR(libtrace x object)
 
+typedef struct {
+	PyObject_HEAD
+	bool destroy;
+} PyFtrace_Object_HEAD;
+
 #define C_OBJECT_WRAPPER_DECLARE(c_type, py_type)				\
 	typedef struct {							\
 	PyObject_HEAD								\
+	bool destroy;								\
 	struct c_type *ptrObj;							\
 } py_type;									\
 PyObject *py_type##_New(struct c_type *c_ptr);					\
 bool py_type##TypeInit();							\
 bool py_type##_Check(PyObject *obj);						\
 
-#define  C_OBJECT_WRAPPER(c_type, py_type, ptr_free)				\
+#define  C_OBJECT_WRAPPER(c_type, py_type, obj_destroy, ptr_free)		\
 static PyTypeObject py_type##Type = {						\
 	PyVarObject_HEAD_INIT(NULL, 0) MAKE_TYPE_STR(c_type)			\
 };										\
@@ -76,6 +88,7 @@ PyObject *py_type##_New(struct c_type *c_ptr)					\
 	py_type *newObject;							\
 	newObject = PyObject_New(py_type, &py_type##Type);			\
 	newObject->ptrObj = c_ptr;						\
+	newObject->destroy = true;						\
 	return (PyObject *) newObject;						\
 }										\
 static int py_type##_init(py_type *self, PyObject *args, PyObject *kwargs)	\
@@ -85,6 +98,8 @@ static int py_type##_init(py_type *self, PyObject *args, PyObject *kwargs)	\
 }										\
 static void py_type##_dealloc(py_type *self)					\
 {										\
+	if (self->destroy)							\
+		obj_destroy(self->ptrObj);					\
 	ptr_free(self->ptrObj);							\
 	Py_TYPE(self)->tp_free(self);						\
 }										\
diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 6739db7..197804b 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -536,6 +536,26 @@ PyObject *PyFtrace_dir(PyObject *self)
 	return PyUnicode_FromString(tracefs_tracing_dir());
 }
 
+PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	static char *kwlist[] = {"object", NULL};
+	PyFtrace_Object_HEAD *obj_head;
+	PyObject *py_obj = NULL;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "O",
+					 kwlist,
+					 &py_obj)) {
+		return false;
+	}
+
+	obj_head = (PyFtrace_Object_HEAD *)py_obj;
+	obj_head->destroy = false;
+
+	Py_RETURN_NONE;
+}
+
 static char aname_pool[] =
 	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
 
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 5d7c19c..514c79b 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -46,6 +46,8 @@ PyObject *PyTep_get_event(PyTep *self, PyObject *args,
 
 PyObject *PyFtrace_dir(PyObject *self);
 
+PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
+
 PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
 						   PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index e3fec7b..2296ec9 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -25,7 +25,7 @@ static PyMethodDef PyTepRecord_methods[] = {
 	{NULL}
 };
 
-C_OBJECT_WRAPPER(tep_record, PyTepRecord, NO_FREE)
+C_OBJECT_WRAPPER(tep_record, PyTepRecord, NO_DESTROY, NO_FREE)
 
 static PyMethodDef PyTepEvent_methods[] = {
 	{"name",
@@ -55,7 +55,7 @@ static PyMethodDef PyTepEvent_methods[] = {
 	{NULL}
 };
 
-C_OBJECT_WRAPPER(tep_event, PyTepEvent, NO_FREE)
+C_OBJECT_WRAPPER(tep_event, PyTepEvent, NO_DESTROY, NO_FREE)
 
 static PyMethodDef PyTep_methods[] = {
 	{"init_local",
@@ -71,7 +71,7 @@ static PyMethodDef PyTep_methods[] = {
 	{NULL}
 };
 
-C_OBJECT_WRAPPER(tep_handle, PyTep, tep_free)
+C_OBJECT_WRAPPER(tep_handle, PyTep, NO_DESTROY, tep_free)
 
 static PyMethodDef ftracepy_methods[] = {
 	{"dir",
@@ -79,6 +79,11 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_NOARGS,
 	 "Get the absolute path to the tracefs directory."
 	},
+	{"detach",
+	 (PyCFunction) PyFtrace_detach,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Detach object from the \'ftracepy\' module."
+	},
 	{"create_instance",
 	 (PyCFunction) PyFtrace_create_instance,
 	 METH_VARARGS | METH_KEYWORDS,
-- 
2.30.2

