Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr690078.outbound.protection.outlook.com ([40.107.69.78]:52480
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726624AbeK1ClR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:41:17 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 29/46] tools/lib/traceevent: Man page for
 tep_filter_strerror()
Date: Tue, 27 Nov 2018 15:42:44 +0000
Message-ID: <20181127154153.11315-30-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man page for tep_filter_strerror()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-filter_error.txt            | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
_error.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter_error.=
txt b/tools/lib/traceevent/Documentation/libtraceevent-filter_error.txt
new file mode 100644
index 000000000000..64e3aa809838
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter_error.txt
@@ -0,0 +1,78 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_filter_strerror - Fills the filter error message in a buffer.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_filter_strerror*(struct tep_event_filter pass:[*]_filter_, enum t=
ep_errno _err_, char pass:[*]buf, size_t _buflen_);
+--
+
+DESCRIPTION
+-----------
+The _tep_filter_strerror()_ function copies the _filter_ error buffer into=
 the=20
+given _buf_ with the size _buflen_. If the error buffer is empty, in the _=
buf_=20
+is copied a string, describing the error _err_.=20
+
+RETURN VALUE
+------------
+The _tep_filter_strerror()_ function returns 0 if message was filled=20
+successfully, or -1 in case of an error.
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
