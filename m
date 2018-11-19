Return-Path: <SRS0=OAlf=N6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810089.outbound.protection.outlook.com ([40.107.81.89]:53856
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728890AbeKSXR4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Nov 2018 18:17:56 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 11/34] tools/lib/traceevent: Man pages
 tep_get_any_field_val(), tep_get_common_field_val(), tep_get_field_val() and
 tep_get_field_raw()
Date: Mon, 19 Nov 2018 12:54:21 +0000
Message-ID: <20181119125357.19449-12-tstoyanov@vmware.com>
References: <20181119125357.19449-1-tstoyanov@vmware.com>
In-Reply-To: <20181119125357.19449-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_get_any_field_val(), tep_get_common_field_val(),
tep_get_field_val() and tep_get_field_raw() as part of the libtraceevent AP=
Is.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-field_get_val.txt           | 117 ++++++++++++++++++
 1 file changed, 117 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_=
get_val.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_get_val=
.txt b/tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt
new file mode 100644
index 000000000000..4d2b99bf342f
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-field_get_val.txt
@@ -0,0 +1,117 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_get_any_field_val,tep_get_common_field_val,tep_get_field_val,tep_get_f=
ield_raw - Get value of a field.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+int *tep_get_any_field_val*(struct trace_seq pass:[*]_s_, struct tep_event=
 pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_rec=
ord_, unsigned long long pass:[*]_val_, int _err_);
+int *tep_get_common_field_val*(struct trace_seq pass:[*]_s_, struct tep_ev=
ent pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_=
record_, unsigned long long pass:[*]_val_, int _err_);
+int *tep_get_field_val*(struct trace_seq pass:[*]_s_, struct tep_event pas=
s:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*]_record_=
, unsigned long long pass:[*]_val_, int _err_);
+void pass:[*]*tep_get_field_raw*(struct trace_seq pass:[*]_s_, struct tep_=
event pass:[*]_event_, const char pass:[*]_name_, struct tep_record pass:[*=
]_record_, int pass:[*]_len_, int _err_);
+--
+
+DESCRIPTION
+-----------
+These functions can be used to find a field and retrieve its value.
+
+The _tep_get_any_field_val()_ function searches in the _record_ for a file=
d with=20
+_name_, part of the _event_. If the field is found, its value is stored in=
 _val_.=20
+In case of an error, an error string is printed into _s_, if _err_ is not =
0.
+
+The _tep_get_common_field_val()_ function does the same as=20
+_tep_get_any_field_val()_, but searches only in the common fields.=20
+
+The _tep_get_field_val()_ function does the same as=20
+_tep_get_any_field_val()_, but searches only in the event specific fields.=
=20
+
+The _tep_get_field_raw()_ function searches in the _record_ for a filed wi=
th _name_,=20
+part of the _event_. If the field is found, a pointer to its raw data is r=
eturned.=20
+The size of the data is stored in _len_. In case of an error, an error str=
ing=20
+is printed into _s_, if _err_ is not 0.
+
+RETURN VALUE
+------------
+The _tep_get_any_field_val()_, _tep_get_common_field_val()_ and=20
+_tep_get_field_val()_ functions return 0 on success, or -1 in case of an e=
rror.
+
+The _tep_get_field_raw()_ function returns a pointer to field's raw data, =
and=20
+places the length of this data in _len_. In case of an error NULL is retur=
ned.
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
+struct tep_event *event =3D tep_find_event_by_name(tep, "kvm", "kvm_exit")=
;
+...
+void process_record(struct tep_record *record)
+{
+	int len;
+	char *comm;
+	struct tep_event_format *event;
+	unsigned long long val;
+
+	event =3D tep_find_event_by_record(pevent, record);
+	if (event !=3D NULL) {
+		if (tep_get_common_field_val(NULL, event, "common_type", record, &val, 0=
) =3D=3D 0) {
+			/* Got the value of common type field */
+		}
+		if (tep_get_field_val(NULL, event, "pid", record, &val, 0) =3D=3D 0) {
+			/* Got the value of pid specific field */
+		}
+		comm =3D tep_get_field_raw(NULL, event, "comm", record, &len, 0);
+		if (comm !=3D NULL) {
+			/* Got a pointer to the comm event specific field */
+		}
+	}=20
+}
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
