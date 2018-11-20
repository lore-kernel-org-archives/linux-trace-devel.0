Return-Path: <SRS0=VnmA=N7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr690070.outbound.protection.outlook.com ([40.107.69.70]:20160
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726611AbeKUAj3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Nov 2018 19:39:29 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 1/3] tools/lib/traceevent: Implemented new API
 tep_get_ref()
Date: Tue, 20 Nov 2018 14:10:08 +0000
Message-ID: <20181120140953.30315-2-tstoyanov@vmware.com>
References: <20181120140953.30315-1-tstoyanov@vmware.com>
In-Reply-To: <20181120140953.30315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch implements new API of the tracevent library:
int tep_get_ref(struct tep_handle *pevent);
The API returns the reference counter "ref_count" of the tep handler.
As "struct tep_handle" is internal only, its members cannot be accessed
by the library users, the API is used to get the reference counter.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse.c | 7 +++++++
 tools/lib/traceevent/event-parse.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index f327c990dedc..c0dd72141a44 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -6774,6 +6774,13 @@ void tep_ref(struct tep_handle *pevent)
 	pevent->ref_count++;
 }
=20
+int tep_get_ref(struct tep_handle *pevent)
+{
+	if (pevent)
+		return pevent->ref_count;
+	return 0;
+}
+
 void tep_free_format_field(struct tep_format_field *field)
 {
 	free(field->type);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/even=
t-parse.h
index cacd0b9f4807..9af316862ed4 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -583,6 +583,7 @@ struct tep_handle *tep_alloc(void);
 void tep_free(struct tep_handle *pevent);
 void tep_ref(struct tep_handle *pevent);
 void tep_unref(struct tep_handle *pevent);
+int tep_get_ref(struct tep_handle *pevent);
=20
 /* access to the internal parser */
 void tep_buffer_init(const char *buf, unsigned long long size);
--=20
2.19.1
