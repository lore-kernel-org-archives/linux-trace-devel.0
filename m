Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730072.outbound.protection.outlook.com ([40.107.73.72]:22643
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729913AbeK1ClJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:41:09 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 19/46] tools/lib/traceevent: Man page for tep_list_events()
Date: Tue, 27 Nov 2018 15:42:31 +0000
Message-ID: <20181127154153.11315-20-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man page for tep_list_events() as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-event_list.txt              | 94 +++++++++++++++++++
 1 file changed, 94 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_=
list.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_list.tx=
t b/tools/lib/traceevent/Documentation/libtraceevent-event_list.txt
new file mode 100644
index 000000000000..f443d8648a34
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_list.txt
@@ -0,0 +1,94 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_list_events - Get list of events, sorted by given criteria.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_event_sort_type* {
+	_TEP_EVENT_SORT_ID_,
+	_TEP_EVENT_SORT_NAME_,
+	_TEP_EVENT_SORT_SYSTEM_,
+};
+
+struct tep_event pass:[*]pass:[*]*tep_list_events*(struct tep_handle pass:=
[*]_tep_, enum tep_event_sort_type _sort_type_);
+--
+
+DESCRIPTION
+-----------
+The _tep_list_events()_ function returns an array of pointers to the event=
s,=20
+sorted by the _sort_type_ criteria. The last element of the array is NULL.
+The returned memory must not be freed, it is managed by the library.=20
+The _tep_ argument is trace event parser context. The _sort_type_ argument=
 is=20
+the required sort criteria:
+[verse]
+--
+	_TEP_EVENT_SORT_ID_	- sort by the event ID.
+	_TEP_EVENT_SORT_NAME_	- sort by the event (name, system, id) triplet.
+	_TEP_EVENT_SORT_SYSTEM_	- sort by the event (system, name, id) triplet.
+--=20
+
+RETURN VALUE
+------------
+The _tep_list_events()_ function returns an array of pointers to events.=20
+In case of an error, NULL is returned.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+int i=3D0;
+struct tep_event_format **events =3D tep_list_events(tep, TEP_EVENT_SORT_I=
D);
+if (events =3D=3D NULL) {
+	/* Failed to get the events, sorted by ID */
+} else {
+	while(events[i]) {
+		/* walk through the list of the events, sorted by the ID */
+		i++;
+	}
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
