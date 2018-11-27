Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr800049.outbound.protection.outlook.com ([40.107.80.49]:61440
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729957AbeK1Ck4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:40:56 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 08/46] tools/lib/traceevent: Man page for
 tep_is_file_bigendian() and tep_set_file_bigendian()
Date: Tue, 27 Nov 2018 15:42:16 +0000
Message-ID: <20181127154153.11315-9-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_is_file_bigendian() and tep_set_file_bigendian()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-file_endian.txt             | 89 +++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-file_e=
ndian.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-file_endian.t=
xt b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
new file mode 100644
index 000000000000..2b763aaf9c6b
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
@@ -0,0 +1,89 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_file_bigendian,tep_set_file_bigendian - Get / set the endianess of the=
=20
+raw data, being accessed by the tep handler.=20
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
+int *tep_file_bigendian*(struct tep_handle pass:[*]_tep_);
+void *tep_set_file_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_en=
dian _endian_);
+
+--
+DESCRIPTION
+-----------
+The _tep_file_bigendian()_ function returns the endianess of the raw data,
+being accessed by the tep handler. The _tep_ argument is trace event parse=
r context.
+
+The _tep_set_file_bigendian()_ set the endianess of raw data, the being ac=
cessed=20
+by the tep handler. The _tep_ argument is trace event parser context.
+[verse]
+--
+The _endian_ argument is the endianess:
+	_TEP_LITTLE_ENDIAN_ - the raw data is in little endian format,
+	_TEP_BIG_ENDIAN_ - the raw data is in big endian format.
+--
+RETURN VALUE
+------------
+The _tep_file_bigendian()_ function returns _TEP_LITTLE_ENDIAN_ or _TEP_BI=
G_ENDIAN_.
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
+	if (TEP_BIG_ENDIAN =3D=3D tep_file_bigendian(tep)) {
+		/* The raw data is in big endian */
+	} else {
+		/* The raw data is in little endian */
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
