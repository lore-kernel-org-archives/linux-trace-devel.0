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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381B8C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Aug 2021 09:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEC17610FD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Aug 2021 09:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239585AbhHYJYb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 05:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239627AbhHYJYZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 05:24:25 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CBDC0613D9
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Aug 2021 02:23:39 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n5so22988416wro.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Aug 2021 02:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hXYGtWFsOPyj6lWnlnCeDPx39hKFrLVz2l3kXIc7BaU=;
        b=q8mjjWjR1yOOlQpMJ2ccs5VLrByvDAo8G7Llgm5BRK3oe9N5poiDZeubn+11FwQ5nr
         GRQwM8m3zh6UFc7Rv2sMDjd0R6FhswH0NrREz0CI8Vr2yWrh0OWnhqKL2sS4+9Fz+BVI
         nngvEJw5nOIrjXZdNThyNBcVGiiS2IrDvvZ7w8h1DfzHM6LcHVTUTpG8pgrr1r2Jxalg
         diEJLqztPpI3elc8u1i+2HN9b1MOVV9CTP+OZRXZaS4Rl6FrNs8VDk6H5OtXLIEjsKI8
         35lEqbylATUIKIVYBfd5y5JuuGVLEP3sbCc333gJnKSWSABYAdT43PKkTPbLLn0/pexq
         mqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hXYGtWFsOPyj6lWnlnCeDPx39hKFrLVz2l3kXIc7BaU=;
        b=Da6i8B3oEiOJtLUz32Gb+LPmtyaEpeJHxFxZo0hI6nAG/N2/Eu4ZiPEJ7iNodyp9uZ
         xjqy1X8JGW3nMgtrpqLL4FujQho/XvCk7cCF2pBsQOh+jrNMYjw5rgU6moeeKdN9YdWx
         KLCYPb9afB8pn+v6RUt7L7hHhxAhqnFy1LDxZFgj7DpcrGF9h3DnLsGBsVuxzwY4Lx1J
         MxpWlv5Tu0MgIcVY5zMCybYVhgqfH6K5SKXREeC3PgPkXL37gWyH4HyVWSRLXbruHdBG
         artg0wTWc+N9OHay6+Bjn6Jq4GasHhNmT/cEyZHGImwIGLD768L8c2g2LUhcyqxFk7w5
         AnOQ==
X-Gm-Message-State: AOAM531ggzzyEnv01hZ424zv083EUFKf1rHuqHekxhuXxLwixH+MZMQb
        x2CpAGwTu8jrbYkJ9qnFsiIk3MVtP08=
X-Google-Smtp-Source: ABdhPJxKUmt23I5jIwlSd6wyz2fw0EOaUssiCC/57nDcepEUwQSxK/a+0QsSalBqUvBsAkj353Ej0w==
X-Received: by 2002:adf:e606:: with SMTP id p6mr17902984wrm.231.1629883418097;
        Wed, 25 Aug 2021 02:23:38 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id w9sm4599323wmc.19.2021.08.25.02.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 02:23:37 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/3] trace-cruncher: Add methods for accessing tracefs errorlog
Date:   Wed, 25 Aug 2021 12:23:24 +0300
Message-Id: <20210825092326.45804-1-y.karadz@gmail.com>
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
 src/ftracepy-utils.c | 68 ++++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  6 ++++
 src/ftracepy.c       | 10 +++++++
 3 files changed, 84 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 581432d..da58855 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -23,6 +23,38 @@ PyObject *TFS_ERROR;
 PyObject *TEP_ERROR;
 PyObject *TRACECRUNCHER_ERROR;
 
+static const char *get_instance_name(struct tracefs_instance *instance);
+
+static char *tfs_error_log(struct tracefs_instance *instance, bool *ok)
+{;
+	char *err_log;
+
+	errno = 0;
+	err_log = tracefs_error_all(instance);
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
@@ -2051,6 +2083,42 @@ PyObject *PyFtrace_hook2pid(PyObject *self, PyObject *args, PyObject *kwargs)
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

