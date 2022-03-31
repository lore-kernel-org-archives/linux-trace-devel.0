Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF57C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 31 Mar 2022 09:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiCaJ51 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 05:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbiCaJ51 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 05:57:27 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6B53DDD6
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Mar 2022 02:55:40 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id r13so32931984wrr.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Mar 2022 02:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SgQiod47sFEUxczZH3PKKs147/zpWToDx6tta0OrLyc=;
        b=K7MFu6FenYv6qi8nnZ9BrJ9zmwsoN7/vHuypAyxllUK+2wZlIpRzDa0ngffM3AXJN2
         1slvmQCMKYW282xwN4ZadcaKhUv/OgVSkgqWZRoYrs+24c0wbA0BcI8ZVUZo7SsgH7Fm
         ++1hv36Z4gf2FAEPL/HfF75RndmZz4iU8yeixpdC5v3isA0mZvG+X3uQePercSd5ZahC
         iGtNixoLDYb20ZGlagu0f85jCL946iIyGW0tnzWzW9TfSfoGSjpsu6eV4Rz9PMJ1O3ah
         f5gz/CqFFKuBRFc/3d9L1lFN60qQhudt/3fMQhI7ap276Q/GfWQUHdOAkuOD7ruuYer+
         k3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SgQiod47sFEUxczZH3PKKs147/zpWToDx6tta0OrLyc=;
        b=e0pcS+F237iArehtUKYWzMiutDp/tj1cznf3hGBt2wjch1UO9OMJ5Gf08H6rx7ZkS+
         NSWDWNl4AuwjZrRHnmvI28s+YAV9dkfieumjj8lHc1hS8Zm7xGxo3B4FgbrydR6stIPO
         957VXVlSHgO9tzQqqe7PY5wUs5HnDQtANL3+Oaj7qdIkcSmNVwfnWYrgs33zI+EKrO6C
         xjkPD8ZSrMlrgN8pziO7qVLOZTDgIMn3khSpXVZEuTce66FKq2xiIb2TBHffyPTK7kxf
         KhdddetxII9g5CDvxN3RISWbFGHqI3X208p+5XcuQtaoMgeW6FoewvVVrQsEVSAxByNi
         WpJg==
X-Gm-Message-State: AOAM532MJjTFWmJ/ocgWTnfJGti5RnTrp1UOtk6358LVkfHUR+g5K5CU
        N33EIakB9/pfohBb1ygLOGU=
X-Google-Smtp-Source: ABdhPJw1yKdebWGD+eEnr7xdyAQuoy/lVcQZNStM/P9ylYWKHrkpqQa+ev1egXzZfB44vRqWWFfcZQ==
X-Received: by 2002:adf:ebc7:0:b0:1ee:945a:ffb4 with SMTP id v7-20020adfebc7000000b001ee945affb4mr3458908wrn.641.1648720538714;
        Thu, 31 Mar 2022 02:55:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm11807493wmq.27.2022.03.31.02.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 02:55:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH 2/4] trace-cruncher: ftrace uprobe raw API
Date:   Thu, 31 Mar 2022 12:55:31 +0300
Message-Id: <20220331095533.75289-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220331095533.75289-1-tz.stoyanov@gmail.com>
References: <20220331095533.75289-1-tz.stoyanov@gmail.com>
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

