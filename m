Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FDDC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 16:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FCE360F23
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Oct 2021 16:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237860AbhJMQ7W (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238095AbhJMQ7K (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 12:59:10 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBA7C061770
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Oct 2021 09:56:44 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k7so10421499wrd.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Oct 2021 09:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=07Ad1CWhPZzNWhtMEksu8jo+JRbgRaGWGWhnMZLd7k4=;
        b=kJUTZaLRm+s+QmEFc2OXwSdKORoFf5dw1dFf0zU8UJtQTaGzdVEpGzORSHGgx5/tX5
         ZpXbeOvO2HftlAT/RTdI3Jr/IgXuM6QLJ3AUc02JYdTqKEsvGyqOXGd6IofO50liPRJh
         3NP/PHgwyphUxvRj6K2Nu7JY8kfH4Vj6X5S04bRSpkIYGkfZTi9hHpQP4nRK3+I2aYBw
         PGiwJyWrkSaIl5NRGSWYaD+eBnq1pgmhDQTJyDO9AmL2f6nmunkkxrRo9b3hNQnRlEwV
         dT/6paSouZyvYEYXOT0uw7r2G2qBG6NIxfRmj+5mYdcjWz3dMenO/w6SOinAlaEQQAir
         xWRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=07Ad1CWhPZzNWhtMEksu8jo+JRbgRaGWGWhnMZLd7k4=;
        b=GgLJ195Fye5EqSAZkQo9wwHzp5Jl5/DZGqkuClZ0hF80Wnzq843A1Tuy6eBhe5/hF2
         qL3sNMgvVhK+V7qw1o2qKmlULAFIl7fM/7IS6VCnpz8bBO6fG6ePeOAQDKF4Gnzb+geb
         5Lk5P1hqAhaaVQUkIICEPoE3xwxePQ6jSgmuMWTuBqsWXkqsN6CTtumtDOQ7USxcoRg+
         Gguz2/HknRlfooYlpPpcTgKsuMZ5+GBrmzidQK8H+jDpzJ+hF5OkUNclz5CLaRfODgfr
         LlHiUMsqiPTZd80Lu6xHZErytAUAz8QLROT+s4itxYC+hIocJe8RmXSnPjJJFa9bRw8p
         GXZw==
X-Gm-Message-State: AOAM531qMi5MzKegd890yLamidlyUUy0LDj2HsAKXyEEzCSmCv7VEJ8f
        OonD/jG4HKinwlutUKEmlMPIlE3yZZUyBA==
X-Google-Smtp-Source: ABdhPJwSgXE+gCfaaO1aqTZfcKyNt6E0JaYfSgwBf9/ELVqtjpN8KTlN9wC6bsAoKrzPHyMDMjpAIg==
X-Received: by 2002:a5d:59aa:: with SMTP id p10mr314713wrr.45.1634144202592;
        Wed, 13 Oct 2021 09:56:42 -0700 (PDT)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id w2sm130690wrt.31.2021.10.13.09.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:56:42 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, warthog9@eaglescrag.net,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] trace-cruncher: Modify the APIs for enable/disable multiple events
Date:   Wed, 13 Oct 2021 19:56:28 +0300
Message-Id: <20211013165628.76149-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013165628.76149-1-y.karadz@gmail.com>
References: <20211013165628.76149-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The current version of these APIs takes the list of systems and the
'list of list' of events to enable/disable in two independent arguments.
This can potentially create confusion since the user is expected to
provide two correlated lists via disjoined arguments. Here we switch to
using a single 'events' argument for these APIs that takes a dictionary
where the 'systems' are 'keys' and the lists of events from each system
are the 'value'.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/start_tracing.py                     |  4 +-
 src/ftracepy-utils.c                          | 87 ++++++-------------
 .../tests/1_unit/test_01_ftracepy_unit.py     | 41 +++------
 3 files changed, 40 insertions(+), 92 deletions(-)

diff --git a/examples/start_tracing.py b/examples/start_tracing.py
index c9960e3..aaeb0cf 100755
--- a/examples/start_tracing.py
+++ b/examples/start_tracing.py
@@ -13,8 +13,8 @@ inst = ft.create_instance()
 
 # Enable all static events from systems "sched" and "irq".
 ft.enable_events(instance=inst,
-                 systems=['sched', 'irq'],
-                 events=[['sched_switch'],['all']])
+                 events={'sched': ['sched_switch', 'sched_waking'],
+                         'irq':   ['all']})
 
 # Print the stream of trace events. "Ctrl+c" to stop tracing.
 ft.read_trace(instance=inst)
diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 5c8bcca..d25d873 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1161,90 +1161,59 @@ PyObject *PyFtrace_disable_event(PyObject *self, PyObject *args,
 static bool set_enable_events(PyObject *self, PyObject *args, PyObject *kwargs,
 			      bool enable)
 {
-	static char *kwlist[] = {"instance", "systems", "events", NULL};
-	PyObject *system_list = NULL, *event_list = NULL, *system_event_list;
-	const char **systems = NULL, **events = NULL;
+	static char *kwlist[] = {"events", "instance", NULL};
+	PyObject *event_dict = NULL, *py_inst = NULL;
 	struct tracefs_instance *instance;
-	PyObject *py_inst = NULL;
-	char *file = NULL;
-	int ret, s, e;
+	PyObject *py_system, *py_events;
+	const char *system, *event;
+	Py_ssize_t pos = 0;
+	int i, n;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "|OOO",
+					 "O|O",
 					 kwlist,
-					 &py_inst,
-					 &system_list,
-					 &event_list)) {
+					 &event_dict,
+					 &py_inst)) {
 		return false;
 	}
 
 	if (!get_optional_instance(py_inst, &instance))
 		return false;
 
