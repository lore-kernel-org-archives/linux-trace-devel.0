Return-Path: <SRS0=OAlf=N6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790045.outbound.protection.outlook.com ([40.107.79.45]:56480
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728846AbeKSXS3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Nov 2018 18:18:29 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 28/34] tools/lib/traceevent: Man page for tep_data_lat_fmt()
Date: Mon, 19 Nov 2018 12:54:40 +0000
Message-ID: <20181119125357.19449-29-tstoyanov@vmware.com>
References: <20181119125357.19449-1-tstoyanov@vmware.com>
In-Reply-To: <20181119125357.19449-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man page for tep_data_lat_fmt()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-record_lat.txt              | 77 +++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-record=
_lat.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-record_lat.tx=
t b/tools/lib/traceevent/Documentation/libtraceevent-record_lat.txt
new file mode 100644
index 000000000000..5c8f5ec0599d
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-record_lat.txt
@@ -0,0 +1,77 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_data_lat_fmt - Parses the data for the latency format.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+void *tep_data_lat_fmt*(struct tep_handle pass:[*]_tep_, struct trace_seq =
pass:[*]_s_, struct tep_record pass:[*]_record_);
+--
+DESCRIPTION
+-----------
+The _tep_data_lat_fmt()_ function parses out the latency format (interrupt=
s=20
+disabled, need rescheduling, in hard/soft interrupt, preempt count and=20
+lock depth) from _record_ and places it into the _s_.  The _tep_ argument =
is=20
+the trace event parser context.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+struct trace_seq seq;
+trace_seq_init(&seq);
+...
+void process_record(struct tep_record *record)
+{
+	/* Place latency information in the seq */
+	tep_data_lat_fmt(tep, &seq, record);
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
+	Trace sequences are used to allow a function to call several other functi=
ons=20
+	to create a string of data to use.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_,_tep_set_latency_format(3)_
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
