Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97068C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 06:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236444AbiA0GKB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 01:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiA0GKA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 01:10:00 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D899C061714
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 22:10:00 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ah7so3465546ejc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 22:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4KgOtkvuvTkzuUIqbiHn7R6Q39mpRL5X00UfsZsDqjo=;
        b=NmXasai+iDsxYkOM6fKQ6XySvXBMcZHMgO1lz5rS5u9aG+K8T/Sk8W/hRnTbtgK8DU
         +QGX3YCSt4D1g6P7LwpiiEqQhiNPFovDPwmPfK83li+4orZi57pjQgHHjsxikEKi5ZWR
         TDDc52YdZ/UOHvfQKQj6+wpDj1DxWTHjheTLwcsaJ2V+RbzAK/af2Nlsf/LtRmkL23Fy
         B7B9x6nshdz4UYdHnNPtJsYJsx4Xp8BmrokIZb8EkcHwV8GynRRZM54szCXSkAe20IJs
         p8bl1+z8fmCDndmbqxe6UhQdSRDJf2KIPKqeF7V7qm81Bjh/HWuUbsXCEJ7ax9LYTAzM
         z78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4KgOtkvuvTkzuUIqbiHn7R6Q39mpRL5X00UfsZsDqjo=;
        b=2kP1y8ycXEQ17TrEHgQSsUhlFHf8fdIYHHfxvYmVqgCQY0MDwl7+E2WyAJyklWe21j
         a/Dgi6mQV8fky40RSKebxOOpdy5yzHjwUjijr7k5JUDRFQJGGCmFj5OAz4s3drDgWqNj
         PPoJU7dK9D/R4VpwHuSFuIz+E0s0WJPmIcyKjTj4rRbra8AYkWimn6f9HwlWxfchZWo7
         Ipyrz4y6i82VT5ZGNAm+/A4Rn1/Y+q93h+xu/J7HqUu5SQr94teWzfQhzzGiyrjeWg8B
         hX/wGtznHuuhLYSatpoKEHI5jD90nL7cINLK1KoZwjiwRPXc0m0+YQGrSjtgMTZndjkl
         Qang==
X-Gm-Message-State: AOAM531UV9GOPcx38ZPN7Wir079B8dw7U/ulRdlzS9YyFWvjk0+ioXYr
        Z+a6ZC+r/ofbkLo1y4aU/5iETkK5qRQ=
X-Google-Smtp-Source: ABdhPJzLk4pnmY/OKXz6QkMWsx2Afei3xxgG4AE7wSyZfBYbEF9mNkA076mwdXbvh2aaYlOgyzjHfw==
X-Received: by 2002:a17:907:a0c9:: with SMTP id hw9mr1690308ejc.421.1643263798972;
        Wed, 26 Jan 2022 22:09:58 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t15sm8279846eju.1.2022.01.26.22.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 22:09:58 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/2] trace-cruncher: Unit test for event probes API
Date:   Thu, 27 Jan 2022 08:09:54 +0200
Message-Id: <20220127060954.22927-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127060954.22927-1-tz.stoyanov@gmail.com>
References: <20220127060954.22927-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All trace-cruncher APIs should be covered by unit tests. Added a test
for newly introduced event probes API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../tests/1_unit/test_01_ftracepy_unit.py     | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index 2de3d89..d23cb63 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -14,6 +14,7 @@ import tracecruncher.ft_utils as tc
 
 instance_name = 'test_instance1'
 another_instance_name = 'test_instance2'
+kernel_version = tuple(map(int, (os.uname()[2].split('.')[:2])))
 
 class InstanceTestCase(unittest.TestCase):
     def test_dir(self):
@@ -457,6 +458,55 @@ class KprobeTestCase(unittest.TestCase):
         ret = kp1.is_enabled(instance=inst)
         self.assertEqual(ret, '0')
 
+class EprobeTestCase(unittest.TestCase):
+    def test_register_eprobe(self):
+        """ Event probes are introduced in Linux kernel 5.15
+        """
+        if kernel_version < (5, 15):
+            return
+
+        evt1 = 'sopen_in'
+        evt1_tsys = 'syscalls'
+        evt1_tevent = 'sys_enter_openat'
+        evt1_args = 'file=+0($filename):ustring'
+        evt2 = 'sopen_out'
+        evt2_tsys = 'syscalls'
+        evt2_tevent = 'sys_exit_openat'
+        evt2_args = 'res=$ret:u64'
+
+        ep1 = ft.register_eprobe(event=evt1, target_system=evt1_tsys, target_event=evt1_tevent,
+                                 fetchargs=evt1_args)
+        self.assertEqual(evt1, ep1.event())
+        self.assertEqual("{}.{}".format(evt1_tsys, evt1_tevent), ep1.address())
+        self.assertEqual(evt1_args, ep1.probe())
+
+        ep2 = ft.register_eprobe(event=evt2, target_system=evt2_tsys, target_event=evt2_tevent,
+                                 fetchargs=evt2_args)
+        self.assertEqual(evt2, ep2.event())
+        self.assertEqual("{}.{}".format(evt2_tsys, evt2_tevent), ep2.address())
+        self.assertEqual(evt2_args, ep2.probe())
+
+    def test_enable_eprobe(self):
+        """ Event probes are introduced in Linux kernel 5.15
+        """
+        if kernel_version < (5, 15):
+            return
+
+        evt1 = 'sopen_out'
+        evt1_tsys = 'syscalls'
+        evt1_tevent = 'sys_exit_openat'
+        evt1_args = 'res=$ret:u64'
+
+        ep1 = ft.register_eprobe(event=evt1, target_system=evt1_tsys, target_event=evt1_tevent,
+                                 fetchargs=evt1_args)
+        inst = ft.create_instance(instance_name)
+        ep1.enable(instance=inst)
+        ret = ep1.is_enabled(instance=inst)
+        self.assertEqual(ret, '1')
+
+        ep1.disable(instance=inst)
+        ret = ep1.is_enabled(instance=inst)
+        self.assertEqual(ret, '0')
 
 class TracingOnTestCase(unittest.TestCase):
     def test_ON_OF(self):
-- 
2.34.1

