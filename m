Return-Path: <SRS0=XLZm=MI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730058.outbound.protection.outlook.com ([40.107.73.58]:63673
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726315AbeIZScR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Sep 2018 14:32:17 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 15/16] tools lib traceevent: Rename data2host*() APIs
Date: Wed, 26 Sep 2018 15:18:31 +0300
Message-Id: <20180926121832.16101-16-tstoyanov@vmware.com>
In-Reply-To: <20180926121832.16101-1-tstoyanov@vmware.com>
References: <20180926121832.16101-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This renames data2host*() APIs

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lkml.kernel.org/r/20180919185724.751088939@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h | 14 +++++++-------
 lib/trace-cmd/trace-input.c      | 14 +++++++-------
 lib/traceevent/event-parse.c     | 10 +++++-----
 tracecmd/trace-output.c          |  6 +++---
 tracecmd/trace-split.c           | 12 ++++++------
 5 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 1e36cba..edb468d 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -484,7 +484,7 @@ static inline void tep_set_flag(struct tep_handle *pevent, int flag)
 }
 
 static inline unsigned short
-__data2host2(struct tep_handle *pevent, unsigned short data)
+__tep_data2host2(struct tep_handle *pevent, unsigned short data)
 {
 	unsigned short swap;
 
@@ -498,7 +498,7 @@ __data2host2(struct tep_handle *pevent, unsigned short data)
 }
 
 static inline unsigned int
-__data2host4(struct tep_handle *pevent, unsigned int data)
+__tep_data2host4(struct tep_handle *pevent, unsigned int data)
 {
 	unsigned int swap;
 
@@ -514,7 +514,7 @@ __data2host4(struct tep_handle *pevent, unsigned int data)
 }
 
 static inline unsigned long long
-__data2host8(struct tep_handle *pevent, unsigned long long data)
+__tep_data2host8(struct tep_handle *pevent, unsigned long long data)
 {
 	unsigned long long swap;
 
@@ -533,14 +533,14 @@ __data2host8(struct tep_handle *pevent, unsigned long long data)
 	return swap;
 }
 
-#define data2host2(pevent, ptr)		__data2host2(pevent, *(unsigned short *)(ptr))
-#define data2host4(pevent, ptr)		__data2host4(pevent, *(unsigned int *)(ptr))
-#define data2host8(pevent, ptr)					\
+#define tep_data2host2(pevent, ptr)		__tep_data2host2(pevent, *(unsigned short *)(ptr))
+#define tep_data2host4(pevent, ptr)		__tep_data2host4(pevent, *(unsigned int *)(ptr))
+#define tep_data2host8(pevent, ptr)					\
 ({								\
 	unsigned long long __val;				\
 								\
 	memcpy(&__val, (ptr), sizeof(unsigned long long));	\
-	__data2host8(pevent, __val);				\
+	__tep_data2host8(pevent, __val);				\
 })
 
 static inline int tep_host_bigendian(void)
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a37a1b7..0395efc 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -294,7 +294,7 @@ static int read4(struct tracecmd_input *handle, unsigned int *size)
 	if (do_read_check(handle, &data, 4))
 		return -1;
 
-	*size = __data2host4(pevent, data);
+	*size = __tep_data2host4(pevent, data);
 	return 0;
 }
 
@@ -306,7 +306,7 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
 	if (do_read_check(handle, &data, 8))
 		return -1;
 
-	*size = __data2host8(pevent, data);
+	*size = __tep_data2host8(pevent, data);
 	return 0;
 }
 
@@ -2128,7 +2128,7 @@ static int handle_options(struct tracecmd_input *handle)
 		/* next 4 bytes is the size of the option */
 		if (do_read_check(handle, &size, 4))
 			return -1;
-		size = __data2host4(handle->pevent, size);
+		size = __tep_data2host4(handle->pevent, size);
 		buf = malloc(size);
 		if (!buf)
 			return -ENOMEM;
@@ -2184,7 +2184,7 @@ static int handle_options(struct tracecmd_input *handle)
 				return -ENOMEM;
 			}
 			offset = *(unsigned long long *)buf;
-			buffer->offset = __data2host8(handle->pevent, offset);
+			buffer->offset = __tep_data2host8(handle->pevent, offset);
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			if (!handle->ts2secs)
@@ -2200,7 +2200,7 @@ static int handle_options(struct tracecmd_input *handle)
 			break;
 		case TRACECMD_OPTION_CPUCOUNT:
 			cpus = *(int *)buf;
-			handle->cpus = __data2host4(handle->pevent, cpus);
+			handle->cpus = __tep_data2host4(handle->pevent, cpus);
 			break;
 		default:
 			warning("unknown option %d", option);
@@ -2818,7 +2818,7 @@ static int read_copy_size8(struct tracecmd_input *handle, int fd, unsigned long
 	if (__do_write_check(fd, size, 8))
 		return -1;
 
-	*size = __data2host8(handle->pevent, *size);
+	*size = __tep_data2host8(handle->pevent, *size);
 	return 0;
 }
 
