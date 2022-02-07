Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA595C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Feb 2022 16:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiBGQy4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 11:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357064AbiBGQjO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 11:39:14 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C439C0401D2
        for <linux-trace-devel@vger.kernel.org>; Mon,  7 Feb 2022 08:39:13 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id l25so10944833eda.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 07 Feb 2022 08:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LBorQjXs70DN6wgM58LhoarVcXmwRYF2XLFhlXFRxDo=;
        b=iIgSeJUWXgEE5tcJ7dZxHfNs2LPyNdyTWM1hCyGN58DhcZv2ae4VNvRW2eJQOER6z4
         r392OBvwXC5Ta0qNmLbSKMGGgfMiH6hIKGP+b6waVAbL5Kd0nTDcksPXWXNvRItr9zod
         vBLlb+bkDOUJ74tu7I8AVoLep3OzHiDyW2OIV+kbKtiU2VHuTrImTtu7R8dX8ZpOFmSH
         m8s8mfBkXXmZLSmgLf+8+xwz6wMLN7r1irHsSetb8CigH8UO+Lk0ddEv+E+yI+JgWIgG
         hJZOi9A5YxIFBDptMQiAVNempkArVyyb89OdV+a3wrAfs+5M4+Hoq0HNA4F3lDu+hTxY
         bwuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LBorQjXs70DN6wgM58LhoarVcXmwRYF2XLFhlXFRxDo=;
        b=K8BnF8i5fsk0b84OC5vF4gwD69/CLqKpiKjPNPBIO7PcSfMTp0r14E+iJxl4olEizI
         /YWNe8WGrfrPlawRWlB7Z6dA2r5PsYJE7cIc9vdA4M933/SxPebfN0Gr15ww2yei/QBm
         FCXRSiJLdhA+bsmhhBHEvj+f5DCh8uPDr3URehiJFRIrPIj/b4VHc6i0QByZbDjTBuWN
         siJE7FBUtxO8fRf6bFePvynqDOFvIx5rScaLSyYXsxJXPrEWYrIo2VyAYSjQ64HIcV4V
         JAtqS9slv7BicoyDX5p1HPIbIqnL0JgyB/gNwOOHHBv/J/pWeA2xjDXOu6QRUxHiX009
         vPvA==
X-Gm-Message-State: AOAM5337CbghdPMDHh5IsX31UCyQS371CtQU6Nn3OaeDMNA5cjrNU5/l
        vm5LP1rDLx/1jOmd3no1KPuwzLAqYUo=
X-Google-Smtp-Source: ABdhPJxfGbn9AXMR9OWeZ+wpRFHVeE0TKBBEagdtu3KUjUbViy5n69EqadfrMrai5ryZCEBKu/uX0g==
X-Received: by 2002:a05:6402:35ca:: with SMTP id z10mr314441edc.43.1644251951693;
        Mon, 07 Feb 2022 08:39:11 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b7sm5415814edv.58.2022.02.07.08.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 08:39:10 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/4] trace-cruncher: Fix coments & style in ft_utils.py
Date:   Mon,  7 Feb 2022 18:38:57 +0200
Message-Id: <20220207163900.178524-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

No functional changes are introduced by this patch.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/ft_utils.py | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index 26978f3..26a7306 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -14,8 +14,8 @@ from . import ftracepy as ft
 def local_tep():
     """ Get the "tep" event of the current system (local).
     """
-    tep = ft.tep_handle();
-    tep.init_local(dir=ft.dir());
+    tep = ft.tep_handle()
+    tep.init_local(dir=ft.dir())
 
     return tep
 
@@ -23,8 +23,8 @@ def local_tep():
 def find_event_id(system, event):
     """ Get the unique identifier of a trace event.
     """
-    tep = ft.tep_handle();
-    tep.init_local(dir=ft.dir(), systems=[system]);
+    tep = ft.tep_handle()
+    tep.init_local(dir=ft.dir(), systems=[system])
 
     return tep.get_event(system=system, name=event).id()
 
@@ -51,7 +51,7 @@ class event:
             self.evt_id = -1
 
     def id(self):
-        """ Retrieve the unique ID of the kprobe event.
+        """ Retrieve the unique ID of the event.
         """
         return int(self.evt_id)
 
@@ -74,7 +74,7 @@ class event:
                             filter=filter)
 
     def clear_filter(self, instance=ft.no_arg()):
-        """ Define the filter for this event.
+        """ Clear the filter for this event.
         """
         ft.clear_event_filter(instance=instance,
                               system=self.system,
@@ -120,7 +120,7 @@ class kprobe(kprobe_base):
         self.add_raw_field(name, probe)
 
     def add_array_arg(self, name, param_id, param_type, offset=0, size=-1):
-        """ Add a array parameter data field to this probe.
+        """ Add an array function parameter data field to this probe.
         """
         if size < 0:
             size = 10
@@ -133,7 +133,7 @@ class kprobe(kprobe_base):
             self.add_raw_field(field_name, probe)
 
     def add_string_arg(self, name, param_id, offset=0, usr_space=False):
-        """ Add a pointer function parameter data field to this probe.
+        """ Add a string function parameter data field to this probe.
         """
         p_type = 'ustring' if usr_space else 'string'
         self.add_ptr_arg(name=name,
@@ -142,7 +142,7 @@ class kprobe(kprobe_base):
                          offset=offset)
 
     def add_string_array_arg(self, name, param_id, offset=0, usr_space=False, size=-1):
-        """ Add a string array parameter data field to this probe.
+        """ Add a string array function parameter data field to this probe.
         """
         p_type = 'ustring' if usr_space else 'string'
         self.add_array_arg(name=name,
@@ -156,13 +156,13 @@ class kprobe(kprobe_base):
         """
         probe = ' '.join('{!s}={!s}'.format(key,val) for (key, val) in self.fields.items())
 
-        self.kp = ft.kprobe(event=self.name, function=self.func, probe=probe);
-        self.kp.register();
+        self.kp = ft.kprobe(event=self.name, function=self.func, probe=probe)
+        self.kp.register()
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
 
 
 def parse_record_array_field(event, record, field, size=-1):
-    """ Register this probe to Ftrace.
+    """ Parse the content of an array function parameter data field.
     """
     if size < 0:
         size = 10
@@ -187,8 +187,8 @@ class kretval_probe(kprobe_base):
     def register(self):
         """ Register this probe to Ftrace.
         """
-        self.kp = ft.kprobe(event=self.name, function=self.func);
-        self.kp.register();
+        self.kp = ft.kprobe(event=self.name, function=self.func)
+        self.kp.register()
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
 
 
@@ -200,7 +200,7 @@ class khist:
         self.name = name
         self.inst = None
 
-        inst_name = name+'_inst'
+        inst_name = name + '_inst'
         if find:
             self.inst = ft.find_instance(name=inst_name)
             self.attached = False
-- 
2.32.0

