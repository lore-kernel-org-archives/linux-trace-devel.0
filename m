Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D309C04A6A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 17:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbjHHRaU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbjHHR3s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 13:29:48 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80678C0B8
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 09:12:52 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id af79cd13be357-76714caf466so454430385a.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Aug 2023 09:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691511138; x=1692115938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8+j2bTWGx5aXCV7PhpIJjmFdeaTKkL9QWYHxWjjg/4=;
        b=ICIGUMBFIgsIQjtjU6LGL6PXcVdtTqq2CP1Q2jyGiw3Icniddk9u29Td1+n7zhdMN+
         PyZuhLrECQnKI5onzsVcGWeEyJfuPBKKOjJ02mZ7zL5eqUGzQfKG+q13RHQI+Vgv07rN
         hU1u9wG122eaAXnTUtJ6k9sd5C72XmTerXB/ebeHqt3MU+Tti/eH2ihFVR5K/M9knh6A
         xwfwsdwc4STl47Zqv1wPXYSyxiM6qpWEmttm1wPceBnTR1Qh7RJWRp2eWDLHQeJVclD1
         e1axal1TaP9IDYeC2oQM/EFL4ii3MG3Y+YBONyGkcSU44xnx5zyEKw5Z1v6yUBmLBvVi
         HQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691511138; x=1692115938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c8+j2bTWGx5aXCV7PhpIJjmFdeaTKkL9QWYHxWjjg/4=;
        b=lFXf5xlOQ8UcbnDNnbbMI/g7pN5uN54oO7/EcyPgxiwyweoDE5dwkHtiWBSbtM3Zef
         dKg28OzvEJ5hmbLJlFIB6XKRLZzgAn+o53XqDFALyA1vD0K68Rr/GdH1otUP6aYdde6P
         G+ArzMmCG093hkvWZpST7f/qNzCLqgMBtXWyEWwvM3lesMPRJ7QUMAkvzV1vaRB9jyVl
         +NVR7pdlm7uZd+VLkCBlj2J/U4jD+m4seNDHRavhnAEb77VP5YShH+t6P3GiKYK+Gar4
         Ub1AKZXjjFIufOGMVQA/bw7DAr1jK1cX6uDho5LKw/qEclwRO7j9fqags2xbO33DGb9D
         t8fQ==
X-Gm-Message-State: AOJu0YxfoJmzhmabmKf1iGqqKHYSDSFrzigOUJ69BC5TDlNIw1FFxc2Q
        ywiOgfvv+tVshDouvP9XCxHuF+O6mOA=
X-Google-Smtp-Source: AGHT+IFNmfIfNK1JC6paPewme/Ulr3uomLp3aGhc1UFGL6wEodxGBH20GMPBoJHoifWdhPfKaFp6Wg==
X-Received: by 2002:a05:620a:f0d:b0:765:8204:dd64 with SMTP id v13-20020a05620a0f0d00b007658204dd64mr190205qkl.7.1691511137785;
        Tue, 08 Aug 2023 09:12:17 -0700 (PDT)
Received: from 3xKetch.hsd1.ma.comcast.net ([2601:180:8300:500::6aa8])
        by smtp.gmail.com with ESMTPSA id s7-20020a05620a030700b0076c97ae43b9sm3381540qkm.66.2023.08.08.09.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 09:12:17 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v3 2/6] histograms: Add traceeval initialize and release
Date:   Tue,  8 Aug 2023 12:11:55 -0400
Message-ID: <20230808161204.5704-3-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230808161204.5704-1-stevie.6strings@gmail.com>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>

traceeval_init() creates a new struct traceeval instance with regards
to the struct traceeval_type array arguments keys and vals. These arrays
define the structure of the histogram, with each describing the expected
structure of inserted arrays of union traceeval_data. The keys and vals
arguments are copied on the heap to ensure that the struct traceeval
instance has access to the definition regardless of how the user
initialized keys and vals.

traceeval_init() uses traceeval_release() and it's helper functions to
clean up on error.

traceeval_release() deconstructs a given struct traceeval instance. It
frees any data allocated to the heap within the entries to the histogram,
and the names allocated for the struct traceeval_type key-value
definitions.

Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
---
 Makefile                 |   2 +-
 include/traceeval-hist.h |   7 +
 src/Makefile             |   1 +
 src/histograms.c         | 310 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 319 insertions(+), 1 deletion(-)
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
diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index ebce94e..5203520 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -127,4 +127,11 @@ struct traceeval_iterator;
 
 struct traceeval;
 
