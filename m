Return-Path: <SRS0=D2WB=J3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:51324 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388036AbeGKNnj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Jul 2018 09:43:39 -0400
Received: by mail-wm0-f67.google.com with SMTP id s12-v6so2499190wmc.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Jul 2018 06:39:14 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 6/6] kernel-shark-qt: Changed the KernelShark version identifier.
Date: Wed, 11 Jul 2018 16:38:14 +0300
Message-Id: <20180711133814.26854-7-y.karadz@gmail.com>
In-Reply-To: <20180711133814.26854-1-y.karadz@gmail.com>
References: <20180711133814.26854-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

(Patch Id) ++

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.txt
index 9ff12a1..7a802cd 100644
--- a/kernel-shark-qt/CMakeLists.txt
+++ b/kernel-shark-qt/CMakeLists.txt
@@ -6,7 +6,7 @@ project(kernel-shark-qt)
 
 set(KS_VERSION_MAJOR 0)
 set(KS_VERSION_MINOR 7)
-set(KS_VERSION_PATCH 0)
+set(KS_VERSION_PATCH 1)
 set(KS_VERSION_STRING ${KS_VERSION_MAJOR}.${KS_VERSION_MINOR}.${KS_VERSION_PATCH})
 message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
 
-- 
2.17.1
