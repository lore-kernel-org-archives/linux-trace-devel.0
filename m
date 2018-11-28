Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790052.outbound.protection.outlook.com ([40.107.79.52]:55564
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727623AbeK1UIu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 15:08:50 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 11/15] tools/lib/traceevent: Changed return logic of
 trace_seq_printf() and trace_seq_vprintf() APIs
Date: Wed, 28 Nov 2018 09:07:42 +0000
Message-ID: <20181128090711.17792-12-tstoyanov@vmware.com>
References: <20181128090711.17792-1-tstoyanov@vmware.com>
In-Reply-To: <20181128090711.17792-1-tstoyanov@vmware.com>
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
 tools/lib/traceevent/trace-seq.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

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
