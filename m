Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5519C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Feb 2022 16:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiBGQy0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 11:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357089AbiBGQjQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 11:39:16 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6808EC0401D9
        for <linux-trace-devel@vger.kernel.org>; Mon,  7 Feb 2022 08:39:15 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id s7so4690504edd.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 07 Feb 2022 08:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7caFXxpaFqz4EtyhSF51ykUPHja0w8urgfzVsqd0oFY=;
        b=JHQoOaBtw4Vhuz6l97ySnIk6bScJIg+5y8E560cO10afA9Z7Gn3gQCZPqN+bXEjar0
         PPuXGZAZBP6fxb7HqcfUMWBf67KbHBvUxb5gWC9qWkZtV1sGJEcUTIoPrDPurI6U/cDk
         nJdc6yrufqwy6O85/ZucikLcsc9lVBozVFZY5/YDoYPW4tE17eYjxU6Y/yZVdoSHsk8H
         Wj0ExcGD7iT8E0zAykPFK1V/lSu0f7WeifrufiKA0WmB84vbnDFYpZJ5BUaRvcP89JUw
         QQxvzLPPQ3o+X9S3rQqxiEYLoYIEX18yt4vtMbLrd2kzCkMCMg+YqooJf3aZOf1ThAvz
         +M/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7caFXxpaFqz4EtyhSF51ykUPHja0w8urgfzVsqd0oFY=;
        b=Yq1zJIU5eO9spZiC7QAHu2+Ykoi/4APn042qdaoMMPtBer656M6/oD5gWwBV3cn13u
         m6w8E+1MDi//NU335iN95jc8HJRaQkGTQ2IeMPje46qAwlbOHoNDITloVKQWHmPf995w
         030VTn354FeFQ+YeiavApTqOcZkTR0JE9eZ8RMfIPcJp+VdtCMNW36yZj1215f2NF9dT
         o4F44Ld/U/4BeUuviDdzoYSfxbYy+ybMCzYyEDxVHer2B0dEcIqPk2pwN4Nxabc/HdWi
         K+4AbQh2y/NvM8Sii3eB2f850E94AfK/a9WrFACm5uWmlr6Td8RixT+8nQXMcmAqxO+S
         5jgA==
X-Gm-Message-State: AOAM530sYIydN4P6nxG2lxuBofhfL5p5QMlVd/vtyG2pav6xR5TEB6Qs
        ZpcjF/qIIQ8wyA605mQMy/4Bc16Z5g0=
X-Google-Smtp-Source: ABdhPJxupLWcz8RmRkCF7tjLklPidJ7JsBe7ml9VMCrgUoa7WYcHjgonf2Ayq6Zko6nh0FxhwgBqKg==
X-Received: by 2002:aa7:d898:: with SMTP id u24mr339909edq.60.1644251953641;
        Mon, 07 Feb 2022 08:39:13 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b7sm5415814edv.58.2022.02.07.08.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 08:39:13 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/4] trace-cruncher: Refactor the python classes for kprobes
Date:   Mon,  7 Feb 2022 18:38:59 +0200
Message-Id: <20220207163900.178524-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220207163900.178524-1-y.karadz@gmail.com>
References: <20220207163900.178524-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently the usage of the python classes for kprobes exhibits a pattern
that is inconsistent with the usage of the classes for histograms and
synthetic events. The constructors of the histograms and synth. event
classes will directly register the new events on the system, so once the
corresponding object is created it is ready to be used. However, this is not
the case for the constructors of the classes 'kprobe' and 'kretval_probe'.
For these two classes, the user is expected to explicitly call the 'register'
method before using the new dynamic event. Since such inconsistency can
be confusing, here we refactor the 'kprobe' and 'kretval_probe' classes,
eliminating the 'register' method and moving the registration inside the
constructor.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/ft_utils.py | 136 ++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 71 deletions(-)

diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index 26a7306..741887b 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -81,87 +81,86 @@ class event:
                               event=self.name)
 
 
-class kprobe_base(event):
-    def __init__(self, name, func=''):
+class _kprobe_base(event):
+    def __init__(self, name, func):
         """ Constructor.
         """
         super().__init__(system=ft.tc_event_system(), name=name, static=False)
         self.func = func
         self.kp = None
+        self.evt_id = -1
 
