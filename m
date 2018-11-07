Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bl2nam02on0062.outbound.protection.outlook.com ([104.47.38.62]:11903
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730846AbeKHBpo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 20:45:44 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 4/8] kernel-shark-qt: Add "Missed events" custom kshark_entry
Date: Wed, 7 Nov 2018 16:14:36 +0000
Message-ID: <20181107161410.22507-5-ykaradzhov@vmware.com>
References: <20181107161410.22507-1-ykaradzhov@vmware.com>
In-Reply-To: <20181107161410.22507-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

The ring buffer used during the acquisition of the tracing data can
overflow. In such a case a fraction of the data is lost. This patch
introduces a custom kshark_entry used to indicate that some data has
been overwrite (lost). Instruments for insertion and processing of
"Missed events" entries are added.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark.c | 196 ++++++++++++++++++++++++++------
 kernel-shark-qt/src/libkshark.h |  16 +++
 2 files changed, 179 insertions(+), 33 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark.c b/kernel-shark-qt/src/libkshar=
k.c
index 64236a5..1a39968 100644
--- a/kernel-shark-qt/src/libkshark.c
+++ b/kernel-shark-qt/src/libkshark.c
@@ -16,7 +16,6 @@
 #include <stdlib.h>
 #include <stdio.h>
 #include <assert.h>
-#include <errno.h>
=20
 // KernelShark
 #include "libkshark.h"
@@ -558,6 +557,52 @@ static void kshark_set_entry_values(struct kshark_cont=
ext *kshark_ctx,
 	entry->pid =3D tep_data_pid(kshark_ctx->pevent, record);
 }
=20
+/** Prior time offset of the "missed_events" entry. */
+#define ME_ENTRY_TIME_SHIFT	10
+
+static void missed_events_action(struct kshark_context *kshark_ctx,
+				 struct tep_record *record,
+				 struct kshark_entry *entry)
+{
+	/*
+	 * Use the offset field of the entry to store the number of missed
+	 * events.
+	 */
+	entry->offset =3D record->missed_events;
+
+	entry->cpu =3D record->cpu;
+
+	/*
+	 * Position the "missed_events" entry a bit before (in time)
+	 * the original record.
+	 */
+	entry->ts =3D record->ts - ME_ENTRY_TIME_SHIFT;
+
+	/* All custom entries must have negative event Identifiers. */
+	entry->event_id =3D KS_EVENT_OVERFLOW;
+
+	entry->visible =3D 0xFF;
+
+	entry->pid =3D tep_data_pid(kshark_ctx->pevent, record);
+}
+
+static const char* missed_events_dump(struct kshark_context *kshark_ctx,
+				      const struct kshark_entry *entry,
+				      bool get_info)
+{
+	int size =3D 0;
+	static char *buffer;
+
+	if (get_info)
+		size =3D asprintf(&buffer, "missed_events=3D%i", (int) entry->offset);
+	else
+		size =3D asprintf(&buffer, "missed_events");
+	if (size > 0)
+		return buffer;
+
+	return NULL;
+}
+
 /**
  * rec_list is used to pass the data to the load functions.
  * The rec_list will contain the list of entries from the source,
@@ -649,6 +694,21 @@ static size_t get_records(struct kshark_context *kshar=
k_ctx,
 				struct kshark_entry *entry;
 				int ret;
=20
+				if (rec->missed_events) {
+					/*
+					 * Insert a custom "missed_events" entry just
+					 * befor this record.
+					 */
+					entry =3D &temp_rec->entry;
+					missed_events_action(kshark_ctx, rec, entry);
+
+					temp_next =3D &temp_rec->next;
+					++count;
+
+					/* Now allocate a new rec_list node and comtinue. */
+					*temp_next =3D temp_rec =3D calloc(1, sizeof(*temp_rec));
+				}
+
 				entry =3D &temp_rec->entry;
 				kshark_set_entry_values(kshark_ctx, rec, entry);
=20
@@ -1006,6 +1066,9 @@ const char *kshark_get_latency_easy(struct kshark_ent=
ry *entry)
 	if (!kshark_instance(&kshark_ctx))
 		return NULL;
