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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E87CC433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 368C123118
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 16:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbhAGQQr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbhAGQQq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 11:16:46 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D36C0612F6
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 08:16:06 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id 6so10461872ejz.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 08:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bpYByy6xxf6EZQ35P6Jo81Zh0mOC5DoQ7VSTCF7bKok=;
        b=ARp0tLRABwsI3Wg30CuWlqzx/a50E4WOdjmW3Kxj25/Id+sW0d+8BjTICUeEAhvqlU
         OP1HxWEQfZmxbWdUwj0w4b6uH/szqDzQkhn9SGR9fkYGjhITcYlDVex4pE7Qv0uF02/G
         QW0R8m7I3zXgDiQJ2QcmmTlklrbhJEPjZowkjd66oRDRUgdJEHYDopHZ4PWerNL3Ec4B
         4qV2JToZOHOwiF3eJ0OKPO8b8jFeb9QwubZdOI7dn15Pfw1tC4M51EgLFkpl/2Bf8mI4
         IZDe3ZzgBCioua73EutCpTdZRW7GJ7B1dQrhbrWHnuNDdKEzBGuYygLoX39ZIWUMqgeP
         TX7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bpYByy6xxf6EZQ35P6Jo81Zh0mOC5DoQ7VSTCF7bKok=;
        b=sdyLM1cGS+eM0OLJ9xYN6Mw8Jl2uHY6jB5LqWGkvw9nXoBRnv85IqMMQmxuMNhD3wL
         rSqNCMaK7AA4dDWk4EFMVY3puZnCCkgDMfOFWR4/0fKDVzAjO4MTvlwAubNZUYEDJ1No
         Nl9zkQMV5glwjeA3WHaBf25m5ajS8L+64Mmsol0QkGMU35y12HIjEoorVicRj89KBfRC
         vJzSRkLHk2W1p7iRxl98BKtPU+388f6gUY8uo1Sj1jxZXH3M3HMgGtokddQDYokURunB
         CxO5kiXdihF6Po7mcbKzD6R24B1ARsNw2MfMYbAXmNG4SxQVrKBnKVcvsyOIGJoo/71P
         rTUg==
X-Gm-Message-State: AOAM533nYd60i1hzURmMJ9AGUIGmx07qAhyrUpV+/Icmm3R0pNyNkEAh
        aJI3MP6icQjSGaJwzBpiH8E=
X-Google-Smtp-Source: ABdhPJzjjybgXECGY3rBtGnUDjmpoqMMHurDKPsHl2o5tMXDT+ElffyKKzodsOTy4CoaY0HWxyJGlA==
X-Received: by 2002:a17:906:55d0:: with SMTP id z16mr6759782ejp.466.1610036164882;
        Thu, 07 Jan 2021 08:16:04 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id j23sm2846212edv.45.2021.01.07.08.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 08:16:04 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/6] kernel-shark: Add kshark_data_container to libkshark
Date:   Thu,  7 Jan 2021 18:15:43 +0200
Message-Id: <20210107161547.207270-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107161547.207270-1-y.karadz@gmail.com>
References: <20210107161547.207270-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We add an infrastructure for recording the data from a particular trace
event field during data loading. The goal is to avoid the use of the
expensive "read_event_field" operation in the case when the value of the
field is needed during the visualization processing (in plugins for
example).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c           | 147 ++++++++++++++++++++++++++++++++++++++
 src/libkshark.h           |  43 +++++++++++
 tests/libkshark-tests.cpp |  37 ++++++++++
 3 files changed, 227 insertions(+)

diff --git a/src/libkshark.c b/src/libkshark.c
index 0e2ce7a..f73e1da 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -2110,3 +2110,150 @@ kshark_merge_data_matrices(struct kshark_matrix_data_set *buffers, int n_buffers
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
+	if (!container)
+		return;
+
+	for (ssize_t i = 0; i < container->size; ++i)
+		free(container->data[i]);
+
+	free(container->data);
+	free(container);
+}
+
+/**
+ * @brief Append data field value to a kshark_data_container
+ * @param container: Input location for the kshark_data_container object.
+ * @param entry: The entry that needs addition data field value.
+ * @param field: The value of data field to be added.
+ *
+ * @returns The size of the container after the addition.
+ */
+ssize_t kshark_data_container_append(struct kshark_data_container *container,
+				     struct kshark_entry *entry, int64_t field)
+{
+	struct kshark_data_field_int64 *data_field;
+
+	if (container->capacity == container->size) {
+		if (!KS_DOUBLE_SIZE(container->data,
+				    container->capacity))
+			return -ENOMEM;
+	}
+
+	data_field = malloc(sizeof(*data_field));
+	data_field->entry = entry;
+	data_field->field = field;
+	container->data[container->size++] = data_field;
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
index d0a3594..8a5dcf1 100644
--- a/tests/libkshark-tests.cpp
+++ b/tests/libkshark-tests.cpp
@@ -66,3 +66,40 @@ BOOST_AUTO_TEST_CASE(doule_size_macro)
 	for (; i < n; ++i)
 		BOOST_CHECK_EQUAL(arr[i], 0);
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
+		kshark_data_container_append(data, &entries[i], 10 - entries[i].ts);
+	}
+
+	BOOST_CHECK_EQUAL(data->size, N_VALUES);
+	BOOST_CHECK_EQUAL(data->capacity, 4 * KS_CONTAINER_DEFAULT_SIZE);
+
+	kshark_data_container_sort(data);
+	BOOST_CHECK_EQUAL(data->capacity, N_VALUES);
+	for (i = 0; i < N_VALUES; ++i) {
+		BOOST_REQUIRE(data->data[i]->entry->ts >= ts_last);
+		BOOST_CHECK_EQUAL(data->data[i]->entry->ts,
+				  10 - data->data[i]->field);
+
+		ts_last = data->data[i]->entry->ts;
+	}
+
+	i = kshark_find_entry_field_by_time(MAX_TS / 2, data->data,
+					    0, N_VALUES - 1);
+
+	BOOST_REQUIRE(data->data[i - 1]->entry->ts < MAX_TS / 2);
+	BOOST_REQUIRE(data->data[i]->entry->ts >= MAX_TS / 2);
+
+	kshark_free_data_container(data);
+}
-- 
2.25.1

