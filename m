Return-Path: <SRS0=D2WB=J3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39496 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388036AbeGKNnh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Jul 2018 09:43:37 -0400
Received: by mail-wm0-f68.google.com with SMTP id h20-v6so2580340wmb.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 11 Jul 2018 06:39:12 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/6] kernel-shark-qt: Make the Vis. model use Data collections.
Date: Wed, 11 Jul 2018 16:38:13 +0300
Message-Id: <20180711133814.26854-6-y.karadz@gmail.com>
In-Reply-To: <20180711133814.26854-1-y.karadz@gmail.com>
References: <20180711133814.26854-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch optimizes the search instruments of the model by
adding the possibility of using Data collections.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/examples/datahisto.c  |  4 ++
 kernel-shark-qt/src/libkshark-model.c | 67 +++++++++++++++++++++++----
 kernel-shark-qt/src/libkshark-model.h | 13 +++++-
 3 files changed, 72 insertions(+), 12 deletions(-)

diff --git a/kernel-shark-qt/examples/datahisto.c b/kernel-shark-qt/examples/datahisto.c
index 1db2b02..77b5416 100644
--- a/kernel-shark-qt/examples/datahisto.c
+++ b/kernel-shark-qt/examples/datahisto.c
@@ -27,18 +27,22 @@ void dump_bin(struct kshark_trace_histo *histo, int bin,
 	if (strcmp(type, "cpu") == 0) {
 		e_front = ksmodel_get_entry_front(histo, bin, true,
 						  kshark_check_cpu, val,
+						  NULL,
 						  &i_front);
 
 		e_back = ksmodel_get_entry_back(histo, bin, true,
 						kshark_check_cpu, val,
+						NULL,
 						&i_back);
 	} else if (strcmp(type, "task") == 0) {
 		e_front = ksmodel_get_entry_front(histo, bin, true,
 						  kshark_check_pid, val,
+						  NULL,
 						  &i_front);
 
 		e_back = ksmodel_get_entry_back(histo, bin, true,
 						kshark_check_pid, val,
+						NULL,
 						&i_back);
 	} else {
 		i_front = ksmodel_first_index_at_bin(histo, bin);
diff --git a/kernel-shark-qt/src/libkshark-model.c b/kernel-shark-qt/src/libkshark-model.c
index 89ca8ab..bb381b4 100644
--- a/kernel-shark-qt/src/libkshark-model.c
+++ b/kernel-shark-qt/src/libkshark-model.c
@@ -855,6 +855,7 @@ ssize_t ksmodel_first_index_at_pid(struct kshark_trace_histo *histo,
  * @param func: Matching condition function.
  * @param val: Matching condition value, used by the Matching condition
  *	       function.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns Pointer ot a kshark_entry, if an entry has been found. Else NULL.
@@ -863,6 +864,7 @@ const struct kshark_entry *
 ksmodel_get_entry_front(struct kshark_trace_histo *histo,
 			int bin, bool vis_only,
 			matching_condition_func func, int val,
+			struct kshark_entry_collection *col,
 			ssize_t *index)
 {
 	struct kshark_entry_request *req;
@@ -877,7 +879,12 @@ ksmodel_get_entry_front(struct kshark_trace_histo *histo,
 	if (!req)
 		return NULL;
 
-	entry = kshark_get_entry_front(req, histo->data, index);
+	if (col && col->size)
+		entry = kshark_get_collection_entry_front(&req, histo->data,
+							  col, index);
+	else
+		entry = kshark_get_entry_front(req, histo->data, index);
+
 	free(req);
 
 	return entry;
@@ -893,6 +900,7 @@ ksmodel_get_entry_front(struct kshark_trace_histo *histo,
  * @param func: Matching condition function.
  * @param val: Matching condition value, used by the Matching condition
  *	       function.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns Pointer ot a kshark_entry, if an entry has been found. Else NULL.
@@ -901,6 +909,7 @@ const struct kshark_entry *
 ksmodel_get_entry_back(struct kshark_trace_histo *histo,
 		       int bin, bool vis_only,
 		       matching_condition_func func, int val,
+		       struct kshark_entry_collection *col,
 		       ssize_t *index)
 {
 	struct kshark_entry_request *req;
@@ -915,7 +924,12 @@ ksmodel_get_entry_back(struct kshark_trace_histo *histo,
 	if (!req)
 		return NULL;
 
-	entry = kshark_get_entry_back(req, histo->data, index);
+	if (col && col->size)
+		entry = kshark_get_collection_entry_back(&req, histo->data,
+							  col, index);
+	else
+		entry = kshark_get_entry_back(req, histo->data, index);
+
 	free(req);
 
 	return entry;
@@ -944,6 +958,7 @@ static int ksmodel_get_entry_pid(const struct kshark_entry *entry)
  * @param bin: Bin id.
  * @param cpu: Cpu Id.
  * @param vis_only: If true, a visible entry is requested.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns Process Id of the task if an entry has been found. Else a negative
@@ -951,13 +966,15 @@ static int ksmodel_get_entry_pid(const struct kshark_entry *entry)
  */
 int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
 			  int bin, int cpu, bool vis_only,
+			  struct kshark_entry_collection *col,
 			  ssize_t *index)
 {
 	const struct kshark_entry *entry;
 
 	entry = ksmodel_get_entry_front(histo, bin, vis_only,
 					       kshark_check_cpu, cpu,
-					       index);
+					       col, index);
+
 	return ksmodel_get_entry_pid(entry);
 }
 
@@ -969,6 +986,7 @@ int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
  * @param bin: Bin id.
  * @param cpu: Cpu Id.
  * @param vis_only: If true, a visible entry is requested.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns Process Id of the task if an entry has been found. Else a negative
@@ -976,13 +994,14 @@ int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
  */
 int ksmodel_get_pid_back(struct kshark_trace_histo *histo,
 			 int bin, int cpu, bool vis_only,
+			 struct kshark_entry_collection *col,
 			 ssize_t *index)
 {
 	const struct kshark_entry *entry;
 
 	entry = ksmodel_get_entry_back(histo, bin, vis_only,
 					      kshark_check_cpu, cpu,
-					      index);
+					      col, index);
 
 	return ksmodel_get_entry_pid(entry);
 }
@@ -1008,12 +1027,14 @@ static int ksmodel_get_entry_cpu(const struct kshark_entry *entry)
  * @param bin: Bin id.
  * @param pid: Process Id of a task.
  * @param vis_only: If true, a visible entry is requested.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns Cpu Id of the first entry from a given Task in this bin.
  */
 int ksmodel_get_cpu(struct kshark_trace_histo *histo,
 		    int bin, int pid, bool vis_only,
+		    struct kshark_entry_collection *col,
 		    ssize_t *index)
 {
 	struct kshark_entry_request *req;
@@ -1039,14 +1060,24 @@ int ksmodel_get_cpu(struct kshark_trace_histo *histo,
 		 * go backwards.
 		 */
 		req->first = ksmodel_bin_count(histo, bin) - 1;
-		entry = kshark_get_entry_back(req, histo->data, index);
+		if (col && col->size)
+			entry = kshark_get_collection_entry_back(&req,
+								 histo->data,
+								 col, index);
+		else
+			entry = kshark_get_entry_back(req, histo->data, index);
 	} else {
 		/*
 		 * Set the position at the beginning of the bin and go
 		 * forward.
 		 */
 		req->first = ksmodel_first_index_at_bin(histo, bin);
-		entry = kshark_get_entry_front(req, histo->data, index);
+		if (col && col->size)
+			entry = kshark_get_collection_entry_front(&req,
+								  histo->data,
+								  col, index);
+		else
+			entry = kshark_get_entry_front(req, histo->data, index);
 	}
 
 	free(req);
@@ -1059,13 +1090,16 @@ int ksmodel_get_cpu(struct kshark_trace_histo *histo,
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
  * @param cpu: Cpu Id.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns True, if a visible entry from the Cpu exists in this bin.
  * 	    Else false.
  */
 bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
-				     int bin, int cpu, ssize_t *index)
+				     int bin, int cpu,
+				     struct kshark_entry_collection *col,
+				     ssize_t *index)
 {
 	struct kshark_entry_request *req;
 	const struct kshark_entry *entry;
@@ -1082,7 +1116,12 @@ bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
 
 	req->vis_mask = KS_EVENT_VIEW_FILTER_MASK;
 
-	entry = kshark_get_entry_front(req, histo->data, index);
+	if (col && col->size)
+		entry = kshark_get_collection_entry_front(&req, histo->data,
+							  col, index);
+	else
+		entry = kshark_get_entry_front(req, histo->data, index);
+
 	free(req);
 
 	if (!entry || !entry->visible) {
@@ -1098,13 +1137,16 @@ bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
  * @param pid: Process Id of the task.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns True, if a visible entry from the task exists in this bin.
  * 	    Else false.
  */
 bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
-				      int bin, int pid, ssize_t *index)
+				      int bin, int pid,
+				      struct kshark_entry_collection *col,
+				      ssize_t *index)
 {
 	struct kshark_entry_request *req;
 	const struct kshark_entry *entry;
@@ -1121,7 +1163,12 @@ bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
 
 	req->vis_mask = KS_EVENT_VIEW_FILTER_MASK;
 
-	entry = kshark_get_entry_front(req, histo->data, index);
+	if (col && col->size)
+		entry = kshark_get_collection_entry_front(&req, histo->data,
+							  col, index);
+	else
+		entry = kshark_get_entry_front(req, histo->data, index);
+
 	free(req);
 
 	if (!entry || !entry->visible) {
diff --git a/kernel-shark-qt/src/libkshark-model.h b/kernel-shark-qt/src/libkshark-model.h
index db42772..b64dfc0 100644
--- a/kernel-shark-qt/src/libkshark-model.h
+++ b/kernel-shark-qt/src/libkshark-model.h
@@ -93,31 +93,40 @@ const struct kshark_entry *
 ksmodel_get_entry_front(struct kshark_trace_histo *histo,
 			int bin, bool vis_only,
 			matching_condition_func func, int val,
+			struct kshark_entry_collection *col,
 			ssize_t *index);
 
 const struct kshark_entry *
 ksmodel_get_entry_back(struct kshark_trace_histo *histo,
 		       int bin, bool vis_only,
 		       matching_condition_func func, int val,
+		       struct kshark_entry_collection *col,
 		       ssize_t *index);
 
 int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
 			  int bin, int cpu, bool vis_only,
+			  struct kshark_entry_collection *col,
 			  ssize_t *index);
 
 int ksmodel_get_pid_back(struct kshark_trace_histo *histo,
 			 int bin, int cpu, bool vis_only,
+			 struct kshark_entry_collection *col,
 			 ssize_t *index);
 
 int ksmodel_get_cpu(struct kshark_trace_histo *histo,
 		    int bin, int pid, bool vis_only,
+		    struct kshark_entry_collection *col,
 		    ssize_t *index);
 
 bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
-				     int bin, int cpu, ssize_t *index);
+				     int bin, int cpu,
+				     struct kshark_entry_collection *col,
+				     ssize_t *index);
 
 bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
-				      int bin, int pid, ssize_t *index);
+				      int bin, int pid,
+				      struct kshark_entry_collection *col,
+				      ssize_t *index);
 
 static inline double ksmodel_bin_time(struct kshark_trace_histo *histo,
 				      int bin)
-- 
2.17.1
