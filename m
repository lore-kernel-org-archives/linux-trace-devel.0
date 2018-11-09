Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810079.outbound.protection.outlook.com ([40.107.81.79]:10688
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727800AbeKIXMl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 18:12:41 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 09/11] tools/lib/traceevent: Man page for
 tep_is_latency_format() and tep_set_latency_format()
Date: Fri, 9 Nov 2018 13:31:56 +0000
Message-ID: <20181109133135.25804-9-tstoyanov@vmware.com>
References: <20181109133135.25804-1-tstoyanov@vmware.com>
In-Reply-To: <20181109133135.25804-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_is_latency_format() and tep_set_latency_format()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-latency_format.txt          | 100 ++++++++++++++++++
 1 file changed, 100 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-latenc=
y_format.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-latency_forma=
t.txt b/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
new file mode 100644
index 000000000000..4b0d7d3f6ae9
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
@@ -0,0 +1,100 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_set_latency_format,tep_is_latency_format - Get / set "latency output" =
format.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+void *tep_set_latency_format*(struct tep_handle pass:[*]_tep_, int _lat_);
+int *tep_is_latency_format*(struct tep_handle pass:[*]_tep_);
+
+--
+
+DESCRIPTION
+-----------
+"Latency output" format prints information about interrupts being disabled=
,=20
+soft irq being disabled, the "need_resched" flag being set and preempt cou=
nt.=20
+This information is recorded with every event, but by default is not print=
ed.
+
+The _tep_set_latency_format()_ function enables the "latency output" print=
ing.
+The _tep_ argument is trace event parser context. The _lat_ argument can b=
e zero,
+for "latency output" disabled, or non zero for "latency output" enabled.
+Information is displayed with 6 characters. When a field is zero, or N/A, =
a pass:['.']=20
+is printed. Example:
+[verse]
+--
+  <idle>-0       0d.h1. 106467.859747: function:             ktime_get <--=
 tick_check_idle
+--
+The 0d.h1. denotes this information. The first character is never a pass:[=
'.']
+and represents what CPU the trace was recorded on (CPU 0). The pass:['d'] =
denotes
+that interrupts were disabled. The pass:['h'] means that this was called i=
nside
+an interrupt handler. The pass:['1'] is the preemption disabled (preempt_c=
ount)
+was set to one.  The two pass:['.']s are "need_resched" flag and kernel lo=
ck
+counter. If the "need_resched" flag is set, then that character would be a=
 pass:['N'].
+
+The _tep_is_latency_format()_ function returns if "latency output" is enab=
led.
+
+This "Latency output" setting affects output of _tep_print_event_task()_
+and _tep_print_event_time()_ APIs.=20
+
+RETURN VALUE
+------------
+
+The _tep_is_latency_format()_ function returns non zero if "latency output=
"=20
+is enabled, or zero if it is disabled.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+...
+	tep_set_latency_format(tep, 1);
+...
+	if (tep_is_latency_format(tep)) {
+		/* latency output format is enabled */
+	} else {
+		/* latency output format is disabled */
+	}
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
+_libtraceevent(3)_, _trace-cmd(1)_, tep_print_event_task(3), tep_print_eve=
nt_time(3)
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
