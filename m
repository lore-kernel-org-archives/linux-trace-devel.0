Return-Path: <SRS0=YO3e=OC=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr740058.outbound.protection.outlook.com ([40.107.74.58]:1920
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405578AbeKXAYX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Nov 2018 19:24:23 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 3/3] tools/lib/traceevent: Changed return logic of
 trace_seq_printf() and trace_seq_vprintf() APIs
Date: Fri, 23 Nov 2018 13:40:02 +0000
Message-ID: <20181123133946.16239-4-tstoyanov@vmware.com>
References: <20181123133946.16239-1-tstoyanov@vmware.com>
In-Reply-To: <20181123133946.16239-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, its API
should be straightforward. The trace_seq_printf() and
trace_seq_vprintf() APIs have inconsistent returned values with
the other trace_seq_* APIs. This path changes the return logic of
trace_seq_printf() and trace_seq_vprintf() - to return the number
of printed characters, as the other trace_seq_* related APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-tseq_print.txt  |  9 +++++----
 tools/lib/traceevent/trace-seq.c                | 17 ++++++++++++-----
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-tseq_print.tx=
t b/tools/lib/traceevent/Documentation/libtraceevent-tseq_print.txt
index ae1aa44710e7..70e222ddbe8c 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent-tseq_print.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent-tseq_print.txt
@@ -30,8 +30,9 @@ list of arguments _args_ in the trace sequence _s_.
 RETURN VALUE
 ------------
=20
-Both _trace_seq_printf()_ and _trace_seq_vprintf()_ functions return non-z=
ero=20
-on success, or 0 in case of an error.
+Both _trace_seq_printf()_ and _trace_seq_vprintf()_ functions return 0 if =
the=20
+trace oversizes the buffer's free space, the number of characters printed,=
 or=20
+a negative value in case of an error.
=20
 EXAMPLE
 -------
@@ -43,7 +44,7 @@ EXAMPLE
 struct trace_seq seq;
 trace_seq_init(&seq);
 ...
-if (trace_seq_printf(&seq, "example print %d", 10) =3D=3D 0) {
+if (trace_seq_printf(&seq, "example print %d", 10) <=3D 0) {
 	/* Failed to print in the trace sequence */
 }
 ...
@@ -51,7 +52,7 @@ void my_print(char *format, ...)
 {
 	va_list ap;
 	va_start(ap, format);
-	if (trace_seq_printf(&seq, format, ap) =3D=3D 0) {
+	if (trace_seq_printf(&seq, format, ap) <=3D 0) {
 		/* Failed to print in the trace sequence */
 	}=09
 	va_end(ap);
diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-=
seq.c
index 7c5cc0a57e3c..32c610bc0538 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -114,7 +114,8 @@ static void expand_buffer(struct trace_seq *s)
  * @fmt: printf format string
  *
  * It returns 0 if the trace oversizes the buffer's free
- * space, 1 otherwise.
+ * space, the number of characters printed, or a negative
+ * value in case of an error.
  *
  * The tracer may use either sequence operations or its own
  * copy to user routines. To simplify formating of a trace
@@ -143,9 +144,10 @@ trace_seq_printf(struct trace_seq *s, const char *fmt,=
 ...)
 		goto try_again;
 	}
=20
-	s->len +=3D ret;
+	if (ret > 0)
+		s->len +=3D ret;
=20
-	return 1;
+	return ret;
 }
=20
 /**
@@ -153,6 +155,10 @@ trace_seq_printf(struct trace_seq *s, const char *fmt,=
 ...)
  * @s: trace sequence descriptor
  * @fmt: printf format string
  *
+ * It returns 0 if the trace oversizes the buffer's free
+ * space, the number of characters printed, or a negative
+ * value in case of an error.
+ * *
  * The tracer may use either sequence operations or its own
  * copy to user routines. To simplify formating of a trace
  * trace_seq_printf is used to store strings into a special
@@ -177,9 +183,10 @@ trace_seq_vprintf(struct trace_seq *s, const char *fmt=
, va_list args)
 		goto try_again;
 	}
=20
-	s->len +=3D ret;
+	if (ret > 0)
+		s->len +=3D ret;
=20
-	return len;
+	return ret;
 }
=20
 /**
--=20
2.19.1
