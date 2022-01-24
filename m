Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BDBC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 08:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242520AbiAXI4y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 03:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242514AbiAXI4x (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 03:56:53 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75782C061401
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:53 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id n12-20020a05600c3b8c00b0034eb13edb8eso2064062wms.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=axfKaeOWgwNORJl845veEXj9grVMhyGAIBbWQqicf4A=;
        b=kyvESqjIlFeApV5OMXIYs3vEI+pVTo8DaTaKOukT5wtYIDVp/jaKQ7tnToDlBGh3xI
         6gVyOpHf9Uo1zfOmpd/MZzqfw1Er9kg08F+VZ03i50pb+cXMvkmRVlSRnf7qwk/euway
         +m4YznD1i4aBpZ4FzcPzgIWCaCHvNebXlEiPcPjt1QNkKsO2OL6zeKpPa01YRbztMvZ+
         vnZ9R/RSZW9KqBpWAJrz+rrCiGP+e6hB1aDp0c/KnBaDPizghirkWnDRzSnX0sCl5LI0
         RNjIkcx3C91lvEBa3qxfiPq1nizgSF8A1y8GH3QhSjRogAq09KrQ2Rm2b0+2X2Gi1QKr
         cHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=axfKaeOWgwNORJl845veEXj9grVMhyGAIBbWQqicf4A=;
        b=BXASIpT6P65Q1phA6ldZm7GApP4UgmoHv56RYKIAVjHm1tFmKSWNA9uyTWaCSCFHO0
         MIMWhNsDufAEmqyGsjglaxA+Ek399zllFMYlfqgbsKhVat013sGtTpjrF7KAgVyjd6iG
         FJKSmo8fSaUlpvTq3JQnoKx4pqYh7zz9SgkU8O0e00oQvVsx3AHChyY52f/3OrDn/vjB
         W18TOQeil9c0AX3EUVr1sM90SXbC8ZFJMrszeAp4StS92WphLufbM+HdcYrVTSMHmzlZ
         pPz3CFsxEbU8nrvIU6jT4cxc9tB0AkfCvE0tGZ2aisa0HtO3uZr3U6vQRaQAcybztZOm
         Px+Q==
X-Gm-Message-State: AOAM532B/EZKvMIcy8Sbfba+OF+i5GocIb2TNDeIBZl8V9hN2uOXHli/
        /I7H7zPd5X+K+DWU7A12EqJxSZ7GY/g=
X-Google-Smtp-Source: ABdhPJyNSCuP41dXs/gm5TNg+0wx/6Y45zGE/MObq6o3zVPsADhPFSsR7XoHqvooJ4jt6+FWPEQgtA==
X-Received: by 2002:a7b:c14b:: with SMTP id z11mr868319wmi.67.1643014611919;
        Mon, 24 Jan 2022 00:56:51 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id f14sm14828091wri.44.2022.01.24.00.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:56:49 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 04/10] trace-cruncher: APIs for registering/unregistering synth. events
Date:   Mon, 24 Jan 2022 10:56:19 +0200
Message-Id: <20220124085625.92297-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220124085625.92297-1-y.karadz@gmail.com>
References: <20220124085625.92297-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Here we add the following methods to the Python type for synthetic events:
register()
unregister()

The constructor only creates the objects that describe the new synthetic
event. We need to use those new APIs in order to actually create/destroy
the event into the system.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 42 +++++++++++++++++++++++++++++++++++++-----
 src/ftracepy-utils.h |  4 ++++
 src/ftracepy.c       | 10 ++++++++++
 3 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 9245b07..244bff9 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1154,17 +1154,49 @@ PyObject *PySynthEvent_add_delta_T(PySynthEvent *self, PyObject *args,
 	Py_RETURN_NONE;
 }
 
-PyObject *PyFtrace_dir(PyObject *self)
-{
-	return PyUnicode_FromString(tracefs_tracing_dir());
-}
-
 static void set_destroy_flag(PyObject *py_obj, bool val)
 {
 	PyFtrace_Object_HEAD *obj_head = (PyFtrace_Object_HEAD *)py_obj;
 	obj_head->destroy = val;
 }
 
+PyObject *PySynthEvent_register(PySynthEvent *self)
+{
+	if (tracefs_synth_create(self->ptrObj) < 0) {
+		TfsError_fmt(NULL, "Failed to register synth. event %s",
+			     tracefs_synth_get_name(self->ptrObj));
+		return NULL;
+	}
+
+	/*
+	 * Here the synthetic event gets added to the system.
+	 * Hence we need to 'destroy' this event at exit.
+	 */
+	set_destroy_flag((PyObject *)self, true);
+	Py_RETURN_NONE;
+}
+
+PyObject *PySynthEvent_unregister(PySynthEvent *self)
+{
+	if (tracefs_synth_destroy(self->ptrObj) < 0) {
+		TfsError_fmt(NULL, "Failed to unregister synth. event %s",
+			     tracefs_synth_get_name(self->ptrObj));
+		return NULL;
+	}
+
+	/*
+	 * Here the synthetic event gets removed from the system.
+	 * Hence we no loger need to 'destroy' this event at exit.
+	 */
+	set_destroy_flag((PyObject *)self, false);
+	Py_RETURN_NONE;
+}
+
+PyObject *PyFtrace_dir(PyObject *self)
+{
+	return PyUnicode_FromString(tracefs_tracing_dir());
+}
+
 static PyObject *set_destroy(PyObject *args, PyObject *kwargs, bool destroy)
 {
 	static char *kwlist[] = {"object", NULL};
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 7b798fc..40b41d8 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -139,6 +139,10 @@ PyObject *PySynthEvent_add_delta_T(PySynthEvent *self, PyObject *args,
 PyObject *PySynthEvent_add_sum(PySynthEvent *self, PyObject *args,
 						   PyObject *kwargs);
 
+PyObject *PySynthEvent_register(PySynthEvent *self);
+
+PyObject *PySynthEvent_unregister(PySynthEvent *self);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 066fc65..0314aa1 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -252,6 +252,16 @@ static PyMethodDef PySynthEvent_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Add 'start + end' field."
 	},
+	{"register",
+	 (PyCFunction) PySynthEvent_register,
+	 METH_NOARGS,
+	 "Register synth. event to a trace instance."
+	},
+	{"unregister",
+	 (PyCFunction) PySynthEvent_unregister,
+	 METH_NOARGS,
+	 "Unregister synth. event from a trace instance."
+	},
 	{NULL, NULL, 0, NULL}
 };
 
-- 
2.32.0

