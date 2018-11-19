Return-Path: <SRS0=OAlf=N6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790045.outbound.protection.outlook.com ([40.107.79.45]:56480
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728933AbeKSXSE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Nov 2018 18:18:04 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 18/34] tools/lib/traceevent: Man pages for
 tep_event_filtered() and tep_filter_remove_event()
Date: Mon, 19 Nov 2018 12:54:29 +0000
Message-ID: <20181119125357.19449-19-tstoyanov@vmware.com>
References: <20181119125357.19449-1-tstoyanov@vmware.com>
In-Reply-To: <20181119125357.19449-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_event_filtered() and tep_filter_remove_event()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-filter_event.txt            | 84 +++++++++++++++++++
 1 file changed, 84 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
_event.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter_event.=
txt b/tools/lib/traceevent/Documentation/libtraceevent-filter_event.txt
new file mode 100644
index 000000000000..8b45dd765e02
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter_event.txt
@@ -0,0 +1,84 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_event_filtered,tep_filter_remove_event - Checks / removes a filter on =
an event.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_event_filtered*(struct tep_event_filter pass:[*]_filter_, int _ev=
ent_id_);
+int *tep_filter_remove_event*(struct tep_event_filter pass:[*]_filter_, in=
t _event_id_);
+--
+
+DESCRIPTION
+-----------
+The _tep_event_filtered()_ function checks if the event with _event_id_ ha=
s=20
+_filter_.
+
+The _tep_filter_remove_event()_ function removes a _filter_ for an event w=
ith=20
+_event_id_.
+
+RETURN VALUE
+------------
+The _tep_event_filtered()_ function returns 1 if the filter is found for g=
iven
+event, or 0 otherwise.
+
+The _tep_filter_remove_event()_ function returns 1 if the vent was removed=
, or=20
+0 if the event was not found.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+struct tep_event_filter *filter =3D tep_filter_alloc(tep);
+...
+if (tep_event_filtered(filter, 1857) =3D=3D 1) {
+	/* Event 1857 has filter */
+}
+
+if (tep_filter_remove_event(filter, 1857) =3D=3D 1) {
+	/* Event 1857 was removed from the filter */
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
