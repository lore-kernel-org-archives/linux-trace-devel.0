Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr800049.outbound.protection.outlook.com ([40.107.80.49]:61440
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729309AbeK1Ckf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Nov 2018 21:40:35 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 03/46] tools/lib/traceevent: Add support for man pages with
 multiple names
Date: Tue, 27 Nov 2018 15:42:09 +0000
Message-ID: <20181127154153.11315-4-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
In-Reply-To: <20181127154153.11315-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch adds support for man pages with multiple names,
used to combine the description of several APIs into one page.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../traceevent/Documentation/asciidoc.conf    | 35 +++++++++++++++++--
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/asciidoc.conf b/tools/lib/t=
raceevent/Documentation/asciidoc.conf
index 1b03c63fb73a..07595717f06e 100644
--- a/tools/lib/traceevent/Documentation/asciidoc.conf
+++ b/tools/lib/traceevent/Documentation/asciidoc.conf
@@ -74,12 +74,41 @@ template::[header-declarations]
 <refmeta>
 <refentrytitle>{mantitle}</refentrytitle>
 <manvolnum>{manvolnum}</manvolnum>
-<refmiscinfo class=3D"source">trace-cmd</refmiscinfo>
+<refmiscinfo class=3D"source">libtraceevent</refmiscinfo>
 <refmiscinfo class=3D"version">{libtraceevent_version}</refmiscinfo>
-<refmiscinfo class=3D"manual">trace-cmd Manual</refmiscinfo>
+<refmiscinfo class=3D"manual">libtraceevent Manual</refmiscinfo>
 </refmeta>
 <refnamediv>
-  <refname>{manname}</refname>
+  <refname>{manname1}</refname>
+  <refname>{manname2}</refname>
+  <refname>{manname3}</refname>
+  <refname>{manname4}</refname>
+  <refname>{manname5}</refname>
+  <refname>{manname6}</refname>
+  <refname>{manname7}</refname>
+  <refname>{manname8}</refname>
+  <refname>{manname9}</refname>
+  <refname>{manname10}</refname>
+  <refname>{manname11}</refname>
+  <refname>{manname12}</refname>
+  <refname>{manname13}</refname>
+  <refname>{manname14}</refname>
+  <refname>{manname15}</refname>
+  <refname>{manname16}</refname>
+  <refname>{manname17}</refname>
+  <refname>{manname18}</refname>
+  <refname>{manname19}</refname>
+  <refname>{manname20}</refname>
+  <refname>{manname21}</refname>
+  <refname>{manname22}</refname>
+  <refname>{manname23}</refname>
+  <refname>{manname24}</refname>
+  <refname>{manname25}</refname>
+  <refname>{manname26}</refname>
+  <refname>{manname27}</refname>
+  <refname>{manname28}</refname>
+  <refname>{manname29}</refname>
+  <refname>{manname30}</refname>
   <refpurpose>{manpurpose}</refpurpose>
 </refnamediv>
 endif::backend-docbook[]
--=20
2.19.1
