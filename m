Return-Path: <SRS0=XLZm=MI=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730062.outbound.protection.outlook.com ([40.107.73.62]:58268
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727205AbeIZSbl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Sep 2018 14:31:41 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 01/16] tools lib traceevent, perf tools: Split trace-seq related APIs in a separate header file
Date: Wed, 26 Sep 2018 15:18:17 +0300
Message-Id: <20180926121832.16101-2-tstoyanov@vmware.com>
In-Reply-To: <20180926121832.16101-1-tstoyanov@vmware.com>
References: <20180926121832.16101-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

In order to make libtraceevent into a proper library, all its APIs
should be defined in corresponding header files.  This patch splits
trace-seq related APIs in a separate header file: trace-seq.h

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20180828185038.2dcb2743@gandalf.local.home
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h | 46 ++------------------------
 include/traceevent/trace-seq.h   | 55 ++++++++++++++++++++++++++++++++
 lib/traceevent/event-parse.c     |  1 +
 lib/traceevent/event-plugin.c    |  1 +
 lib/traceevent/trace-seq.c       |  2 ++
 plugins/plugin_function.c        |  1 +
 plugins/plugin_hrtimer.c         |  1 +
 plugins/plugin_jbd2.c            |  1 +
 plugins/plugin_kmem.c            |  1 +
 plugins/plugin_kvm.c             |  1 +
 plugins/plugin_mac80211.c        |  1 +
 plugins/plugin_sched_switch.c    |  1 +
 plugins/plugin_scsi.c            |  1 +
 plugins/plugin_xen.c             |  1 +
 14 files changed, 70 insertions(+), 44 deletions(-)
 create mode 100644 include/traceevent/trace-seq.h

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 713a4e4..3b6d16d 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -12,17 +12,12 @@
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
@@ -45,43 +40,6 @@ struct tep_record {
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
 /* ----------------------- pevent ----------------------- */
 
 struct tep_handle;
diff --git a/include/traceevent/trace-seq.h b/include/traceevent/trace-seq.h
new file mode 100644
index 0000000..d68ec69
--- /dev/null
+++ b/include/traceevent/trace-seq.h
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
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index ce1e202..70a42be 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -24,6 +24,7 @@
 #include <netinet/in.h>
 #include "event-parse.h"
 #include "event-utils.h"
+#include "trace-seq.h"
 
 static const char *input_buf;
 static unsigned long long input_buf_ptr;
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index f17e250..ec16a10 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -15,6 +15,7 @@
 #include <dirent.h>
 #include "event-parse.h"
 #include "event-utils.h"
+#include "trace-seq.h"
 
 #define LOCAL_PLUGIN_DIR ".traceevent/plugins"
 
diff --git a/lib/traceevent/trace-seq.c b/lib/traceevent/trace-seq.c
index 00cac9f..7f0c2f0 100644
--- a/lib/traceevent/trace-seq.c
+++ b/lib/traceevent/trace-seq.c
@@ -3,6 +3,8 @@
  * Copyright (C) 2009 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
  *
  */
+#include "trace-seq.h"
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/plugins/plugin_function.c b/plugins/plugin_function.c
index 9efa01c..3e0e1b2 100644
--- a/plugins/plugin_function.c
+++ b/plugins/plugin_function.c
@@ -8,6 +8,7 @@
 
 #include "trace-cmd.h"
 #include "event-utils.h"
+#include "trace-seq.h"
 
 static struct func_stack {
 	int size;
diff --git a/plugins/plugin_hrtimer.c b/plugins/plugin_hrtimer.c
index a2edb69..9defa1b 100644
--- a/plugins/plugin_hrtimer.c
+++ b/plugins/plugin_hrtimer.c
@@ -8,6 +8,7 @@
 #include <string.h>
 
 #include "event-parse.h"
+#include "trace-seq.h"
 
 static int timer_expire_handler(struct trace_seq *s, struct tep_record *record,
 				struct event_format *event, void *context)
diff --git a/plugins/plugin_jbd2.c b/plugins/plugin_jbd2.c
index fe95f3e..4b230ad 100644
--- a/plugins/plugin_jbd2.c
+++ b/plugins/plugin_jbd2.c
@@ -7,6 +7,7 @@
 #include <string.h>
 
 #include "event-parse.h"
+#include "trace-seq.h"
 
 #define MINORBITS	20
 #define MINORMASK	((1U << MINORBITS) - 1)
diff --git a/plugins/plugin_kmem.c b/plugins/plugin_kmem.c
index 79e3d3b..29f8e6c 100644
--- a/plugins/plugin_kmem.c
+++ b/plugins/plugin_kmem.c
@@ -7,6 +7,7 @@
 #include <string.h>
 
 #include "trace-cmd.h"
+#include "trace-seq.h"
 
 static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 			     struct event_format *event, void *context)
diff --git a/plugins/plugin_kvm.c b/plugins/plugin_kvm.c
index 3f4a8c0..ca7d111 100644
--- a/plugins/plugin_kvm.c
+++ b/plugins/plugin_kvm.c
@@ -8,6 +8,7 @@
 #include <stdint.h>
 
 #include "event-parse.h"
+#include "trace-seq.h"
 
 #ifdef HAVE_UDIS86
 
diff --git a/plugins/plugin_mac80211.c b/plugins/plugin_mac80211.c
index 72f7d7c..c1276c2 100644
--- a/plugins/plugin_mac80211.c
+++ b/plugins/plugin_mac80211.c
@@ -7,6 +7,7 @@
 #include <string.h>
 
 #include "event-parse.h"
+#include "trace-seq.h"
 
 #define INDENT 65
 
diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index 715587a..1a5f548 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -7,6 +7,7 @@
 #include <string.h>
 
 #include "trace-cmd.h"
+#include "trace-seq.h"
 
 static void write_state(struct trace_seq *s, int val)
 {
diff --git a/plugins/plugin_scsi.c b/plugins/plugin_scsi.c
index 5ec346f..4eba25c 100644
--- a/plugins/plugin_scsi.c
+++ b/plugins/plugin_scsi.c
@@ -3,6 +3,7 @@
 #include <string.h>
 #include <inttypes.h>
 #include "event-parse.h"
+#include "trace-seq.h"
 
 typedef unsigned long sector_t;
 typedef uint64_t u64;
diff --git a/plugins/plugin_xen.c b/plugins/plugin_xen.c
index b2acbd6..bc0496e 100644
--- a/plugins/plugin_xen.c
+++ b/plugins/plugin_xen.c
@@ -3,6 +3,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include "event-parse.h"
+#include "trace-seq.h"
 
 #define __HYPERVISOR_set_trap_table			0
 #define __HYPERVISOR_mmu_update				1
-- 
2.17.1
