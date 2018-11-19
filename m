Return-Path: <SRS0=OAlf=N6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700074.outbound.protection.outlook.com ([40.107.70.74]:19586
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728872AbeKSXSg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Nov 2018 18:18:36 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 10/34] tools/lib/traceevent: Man pages
 tep_find_common_field(), tep_find_field() and tep_find_any_field()
Date: Mon, 19 Nov 2018 12:54:20 +0000
Message-ID: <20181119125357.19449-11-tstoyanov@vmware.com>
References: <20181119125357.19449-1-tstoyanov@vmware.com>
In-Reply-To: <20181119125357.19449-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_find_common_field(), tep_find_field()
and tep_find_any_field() as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-field_find.txt              | 98 +++++++++++++++++++
 1 file changed, 98 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_=
find.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_find.tx=
t b/tools/lib/traceevent/Documentation/libtraceevent-field_find.txt
new file mode 100644
index 000000000000..a5afe260285a
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-field_find.txt
@@ -0,0 +1,98 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_find_common_field,tep_find_field,tep_find_any_field - Search for a fie=
ld in an event.=20
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_format_field pass:[*]*tep_find_common_field*(struct tep_event p=
ass:[*]_event_, const char pass:[*]_name_);
+struct tep_format_field pass:[*]*tep_find_field*(struct tep_event_ormat pa=
ss:[*]_event_, const char pass:[*]_name_);
+struct tep_format_field pass:[*]*tep_find_any_field*(struct tep_event pass=
:[*]_event_, const char pass:[*]_name_);
+--
+
+DESCRIPTION
+-----------
+These functions search for a field with given name in an event.
+
+The _tep_find_common_field()_ function searches for a common field with _n=
ame_=20
+in the _event_.
+
+The _tep_find_field()_ function searches for an event specific field with
+_name_ in the _event_.
+
+The _tep_find_any_field()_ function searches for any field with _name_ in =
the=20
+_event_.
+
+RETURN VALUE
+------------
+The _tep_find_common_field(), _tep_find_field()_ and _tep_find_any_field()=
_
+functions return a pointer to the found field, or NULL in case there is no=
 field
+with the requested name.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+struct tep_event *event =3D tep_find_event_by_name(tep, "timer", "hrtimer_=
start");
+...
+	struct tep_format_field *field;
+
+	field =3D tep_find_common_field(event, "common_pid");
+	if (field =3D=3D NULL) {
+		/* Cannot find "common_pid" common field in the event */
+	}
+
+	field =3D tep_find_field(event, "softexpires");
+	if (field =3D=3D NULL) {
+		/* Cannot find "softexpires" event specific field in the event */
+	}
+=09
+	field =3D tep_find_any_field(event, "mode");
+	if (field =3D=3D NULL) {
+		/* Cannot find "mode" field in the event */
+	}
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
