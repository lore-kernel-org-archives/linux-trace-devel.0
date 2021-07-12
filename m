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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE42BC07E9A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A55136101E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhGLMKQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Jul 2021 08:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbhGLMKP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Jul 2021 08:10:15 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D8DC0613E8
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:07:27 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ec55so2769050edb.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=axU+xjMftFNU2eR+Ctufg4ij0wvLzt7ZOIt23NLj/Hw=;
        b=fBpoV4ZcotPaHuy9xvONEV2zsr7D6UJPtpyMkJig4d9He+iYqMvVq2Z9W4+DEaVdTV
         JZ/VB1w1XwWuUpH584kDd4UOoGrx8Ah4r4i5Nel9BYdFqd8L81DpCRRcLLiuzLC4HGTd
         IcqnOl/3H6NL3ISPpnQZY1DdX/b4QBww0HnMCnH2GMIvQUhQVAnYkweT9lRY5D6tTrS8
         poluXsgw+i9J0faaza9vLJXa4bggujBxz46A3c8LbpC3nV+5+UDhysnwGEdCORtdXelj
         ACU0M9bkboKhBssJ/ARnTI8SJlAiG2OoAuC/pN1hSUaKTUv8te/pGa3tk68+ES9go++e
         EepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=axU+xjMftFNU2eR+Ctufg4ij0wvLzt7ZOIt23NLj/Hw=;
        b=AIkIa8AanlZwxQtYjnzWwZpmDNHj6hQ7zTjIDo7LW/uhOBrRyJxoqzUmjhKhG5SAIo
         lFKTLEdoudM5Dj1YVWI4bXeMbYG1v0go9Z3EQ1QoAxGGleYfF7GKY91NUinliSviSkz4
         nbX4cSl5l+Yb8zqv3g3C4o/7gn3686y5vKuW+pUrweh4jtvQ5chZuLKohhmePwDwuUJ/
         XpfLwyue7lrGoeVHvRC81Eq6HRHfVydWB2D9TaCGznC8OiS3L6b0TjFxJ+gbPvf6RgCV
         QbPCL78v8J+yKcUNKcft0N9mmh7ijBwVNWgzKMnYulxf/c9csk3cIbp/jcr2L+wbFGJ9
         4B9w==
X-Gm-Message-State: AOAM530hAE8RvWlRGNBj2hyDWgGHJno6q5F+SdOICr3g25wzXNVA+knZ
        FiM2fIwt/G7Mo8iRDxszaW4b7lOdfpU=
X-Google-Smtp-Source: ABdhPJxpHNSwRNTrzhl2GYOBMWKkvEGv+l6w1BI8mfa7Wjqfd+xLL+FVLof5IsEN1W21TwjksA6nhg==
X-Received: by 2002:aa7:cd96:: with SMTP id x22mr35881159edv.102.1626091645614;
        Mon, 12 Jul 2021 05:07:25 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.98])
        by smtp.gmail.com with ESMTPSA id ee29sm2900809edb.39.2021.07.12.05.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:07:25 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/3] trace-cruncher: Add events to utils
Date:   Mon, 12 Jul 2021 15:07:05 +0300
Message-Id: <20210712120706.221921-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210712120706.221921-1-y.karadz@gmail.com>
References: <20210712120706.221921-1-y.karadz@gmail.com>
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
index eae161c..5b4f2f2 100644
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
+class kprobe_base(event):
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
+class kprobe(kprobe_base):
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
+class kretval_probe(kprobe_base):
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

