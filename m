Return-Path: <SRS0=L+0X=LS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f42.google.com ([209.85.221.42]:39839 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbeIDUSc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Sep 2018 16:18:32 -0400
Received: by mail-wr1-f42.google.com with SMTP id o37-v6so4505934wrf.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 04 Sep 2018 08:52:49 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 6/7] kernel-shark-qt: Tell Doxygen to enter ../src/plugins/
Date: Tue,  4 Sep 2018 18:52:17 +0300
Message-Id: <20180904155218.32518-7-y.karadz@gmail.com>
In-Reply-To: <20180904155218.32518-1-y.karadz@gmail.com>
References: <20180904155218.32518-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This Patch adds ../src/plugins/ to the list of input locations used by
Doxygen to search for documented source files.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/doc/dox_config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark-qt/doc/dox_config b/kernel-shark-qt/doc/dox_config
index b982baa6..acc9083e 100644
--- a/kernel-shark-qt/doc/dox_config
+++ b/kernel-shark-qt/doc/dox_config
@@ -4,7 +4,7 @@
 DOXYFILE_ENCODING      = UTF-8
 PROJECT_NAME           = "kernel-shark-qt"
 PROJECT_BRIEF = "Kernel Shark is a front-end reader of the Linux kernel tracing data."
-INPUT                  = "../src/"
+INPUT                  = ../src/ ../src/plugins/
 SOURCE_BROWSER         = YES
 QT_AUTOBRIEF           = YES
 TAB_SIZE               = 8
-- 
2.17.1
