Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810083.outbound.protection.outlook.com ([40.107.81.83]:28000
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727800AbeKIXNM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 18:13:12 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 11/11] tools/lib/traceevent: Man page for tep_strerror()
Date: Fri, 9 Nov 2018 13:31:59 +0000
Message-ID: <20181109133135.25804-11-tstoyanov@vmware.com>
References: <20181109133135.25804-1-tstoyanov@vmware.com>
In-Reply-To: <20181109133135.25804-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man page for tep_strerror() as part of libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-strerror.txt  | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-strerr=
or.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt =
b/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
new file mode 100644
index 000000000000..fde1bd71b679
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-strerror.txt
@@ -0,0 +1,78 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_strerror - Returns a string describing regular errno and tep error num=
ber.=20
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_strerror*(struct tep_handle pass:[*]_tep_, enum tep_errno _errnum=
_, char pass:[*]_buf_, size_t _buflen_);
+
+--
+DESCRIPTION
+-----------
+The _tep_strerror()_ function converts tep error number into a human reada=
ble string.
+The _tep_ argument is trace event parser context. The _errnum_ is a regula=
r errno,
+defined in errno.h, or a tep error number. The string, describing this err=
or number=20
+is copied in the _buf_ argument. The _buflen_ argument is the size of the =
_buf_.
+
+RETURN VALUE
+------------
+The _tep_strerror()_ function returns 0, if a valid _errnum_ is passed and=
 the=20
+string is copied into _buf_. If _errnum_ is not a valid error number, -1 i=
s returned=20
+and _buf_ is not modified.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+char buf[32];=20
+char *pool =3D calloc(1, 128);
+if (tep =3D=3D NULL) {
+	tep_strerror(tep, TEP_ERRNO__MEM_ALLOC_FAILED, buf, 32);
+	printf ("The pool is not initialized, %s", buf);
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
2.17.2
