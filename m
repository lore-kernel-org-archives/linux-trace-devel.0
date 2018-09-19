Return-Path: <SRS0=cF1r=MB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f44.google.com ([209.85.128.44]:51998 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731519AbeISUPm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Sep 2018 16:15:42 -0400
Received: by mail-wm1-f44.google.com with SMTP id y2-v6so6561487wma.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Sep 2018 07:37:28 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 6/7] kernel-shark-qt: Tell Doxygen to enter ../src/plugins/
Date: Wed, 19 Sep 2018 17:36:56 +0300
Message-Id: <20180919143657.19472-7-y.karadz@gmail.com>
In-Reply-To: <20180919143657.19472-1-y.karadz@gmail.com>
References: <20180919143657.19472-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This Patch adds ../src/plugins/ to the list of input locations used by
Doxygen to search for documented source files.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/doc/dox_config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark-qt/doc/dox_config b/kernel-shark-qt/doc/dox_config
index b982baa..acc9083 100644
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
