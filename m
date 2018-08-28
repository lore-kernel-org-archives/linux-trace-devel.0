Return-Path: <SRS0=NWCu=LL=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37101 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbeH1OQN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Aug 2018 10:16:13 -0400
Received: by mail-wr1-f68.google.com with SMTP id u12-v6so1055052wrr.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Aug 2018 03:25:14 -0700 (PDT)
From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] tools lib traceevent, perf tools: Split trace-seq related APIs in a separate header file, trace-seq.h
Date: Tue, 28 Aug 2018 13:25:11 +0300
Message-Id: <20180828102511.28409-1-tz.stoyanov@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, all
its APIs should be defined in corresponding header files.
This patch splits trace-seq related APIs in a separate
header file, trace-seq.h.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c         |  1 +
 tools/lib/traceevent/event-parse.h         | 46 +-----------------
 tools/lib/traceevent/event-plugin.c        |  1 +
 tools/lib/traceevent/plugin_function.c     |  1 +
 tools/lib/traceevent/plugin_hrtimer.c      |  1 +
 tools/lib/traceevent/plugin_jbd2.c         |  1 +
 tools/lib/traceevent/plugin_kmem.c         |  1 +
 tools/lib/traceevent/plugin_kvm.c          |  1 +
 tools/lib/traceevent/plugin_mac80211.c     |  1 +
 tools/lib/traceevent/plugin_sched_switch.c |  1 +
 tools/lib/traceevent/plugin_scsi.c         |  1 +
 tools/lib/traceevent/plugin_xen.c          |  1 +
 tools/lib/traceevent/trace-seq.c           |  2 +
 tools/lib/traceevent/trace-seq.h           | 55 ++++++++++++++++++++++
 tools/perf/util/trace-event.h              |  1 +
 15 files changed, 71 insertions(+), 44 deletions(-)
 create mode 100644 tools/lib/traceevent/trace-seq.h

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index ab15b985c047..f327c990dedc 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -40,6 +40,7 @@
 
 #include "event-parse-local.h"
 #include "event-utils.h"
+#include "trace-seq.h"
 
 static const char *input_buf;
 static unsigned long long input_buf_ptr;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 90082df52505..100b0b7b29fc 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -26,17 +26,12 @@
 #include <regex.h>
 #include <string.h>
 
+#include "trace-seq.h"
+
 #ifndef __maybe_unused
 #define __maybe_unused __attribute__((unused))
 #endif
 
-/* ----------------------- trace_seq ----------------------- */
-
-
-#ifndef TRACE_SEQ_BUF_SIZE
-#define TRACE_SEQ_BUF_SIZE 4096
-#endif
-
 #ifndef DEBUG_RECORD
 #define DEBUG_RECORD 0
 #endif
@@ -59,43 +54,6 @@ struct tep_record {
 #endif
 };
 
-enum trace_seq_fail {
-	TRACE_SEQ__GOOD,
-	TRACE_SEQ__BUFFER_POISONED,
-	TRACE_SEQ__MEM_ALLOC_FAILED,
-};
-
-/*
- * Trace sequences are used to allow a function to call several other functions
- * to create a string of data to use (up to a max of PAGE_SIZE).
- */
-
-struct trace_seq {
-	char			*buffer;
-	unsigned int		buffer_size;
-	unsigned int		len;
-	unsigned int		readpos;
-	enum trace_seq_fail	state;
-};
-
-void trace_seq_init(struct trace_seq *s);
-void trace_seq_reset(struct trace_seq *s);
-void trace_seq_destroy(struct trace_seq *s);
-
-extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
-	__attribute__ ((format (printf, 2, 0)));
-
-extern int trace_seq_puts(struct trace_seq *s, const char *str);
-extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
-
-extern void trace_seq_terminate(struct trace_seq *s);
-
-extern int trace_seq_do_fprintf(struct trace_seq *s, FILE *fp);
-extern int trace_seq_do_printf(struct trace_seq *s);
-
-
 /* ----------------------- tep ----------------------- */
 
 struct tep_handle;
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index d15313dbcc8f..9a742a760ac8 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -30,6 +30,7 @@
 #include "event-parse.h"
 #include "event-parse-local.h"
 #include "event-utils.h"
+#include "trace-seq.h"
 
 #define LOCAL_PLUGIN_DIR ".traceevent/plugins"
 
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index a671396f213f..528acc75d81a 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -23,6 +23,7 @@
 
 #include "event-parse.h"
 #include "event-utils.h"
