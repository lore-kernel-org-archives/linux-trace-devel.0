Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0550BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 07:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbiA0HBT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 02:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237030AbiA0HBS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 02:01:18 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F053C06173B
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:01:18 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id b13so2362114edn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FL5QkgZS1Ox/933zA1U8FsAUnggCkt58Ers1x/2y+WI=;
        b=DSZ4P6hoiZC9tLqiFSEZdN/m/7t5lxV+OI6SOZL03xbv74FBsZjVLEHTNOvOrlP/vY
         btPLA7+Wo6uB9bXdeRAij0HfkznmlUCuA7cDs+7Zv3efYkTGG+M8RBJGEaeWaiZ6e/az
         xId6ixkXnXpa2hzg0AImt26o78ZheYXiw+HivjDCBmPrG3u+xsumhnBQYh6nvcg82EpC
         1avX78XTfqoz6yF2ev+cVvMw7L3jV9TbBKqVJMnG90+YQ8kh7/Odr4px7AZCBC25XwIa
         NgJfow3L4kzaOuVsiI1d20RbrVVVcWbcY0+XJ2Cf3IjYE8vHd6MuPzxdfFrwJ+lf4O5m
         Eykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FL5QkgZS1Ox/933zA1U8FsAUnggCkt58Ers1x/2y+WI=;
        b=JsesVLZbADWfm2yunn76Xm0K6KIy2WHx2JMGK3K6lOPC35vltWxOeKf788bEmo5KyA
         YuJYB5ZbF8NFUeZnQmaWqITdR2+c903H1sELqSOBi6josHP2lTrS2sirVrfIfp+uTe79
         k3B75pGUcwliumzxRn/sW4bNqr2l5acuHWuXvTqJQx5CiwwHd4WsN+zAJTbby3murnKb
         jHiapbo8tvmru5hFcIaVVRq5fgRwyuKhO5NKYCTossxwnvx5VnDhaXtqGYQ5SvGi5Qjf
         gNRkBtx5f4VRMIguMHwCYb9CDIOB6kqjzYiFQtcENK6O69GUqn20Q3m8p7lNGoaZLM4V
         iEbQ==
X-Gm-Message-State: AOAM5329y/8YELbRsTHsWd+t3QPt6tgn0gjMfGYrNPwOboEcu0xV3UTH
        EUSuTZzzA/tXNfja0jF5PoamImySUGc=
X-Google-Smtp-Source: ABdhPJw9XBCKzsqDSeDPDzOyzTZVe3ML93uC9NOTqFHH2P+u3bZid/hwk6hiu1jO78YWuQ/r6Dm36w==
X-Received: by 2002:a50:ef05:: with SMTP id m5mr2343338eds.47.1643266876974;
        Wed, 26 Jan 2022 23:01:16 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i17sm8317079ejp.60.2022.01.26.23.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 23:01:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/3] trace-cruncher: Example for event probes API
Date:   Thu, 27 Jan 2022 09:01:11 +0200
Message-Id: <20220127070111.27529-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127070111.27529-1-tz.stoyanov@gmail.com>
References: <20220127070111.27529-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

trace-cruncher APIs should have examples, to demonstrate their usage
in a real use case. Added an example for newly introduced event
probes API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 examples/eprobe.py | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100755 examples/eprobe.py

diff --git a/examples/eprobe.py b/examples/eprobe.py
new file mode 100755
index 0000000..85b0685
--- /dev/null
+++ b/examples/eprobe.py
@@ -0,0 +1,29 @@
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
+import tracecruncher.ft_utils as tc
+
+open_probe = ft.eprobe(event='sopen_in', target_system='syscalls',
+                       target_event='sys_enter_openat', fetchargs='file=+0($filename):ustring')
+
+tep = tc.local_tep()
+
+def callback(event, record):
+    print(tep.info(event, record))
+
+if __name__ == "__main__":
+    if len(sys.argv) < 2:
+        print('Usage: ', sys.argv[0], ' [PROCESS]')
+        sys.exit(1)
+
+    inst = ft.create_instance(tracing_on=False)
+    open_probe.enable(instance=inst)
+    ft.trace_process(instance=inst, argv=sys.argv[1:])
-- 
2.34.1