@@ -2831,7 +2831,7 @@ static int read_copy_size4(struct tracecmd_input *handle, int fd, unsigned int *
 	if (__do_write_check(fd, size, 4))
 		return -1;
 
-	*size = __data2host4(handle->pevent, *size);
+	*size = __tep_data2host4(handle->pevent, *size);
 	return 0;
 }
 
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 055bee7..7980fc6 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -3331,11 +3331,11 @@ unsigned long long tep_read_number(struct tep_handle *pevent,
 	case 1:
 		return *(unsigned char *)ptr;
 	case 2:
-		return data2host2(pevent, ptr);
+		return tep_data2host2(pevent, ptr);
 	case 4:
-		return data2host4(pevent, ptr);
+		return tep_data2host4(pevent, ptr);
 	case 8:
-		return data2host8(pevent, ptr);
+		return tep_data2host8(pevent, ptr);
 	default:
 		/* BUG! */
 		return 0;
@@ -4061,7 +4061,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			f = tep_find_any_field(event, arg->string.string);
 			arg->string.offset = f->offset;
 		}
-		str_offset = data2host4(pevent, data + arg->string.offset);
+		str_offset = tep_data2host4(pevent, data + arg->string.offset);
 		str_offset &= 0xffff;
 		print_str_to_seq(s, format, len_arg, ((char *)data) + str_offset);
 		break;
@@ -4079,7 +4079,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			f = tep_find_any_field(event, arg->bitmask.bitmask);
 			arg->bitmask.offset = f->offset;
 		}
-		bitmask_offset = data2host4(pevent, data + arg->bitmask.offset);
+		bitmask_offset = tep_data2host4(pevent, data + arg->bitmask.offset);
 		bitmask_size = bitmask_offset >> 16;
 		bitmask_offset &= 0xffff;
 		print_bitmask_to_seq(pevent, s, format, len_arg,
diff --git a/tracecmd/trace-output.c b/tracecmd/trace-output.c
index ff7b198..a9d7d6e 100644
--- a/tracecmd/trace-output.c
+++ b/tracecmd/trace-output.c
@@ -85,7 +85,7 @@ static short convert_endian_2(struct tracecmd_output *handle, short val)
 	if (!handle->pevent)
 		return val;
 
-	return __data2host2(handle->pevent, val);
+	return __tep_data2host2(handle->pevent, val);
 }
 
 static int convert_endian_4(struct tracecmd_output *handle, int val)
@@ -93,7 +93,7 @@ static int convert_endian_4(struct tracecmd_output *handle, int val)
 	if (!handle->pevent)
 		return val;
 
-	return __data2host4(handle->pevent, val);
+	return __tep_data2host4(handle->pevent, val);
 }
 
 static unsigned long long convert_endian_8(struct tracecmd_output *handle,
@@ -102,7 +102,7 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
 	if (!handle->pevent)
 		return val;
 
-	return __data2host8(handle->pevent, val);
+	return __tep_data2host8(handle->pevent, val);
 }
 
 void tracecmd_output_free(struct tracecmd_output *handle)
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index cabcc3d..ea76c5b 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -70,7 +70,7 @@ static int create_type_len(struct tep_handle *pevent, int time, int len)
 	else
 		time = (time << 5) | len;
 
-	return __data2host4(pevent, time);
+	return __tep_data2host4(pevent, time);
 }
 
 static int write_record(struct tracecmd_input *handle,
@@ -101,7 +101,7 @@ static int write_record(struct tracecmd_input *handle,
 		*(unsigned *)ptr = time;
 		ptr += 4;
 		time = (unsigned int)(diff >> 27);
-		*(unsigned *)ptr = __data2host4(pevent, time);
+		*(unsigned *)ptr = __tep_data2host4(pevent, time);
 		cpu_data->ts = record->ts;
 		cpu_data->index += 8;
 		return 0;
@@ -123,7 +123,7 @@ static int write_record(struct tracecmd_input *handle,
 
 	if (!len) {
 		len = record->size + 4;
-		*(unsigned *)ptr = __data2host4(pevent, len);
+		*(unsigned *)ptr = __tep_data2host4(pevent, len);
 		ptr += 4;
 		index += 4;
 	}
@@ -144,10 +144,10 @@ static void write_page(struct tep_handle *pevent,
 {
 	if (long_size == 8)
 		*(unsigned long long *)cpu_data->commit =
-			__data2host8(pevent, (unsigned long long)cpu_data->index - 16);
+			__tep_data2host8(pevent, (unsigned long long)cpu_data->index - 16);
 	else
 		*(unsigned int *)cpu_data->commit =
-			__data2host4(pevent, cpu_data->index - 12);
+			__tep_data2host4(pevent, cpu_data->index - 12);
 	write(cpu_data->fd, cpu_data->page, page_size);
 }
 
@@ -240,7 +240,7 @@ static int parse_cpu(struct tracecmd_input *handle,
 			ptr = cpu_data[cpu].page;
 
 			*(unsigned long long*)ptr =
-				__data2host8(pevent, record->ts);
+				__tep_data2host8(pevent, record->ts);
 			cpu_data[cpu].ts = record->ts;
 			ptr += 8;
 			cpu_data[cpu].commit = ptr;
-- 
2.17.1
