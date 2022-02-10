Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D96D8C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Feb 2022 15:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243603AbiBJPYA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:24:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243606AbiBJPX7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 10:23:59 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CA118C
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:59 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id bg21-20020a05600c3c9500b0035283e7a012so4227192wmb.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=icHzew9CcnqGnO2KtjmNj1sBw6PPO2pmMEVU9jOkVbo=;
        b=jr5SdN9LMwWbRwghc6doYYXUVPp86MJl/cm/zzS9+EMOIKabUKo5I6B3ciV8Mtnz5V
         Jwxea/ukJ7zXWuCsUECPg6hdJms9saEA+pmRLGP9AbWimyi+VGyFggod0JL2ERMZBKX/
         jiwAJarPC+mVIPXa0xnRqb1s8qsNWH+VCfwgSMlDnGv3tQ7B/SsfFpdSOXVXIjpYhAEs
         IQpM5nplbKvNcyUm+y/1zSLeXwdV+JA5pr+pkQod50PTShst/Bvjl+U99luR0TQBDAAi
         en+aXgUNJpMhBdhWvSYQ6Kma5n/F7EEcTH8Ade9FABc4cz8OAVtFklSp7ZWSLujGu2R+
         2seQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=icHzew9CcnqGnO2KtjmNj1sBw6PPO2pmMEVU9jOkVbo=;
        b=KTX4MMzG0Ehs5JLOpPnEU7nE6IEBoerkp/zBgALmtBigHyD54T+AUNjG3XVATfhtOs
         EBPJBZFcTxcnJum/CyT2TaX+d9guwzxTOnruqoRJ7kQQ6L2lLkqdSDJZy+SQ0kICIZoM
         kOFS5BSFl8RXz5kHIerQo6MTRtyCuuoUHaBEuPucowJLA0Umsu3PpPdJ8s3NZeUwlfEo
         pXmrieEvJ7rUFjJxoCHyWYP5z6jzs5THjow2dZOVKJcr91HrUa3jsuGbpHqLzUAfu4Dw
         0iRjiCxb8M+7l3H1pwAY8xwcla+b5sfowinLLcPQMjtpQ5CgPKfyVSz9Btf748jcJG8m
         Sezw==
X-Gm-Message-State: AOAM532Z0EujQpRINFO0CxTNNLkRv+yDtHeN7u1+gawz7FVmMdnCWf27
        JhnbwBUPZR7/SblHWE+qXiXuztAoJaM=
X-Google-Smtp-Source: ABdhPJyFC/qmZW1bfbwVsw7VXKJXnVqDfwDyYGTBCetQemHqprLN5RsSOW2r1po4HC3EjZVzo/w2rg==
X-Received: by 2002:a05:600c:587:: with SMTP id o7mr2503463wmd.129.1644506637889;
        Thu, 10 Feb 2022 07:23:57 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id j15sm2245301wmq.19.2022.02.10.07.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 07:23:57 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 6/8] trace-cruncher: Add tc_eprobe class to ft_utiles
Date:   Thu, 10 Feb 2022 17:23:37 +0200
Message-Id: <20220210152339.363943-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210152339.363943-1-y.karadz@gmail.com>
References: <20220210152339.363943-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Define a Python class and helper methods to be used for easy manipulation
of kernel eprobes.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/eprobe.py                            | 13 ++++-
 tracecruncher/ft_utils.py                     | 56 ++++++++++++++++---
 .../tests/1_unit/test_01_ftracepy_unit.py     | 14 +++++
 3 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/examples/eprobe.py b/examples/eprobe.py
index 85b0685..a8be907 100755
--- a/examples/eprobe.py
+++ b/examples/eprobe.py
@@ -11,8 +11,10 @@ import sys
 import tracecruncher.ftracepy as ft
 import tracecruncher.ft_utils as tc
 
-open_probe = ft.eprobe(event='sopen_in', target_system='syscalls',
-                       target_event='sys_enter_openat', fetchargs='file=+0($filename):ustring')
+fields = tc.eprobe_add_string_field(name='file', target_field='filename',
+                                    usr_space=True)
+event = tc.tc_event('syscalls', 'sys_enter_openat')
+eprobe = tc.tc_eprobe(name='sopen_in', target_event=event, fields=fields)
 
 tep = tc.local_tep()
 
