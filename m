Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839C0C2FC1A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 01:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347547AbjHQBdN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 21:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347555AbjHQBdM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 21:33:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CD52D40
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 18:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FB3364AFF
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 01:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE26C433B6;
        Thu, 17 Aug 2023 01:33:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWRst-000N4Y-2X;
        Wed, 16 Aug 2023 21:33:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 15/18] libtraceeval histogram: Add traceeval_iterator_sort_custom()
Date:   Wed, 16 Aug 2023 21:33:07 -0400
Message-Id: <20230817013310.88582-16-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817013310.88582-1-rostedt@goodmis.org>
References: <20230817013310.88582-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add an iterator where the application can supply the sort algorithm where
it gets the teval descriptor along with the keys and values of both of the
entries to compare against. Also, allow it to submit its own data to the
compare function:

int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
				   traceeval_cmp_fn sort_fn, void *data);

with

typedef int (*traceeval_cmp_fn)(struct traceeval *teval,
				const union traceeval_data *Akeys,
				const union traceeval_data *Avals,
				const union traceeval_data *Bkeys,
				const union traceeval_data *Bvals,
				void *data);

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h |  9 +++++++++
 src/histograms.c         | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 8992ace81cdf..fc1e288a43c6 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -86,6 +86,13 @@ typedef int (*traceeval_data_copy_fn)(const struct traceeval_type *type,
 				      union traceeval_data *copy,
 				      const union traceeval_data *origin);
 
+typedef int (*traceeval_cmp_fn)(struct traceeval *teval,
+				const union traceeval_data *Akeys,
+				const union traceeval_data *Avals,
+				const union traceeval_data *Bkeys,
+				const union traceeval_data *Bvals,
+				void *data);
+
 /*
  * struct traceeval_type - Describes the type of a traceevent_data instance
  * @type: The enum type that describes the traceeval_data
@@ -172,6 +179,8 @@ struct traceeval_iterator *traceeval_iterator_get(struct traceeval *teval);
 void traceeval_iterator_put(struct traceeval_iterator *iter);
 int traceeval_iterator_sort(struct traceeval_iterator *iter, const char *sort_field,
 			    int level, bool ascending);
+int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
+				   traceeval_cmp_fn sort_fn, void *data);
 int traceeval_iterator_next(struct traceeval_iterator *iter,
 			    const union traceeval_data **keys);
 
diff --git a/src/histograms.c b/src/histograms.c
index 3050bad4190e..c0f2248cce6f 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -1160,6 +1160,41 @@ static int sort_iter(struct traceeval_iterator *iter)
 	return 0;
 }
 
+struct iter_custom_data {
+	struct traceeval_iterator *iter;
+	traceeval_cmp_fn sort_fn;
+	void *data;
+};
+
+static int iter_custom_cmp(const void *A, const void *B, void *data)
+{
+	struct iter_custom_data *cust_data = data;
+	struct traceeval_iterator *iter = cust_data->iter;
+	struct traceeval *teval = iter->teval;
+	const struct entry *a = *((const struct entry **)A);
+	const struct entry *b = *((const struct entry **)B);
+
+	return cust_data->sort_fn(teval, a->keys, a->vals, b->keys, b->vals,
+				  cust_data->data);
+}
+
+int traceeval_iterator_sort_custom(struct traceeval_iterator *iter,
+				   traceeval_cmp_fn sort_fn, void *data)
+{
+	struct iter_custom_data cust_data = {
+		.iter = iter,
+		.sort_fn = sort_fn,
+		.data = data
+	};
+
+	qsort_r(iter->entries, iter->nr_entries, sizeof(*iter->entries),
+		iter_custom_cmp, &cust_data);
+
+	iter->needs_sort = false;
+	iter->next = 0;
+	return 0;
+}
+
 /**
  * traceeval_iterator_next - retrieve the next entry from an iterator
  * @iter: The iterator to retrieve the next entry from
-- 
2.40.1

