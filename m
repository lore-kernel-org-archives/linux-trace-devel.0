Return-Path: <SRS0=OAlf=N6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700074.outbound.protection.outlook.com ([40.107.70.74]:19586
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728872AbeKSXSk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Nov 2018 18:18:40 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 16/34] tools/lib/traceevent: Man page for
 tep_filter_add_filter_str()
Date: Mon, 19 Nov 2018 12:54:27 +0000
Message-ID: <20181119125357.19449-17-tstoyanov@vmware.com>
References: <20181119125357.19449-1-tstoyanov@vmware.com>
In-Reply-To: <20181119125357.19449-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man page for tep_filter_add_filter_str()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-filter_add.txt              | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
_add.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter_add.tx=
t b/tools/lib/traceevent/Documentation/libtraceevent-filter_add.txt
new file mode 100644
index 000000000000..37208be468f8
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter_add.txt
@@ -0,0 +1,78 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_filter_add_filter_str - Adds a new rule to a filter.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum tep_errno *tep_filter_add_filter_str*(struct tep_event_filter pass:[*=
]_filter_, const char pass:[*]_filter_str_);
+--
+
+DESCRIPTION
+-----------
+The _tep_filter_add_filter_str()_ function adds a new rule to the _filter_=
. The=20
+_filter_str_ argument is the filter string, that contains the rule.
+
+RETURN VALUE
+------------
+The _tep_filter_add_filter_str()_ function returns 0 if the rule was=20
+successfully added or a negative error code.  Use _tep_filter_strerror()_ =
to see=20
+actual error message in case of an error.
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
+int ret;
+char errstr[200];
+ret =3D tep_filter_add_filter_str(filter, "sched/sched_wakeup:target_cpu=
=3D=3D1");=20
+if(ret < 0) {
+	tep_filter_strerror(filter, ret, errstr, sizeof(errstr));
+	/* Failed to add a new rule to the filter, the error string is in errstr =
*/
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
+_libtraceevent(3)_, _trace-cmd(1)_, _tep_filter_strerror(3)_
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
