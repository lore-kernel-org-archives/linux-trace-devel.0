Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C1FC001DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jul 2023 19:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjG1TFq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjG1TFo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 15:05:44 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339E73AA8
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 12:05:41 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id ca18e2360f4ac-78374596182so99033939f.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jul 2023 12:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690571140; x=1691175940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JMbb7Q3GMhiHEEnUcGGyQZpaC0Zkjt1iZeRWhkvmC1k=;
        b=LcURZXLQmHNhrJ4H8GEb0QBykD0FIuHSui+03uoRKnwbu9JFuwAQ2lUL0HR0KOPnIw
         A6KqtJ9aPIF71kFMIwVXpuJnt3cFevGOGaRaqhrYf49tbsurQXKmS6/pcucxNuKLgRwK
         hfR0UoD9WX7tYpGLAuHME4NZzqccJDf8SSELe+Lum+pMg0p1kFcJ0PuLOpjHdoxb5MVS
         0Qr9M+4VgtLVJUJhVXMkHlxttr7eU2Zc7+nMvgCQBsvo7nKf3U+YxDFKTavCn1egcUR6
         v9EZhZgK9F93ecUIAmmcun8J3tsimrQyelJegmHbxzSuMpdxFJ/t8ZLskoZd90cwvomM
         +Lig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690571140; x=1691175940;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JMbb7Q3GMhiHEEnUcGGyQZpaC0Zkjt1iZeRWhkvmC1k=;
        b=W01fk8ayYq4gzNNIU8jnMPVzHPW9IOdk3mwLSvRNRnbIpxh2seyf95NGs5qcAmqWM6
         OMUa9Evs6RWKEWDTZWnzZ2C2PrBObtaBW7Pu2myZlTC0a+sa3VhOgNmV3cMNlKdiNuPY
         7Q/myFUnrqBas8nc1fenk9gIlp+bxaXLjhK1WDHUyLLbz0ItAUEZdBi3Qpbk0CR7+LAb
         Gphw5GW3U148tKaAuXa8mn3ULRdzBLQ9HnI9jScTYPndo8LndVp7HgteFkEG+FD5DgS1
         AW1FdkvH7qBLiQiKx28L5C2HTgsaUYznz5S99xXeNaT+5boUSNJSUO9vhE5e9gMmLdPU
         GAsw==
X-Gm-Message-State: ABy/qLYyzwR7geYiSVxxNvNR0TwgxFh1Q3shLqoEcZo5il9JqrOd5Y7p
        Odl9PohCG6nssImD5KY5fzl81YxAZA1uWg==
X-Google-Smtp-Source: APBJJlHp5Q4CYHpJSDn2T1Diq4BoPIMIOrNfIpO+/KJSzP2gKB01zaeMlpJZG/kiiUq9N7hkfYNsZA==
X-Received: by 2002:a6b:5903:0:b0:785:d0d7:3304 with SMTP id n3-20020a6b5903000000b00785d0d73304mr439961iob.14.1690571140404;
        Fri, 28 Jul 2023 12:05:40 -0700 (PDT)
Received: from localhost.localdomain ([2a00:79e1:abc:1705:d317:f8ec:adf0:bb06])
        by smtp.gmail.com with ESMTPSA id u22-20020a02aa96000000b0042b3a328ee0sm1268452jai.166.2023.07.28.12.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 12:05:40 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH 2/5] histograms: traceeval initialize
Date:   Fri, 28 Jul 2023 15:04:37 -0400
Message-ID: <20230728190515.23088-2-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230728190515.23088-1-stevie.6strings@gmail.com>
References: <20230728190515.23088-1-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>

traceeval_init() creates a new struct traceeval instance with regards
to the struct traceeval_type array arguments keys and vals. These arrays
define the structure of the histogram, with each describing the expected
structure of inserted arrays of union traceeval_data. The keys and vals
arguments are copied on the heap to ensure that the struct traceeval
instance has access to the definition regardless of how the user
initialized keys and vals.

Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
---
 Makefile         |   2 +-
 src/Makefile     |   1 +
 src/histograms.c | 285 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 287 insertions(+), 1 deletion(-)
 create mode 100644 src/histograms.c

diff --git a/Makefile b/Makefile
index 4a24d5a..3ea051c 100644
--- a/Makefile
+++ b/Makefile
@@ -172,7 +172,7 @@ libs: $(LIBRARY_A) $(LIBRARY_SO)
 
 VALGRIND = $(shell which valgrind)
 UTEST_DIR = utest
