Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr690079.outbound.protection.outlook.com ([40.107.69.79]:56248
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726381AbeK1Clp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:41:45 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 34/46] tools/lib/traceevent: Man pages for
 tep_filter_event_has_trivial(), tep_update_trivial() and
 tep_filter_clear_trivial()
Date: Tue, 27 Nov 2018 15:42:51 +0000
Message-ID: <20181127154153.11315-35-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Create man pages for tep_filter_event_has_trivial(),
tep_update_trivial() and tep_filter_clear_trivial()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-filter_trivial.txt          | 112 ++++++++++++++++++
 1 file changed, 112 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter=
_trivial.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter_trivia=
l.txt b/tools/lib/traceevent/Documentation/libtraceevent-filter_trivial.txt
new file mode 100644
index 000000000000..8afd50b29269
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter_trivial.txt
@@ -0,0 +1,112 @@
+libtraceevent(3)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+NAME
+----
+tep_filter_event_has_trivial,tep_update_trivial,tep_filter_clear_trivial -=
 Check / update / clear trivial rules of given filter.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum *tep_filter_trivial_type* {
+	_TEP_FILTER_TRIVIAL_FALSE_,
+	_TEP_FILTER_TRIVIAL_TRUE_,
+	_TEP_FILTER_TRIVIAL_BOTH_,
+};
+
+int *tep_filter_event_has_trivial*(struct tep_event_filter pass:[*]_filter=
_, int _event_id_, enum tep_filter_trivial_type _type_);
+int *tep_update_trivial*(struct tep_event_filter pass:[*]_dest_, struct te=
p_event_filter pass:[*]_source_, enum tep_filter_trivial_type _type_);
+int *tep_filter_clear_trivial*(struct tep_event_filter pass:[*]_filter_, e=
num tep_filter_trivial_type _type_);
+--
+
+DESCRIPTION
+-----------
+The _tep_filter_event_has_trivial()_ function checks if the event with=20
+_event_id_ contains a trivial _filter_ of _type_.
+
+The _tep_update_trivial()_ function updates the trivial rules with the giv=
en=20
+filter. It scans _dest_ for trivial events matching _type_ to replace with=
=20
+the _source_.
+
+The _tep_filter_clear_trivial()_ function clears TRUE and FALSE rules.=20
+It removes rules in the _filter_ that only contain a given _type_ boolean =
arg.
+
+The trivial _type_, used as argument of these functions can be:
+[verse]
+--
+	_TEP_FILTER_TRIVIAL_FALSE_	- TRUE
+	_TEP_FILTER_TRIVIAL_TRUE_	- FALSE
+	_TEP_FILTER_TRIVIAL_BOTH_	- TRUE or FALSE
+
+--
+
+RETURN VALUE
+------------
+The _tep_filter_event_has_trivial()_ function returns 1 if the event conta=
ins=20
+a matching trivial type, otherwise 0.
+
+The _tep_update_trivial()_ function  returns 0 on success, or -1 if there =
was=20
+a problem updating, but events may have still been updated on error.
+
+The _tep_filter_clear_trivial()_ function returns 0 on success, or -1 if t=
here=20
+was a problem.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep =3D tep_alloc();
+struct tep_event_filter *filter1 =3D tep_filter_alloc(tep);
+struct tep_event_filter *filter2 =3D tep_filter_alloc(tep);
+...
+if (tep_filter_event_has_trivial(filter1, 1857,TEP_FILTER_TRIVIAL_FALSE) =
=3D=3D 0) {
+	/* There are FALSE rules in filer1 for the event 1857 */
+}
+
+if (tep_update_trivial(filter1, filter2, TEP_FILTER_TRIVIAL_TRUE) !=3D 0) =
{
+	/* Failed to update TRUE trivial rules of filter1 with filter2 */
+}
+
+if (tep_filter_clear_trivial(filter, TEP_FILTER_TRIVIAL_BOTH) =3D=3D 0) {
+	/* Failed to clear TRUE and FALSE trivial rules of filter1 */
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
