Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22BDCCA479
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jun 2022 12:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345382AbiF1MQ3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 08:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345380AbiF1MQ2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 08:16:28 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E27F27B2B
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Jun 2022 05:16:27 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ge10so25354883ejb.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Jun 2022 05:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aQBlUNuDgqPvC7NX3xeLdCIV1BWkCfXjevdKpEbnUys=;
        b=eXEjBNP0otYk1MYy5nmqP1oACbp66nI5VnLoAyb7R4MNxubcXFTVvNAlvHd0HGBUgU
         NDQG95GmvFoeObR4uhCmPEEdaiYQPliZBd6+97eFDuOGhTPbCcPJAyahV7TRNDZlQzoi
         +Hct0YxkMzfmyLu3kuYyUfAwMvqiWPyrvIveeSE172gW/UQXZUhhOuoAVGQ1DK2Uyq/9
         799i1WMSgsYvmJhV/eWGCumifPNL50Gp3FoX/GnBhCQZUlV9tA8xrvGYtONpeh3Xw5rC
         BlCLO/r3ZPPoFxY8xtQ0QXC37NV8W9I6kgpdVTg8U2VpTwXRZ222i33fgO4aY3NIjv9L
         v8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aQBlUNuDgqPvC7NX3xeLdCIV1BWkCfXjevdKpEbnUys=;
        b=j6vvM6LSzZxRIfp4GvZxCdgs+LoDOs4coikylGZqxLjhztBxhJ8SDZlevu/KY6Qszc
         6bDBc5AeX1JqLQXF1PK3T52r8XCY8Y6pS2nb7Fjtf9wvlJcPlaOMiT0ZCJjXxCsL39H+
         VKb5ig1mpfgXPAj/FAXWqLiY2WyOUWhv2Ok9FndGGsoRIUpKsMTVTzdGbMgvjggxr572
         WYrt+xIAoIhszsZppuOmkMWSRmwuZVG82gycmUGoOrpr0xglIgajZBOfSSm3F26o79Dj
         U9RJO6iYQojusiEwyslJ2qJlzNLKG4nkvCtqT37dE7lgw1xl3njNFieY6mWczquHhrbk
         NG3w==
X-Gm-Message-State: AJIora9lz5qeDpHCbobIMASlSUsFvNBXbyNdSS5XxZSMk7iS5zLSJQxQ
        XvXXFDu9sTjoHTkC12W05URabJyB7qZE5g==
X-Google-Smtp-Source: AGRyM1sWNg27JPYbj6O/Jt5GzbztVWUdzpNvDlUfpy6w74FylFHaebo4TjZ7J97fEg+zGfquAueoYg==
X-Received: by 2002:a17:907:60c9:b0:726:d038:9968 with SMTP id hv9-20020a17090760c900b00726d0389968mr2799219ejc.468.1656418585792;
        Tue, 28 Jun 2022 05:16:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7c04e000000b00431962fe5d4sm9512780edo.77.2022.06.28.05.16.25
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 05:16:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 3/3] trace-cruncher: Example script for uprobes high level API
Date:   Tue, 28 Jun 2022 15:16:21 +0300
Message-Id: <20220628121621.572506-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220628121621.572506-1-tz.stoyanov@gmail.com>
References: <20220628121621.572506-1-tz.stoyanov@gmail.com>
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
2.35.3