=20
+	if (entry->event_id < 0)
+		return NULL;
+
 	data =3D kshark_read_at(kshark_ctx, entry->offset);
 	lat =3D kshark_get_latency(kshark_ctx->pevent, data);
 	free_record(data);
@@ -1048,7 +1111,7 @@ int kshark_get_event_id_easy(struct kshark_entry *ent=
ry)
 		free_record(data);
 	}
=20
-	return event_id;
+	return (event_id =3D=3D -1)? EFAULT : event_id;
 }
=20
 /**
@@ -1070,11 +1133,20 @@ const char *kshark_get_event_name_easy(struct kshar=
k_entry *entry)
 	struct tep_event_format *event;
=20
 	int event_id =3D kshark_get_event_id_easy(entry);
-
-	if (event_id < 0)
+	if (event_id =3D=3D EFAULT)
 		return NULL;
=20
 	kshark_instance(&kshark_ctx);
+
+	if (event_id < 0) {
+		switch (event_id) {
+		case KS_EVENT_OVERFLOW:
+			return missed_events_dump(kshark_ctx, entry, false);
+		default:
+			return NULL;
+		}
+	}
+
 	event =3D tep_data_event_from_type(kshark_ctx->pevent, event_id);
 	if (event)
 		return event->name;
@@ -1105,6 +1177,15 @@ const char *kshark_get_info_easy(struct kshark_entry=
 *entry)
 	if (!kshark_instance(&kshark_ctx))
 		return NULL;
=20
+	if (entry->event_id < 0) {
+		switch (entry->event_id) {
+		case KS_EVENT_OVERFLOW:
+			return missed_events_dump(kshark_ctx, entry, true);
+		default:
+			return NULL;
+		}
+	}
+
 	data =3D kshark_read_at(kshark_ctx, entry->offset);
=20
 	event_id =3D tep_data_type(kshark_ctx->pevent, data);
@@ -1133,6 +1214,43 @@ void kshark_convert_nano(uint64_t time, uint64_t *se=
c, uint64_t *usec)
 	*usec =3D (time - s * 1000000000ULL) / 1000;
 }
=20
+/**
+ * @brief Dump into a string the content a custom entry. The function allo=
cates
+ *	  a null terminated string and returns a pointer to this string.
+ *
+ * @param kshark_ctx: Input location for the session context pointer.
+ * @param entry: A Kernel Shark entry to be printed.
+ * @param info_func:
+ *
+ * @returns The returned string contains a semicolon-separated list of dat=
a
+ *	    fields. The user has to free the returned string.
+ */
+char* kshark_dump_custom_entry(struct kshark_context *kshark_ctx,
+			       const struct kshark_entry *entry,
+			       kshark_custom_info_func info_func)
+{
+	const char *event_name, *task, *info;
+	char *entry_str;
+	int size =3D 0;
+
+	task =3D tep_data_comm_from_pid(kshark_ctx->pevent, entry->pid);
+	event_name =3D info_func(kshark_ctx, entry, false);
+	info =3D info_func(kshark_ctx, entry, true);
+
+	size =3D asprintf(&entry_str, "%li; %s-%i; CPU %i; ; %s; %s",
+			entry->ts,
+			task,
+			entry->pid,
+			entry->cpu,
+			event_name,
+			info);
+
+	if (size > 0)
+		return entry_str;
+
+	return NULL;
+}
+
 /**
  * @brief Dump into a string the content of one entry. The function alloca=
tes
  *	  a null terminated string and returns a pointer to this string. The
@@ -1147,48 +1265,60 @@ char* kshark_dump_entry(const struct kshark_entry *=
entry)
 {
 	const char *event_name, *task, *lat, *info;
 	struct kshark_context *kshark_ctx;
-	struct tep_record *data;
-	struct tep_event_format *event;
 	char *temp_str, *entry_str;
-	int event_id, size =3D 0;
+	int size =3D 0;
=20
 	kshark_ctx =3D NULL;
 	if (!kshark_instance(&kshark_ctx) || !init_thread_seq())
 		return NULL;
=20
-	data =3D kshark_read_at(kshark_ctx, entry->offset);
+	task =3D tep_data_comm_from_pid(kshark_ctx->pevent, entry->pid);
=20
-	event_id =3D tep_data_type(kshark_ctx->pevent, data);
-	event =3D tep_data_event_from_type(kshark_ctx->pevent, event_id);
+	if (entry->event_id >=3D 0) {
+		struct tep_event_format *event;
+		struct tep_record *data;
=20
-	event_name =3D event? event->name : "[UNKNOWN EVENT]";
-	task =3D tep_data_comm_from_pid(kshark_ctx->pevent, entry->pid);
-	lat =3D kshark_get_latency(kshark_ctx->pevent, data);
+		data =3D kshark_read_at(kshark_ctx, entry->offset);
=20
-	size =3D asprintf(&temp_str, "%li %s-%i; CPU %i; %s;",
-			entry->ts,
-			task,
-			entry->pid,
-			entry->cpu,
-			lat);
+		event =3D tep_data_event_from_type(kshark_ctx->pevent,
+						 entry->event_id);
=20
-	info =3D kshark_get_info(kshark_ctx->pevent, data, event);
-	if (size > 0) {
-		size =3D asprintf(&entry_str, "%s %s; %s; 0x%x",
-				temp_str,
-				event_name,
-				info,
-				entry->visible);
+		event_name =3D event? event->name : "[UNKNOWN EVENT]";
+		lat =3D kshark_get_latency(kshark_ctx->pevent, data);
=20
-		free(temp_str);
-	}
+		size =3D asprintf(&temp_str, "%li; %s-%i; CPU %i; %s;",
+				entry->ts,
+				task,
+				entry->pid,
+				entry->cpu,
+				lat);
=20
-	free_record(data);
+		info =3D kshark_get_info(kshark_ctx->pevent, data, event);
=20
-	if (size > 0)
-		return entry_str;
+		if (size > 0) {
+			size =3D asprintf(&entry_str, "%s %s; %s; 0x%x",
+					temp_str,
+					event_name,
+					info,
+					entry->visible);
=20
-	return NULL;
+			free(temp_str);
+		}
+
+		free_record(data);
+		if (size < 1)
+			entry_str =3D NULL;
+	} else {
+		switch (entry->event_id) {
+		case KS_EVENT_OVERFLOW:
+			entry_str =3D kshark_dump_custom_entry(kshark_ctx, entry,
+							     missed_events_dump);
+		default:
+			entry_str =3D NULL;
+		}
+	}
+
+	return entry_str;
 }
=20
 /**
@@ -1402,7 +1532,7 @@ get_entry(const struct kshark_entry_request *req,
=20
 	if (index) {
 		if (e)
-			*index =3D (e->event_id >=3D 0)? i : KS_FILTERED_BIN;
+			*index =3D (e->cpu !=3D KS_FILTERED_BIN)? i : KS_FILTERED_BIN;
 		else
 			*index =3D KS_EMPTY_BIN;
 	}
diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshar=
k.h
index 2b39c26..b94bdc3 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -15,6 +15,7 @@
 // C
 #include <stdint.h>
 #include <pthread.h>
+#include <errno.h>
=20
 // Json-C
 #include <json.h>
@@ -164,6 +165,18 @@ void kshark_convert_nano(uint64_t time, uint64_t *sec,=
 uint64_t *usec);
=20
 char* kshark_dump_entry(const struct kshark_entry *entry);
=20
+/**
+ * Custom entry info function type. To be user for dumping info for custom
+ * KernelShark entryes.
+ */
+typedef const char *(kshark_custom_info_func)(struct kshark_context *,
+					      const struct kshark_entry *,
+					      bool);
+
+char* kshark_dump_custom_entry(struct kshark_context *kshark_ctx,
+			       const struct kshark_entry *entry,
+			       kshark_custom_info_func info_func);
+
 struct tep_record *kshark_read_at(struct kshark_context *kshark_ctx,
 				  uint64_t offset);
=20
@@ -281,6 +294,9 @@ bool kshark_match_cpu(struct kshark_context *kshark_ctx=
,
 /** Filtered bin identifier. */
 #define KS_FILTERED_BIN		-2
=20
+/** Overflow Event identifier. */
+#define KS_EVENT_OVERFLOW	(-EOVERFLOW)
+
 /** Matching condition function type. To be user for data requests */
 typedef bool (matching_condition_func)(struct kshark_context*,
 				       struct kshark_entry*,
--=20
2.17.1
