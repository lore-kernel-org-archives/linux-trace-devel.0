Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B1D9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Jan 2022 13:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239292AbiAFNWM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 08:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239473AbiAFNWM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 08:22:12 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C18C061245
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jan 2022 05:22:12 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id l4so1744493wmq.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 06 Jan 2022 05:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qSnaugyGMhNHqebSmy+Y2bS9w/sj3/iXhI+kuKCIRYk=;
        b=dMyMB1AzBl6HjuM8psY8rxc5Q+TOoIcjghPrL8jQ1jQJE5fSxgbCUGFzdof/LOm8C3
         5wNf3AEaW7lYxsRJpyRUq1FuamqA/chE3mVm1TqD3gTuP4BwQVM2NIvfeKwSYelM9WAO
         2yHRgh0UvmKkg1CRw0/4i/DV0lQKL/31tWkhoykDeGIjEfNfbSF/KtCzOVCnG0jU60Ku
         uN4GYyEB+nqECdRi9WDO2ZomoDPiCqTBtvA0dJwPDvdpXFJZEG7FLyyc/N+BYoTBBpa2
         eqNxs58834HBwQ/M+2OsUG6KOXAp0Uh6h4wx10kqGIk7XHCyWKlQnwqp/0qXw8WFfxig
         s1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qSnaugyGMhNHqebSmy+Y2bS9w/sj3/iXhI+kuKCIRYk=;
        b=DI72Z7aM7tLSnDpYTEuIFf7KVoADj73dPdvNUXLhlVzUMRf8FzzawO0AMwmDwD70ZF
         nDWsKYsjHMnbkOakWNBECGofwTokUGSyM1FcFwxv2dGdXYjlC0m1b/1D64tIoMdJqebW
         UWD94wx6t+nSpS9jtSlA5IfLQ3ebE17tICmse7+rDDWPH7qy7hbaY2DVjNEitEs6glzA
         oZ135RWxW61BMZ1Hul1HBPB1PLrcNADj1L/h2K9xztBI47rN7yT+vdvqlRxVJ9FPUNVd
         eUCZ8U6zxrHYmqEBpivrk+NGyBZYXvnyXXIUm5wN5/CGGVjDS+fhSBdTedshMaHBkllx
         4YQA==
X-Gm-Message-State: AOAM532Bi+ORudPl8kAOlfncQd+CPUS79bW7rXn6PjDukLKtqR9J3xKe
        g1e1VAG8aDE8SAb6crlgBeVLs5fp4EM=
X-Google-Smtp-Source: ABdhPJwMYV68Roui5D6NONU1LHSSVKztGZqsA7iS06F8lOxs/MjqWOaDk3xf0COUuuXwV4vNEKUP7g==
X-Received: by 2002:a1c:a517:: with SMTP id o23mr6903079wme.189.1641475330531;
        Thu, 06 Jan 2022 05:22:10 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id o3sm2329283wry.98.2022.01.06.05.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 05:22:10 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] trace-cruncher: Add tests for the khist class
Date:   Thu,  6 Jan 2022 15:21:56 +0200
Message-Id: <20220106132156.168538-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220106132156.168538-1-y.karadz@gmail.com>
References: <20220106132156.168538-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Testing the high-level Python APIs for kernel histograms.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .../tests/1_unit/test_01_ftracepy_unit.py     | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index 7e5b20e..87b2be8 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -10,6 +10,7 @@ import os
 import sys
 import unittest
 import tracecruncher.ftracepy as ft
+import tracecruncher.ft_utils as tc
 
 instance_name = 'test_instance1'
 another_instance_name = 'test_instance2'
@@ -600,5 +601,95 @@ class HistTestCase(unittest.TestCase):
         hist.close(inst)
 
 
+hist_name = 'h2d'
+evt_sys = 'kmem'
+evt_name = 'kmalloc'
+
+axes={'call_site': 'sym',
+      'bytes_req': 'n'}
+weights=['bytes_alloc']
+sort_keys=['bytes_req', 'bytes_alloc']
+sort_dir={'bytes_req': 'desc'}
+
+tgr_file = '{0}/instances/{1}_inst/events/{2}/{3}/trigger'.format(ft.dir(), hist_name, evt_sys, evt_name)
+
+class HistOopTestCase(unittest.TestCase):
+    def test_hist_create(self):
+        evt = tc.event(evt_sys, evt_name)
+        hist = tc.create_khist(name=hist_name, event=evt, axes=axes, weights=weights,
+                               sort_keys=sort_keys, sort_dir=sort_dir)
+        f = open(tgr_file)
+        h_buff = f.read()
+        self.assertTrue('hist:name=h2d' in h_buff)
+        self.assertTrue(':keys=call_site.sym,bytes_req' in h_buff)
+        self.assertTrue(':vals=hitcount,bytes_alloc' in h_buff)
+        self.assertTrue(':sort=bytes_req.descending,bytes_alloc' in str(h_buff))
+
+        f.close()
+
+    def test_hist_ctrl(self):
+        evt = tc.event(evt_sys, evt_name)
+        hist = tc.create_khist(name=hist_name, event=evt, axes=axes, weights=weights,
+                               sort_keys=sort_keys, sort_dir=sort_dir)
+        f = open(tgr_file)
+        h_buff = f.read()
+        self.assertTrue('[paused]' in h_buff)
+
+        hist.start()
+        f.seek(0)
+        h_buff = f.read()
+        self.assertTrue('[active]' in h_buff)
+
+        hist.stop()
+        f.seek(0)
+        h_buff = f.read()
+        self.assertTrue('[paused]' in h_buff)
+
+        hist.resume()
+        f.seek(0)
+        h_buff = f.read()
+        self.assertTrue('[active]' in h_buff)
+
+        h_buff = hist.data()
+        self.assertTrue('Totals:' in h_buff)
+
+        hist.stop()
+        hist.clear()
+        f.seek(0)
+        h_buff = f.read()
+        self.assertTrue('[paused]' in h_buff)
+        h_buff = hist.data()
+        self.assertTrue('Hits: 0' in h_buff)
+        self.assertTrue('Entries: 0' in h_buff)
+        self.assertTrue('Dropped: 0' in h_buff)
+
+        f.close()
+
+    def test_1_detach(self):
+        evt = tc.event(evt_sys, evt_name)
+        hist = tc.create_khist(name=hist_name, event=evt, axes=axes, weights=weights,
+                               sort_keys=sort_keys, sort_dir=sort_dir)
+        self.assertTrue(hist.is_attached())
+        hist.detach()
+        self.assertFalse(hist.is_attached())
+
+    def test_2_attach(self):
+        evt = tc.event(evt_sys, evt_name)
+        hist = tc.find_khist(name=hist_name, event=evt, axes=axes, weights=weights,
+                             sort_keys=sort_keys, sort_dir=sort_dir)
+        self.assertFalse(hist.is_attached())
+        hist.attach()
+        self.assertTrue(hist.is_attached())
+
+    def test_hist_err(self):
+        evt = tc.event(evt_sys, evt_name)
+
+        err = 'Failed to find histogram'
+        with self.assertRaises(Exception) as context:
+            hist = tc.find_khist(name=hist_name, event=evt, axes=axes, weights=weights,
+                                 sort_keys=sort_keys, sort_dir=sort_dir)
+        self.assertTrue(err in str(context.exception))
+
+
 if __name__ == '__main__':
     unittest.main()
-- 
2.32.0

