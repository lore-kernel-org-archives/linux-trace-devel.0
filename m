Return-Path: <SRS0=cHGG=LM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32791 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbeH2U1c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Aug 2018 16:27:32 -0400
Received: by mail-wr1-f66.google.com with SMTP id v90-v6so5433909wrc.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 29 Aug 2018 09:29:49 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/4] kernel-shark-qt: Remove TODO comment in kshark_load_data_entries()
Date: Wed, 29 Aug 2018 19:29:26 +0300
Message-Id: <20180829162927.20200-3-y.karadz@gmail.com>
In-Reply-To: <20180829162927.20200-1-y.karadz@gmail.com>
References: <20180829162927.20200-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The problem described by the TODO message was fixed, but we forgot
to remove the message itself.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 1b7e544..b4a76ae 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -712,13 +712,6 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 	if (*data_rows)
 		free(*data_rows);
 
-	/*
-	 * TODO: Getting the records separately slows this function
-	 *       down, instead of just accessing the records when
-	 *	 setting up the kernel entries. But this keeps the
-	 *	 code simplier. We should revisit to see if we can
-	 *	 bring back the performance.
-	 */
 	total = get_records(kshark_ctx, &rec_list, type);
 	if (total < 0)
 		goto fail;
-- 
2.17.1
