Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700058.outbound.protection.outlook.com ([40.107.70.58]:36480
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726381AbeK1Cj3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:39:29 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 07/14] tools/lib/traceevent: traceevent API cleanup
Date: Tue, 27 Nov 2018 15:41:01 +0000
Message-ID: <20181127154038.11175-8-tstoyanov@vmware.com>
References: <20181127154038.11175-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154038.11175-1-tstoyanov@vmware.com>
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
The patch also alignes the libtraceevent summary man page with
these API changes.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c   |  6 +++---
 tools/lib/traceevent/event-parse-local.h |  7 +++++++
 tools/lib/traceevent/event-parse.c       | 13 ++++++++-----
 tools/lib/traceevent/event-parse.h       | 18 ------------------
 4 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/=
event-parse-api.c
index 52188921cfe3..bdefe3c235ad 100644
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
diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceeven=
t/event-parse-local.h
index 94746efef433..9a092dd4a86d 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -89,4 +89,11 @@ struct tep_handle {
 	char *trace_clock;
 };
=20
+void tep_free_event(struct tep_event *event);
+void tep_free_format_field(struct tep_format_field *field);
+
+unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short da=
ta);
+unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data);
+unsigned long long tep_data2host8(struct tep_handle *pevent, unsigned long=
 long data);
+
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/even=
t-parse.c
index 7140b845e20f..668bc5e2805f 100644
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
index 0c8548bf234c..4e0602522c28 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
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
--=20
2.19.1
