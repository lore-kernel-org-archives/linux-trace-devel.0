Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730068.outbound.protection.outlook.com ([40.107.73.68]:47354
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729872AbeK1Ckq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:40:46 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 13/46] tools/lib/traceevent: Man page for
 tep_register_trace_clock()
Date: Tue, 27 Nov 2018 15:42:23 +0000
Message-ID: <20181127154153.11315-14-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man page for tep_register_trace_clock()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-reg_clock.txt | 77 +++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_cl=
ock.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_clock.txt=
 b/tools/lib/traceevent/Documentation/libtraceevent-reg_clock.txt
new file mode 100644
index 000000000000..60dd81df6b37
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_clock.txt
@@ -0,0 +1,77 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_register_trace_clock - Registers the clock, used for the timestamp of
+the events.=20
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_register_trace_clock*(struct tep_handle pass:[*]_tep_, const char=
 pass:[*]_trace_clock_);
+--
+
+DESCRIPTION
+-----------
+The _tep_register_trace_clock()_ function registers the clock, used for=20
+the timestamps of the events. When an event is recorded, a timestamp is at=
tached=20
+to it. This timestamp comes from a specified clock. Supported clocks can b=
e seen=20
+in tracefs/trace_clock, the selected one is in square brackets.
+The _tep_ argument is the trace event parser context. The _trace_clock_ ar=
gument=20
+is the name of the clock, the string is copied internally.=20
+
+RETURN VALUE
+------------
+The _tep_register_trace_clock()_ function returns 0 in case of success.=20
+If there is not enough memory to copy the _trace_clock_ string -1 is retur=
ned=20
+and errno is set to ENOMEM.=20
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+	if(tep_register_trace_clock(tep, "local") !=3D 0) {
+		/* Failed to register the clock */
+	}
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
