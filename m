Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:24265
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726681AbeK1Clr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:41:47 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 36/46] tools/lib/traceevent: Man pages for
 tep_set_function_resolver() and tep_reset_function_resolver()
Date: Tue, 27 Nov 2018 15:42:53 +0000
Message-ID: <20181127154153.11315-37-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_set_function_resolver() and tep_reset_function_res=
olver()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-func_resolve.txt            | 96 +++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-func_r=
esolve.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-func_resolve.=
txt b/tools/lib/traceevent/Documentation/libtraceevent-func_resolve.txt
new file mode 100644
index 000000000000..4965cc6c79dc
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-func_resolve.txt
@@ -0,0 +1,96 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_set_function_resolver,tep_reset_function_resolver - Set / reset an alt=
ernative function resolver
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+typedef char pass:[*](*tep_func_resolver_t*)(void pass:[*]_priv_, unsigned=
 long long pass:[*]_addrp_, char pass:[**]_modp_);
+
+int *tep_set_function_resolver*(struct tep_handle pass:[*]_tep_, tep_func_=
resolver_t pass:[*]_func_, void pass:[*]_priv_);
+void *tep_reset_function_resolver*(struct tep_handle pass:[*]_tep_);
+--
+
+DESCRIPTION
+-----------
+Some tools may have already a way to resolve the kernel functions. These A=
PIs
+allow them to keep using it instead of duplicating all the entries inside.
+
+The _tep_set_function_resolver()_ function registers _func_ as an alternat=
ive=20
+kernel functions resolver. The _tep_ argument is trace event parser contex=
t.
+The _priv_ argument is a custom context of the _func_ function.
+
+The _tep_reset_function_resolver()_ function resets the kernel functions=20
+resolver to the default function.  The _tep_ argument is trace event parse=
r=20
+context.
+
+The _tep_func_resolver_t_ type is the prototype of the alternative kernel=
=20
+functions resolver. This function receives a pointer to its custom context=
=20
+(set with the _tep_set_function_resolver()_ call ) and the address of a ke=
rnel=20
+function, which has to be resolved. In case of success, it should return=20
+the name of the function and its module (if any) in _modp_.
+
+RETURN VALUE
+------------
+The _tep_set_function_resolver()_ function returns 0 in case of success, o=
r -1
+in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+char *my_resolve_kernel_addr(void *context, unsigned long long *addrp, cha=
r **modp)
+{=09
+	return NULL;
+}
+...
+	if (tep_set_function_resolver(tep, my_resolve_kernel_addr, NULL) !=3D 0) =
{
+		/* failed to register my_resolve_kernel_addr */
+	}
+...
+	tep_reset_function_resolver(tep);
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