+/* Histogram interfaces */
+
+struct traceeval *traceeval_init(const struct traceeval_type *keys,
+				 const struct traceeval_type *vals);
+
+void traceeval_release(struct traceeval *teval);
+
 #endif /* __LIBTRACEEVAL_HIST_H__ */
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
index 0000000..b85d1a8
--- /dev/null
+++ b/src/histograms.c
@@ -0,0 +1,310 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * libtraceeval histogram interface implementation.
+ *
+ * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
+ */
+
+#include <stdbool.h>
+#include <string.h>
+#include <stdarg.h>
+#include <stdio.h>
+
+#include <traceeval-hist.h>
+
+/* A key-value pair */
+struct entry {
+	union traceeval_data	*keys;
+	union traceeval_data	*vals;
+};
+
+/* A table of key-value entries */
+struct hist_table {
+	struct entry	*map;
+	size_t		nr_entries;
+};
+
+/* Histogram */
+struct traceeval {
+	struct traceeval_type		*key_types;
+	struct traceeval_type		*val_types;
+	struct hist_table		*hist;
+	size_t				nr_key_types;
+	size_t				nr_val_types;
+};
+
+/*
+ * print_err() - print an error message
+ * @fmt: String format
+ * @...: (optional) Additional arguments to print in conjunction with @format
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
+/*
+ * type_release() - free a struct traceeval_type array
+ * @defs: The array to release
+ * @len: The length of @defs
+ *
+ * It is assumed that all elements of @defs, within the length of @len, have
+ * name fields initialized to valid pointers.
+ *
+ * This function was designed to be used on an array allocated by type_alloc().
+ * Note that type_alloc() initializes all name fields of elements within the
+ * returned size.
+ */
+static void type_release(struct traceeval_type *defs, size_t len)
+{
+	if (!defs)
+		return;
+
+	for (size_t i = 0; i < len; i++) {
+		free(defs[i].name);
+	}
+
+	free(defs);
+}
+
+/*
+ * type_alloc() - clone a struct traceeval_type array
+ * @defs: The original array
+ * @copy: A pointer to where to place the @defs copy
+ *
+ * Clone traceeval_type array @defs to the heap, and place in @copy.
+ * @defs must be terminated with an instance of type TRACEEVAL_TYPE_NONE.
+ *
+ * The size of the copy pointed to by @copy is returned. It counts all elements
+ * in @defs excluding the terminating TRACEEVAL_TYPE_NONE traceeval_type.
+ * The copy contains everything from @defs excluding the TRACEEVAL_TYPE_NONE
+ * traceeval_type.
+ * On error, copy is set to point to NULL.
+ *
+ * The name field of each element of @defs (except for the terminating
+ * TRACEEVAL_TYPE_NONE) must be a NULL-terminated string. The validity of the
+ * name field is not checked, but errors are returned upon finding unset name
+ * fields and string duplication failures. It is guaranteed that all elements
+ * of the copy within the returned size have valid pointers in their name
+ * fields.
+ *
+ * Returns the size of the array pointed to by @copy, or -1 on error.
+ */
+static size_t type_alloc(const struct traceeval_type *defs,
+			 struct traceeval_type **copy)
+{
+	struct traceeval_type *new_defs = NULL;
+	size_t size;
+	size_t i;
+
+	if (!defs) {
+		*copy = NULL;
+		return 0;
+	}
+
+	for (size = 0; defs && defs[size].type != TRACEEVAL_TYPE_NONE; size++)
+		;
+
+	if (size) {
+		new_defs = calloc(size, sizeof(*new_defs));
+	} else {
+		*copy = NULL;
+		return 0;
+	}
+
+	for (i = 0; i < size; i++) {
+		/* copy current def data to new_def */
+		new_defs[i] = defs[i];
+
+		/* copy name to heap, ensures name copied */
+		if (!defs[i].name)
+			goto fail;
+		new_defs[i].name = strdup(defs[i].name);
+
+		if (!new_defs[i].name)
+			goto fail;
+	}
+
+	*copy = new_defs;
+	return size;
+
+fail:
+	if (defs[i].name)
+		print_err("Failed to allocate traceeval_type %zu", size);
+	else
+		print_err("traceeval_type list missing a name");
+
+	for (; i >=0; i--)
+		free(new_defs[i].name);
+	free(new_defs);
+	*copy = NULL;
+	return -1;
+}
+
+/*
+ * traceeval_init - create a traceeval descriptor
+ * @keys: Defines the keys to differentiate traceeval entries
+ * @vals: Defines values attached to entries differentiated by @keys.
+ *
+ * The @keys and @vals define how the traceeval instance will be populated.
+ * The @keys will be used by traceeval_query() to find an instance within
+ * the "histogram". Note, both the @keys and @vals array must end with:
+ * { .type = TRACEEVAL_TYPE_NONE }.
+ *
+ * The @keys and @vals passed in are copied for internal use.
+ *
+ * For any member of @keys or @vals that isn't of type TRACEEVAL_TYPE_NONE,
+ * the name field must be a null-terminated string. Members of type
+ * TRACEEVAL_TYPE_NONE are used to terminate the array, therefore their other
+ * fields are ignored.
+ *
+ * @vals can be NULL or start with its type field as TRACEEVAL_TYPE_NONE to
+ * define the values of the histogram to be empty.
+ * @keys must be populated with at least one element that is not of type
+ * TRACEEVAL_TYPE_NONE.
+ *
+ * Returns the descriptor on success, or NULL on error.
+ */
+struct traceeval *traceeval_init(const struct traceeval_type *keys,
+				 const struct traceeval_type *vals)
+{
+	struct traceeval *teval;
+	char *err_msg;
+
+	if (!keys)
+		return NULL;
+
+	if (keys->type == TRACEEVAL_TYPE_NONE) {
+		err_msg = "Keys cannot start with type TRACEEVAL_TYPE_NONE";
+		goto fail;
+	}
+
+	/* alloc teval */
+	teval = calloc(1, sizeof(*teval));
+	if (!teval) {
+		err_msg = "Failed to allocate memory for traceeval instance";
+		goto fail;
+	}
+
+	/* alloc key types */
+	teval->nr_key_types = type_alloc(keys, &teval->key_types);
+	if (teval->nr_key_types <= 0) {
+		err_msg = "Failed to allocate user defined keys";
+		goto fail_release;
+	}
+
+	/* alloc val types */
+	teval->nr_val_types = type_alloc(vals, &teval->val_types);
+	if (teval->nr_val_types < 0) {
+		err_msg = "Failed to allocate user defined values";
+		goto fail_release;
+	}
+
+	/* alloc hist */
+	teval->hist = calloc(1, sizeof(*teval->hist));
+	if (!teval->hist) {
+		err_msg = "Failed to allocate memory for histogram";
+		goto fail_release;
+	}
+
+	return teval;
+
+fail_release:
+	traceeval_release(teval);
+
+fail:
+	print_err(err_msg);
+	return NULL;
+}
+
+/*
+ * Free any specified dynamic data in @data.
+ */
+static void clean_data(union traceeval_data *data, struct traceeval_type *defs,
+		       size_t size)
+{
+	size_t i;
+
+	if (!data || !defs) {
+		if (data)
+			print_err("Data to be freed without accompanied types!");
+		return;
+	}
+
+	for (i = 0; i < size; i++) {
+		switch (defs[i].type) {
+		case TRACEEVAL_TYPE_STRING:
+			free(data[i].string);
+			break;
+		case TRACEEVAL_TYPE_DYNAMIC:
+			if (defs[i].dyn_release)
+				defs[i].dyn_release(defs + i, data[i].dyn_data);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+/*
+ * Free all possible data stored within the entry.
+ */
+static void clean_entry(struct entry *entry, struct traceeval *teval)
+{
+	if (!entry)
+		return;
+
+	/* free dynamic traceeval_data */
+	clean_data(entry->keys, teval->key_types, teval->nr_key_types);
+	clean_data(entry->vals, teval->val_types, teval->nr_val_types);
+	free(entry->keys);
+	free(entry->vals);
+}
+
+/*
+ * Free the hist_table allocated to a traceeval instance.
+ */
+static void hist_table_release(struct traceeval *teval)
+{
+	struct hist_table *hist = teval->hist;
+
+	if (!hist)
+		return;
+
+	for (size_t i = 0; i < hist->nr_entries; i++) {
+		clean_entry(hist->map + i, teval);
+	}
+
+	free(hist->map);
+	free(hist);
+	teval->hist = NULL;
+}
+
+/*
+ * traceeval_release - release a traceeval descriptor
+ * @teval: An instance of traceeval returned by traceeval_init()
+ *
+ * When the caller of traceeval_init() is done with the returned @teval,
+ * it must call traceeval_release().
+ *
+ * This frees all internally allocated data of @teval and will call the
+ * corresponding dyn_release() functions registered for keys and values of
+ * type TRACEEVAL_TYPE_DYNAMIC.
+ */
+void traceeval_release(struct traceeval *teval)
+{
+	if (!teval)
+		return;
+
+	hist_table_release(teval);
+	type_release(teval->key_types, teval->nr_key_types);
+	type_release(teval->val_types, teval->nr_val_types);
+	teval->key_types = NULL;
+	teval->val_types = NULL;
+	free(teval);
+}
-- 
2.41.0

