Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730083.outbound.protection.outlook.com ([40.107.73.83]:39328
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729751AbeK1CmF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:42:05 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 46/46] tools/lib/traceevent: Man pages for
 trace_seq_reset() and trace_seq_terminate()
Date: Tue, 27 Nov 2018 15:43:07 +0000
Message-ID: <20181127154153.11315-47-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for trace_seq_reset() and trace_seq_terminate()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-tseq_reset.txt              | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-tseq_r=
eset.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-tseq_reset.tx=
t b/tools/lib/traceevent/Documentation/libtraceevent-tseq_reset.txt
new file mode 100644
index 000000000000..3951f313d39c
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-tseq_reset.txt
@@ -0,0 +1,78 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+trace_seq_reset,trace_seq_terminate - Reset / terminate a trace sequence.=
=20
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+void *trace_seq_reset*(struct trace_seq pass:[*]_s_);
+void *trace_seq_terminate*(struct trace_seq pass:[*]_s_);
+--
+
+DESCRIPTION
+-----------
+Trace sequences are used to allow a function to call several other functio=
ns=20
+to create a string of data to use.
+
+The _trace_seq_reset()_ function re-initializes the trace sequence _s_. Al=
l=20
+characters already written in _s_ will be deleted.
+
+The _trace_seq_terminate()_ function terminates the trace sequence _s_. It=
 puts
+the null character pass:['\0'] at the end of the buffer.
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
+trace_seq_reset(&seq);
+...
+trace_seq_terminate(&seq);
+...
+--
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
