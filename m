Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BAA8C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 13 Jan 2022 17:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbiAMRuu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 13 Jan 2022 12:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiAMRuu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Jan 2022 12:50:50 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351CFC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 09:50:50 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id b13so26205421edn.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 13 Jan 2022 09:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hOA4WSItgpJZ7g2qbqfYcCfA/0OqeNo5/a7wOw/o3ns=;
        b=dhdLOR8U/7Dpu1+vv/JkOKZxkE3+YcwtiDrRrQoiYMMz7I8gtPvLVyx6PSSjsjp0Hv
         4MfLFkuJlyu1hsN0OUqF50JzSZQmFdEMxUQAT06ke6TjgATVLP2IFQomcmHQIBrCFKOA
         c5KhOiclQPnU/z0EWdYcp3rZR2RQx66vKvIzKIdzbmYu6KKcwvSPUW+fFnH26DsgYlJs
         9j/1pMAcDtUt5f+kqAZ3nJjcbzsyT3U+9VgcFcceAFZ9Rsn61mLOy7ACa4Goci0LX4dk
         3/gW9FfCApiAmBM/xbmdOLl0PY32lmaVvJaVLuSkTU9FvaZOHGR+oUbLpsnkeK0cmI56
         DUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hOA4WSItgpJZ7g2qbqfYcCfA/0OqeNo5/a7wOw/o3ns=;
        b=PplyLGL3YNWtxEhMtB2/01EdyR3B+njl2gNa72EK7PucBQ/m9KtxLqRaZEXYXbXOg5
         9X4s+3iDoAJ6Jx6p4LHni5W8j3Z2fsldML6vGVFD46oMIh9YIaiSa5Iiqu64GPv7Xjrz
         wpCwfEkn5EgF/V/WyL/oo4iOtiidA3rUAy+L4M+pJsA/wHxo/45ia+JnwE1qASZH7JP/
         MSryUDVCWM2l9oyW5f+uipZ69Nzz+S654wAHPED2UX6a3oUXpmHONj9GarqA0H102dN9
         1iK+Kz9vlt/3w/lYDgx7tMmpDc9Ppo2VJD15J/smhepblN35J8fGS5d/uyycHqLQA4cW
         pxnQ==
X-Gm-Message-State: AOAM530tnJAMe+eXqbL4MRKBQKa0ShoT4Mj89GBKofs202m8SXR5zdJb
        yNLK10asaga/d0pX5v1VwpuvvwPfllY=
X-Google-Smtp-Source: ABdhPJxnygbUaCgJ1Gbf2fW6tbtK4O2F+xuRz9NKFwjpPfq2RzYoZWdTfMGjFfMRUe/QKtuapxVHvA==
X-Received: by 2002:a05:6402:c89:: with SMTP id cm9mr5140858edb.304.1642096248560;
        Thu, 13 Jan 2022 09:50:48 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id hq29sm1132531ejc.141.2022.01.13.09.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 09:50:48 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] trace-cruncher: Add static method for getting tep_handle object
Date:   Thu, 13 Jan 2022 19:50:36 +0200
Message-Id: <20220113175036.85340-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The libtracefs APIs for getting the local (for the system) version of the
tep_handle object are being called in number of places in trace-cruncher.
In each of these places a hendling of the error case gets reimplemented,
resulting in a lot of duplicated code. Here we add a static method that
returns the object or prinst a standart error message end returns NULL
in a case of an error.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c                          | 52 +++++++++++--------
 .../tests/1_unit/test_01_ftracepy_unit.py     |  4 +-
 2 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index aac31a4..cecb180 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -307,6 +307,20 @@ static const char **get_arg_list(PyObject *py_list)
 	return NULL;
 }
 
