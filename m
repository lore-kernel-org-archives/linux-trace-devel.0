Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810050.outbound.protection.outlook.com ([40.107.81.50]:60028
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727784AbeKIXNR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 18:13:17 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 05/11] tools/lib/traceevent: Man page for
 tep_get_header_page_size()
Date: Fri, 9 Nov 2018 13:31:51 +0000
Message-ID: <20181109133135.25804-5-tstoyanov@vmware.com>
References: <20181109133135.25804-1-tstoyanov@vmware.com>
In-Reply-To: <20181109133135.25804-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create a man page for tep_get_header_page_size(),
as part of the libtraceevent API.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-header_size.txt             | 73 +++++++++++++++++++
 tools/lib/traceevent/event-parse-api.c        |  4 +-
 2 files changed, 75 insertions(+), 2 deletions(-)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-header=
_size.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-header_size.t=
xt b/tools/lib/traceevent/Documentation/libtraceevent-header_size.txt
new file mode 100644
index 000000000000..8edf49d2a709
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-header_size.txt
@@ -0,0 +1,73 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_get_header_page_size - Get the size of a long integer, in kernel conte=
xt.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_get_header_page_size*(struct tep_handle pass:[*]_tep_);
+
+--
+DESCRIPTION
+-----------
+The _tep_get_header_page_size()_ function returns the size of a long integ=
er,
+in kernel context. The _tep_ argument is trace event parser context.
+This information is retrieved from /sys/kernel/debug/tracing/events/header=
_page,
+ "commit" field.
+
+RETURN VALUE
+------------
+The _tep_get_header_page_size()_ function returns the size of a long integ=
er,=20
+in bytes
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+	int lsize =3D tep_get_header_page_size(tep);
+	printf ("The size of a long in kernel context is %d bytes", lsize);
+...=09
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
diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/=
event-parse-api.c
index c0bbd7864f53..9137862261a5 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -100,10 +100,10 @@ tep_data2host8(struct tep_handle *pevent, unsigned lo=
ng long data)
 }
=20
 /**
- * tep_get_header_page_size - get size of the header page
+ * tep_get_header_page_size - get the size of a long integer, in kernel co=
ntext
  * @pevent: a handle to the tep_handle
  *
- * This returns size of the header page
+ * This returns the size of a long integer, in kernel context
  * If @pevent is NULL, 0 is returned.
  */
 int tep_get_header_page_size(struct tep_handle *pevent)
--=20
2.17.2
