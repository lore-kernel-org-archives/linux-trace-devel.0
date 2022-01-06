Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7342C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Jan 2022 13:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiAFNWM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 08:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239292AbiAFNWL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 08:22:11 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5948BC061201
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jan 2022 05:22:11 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id w20so4720145wra.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 06 Jan 2022 05:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+CktRCeP2Ji58eq8z/vedUgZVGQkN6VSq8zNBfkzYQA=;
        b=qH2lbDsptWEg/oe9GKUZDQB/4OtVcl/veC8AmSazWdeZuOqzT4/FWYNBVh3fhZtWyK
         fb0bsuOn0GwIXDYAGXzSrOfOfbzfWLUR+StBtqLtwI5lSMQgTm8RCV39YUyNv5pChu2s
         cj+KxH3nfqHCwYiZCC5tvNdkqVBLh9qH68hV6dzK8lw4OJmMWRM1skZa/rUmlBeTd+/j
         Hb1rmNEESGuKK6uRYn6301FiL8a+my2PhWD6s3tA4sCcehIz5RPBsYnhn4Vf0YI3JOo7
         czXsAytMTIa11JZtIfEZcRZlvSnCVO6Ik3xHUbbpNOhgk6+Nj/NdWj4R7fdzfEZR0kxK
         Xitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+CktRCeP2Ji58eq8z/vedUgZVGQkN6VSq8zNBfkzYQA=;
        b=WEIpFtNsPV33JRT/j17oFCDwv6/4tAj2MdmuYwF5nTN47F5CafgOuwSDqpsl0iD0q0
         mj2pWrWLZTgJaFez0ds35XBVhb2sZEe/Gb/j6ilazRQikgoZiRnkhAGQfBRTWiuh3QqE
         4mCn3VT28LeZvxToF80zbG7qvwoDkoBQoEEorws1Yi8nNDO9jb7+n30mn2dTd90e+Pf+
         WOlSzUDk9HiPcxnYHZunqU6Xo58ZLsAcVLEd3o6PVD5YnE5129Xqz0XJtWCtJMmGpZA4
         wuChH5a45LuvOfHw21PpmVUzkjOYTG6Ius6/1rWOKtTgjqOUvMPiTfcr02bXhXfecp7c
         soEw==
X-Gm-Message-State: AOAM5326Wz0XeCEBCc02hvTpXmwznaS8kXN2ONPt5T3txCdIDOgrUQrH
        EL0ppduJl42yidZS7IFvr2VjQwv7Ekg=
X-Google-Smtp-Source: ABdhPJyEMVJ3+Y7qkbvl8hyhmBSHVoFLAL+2uOFH9jM82AmBMlVDS9VSN3DvHo8xdixI77OgXQYpKA==
X-Received: by 2002:a5d:588f:: with SMTP id n15mr51737370wrf.279.1641475329800;
        Thu, 06 Jan 2022 05:22:09 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id o3sm2329283wry.98.2022.01.06.05.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 05:22:09 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] trace-cruncher: Add example for the high-level histogram APIs
Date:   Thu,  6 Jan 2022 15:21:55 +0200
Message-Id: <20220106132156.168538-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220106132156.168538-1-y.karadz@gmail.com>
References: <20220106132156.168538-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a very basic example, demonstrating the usage of the new
high-level (OOP) APIs for kernel histograms.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/hist_oop.py | 81 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 examples/hist_oop.py

diff --git a/examples/hist_oop.py b/examples/hist_oop.py
new file mode 100644
index 0000000..1a3aab6
--- /dev/null
+++ b/examples/hist_oop.py
@@ -0,0 +1,81 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: CC-BY-4.0
+
+Copyright 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import sys
+import time
+
+import tracecruncher.ft_utils as tc
+
+name = 'khist_example_oop'
+
+cmds = ['start', 'stop', 'show', 'continue', 'clear', 'close']
+
+evt = tc.event('kmem', 'kmalloc')
+
+axes={'call_site': 'sym',
+      'bytes_req': 'n'}
+
+weights=['bytes_alloc']
+
+sort_keys=['bytes_req', 'bytes_alloc']
+
+sort_dir={'bytes_req': 'desc'}
+
+if __name__ == "__main__":
+    if len(sys.argv) != 2:
+        sys.exit(1)
+
+    if not sys.argv[1].isdigit() and not sys.argv[1] in cmds:
+        sys.exit(1)
+
+    arg1 = sys.argv[1]
+    if arg1.isdigit() or arg1 == 'start':
+        # Create the kernel tracing histogram.
+        hist = tc.create_khist(name=name, event=evt, axes=axes, weights=weights,
+                               sort_keys=sort_keys, sort_dir=sort_dir)
+        # Start taking data.
+        hist.start()
+
+        if arg1.isdigit():
+            # Take data for a while, then stop, print the result and exit. The
+            # trace-cruncher module will take care for clearing and destroying
+            # the histogram in the kernel.
+            time.sleep(int(arg1))
+            hist.stop()
+            print(hist.data())
+
+        else:
+            # Detach the 'hist' object from the trace-cruncher module. This will
+            # prevent the kernel histogram from being destroyed when the module
+            # is closed (at exit).
+            hist.detach()
+
+    else:
+        # Try to find an existing histogram with the same definition.
+        # The returned histogram is detached from the trace-cruncher module.
+        hist = tc.find_khist(name=name, event=evt, axes=axes, weights=weights,
+                             sort_keys=sort_keys, sort_dir=sort_dir)
+
+        if arg1 == 'stop':
+            # Stop taking data.
+            hist.stop()
+        elif arg1 == 'show':
+            # Print the collected data.
+            print(hist.data())
+        elif arg1 == 'continue':
+            # Continue taking data.
+            hist.resume()
+        elif arg1 == 'clear':
+            # Reset the histogram.
+            hist.clear()
+
+        if arg1 == 'close':
+            # Attach the 'hist' object to the trace-cruncher module. This will
+            # ensure that the kernel histogram will be destroyed when the
+            # module is closed (at exit).
+            hist.attach()
-- 
2.32.0

