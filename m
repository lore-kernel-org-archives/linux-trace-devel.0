Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A54BEC001DF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Aug 2023 22:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjHCWyg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 18:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjHCWyf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 18:54:35 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA6FE67
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Aug 2023 15:54:34 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-2685bcd046eso771474a91.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Aug 2023 15:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691103273; x=1691708073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2nWW/QMaGbBrrlZpRPE137ys+sdCvpX7lSHhCtBN54I=;
        b=OsoVuf8x3YXF+W9w170tpxUXbztdQi2EiqN/1N52DC+zvCBeG7QaW7PQoLYHdOOgF4
         O3P8cSVzLzDvfCBrqu8G/t1iEbgOuDeAX7X+O/Ii0fjlRdMO8NHSuurgkrpv8fMAS71A
         ZExD1fj0+rUSkXMuwtRF8g8WEwYhW281FkT4oD1drouqxWFmV0onU2CKjmYjH2ow/o9y
         3W+8HcPWWTi8RbItnQPLroviM0Qdremi5/i8xiQQwFaUe+3AtmG3XmTeeZpU0EWhHMfX
         I45AQhSQcTgcGUYvtpluLalVI5aKNb2YuVrMx6Fu6jEEqiDhHXqIzujun4DZemj7Xvsr
         0ajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691103273; x=1691708073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2nWW/QMaGbBrrlZpRPE137ys+sdCvpX7lSHhCtBN54I=;
        b=lMeMHffSOUNhSQp5RH33Mpd4LGA9wwe/Kjggur+qUKBtx6F9FOaukDOpoRKghZIjmK
         utu2fZVwNqKxGlVmyXPl4KiMdkEald2fr0qQEVBWXKt9ga27AE7G8iaZgTJ7rY1fjXVW
         1YbPIDjUZmmjZbuRPEPACvVO2oznTRiuBy7hYRm0TxQZi+dY6qJVOFRF0z9qvmE5Lp8k
         SWHWhuHE0RjO2h7XzPTVnJKQmYVVWDef/GfgzvHzz3laWFoICZ5UDHG6Uv4e3iXU0+Mu
         iiG5BSlIosYYAF7GYF7+n8zQ/M2qf4eImUz6iHQkaf4g2XirXQhrqOzh64KPtKIZ4VfZ
         if6g==
X-Gm-Message-State: AOJu0YyRJRu8NoHxe0TTep6ZW+A6OaPpjTri1rG9LUMoWej01FJdCr1/
        5supy/fsCB1wAa74IEV0sANoEQdZpQ7Kmw==
X-Google-Smtp-Source: AGHT+IFGHZ3gYssl2oOlSVlGVlaTibSWeczwBdp9ddyaxhTGc++KbgZ4/mfT6qnbJ7iLODPZGIn9lQ==
X-Received: by 2002:a17:90a:5207:b0:268:5fd8:d8ff with SMTP id v7-20020a17090a520700b002685fd8d8ffmr120163pjh.0.1691103273288;
        Thu, 03 Aug 2023 15:54:33 -0700 (PDT)
Received: from 3xKetch.lan ([2601:600:a17f:b422::ffc])
        by smtp.gmail.com with ESMTPSA id o14-20020a17090a4b4e00b00268b439a0cbsm351120pjl.23.2023.08.03.15.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 15:54:32 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v2 4/5] histograms: Add traceeval compare
Date:   Thu,  3 Aug 2023 18:54:02 -0400
Message-ID: <20230803225413.40697-5-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803225413.40697-1-stevie.6strings@gmail.com>
References: <20230803225413.40697-1-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>

traceeval_compare() compares two struct traceeval instances for
equality. This suite of comparitors was made for testing purposes.

Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
---
 include/traceeval-test.h |  16 +++
 src/histograms.c         | 221 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 234 insertions(+), 3 deletions(-)
 create mode 100644 include/traceeval-test.h

