Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr690062.outbound.protection.outlook.com ([40.107.69.62]:29120
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729872AbeK1Cky (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:40:54 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 20/46] tools/lib/traceevent: Man pages for
 tep_print_event(), tep_print_event_data(), tep_event_info(),
 tep_print_event_task() and tep_print_event_time()
Date: Tue, 27 Nov 2018 15:42:32 +0000
Message-ID: <20181127154153.11315-21-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_print_event(), tep_print_event_data(),
tep_event_info(), tep_print_event_task() and tep_print_event_time()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-event_print.txt             | 126 ++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_=
print.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-event_print.t=
xt b/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
new file mode 100644
index 000000000000..f5af35d0d409
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
@@ -0,0 +1,126 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_print_event,tep_print_event_data,tep_event_info,tep_print_event_task,t=
ep_print_event_time - Parses the data into the print format.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+void *tep_print_event_time*(struct tep_handle pass:[*]_tep_, struct trace_=
seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[=
*]record, bool _use_trace_clock_);
+void *tep_print_event_task*(struct tep_handle pass:[*]_tep_, struct trace_=
seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[=
*]_record_);
+void *tep_event_info*(struct trace_seq pass:[*]_s_, struct tep_event pass:=
[*]_event_, struct tep_record pass:[*]_record_);
+void *tep_print_event_data*(struct tep_handle pass:[*]_tep_, struct trace_=
seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[=
*]_record_);
+void *tep_print_event*(struct tep_handle pass:[*]_tep_, struct trace_seq p=
ass:[*]_s_, struct tep_record pass:[*]_record_, bool _use_trace_clock_);
+--
+
+DESCRIPTION
+-----------
+The _tep_print_event_time()_ function prints the timestamp of the _record_=
 using=20
+the given _event_ information as trace sequence in _s_. The _tep_ argument=
 is=20
+trace event parser context. The _use_trace_clock_ argument indicates if=20
+the tep->trace_clock should be used for parsing the timestamp.
+
+The _tep_print_event_task()_ function prints the task command, pid and CPU=
 of=20
+the _record_ using the given _event_ information as trace sequence in _s_.=
=20
+The _tep_ argument is trace event parser context.=20
+
+The _tep_event_info()_ function parses the raw data from the _record_ usin=
g=20
+the given _event_ information and writes the print format as trace sequenc=
e in
+_s_.
+
+The _tep_print_event_data()_ function writes the _event_ name  as trace=20
+sequence in _s_ and calls _tep_event_info()_ to parse and write the raw da=
ta
+from the _record_. The _tep_ argument is trace event parser context.=20
+
+The _tep_print_event()_ function prints the _record_ information as trace=
=20
+sequence in _s_. It finds the corresponding event and calls=20
+_tep_print_event_task()_,_tep_print_event_time()_ and _tep_print_event_dat=
a()_
+to parse and print the information. =20
+The _tep_ argument is trace event parser context. The _use_trace_clock_=20
+argument indicates if the tep->trace_clock should be used for parsing=20
+the timestamp.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct trace_seq seq;
+trace_seq_init(&seq);
+struct tep_handle *tep =3D tep_alloc();
+...
+void print_my_event(struct tep_record *record)
+{=09
+	struct tep_event *event;
+=09
+	/* print all event information */
+	trace_seq_reset(&seq);
+	tep_print_event(tep, &seq, record, TRUE);
+=09
+	event =3D tep_find_event_by_record(tep, record);
+=09
+	if (event !=3D NULL) {
+		/* print event timestamp */
+		trace_seq_reset(&seq);
+		tep_print_event_time(tep, &seq, event, record, TRUE);
+	=09
+		/* print event task information */
+		trace_seq_reset(&seq);
+		tep_print_event_task(tep, &seq, event, record);
+
+		/* print event name and raw data */
+		trace_seq_reset(&seq);
+		tep_print_event_data(tep, &seq, event, record);=09
+
+		/* print event raw data */
+		trace_seq_reset(&seq);
+		tep_event_info(&seq, event, record);=09
+	}
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
