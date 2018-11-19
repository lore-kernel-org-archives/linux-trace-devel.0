Return-Path: <SRS0=OAlf=N6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710056.outbound.protection.outlook.com ([40.107.71.56]:22208
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728890AbeKSXRz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Nov 2018 18:17:55 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 05/34] tools/lib/traceevent: Man page for tep_read_number()
Date: Mon, 19 Nov 2018 12:54:14 +0000
Message-ID: <20181119125357.19449-6-tstoyanov@vmware.com>
References: <20181119125357.19449-1-tstoyanov@vmware.com>
In-Reply-To: <20181119125357.19449-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man page for tep_read_number() as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-endian_read.txt             | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-endian=
_read.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-endian_read.t=
xt b/tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt
new file mode 100644
index 000000000000..7f355e439a6e
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-endian_read.txt
@@ -0,0 +1,76 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_read_number - Reads a number from raw data.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+unsigned long long *tep_read_number*(struct tep_handle pass:[*]_tep_, cons=
t void pass:[*]_ptr_, int _size_);
+--
+
+DESCRIPTION
+-----------
+The _tep_read_number()_ function reads an integer from raw data, taking in=
to=20
+account the endianness of the raw data and the current host. The _tep_ arg=
ument=20
+is the trace event parser context. The _ptr_ is a pointer to the raw data,=
 where=20
+the integer is, and the _size_ is the size of the integer.=20
+
+RETURN VALUE
+------------
+The _tep_read_number()_ function returns the integer in the byte order of=
=20
+the current host. In case of an error, 0 is returned.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+void process_record(struct tep_record *record)
+{
+	int data =3D tep_read_number(tep, record->data, 4);
+	/* Read the first 4 bytes of the record as integer */
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
