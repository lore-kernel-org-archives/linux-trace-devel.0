Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EED7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 06:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238209AbiBWGNe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 01:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbiBWGNa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 01:13:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0774760CD0
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 22:13:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 954AF61326
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 06:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA4BC340E7
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 06:13:01 +0000 (UTC)
Date:   Wed, 23 Feb 2022 01:13:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix various memory issues
Message-ID: <20220223011300.377389b9@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Running "make test_mem" which calls valgrind on the unit tests, uncovered
various issues with allocations, initialization and freeing.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-dynevents.c |  3 ++-
 src/tracefs-hist.c      |  2 ++
 src/tracefs-sqlhist.c   |  2 +-
 src/tracefs-utils.c     | 10 ++++------
 utest/tracefs-utest.c   |  2 ++
 5 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index ddebb6bb68b0..61804b9d9d5e 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -120,7 +120,7 @@ static int dyn_generic_parse(struct dyn_events_desc *desc, const char *group,
 	struct tracefs_dynevent *dyn;
 	char *word;
 	char *format = NULL;
-	char *address;
+	char *address = NULL;
 	char *system;
 	char *prefix;
 	char *event;
@@ -582,6 +582,7 @@ tracefs_dynevent_get_all(unsigned int types, const char *system)
 			all += count;
 			/* Add a NULL pointer at the end */
 			all_events[all] = NULL;
+			free(events);
 		}
 	}
 
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index aec61ad52e72..96eb63338d02 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -745,12 +745,14 @@ void tracefs_synth_free(struct tracefs_synth *synth)
 	free(synth->end_hist);
 	tracefs_list_free(synth->synthetic_fields);
 	tracefs_list_free(synth->synthetic_args);
+	tracefs_list_free(synth->start_selection);
 	tracefs_list_free(synth->start_keys);
 	tracefs_list_free(synth->end_keys);
 	tracefs_list_free(synth->start_vars);
 	tracefs_list_free(synth->end_vars);
 	free(synth->start_filter);
 	free(synth->end_filter);
+	free(synth->start_type);
 
 	tep_unref(synth->tep);
 
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 016f3eb23725..63f8ddf71103 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -1538,7 +1538,7 @@ static void free_sql_table(struct sql_table *table)
 		return;
 
 	while ((expr = table->exprs)) {
-		table->exprs = expr->next;
+		table->exprs = expr->free_list;
 		free(expr);
 	}
 
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index a502c2dec736..35f25ef6bddf 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -183,18 +183,16 @@ const char *tracefs_tracing_dir(void)
  */
 char *tracefs_get_tracing_file(const char *name)
 {
-	static const char *tracing;
+	const char *tracing;
 	char *file;
 	int ret;
 
 	if (!name)
 		return NULL;
 
-	if (!tracing) {
-		tracing = trace_find_tracing_dir();
-		if (!tracing)
-			return NULL;
-	}
+	tracing = tracefs_tracing_dir();
+	if (!tracing)
+		return NULL;
 
 	ret = asprintf(&file, "%s/%s", tracing, name);
 	if (ret < 0)
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index e8d5c6981ef2..09032438f425 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -430,6 +430,8 @@ static void test_synth_compare(struct test_synth *synth, struct tracefs_dynevent
 		if (synth[i].match_name) {
 			CU_TEST(strstr(format, synth[i].match_name) != NULL);
 		}
+		free(event);
+		free(format);
 	}
 	CU_TEST(devents[i] == NULL);
 }
-- 
2.34.1

