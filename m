Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBC2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 08:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242525AbiAXI46 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 03:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242514AbiAXI45 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 03:56:57 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E61DC061401
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:57 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id r14so1592417wrc.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IT9fnsBeCvct00PWZinRFT1MylwyyrFzOE1yTCdvq8Y=;
        b=mXRfYyiJmpf2XCW49h0PZrTrCGqO8dsdFJ1/3sKRpMysmjKGUQhxgI6gxrmLpYYFc9
         MXO8C7RWdBquYHDiZX3BeIpnuf2o4ic+/hUMc3Lg5WygH7FSm3zoLpE313vxHWcBWwON
         ObNIc6R7tpoMNh8smbemVFkgz8yFuyGjFPw93PqPV35yEzZR+ua28FrpqQMrmZ0TDS4i
         p5gIJulccNHhczkVhiLlt4hNSamQYNcu7riKD7spqUte0QXIu+KNIYAT8gscvl/4pH4E
         quwhMy2UWNurd7YsFFYYRYm+Ip9PfNoU9vBALg0Z6UeB6Drx8uyjiaWFdPTqfkQwuuNn
         X12Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IT9fnsBeCvct00PWZinRFT1MylwyyrFzOE1yTCdvq8Y=;
        b=QCQb5/4sWjOcEkJ/dsfPRele0G2WrGU2waDIvQ69uaJSsWuP/6lhwtvlKKy8wcS6j6
         QAnj41kRcuX7pi5eLSfL/4KUdynJyHy7KQO5LNTMKO/7sCvF7rFLEwxggqBFWBpRvPP+
         O+hT78egvJIsxIf65LlILI6GNw5ZGM+ZS1kfeOwvlayOeT/3bEjdu13z4y3vfejyNQxh
         7ox7Hi2QEnIJ9JasV8HHhK2aVd6i/ErVvJUgKmGe403VJ1QclYi6Vh5dsI3uLSimR2OW
         uSKeBt3vsmNl2v/ws5QhrqRlbNhGKicZ7iW49F3VY7BfSiHeZRs02cgG3FPVO+3W5ZlO
         MHfg==
X-Gm-Message-State: AOAM531sV0/KTNL8CO0LyqpU6XrjkvW9JF0uliB5108GA0nJHViu+QjR
        y6krIPpRvRN59mnFvcbo5U0WsvMl5+A=
X-Google-Smtp-Source: ABdhPJywsW/NUV8fYQhwUbMMYyZMUcU9PA2+Drax8VfPoK9QvCvrovVO8QV1XOk5EK9O937UsV7RpQ==
X-Received: by 2002:a05:6000:1869:: with SMTP id d9mr3619160wri.432.1643014615721;
        Mon, 24 Jan 2022 00:56:55 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id f14sm14828091wri.44.2022.01.24.00.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:56:55 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 09/10] trace-cruncher: Add synthetic event example
Date:   Mon, 24 Jan 2022 10:56:24 +0200
Message-Id: <20220124085625.92297-10-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220124085625.92297-1-y.karadz@gmail.com>
References: <20220124085625.92297-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a very basic example, demonsting the usage of the new APIs
for kernel synth. events.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/synth.py | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100755 examples/synth.py

diff --git a/examples/synth.py b/examples/synth.py
new file mode 100755
index 0000000..ec9427b
--- /dev/null
+++ b/examples/synth.py
@@ -0,0 +1,43 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: CC-BY-4.0
+
+Copyright 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import tracecruncher.ftracepy as ft
+
+# Define a synthetic event that combines 'sched_waking' and 'sched_switch'.
+# A synth. event will be recorded every time a 'start' event (sched_waking)
+# is followed by an 'end' event (sched_switch) and both events have the same
+# value of the fields 'pid' and 'next_pid' (belong to the same process).
+synth = ft.synth(name='synth_wakeup',
+                 start_sys='sched', start_evt='sched_waking',
+                 end_sys='sched',   end_evt='sched_switch',
+                 start_match='pid', end_match='next_pid',
+                 match_name='pid')
+
+# Add to the synth. event two fields from the 'start' event. In the synth. event,
+# the field 'target_cpu' will be renamed to 'cpu'.
+synth.add_start_fields(fields=['target_cpu', 'prio'],
+                       names=['cpu', None])
+
+# Add to the synth. event one field from the 'end' event.
+synth.add_end_fields(fields=['next_prio'])
+
+# Add to the synth. event a field that measures the time-difference between
+# the 'start' and 'end' events. Use 'hd' time resolution (nanoseconds).
+synth.add_delta_T(hd=True)
+
+# Register the synth. event on the system.
+synth.register()
+
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

