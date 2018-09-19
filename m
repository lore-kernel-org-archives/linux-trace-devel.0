Return-Path: <SRS0=cF1r=MB=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387697AbeITAgl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Sep 2018 20:36:41 -0400
Message-Id: <20180919185724.751088939@goodmis.org>
Date: Wed, 19 Sep 2018 14:56:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH 14/15] tools/lib/traceevent: Rename data2host*() APIs
References: <20180919185643.358126338@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, variables, data
structures and functions require a unique prefix to prevent name space
conflicts. That prefix will be "tep_". This renames data2host*() APIs

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 10 +++++-----
 tools/lib/traceevent/event-parse.h | 14 +++++++-------
 tools/perf/util/trace-event-read.c |  4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 055bee7b738a..7980fc6c3bac 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
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
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 2a7b0a857f39..830147dc6b21 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -496,7 +496,7 @@ static inline void tep_set_flag(struct tep_handle *pevent, int flag)
 }
 
 static inline unsigned short
-__data2host2(struct tep_handle *pevent, unsigned short data)
+__tep_data2host2(struct tep_handle *pevent, unsigned short data)
 {
 	unsigned short swap;
 
@@ -510,7 +510,7 @@ __data2host2(struct tep_handle *pevent, unsigned short data)
 }
 
 static inline unsigned int
-__data2host4(struct tep_handle *pevent, unsigned int data)
+__tep_data2host4(struct tep_handle *pevent, unsigned int data)
 {
 	unsigned int swap;
 
@@ -526,7 +526,7 @@ __data2host4(struct tep_handle *pevent, unsigned int data)
 }
 
 static inline unsigned long long
-__data2host8(struct tep_handle *pevent, unsigned long long data)
+__tep_data2host8(struct tep_handle *pevent, unsigned long long data)
 {
 	unsigned long long swap;
 
@@ -545,14 +545,14 @@ __data2host8(struct tep_handle *pevent, unsigned long long data)
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
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 3dfc1db6b25b..b98ee2a2eb44 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -102,7 +102,7 @@ static unsigned int read4(struct tep_handle *pevent)
 
 	if (do_read(&data, 4) < 0)
 		return 0;
-	return __data2host4(pevent, data);
+	return __tep_data2host4(pevent, data);
 }
 
 static unsigned long long read8(struct tep_handle *pevent)
@@ -111,7 +111,7 @@ static unsigned long long read8(struct tep_handle *pevent)
 
 	if (do_read(&data, 8) < 0)
 		return 0;
-	return __data2host8(pevent, data);
+	return __tep_data2host8(pevent, data);
 }
 
 static char *read_string(void)
-- 
2.18.0