-UTEST_BINARY = trace-utest
+UTEST_BINARY = eval-utest
 
 test: force $(LIBRARY_STATIC)
 ifneq ($(CUNIT_INSTALLED),1)
diff --git a/src/Makefile b/src/Makefile
index b4b6e52..b32a389 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -4,6 +4,7 @@ include $(src)/scripts/utils.mk
 
 OBJS =
 OBJS += trace-analysis.o
+OBJS += histograms.o
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 
diff --git a/src/histograms.c b/src/histograms.c
new file mode 100644
index 0000000..13830e4
--- /dev/null
+++ b/src/histograms.c
@@ -0,0 +1,285 @@
+
+/* SPDX-License-Identifier: MIT */
+/*
+ * libtraceeval histogram interface implementation.
+ *
+ * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
+ */
+
+#include <histograms.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <string.h>
+#include <stdarg.h>
+
+/**
+ * Iterate over @keys, which should be an array of struct traceeval_type's,
+ * until reaching an instance of type TRACEEVAL_TYPE_NONE.
+ * @i should be a declared integer type.
+ */
+#define for_each_key(i, keys)	\
+	for (i = 0; (keys)[(i)].type != TRACEEVAL_TYPE_NONE; (i)++)
+
+/** A key-value pair */
+struct entry {
+	union traceeval_data	*keys;
+	union traceeval_data	*vals;
+};
+
+/** A table of key-value entries */
+struct hist_table {
+	struct entry	*map;
+	size_t		nr_entries;
+};
+
+/** Histogram */
+struct traceeval {
+	struct traceeval_type		*def_keys;
+	struct traceeval_type		*def_vals;
+	struct hist_table		*hist;
+};
+
+/** Iterate over results of histogram */
+struct traceeval_iterator {};  // TODO
+
+/**
+ * Print error message.
+ * Additional arguments are used with respect to fmt.
+ */
+static void print_err(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	vfprintf(stderr, fmt, ap);
+	va_end(ap);
+	fprintf(stderr, "\n");
+}
+
+// TODO
+int traceeval_compare(struct traceeval *orig, struct traceeval *copy)
+{
+	return -1;
+}
+
+/**
+ * Resize a struct traceeval_type array to a size of @size + 1.
+ *
+ * Returns a pointer to the resized array, or NULL if the provided pointer was
+ * freed to due lack of memory.
+ */
+static struct traceeval_type *type_realloc(struct traceeval_type *defs,
+		size_t size)
+{
+	struct traceeval_type *tmp_defs = NULL;
+	tmp_defs = realloc(defs,
+			(size + 1) * sizeof(struct traceeval_type));
+	if (!tmp_defs)
+		goto fail_type_realloc;
+	return tmp_defs;
+
+fail_type_realloc:
+	for (int i = 0; i < size; i++) {
+		if (defs[i].name)
+			free(defs[i].name);
+	}
+	free(defs);
+	return NULL;
+}
+
+/**
+ * Clone traceeval_type array @defs to the heap. Must be terminated with
+ * an instance of type TRACEEVAL_TYPE_NONE.
+ * Returns NULL if @defs is NULL, or a name is not null terminated.
+ */
+static struct traceeval_type *type_alloc(const struct traceeval_type *defs)
+{
+	struct traceeval_type *new_defs = NULL;
+	char *name;
+	size_t size = 0;
+
+	// Empty def is represented with single TRACEEVAL_TYPE_NONE
+	if (defs == NULL) {
+		if (!(new_defs = calloc(1, sizeof(struct traceeval_type))))
+			goto fail_type_alloc;
+		new_defs->type = TRACEEVAL_TYPE_NONE;
+		return new_defs;
+	}
+
+	for_each_key(size, defs) {
+		// Resize heap defs and clone
+		new_defs = type_realloc(new_defs, size);
+		if (!new_defs)
+			goto fail_type_alloc;
+
+		// copy current def data to new_def
+		new_defs[size] = defs[size];
+		new_defs[size].name = NULL;
+		// copy name to heap if it's not NULL or type NONE
+		if (defs[size].type != TRACEEVAL_TYPE_NONE) {
+			name = NULL;
+			if (!defs[size].name)
+				goto fail_type_alloc_name;
+
+			name = strdup(defs[size].name);
+			if (!name)
+				goto fail_type_alloc_name;
+			new_defs[size].name = name;
+		}
+	}
+
+	// append array terminator
+	new_defs = type_realloc(new_defs, size);
+	if (!new_defs)
+		goto fail_type_alloc;
+	new_defs[size].type = TRACEEVAL_TYPE_NONE;
+
+	return new_defs;
+fail_type_alloc:
+	if (defs[size].name)
+		print_err("failed to allocate memory for traceeval_type %s", defs[size].name);
+	print_err("failed to allocate memory for traceeval_type index %zu", size);
+	return NULL;
+
+fail_type_alloc_name:
+	if (defs[size].name)
+		print_err("failed to allocate name for traceeval_type %s", defs[size].name);
+
+	print_err("failed to allocate name for traceeval_type index %zu", size);
+	return NULL;
+}
+
+/**
+ * Create a new histogram over the given keys and values.
+ */
+struct traceeval *traceeval_init(const struct traceeval_type *keys,
+				 const struct traceeval_type *vals)
+{
+	struct traceeval *teval;
+	char *err_msg;
+	struct traceeval_type type = {
+		.type = TRACEEVAL_TYPE_NONE
+	};
+
+	if (!keys)
+		return NULL;
+
+	if (keys->type == TRACEEVAL_TYPE_NONE) {
+		err_msg = "keys cannot start with type TRACEEVAL_TYPE_NONE";
+		goto fail_eval_init_unalloced;
+	}
+
+	teval = calloc(1, sizeof(struct traceeval));
+	if (!teval) {
+		err_msg = "failed to allocate memory for traceeval instance";
+		goto fail_eval_init_unalloced;
+	}
+
+	teval->def_keys = type_alloc(keys);
+	if (!teval->def_keys) {
+		err_msg = "failed to allocate user defined keys";
+		goto fail_eval_init;
+	}
+
+	// if vals is NULL, alloc single type NONE
+	if (vals)
+		teval->def_vals = type_alloc(vals);
+	else
+		teval->def_vals = type_alloc(&type);
+
+	if (!teval->def_vals) {
+		err_msg = "failed to allocate user defined values";
+		goto fail_eval_init;
+	}
+
+	teval->hist = calloc(1, sizeof(struct hist_table));
+	if (!teval->hist) {
+		err_msg = "failed to allocate memory for histogram";
+		goto fail_eval_init;
+	}
+	teval->hist->nr_entries = 0;
+
+	return teval;
+fail_eval_init:
+	traceeval_release(teval);
+	/* fall-through */
+
+fail_eval_init_unalloced:
+	print_err(err_msg);
+	return NULL;
+}
+
+// TODO
+void traceeval_release(struct traceeval *teval)
+{
+
+}
+
+// TODO
+int traceeval_insert(struct traceeval *teval,
+		     const union traceeval_data *keys,
+		     const union traceeval_data *vals)
+{
+	return -1;
+}
+
+// TODO
+int traceeval_query(struct traceeval *teval,
+		    const union traceeval_data *keys,
+		    union traceeval_data * const *results)
+{
+	return 0;
+}
+
+// TODO
+int traceeval_find_key(struct traceeval *teval, const char *field)
+{
+	return -1;
+}
+
+// TODO
+int traceeval_find_val(struct traceeval *teval, const char *field)
+{
+	return -1;
+}
+
+// TODO
+void traceeval_results_release(struct traceeval *teval,
+			       const union traceeval_data *results)
+{
+
+}
+
+// TODO
+struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval)
+{
+	return NULL;
+}
+
+// TODO
+int traceeval_iterator_sort(struct traceeval_iterator *iter,
+			    const char *sort_field, int level, bool ascending)
+{
+	return -1;
+}
+
+// TODO
+int traceeval_iterator_next(struct traceeval_iterator *iter,
+			    const union traceeval_data **keys)
+{
+	return 0;
+}
+
+// TODO
+void traceeval_keys_release(struct traceeval_iterator *iter,
+			    const union traceeval_data *keys)
+{
+
+}
+
+// TODO
+int traceeval_stat(struct traceeval *teval, const union traceeval_data *keys,
+		   const char *field, struct traceeval_stat *stat)
+{
+	return -1;
+}
-- 
2.41.0