diff --git a/include/traceeval-test.h b/include/traceeval-test.h
new file mode 100644
index 0000000..bb8092a
--- /dev/null
+++ b/include/traceeval-test.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * libtraceeval interface for unit testing.
+ *
+ * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
+ * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
+ */
+
+#ifndef __LIBTRACEEVAL_TEST_H__
+#define __LIBTRACEEVAL_TEST_H__
+
+#include <traceeval-hist.h>
+
+int traceeval_compare(struct traceeval *orig, struct traceeval *copy);
+
+#endif /* __LIBTRACEEVAL_TEST_H__ */
diff --git a/src/histograms.c b/src/histograms.c
index 95243b0..8094678 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -11,6 +11,20 @@
 #include <stdio.h>
 
 #include <traceeval-hist.h>
+#include <traceeval-test.h>
+
+/*
+ * Compare two integers of variable length.
+ *
+ * Return 0 if @a and @b are the same, 1 if @a is greater than @b, and -1
+ * if @b is greater than @a.
+ */
+#define compare_numbers_return(a, b)	\
+do {					\
+	if ((a) < (b))			\
+		return -1;		\
+	return (a) != (b);		\
+} while (0)				\
 
 /* A key-value pair */
 struct entry {
@@ -158,12 +172,13 @@ fail_type_name:
  * The @keys and @vals passed in are copied for internal use.
  *
  * For any member of @keys or @vals that isn't of type TRACEEVAL_TYPE_NONE,
- * the name field must be a null-terminated string. For members of type
- * TRACEEVAL_TYPE_NONE, the name is ignored.
+ * the name field must be a null-terminated string. Members of type
+ * TRACEEVAL_TYPE_NONE are used to terminate the array, therefore their other
+ * fields are ignored.
  *
  * @vals can be NULL or start with its type field as TRACEEVAL_TYPE_NONE to
  * define the values of the histogram to be empty.
- * @keys must be populated with at least one element that is not
+ * @keys must be populated with at least one element that is not of type
  * TRACEEVAL_TYPE_NONE.
  *
  * Returns the descriptor on success, or NULL on error.
@@ -305,3 +320,203 @@ void traceeval_release(struct traceeval *teval)
 	teval->val_types = NULL;
 	free(teval);
 }
