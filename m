Return-Path: <SRS0=VoGV=M6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bn3nam01on0049.outbound.protection.outlook.com ([104.47.33.49]:29728
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726043AbeJRUEC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Oct 2018 16:04:02 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tools lib traceevent: Separate out tep_strerror() for
 strerror_r() issues
Date: Thu, 18 Oct 2018 12:03:14 +0000
Message-ID: <20181018120301.3314-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

While working on having PowerTop use libtracevent as a shared object
library, Tzvetomir hit "str_error_r not defined". This was added by commit
c3cec9e68f12d ("tools lib traceevent: Use str_error_r()") because
strerror_r() has two definitions, where one is GNU specific, and the other
is XSI complient. The strerror_r() is in a wrapper str_error_r() to keep th=
e
code from having to worry about which compiler is being used.

The problem is that str_error_r() is external to libtraceevent, and not par=
t
of the library. If it is used as a shared object then the tools using it
will need to define that function. I do not want that function defined in
libtraceevent itself, as it is out of scope for that library.

As there's only a single instance of this call, and its in the traceevent
library's own tep_strerror() function, we can copy what was done in perf,
and create yet another external file that undefs _GNU_SOURCE to use the mor=
e
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
 include/linux/string.h                        |  6 ---
 lib/traceevent/Makefile                       |  4 +-
 lib/traceevent/event-parse.c                  | 30 --------------
 .../{str_error_r.c =3D> tep_strerror.c}         | 39 ++++++++++++++++---
 4 files changed, 34 insertions(+), 45 deletions(-)
 delete mode 100644 include/linux/string.h
 rename lib/traceevent/{str_error_r.c =3D> tep_strerror.c} (54%)

diff --git a/include/linux/string.h b/include/linux/string.h
deleted file mode 100644
index 8052d80..0000000
--- a/include/linux/string.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_STRING_H_
-#define __LINUX_STRING_H_
-
-char *str_error_r(int errnum, char *buf, size_t buflen);
-
-#endif
diff --git a/lib/traceevent/Makefile b/lib/traceevent/Makefile
index bfbb6a3..c3f0957 100644
--- a/lib/traceevent/Makefile
+++ b/lib/traceevent/Makefile
@@ -14,9 +14,7 @@ OBJS +=3D trace-seq.o
 OBJS +=3D parse-filter.o
 OBJS +=3D parse-utils.o
 OBJS +=3D event-parse-api.o
-
-# Additional util objects
-OBJS +=3D str_error_r.o
+OBJS +=3D tep_strerror.o
=20
 OBJS :=3D $(OBJS:%.o=3D$(bdir)/%.o)
 DEPS :=3D $(OBJS:$(bdir)/%.o=3D$(bdir)/.%.d)
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 73662d0..50fb558 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -18,7 +18,6 @@
 #include <errno.h>
 #include <stdint.h>
 #include <limits.h>
-#include <linux/string.h>
 #include <linux/time64.h>
=20
 #include <netinet/in.h>
@@ -6242,35 +6241,6 @@ enum tep_errno tep_parse_event(struct tep_handle *pe=
vent, const char *buf,
 	return __parse_event(pevent, &event, buf, size, sys);
 }
=20
-#undef _PE
-#define _PE(code, str) str
-static const char * const tep_error_str[] =3D {
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
-	if (errnum >=3D 0) {
-		str_error_r(errnum, buf, buflen);
-		return 0;
-	}
-
-	if (errnum <=3D __TEP_ERRNO__START ||
-	    errnum >=3D __TEP_ERRNO__END)
-		return -1;
-
-	idx =3D errnum - __TEP_ERRNO__START - 1;
-	msg =3D tep_error_str[idx];
-	snprintf(buf, buflen, "%s", msg);
-
-	return 0;
-}
-
 int get_field_val(struct trace_seq *s, struct tep_format_field *field,
 		  const char *name, struct tep_record *record,
 		  unsigned long long *val, int err)
diff --git a/lib/traceevent/str_error_r.c b/lib/traceevent/tep_strerror.c
similarity index 54%
rename from lib/traceevent/str_error_r.c
rename to lib/traceevent/tep_strerror.c
index 503ae07..4ac2644 100644
--- a/lib/traceevent/str_error_r.c
+++ b/lib/traceevent/tep_strerror.c
@@ -1,7 +1,16 @@
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
+static const char * const tep_error_str[] =3D {
+	TEP_ERRORS
+};
+#undef _PE
=20
 /*
  * The tools so far have been using the strerror_r() GNU variant, that ret=
urns
@@ -17,10 +26,28 @@
  * interface, but uses the portable XSI variant of strerror_r(), so that u=
sers
  * rest asured that the provided buffer is used and it is what is returned=
.
  */
-char *str_error_r(int errnum, char *buf, size_t buflen)
+int tep_strerror(struct tep_handle *tep __maybe_unused,
+		 enum tep_errno errnum, char *buf, size_t buflen)
 {
-	int err =3D strerror_r(errnum, buf, buflen);
-	if (err)
-		snprintf(buf, buflen, "INTERNAL ERROR: strerror_r(%d, %p, %zd)=3D%d", er=
rnum, buf, buflen, err);
-	return buf;
+	const char *msg;
+	int idx;
+
+	if (!buflen)
+		return 0;
+
+	if (errnum >=3D 0) {
+		int err =3D strerror_r(errnum, buf, buflen);
+		buf[buflen - 1] =3D 0;
+		return err;
+	}
+
+	if (errnum <=3D __TEP_ERRNO__START ||
+	    errnum >=3D __TEP_ERRNO__END)
+		return -1;
+
+	idx =3D errnum - __TEP_ERRNO__START - 1;
+	msg =3D tep_error_str[idx];
+	snprintf(buf, buflen, "%s", msg);
+
+	return 0;
 }
--=20
2.17.2
