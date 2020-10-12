Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5928C43467
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C96320757
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qOkq6rE3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390919AbgJLOEr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 10:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730953AbgJLNgE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:36:04 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F634C0613D1
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:04 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id j136so17576511wmj.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eoqAnrsjvwy1ZKKAHaVz6ED3inWdsijpE+tgXuw5Q/o=;
        b=qOkq6rE3vIPxUzAuQ5W/Q5wEvNwTqc9lT+HCUG8P9hJ8lAyCP4M0DKoYrf/zA6JcVo
         YFUOJSd+bJvwMlXi+epah64513TcwqiyC0PNvQZyHg1Btoohp0W4d1cRj/ONvDcWnENw
         oCsAqD9kTEW10OY9/1ph0zFXbCaoEdBrg3FCJ+FKU5VbEI+99J7bf4d2HH0Z95GKILD4
         FXf7Ff2uAAFhJpiKc21RvmhTHGLaGM2VrxyMn36l2RbANIrjiqA/Ps+eef7L/M0UOV2W
         qswvW4PRxQzlrR0zXe/ZJSr1zdUPdIt6X6NdQ21ayPuKR8Li2BV70MRqYz0UceNyl65E
         uFDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eoqAnrsjvwy1ZKKAHaVz6ED3inWdsijpE+tgXuw5Q/o=;
        b=YpLUAe9vueyqkyers1GFmZZaSm/REg3yD0MTnOt0DCV7Aw7d3+whA2JKlAd+HYZHqx
         5F3nZGii+HjGM0sdaVgUbOPfb9eHqaKDeLVY1bH+Qemyf0FiBtH0HizbQYMkVLj19amc
         +qAODCrafYrvmtDQuOtywFSLYUaddhWHBkHd86ePtYai1ShVfqrGeHnp46SL2GKacsgm
         l5EFjrJmyT6WXW05QRrgoO6DNxVbiDjjiQHSBUAlKrshfZr9TtgCcbpkI9h3uCqHUBha
         W3gY8pXQEYbdJ5k2fX9WN3M4cB9C4S87KaQr8bevKcVzqUMqXKBOz7iDZlDNRKaYmXoN
         kS1A==
X-Gm-Message-State: AOAM5303Qg0SZ5ndV36Z1JN1xLj3OfW8atsJ+2tftYaQLHMaL/BowlJo
        +ed0HeVzH/q8CAb+6GFwvt0=
X-Google-Smtp-Source: ABdhPJx5aqLNYGYyBhYH+i90siRDZWzuwPGizDfm5A9xsXdV8/0e93WRI0D2RgNE+3xK0rQz/mXepA==
X-Received: by 2002:a05:600c:21d9:: with SMTP id x25mr10412027wmj.145.1602509762666;
        Mon, 12 Oct 2020 06:36:02 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:36:02 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 03/20] kernel-shark: Introduce libkshark-hash
Date:   Mon, 12 Oct 2020 16:35:06 +0300
Message-Id: <20201012133523.469040-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012133523.469040-1-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
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
index 2e092b2e..39c4dcf0 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -2,6 +2,7 @@ message("\n src ...")
 
 message(STATUS "libkshark")
 add_library(kshark SHARED libkshark.c
+                          libkshark-hash.c
 #                           libkshark-model.c
                           libkshark-plugin.c
 #                           libkshark-configio.c
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
index 9eecc2d0..0182cf6d 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -72,6 +72,52 @@ struct kshark_entry {
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

