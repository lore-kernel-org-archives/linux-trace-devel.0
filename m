Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0E6C5519F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42A0A246AA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JT2pnefS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgKROu3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 09:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgKROu3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 09:50:29 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1FCC0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:29 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id a186so491333wme.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nJtuDdyfVkYAdK6/PIvVw7J5G1ZpQXl8NfpegQI/6Og=;
        b=JT2pnefS1MT6vmtZknG3utR+RBuHDfUqhaIwKuwMDagBO2NI85mN36Eh7LTQtLMimd
         o2KhZ2fdL2L9BHaY7AbINiVaI4bUMl+zwvppeeokLa1i1HA3IQmRTEA1FlWl+lI2810g
         ZW3dSDCKjS6GIde2KuJ6xjGssGtAyK/A+GK+Rq8JeUp1iUvwEuQY/ovmGcG9SM65kRSV
         EYC/1t3U4+562CFD3fDLBL8KJfew8pW0rID+ajEdl1Coe6KELZsFg5S3i4ZwVg/IffrR
         ZmMBiry1w4VXzc8muRwqUgmwrflqVURvGgm+hMfuQhPcF4CcslvbFlv/cvJ59fC7HE5U
         9yGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nJtuDdyfVkYAdK6/PIvVw7J5G1ZpQXl8NfpegQI/6Og=;
        b=K4bJhxU1jRYF3GMAq4HDGqgaxkJUso54wiODdm/VAgYkBYnoZeutVzfWuDSZJaFWFR
         ldBzDKje/EKakLVPPLp0L6sx2UX13f54PGlqQV1Ue4TrC2rhmSQuBTwsuEdRaEZcCD9D
         yZocALiFmN8VLp6SGz5SOYWEpZ9tA0f5NMvaChMxVKKEH/ycAIHdJSaIsvFTKzzo0v6a
         SexAm2mCWVHdrkmMCcMjcWzS13PBxbFy55qbdw0dfxTet65CtkRdiGu6GZhCxWW7EF33
         vqYF2B0mCZVp3lhzqzMUJc/FNJ6Z9RqW8NWMHBD4DXtPVtmNGrSqq/NaIdKeUZz+lm8x
         ZONQ==
X-Gm-Message-State: AOAM531kYg3A0CEHOEto6jXw3/iWyg8O+PBGM4/70Z+qPDkQHXs1WeA2
        I16de7RmZuC1SDIMrnwETd8=
X-Google-Smtp-Source: ABdhPJxKD3U21qjThW5ZGFn5NDlh2hrxhDsfREzGgDuKRYh/TZwIG/tbug2/uUoq1PFhxExMLlXhQQ==
X-Received: by 2002:a1c:ab57:: with SMTP id u84mr368297wme.99.1605711027695;
        Wed, 18 Nov 2020 06:50:27 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id s202sm3926190wme.39.2020.11.18.06.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 06:50:27 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 03/20] kernel-shark: Introduce libkshark-hash
Date:   Wed, 18 Nov 2020 16:49:46 +0200
Message-Id: <20201118145003.156542-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201118145003.156542-1-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

