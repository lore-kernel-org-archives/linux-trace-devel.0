Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700082.outbound.protection.outlook.com ([40.107.70.82]:10650
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728044AbeJFBdS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 21:33:18 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 1/5] kernel-shark-qt: Add kshark_get_X_easy() functions.
Date: Fri, 5 Oct 2018 18:33:20 +0000
Message-ID: <20181005183241.27026-2-ykaradzhov@vmware.com>
References: <20181005183241.27026-1-ykaradzhov@vmware.com>
In-Reply-To: <20181005183241.27026-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>

The kshark_get_X_easy() functions allow for an easy access to the
tep_record's fields. Using these functions can be inefficient if you
need access to more than one of the fields of the record.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/libkshark.c | 196 ++++++++++++++++++++++++++++++++
 kernel-shark-qt/src/libkshark.h |  12 ++
 2 files changed, 208 insertions(+)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshar=
k.c
index 506511d..ef577e0 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -888,6 +888,202 @@ static const char *kshark_get_info(struct tep_handle =
*pe,
 	return seq.buffer;
 }
=20
+/**
+ * @brief This function allows for an easy access to the original value of=
 the
+ *	  Process Id as recorded in the tep_record object. The record is read
+ *	  from the file only in the case of an entry being touched by a plugin.
+ *	  Be aware that using the kshark_get_X_easy functions can be
+ *	  inefficient if you need an access to more than one of the data fields
+ *	  of the record.
+ *
+ * @param entry: Input location for the KernelShark entry.
+ *
+ * @returns The original value of the Process Id as recorded in the
+ *	    tep_record object on success, otherwise negative error code.
+ */
+int kshark_get_pid_easy(struct kshark_entry *entry)
+{
+	struct kshark_context *kshark_ctx =3D NULL;
+	struct tep_record *data;
+	int pid;
+
+	if (!kshark_instance(&kshark_ctx))
+		return -ENODEV;
+
+	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
+		pid =3D entry->pid;
+	} else {
+		/*
+		 * The entry has been touched by a plugin callback function.
+		 * Because of this we do not trust the value of "entry->pid".
+		 */
+		data =3D kshark_read_at(kshark_ctx, entry->offset);
+		pid =3D tep_data_pid(kshark_ctx->pevent, data);
+		free_record(data);
+	}
+
+	return pid;
+}
+
+/**
+ * @brief This function allows for an easy access to the original value of=
 the
+ *	  Task name as recorded in the tep_record object. The record is read
+ *	  from the file only in the case of an entry being touched by a plugin.
+ *	  Be aware that using the kshark_get_X_easy functions can be
+ *	  inefficient if you need an access to more than one of the data fields
+ *	  of the record.
+ *
+ * @param entry: Input location for the KernelShark entry.
+ *
+ * @returns The original name of the task, retrieved from the Process Id
+ *	    recorded in the tep_record object on success, otherwise NULL.
+ */
+const char *kshark_get_task_easy(struct kshark_entry *entry)
+{
+	struct kshark_context *kshark_ctx =3D NULL;
+	int pid =3D kshark_get_pid_easy(entry);
+
+	if (pid < 0)
+		return NULL;
+
+	kshark_instance(&kshark_ctx);
+	return tep_data_comm_from_pid(kshark_ctx->pevent, pid);
+}
+
+/**
+ * @brief This function allows for an easy access to the latency informati=
on
+ *	  recorded in the tep_record object. The record is read from the file
+ *	  using the offset field of kshark_entry. Be aware that using the
+ *	  kshark_get_X_easy functions can be inefficient if you need an access
+ *	  to more than one of the data fields of the record.
+ *
+ * @param entry: Input location for the KernelShark entry.
+ *
+ * @returns On success the function returns a string showing the latency
+ *	    information, coded into 5 fields:
+ *	    interrupts disabled, need rescheduling, hard/soft interrupt,
+ *	    preempt count and lock depth. On failure it returns NULL.
+ */
+const char *kshark_get_latency_easy(struct kshark_entry *entry)
+{
+	struct kshark_context *kshark_ctx =3D NULL;
+	struct tep_record *data;
+	const char *lat;
+
+	if (!kshark_instance(&kshark_ctx))
+		return NULL;
+
+	data =3D kshark_read_at(kshark_ctx, entry->offset);
+	lat =3D kshark_get_latency(kshark_ctx->pevent, data);
+	free_record(data);
+
+	return lat;
+}
+
+/**
+ * @brief This function allows for an easy access to the original value of=
 the
+ *	  Event Id as recorded in the tep_record object. The record is read
+ *	  from the file only in the case of an entry being touched by a plugin.
+ *	  Be aware that using the kshark_get_X_easy functions can be
+ *	  inefficient if you need an access to more than one of the data fields
+ *	  of the record.
+ *
+ * @param entry: Input location for the KernelShark entry.
+ *
+ * @returns The original value of the Event Id as recorded in the
+ *	    tep_record object on success, otherwise negative error code.
+ */
+int kshark_get_event_id_easy(struct kshark_entry *entry)
+{
+	struct kshark_context *kshark_ctx =3D NULL;
+	struct tep_record *data;
+	int event_id;
+
+	if (!kshark_instance(&kshark_ctx))
+		return -ENODEV;
+
+	if (entry->visible & KS_PLUGIN_UNTOUCHED_MASK) {
+		event_id =3D entry->event_id;
+	} else {
+		/*
+		 * The entry has been touched by a plugin callback function.
+		 * Because of this we do not trust the value of
+		 * "entry->event_id".
+		 */
+		data =3D kshark_read_at(kshark_ctx, entry->offset);
+		event_id =3D tep_data_type(kshark_ctx->pevent, data);
+		free_record(data);
+	}
+
+	return event_id;
+}
+
+/**
+ * @brief This function allows for an easy access to the original name of =
the
+ *	  trace event as recorded in the tep_record object. The record is read
+ *	  from the file only in the case of an entry being touched by a plugin.
+ *	  Be aware that using the kshark_get_X_easy functions can be
+ *	  inefficient if you need an access to more than one of the data fields
+ *	  of the record.
+ *
+ * @param entry: Input location for the KernelShark entry.
+ *
+ * @returns The mane of the trace event recorded in the tep_record object =
on
+ *	    success, otherwise "[UNKNOWN EVENT]" or NULL.
+ */
+const char *kshark_get_event_name_easy(struct kshark_entry *entry)
+{
+	struct kshark_context *kshark_ctx =3D NULL;
+	struct event_format *event;
+
+	int event_id =3D kshark_get_event_id_easy(entry);
+
+	if (event_id < 0)
+		return NULL;
+
+	kshark_instance(&kshark_ctx);
+	event =3D tep_data_event_from_type(kshark_ctx->pevent, event_id);
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
+ * @returns A string showing the data output of the trace event on success=
,
+ *	    otherwise NULL.
+ */
+const char *kshark_get_info_easy(struct kshark_entry *entry)
+{
+	struct kshark_context *kshark_ctx =3D NULL;
+	struct event_format *event;
+	struct tep_record *data;
+	const char *info =3D NULL;
+	int event_id;
+
+	if (!kshark_instance(&kshark_ctx))
+		return NULL;
+
+	data =3D kshark_read_at(kshark_ctx, entry->offset);
+
+	event_id =3D tep_data_type(kshark_ctx->pevent, data);
+	event =3D tep_data_event_from_type(kshark_ctx->pevent, event_id);
+	if (event)
+		info =3D kshark_get_info(kshark_ctx->pevent, data, event);
+
+	free_record(data);
+
+	return info;
+}
+
 /**
  * @brief Dump into a string the content of one entry. The function alloca=
tes
  *	  a null terminated string and returns a pointer to this string. The
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshar=
k.h
index e846c85..f00a584 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -148,6 +148,18 @@ void kshark_close(struct kshark_context *kshark_ctx);
=20
 void kshark_free(struct kshark_context *kshark_ctx);
=20
+int kshark_get_pid_easy(struct kshark_entry *entry);
+
+const char *kshark_get_task_easy(struct kshark_entry *entry);
+
+const char *kshark_get_latency_easy(struct kshark_entry *entry);
+
+int kshark_get_event_id_easy(struct kshark_entry *entry);
+
+const char *kshark_get_event_name_easy(struct kshark_entry *entry);
+
+const char *kshark_get_info_easy(struct kshark_entry *entry);
+
 char* kshark_dump_entry(const struct kshark_entry *entry);
=20
 struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
--=20
2.17.1
