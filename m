Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FDDC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 16:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14A5323131
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 16:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbhAFQMS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 11:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbhAFQMR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 11:12:17 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2152CC061358
        for <linux-trace-devel@vger.kernel.org>; Wed,  6 Jan 2021 08:11:37 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id b9so5842139ejy.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 06 Jan 2021 08:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pw4SkXIOP3gYsrfkXUMDmrfWVE+b+YR/QHYLmcMcDkw=;
        b=aefvSY2I8SlfJfl71rmVQu4eVxkFN80UyYTt6TW3O/2heX7AUbWt3SVLnxiQ2wWVPv
         MDxiI4374crCU8QmsDjw9AXCgWa4oqgzUQGm0ii5FMi2R+1lRYjl/P4Lln9IuyZqS03e
         T+QbPsRILi63jUf86fY4OaadFMrzGP2gh3BLccOu2bwaHU5S69sHW1u+1kl5UDy7L1ZN
         awUGekt/KDn1Q4HJh11m9NEjWSCdsBJOGgtb57kWvr7Phr1dkSmlCyM0gZI076HKeQgM
         CA6PNocPImwPfaaW1oEMQMjjOUZ8FQlDYlgrB2sHd4V6wZaVjsHQxhoeZzRtEDZkX/mR
         ZUoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pw4SkXIOP3gYsrfkXUMDmrfWVE+b+YR/QHYLmcMcDkw=;
        b=ob+yO7KGYKboJAy905zpBGVPJgS7tX++hLYhMz0bT5ghJa4eICX9ATp7xl2FqvnOXK
         TYLrJRqSw8+KH1+7vAK9ZtD8Y8KMPeTLVO9rU0t/CclbRdBOvkArWo+wTdWBuHqG47q1
         qUsKIThBm+Najea/7j8Ouc8ovXO7ClRRQ2epl2nUYS/M5b88VkagIqlVAO81G8xtIrsx
         XrXV+c0spRGVmAU64dpgAFtRz+Ud5koEoH8tTkUlII65PgWqJ04mp4Mf23Y+S5ohyKBj
         dnz7Cd82TQ2QqDYhoy85TLuX+d628WbaBCZuZZEZ7LfagO9ImMhX4sxzLRib1wxkK9h3
         axww==
X-Gm-Message-State: AOAM533M9IG/LoF2UpzbKCooDEftFOTPqWftU8xRH8H+f871t9umvM01
        tv6HcmTNYlV8zt191jevNxOVCvL6kR+WZA==
X-Google-Smtp-Source: ABdhPJxdDC9LYjuVMNMAILLoOIdHmTMNfNEBfLK4h2aMwNAporMoU1m+Zz2Tn4odK0CYTtP/Dvwejg==
X-Received: by 2002:a17:906:4348:: with SMTP id z8mr3326230ejm.371.1609949495817;
        Wed, 06 Jan 2021 08:11:35 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id q25sm1570041eds.85.2021.01.06.08.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 08:11:35 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/6] kernel-shark: Add kshark_data_container to libkshark
Date:   Wed,  6 Jan 2021 18:11:16 +0200
Message-Id: <20210106161120.119085-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106161120.119085-1-y.karadz@gmail.com>
References: <20210106161120.119085-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We add an infrastructure for recording the data from a particular trace
event field during data loading. The goal is to avoid the use of the
expensive "read_event_field" operation in the case when the value of the
field is needed during the visualization processing (in a plugins for
example).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c           | 147 ++++++++++++++++++++++++++++++++++++++
 src/libkshark.h           |  43 +++++++++++
 tests/libkshark-tests.cpp |  34 +++++++++
 3 files changed, 224 insertions(+)

diff --git a/src/libkshark.c b/src/libkshark.c
index 3aa3fa2..8722794 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -2116,3 +2116,150 @@ kshark_merge_data_matrices(struct kshark_matrix_data_set *buffers, int n_buffers
  end:
 	return merged_data;
 }
