Return-Path: <SRS0=ZRv/=OO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710054.outbound.protection.outlook.com ([40.107.71.54]:10064
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727195AbeLEJVz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Dec 2018 04:21:55 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 4/6] tools lib traceevent: traceevent API cleanup
Date: Wed, 5 Dec 2018 09:21:51 +0000
Message-ID: <20181205092134.2214-5-tstoyanov@vmware.com>
References: <20181205092134.2214-1-tstoyanov@vmware.com>
In-Reply-To: <20181205092134.2214-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, its API should be
straightforward. This patch hides few API functions, intended for
internal usage only:

tep_free_event(), tep_free_format_field(), __tep_data2host2(),
__tep_data2host4() and __tep_data2host8().
The patch also alignes the libtraceevent summary man page with
these API changes.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20181130154647.891651290@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h   | 17 -----------------
 lib/trace-cmd/trace-input.c        | 14 +++++++-------
 lib/traceevent/event-parse-api.c   |  6 +++---
 lib/traceevent/event-parse-local.h |  7 +++++++
 lib/traceevent/event-parse.c       | 13 ++++++++-----
 tracecmd/trace-output.c            |  6 +++---
 tracecmd/trace-split.c             | 19 +++++++++++--------
 7 files changed, 39 insertions(+), 43 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-pa=
rse.h
index a388d72..3ffc26a 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -398,21 +398,6 @@ void tep_set_flag(struct tep_handle *tep, enum tep_fla=
g flag);
 void tep_reset_flag(struct tep_handle *tep, enum tep_flag flag);
 int tep_check_flag(struct tep_handle *tep, enum tep_flag flag);
=20
-unsigned short __tep_data2host2(struct tep_handle *pevent, unsigned short =
data);
-unsigned int __tep_data2host4(struct tep_handle *pevent, unsigned int data=
);
-unsigned long long
-__tep_data2host8(struct tep_handle *pevent, unsigned long long data);
-
-#define tep_data2host2(pevent, ptr)	__tep_data2host2(pevent, *(unsigned sh=
ort *)(ptr))
-#define tep_data2host4(pevent, ptr)	__tep_data2host4(pevent, *(unsigned in=
t *)(ptr))
-#define tep_data2host8(pevent, ptr)	\
-({								\
-	unsigned long long __val;				\
-								\
-	memcpy(&__val, (ptr), sizeof(unsigned long long));	\
-	__tep_data2host8(pevent, __val);				\
-})
-
 static inline int tep_host_bigendian(void)
 {
 	unsigned char str[] =3D { 0x1, 0x2, 0x3, 0x4 };
@@ -464,8 +449,6 @@ enum tep_errno tep_parse_format(struct tep_handle *peve=
nt,
 				struct tep_event **eventp,
 				const char *buf,
 				unsigned long size, const char *sys);
-void tep_free_event(struct tep_event *event);
-void tep_free_format_field(struct tep_format_field *field);
=20
 void *tep_get_field_raw(struct trace_seq *s, struct tep_event *event,
 			const char *name, struct tep_record *record,
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index d70c110..daf3440 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -294,7 +294,7 @@ static int read4(struct tracecmd_input *handle, unsigne=
d int *size)
 	if (do_read_check(handle, &data, 4))
 		return -1;
=20
-	*size =3D __tep_data2host4(pevent, data);
+	*size =3D tep_read_number(pevent, &data, 4);
 	return 0;
 }
=20
@@ -306,7 +306,7 @@ static int read8(struct tracecmd_input *handle, unsigne=
d long long *size)
 	if (do_read_check(handle, &data, 8))
 		return -1;
=20
-	*size =3D __tep_data2host8(pevent, data);
+	*size =3D tep_read_number(pevent, &data, 8);
 	return 0;
 }
=20
@@ -2128,7 +2128,7 @@ static int handle_options(struct tracecmd_input *hand=
le)
 		/* next 4 bytes is the size of the option */
 		if (do_read_check(handle, &size, 4))
 			return -1;
