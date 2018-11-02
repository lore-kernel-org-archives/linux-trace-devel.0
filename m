Return-Path: <SRS0=Mn5y=NN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730040.outbound.protection.outlook.com ([40.107.73.40]:32992
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbeKCAE4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Nov 2018 20:04:56 -0400
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 3/3] tools/lib/traceevent: Implement libtraceevent man pages
Date: Fri, 2 Nov 2018 14:57:29 +0000
Message-ID: <20181102145714.25885-4-tstoyanov@vmware.com>
References: <20181102145714.25885-1-tstoyanov@vmware.com>
In-Reply-To: <20181102145714.25885-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch implements 5 new man pages, which describe following libtraceeve=
nt APIs:
tep_register_comm,tep_pid_is_registered,tep_data_comm_from_pid,
tep_data_pid_from_comm,tep_cmdline_pid,tep_alloc,tep_free,tep_get_long_size=
,
tep_set_long_size,tep_set_flag.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-commands.txt  | 125 ++++++++++++++++++
 .../Documentation/libtraceevent-handle.txt    |  77 +++++++++++
 .../Documentation/libtraceevent-long_size.txt |  75 +++++++++++
 .../Documentation/libtraceevent-ref.txt       |  84 ++++++++++++
 .../Documentation/libtraceevent-set_flag.txt  |  94 +++++++++++++
 5 files changed, 455 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-comman=
ds.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-handle=
.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-long_s=
ize.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-ref.tx=
t
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-set_fl=
ag.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-commands.txt =
b/tools/lib/traceevent/Documentation/libtraceevent-commands.txt
new file mode 100644
index 000000000000..9ca6c19cf9cb
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-commands.txt
@@ -0,0 +1,125 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_register_comm,tep_pid_is_registered,tep_data_comm_from_pid,tep_data_pi=
d_from_comm,tep_cmdline_pid - handle pid to process name mappings
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_register_comm*(struct tep_handle pass:[*]_tep_, const char pass:[=
*]_comm_, int _pid_);
+int *tep_pid_is_registered*(struct tep_handle pass:[*]_tep_, int _pid_);
+const char pass:[*]*tep_data_comm_from_pid*(struct tep_handle pass:[*]_pev=
ent_, int _pid_);
+struct cmdline pass:[*]*tep_data_pid_from_comm*(struct tep_handle pass:[*]=
_pevent_, const char pass:[*]_comm_, struct cmdline pass:[*]_next_);
+int *tep_cmdline_pid*(struct tep_handle pass:[*]_pevent_, struct cmdline p=
ass:[*]_cmdline_);
+--
+
+DESCRIPTION
+-----------
+These functions can be used to handle the mapping between pid and process =
name.=20
+The library builds a cache of these mappings, which is used to display the=
 name of=20
+the process, instead of its pid. This information can be retrieved from=20
+debugfs/tracing/saved_cmdlines file. It is also saved in trace.dat file.=20
+
+The _tep_register_comm()_ function registers a pid / process name mapping.=
=20
+The _pid_ argument is the process ID, the _comm_ argument is the process n=
ame,=20
+_tep_ is the event context. The process name string is duplicated.=20
+
+The _tep_pid_is_registered()_ function checks if a pid has a process name =
mapping registered.=20
+The _pid_ argumnet is the process ID, _tep_ is the event context.
+
+The _tep_data_comm_from_pid()_ function returns the process name for given=
 pid.
+The _pid_ argument is the process ID, _tep_ is the event context.=20
+
+The _tep_data_pid_from_comm()_ function returns pid for given process name=
.
+The _comm_ argument is the process name, _tep_ is the event context.=20
+The argument _next_ is the cmdline structure to search for the next pid, c=
an be NULL.
+As there may be more than one pid for a given process, the result of this =
call=20
+can be passed back into a recurring call in the _next_ parameter, to searc=
h for the next pid.
+The function performs a linear seach, so it may be slow.
+
+The _tep_cmdline_pid()_ function returns the pid associated with a given _=
cmdline_.
+The _tep_ argument is the event context.
+
+RETURN VALUE
+------------
+_tep_register_comm()_ function returns 0 on success completion, or -1 in c=
ase of a error.
+
+_tep_pid_is_registered()_ function returns 1 if the _pid_ has a process na=
me mapped to it, 0 otherwise.
+
+_tep_data_comm_from_pid()_ function returns the process name as string, or=
 the string "<...>" if thers is no mapping for the given pid.
