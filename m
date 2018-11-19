Return-Path: <SRS0=OAlf=N6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700074.outbound.protection.outlook.com ([40.107.70.74]:19586
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728872AbeKSXSa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Nov 2018 18:18:30 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 06/34] tools/lib/traceevent: Man pages for tep_find_event(),
 tep_find_event_by_name() and tep_find_event_by_record()
Date: Mon, 19 Nov 2018 12:54:16 +0000
Message-ID: <20181119125357.19449-7-tstoyanov@vmware.com>
References: <20181119125357.19449-1-tstoyanov@vmware.com>
In-Reply-To: <20181119125357.19449-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_find_event(), tep_find_event_by_name()
and tep_find_event_by_record() as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-event_find.txt              | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_=
find.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_find.tx=
t b/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
new file mode 100644
index 000000000000..69a91bd21639
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_find.txt
@@ -0,0 +1,99 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_find_event,tep_find_event_by_name,tep_find_event_by_record - Find even=
ts by given key.=20
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_event pass:[*]*tep_find_event*(struct tep_handle pass:[*]_tep_,=
 int _id_);
+struct tep_event pass:[*]*tep_find_event_by_name*(struct tep_handle pass:[=
*]_tep_, const char pass:[*]_sys_, const char pass:[*]_name_);
+struct tep_event pass:[*]*tep_find_event_by_record*(struct tep_handle pass=
:[*]_tep_, struct tep_record pass:[*]_record_);
+--
+
+DESCRIPTION
+-----------
+This set of functions can be used to search for an event, based on a given=
=20
+criteria. All functions require a pointer to a _tep_, trace event parser c=
ontext.
+
+The _tep_find_event()_ function searches for an event by given event _id_.
+
+The tep_find_event_by_name()_ function searches for an event by given=20
+event _name_, under the system _sys_. If the _sys_ is NULL (not specified)=
,
+the first event with _name_ is returned.
+
+The tep_find_event_by_record()_ function searches for an event from a give=
n=20
+_record_.
+
+RETURN VALUE
+------------
+All these functions return a pointer to the found event, or NULL if there =
is no=20
+such event.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+struct tep_event *event;
+
+event =3D tep_find_event(tep, 1857);
+if (event =3D=3D NULL) {
+	/* There is no event with ID 1857 */
+}
+
+event =3D tep_find_event_by_name(tep, "kvm", "kvm_exit");
+if (event =3D=3D NULL) {
+	/* There is no kvm_exit event, from kvm system */
+}
+
+void event_from_record(struct tep_record *record)
+{
+ struct tep_event *event =3D tep_find_event_by_record(tep, record);
+	if (event =3D=3D NULL) {
+		/* There is no event from given record */
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
