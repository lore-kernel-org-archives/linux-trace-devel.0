Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C0AC001B0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 17:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbjHIRxw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 13:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjHIRxw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 13:53:52 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A6E10F6
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 10:53:51 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id 6a1803df08f44-63fba828747so566326d6.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Aug 2023 10:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691603630; x=1692208430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7E+Hjbc3wWdeXPLd5XqEKGpICnBXALlADWs7V9geozA=;
        b=o3dCzH8We6Z02+aEArYG6yRszbWvUVvybDr+EFrraYeZuiF/dDsEIHVrFcEqme8HwT
         S/SC+81G52KrUGl2TDvWJX1e3N+ZRkSHUauy13aCwXy8ZI2o+FGO+6jwGeHxLVH+6yCy
         u2rk9RjtHE5a0O1hZ7OBaXZwU0UMupqbPedmNiNOFW3ttODDCZJv50sNIO0oXBae8cJh
         4pfjU5cUQPa60x+Yj9x6WRKAe2ySHWkcnQc/+d4tTDXKxa4n3vIIFTkwrIV6QkXn4eTS
         gypZDhrNu61zF3YPmtu/5xRDPTomriBEJ3KMvK08E3jLKeTiwcC2LXkRRrqg0BYLyaEd
         8cHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691603630; x=1692208430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7E+Hjbc3wWdeXPLd5XqEKGpICnBXALlADWs7V9geozA=;
        b=Y1Bp4814a6UHVbzP8NAy/9RkIDFk41Uk7VAe2Bhi8q9UnlOzHcnXfEc9/OXCxF+vZK
         pck2Gsr5Cq6R2rmosuh1Jy3nCenx25oqSycUizGLx2yYMPSfjWsa/hNwi/tP2LUOKbNA
         31ndKytWKu2ox4Cjpoa6WfovZa/9n0xfIhCJ7A/WxpLVvQoD1iEeSNP3nzDl59AYKPL4
         JwWZnjJax4iuMBHVNUtOzw/87qemPZyPK3p2vKyWMuP4bJazbbeueAIWIOdnzF5kjIqU
         cvBdOrQLZf+fKwOoniFVIFWfUdMoMrv4q1j7iI4aamrhBkjX02isKTpoHHvfKtVSXCwS
         yjHw==
X-Gm-Message-State: AOJu0YzzJZOUH70qnLJ2BCAPLXNu+Mook8+ECMecp9Wu2IWDufPwcuTP
        xXvn5nFnRQBJuiYivAOhF38BPc+2AhQ=
X-Google-Smtp-Source: AGHT+IG85/o3BnIinb2N5lJunE0fMhyLxJ+hrz/wfCll3H9qoCii9CXG3NiA2RZsdQbvDVDt9tF0qw==
X-Received: by 2002:a05:6214:517:b0:63d:639a:37d4 with SMTP id px23-20020a056214051700b0063d639a37d4mr3129630qvb.45.1691603629840;
        Wed, 09 Aug 2023 10:53:49 -0700 (PDT)
Received: from 3xKetch.hsd1.ma.comcast.net ([2601:180:8300:500::2409])
        by smtp.gmail.com with ESMTPSA id x4-20020a0c8e84000000b00623839cba8csm4633646qvb.44.2023.08.09.10.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:53:49 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v4 3/5] histograms: Add traceeval compare
Date:   Wed,  9 Aug 2023 13:53:36 -0400
Message-ID: <20230809175340.3066-4-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809175340.3066-1-stevie.6strings@gmail.com>
References: <20230809175340.3066-1-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>

traceeval_compare() compares two struct traceeval instances for
equality. This suite of comparitors was made for testing purposes.

Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
---
 include/traceeval-test.h |  16 +++
 src/histograms.c         | 214 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 230 insertions(+)
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
index 568c631..ed631b0 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -12,6 +12,21 @@
 
 #include <traceeval-hist.h>
 
+#include "traceeval-test.h"
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
+
 /* A key-value pair */
 struct entry {
 	union traceeval_data	*keys;
@@ -48,6 +63,205 @@ static void print_err(const char *fmt, ...)
 	fprintf(stderr, "\n");
 }
 
+/*
+ * Compare traceeval_type instances for equality.
+ *
+ * Return 1 if @orig and @copy are the same, 0 otherwise.
+ */
+static int compare_traceeval_type(struct traceeval_type *orig,
+				  struct traceeval_type *copy,
+				  size_t orig_size, size_t copy_size)
+{
+	size_t i;
+
+	/* same memory/NULL */
+	if (orig == copy)
+		return 1;
+	if (!!orig != !!copy)
+		return 0;
+
+	if (orig_size != copy_size)
+		return 0;
+
+	for (i = 0; i < orig_size; i++) {
+		if (orig[i].type != copy[i].type)
+			return 0;
+		if (orig[i].flags != copy[i].flags)
+			return 0;
+		if (orig[i].id != copy[i].id)
+			return 0;
+		if (orig[i].dyn_release != copy[i].dyn_release)
+			return 0;
+		if (orig[i].dyn_cmp != copy[i].dyn_cmp)
+			return 0;
+
+		// make sure both names are same type
+		if (!!orig[i].name != !!copy[i].name)
+			return 0;
+		if (!orig[i].name)
+			continue;
+		if (strcmp(orig[i].name, copy[i].name) != 0)
+			return 0;
+	}
+
+	return 1;
+}
+
+/*
+ * Compare traceeval_data instances.
+ *
+ * Return 0 if @orig and @copy are the same, 1 if @orig is greater than @copy,
+ * -1 for the other way around, and -2 on error.
+ */
+static int compare_traceeval_data(union traceeval_data *orig,
+				  const union traceeval_data *copy,
+				  struct traceeval_type *type)
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
+ * Return 1 if @orig and @copy are the same, 0 if not, and -1 on error.
+ */
+static int compare_traceeval_data_set(union traceeval_data *orig,
+				      const union traceeval_data *copy,
+				      struct traceeval_type *defs, size_t size)
+{
+	int check;
+	size_t i;
+
+	/* compare data arrays */
+	for (i = 0; i < size; i++) {
+		if ((check = compare_traceeval_data(orig + i, copy + i, defs + i)))
+			return check == -2 ? -1 : 0;
+	}
+
+	return 1;
+}
+
+/*
+ * Return 1 if @orig and @copy are the same, 0 if not, and -1 on error.
+ */
+static int compare_entries(struct entry *orig, struct entry *copy,
+			   struct traceeval *teval)
+{
+	int check;
+
+	/* compare keys */
+	check = compare_traceeval_data_set(orig->keys, copy->keys,
+			teval->key_types, teval->nr_key_types);
+	if (check < 1)
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
+ * Return 1 if struct hist_table of @orig and @copy are the same, 0 if not,
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
+		return 0;
+
+	for (size_t i = 0; i < o_hist->nr_entries; i++) {
+		if ((c = compare_entries(o_hist->map + i, c_hist->map + i, orig)) < 1)
+			return c;
+	}
+
+	return 1;
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
+ * Returns 1 if @orig and @copy are the same, 0 if not, and -1 on error.
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
+	return keys && vals && hists;
+}
+
 /*
  * type_release - free a struct traceeval_type array
  * @defs: The array to release
-- 
2.41.0

