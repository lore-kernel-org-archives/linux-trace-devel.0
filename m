Return-Path: <SRS0=opg7=KS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41166 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732294AbeHCQ1H (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Aug 2018 12:27:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id j5-v6so5595610wrr.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Aug 2018 07:30:31 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 6/6] kernel-shark-qt: Changed the KernelShark version identifier.
Date: Fri,  3 Aug 2018 17:29:37 +0300
Message-Id: <20180803142937.3970-7-y.karadz@gmail.com>
In-Reply-To: <20180803142937.3970-1-y.karadz@gmail.com>
References: <20180803142937.3970-1-y.karadz@gmail.com>
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
