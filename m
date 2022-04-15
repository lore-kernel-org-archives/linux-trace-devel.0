Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04A2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349353AbiDOEMp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Apr 2022 00:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238722AbiDOEMo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Apr 2022 00:12:44 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05C967D0D
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 21:10:17 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id s18so13594069ejr.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 21:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SgQiod47sFEUxczZH3PKKs147/zpWToDx6tta0OrLyc=;
        b=OfY+9+W0rpwQy1dYko7t+UcOx2Z+rW9Yjjzn+uBXxyCHl2bX6vdd0KEAwgORQOdGVK
         2Idi0nWFSFK6xC65gdxyFdUTkeLr7LFP7O509l9a02IbyfGTkuiObP+M20nS+3al1/Xq
         jnK9KM/zOo/YFfqnxkacl6Jl1tnN3AKHQQUSK9SRuKqJZZWFZUyITSOHGD5YeOpjQoZW
         /YnIi9P80tfrpFqXxWSni/64HF9I/zb8youbQjp9Uk4vt7aYv1fn12k94pDca7OQv5+v
         IBXon1N/z+hvVCyKQuCGb63SEcRwHY/ApXNWSOaWl0JjRHsq9bFwAD7QClzOct1Vn/Ac
         iQNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SgQiod47sFEUxczZH3PKKs147/zpWToDx6tta0OrLyc=;
        b=eqv2co8ORnfLIGXFMBv3sIgYMLKtCHNu1SX7ccM8gC3idSvnF7uLASsAqtGkYUa/zs
         Q3wYRnXhG4JnSRabKzk9YYQ8u8PXlcslzvWLaJ4x/SefVCjonh66pY+56GK7iop259SV
         I9rJCQnMoFq+ii+T3tg4vrlp3lJ0NRaqO/BrG6l5aqB9tnaG5ub//Ik8iwfuOjMnY9DW
         7wvcmD861xPycuDc/s1z9SCI4usLgBhXCPlBisQE0Z92KBhj+PCzJ3m1wuKNbXbp2HhG
         Z7bJ9DQkeDI20xzkRMFchW1LxlhPbCgXJBZuWpGx2B8QnFyEgQkjd1T34+MKEmSjJnmQ
         Y5OQ==
X-Gm-Message-State: AOAM530uXGJmllwaCfmjJcaBfTbihxTJSAq7M4/cMHolzzu0pls5x2I3
        aWH6XrRCCx2I2+WGWo2wcbk=
X-Google-Smtp-Source: ABdhPJw2bXODcatvRtQ8Lv/NZbXrNYwYgLSHiXT3xIUegXPFo/lJm6SJN4luqcJa86r/B/dkbzpgdg==
X-Received: by 2002:a17:906:478b:b0:6db:8b6e:d5de with SMTP id cw11-20020a170906478b00b006db8b6ed5demr5031630ejc.161.1649995816291;
        Thu, 14 Apr 2022 21:10:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dd6-20020a1709069b8600b006df08710d00sm1255724ejc.85.2022.04.14.21.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 21:10:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH v2 2/4] trace-cruncher: ftrace uprobe raw API
Date:   Fri, 15 Apr 2022 07:10:10 +0300
Message-Id: <20220415041012.36151-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415041012.36151-1-tz.stoyanov@gmail.com>
References: <20220415041012.36151-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace-cruncher low level wrappers for tracefs library APIs for
uprobe and uretprobe allocation.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/ftracepy-utils.c | 48 ++++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  4 ++++
 src/ftracepy.c       | 10 +++++++++
 3 files changed, 62 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index e8411ae..b39459b 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2449,6 +2449,54 @@ PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs)
 	return py_dyn;
 }
 
+static PyObject *alloc_uprobe(PyObject *self, PyObject *args, PyObject *kwargs, bool pret)
+{
+	static char *kwlist[] = {"event", "file", "offset", "fetch_args", NULL};
+	const char *event, *file, *fetchargs = NULL;
+	unsigned long long offset;
+	struct tracefs_dynevent *uprobe;
+	PyObject *py_dyn;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "ssK|s",
+					 kwlist,
+					 &event,
+					 &file,
+					 &offset,
+					 &fetchargs)) {
+		return NULL;
+	}
+
+	if (pret)
+		uprobe = tracefs_uretprobe_alloc(TC_SYS, event, file, offset, fetchargs);
+	else
+		uprobe = tracefs_uprobe_alloc(TC_SYS, event, file, offset, fetchargs);
+	if (!uprobe) {
+		MEM_ERROR;
+		return NULL;
+	}
+
+	py_dyn = PyDynevent_New(uprobe);
+	/*
+	 * Here we only allocated and initializes a dynamic event object.
+	 * However, no dynamic event is added to the system yet. Hence,
+	 * there is no need to 'destroy' this event at exit.
+	 */
+	set_destroy_flag(py_dyn, false);
+	return py_dyn;
+}
+
+PyObject *PyFtrace_uprobe(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	return alloc_uprobe(self, args, kwargs, false);
+}
+
+PyObject *PyFtrace_uretprobe(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	return alloc_uprobe(self, args, kwargs, true);
+}
+
 static PyObject *set_filter(PyObject *args, PyObject *kwargs,
 			    struct tep_handle *tep,
 			    struct tep_event *event)
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 9491b18..e6fab69 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -257,6 +257,10 @@ PyObject *PyFtrace_kretprobe(PyObject *self, PyObject *args, PyObject *kwargs);
 
 PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs);
 
+PyObject *PyFtrace_uprobe(PyObject *self, PyObject *args, PyObject *kwargs);
+
+PyObject *PyFtrace_uretprobe(PyObject *self, PyObject *args, PyObject *kwargs);
+
 PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
 					PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 574bf38..681d641 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -481,6 +481,16 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Define an eprobe."
 	},
+	{"uprobe",
+	 (PyCFunction) PyFtrace_uprobe,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define a uprobe."
+	},
+	{"uretprobe",
+	 (PyCFunction) PyFtrace_uretprobe,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define a uretprobe."
+	},
 	{"hist",
 	 (PyCFunction) PyFtrace_hist,
 	 METH_VARARGS | METH_KEYWORDS,
-- 
2.35.1

