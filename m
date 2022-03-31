Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68248C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 31 Mar 2022 09:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbiCaJ6Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 05:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbiCaJ53 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 05:57:29 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DADD3DDD6
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Mar 2022 02:55:42 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id p189so13914073wmp.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 31 Mar 2022 02:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3dJaszTQKgqeyQQR8z2WdJafRUs7ovflDs+KgUAnzq0=;
        b=Z+jWtyqixVAgIBOgaLtvcY9Ngx1NSFUvFtOVPrAPGPYl+G4U88Kd83CZGzax2K3UzH
         AQC3ENcmXGjzrLrjze6xlXA9nX4m/1xesSSretsBE+1dKK0bRfXHFiEP5UUvqQiQL5w6
         YcAX3q1PH9aBa+jnoTSnLt+vh25BQ5OxkMiu3DI8Zbtx0c6lFiT6B6DGesEf3CDi3nKB
         SZ5xAzrctq7CSmY82tYk5IsgDgwKYy8rVn0TtkPSEbanSVkabyBjt5k8ZGpL9vaOIq30
         eaZoBLdslfZcHBlalVOdTxpVl1qwxt4xN2iuZ5sPckd9e2Dkf3rk/YRH1gZ3RyyFxpyH
         xCTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3dJaszTQKgqeyQQR8z2WdJafRUs7ovflDs+KgUAnzq0=;
        b=DtUnSfniVvsMq468WTTP+eXBS05dI5FWxunErLTJnocUrUB5kCBH4sEPINc3D2SNkA
         JT7E/eXtx0UrAayUGQM+hRqTOZroD10hBLGF8Agn7MvZV1qp2OjPOryrKaWcIrmXrY6s
         BgtfrzB95i9BQjvyESp3rJRb6PBmZHZ4zYgpYnVc4qHkvXMF3nouerBXmeXMqxq7fgGS
         /AIYggTXoUrIrTgXSf2kIZWIDRtfp1Hnn2O/GDNEUd3LlbfVWeHAOvpKPGm348IuImc9
         nCcOI84xw/OQCIAbnDVKPLwkO7XKYDUqA5+AV9RE4P3NsnDrgBatYicNuiZizmiU3iuS
         ps9g==
X-Gm-Message-State: AOAM533Wo5K62FvWxJeo9/LMAFoAjz26l+vwwi148GI9xm1df5VH0lLp
        /WxI9GfyOFPOlBgg8l3pHAV91BNVZ84=
X-Google-Smtp-Source: ABdhPJzeIOW7qwV3MtRDd0TYlsSyVC3JIbnCXaWFzcFHC2k69X/EV14CQVSKmzLCx9ua/VH5W2iI3g==
X-Received: by 2002:a05:600c:1d26:b0:38e:2c97:6f19 with SMTP id l38-20020a05600c1d2600b0038e2c976f19mr4036971wms.89.1648720540955;
        Thu, 31 Mar 2022 02:55:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm11807493wmq.27.2022.03.31.02.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 02:55:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH 4/4] trace-cruncher: Example script for uprobes high level API
Date:   Thu, 31 Mar 2022 12:55:33 +0300
Message-Id: <20220331095533.75289-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220331095533.75289-1-tz.stoyanov@gmail.com>
References: <20220331095533.75289-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Proposed example illustrates how to use uprobes high level API to trace
all functions for user program. It can be attached to already running
program, or run the program and trace its execution.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 examples/user_trace.py | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100755 examples/user_trace.py

diff --git a/examples/user_trace.py b/examples/user_trace.py
new file mode 100755
index 0000000..0d3adcd
--- /dev/null
+++ b/examples/user_trace.py
@@ -0,0 +1,41 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: CC-BY-4.0
+
+Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
+"""
+
+import sys
+
+import tracecruncher.ftracepy as ft
+
+if __name__ == "__main__":
+    if len(sys.argv) < 2:
+        print('Usage: ', sys.argv[0], ' [PROCESS]')
+        sys.exit(1)
+
+    # Create new Ftrace instance to work in. The tracing in this new instance
+    # is not going to be enabled yet.
+    inst = ft.create_instance(tracing_on=False)
+
+    # Create a user tracing context for given process, exclude the libraries
+    if sys.argv[1].isdigit():
+        utrace = ft.user_trace(pid=int(sys.argv[1]), follow_libs=False)
+    else:
+        utrace = ft.user_trace(name=sys.argv[1], follow_libs=False)
+
+    # Trace execution of all available functions in the given process
+    utrace.add_function(fname = "*")
+
+    # Add trace points on functions return as well
+    utrace.add_ret_function(fname = "*")
+
+    # Start tracing in an instance
+    utrace.start(instance = inst)
+
+    # Read the trace buffer during the trace until ctrl-c is pressed
+    ft.read_trace(instance=inst)
+
+    # Disable the tracing
+    utrace.stop(instance = inst)
-- 
2.35.1