+#include "trace-seq.h"
 
 static struct func_stack {
 	int size;
diff --git a/tools/lib/traceevent/plugin_hrtimer.c b/tools/lib/traceevent/plugin_hrtimer.c
index 14eeb9b11515..9aa05b4ca811 100644
--- a/tools/lib/traceevent/plugin_hrtimer.c
+++ b/tools/lib/traceevent/plugin_hrtimer.c
@@ -23,6 +23,7 @@
 #include <string.h>
 
 #include "event-parse.h"
+#include "trace-seq.h"
 
 static int timer_expire_handler(struct trace_seq *s,
 				struct tep_record *record,
diff --git a/tools/lib/traceevent/plugin_jbd2.c b/tools/lib/traceevent/plugin_jbd2.c
index 45a9acd19640..a5e34135dd6a 100644
--- a/tools/lib/traceevent/plugin_jbd2.c
+++ b/tools/lib/traceevent/plugin_jbd2.c
@@ -22,6 +22,7 @@
 #include <string.h>
 
 #include "event-parse.h"
+#include "trace-seq.h"
 
 #define MINORBITS	20
 #define MINORMASK	((1U << MINORBITS) - 1)
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
index e40e15a52086..1beb4eaddfdf 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -22,6 +22,7 @@
 #include <string.h>
 
 #include "event-parse.h"
+#include "trace-seq.h"
 
 static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 			     struct tep_event_format *event, void *context)
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index db108d1a1207..d13c22846fa9 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -23,6 +23,7 @@
 #include <stdint.h>
 
 #include "event-parse.h"
+#include "trace-seq.h"
 
 #ifdef HAVE_UDIS86
 
diff --git a/tools/lib/traceevent/plugin_mac80211.c b/tools/lib/traceevent/plugin_mac80211.c
index d3ce41ebe400..da3855e7b86f 100644
--- a/tools/lib/traceevent/plugin_mac80211.c
+++ b/tools/lib/traceevent/plugin_mac80211.c
@@ -22,6 +22,7 @@
 #include <string.h>
 
 #include "event-parse.h"
+#include "trace-seq.h"
 
 #define INDENT 65
 
diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceevent/plugin_sched_switch.c
index 07f067b84396..77882272672f 100644
--- a/tools/lib/traceevent/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -22,6 +22,7 @@
 #include <string.h>
 
 #include "event-parse.h"
+#include "trace-seq.h"
 
 static void write_state(struct trace_seq *s, int val)
 {
diff --git a/tools/lib/traceevent/plugin_scsi.c b/tools/lib/traceevent/plugin_scsi.c
index 5ec346f6b842..4eba25cc1431 100644
--- a/tools/lib/traceevent/plugin_scsi.c
+++ b/tools/lib/traceevent/plugin_scsi.c
@@ -3,6 +3,7 @@
 #include <string.h>
 #include <inttypes.h>
 #include "event-parse.h"
+#include "trace-seq.h"
 
 typedef unsigned long sector_t;
 typedef uint64_t u64;
diff --git a/tools/lib/traceevent/plugin_xen.c b/tools/lib/traceevent/plugin_xen.c
index b2acbd6e9c86..bc0496e4c296 100644
--- a/tools/lib/traceevent/plugin_xen.c
+++ b/tools/lib/traceevent/plugin_xen.c
@@ -3,6 +3,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include "event-parse.h"
+#include "trace-seq.h"
 
 #define __HYPERVISOR_set_trap_table			0
 #define __HYPERVISOR_mmu_update				1
diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
index 292dc9f1d233..7c5cc0a57e3c 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -17,6 +17,8 @@
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
+#include "trace-seq.h"
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/tools/lib/traceevent/trace-seq.h b/tools/lib/traceevent/trace-seq.h
new file mode 100644
index 000000000000..d68ec69f8d1a
--- /dev/null
+++ b/tools/lib/traceevent/trace-seq.h
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+
+#ifndef _TRACE_SEQ_H
+#define _TRACE_SEQ_H
+
+#include <stdarg.h>
+#include <stdio.h>
+
+/* ----------------------- trace_seq ----------------------- */
+
+#ifndef TRACE_SEQ_BUF_SIZE
+#define TRACE_SEQ_BUF_SIZE 4096
+#endif
+
+enum trace_seq_fail {
+	TRACE_SEQ__GOOD,
+	TRACE_SEQ__BUFFER_POISONED,
+	TRACE_SEQ__MEM_ALLOC_FAILED,
+};
+
+/*
+ * Trace sequences are used to allow a function to call several other functions
+ * to create a string of data to use (up to a max of PAGE_SIZE).
+ */
+
+struct trace_seq {
+	char			*buffer;
+	unsigned int		buffer_size;
+	unsigned int		len;
+	unsigned int		readpos;
+	enum trace_seq_fail	state;
+};
+
+void trace_seq_init(struct trace_seq *s);
+void trace_seq_reset(struct trace_seq *s);
+void trace_seq_destroy(struct trace_seq *s);
+
+extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
+extern int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
+	__attribute__ ((format (printf, 2, 0)));
+
+extern int trace_seq_puts(struct trace_seq *s, const char *str);
+extern int trace_seq_putc(struct trace_seq *s, unsigned char c);
+
+extern void trace_seq_terminate(struct trace_seq *s);
+
+extern int trace_seq_do_fprintf(struct trace_seq *s, FILE *fp);
+extern int trace_seq_do_printf(struct trace_seq *s);
+
+#endif /* _TRACE_SEQ_H */
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index c47e0200688a..f024d73bfc40 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -3,6 +3,7 @@
 #define _PERF_UTIL_TRACE_EVENT_H
 
 #include <traceevent/event-parse.h>
+#include <traceevent/trace-seq.h>
 #include "parse-events.h"
 
 struct machine;
-- 
2.17.1
