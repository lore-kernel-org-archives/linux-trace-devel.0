Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-eopbgr820084.outbound.protection.outlook.com ([40.107.82.84]:56293
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725930AbfADUIV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Jan 2019 15:08:21 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 1/2] kernel-shark-qt: Avoid race condition when reading data
Date: Fri, 4 Jan 2019 20:06:20 +0000
Message-ID: <20190104200559.24471-2-ykaradzhov@vmware.com>
References: <20190104200559.24471-1-ykaradzhov@vmware.com>
In-Reply-To: <20190104200559.24471-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

We know that the data reading operations are not thread-safe.
A permanent solution for the problem is being worked on. For
the time being, this patch provides a naive temporary fix by
slapping mutexes all over the code, which will slow things down
a bit.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark.c            | 74 +++++++++++++---------
 kernel-shark-qt/src/libkshark.h            |  3 -
 kernel-shark-qt/src/plugins/sched_events.c |  6 +-
 3 files changed, 47 insertions(+), 36 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshar=
k.c
index 598ea52..23dc813 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -960,31 +960,6 @@ ssize_t kshark_load_data_records(struct kshark_context=
 *kshark_ctx,
 	return -ENOMEM;
 }
=20
-/**
- * @brief A thread-safe read of a record from a specific offset.
- *
- * @param kshark_ctx: Input location for the session context pointer.
- * @param offset: the offset into the file to find the record.
- *
- * @returns The returned pevent_record must be freed.
- */
-struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
-				  uint64_t offset)
-{
-	/*
-	 * Calling tracecmd_read_at() is not thread-safe. Use a mutex to
-	 * protect the access.
-	 */
-	pthread_mutex_lock(&kshark_ctx->input_mutex);
-
-	struct tep_record *data =3D tracecmd_read_at(kshark_ctx->handle,
-						      offset, NULL);
-
-	pthread_mutex_unlock(&kshark_ctx->input_mutex);
-
-	return data;
-}
-
 static const char *kshark_get_latency(struct tep_handle *pe,
 				      struct tep_record *record)
 {
@@ -1046,10 +1021,18 @@ int kshark_get_pid_easy(struct kshark_entry *entry)
 		/*
 		 * The entry has been touched by a plugin callback function.
 		 * Because of this we do not trust the value of "entry->pid".
+		 *
+		 * Currently the data reading operations are not thread-safe.
+		 * Use a mutex to protect the access.
 		 */
-		data =3D kshark_read_at(kshark_ctx, entry->offset);
+		pthread_mutex_lock(&kshark_ctx->input_mutex);
+
+		data =3D tracecmd_read_at(kshark_ctx->handle, entry->offset,
+					NULL);
 		pid =3D tep_data_pid(kshark_ctx->pevent, data);
 		free_record(data);
+
+		pthread_mutex_unlock(&kshark_ctx->input_mutex);
 	}
=20
 	return pid;
@@ -1106,10 +1089,18 @@ const char *kshark_get_latency_easy(struct kshark_e=
ntry *entry)
 	if (entry->event_id < 0)
 		return NULL;
=20
-	data =3D kshark_read_at(kshark_ctx, entry->offset);
+	/*
+	 * Currently the data reading operations are not thread-safe.
+	 * Use a mutex to protect the access.
+	 */
+	pthread_mutex_lock(&kshark_ctx->input_mutex);
+
+	data =3D tracecmd_read_at(kshark_ctx->handle, entry->offset, NULL);
 	lat =3D kshark_get_latency(kshark_ctx->pevent, data);
 	free_record(data);
=20
+	pthread_mutex_unlock(&kshark_ctx->input_mutex);
+
 	return lat;
 }
=20
@@ -1142,10 +1133,18 @@ int kshark_get_event_id_easy(struct kshark_entry *e=
ntry)
 		 * The entry has been touched by a plugin callback function.
 		 * Because of this we do not trust the value of
 		 * "entry->event_id".
+		 *
+		 * Currently the data reading operations are not thread-safe.
+		 * Use a mutex to protect the access.
 		 */
-		data =3D kshark_read_at(kshark_ctx, entry->offset);
+		pthread_mutex_lock(&kshark_ctx->input_mutex);
+
+		data =3D tracecmd_read_at(kshark_ctx->handle, entry->offset,
+					NULL);
 		event_id =3D tep_data_type(kshark_ctx->pevent, data);
 		free_record(data);
+
+		pthread_mutex_unlock(&kshark_ctx->input_mutex);
 	}
