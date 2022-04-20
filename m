Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C356C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 08:02:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376598AbiDTIFD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376433AbiDTIFA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 04:05:00 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929F93C4B5
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 01:02:15 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id g18so1795199ejc.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 01:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BIRv3Z1Yu8sQXl4ViSztyM9UBTpvjZTiPqvH6s98QZw=;
        b=A7/T81ezZzYwNiFeHP95a46KAsJScCCacvw/hRNdZJ8yRe2XdWf1+HunNuJQn4WoPI
         jqu/gPc7YR3tf9FUJ5HuoxdXHIkzbNSpwrfzEhNLS+uzPYuhFRSov7cl3Gk/7tkO4A2A
         lwT/snZPRjobKYpTaWptNBLFtZ1GwVFbH6IavDPhkxMeH45XTHurJmdZ7iqGNLleKnMm
         nlydQn4HG28sTgWLKSxW8+seALrBiKi3FIH2CCuwQNnqXRhw8KMDTK7uobwktfR2atvL
         6hMbjmK3K91Ip+GXGo8isgZsdeHb4a+kEJaHtgD2ZdIsw+wPqcOEtHYQc9YUIqkCrnWB
         P1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BIRv3Z1Yu8sQXl4ViSztyM9UBTpvjZTiPqvH6s98QZw=;
        b=hsQuUMDXNMEZ0tMsqWyid61VhmRvgS3lu1+6WzUOCmui6zbsowyHWEiiAiNTugZRHx
         YtajghYzaUSolW8Ehb3gTRXWJHopM+1PF/ie49+lmmR+Xp/ALBD3dLKXwwddIq4YNNdy
         py/Nw6i6PaHEgxOOmOyT5G+uPqmklGkoX9zQAdB/Hhdb1ib/LPRmMv9snovn4Usok6Yn
         +dTeuL9DTdr2XVrgGuFt7oRugQ4NaMulcO+tSeFN57BxiuMsDGG3GdsL6YItMrhGCXql
         wyT1AayDAxh/j58LSskNo6YfOdShhgnAjSy+nUWHutgzIUh0D45bI/8EoKrn+RzXi+44
         w8OA==
X-Gm-Message-State: AOAM533oQNnX4UncUZreCE7qWy81CJ2zXHouxy7Uf3uH5jvjdC/BM/Mb
        6sNc0VQTGwXfhQZwDKcSqu0=
X-Google-Smtp-Source: ABdhPJy49wf3Qs7+TAjdsjtOe70qlRMZJ3SXwcDoktxMNTyDa/HCOadGpcZgJLbpu+HDUx8mI9A2kQ==
X-Received: by 2002:a17:906:d9cf:b0:6ee:32ef:8da with SMTP id qk15-20020a170906d9cf00b006ee32ef08damr17538522ejb.750.1650441734087;
        Wed, 20 Apr 2022 01:02:14 -0700 (PDT)
Received: from oberon.zico.biz.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t12-20020a1709067c0c00b006e86db76851sm6393763ejo.193.2022.04.20.01.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 01:02:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH v3 4/4] trace-cruncher: Example script for uprobes high level API
Date:   Wed, 20 Apr 2022 11:02:06 +0300
Message-Id: <20220420080206.252356-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220420080206.252356-1-tz.stoyanov@gmail.com>
References: <20220420080206.252356-1-tz.stoyanov@gmail.com>
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
 examples/user_trace.py | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100755 examples/user_trace.py

diff --git a/examples/user_trace.py b/examples/user_trace.py
new file mode 100755
index 0000000..3fdef26
--- /dev/null
+++ b/examples/user_trace.py
@@ -0,0 +1,39 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: CC-BY-4.0
+
+Copyright 2022 VMware Inc, Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
+"""
+
+import sys
+import shutil
+
+import tracecruncher.ftracepy as ft
+
+if __name__ == "__main__":
+    if len(sys.argv) < 2:
+        print('Usage: ', sys.argv[0], ' [PROCESS or PID]')
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
+        utrace = ft.user_trace(argv=sys.argv[1:], follow_libs=False)
+
+    # Trace execution of all available functions in the given process
+    utrace.add_function(fname="*")
+
+    # Add trace points on functions return as well
+    utrace.add_ret_function(fname="*")
+
+    # Start tracing in an instance
+    utrace.enable(instance=inst, wait=False)
+
+    # Read the trace buffer during the trace until ctrl-c is pressed
+    ft.read_trace(instance=inst)
-- 
2.35.1

