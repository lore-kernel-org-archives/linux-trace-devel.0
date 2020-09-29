Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE83CC4727D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E628208FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X8aQ8lnm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729975AbgI2Nl6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730018AbgI2Nly (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:41:54 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE5CC061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:53 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g4so5473221wrs.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d1DPKVdrhYOWagpKu1yFI8EjBUvx4yL9MDz4urWVFgM=;
        b=X8aQ8lnmhwN1hZNHLvvzC6VPiBKcUvUJB1LMCarTFLeY9XHBvtfE/kU4aqml9n7cZg
         jxhAIIrjg00z+8GvfdgtViRUpGOuAWYSuhhj4/+JgWYHOsNEuYpVN5ItCkbPN7REE/hC
         VM1g1RvDMGHYTiTD3akxBJRHKUa/5aSnpxtiNqw9G07dYHS7nH2W6vWEldEekS2fo3Q2
         nTYMJT2Is/vxcpgAv8tYj+v26WSFu9AdzeejNzki3pDLDfsZP68OUfzGs4dJKwLC2CAl
         B4ZtnrZAjzKvaLvyPA68yn1rb7G8LtTiOUdwTOSAvUFc9xT7XvrXpiPSuTZRfXrEiNjv
         WoAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d1DPKVdrhYOWagpKu1yFI8EjBUvx4yL9MDz4urWVFgM=;
        b=rYqZ99nlFBzvU2U7aznTRET+LCCG2I0GCx3I2/Jk8FGkWBase0VQGcn7hiYZ1bwpsz
         dlnTd824XFl4KMZf/kIbBl/+zTt/cgHKzmGb8ZlGsw5KVvBGjJdKzz2iiC0QVqNxHuRv
         FsiRWgvUvC9fNP4hOOlv+JaJuvcfNjoadv17gsRJuu6lt+Gk2eRd+GEQvZpgRUqmzrzF
         vrRVC9+ARYV+oI6mZJwL7AbuuebIKE4pSPI18Tx24Dr6/Yy69z2S0lNCpLMmsnM9k3F6
         /Xkjx0C1vLEn7KJ7Hbhmvp87Jd0I8mtwugygeGRWkEEEje8SHP32vxbCYFwC9oQO5gWs
         UQLA==
X-Gm-Message-State: AOAM530OuSVmU7y6OMVtSiQM18Pbx31JHIw3dH0pfGuKgfW2c6J7lPOB
        Hc+NNFMc1xmgMegfAcwX8QE=
X-Google-Smtp-Source: ABdhPJxEi4Gyg+O7F5EC4so7NFY5dZYMuu5sjaKoRsgi4OZx1ZDNCpd8wcGvtqPwDQDMFazfW9vrrA==
X-Received: by 2002:adf:f245:: with SMTP id b5mr4664070wrp.288.1601386912473;
        Tue, 29 Sep 2020 06:41:52 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id b84sm6162792wmd.0.2020.09.29.06.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:41:52 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 05/15] kernel-shark: Introduce libkshark-hash
Date:   Tue, 29 Sep 2020 16:41:13 +0300
Message-Id: <20200929134123.178688-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929134123.178688-1-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
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
 src/libkshark-hash.c | 213 +++++++++++++++++++++++++++++++++++++++++++
 src/libkshark.h      |  47 ++++++++++
 3 files changed, 261 insertions(+)
 create mode 100644 src/libkshark-hash.c

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 2e092b2..39c4dcf 100644
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
index 0000000..4079355
--- /dev/null
+++ b/src/libkshark-hash.c
@@ -0,0 +1,213 @@
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
+#include <string.h>
+#include <stdarg.h>
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
+	assert(hash);
+
+	hash->n_bits = n_bits;
+	hash->count = 0;
+
+	size = hash_size(hash);
+	hash->hash = calloc(size, sizeof(*hash->hash));
+
+	return hash;
+}
+
+/** Free the hash table of Ids. */
+void kshark_hash_id_free(struct kshark_hash_id *hash)
+{
+	if (!hash)
+		return;
+
+	kshark_hash_id_clear(hash);
+	free(hash->hash);
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
+ */
+void kshark_hash_id_add(struct kshark_hash_id *hash, int id)
+{
+	uint32_t key = quick_hash(id, hash->n_bits);
+	struct kshark_hash_id_item *item;
+
+	if (kshark_hash_id_find(hash, id))
+		return;
+
+	item = calloc(1, sizeof(*item));
+	assert(item);
+
+	item->id = id;
+	item->next = hash->hash[key];
+	hash->hash[key] = item;
+	hash->count++;
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
+	size_t size = hash_size(hash);
+	int i;
+
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
+	assert(ids);
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
index 9eecc2d..57bd5e5 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -33,6 +33,7 @@ extern "C" {
 // KernelShark
 #include "libkshark-plugin.h"
 
+
 /**
  * Kernel Shark entry contains all information from one trace record needed
  * in order to  visualize the time-series of trace records. The part of the
@@ -72,6 +73,52 @@ struct kshark_entry {
 	int64_t		ts;
 };
 
+/** Size of the task'c hash table in terms of bits being used by the key. */
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
+void kshark_hash_id_add(struct kshark_hash_id *hash, int id);
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

