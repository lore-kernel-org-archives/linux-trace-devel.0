Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730068.outbound.protection.outlook.com ([40.107.73.68]:47354
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729862AbeK1Ckw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:40:52 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 14/46] tools/lib/traceevent: Man pages for
 tep_register_event_handler() and tep_unregister_event_handler()
Date: Tue, 27 Nov 2018 15:42:24 +0000
Message-ID: <20181127154153.11315-15-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_register_event_handler() and tep_unregister_event_=
handler()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-reg_event_handler.txt       | 129 ++++++++++++++++++
 1 file changed, 129 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_ev=
ent_handler.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_event_han=
dler.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handl=
er.txt
new file mode 100644
index 000000000000..ee9aa3a4151b
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.tx=
t
@@ -0,0 +1,129 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_register_event_handler,tep_unregister_event_handler -  Register / unre=
gisters
+a callback function to parse an event information.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_reg_handler* {
+	_TEP_REGISTER_SUCCESS_,
+	_TEP_REGISTER_SUCCESS_OVERWRITE_,
+};
+
+int *tep_register_event_handler*(struct tep_handle pass:[*]_tep_, int _id_=
, const char pass:[*]_sys_name_, const char pass:[*]_event_name_, tep_event=
_handler_func _func_, void pass:[*]_context_);
+int *tep_unregister_event_handler*(struct tep_handle pass:[*]tep, int id, =
const char pass:[*]sys_name, const char pass:[*]event_name, tep_event_handl=
er_func func, void pass:[*]_context_);
+
+typedef int (*pass:[*]tep_event_handler_func*)(struct trace_seq pass:[*]s,=
 struct tep_record pass:[*]record, struct tep_event pass:[*]event, void pas=
s:[*]context);
+--
+
+DESCRIPTION
+-----------
+The _tep_register_event_handler()_ function registers a handler function,=
=20
+which is going to be called to parse the information for a given event.=20
+The _tep_ argument is the trace event parser context. The _id_ argument is=
=20
+the id of the event. The _sys_name_ argument is the name of the system,=20
+the event belongs to. The _event_name_ argument is the name of the event.
+If _id_ is >=3D 0, it is used to find the event, otherwise _sys_name_ and=
=20
+_event_name_ are used. The _func_ is a pointer to the function, which is g=
oing=20
+to be called to parse the event information. The _context_ argument is a p=
ointer
+to the context data, which will be passed to the _func_. If a handler func=
tion=20
+for the same event is already registered, it will be overridden with the n=
ew=20
+one. This mechanism allows a developer to override the parsing of a given =
event.
+If for some reason the default print format is not sufficient, the develop=
er=20
+can register a function for an event to be used to parse the data instead.
+
+The _tep_unregister_event_handler()_ function unregisters the handler func=
tion,
+previously registered with _tep_register_event_handler()_. The _tep_ argum=
ent=20
+is the trace event parser context. The _id_, _sys_name_, _event_name_, _fu=
nc_,
+and _context_ are the same arguments, as when the callback function _func_=
 was
+registered.
+
+The _tep_event_handler_func_ is the type of the custom event handler=20
+function. The _s_ argument is the trace sequence, it can be used to create=
 a=20
+custom string, describing the event. A _record_  to get the event from is =
passed=20
+as input parameter and also the _event_ - the handle to the record's event=
. The=20
+_context_ is custom context, set when the custom event handler is register=
ed.=20
+=20
+RETURN VALUE
+------------
+The _tep_register_event_handler()_ function returns _TEP_REGISTER_SUCCESS_
+if the new handler is registered successfully or _TEP_REGISTER_SUCCESS_OVE=
RWRITE_ if
+an existing handler is overwritten. If there is not  enough memory to comp=
lete=20
+the registration, TEP_ERRNO__MEM_ALLOC_FAILED is returned.=20
+
+The _tep_unregister_event_handler()_ function returns 0 if _func_ was remo=
ved=20
+successful or, -1 if the event was not found.
+
+The _tep_event_handler_func_ should return -1 in case of an error, or 0 ot=
herwise.
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
+int custom_event_handler(struct trace_seq *s, struct tep_record *record,
+			 struct tep_event *event, void *context)=20
+{
+	trace_seq_printf(s, "kvm_exit event");
+	return 0;
+}
+...
+	if (tep_register_event_handler(tep, -1, "kvm", "kvm_exit",
+				   custom_event_handler, NULL)) {
+	/* Failed to register the handler for event "kvm_exit" from "kvm" system =
*/
+	}
+...
+	if (tep_unregister_event_handler(pevent, -1, "kvm", "kvm_exit",
+				     custom_event_handler, NULL) !=3D ) {
+	/* Failed to unregister the handler for event "kvm_exit" from "kvm" syste=
m */
+	}
+
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
