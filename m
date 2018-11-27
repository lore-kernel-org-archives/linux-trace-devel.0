Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730068.outbound.protection.outlook.com ([40.107.73.68]:47354
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729913AbeK1Ckx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:40:53 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 16/46] tools/lib/traceevent: Man pages for
 tep_register_print_function() and tep_unregister_print_function()
Date: Tue, 27 Nov 2018 15:42:27 +0000
Message-ID: <20181127154153.11315-17-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_register_print_function() and tep_unregister_print=
_function()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-reg_print_func.txt          | 128 ++++++++++++++++++
 1 file changed, 128 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_pr=
int_func.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_print_fun=
c.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt
new file mode 100644
index 000000000000..fbb2f973f3b0
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt
@@ -0,0 +1,128 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_register_print_function,tep_unregister_print_function - Registers / Un=
registers
+a helper function.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_func_arg_type* {
+	TEP_FUNC_ARG_VOID,
+	TEP_FUNC_ARG_INT,
+	TEP_FUNC_ARG_LONG,
+	TEP_FUNC_ARG_STRING,
+	TEP_FUNC_ARG_PTR,
+	TEP_FUNC_ARG_MAX_TYPES
+};
+
+typedef unsigned long long (*pass:[*]tep_func_handler*)(struct trace_seq p=
ass:[*]s, unsigned long long pass:[*]args);
+
+int *tep_register_print_function*(struct tep_handle pass:[*]_tep_, tep_fun=
c_handler _func_, enum tep_func_arg_type _ret_type_, char pass:[*]_name_, _=
..._);
+int *tep_unregister_print_function*(struct tep_handle pass:[*]_tep_, tep_f=
unc_handler _func_, char pass:[*]_name_);
+--
+
+DESCRIPTION
+-----------
+Some events may have helper functions in the print format arguments. This =
allows
+a plugin to dynamically create a way to process one of these functions.
+
+The _tep_register_print_function()_ registers such helper function. The _t=
ep_=20
+argument is the trace event parser context. The _func_ argument is the add=
ress
+of the helper function. The _ret_type_ argument is  the return type of the=
=20
+helper function, value from the _tep_func_arg_type_ enum. The _name_ is th=
e name
+of the helper function, as seen in the print format arguments. The _..._ i=
s a=20
+variable list of _tep_func_arg_type_ enums, the _func_ function arguments.=
=20
+This list must end with _TEP_FUNC_ARG_VOID_.
+
+The _tep_unregister_print_function()_ unregisters a helper function, previ=
ously=20
+registered with _tep_register_print_function()_. The _tep_ argument is the=
=20
+trace event parser context. The _func_ and _name_ arguments are the same, =
used=20
+when the helper function was registered.
+
+The _tep_func_handler_ is the type of the helper function. The _s_ argumen=
t is=20
+the trace sequence, it can be used to create a custom string.
+The _args_  is a list of arguments, defined when the helper function was=20
+registered.=20
+
+RETURN VALUE
+------------
+The _tep_register_print_function()_ function returns 0 in case of success.=
=20
+In case of an error, TEP_ERRNO_... code is returned.
+
+The _tep_unregister_print_function()_ returns 0 in case of success, or -1 =
in
+case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+static long long
+process_custom_helper(struct trace_seq *s, unsigned long long *args)
+{
+	unsigned long long param =3D args[0];
+	trace_seq_printf(s, "the helper was called, with argument %lld", param);
+	return 0;
+}
+...
+	if ( tep_register_print_function(tep,
+				    process_custom_helper,
+				    TEP_FUNC_ARG_STRING,
+				    "custom_helper",
+				    TEP_FUNC_ARG_LONG,
+				    TEP_FUNC_ARG_VOID) !=3D 0) {
+		/* Failed to register my process_custom_helper function */
+	}
+...
+	if (tep_unregister_print_function(tep, process_custom_helper,
+				      	  "custom_helper") !=3D 0) {
+		/* Failed to unregister my process_custom_helper function */
+	}				   =20
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*trace-seq.h*
+	Header file to include in order to have access to trace sequences related=
 APIs.
+	Trace sequences are used to allow a function to call several other functi=
ons=20
+	to create a string of data to use.
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
