Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 901BEC07E96
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Jul 2021 13:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 720BF61459
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Jul 2021 13:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhGHNzm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Jul 2021 09:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbhGHNzm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Jul 2021 09:55:42 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC0DC061574
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Jul 2021 06:52:59 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id b2so9771593ejg.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Jul 2021 06:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZGSiSJFlPrAjk5k6XV8HTFEsLLbB43WFjQH3G3F68dw=;
        b=pNZn3SgUsVyKkx6IBEW75kVm5VspLwUOe/2jTIOoyI0lMuzmckMRBdCG49AHE79ETJ
         DGpbNeswQfLNPdrwFGszKlnrOU/0CF2us3s9qOyAZOxOtIakWAfn7i9A9mWOTmim1V2s
         D6oAI4Ms541s7SEK+5bII4DzTUQvDNkt4Fyuqwq36Y8/oGml/W0OgSQzs3Ap24uNaSYD
         GTVrhRM2MfgD++V6aIsbgKEUKwU6yfi1cFC55laBHIXRBnNKH5E0HzZsVlnZiSR2QtGy
         QZQUCq9qW692e4o69ZnmYRThUhhnGp7gnYdA5halYyEuWzWGeRJtPpiQWNIfOTcmL3n5
         gQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZGSiSJFlPrAjk5k6XV8HTFEsLLbB43WFjQH3G3F68dw=;
        b=ghWMYBygxbc4wRSOYIUqXcPoRHXp1DhFA/I8mRSiMiUHIlTB9soPu0N9LnxqHbBX49
         R4VAzACaXspmD/4hJwdC5Anz308F5kAz9U2bEFMUMbNsT1HmHOKhsj/5TNQvELJOPcTZ
         tj6spFmB7mC1phf/ETzYQzn6tlq7iZo3a9dsgFXDj+7hgoDvExA2z2R7+9HEJduM2L22
         U1Ta4WygO3ADQJIcUWUUuv1dI17H4uG0PTWkRpW689JoOcrMuzBQ/VGGIvj1Wxi76Frh
         TxAxtL1sQFcklNPVrzsRamXvrz2hS1J9qBk5jz6u8vGMPBnB5NYSfgLkNJoNW7Ycv9zy
         dVGg==
X-Gm-Message-State: AOAM531TpM5uRm6yqxSeQP4osoIR+uCPOHGeL6NumlSbY+ig5ftUtm3P
        IFqUccRbLmAKKq+VPTOshxtoQZB0R4w=
X-Google-Smtp-Source: ABdhPJxHbcrlMSsrrFHygnJFthApcddl9iPKYfws7kn54YqgDBOfdKGm5ypd1CBlWcNVTyda3bjUkA==
X-Received: by 2002:a17:906:7f95:: with SMTP id f21mr31511728ejr.548.1625752377808;
        Thu, 08 Jul 2021 06:52:57 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.215])
        by smtp.gmail.com with ESMTPSA id hz7sm996487ejc.27.2021.07.08.06.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 06:52:57 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] trace-cruncher: Add events to utils
Date:   Thu,  8 Jul 2021 16:52:42 +0300
Message-Id: <20210708135243.25229-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210708135243.25229-1-y.karadz@gmail.com>
References: <20210708135243.25229-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Define a hierarchy of Python classes, to be used for easy manipulation
of Staic events and Kprobes.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/ft_utils.py | 182 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 182 insertions(+)

diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index eae161c..4c083ef 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -6,6 +6,7 @@ Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
 
 import sys
 import time
+import ctypes
 
 from . import ftracepy as ft
 
@@ -17,3 +18,184 @@ def find_event_id(system, event):
     tep.init_local(dir=ft.dir(), systems=[system]);
 
     return tep.get_event(system=system, name=event).id()
