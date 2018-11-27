Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730072.outbound.protection.outlook.com ([40.107.73.72]:22643
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729309AbeK1Ckz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:40:55 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 15/46] tools/lib/traceevent: Man pages for
 tep_register_function() and tep_register_print_string()
Date: Tue, 27 Nov 2018 15:42:25 +0000
Message-ID: <20181127154153.11315-16-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_register_function() and tep_register_print_string(=
)
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-reg_funcstr.txt             | 89 +++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_fu=
ncstr.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_funcstr.t=
xt b/tools/lib/traceevent/Documentation/libtraceevent-reg_funcstr.txt
new file mode 100644
index 000000000000..b0e196a1e47b
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_funcstr.txt
@@ -0,0 +1,89 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_register_function, tep_register_print_string - Registers a function / =
string=20
+with a given address.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_register_function*(struct tep_handle pass:[*]_tep_, char pass:[*]=
_name_, unsigned long long _addr_, char pass:[*]_mod_);
+int *tep_register_print_string*(struct tep_handle pass:[*]_tep_, const cha=
r pass:[*]_fmt_, unsigned long long _addr_);
+--
+
+DESCRIPTION
+-----------
+The _tep_register_function()_ function registers a function name with an=20
+address and module. The _tep_ argument is the trace event parser context. =
The=20
+_name_ is the name of the function, the string is copied internally. The _=
addr_=20
+is the start address of the function. The _mod_ is the kernel module=20
+the function may be in (NULL for none).=20
+
+The _tep_register_print_string()_ function  registers a string by the addr=
ess=20
+it was stored in the kernel. The _tep_ argument is the trace event parser=
=20
+context. The _fmt_ is the string to register, it is copied internally. The=
 _addr_=20
+is the address the string was located at.
+
+RETURN VALUE
+------------
+The _tep_register_function()_ function returns 0 in case of success. In ca=
se of=20
+an error -1 is returned, and errno is set to the appropriate error number.
+
+The _tep_register_print_string()_ function returns 0 in case of success. I=
n case=20
+of an error -1 is returned, and errno is set to the appropriate error numb=
er.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+	if (tep_register_function(tep, "my_custom_func",
+			  	 (unsigned long long) 0x12345678, NULL) !=3D 0) {
+		/* Failed to register my_custom_func address mapping */
+	}
+...
+	if (tep_register_print_string(tep, "print string",
+			  	 (unsigned long long) 0x87654321, NULL) !=3D 0) {
+		/* Failed to register "print string" address mapping */
+	}
+--
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