-		size =3D __tep_data2host4(handle->pevent, size);
+		size =3D tep_read_number(handle->pevent, &size, 4);
 		buf =3D malloc(size);
 		if (!buf)
 			return -ENOMEM;
@@ -2184,7 +2184,7 @@ static int handle_options(struct tracecmd_input *hand=
le)
 				return -ENOMEM;
 			}
 			offset =3D *(unsigned long long *)buf;
-			buffer->offset =3D __tep_data2host8(handle->pevent, offset);
+			buffer->offset =3D tep_read_number(handle->pevent, &offset, 8);
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			if (!handle->ts2secs)
@@ -2200,7 +2200,7 @@ static int handle_options(struct tracecmd_input *hand=
le)
 			break;
 		case TRACECMD_OPTION_CPUCOUNT:
 			cpus =3D *(int *)buf;
-			handle->cpus =3D __tep_data2host4(handle->pevent, cpus);
+			handle->cpus =3D tep_read_number(handle->pevent, &cpus, 4);
 			break;
 		default:
 			warning("unknown option %d", option);
@@ -2818,7 +2818,7 @@ static int read_copy_size8(struct tracecmd_input *han=
dle, int fd, unsigned long
 	if (__do_write_check(fd, size, 8))
 		return -1;
=20
-	*size =3D __tep_data2host8(handle->pevent, *size);
+	*size =3D tep_read_number(handle->pevent, size, 8);
 	return 0;
 }
=20
@@ -2831,7 +2831,7 @@ static int read_copy_size4(struct tracecmd_input *han=
dle, int fd, unsigned int *
 	if (__do_write_check(fd, size, 4))
 		return -1;
=20
-	*size =3D __tep_data2host4(handle->pevent, *size);
+	*size =3D tep_read_number(handle->pevent, size, 4);
 	return 0;
 }
=20
diff --git a/lib/traceevent/event-parse-api.c b/lib/traceevent/event-parse-=
api.c
index 6641780..347ff10 100644
--- a/lib/traceevent/event-parse-api.c
+++ b/lib/traceevent/event-parse-api.c
@@ -93,7 +93,7 @@ int tep_check_flag(struct tep_handle *tep, enum tep_flag =
flag)
 	return 0;
 }
=20
-unsigned short __tep_data2host2(struct tep_handle *pevent, unsigned short =
data)
+unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short da=
ta)
 {
 	unsigned short swap;
=20
@@ -106,7 +106,7 @@ unsigned short __tep_data2host2(struct tep_handle *peve=
nt, unsigned short data)
 	return swap;
 }
=20
-unsigned int __tep_data2host4(struct tep_handle *pevent, unsigned int data=
)
+unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data)
 {
 	unsigned int swap;
=20
@@ -122,7 +122,7 @@ unsigned int __tep_data2host4(struct tep_handle *pevent=
, unsigned int data)
 }
=20
 unsigned long long
