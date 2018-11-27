Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr690079.outbound.protection.outlook.com ([40.107.69.79]:56248
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726681AbeK1Cln (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:41:43 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 33/46] tools/lib/traceevent: Man page for
 tep_filter_make_string()
Date: Tue, 27 Nov 2018 15:42:49 +0000
Message-ID: <20181127154153.11315-34-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man page for tep_filter_make_string()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-filter_show.txt             | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
_show.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter_show.t=
xt b/tools/lib/traceevent/Documentation/libtraceevent-filter_show.txt
new file mode 100644
index 000000000000..889b9328f87f
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter_show.txt
@@ -0,0 +1,75 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_filter_make_string - Returns a string showing the filter.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+char pass:[*]*tep_filter_make_string*(struct tep_event_filter pass:[*]_fil=
ter_, int _event_id_);
+--
+
+DESCRIPTION
+-----------
+The _tep_filter_make_string()_ function constructs a string, displaying=20
+the _filter_ contents for given _event_id_.
+
+RETURN VALUE
+------------
+The _tep_filter_make_string()_ function returns a string, which must be fr=
eed=20
+with free(), or NULL in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+struct tep_event_filter *filter =3D tep_filter_alloc(tep);
+...
+char *fstring =3D tep_filter_make_string(filter, 352);
+if (fstring !=3D NULL) {
+	/* The filter for event 352 is in fstring */
+	free(fstring);
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
