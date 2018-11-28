Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790052.outbound.protection.outlook.com ([40.107.79.52]:55564
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727883AbeK1UIw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 15:08:52 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 12/15] tools/lib/traceevent: Changed return logic of
 tep_register_event_handler() API
Date: Wed, 28 Nov 2018 09:07:43 +0000
Message-ID: <20181128090711.17792-13-tstoyanov@vmware.com>
References: <20181128090711.17792-1-tstoyanov@vmware.com>
In-Reply-To: <20181128090711.17792-1-tstoyanov@vmware.com>
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
 tools/lib/traceevent/event-parse.c | 10 ++++++++--
 tools/lib/traceevent/event-parse.h |  5 +++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index af502b970dd9..7b26b9e3a4ba 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -6675,6 +6675,12 @@ static struct tep_event *search_event(struct tep_han=
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
@@ -6692,7 +6698,7 @@ int tep_register_event_handler(struct tep_handle *pev=
ent, int id,
=20
 	event->handler =3D func;
 	event->context =3D context;
-	return 0;
+	return TEP_REGISTER_SUCCESS_OVERWRITE;
=20
  not_found:
 	/* Save for later use. */
@@ -6722,7 +6728,7 @@ int tep_register_event_handler(struct tep_handle *pev=
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
index 15f421428fce..abe6251cf473 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -485,6 +485,11 @@ int tep_print_func_field(struct trace_seq *s, const ch=
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
