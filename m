Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F31C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 08:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376596AbiDTIFC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376598AbiDTIE7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 04:04:59 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5D53C4BE
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 01:02:13 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 11so1268232edw.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 01:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SgQiod47sFEUxczZH3PKKs147/zpWToDx6tta0OrLyc=;
        b=WGtpIN0TVxIiLIPJePlHBgEG3+YINfpSd6Ru0sRX4z+MfgfPTWaxp3Kepi07f/9CyX
         uQIhNcaNoRTssJ6TgNOSP2VFv++I053kJuinN1z3SsVWwTkHRBJ+jWSgZoDDGZwKsLeb
         auHzFRiDdoEg5BaFEABGAi0/BrV5n0eggMgDxKOZ5XGOP4EJ8nbulAfX9d6Noli3IyHu
         uZjkBr7oRnPosEwLB5dUQx6+aI6cA1TbAY54IXTKHOf1OVfPS6MGZJs3JRhrwfNZ6J7Q
         WCfmwYalx/jpIKKQjBXyg26YHXR8IuEl5EyBlolfBYGxjK4vLvz8iY47Oqh+dEZBfBvO
         Awlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SgQiod47sFEUxczZH3PKKs147/zpWToDx6tta0OrLyc=;
        b=P8vetJRq3tqcsDbDhd2jJAsWm6McKzc58iZQDVA2/jB7g5YLZ55WpxKE1M84iFFvGH
         otOKmAlT9Mbz31sRXNDUN6Sxv9UKcQCJQpXRU505uL9OEO1CTfH4eRqS1HVrqieRwHwX
         UsBwqdXCDopPo0xYv26RSKocASznQ3ZxuAri2hv4tvvmg0utSu9u5bjinTeupyfrvzDS
         o4rr01YGbLp6efUhHzVZAAYET0CNhHquiQGVPTkIxav10SxZGYjg66FUBuYnBdT0FGfv
         sb+RZg5mxr8nnxQBUaAnBE/6ulTfAumi0/WqnMfcsEPutSUSS8d2TdomlKfM5WEJhMIM
         zj0A==
X-Gm-Message-State: AOAM533+6XMMv99RJA8nQ/Lj7PX5s3Er3nnQJJM50AT6YyjTLd54o9uN
        JWS3l7qajmBazb6u11t03g5fKmBLJiZC8A==
X-Google-Smtp-Source: ABdhPJzy030LSZ/boR5ywfCt9mDKhDVVvQzaeIESDNCST/GK+BXnukm4nElV+VuZ3gNSetHjSOfUsA==
X-Received: by 2002:a05:6402:14d0:b0:41d:946b:7494 with SMTP id f16-20020a05640214d000b0041d946b7494mr21337738edx.190.1650441731863;
        Wed, 20 Apr 2022 01:02:11 -0700 (PDT)
Received: from oberon.zico.biz.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t12-20020a1709067c0c00b006e86db76851sm6393763ejo.193.2022.04.20.01.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 01:02:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH v3 2/4] trace-cruncher: ftrace uprobe raw API
Date:   Wed, 20 Apr 2022 11:02:04 +0300
Message-Id: <20220420080206.252356-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220420080206.252356-1-tz.stoyanov@gmail.com>
References: <20220420080206.252356-1-tz.stoyanov@gmail.com>
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

