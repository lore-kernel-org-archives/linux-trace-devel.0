Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810079.outbound.protection.outlook.com ([40.107.81.79]:10688
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727667AbeKIXNV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 18:13:21 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 10/11] tools/lib/traceevent: Man page for
 tep_get_page_size() and tep_set_page_size()
Date: Fri, 9 Nov 2018 13:31:57 +0000
Message-ID: <20181109133135.25804-10-tstoyanov@vmware.com>
References: <20181109133135.25804-1-tstoyanov@vmware.com>
In-Reply-To: <20181109133135.25804-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_get_page_size() and tep_set_page_size()
as part of the libtraceevent APIs. It also alignes description of
the functions (in the C code) with the man pages.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-page_size.txt | 80 +++++++++++++++++++
 tools/lib/traceevent/event-parse-api.c        | 12 ++-
 2 files changed, 88 insertions(+), 4 deletions(-)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-page_s=
ize.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt=
 b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
new file mode 100644
index 000000000000..015664b96197
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-page_size.txt
@@ -0,0 +1,80 @@
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
+the machine, where the trace is generated. The _tep_ argument is trace=20
+event parser context.
+
+The _tep_set_page_size()_ function stores in the _tep_ context the size of=
 a=20
+memory page on the machine, where the trace is generated.=20
+The _tep_ argument is trace event parser context.
+The _page_size_ argument is the size of a memory page, in bytes.=20
+
+RETURN VALUE
+------------
+The _tep_get_page_size()_ function returns size of the memory page, in byt=
es.
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
diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/=
event-parse-api.c
index 9137862261a5..39e0fca2d9a2 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -170,10 +170,12 @@ void tep_set_long_size(struct tep_handle *pevent, int=
 long_size)
 }
=20
 /**
- * tep_get_page_size - get the size of a memory page on the current machin=
e
+ * tep_get_page_size - get the size of a memory page on the machine,
+ * 			where the trace is generated
  * @pevent: a handle to the tep_handle
  *
- * This returns the size of a memory page on the current machine
+ * This returns the size of a memory page on the machine,
+ * where the trace is generated
  * If @pevent is NULL, 0 is returned.
  */
 int tep_get_page_size(struct tep_handle *pevent)
@@ -184,11 +186,13 @@ int tep_get_page_size(struct tep_handle *pevent)
 }
=20
 /**
- * tep_set_page_size - set the size of a memory page on the current machin=
e
+ * tep_set_page_size - set the size of a memory page on the machine,
+ * 			where the trace is generated
  * @pevent: a handle to the tep_handle
  * @_page_size: size of a memory page, in bytes
  *
- * This sets the size of a memory page on the current machine
+ * This sets the size of a memory page on the machine,
+ * where the trace is generated
  */
 void tep_set_page_size(struct tep_handle *pevent, int _page_size)
 {
--=20
2.17.2
