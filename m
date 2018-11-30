Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr720049.outbound.protection.outlook.com ([40.107.72.49]:20658
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726577AbeLAAWl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 19:22:41 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 1/2] tools/lib/traceevent: make libtraceevent thread safe
Date: Fri, 30 Nov 2018 13:13:08 +0000
Message-ID: <20181130131254.32621-2-tstoyanov@vmware.com>
References: <20181130131254.32621-1-tstoyanov@vmware.com>
In-Reply-To: <20181130131254.32621-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch begins tranformation of libtraceevent into a
thread safe library. It implements per thread local storage
of tep hadler thread sensitive data and internal
APIs to access it. It covers tep->last_event cache,
more library's thread sensitive data will be added with
additional patches.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
---
 tools/lib/traceevent/Build                |  1 +
 tools/lib/traceevent/event-parse-local.h  | 15 ++++--
 tools/lib/traceevent/event-parse-thread.c | 63 +++++++++++++++++++++++
 tools/lib/traceevent/event-parse.c        | 39 +++++++-------
 4 files changed, 97 insertions(+), 21 deletions(-)
 create mode 100644 tools/lib/traceevent/event-parse-thread.c

diff --git a/tools/lib/traceevent/Build b/tools/lib/traceevent/Build
index c10a937cc85a..a6a1edd25827 100644
--- a/tools/lib/traceevent/Build
+++ b/tools/lib/traceevent/Build
@@ -5,6 +5,7 @@ libtraceevent-y +=3D parse-filter.o
 libtraceevent-y +=3D parse-utils.o
 libtraceevent-y +=3D kbuffer-parse.o
 libtraceevent-y +=3D event-parse-api.o
+libtraceevent-y +=3D event-parse-thread.o
=20
 plugin_jbd2-y         +=3D plugin_jbd2.o
 plugin_hrtimer-y      +=3D plugin_hrtimer.o
diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceeven=
t/event-parse-local.h
index 35833ee32d6c..8b8feb6c67d2 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -14,6 +14,12 @@ struct func_list;
 struct event_handler;
 struct func_resolver;
=20
+/* cache */
+struct tep_thread_data {
+	struct tep_handle *tep;
+	struct tep_event *last_event;
+};
+
 struct tep_handle {
 	int ref_count;
=20
@@ -83,9 +89,6 @@ struct tep_handle {
 	struct event_handler *handlers;
 	struct tep_function_handler *func_handlers;
=20
-	/* cache */
-	struct tep_event *last_event;
-
 	char *trace_clock;
 };
=20
@@ -96,4 +99,10 @@ unsigned short tep_data2host2(struct tep_handle *pevent,=
 unsigned short data);
 unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data);
 unsigned long long tep_data2host8(struct tep_handle *pevent, unsigned long=
 long data);
=20
+/* tep cache per thread */
+struct tep_event *get_thread_local_event_by_id(struct tep_handle *tep, int=
 id);
+struct tep_event *
+get_thread_local_event_by_name(struct tep_handle *tep, const char *name, c=
onst char *sys);
+void set_thread_local_event_cache(struct tep_handle *tep, struct tep_event=
 *event);
+
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/tools/lib/traceevent/event-parse-thread.c b/tools/lib/traceeve=
nt/event-parse-thread.c
new file mode 100644
index 000000000000..f84635030845
--- /dev/null
+++ b/tools/lib/traceevent/event-parse-thread.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.c=
om>
+ *
+ */
+
+#include "event-parse.h"
+#include "event-parse-local.h"
+#include "event-utils.h"
+
+static __thread struct tep_thread_data tep_thread_local;
+
+/**
+ * get_thread_local_event_by_id - Find event with given id in the cache
+ * @tep: a handle to the tep context
+ * @id: event's id
+ *
+ * Searches in the cache for event with given id
+ */
+struct tep_event *get_thread_local_event_by_id(struct tep_handle *tep, int=
 id)
