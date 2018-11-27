Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:24265
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbeK1Clo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:41:44 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 35/46] tools/lib/traceevent: Man pages for
 tep_find_function() and tep_find_function_address()
Date: Tue, 27 Nov 2018 15:42:52 +0000
Message-ID: <20181127154153.11315-36-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_find_function() and tep_find_function_address()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-func_find.txt | 88 +++++++++++++++++++
 1 file changed, 88 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_f=
ind.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-func_find.txt=
 b/tools/lib/traceevent/Documentation/libtraceevent-func_find.txt
new file mode 100644
index 000000000000..3826269bde6f
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-func_find.txt
@@ -0,0 +1,88 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_find_function,tep_find_function_address - Find function name / start a=
ddress.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+const char pass:[*]*tep_find_function*(struct tep_handle pass:[*]_tep_, un=
signed long long _addr_);
+unsigned long long *tep_find_function_address*(struct tep_handle pass:[*]_=
tep_, unsigned long long _addr_);
+--
+
+DESCRIPTION
+-----------
+These functions can be used to find function name and start address, by gi=
ven=20
+address. The given address does not have to be exact, it will select the f=
unction=20
+that would contain it.
+
+The _tep_find_function()_ function returns the function name, which contai=
ns the
+given address _addr_. The _tep_ argument is the trace event parser context=
.
+
+The _tep_find_function_address()_ function returns the function start addr=
ess,=20
+by given address _addr_. The _addr_ does not have to be exact, it will sel=
ect the function=20
+that would contain it. The _tep_ argument is the trace event parser contex=
t.
+
+RETURN VALUE
+------------
+The _tep_find_function()_ function returns the function name, or NULL in c=
ase=20
+it cannot be found.
+
+The _tep_find_function_address()_ function returns the function start addr=
ess,=20
+or 0 in case it cannot be found.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+void show_function( unsigned long long addr)
+{
+	const char *fname =3D tep_find_function(tep, addr);
+	unsigned long long fstart =3D tep_find_function_address(tep, addr);
+=09
+	/* addr is in function named fname, starting at fstart address, at offset=
 (addr - fstart) */
+}=20
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
