Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0E6C6379F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3DA1246EB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:51:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XW9eGfBz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbgKROun (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 09:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbgKROum (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 09:50:42 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A49BC0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:42 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id a65so2984819wme.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wC87hoRooleghwjWGqH5v8Ih5NmseOrhNBsc1VnJBSA=;
        b=XW9eGfBz1oQHghNRfUIWBrekajvkMJv2931v9FNIcvlBI6dIrHGMIDdQUEoRkmRTCF
         TcwBE5O67MqrYQ3A/VBMY0zbAqZ1RPeikfGGmCc20D4NO+0OaIBXuHmBnC6/MAFPD8Da
         q4A7oeER/Hj6p0DSvrITGmAhnTHqUg09RETikZQr6euTh/4cZtkQdSHJkli1FeZDqWPy
         yETbxbtfTYJb7n0S9FqoUQZaZDO+jTsfGXs+PLTet8Jw4AequILn2PoZvN7uhFybMCPm
         gp7F9NabXhyYV8OOjaaw0GgYDuQuUyxXaJZiP0J5MjA0xdcYdFD0peatBZzSaARuPNvH
         nqrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wC87hoRooleghwjWGqH5v8Ih5NmseOrhNBsc1VnJBSA=;
        b=pmmG8pwjV7oKooUg8CvL6Vbo0WNN7Sa0McA+32woWFqRWJnMN0vVSkffomVT/HLtzk
         /VcPiT1ibmzzeCWdzwjEnPk8gy45aS9S2M4AvPy/NZPfL2fybq7ezcKzxTo58EVsNtJ/
         8Yo5L0WZTfRTVIYFhEJllCHN78TwY5+yNnhlKpjTMk5tE8htm11ZrshHLWrYfFDlKINq
         b30weAvlP8nVc1n59Pxh24zdlwoaVJozpX77Xt1WIn1MoLnGcTxb0f2vYzTzWwCwHcf1
         OOCtttIr0HlOpUD/Bgp04ao7PoBvTdPuTB/USpXUVdYZAsloE1/fXvKf4xhKM87Ppg75
         yw8g==
X-Gm-Message-State: AOAM530fzVhb2gaWzCxmTMDs/VaZ4bfkqWTmN74S/hfBxxPjSp3PF8aA
        PYLnrnH2kzfp6KM1MhVDdhQ=
X-Google-Smtp-Source: ABdhPJxGHUdDs+hHoINF3LO9f/WrU5/9nFpC05A81WoRIkUWMXV4a1PVRfYnVY4SLAqsJDHyTRscsw==
X-Received: by 2002:a1c:1b12:: with SMTP id b18mr381345wmb.119.1605711040899;
        Wed, 18 Nov 2020 06:50:40 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id s202sm3926190wme.39.2020.11.18.06.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 06:50:40 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 15/20] kernel-shark: Integrate the stream definitions with data model
Date:   Wed, 18 Nov 2020 16:49:58 +0200
Message-Id: <20201118145003.156542-16-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201118145003.156542-1-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
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

