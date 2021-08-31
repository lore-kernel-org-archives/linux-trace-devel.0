Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1A2C43214
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 Aug 2021 12:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A44361041
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 Aug 2021 12:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhHaMzJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 31 Aug 2021 08:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhHaMzJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 08:55:09 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D34C061575
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Aug 2021 05:54:13 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id e21so38376244ejz.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Aug 2021 05:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L/W8EFIlGS+Cd0HJ8OdZKFcPxUBHrjWzs5U237S6x5g=;
        b=pmem1WMJQ2x0smhf8Crw6d78uzwVIFqNQzBLQtXABISJqUD4bD8HQwtUVG2hkV1LWB
         Orlkg6A8mnTzT5WxLwsGmOSvXZqmBZefKQ6XJ4v0wJjZM0RW0Kv6zs6o78w9yajNmAWz
         klpIVfftXL45BRyd5o6aNZ/3SnmVuNXb5a0H9913p5bHsdWsb01Xr0MlQ3g9zQXPylIe
         VWudOz26VZA0JL9iN+bt9J8guw1wuYWaOxPOYG8PehZVyikUwSeeYhiW7Oocn0QCghAU
         zo5tKdA3/cO0mgaijM2MHHoyVb1vRiGs3Z/Ma2Db6VWLR6riRKAFirTDuhyrSns9+bZ/
         M8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L/W8EFIlGS+Cd0HJ8OdZKFcPxUBHrjWzs5U237S6x5g=;
        b=dhNcEl5NMMUQQBHXGfvWFaHyThHPbzI0nDMoEXYa0BPPaH0zG7MdQm9Qgp5WnFKCHz
         suIP8sN0JA+fAAFG8seTQ+DL1BqC3Q3WpppB9fYr5n0bfvp8wiF3YlpQh1MCBKlFu5sD
         4bqNxlBU5nDWObtN4vrUUGoblQybrhip40OSVo36ogJmWogrEd9tsH7Ggn/J1Ob12B2p
         tJXuIOPs6sjFs2YQ4MbXnRmKy0Q94gkTK/3kWN81YDgt2Z/oXZJ5tW87NCeTFD9qA4/m
         KxLwPv+1bKcM2HYzEAXi252xvXTwrGXL1sb6HyFhLOLb6ImKG7pDjTRlpy+m8c0+/Rr+
         Vk6w==
X-Gm-Message-State: AOAM5331RUq9Iq8THx6TfSKv7GjmFzhKI/9lTJeXONNks75SONO2WQFd
        1TqMwTvhqtU1jp7RdUYrV9DLNQnnVGU=
X-Google-Smtp-Source: ABdhPJzPkSWSIFFGeY+/antd5M853jKLeOVkB/lmldMFV6DqImEJ3uRAi7ciPAsajOvawegGvPduhQ==
X-Received: by 2002:a17:906:7855:: with SMTP id p21mr19163843ejm.330.1630414452234;
        Tue, 31 Aug 2021 05:54:12 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id be5sm9346976edb.57.2021.08.31.05.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 05:54:12 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/4] trace-cruncher: Add tests for sorted events/systems
Date:   Tue, 31 Aug 2021 15:53:57 +0300
Message-Id: <20210831125357.56862-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210831125357.56862-1-y.karadz@gmail.com>
References: <20210831125357.56862-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

An optional parameter 'sort' was added to available_event_systems()
and available_system_events(). Here we add the corresponding test
cases.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 .../tests/1_unit/test_01_ftracepy_unit.py          | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
index 971fd5f..710d3e1 100644
--- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
+++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
@@ -111,19 +111,23 @@ class TracersTestCase(unittest.TestCase):
 
 class EventsTestCase(unittest.TestCase):
     def test_available_systems(self):
-        systems = ft.available_event_systems()
-        self.assertTrue(len(systems) > 1)
+        systems = ft.available_event_systems(sort=True)
+        self.assertTrue(len(systems) > 2)
         self.assertTrue('sched' in systems)
+        for i in range(len(systems) - 2):
+            self.assertTrue(systems[i] < systems[i + 1])
 
         inst = ft.create_instance(instance_name)
         systems = ft.available_event_systems(inst)
-        self.assertTrue(len(systems) > 1)
+        self.assertTrue(len(systems) > 2)
         self.assertTrue('sched' in systems)
 
     def test_available_system_events(self):
-        events = ft.available_system_events(system='sched')
-        self.assertTrue(len(events) > 1)
+        events = ft.available_system_events(system='sched', sort=True)
+        self.assertTrue(len(events) > 2)
         self.assertTrue('sched_switch' in events)
+        for i in range(len(events) - 2):
+            self.assertTrue(events[i] < events[i + 1])
 
         inst = ft.create_instance(instance_name)
         events = ft.available_system_events(instance=inst,
-- 
2.30.2

