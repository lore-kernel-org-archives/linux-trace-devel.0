Return-Path: <SRS0=ZWpJ=OI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr800053.outbound.protection.outlook.com ([40.107.80.53]:16334
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726683AbeK2X25 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Nov 2018 18:28:57 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [POC][PATCH v4] tools/lib/traceevent: make libtraceevent thread safe
Date: Thu, 29 Nov 2018 12:23:42 +0000
Message-ID: <20181129122330.22500-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch is a PoC about transforming libtraceevent
into a thread safe library. It implements per thread local
storage and internal APIs to access it. It covers only
tep->last_event cache, but easily can be extended with all
library's thread sensitive data.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
v2: Added local thread data per tep context
v3: Implemented APIs to access specific tread local data,
    instead of the whole struct tep_thread_data.
v4: Simplify the implementation to keep cache only for the last
    used tep context in current thread, instead to track
    cache for all tep contexts. Remove "tep_" prefix of functions,
    as these are internal APIs and are not going to be exposed to
    the library users.
---
 tools/lib/traceevent/event-parse-local.h  | 16 ++++--
 tools/lib/traceevent/event-parse-thread.c | 62 +++++++++++++++++++++++
 tools/lib/traceevent/event-parse.c        | 21 ++++----
 3 files changed, 87 insertions(+), 12 deletions(-)
 create mode 100644 tools/lib/traceevent/event-parse-thread.c

diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceeven=
t/event-parse-local.h
index 9a092dd4a86d..bf3f810ce02f 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -14,6 +14,13 @@ struct func_list;
 struct event_handler;
 struct func_resolver;
=20
+/* cache */
+struct tep_thread_data {
+	struct tep_handle *tep;
+
+	struct tep_event *last_event;
+};
+
 struct tep_handle {
 	int ref_count;
=20
@@ -83,9 +90,6 @@ struct tep_handle {
 	struct event_handler *handlers;
 	struct tep_function_handler *func_handlers;
=20
-	/* cache */
-	struct tep_event *last_event;
-
 	char *trace_clock;
 };
=20
@@ -96,4 +100,10 @@ unsigned short tep_data2host2(struct tep_handle *pevent=
, unsigned short data);
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
index 000000000000..b575f7d8424e
--- /dev/null
+++ b/tools/lib/traceevent/event-parse-thread.c
@@ -0,0 +1,62 @@
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
+	if (tep_thread_local->last_event && tep_thread_local->tep =3D=3D tep &&
+	    tep_thread_local->last_event->id =3D=3D id)
+		return tep_thread_local->last_event;
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
+	if (tep_thread_local->last_event &&
+	    tep_thread_local->tep =3D=3D tep &&
+	    strcmp(tep_thread_local->last_event->name, name) =3D=3D 0 &&
+	    (!sys || strcmp(tep_thread_local->last_event->system, sys) =3D=3D 0))
+		return tep_thread_local->last_event;
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
+	tep_thread_local->last_event =3D event;
+}
+
+
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index a5048c1b9bec..ea6292c61ad4 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3485,10 +3485,11 @@ struct tep_event *tep_find_event(struct tep_handle =
*pevent, int id)
 	struct tep_event **eventptr;
 	struct tep_event key;
 	struct tep_event *pkey =3D &key;
+	struct tep_event *event_cache =3D get_thread_local_event_by_id(pevent, id=
);
=20
 	/* Check cache first */
-	if (pevent->last_event && pevent->last_event->id =3D=3D id)
-		return pevent->last_event;
+	if (event_cache)
+		return event_cache;
=20
 	key.id =3D id;
=20
@@ -3496,7 +3497,7 @@ struct tep_event *tep_find_event(struct tep_handle *p=
event, int id)
 			   sizeof(*pevent->events), events_id_cmp);
=20
 	if (eventptr) {
-		pevent->last_event =3D *eventptr;
+		set_thread_local_event_cache(pevent, *eventptr);
 		return *eventptr;
 	}
=20
@@ -3516,13 +3517,13 @@ struct tep_event *
 tep_find_event_by_name(struct tep_handle *pevent,
 		       const char *sys, const char *name)
 {
-	struct tep_event *event =3D NULL;
 	int i;
+	struct tep_event *event =3D NULL;
+	struct tep_event *event_cache =3D get_thread_local_event_by_name(pevent, =
name, sys);
=20
-	if (pevent->last_event &&
-	    strcmp(pevent->last_event->name, name) =3D=3D 0 &&
-	    (!sys || strcmp(pevent->last_event->system, sys) =3D=3D 0))
-		return pevent->last_event;
+	/* Check cache first */
+	if (event_cache)
+		return event_cache;
=20
 	for (i =3D 0; i < pevent->nr_events; i++) {
 		event =3D pevent->events[i];
@@ -3533,10 +3534,12 @@ tep_find_event_by_name(struct tep_handle *pevent,
 				break;
 		}
 	}
+
 	if (i =3D=3D pevent->nr_events)
 		event =3D NULL;
+	if (event)
+		set_thread_local_event_cache(pevent, event);
=20
-	pevent->last_event =3D event;
 	return event;
 }
=20
--=20
2.19.1
