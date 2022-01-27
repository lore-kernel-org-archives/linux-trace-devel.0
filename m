Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C5BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 07:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbiA0HBT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 02:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237028AbiA0HBS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 02:01:18 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500C4C061714
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:01:17 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id w14so2258341edd.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2HnGuIneRynFxENKuxdJLTxuibLizoDMquQzVbAiiJU=;
        b=ZWJUxnHxz7wXlbNtV1F3tRIA17ZoclOVIuNRCHGokpKjEAB3Ykh2AERbfWGhnwRWzc
         diY4ua4+fdpgtdfzjAIVcSSZhK83R13Pdt6O98f5tXqnJ31Byn0snmBQm3UWez388/54
         +Bi92XplpZdMdzs1Y3mvmJGmpzP0Kx9WFNUf+Qly5lqsIWvptt54YTM5Rbfk0myDR1Dm
         0zXqWKFk2Jpkr5DW8rXwHyXUIMoIFMkjx3XRovo5SUELeNW/0Mw8uLGdDy5LkaIKz7BN
         KSkgi8HxtBm8l75Dqx8iKebc/ftpuGfdd3jGOorZ27DliN1Bo43PLfy1waLyAf0jZGRK
         pX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2HnGuIneRynFxENKuxdJLTxuibLizoDMquQzVbAiiJU=;
        b=5sqrapHo3Urp98yBdQFBu80r1KO0TMySrMPSqcpS7gJBwsjO0e633qPvYbh2qoIMAg
         +L+1PilvgDOmVWdlcaQglvspbj14sljILfE5Uwn1E2+XcDvbLPz5oy24HIqN/cfqLrBO
         RpTrFWrmHOeQjEnocEzImwmWWiqKBzCI8y4I1W1bFTiiUCOQW9fkZIMV91s36wELvxfP
         MOumyCN9qgjacQ4HYMhB9CKUyYycBcOz7L87wF+x0vRfXEAv8MrnNWL/N1OeQBvDrbuN
         kOiSCMw7UR3bZgqC1+HYmk+opKaZ0jpanBlmpK8iWi7WkjNFhDynJpHDViOkTRkGQim7
         AtEA==
X-Gm-Message-State: AOAM532iBorV/0aTO1Il7/TF4HKEAdtT9Sh7Wc+Zfy9/4BTujg9zqvmO
        /4TxwQQ4MKyAQbl5ADLShuWbKm75sdk=
X-Google-Smtp-Source: ABdhPJyWjSnel/ZfFs/F1rM9cIgDGemVZz3BKYW7gSiIHu6tBc159CiXrX6oosnL0xcvhZPS6el0fA==
X-Received: by 2002:a05:6402:2052:: with SMTP id bc18mr2317410edb.63.1643266875787;
        Wed, 26 Jan 2022 23:01:15 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i17sm8317079ejp.60.2022.01.26.23.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 23:01:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 2/3] trace-cruncher: Unit test for event probes API
Date:   Thu, 27 Jan 2022 09:01:10 +0200
Message-Id: <20220127070111.27529-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127070111.27529-1-tz.stoyanov@gmail.com>
References: <20220127070111.27529-1-tz.stoyanov@gmail.com>
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
index 2de3d89..d773acc 100644
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
+    def test_eprobe(self):
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
+        ep1 = ft.eprobe(event=evt1, target_system=evt1_tsys, target_event=evt1_tevent,
+                        fetchargs=evt1_args)
+        self.assertEqual(evt1, ep1.event())
+        self.assertEqual("{}.{}".format(evt1_tsys, evt1_tevent), ep1.address())
+        self.assertEqual(evt1_args, ep1.probe())
+
+        ep2 = ft.eprobe(event=evt2, target_system=evt2_tsys, target_event=evt2_tevent,
+                        fetchargs=evt2_args)
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
+        ep1 = ft.eprobe(event=evt1, target_system=evt1_tsys, target_event=evt1_tevent,
+                        fetchargs=evt1_args)
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