+
+_tep_data_pid_from_comm()_ function returns pointer to struct cmdline, tha=
t holds a pid for a given
+process, or NULL if none is found. This result can be passed back into a r=
ecurring call as the _next_ parameter of the function.
+
+_tep_cmdline_pid()_ functions returns the pid for the give cmdline. If _cm=
dline_ is NULL, then
+ -1 is returned.
+=20
+EXAMPLE
+-------
+The following example registers pid for command "ls", in context of event =
_tep_=20
+and performs various searches for pid / process name mappings:
+[source,c]
+--
+#include <event-parse.h>
+...
+int ls_pid =3D 1021;
+struct tep_handle *tep =3D tep_alloc();
+...
+	if (0 !=3D tep_register_comm(tep, "ls", ls_pid)) {
+		/* Failed to register pid / command mapping */
+	}
+....
+	if (0 =3D=3D tep_pid_is_registered(tep, ls_pid)) {
+		/* Command mapping for ls_pid is not registered */
+	}
+...
+	const char *comm =3D tep_data_comm_from_pid(tep, ls_pid);
+	if (comm) {
+		/* Found process name for ls_pid */
+	}
+...=09
+	int pid;
+	struct cmdline *cmd =3D tep_data_pid_from_comm(tep, "ls", NULL);
+	while (cmd) {
+		pid =3D tep_cmdline_pid(tep, cmd);
+		/* Found pid for process "ls" */
+		cmd =3D tep_data_pid_from_comm(tep, "ls", cmd);
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
diff --git a/tools/lib/traceevent/Documentation/libtraceevent-handle.txt b/=
tools/lib/traceevent/Documentation/libtraceevent-handle.txt
new file mode 100644
index 000000000000..f6dcfad7b264
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-handle.txt
@@ -0,0 +1,77 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_alloc,tep_free - Create / destroy trace event parser context.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_handle pass:[*]*tep_alloc*(void);
+void *tep_free*(struct tep_handle pass:[*]_tep_);
+--
+
+DESCRIPTION
+-----------
+These are main functions to create and destroy tep_handle - the main struc=
ture, representing the trace event parser context.=20
+This context is used as input parameter of all library APIs.
+
+The _tep_alloc()_ functions allocates and initializes the tep context. It =
sets its reference counter to 1.
+
+The _tep_free()_ functions decrements the tep context reference counter by=
 1. When this counter reaches 0, the context is destroyed.
+Before destroying, a full clean up is performed of all internal structures=
.=20
+The argument _tep_ is pointer to the trace event parser context.
+
+RETURN VALUE
+------------
+_tep_alloc()_ returns pointer to newly created tep_handle structure. A NUL=
L is returned in case there is not enough free memory to allocate it.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+
+...
+struct tep_handle *tep =3D tep_alloc();
+
+...
+tep_free(tep);
+...
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
diff --git a/tools/lib/traceevent/Documentation/libtraceevent-long_size.txt=
 b/tools/lib/traceevent/Documentation/libtraceevent-long_size.txt
new file mode 100644
index 000000000000..327922e52af4
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-long_size.txt
@@ -0,0 +1,75 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_get_long_size,tep_set_long_size - Get / set the size of of a long inte=
ger on the current machine, in bytes
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_get_long_size*(strucqt tep_handle pass:[*]_tep_);
+void *tep_set_long_size*(struct tep_handle pass:[*]_tep_, int _long_size_)=
;
+--
+
+DESCRIPTION
+-----------
+The _tep_get_long_size()_ function returns the size of a long integer on t=
he current machine.=20
+The _tep_ argument is trace event parser context.
+
+The _tep_set_long_size()_ function sets the size of a long integer on the =
current machine.
+The _tep_ argument is trace event parser context. The _long_size_ is the s=
ize of a long integer, in bytes.=20
+
+RETURN VALUE
+------------
+The _tep_get_long_size()_ function returns the size of of a long integer o=
n the current machine, in bytes.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+tep_set_long_size(tep, 4);
+...
+int long_size =3D tep_get_long_size(tep);
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
diff --git a/tools/lib/traceevent/Documentation/libtraceevent-ref.txt b/too=
ls/lib/traceevent/Documentation/libtraceevent-ref.txt
new file mode 100644
index 000000000000..ef0b6f0935d0
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-ref.txt
@@ -0,0 +1,84 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_ref,tep_unref,tep_ref_get - Manage reference counter of trace event pa=
rser context.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+void *tep_ref*(struct tep_handle pass:[*]_tep_);
+void *tep_unref*(struct tep_handle pass:[*]_tep_);
+int *tep_ref_get*(struct tep_handle pass:[*]_tep_);
+--
+
+DESCRIPTION
+-----------
+These functions manage the reference counter of trace event parser context=
. When this counter reaches 0, the context is destroyed.
+
+The _tep_ref()_ function increments the reference counter of _tep_ by 1.
+
+The _tep_unref()_ function decrements the reference counter of _tep_ by 1.=
 If this counter reaches 0, the context is destroyed.
+
+The _tep_ref_get()_ functions gets the current value of _tep_ reference co=
unter.
+
+RETURN VALUE
+------------
+_tep_ref_get()_ returns the value of _tep_ reference counter. If _tep_ is =
NULL, 0 is returned.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+ ...
+struct tep_handle *tep =3D tep_alloc();
+if ( 1 !=3D _tep_ref_get(tep)) {
+	/* Something wrong happened, the counter must be 1 right after its creati=
on */
+}
+
+...
+int ref =3D tep_ref_get(tep);
+tep_ref(tep);
+if ( (ref+1) !=3D tep_ref_get(tep)) {
+	/* Something wrong happened, the counter is not incremented by 1 */
+}
+tep_unref(tep);
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
diff --git a/tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt =
b/tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt
new file mode 100644
index 000000000000..751814985b16
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt
@@ -0,0 +1,94 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_set_flag - Set a flag or combination of flags of trace event parser co=
ntext=20
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_flag* {
+	_TEP_NSEC_OUTPUT_,
+	_TEP_DISABLE_SYS_PLUGINS_,
+	_TEP_DISABLE_PLUGINS_
+};
+void *tep_set_flag*(struct tep_handle pass:[*]_tep_, int _flag_);
+--
+
+DESCRIPTION
+-----------
+[verse]
+--
+The _tep_set_flag()_ function sets _flag_ or any combination of flags to _=
tep_ context.
+Flags are defined in *enum tep_flag*:
+	_TEP_NSEC_OUTPUT_ - print event's timestamp in nano seconds, instead of m=
icro seconds.
+	_TEP_DISABLE_SYS_PLUGINS_ - disable plugins, located in system's plugin d=
irectory.=20
+				This directory is defined at library compile time, and usually is
+				depends on library installation prefix: (install_preffix)/lib/traceeve=
nt/plugins
+	_TEP_DISABLE_PLUGINS_ - disable all library plugins:=20
+			 	- in system's plugin directory=20
+			 	- in directory, defined by the environment variable _TRACEEVENT_PLUGI=
N_DIR_
+			 	- in user's home directory, _~/.traceevent/plugins_
+
+Note: plugin related flags must me set before calling _tep_load_plugins()_=
 API.
+--
+
+RETURN VALUE
+------------
+_tep_set_flag()_ functions has no return value.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+/* Set printing of timestamps in nano seconds and disable system plugins *=
/
+tep_set_flag(tep, TEP_NSEC_OUTPUT | TEP_DISABLE_SYS_PLUGINS);
+...
+/* Disable all library plugins */
+tep_set_flag(tep,  TEP_DISABLE_PLUGINS);
+...
+--
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
2.17.2
