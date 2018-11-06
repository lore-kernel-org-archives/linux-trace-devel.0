Return-Path: <SRS0=lo60=NR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700041.outbound.protection.outlook.com ([40.107.70.41]:46080
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387704AbeKFWLZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Nov 2018 17:11:25 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tools/lib/traceevent, tools/perf: traceevent API cleanup
Date: Tue, 6 Nov 2018 12:46:13 +0000
Message-ID: <20181106124600.1104-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, its API
should be straightforward. This patch hides few API functions,
intended for internal usage only:
tep_free_event(), tep_free_format_field(), __tep_data2host2(),
__tep_data2host4() and __tep_data2host8().

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c   | 27 +++++++++++++++---------
 tools/lib/traceevent/event-parse-local.h |  8 +++++++
 tools/lib/traceevent/event-parse.c       | 13 +++++++-----
 tools/lib/traceevent/event-parse.h       | 20 +-----------------
 tools/perf/util/trace-event-read.c       |  5 +++--
 5 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/=
event-parse-api.c
index 52188921cfe3..6a1899b378b1 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -51,7 +51,7 @@ void tep_set_flag(struct tep_handle *tep, int flag)
 		tep->flags |=3D flag;
 }
=20
-unsigned short __tep_data2host2(struct tep_handle *pevent, unsigned short =
data)
+unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short da=
ta)
 {
 	unsigned short swap;
=20
@@ -64,7 +64,7 @@ unsigned short __tep_data2host2(struct tep_handle *pevent=
, unsigned short data)
 	return swap;
 }
=20
-unsigned int __tep_data2host4(struct tep_handle *pevent, unsigned int data=
)
+unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data)
 {
 	unsigned int swap;
=20
@@ -80,7 +80,7 @@ unsigned int __tep_data2host4(struct tep_handle *pevent, =
unsigned int data)
 }
=20
 unsigned long long
-__tep_data2host8(struct tep_handle *pevent, unsigned long long data)
+tep_data2host8(struct tep_handle *pevent, unsigned long long data)
 {
 	unsigned long long swap;
=20
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
diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceeven=
t/event-parse-local.h
index 94746efef433..288252bc329b 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -89,4 +89,12 @@ struct tep_handle {
 	char *trace_clock;
 };
=20
+void tep_free_event(struct tep_event *event);
+void tep_free_format_field(struct tep_format_field *field);
+
+unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short da=
ta);
+unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data);
+unsigned long long
+tep_data2host8(struct tep_handle *pevent, unsigned long long data);
+
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index 73347e2ef81d..4e768357a30d 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3343,15 +3343,18 @@ tep_find_any_field(struct tep_event *event, const c=
har *name)
 unsigned long long tep_read_number(struct tep_handle *pevent,
 				   const void *ptr, int size)
 {
+	unsigned long long val;
+
 	switch (size) {
 	case 1:
 		return *(unsigned char *)ptr;
 	case 2:
-		return tep_data2host2(pevent, ptr);
+		return tep_data2host2(pevent, *(unsigned short *)ptr);
 	case 4:
-		return tep_data2host4(pevent, ptr);
+		return tep_data2host4(pevent, *(unsigned int *)ptr);
 	case 8:
-		return tep_data2host8(pevent, ptr);
+		memcpy(&val, (ptr), sizeof(unsigned long long));
+		return tep_data2host8(pevent, val);
 	default:
 		/* BUG! */
 		return 0;
@@ -4077,7 +4080,7 @@ static void print_str_arg(struct trace_seq *s, void *=
data, int size,
 			f =3D tep_find_any_field(event, arg->string.string);
 			arg->string.offset =3D f->offset;
 		}
-		str_offset =3D tep_data2host4(pevent, data + arg->string.offset);
+		str_offset =3D tep_data2host4(pevent, *(unsigned int *)(data + arg->stri=
ng.offset));
 		str_offset &=3D 0xffff;
 		print_str_to_seq(s, format, len_arg, ((char *)data) + str_offset);
 		break;
@@ -4095,7 +4098,7 @@ static void print_str_arg(struct trace_seq *s, void *=
data, int size,
 			f =3D tep_find_any_field(event, arg->bitmask.bitmask);
 			arg->bitmask.offset =3D f->offset;
 		}
-		bitmask_offset =3D tep_data2host4(pevent, data + arg->bitmask.offset);
+		bitmask_offset =3D tep_data2host4(pevent, *(unsigned int *)(data + arg->=
bitmask.offset));
 		bitmask_size =3D bitmask_offset >> 16;
 		bitmask_offset &=3D 0xffff;
 		print_bitmask_to_seq(pevent, s, format, len_arg,
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/even=
t-parse.h
index 16131e006cfe..eb0d5d2471a1 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -334,7 +334,7 @@ enum tep_func_arg_type {
 enum tep_flag {
 	TEP_NSEC_OUTPUT		=3D 1,	/* output in NSECS */
 	TEP_DISABLE_SYS_PLUGINS	=3D 1 << 1,
-	TEP_DISABLE_PLUGINS	=3D 1 << 2,
+	TEP_DISABLE_PLUGINS	=3D 1 << 2
 };
=20
 #define TEP_ERRORS 							      \
@@ -409,22 +409,6 @@ void tep_print_plugins(struct trace_seq *s,
 typedef char *(tep_func_resolver_t)(void *priv,
 				    unsigned long long *addrp, char **modp);
 void tep_set_flag(struct tep_handle *tep, int flag);
-unsigned short __tep_data2host2(struct tep_handle *pevent, unsigned short =
data);
-unsigned int __tep_data2host4(struct tep_handle *pevent, unsigned int data=
);
-unsigned long long
-__tep_data2host8(struct tep_handle *pevent, unsigned long long data);
-
-#define tep_data2host2(pevent, ptr)	\
-	__tep_data2host2(pevent, *(unsigned short *)(ptr))
-#define tep_data2host4(pevent, ptr)	\
-	__tep_data2host4(pevent, *(unsigned int *)(ptr))
-#define tep_data2host8(pevent, ptr)	\
-({								\
-	unsigned long long __val;				\
-								\
-	memcpy(&__val, (ptr), sizeof(unsigned long long));	\
-	__tep_data2host8(pevent, __val);			\
-})
=20
 static inline int tep_host_bigendian(void)
 {
@@ -477,8 +461,6 @@ enum tep_errno tep_parse_format(struct tep_handle *peve=
nt,
 				struct tep_event **eventp,
 				const char *buf,
 				unsigned long size, const char *sys);
-void tep_free_event(struct tep_event *event);
-void tep_free_format_field(struct tep_format_field *field);
=20
 void *tep_get_field_raw(struct trace_seq *s, struct tep_event *event,
 			const char *name, struct tep_record *record,
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-eve=
nt-read.c
index cdf6de82a507..3dca624399aa 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -102,7 +102,7 @@ static unsigned int read4(struct tep_handle *pevent)
=20
 	if (do_read(&data, 4) < 0)
 		return 0;
-	return __tep_data2host4(pevent, data);
+	return tep_read_number(pevent, &data, 4);
 }
=20
 static unsigned long long read8(struct tep_handle *pevent)
@@ -111,7 +111,8 @@ static unsigned long long read8(struct tep_handle *peve=
nt)
=20
 	if (do_read(&data, 8) < 0)
 		return 0;
-	return __tep_data2host8(pevent, data);
+	return tep_read_number(pevent, &data, 8);
+
 }
=20
 static char *read_string(void)
--=20
2.17.2
