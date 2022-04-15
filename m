Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697F9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 11:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiDOLoR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Apr 2022 07:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352702AbiDOLoQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Apr 2022 07:44:16 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF6764713
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 04:41:48 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ks6so15002538ejb.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 04:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I+7QGiwNQdtdU3g6ibqa/9A1F3sk3TZU8yarlBnuJDc=;
        b=dm2bfKFXB1BndupzZ+a9YRIPcIm96HjQx/RkR7fdFuZNSmzquOsZKoQrRBBPERUAQZ
         PtOe5JzRFoc2e14FverLdh38nWnI4mkkbEIkMiEUlWyfv/8GppYovej6I7rnmNSPtpoO
         X8IiDFQsLrI0B+liOHcvqOaX9DHJGK3Q0vGHg/ngzNd/l1pFyA65uc898pH6oKb7Z5fP
         iBJpvoYgRM1w4pacN0S9Yj0vjgBYYgH1zTEAUmiys0MVio3nbYYio0LLIr47BjeguN9x
         oQjHKZELtuXsLjyR1hFkctUv6ezuh7ea/jdr/xQ8oEXzn9p+YiiREujdd10GFzgovIc+
         2RfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I+7QGiwNQdtdU3g6ibqa/9A1F3sk3TZU8yarlBnuJDc=;
        b=VLxYeSUPdLN4iVvW5E3W0Cfcm8kePorQLtro4b+QQVyrXtcGRZznIDTq+FT8r9KKK2
         JGaMg4YVBEY5MUrU67MWom6O5/Rlsgi3teE4AGenBDtYu3ydqtX1DfC9kqOnRTH5nybw
         hFg40rjbE5Q+JkeT1654csuvmoroUKVahSE2HGZg6aAK3AlJqXdXzvBp4pBX6wOYPE4q
         gYFuJmg5tILx8PkghROElyb/Oi1YN6+HhLLg+2c7MOPGsJ5kngI3BPA6ROToJ90gMUrI
         V9FWzSRAW+bnMRVrlcSe0zYG6YE6tFuhuuX+iVG8w4vKpI0Gqu8e23c9Jn9EFscBba3T
         ee/w==
X-Gm-Message-State: AOAM532M1HPejTsPSLzk8GAUYs4eNmysbDeIXdbVC4DW+dsFmkRKz1+m
        xob9TytLPq/uT53UXDgABKI=
X-Google-Smtp-Source: ABdhPJz2HWqo626owkZ2FxaOt4Sx279y+GIVJMsBK0swfurCH91W5HHywQsDrSMSXcXN+I1J/LMAGw==
X-Received: by 2002:a17:906:a2c2:b0:6e7:efc2:17f2 with SMTP id by2-20020a170906a2c200b006e7efc217f2mr5687556ejb.542.1650022906995;
        Fri, 15 Apr 2022 04:41:46 -0700 (PDT)
Received: from oberon.zico.biz.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7-20020aa7cd87000000b004207282701fsm2462878edv.63.2022.04.15.04.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 04:41:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH v3 3/3] trace-cruncher: perf example
Date:   Fri, 15 Apr 2022 14:41:40 +0300
Message-Id: <20220415114140.64468-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415114140.64468-1-tz.stoyanov@gmail.com>
References: <20220415114140.64468-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Example python program for using trace-cruncher to collect performance
statistics of a given process.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 examples/perf_sampling.py | 53 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100755 examples/perf_sampling.py

diff --git a/examples/perf_sampling.py b/examples/perf_sampling.py
new file mode 100755
index 0000000..6219bff
--- /dev/null
+++ b/examples/perf_sampling.py
@@ -0,0 +1,53 @@
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
+import shutil
+
+import tracecruncher.perfpy as perf
+
+def SortKey(sample):
+    return sample.time()
+
+if __name__ == "__main__":
+    if len(sys.argv) < 2:
+        print('Usage: ', sys.argv[0], ' [PROCESS]')
+        sys.exit(1)
+
+    # Create perf sample object for the given process
+    if sys.argv[1].isdigit():
+        p = perf.sampler_instance(pid=int(sys.argv[1]), freq=99)
+    else:
+        file = shutil.which(sys.argv[1])
+        if file is None:
+            print('Cannot find ', sys.argv[1], ' in the system')
+            sys.exit(1)
+        p = perf.sampler_instance(command=file, argv=sys.argv[1:], freq=99)
+
+    print('Start collecting performance data, press ctrl+c  to stop')
+    # Start collecting performance traces
+    p.enable(wait=True)
+
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
2.35.1

