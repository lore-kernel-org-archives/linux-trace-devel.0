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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F329C07E9A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 307AE60FF2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhGLMfp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Jul 2021 08:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhGLMfo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Jul 2021 08:35:44 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98CDC0613DD
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:32:54 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t3so27700958edt.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=59a+wgtio3H2Yl9QvOAwrecUPo0WRNpBELA/KD4uJVU=;
        b=qm41ipiARgtsvXlDN/E/9LFZDnAVzFktkzJXU/wS83souu+Xtkyc/OsDyAkFEipazo
         sLtpZncWoTNnzqoD5HYcqycBpIjp+h59HhDpEzWitoRfJRkMfig11kC1tjOWoZI8XjPh
         b2urA2rNclujGRN1YVMtkh3TmZVTdfgHZywHfhZiI5vE2FJ4Q0uHROxuowlLlC8v/QT4
         CXHeVX/zRsYDeG1rHdQlAlE6Q3nIhw/2ggifizn7CuVQMujKOg1DLdJMhdZXlOJeenLq
         opFY1RkaA21DHYY5R7Ygl67fh/LqH+F2LvVK8ElA4nWMC6vOg88v1SIolV9rxH78SVpJ
         So3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=59a+wgtio3H2Yl9QvOAwrecUPo0WRNpBELA/KD4uJVU=;
        b=OjynsGU0v7caNM6UXKI6/CjQplZA9TPUtzLD+cur2lEfYBjt/jvnVC5zT/Q6xKtjT1
         UhtePsRwfleUJfpGF+fsmNUiqd34NoQLnfR/vuKo8Y2igK6vVJ15ECAVq+OJAIXFRRXx
         O6FYeNRuVART9BU5j30Lt5dzB4BfMWzE7iJdApZrFkycxyjJcxjsfvvvO5gz2+yjonVK
         3vmFhD47oUpaZEXblZLlpTdnCfYBR6FoWGpyYbVbWl4ddyLwy7cBiX/bECbJ2QGKY87o
         HcC9qaHoWOKo5tcsclfIZEfexpcuySl4kGsi2Dc2zJvVRLc046z/ks2m1mTVdLY4drnB
         pOGQ==
X-Gm-Message-State: AOAM5313P1bKoAX9JeVN8k5zmeBkdH75ncPbTWeyd3Qv+47H4M6iZNI4
        luk4ywda5XZlkJ4HteuKn+AsDXrOoh0=
X-Google-Smtp-Source: ABdhPJxpLfwM4z1xfoF07sqfvvsUbrdFX63XFA+rTdHz1dHcU5+VTIWCDdmXttNrDBPuIp6FKA2rIw==
X-Received: by 2002:a05:6402:42d2:: with SMTP id i18mr64432223edc.168.1626093172698;
        Mon, 12 Jul 2021 05:32:52 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.98])
        by smtp.gmail.com with ESMTPSA id z5sm6477473ejn.65.2021.07.12.05.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:32:52 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/4] trace-cruncher: Add set_ftrace_loglevel()
Date:   Mon, 12 Jul 2021 15:32:39 +0300
Message-Id: <20210712123242.223500-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 23 +++++++++++++++++++++++
 src/ftracepy-utils.h |  3 +++
 src/ftracepy.c       |  5 +++++
 3 files changed, 31 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index dfb0669..8f4b50c 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1801,6 +1801,29 @@ PyObject *PyFtrace_kprobe_is_enabled(PyObject *self, PyObject *args,
 	return event_is_enabled(instance, TC_SYS, event);
 }
 
+PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
+						       PyObject *kwargs)
+{
+	static char *kwlist[] = {"level", NULL};
+	int level;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "i",
+					 kwlist,
+					 &level)) {
+		return NULL;
+	}
+
+	if (level < 0)
+		level = 0;
+
+	tracefs_set_loglevel(level);
+	tep_set_loglevel(level);
+
+	Py_RETURN_NONE;
+}
+
 static bool set_fork_options(struct tracefs_instance *instance, bool enable)
 {
 	if (enable) {
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index d826427..5d7c19c 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -155,6 +155,9 @@ PyObject *PyFtrace_disable_kprobe(PyObject *self, PyObject *args,
 PyObject *PyFtrace_kprobe_is_enabled(PyObject *self, PyObject *args,
 						     PyObject *kwargs);
 
+PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
+						       PyObject *kwargs);
+
 PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
 						 PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index e5fcd54..e3fec7b 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -269,6 +269,11 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Check if kprobe event is enabled."
 	},
+	{"set_ftrace_loglevel",
+	 (PyCFunction) PyFtrace_set_ftrace_loglevel,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Set the verbose level of the ftrace libraries."
+	},
 	{"trace_process",
 	 (PyCFunction) PyFtrace_trace_process,
 	 METH_VARARGS | METH_KEYWORDS,
-- 
2.27.0

