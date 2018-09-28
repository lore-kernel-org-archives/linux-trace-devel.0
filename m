Return-Path: <SRS0=W9qh=MK=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0069.outbound.protection.outlook.com ([104.47.36.69]:51628
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728739AbeI1NoO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Sep 2018 09:44:14 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] tools/lib/traceevent: Implemented new API tep_ref_get()
Date: Fri, 28 Sep 2018 10:19:38 +0300
Message-Id: <20180928071940.29810-2-tstoyanov@vmware.com>
In-Reply-To: <20180928071940.29810-1-tstoyanov@vmware.com>
References: <20180928071940.29810-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch implements new API of the tracevent library:
int tep_ref_get(struct tep_handle *pevent);
The API returns the reference counter "ref_count" of the tep handler.
As "struct tep_handle" is internal only, its members cannot be accessed
by the library users, the API is used to get the reference counter.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse.c | 7 +++++++
 tools/lib/traceevent/event-parse.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f327c990dedc..aa26d0e7c074 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -6774,6 +6774,13 @@ void tep_ref(struct tep_handle *pevent)
 	pevent->ref_count++;
 }
 
+int tep_ref_get(struct tep_handle *pevent)
+{
+	if (pevent)
+		return pevent->ref_count;
+	return 0;
+}
+
 void tep_free_format_field(struct tep_format_field *field)
 {
 	free(field->type);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 100b0b7b29fc..cda21a67160e 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -577,6 +577,7 @@ struct tep_handle *tep_alloc(void);
 void tep_free(struct tep_handle *pevent);
 void tep_ref(struct tep_handle *pevent);
 void tep_unref(struct tep_handle *pevent);
+int tep_ref_get(struct tep_handle *pevent);
 
 /* access to the internal parser */
 void tep_buffer_init(const char *buf, unsigned long long size);
-- 
2.17.1
