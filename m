Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8727BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jan 2022 18:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345547AbiA1SVS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jan 2022 13:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244651AbiA1SVR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jan 2022 13:21:17 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50AC0C061714
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jan 2022 10:21:17 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id l25so12396337wrb.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jan 2022 10:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2AitvGUNRIMmDNvFTtfRqZkeAbdUNhueLWGjCIB3t8Y=;
        b=S8rV1O5hyVohvar7M3NahA6bcZT18XQqKpt2X5YCY0wxqZcU9Ys+fKEU3hQGIhHCgY
         cgE5XDv1rO7ZPWCNYiFBNRUsxrCh4qnTvVHdD7zECFP/T4i+MdN5SYJj9orjH3rHQpCZ
         vF6W+LcpNHZe4JgF+CYpNpeinWnsKHmdSDF6goaTXxkLibxJPBj3PrZ6tHzGFR/mGJXJ
         GqKLEbzRX9X4EYxylnNddXrqbRgll9B3EyZ5sXTbTCOR3iUXJFQjeZjVLDciypP5TROO
         IgQZr7Fwrz5zHXttmxwoeZc5WkuvqNZ4V4nBDNtyFgzNAk1L5iphXcFWfRVBHPcSL/I0
         A3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2AitvGUNRIMmDNvFTtfRqZkeAbdUNhueLWGjCIB3t8Y=;
        b=VHhd6cQt/3OTOa6GIzunqh320YDYMOrgva4a9dGB8iK/kJjPZRS9Yx73vLNXO3xdCF
         526k6c2zYpDRBFiLWHka423JX9955cC4Ca4vNCQhslNpwG+mn8OdFL3k/axrEgKEqITr
         qKdtm5QTgDyH1Jxc44qKZXMbThrKRJosxCE+DexDpiEfbNJsr2pzwe8gaksfRJpBN44W
         Ef4UqCvw4aZZAGSTFKKVMI2gI4r1zoMBd2NsovH2F4hoe8E7FCkuNXS83cA0BT3/IQkJ
         XTJ1jFXKb3oeKvUrHVBXCECv56RmKp2oe+geUEZCndTiDhTdstbymDQ/QThH0mo58l8z
         JvGA==
X-Gm-Message-State: AOAM533Y8EGpKo3DjiCGWjC0jDO+IORLlIPK2xEXEV1LmI3wlWCK0NWm
        VMoU4oItb+uNgi8vxhSgmt6ZgYfUvd4=
X-Google-Smtp-Source: ABdhPJz6tiUPg5Ggw/Q+P0tDm5Cn7ZdgMwdrj9WSXz/qsLy4RkG93rTsMaC1nJbzx5NKON/UMLj+Ow==
X-Received: by 2002:a05:6000:178d:: with SMTP id e13mr7914587wrg.183.1643394075495;
        Fri, 28 Jan 2022 10:21:15 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id o14sm6220698wry.104.2022.01.28.10.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 10:21:15 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] trace-cruncher: Add example of tracing systemcalls
Date:   Fri, 28 Jan 2022 20:21:02 +0200
Message-Id: <20220128182102.8672-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220128182102.8672-1-y.karadz@gmail.com>
References: <20220128182102.8672-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a very basic example, demonstrating how the low-level APIs can
be used to trace system calls.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/syscall_trace.py | 66 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100755 examples/syscall_trace.py

diff --git a/examples/syscall_trace.py b/examples/syscall_trace.py
new file mode 100755
index 0000000..7d6f399
--- /dev/null
+++ b/examples/syscall_trace.py
@@ -0,0 +1,66 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: CC-BY-4.0
+
+Copyright 2022 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import sys
+
+import tracecruncher.ftracepy as ft
+import tracecruncher.ft_utils as tc
+
+eprobe_evt = 'eprobe_open'
+synth_evt = 'synth_open'
+syscall = 'openat'
+args = 'file=+0($file):ustring delta_T=$delta_T:s64'
+
+# In order to trace a system call, we will create a synthetic event that
+# combines the 'sys_enter_XXX' and 'sys_exit_XXX' static events. A dynamic
+# 'eprobe' will be attached to this synthetic event in order to decode the
+# pointer argument of the system and to calculate the time spend between
+# 'sys_enter_XXX' and 'sys_exit_XXX' (syscall duration).
+
+eprobe = ft.eprobe(event=eprobe_evt,
+                   target_system='synthetic', target_event=synth_evt,
+                   fetchargs=args)
+
+synth = ft.synth(name=synth_evt,
+                 start_sys='syscalls', start_evt='sys_enter_' + syscall,
+                 end_sys='syscalls',   end_evt='sys_exit_' + syscall,
+                 start_match='common_pid', end_match='common_pid')
+
+# Add to the synth. event one field from the 'start' event. In the synth. event,
+# the field 'filename' will be renamed to 'file'.
+synth.add_start_fields(fields=['filename'], names=['file'])
+
+# Add to the synth. event a field that measures the time-difference between
+# the 'start' and 'end' events. Use 'hd' time resolution (nanoseconds).
+synth.add_delta_T(hd=True)
+
+# The synthetic event must be registered first (and destroyed last), because the
+# eprobe depends on it. Note that the order in which the events are allocated
+# will be the order in which Python will destroy them at exit.
+synth.register()
+eprobe.register()
+
+tep = tc.local_tep()
+eprobe_id = tep.get_event(system=ft.tc_event_system(), name=eprobe_evt).id()
+
+def callback(event, record):
+    if event.id() == eprobe_id:
+        # Print only the dynamic eprobe.
+        print(tep.info(event, record))
+
+if __name__ == "__main__":
+    if len(sys.argv) < 2:
+        print('Usage: ', sys.argv[0], ' [PROCESS]')
+        sys.exit(1)
+
+    inst = ft.create_instance(tracing_on=False)
+
+    # Enable the two events and trace the user process.
+    synth.enable(instance=inst)
+    eprobe.enable(instance=inst)
+    ft.trace_process(instance=inst, argv=sys.argv[1:])
-- 
2.33.1

