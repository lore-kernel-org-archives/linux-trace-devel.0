Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr690062.outbound.protection.outlook.com ([40.107.69.62]:29120
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729913AbeK1Ckz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:40:55 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 21/46] tools/lib/traceevent: Man pages
 tep_get_first_event() and tep_get_events_count()
Date: Tue, 27 Nov 2018 15:42:33 +0000
Message-ID: <20181127154153.11315-22-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_get_first_event() and tep_get_events_count()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-events.txt    | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-events=
.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-events.txt b/=
tools/lib/traceevent/Documentation/libtraceevent-events.txt
new file mode 100644
index 000000000000..169bb3240633
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-events.txt
@@ -0,0 +1,87 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_get_first_event,tep_get_events_count - Access events.=20
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_event pass:[*]*tep_get_first_event*(struct tep_handle pass:[*]_=
tep_);
+int *tep_get_events_count*(struct tep_handle pass:[*]_tep_);
+--
+
+DESCRIPTION
+-----------
+The _tep_get_first_event()_ function returns a pointer to the first event.=
 As events are=20
+stored in an array, this function returns the pointer to the beginning=20
+of the array. The _tep_ argument is trace event parser context.=20
+
+The _tep_get_events_count()_ function returns the number of the events=20
+in the array. The _tep_ argument is trace event parser context.
+
+RETURN VALUE
+------------
+The _tep_get_first_event()_ returns a pointer to the first event. NULL is=
=20
+returned in case of error, or in case there are no events.
+
+The _tep_get_events_count()_ returns the number of the events. 0 is=20
+returned in case of error, or in case there are no events.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+int i,count =3D tep_get_events_count(tep);
+struct tep_event *event, *events =3D tep_get_first_event(tep);
+
+if (events =3D=3D NULL) {
+	/* There are no events */
+} else {
+	for (i=3D0; i<count; i++) {
+		event =3D (events+i);
+		/* process events[i] */
+	}
+}
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
