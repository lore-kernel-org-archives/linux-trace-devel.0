Return-Path: <SRS0=lo60=NR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710057.outbound.protection.outlook.com ([40.107.71.57]:57353
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388105AbeKFWqJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Nov 2018 17:46:09 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 6/7] tools/lib/traceevent: Implement libtraceevent man pages
Date: Tue, 6 Nov 2018 13:20:56 +0000
Message-ID: <20181106132035.7692-7-tstoyanov@vmware.com>
References: <20181106132035.7692-1-tstoyanov@vmware.com>
In-Reply-To: <20181106132035.7692-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch implements a man page, which documents
tep_get_page_size() and tep_set_page_size()
libtraceevent APIs

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-page_size.txt | 79 +++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_s=
ize.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt=
 b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
new file mode 100644
index 000000000000..d2bad8dca42d
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
@@ -0,0 +1,79 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_get_page_size,tep_set_page_size - Get / set the size of a memory page =
on the=20
+machine, where the trace is generated=20
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
+void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_)=
;
+--
+
+DESCRIPTION
+-----------
+The _tep_get_page_size()_ function returns the size of a memory page on=20
+the machine, where the trace is generated. The _tep_ argument is trace eve=
nt parser context.
+
+The _tep_set_page_size()_ function sets the size of a memory page on the m=
achine,=20
+where the trace is generated. The _tep_ argument is trace event parser con=
text.
+The _page_size_ argument is the size of a memory page, in bytes.=20
+This information is saved in the trace.dat file.=20
+
+RETURN VALUE
+------------
+The _tep_get_page_size()_ function returns size, in bytes, of the memory p=
age.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+	int page_size =3D 4096;
+	tep_set_page_size(tep, page_size);
+	if ( 4096 !=3D tep_get_page_size(tep)) {
+		/* Something wrong happened, page size is not set as expected */
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
