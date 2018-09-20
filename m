Return-Path: <SRS0=7BWw=MC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39334 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbeITWkp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Sep 2018 18:40:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id q8-v6so246375wmq.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Sep 2018 09:56:21 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 5/8] kernel-shark-qt: Remove the TODO action in kshark_read_at()
Date: Thu, 20 Sep 2018 19:55:41 +0300
Message-Id: <20180920165544.17579-6-y.karadz@gmail.com>
In-Reply-To: <20180920165544.17579-1-y.karadz@gmail.com>
References: <20180920165544.17579-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The TODO message states that we have to understand why racecmd_read_at()
is not thread-safe and see if this can be fixed. We now know why and we
know that this cannot be fixed.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 3635b48..506511d 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -842,9 +842,8 @@ struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
 				  uint64_t offset)
 {
 	/*
-	 * It turns that tracecmd_read_at() is not thread-safe.
-	 * TODO: Understand why and see if this can be fixed.
-	 * For the time being use a mutex to protect the access.
+	 * Calling tracecmd_read_at() is not thread-safe. Use a mutex to
+	 * protect the access.
 	 */
 	pthread_mutex_lock(&kshark_ctx->input_mutex);
 
-- 
2.17.1
