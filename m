Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5058C4CEC9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD44420C01
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 15:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388766AbfITPU0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 11:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388863AbfITPU0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 11:20:26 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A264D208C3;
        Fri, 20 Sep 2019 15:20:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iBKhs-0003pe-RG; Fri, 20 Sep 2019 11:20:24 -0400
Message-Id: <20190920152024.729716704@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 20 Sep 2019 11:15:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark: Increase the size of the task hash
References: <20190920151526.528126066@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When loading a data file that contained 100,000s of tasks, using a 256
bucket size hash crippled it. By increasing the hash to 2^16 (65536) it
solves the issue (still small enough not to waste too much memory).

Also switched to the tracecmd_quick_hash() which is basically the same
as the local knuth_hash() function in libkshark.c.

Link: http://lore.kernel.org/linux-trace-devel/20190828140016.3ce1be4f@gandalf.local.home

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/libkshark.c | 18 ++++--------------
 kernel-shark/src/libkshark.h |  3 ++-
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 4207ae6ffdb2..a36157835ce0 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -252,19 +252,8 @@ void kshark_free(struct kshark_context *kshark_ctx)
 	free(kshark_ctx);
 }
 
-static inline uint8_t knuth_hash(uint32_t val)
-{
-	/*
-	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
-	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
-	 * Multiplication by the Prime number, closest to the golden ratio of
-	 * 2^8.
-	 */
-	return UINT8_C(val) * UINT8_C(157);
-}
-
 static struct kshark_task_list *
-kshark_find_task(struct kshark_context *kshark_ctx, uint8_t key, int pid)
+kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
 {
 	struct kshark_task_list *list;
 
@@ -280,9 +269,10 @@ static struct kshark_task_list *
 kshark_add_task(struct kshark_context *kshark_ctx, int pid)
 {
 	struct kshark_task_list *list;
-	uint8_t key;
+	uint32_t key;
+
+	key = tracecmd_quick_hash(pid, KS_TASK_HASH_SHIFT);
 
-	key = knuth_hash(pid);
 	list = kshark_find_task(kshark_ctx, key, pid);
 	if (list)
 		return list;
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
index 04e9cbfc71df..3407db197320 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -72,7 +72,8 @@ struct kshark_entry {
 };
 
 /** Size of the task's hash table. */
-#define KS_TASK_HASH_SIZE 256
+#define KS_TASK_HASH_SHIFT 16
+#define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
 
 /** Linked list of tasks. */
 struct kshark_task_list {
-- 
2.20.1


