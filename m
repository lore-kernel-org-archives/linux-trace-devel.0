Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790052.outbound.protection.outlook.com ([40.107.79.52]:55564
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727623AbeK1UIx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 15:08:53 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 13/15] tools/lib/traceevent: Rename tep_is_file_bigendian()
 to tep_file_bigendian()
Date: Wed, 28 Nov 2018 09:07:45 +0000
Message-ID: <20181128090711.17792-14-tstoyanov@vmware.com>
References: <20181128090711.17792-1-tstoyanov@vmware.com>
In-Reply-To: <20181128090711.17792-1-tstoyanov@vmware.com>
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
 tools/lib/traceevent/event-parse-api.c | 4 ++--
 tools/lib/traceevent/event-parse.h     | 2 +-
 tools/lib/traceevent/plugin_kvm.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/=
event-parse-api.c
index bdefe3c235ad..d4368dcc16ea 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -194,13 +194,13 @@ void tep_set_page_size(struct tep_handle *pevent, int=
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
index abe6251cf473..0d809e939948 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -559,7 +559,7 @@ int tep_get_long_size(struct tep_handle *pevent);
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
2.19.1
