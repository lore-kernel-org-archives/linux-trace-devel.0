Return-Path: <SRS0=YO3e=OC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr720041.outbound.protection.outlook.com ([40.107.72.41]:43424
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394909AbeKXA0L (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Nov 2018 19:26:11 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 2/3] tools/lib/traceevent: Changed return logic of
 tep_register_event_handler() API
Date: Fri, 23 Nov 2018 13:40:01 +0000
Message-ID: <20181123133946.16239-3-tstoyanov@vmware.com>
References: <20181123133946.16239-1-tstoyanov@vmware.com>
In-Reply-To: <20181123133946.16239-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, its API
should be straightforward. The tep_register_event_handler()
functions returns -1 in case it successfully registers the
new event handler. Such return code is used by the other library
APIs in case of an error. To unify the return logic of
tep_register_event_handler() with the other APIs, this patch
introduces enum tep_reg_handler, which is used by this function
as return value, to handle all possible successful return cases.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-reg_event_handler.txt              | 12 +++++++++---
 tools/lib/traceevent/event-parse.c                   | 10 ++++++++--
 tools/lib/traceevent/event-parse.h                   |  5 +++++
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_event_han=
dler.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handl=
er.txt
index 1a9269039f6c..ee9aa3a4151b 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.tx=
t
+++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.tx=
t
@@ -12,6 +12,11 @@ SYNOPSIS
 --
 *#include <event-parse.h>*
=20
+enum *tep_reg_handler* {
+	_TEP_REGISTER_SUCCESS_,
+	_TEP_REGISTER_SUCCESS_OVERWRITE_,
+};
+
 int *tep_register_event_handler*(struct tep_handle pass:[*]_tep_, int _id_=
, const char pass:[*]_sys_name_, const char pass:[*]_event_name_, tep_event=
_handler_func _func_, void pass:[*]_context_);
 int *tep_unregister_event_handler*(struct tep_handle pass:[*]tep, int id, =
const char pass:[*]sys_name, const char pass:[*]event_name, tep_event_handl=
er_func func, void pass:[*]_context_);
=20
@@ -48,9 +53,10 @@ _context_ is custom context, set when the custom event h=
andler is registered.
 =20
 RETURN VALUE
 ------------
-The _tep_register_event_handler()_ function returns 0 in case of success.=
=20
-If there is not  enough memory to complete the registration,=20
-TEP_ERRNO__MEM_ALLOC_FAILED is returned.=20
+The _tep_register_event_handler()_ function returns _TEP_REGISTER_SUCCESS_
+if the new handler is registered successfully or _TEP_REGISTER_SUCCESS_OVE=
RWRITE_ if
+an existing handler is overwritten. If there is not  enough memory to comp=
lete=20
+the registration, TEP_ERRNO__MEM_ALLOC_FAILED is returned.=20
=20
 The _tep_unregister_event_handler()_ function returns 0 if _func_ was remo=
ved=20
 successful or, -1 if the event was not found.
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index 2970358b4c10..a5048c1b9bec 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -6624,6 +6624,12 @@ static struct tep_event *search_event(struct tep_han=
dle *pevent, int id,
  *
  * If @id is >=3D 0, then it is used to find the event.
  * else @sys_name and @event_name are used.
+ *
+ * Returns:
+ *  TEP_REGISTER_SUCCESS_OVERWRITE if an existing handler is overwritten
+ *  TEP_REGISTER_SUCCESS if a new handler is registered successfully
+ *  negative TEP_ERRNO_... in case of an error
+ *
  */
 int tep_register_event_handler(struct tep_handle *pevent, int id,
 			       const char *sys_name, const char *event_name,
@@ -6641,7 +6647,7 @@ int tep_register_event_handler(struct tep_handle *pev=
ent, int id,
=20
 	event->handler =3D func;
 	event->context =3D context;
-	return 0;
+	return TEP_REGISTER_SUCCESS_OVERWRITE;
=20
  not_found:
 	/* Save for later use. */
@@ -6671,7 +6677,7 @@ int tep_register_event_handler(struct tep_handle *pev=
ent, int id,
 	pevent->handlers =3D handle;
 	handle->context =3D context;
=20
-	return -1;
+	return TEP_REGISTER_SUCCESS;
 }
=20
 static int handle_matches(struct event_handler *handler, int id,
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/even=
t-parse.h
index c6bdebf0a0ed..e5bdce43b3b4 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -484,6 +484,11 @@ int tep_print_func_field(struct trace_seq *s, const ch=
ar *fmt,
 			 struct tep_event *event, const char *name,
 			 struct tep_record *record, int err);
=20
+enum tep_reg_handler {
+	TEP_REGISTER_SUCCESS =3D 0,
+	TEP_REGISTER_SUCCESS_OVERWRITE,
+};
+
 int tep_register_event_handler(struct tep_handle *pevent, int id,
 			       const char *sys_name, const char *event_name,
 			       tep_event_handler_func func, void *context);
--=20
2.19.1
