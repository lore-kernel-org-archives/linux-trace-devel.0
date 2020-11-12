Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D5B2C2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D940A22248
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EZS8+Qfo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgKLOYg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgKLOYg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 09:24:36 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA07C0613D4
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:35 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id k2so6213863wrx.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wC87hoRooleghwjWGqH5v8Ih5NmseOrhNBsc1VnJBSA=;
        b=EZS8+QfoGofEJnosg2jOtepfkkfVVHzhRqs9/aApKi02MpoKZiu6C/afJ8JSIbgZlb
         cXGagxIurouUvRUl42EQ6NN7b5TMJ5poyWwpVv23FTFWFR65dUJIsqszFGGyKn1wbOsj
         4M2+DKUPWHzgyiCK9hCw+cf6H6OArW/tga2b4YjS9356s6HbAKrvuzIeCbRhGDWQH/Cy
         TZ+Oo2z8xac7/n3+xbUrE0M/HnDFw5ou/1LHtY5iIYNG+KQjoaC09k9MP3g3rGcQSwI4
         26iTbEZuNF5Nu4Fo1luV06DNn8QNjqhcHBBCAgdaZ7UVl/f1OpVIbbeB7twXB5MDjZaP
         jdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wC87hoRooleghwjWGqH5v8Ih5NmseOrhNBsc1VnJBSA=;
        b=KecZ3Kdy9QsuOwxyqrKx+4O2xfRDT4yiZyqbkgal5TA24n6D62m55LcJ5AL8SU5R/3
         NSvDxQEOmx+Nz0W76OgpM4b7Bg2+vqidj8e6Tha/+KVYOnz8dndSBNzwgHpZ0aPXmmvU
         S3GVCLZ8xKfGMtFhSDZr3WEcqBhFgiNL2++NBOwIWCe5o1GE4JRDXRwQlb/CIEevEtzz
         lgutdS0y2x515gZwB5P2+aCyv47Wb2v0hLcmdNsBDwtDMBLqL7e1Slnd5+McEUb67Vyc
         OO1PhYb2sdV0g4p2YfvQzmvbm3gKlQ1zSyj2d1p15CbJPHBjbaTBqYhSpCBK3K4EnJNd
         rdpQ==
X-Gm-Message-State: AOAM533h0f68C34wSk9mgSXubTrlVvRcOHRf+HLw1BFEtri7mKrwsD7c
        mrxhv658NZJQI2+aVskZKV0=
X-Google-Smtp-Source: ABdhPJyge8gRabnFk4ylTFc46lUahQvkZrXlxm1OyL+EElFo15ygmPTakmZ0HLT+sihGFHw2h31e0Q==
X-Received: by 2002:a5d:69d1:: with SMTP id s17mr25862531wrw.104.1605191074269;
        Thu, 12 Nov 2020 06:24:34 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id h15sm6950685wrw.15.2020.11.12.06.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 06:24:33 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 15/20] kernel-shark: Integrate the stream definitions with data model
Date:   Thu, 12 Nov 2020 16:23:53 +0200
Message-Id: <20201112142358.36821-16-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112142358.36821-1-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The visualization model is adapted in order to be able to distinguish
the entries belonging to different Data streams.
We re-enable the visualization model example as well.

Signen-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/CMakeLists.txt |   8 ++--
 examples/datahisto.c    |  38 +++++++--------
 src/CMakeLists.txt      |   2 +-
 src/libkshark-model.c   | 102 ++++++++++++++++++++++++----------------
 src/libkshark-model.h   |  34 +++++++-------
 5 files changed, 102 insertions(+), 82 deletions(-)

diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
index 831eee24..2f6acea2 100644
--- a/examples/CMakeLists.txt
+++ b/examples/CMakeLists.txt
@@ -12,10 +12,10 @@ message(STATUS "multibufferload")
 add_executable(mbload          multibufferload.c)
 target_link_libraries(mbload   kshark)
 
-# message(STATUS "datahisto")
-# add_executable(dhisto          datahisto.c)
-# target_link_libraries(dhisto   kshark)
-#
+message(STATUS "datahisto")
+add_executable(dhisto          datahisto.c)
+target_link_libraries(dhisto   kshark)
+
 # message(STATUS "confogio")
 # add_executable(confio          configio.c)
 # target_link_libraries(confio   kshark)
