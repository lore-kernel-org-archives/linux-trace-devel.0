Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr800049.outbound.protection.outlook.com ([40.107.80.49]:61440
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729808AbeK1Ckk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:40:40 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 05/46] tools/lib/traceevent: libtraceevent man pages for
 tep_handler related APIs
Date: Tue, 27 Nov 2018 15:42:12 +0000
Message-ID: <20181127154153.11315-6-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch adds 4 new man pages for:
tep_register_comm,tep_pid_is_registered,tep_data_comm_from_pid,
tep_data_pid_from_comm,tep_cmdline_pid,tep_alloc,tep_free,tep_get_long_size=
,
tep_set_long_size,tep_set_flag, as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-commands.txt  | 130 ++++++++++++++++++
 .../Documentation/libtraceevent-handle.txt    | 101 ++++++++++++++
 .../Documentation/libtraceevent-long_size.txt |  78 +++++++++++
 .../Documentation/libtraceevent-set_flag.txt  |  90 ++++++++++++
 4 files changed, 399 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-comman=
ds.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-handle=
.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-long_s=
ize.txt
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-set_fl=
ag.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-commands.txt =
b/tools/lib/traceevent/Documentation/libtraceevent-commands.txt
new file mode 100644
index 000000000000..e8d226f6c072
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-commands.txt
@@ -0,0 +1,130 @@
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
+tracefs/saved_cmdlines file.=20
+
+The _tep_register_comm()_ function registers a pid / process name mapping.=
=20
+The _pid_ argument is the process ID, the _comm_ argument is the process n=
ame,=20
+_tep_ is the event context. The _comm_ is copied internally.=20
+
+The _tep_pid_is_registered()_ function checks if a pid has a process name =
mapping=20
+registered. The _pid_ argument is the process ID, _tep_ is the event conte=
xt.
+
+The _tep_data_comm_from_pid()_ function returns the process name for a giv=
en pid.
+The _pid_ argument is the process ID, _tep_ is the event context. The retu=
rned=20
+string should not be freed, but will be freed when the _tep_ handler is cl=
osed.=20
+
+The _tep_data_pid_from_comm()_ function returns a pid for a given process =
name.
+The _comm_ argument is the process name, _tep_ is the event context.=20
+The argument _next_ is the cmdline structure to search for the next pid.
+As there may be more than one pid for a given process, the result of this =
call=20
+can be passed back into a recurring call in the _next_ parameter, to searc=
h for=20
+the next pid. If _next_ is NULL, it will return the first pid associated w=
ith
+the _comm_. The function performs a linear search, so it may be slow.
+
+The _tep_cmdline_pid()_ function returns the pid associated with a given _=
cmdline_.
+The _tep_ argument is the event context.
+
+RETURN VALUE
+------------
+_tep_register_comm()_ function returns 0 on success, or -1 in case of an e=
rror.
+
+_tep_pid_is_registered()_ function returns 1 if the _pid_ has a process na=
me=20
+mapped to it, 0 otherwise.
+
+_tep_data_comm_from_pid()_ function returns the process name as string, or=
 the=20
+string "<...>" if there is no mapping for the given pid.
+
+_tep_data_pid_from_comm()_ function returns a pointer to a struct cmdline,=
 that=20
+holds a pid for a given process, or NULL if none is found. This result can=
 be=20
+passed back into a recurring call as the _next_ parameter of the function.
+
+_tep_cmdline_pid()_ functions returns the pid for the give cmdline. If _cm=
dline_
+ is NULL, then -1 is returned.
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
+	if (tep_register_comm(tep, "ls", ls_pid) !=3D 0) {
+		/* Failed to register pid / command mapping */
+	}
+....
+	if (tep_pid_is_registered(tep, ls_pid) =3D=3D 0) {
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
index 000000000000..67d9593422dc
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-handle.txt
@@ -0,0 +1,101 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_alloc,tep_free,tep_ref,tep_unref,tep_ref_get - Create, destroy, manage=
=20
+references of trace event parser context.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+struct tep_handle pass:[*]*tep_alloc*(void);
+void *tep_free*(struct tep_handle pass:[*]_tep_);
+void *tep_ref*(struct tep_handle pass:[*]_tep_);
+void *tep_unref*(struct tep_handle pass:[*]_tep_);
+int *tep_ref_get*(struct tep_handle pass:[*]_tep_);
+--
+
+DESCRIPTION
+-----------
+These are the main functions to create and destroy tep_handle - the main
+structure, representing the trace event parser context. This context is us=
ed as
+the input parameter of most library APIs.
+
+The _tep_alloc()_ function allocates and initializes the tep context.
+
+The _tep_free()_ function will decrement the reference of the _tep_ handle=
r.
+When there is no more references, then it will free the handler, as well
+as clean up all its resources that it had used. The argument _tep_ is=20
+the pointer to the trace event parser context.
+
+The _tep_ref()_ function adds a reference to the _tep_ handler.
+
+The _tep_unref()_ function removes a reference from the _tep_ handler. Whe=
n=20
+the last reference is removed, the _tep_ is destroyed, and all resources t=
hat=20
+it had used are cleaned up.
+
+The _tep_ref_get()_ functions gets the current references of the _tep_ han=
dler.
+
+RETURN VALUE
+------------
+_tep_alloc()_ returns a pointer to a newly created tep_handle structure.=20
+NULL is returned in case there is not enough free memory to allocate it.
+
+_tep_ref_get()_ returns the current references of _tep_.
+If _tep_ is NULL, 0 is returned.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+int ref =3D tep_ref_get(tep);
+tep_ref(tep);
+if ( (ref+1) !=3D tep_ref_get(tep)) {
+	/* Something wrong happened, the counter is not incremented by 1 */
+}
+tep_unref(tep);
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
index 000000000000..89830b87678c
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-long_size.txt
@@ -0,0 +1,78 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_get_long_size,tep_set_long_size - Get / set the size of a long integer=
 on=20
+the machine, where the trace is generated, in bytes
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
he machine,=20
+where the trace is generated. The _tep_ argument is trace event parser con=
text.
+
+The _tep_set_long_size()_ function sets the size of a long integer on the =
machine,=20
+where the trace is generated. The _tep_ argument is trace event parser con=
text.=20
+The _long_size_ is the size of a long integer, in bytes.=20
+
+RETURN VALUE
+------------
+The _tep_get_long_size()_ function returns the size of a long integer on t=
he machine,=20
+where the trace is generated, in bytes.
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
diff --git a/tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt =
b/tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt
new file mode 100644
index 000000000000..e1d6dfccca4a
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-set_flag.txt
@@ -0,0 +1,90 @@
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
+				This directory is defined at library compile time, and usually
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
