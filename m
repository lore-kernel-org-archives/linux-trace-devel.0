Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr710050.outbound.protection.outlook.com ([40.107.71.50]:5970
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728172AbeKJBRg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 20:17:36 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tools/lib/traceevent: Rename tep_is_file_bigendian() to
 tep_file_bigendian()
Date: Fri, 9 Nov 2018 15:36:29 +0000
Message-ID: <20181109153618.11961-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

In order to make libtraceevent into a proper library, its API
should be straightforward. After discussion with Steven Rostedt,
we decided to rename few APIs, to have more intuitive names.
This patch renames tep_is_file_bigendian() to tep_file_bigendian().

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../Documentation/libtraceevent-file_endian.txt        | 10 +++++-----
 tools/lib/traceevent/Documentation/libtraceevent.txt   |  2 +-
 tools/lib/traceevent/event-parse-api.c                 |  4 ++--
 tools/lib/traceevent/event-parse.h                     |  2 +-
 tools/lib/traceevent/plugin_kvm.c                      |  2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-file_endian.t=
xt b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
index 5b8e01235eda..2b763aaf9c6b 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent-file_endian.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
=20
 NAME
 ----
-tep_is_file_bigendian,tep_set_file_bigendian - Get / set the endianess of =
the=20
+tep_file_bigendian,tep_set_file_bigendian - Get / set the endianess of the=
=20
 raw data, being accessed by the tep handler.=20
=20
 SYNOPSIS
@@ -17,13 +17,13 @@ enum *tep_endian* {
 	TEP_BIG_ENDIAN
 };
=20
-int *tep_is_file_bigendian*(struct tep_handle pass:[*]_tep_);
+int *tep_file_bigendian*(struct tep_handle pass:[*]_tep_);
 void *tep_set_file_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_en=
dian _endian_);
=20
 --
 DESCRIPTION
 -----------
-The _tep_is_file_bigendian()_ function returns the endianess of the raw da=
ta,
+The _tep_file_bigendian()_ function returns the endianess of the raw data,
 being accessed by the tep handler. The _tep_ argument is trace event parse=
r context.
=20
 The _tep_set_file_bigendian()_ set the endianess of raw data, the being ac=
cessed=20
@@ -36,7 +36,7 @@ The _endian_ argument is the endianess:
 --
 RETURN VALUE
 ------------
-The _tep_is_file_bigendian()_ function returns _TEP_LITTLE_ENDIAN_ or _TEP=
_BIG_ENDIAN_.
+The _tep_file_bigendian()_ function returns _TEP_LITTLE_ENDIAN_ or _TEP_BI=
G_ENDIAN_.
=20
 EXAMPLE
 -------
@@ -48,7 +48,7 @@ struct tep_handle *tep =3D tep_alloc();
 ...
 	tep_set_file_bigendian(tep, TEP_LITTLE_ENDIAN);
 ...
-	if (TEP_BIG_ENDIAN =3D=3D tep_is_file_bigendian(tep)) {
+	if (TEP_BIG_ENDIAN =3D=3D tep_file_bigendian(tep)) {
 		/* The raw data is in big endian */
 	} else {
 		/* The raw data is in little endian */
diff --git a/tools/lib/traceevent/Documentation/libtraceevent.txt b/tools/l=
ib/traceevent/Documentation/libtraceevent.txt
index e2b4ca615809..1100240a8a29 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent.txt
@@ -129,7 +129,7 @@ Command and task related APIs:
 Endian related APIs:
 	int *tep_host_bigendian*(void);
 	unsigned long long *tep_read_number*(struct tep_handle pass:[*]_tep_, con=
st void pass:[*]_ptr_, int _size_);
-	int *tep_is_file_bigendian*(struct tep_handle pass:[*]_tep_);
+	int *tep_file_bigendian*(struct tep_handle pass:[*]_tep_);
 	void *tep_set_file_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_e=
ndian _endian_);
 	int *tep_is_host_bigendian*(struct tep_handle pass:[*]_tep_);
 	void *tep_set_host_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_e=
ndian _endian_);
diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/=
event-parse-api.c
index 39e0fca2d9a2..884b8585d22e 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -201,13 +201,13 @@ void tep_set_page_size(struct tep_handle *pevent, int=
 _page_size)
 }
=20
 /**
- * tep_is_file_bigendian - get if the file is in big endian order
+ * tep_file_bigendian - get if the file is in big endian order
  * @pevent: a handle to the tep_handle
  *
  * This returns if the file is in big endian order
  * If @pevent is NULL, 0 is returned.
  */
-int tep_is_file_bigendian(struct tep_handle *pevent)
+int tep_file_bigendian(struct tep_handle *pevent)
 {
 	if (pevent)
 		return pevent->file_bigendian;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/even=
t-parse.h
index ff74dc392268..262abe3c6c9e 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -553,7 +553,7 @@ int tep_get_long_size(struct tep_handle *pevent);
 void tep_set_long_size(struct tep_handle *pevent, int long_size);
 int tep_get_page_size(struct tep_handle *pevent);
 void tep_set_page_size(struct tep_handle *pevent, int _page_size);
-int tep_is_file_bigendian(struct tep_handle *pevent);
+int tep_file_bigendian(struct tep_handle *pevent);
 void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian end=
ian);
 int tep_is_host_bigendian(struct tep_handle *pevent);
 void tep_set_host_bigendian(struct tep_handle *pevent, enum tep_endian end=
ian);
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugi=
n_kvm.c
index 637be7c18476..388a78a6035f 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -389,7 +389,7 @@ static int kvm_mmu_print_role(struct trace_seq *s, stru=
ct tep_record *record,
 	 * We can only use the structure if file is of the same
 	 * endianess.
 	 */
-	if (tep_is_file_bigendian(event->pevent) =3D=3D
+	if (tep_file_bigendian(event->pevent) =3D=3D
 	    tep_is_host_bigendian(event->pevent)) {
=20
 		trace_seq_printf(s, "%u q%u%s %s%s %spae %snxe %swp%s%s%s",
--=20
2.17.2
