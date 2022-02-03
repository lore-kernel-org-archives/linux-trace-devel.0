Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CC0C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Feb 2022 15:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240490AbiBCPgM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Feb 2022 10:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbiBCPgL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Feb 2022 10:36:11 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598B1C061714
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Feb 2022 07:36:11 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id v123so2366782wme.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Feb 2022 07:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fyPT2rDeN3eg/cGYmcfxCvL8JkkfuGsSr7AkFnWtWoQ=;
        b=Ek7eBHwtnsqtwF5V1Vd3O6ozUl+/HWC/Ipgi099v/Ljgrd7I+nuT2SAY+gVUT9qFkK
         e8Nb6OwNMivTauwmE8xtdgDq3SCpTxXsEMByXQtJpImqao6d/zDg7jmAwxAW21o6l317
         fcUkHD5hdwQJM5QYdc7YA1EAZG1vZDefNZ9bhuI920K9grpAIstMC8jBoIWY0XXi5qDN
         pqQZd3JPV+PQS3HCrtGoV5lxxRTSKY+gKn7M9id4WMVjFRLbu5NHjM1aT0svYm/9uDqz
         T/BU44+McOCQyZnegybv090DG+MtZpTYX/PFXfGhcud4dNUncNXrIqZxRwQFMWL0pDXu
         INxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fyPT2rDeN3eg/cGYmcfxCvL8JkkfuGsSr7AkFnWtWoQ=;
        b=CazP7Yzj70hWeuv5Vv/X64CWi3KhM8PqiSdu8+5pnyh6O46ppqOxdqkGTbhNJR+MYB
         LLNz4vQLiLx1CcBZk3fQQZenCN2QdYLXEUDN/bHf7C/qeAlekfCWCj3GbrALWDgIY9sh
         xi/9vKsLbJPR8FYjRllK2OfE/tsP/qbh1mZW/NCHyG3+4fpGu/MKRedOyrLOP8gnrSKG
         aI+mDE0LlIc7n9sxTbToIpbXfLqe5U264q84XdVQpvOaAcSsNXQn5VtPILbmoxobiaqY
         ZqJ1NFQt1vwRTUkUWljvaYC/5HdU6aOlLlI9b4RGff9gSqXOWMvVURDOZVJ0dLovDWSA
         KJZA==
X-Gm-Message-State: AOAM531OcBBVkqcLh5wJtrm2Jx68ezsMzobNl1HKdrtPmSPgjIDUqrPk
        ST12DzO7d2IpLvXBMYVtD7QOyRB5ZQ4=
X-Google-Smtp-Source: ABdhPJx4M1wnM/a1Xc2j7+Kvv/CJjKakZTsr2ROo9tJ2EY/tBZFl7FP8zWfYLHjfFDMrZIPeOhF9ow==
X-Received: by 2002:a05:600c:3d8a:: with SMTP id bi10mr11101003wmb.62.1643902569621;
        Thu, 03 Feb 2022 07:36:09 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id z1sm7595762wmk.32.2022.02.03.07.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 07:36:09 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] trace-cruncher: Add example for the high-level synth. events APIs
Date:   Thu,  3 Feb 2022 17:35:56 +0200
Message-Id: <20220203153556.26878-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220203153556.26878-1-y.karadz@gmail.com>
References: <20220203153556.26878-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a very basic example, demonstrating the usage of the new
high-level Python APIs for kernel synthetic events.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/synth_oop.py | 45 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 examples/synth_oop.py

diff --git a/examples/synth_oop.py b/examples/synth_oop.py
new file mode 100644
index 0000000..865e784
--- /dev/null
+++ b/examples/synth_oop.py
@@ -0,0 +1,45 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: CC-BY-4.0
+
+Copyright 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import tracecruncher.ftracepy as ft
+import tracecruncher.ft_utils as tc
+
+# We will define a synthetic event, to be recorded every time a 'start' event is
+# followed by an 'end' event and both events have the same value of a 'match' field. 
+
+# Get the static kernel event 'sched_waking' and 'sched_switch' from system
+# 'sched'. Those two events will be used to create the synthetic event.
+swaking = tc.event('sched', 'sched_waking')
+sswitch = tc.event('sched', 'sched_switch')
+
+# Add to the synth. event two fields from the 'start' event (sched_waking). In the
+# synth. event, the field 'target_cpu' will be renamed to 'cpu'. Use the 'pid' field
+# for matching with the corresponding 'end' event.
+start = tc.ksynth_event_item(event=swaking, fields=['target_cpu', 'prio'], match='pid')
+start = tc.ksynth_field_rename(start, field='target_cpu', name='cpu')
+
+# Add to the synth. event one field from the 'end' event (sched_switch).
+# Use the 'next_pid' field for matching with the corresponding 'start' event.
+end = tc.ksynth_event_item(event=sswitch, fields=['prev_prio'], match='next_pid')
+
+# Define a synthetic event. The 'match' value will be recorder as a field in the
+# synth. event using 'pid' as name. We also add to the synth. event a field that
+# measures the time-difference between the 'start' and 'end' events. This new field
+# will use 'hd' time resolution (nanoseconds).
+synth = tc.ksynth(name='synth_wakeup', start_event=start, end_event=end,
+                  synth_fields=[tc.ksynth_field_deltaT(hd=True)], match_name='pid')
+
+# Create new instance of Ftrace.
+inst = ft.create_instance()
+
+# Apply a filter and enable the synth. event.
+synth.set_filter(instance=inst, filter='prio<100')
+synth.enable(instance=inst)
+
+# Print the stream of trace events. "Ctrl+c" to stop tracing.
+ft.read_trace(instance=inst)
-- 
2.32.0

