Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr760047.outbound.protection.outlook.com ([40.107.76.47]:47776
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727585AbeK1UIa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 15:08:30 -0500
From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 03/15] tools/lib/traceevent: Install trace-seq.h API header
 file
Date: Wed, 28 Nov 2018 09:07:32 +0000
Message-ID: <20181128090711.17792-4-tstoyanov@vmware.com>
References: <20181128090711.17792-1-tstoyanov@vmware.com>
In-Reply-To: <20181128090711.17792-1-tstoyanov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This patch installs trace-seq.h header file on "make install".

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 05ac0ec9bcd1..f65243137d6d 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -285,7 +285,7 @@ define do_install_pkgconfig_file
 	fi=09
 endef
=20
-install_lib: all_cmd install_plugins install_pkgconfig
+install_lib: all_cmd install_plugins install_headers install_pkgconfig
 	$(call QUIET_INSTALL, $(LIB_TARGET)) \
 		$(call do_install_mkdir,$(libdir_SQ)); \
 		cp -fpR $(LIB_INSTALL) $(DESTDIR)$(libdir_SQ)
@@ -302,6 +302,7 @@ install_headers:
 	$(call QUIET_INSTALL, headers) \
 		$(call do_install,event-parse.h,$(prefix)/include/traceevent,644); \
 		$(call do_install,event-utils.h,$(prefix)/include/traceevent,644); \
+		$(call do_install,trace-seq.h,$(prefix)/include/traceevent,644); \
 		$(call do_install,kbuffer.h,$(prefix)/include/traceevent,644)
=20
 install: install_lib
--=20
2.19.1
