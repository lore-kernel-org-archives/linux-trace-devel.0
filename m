Return-Path: <SRS0=LhtG=MV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from terminus.zytor.com ([198.137.202.136]:43125 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbeJIMs3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Oct 2018 08:48:29 -0400
Date: Mon, 8 Oct 2018 22:33:10 -0700
From: "tip-bot for Steven Rostedt (VMware)" <tipbot@zytor.com>
Message-ID: <tip-bbbab191c2c474d183e93799d008b412e97f5936@git.kernel.org>
Cc: tz.stoyanov@gmail.com, tstoyanov@vmware.com, jolsa@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        acme@redhat.com, linux-trace-devel@vger.kernel.org,
        namhyung@kernel.org
Reply-To: namhyung@kernel.org, linux-trace-devel@vger.kernel.org,
          acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
          linux-kernel@vger.kernel.org, tglx@linutronix.de,
          rostedt@goodmis.org, jolsa@redhat.com, tstoyanov@vmware.com,
          tz.stoyanov@gmail.com
In-Reply-To: <20181005121816.484e654f@gandalf.local.home>
References: <20181005121816.484e654f@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Separate out tep_strerror()
 for strerror_r() issues
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Commit-ID:  bbbab191c2c474d183e93799d008b412e97f5936
Gitweb:     https://git.kernel.org/tip/bbbab191c2c474d183e93799d008b412e97f5936
Author:     Steven Rostedt (VMware) <rostedt@goodmis.org>
AuthorDate: Fri, 5 Oct 2018 12:18:16 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Oct 2018 14:30:45 -0300

tools lib traceevent: Separate out tep_strerror() for strerror_r() issues

While working on having PowerTop use libtracevent as a shared object
library, Tzvetomir hit "str_error_r not defined". This was added by commit
c3cec9e68f12d ("tools lib traceevent: Use str_error_r()") because
strerror_r() has two definitions, where one is GNU specific, and the other
is XSI complient. The strerror_r() is in a wrapper str_error_r() to keep the
code from having to worry about which compiler is being used.

The problem is that str_error_r() is external to libtraceevent, and not part
of the library. If it is used as a shared object then the tools using it
will need to define that function. I do not want that function defined in
libtraceevent itself, as it is out of scope for that library.

As there's only a single instance of this call, and its in the traceevent
library's own tep_strerror() function, we can copy what was done in perf,
and create yet another external file that undefs _GNU_SOURCE to use the more
portable version of the function. We don't need to worry about the errors
that strerror_r() returns. If the buffer isn't big enough, we simply
truncate it.

Reported-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux trace devel <linux-trace-devel@vger.kernel.org>
Link: http://lkml.kernel.org/r/20181005121816.484e654f@gandalf.local.home
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Build                         |  1 +
 tools/lib/traceevent/event-parse.c                 | 30 ----------------
 .../{str_error_r.c => traceevent/tep_strerror.c}   | 40 ++++++++++++++++++----
 3 files changed, 34 insertions(+), 37 deletions(-)

diff --git a/tools/lib/traceevent/Build b/tools/lib/traceevent/Build
index c681d0575d16..0050c145d806 100644
--- a/tools/lib/traceevent/Build
+++ b/tools/lib/traceevent/Build
@@ -4,6 +4,7 @@ libtraceevent-y += trace-seq.o
 libtraceevent-y += parse-filter.o
 libtraceevent-y += parse-utils.o
 libtraceevent-y += kbuffer-parse.o
+libtraceevent-y += tep_strerror.o
 
 plugin_jbd2-y         += plugin_jbd2.o
 plugin_hrtimer-y      += plugin_hrtimer.o
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 7980fc6c3bac..233179a712d6 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -18,7 +18,6 @@
 #include <errno.h>
 #include <stdint.h>
 #include <limits.h>
-#include <linux/string.h>
 #include <linux/time64.h>
 
 #include <netinet/in.h>
@@ -6201,35 +6200,6 @@ enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
 	return __parse_event(pevent, &event, buf, size, sys);
 }
 
-#undef _PE
-#define _PE(code, str) str
-static const char * const tep_error_str[] = {
-	TEP_ERRORS
-};
-#undef _PE
-
-int tep_strerror(struct tep_handle *pevent __maybe_unused,
-		 enum tep_errno errnum, char *buf, size_t buflen)
-{
-	int idx;
-	const char *msg;
-
-	if (errnum >= 0) {
-		str_error_r(errnum, buf, buflen);
-		return 0;
-	}
-
-	if (errnum <= __TEP_ERRNO__START ||
-	    errnum >= __TEP_ERRNO__END)
-		return -1;
-
-	idx = errnum - __TEP_ERRNO__START - 1;
-	msg = tep_error_str[idx];
-	snprintf(buf, buflen, "%s", msg);
-
-	return 0;
-}
-
 int get_field_val(struct trace_seq *s, struct tep_format_field *field,
 		  const char *name, struct tep_record *record,
 		  unsigned long long *val, int err)
diff --git a/tools/lib/str_error_r.c b/tools/lib/traceevent/tep_strerror.c
similarity index 54%
copy from tools/lib/str_error_r.c
copy to tools/lib/traceevent/tep_strerror.c
index 6aad8308a0ac..4ac26445b2f6 100644
--- a/tools/lib/str_error_r.c
+++ b/tools/lib/traceevent/tep_strerror.c
@@ -1,8 +1,16 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: LGPL-2.1
 #undef _GNU_SOURCE
 #include <string.h>
 #include <stdio.h>
-#include <linux/string.h>
+
+#include "event-parse.h"
+
+#undef _PE
+#define _PE(code, str) str
+static const char * const tep_error_str[] = {
+	TEP_ERRORS
+};
+#undef _PE
 
 /*
  * The tools so far have been using the strerror_r() GNU variant, that returns
@@ -18,10 +26,28 @@
  * interface, but uses the portable XSI variant of strerror_r(), so that users
  * rest asured that the provided buffer is used and it is what is returned.
  */
-char *str_error_r(int errnum, char *buf, size_t buflen)
+int tep_strerror(struct tep_handle *tep __maybe_unused,
+		 enum tep_errno errnum, char *buf, size_t buflen)
 {
-	int err = strerror_r(errnum, buf, buflen);
-	if (err)
-		snprintf(buf, buflen, "INTERNAL ERROR: strerror_r(%d, [buf], %zd)=%d", errnum, buflen, err);
-	return buf;
+	const char *msg;
+	int idx;
+
+	if (!buflen)
+		return 0;
+
+	if (errnum >= 0) {
+		int err = strerror_r(errnum, buf, buflen);
+		buf[buflen - 1] = 0;
+		return err;
+	}
+
+	if (errnum <= __TEP_ERRNO__START ||
+	    errnum >= __TEP_ERRNO__END)
+		return -1;
+
+	idx = errnum - __TEP_ERRNO__START - 1;
+	msg = tep_error_str[idx];
+	snprintf(buf, buflen, "%s", msg);
+
+	return 0;
 }
