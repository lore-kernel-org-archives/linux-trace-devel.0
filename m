Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E004C07E99
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0719B61003
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbhGLMfr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Jul 2021 08:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhGLMfr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Jul 2021 08:35:47 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D76C0613DD
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:32:57 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id v20so34243444eji.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eceWyTFNnPBQfYSkYX5yOi4Zdou57BzvQlADbNIRtMU=;
        b=gp/q7P9vKIedm0T8yJwV51lamAY91AsATsKCyjgKBV99wNdC/9QN/2zXG1tBTvjk2w
         UGkYZV/MoEtf304bxyN4nqXQz8zBYOV7oLmUa60ARNAOb2+kNQ3WhVguO3HebUVRNwZz
         KJjxeRIy4OMrdqd6WSAqHRMkR/wrNJugduR7hlz0TU4vkwB2cO/3oxl9vv+WsHHel6oj
         GnnZkUcigyrw7BlAq+YU/rfimoVFNTLll8ULaZUg/pUknSoqyd4r3MLwMG2d+C/UrPum
         u6SnFVaHVt+qess0Hbug//FG7e6taTQt9rVDfM0OE15xTC17MwN4CEb9VJ2Zk9selbLm
         8Fqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eceWyTFNnPBQfYSkYX5yOi4Zdou57BzvQlADbNIRtMU=;
        b=B/E2s0Tl5y8QvANmcgQ/F0A6a5WCe/0GThfdZ9i5ajA+q5Na+8rCAaaQr5NYHYuDFr
         /talK+6bQlgaGvUdSZSs8pFW5tUv1/sgniVR6J7UcDN2zXD4X237KW8wPV0gVHF8v+UO
         FIwrRqOPT7IW6iD2JtWWQfCvQJXqwmJz74n8rIchFJkwA/nKU7I+UuwlpCswqSMI5tvH
         8/cjFJ6YhcSRYSkREfxXyIhcTsAUgX+MU4f8DktBGM/fnn9euPavo6xBdrF0ttrBMvYC
         rg8z5EFgX8cfl5tU7bvKmKyiX8Sud/nmIgPFGdoXDJh81Zhrc5reHrpJGvcXCHyr29XU
         HYHg==
X-Gm-Message-State: AOAM533VE5lr9VMoj6iwBJUnwNmk8T+1uOq9pab9l19r8jVN9kVDgyPO
        d2nSlU48OnQ0jd49ybQDCJ42rwHihkA=
X-Google-Smtp-Source: ABdhPJxV8NsXv/jRvPgPtuYDUkZRKjOjUDJF2TGEp9QEkS+hFz78XTv6iEpHgri/rmaDsNZJ0H2Nag==
X-Received: by 2002:a17:906:7111:: with SMTP id x17mr6897308ejj.294.1626093176321;
        Mon, 12 Jul 2021 05:32:56 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.98])
        by smtp.gmail.com with ESMTPSA id z5sm6477473ejn.65.2021.07.12.05.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:32:56 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/4] trace-cruncher: Allow for detachable kprobes
Date:   Mon, 12 Jul 2021 15:32:42 +0300
Message-Id: <20210712123242.223500-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210712123242.223500-1-y.karadz@gmail.com>
References: <20210712123242.223500-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If a kprobe or kretprobe is created with "detached=True", the Python
module is no longer responsible for destroying it when exiting. It is
therefore up to the user free it explicitly, or to keep it active.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c                  | 26 ++++++++++++++++----------
 tests/1_unit/test_01_ftracepy_unit.py |  9 +++++++++
 tracecruncher/ft_utils.py             |  8 ++++----
 3 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index d061817..605f7eb 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1570,16 +1570,18 @@ bool store_new_kprobe(const char *event)
 PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 						   PyObject *kwargs)
 {
-	static char *kwlist[] = {"event", "function", "probe", NULL};
+	static char *kwlist[] = {"event", "function", "probe", "detached", NULL};
 	const char *event, *function, *probe;
+	int detached = false;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "sss",
+					 "sss|p",
 					 kwlist,
 					 &event,
 					 &function,
-					 &probe)) {
+					 &probe,
+					 &detached)) {
 		return NULL;
 	}
 
@@ -1589,8 +1591,9 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 		return NULL;
 	}
 
-	if (!store_new_kprobe(event))
-		return NULL;
+	if (!detached)
+		if (!store_new_kprobe(event))
+			return NULL;
 
 	Py_RETURN_NONE;
 }
@@ -1598,16 +1601,18 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 						      PyObject *kwargs)
 {
-	static char *kwlist[] = {"event", "function", "probe", NULL};
+	static char *kwlist[] = {"event", "function", "probe", "detached", NULL};
 	const char *event, *function, *probe = "$retval";
+	int detached = false;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "ss|s",
+					 "ss|sp",
 					 kwlist,
 					 &event,
 					 &function,
-					 &probe)) {
+					 &probe,
+					 &detached)) {
 		return NULL;
 	}
 
@@ -1617,8 +1622,9 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 		return NULL;
 	}
 
-	if (!store_new_kprobe(event))
-		return NULL;
+	if (!detached)
+		if (!store_new_kprobe(event))
+			return NULL;
 
 	Py_RETURN_NONE;
 }
diff --git a/tests/1_unit/test_01_ftracepy_unit.py b/tests/1_unit/test_01_ftracepy_unit.py
index 0d62da2..a7a6dec 100644
--- a/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tests/1_unit/test_01_ftracepy_unit.py
@@ -479,6 +479,15 @@ class KprobeTestCase(unittest.TestCase):
         all_kprobes = ft.registered_kprobes()
         self.assertEqual(len(all_kprobes), 0)
 
+        ft.register_kprobe(event=evt1, function=evt1_func,
+                           probe=evt1_prove, detached=True)
+        ft.unregister_kprobe(event='ALL')
+        all_kprobes = ft.registered_kprobes()
+        self.assertEqual(len(all_kprobes), 1)
+        ft.unregister_kprobe(event='ALL', force=True)
+        all_kprobes = ft.registered_kprobes()
+        self.assertEqual(len(all_kprobes), 0)
+
 
     def test_enable_kprobe(self):
         evt1 = 'mkdir'
diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index 8c245b1..a976885 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -171,12 +171,12 @@ class kprobe(kprobe_base):
                            offset=offset,
                            size=size)
 
-    def register(self):
+    def register(self, detached=False):
         """ Register this probe to Ftrace.
         """
         probe = ' '.join('{!s}={!s}'.format(key,val) for (key, val) in self.fields.items())
 
-        ft.register_kprobe(event=self.name, function=self.func, probe=probe);
+        ft.register_kprobe(event=self.name, function=self.func, probe=probe, detached=detached);
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
 
 
@@ -203,8 +203,8 @@ class kretval_probe(kprobe_base):
         """
         super().__init__(name, func)
 
-    def register(self):
+    def register(self, detached=False):
         """ Register this probe to Ftrace.
         """
-        ft.register_kprobe(event=self.name, function=self.func);
+        ft.register_kprobe(event=self.name, function=self.func, detached=detached);
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
-- 
2.27.0

