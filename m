Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3ECC55ABD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 11:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CA082222A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 11:45:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o+mBJBYv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgKLLpN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 06:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbgKLLoV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 06:44:21 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62175C0613D6
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 03:44:21 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id a65so5235353wme.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 03:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BOxT7SB6HuPrVowds0wta+FRQeXG7ABBqiTvuQDB4XY=;
        b=o+mBJBYvg1gBix3p8JkWVdxPwumz2XIpQJ36x17Vnp/YMaqxhJAbZilRPS+9Mbz18r
         eZa0FoQ6yS5+YbaA/EMWxJ8gL7cGPUFuOrfYghweOEftRhCVuEVCFZeUnw6rJ8x4ywFR
         PczbeTSIGMzMxH+QzvZ+Sw63m4R5NfjSik3ERMhkLhcpUsReGzsj91Xvv1Lt8DFZ99gU
         aTEBb89CBqN+8ktXh/MLYuXGeO9EkGL1qDN23jcRYK9dP4/QDIlKIg8kdRs82rA4qiYo
         eAUgAmTNSykjsYvyatVqDbVSf++uKXbHiRH/PoH0mosXUbU4qqJsE1cjUr+zuHdaIEUc
         KhtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BOxT7SB6HuPrVowds0wta+FRQeXG7ABBqiTvuQDB4XY=;
        b=pRYoKWJzB6ToXEf6xtkhX34uUwnQjnHo+EXbYpzTbejn7ilweQiHXk0bhM7FoiRZkV
         39JD+obkuTx3zCjro1FdWIHv+oLW9onuI/CSQC6lvsEBBgcq1HMmduLbTbU88w/WI+kC
         Zi4CAc4u2mQXWvjTYeKXvC8OgocLL7aY2A5+tewrlY6Q1oplGU1iy7RPlzkof7ApvbJf
         wgI9iaCHT4uyyUEMa4oXBEbzchwnMYpmPWs4zOPWX+cdcPlmtREl47z4+JK5mY3qd3fM
         XSfdAOBgZhUngyznHcyskrmmUo79cRVE9dHtpFG1mJZQyT7PVWCwpxhWw3W7hL96H51T
         427g==
X-Gm-Message-State: AOAM531iyIWo2eU01F8b1AMu+I4VvzTf11Fe3ZGIwPhBh+/aHj5789a1
        HbXvcUv+iMH6wSOgfNdT/ZrloJet91YhkEfE
X-Google-Smtp-Source: ABdhPJy04EoY1Qjsw5uUOzbIDwbCC6tzRLN4Eih26/X1+Mc7xxXIPJKNDSANAq8xWDW5eXrona+a5A==
X-Received: by 2002:a05:600c:2282:: with SMTP id 2mr9821602wmf.154.1605181460075;
        Thu, 12 Nov 2020 03:44:20 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 15sm6081146wmg.1.2020.11.12.03.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:44:19 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] KernelShark: Remove unneeded libtracecmd dependencies
Date:   Thu, 12 Nov 2020 13:44:17 +0200
Message-Id: <20201112114417.1250217-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

Remove unused "trace-cmd.h" includes.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/KsAdvFilteringDialog.cpp | 3 ---
 src/KsCaptureDialog.hpp      | 3 ---
 src/plugins/KVMCombo.cpp     | 3 ---
 src/plugins/sched_events.c   | 4 ++--
 4 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
index 7f404b8..9f4cc9b 100644
--- a/src/KsAdvFilteringDialog.cpp
+++ b/src/KsAdvFilteringDialog.cpp
@@ -9,9 +9,6 @@
  *  @brief   GUI Dialog for Advanced filtering settings.
  */
 
-// trace-cmd
-#include "trace-cmd/trace-cmd.h"
-
 // KernelShark
 #include "libkshark.h"
 #include "libkshark-tepdata.h"
diff --git a/src/KsCaptureDialog.hpp b/src/KsCaptureDialog.hpp
index e86b47f..fe6a2a6 100644
--- a/src/KsCaptureDialog.hpp
+++ b/src/KsCaptureDialog.hpp
@@ -15,9 +15,6 @@
 // Qt
 #include <QtWidgets>
 
-// trace-cmd
-#include "trace-cmd/trace-cmd.h"
-
 // KernelShark
 #include "KsWidgetsLib.hpp"
 
diff --git a/src/plugins/KVMCombo.cpp b/src/plugins/KVMCombo.cpp
index bc3c6b0..25deefd 100644
--- a/src/plugins/KVMCombo.cpp
+++ b/src/plugins/KVMCombo.cpp
@@ -12,9 +12,6 @@
 // C++
 #include <iostream>
 
-// trace-cmd
-#include "trace-cmd/trace-cmd.h"
-
 // KernelShark
 #include "libkshark.h"
 #include "libkshark-tepdata.h"
diff --git a/src/plugins/sched_events.c b/src/plugins/sched_events.c
index 5a46932..034ffa0 100644
--- a/src/plugins/sched_events.c
+++ b/src/plugins/sched_events.c
@@ -14,8 +14,8 @@
 #include <stdio.h>
 #include <assert.h>
 
-// trace-cmd
-#include "trace-cmd/trace-cmd.h"
+// libtraceevent
+#include "traceevent/event-parse.h"
 
 // KernelShark
 #include "plugins/sched_events.h"
-- 
2.28.0

