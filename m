Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:24265
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726381AbeK1CmI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:42:08 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 43/46] tools/lib/traceevent: Man pages for
 trace_seq_do_fprintf() and trace_seq_do_printf()
Date: Tue, 27 Nov 2018 15:43:03 +0000
Message-ID: <20181127154153.11315-44-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for trace_seq_do_fprintf() and trace_seq_do_printf()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-tseq_doprint.txt            | 89 +++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_d=
oprint.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-tseq_doprint.=
txt b/tools/lib/traceevent/Documentation/libtraceevent-tseq_doprint.txt
new file mode 100644
index 000000000000..441afae8ca0c
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-tseq_doprint.txt
@@ -0,0 +1,89 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+trace_seq_do_fprintf,trace_seq_do_printf - Print the trace sequence buffer=
 to a file.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+int *trace_seq_do_printf*(struct trace_seq pass:[*]_s_);
+int *trace_seq_do_fprintf*(struct trace_seq pass:[*]_s_, FILE pass:[*]_fp_=
);
+--
+
+DESCRIPTION
+-----------
+Trace sequences are used to allow a function to call several other functio=
ns=20
+to create a string of data to use.
+
+The _trace_seq_do_printf()_ function prints the buffer of trace sequence _=
s_ to
+the standard output stdout.
+
+The _trace_seq_do_fprintf()_ function prints the buffer of trace sequence =
_s_=20
+to the given file _fp_.
+
+RETURN VALUE
+------------
+Both _trace_seq_do_printf()_ and _trace_seq_do_fprintf()_ functions return=
 the
+number of printed characters, or -1 in case of an error.
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
+if (trace_seq_do_printf(&seq) < 0 ) [
+	/* Failed to print the buffer of the trace sequence to the standard outpu=
t */
+}
+...
+FILE *fp =3D fopen("trace.txt", "w");
+if (trace_seq_do_fprintf(&seq, fp) < 0 ) [
+	/* Failed to print the buffer of the trace sequence to the trace.txt file=
 */
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
