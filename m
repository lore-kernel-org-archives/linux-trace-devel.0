Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BAFC07E9C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Jul 2021 13:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE1E61493
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Jul 2021 13:53:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhGHNzn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Jul 2021 09:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbhGHNzm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Jul 2021 09:55:42 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E4AC06175F
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Jul 2021 06:53:00 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id c17so9706763ejk.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Jul 2021 06:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f5g39+qOjCuYpw84giJ6IYfWYCyAba3AS6qJtwKdxKA=;
        b=F1o+CEQerXtA49SmYeRkPfWdLhAPBM0X1vnPzpeNckanQS0M8XtbgZNQNmMVmHHYFA
         05cjzs2c+Jl81j+i6sndOKAAZQK8jwlMchnfZRRNWCMZDBUgDyA4r86szP82F/89Ghkg
         5oKx8URVDcepxrwj2XGgEZ3hPk3jGjXmIVcBVuzB7JA4pwWQ43e1qKAcXcIBZWnKDJwG
         hi6NJ7jfXrEkuipwDIe7AQN98rK0lpr6D44jxpRAD9PzbPAzpWTG6JTePXeY+cimY8Ug
         oOKccqWM/TPwgvu7E02TZpb5Ze7KC+GLx9cLykW9iuyLTJ88esSUQBzEg3y/0uv6fCmH
         wm7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f5g39+qOjCuYpw84giJ6IYfWYCyAba3AS6qJtwKdxKA=;
        b=eGCLAFydu5oOLzFxMx0iOhT0wFak/l9UvUX00VXpT6LaFlc/ljukA0hLZRQ5WLwgeE
         xSZta+dc4JxKT+RC/CF+weB4wEnKHyRB2OpD23ep8Rv+au+9Fp14swRjRQYVT6yWpAWI
         Wsdf/G4naa4+fTu+R+ShZO7z1vwm8wx/5OSuUCFXBkZJ7Ys2KxK4RDZY40heIticKb6I
         BW6KdwISBt/kUMYUtzbfv3DB2dqvMUs4LDu7T9L7Xpdq4C1xm7e5YzeNkmx9ncmpGMnn
         ad4CNy/NOfUKu/7P8R1esINQ1oAqVHnwbZ2ffCE4raTo5Ehzxs7rgNtD4q0cHTA96QpX
         Q8GQ==
X-Gm-Message-State: AOAM531JMfJ8T6bvPrBCTQt2aoU7ZwPtCTaQxZ0g3kdDpt2zM9qRzlLn
        pfAdUKSwn0ipwocEwtGAK4YjMx8b5go=
X-Google-Smtp-Source: ABdhPJy7kTPrPkAbCl2cvLvC2aqP1kqApHmMAR/EbsVLLYFvrPRRYUGJHA40QxlMclb7tHbpW7/rmQ==
X-Received: by 2002:a17:906:719:: with SMTP id y25mr15531199ejb.82.1625752378588;
        Thu, 08 Jul 2021 06:52:58 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.215])
        by smtp.gmail.com with ESMTPSA id hz7sm996487ejc.27.2021.07.08.06.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 06:52:58 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] trace-cruncher: Add Kprobe example
Date:   Thu,  8 Jul 2021 16:52:43 +0300
Message-Id: <20210708135243.25229-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210708135243.25229-1-y.karadz@gmail.com>
References: <20210708135243.25229-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a very basic example that aims to demonstrate the usage
of Kprobes in trace-cruncher.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/kprobe_open.py | 44 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100755 examples/kprobe_open.py

diff --git a/examples/kprobe_open.py b/examples/kprobe_open.py
new file mode 100755
index 0000000..f8d4d8b
--- /dev/null
+++ b/examples/kprobe_open.py
@@ -0,0 +1,44 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: CC-BY-4.0
+
+Copyright (C) 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
+"""
+
+import sys
+
+import tracecruncher.ftracepy as ft
+import tracecruncher.ft_utils as tc
+
+open_probe = tc.kprobe(name='open', func='do_sys_openat2')
+
+open_probe.add_string_arg(name='file', param_id=2)
+
+open_probe.add_ptr_arg(name='flags',
+                       param_id=3,
+                       param_type='x64')
+
+open_probe.add_ptr_arg(name='mode',
+                       param_id=3,
+                       param_type='x64',
+                       offset=8)
+
+open_probe.register()
+
+def callback(event, record):
+    if event.id() == open_probe.id():
+        file_name = event.parse_record_field(record=record, field='file')
+        flags = event.parse_record_field(record, 'flags')
+        mode = event.parse_record_field(record, 'mode')
+        print('file: {0}  (flags: {1}; mode: {2})'.format(file_name, hex(flags), hex(mode)))
+
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
2.27.0

