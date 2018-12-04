Return-Path: <SRS0=S9Jt=ON=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr720057.outbound.protection.outlook.com ([40.107.72.57]:59188
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725802AbeLDNL4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Dec 2018 08:11:56 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tools/lib/traceevent: Parameterize the install paths in
 pkg-config file
Date: Tue, 4 Dec 2018 13:11:52 +0000
Message-ID: <20181204131139.24876-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Install directories of header and library files are hardcoded in
pkg-config templete file. This patch makes them configurable and
modifies the Makefile to set them on the install stage.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Makefile                  | 13 +++++++++----
 tools/lib/traceevent/libtraceevent.pc.template |  4 ++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 67fe5d7ef190..6419a24058ab 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -50,6 +50,9 @@ man_dir =3D $(prefix)/share/man
 man_dir_SQ =3D '$(subst ','\'',$(man_dir))'
 pkgconfig_dir ?=3D $(word 1,$(shell $(PKG_CONFIG) 		\
 			--variable pc_path pkg-config | tr ":" " "))
+includedir_relative =3D traceevent
+includedir =3D $(prefix)/include/$(includedir_relative)
+includedir_SQ =3D '$(subst ','\'',$(includedir))'
=20
 export man_dir man_dir_SQ INSTALL
 export DESTDIR DESTDIR_SQ
@@ -279,6 +282,8 @@ define do_install_pkgconfig_file
 		cp -f ${PKG_CONFIG_FILE}.template ${PKG_CONFIG_FILE}; 		\
 		sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
 		sed -i "s|LIB_VERSION|${EVENT_PARSE_VERSION}|g" ${PKG_CONFIG_FILE}; \
+		sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
+		sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE}; \
 		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
 	else 									\
 		(echo Failed to locate pkg-config directory) 1>&2;		\
@@ -300,10 +305,10 @@ install_pkgconfig:
=20
 install_headers:
 	$(call QUIET_INSTALL, headers) \
-		$(call do_install,event-parse.h,$(prefix)/include/traceevent,644); \
-		$(call do_install,event-utils.h,$(prefix)/include/traceevent,644); \
-		$(call do_install,trace-seq.h,$(prefix)/include/traceevent,644); \
-		$(call do_install,kbuffer.h,$(prefix)/include/traceevent,644)
+		$(call do_install,event-parse.h,$(DESTDIR)$(includedir_SQ),644); \
+		$(call do_install,event-utils.h,$(DESTDIR)$(includedir_SQ),644); \
+		$(call do_install,trace-seq.h,$(DESTDIR)$(includedir_SQ),644); \
+		$(call do_install,kbuffer.h,$(DESTDIR)$(includedir_SQ),644)
=20
 install: install_lib
=20
diff --git a/tools/lib/traceevent/libtraceevent.pc.template b/tools/lib/tra=
ceevent/libtraceevent.pc.template
index 42e4d6cb6b9e..86384fcd57f1 100644
--- a/tools/lib/traceevent/libtraceevent.pc.template
+++ b/tools/lib/traceevent/libtraceevent.pc.template
@@ -1,6 +1,6 @@
 prefix=3DINSTALL_PREFIX
-libdir=3D${prefix}/lib64
-includedir=3D${prefix}/include/traceevent
+libdir=3DLIB_DIR
+includedir=3DHEADER_DIR
=20
 Name: libtraceevent
 URL: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
--=20
2.19.2
