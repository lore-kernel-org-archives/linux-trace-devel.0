Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9E3C3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 18:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A3DE22CF8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 18:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfH1SAT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 14:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbfH1SAT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 14:00:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 534F6206BB;
        Wed, 28 Aug 2019 18:00:18 +0000 (UTC)
Date:   Wed, 28 Aug 2019 14:00:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Increase the size of the task hash
Message-ID: <20190828140016.3ce1be4f@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

When loading a data file that contained 100,000s of tasks, using a 256
bucket size hash crippled it. By increasing the hash to 2^16 (65536) it
solves the issue (still small enough not to waste too much memory).

In the process, I changed the knuth_hash() in libkshark.c to use the 32
bit version and just have the key use what it needs:

  key = knuth_hash();
  key += knuth_hash >> SHIFT;
  key &= (1 << SHIFT) - 1;

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 4201fa02..41572e18 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -252,19 +252,19 @@ void kshark_free(struct kshark_context *kshark_ctx)
 	free(kshark_ctx);
 }
 
-static inline uint8_t knuth_hash(uint32_t val)
+static inline uint32_t knuth_hash(uint32_t val)
 {
 	/*
-	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
+	 * Hashing function adapted from Donald E. Knuth's 32 bit
 	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
 	 * Multiplication by the Prime number, closest to the golden ratio of
-	 * 2^8.
+	 * 2^32.
 	 */
-	return UINT8_C(val) * UINT8_C(157);
+	return val * UINT32_C(2654435761);
 }
 
 static struct kshark_task_list *
-kshark_find_task(struct kshark_context *kshark_ctx, uint8_t key, int pid)
+kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
 {
 	struct kshark_task_list *list;
 
@@ -280,9 +280,12 @@ static struct kshark_task_list *
 kshark_add_task(struct kshark_context *kshark_ctx, int pid)
 {
 	struct kshark_task_list *list;
-	uint8_t key;
+	uint32_t key;
 
 	key = knuth_hash(pid);
+	key += key >> KS_TASK_HASH_SHIFT;
+	key &= (1 << KS_TASK_HASH_SHIFT) - 1;
+
 	list = kshark_find_task(kshark_ctx, key, pid);
 	if (list)
 		return list;
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
index 04e9cbfc..3407db19 100644
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
