Return-Path: <SRS0=OAlf=N6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700074.outbound.protection.outlook.com ([40.107.70.74]:19586
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728922AbeKSXSk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Nov 2018 18:18:40 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 15/34] tools/lib/traceevent: Man pages for tep_filter_alloc(),
 tep_filter_free() and tep_filter_reset()
Date: Mon, 19 Nov 2018 12:54:26 +0000
Message-ID: <20181119125357.19449-16-tstoyanov@vmware.com>
References: <20181119125357.19449-1-tstoyanov@vmware.com>
In-Reply-To: <20181119125357.19449-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages tep_filter_alloc(), tep_filter_free() and tep_filter_reset=
()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-filter.txt    | 85 +++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter.txt b/=
tools/lib/traceevent/Documentation/libtraceevent-filter.txt
new file mode 100644
index 000000000000..8b51f246b402
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter.txt
@@ -0,0 +1,85 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_filter_alloc,tep_filter_free,tep_filter_reset - Create / free / reset =
an event filter.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_event_filter pass:[*]*tep_filter_alloc*(struct tep_handle pass:=
[*]_tep_);
+void *tep_filter_free*(struct tep_event_filter pass:[*]_filter_);
+void *tep_filter_reset*(struct tep_event_filter pass:[*]_filter_);
+--
+
+DESCRIPTION
+-----------
+The _tep_filter_alloc()_ function creates a new event filter. The _tep_ ar=
gument
+is the trace event parser context.
+
+The _tep_filter_free()_ function frees an event filter and all resources t=
hat it=20
+had used.=20
+
+The _tep_filter_reset()_ function removes all rules from an event filter a=
nd=20
+resets it.
+
+RETURN VALUE
+------------
+The _tep_filter_alloc()_ function returns a pointer to the newly created e=
vent
+filter, or NULL in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+struct tep_event_filter *filter =3D tep_filter_alloc(tep);
+if (filter =3D=3D NULL) {
+	/* Failed to create the filter */
+}
+...
+tep_filter_reset(filter);
+...
+tep_filter_free(filter);
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
