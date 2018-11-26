Return-Path: <SRS0=Jn1h=OF=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810070.outbound.protection.outlook.com ([40.107.81.70]:46047
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726176AbeK0ARM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Nov 2018 19:17:12 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] tools/lib/traceevent: make libtraceevent thread safe
Date: Mon, 26 Nov 2018 13:22:59 +0000
Message-ID: <20181126132245.19576-1-tstoyanov@vmware.com>
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

[v2 - added local thread data per tep context]

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-local.h  | 14 ++++--
 tools/lib/traceevent/event-parse-thread.c | 57 +++++++++++++++++++++++
 tools/lib/traceevent/event-parse.c        | 23 +++++----
 3 files changed, 81 insertions(+), 13 deletions(-)
 create mode 100644 tools/lib/traceevent/event-parse-thread.c

diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceeven=
t/event-parse-local.h
index 9a092dd4a86d..6fa0f05b29c3 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -14,6 +14,14 @@ struct func_list;
 struct event_handler;
 struct func_resolver;
=20
+/* cache */
+struct tep_thread_data {
+	struct tep_handle *tep;
+	struct tep_thread_data *next;
+
+	struct tep_event *last_event;
+};
+
 struct tep_handle {
 	int ref_count;
=20
@@ -83,9 +91,6 @@ struct tep_handle {
 	struct event_handler *handlers;
 	struct tep_function_handler *func_handlers;
=20
-	/* cache */
-	struct tep_event *last_event;
-
 	char *trace_clock;
 };
=20
@@ -96,4 +101,7 @@ unsigned short tep_data2host2(struct tep_handle *pevent,=
 unsigned short data);
 unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data);
 unsigned long long tep_data2host8(struct tep_handle *pevent, unsigned long=
 long data);
=20
+struct tep_thread_data *tep_get_thread_local(struct tep_handle *tep);
+void tep_destroy_thread_local(struct tep_handle *tep);
+
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/tools/lib/traceevent/event-parse-thread.c b/tools/lib/traceeve=
nt/event-parse-thread.c
new file mode 100644
index 000000000000..39350dc82c5d
--- /dev/null
+++ b/tools/lib/traceevent/event-parse-thread.c
@@ -0,0 +1,57 @@
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
+struct tep_thread_data *tep_get_thread_local(struct tep_handle *tep)
+{
+	struct tep_thread_data *local =3D tep_thread_local;
+
+	while(local) {
+		if (local->tep =3D=3D tep)
+			return local;
+		local =3D local->next;
+	}
+
+	local =3D calloc(1, sizeof(struct tep_thread_data));
+	if(local) {
+		local->tep =3D tep;
+		local->next =3D tep_thread_local;
+		tep_thread_local =3D local;
+	}
+	return local;
+}
+
+
+void tep_destroy_thread_local(struct tep_handle *tep)
+{
+	struct tep_thread_data **local, *del;
+
+	if(!tep_thread_local)
+		return;
+	local =3D &tep_thread_local;
+
+	while(*local) {
+		if ((*local)->tep =3D=3D tep) {
+			tep_thread_local =3D (*local)->next;
+			free(*local);
+			return;
+		}
+		if ((*local)->next && (*local)->next->tep =3D=3D tep) {
+			del =3D (*local)->next;
+			(*local)->next =3D (*local)->next->next;
+			free(del);
+			return;
+		}
+		local =3D &((*local)->next);
+	}
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