So far KernelShark have been using an implementation of a hash table
from trace-cmd/include/trace-cmd/trace-filter-hash.h. However it turns
that KernelShark is the only user of trace-filter-hash, which means
that it make more sense to make this implementation of the hash table
part of KernelShark. In this patch we adapt the original trace-cmd
implementation and change the naming convention used.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt   |   1 +
 src/libkshark-hash.c | 239 +++++++++++++++++++++++++++++++++++++++++++
 src/libkshark.h      |  46 +++++++++
 3 files changed, 286 insertions(+)
 create mode 100644 src/libkshark-hash.c

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 457c1007..0b84851c 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -2,6 +2,7 @@ message("\n src ...")
 
 message(STATUS "libkshark")
 add_library(kshark SHARED libkshark.c
+                          libkshark-hash.c
                           libkshark-model.c
                           libkshark-plugin.c
                           libkshark-configio.c
diff --git a/src/libkshark-hash.c b/src/libkshark-hash.c
new file mode 100644
index 00000000..89c021ba
--- /dev/null
+++ b/src/libkshark-hash.c
@@ -0,0 +1,239 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2009, Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2018 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ */
+
+/**
+ *  @file    libkshark-hash.c
+ *  @brief   Hash table of integer Id numbers.
+ */
+
+// C
+#include <stdio.h>
+#include <stdlib.h>
+#include <assert.h>
+
+// KernelShark
+#include "libkshark.h"
+
+/**
+ * @brief: quick_hash - A quick (non secured) hash alogirthm
+ * @param val: The value to perform the hash on
+ * @param bits: The size in bits you need to return
+ *
+ * This is a quick hashing function adapted from Donald E. Knuth's 32
+ * bit multiplicative hash. See The Art of Computer Programming (TAOCP).
+ * Multiplication by the Prime number, closest to the golden ratio of
+ * 2^32.
+ *
+ * "bits" is used to max the result for use cases that require
+ * a power of 2 return value that is less than 32 bits. Any value
+ * of "bits" greater than 31 (or zero), will simply return the full hash
+ * on "val".
+ */
+static inline uint32_t quick_hash(uint32_t val, unsigned int bits)
+{
+	val *= UINT32_C(2654435761);
+
+	if (!bits || bits > 31)
+		return val;
+
+	return val & ((1 << bits) - 1);
+}
+
+static size_t hash_size(struct kshark_hash_id *hash)
+{
+	return (1 << hash->n_bits);
+}
+
+/**
+ * Create new hash table of Ids.
+ */
+struct kshark_hash_id *kshark_hash_id_alloc(size_t n_bits)
+{
+	struct kshark_hash_id *hash;
+	size_t size;
+
+	hash = calloc(1, sizeof(*hash));
+	if (!hash)
+		goto fail;
+
+	hash->n_bits = n_bits;
+	hash->count = 0;
+
+	size = hash_size(hash);
+	hash->hash = calloc(size, sizeof(*hash->hash));
+	if (!hash->hash)
+		goto fail;
+
+	return hash;
+
+ fail:
+	fprintf(stderr, "Failed to allocate memory for hash table.\n");
+	kshark_hash_id_free(hash);
+	return NULL;
+}
+
+/** Free the hash table of Ids. */
+void kshark_hash_id_free(struct kshark_hash_id *hash)
+{
+	if (!hash)
+		return;
+
+	if (hash->hash) {
+		kshark_hash_id_clear(hash);
+		free(hash->hash);
+	}
+
+	free(hash);
+}
+
+/**
+ * @brief Check if an Id with a given value exists in this hash table.
+ */
+bool kshark_hash_id_find(struct kshark_hash_id *hash, int id)
+{
+	uint32_t key = quick_hash(id, hash->n_bits);
+	struct kshark_hash_id_item *item;
+
+	for (item = hash->hash[key]; item; item = item->next)
+		if (item->id == id)
+			break;
+
+	return !!(unsigned long) item;
+}
+
+/**
+ * @brief Add Id to the hash table.
+ *
+ * @param hash: The hash table to add to.
+ * @param id: The Id number to be added.
+ *
+ * @returns Zero if the Id already exists in the table, one if the Id has been
+ *	    added and negative errno code on failure.
+ */
+int kshark_hash_id_add(struct kshark_hash_id *hash, int id)
+{
+	uint32_t key = quick_hash(id, hash->n_bits);
+	struct kshark_hash_id_item *item;
+
+	if (kshark_hash_id_find(hash, id))
+		return 0;
+
+	item = calloc(1, sizeof(*item));
+	if (!item) {
+		fprintf(stderr,
+			"Failed to allocate memory for hash table item.\n");
+		return -ENOMEM;
+	}
+
+	item->id = id;
+	item->next = hash->hash[key];
+	hash->hash[key] = item;
+	hash->count++;
+
+	return 1;
+}
+
+/**
+ * @brief Remove Id from the hash table.
+ */
+void kshark_hash_id_remove(struct kshark_hash_id *hash, int id)
+{
+	struct kshark_hash_id_item *item, **next;
+	int key = quick_hash(id, hash->n_bits);
+
+	next = &hash->hash[key];
+	while (*next) {
+		if ((*next)->id == id)
+			break;
+		next = &(*next)->next;
+	}
+
+	if (!*next)
+		return;
+
+	assert(hash->count);
+
+	hash->count--;
+	item = *next;
+	*next = item->next;
+
+	free(item);
+}
+
+/** Remove (free) all Ids (items) from this hash table. */
+void kshark_hash_id_clear(struct kshark_hash_id *hash)
+{
+	struct kshark_hash_id_item *item, *next;
+	size_t size;
+	int i;
+
+	if (!hash || ! hash->hash)
+		return;
+
+	size = hash_size(hash);
+	for (i = 0; i < size; i++) {
+		next = hash->hash[i];
+		if (!next)
+			continue;
+
+		hash->hash[i] = NULL;
+		while (next) {
+			item = next;
+			next = item->next;
+			free(item);
+		}
+	}
+
+	hash->count = 0;
+}
+
+static int compare_ids(const void* a, const void* b)
+{
+	int arg1 = *(const int*)a;
+	int arg2 = *(const int*)b;
+
+	if (arg1 < arg2)
+		return -1;
+
+	if (arg1 > arg2)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * @brief Get a sorted array containing all Ids of this hash table.
+ */
+int *kshark_hash_ids(struct kshark_hash_id *hash)
+{
+	struct kshark_hash_id_item *item;
+	size_t size = hash_size(hash);
+	int count = 0, i;
+	int *ids;
+
+	if (!hash->count)
+		return NULL;
+
+	ids = calloc(hash->count, sizeof(*ids));
+	if (!ids) {
+		fprintf(stderr,
+			"Failed to allocate memory for Id array.\n");
+		return NULL;
+	}
+
+	for (i = 0; i < size; i++) {
+		item = hash->hash[i];
+		while (item) {
+			ids[count++] = item->id;
+			item = item->next;
+		}
+	}
+
+	qsort(ids, hash->count, sizeof(*ids), compare_ids);
+
+	return ids;
+}
diff --git a/src/libkshark.h b/src/libkshark.h
index 7d8b53b0..cc20077f 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -75,6 +75,52 @@ struct kshark_entry {
 	int64_t		ts;
 };
 
+/** Size of the hash table of PIDs in terms of bits being used by the key. */
+#define KS_TASK_HASH_NBITS	16
+
+/** Size of the hash table of Ids in terms of bits being used by the key. */
+#define KS_FILTER_HASH_NBITS	8
+
+/** A bucket for the hash table of integer Id numbers (kshark_hash_id). */
+struct kshark_hash_id_item {
+	/** Pointer to the Id in this bucket. */
+	struct kshark_hash_id_item	*next;
+
+	/** The Id value. */
+	int				id;
+};
+
+/**
+ * Hash table of integer Id numbers. To be used for fast filter of trace
+ * entries.
+ */
+struct kshark_hash_id {
+	/** Array of buckets. */
+	struct kshark_hash_id_item	**hash;
+
+	/** The number of Ids in the table. */
+	size_t	count;
+
+	/**
+	 * The number of bits used by the hashing function.
+	 * Note that the number of buckets in the table if given by
+	 * 1 << n_bits.
+	 */
+	size_t	n_bits;
+};
+
+bool kshark_hash_id_find(struct kshark_hash_id *hash, int id);
+
+int kshark_hash_id_add(struct kshark_hash_id *hash, int id);
+
+void kshark_hash_id_clear(struct kshark_hash_id *hash);
+
+struct kshark_hash_id *kshark_hash_id_alloc(size_t n_bits);
+
+void kshark_hash_id_free(struct kshark_hash_id *hash);
+
+int *kshark_hash_ids(struct kshark_hash_id *hash);
+
 /** Size of the task's hash table. */
 #define KS_TASK_HASH_SHIFT 16
 #define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
-- 
2.25.1

