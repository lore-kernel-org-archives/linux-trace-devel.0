Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr690079.outbound.protection.outlook.com ([40.107.69.79]:56248
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbeK1Cli (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:41:38 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 32/46] tools/lib/traceevent: Man pages for
 tep_filter_copy() and tep_filter_compare()
Date: Tue, 27 Nov 2018 15:42:48 +0000
Message-ID: <20181127154153.11315-33-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_filter_copy() and tep_filter_compare()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-filter_oper.txt             | 84 +++++++++++++++++++
 1 file changed, 84 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
_oper.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter_oper.t=
xt b/tools/lib/traceevent/Documentation/libtraceevent-filter_oper.txt
new file mode 100644
index 000000000000..5ddae5819a99
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter_oper.txt
@@ -0,0 +1,84 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_filter_copy,tep_filter_compare - Copy / compare operations with event =
filters.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_filter_copy*(struct tep_event_filter pass:[*]_dest_, struct tep_e=
vent_filter pass:[*]_source_);
+int *tep_filter_compare*(struct tep_event_filter pass:[*]_filter1_, struct=
 tep_event_filter pass:[*]_filter2_);
+--
+
+DESCRIPTION
+-----------
+The _tep_filter_copy()_ function copies a _source_ filter into a _dest_ fi=
lter.
+
+The _tep_filter_compare()_ function compares two filers - _filter1_ and _f=
ilter2_.
+
+RETURN VALUE
+------------
+The _tep_filter_copy()_ function returns 0 on success or -1 if not all rul=
es
+ were copied.
+=20
+The _tep_filter_compare()_ function returns 1 if the two filters hold the =
same=20
+content, or 0 if they do not.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+struct tep_event_filter *filter1 =3D tep_filter_alloc(tep);
+struct tep_event_filter *filter2 =3D tep_filter_alloc(tep);
+...
+if (tep_filter_copy(filter1, filter2) !=3D 0) {
+	/* Failed to copy filter2 in filter1 */
+}
+...
+if (tep_filter_compare(filter1, filter2) !=3D 1) {
+	/* Both filters are different */
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
