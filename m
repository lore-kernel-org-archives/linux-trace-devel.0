Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B74B4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 08:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242517AbiAXI46 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 03:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242526AbiAXI46 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 03:56:58 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AC1C06173B
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:57 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id k18so12152509wrg.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4r5c1OhgDg4fVLQNXAQNqqUddRRCC9GVZ4qROs5kdnM=;
        b=jS+neGe3KibVbwZkw1DplVthoF2msb4vyxZ+JnsOo5Zo2AI7LU4TUaw/jsGNVfNEly
         m6P2i8FTTaL7VY2TiaC/lAvSV6567doWOoyeNmYMBE6TG/bSS6wfu1yoH5/12AMAgaBR
         RxNMRaCm8FSbOzJ975YJUd3L/JNrTQd0HU51rPAqwcxdUrLeFLpRSbuoJ08Od985HUGa
         RHAaXoAAnYGe3QYZd+JC+34/e0KylXKskXgles6eXHpBSazT5TlR2bIFocMKrenC3znQ
         FOaCc95jIvFMwRdGnAD2p6WiMYj2crVrA8rO3HmHBBRJ4AkjDrPEoLV2FN7XDRkyWasz
         7Y1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4r5c1OhgDg4fVLQNXAQNqqUddRRCC9GVZ4qROs5kdnM=;
        b=2+E2WueVjoVRfjIbjzao3ckCOuxdH0G70MbffQOM0q6vBJ5V1ajrZi0ZmErCK4rRP6
         EerfY86nFu+do7q99i47+8jYokf4yXWDOY8eRhncPWvX/1Y1tvvKyNRkTrIffwv80QAs
         H99KWHYnVrfAaQtVqDdblDTBgzUHpf2W30rOHT4f0JjCq52kkOpEf6tS8LMrKgKQT1Ba
         UN77XW0MTcZwiKlK1o/IwyaeYNT2S7BL/FO15cdpc6h7n+sC0qc826eWzEN06xAqrCUv
         BC2sH2HwxPzw7A/uqmFmx9UcNkh3YMqkeWxE4xPQ37EjwkhJII8mXIuXkNlL+WHiGeZq
         fyXA==
X-Gm-Message-State: AOAM533twkI+efiF7eEP0Yhgs3WgXVAbRK2DmTAz+ezoAYyd6DUpK+9t
        qm43334QlyVLO1J7BmuFjWTC/i2vKw0=
X-Google-Smtp-Source: ABdhPJz/lUrTi3aS/S1EMLU4rW7nKOm/3ge3ryHJ2eycGBFN2lwKg5/OjT56HYC+ynhCmDbuqW8NmQ==
X-Received: by 2002:adf:d1c9:: with SMTP id b9mr13636458wrd.560.1643014616426;
        Mon, 24 Jan 2022 00:56:56 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id f14sm14828091wri.44.2022.01.24.00.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:56:56 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 10/10] trace-cruncher: Add synth. events tests
Date:   Mon, 24 Jan 2022 10:56:25 +0200
Message-Id: <20220124085625.92297-11-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220124085625.92297-1-y.karadz@gmail.com>
References: <20220124085625.92297-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

APIs for kernel synthetic events have been added.
Here we add the corresponding test cases.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .../tests/1_unit/test_01_ftracepy_unit.py     | 86 +++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index 51970d3..2de3d89 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -691,5 +691,91 @@ class HistOopTestCase(unittest.TestCase):
         self.assertTrue(err in str(context.exception))
 
 
+class SyntTestCase(unittest.TestCase):
+    def test_synt_create(self):
+        synth = ft.synth(name='wakeup_lat',
+                         start_sys='sched', start_evt='sched_waking',
+                         end_sys='sched',   end_evt='sched_switch',
+                         start_match='pid', end_match='next_pid',
+                         match_name='pid')
+
+        synth.add_start_fields(fields=['target_cpu', 'prio'],
+                               names=['cpu', None])
+        synth.add_end_fields(fields=['prev_prio', 'next_prio'],
+                             names=[None, 'nxt_p'])
+        synth.register()
+
+        event = synth.repr(event=True, hist_start=False, hist_end=False)
+        hist_s = synth.repr(event=False, hist_start=True, hist_end=False)
+        hist_e = synth.repr(event=False, hist_start=False, hist_end=True)
+
+        self.assertTrue('keys=pid'in hist_s)
+        self.assertTrue('keys=next_pid' in hist_e)
+        self.assertTrue('pid=next_pid' in hist_e)
+        self.assertTrue('onmatch(sched.sched_waking).trace(wakeup_lat,$pid' in hist_e)
+
+        self.assertTrue('s32 cpu;' in event)
+        self.assertTrue('s32 prio;' in event)
+        hist_s = synth.repr(event=False, hist_start=True, hist_end=False)
+        split_1 = hist_s.split('__arg_')
+        arg1 = '__arg_' + split_1[1].split('=')[0]
+        arg2 = '__arg_' + split_1[2].split('=')[0]
+        self.assertTrue(arg1 + '=target_cpu' in hist_s)
+        self.assertTrue(arg2 + '=prio' in hist_s)
+        hist_e = synth.repr(event=False, hist_start=False, hist_end=True)
+        self.assertTrue('cpu=$' + arg1 in hist_e)
+        self.assertTrue('prio=$' + arg2 in hist_e)
+        split_2 = hist_e.split('trace(')
+        self.assertTrue('$pid' in split_2[1])
+        self.assertTrue('$prio' in split_2[1])
+
+        event = synth.repr(event=True, hist_start=False, hist_end=False)
+        self.assertTrue('s32 prev_prio;' in event)
+        self.assertTrue('s32 nxt_p;' in event)
+        hist_e = synth.repr(event=False, hist_start=False, hist_end=True)
+        self.assertTrue('nxt_p=next_prio' in hist_e)
+        split_3 = hist_e.split('__arg_')
+        arg3 = '__arg_' + split_3[3].split('=')[0]
+        self.assertTrue(arg3 + '=prev_prio' in hist_e)
+        split_4 = hist_e.split('trace(')
+        self.assertTrue('$nxt_p' in split_4[1])
+        self.assertTrue('$' + arg3 in split_4[1])
+
+        synth.unregister()
+
+    def test_synt_enable(self):
+        synth = ft.synth(name='wakeup_lat',
+                         start_sys='sched', start_evt='sched_waking',
+                         end_sys='sched',   end_evt='sched_switch',
+                         start_match='pid', end_match='next_pid',
+                         match_name='pid')
+        synth.register()
+        ret = synth.is_enabled()
+        self.assertEqual(ret, '0')
+        synth.enable()
+        ret = synth.is_enabled()
+        self.assertEqual(ret, '1')
+        synth.disable()
+        ret = synth.is_enabled()
+        self.assertEqual(ret, '0')
+        synth.unregister()
+
+    def test_synt_enable(self):
+        evt_filter = 'prio<100'
+        synth = ft.synth(name='wakeup_lat',
+                         start_sys='sched', start_evt='sched_waking',
+                         end_sys='sched',   end_evt='sched_switch',
+                         start_match='pid', end_match='next_pid',
+                         match_name='pid')
+        synth.add_start_fields(fields=['prio'])
+        synth.register()
+        self.assertEqual('none', synth.get_filter())
+        synth.set_filter(filter=evt_filter)
+        self.assertEqual(evt_filter, synth.get_filter())
+        synth.clear_filter()
+        self.assertEqual('none', synth.get_filter())
+        synth.unregister()
+
+
 if __name__ == '__main__':
     unittest.main()
-- 
2.32.0

