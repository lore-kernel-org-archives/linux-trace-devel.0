Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bl2nam02on0062.outbound.protection.outlook.com ([104.47.38.62]:11903
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727546AbeKHBq0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 20:46:26 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 5/8] kernel-shark-qt: Add instrumentation for "Missed events"
 to the model
Date: Wed, 7 Nov 2018 16:14:37 +0000
Message-ID: <20181107161410.22507-6-ykaradzhov@vmware.com>
References: <20181107161410.22507-1-ykaradzhov@vmware.com>
In-Reply-To: <20181107161410.22507-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch adds to the Visualization model instruments, used for
finding and plotting "Missed events".

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark-model.c | 60 +++++++++++++++++++++++++++
 kernel-shark-qt/src/libkshark-model.h | 12 ++++++
 2 files changed, 72 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark-model.c b/kernel-shark-qt/src/li=
bkshark-model.c
index 7800090..ef6ad48 100644
--- a/kernel-shark-qt/src/libkshark-model.c
+++ b/kernel-shark-qt/src/libkshark-model.c
@@ -1222,3 +1222,63 @@ bool ksmodel_task_visible_event_exist(struct kshark_=
trace_histo *histo,
=20
 	return true;
 }
+
+static bool match_cpu_missed_events(struct kshark_context *kshark_ctx,
+				    struct kshark_entry *e, int cpu)
+{
+	return e->event_id =3D=3D -EOVERFLOW && e->cpu =3D=3D cpu;
+}
+
+static bool match_pid_missed_events(struct kshark_context *kshark_ctx,
+				    struct kshark_entry *e, int pid)
+{
+	return e->event_id =3D=3D -EOVERFLOW && e->pid =3D=3D pid;
+}
+
+/**
+ * @brief In a given CPU and bin, start from the front end of the bin and =
go towards
+ *	  the back end, searching for a Missed Events entry.
+ *
+ * @param histo: Input location for the model descriptor.
+ * @param bin: Bin id.
+ * @param cpu: CPU Id.
+ * @param col: Optional input location for Data collection.
+ * @param index: Optional output location for the index of the requested
+ *		 entry inside the array.
+ *
+ * @returns Pointer ot a kshark_entry, if an entry has been found. Else NU=
LL.
+ */
+const struct kshark_entry *
+ksmodel_get_cpu_missed_events(struct kshark_trace_histo *histo,
+			      int bin, int cpu,
+			      struct kshark_entry_collection *col,
+			      ssize_t *index)
+{
+	return ksmodel_get_entry_front(histo, bin, true,
+				       match_cpu_missed_events, cpu,
+				       col, index);
+}
+
+/**
+ * @brief In a given task and bin, start from the front end of the bin and=
 go towards
+ *	  the back end, searching for a Missed Events entry.
+ *
+ * @param histo: Input location for the model descriptor.
+ * @param bin: Bin id.
+ * @param pid: Process Id of the task.
+ * @param col: Optional input location for Data collection.
+ * @param index: Optional output location for the index of the requested
+ *		 entry inside the array.
+ *
+ * @returns Pointer ot a kshark_entry, if an entry has been found. Else NU=
LL.
+ */
+const struct kshark_entry *
+ksmodel_get_task_missed_events(struct kshark_trace_histo *histo,
+			       int bin, int pid,
+			       struct kshark_entry_collection *col,
+			       ssize_t *index)
+{
+	return ksmodel_get_entry_front(histo, bin, true,
+				       match_pid_missed_events, pid,
+				       col, index);
+}
diff --git a/kernel-shark-qt/src/libkshark-model.h b/kernel-shark-qt/src/li=
bkshark-model.h
index 1cf68da..db681cc 100644
--- a/kernel-shark-qt/src/libkshark-model.h
+++ b/kernel-shark-qt/src/libkshark-model.h
@@ -148,6 +148,18 @@ bool ksmodel_task_visible_event_exist(struct kshark_tr=
ace_histo *histo,
 				      struct kshark_entry_collection *col,
 				      ssize_t *index);
=20
+const struct kshark_entry *
+ksmodel_get_cpu_missed_events(struct kshark_trace_histo *histo,
+			      int bin, int cpu,
+			      struct kshark_entry_collection *col,
+			      ssize_t *index);
+
+const struct kshark_entry *
+ksmodel_get_task_missed_events(struct kshark_trace_histo *histo,
+			       int bin, int pid,
+			       struct kshark_entry_collection *col,
+			       ssize_t *index);
+
 static inline double ksmodel_bin_time(struct kshark_trace_histo *histo,
 				      int bin)
 {
--=20
2.17.1
