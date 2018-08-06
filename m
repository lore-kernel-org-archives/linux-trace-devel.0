Return-Path: <SRS0=QejA=KV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44161 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730876AbeHFSaF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Aug 2018 14:30:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16-v6so12901375wrt.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Aug 2018 09:20:15 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 6/6] kernel-shark-qt: Changed the KernelShark version identifier.
Date: Mon,  6 Aug 2018 19:19:27 +0300
Message-Id: <20180806161927.11206-7-y.karadz@gmail.com>
In-Reply-To: <20180806161927.11206-1-y.karadz@gmail.com>
References: <20180806161927.11206-1-y.karadz@gmail.com>
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
