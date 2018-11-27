Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700067.outbound.protection.outlook.com ([40.107.70.67]:39904
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726381AbeK1Cju (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:39:50 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 14/14] tools/lib/traceevent: Change description of few APIs
Date: Tue, 27 Nov 2018 15:41:10 +0000
Message-ID: <20181127154038.11175-15-tstoyanov@vmware.com>
References: <20181127154038.11175-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154038.11175-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

APIs descriptions should describe the purpose of the
function, its parameters and return value. While working
on man pages implementation, I noticed mismatches in the
descriptions of few APIs. This patch changes the description
of these APIs, making them consistent with the man pages:
tep_print_num_field(), tep_print_func_field(),
tep_get_header_page_size(), tep_get_long_size(),
tep_set_long_size(), tep_get_page_size() and
tep_set_page_size().

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c | 25 ++++++++++++++++---------
 tools/lib/traceevent/event-parse.c     |  4 ++--
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/=
event-parse-api.c
index d4368dcc16ea..884b8585d22e 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -100,10 +100,10 @@ tep_data2host8(struct tep_handle *pevent, unsigned lo=
ng long data)
 }
=20
 /**
- * tep_get_header_page_size - get size of the header page
+ * tep_get_header_page_size - get the size of a long integer, in kernel co=
ntext
  * @pevent: a handle to the tep_handle
  *
- * This returns size of the header page
+ * This returns the size of a long integer, in kernel context
  * If @pevent is NULL, 0 is returned.
  */
 int tep_get_header_page_size(struct tep_handle *pevent)
@@ -140,10 +140,12 @@ void tep_set_cpus(struct tep_handle *pevent, int cpus=
)
 }
=20
 /**
- * tep_get_long_size - get the size of a long integer on the current machi=
ne
+ * tep_get_long_size - get the size of a long integer on the machine,
+ * 		       where the trace is generated
  * @pevent: a handle to the tep_handle
  *
- * This returns the size of a long integer on the current machine
+ * This returns the size of a long integer on the machine,
+ * where the trace is generated
  * If @pevent is NULL, 0 is returned.
  */
 int tep_get_long_size(struct tep_handle *pevent)
@@ -154,7 +156,8 @@ int tep_get_long_size(struct tep_handle *pevent)
 }
=20
 /**
- * tep_set_long_size - set the size of a long integer on the current machi=
ne
+ * tep_set_long_size - set the size of a long integer on the machine,
+ * 			where the trace is generated
  * @pevent: a handle to the tep_handle
  * @size: size, in bytes, of a long integer
  *
@@ -167,10 +170,12 @@ void tep_set_long_size(struct tep_handle *pevent, int=
 long_size)
 }
=20
 /**
- * tep_get_page_size - get the size of a memory page on the current machin=
e
+ * tep_get_page_size - get the size of a memory page on the machine,
+ * 			where the trace is generated
  * @pevent: a handle to the tep_handle
  *
- * This returns the size of a memory page on the current machine
+ * This returns the size of a memory page on the machine,
+ * where the trace is generated
  * If @pevent is NULL, 0 is returned.
  */
 int tep_get_page_size(struct tep_handle *pevent)
@@ -181,11 +186,13 @@ int tep_get_page_size(struct tep_handle *pevent)
 }
=20
 /**
- * tep_set_page_size - set the size of a memory page on the current machin=
e
+ * tep_set_page_size - set the size of a memory page on the machine,
+ * 			where the trace is generated
  * @pevent: a handle to the tep_handle
  * @_page_size: size of a memory page, in bytes
  *
- * This sets the size of a memory page on the current machine
+ * This sets the size of a memory page on the machine,
+ * where the trace is generated
  */
 void tep_set_page_size(struct tep_handle *pevent, int _page_size)
 {
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index 947ba9ff27a5..854b68ef2e4e 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -6429,7 +6429,7 @@ int tep_get_any_field_val(struct trace_seq *s, struct=
 tep_event *event,
  * @record: The record with the field name.
  * @err: print default error if failed.
  *
- * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
+ * Returns: 1 on success, -1 field not found, or 0 if buffer is full.
  */
 int tep_print_num_field(struct trace_seq *s, const char *fmt,
 			struct tep_event *event, const char *name,
@@ -6461,7 +6461,7 @@ int tep_print_num_field(struct trace_seq *s, const ch=
ar *fmt,
  * @record: The record with the field name.
  * @err: print default error if failed.
  *
- * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
+ * Returns: 1 on success, -1 field not found, or 0 if buffer is full.
  */
 int tep_print_func_field(struct trace_seq *s, const char *fmt,
 			 struct tep_event *event, const char *name,
--=20
2.19.1
