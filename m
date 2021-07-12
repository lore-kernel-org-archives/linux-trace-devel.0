Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A6CC11F67
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B93961004
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbhGLMKR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Jul 2021 08:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbhGLMKR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Jul 2021 08:10:17 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5947BC0613DD
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:07:28 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id k27so3992529edk.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f5g39+qOjCuYpw84giJ6IYfWYCyAba3AS6qJtwKdxKA=;
        b=R9fSt75gH8sTfhzJakPASTL2Wo/QCPSMd2H6af3k5Xfjgz0AUEnKGd6LmCXPJPRd6P
         kZ6yyJtkK2eP2FvvWQdqcqpSU66xv1Wyc5JUlkkdiBD89Y/wf4ZzCWCafSd2XSQo4GCH
         srSQudGD3he+ap7+YPF/x3UuRJDikqjeUC9b8VpoO2bWQtaWkcdYEI0TP/LclMMxjWh3
         7brihxPUiawgGqvX26Tnnfc778rk4y2HP0b36uIwXLBoMqGGkqrbEyx+ynhyTXg2Uygj
         Nqq3zn7K0DEGqNcK4I2pzpDP8dACKwwymcb318/FMNZQrHBTOLz8SFTYVVze4pbwiiPn
         nA2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f5g39+qOjCuYpw84giJ6IYfWYCyAba3AS6qJtwKdxKA=;
        b=rabxo5169qMydk2cE58joTnOBVlzBwlJePDBUOrR2L0yEEgswMaI7ZSsdT5SwGQpE4
         8n9Eu6o/f20lDYsvnbRu7KPQc0K8uXot/61RmMJd8hMSSXhA7I85epNqLvfp/nSg3FuF
         KvOBmnoUE+vzyhLoElArcCeNHspE6D6vPtX2uEv6HhzEViWt8kBv+pCbrZ6A6f4PsiJJ
         98ynAI1sm1gIn0g253mdJ0lSbDaRb3x+CtoP6TxNYNDrAfOLVEEFt4R4x+ury58MV2wI
         RnKi0wyzST2jZbL1O8izDn0r1nA3hXHk7LdwXhajWvS/LoFYGy7k0ZLLwzwRACUpygut
         RLPQ==
X-Gm-Message-State: AOAM533RsESOvzI4F2WoM+GhO7wuuGG+B7nuxPdWFbGezV6PKURFU7wV
        Va7kXYrwZg+JCoye4vVLdljF5LWaRs8=
X-Google-Smtp-Source: ABdhPJwErLrIzU/U6VrFawDeCPtQv+41iz51B4u3Qm/NzKDtgDMLWAHYxgzmpiC0Zhrgej9Xa/VYaw==
X-Received: by 2002:aa7:c5c3:: with SMTP id h3mr1277123eds.376.1626091646788;
        Mon, 12 Jul 2021 05:07:26 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.98])
        by smtp.gmail.com with ESMTPSA id ee29sm2900809edb.39.2021.07.12.05.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:07:26 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/3] trace-cruncher: Add Kprobe example
Date:   Mon, 12 Jul 2021 15:07:06 +0300
Message-Id: <20210712120706.221921-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210712120706.221921-1-y.karadz@gmail.com>
References: <20210712120706.221921-1-y.karadz@gmail.com>
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

