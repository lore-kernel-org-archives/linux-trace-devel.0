Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:24265
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726381AbeK1Clw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:41:52 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 41/46] tools/lib/traceevent: Man pages for tep_data_type(),
 tep_data_pid(), tep_data_preempt_count() and tep_data_flags()
Date: Tue, 27 Nov 2018 15:43:00 +0000
Message-ID: <20181127154153.11315-42-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_data_type(), tep_data_pid(),
tep_data_preempt_count() and tep_data_flags()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-record_parse.txt            | 134 ++++++++++++++++++
 1 file changed, 134 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-record=
_parse.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-record_parse.=
txt b/tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt
new file mode 100644
index 000000000000..6b4ca8dbcdfd
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-record_parse.txt
@@ -0,0 +1,134 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_data_type,tep_data_pid,tep_data_preempt_count,tep_data_flags - Extract=
 common fields from a record.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *trace_flag_type* {
+	_TRACE_FLAG_IRQS_OFF_,
+	_TRACE_FLAG_IRQS_NOSUPPOR_,
+	_TRACE_FLAG_NEED_RESCHED_,
+	_TRACE_FLAG_HARDIRQ_,
+	_TRACE_FLAG_SOFTIRQ_,
+};
+
+int *tep_data_type*(struct tep_handle pass:[*]_tep_, struct tep_record pas=
s:[*]_rec_);
+int *tep_data_pid*(struct tep_handle pass:[*]_tep_, struct tep_record pass=
:[*]_rec_);
+int *tep_data_preempt_count*(struct tep_handle pass:[*]_tep_, struct tep_r=
ecord pass:[*]_rec_);
+int *tep_data_flags*(struct tep_handle pass:[*]_tep_, struct tep_record pa=
ss:[*]_rec_);
+--
+
+DESCRIPTION
+-----------
+This set of functions can be used to extract common fields from a record.
+
+The _tep_data_type()_ function gets the event id from the record _rec_. It=
 reads=20
+the "common_type" field. The _tep_ argument is the trace event parser cont=
ext.
+
+The _tep_data_pid()_ function gets the process id from the record _rec_. I=
t reads=20
+the "common_pid" field. The _tep_ argument is the trace event parser conte=
xt.
+
+The _tep_data_preempt_count()_ function gets the preemption count from the=
 record=20
+_rec_. It reads the "common_preempt_count" field. The _tep_ argument is th=
e=20
+trace event parser context.
+
+The _tep_data_flags()_ function gets the latency flags from the record _re=
c_.=20
+It reads the "common_flags" field. The _tep_ argument is the trace event p=
arser=20
+context. Supported latency flags are:
+[verse]
+--
+	_TRACE_FLAG_IRQS_OFF_,		Interrupts are disabled.
+	_TRACE_FLAG_IRQS_NOSUPPOR_,	Reading IRQ flag is not supported by the arch=
itecture.
+	_TRACE_FLAG_NEED_RESCHED_,	Task needs rescheduling.
+	_TRACE_FLAG_HARDIRQ_,		Hard IRQ is running.
+	_TRACE_FLAG_SOFTIRQ_,		Soft IRQ is running.
+--
+
+RETURN VALUE
+------------
+The _tep_data_type()_ function returns an integer, representing the event =
id.
+
+The _tep_data_pid()_ function returns an integer, representing the process=
 id
+
+The _tep_data_preempt_count()_ function returns an integer, representing t=
he=20
+preemption count.
+
+The _tep_data_flags()_ function returns an integer, representing the laten=
cy=20
+flags. Look at the _trace_flag_type_ enum for supported flags.
+
+All these functions in case of an error return a negative integer.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+void process_record(struct tep_record *record)
+{
+	int data;
+=09
+	data =3D tep_data_type(tep, record);
+	if (data >=3D 0) {
+		/* Got the ID of the event */
+	}
+=09
+	data =3D tep_data_pid(tep, record);
+	if (data >=3D 0) {
+		/* Got the process ID */
+	}
+=09
+	data =3D tep_data_preempt_count(tep, record);
+	if (data >=3D 0) {
+		/* Got the preemption count */
+	}
+=09
+	data =3D tep_data_flags(tep, record);
+	if (data >=3D 0) {
+		/* Got the latency flags */
+	}=09
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
