Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730083.outbound.protection.outlook.com ([40.107.73.83]:39328
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726681AbeK1Clv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:41:51 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 45/46] tools/lib/traceevent: Man pages for trace_seq_putc()
 and trace_seq_puts()
Date: Tue, 27 Nov 2018 15:43:06 +0000
Message-ID: <20181127154153.11315-46-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for trace_seq_putc() and trace_seq_puts()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-tseq_put.txt  | 89 +++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_p=
ut.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-tseq_put.txt =
b/tools/lib/traceevent/Documentation/libtraceevent-tseq_put.txt
new file mode 100644
index 000000000000..78d2e87dbba8
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-tseq_put.txt
@@ -0,0 +1,89 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+trace_seq_putc,trace_seq_puts - Put string / character in  a trace sequenc=
e.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+int *trace_seq_putc*(struct trace_seq pass:[*]_s_, unsigned char _c_);
+int *trace_seq_puts*(struct trace_seq pass:[*]_s_, const char pass:[*]_str=
_);
+--
+
+DESCRIPTION
+-----------
+Trace sequences are used to allow a function to call several other functio=
ns=20
+to create a string of data to use.
+
+The _trace_seq_putc()_ function puts a single character _c_ in the trace=20
+sequence _s_.
+
+The _trace_seq_puts()_ function puts a NULL terminated string _str_ in the=
=20
+trace sequence _s_.
+
+RETURN VALUE
+------------
+Both _trace_seq_putc()_ and _trace_seq_puts()_ functions return the number=
 of=20
+characters put in the trace sequence, or 0 in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct trace_seq seq;
+trace_seq_init(&seq);
+...
+if (trace_seq_putc(&seq, ';') !=3D 1) {
+	/* Failed to put ';' in the trace sequence */
+}
+...
+char *str =3D " foo ";
+if (trace_seq_puts(&seq, str) !=3D strlen(str)) {
+	/* Failed to put " foo " in the trace sequence */
+}
+...
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*trace-seq.h*
+	Header file to include in order to have access to trace sequences related=
 APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
--=20
2.19.1
