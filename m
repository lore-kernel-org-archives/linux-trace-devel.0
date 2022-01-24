Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3D4C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 08:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242519AbiAXI4z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 03:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242517AbiAXI4z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 03:56:55 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4C4C06173B
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:55 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id h29so9520378wrb.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fkg2Jb6D7BJON9PjzuIEQk5TeR5GDIvfZcXG48kLwWA=;
        b=e7S9scIMLvkA17dYsx7eCcWst88vOej/rkikeVnGf2NJA+xlVjatjPES+pLtjGj8gm
         vQQe/ROWoO6w+3R6hZJyRzrw6gvgZ5zse6yW7cn39p3VntFm9Z2MoigK5hQqD06dIgZI
         A4B7AYPzzJnwlM5LJo8vKz/prntW5iDPjM9R1vzBiTdiaU3zqQ7YnJ86S2Ut8GWW0PGF
         GhtL8kexL7B3XC3FWcaEmq9N7L0Wu7itYaKBqEz51/3esPAhBn4qc8mMu5xqv09wD/WG
         peQpxbNr51M/C1qZpUQFiMLY/mJYxRhxIktAcm/qbwJtSRQVyfxmY4ygmIuB8NudmuWq
         JPMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fkg2Jb6D7BJON9PjzuIEQk5TeR5GDIvfZcXG48kLwWA=;
        b=Y8Nac2PPGfsJyVInhG+L0wqp82M89zOGfb5AGdbPudj6JYhyAQAcXHMddEud/PYmK4
         xVOfyoJ1HQ+vncUtM+oI9LS87/L8aBkABD6bBVkspMpvVwYnuFy8P5i1xWPoag4iffHj
         oZYuCaISGOOHnvRatGlcyNviq2MmQCgrL8SzGXbRUxGLwvERXVgdxXLxTfDCdS9wH7te
         cElNzLMrSldNzaLz/SuLZrFiQUp2oL8s/HapRRz/y6zJihmyqbM9NWCDOk1aihWcNKq9
         c1EYzyV13VzdpkyDiYPiZjy2AMCduAfj5V5ACVUmkbU/4wrixlDfFWkKBLUzaDDhZWLF
         OkXw==
X-Gm-Message-State: AOAM531MKOAg/sP2zic+ovoKn/OpCIvdmsZYZFFwe2FpJuLbGtim256b
        k4axB4IQLn+/u7ABkRhQEtzLRDFbXTY=
X-Google-Smtp-Source: ABdhPJxwgU/f04KT+zCYh+WXI4FR3aNpNNAlTsYE17OqdnodyO7fbN4duW/CbMxXd2CmMF9WG2nDqg==
X-Received: by 2002:a5d:47cd:: with SMTP id o13mr13854123wrc.438.1643014613466;
        Mon, 24 Jan 2022 00:56:53 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id f14sm14828091wri.44.2022.01.24.00.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:56:53 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 06/10] trace-cryncher: Add static methods for manipulating filters
Date:   Mon, 24 Jan 2022 10:56:21 +0200
Message-Id: <20220124085625.92297-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220124085625.92297-1-y.karadz@gmail.com>
References: <20220124085625.92297-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All the code that can have a general use is extracted from the
implementation of the APIs for dealing with filters of dynamic
events and gets isolated in static methods. This is a preparation
for the implementation of the APIs for dealing with filters of
synthetic events. The new APIs for filtering synthetic events
will be implemented in a following patch.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 121 +++++++++++++++++++++++++++----------------
 1 file changed, 77 insertions(+), 44 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 8a0c3c3..af73784 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2241,13 +2241,34 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 	return PyDynevent_New(kprobe);
 }
 
