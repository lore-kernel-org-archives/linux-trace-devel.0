Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EC4C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 16:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiBXQhv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 11:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiBXQht (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 11:37:49 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B02B767B;
        Thu, 24 Feb 2022 08:37:19 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id h15so3658028edv.7;
        Thu, 24 Feb 2022 08:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DRp6HxKjBEIGZmE5BvCC94ci3MHf9GanMRxzhriX6NM=;
        b=YKXQLOFwVMqKTnQfSqCUdy1CPkD4YP8GJL6VQ55XekpBacosa7KlKtYh75jRWF4VOU
         QaLH+60NGwAvfqMrkUZaSR6umX4c9V5BRCEw7st1c5R0f9/iqqWDyiopsSbnic7Kbfqh
         AAo3N6+VByQkANk43nB7TX97fucyEB36mBBNQxL5W67TFwFDMY4yKzBFBsH55+7cngWV
         9L+HBvuXiMsOT9EoGmojax3EmWZP3H7IlPfYWvzWdP3vX/Qfn7XRMhMo60Enq0RSzMB7
         iVXPrErq7Cr8SAy455UBCOB3PCVWTCngDICaJ2L0Jc8VkWo0+NO342sGajT6piCHJKQD
         knAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DRp6HxKjBEIGZmE5BvCC94ci3MHf9GanMRxzhriX6NM=;
        b=68MkLQu5FZ+JFsOBEMobOAygK7jbBwvwj6vLo1EeWkM2cWBN+OLEl1zhWofs+0MLc0
         6tcS+04MwqJfJA6VsZQ0QYBTvdDiG//vdMoeoJ29DZZyW8rcDnT9uBfQ5PHTaBB6JJyG
         G3OxoOdSQueTnLMsj1mngnREBwCI3jEf/waPqRJDxDd3RjM1nVlE4LzIULBZ57cOlpZO
         9Il//FwHTg8BBpLabjke717dZF5sOD6zrUBvjNsFipnpBWqN3eLsTfwibjpgftGp35jk
         b13XpDvtCRqpqxd72oxALa2NVw/8U0Z8LkL3rRrG7UAqaF0UGZx7cbZ1QKcL8CQFfGG3
         ALEg==
X-Gm-Message-State: AOAM531vNysoI61wPF2UAFmvqO+XuWwGu6IzGr8iaf5G135c4KoPfBUr
        c5s8XLZnZ0FByLBplMsg+FU=
X-Google-Smtp-Source: ABdhPJw1UUT9XRvR9BSBsUrlR7S8vvqGkFoczf2TiWXu1zYwYrKoQPVxxSXc7KfY5FYoxl3Nmu6tEQ==
X-Received: by 2002:a50:d086:0:b0:413:38a6:24a7 with SMTP id v6-20020a50d086000000b0041338a624a7mr3043707edd.183.1645720638028;
        Thu, 24 Feb 2022 08:37:18 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o10sm1579690ejj.6.2022.02.24.08.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 08:37:17 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com, acme@kernel.org, olsajiri@gmail.com,
        irogers@google.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [RFC PATCH 3/3] trace-cruncher: perf example
Date:   Thu, 24 Feb 2022 18:37:11 +0200
Message-Id: <20220224163711.185308-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220224163711.185308-1-tz.stoyanov@gmail.com>
References: <20220224163711.185308-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Example python program for using trace-cruncher to collect performance
statistics of a given process.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 examples/perf_sampling.py | 51 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100755 examples/perf_sampling.py

diff --git a/examples/perf_sampling.py b/examples/perf_sampling.py
new file mode 100755
index 0000000..1b57f39
--- /dev/null
+++ b/examples/perf_sampling.py
@@ -0,0 +1,51 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: CC-BY-4.0
+
+Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
+"""
+
+import sys
+import time
+import signal
+
+import tracecruncher.perfpy as perf
+
+def SortKey(sample):
+    return sample.time()
+
+def perf_stop(sig, frame):
+    # Stop collection of performance traces
+    p.stop()
+
+if __name__ == "__main__":
+    if len(sys.argv) < 2:
+        print('Usage: ', sys.argv[0], ' [PROCESS]')
+        sys.exit(1)
+
+    # Create perf sample object for the given process
+    p = perf.sample(pid=int(sys.argv[1]), freq=99)
+    signal.signal(signal.SIGINT, perf_stop)
+    print('Start collecting performance data, press ctrl+c  to stop')
+    # Start collecting performance traces
+    p.start()
+    # wait for ctrl+c
+    signal.pause()
+    # Get collected samples
+    samples = p.get_samples()
+    # Sort the list based on the timestamp
+    samples.sort(key=SortKey)
+    time = 0
+    ip_count = 0
+    for s in samples:
+        # Print PID, TID, time and trace depth of each sample
+        if time == 0:
+            time = s.time()
+        print("{0} {1} ({2}), +{3}:".format(s.ip(), s.tid(), s.tid_comm(), s.time() - time))
+        ips = s.stack()
+        ip_count += len(ips)
+        for ip in reversed(ips):
+            # Print stack trace of the sample
+            print("\t{0}".format(ip))
+    print("\nCollected {0} samples, {1} ip traces".format(len(samples), ip_count))
\ No newline at end of file
-- 
2.34.1

