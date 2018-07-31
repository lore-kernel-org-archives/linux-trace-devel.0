Return-Path: <SRS0=gflo=KP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44688 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732160AbeGaPeT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Jul 2018 11:34:19 -0400
Received: by mail-wr1-f67.google.com with SMTP id r16-v6so16749558wrt.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Jul 2018 06:53:52 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 7/7] kernel-shark-qt: Changed the KernelShark version identifier.
Date: Tue, 31 Jul 2018 16:52:48 +0300
Message-Id: <20180731135248.30587-8-y.karadz@gmail.com>
In-Reply-To: <20180731135248.30587-1-y.karadz@gmail.com>
References: <20180731135248.30587-1-y.karadz@gmail.com>
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
