Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700077.outbound.protection.outlook.com ([40.107.70.77]:22368
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729862AbeK1Cmu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:42:50 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 24/46] tools/lib/traceevent: Man pages for
 tep_print_field(), tep_print_fields(), tep_print_num_field() and
 tep_print_func_field()
Date: Tue, 27 Nov 2018 15:42:37 +0000
Message-ID: <20181127154153.11315-25-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_print_field(), tep_print_fields(),
tep_print_num_field() and tep_print_func_field()
as part of the libtraceevent APIs.
Updated description of functions in event-parse.c

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-field_print.txt             | 120 ++++++++++++++++++
 1 file changed, 120 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_=
print.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_print.t=
xt b/tools/lib/traceevent/Documentation/libtraceevent-field_print.txt
new file mode 100644
index 000000000000..3a9372ba1102
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-field_print.txt
@@ -0,0 +1,120 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_print_field,tep_print_fields,tep_print_num_field,tep_print_func_field =
- Print the field content.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+void *tep_print_field*(struct trace_seq pass:[*]_s_, void pass:[*]_data_, =
struct tep_format_field pass:[*]_field_);
+void *tep_print_fields*(struct trace_seq pass:[*]_s_, void pass:[*]_data_,=
 int _size_, struct tep_event pass:[*]_event_);
+int *tep_print_num_field*(struct trace_seq pass:[*]_s_, const char pass:[*=
]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struct=
 tep_record pass:[*]_record_, int _err_);
+int *tep_print_func_field*(struct trace_seq pass:[*]_s_, const char pass:[=
*]_fmt_, struct tep_event pass:[*]_event_, const char pass:[*]_name_, struc=
t tep_record pass:[*]_record_, int _err_);
+--
+
+DESCRIPTION
+-----------
+These functions print recorded field's data, according to the field's type=
.
+
+The _tep_print_field()_ function extracts from the recorded raw _data_ val=
ue of=20
+the _field_ and prints it into _s_, according to the field type.
+
+The _tep_print_fields()_ prints recorded values of all _event_'s fields. I=
t=20
+iterates all fileds of the _event_, and calls _tep_print_field()_ for each=
 of
+them.
+
+The _tep_print_num_field()_ function prints a numeric field with given for=
mat=20
+string. A search is performed in the _event_ for a field with _name_. If s=
uch=20
+field is found, its value is extracted from the _record_ and is printed in=
 the=20
+_s_, according to the given format string _fmt_. If the argument _err_ is =
non-zero,
+and an error occures - it is printed in the _s_.
+
+The _tep_print_func_field()_ function prints a function field with given f=
ormat=20
+string.  A search is performed in the _event_ for a field with _name_. If =
such=20
+field is found, its value is extracted from the _record_. The value is ass=
umed=20
+to be a function address, and a search is perform to find the name of this=
=20
+function. The function name (if found) and its address are printed in the =
_s_,=20
+according to the given format string _fmt_. If the argument _err_ is non-z=
ero,
+and an error occures - it is printed in _s_.
+
+RETURN VALUE
+------------
+The _tep_print_num_field()_ and _tep_print_func_field()_ functions return =
1=20
+on success, -1 in case of an error or 0 if the print buffer _s_ is full.
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
+struct trace_seq seq;
+trace_seq_init(&seq);
+struct tep_event *event =3D tep_find_event_by_name(tep, "timer", "hrtimer_=
start");
+...
+void process_record(struct tep_record *record)
+{
+ 	struct tep_format_field *field_pid =3D tep_find_common_field(event, "com=
mon_pid");
+=20
+ 	trace_seq_reset(&seq);
+ =09
+ 	/* Print the value of "common_pid" */
+ 	tep_print_field(&seq, record->data, field_pid);
+ =09
+ 	/* Print all fields of the "hrtimer_start" event */
+ 	tep_print_fields(&seq, record->data, record->size, event);
+ =09
+ 	/* Print the value of "expires" field with custom format string */
+ 	tep_print_num_field(&seq, " timer expires in %llu ", event, "expires", r=
ecord, 0);
+ =09
+ 	/* Print the address and the name of "function" field with custom format=
 string */
+	tep_print_func_field(&seq, " timer function is %s ", event, "function", r=
ecord, 0);
+ }
+ ...
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
