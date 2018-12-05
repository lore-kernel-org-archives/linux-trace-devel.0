Return-Path: <SRS0=ZRv/=OO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710060.outbound.protection.outlook.com ([40.107.71.60]:45856
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726918AbeLEJWP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Dec 2018 04:22:15 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 1/2] tools/lib/traceevent: make libtraceevent thread safe
Date: Wed, 5 Dec 2018 09:22:12 +0000
Message-ID: <20181205092200.2291-2-tstoyanov@vmware.com>
References: <20181205092200.2291-1-tstoyanov@vmware.com>
In-Reply-To: <20181205092200.2291-1-tstoyanov@vmware.com>
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
 lib/traceevent/Makefile             |  1 +
 lib/traceevent/event-parse-local.h  | 15 +++++--
 lib/traceevent/event-parse-thread.c | 63 +++++++++++++++++++++++++++++
 lib/traceevent/event-parse.c        | 39 +++++++++---------
 4 files changed, 97 insertions(+), 21 deletions(-)
 create mode 100644 lib/traceevent/event-parse-thread.c

diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
index bfbb6a3..8e34a97 100644
--- a/lib/traceevent/Makefile
+++ b/lib/traceevent/Makefile
@@ -14,6 +14,7 @@ OBJS +=3D trace-seq.o
 OBJS +=3D parse-filter.o
 OBJS +=3D parse-utils.o
 OBJS +=3D event-parse-api.o
+OBJS +=3D event-parse-thread.o
=20
 # Additional util objects
 OBJS +=3D str_error_r.o
diff --git a/lib/traceevent/event-parse-local.h b/lib/traceevent/event-pars=
e-local.h
index 70693b8..2c75f9e 100644
--- a/lib/traceevent/event-parse-local.h
+++ b/lib/traceevent/event-parse-local.h
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
@@ -85,9 +91,6 @@ struct tep_handle {
=20
 	int parsing_failures;
=20
-	/* cache */
-	struct tep_event *last_event;
-
 	char *trace_clock;
 };
=20
@@ -98,4 +101,10 @@ unsigned short tep_data2host2(struct tep_handle *pevent=
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
diff --git a/lib/traceevent/event-parse-thread.c b/lib/traceevent/event-par=
se-thread.c
new file mode 100644
index 0000000..f846350
--- /dev/null
+++ b/lib/traceevent/event-parse-thread.c
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
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index bc35dc8..cacdcc4 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -3461,28 +3461,29 @@ static int events_id_cmp(const void *a, const void =
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
@@ -3491,7 +3492,7 @@ struct tep_event *tep_find_event(struct tep_handle *p=
event, int id)
=20
 /**
  * tep_find_event_by_name - find an event by given name
- * @pevent: a handle to the pevent
+ * @tep: a handle to the tep context
  * @sys: the system name to search for
  * @name: the name of the event to search for
  *
@@ -3499,19 +3500,19 @@ struct tep_event *tep_find_event(struct tep_handle =
*pevent, int id)
  * @sys. If @sys is NULL the first event with @name is returned.
  */
 struct tep_event *
-tep_find_event_by_name(struct tep_handle *pevent,
+tep_find_event_by_name(struct tep_handle *tep,
 		       const char *sys, const char *name)
 {
-	struct tep_event *event;
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
@@ -3519,10 +3520,12 @@ tep_find_event_by_name(struct tep_handle *pevent,
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
2.19.2
