Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF72C48BD1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82A83613F3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Jun 2021 11:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhFKLnQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 07:43:16 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:38545 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbhFKLnP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 07:43:15 -0400
Received: by mail-wr1-f53.google.com with SMTP id c9so5711904wrt.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jun 2021 04:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s0tPE8GkRIuGvdRBYeSfU44E0GLS3xlVseQ56PtIN24=;
        b=XkpKVMgUe5fFBdFWqnTboCmp9/joHypgXIapzBYcktQFmeRBmRmNXw6KdbWpAoVtZ2
         Qf56HY3NPTm6dC8HiB9oMnHjupDy6fQfQvSg23Emv2I8HcfXnPXSOxPwEtQQ4vuJTNKy
         cr1Fj9sD7ER0cx58zDRzY4TdjwXjLN/9sZIuvFGXCfDoxjKHwiMCcKmNjCjv1Yl6E++9
         QrEgbg+4qG4Z7QAG910eB/aykcReftSf3IE7srIc5uFw4vpEVWgqfY0v9tgbHU3sc1Jm
         si5DSAkggEtv+lY/1C5VX55mQr5rxNyBj8p+TxQO8b+y6rdi6vBw/gGP4ujhH0G4CSG0
         mMzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s0tPE8GkRIuGvdRBYeSfU44E0GLS3xlVseQ56PtIN24=;
        b=hSn8WZycwPY2HMO252ZXCVn7XQzrixUOd9UUxJ8i3KOkM7wt175iOix74JooCE6KGB
         fZJQfPYjA8DWgtpHcfBBzYoDJiziSOQYVd/rRrmJSfoCW8jHH8LxDGmrmDbteWNsGUlD
         Cf507sDilhE5v0ivu8reFUejdjRT4XoYApSdqgP2KiksNk/fUVCya5dhl95SwaW5HU61
         dxlOK39BEJ3ZE3GaIQIDRtvrjHHGBzOe1SLRUiTn1TiTXTJ/FOK0ZmHwbaWXtqibZkQb
         ZnY+7LnVrj/qPv6EDzZZGpChws8SQDji9Lgl2GI5Ul2tKlJjEntCv0jCYrWxDU0Tbenv
         l5cQ==
X-Gm-Message-State: AOAM530HkC3bL4DGewISFjkf/kEOGwMsVwRYtTX9HxjSsZWfpxjv4mHj
        xs/oE0+HEc9B8RFF3JhwDx/ZdB7t9uw=
X-Google-Smtp-Source: ABdhPJzHXTuTxyIWktKf/49TWdV3BqfCq5ALs2vsQDPIbEo5MGngmqj3xSlIQCxjDG7MTvhe1vVmoA==
X-Received: by 2002:adf:d1e4:: with SMTP id g4mr3586351wrd.405.1623411616258;
        Fri, 11 Jun 2021 04:40:16 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id c7sm6856464wrs.23.2021.06.11.04.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 04:40:15 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 8/9] trace-cruncher: Add testing
Date:   Fri, 11 Jun 2021 14:39:57 +0300
Message-Id: <20210611113958.38142-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611113958.38142-1-y.karadz@gmail.com>
References: <20210611113958.38142-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add basic infrastructure for CI testing.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tests/0_get_data/__init__.py                  |   0
 tests/0_get_data/test_get_data.py             |  26 +
 tests/1_unit/__init__.py                      |   0
 tests/1_unit/test_01_ftracepy_unit.py         | 495 ++++++++++++++++++
 tests/1_unit/test_02_datawrapper_unit.py      |  41 ++
 tests/1_unit/test_03_ksharkpy_unit.py         |  72 +++
 tests/2_integration/__init__.py               |   0
 .../test_01_ftracepy_integration.py           | 113 ++++
 .../test_03_ksharkpy_integration.py           |  25 +
 tests/__init__.py                             |   0
 10 files changed, 772 insertions(+)
 create mode 100644 tests/0_get_data/__init__.py
 create mode 100755 tests/0_get_data/test_get_data.py
 create mode 100644 tests/1_unit/__init__.py
 create mode 100644 tests/1_unit/test_01_ftracepy_unit.py
 create mode 100755 tests/1_unit/test_02_datawrapper_unit.py
 create mode 100755 tests/1_unit/test_03_ksharkpy_unit.py
 create mode 100644 tests/2_integration/__init__.py
 create mode 100755 tests/2_integration/test_01_ftracepy_integration.py
 create mode 100755 tests/2_integration/test_03_ksharkpy_integration.py
 create mode 100644 tests/__init__.py