-PyObject *PyDynevent_set_filter(PyDynevent *self, PyObject *args,
-						  PyObject *kwargs)
+struct tep_event *dynevent_get_event(PyDynevent *event,
+				     struct tep_handle **tep_ptr)
+{
+	struct tep_event *tep_evt;
+	struct tep_handle *tep;
+
+	tep = get_tep(NULL, NULL);
+	if (!tep)
+		return NULL;
+
+	tep_evt = tracefs_dynevent_get_event(tep, event->ptrObj);
+	if (!tep_evt) {
+		TfsError_setstr(NULL, "Failed to get dynevent.");
+		return NULL;
+	}
+
+	if (tep_ptr)
+		*tep_ptr = tep;
+
+	return tep_evt;
+}
+
+static PyObject *set_filter(PyObject *args, PyObject *kwargs,
+			    struct tep_handle *tep,
+			    struct tep_event *event)
 {
 	struct tracefs_instance *instance;
 	PyObject *py_inst = NULL;
-	struct tep_handle * tep;
-	struct tep_event *event;
 	const char *filter;
 
 	static char *kwlist[] = {"filter", "instance", NULL};
@@ -2263,16 +2284,6 @@ PyObject *PyDynevent_set_filter(PyDynevent *self, PyObject *args,
 	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
-	tep = get_tep(NULL, NULL);
-	if (!tep)
-		return NULL;
-
-	event = tracefs_dynevent_get_event(tep, self->ptrObj);
-	if (!event) {
-		TfsError_setstr(NULL, "Failed to get event.");
-		return NULL;
-	}
-
 	if (tracefs_event_filter_apply(instance, event, filter) < 0) {
 		TfsError_fmt(NULL, "Failed to apply filter '%s' to event '%s'.",
 			     filter, event->name);
@@ -2282,59 +2293,36 @@ PyObject *PyDynevent_set_filter(PyDynevent *self, PyObject *args,
 	Py_RETURN_NONE;
 }
 
-PyObject *PyDynevent_get_filter(PyDynevent *self, PyObject *args,
-						  PyObject *kwargs)
+static PyObject *get_filter(PyObject *args, PyObject *kwargs,
+			    const char *system, const char* event )
 {
-	char *evt_name, *evt_system, *filter = NULL;
 	struct tracefs_instance *instance;
 	PyObject *ret = NULL;
+	char *filter = NULL;
 	char path[PATH_MAX];
-	int type;
 
 	if (!get_instance_from_arg(args, kwargs, &instance))
 		return NULL;
 
-	type = tracefs_dynevent_info(self->ptrObj, &evt_system, &evt_name,
-				     NULL, NULL, NULL);
-	if (type == TRACEFS_DYNEVENT_UNKNOWN) {
-		PyErr_SetString(TFS_ERROR, "Failed to get dynevent info.");
-		return NULL;
-	}
-
-	sprintf(path, "events/%s/%s/filter", evt_system, evt_name);
+	sprintf(path, "events/%s/%s/filter", system, event);
 	if (read_from_file(instance, path, &filter) <= 0)
-		goto free;
+		return NULL;
 
 	trim_new_line(filter);
 	ret = PyUnicode_FromString(filter);
- free:
-	free(evt_system);
-	free(evt_name);
 	free(filter);
 
 	return ret;
 }
 
-PyObject *PyDynevent_clear_filter(PyDynevent *self, PyObject *args,
-						    PyObject *kwargs)
+static PyObject *clear_filter(PyObject *args, PyObject *kwargs,
+			      struct tep_event *event)
 {
 	struct tracefs_instance *instance;
-	struct tep_handle * tep;
-	struct tep_event *event;
 
 	if (!get_instance_from_arg(args, kwargs, &instance))
 		return NULL;
 
-	tep = get_tep(NULL, NULL);
-	if (!tep)
-		return NULL;
-
-	event = tracefs_dynevent_get_event(tep, self->ptrObj);
-	if (!event) {
-		TfsError_setstr(NULL, "Failed to get event.");
-		return NULL;
-	}
-
 	if (tracefs_event_filter_clear(instance, event) < 0) {
 		TfsError_fmt(NULL, "Failed to clear filter for event '%s'.",
 			     event->name);
@@ -2344,6 +2332,51 @@ PyObject *PyDynevent_clear_filter(PyDynevent *self, PyObject *args,
 	Py_RETURN_NONE;
 }
 
+PyObject *PyDynevent_set_filter(PyDynevent *self, PyObject *args,
+						  PyObject *kwargs)
+{
+	struct tep_handle *tep;
+	struct tep_event *evt;
+
+	evt = dynevent_get_event(self, &tep);
+	if (!evt)
+		return NULL;
+
+	return set_filter(args, kwargs, tep, evt);
+}
+
+PyObject *PyDynevent_get_filter(PyDynevent *self, PyObject *args,
+						  PyObject *kwargs)
+{
+	struct tep_event *evt = dynevent_get_event(self, NULL);
+	char *evt_name, *evt_system;
+	int type;
+
+	if (!evt)
+		return NULL;
+
+	type = tracefs_dynevent_info(self->ptrObj, &evt_system, &evt_name,
+				     NULL, NULL, NULL);
+
+	if (type == TRACEFS_DYNEVENT_UNKNOWN) {
+		PyErr_SetString(TFS_ERROR, "Failed to get dynevent info.");
+		return NULL;
+	}
+
+	return get_filter(args, kwargs, evt_system, evt_name);
+}
+
+PyObject *PyDynevent_clear_filter(PyDynevent *self, PyObject *args,
+						    PyObject *kwargs)
+{
+	struct tep_event *evt = dynevent_get_event(self, NULL);
+
+	if (!evt)
+		return NULL;
+
+	return clear_filter(args, kwargs, evt);
+}
+
 static bool enable_dynevent(PyDynevent *self, PyObject *args, PyObject *kwargs,
 			  bool enable)
 {
-- 
2.32.0

