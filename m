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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E00C07E95
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0CA361C5B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 13:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhGGNY6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 09:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbhGGNY6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 09:24:58 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C345C061574
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Jul 2021 06:22:16 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id s15so3304898edt.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Jul 2021 06:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=topsiAcRQNIk9UC840oPCMlScCL+Ty8bkbxddrD/khA=;
        b=ZepmgbY/zbOYB84EdbTd2lZoZ3hI7Rm2HYlWoZH9jcngDpiJyyMK/wLa1OxduPeM6z
         vMZ0rniQI6TZwPZFBtb8Bf9cvk/tiPhX+nKR663VW3kDiuCWwe1RlFyK7fN/VoEvn4sB
         84jDYVkAtk8MMK0bUPDoTSoZKXIimJXnjEpnMHdClgouRmvTSd75UKJZNZ1CBZUOxcEM
         gh85vPuztM5qcyOVEHwrwIvDVS4UJcp71na2xPEgGqOc+ftUgVy8LaH2ZGothhU1/r4k
         4oLzWjfzTsto01oDhXrYXPYYGpLLfjp5vPZ1gNy8UTSGfzRXYHSgulcksDpwpKSM3kWW
         we4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=topsiAcRQNIk9UC840oPCMlScCL+Ty8bkbxddrD/khA=;
        b=RlbdGKbUY8m0/ndSUdJ0sHR6X1tzQMaPUdZreQ7+zS6THrTU9hVlk8j0KfFNjQfEYU
         uCvNDN0XFWDrlPP4Zsow30tznG8Xh4a8LqPLTVjzuWeN9DRaKL4lambqmvL6WnWybi/f
         8nDc/9+C00xFbuADA1g3mqgLHZ1wRWrEUevsJxhzWKvrTSehyujpkLUfvDoT/+TzanB9
         sc7SvDCxzqqTrhB+TQcy8y+yDwOYDxwc/2jiCUzgbNmP/HVrva/zZgjDeZKlx5VJWRFJ
         1QcHnjnIVo8V9b7og7+Ex0o8XczY6cMXPPCrSlna3akAVXYyamcHbAr8FxJwN7VodNlI
         R5uA==
X-Gm-Message-State: AOAM531CZgz7iamHkYsvN/8tFEoGPnsAQb1+k0UmRLuyqCa8X0dVKjZJ
        FimjrCUEUVfiBV1aByoQqxidwD8eNAU=
X-Google-Smtp-Source: ABdhPJwoKd1pp8b/BVPMpJhKFU9dN/ZJwxnxc1FvVANj26Fm7CIL+CRL3THQ+s7bT/sQQjofRPb1CA==
X-Received: by 2002:a50:ed82:: with SMTP id h2mr30024569edr.165.1625664135114;
        Wed, 07 Jul 2021 06:22:15 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id eb9sm7064881ejc.32.2021.07.07.06.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 06:22:14 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 06/11] trace-cruncher: Add ftracepy example
Date:   Wed,  7 Jul 2021 16:21:53 +0300
Message-Id: <20210707132158.68520-8-y.karadz@gmail.com>
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

