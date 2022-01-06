Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE79C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Jan 2022 12:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238841AbiAFMfo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 07:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238831AbiAFMfo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 07:35:44 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2082BC061245
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jan 2022 04:35:44 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id u25so8952623edf.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 06 Jan 2022 04:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xZ8fuOCpcM5+wONweih26Q58W1S0/WfQTjASoK5IuD0=;
        b=LTifTM3RZ2AFUmP6rB4m6quYEc04iLOCfPBclnQ28DbY/DInLS7iFg4NU6VzA8cYrr
         MYg4Yhl2TXEG0xUC3eI58C3xZUluqLB62R+d4AlMWG/w6URUWAXx0w+KzHCypoR28eD8
         KgVE8oyeelWYYbH9ME+s4Rm2HdRTajiB8Q3bwYo8e7MNwDSlxQj4im3twypPc2CqxaxB
         n0/Q5rDR2PVbDTDuKM9oJAZWuj5iVvTeV9gUO4TOIox3FcanFg07lF2ag0IsZm6XWU8l
         67109HXFrmgh6P4XICdNUMb4eSFGw8/gddqHLkK/Mvj32x+74dRjj+dbGjQwRd6Y6pws
         nU7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xZ8fuOCpcM5+wONweih26Q58W1S0/WfQTjASoK5IuD0=;
        b=a1Zuy+NYolTqTPy0/BcVzyFnH3ZTuXvmzlw5pZQeCxp+D2zynBSx0nAOij51/3qBIu
         PAwO3Fno+bIH5WKGvpZt2wj3aDX9NFozBFnHEKABC7iJfz0HxPs8D1OV7IP3c8h+44WK
         +yR92v3skmfmKO3V7SIUx3UVdLuBXsq8iyixiy2BbSsNELGRe1vnbgNEIOaw4Q8Ex/PI
         OoGqIkISBwDapTmvjFQvwImcvTIqRFnzx6I+dcNokasqLJiW99iJSgObl6O7qw3oCDrm
         mnfpT+CvpLnKoZHoHWtQL6OSAQDoP2ngXd3kalpNwZ+i5W5ShyuYT6hxYja1Qqc0lH4w
         IHWA==
X-Gm-Message-State: AOAM530yUgaPfeCUty+SbeLY+sCs8SkipCFE2/SDbE8VlYLpeRZs0mbb
        CXf88vaGIHBknJjKEUNl4vtTAoG0Re8=
X-Google-Smtp-Source: ABdhPJwiVcXLMmZW48GP5lQnLbRZ8Y9IiAxsdnf88JbiE2lB/dsd57trusQBZWXZjEjQctWxpMJh/g==
X-Received: by 2002:a17:906:7044:: with SMTP id r4mr46257847ejj.351.1641472542516;
        Thu, 06 Jan 2022 04:35:42 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id 10sm468680ejy.174.2022.01.06.04.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 04:35:42 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] trace-cruncher: Add 'is_attached()'
Date:   Thu,  6 Jan 2022 14:35:04 +0200
Message-Id: <20220106123505.164550-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We already have APIs for attaching/detaching an object from/to
the 'ftracepy' module. For the sake of completeness we have to
add an API that checks if the object is attached.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 22 ++++++++++++++++++++++
 src/ftracepy-utils.h |  2 ++
 src/ftracepy.c       |  5 +++++
 3 files changed, 29 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 1b1f350..aac31a4 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1037,6 +1037,28 @@ PyObject *PyFtrace_attach(PyObject *self, PyObject *args, PyObject *kwargs)
 	return set_destroy(args, kwargs, true);
 }
 
+static bool get_destroy_flag(PyObject *py_obj)
+{
+	PyFtrace_Object_HEAD *obj_head = (PyFtrace_Object_HEAD *)py_obj;
+	return obj_head->destroy;
+}
+
+PyObject *PyFtrace_is_attached(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	static char *kwlist[] = {"object", NULL};
+	PyObject *py_obj;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "O",
+					 kwlist,
+					 &py_obj)) {
+		return NULL;
+	}
+
+	return get_destroy_flag(py_obj) ? Py_True : Py_False;
+}
+
 static char aname_pool[] =
 	"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
 
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index d09c8bf..fc5016c 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -125,6 +125,8 @@ PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
 
 PyObject *PyFtrace_attach(PyObject *self, PyObject *args, PyObject *kwargs);
 
+PyObject *PyFtrace_is_attached(PyObject *self, PyObject *args, PyObject *kwargs);
+
 PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
 						   PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index b270b71..f59bd4c 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -237,6 +237,11 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Attach object to the \'ftracepy\' module."
 	},
+	{"is_attached",
+	 (PyCFunction) PyFtrace_is_attached,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Check if the object is attached to the \'ftracepy\' module."
+	},
 	{"create_instance",
 	 (PyCFunction) PyFtrace_create_instance,
 	 METH_VARARGS | METH_KEYWORDS,
-- 
2.32.0

