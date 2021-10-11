Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BBEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 12:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F5F060F3A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Oct 2021 12:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbhJKMKs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 08:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234733AbhJKMKs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 08:10:48 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E454EC06161C
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Oct 2021 05:08:47 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id o20so55386169wro.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Oct 2021 05:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vzpc9yem+OywQP3JOOfuB4cyulhSBiGbOoZJ0+yMsSY=;
        b=ZWXxPLogYWZpHD1Kq1Mun3zJfzo9QkGwpgNfXMhhgkY2+d5Fgt8fElxX+J1ME3ZPoj
         HuRSIO9AR4D1wdfs1kxu4dBHoXkBj7pj/Yqd6G7RdXOKrb7BT0Nt0noHFEOqJieGHnTG
         j9X1HBYncfa0/IW5r5X5gnAiLl6sXBDVxqkDxLnrdtZ+I5TIBfFfaQH/mYMsmpW3hd8o
         H9B1gX9Htp0RdUjiplf6K8FEu+wjJsR5hVvKvnzTHe1HxWoKM9N5/mtOfKLKfsSkwJ6O
         ckaVSuylzIiS8b9mdOohd4zeOMBt5VOT5HmzFU99uETuQF0oQK+RiDMDITxaOoe3jFOE
         uLgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vzpc9yem+OywQP3JOOfuB4cyulhSBiGbOoZJ0+yMsSY=;
        b=pXafGtCkiIjOSaSHQkDHUr2/OBOvuq9Xx5vlOQyUd0VWvWgJZD0+MdZz1IIKYURiYM
         u47+vlex8zrhPUKVlHig2bfrU1YEq/Lw0eKlYa4toRCoZtogNelBPANMDGKhZGfNHpal
         ObuxNt7kVFBpcm5ghfDE4ZjjfFXztthc0a7OGMGgteB7Rft7aNu/Ogk4Zzfip46MQ5uz
         XsfkLL0i8W3cAIwkdwLSRFocYM+mZaH1ooVMZFuyYs+axrcFG+0vezcn8MLkYow4QNEw
         24Sle7V+jenBxwTsWhhhdKEFg/d8ZXGO40z6znJ6XoAfayrxzTzGr/1xICmRgSIQbXzv
         QL2w==
X-Gm-Message-State: AOAM530xQB4Magk6jZQouEaDTyYQAL7PMO0S3ydwK3pzUy4vSqdhc4pP
        +q7LanFS6sKDeWe7rd9cdl/inos7k91H0Q==
X-Google-Smtp-Source: ABdhPJzXxjeb6zRQeFPm3LU98cvxqglQhyhrf8AoYDcvKogsgn/A3OHuPANe7Q7ccD/qrexTq6jtqA==
X-Received: by 2002:adf:d1ee:: with SMTP id g14mr24477239wrd.264.1633954125790;
        Mon, 11 Oct 2021 05:08:45 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t14sm6034942wrr.75.2021.10.11.05.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 05:08:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] New example for syscalls tracing
Date:   Mon, 11 Oct 2021 15:08:43 +0300
Message-Id: <20211011120843.1704006-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New trace-cruncher example script dumps all system calls of given
process and its children.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 examples/trace_syscalls.py | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100755 examples/trace_syscalls.py

diff --git a/examples/trace_syscalls.py b/examples/trace_syscalls.py
new file mode 100755
index 0000000..4cec54f
--- /dev/null
+++ b/examples/trace_syscalls.py
@@ -0,0 +1,34 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: CC-BY-4.0
+
+Copyright (C) 2021, VMware, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+"""
+
+import sys
+import tracecruncher.ftracepy as ft
+
+args = len(sys.argv)
+if args < 2:
+    print('Usage: ', sys.argv[0],
+          ' [PROCESS ID 1] ... [PROCESS ID n]; print all system calls of given processes')
+    sys.exit(1)
+
+# Create new Ftrace instance to work in.
+inst = ft.create_instance(tracing_on=False)
+
+# Enable all static events from system calls.
+ft.enable_events(instance=inst, systems=['syscalls'], events=[['all']])
+
+# Filter system calls only for the desired PIDs
+for i in range(1, args):
+   ft.set_event_pid(instance=inst, pid=int(sys.argv[i]))
+# Also, track system calls for the children
+ft.enable_option(instance=inst, option="event-fork")
+
+# Enable tracing
+ft.tracing_ON(instance=inst)
+
+# Read and print traced events, until <ctrl-c> is pressed.
+ft.read_trace(instance=inst)
-- 
2.31.1

