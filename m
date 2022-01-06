Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66DEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Jan 2022 13:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239441AbiAFNWM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 08:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiAFNWL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 08:22:11 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23D6C061245
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jan 2022 05:22:10 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id i22so4689694wrb.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 06 Jan 2022 05:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KfOBcjvG/FdMyYfeavYMJxanZ671mMYUw12xivxKaJg=;
        b=N9663iAjVQpsgXpETXhUd1KDSvwj1ksVKHiolxuugtmxEPjZffynyGReq0jx2M9nDR
         fB+AqF4liGtyh06lWFrmmcYJfeY4yDFq0OJ8tJ8Kf6+G0oTkWpNRzT5PbNE7IRYoV7HU
         6SI3OZYTHBCxywGaZ66kimwIVBFMW3oqw+/ktwBBS+B1T9A2ar5WYKk7vbWSD05axvLn
         Mfa1A3BncI42WDui1MHdbtGTq7fMr+/VBDwup6dUTprjLIyFP6pv60alPqaEGlCeo3xw
         klxW6YmcQEmeTaa0mclrylfymK6BumKT+XWXv4eXm845ufWokzM3LQYItVfpeUSqEPpr
         URMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KfOBcjvG/FdMyYfeavYMJxanZ671mMYUw12xivxKaJg=;
        b=FDfATqlNQQcsZgsvOxoSU94aSQoBgCQ/gbV4WrgqkPzpOKRs+2ifAtUHtCv3mUv9lP
         hggoW6VUsWZbuE/9f60k8vwxGoihaKbxN+72uhECV5jSXhGbk2HiXYgXcPMmNR9AopUG
         GTZMy5zLB9hyQW0VtkTEi+rnI8usHfE1hUC4Q6h2RfnSM8I5U7VbBjj5xiucyZ8cmuV8
         KrHpK+xpsMofdrvqe7DYPEH7YUyEkIU4J4F4/sWIjq0p0Zds2yDSxPcuxiQF7d8NOL8n
         zxgkpSHh+AwSfIYgMgyHGy9Mu9in6wtaGEQd9wU1gEqdK/DhZ53QcZtK/diKJO1XyXn9
         +Lmw==
X-Gm-Message-State: AOAM531UeP999X/LhzCBkr05nvTurtlfa/oEZ4Zsx7rxguWj0LETeebl
        1WbHXOodBVhXrG/BG4pyYYRu72Yw/gI=
X-Google-Smtp-Source: ABdhPJz11ysuQWcJpnL2rKvZQR4c2R/YzLshoemkiTIRF9xJn+TNyrtINRlcmbCPfX2Z8k+i3XDTCQ==
X-Received: by 2002:adf:fc50:: with SMTP id e16mr6456483wrs.554.1641475328952;
        Thu, 06 Jan 2022 05:22:08 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id o3sm2329283wry.98.2022.01.06.05.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 05:22:08 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/3] trace-cruncher: Add khist class to ft_utiles
Date:   Thu,  6 Jan 2022 15:21:54 +0200
Message-Id: <20220106132156.168538-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Define a Python class to be used for easy manipulation of kernel
histograms.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/ft_utils.py | 124 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index cae54b0..ed4bdcd 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -210,3 +210,127 @@ class kretval_probe(kprobe_base):
         """
         self.kp = ft.register_kprobe(event=self.name, function=self.func);
         self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
+
+
+class khist:
+    def __init__(self, name, event, axes, weights=[],
+                 sort_keys=[], sort_dir={}, find=False):
+        """ Constructor.
+        """
+        self.name = name
+        self.inst = None
+
+        inst_name = name+'_inst'
+        if find:
+            self.inst = ft.find_instance(name=inst_name)
+            self.attached = False
+        else:
+            self.inst = ft.create_instance(name=inst_name)
+            self.attached = True
+
+        self.hist = ft.hist(name=name,
+                            system=event.system,
+                            event=event.name,
+                            axes=axes)
+
+        for v in weights:
+            self.hist.add_value(value=v)
+
+        self.hist.sort_keys(keys=sort_keys)
+
+        for key, val in sort_dir.items():
+            self.hist.sort_key_direction(sort_key=key,
+                                         direction=val)
+
+        self.trigger = '{0}/events/{1}/{2}/trigger'.format(self.inst.dir(),
+                                                           event.system,
+                                                           event.name)
+
+        if not find:
+            # Put the kernel histogram on 'standby'
+            self.hist.stop(self.inst)
+
+    def __del__(self):
+        """ Destructor.
+        """
+        if self.inst and self.attached:
+            self.clear()
+
+    def start(self):
+        """ Start accumulating data.
+        """
+        self.hist.resume(self.inst)
+
+    def stop(self):
+        """ Stop accumulating data.
+        """
+        self.hist.stop(self.inst)
+
+    def resume(self):
+        """ Continue accumulating data.
+        """
+        self.hist.resume(self.inst)
+
+    def data(self):
+        """ Read the accumulated data.
+        """
+        return self.hist.read(self.inst)
+
+    def clear(self):
+        """ Clear the accumulated data.
+        """
+        self.hist.clear(self.inst)
+
+    def detach(self):
+        """ Detach the object from the Python module.
+        """
+        ft.detach(self.inst)
+        self.attached = False
+
+    def attach(self):
+        """ Attach the object to the Python module.
+        """
+        ft.attach(self.inst)
+        self.attached = True
+
+    def is_attached(self):
+        """ Check if the object is attached to the Python module.
+        """
+        return self.attached
+
+    def __repr__(self):
+        """ Read the descriptor of the histogram.
+        """
+        with open(self.trigger) as f:
+            return f.read().rstrip()
+
+    def __str__(self):
+        return self.data()
+
+
+def create_khist(name, event, axes, weights=[],
+                 sort_keys=[], sort_dir={}):
+    """ Create new kernel histogram.
+    """
+    try:
+        hist = khist(name=name, event=event, axes=axes, weights=weights,
+                     sort_keys=sort_keys, sort_dir=sort_dir, find=False)
+    except Exception as err:
+        msg = 'Failed to create histogram \'{0}\''.format(name)
+        raise RuntimeError(msg) from err
+
+    return hist
+
+
+def find_khist(name, event, axes, instance=None,
+               weights=[], sort_keys=[], sort_dir={}):
+    """ Find existing kernel histogram.
+    """
+    try:
+        hist = khist(name=name, event=event, axes=axes, weights=weights,
+                     sort_keys=sort_keys, sort_dir=sort_dir, find=True)
+    except Exception as err:
+        msg = 'Failed to find histogram \'{0}\''.format(name)
+        raise RuntimeError(msg) from err
+
+    return hist
-- 
2.32.0

