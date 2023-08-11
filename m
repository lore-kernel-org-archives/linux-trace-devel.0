Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFBCDC04E69
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Aug 2023 05:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbjHKFju (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjHKFjq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Aug 2023 01:39:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1790D2D52
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 22:39:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 707C864400
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Aug 2023 05:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E4AC433D9;
        Fri, 11 Aug 2023 05:39:44 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qUKsB-005uPv-2h;
        Fri, 11 Aug 2023 01:39:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 06/17] libtraceeval histogram: Remove comparing of traceeval and types
Date:   Fri, 11 Aug 2023 01:39:29 -0400
Message-Id: <20230811053940.1408424-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811053940.1408424-1-rostedt@goodmis.org>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The compare functions for traceeval and types were created for testing. But
because the tests have not yet been pulled in, remove these functions as
they are currently unused and cause an unnecessary burden of making sure
they are updated when other code they use is updated.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile                 |   1 -
 include/traceeval-test.h |  16 -----
 src/histograms.c         | 127 ---------------------------------------
 3 files changed, 144 deletions(-)
 delete mode 100644 include/traceeval-test.h

diff --git a/Makefile b/Makefile
index 62ca9285d7a0..d8c57ef4e356 100644
--- a/Makefile
+++ b/Makefile
@@ -172,7 +172,6 @@ libs: $(LIBRARY_A) $(LIBRARY_SO)
 
 VALGRIND = $(shell which valgrind)
 UTEST_DIR = utest
-UTEST_BINARY = eval-utest
 
 test: force $(LIBRARY_STATIC)
 ifneq ($(CUNIT_INSTALLED),1)
diff --git a/include/traceeval-test.h b/include/traceeval-test.h
deleted file mode 100644
index bb8092ac2e50..000000000000
--- a/include/traceeval-test.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* SPDX-License-Identifier: MIT */
-/*
- * libtraceeval interface for unit testing.
- *
- * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
- * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
- */
-
-#ifndef __LIBTRACEEVAL_TEST_H__
-#define __LIBTRACEEVAL_TEST_H__
-
-#include <traceeval-hist.h>
-
-int traceeval_compare(struct traceeval *orig, struct traceeval *copy);
-
-#endif /* __LIBTRACEEVAL_TEST_H__ */
diff --git a/src/histograms.c b/src/histograms.c
index ece1395ac300..1ae1d793b6a2 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -12,8 +12,6 @@
 
 #include <traceeval-hist.h>
 
-#include "traceeval-test.h"
-
 /*
  * Compare two integers of variable length.
  *
@@ -63,50 +61,6 @@ static void print_err(const char *fmt, ...)
 	fprintf(stderr, "\n");
 }
 
-/*
- * Compare traceeval_type instances for equality.
- *
- * Return 1 if @orig and @copy are the same, 0 otherwise.
- */
-static int compare_traceeval_type(struct traceeval_type *orig,
-				  struct traceeval_type *copy,
-				  size_t orig_size, size_t copy_size)
-{
-	size_t i;
-
-	/* same memory/NULL */
-	if (orig == copy)
-		return 1;
-	if (!!orig != !!copy)
-		return 0;
-
-	if (orig_size != copy_size)
-		return 0;
-
-	for (i = 0; i < orig_size; i++) {
-		if (orig[i].type != copy[i].type)
-			return 0;
-		if (orig[i].flags != copy[i].flags)
-			return 0;
-		if (orig[i].id != copy[i].id)
-			return 0;
-		if (orig[i].release != copy[i].release)
-			return 0;
-		if (orig[i].cmp != copy[i].cmp)
-			return 0;
-
-		// make sure both names are same type
-		if (!!orig[i].name != !!copy[i].name)
-			return 0;
-		if (!orig[i].name)
-			continue;
-		if (strcmp(orig[i].name, copy[i].name) != 0)
-			return 0;
-	}
-
-	return 1;
-}
-
 /*
  * Compare traceeval_data instances.
  *
@@ -185,87 +139,6 @@ static int compare_traceeval_data_set(struct traceeval *teval,
 	return 1;
 }
 
-/*
- * Return 1 if @orig and @copy are the same, 0 if not, and -1 on error.
- */
-static int compare_entries(struct entry *orig, struct entry *copy,
-			   struct traceeval *teval)
-{
-	int check;
-
-	/* compare keys */
-	check = compare_traceeval_data_set(teval, orig->keys, copy->keys,
-			teval->key_types, teval->nr_key_types);
-	if (check < 1)
-		return check;
-
-	/* compare values */
-	check = compare_traceeval_data_set(teval, orig->vals, copy->vals,
-			teval->val_types, teval->nr_val_types);
-	return check;
-}
-
-/*
- * Compares the hist fields of @orig and @copy for equality.
- *
- * Assumes all other aspects of @orig and @copy are the same.
- *
- * Return 1 if struct hist_table of @orig and @copy are the same, 0 if not,
- * and -1 on error.
- */
-static int compare_hist(struct traceeval *orig, struct traceeval *copy)
-{
-	struct hist_table *o_hist;
-	struct hist_table *c_hist;
-	int c;
-
-	o_hist = orig->hist;
-	c_hist = copy->hist;
-
-	if (o_hist->nr_entries != c_hist->nr_entries)
-		return 0;
-
-	for (size_t i = 0; i < o_hist->nr_entries; i++) {
-		if ((c = compare_entries(o_hist->map + i, c_hist->map + i, orig)) < 1)
-			return c;
-	}
-
-	return 1;
-}
-
-/*
- * traceeval_compare - Check equality between two traceeval instances
- * @orig: The first traceeval instance
- * @copy: The second traceeval instance
- *
- * This compares the values of the key definitions, value definitions, and
- * inserted data between @orig and @copy in order. It does not compare
- * by memory address, except for struct traceeval_type's release() and
- * cmp() fields.
- *
- * Returns 1 if @orig and @copy are the same, 0 if not, and -1 on error.
- */
- int traceeval_compare(struct traceeval *orig, struct traceeval *copy)
-{
-	int keys;
-	int vals;
-	int hists;
-
-	if (!orig || !copy)
-		return -1;
-
-	keys = compare_traceeval_type(orig->key_types, copy->key_types,
-			orig->nr_key_types, copy->nr_key_types);
-	vals = compare_traceeval_type(orig->val_types, copy->val_types,
-			orig->nr_val_types, copy->nr_val_types);
-	hists = compare_hist(orig, copy);
-
-	if (hists == -1)
-		return -1;
-
-	return keys && vals && hists;
-}
-
 /*
  * type_release - free a struct traceeval_type array
  * @defs: The array to release
-- 
2.40.1

