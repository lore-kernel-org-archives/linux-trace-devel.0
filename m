Return-Path: <SRS0=ZRv/=OO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710071.outbound.protection.outlook.com ([40.107.71.71]:23480
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727195AbeLEJVw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Dec 2018 04:21:52 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 3/6] tools lib traceevent: Rename tep_free_format() to
 tep_free_event()
Date: Wed, 5 Dec 2018 09:21:50 +0000
Message-ID: <20181205092134.2214-4-tstoyanov@vmware.com>
References: <20181205092134.2214-1-tstoyanov@vmware.com>
In-Reply-To: <20181205092134.2214-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. This renames tep_free_format() to tep_free_event(), which
describes more closely the purpose of the function.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20181130154647.591673556@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h | 2 +-
 lib/traceevent/event-parse.c     | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-pa=
rse.h
index 4252ff1..a388d72 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -464,7 +464,7 @@ enum tep_errno tep_parse_format(struct tep_handle *peve=
nt,
 				struct tep_event **eventp,
 				const char *buf,
 				unsigned long size, const char *sys);
-void tep_free_format(struct tep_event *event);
+void tep_free_event(struct tep_event *event);
 void tep_free_format_field(struct tep_format_field *field);
=20
 void *tep_get_field_raw(struct trace_seq *s, struct tep_event *event,
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index d0072b0..3c3e19b 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -6156,7 +6156,7 @@ __parse_event(struct tep_handle *pevent,
 	return 0;
=20
 event_add_failed:
-	tep_free_format(event);
+	tep_free_event(event);
 	return ret;
 }
=20
@@ -6794,7 +6794,7 @@ static void free_formats(struct tep_format *format)
 	free_format_fields(format->fields);
 }
=20
-void tep_free_format(struct tep_event *event)
+void tep_free_event(struct tep_event *event)
 {
 	free(event->name);
 	free(event->system);
@@ -6880,7 +6880,7 @@ void tep_free(struct tep_handle *pevent)
 	}
=20
 	for (i =3D 0; i < pevent->nr_events; i++)
-		tep_free_format(pevent->events[i]);
+		tep_free_event(pevent->events[i]);
=20
 	while (pevent->handlers) {
 		handle =3D pevent->handlers;
--=20
2.19.2