+
+
+class event:
+    def __init__(self, system, name, static=True):
+        """ Constructor.
+        """
+        self.system = system
+        self.name = name
+        self.instance_list = []
+        if static:
+            self.evt_id = find_event_id(system, name)
+        else:
+            self.evt_id = -1
+
+    def id(self):
+        """ Retrieve the unique ID of the kprobe event.
+        """
+        return int(self.evt_id)
+
+    def enable(self, instance=None):
+        """ Enable this event.
+        """
+        if instance is None:
+            ft.enable_event(system=self.system, event=self.name)
+            self.instance_list.append('top')
+        else:
+            ft.enable_event(instance=instance, system=self.system, event=self.name)
+            self.instance_list.append(instance)
+
+        self.instance_list = list(set(self.instance_list))
+
+    def disable(self, instance=None):
+        """ Disable this event.
+        """
+        if instance is None:
+            ft.disable_event(system=self.system, event=self.name)
+            self.instance_list.remove('top')
+        else:
+            ft.disable_event(instance=instance,system=self.system, event=self.name)
+            self.instance_list.remove(instance)
+
+    def set_filter(self, filter, instance=None):
+        """ Define a filter for this event.
+        """
+        if instance is None:
+            ft.set_event_filter(system=self.system,
+                                event=self.name,
+                                filter=filter)
+        else:
+            ft.set_event_filter(instance=instance,
+                                system=self.system,
+                                event=self.name,
+                                filter=filter)
+
+    def clear_filter(self, instance=None):
+        """ Define the filter for this event.
+        """
+        if instance is None:
+            ft.clear_event_filter(system=self.system,
+                                  event=self.name)
+        else:
+            ft.clear_event_filter(instance=instance,
+                                  system=self.system,
+                                  event=self.name)
+
+
+class kprobe(event):
+    def __init__(self, name, func=''):
+        """ Constructor.
+        """
+        super().__init__(system=ft.tc_event_system(), name=name, static=False)
+        self.func = func
+
+    def set_function(self, name):
+        """ Set the name of the function to be traced.
+        """
+        self.func = name
+
+    def unregister(self):
+        """ Unregister this probe from Ftrace.
+        """
+        inst_list = self.instance_list.copy()
+        for instance in inst_list:
+            self.disable(instance)
+
+        ft.unregister_kprobe(event=self.name);
+
+
+class kprobe(kprobe):
+    def __init__(self, name, func=''):
+        """ Constructor.
+        """
+        super().__init__(name, func)
+        self.fields = {}
+
+    def add_raw_field(self, name, probe):
+        """ Add a raw definition of a data field to this probe.
+        """
+        self.fields[str(name)] = str(probe)
+
+    def add_arg(self, name, param_id, param_type):
+        """ Add a function parameter data field to this probe.
+        """
+        probe = '$arg{0}:{1}'.format(param_id, param_type)
+        self.add_raw_field(name, probe)
+
+    def add_ptr_arg(self, name, param_id, param_type, offset=0):
+        """ Add a pointer function parameter data field to this probe.
+        """
+        probe = '+{0}($arg{1}):{2}'.format(offset, param_id, param_type)
+        self.add_raw_field(name, probe)
+
+    def add_array_arg(self, name, param_id, param_type, offset=0, size=-1):
+        """ Add a array parameter data field to this probe.
+        """
+        if size < 0:
+            size = 10
+
+        ptr_size = ctypes.sizeof(ctypes.c_voidp)
+        for i in range(size):
+            field_name = name + str(i)
+            probe = '+{0}(+{1}'.format(offset, i * ptr_size)
+            probe += '($arg{0})):{1}'.format(param_id, param_type)
+            self.add_raw_field(field_name, probe)
+
+    def add_string_arg(self, name, param_id, offset=0, usr_space=False):
+        """ Add a pointer function parameter data field to this probe.
+        """
+        p_type = 'ustring' if usr_space else 'string'
+        self.add_ptr_arg(name=name,
+                         param_id=param_id,
+                         param_type=p_type,
+                         offset=offset)
+
+    def add_string_array_arg(self, name, param_id, offset=0, usr_space=False, size=-1):
+        """ Add a string array parameter data field to this probe.
+        """
+        p_type = 'ustring' if usr_space else 'string'
+        self.add_array_arg(name=name,
+                           param_id=param_id,
+                           param_type=p_type,
+                           offset=offset,
+                           size=size)
+
+    def register(self):
+        """ Register this probe to Ftrace.
+        """
+        probe = ' '.join('{!s}={!s}'.format(key,val) for (key, val) in self.fields.items())
+
+        ft.register_kprobe(event=self.name, function=self.func, probe=probe);
+        self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
+
+
+def parse_record_array_field(event, record, field, size=-1):
+    """ Register this probe to Ftrace.
+    """
+    if size < 0:
+        size = 10
+
+    arr = []
+    for i in range(size):
+        field_name = field + str(i)
+        val = event.parse_record_field(record=record, field=field_name)
+        if (val == '(nil)'):
+            break
+        arr.append(val)
+
+    return arr
+
+
+class kretval_probe(kprobe):
+    def __init__(self, name, func=''):
+        """ Constructor.
+        """
+        super().__init__(name, func)
+
+    def register(self):
+        """ Register this probe to Ftrace.
+        """
+        ft.register_kprobe(event=self.name, function=self.func);
+        self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
-- 
2.27.0