=20
 	return (event_id =3D=3D -1)? -EFAULT : event_id;
@@ -1184,7 +1183,14 @@ const char *kshark_get_event_name_easy(struct kshark=
_entry *entry)
 		}
 	}
=20
+	/*
+	 * Currently the data reading operations are not thread-safe.
+	 * Use a mutex to protect the access.
+	 */
+	pthread_mutex_lock(&kshark_ctx->input_mutex);
 	event =3D tep_data_event_from_type(kshark_ctx->pevent, event_id);
+	pthread_mutex_unlock(&kshark_ctx->input_mutex);
+
 	if (event)
 		return event->name;
=20
@@ -1223,8 +1229,13 @@ const char *kshark_get_info_easy(struct kshark_entry=
 *entry)
 		}
 	}
=20
-	data =3D kshark_read_at(kshark_ctx, entry->offset);
+	/*
+	 * Currently the data reading operations are not thread-safe.
+	 * Use a mutex to protect the access.
+	 */
+	pthread_mutex_lock(&kshark_ctx->input_mutex);
=20
+	data =3D tracecmd_read_at(kshark_ctx->handle, entry->offset, NULL);
 	event_id =3D tep_data_type(kshark_ctx->pevent, data);
 	event =3D tep_data_event_from_type(kshark_ctx->pevent, event_id);
 	if (event)
@@ -1232,6 +1243,8 @@ const char *kshark_get_info_easy(struct kshark_entry =
*entry)
=20
 	free_record(data);
=20
+	pthread_mutex_unlock(&kshark_ctx->input_mutex);
+
 	return info;
 }
=20
@@ -1315,7 +1328,8 @@ char* kshark_dump_entry(const struct kshark_entry *en=
try)
 		struct tep_event_format *event;
 		struct tep_record *data;
=20
-		data =3D kshark_read_at(kshark_ctx, entry->offset);
+		data =3D tracecmd_read_at(kshark_ctx->handle, entry->offset,
+					NULL);
=20
 		event =3D tep_data_event_from_type(kshark_ctx->pevent,
 						 entry->event_id);
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshar=
k.h
index 7d1edfc..a1b1f91 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -183,9 +183,6 @@ char* kshark_dump_custom_entry(struct kshark_context *k=
shark_ctx,
 			       const struct kshark_entry *entry,
 			       kshark_custom_info_func info_func);
=20
-struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
-				  uint64_t offset);
-
 /** Bit masks used to control the visibility of the entry after filtering.=
 */
 enum kshark_filter_masks {
 	/**
diff --git a/kernel-shark-qt/src/plugins/sched_events.c b/kernel-shark-qt/s=
rc/plugins/sched_events.c
index 1500110..5409bc6 100644
--- a/kernel-shark-qt/src/plugins/sched_events.c
+++ b/kernel-shark-qt/src/plugins/sched_events.c
@@ -184,7 +184,7 @@ bool plugin_wakeup_match_rec_pid(struct kshark_context =
*kshark_ctx,
=20
 	if (plugin_ctx->sched_wakeup_event &&
 	    e->event_id =3D=3D plugin_ctx->sched_wakeup_event->id) {
-		record =3D kshark_read_at(kshark_ctx, e->offset);
+		record =3D tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
=20
 		/* We only want those that actually woke up the task. */
 		ret =3D tep_read_number_field(plugin_ctx->sched_wakeup_success_field,
@@ -196,7 +196,7 @@ bool plugin_wakeup_match_rec_pid(struct kshark_context =
*kshark_ctx,
=20
 	if (plugin_ctx->sched_wakeup_new_event &&
 	    e->event_id =3D=3D plugin_ctx->sched_wakeup_new_event->id) {
-		record =3D kshark_read_at(kshark_ctx, e->offset);
+		record =3D tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
=20
 		/* We only want those that actually woke up the task. */
 		ret =3D tep_read_number_field(plugin_ctx->sched_wakeup_new_success_field=
,
@@ -238,7 +238,7 @@ bool plugin_switch_match_rec_pid(struct kshark_context =
*kshark_ctx,
 	    e->event_id =3D=3D plugin_ctx->sched_switch_event->id) {
 		struct tep_record *record;
=20
-		record =3D kshark_read_at(kshark_ctx, e->offset);
+		record =3D tracecmd_read_at(kshark_ctx->handle, e->offset, NULL);
 		ret =3D tep_read_number_field(plugin_ctx->sched_switch_prev_state_field,
 					    record->data, &val);
=20
--=20
2.17.1