+static struct tep_handle *get_tep(const char *dir, const char **sys_names)
+{
+	struct tep_handle *tep;
+
+	tep = tracefs_local_events_system(dir, sys_names);
+	if (!tep) {
+		TfsError_fmt(NULL,
+			     "Failed to get local 'tep' event from %s", dir);
+		return NULL;
+	}
+
+	return tep;
+}
+
 PyObject *PyTep_init_local(PyTep *self, PyObject *args,
 					PyObject *kwargs)
 {
@@ -333,17 +347,14 @@ PyObject *PyTep_init_local(PyTep *self, PyObject *args,
 			return NULL;
 		}
 
-		tep = tracefs_local_events_system(dir_str, sys_names);
+		tep = get_tep(dir_str, sys_names);
 		free(sys_names);
 	} else {
-		tep = tracefs_local_events(dir_str);
+		tep = get_tep(dir_str, NULL);
 	}
 
-	if (!tep) {
-		TfsError_fmt(NULL, "Failed to get local events from \'%s\'.",
-			     dir_str);
+	if (!tep)
 		return NULL;
-	}
 
 	tep_free(self->ptrObj);
 	self->ptrObj = tep;
@@ -2075,11 +2086,9 @@ PyObject *PyDynevent_set_filter(PyDynevent *self, PyObject *args,
 	if (!get_optional_instance(py_inst, &instance))
 		return NULL;
 
-	tep = tracefs_local_events(NULL);
-	if (!tep) {
-		TfsError_setstr(NULL, "Failed to get local events.");
+	tep = get_tep(NULL, NULL);
+	if (!tep)
 		return NULL;
-	}
 
 	event = tracefs_dynevent_get_event(tep, self->ptrObj);
 	if (!event) {
@@ -2139,11 +2148,9 @@ PyObject *PyDynevent_clear_filter(PyDynevent *self, PyObject *args,
 	if (!get_instance_from_arg(args, kwargs, &instance))
 		return NULL;
 
-	tep = tracefs_local_events(NULL);
-	if (!tep) {
-		TfsError_setstr(NULL, "Failed to get local events.");
+	tep = get_tep(NULL, NULL);
+	if (!tep)
 		return NULL;
-	}
 
 	event = tracefs_dynevent_get_event(tep, self->ptrObj);
 	if (!event) {
@@ -2391,9 +2398,9 @@ PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
 		return NULL;
 	}
 
-	tep = tracefs_local_events(tracefs_tracing_dir());
+	tep = get_tep(NULL, NULL);
 	if (!tep)
-		goto fail;
+		return NULL;
 
 	if (py_key && ! py_axes) {
 		hist = hist_from_key(tep, system, event, py_key, py_type);
@@ -2622,13 +2629,9 @@ static bool init_callback_tep(struct tracefs_instance *instance,
 	if (!*py_func)
 		return false;
 
-	*tep = tracefs_local_events(tracefs_instance_get_dir(instance));
-	if (!*tep) {
-		TfsError_fmt(instance,
-			     "Unable to get 'tep' event from instance \'%s\'.",
-			     get_instance_name(instance));
+	*tep = get_tep(tracefs_instance_get_dir(instance), NULL);
+	if (!*tep)
 		return false;
-	}
 
 	if (!notrace_this_pid(instance))
 		return false;
@@ -2814,7 +2817,10 @@ PyObject *PyFtrace_iterate_trace(PyObject *self, PyObject *args,
 	    !notrace_this_pid(itr_instance))
 		return NULL;
 
-	tep = tracefs_local_events(tracefs_instance_get_dir(itr_instance));
+	tep = get_tep(tracefs_instance_get_dir(itr_instance), NULL);
+	if (!tep)
+		return NULL;
+
 	(*(volatile bool *)callback_status) = true;
 	callback_ctx.py_callback = py_func;
 	tracing_ON(itr_instance);
diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index 87b2be8..51970d3 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -80,9 +80,9 @@ class PyTepTestCase(unittest.TestCase):
             tep.init_local(systems=['sched', 'irq']);
         self.assertTrue(err in str(context.exception))
 
-        err='Failed to get local events from \'no_dir\''
+        err='Failed to get local \'tep\' event from /no/dir'
         with self.assertRaises(Exception) as context:
-            tep.init_local(dir='no_dir', systems=['sched', 'irq']);
+            tep.init_local(dir='/no/dir', systems=['sched', 'irq'])
         self.assertTrue(err in str(context.exception))
 
     def test_get_event(self):
-- 
2.32.0

