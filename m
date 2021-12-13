Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8453DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Dec 2021 14:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239512AbhLMOhj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Dec 2021 09:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239515AbhLMOhe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Dec 2021 09:37:34 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784CDC06173F
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 06:37:33 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id r25so52320160edq.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 06:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IfX9rum4ElLer9ukq0HT9g7zGFPx5pLeyllgFUJXi3A=;
        b=I66g1FAxehdSyMIpmrd0Ies44Gv6adMgsDSphEfCtwG+Tn5EuxA+GE9PzK8jcq9VJc
         EPfZZyG5C3YkkFzScGVbOL8Utbh3UaLXcqni5hwL2HtS59/U5wJZt1NSuBjZ8SCcVOJY
         dypHVDoMNEmzFjJaYv8ip5Vw9ho9H8097hTiobtS+8/jABK86LE3sGQnvZB9XvVeD5T3
         /jrB0Glh8xGETDGshO0cvSfFaD8peTZornuPCWviMLL0VjGm3GyDDyv19S2aJI+bYkXF
         NotksJPDCe7HVh7WWng3KkRi1VbBlY8YM4heSTNkcQBTVyV2+dPOEmQcj1VOHyDgMl6I
         wWmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IfX9rum4ElLer9ukq0HT9g7zGFPx5pLeyllgFUJXi3A=;
        b=GVpNwin1y5lv6pVCP5yZYWXF9ivNfb+ArXO7INLMO68155GooqQfUS98IrSblQjRhT
         j6xg2lW4OI6vS+B6BgzEZb9Zo1RTbjyObkwQ5Pe5dN1u4/v/kb5upiJhZT9rQbzUJg91
         f9FKVP1tQrtGLqpPL2HQgAhoj0qazar1GCpkZVYgnp0EyGQWhjQAvTEIyJK5LQcgZBcy
         rKmeunIxuP23zFIWpKo7WcG7NEzFdfMVRbFzO2ST4UdHJRxCeD2etmbsD/7kFW7NjYt1
         f6RrmFH3ZSxu8l8DzHd1mk8u7GeOjffgfLq/DvgqvGTyW5AqszqrwMCytQ5bSJHS0rR3
         O7OQ==
X-Gm-Message-State: AOAM530JbGB+2jYo+LxNFuzxBmD11mezx39x/tuGbEcXY9lHYd6vwcY/
        7whxvZ22Ey9a+qJ2m5U/6tT+p4dK5Xk=
X-Google-Smtp-Source: ABdhPJwo3O9R8QmLNSrpB0HV6ZIOsoCJ94hVBhDBH/jOPI3zuL350cf/b1Q6LnH2m4SsaSdT9bg3xQ==
X-Received: by 2002:aa7:c347:: with SMTP id j7mr65591749edr.272.1639406251675;
        Mon, 13 Dec 2021 06:37:31 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id el20sm5851213ejc.40.2021.12.13.06.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 06:37:31 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] trace-cruncher: Add histogram tests
Date:   Mon, 13 Dec 2021 16:37:19 +0200
Message-Id: <20211213143719.116943-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

APIs for kernel tracing histograms have been added.
Here we add the corresponding test cases.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .../tests/1_unit/test_01_ftracepy_unit.py     | 102 ++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index 8a5881e..7b344e2 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -480,5 +480,107 @@ class TracingOnTestCase(unittest.TestCase):
         self.assertTrue(err in str(context.exception))
 
 
+class HistTestCase(unittest.TestCase):
+    def test_hist_create(self):
+        inst = ft.create_instance(instance_name)
+        sys = 'kmem'
+        evt = 'kmalloc'
+        tgr_file = inst.dir() + '/events/' +  sys + '/' + evt + '/trigger'
+
+        f = open(tgr_file)
+
+        hist = ft.hist(system=sys, event=evt, key='call_site', type='sym')
+        hist.stop(inst)
+        h_buff = f.read()
+        self.assertTrue('hist:keys=call_site.sym' in h_buff)
+        hist.close(inst)
+
+        hist = ft.hist(system=sys, event=evt,
+                       axes={'call_site': 'sym',
+                             'bytes_alloc': 'n'})
+        hist.stop(inst)
+        f.seek(0)
+        h_buff = f.read()
+        self.assertTrue('hist:keys=call_site.sym,bytes_alloc' in h_buff)
+        hist.close(inst)
+
+        hist = ft.hist(name='h2d', system=sys, event=evt,
+                       axes={'bytes_req': 'log',
+                             'bytes_alloc': 'h'})
+        hist.stop(inst)
+        f.seek(0)
+        h_buff = f.read()
+        self.assertTrue('hist:name=h2d:keys=bytes_req.log2,bytes_alloc.hex' in h_buff)
+
+        hist.close(inst)
+        f.close()
+
+    def test_hist_setup(self):
+        inst = ft.create_instance(instance_name)
+        sys = 'kmem'
+        evt = 'kmalloc'
+        tgr_file = inst.dir() + '/events/' +  sys + '/' + evt + '/trigger'
+
+        f = open(tgr_file)
+
+        hist = ft.hist(system=sys, event=evt,
+                       axes={'call_site': 'sym',
+                             'bytes_alloc': 'n'})
+
+        hist.add_value(value='bytes_req')
+        hist.stop(inst)
+        h_buff = f.read()
+        self.assertTrue(':vals=hitcount,bytes_req' in h_buff)
+
+        hist.sort_keys(keys=['bytes_req', 'bytes_alloc'])
+        hist.stop(inst)
+        f.seek(0)
+        h_buff = f.read()
+        self.assertTrue(':sort=bytes_req,bytes_alloc' in h_buff)
+
+        hist.sort_key_direction('bytes_req', 'desc')
+        hist.stop(inst)
+        f.seek(0)
+        h_buff = f.read()
+        self.assertTrue(':sort=bytes_req.descending,bytes_alloc' in str(h_buff))
+
+        hist.close(inst)
+        f.close()
+
+    def test_hist_ctrl(self):
+        inst = ft.create_instance(instance_name)
+        sys = 'kmem'
+        evt = 'kmalloc'
+        tgr_file = inst.dir() + '/events/' +  sys + '/' + evt + '/trigger'
+
+        f = open(tgr_file)
+
+        hist = ft.hist(system=sys, event=evt,
+                       axes={'call_site': 'sym',
+                             'bytes_alloc': 'n'})
+
+        hist.start(inst)
+        h_buff = f.read()
+        self.assertTrue('[active]' in h_buff)
+
+        hist.stop(inst)
+        f.seek(0)
+        h_buff = f.read()
+        self.assertTrue('[paused]' in h_buff)
+
+        hist.resume(inst)
+        f.seek(0)
+        h_buff = f.read()
+        self.assertTrue('[active]' in h_buff)
+
+        h_buff = hist.read(inst)
+        self.assertTrue('Totals:' in h_buff)
+
+        hist.close(inst)
+        f.seek(0)
+        h_buff = f.read()
+        self.assertTrue('Available triggers:' in h_buff)
+        f.close()
+
 if __name__ == '__main__':
     unittest.main()
-- 
2.32.0

