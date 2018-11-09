Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810079.outbound.protection.outlook.com ([40.107.81.79]:10688
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727667AbeKIXMk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 18:12:40 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 08/11] tools/lib/traceevent: Man page for
 tep_is_host_bigendian() and tep_set_host_bigendian()
Date: Fri, 9 Nov 2018 13:31:55 +0000
Message-ID: <20181109133135.25804-8-tstoyanov@vmware.com>
References: <20181109133135.25804-1-tstoyanov@vmware.com>
In-Reply-To: <20181109133135.25804-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_is_host_bigendian() and tep_set_host_bigendian()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-host_endian.txt             | 90 +++++++++++++++++++
 1 file changed, 90 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-host_e=
ndian.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-host_endian.t=
xt b/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
new file mode 100644
index 000000000000..250eb430c06a
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
@@ -0,0 +1,90 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_is_host_bigendian,tep_set_host_bigendian,tep_host_bigendian - Get / se=
t the endianess of=20
+the machine running the current code.
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
+int *tep_is_host_bigendian*(struct tep_handle pass:[*]_tep_);
+void *tep_set_host_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_en=
dian _endian_);
+int tep_host_bigendian(void);
+--
+
+DESCRIPTION
+-----------
+The _tep_is_host_bigendian()_ function returns the endianess of the the ma=
chine=20
+running the current code. The _tep_ argument is trace event parser context=
.
+
+The _tep_set_host_bigendian()_ set the endianess of the machine running th=
e code.
+The _tep_ argument is trace event parser context. The _endian_ argument is=
 the endianess:
+[verse]
+--
+	_TEP_LITTLE_ENDIAN_ - the machine is little endian,
+	_TEP_BIG_ENDIAN_ - the machine is big endian.
+--
+
+RETURN VALUE
+------------
+The _tep_is_host_bigendian()_ function returns _TEP_LITTLE_ENDIAN_ or _TEP=
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
+	tep_set_host_bigendian(tep, TEP_LITTLE_ENDIAN);
+...
+	if (TEP_BIG_ENDIAN =3D=3D tep_is_host_bigendian(tep)) {
+		/* The local host is big endian */
+	} else {
+		/* The local host is little endian */
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