+
+/*
+ * Compare traceeval_type instances for equality.
+ *
+ * Return 0 if @orig and @copy are the same, 1 otherwise.
+ */
+static int compare_traceeval_type(struct traceeval_type *orig,
+		struct traceeval_type *copy, size_t orig_size, size_t copy_size)
+{
+	size_t i;
+
+	/* same memory/NULL */
+	if (orig == copy)
+		return 0;
+	if (!!orig != !!copy)
+		return 1;
+
+	if (orig_size != copy_size)
+		return 1;
+
+	for (i = 0; i < orig_size; i++) {
+		if (orig[i].type != copy[i].type)
+			return 1;
+		if (orig[i].flags != copy[i].flags)
+			return 1;
+		if (orig[i].id != copy[i].id)
+			return 1;
+		if (orig[i].dyn_release != copy[i].dyn_release)
+			return 1;
+		if (orig[i].dyn_cmp != copy[i].dyn_cmp)
+			return 1;
+
+		// make sure both names are same type
+		if (!!orig[i].name != !!copy[i].name)
+			return 1;
+		if (!orig[i].name)
+			continue;
+		if (strcmp(orig[i].name, copy[i].name) != 0)
+			return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Compare traceeval_data instances.
+ *
+ * Return 0 if @orig and @copy are the same, 1 if @orig is greater than @copy,
+ * -1 for the other way around, and -2 on error.
+ */
+static int compare_traceeval_data(union traceeval_data *orig,
+		const union traceeval_data *copy, struct traceeval_type *type)
+{
+	int i;
+
+	if (orig == copy)
+		return 0;
+
+	if (!orig)
+		return -1;
+
+	if (!copy)
+		return 1;
+
+	switch (type->type) {
+	case TRACEEVAL_TYPE_STRING:
+		i = strcmp(orig->string, copy->string);
+		compare_numbers_return(i, 0);
+
+	case TRACEEVAL_TYPE_NUMBER:
+		compare_numbers_return(orig->number, copy->number);
+
+	case TRACEEVAL_TYPE_NUMBER_64:
+		compare_numbers_return(orig->number_64, copy->number_64);
+
+	case TRACEEVAL_TYPE_NUMBER_32:
+		compare_numbers_return(orig->number_32, copy->number_32);
+
+	case TRACEEVAL_TYPE_NUMBER_16:
+		compare_numbers_return(orig->number_16, copy->number_16);
+
+	case TRACEEVAL_TYPE_NUMBER_8:
+		compare_numbers_return(orig->number_8, copy->number_8);
+
+	case TRACEEVAL_TYPE_DYNAMIC:
+		if (type->dyn_cmp)
+			return type->dyn_cmp(orig->dyn_data, copy->dyn_data, type);
+		return 0;
+
+	default:
+		print_err("%d is an invalid enum traceeval_data_type member",
+				type->type);
+		return -2;
+	}
+}
+
+/*
+ * Compare arrays of union traceeval_data's with respect to @def.
+ *
+ * Return 0 if @orig and @copy are the same, 1 if not, and -1 on error.
+ */
+static int compare_traceeval_data_set(union traceeval_data *orig,
+		const union traceeval_data *copy, struct traceeval_type *defs,
+		size_t size)
+{
+	int check;
+	size_t i;
+
+	/* compare data arrays */
+	for (i = 0; i < size; i++) {
+		if ((check = compare_traceeval_data(&orig[i], &copy[i], &defs[i])))
+			goto fail_c_set;
+	}
+
+	return 0;
+
+fail_c_set:
+	return check == -2 ? -1 : 1;
+}
+
+/*
+ * Return 0 if @orig and @copy are the same, 1 if not, and -1 on error.
+ */
+static int compare_entries(struct entry *orig, struct entry *copy,
+		struct traceeval *teval)
+{
+	int check;
+
+	/* compare keys */
+	check = compare_traceeval_data_set(orig->keys, copy->keys,
+			teval->key_types, teval->nr_key_types);
+	if (check)
+		return check;
+
+	/* compare values */
+	check = compare_traceeval_data_set(orig->vals, copy->vals,
+			teval->val_types, teval->nr_val_types);
+	return check;
+}
+
+/*
+ * Compares the hist fields of @orig and @copy for equality.
+ *
+ * Assumes all other aspects of @orig and @copy are the same.
+ *
+ * Return 0 if struct hist_table of @orig and @copy are the same, 1 if not,
+ * and -1 on error.
+ */
+static int compare_hist(struct traceeval *orig, struct traceeval *copy)
+{
+	struct hist_table *o_hist;
+	struct hist_table *c_hist;
+	int c;
+
+	o_hist = orig->hist;
+	c_hist = copy->hist;
+
+	if (o_hist->nr_entries != c_hist->nr_entries)
+		return 1;
+
+	for (size_t i = 0; i < o_hist->nr_entries; i++) {
+		if ((c = compare_entries(&o_hist->map[i], &c_hist->map[i], orig)))
+			return c;
+	}
+
+	return 0;
+}
+
+/*
+ * traceeval_compare - Check equality between two traceeval instances
+ * @orig: The first traceeval instance
+ * @copy: The second traceeval instance
+ *
+ * This compares the values of the key definitions, value definitions, and
+ * inserted data between @orig and @copy in order. It does not compare
+ * by memory address, except for struct traceeval_type's dyn_release() and
+ * dyn_cmp() fields.
+ *
+ * Returns 0 if @orig and @copy are the same, 1 if not, and -1 on error.
+ */
+ int traceeval_compare(struct traceeval *orig, struct traceeval *copy)
+{
+	int keys;
+	int vals;
+	int hists;
+
+	if (!orig || !copy)
+		return -1;
+
+	keys = compare_traceeval_type(orig->key_types, copy->key_types,
+			orig->nr_key_types, copy->nr_key_types);
+	vals = compare_traceeval_type(orig->val_types, copy->val_types,
+			orig->nr_val_types, copy->nr_val_types);
+	hists = compare_hist(orig, copy);
+
+	if (hists == -1)
+		return -1;
+
+	return keys || vals || hists;
+}
-- 
2.41.0