@@ -25,5 +27,10 @@ if __name__ == "__main__":
         sys.exit(1)
 
     inst = ft.create_instance(tracing_on=False)
-    open_probe.enable(instance=inst)
+
+    # Enable the probe.
+    eprobe.enable(instance=inst)
+
+    # Subscribe for the kprobe event (using the default function name 'callback')
+    # and trace the user process.
     ft.trace_process(instance=inst, argv=sys.argv[1:])
diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index 67e020f..b27f38a 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -81,22 +81,29 @@ class tc_event:
                               event=self.name)
 
 
-class _kprobe_base(tc_event):
-    def __init__(self, name, func):
+class _dynevent(tc_event):
+    def __init__(self, name):
         """ Constructor.
         """
         super().__init__(system=ft.tc_event_system(), name=name, static=False)
-        self.func = func
-        self.kp = None
+        self.evt = None
         self.evt_id = -1
 
     def register(self):
         """ Register this probe to Ftrace.
         """
-        self.kp.register()
+        self.evt.register()
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
 
 
+class _kprobe_base(_dynevent):
+    def __init__(self, name, func):
+        """ Constructor.
+        """
+        super().__init__(name=name)
+        self.func = func
+
+
 class tc_kprobe(_kprobe_base):
     def __init__(self, name, func, fields):
         """ Constructor.
@@ -104,7 +111,7 @@ class tc_kprobe(_kprobe_base):
         super().__init__(name, func)
         self.fields = fields
         probe = ' '.join('{!s}={!s}'.format(key,val) for (key, val) in self.fields.items())
-        self.kp = ft.kprobe(event=self.name, function=self.func, probe=probe)
+        self.evt = ft.kprobe(event=self.name, function=self.func, probe=probe)
         self.register()
 
 
@@ -190,8 +197,41 @@ class tc_kretval_probe(_kprobe_base):
         """ Constructor.
         """
         super().__init__(name, func)
-        self.kp = ft.kprobe(event=self.name, function=self.func)
-        self.kp.register()
+        self.evt = ft.kprobe(event=self.name, function=self.func)
+        self.register()
+
+
+class tc_eprobe(_dynevent):
+    def __init__(self, name, target_event, fields):
+        """ Constructor.
+        """
+        super().__init__(name=name)
+        self.target_event = target_event
+        self.fields = fields
+        probe = ' '.join('{!s}={!s}'.format(key,val) for (key, val) in self.fields.items())
+        self.evt = ft.eprobe(event=self.name,
+                            target_system=target_event.system,
+                            target_event=target_event.name,
+                            fetch_fields=probe)
+        self.register()
+
+
+def eprobe_add_ptr_field(name, target_field, field_type, offset=0, fields={}):
+    """ Add a pointer data field to the eprobe descriptor.
+    """
+    probe = '+{0}(${1}):{2}'.format(offset, target_field, field_type)
+    return kprobe_add_raw_field(name=name, probe=probe, fields=fields)
+
+
+def eprobe_add_string_field(name, target_field, offset=0, usr_space=False, fields={}):
+    """ Add a string data field to the eprobe descriptor.
+    """
+    f_type = 'ustring' if usr_space else 'string'
+    return eprobe_add_ptr_field(name=name,
+                                target_field=target_field,
+                                field_type=f_type,
+                                offset=offset,
+                                fields=fields)
 
 
 class tc_hist:
diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index 6fdd053..debdd83 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -507,6 +507,20 @@ class EprobeTestCase(unittest.TestCase):
         ret = ep1.is_enabled(instance=inst)
         self.assertEqual(ret, '0')
 
+class EprobeOopTestCase(unittest.TestCase):
+    def test_eprobe(self):
+        fields = tc.eprobe_add_string_field(name='file',
+                                            target_field='filename',
+                                            usr_space=True)
+        self.assertEqual(fields, {'file': '+0($filename):ustring'})
+
+        if kernel_version < (5, 15):
+            return
+
+        event = tc.tc_event('syscalls', 'sys_enter_openat')
+        eprobe = tc.tc_eprobe(name='opn', target_event=event, fields=fields)
+        self.assertEqual(eprobe.evt.probe(), 'file=+0($filename):ustring')
+
 class TracingOnTestCase(unittest.TestCase):
     def test_ON_OF(self):
         ft.tracing_ON()
-- 
2.32.0

