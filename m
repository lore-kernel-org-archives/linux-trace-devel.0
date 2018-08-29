Return-Path: <SRS0=cHGG=LM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46095 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbeH2U1d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Aug 2018 16:27:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id a108-v6so5393009wrc.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Aug 2018 09:29:51 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/4] kernel-shark-qt: Fix Doxygen doc. for libkshark-model.c
Date: Wed, 29 Aug 2018 19:29:27 +0300
Message-Id: <20180829162927.20200-4-y.karadz@gmail.com>
In-Reply-To: <20180829162927.20200-1-y.karadz@gmail.com>
References: <20180829162927.20200-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch corrects some typos in the Doxygen documentation of
libkshark-model.c

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark-model.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark-model.c b/kernel-shark-qt/src/libkshark-model.c
index 3138257..246a60c 100644
--- a/kernel-shark-qt/src/libkshark-model.c
+++ b/kernel-shark-qt/src/libkshark-model.c
@@ -5,7 +5,7 @@
  */
 
  /**
-  *  @file    libkshark.c
+  *  @file    libkshark-model.c
   *  @brief   Visualization model for FTRACE (trace-cmd) data.
   */
 
@@ -16,13 +16,13 @@
 // KernelShark
 #include "libkshark-model.h"
 
-/* The index of the Upper Overflow bin. */
+/** The index of the Upper Overflow bin. */
 #define UOB(histo) (histo->n_bins)
 
-/* The index of the Lower Overflow bin. */
+/** The index of the Lower Overflow bin. */
 #define LOB(histo) (histo->n_bins + 1)
 
-/* For all bins */
+/** For all bins. */
 # define ALLB(histo) LOB(histo)
 
 /**
-- 
2.17.1
