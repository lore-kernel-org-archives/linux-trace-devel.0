Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730083.outbound.protection.outlook.com ([40.107.73.83]:39328
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726681AbeK1Cls (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:41:48 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 44/46] tools/lib/traceevent: Man pages for
 trace_seq_printf() and trace_seq_vprintf()
Date: Tue, 27 Nov 2018 15:43:04 +0000
Message-ID: <20181127154153.11315-45-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for trace_seq_printf() and trace_seq_vprintf()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-tseq_print.txt              | 96 +++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_p=
rint.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-tseq_print.tx=
t b/tools/lib/traceevent/Documentation/libtraceevent-tseq_print.txt
new file mode 100644
index 000000000000..70e222ddbe8c
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-tseq_print.txt
@@ -0,0 +1,96 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+trace_seq_printf,trace_seq_vprintf - Print formated string with arguments =
in a trace sequence.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+int *trace_seq_printf*(struct trace_seq pass:[*]_s_, const char pass:[*]_f=
mt_, _..._);
+int *trace_seq_vprintf*(struct trace_seq pass:[*]_s_, const char pass:[*]_=
fmt_, va_list _args_);
+--
+
+DESCRIPTION
+-----------
+Trace sequences are used to allow a function to call several other functio=
ns=20
+to create a string of data to use.
+
+The _trace_seq_printf()_ function puts a formated string _fmt _with=20
+variable arguments _..._ in the trace sequence _s_.
+
+The _trace_seq_vprintf()_ function puts a formated string _fmt _with=20
+list of arguments _args_ in the trace sequence _s_.=20
+
+RETURN VALUE
+------------
+
+Both _trace_seq_printf()_ and _trace_seq_vprintf()_ functions return 0 if =
the=20
+trace oversizes the buffer's free space, the number of characters printed,=
 or=20
+a negative value in case of an error.
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
+if (trace_seq_printf(&seq, "example print %d", 10) <=3D 0) {
+	/* Failed to print in the trace sequence */
+}
+...
+void my_print(char *format, ...)
+{
+	va_list ap;
+	va_start(ap, format);
+	if (trace_seq_printf(&seq, format, ap) <=3D 0) {
+		/* Failed to print in the trace sequence */
+	}=09
+	va_end(ap);
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
