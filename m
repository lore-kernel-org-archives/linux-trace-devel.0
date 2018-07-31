Return-Path: <SRS0=gflo=KP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:52689 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732257AbeGaPeT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Jul 2018 11:34:19 -0400
Received: by mail-wm0-f66.google.com with SMTP id o11-v6so3171949wmh.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Jul 2018 06:53:50 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 6/7] kernel-shark-qt: Make the Vis. model use Data collections.
Date: Tue, 31 Jul 2018 16:52:47 +0300
Message-Id: <20180731135248.30587-7-y.karadz@gmail.com>
In-Reply-To: <20180731135248.30587-1-y.karadz@gmail.com>
References: <20180731135248.30587-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch optimizes the search instruments of the model by
adding the possibility of using Data collections.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/examples/datahisto.c  |  4 ++
 kernel-shark-qt/src/libkshark-model.c | 57 +++++++++++++++++++++++----
 kernel-shark-qt/src/libkshark-model.h | 14 ++++++-
 3 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/kernel-shark-qt/examples/datahisto.c b/kernel-shark-qt/examples/datahisto.c
index 3f19870..99ac495 100644
--- a/kernel-shark-qt/examples/datahisto.c
+++ b/kernel-shark-qt/examples/datahisto.c
@@ -27,18 +27,22 @@ void dump_bin(struct kshark_trace_histo *histo, int bin,
 	if (strcmp(type, "cpu") == 0) {
 		e_front = ksmodel_get_entry_front(histo, bin, true,
 						  kshark_match_cpu, val,
+						  NULL,
 						  &i_front);
 
 		e_back = ksmodel_get_entry_back(histo, bin, true,
 						kshark_match_cpu, val,
+						NULL,
 						&i_back);
 	} else if (strcmp(type, "task") == 0) {
 		e_front = ksmodel_get_entry_front(histo, bin, true,
 						  kshark_match_pid, val,
+						  NULL,
 						  &i_front);
 
 		e_back = ksmodel_get_entry_back(histo, bin, true,
 						kshark_match_pid, val,
+						NULL,
 						&i_back);
 	} else {
 		i_front = ksmodel_first_index_at_bin(histo, bin);
diff --git a/kernel-shark-qt/src/libkshark-model.c b/kernel-shark-qt/src/libkshark-model.c
index 4a4e910..73251f2 100644
--- a/kernel-shark-qt/src/libkshark-model.c
+++ b/kernel-shark-qt/src/libkshark-model.c
@@ -836,6 +836,7 @@ ssize_t ksmodel_first_index_at_pid(struct kshark_trace_histo *histo,
  * @param func: Matching condition function.
  * @param val: Matching condition value, used by the Matching condition
  *	       function.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns Pointer ot a kshark_entry, if an entry has been found. Else NULL.
@@ -844,6 +845,7 @@ const struct kshark_entry *
 ksmodel_get_entry_front(struct kshark_trace_histo *histo,
 			int bin, bool vis_only,
 			matching_condition_func func, int val,
+			struct kshark_entry_collection *col,
 			ssize_t *index)
 {
 	struct kshark_entry_request *req;
@@ -858,7 +860,12 @@ ksmodel_get_entry_front(struct kshark_trace_histo *histo,
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
@@ -874,6 +881,7 @@ ksmodel_get_entry_front(struct kshark_trace_histo *histo,
  * @param func: Matching condition function.
  * @param val: Matching condition value, used by the Matching condition
  *	       function.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns Pointer ot a kshark_entry, if an entry has been found. Else NULL.
@@ -882,6 +890,7 @@ const struct kshark_entry *
 ksmodel_get_entry_back(struct kshark_trace_histo *histo,
 		       int bin, bool vis_only,
 		       matching_condition_func func, int val,
+		       struct kshark_entry_collection *col,
 		       ssize_t *index)
 {
 	struct kshark_entry_request *req;
@@ -896,7 +905,12 @@ ksmodel_get_entry_back(struct kshark_trace_histo *histo,
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
@@ -926,6 +940,7 @@ static int ksmodel_get_entry_pid(const struct kshark_entry *entry)
  * @param bin: Bin id.
  * @param cpu: CPU Id.
  * @param vis_only: If true, a visible entry is requested.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns Process Id of the task if an entry has been found. Else a negative
@@ -933,6 +948,7 @@ static int ksmodel_get_entry_pid(const struct kshark_entry *entry)
  */
 int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
 			  int bin, int cpu, bool vis_only,
+			  struct kshark_entry_collection *col,
 			  ssize_t *index)
 {
 	const struct kshark_entry *entry;
@@ -942,7 +958,8 @@ int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
 
 	entry = ksmodel_get_entry_front(histo, bin, vis_only,
 					       kshark_match_cpu, cpu,
-					       index);
+					       col, index);
+
 	return ksmodel_get_entry_pid(entry);
 }
 
@@ -954,6 +971,7 @@ int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
  * @param bin: Bin id.
  * @param cpu: CPU Id.
  * @param vis_only: If true, a visible entry is requested.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns Process Id of the task if an entry has been found. Else a negative
@@ -961,6 +979,7 @@ int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
  */
 int ksmodel_get_pid_back(struct kshark_trace_histo *histo,
 			 int bin, int cpu, bool vis_only,
+			 struct kshark_entry_collection *col,
 			 ssize_t *index)
 {
 	const struct kshark_entry *entry;
@@ -970,7 +989,7 @@ int ksmodel_get_pid_back(struct kshark_trace_histo *histo,
 
 	entry = ksmodel_get_entry_back(histo, bin, vis_only,
 					      kshark_match_cpu, cpu,
-					      index);
+					      col, index);
 
 	return ksmodel_get_entry_pid(entry);
 }
@@ -999,6 +1018,7 @@ static int ksmodel_get_entry_cpu(const struct kshark_entry *entry)
  * @param bin: Bin id.
  * @param pid: Process Id.
  * @param vis_only: If true, a visible entry is requested.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns Process Id of the task if an entry has been found. Else a negative
@@ -1006,6 +1026,7 @@ static int ksmodel_get_entry_cpu(const struct kshark_entry *entry)
  */
 int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
 			  int bin, int pid, bool vis_only,
+			  struct kshark_entry_collection *col,
 			  ssize_t *index)
 {
 	const struct kshark_entry *entry;
@@ -1015,6 +1036,7 @@ int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
 
 	entry = ksmodel_get_entry_front(histo, bin, vis_only,
 					       kshark_match_pid, pid,
+					       col,
 					       index);
 	return ksmodel_get_entry_cpu(entry);
 }
@@ -1027,6 +1049,7 @@ int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
  * @param bin: Bin id.
  * @param pid: Process Id.
  * @param vis_only: If true, a visible entry is requested.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns Process Id of the task if an entry has been found. Else a negative
@@ -1034,6 +1057,7 @@ int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
  */
 int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
 			 int bin, int pid, bool vis_only,
+			 struct kshark_entry_collection *col,
 			 ssize_t *index)
 {
 	const struct kshark_entry *entry;
@@ -1043,6 +1067,7 @@ int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
 
 	entry = ksmodel_get_entry_back(histo, bin, vis_only,
 					      kshark_match_pid, pid,
+					      col,
 					      index);
 
 	return ksmodel_get_entry_cpu(entry);
@@ -1053,12 +1078,15 @@ int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
  * @param cpu: Cpu Id.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns True, if a visible entry exists in this bin. Else false.
  */
 bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
-				     int bin, int cpu, ssize_t *index)
+				     int bin, int cpu,
+				     struct kshark_entry_collection *col,
+				     ssize_t *index)
 {
 	struct kshark_entry_request *req;
 	const struct kshark_entry *entry;
@@ -1080,7 +1108,12 @@ bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
 	 */
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
@@ -1096,12 +1129,15 @@ bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
  * @param pid: Process Id of the task.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  * @returns True, if a visible entry exists in this bin. Else false.
  */
 bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
-				      int bin, int pid, ssize_t *index)
+				      int bin, int pid,
+				      struct kshark_entry_collection *col,
+				      ssize_t *index)
 {
 	struct kshark_entry_request *req;
 	const struct kshark_entry *entry;
@@ -1123,7 +1159,12 @@ bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
 	 */
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
index 15391a9..5ffa682 100644
--- a/kernel-shark-qt/src/libkshark-model.h
+++ b/kernel-shark-qt/src/libkshark-model.h
@@ -93,35 +93,45 @@ const struct kshark_entry *
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
 
 int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
 			  int bin, int pid, bool vis_only,
+			  struct kshark_entry_collection *col,
 			  ssize_t *index);
 
 int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
 			 int bin, int pid, bool vis_only,
+			 struct kshark_entry_collection *col,
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
