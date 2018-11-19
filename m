Return-Path: <SRS0=OAlf=N6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790045.outbound.protection.outlook.com ([40.107.79.45]:56480
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728991AbeKSXSY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Nov 2018 18:18:24 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 26/34] tools/lib/traceevent: Man page for
 tep_parse_header_page()
Date: Mon, 19 Nov 2018 12:54:38 +0000
Message-ID: <20181119125357.19449-27-tstoyanov@vmware.com>
References: <20181119125357.19449-1-tstoyanov@vmware.com>
In-Reply-To: <20181119125357.19449-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man page for tep_parse_header_page()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-parse_head.txt              | 82 +++++++++++++++++++
 1 file changed, 82 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-parse_=
head.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-parse_head.tx=
t b/tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt
new file mode 100644
index 000000000000..a5e7295b911c
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-parse_head.txt
@@ -0,0 +1,82 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_parse_header_page - Parses the data stored in the header page.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_parse_header_page*(struct tep_handle pass:[*]_tep_, char pass:[*]=
_buf_, unsigned long _size_, int _long_size_);
+--
+
+DESCRIPTION
+-----------
+The _tep_parse_header_page()_ function parses the header page data from _b=
uf_,=20
+and initializes the _tep_, trace event parser context, with it. The buffer=
=20
+_buf_ is with _size_, and is supposed to be copied from=20
+tracefs/events/header_page.=20
+
+Some old kernels do not have header page info, in this case the=20
+_tep_parse_header_page()_ function  can be called with _size_ equal to 0. =
The=20
+_tep_ context is initialized with default values. The _long_size_ can be u=
sed in
+this use case, to set the size of a long integer to be used.=20
+
+RETURN VALUE
+------------
+The _tep_parse_header_page()_ function returns 0 in case of success, or -1=
=20
+in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+char *buf;
+int size;
+buf =3D read_file("/sys/kernel/tracing/events/header_page", &size);
+if (tep_parse_header_page(tep, buf, size, sizeof(unsigned long)) !=3D 0) {
+	/* Failed to parse the header page */
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
