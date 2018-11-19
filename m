Return-Path: <SRS0=OAlf=N6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700074.outbound.protection.outlook.com ([40.107.70.74]:19586
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728872AbeKSXSj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Nov 2018 18:18:39 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 14/34] tools/lib/traceevent: Man pages for
 tep_event_common_fields() and tep_event_fields()
Date: Mon, 19 Nov 2018 12:54:25 +0000
Message-ID: <20181119125357.19449-15-tstoyanov@vmware.com>
References: <20181119125357.19449-1-tstoyanov@vmware.com>
In-Reply-To: <20181119125357.19449-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_event_common_fields() and tep_event_fields()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-fields.txt    | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-fields=
.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-fields.txt b/=
tools/lib/traceevent/Documentation/libtraceevent-fields.txt
new file mode 100644
index 000000000000..45e1e05cbfb2
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-fields.txt
@@ -0,0 +1,99 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_event_common_fields,tep_event_fields - Get a list of fields for an eve=
nt.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_format_field pass:[*]pass:[*]*tep_event_common_fields*(struct t=
ep_event pass:[*]_event_);
+struct tep_format_field pass:[*]pass:[*]*tep_event_fields*(struct tep_even=
t pass:[*]_event_);
+--
+
+DESCRIPTION
+-----------
+The _tep_event_common_fields()_ function returns an array of pointers to c=
ommon=20
+fields for the _event_. The array is allocated in the function and must be=
 freed
+by free(). The last element of the array is NULL.
+
+The _tep_event_fields()_ function returns an array of pointers to event sp=
ecific=20
+fields for the _event_. The array is allocated in the function and must be=
 freed
+by free(). The last element of the array is NULL.
+
+RETURN VALUE
+------------
+Both _tep_event_common_fields()_ and _tep_event_fields()_ functions return
+an array of pointers to tep_format_field structures in case of success, or
+NULL in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+int i;
+struct tep_format_field **fields;
+struct tep_event *event =3D tep_find_event_by_name(tep, "kvm", "kvm_exit")=
;
+if (event !=3D NULL) {
+	fields =3D tep_event_common_fields(event);
+	if (fields !=3D NULL) {
+		i =3D 0;
+		while (fields[i]) {
+			/* walk through the list of the common fields of the kvm_exit event */
+			i++;
+		}
+		free(fields);
+	}
+	fields =3D tep_event_fields(event);
+	if (fields !=3D NULL) {
+		i =3D 0;
+		while (fields[i]) {
+			/* walk through the list of the event specific fields of the kvm_exit e=
vent */
+			i++;
+		}
+		free(fields);
+	}=09
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
