Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304C5C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Feb 2022 13:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358968AbiBUNVp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 08:21:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358867AbiBUNVp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 08:21:45 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAFB1EEDA
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 05:21:21 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id i11so27668814eda.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 05:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UFnv81s5520jsesZdmYu/nraB0uFtJSNt/KUkycEDjc=;
        b=RKrXfftHHrH+iyc6W/ta/4UlYmENB2nRSldc9vT5IvY1cb41Aod47SolGwyw2QYGwR
         g13ieVFgtKWlIA5rdtTBz/4Lq9iLcQra8zmUhHWL3Zjh/+jWcyYN2sbSMMvMxKFTQFJ2
         e4KDjzq35Z/Xpx08NJYpKpMERst9IP86KndFeq1XOHBUnOMeNDc4vhbN3w0OvNEyRnN+
         87yk/b9ekBDWG8nrWNox7HnQEmXnHIHI4Lb0kMJ8Ti6FSM0gVdwZaNvkH70pMsHFhGKI
         vBm+FnOnr/uDILsceUdlvX3Cc4tkPP9sfDb79j0YSgoABFXSf3KsveEHEb3Z3Ik/5yCA
         NhZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UFnv81s5520jsesZdmYu/nraB0uFtJSNt/KUkycEDjc=;
        b=nT9Pl2eqiNqJntoTMXjGdJiE7fZJ9pJYIP2Bh0s7NETWS18nIA4q3yuinkXDCrrgaC
         ihjrnk9i31aRHPGs8yS+dQ4fbPAYTghIem9HgG7aNeCj11Z5ElOPelh9ySiNJOlTreWX
         LWVPBuHP6WYIApOhEGqkcTMWik+XtvMdT+c79W9aP9Yu0ZnowNcPpoVBFoy6UoCgEUNY
         iv78F4X5Q3v8e2RSdNjEgyi7w+M6noMh9OvQ8/uNiFq/h0dvHAB1Pe5DeIzzuHPF2N10
         v7enpeXVPBr9zftj/jjKAoIuysi2a76I2MuhjPNc9/rYCFAUUUcEq6bUQ5fB4A/zo6yG
         Gcng==
X-Gm-Message-State: AOAM533pD3V43UNyZlmBr6C/5/VYrSgAJAuTFJ4fbYSMOZVZfp0m8xYQ
        aUFK6RsqRc62BgmHLKz+T4VBQYvw8GI=
X-Google-Smtp-Source: ABdhPJxX61GJCQR9K1p5aF3wZ+UNj/1R/3TLwcWDFQi8S2DqV7FyYRN2SHluTjr04YJdpZ1NkSNRPQ==
X-Received: by 2002:a50:9dc3:0:b0:3e5:4093:7b66 with SMTP id l3-20020a509dc3000000b003e540937b66mr21330265edk.174.1645449679407;
        Mon, 21 Feb 2022 05:21:19 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id j23sm5145232eja.204.2022.02.21.05.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 05:21:19 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] trace-cruncher: Fix default function arguments in utils
Date:   Mon, 21 Feb 2022 15:21:05 +0200
Message-Id: <20220221132105.929989-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In Python the argument defaults are set when the function is defined.
Using mutable types as default values will set the desired value only
the first time the function is called.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/ft_utils.py | 50 +++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index b27f38a..f0bed95 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -115,21 +115,24 @@ class tc_kprobe(_kprobe_base):
         self.register()
 
 
-def kprobe_add_raw_field(name, probe, fields={}):
+def kprobe_add_raw_field(name, probe, fields=None):
     """ Add a raw definition of a data field to the probe descriptor.
     """
+    if fields is None:
+        fields = {}
+
     fields[str(name)] = str(probe)
     return fields
 
 
-def kprobe_add_arg(name, param_id, param_type, fields={}):
+def kprobe_add_arg(name, param_id, param_type, fields=None):
     """ Add a function parameter data field to the probe descriptor.
     """
     probe = '$arg{0}:{1}'.format(param_id, param_type)
     return kprobe_add_raw_field(name=name, probe=probe, fields=fields)
 
 
-def kprobe_add_ptr_arg(name, param_id, param_type, offset=0, fields={}):
+def kprobe_add_ptr_arg(name, param_id, param_type, offset=0, fields=None):
     """ Add a pointer function parameter data field to the probe descriptor.
     """
     probe = '+{0}($arg{1}):{2}'.format(offset, param_id, param_type)