diff --git a/tests/0_get_data/__init__.py b/tests/0_get_data/__init__.py
new file mode 100644
index 0000000..e69de29
diff --git a/tests/0_get_data/test_get_data.py b/tests/0_get_data/test_get_data.py
new file mode 100755
index 0000000..53decd0
--- /dev/null
+++ b/tests/0_get_data/test_get_data.py
@@ -0,0 +1,26 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright (C) 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import os
+import sys
+import shutil
+import unittest
+import git
+
+class GetTestData(unittest.TestCase):
+    def test_get_data(self):
+        data_dir = 'testdata'
+        if os.path.exists(data_dir) and os.path.isdir(data_dir):
+            shutil.rmtree(data_dir)
+
+        github_repo = 'https://github.com/yordan-karadzhov/kernel-shark_testdata.git'
+        repo = git.Repo.clone_from(github_repo, data_dir)
+
+
+if __name__ == '__main__':
+    unittest.main()
diff --git a/tests/1_unit/__init__.py b/tests/1_unit/__init__.py
new file mode 100644
index 0000000..e69de29
diff --git a/tests/1_unit/test_01_ftracepy_unit.py b/tests/1_unit/test_01_ftracepy_unit.py
new file mode 100644
index 0000000..8b665d0
--- /dev/null
+++ b/tests/1_unit/test_01_ftracepy_unit.py
@@ -0,0 +1,495 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright (C) 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import os
+import sys
+import unittest
+import tracecruncher.ftracepy as ft
+
+instance_name = 'test_instance1'
+another_instance_name = 'test_instance2'
+
+class InstanceTestCase(unittest.TestCase):
+    def test_dir(self):
+        tracefs_dir = ft.dir()
+        self.assertTrue(os.path.isdir(tracefs_dir))
+        instances_dir = tracefs_dir + '/instances/'
+        self.assertTrue(os.path.isdir(instances_dir))
+
+    def test_create_instance(self):
+        ft.create_instance(instance_name)
+        instances_dir = ft.dir() + '/instances/'
+        self.assertTrue(os.path.isdir(instances_dir + instance_name))
+
+        err = 'function missing required argument'
+        with self.assertRaises(Exception) as context:
+            ft.create_instance();
+        self.assertTrue(err in str(context.exception))
+
+        err = 'is not a valid name for trace instance'
+        with self.assertRaises(Exception) as context:
+            ft.create_instance('');
+        self.assertTrue(err in str(context.exception))
+
+    def test_destroy_instance(self):
+        ft.destroy_instance(instance_name)
+        instances_dir = ft.dir() + '/instances/'
+        self.assertFalse(os.path.isdir(instances_dir + instance_name))
+
+        err = 'Unable to destroy trace instances'
+        with self.assertRaises(Exception) as context:
+            ft.destroy_instance(instance_name)
+        self.assertTrue(err in str(context.exception))
+
+        ft.create_instance(instance_name)
+        ft.create_instance(another_instance_name)
+        ft.destroy_all_instances()
+        self.assertFalse(os.path.isdir(instances_dir + instance_name))
+
+        ft.create_instance(instance_name)
+        ft.create_instance(another_instance_name)
+        ft.destroy_instance('all')
+        self.assertFalse(os.path.isdir(instances_dir + instance_name))
+
+    def test_get_all(self):
+        ft.create_instance(instance_name)
+        ft.create_instance(another_instance_name)
+        self.assertEqual(ft.get_all_instances(),
+                         [instance_name, another_instance_name])
+        ft.destroy_all_instances()
+
+    def test_instance_dir(self):
+        ft.create_instance(instance_name)
+        tracefs_dir = ft.dir();
+        instance_dir = tracefs_dir + '/instances/' + instance_name
+        self.assertEqual(instance_dir, ft.instance_dir(instance_name))
+        ft.destroy_all_instances()
+
+class PyTepTestCase(unittest.TestCase):
+    def test_init_local(self):
+        tracefs_dir = ft.dir()
+        tep = ft.tep_handle();
+        tep.init_local(tracefs_dir);
+
+        tep.init_local(dir=tracefs_dir, systems=['sched', 'irq']);
+
+        ft.create_instance(instance_name)
+        tracefs_dir = ft.instance_dir(instance_name)
+        tep.init_local(dir=tracefs_dir, systems=['sched', 'irq']);
+
+        err='function missing required argument \'dir\''
+        with self.assertRaises(Exception) as context:
+            tep.init_local(systems=['sched', 'irq']);
+        self.assertTrue(err in str(context.exception))
+
+        err='Failed to get local events from \'no_dir\''
+        with self.assertRaises(Exception) as context:
+            tep.init_local(dir='no_dir', systems=['sched', 'irq']);
+        self.assertTrue(err in str(context.exception))
+        ft.destroy_all_instances()
+
+    def test_get_event(self):
+        tracefs_dir = ft.dir()
+        tep = ft.tep_handle();
+        tep.init_local(tracefs_dir);
+        evt = tep.get_event(system='sched', name='sched_switch');
+
+
+class PyTepEventTestCase(unittest.TestCase):
+    def test_name(self):
+        tracefs_dir = ft.dir()
+        tep = ft.tep_handle();
+        tep.init_local(tracefs_dir);
+        evt = tep.get_event(system='sched', name='sched_switch');
+        self.assertEqual(evt.name(), 'sched_switch');
+
+    def test_field_names(self):
+        tracefs_dir = ft.dir()
+        tep = ft.tep_handle();
+        tep.init_local(tracefs_dir);
+        evt = tep.get_event(system='sched', name='sched_switch');
+        fiels = evt.field_names()
+        self.assertEqual(fiels , ['common_type',
+                                  'common_flags',
+                                  'common_preempt_count',
+                                  'common_pid',
+                                  'prev_comm',
+                                  'prev_pid',
+                                  'prev_prio',
+                                  'prev_state',
+                                  'next_comm',
+                                  'next_pid',
+                                  'next_prio'])
+
+
+class TracersTestCase(unittest.TestCase):
+    def test_available_tracers(self):
+        tracers = ft.available_tracers()
+        self.assertTrue(len(tracers) > 1)
+        self.assertTrue('function' in tracers)
+
+    def test_set_tracer(self):
+        ft.set_current_tracer(tracer='function')
+        ft.set_current_tracer(tracer='')
+
+        err = 'Tracer \'zero\' is not available.'
+        with self.assertRaises(Exception) as context:
+            ft.set_current_tracer(tracer='zero')
+        self.assertTrue(err in str(context.exception))
+
+
+class EventsTestCase(unittest.TestCase):
+    def test_available_systems(self):
+        systems = ft.available_event_systems()
+        self.assertTrue(len(systems) > 1)
+        self.assertTrue('sched' in systems)
+
+        ft.create_instance(instance_name)
+        systems = ft.available_event_systems(instance_name)
+        self.assertTrue(len(systems) > 1)
+        self.assertTrue('sched' in systems)
+
+        ft.destroy_all_instances()
+
+    def test_available_system_events(self):
+        events = ft.available_system_events(system='sched')
+        self.assertTrue(len(events) > 1)
+        self.assertTrue('sched_switch' in events)
+
+        ft.create_instance(instance_name)
+        events = ft.available_system_events(instance=instance_name,
+                                              system='sched')
+        self.assertTrue(len(events) > 1)
+        self.assertTrue('sched_switch' in events)
+
+        err = 'function missing required argument'
+        with self.assertRaises(Exception) as context:
+            ft.available_system_events(instance=instance_name)
+        self.assertTrue(err in str(context.exception))
+
+        ft.destroy_all_instances()
+
+    def test_enable_event(self):
+        ft.create_instance(instance_name)
+
+        ret = ft.event_is_enabled(instance=instance_name, system='all')
+        self.assertEqual(ret, '0')
+        ft.enable_event(instance=instance_name, system='all')
+        ret = ft.event_is_enabled(instance=instance_name, system='all')
+        self.assertEqual(ret, '1')
+        ft.disable_event(instance=instance_name, system='all')
+        ret = ft.event_is_enabled(instance=instance_name, system='all')
+        self.assertEqual(ret, '0')
+
+        ret = ft.event_is_enabled(instance=instance_name, event='all')
+        self.assertEqual(ret, '0')
+        ft.enable_event(instance=instance_name, event='all')
+        ret = ft.event_is_enabled(instance=instance_name, event='all')
+        self.assertEqual(ret, '1')
+        ft.disable_event(instance=instance_name, event='all')
+        ret = ft.event_is_enabled(instance=instance_name, event='all')
+        self.assertEqual(ret, '0')
+
+        ret = ft.event_is_enabled(instance=instance_name, system='sched')
+        self.assertEqual(ret, '0')
+        ft.enable_event(instance=instance_name, system='sched')
+        ret = ft.event_is_enabled(instance=instance_name, system='sched')
+        self.assertEqual(ret, '1')
+        ft.disable_event(instance=instance_name, system='sched')
+        ret = ft.event_is_enabled(instance=instance_name, system='sched')
+        self.assertEqual(ret, '0')
+
+        ft.enable_event(instance=instance_name,
+                        system='sched',
+                        event='sched_switch')
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='sched_switch')
+        self.assertEqual(ret, '1')
+        ft.disable_event(instance=instance_name,
+                         system='sched',
+                         event='sched_switch')
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='sched_switch')
+        self.assertEqual(ret, '0')
+
+        ft.enable_event(instance=instance_name,
+                        system='sched',
+                        event='all')
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='all')
+        self.assertEqual(ret, '1')
+        ft.disable_event(instance=instance_name,
+                         system='sched',
+                         event='all')
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='all')
+        self.assertEqual(ret, '0')
+
+        ft.enable_event(instance=instance_name,
+                        event='sched_switch')
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='sched_switch')
+        self.assertEqual(ret, '1')
+        ft.disable_event(instance=instance_name,
+                         event='sched_switch')
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='sched_switch')
+        self.assertEqual(ret, '0')
+
+        ft.enable_event(instance=instance_name,
+                        system='all',
+                        event='sched_switch')
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='sched_switch')
+        self.assertEqual(ret, '1')
+        ft.disable_event(instance=instance_name,
+                         system='all',
+                         event='sched_switch')
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='sched_switch')
+        self.assertEqual(ret, '0')
+
+        ft.enable_event(instance=instance_name,
+                        system='xen',
+                        event='xen_mc_flush',
+                        regex=True)
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='xen',
+                                  event='xen_mc_flush')
+        self.assertEqual(ret, '1')
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='xen',
+                                  event='xen_mc_flush_reason')
+        self.assertEqual(ret, '1')
+
+        ft.destroy_all_instances()
+
+    def test_enable_event_err(self):
+        ft.create_instance(instance_name)
+
+        err = 'Failed to enable/disable event'
+        with self.assertRaises(Exception) as context:
+            ft.enable_event(instance=instance_name,
+                            system='zero')
+        self.assertTrue(err in str(context.exception))
+
+        with self.assertRaises(Exception) as context:
+            ft.enable_event(instance=instance_name,
+                            system='sched',
+                            event='zero')
+        self.assertTrue(err in str(context.exception))
+
+        err = 'Regex symbols used'
+        with self.assertRaises(Exception) as context:
+            ft.enable_event(instance=instance_name,
+                            system='a(?:bc)*')
+        self.assertTrue(err in str(context.exception))
+
+        ft.destroy_all_instances()
+
+    def test_enable_events(self):
+        ft.create_instance(instance_name)
+        ft.enable_events(instance=instance_name,
+                         events='all')
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  event='all')
+        self.assertEqual(ret, '1')
+        ft.disable_events(instance=instance_name,
+                          events='all')
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  event='all')
+        self.assertEqual(ret, '0')
+
+        ft.enable_events(instance=instance_name,
+                         systems=['sched', 'irq'])
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='all')
+        self.assertEqual(ret, '1')
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='irq',
+                                  event='all')
+        self.assertEqual(ret, '1')
+
+        ft.disable_events(instance=instance_name,
+                          systems=['sched', 'irq'])
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='all')
+        self.assertEqual(ret, '0')
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='irq',
+                                  event='all')
+        self.assertEqual(ret, '0')
+
+        ft.enable_events(instance=instance_name,
+                         systems=['sched', 'irq'],
+                         events=[['sched_switch', 'sched_waking'],
+                                 ['all']])
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='sched_switch')
+        self.assertEqual(ret, '1')
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='sched_waking')
+        self.assertEqual(ret, '1')
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='sched_wakeup')
+        self.assertEqual(ret, '0')
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='irq',
+                                  event='all')
+        self.assertEqual(ret, '1')
+
+        ft.disable_events(instance=instance_name,
+                          systems=['sched', 'irq'],
+                          events=[['sched_switch', 'sched_waking'],
+                                  ['all']])
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='sched_switch')
+        self.assertEqual(ret, '0')
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='sched',
+                                  event='sched_waking')
+        self.assertEqual(ret, '0')
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                  system='irq',
+                                  event='all')
+        self.assertEqual(ret, '0')
+
+        ft.destroy_all_instances()
+
+    def test_enable_events_err(self):
+        ft.create_instance(instance_name)
+
+        err = 'Inconsistent \"events\" argument'
+        with self.assertRaises(Exception) as context:
+            ft.enable_events(instance=instance_name,
+                             systems=['sched'],
+                             events=['all'])
+        self.assertTrue(err in str(context.exception))
+
+        err = 'Failed to enable events for unspecified system'
+        with self.assertRaises(Exception) as context:
+            ft.enable_events(instance=instance_name,
+                             events=['sched_switch', 'sched_wakeup'])
+        self.assertTrue(err in str(context.exception))
+
+        err = 'Failed to enable/disable event'
+        with self.assertRaises(Exception) as context:
+            ft.enable_events(instance=instance_name,
+                             systems=['sched'],
+                             events=[['no_event']])
+        self.assertTrue(err in str(context.exception))
+
+        ft.destroy_all_instances()
+
+
+class OptionsTestCase(unittest.TestCase):
+    def test_enable_option(self):
+        ft.create_instance(instance_name)
+        opt = 'event-fork'
+        ret = ft.option_is_set(instance=instance_name,
+                                   option=opt)
+        self.assertFalse(ret)
+
+        ft.enable_option(instance=instance_name,
+                         option=opt)
+        ret = ft.option_is_set(instance=instance_name,
+                               option=opt)
+        self.assertTrue(ret)
+
+        ft.disable_option(instance=instance_name,
+                          option=opt)
+        ret = ft.option_is_set(instance=instance_name,
+                                   option=opt)
+        self.assertFalse(ret)
+
+        opt = 'no-opt'
+        err = 'Failed to set option \"no-opt\"'
+        with self.assertRaises(Exception) as context:
+            ft.enable_option(instance=instance_name,
+                             option=opt)
+        self.assertTrue(err in str(context.exception))
+
+        ft.destroy_all_instances()
+
+    def test_supported_options(self):
+        ft.create_instance(instance_name)
+        opts = ft.supported_options(instance_name)
+        self.assertTrue(len(opts) > 20)
+        self.assertTrue('event-fork' in opts)
+
+        ft.destroy_all_instances()
+
+    def test_enabled_options(self):
+        ft.create_instance(instance_name)
+        opts = ft.enabled_options(instance_name)
+        n = len(opts)
+        ft.enable_option(instance=instance_name, option='function-fork')
+        ft.enable_option(instance=instance_name, option='event-fork')
+        opts = ft.enabled_options(instance_name)
+
+        self.assertEqual(len(opts), n + 2)
+        self.assertTrue('event-fork' in opts)
+        self.assertTrue('function-fork' in opts)
+
+        ft.destroy_all_instances()
+
+
+class TracingOnTestCase(unittest.TestCase):
+    def test_ON_OF(self):
+        ft.tracing_ON()
+        self.assertTrue(ft.is_tracing_ON())
+        ft.tracing_OFF()
+
+        ft.create_instance(instance_name)
+        ft.tracing_ON(instance=instance_name)
+        self.assertTrue(ft.is_tracing_ON(instance=instance_name))
+        self.assertFalse(ft.is_tracing_ON())
+        ft.tracing_OFF(instance=instance_name)
+
+        ft.destroy_all_instances()
+
+    def test_err(self):
+        err = 'returned a result with an error set'
+        with self.assertRaises(Exception) as context:
+            ft.tracing_ON('zero')
+        self.assertTrue(err in str(context.exception))
+
+        with self.assertRaises(Exception) as context:
+            ft.tracing_OFF('zero')
+        self.assertTrue(err in str(context.exception))
+
+
+if __name__ == '__main__':
+    unittest.main()
diff --git a/tests/1_unit/test_02_datawrapper_unit.py b/tests/1_unit/test_02_datawrapper_unit.py
new file mode 100755
index 0000000..58c8706
--- /dev/null
+++ b/tests/1_unit/test_02_datawrapper_unit.py
@@ -0,0 +1,41 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright (C) 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import os
+import sys
+import unittest
+import tracecruncher.ksharkpy as ks
+import tracecruncher.npdatawrapper as dw
+
+file_1 = 'testdata/trace_test1.dat'
+
+class DwPyTestCase(unittest.TestCase):
+    def test_columns(self):
+        self.assertEqual(dw.columns(), ['event', 'cpu', 'pid', 'offset', 'time'])
+
+    def test_load(self):
+        sd = ks.open(file_1)
+        data = dw.load(sd)
+        self.assertEqual(len(dw.columns()), len(data))
+        self.assertEqual(data['pid'].size, 1530)
+
+        data_no_ts = dw.load(sd, ts_data=False)
+        self.assertEqual(data_no_ts['pid'].size, 1530)
+        self.assertEqual(len(dw.columns()) - 1, len(data_no_ts))
+
+        data_pid_cpu = dw.load(sd, evt_data=False,
+                                   ofst_data=False,
+                                   ts_data=False)
+        self.assertEqual(data_pid_cpu['cpu'].size, 1530)
+        self.assertEqual(2, len(data_pid_cpu))
+
+        ks.close()
+
+
+if __name__ == '__main__':
+    unittest.main()
diff --git a/tests/1_unit/test_03_ksharkpy_unit.py b/tests/1_unit/test_03_ksharkpy_unit.py
new file mode 100755
index 0000000..c7da2a1
--- /dev/null
+++ b/tests/1_unit/test_03_ksharkpy_unit.py
@@ -0,0 +1,72 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright (C) 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import os
+import sys
+import unittest
+import tracecruncher.ksharkpy as ks
+import tracecruncher.npdatawrapper as dw
+
+file_1 = 'testdata/trace_test1.dat'
+file_2 = 'testdata/trace_test2.dat'
+
+ss_id = 323
+
+class KsPyTestCase(unittest.TestCase):
+    def test_open_close(self):
+        sd = ks.open(file_1)
+        self.assertEqual(sd, 0)
+        sd = ks.open(file_2)
+        self.assertEqual(sd, 1)
+        ks.close()
+
+        sd = ks.open(file_1)
+        self.assertEqual(sd, 0)
+        ks.close()
+
+        err = 'Failed to open file'
+        with self.assertRaises(Exception) as context:
+            sd = ks.open('no_file')
+        self.assertTrue(err in str(context.exception))
+
+    def test_event_id(self):
+        sd = ks.open(file_1)
+        eid = ks.event_id(stream_id=sd, name='sched/sched_switch')
+        self.assertEqual(eid, ss_id)
+
+        err = 'Failed to retrieve the Id of event'
+        with self.assertRaises(Exception) as context:
+            eid = ks.event_id(stream_id=sd, name='sched/no_such_event')
+        self.assertTrue(err in str(context.exception))
+
+        ks.close()
+
+    def test_event_name(self):
+        sd = ks.open(file_1)
+        name = ks.event_name(stream_id=sd, event_id=ss_id)
+        self.assertEqual(name, 'sched/sched_switch')
+
+        err = 'Failed to retrieve the name of event'
+        with self.assertRaises(Exception) as context:
+            name = ks.event_name(stream_id=sd, event_id=2**30)
+        self.assertTrue(err in str(context.exception))
+
+        ks.close()
+
+    def read_field(self):
+        sd = ks.open(file_1)
+        data = dw.load(sd)
+        next_pid = read_event_field(stream_id=sd,
+                                    offset=data['offset'],
+                                    event_id=ss_id,
+                                    field='next_pid')
+        self.assertEqual(next_pid, 4182)
+
+
+if __name__ == '__main__':
+    unittest.main()
diff --git a/tests/2_integration/__init__.py b/tests/2_integration/__init__.py
new file mode 100644
index 0000000..e69de29
diff --git a/tests/2_integration/test_01_ftracepy_integration.py b/tests/2_integration/test_01_ftracepy_integration.py
new file mode 100755
index 0000000..d3b2c6b
--- /dev/null
+++ b/tests/2_integration/test_01_ftracepy_integration.py
@@ -0,0 +1,113 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright (C) 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import os
+import sys
+import unittest
+import tracecruncher.ftracepy as ft
+
+class InstanceTestCase(unittest.TestCase):
+    def test_create_instance(self):
+        tracefs_dir = ft.dir()
+        instances_dir = tracefs_dir + '/instances/'
+        self.assertEqual(len(os.listdir(instances_dir)), 0)
+
+        for i in range(25) :
+            instance_name = 'test_instance_%s' % i
+            ft.create_instance(instance_name)
+            self.assertTrue(os.path.isdir(instances_dir + instance_name))
+
+        for i in range(15) :
+            instance_name = 'test_instance_%s' % i
+            ft.destroy_instance(instance_name)
+            self.assertFalse(os.path.isdir(instances_dir + instance_name))
+
+        self.assertEqual(len(os.listdir(instances_dir)), 10)
+        ft.destroy_instance('all')
+        self.assertEqual(len(os.listdir(instances_dir)), 0)
+
+    def test_current_tracer(self):
+        current = ft.get_current_tracer()
+        self.assertEqual(current, 'nop')
+        ft.tracing_OFF()
+        name = 'function'
+        ft.set_current_tracer(tracer=name)
+        current = ft.get_current_tracer()
+        self.assertEqual(current, name)
+        ft.set_current_tracer()
+
+        instance_name = 'test_instance'
+        ft.create_instance(instance_name)
+        current = ft.get_current_tracer(instance=instance_name)
+        self.assertEqual(current, 'nop')
+        ft.tracing_OFF(instance=instance_name)
+        ft.set_current_tracer(instance=instance_name, tracer=name)
+        current = ft.get_current_tracer(instance=instance_name)
+        self.assertEqual(current, name)
+        ft.destroy_instance('all')
+
+    def test_enable_events(self):
+        instance_name = 'test_instance'
+        ft.create_instance(instance_name)
+        systems = ft.available_event_systems(instance=instance_name)
+        systems.remove('ftrace')
+        for s in systems:
+            ret = ft.event_is_enabled(instance=instance_name,
+                                       system=s)
+            self.assertEqual(ret, '0')
+            ft.enable_event(instance=instance_name,
+                             system=s)
+            ret = ft.event_is_enabled(instance=instance_name,
+                                       system=s)
+            self.assertEqual(ret, '1')
+
+            ft.disable_event(instance=instance_name,
+                             system=s)
+            events = ft.available_system_events(instance=instance_name,
+                                                 system=s)
+            for e in events:
+                ret = ft.event_is_enabled(instance=instance_name,
+                                           system=s,
+                                           event=e)
+                self.assertEqual(ret, '0')
+                ft.enable_event(instance=instance_name,
+                                 system=s,
+                                 event=e)
+                ret = ft.event_is_enabled(instance=instance_name,
+                                           system=s,
+                                           event=e)
+                self.assertEqual(ret, '1')
+                ret = ft.event_is_enabled(instance=instance_name,
+                                           system=s)
+                if e != events[-1]:
+                    self.assertEqual(ret, 'X')
+
+            ret = ft.event_is_enabled(instance=instance_name,
+                                       system=s)
+            self.assertEqual(ret, '1')
+
+        ret = ft.event_is_enabled(instance=instance_name,
+                                   system=s)
+        self.assertEqual(ret, '1')
+
+        ft.disable_event(instance=instance_name, event='all')
+        for s in systems:
+            ret = ft.event_is_enabled(instance=instance_name,
+                                       system=s)
+            self.assertEqual(ret, '0')
+            events = ft.available_system_events(instance=instance_name,
+                                                 system=s)
+            for e in events:
+                ret = ft.event_is_enabled(instance=instance_name,
+                                           system=s,
+                                           event=e)
+                self.assertEqual(ret, '0')
+
+
+if __name__ == '__main__':
+    unittest.main()
diff --git a/tests/2_integration/test_03_ksharkpy_integration.py b/tests/2_integration/test_03_ksharkpy_integration.py
new file mode 100755
index 0000000..dd8e0b5
--- /dev/null
+++ b/tests/2_integration/test_03_ksharkpy_integration.py
@@ -0,0 +1,25 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright (C) 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import os
+import sys
+import shutil
+import unittest
+import tracecruncher.ks_utils as tc
+
+class GetTestData(unittest.TestCase):
+    def test_open_and_read(self):
+        f = tc.open_file(file_name='testdata/trace_test1.dat')
+        data = f.load(pid_data=False)
+        tasks = f.get_tasks()
+        self.assertEqual(len(tasks), 29)
+        self.assertEqual(tasks['zoom'], [28121, 28137, 28141, 28199, 28201, 205666])
+
+
+if __name__ == '__main__':
+    unittest.main()
diff --git a/tests/__init__.py b/tests/__init__.py
new file mode 100644
index 0000000..e69de29
-- 
2.27.0

