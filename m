Return-Path: <SRS0=opg7=KS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39593 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732188AbeHCQ1G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Aug 2018 12:27:06 -0400
Received: by mail-wr1-f66.google.com with SMTP id h10-v6so5605331wre.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Aug 2018 07:30:29 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 5/6] kernel-shark-qt: Make the Vis. model use Data collections.
Date: Fri,  3 Aug 2018 17:29:36 +0300
Message-Id: <20180803142937.3970-6-y.karadz@gmail.com>
In-Reply-To: <20180803142937.3970-1-y.karadz@gmail.com>
References: <20180803142937.3970-1-y.karadz@gmail.com>
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
index d750886..d9d95fd 100644
--- a/kernel-shark-qt/src/libkshark-model.c
+++ b/kernel-shark-qt/src/libkshark-model.c
@@ -868,6 +868,7 @@ ssize_t ksmodel_first_index_at_pid(struct kshark_trace_histo *histo,
  * @param func: Matching condition function.
  * @param val: Matching condition value, used by the Matching condition
  *	       function.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  *
@@ -877,6 +878,7 @@ const struct kshark_entry *
 ksmodel_get_entry_front(struct kshark_trace_histo *histo,
 			int bin, bool vis_only,
 			matching_condition_func func, int val,
+			struct kshark_entry_collection *col,
 			ssize_t *index)
 {
 	struct kshark_entry_request *req;
@@ -891,7 +893,12 @@ ksmodel_get_entry_front(struct kshark_trace_histo *histo,
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
@@ -908,6 +915,7 @@ ksmodel_get_entry_front(struct kshark_trace_histo *histo,
  * @param func: Matching condition function.
  * @param val: Matching condition value, used by the Matching condition
  *	       function.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  *
@@ -917,6 +925,7 @@ const struct kshark_entry *
 ksmodel_get_entry_back(struct kshark_trace_histo *histo,
 		       int bin, bool vis_only,
 		       matching_condition_func func, int val,
+		       struct kshark_entry_collection *col,
 		       ssize_t *index)
 {
 	struct kshark_entry_request *req;
@@ -931,7 +940,12 @@ ksmodel_get_entry_back(struct kshark_trace_histo *histo,
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
@@ -962,6 +976,7 @@ static int ksmodel_get_entry_pid(const struct kshark_entry *entry)
  * @param bin: Bin id.
  * @param cpu: CPU Id.
  * @param vis_only: If true, a visible entry is requested.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  *
@@ -970,6 +985,7 @@ static int ksmodel_get_entry_pid(const struct kshark_entry *entry)
  */
 int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
 			  int bin, int cpu, bool vis_only,
+			  struct kshark_entry_collection *col,
 			  ssize_t *index)
 {
 	const struct kshark_entry *entry;
@@ -979,7 +995,8 @@ int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
 
 	entry = ksmodel_get_entry_front(histo, bin, vis_only,
 					       kshark_match_cpu, cpu,
-					       index);
+					       col, index);
+
 	return ksmodel_get_entry_pid(entry);
 }
 
@@ -992,6 +1009,7 @@ int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
  * @param bin: Bin id.
  * @param cpu: CPU Id.
  * @param vis_only: If true, a visible entry is requested.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  *
@@ -1000,6 +1018,7 @@ int ksmodel_get_pid_front(struct kshark_trace_histo *histo,
  */
 int ksmodel_get_pid_back(struct kshark_trace_histo *histo,
 			 int bin, int cpu, bool vis_only,
+			 struct kshark_entry_collection *col,
 			 ssize_t *index)
 {
 	const struct kshark_entry *entry;
@@ -1009,7 +1028,7 @@ int ksmodel_get_pid_back(struct kshark_trace_histo *histo,
 
 	entry = ksmodel_get_entry_back(histo, bin, vis_only,
 					      kshark_match_cpu, cpu,
-					      index);
+					      col, index);
 
 	return ksmodel_get_entry_pid(entry);
 }
@@ -1039,6 +1058,7 @@ static int ksmodel_get_entry_cpu(const struct kshark_entry *entry)
  * @param bin: Bin id.
  * @param pid: Process Id.
  * @param vis_only: If true, a visible entry is requested.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  *
@@ -1047,6 +1067,7 @@ static int ksmodel_get_entry_cpu(const struct kshark_entry *entry)
  */
 int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
 			  int bin, int pid, bool vis_only,
+			  struct kshark_entry_collection *col,
 			  ssize_t *index)
 {
 	const struct kshark_entry *entry;
@@ -1056,6 +1077,7 @@ int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
 
 	entry = ksmodel_get_entry_front(histo, bin, vis_only,
 					       kshark_match_pid, pid,
+					       col,
 					       index);
 	return ksmodel_get_entry_cpu(entry);
 }
@@ -1069,6 +1091,7 @@ int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
  * @param bin: Bin id.
  * @param pid: Process Id.
  * @param vis_only: If true, a visible entry is requested.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  *
@@ -1077,6 +1100,7 @@ int ksmodel_get_cpu_front(struct kshark_trace_histo *histo,
  */
 int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
 			 int bin, int pid, bool vis_only,
+			 struct kshark_entry_collection *col,
 			 ssize_t *index)
 {
 	const struct kshark_entry *entry;
@@ -1086,6 +1110,7 @@ int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
 
 	entry = ksmodel_get_entry_back(histo, bin, vis_only,
 					      kshark_match_pid, pid,
+					      col,
 					      index);
 
 	return ksmodel_get_entry_cpu(entry);
@@ -1097,13 +1122,16 @@ int ksmodel_get_cpu_back(struct kshark_trace_histo *histo,
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
  * @param cpu: Cpu Id.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  *
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
@@ -1125,7 +1153,12 @@ bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
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
@@ -1142,13 +1175,16 @@ bool ksmodel_cpu_visible_event_exist(struct kshark_trace_histo *histo,
  * @param histo: Input location for the model descriptor.
  * @param bin: Bin id.
  * @param pid: Process Id of the task.
+ * @param col: Optional input location for Data collection.
  * @param index: Optional output location for the index of the requested
  *		 entry inside the array.
  *
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
@@ -1170,7 +1206,12 @@ bool ksmodel_task_visible_event_exist(struct kshark_trace_histo *histo,
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
index b99d9d1..6c135c7 100644
--- a/kernel-shark-qt/src/libkshark-model.h
+++ b/kernel-shark-qt/src/libkshark-model.h
@@ -100,35 +100,45 @@ const struct kshark_entry *
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
