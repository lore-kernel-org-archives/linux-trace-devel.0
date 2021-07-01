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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DE3FC11F64
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06CF261452
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jul 2021 11:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbhGALRH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 07:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236040AbhGALRH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 07:17:07 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4643CC061756
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jul 2021 04:14:37 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i94so7712713wri.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 01 Jul 2021 04:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=topsiAcRQNIk9UC840oPCMlScCL+Ty8bkbxddrD/khA=;
        b=UHtkPFHqPWFtODi0a0IMxUVC4zIdcNJqKkSDpys6Xiq7PEwiifIeQ6StJn5aaQhudM
         YVHYPfSuCp5i8537tOfYviBSUId2MmRGtG7QITIz4Y3oX+W59dGB6TLgmfDp4guyOYyS
         RjtvLdWGu6+Pgl2E7SfUdq50S5xvT+ZT1kGIQAoql79DIx5xD5E2t9dai1GolWNetajU
         3/R5RsfzCDQI0AyCTLV+K0LaNFb8lY/VRXChYzCve65rj7IK4HQUbgY/E61h9sUmluRS
         sbtr7U7Ocr68epjqrO/dGVe47kfPNYZ8/+2vMVJdLYfgbOaImnRpoNf0z1m676XlmiS2
         vY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=topsiAcRQNIk9UC840oPCMlScCL+Ty8bkbxddrD/khA=;
        b=Vtmjt6GsYoyalYjxzNewLBICk6sAWW4SI+8YrEiURK9WNUaCT9r793bNkE9Opv4hdJ
         IUSz000joH/xffoIDP+jdnwyZftoD/CxBgwRRizyH3msGnmGjAfT6rbrssrT12+48/Yf
         pgrH8RF7reYLZQC3RUMAl5bj5aohVrq2EgHT68SYMQPSyIMRAQ5dIXgzrFCk1hfRgcc1
         gtx/zhM86R90YR7iDO/ZICQBEQZ4//CHxl1w8UfNQ/4MfbUyutKBxfR4gaINMQvDmrDh
         bfNdm4qJkt2dBSTX85v0VRXwbTpeq32BLBGZ+/BLeFD7YYc4JmhgEuPrjvWLjOHGAnjl
         CL+w==
X-Gm-Message-State: AOAM533m0Fipff4BYGcXPpSWvGqMQv+O9XlwFe/aF/eSBAQpBITIiU6J
        EkwA+Yr0IsDaztCBaC2i0ASNB2x02JE=
X-Google-Smtp-Source: ABdhPJyfrQ7+CEANijIfjYlV7tfUnL4fPX81MiZPBMZkbWXriS/0xTYMjgg9IV1mwJwsBZdbTZK1xA==
X-Received: by 2002:adf:e804:: with SMTP id o4mr45012929wrm.103.1625138075778;
        Thu, 01 Jul 2021 04:14:35 -0700 (PDT)
Received: from bucy.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id o17sm9223009wmh.19.2021.07.01.04.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 04:14:35 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, warthog9@eaglescrag.net,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 06/11] trace-cruncher: Add ftracefy example
Date:   Thu,  1 Jul 2021 14:14:13 +0300
Message-Id: <20210701111418.18386-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210701111418.18386-1-y.karadz@gmail.com>
References: <20210701111418.18386-1-y.karadz@gmail.com>
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

