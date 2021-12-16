Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B085C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 13:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237522AbhLPN34 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 08:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhLPN34 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 08:29:56 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A310C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 05:29:56 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id t26so7894176wrb.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 05:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qoZEuanlkR/noC4+fz4OFwDmE+WQJryj+prNklu+HVk=;
        b=TrkbtuEyLX2PasWj7EwBkRv//RKYMwWl59Z5/f7Xd27O6kbrGpi+dlZmkHkfzqHiqy
         i5PcKLD7DrNcffHdw/9Zq80yBAF3wnqRv4tbxYzwoer/hnop/bSCqluMgKoJW6AX5/2F
         xYozNdv1tDHwTPabb8OFsc6U8p7N6A1Bef5YO/UWiOnpBpDikDUmD4CFkAWCXMpyQiRB
         ZsUznOQfaL6Mtmp6TN+iqeRGGPKKCiNWMyAJDQpuW8LhZrpor7AKUroHX4jbTzAkOtlN
         zPy37zzwTVgcFbpWE0v9h882Wf7V95ONLP5+vkQ291mfW5bknfF2OpHOdkmpdmoYtsnh
         FyAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qoZEuanlkR/noC4+fz4OFwDmE+WQJryj+prNklu+HVk=;
        b=RDgDQIO4d/hRIRvgrLcjYfMbqWOp5yVmq3COgtCkzqeIUb5FoSPdUkTtjkGDsek5+k
         Ww5fc+TU8lhE3sknIjYGOjvqdeZsd8ExCybYvgkZYKmBMYrWV+NFrUGmKxt8M3hJZohr
         EUFQfaUC0/KURoFOGTtvs+pl34FfLzjFkNEfJcAnoSk0VZyPP+f2A91Rl+ZAubhY927l
         XQUCyyGIb7Akr8HHSMSfJYfCfWNiEAbUl4dhE1y6clt5bQ6Nao0Do8sGrcwSBkKV9t5F
         gHDRbSp/VcmXsSsRfL2mDeEKkohI2My3B6f0UsznFNtcveBsjRUPIWVeFZ7QzsHPVRRG
         Okug==
X-Gm-Message-State: AOAM530wqmfuy8+keHriEVuxzphRcUgBu7HaGIo9N9I3KVkmDCemfQKF
        FFu9lwfMvW+dxmpvo/6E/Et/TS0mmoU=
X-Google-Smtp-Source: ABdhPJznh7GKxXBCvyDCy9rSOGk1Oc0x6uOOSGEHn+wtyYsIKLADkcwk9Xkxd+h322TaQRrMXdAcjA==
X-Received: by 2002:a5d:6dab:: with SMTP id u11mr8960173wrs.46.1639661394630;
        Thu, 16 Dec 2021 05:29:54 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id l5sm5608931wrs.59.2021.12.16.05.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 05:29:54 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] trace-cruncher: Add more histogram tests
Date:   Thu, 16 Dec 2021 15:29:21 +0200
Message-Id: <20211216132921.239628-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211216132921.239628-1-y.karadz@gmail.com>
References: <20211216132921.239628-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Testing the handling of couple of error cases.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .../tests/1_unit/test_01_ftracepy_unit.py      | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index 7b344e2..7e5b20e 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -582,5 +582,23 @@ class HistTestCase(unittest.TestCase):
         self.assertTrue('Available triggers:' in h_buff)
         f.close()
 
+    def test_hist_err(self):
+        inst = ft.create_instance(instance_name)
+        hist = ft.hist(system='kmem', event='kmalloc',
+                       axes={'call_site': 'sym',
+                             'bytes_alloc': 'n'})
+        err = 'Failed read data from histogram'
+        with self.assertRaises(Exception) as context:
+            hist.read(inst)
+        self.assertTrue(err in str(context.exception))
+
+        hist.start(inst)
+        err = 'Failed to start filling the histogram'
+        with self.assertRaises(Exception) as context:
+            hist.start(inst)
+        self.assertTrue(err in str(context.exception))
+        hist.close(inst)
+
+
 if __name__ == '__main__':
     unittest.main()
-- 
2.32.0

