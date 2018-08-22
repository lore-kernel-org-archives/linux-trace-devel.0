Return-Path: <SRS0=wogL=LF=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35834 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729208AbeHVTHm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Aug 2018 15:07:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id j26-v6so2005729wre.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Aug 2018 08:42:18 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/5] kernel-shark-qt: Version 0.8.0
Date: Wed, 22 Aug 2018 18:41:40 +0300
Message-Id: <20180822154140.3748-6-y.karadz@gmail.com>
In-Reply-To: <20180822154140.3748-1-y.karadz@gmail.com>
References: <20180822154140.3748-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/CMakeLists.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.txt
index 0187eb4..793a63b 100644
--- a/kernel-shark-qt/CMakeLists.txt
+++ b/kernel-shark-qt/CMakeLists.txt
@@ -5,8 +5,8 @@ cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
 project(kernel-shark-qt)
 
 set(KS_VERSION_MAJOR 0)
-set(KS_VERSION_MINOR 7)
-set(KS_VERSION_PATCH 1)
+set(KS_VERSION_MINOR 8)
+set(KS_VERSION_PATCH 0)
 set(KS_VERSION_STRING ${KS_VERSION_MAJOR}.${KS_VERSION_MINOR}.${KS_VERSION_PATCH})
 message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
 
-- 
2.17.1