+
+/** @brief Allocate memory for kshark_data_container. */
+struct kshark_data_container *kshark_init_data_container()
+{
+	struct kshark_data_container *container;
+
+	container = calloc(1, sizeof(*container));
+	if (!container)
+		goto fail;
+
+	container->data = calloc(KS_CONTAINER_DEFAULT_SIZE,
+				  sizeof(*container->data));
+
+	if (!container->data)
+		goto fail;
+
+	container->capacity = KS_CONTAINER_DEFAULT_SIZE;
+	container->sorted = false;
+
+	return container;
+
+ fail:
+	fprintf(stderr, "Failed to allocate memory for data container.\n");
+	kshark_free_data_container(container);
+	return NULL;
+}
+
+/**
+ * @brief Free the memory allocated for a kshark_data_container
+ * @param container: Intput location for the kshark_data_container object.
+ */
+void kshark_free_data_container(struct kshark_data_container *container)
+{
+	for (ssize_t i = 0; i < container->size; ++i)
+		free(container->data[i]);
+
+	free(container->data);
+	free(container);
+}
+
+/**
+ * @brief Append data field value to a kshark_data_container
+ * @param container: Intput location for the kshark_data_container object.
+ * @param entry: The entry that needs addition data field value.
+ * @param field: The value of data field to be added.
+ *
+ * @returns The size of the container after the addition.
+ */
+ssize_t kshark_data_container_append(struct kshark_data_container *container,
+				     struct kshark_entry *entry, int64_t field)
+{
+	if (container->capacity == container->size) {
+		bool ok;
+
+		KS_DOUBLE_SIZE(struct kshark_data_field_int64 *,
+			       container->data,
+			       &container->capacity,
+			       &ok);
+
+		if (!ok)
+			return -ENOMEM;
+	}
+
+	container->data[container->size] = malloc(sizeof(container->data));
+	container->data[container->size]->entry = entry;
+	container->data[container->size++]->field = field;
+
+	return container->size;
+}
+
+static int compare_time_dc(const void* a, const void* b)
+{
+	const struct kshark_data_field_int64 *field_a, *field_b;
+
+	field_a = *(const struct kshark_data_field_int64 **) a;
+	field_b = *(const struct kshark_data_field_int64 **) b;
+
+	if (field_a->entry->ts > field_b->entry->ts)
+		return 1;
+
+	if (field_a->entry->ts < field_b->entry->ts)
+		return -1;
+
+	return 0;
+}
+
+/**
+ * @brief Sort in time the records in kshark_data_container. The container is
+ *	  resized in order to free the unused memory capacity.
+ *
+ * @param container: Intput location for the kshark_data_container object.
+ */
+void kshark_data_container_sort(struct kshark_data_container *container)
+{
+	struct kshark_data_field_int64	**data_tmp;
+
+	qsort(container->data, container->size,
+	      sizeof(struct kshark_data_field_int64 *),
+	      compare_time_dc);
+
+	container->sorted = true;
+
+	data_tmp = realloc(container->data,
+			   container->size * sizeof(*container->data));
+
+	if (!data_tmp)
+		return;
+
+	container->data = data_tmp;
+	container->capacity = container->size;
+}
+
+/**
+ * @brief Binary search inside a time-sorted array of kshark_data_field_int64.
+ *
+ * @param time: The value of time to search for.
+ * @param data: Input location for the data.
+ * @param l: Array index specifying the lower edge of the range to search in.
+ * @param h: Array index specifying the upper edge of the range to search in.
+ *
+ * @returns On success, the index of the first kshark_data_field_int64 inside
+ *	    the range, having a timestamp equal or bigger than "time".
+ *	    If all fields inside the range have timestamps greater than "time"
+ *	    the function returns BSEARCH_ALL_GREATER (negative value).
+ *	    If all fields inside the range have timestamps smaller than "time"
+ *	    the function returns BSEARCH_ALL_SMALLER (negative value).
+ */
+ssize_t kshark_find_entry_field_by_time(int64_t time,
+					struct kshark_data_field_int64 **data,
+					size_t l, size_t h)
+{
+	size_t mid;
+
+	if (data[l]->entry->ts > time)
+		return BSEARCH_ALL_GREATER;
+
+	if (data[h]->entry->ts < time)
+		return BSEARCH_ALL_SMALLER;
+
+	/*
+	 * After executing the BSEARCH macro, "l" will be the index of the last
+	 * entry having timestamp < time and "h" will be the index of the first
+	 * entry having timestamp >= time.
+	 */
+	BSEARCH(h, l, data[mid]->entry->ts < time);
+	return h;
+}
diff --git a/src/libkshark.h b/src/libkshark.h
index dd4f2b7..aa4b3ca 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -1105,6 +1105,49 @@ struct kshark_matrix_data_set
 kshark_merge_data_matrices(struct kshark_matrix_data_set *buffers,
 			   int n_buffers);
 
