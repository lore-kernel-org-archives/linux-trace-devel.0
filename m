Return-Path: <SRS0=lLmH=O3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41934 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbeLRNaS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Dec 2018 08:30:18 -0500
Received: by mail-wr1-f67.google.com with SMTP id x10so15904708wrs.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Dec 2018 05:30:15 -0800 (PST)
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: implement a new API, tep_list_events_copy()
Date: Tue, 18 Dec 2018 15:30:13 +0200
Message-Id: <20181218133013.31094-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Existing API tep_list_events() is not thread safe, it
uses the internal array sort_events to keep cache of
the sorted events and reuses it. This patch implements
a new API, tep_list_events_copy(), which allocates new
sorted array each time it is called. It could be used
when a sorted events functionality is needed in thread
safe use cases. It is up to the caller to free the array.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/traceevent/event-parse.h |   5 +-
 lib/traceevent/event-parse.c     | 109 ++++++++++++++++++++++++-------
 2 files changed, 91 insertions(+), 23 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 3ffc26a..405fee8 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -528,7 +528,10 @@ void tep_event_info(struct trace_seq *s, struct tep_event *event,
 int tep_strerror(struct tep_handle *pevent, enum tep_errno errnum,
 		    char *buf, size_t buflen);
 
-struct tep_event **tep_list_events(struct tep_handle *pevent, enum tep_event_sort_type);
+struct tep_event **tep_list_events(struct tep_handle *tep,
+				   enum tep_event_sort_type);
+struct tep_event **tep_list_events_copy(struct tep_handle *tep,
+					enum tep_event_sort_type);
 struct tep_format_field **tep_event_common_fields(struct tep_event *event);
 struct tep_format_field **tep_event_fields(struct tep_event *event);
 
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 1cab1a5..1df8b14 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5626,32 +5626,26 @@ static int events_system_cmp(const void *a, const void *b)
 	return events_id_cmp(a, b);
 }
 
-struct tep_event **tep_list_events(struct tep_handle *pevent, enum tep_event_sort_type sort_type)
+static struct tep_event **list_events_copy(struct tep_handle *tep)
 {
 	struct tep_event **events;
-	int (*sort)(const void *a, const void *b);
-
-	events = pevent->sort_events;
-
-	if (events && pevent->last_type == sort_type)
-		return events;
 
-	if (!events) {
-		events = malloc(sizeof(*events) * (pevent->nr_events + 1));
-		if (!events)
-			return NULL;
+	if (!tep)
+		return NULL;
 
-		memcpy(events, pevent->events, sizeof(*events) * pevent->nr_events);
-		events[pevent->nr_events] = NULL;
+	events = malloc(sizeof(*events) * (tep->nr_events + 1));
+	if (!events)
+		return NULL;
 
-		pevent->sort_events = events;
+	memcpy(events, tep->events, sizeof(*events) * tep->nr_events);
+	events[tep->nr_events] = NULL;
+	return events;
+}
 
-		/* the internal events are sorted by id */
-		if (sort_type == TEP_EVENT_SORT_ID) {
-			pevent->last_type = sort_type;
-			return events;
-		}
-	}
+static void list_events_sort(struct tep_event **events, int nr_events,
+			     enum tep_event_sort_type sort_type)
+{
+	int (*sort)(const void *a, const void *b);
 
 	switch (sort_type) {
 	case TEP_EVENT_SORT_ID:
@@ -5664,11 +5658,82 @@ struct tep_event **tep_list_events(struct tep_handle *pevent, enum tep_event_sor
 		sort = events_system_cmp;
 		break;
 	default:
+		sort = NULL;
+	}
+
+	if (sort)
+		qsort(events, nr_events, sizeof(*events), sort);
+}
+
+/**
+ * tep_list_events - Get events, sorted by given criteria.
+ * @tep: a handle to the tep context
+ * @sort_type: desired sort order of the events in the array
+ *
+ * Returns an array of pointers to all events, sorted by the given
+ * @sort_type criteria. The last element of the array is NULL. The returned
+ * memory must not be freed, it is managed by the library.
+ * The function is not thread safe.
+ */
+struct tep_event **tep_list_events(struct tep_handle *tep,
+				   enum tep_event_sort_type sort_type)
+{
+	struct tep_event **events;
+
+	if (!tep)
+		return NULL;
+
+	events = tep->sort_events;
+	if (events && tep->last_type == sort_type)
 		return events;
+
+	if (!events) {
+		events = list_events_copy(tep);
+		if (!events)
+			return NULL;
+
+		tep->sort_events = events;
+
+		/* the internal events are sorted by id */
+		if (sort_type == TEP_EVENT_SORT_ID) {
+			tep->last_type = sort_type;
+			return events;
+		}
 	}
 
-	qsort(events, pevent->nr_events, sizeof(*events), sort);
-	pevent->last_type = sort_type;
+	list_events_sort(events, tep->nr_events, sort_type);
+	tep->last_type = sort_type;
+
+	return events;
+}
+
+
+/**
+ * tep_list_events_copy - Thread safe version of tep_list_events()
+ * @tep: a handle to the tep context
+ * @sort_type: desired sort order of the events in the array
+ *
+ * Returns an array of pointers to all events, sorted by the given
+ * @sort_type criteria. The last element of the array is NULL. The returned
+ * array is newly allocated inside the function and must be freed by the caller
+ */
+struct tep_event **tep_list_events_copy(struct tep_handle *tep,
+					enum tep_event_sort_type sort_type)
+{
+	struct tep_event **events;
+
+	if (!tep)
+		return NULL;
+
+	events = list_events_copy(tep);
+	if (!events)
+		return NULL;
+
+	/* the internal events are sorted by id */
+	if (sort_type == TEP_EVENT_SORT_ID)
+		return events;
+
+	list_events_sort(events, tep->nr_events, sort_type);
 
 	return events;
 }
-- 
2.19.2
