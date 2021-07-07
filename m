Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3C7C11F67
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A06F261C5B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhGGNY5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 09:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhGGNY5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 09:24:57 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CE7C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jul 2021 06:22:15 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id s15so3304851edt.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Jul 2021 06:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=topsiAcRQNIk9UC840oPCMlScCL+Ty8bkbxddrD/khA=;
        b=JdHm3NqRMUunZOQgnZlJ6cFDD4cghsPnqlcg8PeaOc4t0YKnRq+rNA5G8GV6oC0JqW
         XQvNRI/NepECQohPvJ2JJjf4aBKSndofOCzQwZt6j61nHGE3ex+USruKYUcdtlXu5mMK
         Z8qrfVg1VA4XIrTnuIaRZ3Dm2I/Ok818wF3l0TrBM26CiEyNJuTqUwZtueQpKAj4oI6N
         Qr0uiKjZyW2d1x5ktTeFBTGq8UU2nkMgPK02lV0xRl7icG0aiRRvKPvM8NORl6k8kSFL
         Xai8qn40ykGY6HHucQt9NqPoeumFZ+OIS05K1rcd44tXHKu5UlCG0JouuN4FiMPqsv4p
         auMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=topsiAcRQNIk9UC840oPCMlScCL+Ty8bkbxddrD/khA=;
        b=KK2zMqywtNo3Yl2jnYhvwT3nQ+yxju5htDeJ4bX0YshF0MOy9z6PRd/PwOuv/WVh02
         tdVo4WLbf5m05yVmkuG+8/o25AOOsc+AHTZ0DgRg08htMwd0FNOzYR+GKB6u17RQmipk
         hqBsiCv/Dfc/kbxeDSP6/9wU4peAx7W60hMw12Lw+MwiXESEz4TZNhWgZ0n2OhoJHarU
         9mmHX6XU60Tr0V9DVUSioHuZeB2ZZ8k4fOSSnFHyTziwQIvmIHu9/jzoMbK5l1zwNKA4
         m59yZ388nX/fNmjEojt5fxu763651f/sp5VpWhGQH9qiPNsgrJAacV/1H3GJZC0wuHo5
         cBSw==
X-Gm-Message-State: AOAM533jPveJKQkhlxEXDgJQuyqiv1ti4iNREdw+tOuNJVEQ7qha8Ih+
        gX9aMJ/uF61LCHTqOMPtxNqHYe00MkA=
X-Google-Smtp-Source: ABdhPJyGDCRysRgEI+KqKo/y8h+PTtshRcuKmRuFet7QNHbzEj/TJp7VkyV09+z6k3c6OG1nmXZOiQ==
X-Received: by 2002:a05:6402:792:: with SMTP id d18mr30219482edy.281.1625664134214;
        Wed, 07 Jul 2021 06:22:14 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id eb9sm7064881ejc.32.2021.07.07.06.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 06:22:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 06/11] trace-cruncher: Add ftracefy example
Date:   Wed,  7 Jul 2021 16:21:52 +0300
Message-Id: <20210707132158.68520-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210707132158.68520-1-y.karadz@gmail.com>
References: <20210707132158.68520-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is the most basic possible example. To be considered as an
equivalent of a "Hello world" program.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/start_tracing.py | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100755 examples/start_tracing.py

diff --git a/examples/start_tracing.py b/examples/start_tracing.py
new file mode 100755
index 0000000..da36164
--- /dev/null
+++ b/examples/start_tracing.py
@@ -0,0 +1,20 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: CC-BY-4.0
+
+Copyright (C) 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import tracecruncher.ftracepy as ft
+
+# Create new Ftrace instance to work in.
+inst = ft.create_instance()
+
+# Enable all static events from systems "sched" and "irq".
+ft.enable_events(instance=inst,
+                 systems=['sched', 'irq'],
+                 events=[['sched_switch'],['all']])
+
+# Print the stream of trace events. "Ctrl+c" to stop tracing.
+ft.read_trace(instance=inst)
-- 
2.27.0

