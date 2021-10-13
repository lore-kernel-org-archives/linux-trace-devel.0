Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4364C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 16:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CAAE61056
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 16:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbhJMQ7M (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238029AbhJMQ6v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 12:58:51 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA63C06176D
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Oct 2021 09:56:43 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id m22so10720858wrb.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Oct 2021 09:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=40Mq3uCZm93XC8lWlE47L7jYgJCpjnvKFznJ8ZS0L8s=;
        b=nIEB/EJtz710/NLNtQPsUIu76POAVbmZRogealDksr3uxT3TQDNF4DD+cgtCneX8Q2
         Fw2BV6j2NHpGJsmV0BwO6+JrDPcaZRwD67SbWREJWqTsDgDwVl9dsh1xY/c7MpBEibPC
         xZq8yawHiaxo2UMR3PJzu4vzjeyMELBtwWVEK+PNyLf22CiXfNcpgaU5juvveqJUaZtV
         X5siPUF052rsjGaXLS1iOkOD36KeYVX9vKtvQ04HuAOvfDWmLDviAT8ENr2OaVlAHhQu
         x1juKDSO8ZB64fzrCgl2kVxnzZp1eExYtmwc9Z9wInL5acShij8A9PSz7g6nI8TrqhDs
         h4qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=40Mq3uCZm93XC8lWlE47L7jYgJCpjnvKFznJ8ZS0L8s=;
        b=VfocOi1EpzUsn2mWDEqUegyLEnEgr7yFKkYFL7yblqKah4RmlL/0FOlKo+leRyIxvi
         mE6rwtw80qfn45NPQJHsE+AgSOKXPy5g117FgNy19wfvIHguwZl8ef1sRYFk1k+q7NL/
         qXM0mUz6xEp/UezXcdsE+TtrStvjsLX9uvdb4bMeLOiXZD4JaWjBvcIDI8m5C3R0aa+0
         hdv/WRbhsH9YNr5y7Kl+bm1emkPnFD5GGLMz7oeYG+8aK+dX6zIL2/+ALdjou2tyWcZV
         JAYcmx2TNdfjnRz5QvTz+ahfVouP/mqke1AZG4VdY82hqS6GpoWfhk4U5thTAvWNp3tS
         7mzg==
X-Gm-Message-State: AOAM533UQbAgTVphffJiQmZZJ4I9CvgREzN9U05jz8hvJ7+RD4utohBw
        rUQ+gtYadUdLTyp92rOOMwSKHhwEQQBTJg==
X-Google-Smtp-Source: ABdhPJyHrCihIhKt4M0rHTKd6NHS10RjoZ8TgdJ7pPcqGi7yj8QxAcEqVCE9/ey2fnjmd30wZk9lAw==
X-Received: by 2002:a5d:6da5:: with SMTP id u5mr323227wrs.436.1634144201741;
        Wed, 13 Oct 2021 09:56:41 -0700 (PDT)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id w2sm130690wrt.31.2021.10.13.09.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:56:41 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, warthog9@eaglescrag.net,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] trace-cruncher: Optimize get_arg_list()
Date:   Wed, 13 Oct 2021 19:56:27 +0300
Message-Id: <20211013165628.76149-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The extraction of a 'C' string from a Python list of strings gets
defined as a static method instead of being coded in the body of
'get_arg_list()'. The new static method will be used in following
patches. The error message emitted in the case of an error is
remover since it will never get printed (it is overwritten by the
error messages of the functions calling 'get_arg_list()').

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index d8115f6..5c8bcca 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -274,10 +274,19 @@ PyObject *PyTepEvent_get_pid(PyTepEvent* self, PyObject *args,
 	return PyLong_FromLong(pid);
 }
 
+static const char *str_from_list(PyObject *py_list, int i)
+{
+	PyObject *item = PyList_GetItem(py_list, i);
+
+	if (!PyUnicode_Check(item))
+		return NULL;
+
+	return PyUnicode_DATA(item);
+}
+
 static const char **get_arg_list(PyObject *py_list)
 {
 	const char **argv = NULL;
-	PyObject *arg_py;
 	int i, n;
 
 	if (!PyList_CheckExact(py_list))
@@ -286,18 +295,14 @@ static const char **get_arg_list(PyObject *py_list)
 	n = PyList_Size(py_list);
 	argv = calloc(n + 1, sizeof(*argv));
 	for (i = 0; i < n; ++i) {
-		arg_py = PyList_GetItem(py_list, i);
-		if (!PyUnicode_Check(arg_py))
+		argv[i] = str_from_list(py_list, i);
+		if (!argv[i])
 			goto fail;
-
-		argv[i] = PyUnicode_DATA(arg_py);
 	}
 
 	return argv;
 
  fail:
-	PyErr_SetString(TRACECRUNCHER_ERROR,
-			"Failed to parse argument list.");
 	free(argv);
 	return NULL;
 }
-- 
2.30.2