+{
+
+	if (tep_thread_local.last_event && tep_thread_local.tep =3D=3D tep &&
+	    tep_thread_local.last_event->id =3D=3D id)
+		return tep_thread_local.last_event;
+
+	return NULL;
+}
+
+/**
+ * get_thread_local_event_by_name - Find event with given name and sys in =
the cache
+ * @tep: a handle to the tep context
+ * @name: event's name
+ * @sys: event's system
+ *
+ * Searches in the cache for event with given name and system
+ */
+struct tep_event *
+get_thread_local_event_by_name(struct tep_handle *tep, const char *name, c=
onst char *sys)
+{
+	if (tep_thread_local.last_event &&
+	    tep_thread_local.tep =3D=3D tep &&
+	    strcmp(tep_thread_local.last_event->name, name) =3D=3D 0 &&
+	    (!sys || strcmp(tep_thread_local.last_event->system, sys) =3D=3D 0))
+		return tep_thread_local.last_event;
+
+	return NULL;
+}
+
+/**
+ * set_thread_local_event_cache - set last used event in the cache
+ * @tep: a handle to the tep context
+ * @event: pointer to the last used event
+ *
+ * Sets last used event in the cache, to speed up the next searches
+ */
+void set_thread_local_event_cache(struct tep_handle *tep, struct tep_event=
 *event)
+{
+	tep_thread_local.tep =3D tep;
+	tep_thread_local.last_event =3D event;
+}
+
+
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index 70f04b02c8c5..8f19dcdd06ec 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3514,28 +3514,29 @@ static int events_id_cmp(const void *a, const void =
*b);
=20
 /**
  * tep_find_event - find an event by given id
- * @pevent: a handle to the pevent
+ * @tep: a handle to the tep context
  * @id: the id of the event
  *
  * Returns an event that has a given @id.
  */
-struct tep_event *tep_find_event(struct tep_handle *pevent, int id)
+struct tep_event *tep_find_event(struct tep_handle *tep, int id)
 {
 	struct tep_event **eventptr;
 	struct tep_event key;
 	struct tep_event *pkey =3D &key;
+	struct tep_event *event_cache =3D get_thread_local_event_by_id(tep, id);
=20
 	/* Check cache first */
-	if (pevent->last_event && pevent->last_event->id =3D=3D id)
-		return pevent->last_event;
+	if (event_cache)
+		return event_cache;
=20
 	key.id =3D id;
=20
-	eventptr =3D bsearch(&pkey, pevent->events, pevent->nr_events,
-			   sizeof(*pevent->events), events_id_cmp);
+	eventptr =3D bsearch(&pkey, tep->events, tep->nr_events,
+			   sizeof(*tep->events), events_id_cmp);
=20
 	if (eventptr) {
-		pevent->last_event =3D *eventptr;
+		set_thread_local_event_cache(tep, *eventptr);
 		return *eventptr;
 	}
=20
@@ -3544,7 +3545,7 @@ struct tep_event *tep_find_event(struct tep_handle *p=
event, int id)
=20
 /**
  * tep_find_event_by_name - find an event by given name
- * @pevent: a handle to the pevent
+ * @tep: a handle to the tep context
  * @sys: the system name to search for
  * @name: the name of the event to search for
  *
@@ -3552,19 +3553,19 @@ struct tep_event *tep_find_event(struct tep_handle =
*pevent, int id)
  * @sys. If @sys is NULL the first event with @name is returned.
  */
 struct tep_event *
-tep_find_event_by_name(struct tep_handle *pevent,
+tep_find_event_by_name(struct tep_handle *tep,
 		       const char *sys, const char *name)
 {
-	struct tep_event *event =3D NULL;
 	int i;
+	struct tep_event *event =3D NULL;
+	struct tep_event *event_cache =3D get_thread_local_event_by_name(tep, nam=
e, sys);
=20
-	if (pevent->last_event &&
-	    strcmp(pevent->last_event->name, name) =3D=3D 0 &&
-	    (!sys || strcmp(pevent->last_event->system, sys) =3D=3D 0))
-		return pevent->last_event;
+	/* Check cache first */
+	if (event_cache)
+		return event_cache;
=20
-	for (i =3D 0; i < pevent->nr_events; i++) {
-		event =3D pevent->events[i];
+	for (i =3D 0; i < tep->nr_events; i++) {
+		event =3D tep->events[i];
 		if (strcmp(event->name, name) =3D=3D 0) {
 			if (!sys)
 				break;
@@ -3572,10 +3573,12 @@ tep_find_event_by_name(struct tep_handle *pevent,
 				break;
 		}
 	}
-	if (i =3D=3D pevent->nr_events)
+
+	if (i =3D=3D tep->nr_events)
 		event =3D NULL;
+	if (event)
+		set_thread_local_event_cache(tep, event);
=20
-	pevent->last_event =3D event;
 	return event;
 }
=20
--=20
2.19.1