-	if (!system_list && !event_list)
-		return event_enable_disable(instance, NULL, NULL, enable);
+	if (!PyDict_CheckExact(event_dict))
+		goto fail_with_err;
 
-	if (!system_list && event_list) {
-		if (PyUnicode_Check(event_list) &&
-		    is_all(PyUnicode_DATA(event_list))) {
-			return event_enable_disable(instance, NULL, NULL, enable);
-		} else {
-			TfsError_setstr(instance,
-					"Failed to enable events for unspecified system");
-			return false;
-		}
-	}
+	while (PyDict_Next(event_dict, &pos, &py_system, &py_events)) {
+		if (!PyUnicode_Check(py_system) ||
+		    !PyList_CheckExact(py_events))
+			goto fail_with_err;
 
-	systems = get_arg_list(system_list);
-	if (!systems) {
-		TfsError_setstr(instance, "Inconsistent \"systems\" argument.");
-		return false;
-	}
+		system = PyUnicode_DATA(py_system);
+		n = PyList_Size(py_events);
 
-	if (!event_list) {
-		for (s = 0; systems[s]; ++s) {
-			ret = event_enable_disable(instance, systems[s], NULL, enable);
-			if (ret < 0)
+		if (n == 0 || (n == 1 && is_all(str_from_list(py_events, 0)))) {
+			if (!event_enable_disable(instance, system, NULL,
+						  enable))
 				return false;
+			continue;
 		}
 
-		return true;
-	}
-
-	if (!PyList_CheckExact(event_list))
-		goto fail_with_err;
-
-	for (s = 0; systems[s]; ++s) {
-		system_event_list = PyList_GetItem(event_list, s);
-		if (!system_event_list || !PyList_CheckExact(system_event_list))
-			goto fail_with_err;
-
-		events = get_arg_list(system_event_list);
-		if (!events)
-			goto fail_with_err;
+		for (i = 0; i < n; ++i) {
+			event = str_from_list(py_events, i);
+			if (!event)
+				goto fail_with_err;
 
-		for (e = 0; events[e]; ++e) {
-			if (!event_enable_disable(instance, systems[s], events[e], enable))
-				goto fail;
+			if (!event_enable_disable(instance, system, event,
+						  enable))
+				return false;
 		}
-
-		free(events);
-		events = NULL;
 	}
 
-	free(systems);
-
 	return true;
 
  fail_with_err:
 	TfsError_setstr(instance, "Inconsistent \"events\" argument.");
-
- fail:
-	free(systems);
-	free(events);
-	free(file);
-
 	return false;
 }
 
diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index d3e3960..b9c8fd0 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -270,20 +270,8 @@ class EventsTestCase(unittest.TestCase):
     def test_enable_events(self):
         inst = ft.create_instance(instance_name)
         ft.enable_events(instance=inst,
-                         events='all')
-
-        ret = ft.event_is_enabled(instance=inst,
-                                  event='all')
-        self.assertEqual(ret, '1')
-        ft.disable_events(instance=inst,
-                          events='all')
-
-        ret = ft.event_is_enabled(instance=inst,
-                                  event='all')
-        self.assertEqual(ret, '0')
-
-        ft.enable_events(instance=inst,
-                         systems=['sched', 'irq'])
+                         events={'sched': ['all'],
+                                 'irq': ['all']})
 
         ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
@@ -296,7 +284,8 @@ class EventsTestCase(unittest.TestCase):
         self.assertEqual(ret, '1')
 
         ft.disable_events(instance=inst,
-                          systems=['sched', 'irq'])
+                          events={'sched': ['all'],
+                                  'irq': ['all']})
 
         ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
@@ -309,9 +298,8 @@ class EventsTestCase(unittest.TestCase):
         self.assertEqual(ret, '0')
 
         ft.enable_events(instance=inst,
-                         systems=['sched', 'irq'],
-                         events=[['sched_switch', 'sched_waking'],
-                                 ['all']])
+                         events={'sched': ['sched_switch', 'sched_waking'],
+                                 'irq':   ['all']})
 
         ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
@@ -334,9 +322,8 @@ class EventsTestCase(unittest.TestCase):
         self.assertEqual(ret, '1')
 
         ft.disable_events(instance=inst,
-                          systems=['sched', 'irq'],
-                          events=[['sched_switch', 'sched_waking'],
-                                  ['all']])
+                          events={'sched': ['sched_switch', 'sched_waking'],
+                                  'irq':   ['all']})
 
         ret = ft.event_is_enabled(instance=inst,
                                   system='sched',
@@ -359,21 +346,13 @@ class EventsTestCase(unittest.TestCase):
         err = 'Inconsistent \"events\" argument'
         with self.assertRaises(Exception) as context:
             ft.enable_events(instance=inst,
-                             systems=['sched'],
-                             events=['all'])
-        self.assertTrue(err in str(context.exception))
-
-        err = 'Failed to enable events for unspecified system'
-        with self.assertRaises(Exception) as context:
-            ft.enable_events(instance=inst,
-                             events=['sched_switch', 'sched_wakeup'])
+                             events='all')
         self.assertTrue(err in str(context.exception))
 
         err = 'Failed to enable/disable event'
         with self.assertRaises(Exception) as context:
             ft.enable_events(instance=inst,
-                             systems=['sched'],
-                             events=[['no_event']])
+                             events={'sched': ['no_event']})
         self.assertTrue(err in str(context.exception))
 
 
-- 
2.30.2

