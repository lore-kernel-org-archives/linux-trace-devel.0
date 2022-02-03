Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B95C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Feb 2022 15:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347721AbiBCPgL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Feb 2022 10:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240490AbiBCPgK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Feb 2022 10:36:10 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA86C06173B
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Feb 2022 07:36:10 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id a13so5760827wrh.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Feb 2022 07:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nW6iUE8g4RFhHjxj+R7/3qPwS9Xtf0hMFv1tu0N119Y=;
        b=Pl25L+z3MC6BV8/l6thZrozCvD38w81g/Pdee0DmOXz46EJX/6XPNIhNoyK6ksyDRl
         E1YabsDK2VVWnfKTWo0LHPikDYbBw+Tft4euecARu+HUzfmUPHGJ6MCvo1iNsFlyA8Hk
         iduymj4pr2ZiAPCu26bG+tZebSH3E5xasJrr0NkKjHe9PMk75GpDUWZoSH50Sw+PfGFz
         0942tnSlmlAPjy45RgW/l1WAEIFASU1u2XnTiQRI4tQ8HbP3PDJ9TO9J4PNATEFqM30i
         rfp0M9md5JzXuCihtahQFHHTs4Ex7H8JgvAtAa/vx9EReCEQapexxst8EFJqpVMAAPg4
         Uvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nW6iUE8g4RFhHjxj+R7/3qPwS9Xtf0hMFv1tu0N119Y=;
        b=Fcx9BEDeRbXQqNyqxfVk41i8DQ7MAzsHHlxJnc3OUmnhEB9Zm2fX7URMFVOjT6KZ/D
         Q7GGGbLQkWDSYmi6HaKcKOJpKwJFHBwnpsU9HWciA6YExW7lXXr1ik78nGynt85p3fVY
         o+L+bFDErXaR36ri1yTmkDXwxMl7bvHTnJSpGJ8U359H3hV/PeXTV/z4cV3TiqVpBhMw
         WX2JiSyzILf3cfsR/I83r+2hYuQ7V/C16miabAuayzIixO2rLewr+VmpEwB/MdiJ04du
         tbC9ObZpWYddsf39fTJPLzsNnJIwKnaffHH2G17eUQog6QYK/pHu5C5B/KUsb0/leqEH
         UkxQ==
X-Gm-Message-State: AOAM532vSCUWZg+gXGUjufWrATp4a63cIh+AmVbrCj8raof3ImlXpgS8
        nE58VEQGSBjT/CuHrv9NvpodN9SdDxo=
X-Google-Smtp-Source: ABdhPJxtpwRBihjFdtnFlMjt7Z1oGRv80cryil7tMuOarvH5VWjRtZ6JrKHGx9ulpyEaXKaVqYGpww==
X-Received: by 2002:a5d:6da8:: with SMTP id u8mr11732315wrs.603.1643902568719;
        Thu, 03 Feb 2022 07:36:08 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id z1sm7595762wmk.32.2022.02.03.07.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 07:36:08 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] trace-cruncher: Add tests for the ksynth class
Date:   Thu,  3 Feb 2022 17:35:55 +0200
Message-Id: <20220203153556.26878-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220203153556.26878-1-y.karadz@gmail.com>
References: <20220203153556.26878-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Testing the high-level Python APIs for kernel synthetic events.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .../tests/1_unit/test_01_ftracepy_unit.py     | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index f51bcc1..70f5d29 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -825,6 +825,61 @@ class SyntTestCase(unittest.TestCase):
         self.assertEqual('none', synth.get_filter())
         synth.unregister()
 
+swaking = tc.event('sched', 'sched_waking')
+sswitch = tc.event('sched', 'sched_switch')
+
+class SyntTestCase(unittest.TestCase):
+    def test_synt_create(self):
+        start = tc.ksynth_event_item(event=swaking,
+                                     fields=['target_cpu', 'prio'],
+                                     match='pid')
+        self.assertEqual(start['fields'], ['target_cpu', 'prio'])
+        self.assertEqual(start['match'], 'pid')
+        self.assertEqual(start['field_names'], [None, None])
+
+        start = tc.ksynth_field_rename(start,
+                                       field='target_cpu', name='cpu')
+        self.assertEqual(start['field_names'], ['cpu', None])
+
+        end = tc.ksynth_event_item(event=sswitch,
+                                   fields=['prev_prio'],
+                                   match='next_pid')
+        self.assertEqual(end['fields'], ['prev_prio'])
+        self.assertEqual(end['match'], 'next_pid')
+
+        synth = tc.ksynth(name='synth_wakeup',
+                          start_event=start, end_event=end,
+                          synth_fields=[tc.ksynth_field_deltaT(hd=True)],
+                          match_name='pid')
+
+        synth_str = synth.__repr__().split('\n')
+        event = synth_str[0]
+        hist_s = synth_str[1]
+        hist_e = synth_str[2]
+
+        self.assertTrue('keys=pid'in hist_s)
+        self.assertTrue('keys=next_pid' in hist_e)
+        self.assertTrue('pid=next_pid' in hist_e)
+        self.assertTrue('onmatch(sched.sched_waking).trace(synth_wakeup,$pid' in hist_e)
+        self.assertTrue('s32 cpu;' in event)
+        self.assertTrue('s32 prio;' in event)
+        split_1 = hist_s.split('__arg_')
+        arg1 = '__arg_' + split_1[1].split('=')[0]
+        arg2 = '__arg_' + split_1[2].split('=')[0]
+        self.assertTrue(arg1 + '=target_cpu' in hist_s)
+        self.assertTrue(arg2 + '=prio' in hist_s)
+        self.assertTrue('cpu=$' + arg1 in hist_e)
+        self.assertTrue('prio=$' + arg2 in hist_e)
+        split_2 = hist_e.split('trace(')
+        self.assertTrue('$pid' in split_2[1])
+        self.assertTrue('$prio' in split_2[1])
+        self.assertTrue('s32 prev_prio;' in event)
+        split_3 = hist_e.split('__arg_')
+        arg3 = '__arg_' + split_3[3].split('=')[0]
+        self.assertTrue(arg3 + '=prev_prio' in hist_e)
+        split_4 = hist_e.split('trace(')
+        self.assertTrue('$' + arg3 in split_4[1])
+
 
 if __name__ == '__main__':
     unittest.main()
-- 
2.32.0

