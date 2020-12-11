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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9A6C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB38320657
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406374AbgLKOqi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406378AbgLKOqY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 09:46:24 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0358DC061282
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 06:45:31 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id y23so8839292wmi.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 06:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hdGcrl8GfaowN2ANak9fyn2yQpnSJJjZK2SyDiapgtg=;
        b=auc/G6qGbsu5GMCRk6KESF+MpnCGqgBEIkho6WoXxuxq7yfLYhoqWmv8AdLO0rc8fX
         44Du4QyAFJXcdUldEK6m4SrlfWeuFrJ3QTs3a35533MTofZ5ZlV80fvaVo16QF0coPd7
         xrDyIE1azJC1vhOQbng7rZwUXDQfOwJllNMGsnzQ1/JgrZz9DkGq2gZXKYK8ykfCd3YR
         CM7NDuR5QduDG2jgVHG6/Q4kp0yDxgrJ9DyV/x3gpqJEjefbGHEuM3OiviJf6DvOfnMm
         Uu06vx3vQZ8j3olizTktrWTStF1u+ONcYV1bfZcE/vCQ4b9fzOE/cCXLQu+z1TzUVyGZ
         zQaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hdGcrl8GfaowN2ANak9fyn2yQpnSJJjZK2SyDiapgtg=;
        b=jwe0b6djejTG6AYlDKp/DdBwNJTYIdUGm2BQsEpPaZeVKXN28+sDM7mCyx6hhA6ye/
         MiXIo2+83PzrEVkSESiCYAH9l7t6YCVjAMyb1XpnZ1opj4erbJh0CyiLoyCEoujAgKaA
         o4sToOoH40L906bMGMICFmW84r4Q2wSbPswKJB5xGiNHdEFOFp5b0Hs0oQQJXY3ua0jg
         e7QzDQCHmCDZMef9PFUswKx3QodbCDwYxbss6K6JDCmojf2uCO6YsTXTaJcU0+40Ql6s
         Sx86Tt9mYKp11W7zG/8VUrvLD18B9YuewJtgEVDK7+TjRgKljN9LeeHuj0WFx7zBMWhW
         +/ew==
X-Gm-Message-State: AOAM531moC2oJs9dp7TV77E7q0kpP8m/HGaO1dMU9Moci47XM+j3CG1q
        5OcY65Zvsgo/wvjoHEb9hPOFxI325qA=
X-Google-Smtp-Source: ABdhPJy6TbzsyDScidCRJEJDXJFlJDvVYmuwNbO7+j8xh/JHuACkwYrwtb7EgP8AEHR4+PvhAqP2/A==
X-Received: by 2002:a7b:c208:: with SMTP id x8mr13982211wmi.179.1607697929748;
        Fri, 11 Dec 2020 06:45:29 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id y2sm14471471wma.6.2020.12.11.06.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:45:29 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 08/32] kernel-shark: Introduce libkshark-hash
Date:   Fri, 11 Dec 2020 16:44:47 +0200
Message-Id: <20201211144511.575346-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211144511.575346-1-y.karadz@gmail.com>
References: <20201211144511.575346-1-y.karadz@gmail.com>
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
index 213ce87..e7ae09c 100644
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
index 0000000..89c021b
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
index 7d8b53b..cc20077 100644
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