+/**
+ * Structure used to store the data of a kshark_entry plus one additional
+ * 64 bit integer data field.
+ */
+struct kshark_data_field_int64 {
+	/** The entry object holding the basic data of the trace record. */
+	struct kshark_entry	*entry;
+
+	/** Additional 64 bit integer data field. */
+	int64_t			field;
+};
+
+/** The capacity of the kshark_data_container object after initialization. */
+#define KS_CONTAINER_DEFAULT_SIZE	1024
+
+/** Structure used to store an array of entries and data fields. */
+struct kshark_data_container {
+	/** An array of kshark_data_field_int64 objects. */
+	struct kshark_data_field_int64	**data;
+
+	/** The total number of kshark_data_field_int64 objects stored. */
+	ssize_t		size;
+
+	/** The memory capacity of the container. */
+	ssize_t		capacity;
+
+	/** Is sorted in time. */
+	bool		sorted;
+};
+
+struct kshark_data_container *kshark_init_data_container();
+
+void kshark_free_data_container(struct kshark_data_container *container);
+
+ssize_t kshark_data_container_append(struct kshark_data_container *container,
+				     struct kshark_entry *entry, int64_t field);
+
+void kshark_data_container_sort(struct kshark_data_container *container);
+
+ssize_t kshark_find_entry_field_by_time(int64_t time,
+					struct kshark_data_field_int64 **data,
+					size_t l, size_t h);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/tests/libkshark-tests.cpp b/tests/libkshark-tests.cpp
index 27c1171..06fdf62 100644
--- a/tests/libkshark-tests.cpp
+++ b/tests/libkshark-tests.cpp
@@ -46,3 +46,37 @@ BOOST_AUTO_TEST_CASE(add_remove_streams)
 
 	kshark_close_all(kshark_ctx);
 }
+
+#define N_VALUES	2 * KS_CONTAINER_DEFAULT_SIZE + 1
+#define MAX_TS		100000
+BOOST_AUTO_TEST_CASE(fill_data_container)
+{
+	struct kshark_data_container *data = kshark_init_data_container();
+	struct kshark_entry entries[N_VALUES];
+	int64_t i, ts_last(0);
+
+	BOOST_CHECK_EQUAL(data->capacity, KS_CONTAINER_DEFAULT_SIZE);
+
+	for (i = 0; i < N_VALUES; ++i) {
+		entries[i].ts = rand() % MAX_TS;
+		kshark_data_container_append(data, &entries[i], i);
+	}
+
+	BOOST_CHECK_EQUAL(data->size, N_VALUES);
+	BOOST_CHECK_EQUAL(data->capacity, 4 * KS_CONTAINER_DEFAULT_SIZE);
+
+	kshark_data_container_sort(data);
+	BOOST_CHECK_EQUAL(data->capacity, N_VALUES);
+	for (i = 0; i < N_VALUES; ++i) {
+		BOOST_REQUIRE(data->data[i]->entry->ts >= ts_last);
+		ts_last = data->data[i]->entry->ts;
+	}
+
+	i = kshark_find_entry_field_by_time(MAX_TS / 2, data->data,
+					    0, N_VALUES -1);
+
+	BOOST_REQUIRE(data->data[i - 1]->entry->ts < MAX_TS / 2);
+	BOOST_REQUIRE(data->data[i]->entry->ts >= MAX_TS / 2);
+
+	kshark_free_data_container(data);
+}
-- 
2.25.1

