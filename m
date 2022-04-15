Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013F1C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349355AbiDOEMs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Apr 2022 00:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349354AbiDOEMq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Apr 2022 00:12:46 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24F6673CE
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 21:10:19 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id g18so13470456ejc.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 21:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zEwjaKVDYMyTHYt+MgnjUsT/Q1wODghcQ0xS6cuAwXk=;
        b=Nrwu+aST+6pCQPznHa/sg0lFtNDHxR96Uvd5QQHRNH7bgEvP90LrCUl6LKwI8AfNZn
         TEpMzYF0KSGFHNe0KL5+uvAPFcFIraC40+22NQv4vdNrpN1ldQqgX7Kle7j5tUgJXiZu
         1mar91FgFThqPbBY4GjEEgKjzbMFq4yqvTYY7h3lxfeLD8BJrhJkdo+/Ie+mBzKJEHYE
         ryI/gJL/YYZgPdw1K2ptJSAwTMEePWf+atWb/cfauQAJ1/v28uc36PiJk+ctB0KT7aPH
         pLniRwSEEcfiO4z0wpS4NYBLX1QzfqHi4pVPLPPZcvxpER+g2uNsb68oZkDfWXsTLwsT
         fVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zEwjaKVDYMyTHYt+MgnjUsT/Q1wODghcQ0xS6cuAwXk=;
        b=VQSCQKsBH0/Z0IR13fOHvEsTFToudlEY29SFcR9xPc0dux5LzthGlhR/4v0BdaNsTZ
         ULdmSmhGVzMfYpIsFsfOqov1OggkiMf0dWal6E01xaUpioKSQQ8Yz7QZZeriJify803u
         NUfi6MiI5+82Uuu/7JDLg32mDP5wrbkdLGs94RrCj5D3AhWKE676VUuJayHJbjRXp5F6
         u/KCpEXaiqdbEyqXoutQ92AwsRAp99cdX8BkkycWLPNDrT/0A0StCdVMwIPDBA6Nj/Oq
         aZf5RUYr5rY+6T8ymkw15KtktpHx+58McrQEoskSo4/cVfNqDS72f4/HzH5qSxBLBkjk
         0qRQ==
X-Gm-Message-State: AOAM530Jzs2GodLtNvmh3j3JjCyuLgpYs+cRDF1Ydgxbbun2OdATRZvw
        7RR+uxkYYezMJ4lOmhcovrGG/ss0TAc=
X-Google-Smtp-Source: ABdhPJwM4+h5jaGsJs2pJAnFiTOhVvj+br2wvg7SlP3aI7UZ4hPFdzkYtj34bHlyza3HeS5iZfRdOw==
X-Received: by 2002:a17:906:e87:b0:6df:8602:5801 with SMTP id p7-20020a1709060e8700b006df86025801mr4867661ejf.140.1649995818361;
        Thu, 14 Apr 2022 21:10:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dd6-20020a1709069b8600b006df08710d00sm1255724ejc.85.2022.04.14.21.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 21:10:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH v2 4/4] trace-cruncher: Example script for uprobes high level API
Date:   Fri, 15 Apr 2022 07:10:12 +0300
Message-Id: <20220415041012.36151-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415041012.36151-1-tz.stoyanov@gmail.com>
References: <20220415041012.36151-1-tz.stoyanov@gmail.com>
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
 examples/user_trace.py | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100755 examples/user_trace.py

diff --git a/examples/user_trace.py b/examples/user_trace.py
new file mode 100755
index 0000000..640ace8
--- /dev/null
+++ b/examples/user_trace.py
@@ -0,0 +1,43 @@
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
+        print('Usage: ', sys.argv[0], ' [PROCESS]')
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
+        file = shutil.which(sys.argv[1])
+        if file is None:
+            print('Cannot find ', sys.argv[1], ' in the system')
+            sys.exit(1)
+        utrace = ft.user_trace(name=file, argv=sys.argv[1:], follow_libs=False)
+
+    # Trace execution of all available functions in the given process
+    utrace.add_function(fname = "*")
+
+    # Add trace points on functions return as well
+    utrace.add_ret_function(fname = "*")
+
+    # Start tracing in an instance
+    utrace.enable(instance = inst, wait=False)
+
+    # Read the trace buffer during the trace until ctrl-c is pressed
+    ft.read_trace(instance=inst)
\ No newline at end of file
-- 
2.35.1