diff --git a/examples/datahisto.c b/examples/datahisto.c
index b177b088..568072d8 100644
--- a/examples/datahisto.c
+++ b/examples/datahisto.c
@@ -7,6 +7,7 @@
 // C
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 
 // KernelShark
 #include "libkshark.h"
@@ -16,7 +17,7 @@
 
 const char *default_file = "trace.dat";
 
-void dump_bin(struct kshark_trace_histo *histo, int bin,
+void dump_bin(struct kshark_trace_histo *histo, int bin, int sd,
 	      const char *type, int val)
 {
 	const struct kshark_entry *e_front, *e_back;
@@ -26,22 +27,22 @@ void dump_bin(struct kshark_trace_histo *histo, int bin,
 	printf("bin %i {\n", bin);
 	if (strcmp(type, "cpu") == 0) {
 		e_front = ksmodel_get_entry_front(histo, bin, true,
-						  kshark_match_cpu, val,
+						  kshark_match_cpu, sd, &val,
 						  NULL,
 						  &i_front);
 
 		e_back = ksmodel_get_entry_back(histo, bin, true,
-						kshark_match_cpu, val,
+						kshark_match_cpu, sd, &val,
 						NULL,
 						&i_back);
 	} else if (strcmp(type, "task") == 0) {
 		e_front = ksmodel_get_entry_front(histo, bin, true,
-						  kshark_match_pid, val,
+						  kshark_match_pid, sd, &val,
 						  NULL,
 						  &i_front);
 
 		e_back = ksmodel_get_entry_back(histo, bin, true,
-						kshark_match_pid, val,
+						kshark_match_pid, sd, &val,
 						NULL,
 						&i_back);
 	} else {
@@ -67,12 +68,12 @@ void dump_bin(struct kshark_trace_histo *histo, int bin,
 	puts("}\n");
 }
 
-void dump_histo(struct kshark_trace_histo *histo, const char *type, int val)
+void dump_histo(struct kshark_trace_histo *histo, int sd, const char *type, int val)
 {
 	size_t bin;
 
 	for (bin = 0; bin < histo->n_bins; ++bin)
-		dump_bin(histo, bin, type, val);
+		dump_bin(histo, bin, sd, type, val);
 }
 
 int main(int argc, char **argv)
@@ -81,8 +82,7 @@ int main(int argc, char **argv)
 	struct kshark_entry **data = NULL;
 	struct kshark_trace_histo histo;
 	ssize_t i, n_rows, n_tasks;
-	bool status;
-	int *pids;
+	int sd, *pids;
 
 	/* Create a new kshark session. */
 	kshark_ctx = NULL;
@@ -91,24 +91,24 @@ int main(int argc, char **argv)
 
 	/* Open a trace data file produced by trace-cmd. */
 	if (argc > 1)
-		status = kshark_open(kshark_ctx, argv[1]);
+		sd = kshark_open(kshark_ctx, argv[1]);
 	else
-		status = kshark_open(kshark_ctx, default_file);
+		sd = kshark_open(kshark_ctx, default_file);
 
-	if (!status) {
+	if (sd < 0) {
 		kshark_free(kshark_ctx);
 		return 1;
 	}
 
 	/* Load the content of the file into an array of entries. */
-	n_rows = kshark_load_data_entries(kshark_ctx, &data);
+	n_rows = kshark_load_entries(kshark_ctx, sd, &data);
 	if (n_rows < 1) {
 		kshark_free(kshark_ctx);
 		return 1;
 	}
 
 	/* Get a list of all tasks. */
-	n_tasks = kshark_get_task_pids(kshark_ctx, &pids);
+	n_tasks = kshark_get_task_pids(kshark_ctx, sd, &pids);
 
 	/* Initialize the Visualization Model. */
 	ksmodel_init(&histo);
@@ -119,7 +119,7 @@ int main(int argc, char **argv)
 	ksmodel_fill(&histo, data, n_rows);
 
 	/* Dump the raw bins. */
-	dump_histo(&histo, "", 0);
+	dump_histo(&histo, sd, "", 0);
 
 	puts("\n...\n\n");
 
@@ -127,13 +127,13 @@ int main(int argc, char **argv)
 	 * Change the state of the model. Do 50% Zoom-In and dump only CPU 0.
 	 */
 	ksmodel_zoom_in(&histo, .50, -1);
-	dump_histo(&histo, "cpu", 0);
+	dump_histo(&histo, sd, "cpu", 0);
 
 	puts("\n...\n\n");
 
 	/* Shift forward by two bins and this time dump only CPU 1. */
 	ksmodel_shift_forward(&histo, 2);
-	dump_histo(&histo, "cpu", 1);
+	dump_histo(&histo, sd, "cpu", 1);
 
 	puts("\n...\n\n");
 
@@ -142,7 +142,7 @@ int main(int argc, char **argv)
 	 * Task.
 	 */
 	ksmodel_zoom_out(&histo, .10, N_BINS - 1);
-	dump_histo(&histo, "task", pids[n_tasks - 1]);
+	dump_histo(&histo, sd, "task", pids[n_tasks - 1]);
 
 	/* Reset (clear) the model. */
 	ksmodel_clear(&histo);
@@ -154,7 +154,7 @@ int main(int argc, char **argv)
 	free(data);
 
 	/* Close the file. */
-	kshark_close(kshark_ctx);
+	kshark_close(kshark_ctx, sd);
 
 	/* Close the session. */
 	kshark_free(kshark_ctx);
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 2bdab1a5..cbcc5701 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -3,7 +3,7 @@ message("\n src ...")
 message(STATUS "libkshark")
 add_library(kshark SHARED libkshark.c
                           libkshark-hash.c
-#                           libkshark-model.c
+                          libkshark-model.c
                           libkshark-plugin.c
                           libkshark-tepdata.c
 #                           libkshark-configio.c
diff --git a/src/libkshark-model.c b/src/libkshark-model.c
index babac2a2..97cff314 100644
--- a/src/libkshark-model.c
+++ b/src/libkshark-model.c
@@ -1,17 +1,19 @@
 // SPDX-License-Identifier: LGPL-2.1
 
 /*
- * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
- /**
-  *  @file    libkshark-model.c
-  *  @brief   Visualization model for FTRACE (trace-cmd) data.
-  */
+/**
+ *  @file    libkshark-model.c
+ *  @brief   Time series visualization model for tracing data.
+ */
 
 // C
 #include <stdlib.h>
 #include <assert.h>
+#include <string.h>
+#include <stdio.h>
 
 // KernelShark
 #include "libkshark-model.h"
@@ -782,7 +784,8 @@ static bool ksmodel_is_visible(struct kshark_entry *e)
 static struct kshark_entry_request *
 ksmodel_entry_front_request_alloc(struct kshark_trace_histo *histo,
 				  int bin, bool vis_only,
-				  matching_condition_func func, int val)
+				  matching_condition_func func,
+				  int sd, int *values)
 {
 	size_t first, n;
 
@@ -794,14 +797,15 @@ ksmodel_entry_front_request_alloc(struct kshark_trace_histo *histo,
 	first = ksmodel_first_index_at_bin(histo, bin);
 
 	return kshark_entry_request_alloc(first, n,
-					  func, val,
+					  func, sd, values,
 					  vis_only, KS_GRAPH_VIEW_FILTER_MASK);
 }
 
 static struct kshark_entry_request *
 ksmodel_entry_back_request_alloc(struct kshark_trace_histo *histo,
 				 int bin, bool vis_only,
-				 matching_condition_func func, int val)
+				 matching_condition_func func,
+				 int sd, int *values)
 {
 	size_t first, n;
 
@@ -813,7 +817,7 @@ ksmodel_entry_back_request_alloc(struct kshark_trace_histo *histo,
 	first = ksmodel_last_index_at_bin(histo, bin);
 
 	return kshark_entry_request_alloc(first, n,
-					  func, val,
+					  func, sd, values,
 					  vis_only, KS_GRAPH_VIEW_FILTER_MASK);
 }
 
@@ -822,12 +826,13 @@ ksmodel_entry_back_request_alloc(struct kshark_trace_histo *histo,
  *
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
+ * @param sd: Data stream identifier.
  * @param cpu: Cpu Id.
  *
  * @returns Index of the first entry from a given Cpu in this bin.
  */
 ssize_t ksmodel_first_index_at_cpu(struct kshark_trace_histo *histo,
-				   int bin, int cpu)
+				   int bin, int sd, int cpu)
 {
 	size_t i, n, first, not_found = KS_EMPTY_BIN;
 
@@ -838,7 +843,8 @@ ssize_t ksmodel_first_index_at_cpu(struct kshark_trace_histo *histo,
 	first = ksmodel_first_index_at_bin(histo, bin);
 
 	for (i = first; i < first + n; ++i) {
-		if (histo->data[i]->cpu == cpu) {
+		if (histo->data[i]->cpu == cpu &&
+		    histo->data[i]->stream_id == sd) {
 			if (ksmodel_is_visible(histo->data[i]))
 				return i;
 			else
@@ -854,12 +860,13 @@ ssize_t ksmodel_first_index_at_cpu(struct kshark_trace_histo *histo,
  *
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
+ * @param sd: Data stream identifier.
  * @param pid: Process Id of a task.
  *
  * @returns Index of the first entry from a given Task in this bin.
  */
 ssize_t ksmodel_first_index_at_pid(struct kshark_trace_histo *histo,
-				   int bin, int pid)
+				   int bin, int sd, int pid)
 {
 	size_t i, n, first, not_found = KS_EMPTY_BIN;
 
@@ -870,7 +877,8 @@ ssize_t ksmodel_first_index_at_pid(struct kshark_trace_histo *histo,
 	first = ksmodel_first_index_at_bin(histo, bin);
 
 	for (i = first; i < first + n; ++i) {
-		if (histo->data[i]->pid == pid) {
+		if (histo->data[i]->pid == pid &&
+		    histo->data[i]->stream_id == sd) {
 			if (ksmodel_is_visible(histo->data[i]))
 				return i;
 			else
@@ -890,8 +898,9 @@ ssize_t ksmodel_first_index_at_pid(struct kshark_trace_histo *histo,
  * @param bin: Bin id.
  * @param vis_only: If true, a visible entry is requested.
  * @param func: Matching condition function.
- * @param val: Matching condition value, used by the Matching condition
- *	       function.
+ * @param sd: Data stream identifier.
+ * @param values: Matching condition values, used by the Matching condition
+ *                function.
  * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
@@ -901,7 +910,7 @@ ssize_t ksmodel_first_index_at_pid(struct kshark_trace_histo *histo,
 const struct kshark_entry *
 ksmodel_get_entry_front(struct kshark_trace_histo *histo,
 			int bin, bool vis_only,
-			matching_condition_func func, int val,
+			matching_condition_func func, int sd, int *values,
 			struct kshark_entry_collection *col,
 			ssize_t *index)
 {
@@ -913,7 +922,7 @@ ksmodel_get_entry_front(struct kshark_trace_histo *histo,
 
 	/* Set the position at the beginning of the bin and go forward. */
 	req = ksmodel_entry_front_request_alloc(histo, bin, vis_only,
-							    func, val);
+						func, sd, values);
 	if (!req)
 		return NULL;
 
@@ -937,8 +946,9 @@ ksmodel_get_entry_front(struct kshark_trace_histo *histo,
  * @param bin: Bin id.
  * @param vis_only: If true, a visible entry is requested.
  * @param func: Matching condition function.
- * @param val: Matching condition value, used by the Matching condition
- *	       function.
+ * @param sd: Data stream identifier.
+ * @param values: Matching condition values, used by the Matching condition
+ *                function.
  * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
@@ -948,7 +958,7 @@ ksmodel_get_entry_front(struct kshark_trace_histo *histo,
 const struct kshark_entry *
 ksmodel_get_entry_back(struct kshark_trace_histo *histo,
 		       int bin, bool vis_only,
-		       matching_condition_func func, int val,
+		       matching_condition_func func, int sd, int *values,
 		       struct kshark_entry_collection *col,
 		       ssize_t *index)
 {
@@ -960,7 +970,7 @@ ksmodel_get_entry_back(struct kshark_trace_histo *histo,
 
 	/* Set the position at the end of the bin and go backwards. */
 	req = ksmodel_entry_back_request_alloc(histo, bin, vis_only,
-							   func, val);
+					       func, sd, values);
 	if (!req)
 		return NULL;
 
@@ -998,6 +1008,7 @@ static int ksmodel_get_entry_pid(const struct kshark_entry *entry)
  *
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
+ * @param sd: Data stream identifier.
  * @param cpu: CPU Id.
  * @param vis_only: If true, a visible entry is requested.
  * @param col: Optional input location for Data collection.
@@ -1008,7 +1019,7 @@ static int ksmodel_get_entry_pid(const struct kshark_entry *entry)
  *	    Identifier (KS_EMPTY_BIN or KS_FILTERED_BIN).
  */
 int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
-			  int bin, int cpu, bool vis_only,
+			  int bin, int sd, int cpu, bool vis_only,
 			  struct kshark_entry_collection *col,
 			  ssize_t *index)
 {
@@ -1018,7 +1029,7 @@ int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
 		return KS_EMPTY_BIN;
 
 	entry = ksmodel_get_entry_front(histo, bin, vis_only,
-					       kshark_match_cpu, cpu,
+					       kshark_match_cpu, sd, &cpu,
 					       col, index);
 
 	return ksmodel_get_entry_pid(entry);
@@ -1031,6 +1042,7 @@ int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
  *
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
+ * @param sd: Data stream identifier.
  * @param cpu: CPU Id.
  * @param vis_only: If true, a visible entry is requested.
  * @param col: Optional input location for Data collection.
@@ -1041,7 +1053,7 @@ int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
  *	    Identifier (KS_EMPTY_BIN or KS_FILTERED_BIN).
  */
 int ksmodel_get_pid_back(struct kshark_trace_histo *histo,
-			 int bin, int cpu, bool vis_only,
+			 int bin, int sd, int cpu, bool vis_only,
 			 struct kshark_entry_collection *col,
 			 ssize_t *index)
 {
@@ -1051,7 +1063,7 @@ int ksmodel_get_pid_back(struct kshark_trace_histo *histo,
 		return KS_EMPTY_BIN;
 
 	entry = ksmodel_get_entry_back(histo, bin, vis_only,
-					      kshark_match_cpu, cpu,
+					      kshark_match_cpu, sd, &cpu,
 					      col, index);
 
 	return ksmodel_get_entry_pid(entry);
@@ -1080,6 +1092,7 @@ static int ksmodel_get_entry_cpu(const struct kshark_entry *entry)
  *
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
+ * @param sd: Data stream identifier.
  * @param pid: Process Id.
  * @param vis_only: If true, a visible entry is requested.
  * @param col: Optional input location for Data collection.
@@ -1090,7 +1103,7 @@ static int ksmodel_get_entry_cpu(const struct kshark_entry *entry)
  *	    Identifier (KS_EMPTY_BIN or KS_FILTERED_BIN).
  */
 int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
-			  int bin, int pid, bool vis_only,
+			  int bin, int sd, int pid, bool vis_only,
 			  struct kshark_entry_collection *col,
 			  ssize_t *index)
 {
@@ -1100,7 +1113,7 @@ int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
 		return KS_EMPTY_BIN;
 
 	entry = ksmodel_get_entry_front(histo, bin, vis_only,
-					       kshark_match_pid, pid,
+					       kshark_match_pid, sd, &pid,
 					       col,
 					       index);
 	return ksmodel_get_entry_cpu(entry);
@@ -1113,6 +1126,7 @@ int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
  *
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
+ * @param sd: Data stream identifier.
  * @param pid: Process Id.
  * @param vis_only: If true, a visible entry is requested.
  * @param col: Optional input location for Data collection.
@@ -1123,7 +1137,7 @@ int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
  *	    Identifier (KS_EMPTY_BIN or KS_FILTERED_BIN).
  */
 int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
-			 int bin, int pid, bool vis_only,
+			 int bin, int sd, int pid, bool vis_only,
 			 struct kshark_entry_collection *col,
 			 ssize_t *index)
 {
@@ -1133,7 +1147,7 @@ int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
 		return KS_EMPTY_BIN;
 
 	entry = ksmodel_get_entry_back(histo, bin, vis_only,
-					      kshark_match_pid, pid,
+					      kshark_match_pid, sd, &pid,
 					      col,
 					      index);
 
@@ -1145,6 +1159,7 @@ int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
  *
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
+ * @param sd: Data stream identifier.
  * @param cpu: Cpu Id.
  * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
@@ -1153,7 +1168,7 @@ int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
  * @returns True, if a visible entry exists in this bin. Else false.
  */
 bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
-				     int bin, int cpu,
+				     int bin, int sd, int cpu,
 				     struct kshark_entry_collection *col,
 				     ssize_t *index)
 {
@@ -1166,7 +1181,7 @@ bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
 	/* Set the position at the beginning of the bin and go forward. */
 	req = ksmodel_entry_front_request_alloc(histo,
 						bin, true,
-						kshark_match_cpu, cpu);
+						kshark_match_cpu, sd, &cpu);
 	if (!req)
 		return false;
 
@@ -1198,6 +1213,7 @@ bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
  *
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
+ * @param sd: Data stream identifier.
  * @param pid: Process Id of the task.
  * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
@@ -1206,7 +1222,7 @@ bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
  * @returns True, if a visible entry exists in this bin. Else false.
  */
 bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
-				      int bin, int pid,
+				      int bin, int sd, int pid,
 				      struct kshark_entry_collection *col,
 				      ssize_t *index)
 {
@@ -1219,7 +1235,7 @@ bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
 	/* Set the position at the beginning of the bin and go forward. */
 	req = ksmodel_entry_front_request_alloc(histo,
 						bin, true,
-						kshark_match_pid, pid);
+						kshark_match_pid, sd, &pid);
 	if (!req)
 		return false;
 
@@ -1247,15 +1263,17 @@ bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
 }
 
 static bool match_cpu_missed_events(struct kshark_context *kshark_ctx,
-				    struct kshark_entry *e, int cpu)
+				    struct kshark_entry *e, int sd, int *cpu)
 {
-	return e->event_id == -EOVERFLOW && e->cpu == cpu;
+	return e->event_id == KS_EVENT_OVERFLOW &&
+	       e->cpu == *cpu && e->stream_id == sd;
 }
 
 static bool match_pid_missed_events(struct kshark_context *kshark_ctx,
-				    struct kshark_entry *e, int pid)
+				    struct kshark_entry *e, int sd, int *pid)
 {
-	return e->event_id == -EOVERFLOW && e->pid == pid;
+	return e->event_id == KS_EVENT_OVERFLOW &&
+	       e->pid == *pid && e->stream_id == sd;
 }
 
 /**
@@ -1264,6 +1282,7 @@ static bool match_pid_missed_events(struct kshark_context *kshark_ctx,
  *
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
+ * @param sd: Data stream identifier.
  * @param cpu: CPU Id.
  * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
@@ -1273,12 +1292,12 @@ static bool match_pid_missed_events(struct kshark_context *kshark_ctx,
  */
 const struct kshark_entry *
 ksmodel_get_cpu_missed_events(struct kshark_trace_histo *histo,
-			      int bin, int cpu,
+			      int bin, int sd, int cpu,
 			      struct kshark_entry_collection *col,
 			      ssize_t *index)
 {
 	return ksmodel_get_entry_front(histo, bin, true,
-				       match_cpu_missed_events, cpu,
+				       match_cpu_missed_events, sd, &cpu,
 				       col, index);
 }
 
@@ -1288,6 +1307,7 @@ ksmodel_get_cpu_missed_events(struct kshark_trace_histo *histo,
  *
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
+ * @param sd: Data stream identifier.
  * @param pid: Process Id of the task.
  * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
@@ -1297,11 +1317,11 @@ ksmodel_get_cpu_missed_events(struct kshark_trace_histo *histo,
  */
 const struct kshark_entry *
 ksmodel_get_task_missed_events(struct kshark_trace_histo *histo,
-			       int bin, int pid,
+			       int bin, int sd, int pid,
 			       struct kshark_entry_collection *col,
 			       ssize_t *index)
 {
 	return ksmodel_get_entry_front(histo, bin, true,
-				       match_pid_missed_events, pid,
+				       match_pid_missed_events, sd, &pid,
 				       col, index);
 }
diff --git a/src/libkshark-model.h b/src/libkshark-model.h
index 47793b11..87e252eb 100644
--- a/src/libkshark-model.h
+++ b/src/libkshark-model.h
@@ -1,13 +1,13 @@
 /* SPDX-License-Identifier: LGPL-2.1 */
 
 /*
- * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
- /**
-  *  @file    libkshark-model.h
-  *  @brief   Visualization model for FTRACE (trace-cmd) data.
-  */
+/**
+ *  @file    libkshark-model.h
+ *  @brief   Time series visualization model for tracing data.
+ */
 
 #ifndef _LIB_KSHARK_MODEL_H
 #define _LIB_KSHARK_MODEL_H
@@ -102,64 +102,64 @@ ssize_t ksmodel_first_index_at_bin(struct kshark_trace_histo *histo, int bin);
 ssize_t ksmodel_last_index_at_bin(struct kshark_trace_histo *histo, int bin);
 
 ssize_t ksmodel_first_index_at_cpu(struct kshark_trace_histo *histo,
-				   int bin, int cpu);
+				   int bin, int sd, int cpu);
 
 ssize_t ksmodel_first_index_at_pid(struct kshark_trace_histo *histo,
-				   int bin, int pid);
+				   int bin, int sd, int pid);
 
 const struct kshark_entry *
 ksmodel_get_entry_front(struct kshark_trace_histo *histo,
 			int bin, bool vis_only,
-			matching_condition_func func, int val,
+			matching_condition_func func, int sd, int *values,
 			struct kshark_entry_collection *col,
 			ssize_t *index);
 
 const struct kshark_entry *
 ksmodel_get_entry_back(struct kshark_trace_histo *histo,
 		       int bin, bool vis_only,
-		       matching_condition_func func, int val,
+		       matching_condition_func func, int sd, int *values,
 		       struct kshark_entry_collection *col,
 		       ssize_t *index);
 
 int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
-			  int bin, int cpu, bool vis_only,
+			  int bin, int sd, int cpu, bool vis_only,
 			  struct kshark_entry_collection *col,
 			  ssize_t *index);
 
 int ksmodel_get_pid_back(struct kshark_trace_histo *histo,
-			 int bin, int cpu, bool vis_only,
+			 int bin, int sd, int cpu, bool vis_only,
 			 struct kshark_entry_collection *col,
 			 ssize_t *index);
 
 int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
-			  int bin, int pid, bool vis_only,
+			  int bin, int sd, int pid, bool vis_only,
 			  struct kshark_entry_collection *col,
 			  ssize_t *index);
 
 int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
-			 int bin, int pid, bool vis_only,
+			 int bin, int sd, int pid, bool vis_only,
 			 struct kshark_entry_collection *col,
 			 ssize_t *index);
 
 bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
-				     int bin, int cpu,
+				     int bin, int sd, int cpu,
 				     struct kshark_entry_collection *col,
 				     ssize_t *index);
 
 bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
-				      int bin, int pid,
+				      int bin, int sd, int pid,
 				      struct kshark_entry_collection *col,
 				      ssize_t *index);
 
 const struct kshark_entry *
 ksmodel_get_cpu_missed_events(struct kshark_trace_histo *histo,
-			      int bin, int cpu,
+			      int bin, int sd, int cpu,
 			      struct kshark_entry_collection *col,
 			      ssize_t *index);
 
 const struct kshark_entry *
 ksmodel_get_task_missed_events(struct kshark_trace_histo *histo,
-			       int bin, int pid,
+			       int bin, int sd, int pid,
 			       struct kshark_entry_collection *col,
 			       ssize_t *index);
 
-- 
2.25.1

