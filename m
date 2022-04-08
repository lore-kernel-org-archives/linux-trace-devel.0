Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D38C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Apr 2022 10:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbiDHKGS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 06:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbiDHKGE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 06:06:04 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CFBBBE0E
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Apr 2022 03:03:47 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id i27so16263911ejd.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Apr 2022 03:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I+7QGiwNQdtdU3g6ibqa/9A1F3sk3TZU8yarlBnuJDc=;
        b=H+c/8+KC9He/Vhwu7AM0plh1p/+jinjBaQ0CWmRhWctCx/TyTqKXQO+gDEDJi6jAlh
         y1f7KV/CoPd65vA95G9eWhfrmqFV2wjcBxIOozbh+Bc3FUnqEihChRhxxlicivDO7pCE
         s3wSLOtVg1IUzEM2MirRn06rtYbhuHZMBLCOUpc5lzKGhiP4uLfn5Bbf/t7B2v6B/gjK
         1Ers6qlRmFuQTyM01y0cvCPxAAke4aAK2Xbd648sYR8vT56++yrdfyIWY6EJlGeysJ9T
         TGVgwMjcjKaYKJ2mDSoGFpWZe1pX8mW8Tef6Yyi6rpwd4pAatpIENA4BrX56HTAPdG6n
         s1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I+7QGiwNQdtdU3g6ibqa/9A1F3sk3TZU8yarlBnuJDc=;
        b=WZDIgTL7bBiSxNv6nFFJWpmLBDY2qcAYwP39t31/73kl9yt+xp7qzSeI1YegRUheHR
         x/wczoZ5t5qbqFaQ2aMt97rjwFzcyL1D29EYLXI/T3TjRvwyLrS1aj2rDlMhPhsc+5yy
         kHHdJsMRsibD70v33ecoBvd2PProspYkBGBJBlesYTm1m7a2L1ZWF6peeXrlPVTBsJ4t
         4cpKVS1q4h3H3jmr/e8VmP6N5NDfZF6nOSelbHz6ATRgfBpI+IrTY9sTxKPAJ27bqN2Q
         DC+e2vYMBn2NNQGj7Kel50hZI8Hh77pywbCCLyFJ1wpbw5VVpIa4Ga0zKEE+zAOfxJkH
         YTmg==
X-Gm-Message-State: AOAM533cQF30NCSXkT/Hji1Aj0aiDOluGgIDDX3VEMYmympKyF0fmwoK
        VAL89kppnpWAHTxQckc+npF6hQXOsrY=
X-Google-Smtp-Source: ABdhPJz9XEMS1GXrY85cC3BlXQf72RYL7Cm9/nRD70eDUD5sNm9XFsE5SGwmUG8M5DkQt55q0zK+CA==
X-Received: by 2002:a17:906:60c2:b0:6e7:681e:b4b7 with SMTP id f2-20020a17090660c200b006e7681eb4b7mr17557383ejk.130.1649412226023;
        Fri, 08 Apr 2022 03:03:46 -0700 (PDT)
Received: from oberon.zico.biz.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l17-20020a056402231100b0041d0718a3e3sm1860369eda.23.2022.04.08.03.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 03:03:45 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH v2 3/3] trace-cruncher: perf example
Date:   Fri,  8 Apr 2022 13:03:39 +0300
Message-Id: <20220408100339.594358-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220408100339.594358-1-tz.stoyanov@gmail.com>
References: <20220408100339.594358-1-tz.stoyanov@gmail.com>
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