-    def set_function(self, name):
-        """ Set the name of the function to be traced.
+    def register(self):
+        """ Register this probe to Ftrace.
         """
-        self.func = name
-
+        self.kp.register()
+        self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
 
-class kprobe(kprobe_base):
-    def __init__(self, name, func=''):
+class kprobe(_kprobe_base):
+    def __init__(self, name, func, fields):
         """ Constructor.
         """
         super().__init__(name, func)
-        self.fields = {}
-
-    def add_raw_field(self, name, probe):
-        """ Add a raw definition of a data field to this probe.
-        """
-        self.fields[str(name)] = str(probe)
-
-    def add_arg(self, name, param_id, param_type):
-        """ Add a function parameter data field to this probe.
-        """
-        probe = '$arg{0}:{1}'.format(param_id, param_type)
-        self.add_raw_field(name, probe)
+        self.fields = fields
+        probe = ' '.join('{!s}={!s}'.format(key,val) for (key, val) in self.fields.items())
+        self.kp = ft.kprobe(event=self.name, function=self.func, probe=probe)
+        self.register()
 
-    def add_ptr_arg(self, name, param_id, param_type, offset=0):
-        """ Add a pointer function parameter data field to this probe.
-        """
-        probe = '+{0}($arg{1}):{2}'.format(offset, param_id, param_type)
-        self.add_raw_field(name, probe)
+def kprobe_add_raw_field(name, probe, fields={}):
+    """ Add a raw definition of a data field to the probe descriptor.
+    """
+    fields[str(name)] = str(probe)
+    return fields
 
-    def add_array_arg(self, name, param_id, param_type, offset=0, size=-1):
-        """ Add an array function parameter data field to this probe.
-        """
-        if size < 0:
-            size = 10
-
-        ptr_size = ctypes.sizeof(ctypes.c_voidp)
-        for i in range(size):
-            field_name = name + str(i)
-            probe = '+{0}(+{1}'.format(offset, i * ptr_size)
-            probe += '($arg{0})):{1}'.format(param_id, param_type)
-            self.add_raw_field(field_name, probe)
-
-    def add_string_arg(self, name, param_id, offset=0, usr_space=False):
-        """ Add a string function parameter data field to this probe.
-        """
-        p_type = 'ustring' if usr_space else 'string'
-        self.add_ptr_arg(name=name,
-                         param_id=param_id,
-                         param_type=p_type,
-                         offset=offset)
-
-    def add_string_array_arg(self, name, param_id, offset=0, usr_space=False, size=-1):
-        """ Add a string array function parameter data field to this probe.
-        """
-        p_type = 'ustring' if usr_space else 'string'
-        self.add_array_arg(name=name,
-                           param_id=param_id,
-                           param_type=p_type,
-                           offset=offset,
-                           size=size)
+def kprobe_add_arg(name, param_id, param_type, fields={}):
+    """ Add a function parameter data field to the probe descriptor.
+    """
+    probe = '$arg{0}:{1}'.format(param_id, param_type)
+    return kprobe_add_raw_field(name=name, probe=probe, fields=fields)
 
-    def register(self):
-        """ Register this probe to Ftrace.
-        """
-        probe = ' '.join('{!s}={!s}'.format(key,val) for (key, val) in self.fields.items())
+def kprobe_add_ptr_arg(name, param_id, param_type, offset=0, fields={}):
+    """ Add a pointer function parameter data field to the probe descriptor.
+    """
+    probe = '+{0}($arg{1}):{2}'.format(offset, param_id, param_type)
+    return kprobe_add_raw_field(name=name, probe=probe, fields=fields)
 
-        self.kp = ft.kprobe(event=self.name, function=self.func, probe=probe)
-        self.kp.register()
-        self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
+def kprobe_add_array_arg(name, param_id, param_type, offset=0,
+                         size=-1, fields={}):
+    """ Add an array function parameter data field to the probe descriptor.
+    """
+    if size < 0:
+        size = 10
 
+    ptr_size = ctypes.sizeof(ctypes.c_voidp)
+    for i in range(size):
+        field_name = name + str(i)
+        probe = '+{0}(+{1}'.format(offset, i * ptr_size)
+        probe += '($arg{0})):{1}'.format(param_id, param_type)
+        return kprobe_add_raw_field(name=field_name, probe=probe, fields=fields)
 
-def parse_record_array_field(event, record, field, size=-1):
+def kprobe_add_string_arg(name, param_id, offset=0, usr_space=False, fields={}):
+    """ Add a string function parameter data field to the probe descriptor.
+    """
+    p_type = 'ustring' if usr_space else 'string'
+    return kprobe_add_ptr_arg(name=name,
+                              param_id=param_id,
+                              param_type=p_type,
+                              offset=offset,
+                              fields=fields)
+
+def kprobe_add_string_array_arg(name, param_id, offset=0, usr_space=False,
+                                size=-1, fields={}):
+    """ Add a string array function parameter data field to the probe descriptor.
+    """
+    p_type = 'ustring' if usr_space else 'string'
+    return kprobe_add_array_arg(name=name,
+                                param_id=param_id,
+                                param_type=p_type,
+                                offset=offset,
+                                size=size,
+                                fields=fields)
+
+def kprobe_parse_record_array_field(event, record, field, size=-1):
     """ Parse the content of an array function parameter data field.
     """
     if size < 0:
@@ -178,18 +177,13 @@ def parse_record_array_field(event, record, field, size=-1):
     return arr
 
 
-class kretval_probe(kprobe_base):
-    def __init__(self, name, func=''):
+class kretval_probe(_kprobe_base):
+    def __init__(self, name, func):
         """ Constructor.
         """
         super().__init__(name, func)
-
-    def register(self):
-        """ Register this probe to Ftrace.
-        """
         self.kp = ft.kprobe(event=self.name, function=self.func)
         self.kp.register()
-        self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
 
 
 class khist:
-- 
2.32.0

