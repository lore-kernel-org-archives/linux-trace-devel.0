Return-Path: <SRS0=lo60=NR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710077.outbound.protection.outlook.com ([40.107.71.77]:38016
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388065AbeKFWqG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Nov 2018 17:46:06 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 3/7] tools/lib/traceevent: Implement libtraceevent man pages
Date: Tue, 6 Nov 2018 13:20:52 +0000
Message-ID: <20181106132035.7692-4-tstoyanov@vmware.com>
References: <20181106132035.7692-1-tstoyanov@vmware.com>
In-Reply-To: <20181106132035.7692-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch implements a man page, which documents
tep_is_file_bigendian() and tep_set_file_bigendian()
libtraceevent APIs

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-file_endian.txt             | 87 +++++++++++++++++++
 1 file changed, 87 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-file_e=
ndian.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-file_endian.t=
xt b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
new file mode 100644
index 000000000000..403db4e23b3f
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
@@ -0,0 +1,87 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_is_file_bigendian,tep_set_file_bigendian - Get / set the endianess of =
the=20
+trace.dat file=20
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_endian* {
+	TEP_LITTLE_ENDIAN =3D 0,
+	TEP_BIG_ENDIAN
+};
+
+int *tep_is_file_bigendian*(struct tep_handle pass:[*]_tep_);
+void *tep_set_file_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_en=
dian _endian_);
+
+--
+DESCRIPTION
+-----------
+The _tep_is_file_bigendian()_ function returns the endianess of the trace.=
dat file.=20
+The _tep_ argument is trace event parser context.
+
+The _tep_set_file_bigendian()_ set the endianess of the trace.dat file.
+The _tep_ argument is trace event parser context. The _endian_ argument is=
 the endianess:
+	_TEP_LITTLE_ENDIAN_ - the file is in little endian format,
+	_TEP_BIG_ENDIAN_ - the file is in big endian format.
+This information is saved in the trace.dat file.
+
+RETURN VALUE
+------------
+The _tep_is_file_bigendian()_ function returns _TEP_LITTLE_ENDIAN_ or _TEP=
_BIG_ENDIAN_.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+	tep_set_file_bigendian(tep, TEP_LITTLE_ENDIAN);
+...
+	if (TEP_BIG_ENDIAN =3D=3D tep_is_file_bigendian(tep)) {
+		/* The file is in big endian */
+	} else {
+		/* The file is in little endian */
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
2.17.2