-__tep_data2host8(struct tep_handle *pevent, unsigned long long data)
+tep_data2host8(struct tep_handle *pevent, unsigned long long data)
 {
 	unsigned long long swap;
=20
diff --git a/lib/traceevent/event-parse-local.h b/lib/traceevent/event-pars=
e-local.h
index 3198e9b..70693b8 100644
--- a/lib/traceevent/event-parse-local.h
+++ b/lib/traceevent/event-parse-local.h
@@ -91,4 +91,11 @@ struct tep_handle {
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
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 3c3e19b..bc35dc8 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -3329,15 +3329,18 @@ tep_find_any_field(struct tep_event *event, const c=
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
@@ -4063,7 +4066,7 @@ static void print_str_arg(struct trace_seq *s, void *=
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
@@ -4081,7 +4084,7 @@ static void print_str_arg(struct trace_seq *s, void *=
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
diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index 99493e6..fde385f 100644
--- a/tracecmd/trace-output.c
+++ b/tracecmd/trace-output.c
@@ -84,7 +84,7 @@ static short convert_endian_2(struct tracecmd_output *han=
dle, short val)
 	if (!handle->pevent)
 		return val;
=20
-	return __tep_data2host2(handle->pevent, val);
+	return tep_read_number(handle->pevent, &val, 2);
 }
=20
 static int convert_endian_4(struct tracecmd_output *handle, int val)
@@ -92,7 +92,7 @@ static int convert_endian_4(struct tracecmd_output *handl=
e, int val)
 	if (!handle->pevent)
 		return val;
=20
-	return __tep_data2host4(handle->pevent, val);
+	return tep_read_number(handle->pevent, &val, 4);
 }
=20
 static unsigned long long convert_endian_8(struct tracecmd_output *handle,
@@ -101,7 +101,7 @@ static unsigned long long convert_endian_8(struct trace=
cmd_output *handle,
 	if (!handle->pevent)
 		return val;
=20
-	return __tep_data2host8(handle->pevent, val);
+	return tep_read_number(handle->pevent, &val, 8);
 }
=20
 void tracecmd_output_free(struct tracecmd_output *handle)
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index f18616a..d27b3c6 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -69,7 +69,7 @@ static int create_type_len(struct tep_handle *pevent, int=
 time, int len)
 	else
 		time =3D (time << 5) | len;
=20
-	return __tep_data2host4(pevent, time);
+	return tep_read_number(pevent, &time, 4);
 }
=20
 static int write_record(struct tracecmd_input *handle,
@@ -100,7 +100,7 @@ static int write_record(struct tracecmd_input *handle,
 		*(unsigned *)ptr =3D time;
 		ptr +=3D 4;
 		time =3D (unsigned int)(diff >> 27);
-		*(unsigned *)ptr =3D __tep_data2host4(pevent, time);
+		*(unsigned *)ptr =3D tep_read_number(pevent, &time, 4);
 		cpu_data->ts =3D record->ts;
 		cpu_data->index +=3D 8;
 		return 0;
@@ -122,7 +122,7 @@ static int write_record(struct tracecmd_input *handle,
=20
 	if (!len) {
 		len =3D record->size + 4;
-		*(unsigned *)ptr =3D __tep_data2host4(pevent, len);
+		*(unsigned *)ptr =3D tep_read_number(pevent, &len, 4);
 		ptr +=3D 4;
 		index +=3D 4;
 	}
@@ -141,12 +141,15 @@ static int write_record(struct tracecmd_input *handle=
,
 static void write_page(struct tep_handle *pevent,
 		       struct cpu_data *cpu_data, int long_size)
 {
-	if (long_size =3D=3D 8)
+	if (long_size =3D=3D 8) {
+		unsigned long long index =3D cpu_data->index - 16;
 		*(unsigned long long *)cpu_data->commit =3D
-			__tep_data2host8(pevent, (unsigned long long)cpu_data->index - 16);
-	else
+				tep_read_number(pevent, &index, 8);
+	} else {
+		unsigned int index =3D cpu_data->index - 12;
 		*(unsigned int *)cpu_data->commit =3D
-			__tep_data2host4(pevent, cpu_data->index - 12);
+			tep_read_number(pevent, &index, 4);
+	}
 	write(cpu_data->fd, cpu_data->page, page_size);
 }
=20
@@ -239,7 +242,7 @@ static int parse_cpu(struct tracecmd_input *handle,
 			ptr =3D cpu_data[cpu].page;
=20
 			*(unsigned long long*)ptr =3D
-				__tep_data2host8(pevent, record->ts);
+				tep_read_number(pevent, &(record->ts), 8);
 			cpu_data[cpu].ts =3D record->ts;
 			ptr +=3D 8;
 			cpu_data[cpu].commit =3D ptr;
--=20
2.19.2