@@ -137,7 +140,7 @@ def kprobe_add_ptr_arg(name, param_id, param_type, offset=0, fields={}):
 
 
 def kprobe_add_array_arg(name, param_id, param_type, offset=0,
-                         size=-1, fields={}):
+                         size=-1, fields=None):
     """ Add an array function parameter data field to the probe descriptor.
     """
     if size < 0:
@@ -151,7 +154,7 @@ def kprobe_add_array_arg(name, param_id, param_type, offset=0,
         return kprobe_add_raw_field(name=field_name, probe=probe, fields=fields)
 
 
-def kprobe_add_string_arg(name, param_id, offset=0, usr_space=False, fields={}):
+def kprobe_add_string_arg(name, param_id, offset=0, usr_space=False, fields=None):
     """ Add a string function parameter data field to the probe descriptor.
     """
     p_type = 'ustring' if usr_space else 'string'
@@ -163,7 +166,7 @@ def kprobe_add_string_arg(name, param_id, offset=0, usr_space=False, fields={}):
 
 
 def kprobe_add_string_array_arg(name, param_id, offset=0, usr_space=False,
-                                size=-1, fields={}):
+                                size=-1, fields=None):
     """ Add a string array function parameter data field to the probe descriptor.
     """
     p_type = 'ustring' if usr_space else 'string'
@@ -216,14 +219,14 @@ class tc_eprobe(_dynevent):
         self.register()
 
 
-def eprobe_add_ptr_field(name, target_field, field_type, offset=0, fields={}):
+def eprobe_add_ptr_field(name, target_field, field_type, offset=0, fields=None):
     """ Add a pointer data field to the eprobe descriptor.
     """
     probe = '+{0}(${1}):{2}'.format(offset, target_field, field_type)
     return kprobe_add_raw_field(name=name, probe=probe, fields=fields)
 
 
-def eprobe_add_string_field(name, target_field, offset=0, usr_space=False, fields={}):
+def eprobe_add_string_field(name, target_field, offset=0, usr_space=False, fields=None):
     """ Add a string data field to the eprobe descriptor.
     """
     f_type = 'ustring' if usr_space else 'string'
@@ -235,8 +238,8 @@ def eprobe_add_string_field(name, target_field, offset=0, usr_space=False, field
 
 
 class tc_hist:
-    def __init__(self, name, event, axes, weights=[],
-                 sort_keys=[], sort_dir={}, find=False):
+    def __init__(self, name, event, axes, weights,
+                 sort_keys, sort_dir, find=False):
         """ Constructor.
         """
         self.name = name
@@ -330,9 +333,18 @@ class tc_hist:
         return self.data()
 
 
-def create_hist(name, event, axes, weights=[], sort_keys=[], sort_dir={}):
+def create_hist(name, event, axes, weights=None, sort_keys=None, sort_dir=None):
     """ Create new kernel histogram.
     """
+    if weights is None:
+        weights = []
+
+    if sort_keys is None:
+        sort_keys = []
+
+    if sort_dir is None:
+        sort_dir = {}
+
     try:
         hist = tc_hist(name=name, event=event, axes=axes, weights=weights,
                        sort_keys=sort_keys, sort_dir=sort_dir, find=False)
@@ -343,9 +355,18 @@ def create_hist(name, event, axes, weights=[], sort_keys=[], sort_dir={}):
     return hist
 
 
-def find_hist(name, event, axes, weights=[], sort_keys=[], sort_dir={}):
+def find_hist(name, event, axes, weights=None, sort_keys=None, sort_dir=None):
     """ Find existing kernel histogram.
     """
+    if weights is None:
+        weights = []
+
+    if sort_keys is None:
+        sort_keys = []
+
+    if sort_dir is None:
+        sort_dir = {}
+
     try:
         hist = tc_hist(name=name, event=event, axes=axes, weights=weights,
                        sort_keys=sort_keys, sort_dir=sort_dir, find=True)
@@ -432,10 +453,13 @@ class tc_synth(tc_event):
         return self.synth.repr(event=True, hist_start=True, hist_end=True)
 
 
-def synth_event_item(event, match, fields=[]):
+def synth_event_item(event, match, fields=None):
     """ Create descriptor for an event item (component) of a synthetic event.
         To be used as a start/end event.
     """
+    if fields is None:
+        fields = []
+
     sub_evt = {}
     sub_evt['event'] = event
     sub_evt['fields'] = fields
-- 
2.32.0

