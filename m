Return-Path: <SRS0=OAlf=N6=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810089.outbound.protection.outlook.com ([40.107.81.89]:53856
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728818AbeKSXR7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Nov 2018 18:17:59 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 13/34] tools/lib/traceevent: Man page for
 tep_read_number_field()
Date: Mon, 19 Nov 2018 12:54:23 +0000
Message-ID: <20181119125357.19449-14-tstoyanov@vmware.com>
References: <20181119125357.19449-1-tstoyanov@vmware.com>
In-Reply-To: <20181119125357.19449-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man page for tep_read_number_field()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-field_read.txt              | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-field_=
read.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-field_read.tx=
t b/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
new file mode 100644
index 000000000000..8e4ca26b73aa
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-field_read.txt
@@ -0,0 +1,80 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_read_number_field - Reads a number from a raw data.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+int *tep_read_number_field*(struct tep_format_field pass:[*]_field_, const=
 void pass:[*]_data_, unsigned long long pass:[*]_value_);
+--
+
+DESCRIPTION
+-----------
+The _tep_read_number_field()_ function reads the value of the _field_ from=
 the=20
+raw _data_ and stores it in the _value_. The function sets the _value_ acc=
ording
+to the endianness of the raw data and the current machine.=20
+
+RETURN VALUE
+------------
+The _tep_read_number_field()_ function retunrs 0 in case of success, or -1=
 in=20
+case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+struct tep_event *event =3D tep_find_event_by_name(tep, "timer", "hrtimer_=
start");
+...
+void process_record(struct tep_record *record)
+{
+	unsigned long long pid;
+	struct tep_format_field *field_pid =3D tep_find_common_field(event, "comm=
on_pid");
+=09
+	if (tep_read_number_field(field_pid, record->data, &pid) !=3D 0) {
+		/* Failed to get "common_pid" value */
+	}
+}
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
