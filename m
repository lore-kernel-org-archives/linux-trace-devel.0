Return-Path: <SRS0=VoGV=M6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bl2nam02on0054.outbound.protection.outlook.com ([104.47.38.54]:43069
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726132AbeJRUFx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Oct 2018 16:05:53 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 3/3] tools/lib/traceevent, tools/perf: Rename
 tep_free_format() to tep_free_event()
Date: Thu, 18 Oct 2018 12:04:33 +0000
Message-ID: <20181018120423.3665-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. This renames tep_free_format() to tep_free_event(),
which describes more closely the purpose of the function.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse.c | 6 +++---
 tools/lib/traceevent/event-parse.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index d2aac1461769..73347e2ef81d 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -6169,7 +6169,7 @@ __parse_event(struct tep_handle *pevent,
 	return 0;
=20
 event_add_failed:
-	tep_free_format(event);
+	tep_free_event(event);
 	return ret;
 }
=20
@@ -6807,7 +6807,7 @@ static void free_formats(struct tep_format *format)
 	free_format_fields(format->fields);
 }
=20
-void tep_free_format(struct tep_event *event)
+void tep_free_event(struct tep_event *event)
 {
 	free(event->name);
 	free(event->system);
@@ -6893,7 +6893,7 @@ void tep_free(struct tep_handle *pevent)
 	}
=20
 	for (i =3D 0; i < pevent->nr_events; i++)
-		tep_free_format(pevent->events[i]);
+		tep_free_event(pevent->events[i]);
=20
 	while (pevent->handlers) {
 		handle =3D pevent->handlers;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/even=
t-parse.h
index 00b696efd671..16131e006cfe 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -477,7 +477,7 @@ enum tep_errno tep_parse_format(struct tep_handle *peve=
nt,
 				struct tep_event **eventp,
 				const char *buf,
 				unsigned long size, const char *sys);
-void tep_free_format(struct tep_event *event);
+void tep_free_event(struct tep_event *event);
 void tep_free_format_field(struct tep_format_field *field);
=20
 void *tep_get_field_raw(struct trace_seq *s, struct tep_event *event,
--=20
2.17.2
