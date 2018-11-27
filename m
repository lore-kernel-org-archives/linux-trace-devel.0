Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:24265
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726381AbeK1Clr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:41:47 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 37/46] tools/lib/traceevent: Man pages for
 tep_parse_event() and tep_parse_format()
Date: Tue, 27 Nov 2018 15:42:55 +0000
Message-ID: <20181127154153.11315-38-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_parse_event() and tep_parse_format()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-parse_event.txt             | 90 +++++++++++++++++++
 1 file changed, 90 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_=
event.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-parse_event.t=
xt b/tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt
new file mode 100644
index 000000000000..ceb41cdd6514
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-parse_event.txt
@@ -0,0 +1,90 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_parse_event,tep_parse_format - Parse the event format information
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum tep_errno *tep_parse_event*(struct tep_handle pass:[*]_tep_, const ch=
ar pass:[*]_buf_, unsigned long _size_, const char pass:[*]_sys_);
+enum tep_errno *tep_parse_format*(struct tep_handle pass:[*]_tep_, struct =
tep_event pass:[*]pass:[*]_eventp_, const char pass:[*]_buf_, unsigned long=
 _size_, const char pass:[*]_sys_);
+--
+
+DESCRIPTION
+-----------
+The _tep_parse_event()_ function parses the event format and creates an ev=
ent=20
+structure to quickly parse raw data for a given event. The _tep_ argument =
is=20
+the trace event parser context. The created event structure is stored in t=
he=20
+_tep_ context. The _buf_ argument is a buffer with _size_, where the event=
=20
+format data is. The event format data can be taken from=20
+tracefs/events/.../.../format files. The _sys_ argument is the system of=20
+the event.=20
+
+The _tep_parse_format()_ function does the same as _tep_parse_event()_. Th=
e only
+difference is in the extra _eventp_ argument, where the newly created even=
t=20
+structure is returned.
+
+RETURN VALUE
+------------
+Both _tep_parse_event()_ and _tep_parse_format()_ functions return 0 on su=
ccess,
+or TEP_ERRNO__... in case of an error.=20
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+char *buf;
+int size;
+struct tep_event *event =3D NULL;
+buf =3D read_file("/sys/kernel/tracing/events/ftrace/print/format", &size)=
;
+if (tep_parse_event(tep, buf, size, "ftrace") !=3D 0) {
+	/* Failed to parse the ftrace print format */
+}
+
+if (tep_parse_format(tep, &event, buf, size, "ftrace") !=3D 0) {
+	/* Failed to parse the ftrace print format */
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
