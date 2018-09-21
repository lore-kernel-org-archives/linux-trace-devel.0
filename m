Return-Path: <SRS0=4N8R=MD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0058.outbound.protection.outlook.com ([104.47.36.58]:21536
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389022AbeIUTfW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Sep 2018 15:35:22 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/4] kernel-shark-qt: Add kshark_get_X_easy() functions.
Date: Fri, 21 Sep 2018 16:45:37 +0300
Message-Id: <20180921134540.13074-2-ykaradzhov@vmware.com>
In-Reply-To: <20180921134540.13074-1-ykaradzhov@vmware.com>
References: <20180921134540.13074-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>

The kshark_get_X_easy() functions allow for an easy access to the
tep_record's fields. Using these functions can be inefficient if you
need access to more than one of the fields of the record.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 152 ++++++++++++++++++++++++++++++++
 kernel-shark-qt/src/libkshark.h |  10 +++
 2 files changed, 162 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshark.c
index 506511d..9ccb3cc 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -888,6 +888,158 @@ static const char *kshark_get_info(struct tep_handle *pe,
 	return seq.buffer;
 }
 
+/**
+ * @brief This function allows for an easy access to the original value of the
+ *	  Process Id as recorded in the tep_record object. The record is read
+ *	  from the file only in the case of an entry being touched by a plugin.
+ *	  Be aware that using the kshark_get_X_easy functions can be
+ *	  inefficient if you need an access to more than one of the data fields
+ *	  of the record.
+ *
+ * @param entry: Input location for the KernelShark entry.
+ *
+ * @returns The original value of the Process Id as recorded in the
+ *	    tep_record object.
+ */
+int kshark_get_pid_easy(struct kshark_entry *entry)
+{
+	int pid;
+
+	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
+		pid = entry->pid;
+	} else {
+		struct kshark_context *kshark_ctx = NULL;
+		kshark_instance(&kshark_ctx);
+
+		struct tep_record *data = kshark_read_at(kshark_ctx,
+							 entry->offset);
+
+		pid = tep_data_pid(kshark_ctx->pevent, data);
+		free_record(data);
+	}
+
+	return pid;
+}
+
+/**
+ * @brief This function allows for an easy access to the original value of the
+ *	  Task name as recorded in the tep_record object. The record is read
+ *	  from the file only in the case of an entry being touched by a plugin.
+ *	  Be aware that using the kshark_get_X_easy functions can be
+ *	  inefficient if you need an access to more than one of the data fields
+ *	  of the record.
+ *
+ * @param entry: Input location for the KernelShark entry.
+ *
+ * @returns The original name of the task, retrieved from the Process Id
+ *	    recorded in the tep_record object.
+ */
+const char *kshark_get_task_easy(struct kshark_entry *entry)
+{
+	int pid = kshark_get_pid_easy(entry);
+
+	struct kshark_context *kshark_ctx = NULL;
+	kshark_instance(&kshark_ctx);
+
+	return tep_data_comm_from_pid(kshark_ctx->pevent, pid);
+}
+
+/**
+ * @brief This function allows for an easy access to the latency information
+ *	  recorded in the tep_record object. The record is read from the file
+ *	  using the offset field of kshark_entry. Be aware that using the
+ *	  kshark_get_X_easy functions can be inefficient if you need an access
+ *	  to more than one of the data fields of the record.
+ *
+ * @param entry: Input location for the KernelShark entry.
+ *
+ * @returns A string showing the latency information, coded into 5 fields:
+ * 	    interrupts disabled, need rescheduling, hard/soft interrupt,
+ *	    preempt count and lock depth.
+ */
+const char *kshark_get_latency_easy(struct kshark_entry *entry)
+{
+	const char *lat;
+	struct kshark_context *kshark_ctx = NULL;
+	kshark_instance(&kshark_ctx);
+
+	struct tep_record *data = kshark_read_at(kshark_ctx,
+						 entry->offset);
+
+	lat = kshark_get_latency(kshark_ctx->pevent, data);
+	free_record(data);
+
+	return lat;
+}
+
+/**
+ * @brief This function allows for an easy access to the original name of the
+ * 	  trace event as recorded in the tep_record object. The record is read
+ *	  from the file only in the case of an entry being touched by a plugin.
+ *	  Be aware that using the kshark_get_X_easy functions can be
+ *	  inefficient if you need an access to more than one of the data fields
+ *	  of the record.
+ *
+ * @param entry: Input location for the KernelShark entry.
+ *
+ * @returns The mane of the trace event recorded in the tep_record object on
+ * 	    success, otherwise "[UNKNOWN EVENT]".
+ */
+const char *kshark_get_event_name_easy(struct kshark_entry *entry)
+{
+	int event_id;
+	struct event_format *event;
+	struct kshark_context *kshark_ctx = NULL;
+	kshark_instance(&kshark_ctx);
+
+	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
+		event_id = entry->event_id;
+	} else {
+		struct tep_record *data = kshark_read_at(kshark_ctx,
+							 entry->offset);
+		event_id = tep_data_type(kshark_ctx->pevent, data);
+		free_record(data);
+	}
+
+	event = tep_data_event_from_type(kshark_ctx->pevent, event_id);
+	if (event)
+		return event->name;
+
+	return "[UNKNOWN EVENT]";
+}
+
+/**
+ * @brief This function allows for an easy access to the tep_record's info
+ *	  streang. The record is read from the file using the offset field of
+ *	  kshark_entry. Be aware that using the kshark_get_X_easy functions can
+ *	  be inefficient if you need an access to more than one of the data
+ *	  fields of the record.
+ *
+ * @param entry: Input location for the KernelShark entry.
+ *
+ * @returns A string showing the data output of the trace event.
+ */
+const char *kshark_get_info_easy(struct kshark_entry *entry)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	struct event_format *event;
+	const char *info;
+	int event_id;
+
+	if (!kshark_instance(&kshark_ctx))
+		return NULL;
+
+	struct tep_record *data = kshark_read_at(kshark_ctx,
+						    entry->offset);
+	event_id = tep_data_type(kshark_ctx->pevent, data);
+	event = tep_data_event_from_type(kshark_ctx->pevent, event_id);
+
+	info = kshark_get_info(kshark_ctx->pevent, data, event);
+	free_record(data);
+
+	return info;
+}
+
 /**
  * @brief Dump into a string the content of one entry. The function allocates
  *	  a null terminated string and returns a pointer to this string. The
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index e846c85..a1f294a 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -148,6 +148,16 @@ void kshark_close(struct kshark_context *kshark_ctx);
 
 void kshark_free(struct kshark_context *kshark_ctx);
 
+int kshark_get_pid_easy(struct kshark_entry *entry);
+
+const char *kshark_get_task_easy(struct kshark_entry *entry);
+
+const char *kshark_get_latency_easy(struct kshark_entry *entry);
+
+const char *kshark_get_event_name_easy(struct kshark_entry *entry);
+
+const char *kshark_get_info_easy(struct kshark_entry *entry);
+
 char* kshark_dump_entry(const struct kshark_entry *entry);
 
 struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
-- 
2.17.1
