Return-Path: <SRS0=YO3e=OC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr740044.outbound.protection.outlook.com ([40.107.74.44]:1170
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410047AbeKXAZ7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Nov 2018 19:25:59 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tools/lib/traceevent: make libtraceevent thread safe
Date: Fri, 23 Nov 2018 13:41:40 +0000
Message-ID: <20181123134130.16566-1-tstoyanov@vmware.com>
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
 tools/lib/traceevent/event-parse-local.h  | 17 ++++++++++---
 tools/lib/traceevent/event-parse-thread.c | 29 +++++++++++++++++++++++
 tools/lib/traceevent/event-parse.c        | 23 ++++++++++--------
 3 files changed, 56 insertions(+), 13 deletions(-)
 create mode 100644 tools/lib/traceevent/event-parse-thread.c

diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceeven=
t/event-parse-local.h
index 9a092dd4a86d..11f71ef8850b 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -14,6 +14,17 @@ struct func_list;
 struct event_handler;
 struct func_resolver;
=20
+/* cache */
+struct tep_thread_data {
+	struct tep_event *last_event;
+};
+
+struct tep_thread_data_list {
+	pid_t tid;
+	struct tep_thread_data thr_data;
+	struct tep_thread_data_pool *next;
+};
+
 struct tep_handle {
 	int ref_count;
=20
@@ -83,9 +94,6 @@ struct tep_handle {
 	struct event_handler *handlers;
 	struct tep_function_handler *func_handlers;
=20
-	/* cache */
-	struct tep_event *last_event;
-
 	char *trace_clock;
 };
=20
@@ -96,4 +104,7 @@ unsigned short tep_data2host2(struct tep_handle *pevent,=
 unsigned short data);
 unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data);
 unsigned long long tep_data2host8(struct tep_handle *pevent, unsigned long=
 long data);
=20
+struct tep_thread_data *tep_get_thread_local();
+void tep_destroy_thread_local();
+
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/tools/lib/traceevent/event-parse-thread.c b/tools/lib/traceeve=
nt/event-parse-thread.c
new file mode 100644
index 000000000000..775d953041ab
--- /dev/null
+++ b/tools/lib/traceevent/event-parse-thread.c
@@ -0,0 +1,29 @@
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
+static __thread struct tep_thread_data *tep_thread_local;
+
+
+struct tep_thread_data *tep_get_thread_local(struct tep_handle *tep __mayb=
e_unused)
+{
+	if (tep_thread_local)
+		return tep_thread_local;
+
+	tep_thread_local =3D calloc(1, sizeof(struct tep_thread_data));
+	return tep_thread_local;
+}
+
+
+void tep_destroy_thread_local()
+{
+	free(tep_thread_local);
+	tep_thread_local =3D NULL;
+}
+
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index a5048c1b9bec..25f4ceab9a58 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3485,10 +3485,11 @@ struct tep_event *tep_find_event(struct tep_handle =
*pevent, int id)
 	struct tep_event **eventptr;
 	struct tep_event key;
 	struct tep_event *pkey =3D &key;
-
+	struct tep_thread_data *local =3D tep_get_thread_local(pevent);
 	/* Check cache first */
-	if (pevent->last_event && pevent->last_event->id =3D=3D id)
-		return pevent->last_event;
+
+	if (local && local->last_event && local->last_event->id =3D=3D id)
+		return local->last_event;
=20
 	key.id =3D id;
=20
@@ -3496,7 +3497,8 @@ struct tep_event *tep_find_event(struct tep_handle *p=
event, int id)
 			   sizeof(*pevent->events), events_id_cmp);
=20
 	if (eventptr) {
-		pevent->last_event =3D *eventptr;
+		if (local)
+			local->last_event =3D *eventptr;
 		return *eventptr;
 	}
=20
@@ -3516,13 +3518,14 @@ struct tep_event *
 tep_find_event_by_name(struct tep_handle *pevent,
 		       const char *sys, const char *name)
 {
+	struct tep_thread_data *local =3D tep_get_thread_local(pevent);
 	struct tep_event *event =3D NULL;
 	int i;
=20
-	if (pevent->last_event &&
-	    strcmp(pevent->last_event->name, name) =3D=3D 0 &&
-	    (!sys || strcmp(pevent->last_event->system, sys) =3D=3D 0))
-		return pevent->last_event;
+	if (local && local->last_event &&
+	    strcmp(local->last_event->name, name) =3D=3D 0 &&
+	    (!sys || strcmp(local->last_event->system, sys) =3D=3D 0))
+		return local->last_event;
=20
 	for (i =3D 0; i < pevent->nr_events; i++) {
 		event =3D pevent->events[i];
@@ -3535,8 +3538,8 @@ tep_find_event_by_name(struct tep_handle *pevent,
 	}
 	if (i =3D=3D pevent->nr_events)
 		event =3D NULL;
-
-	pevent->last_event =3D event;
+	if (local)
+		local->last_event =3D event;
 	return event;
 }
=20
--=20
2.19.1
