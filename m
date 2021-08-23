Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A2CC4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 12:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD74261368
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 12:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235775AbhHWMyn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 08:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235738AbhHWMyn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 08:54:43 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991AAC061575
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 05:54:00 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id u15so10466905wmj.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 05:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=STWeokfcx6qA/UgUiqfu23UhAh6YEHrTUltNx3cIG2U=;
        b=SxNuPdjKTkVyEb6Pv+zRCvPJzNNvXvly46VK9BIo3e0OhbmDJCYTHcx3Hh22/O6u1N
         bSTHM/i0Ik3AYpyeZmIHUfPmgnG+jjs1og6Vj0YJAXHbOJigGPTbLf9z1y471KXCTtf+
         GuOLy1QUuDSjTKROZ2qn6pB84P5BDd7Hb9mpbjiukBDYKNPC+h7lv0t9U2DVgWvbiS2N
         6PC2C0Df7RigI7Fvu+MDMMeKWZXiXem+aN252zBJAhrlLByiRUVLN4WtPALQ11fofSx/
         /SjGcBDWbmKQwpT2yYqZ+zMmOGXfiJM3ApfpIuYnDABMXJiG8c/HPFAtUr/AMVvIj5nP
         pq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=STWeokfcx6qA/UgUiqfu23UhAh6YEHrTUltNx3cIG2U=;
        b=gLhXlwWpssUlSTCfw81sLT7ggiyyhti/sC6uo0IBkKtDyQPXOTah8f3Z+CgIuMosNr
         WMiBD5Q3mf8gYeDIXQxF11YmSlGLgbMHq9zoLWbxnernhKd+WjTFCQa74FIR0u8hCoz1
         BWnzgBGvYkokBr2mSGC1PWFp15R0E/1SpcSXQHmMesS/LdPSFtNCmdSU8kKAnDVGZ4WL
         NYoTYeW2FUFutBQUuLQUjWZgU9qT5vjqeyexjEsY989AYdyzGZhX2s3SZE6c9j7zJh3+
         FZMRxmqB2g6VI6A/PRzWjooortFMRl87F+ORCVtFPRbRZVZ02zEnxfxUvkplZVzPxkdX
         TFSw==
X-Gm-Message-State: AOAM531xeSZ5lhtfjJ4SQtNU7isLf0qmu3fip3xGd/IgqMfwC5v3fTrH
        3gAUi6trxOd05yPwoyy7Rh+5eCoY6ec=
X-Google-Smtp-Source: ABdhPJxBlZFVKzP73oIl9txQLF9WWZ+yE81gKRsnlCZN6ZtIRgp0JyKsGVvHN7pSat4dfVH12p++SQ==
X-Received: by 2002:a1c:3b05:: with SMTP id i5mr2555523wma.136.1629723238933;
        Mon, 23 Aug 2021 05:53:58 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id b10sm11469454wrt.43.2021.08.23.05.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 05:53:58 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/3] trace-cruncher: Add methods for accessing tracefs errorlog
Date:   Mon, 23 Aug 2021 15:53:46 +0300
Message-Id: <20210823125348.145615-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Just wrapping the corresponding APIs of libtracefs.
The functionalities are also available as static methods and will be
used by the module itself when printing the error messages.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 67 ++++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  6 ++++
 src/ftracepy.c       | 10 +++++++
 3 files changed, 83 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 581432d..a3ae03a 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -23,6 +23,37 @@ PyObject *TFS_ERROR;
 PyObject *TEP_ERROR;
 PyObject *TRACECRUNCHER_ERROR;
 
+static const char *get_instance_name(struct tracefs_instance *instance);
+
+static char *tfs_error_log(struct tracefs_instance *instance, bool *ok)
+{;
+	char *err_log = tracefs_error_all(instance);
+
+	errno = 0;
+	if (errno && !err_log) {
+		PyErr_Format(TFS_ERROR,
+			     "Unable to get error log for instance \'%s\'.",
+		             get_instance_name(instance));
+	}
+
+	if (ok)
+		*ok = errno ? false : true;
+
+	return err_log;
+}
+
+static bool tfs_clear_error_log(struct tracefs_instance *instance)
+{
+	if (tracefs_error_clear(instance) < 0) {
+		PyErr_Format(TFS_ERROR,
+			     "Unable to clear error log for instance \'%s\'.",
+			     get_instance_name(instance));
+		return false;
+	}
+
+	return true;
+}
+
 PyObject *PyTepRecord_time(PyTepRecord* self)
 {
 	unsigned long ts = self->ptrObj ? self->ptrObj->ts : 0;
@@ -2051,6 +2082,42 @@ PyObject *PyFtrace_hook2pid(PyObject *self, PyObject *args, PyObject *kwargs)
 	Py_RETURN_NONE;
 }
 
+PyObject *PyFtrace_error_log(PyObject *self, PyObject *args,
+					     PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+	PyObject *ret = NULL;
+	char *err_log;
+	bool ok;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	err_log = tfs_error_log(instance, &ok);
+	if (err_log) {
+		ret = PyUnicode_FromString(err_log);
+		free(err_log);
+	} else if (ok) {
+		ret = PyUnicode_FromString("(nil)");
+	}
+
+	return ret;
+}
+
+PyObject *PyFtrace_clear_error_log(PyObject *self, PyObject *args,
+						   PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	if (!tfs_clear_error_log(instance))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
 void PyFtrace_at_exit(void)
 {
 }
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 4e04fb0..26a2f14 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -177,6 +177,12 @@ PyObject *PyFtrace_iterate_trace(PyObject *self, PyObject *args,
 
 PyObject *PyFtrace_hook2pid(PyObject *self, PyObject *args, PyObject *kwargs);
 
+PyObject *PyFtrace_error_log(PyObject *self, PyObject *args,
+					     PyObject *kwargs);
+
+PyObject *PyFtrace_clear_error_log(PyObject *self, PyObject *args,
+						   PyObject *kwargs);
+
 void PyFtrace_at_exit(void);
 
 #endif
diff --git a/src/ftracepy.c b/src/ftracepy.c
index a4fba01..e5a91fc 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -310,6 +310,16 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Trace only particular process."
 	},
+	{"error_log",
+	 (PyCFunction) PyFtrace_error_log,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get the content of the error log."
+	},
+	{"clear_error_log",
+	 (PyCFunction) PyFtrace_clear_error_log,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Clear the content of the error log."
+	},
 	{NULL, NULL, 0, NULL}
 };
 
-- 
2.30.2

