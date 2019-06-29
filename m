Return-Path: <SRS0=WJFG=U4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E21C7C4321A
	for <linux-trace-devel@archiver.kernel.org>; Sat, 29 Jun 2019 06:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB66F2063F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 29 Jun 2019 06:28:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bf58BNTW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfF2G2W (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 29 Jun 2019 02:28:22 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:57201 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfF2G2W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 29 Jun 2019 02:28:22 -0400
Received: by mail-pg1-f201.google.com with SMTP id x13so4265108pgk.23
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jun 2019 23:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=P5pwqm0rEV2Up8GDR1U55SfeXGCLtuWbUKbxbKiyJv0=;
        b=Bf58BNTWi4wxsalWOov+ARnPODu/u4gqHhMD/6cmo4zHvZXRdatasePVMMGnn2bmpt
         T06dhNlWrYIjIFkbYI5u+Ye60lwW7aT+e/Yt5RS/mKDFmw91gm1TQ+mJxTEUxnu2eb9b
         lfChMy2bcQGkN2ae4+BQYc/9AOu3jr6o4FtigYdFHy0EdieiAu/mzvVwgNpzq2R1NDes
         eaTP8pUf4TN8SbFKwdIBSiVr5e3BClqOEi6B9TgZkywYOtDb7IIF64UoH6gnM4R6iPum
         888df/EFjQ+nKESI39CqxW6+73j6h3X/8aM++vtDrT9r4VQKegfT+6h+4vdC8ELlkTcG
         O4LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=P5pwqm0rEV2Up8GDR1U55SfeXGCLtuWbUKbxbKiyJv0=;
        b=abrSd7trY+RTWMFY5Y8em5t5aplk8D1U5nqvlmp+kzzmpHt5Ix7Y67j6SJO7YrQXp3
         XufZtQnxGIxlKtVYg5Q3eI6DgpHCnokoMNbXjnNKVp1lzEuqH203U5oaAdpzH0AsGel5
         piljf4+NRCvsjTjdQe/Yk/THcgsMDy3Cu89d4MBz6Qv8r72FfR8ICrGsw+xPSqLB3KHn
         PrHmYSp4RbjVFdyjGN1blS9hdzWJXo4eHOHJ2gY1sKMPcwfETsghkXlEbJBIyxRhkYvV
         /W1lxjwJKz+fFZlcGKlb160YDH3A99bC695X9QPj68+RAJb+JNw9T0ur4mjGsuEAD6X3
         o+Ew==
X-Gm-Message-State: APjAAAXbKwHmJhAg+pgsnyEtGF6WV/S0VFeDCn8DesQ5Nk6fHLi4HRjm
        dpUzgkUG1UVr73CEmFy/JWwZ40VNQtGd
X-Google-Smtp-Source: APXvYqwNY2hlKUL655n3DWw8QYLhjxCPYB3riRSoQE1soJ96amBtU2KnmCJO1e+dZ+EABgj37wfdd8ayXCXE
X-Received: by 2002:a63:5c19:: with SMTP id q25mr13234050pgb.215.1561789700997;
 Fri, 28 Jun 2019 23:28:20 -0700 (PDT)
Date:   Fri, 28 Jun 2019 23:27:52 -0700
In-Reply-To: <20190627121542.2dc0d328@gandalf.local.home>
Message-Id: <20190629062752.204113-1-gthelen@google.com>
Mime-Version: 1.0
References: <20190627121542.2dc0d328@gandalf.local.home>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v2] trace-cmd: remove ununsed knuth_hash*() routines
From:   Greg Thelen <gthelen@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Neither 16-bit knuth_hash16() nor the 32-bit knuth_hash() are used.
Delete them both.

And rename the remaining function: knuth_hash8() => knuth_hash()

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 kernel-shark/src/libkshark.c      | 12 +++++-----
 lib/trace-cmd/trace-filter-hash.c | 40 +++++++------------------------
 2 files changed, 14 insertions(+), 38 deletions(-)

diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 0f0a1bab4d5c..d2764e813194 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -252,13 +252,13 @@ void kshark_free(struct kshark_context *kshark_ctx)
 	free(kshark_ctx);
 }
 
-static inline uint8_t knuth_hash8(uint32_t val)
+static inline uint8_t knuth_hash(uint32_t val)
 {
 	/*
-	 * Hashing functions, based on Donald E. Knuth's Multiplicative
-	 * hashing. See The Art of Computer Programming (TAOCP).
-	 * Multiplication by the Prime number, closest to the golden
-	 * ratio of 2^8.
+	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
+	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
+	 * Multiplication by the Prime number, closest to the golden ratio of
+	 * 2^8.
 	 */
 	return UINT8_C(val) * UINT8_C(157);
 }
@@ -282,7 +282,7 @@ kshark_add_task(struct kshark_context *kshark_ctx, int pid)
 	struct kshark_task_list *list;
 	uint8_t key;
 
-	key = knuth_hash8(pid);
+	key = knuth_hash(pid);
 	list = kshark_find_task(kshark_ctx, key, pid);
 	if (list)
 		return list;
diff --git a/lib/trace-cmd/trace-filter-hash.c b/lib/trace-cmd/trace-filter-hash.c
index 39b28790e0bc..45ca68c2959e 100644
--- a/lib/trace-cmd/trace-filter-hash.c
+++ b/lib/trace-cmd/trace-filter-hash.c
@@ -14,45 +14,21 @@
 
 #define FILTER_HASH_SIZE	256
 
-/*
- * Hashing functions, based on Donald E. Knuth's Multiplicative hashing.
- * See The Art of Computer Programming (TAOCP).
- */
-
-static inline uint8_t knuth_hash8(uint32_t val)
+static inline uint8_t knuth_hash(uint32_t val)
 {
 	/*
-	 * Multiplicative hashing function.
-	 * Multiplication by the Prime number, closest to the golden
-	 * ratio of 2^8.
+	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
+	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
+	 * Multiplication by the Prime number, closest to the golden ratio of
+	 * 2^8.
 	 */
 	return UINT8_C(val) * UINT8_C(157);
 }
 
-static inline uint16_t knuth_hash16(uint32_t val)
-{
-	/*
-	 * Multiplicative hashing function.
-	 * Multiplication by the Prime number, closest to the golden
-	 * ratio of 2^16.
-	 */
-	return UINT16_C(val) * UINT16_C(40507);
-}
-
-static inline uint32_t knuth_hash(uint32_t val)
-{
-	/*
-	 * Multiplicative hashing function.
-	 * Multiplication by the Prime number, closest to the golden
-	 * ratio of 2^32.
-	 */
-	return val * UINT32_C(2654435761);
-}
-
 struct tracecmd_filter_id_item *
 tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id)
 {
-	int key = knuth_hash8(id);
+	int key = knuth_hash(id);
 	struct tracecmd_filter_id_item *item = hash->hash[key];
 
 	while (item) {
@@ -66,7 +42,7 @@ tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id)
 
 void tracecmd_filter_id_add(struct tracecmd_filter_id *hash, int id)
 {
-	int key = knuth_hash8(id);
+	int key = knuth_hash(id);
 	struct tracecmd_filter_id_item *item;
 
 	item = calloc(1, sizeof(*item));
@@ -81,7 +57,7 @@ void tracecmd_filter_id_add(struct tracecmd_filter_id *hash, int id)
 
 void tracecmd_filter_id_remove(struct tracecmd_filter_id *hash, int id)
 {
-	int key = knuth_hash8(id);
+	int key = knuth_hash(id);
 	struct tracecmd_filter_id_item **next = &hash->hash[key];
 	struct tracecmd_filter_id_item *item;
 
-- 
2.22.0.410.gd8fdbe21b5-goog

